#!/usr/bin/env python3
"""
GDB RSP trace client for RC702 BIOS-in-C debugging.

Connects to MAME's GDB stub, sets breakpoints at all BIOS entry points,
injects keyboard commands (DIR *.ASM, TYPE DUMP.ASM), and logs every
BIOS call with full register and variable state.

Also monitors the floppy ISR to verify CTC ch3 interrupt delivery.

Usage:
  1. Launch MAME:  ./run_mame.sh -g
  2. Run tracer:   python3 gdb_trace.py [port]
"""

import socket
import sys
import time

# --- Configuration ---

GDB_HOST = "localhost"
GDB_PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 23946
TIMEOUT_IDLE = 4.0   # seconds of no breakpoint = command done

# --- BDOS function numbers ---
BDOS_OPEN    = 15
BDOS_CLOSE   = 16
BDOS_SEARCH  = 17
BDOS_SEARCH_N = 18
BDOS_READ_SEQ = 20
BDOS_WRITE_SEQ = 21
BDOS_SETDMA  = 26

BDOS_NAMES = {
    0: "BOOT", 1: "CONST", 2: "CONOUT", 6: "DIRECTIO", 9: "PRINT$",
    10: "READBUF", 11: "CONST2", 12: "VERSION",
    13: "RESETDSK", 14: "SELDSK", 15: "OPEN", 16: "CLOSE",
    17: "SEARCH", 18: "SEARCH_N", 19: "DELETE", 20: "READ_SEQ",
    21: "WRITE_SEQ", 22: "MAKE", 23: "RENAME", 24: "LOGINVEC",
    25: "CURDSK", 26: "SETDMA", 27: "GETALLOC",
    32: "GETUSER", 35: "GETRO", 36: "GETFREE",
}

# CP/M addresses
BDOS_ENTRY   = 0x0005    # JP BDOS (we break here to catch C=function#)
DEFAULT_FCB  = 0x005C    # Default FCB used by CCP commands
DEFAULT_DMA  = 0x0080    # Default DMA buffer

# --- BIOS JP table addresses (entry points at 0xDA00) ---

BIOS_ENTRY = {
    0xDA00: "BOOT",    0xDA03: "WBOOT",   0xDA06: "CONST",
    0xDA09: "CONIN",   0xDA0C: "CONOUT",  0xDA0F: "LIST",
    0xDA12: "PUNCH",   0xDA15: "READER",  0xDA18: "HOME",
    0xDA1B: "SELDSK",  0xDA1E: "SETTRK",  0xDA21: "SETSEC",
    0xDA24: "SETDMA",  0xDA27: "READ",    0xDA2A: "WRITE",
    0xDA2D: "LISTST",  0xDA30: "SECTRAN",
}

# Internal function addresses (from bios.map)
INTERNAL = {
    0xE2D7: "secrd",   0xE458: "rdhst",   0xE479: "rwoper",
    0xE255: "chktrk",  0xE1A0: "fdc_irq_arm",   0xE1AF: "fdc_irq_wait_rearm",
    0xEFC0: "isr_floppy",
    0xE1B5: "flp_dma_setup",
    0xE1EE: "fdc_general_cmd",
}

# BIOS variable addresses (from bios.map)
VARS = {
    "cpm_disk":  0xDF83, "cpm_track":  0xDF84, "cpm_sector":  0xDF86,
    "hostbuf_disk":  0xDF88, "hostbuf_track":  0xDF89, "hostbuf_sector":  0xDF8B,
    "last_seek_disk":  0xDF8D, "last_seek_track":  0xDF8E, "cpm_sector_as_host":  0xDF90,
    "hostbuf_valid":  0xDF92, "hostbuf_dirty":  0xDF93, "unalloc_count":  0xDF94,
    "disk_error":  0xDF9B, "need_pre_read":  0xDF9C, "is_read":  0xDF9D,
    "cpm_dma_addr":  0xDF9F, "current_format":    0xDFA1, "current_format_idx":   0xDFA3,
    "track0_sectors_per_side":    0xDFA4, "fdc_unit_head":   0xDFA6, "fdc_track":   0xDFA9,
    "fdc_sector":   0xDFAA, "fl_flg":  0xDFB4,
    "kbbuf":   0xDC23, "kbhead":  0xDC33, "kbtail":  0xDC34,
}

# Screen memory
SCREEN_BASE = 0xF800
SCREEN_COLS = 80
SCREEN_ROWS = 25

# Commands to inject
COMMANDS = [
    "DIR *.ASM\r",
    "TYPE DUMP.ASM\r",
]

# --- GDB RSP Protocol ---

class GdbClient:
    def __init__(self, host, port):
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.connect((host, port))
        self.sock.settimeout(TIMEOUT_IDLE)
        self.buf = b""
        # GDB RSP handshake
        self._send_ack()
        # Feature negotiation
        self.send_packet("qSupported:xmlRegisters=i386")
        features = self._recv_packet()
        print(f"Features: {features}")
        # Query stop reason
        self.send_packet("?")
        pkt = self._recv_packet()
        print(f"Stop reason: {pkt}")
        # Fetch target description XML (required before register reads work)
        self._fetch_target_xml()
        # Let CPU run briefly to initialize state, then stop
        print("Letting CPU run to initialize state...")
        self.send_packet("c")
        time.sleep(0.5)
        self.interrupt()
        stop = self.recv_stop()
        print(f"Stopped: {stop}")
        # Verify register read works
        regs = self.read_regs()
        if "PC" in regs:
            print(f"Registers OK, PC={regs['PC']:04X}")
        else:
            print(f"WARNING: register read failed: {regs}")

    def close(self):
        try:
            self.send_packet("D")  # detach
        except:
            pass
        self.sock.close()

    def _send_ack(self):
        self.sock.sendall(b"+")

    def _checksum(self, data):
        return sum(data.encode()) & 0xFF

    def send_packet(self, data):
        cs = self._checksum(data)
        pkt = f"${data}#{cs:02x}"
        self.sock.sendall(pkt.encode())
        # Wait for ACK
        while True:
            ch = self.sock.recv(1)
            if ch == b"+":
                break
            elif ch == b"-":
                self.sock.sendall(pkt.encode())  # resend

    def _recv_packet(self):
        """Receive one GDB RSP packet, return payload string."""
        while True:
            # Accumulate data
            try:
                chunk = self.sock.recv(4096)
                if not chunk:
                    raise ConnectionError("GDB connection closed")
                self.buf += chunk
            except socket.timeout:
                raise

            # Look for $...#xx in buffer
            while True:
                start = self.buf.find(b"$")
                if start == -1:
                    break
                end = self.buf.find(b"#", start)
                if end == -1:
                    break
                if len(self.buf) < end + 3:
                    break  # need checksum bytes
                payload = self.buf[start+1:end].decode(errors="replace")
                self.buf = self.buf[end+3:]
                self._send_ack()
                return payload

    def recv_stop(self):
        """Wait for stop packet (Txx or Sxx). Returns stop reason."""
        pkt = self._recv_packet()
        return pkt

    def interrupt(self):
        """Send Ctrl+C to pause execution."""
        self.sock.sendall(b"\x03")

    def _fetch_target_xml(self):
        """Fetch target description XML via qXfer — required before register reads."""
        xml = ""
        offset = 0
        while True:
            self.send_packet(f"qXfer:features:read:target.xml:{offset:x},fff")
            resp = self._recv_packet()
            if not resp or resp.startswith("E"):
                print(f"  target XML fetch error: {resp}")
                break
            # Response: 'l<data>' (last) or 'm<data>' (more)
            kind = resp[0]
            xml += resp[1:]
            if kind == 'l':
                break
            offset += len(resp) - 1
        print(f"  Target XML: {len(xml)} bytes")
        # Parse register names from XML for our reference
        if "z80" in xml.lower() or "Z80" in xml:
            print("  CPU type: Z80")
        return xml

    # --- High-level commands ---

    def set_breakpoint(self, addr):
        self.send_packet(f"Z0,{addr:x},1")
        resp = self._recv_packet()
        return resp == "OK"

    def remove_breakpoint(self, addr):
        self.send_packet(f"z0,{addr:x},1")
        resp = self._recv_packet()
        return resp == "OK"

    def cont(self):
        self.send_packet("c")

    def step(self):
        self.send_packet("s")
        return self.recv_stop()

    def read_regs(self):
        """Read all Z80 registers. Returns dict."""
        self.send_packet("g")
        resp = self._recv_packet()
        if resp.startswith("E"):
            print(f"  register read error: {resp}")
            return {}
        # Z80 register order: AF, BC, DE, HL, AF', BC', DE', HL', IX, IY, SP, PC
        # Each 16-bit, little-endian in hex (4 chars each)
        names = ["AF", "BC", "DE", "HL", "AF'", "BC'", "DE'", "HL'",
                 "IX", "IY", "SP", "PC"]
        regs = {}
        for i, name in enumerate(names):
            h = resp[i*4 : i*4+4]
            if len(h) >= 4:
                lo = int(h[0:2], 16)
                hi = int(h[2:4], 16)
                regs[name] = (hi << 8) | lo
        return regs

    def read_mem(self, addr, length):
        """Read memory. Returns bytes."""
        self.send_packet(f"m{addr:x},{length:x}")
        resp = self._recv_packet()
        if resp.startswith("E"):
            return b""
        return bytes.fromhex(resp)

    def write_mem(self, addr, data):
        """Write memory."""
        hexdata = data.hex()
        self.send_packet(f"M{addr:x},{len(data):x}:{hexdata}")
        resp = self._recv_packet()
        return resp == "OK"

    def read_byte(self, addr):
        b = self.read_mem(addr, 1)
        return b[0] if b else 0

    def read_word(self, addr):
        b = self.read_mem(addr, 2)
        return (b[1] << 8) | b[0] if len(b) == 2 else 0

    def write_byte(self, addr, val):
        return self.write_mem(addr, bytes([val & 0xFF]))


# --- BIOS Tracer ---

class BiosTracer:
    def __init__(self, gdb):
        self.gdb = gdb
        self.call_num = 0
        self.isr_count = 0
        self.cmd_idx = 0
        self.phase = "BOOT"  # BOOT, DIR, TYPE, DONE
        self.bp_set = set()
        self.bdos_call_count = 0
        self.last_bdos_func = None
        self.bdos_return_bp = None  # temporary breakpoint for BDOS return
        self.type_read_count = 0
        self.single_step_after_read = False

    def setup_breakpoints(self):
        """Set breakpoints at BIOS entry points and key internal functions."""
        # BIOS JP table entries (skip CONST, CONIN, CONOUT, LIST, PUNCH, READER, LISTST)
        # Include WBOOT to detect when CCP reloads
        disk_entries = [0xDA03,  # WBOOT
                        0xDA18, 0xDA1B, 0xDA1E, 0xDA21, 0xDA24,
                        0xDA27, 0xDA2A, 0xDA30]  # HOME..SECTRAN
        for addr in disk_entries:
            if self.gdb.set_breakpoint(addr):
                self.bp_set.add(addr)

        # Floppy ISR — to count interrupt firings
        if self.gdb.set_breakpoint(0xEFC0):
            self.bp_set.add(0xEFC0)

        # Internal: secrd entry — to see physical disk reads
        if self.gdb.set_breakpoint(0xE2D7):
            self.bp_set.add(0xE2D7)

        # Internal: rdhst — to see host buffer reads
        if self.gdb.set_breakpoint(0xE458):
            self.bp_set.add(0xE458)

        # BDOS entry — to trace OPEN, READ_SEQ, etc.
        if self.gdb.set_breakpoint(BDOS_ENTRY):
            self.bp_set.add(BDOS_ENTRY)

        print(f"Set {len(self.bp_set)} breakpoints")

    def inject_keys(self, text):
        """Write characters into keyboard ring buffer."""
        head = self.gdb.read_byte(VARS["kbhead"])
        for ch in text:
            self.gdb.write_byte(VARS["kbbuf"] + head, ord(ch))
            head = (head + 1) % 16
        self.gdb.write_byte(VARS["kbhead"], head)

    def read_screen_line(self, row):
        """Read one screen line."""
        data = self.gdb.read_mem(SCREEN_BASE + row * SCREEN_COLS, SCREEN_COLS)
        return "".join(chr(b) if 0x20 <= b < 0x7F else " " for b in data).rstrip()

    def screen_has(self, text):
        """Check if text appears on screen."""
        data = self.gdb.read_mem(SCREEN_BASE, SCREEN_COLS * SCREEN_ROWS)
        s = "".join(chr(b) if 0x20 <= b < 0x7F else " " for b in data)
        return text in s

    def dump_screen(self):
        """Dump non-empty screen lines."""
        print("  --- Screen ---")
        for row in range(SCREEN_ROWS):
            line = self.read_screen_line(row)
            if line:
                print(f"  {row:2d}: {line}")
        print("  --- End screen ---")

    def read_var8(self, name):
        return self.gdb.read_byte(VARS[name])

    def read_var16(self, name):
        return self.gdb.read_word(VARS[name])

    def dump_disk_state(self):
        """Print current disk deblocking state."""
        print(f"       cpm_disk={self.read_var8('cpm_disk'):02X}"
              f" cpm_track={self.read_var16('cpm_track'):04X}"
              f" cpm_sector={self.read_var16('cpm_sector'):04X}"
              f" cpm_sector_as_host={self.read_var16('cpm_sector_as_host'):04X}")
        print(f"       hostbuf_disk={self.read_var8('hostbuf_disk'):02X}"
              f" hostbuf_track={self.read_var16('hostbuf_track'):04X}"
              f" hostbuf_sector={self.read_var16('hostbuf_sector'):04X}"
              f" hostbuf_valid={self.read_var8('hostbuf_valid'):02X}"
              f" hostbuf_dirty={self.read_var8('hostbuf_dirty'):02X}")
        print(f"       cpm_dma_addr={self.read_var16('cpm_dma_addr'):04X}"
              f" disk_error={self.read_var8('disk_error'):02X}"
              f" need_pre_read={self.read_var8('need_pre_read'):02X}"
              f" is_read={self.read_var8('is_read'):02X}"
              f" unalloc_count={self.read_var8('unalloc_count'):02X}")
        print(f"       fl_flg={self.read_var8('fl_flg'):02X}"
              f" track0_sectors_per_side={self.read_var8('track0_sectors_per_side'):02X}"
              f" current_format_idx={self.read_var8('current_format_idx'):02X}"
              f" fdc_unit_head={self.read_var8('fdc_unit_head'):02X}"
              f" isr_floppy_count={self.isr_count}")

    def dump_fdc_state(self):
        """Print FDC-related state for sector read investigation."""
        print(f"       fdc_track={self.read_var8('fdc_track'):02X}"
              f" fdc_sector={self.read_var8('fdc_sector'):02X}"
              f" last_seek_disk={self.read_var8('last_seek_disk'):02X}"
              f" last_seek_track={self.read_var16('last_seek_track'):04X}"
              f" form={self.read_var16('current_format'):04X}")

    def dump_fcb(self, addr=DEFAULT_FCB, label="FCB"):
        """Dump a CP/M FCB (36 bytes)."""
        fcb = self.gdb.read_mem(addr, 36)
        if not fcb or len(fcb) < 32:
            print(f"       {label}: read error")
            return
        dr = fcb[0]
        name = bytes(fcb[1:9]).decode('ascii', errors='replace')
        ext = bytes(fcb[9:12]).decode('ascii', errors='replace')
        ex = fcb[12]
        s1 = fcb[13]
        s2 = fcb[14]
        rc = fcb[15]
        # Allocation blocks (16-bit for DSM>255)
        alloc = []
        for j in range(16, 32, 2):
            blk = fcb[j] | (fcb[j+1] << 8)
            alloc.append(blk)
        cr = fcb[32] if len(fcb) > 32 else 0
        print(f"       {label}@{addr:04X}: DR={dr} \"{name}.{ext}\" EX={ex:02X} S1={s1:02X} S2={s2:02X} RC={rc}")
        print(f"       CR={cr} alloc={[b for b in alloc if b]}")
        print(f"       raw={fcb[:32].hex()}")

    def handle_breakpoint(self, regs):
        """Handle a breakpoint hit. Returns True to continue, False to stop."""
        pc = regs["PC"]

        # Floppy ISR — just count and continue
        if pc == 0xEFC0:
            self.isr_count += 1
            return True

        # BDOS return breakpoint — check return value from OPEN etc.
        if self.bdos_return_bp and pc == self.bdos_return_bp:
            a = (regs["AF"] >> 8) & 0xFF
            hl = regs["HL"]
            print(f"  BDOS RETURN: A={a:02X} HL={hl:04X} (from {BDOS_NAMES.get(self.last_bdos_func, '?')})")
            if self.last_bdos_func == BDOS_OPEN:
                if a == 0xFF:
                    print("       *** OPEN FAILED (A=FF) — file not found! ***")
                else:
                    print(f"       OPEN succeeded (dir code={a})")
                    self.dump_fcb(DEFAULT_FCB, "FCB after OPEN")
            elif self.last_bdos_func == BDOS_READ_SEQ:
                if a != 0:
                    print(f"       *** READ_SEQ FAILED (A={a:02X}) ***")
                else:
                    print(f"       READ_SEQ ok")
            # Remove temporary breakpoint
            self.gdb.remove_breakpoint(self.bdos_return_bp)
            self.bdos_return_bp = None
            return True

        # BDOS entry — trace function calls during TYPE phase
        if pc == BDOS_ENTRY:
            c = regs["BC"] & 0xFF
            de = regs["DE"]
            self.bdos_call_count += 1
            fname = BDOS_NAMES.get(c, f"F{c}")

            # Only log disk-related BDOS calls and during TYPE phase
            if self.phase == "TYPE" or c in (BDOS_OPEN, BDOS_READ_SEQ, BDOS_CLOSE,
                                              BDOS_SEARCH, BDOS_SEARCH_N, BDOS_SETDMA):
                print(f"  BDOS #{self.bdos_call_count:4d} {self.phase:5s} {fname:12s} C={c:02X} DE={de:04X}")

                # Dump FCB for OPEN and SEARCH
                if c in (BDOS_OPEN, BDOS_SEARCH):
                    self.dump_fcb(de, "FCB")

                self.last_bdos_func = c

                # Set temporary breakpoint at caller's return address
                # 0x0005 has JP xxxx, so this BP is at the CALL 5 site
                # The return address is on the stack
                if c in (BDOS_OPEN, BDOS_READ_SEQ, BDOS_SEARCH) and self.phase == "TYPE":
                    sp = regs["SP"]
                    ret_addr = self.gdb.read_word(sp)
                    if ret_addr and self.bdos_return_bp is None:
                        self.bdos_return_bp = ret_addr
                        self.gdb.set_breakpoint(ret_addr)
                        print(f"       (return BP set at {ret_addr:04X})")

            return True

        self.call_num += 1
        name = BIOS_ENTRY.get(pc) or INTERNAL.get(pc) or f"BP@{pc:04X}"

        # Format register info based on call type
        bc = regs["BC"]
        de = regs["DE"]
        hl = regs["HL"]
        a = (regs["AF"] >> 8) & 0xFF
        c = bc & 0xFF

        # Skip DIR phase logging for brevity
        if self.phase == "DIR":
            return True

        line = f"[{self.call_num:4d}] {self.phase:5s} {name:12s}"

        if name == "SELDSK":
            line += f" C={c:02X} (drive {c})"
        elif name == "SETTRK":
            line += f" BC={bc:04X} (track {bc})"
        elif name == "SETSEC":
            line += f" BC={bc:04X} (sector {bc})"
        elif name == "SETDMA":
            line += f" BC={bc:04X}"
        elif name == "READ":
            line += f" A={a:02X}"
        elif name == "WRITE":
            line += f" C={c:02X} (type {c})"
        elif name == "SECTRAN":
            line += f" BC={bc:04X} DE={de:04X}"
        elif name == "HOME":
            line += ""
        elif name in ("secrd", "rdhst", "chktrk"):
            line += f" (internal)"
        else:
            line += f" A={a:02X} BC={bc:04X} DE={de:04X} HL={hl:04X}"

        print(line)

        # Dump state for disk operations
        if name in ("READ", "WRITE", "secrd", "rdhst"):
            self.dump_disk_state()
            if name in ("secrd", "rdhst"):
                self.dump_fdc_state()

        # During TYPE: dump FCB after first HOME (OPEN just finished setting up FCB)
        if self.phase == "TYPE" and name == "HOME":
            print("       --- FCB state when TYPE starts disk I/O ---")
            self.dump_fcb(DEFAULT_FCB, "DefaultFCB")
            # Also dump DMA buffer
            dma = self.gdb.read_mem(DEFAULT_DMA, 128)
            if dma:
                print(f"       DMA@0080: {dma[:32].hex()} ...")

        # During TYPE: after READ, dump hstbuf and dirbuf
        if self.phase == "TYPE" and name == "READ":
            self.type_read_count += 1
            # After 2nd READ: remove all breakpoints and single-step
            if self.type_read_count == 2:
                print("       *** 2nd TYPE READ — will single-step after return ***")
                self.single_step_after_read = True

        return True

    def single_step_trace(self, max_steps=2000):
        """Single-step and track PC/SP to find crash point."""
        print(f"\n  === Single-stepping up to {max_steps} instructions ===")
        prev_sp = 0
        prev_pc = 0
        verbose_start = -1  # step number to start verbose logging
        for step_num in range(max_steps):
            stop = self.gdb.step()
            regs = self.gdb.read_regs()
            if not regs:
                print(f"  STEP {step_num}: register read failed")
                break
            pc = regs["PC"]
            sp = regs["SP"]
            a = (regs["AF"] >> 8) & 0xFF
            hl = regs["HL"]
            de = regs["DE"]
            bc = regs["BC"]

            # Log every Nth step or on significant SP/PC change
            sp_changed = abs(sp - prev_sp) > 4 if prev_sp else False
            pc_jump = abs(pc - prev_pc) > 100 if prev_pc else False
            verbose = step_num > 1100  # verbose for the crash area
            if step_num % 200 == 0 or sp_changed or pc_jump or verbose or pc < 0x0500 or pc > 0xF000:
                # Read instruction byte for context
                inst = self.gdb.read_mem(pc, 1)
                inst_hex = inst.hex() if inst else "??"
                print(f"  STEP {step_num:5d}: PC={pc:04X} [{inst_hex}] SP={sp:04X} A={a:02X} BC={bc:04X} DE={de:04X} HL={hl:04X}")

            # When SP enters BIOS stack area (0xF4xx-0xF500), start verbose mode soon
            if sp > 0xF400 and sp <= 0xF500 and verbose_start < 0:
                verbose_start = step_num + 500  # start verbose 500 steps after entering BIOS stack

            # Detect crash: PC in TPA area
            if 0x0005 < pc < 0x0500:
                print(f"\n  *** CRASH at step {step_num}: PC={pc:04X} SP={sp:04X} ***")
                # Show last 10 steps context
                code = self.gdb.read_mem(pc, 16)
                if code:
                    print(f"      Code: {code.hex()}")
                stack = self.gdb.read_mem(sp, 16)
                if stack:
                    print(f"      Stack: {stack.hex()}")
                self.dump_fcb(0xCBCD, "CCP FCB")
                break

            prev_sp = sp
            prev_pc = pc
        else:
            print(f"  === {max_steps} steps without crash ===")
            regs = self.gdb.read_regs()
            if regs:
                print(f"  Final: PC={regs['PC']:04X} SP={regs['SP']:04X}")

    def run(self):
        """Main trace loop."""
        self.setup_breakpoints()

        # Start execution
        print(f"\n{'='*60}")
        print("Starting MAME execution, waiting for boot...")
        print(f"{'='*60}\n")
        self.gdb.cont()

        first_bp = True

        while self.phase != "DONE":
            try:
                stop = self.gdb.recv_stop()
            except socket.timeout:
                # No breakpoint for TIMEOUT_IDLE seconds
                if self.phase == "BOOT":
                    print(f"\n--- Timeout during BOOT (no BIOS JP table calls?) ---")
                    print("--- This is normal: wboot bypasses JP table ---")
                    print("--- Sending interrupt to check screen ---\n")
                    self.gdb.interrupt()
                    stop = self.gdb.recv_stop()
                    regs = self.gdb.read_regs()

                    if self.screen_has("A>"):
                        print(f"\n{'='*60}")
                        print(f"Boot complete. Injecting: {COMMANDS[0]!r}")
                        print(f"{'='*60}\n")
                        self.inject_keys(COMMANDS[0])
                        self.cmd_idx = 1
                        self.phase = "DIR"
                        self.isr_count = 0
                    else:
                        print("Screen does not show A> yet, waiting more...")
                        self.dump_screen()

                    self.gdb.cont()
                    continue

                elif self.phase == "DIR":
                    print(f"\n--- DIR done, injecting TYPE ---")
                    self.gdb.interrupt()
                    stop = self.gdb.recv_stop()
                    if self.cmd_idx < len(COMMANDS):
                        cmd = COMMANDS[self.cmd_idx]
                        self.inject_keys(cmd)
                        self.cmd_idx += 1
                        self.phase = "TYPE"
                        self.isr_count = 0
                        self.gdb.cont()
                        continue

                elif self.phase == "TYPE":
                    print(f"\n{'='*60}")
                    print(f"TYPE stalled (no BIOS calls for {TIMEOUT_IDLE}s)")
                    self.gdb.interrupt()
                    stop = self.gdb.recv_stop()
                    regs = self.gdb.read_regs()
                    if regs:
                        pc = regs["PC"]
                        sp = regs["SP"]
                        a = (regs["AF"] >> 8) & 0xFF
                        print(f"  STALL PC={pc:04X} SP={sp:04X} A={a:02X} BC={regs['BC']:04X} DE={regs['DE']:04X} HL={regs['HL']:04X}")
                        # Dump code around PC
                        code = self.gdb.read_mem(pc, 16)
                        if code:
                            print(f"  Code at PC: {code.hex()}")
                        # Dump stack
                        stack = self.gdb.read_mem(sp, 16)
                        if stack:
                            print(f"  Stack at SP: {stack.hex()}")
                        # Dump FCB state
                        self.dump_fcb(0xCBCD, "CCP FCB")
                        self.dump_fcb(DEFAULT_FCB, "Default FCB")
                        # Dump dirbuf
                        dirbuf = self.gdb.read_mem(0xDE35, 128)
                        if dirbuf:
                            for i in range(0, 128, 32):
                                entry = dirbuf[i:i+32]
                                user = entry[0]
                                name = bytes(entry[1:9]).decode('ascii', errors='replace')
                                ext = bytes(entry[9:12]).decode('ascii', errors='replace')
                                rc = entry[15]
                                alloc = []
                                for j in range(16, 32, 2):
                                    blk = entry[j] | (entry[j+1] << 8)
                                    if blk: alloc.append(blk)
                                print(f"  dirbuf[{i//32}]: u={user} \"{name}.{ext}\" RC={rc} alloc={alloc}")
                    self.dump_screen()
                    print(f"{'='*60}")
                    self.phase = "DONE"
                    break

            # Handle breakpoint
            regs = self.gdb.read_regs()
            if not regs:
                print("WARNING: could not read registers, continuing...")
                self.gdb.cont()
                continue
            pc = regs["PC"]

            # On first non-ISR breakpoint after boot, inject first command
            if self.phase == "BOOT" and pc != 0xEFC0:
                print(f"\n{'='*60}")
                print(f"First BIOS JP table call after boot at PC={pc:04X}")
                name = BIOS_ENTRY.get(pc, "???")
                print(f"  → {name}")
                print(f"Injecting: {COMMANDS[0]!r}")
                print(f"{'='*60}\n")
                self.inject_keys(COMMANDS[0])
                self.cmd_idx = 1
                self.phase = "DIR"
                self.isr_count = 0

            if not self.handle_breakpoint(regs):
                break

            # After 2nd TYPE READ's SETDMA, switch to single-step mode
            if self.single_step_after_read and pc == 0xDA24:  # SETDMA
                print("       *** SETDMA after 2nd READ — removing BPs and single-stepping ***")
                # Remove all breakpoints
                for addr in list(self.bp_set):
                    self.gdb.remove_breakpoint(addr)
                if self.bdos_return_bp:
                    self.gdb.remove_breakpoint(self.bdos_return_bp)
                # Step past SETDMA (ld (cpm_dma_addr),bc = 4 bytes + ret = 1 byte)
                # Just start single-stepping immediately from SETDMA entry
                self.single_step_trace(3000)
                self.phase = "DONE"
                break

            self.gdb.cont()

        # Final summary
        print(f"\n{'='*60}")
        print(f"Trace complete. Total BIOS calls logged: {self.call_num}")
        print(f"Total floppy ISR firings: {self.isr_count}")
        print(f"{'='*60}")


def main():
    print(f"Connecting to MAME GDB stub at {GDB_HOST}:{GDB_PORT}...")
    try:
        gdb = GdbClient(GDB_HOST, GDB_PORT)
    except ConnectionRefusedError:
        print(f"ERROR: Cannot connect. Is MAME running with -debugger gdbstub?")
        print(f"  Launch: ./run_mame.sh -g")
        sys.exit(1)

    try:
        tracer = BiosTracer(gdb)
        tracer.run()
    except KeyboardInterrupt:
        print("\n\nInterrupted by user")
    except Exception as e:
        print(f"\nERROR: {e}")
        import traceback
        traceback.print_exc()
    finally:
        gdb.close()
        print("Disconnected.")


if __name__ == "__main__":
    main()

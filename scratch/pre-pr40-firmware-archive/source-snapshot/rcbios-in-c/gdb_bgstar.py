#!/usr/bin/env python3
"""
GDB RSP debug client for BGSTAR bg_set_bit tracing.

Connects to MAME's GDB stub, waits for boot, injects "BGTEST\r",
sets breakpoints on bg_set_bit and specc case 0x13, then traces
register/memory state at each hit.

Usage:
  1. Launch MAME:  ./run_mame.sh -g
  2. Run tracer:   python3 gdb_bgstar.py [port]
"""

import socket
import sys
import time

GDB_HOST = "localhost"
GDB_PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 23946

# Addresses from bios.map (after rebuilding with real bg_set_bit)
# These will be read from bios.map automatically
def read_map_addr(symbol):
    with open("bios.map") as f:
        for line in f:
            if symbol + " " in line and "= $" in line:
                addr = int(line.split("= $")[1].split()[0], 16)
                return addr
    raise ValueError(f"Symbol {symbol} not found in bios.map")

BG_SET_BIT = read_map_addr("_bg_set_bit")
BGFLG = read_map_addr("_bgflg")
SPECC = read_map_addr("_specc")
DISPL = read_map_addr("_displ")
CONOUT_BODY = read_map_addr("_conout_body")
KBBUF = read_map_addr("_kbbuf")
KBHEAD = read_map_addr("_kbhead")

BGSTAR = 0xF500
USESSION = 0xFFDA
LOCAD = 0xFFD8
CURX = 0xFFD1
CURY = 0xFFD2
CURSY = 0xFFD4

print(f"Addresses: bg_set_bit=0x{BG_SET_BIT:04X} bgflg=0x{BGFLG:04X} "
      f"specc=0x{SPECC:04X} displ=0x{DISPL:04X} conout_body=0x{CONOUT_BODY:04X}")


class GdbClient:
    def __init__(self, host, port):
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.connect((host, port))
        self.sock.settimeout(5.0)
        self.buf = b""
        self._send_ack()
        self.send_packet("qSupported:xmlRegisters=i386")
        self._recv_packet()
        self.send_packet("?")
        self._recv_packet()
        self._fetch_target_xml()
        # Let CPU run to initialize
        self.send_packet("c")
        time.sleep(0.5)
        self.interrupt()
        self.recv_stop()
        regs = self.read_regs()
        print(f"Connected, PC=0x{regs.get('PC', 0):04X}")

    def close(self):
        try:
            self.send_packet("D")
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
        while True:
            ch = self.sock.recv(1)
            if ch == b"+":
                break
            elif ch == b"-":
                self.sock.sendall(pkt.encode())

    def _recv_packet(self):
        while True:
            try:
                chunk = self.sock.recv(4096)
                if not chunk:
                    raise ConnectionError("closed")
                self.buf += chunk
            except socket.timeout:
                raise
            while True:
                start = self.buf.find(b"$")
                if start == -1:
                    break
                end = self.buf.find(b"#", start)
                if end == -1:
                    break
                if len(self.buf) < end + 3:
                    break
                payload = self.buf[start+1:end].decode(errors="replace")
                self.buf = self.buf[end+3:]
                self._send_ack()
                return payload

    def recv_stop(self):
        return self._recv_packet()

    def interrupt(self):
        self.sock.sendall(b"\x03")

    def _fetch_target_xml(self):
        xml = ""
        offset = 0
        while True:
            self.send_packet(f"qXfer:features:read:target.xml:{offset:x},fff")
            resp = self._recv_packet()
            if not resp or resp.startswith("E"):
                break
            kind = resp[0]
            xml += resp[1:]
            if kind == 'l':
                break
            offset += len(resp) - 1

    def set_breakpoint(self, addr):
        self.send_packet(f"Z0,{addr:x},1")
        return self._recv_packet() == "OK"

    def remove_breakpoint(self, addr):
        self.send_packet(f"z0,{addr:x},1")
        return self._recv_packet() == "OK"

    def cont(self):
        self.send_packet("c")

    def step(self):
        self.send_packet("s")
        return self.recv_stop()

    def read_regs(self):
        self.send_packet("g")
        resp = self._recv_packet()
        if resp.startswith("E"):
            return {}
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
        self.send_packet(f"m{addr:x},{length:x}")
        resp = self._recv_packet()
        if resp.startswith("E"):
            return b""
        return bytes.fromhex(resp)

    def write_mem(self, addr, data):
        self.send_packet(f"M{addr:x},{len(data):x}:{data.hex()}")
        return self._recv_packet() == "OK"

    def read_byte(self, addr):
        b = self.read_mem(addr, 1)
        return b[0] if b else 0

    def read_word(self, addr):
        b = self.read_mem(addr, 2)
        return (b[1] << 8) | b[0] if len(b) == 2 else 0

    def write_byte(self, addr, val):
        return self.write_mem(addr, bytes([val & 0xFF]))


def inject_key(gdb, ch):
    head = gdb.read_byte(KBHEAD)
    gdb.write_byte(KBBUF + head, ch)
    gdb.write_byte(KBHEAD, (head + 1) % 16)


def inject_string(gdb, s):
    for ch in s:
        inject_key(gdb, ord(ch))
        time.sleep(0.05)


def at_prompt(gdb):
    curx = gdb.read_byte(CURX)
    cursy = gdb.read_byte(CURSY)
    if curx != 2:
        return False
    row_addr = 0xF800 + cursy * 80
    return gdb.read_byte(row_addr) == 0x41 and gdb.read_byte(row_addr + 1) == 0x3E


def dump_bgstar(gdb, label):
    data = gdb.read_mem(BGSTAR, 32)
    s = f"{label} BGSTAR[0-31]: " + " ".join(f"{b:02X}" for b in data)
    print(s)


def main():
    print(f"Connecting to MAME GDB stub at {GDB_HOST}:{GDB_PORT}...")
    try:
        gdb = GdbClient(GDB_HOST, GDB_PORT)
    except ConnectionRefusedError:
        print(f"ERROR: Cannot connect. Is MAME running with -debugger gdbstub?")
        print(f"  Launch: ./run_mame.sh -g")
        sys.exit(1)

    try:
        # Wait for boot prompt
        print("Waiting for A> prompt...")
        for _ in range(60):
            gdb.cont()
            time.sleep(0.5)
            gdb.interrupt()
            gdb.recv_stop()
            if at_prompt(gdb):
                print("A> prompt found!")
                break
        else:
            print("TIMEOUT waiting for boot")
            gdb.close()
            return

        # Inject BGTEST command
        print("Injecting BGTEST command...")
        inject_string(gdb, "BGTEST\r")

        # Set breakpoints
        print(f"Setting breakpoint on bg_set_bit at 0x{BG_SET_BIT:04X}")
        gdb.set_breakpoint(BG_SET_BIT)
        print(f"Setting breakpoint on specc at 0x{SPECC:04X}")
        gdb.set_breakpoint(SPECC)

        # Run and catch breakpoints
        hit_count = 0
        specc_count = 0
        bg_set_bit_count = 0

        gdb.cont()

        for _ in range(2000):
            try:
                stop = gdb.recv_stop()
            except socket.timeout:
                print("Timeout waiting for breakpoint, checking state...")
                gdb.interrupt()
                gdb.recv_stop()
                bgflg = gdb.read_byte(BGFLG)
                print(f"  bgflg={bgflg}")
                dump_bgstar(gdb, "  Current")
                if bgflg == 0 and bg_set_bit_count > 0:
                    print("  bgflg back to 0, test likely complete")
                    break
                gdb.cont()
                continue

            regs = gdb.read_regs()
            pc = regs.get("PC", 0)
            hit_count += 1

            if pc == SPECC:
                specc_count += 1
                usession = gdb.read_byte(USESSION)
                bgflg = gdb.read_byte(BGFLG)
                if usession in (0x13, 0x14, 0x15, 0x0C):
                    names = {0x13: "SET_BG", 0x14: "SET_FG", 0x15: "CLR_FG", 0x0C: "CLR_SCR"}
                    print(f"  SPECC #{specc_count}: usession=0x{usession:02X} ({names.get(usession, '?')}) bgflg={bgflg}")
                gdb.cont()

            elif pc == BG_SET_BIT:
                bg_set_bit_count += 1
                hl = regs.get("HL", 0)
                bgflg = gdb.read_byte(BGFLG)
                locad = gdb.read_word(LOCAD)
                curx = gdb.read_byte(CURX)
                cury = gdb.read_word(CURY)

                byteoff = hl >> 3
                bitno = hl & 7
                mask = 0x80 >> bitno
                old_val = gdb.read_byte(BGSTAR + byteoff)

                if bg_set_bit_count <= 20:  # Only log first 20
                    print(f"  BG_SET_BIT #{bg_set_bit_count}: HL(pos)={hl} "
                          f"byte={byteoff} bit={bitno} mask=0x{mask:02X} "
                          f"bgstar[{byteoff}]=0x{old_val:02X} bgflg={bgflg}")

                # Step through bg_set_bit and check result
                # Run to ret (0xC9)
                gdb.remove_breakpoint(BG_SET_BIT)
                gdb.remove_breakpoint(SPECC)
                # Set BP on the ret instruction
                ret_addr = BG_SET_BIT + (0x0720 - 0x06E1)  # offset of RET in listing
                gdb.set_breakpoint(ret_addr)
                gdb.cont()
                try:
                    gdb.recv_stop()
                    new_val = gdb.read_byte(BGSTAR + byteoff)
                    regs2 = gdb.read_regs()
                    if bg_set_bit_count <= 20:
                        print(f"    After: bgstar[{byteoff}]=0x{new_val:02X} "
                              f"A=0x{(regs2.get('AF',0)>>8):02X} "
                              f"BC=0x{regs2.get('BC',0):04X}")
                except socket.timeout:
                    print(f"    Timeout waiting for bg_set_bit ret!")
                gdb.remove_breakpoint(ret_addr)
                gdb.set_breakpoint(BG_SET_BIT)
                gdb.set_breakpoint(SPECC)
                gdb.cont()

            else:
                # Unknown breakpoint
                print(f"  Unknown BP at PC=0x{pc:04X}")
                gdb.cont()

            if bg_set_bit_count >= 50:
                print("  (reached 50 bg_set_bit calls, stopping)")
                break

        # Final state
        gdb.interrupt()
        gdb.recv_stop()
        bgflg = gdb.read_byte(BGFLG)
        print(f"\nFinal: bgflg={bgflg}")
        dump_bgstar(gdb, "Final")

        # Check screen at cat position
        data = gdb.read_mem(0xF800 + 2*80 + 35, 7)
        parts = []
        for b in data:
            c = chr(b) if 32 <= b < 127 else '?'
            parts.append(f"{b:02X}({c})")
        print(f"Screen row2 col35: {' '.join(parts)}")

        print(f"\nTotals: {hit_count} breakpoint hits, {specc_count} specc, {bg_set_bit_count} bg_set_bit")

    except KeyboardInterrupt:
        print("\nInterrupted")
    except Exception as e:
        print(f"\nERROR: {e}")
        import traceback
        traceback.print_exc()
    finally:
        gdb.close()
        print("Disconnected.")


if __name__ == "__main__":
    main()

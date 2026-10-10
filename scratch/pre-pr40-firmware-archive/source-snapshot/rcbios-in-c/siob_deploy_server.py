#!/usr/bin/env python3
"""Dual-port server for BIOS deploy via serial.

SIO-B (console, port CONSOLE_PORT): sends CP/M commands, reads output.
SIO-A (data, port DATA_PORT): sends Intel HEX file for PIP to read.

Workflow:
  1. Wait for SIO-B console trigger (Lua detects boot + serial banner)
  2. Send "PIP CPM56.HEX=RDR:" on SIO-B console
  3. Send hex contents on SIO-A data port (RTS flow control)
  4. Wait for SIO-B console A> prompt (PIP done)
  5. Send "MLOAD CPM56.COM=BDOSCCP.COM,CPM56.HEX" — overlay BIOS onto CCP+BDOS
  6. Send "CPM56" to verify checksum, wait for OK
  7. Send "SYSGEN CPM56.COM" on SIO-B console, wait for prompts
  8. Signal Lua "done" so it can hard_reset and verify banner

Requires MLOAD.COM on the CP/M disk image.

Usage:
    python3 siob_deploy_server.py <hex_file> [console_port] [data_port]
"""

import os
import socket
import sys
import time

CONSOLE_PORT = int(sys.argv[2]) if len(sys.argv) > 2 else 4324
DATA_PORT = int(sys.argv[3]) if len(sys.argv) > 3 else 4325


def wait_for(conn, needle, timeout=60):
    """Read from socket until needle found. Returns all data read."""
    buf = b""
    deadline = time.time() + timeout
    while time.time() < deadline:
        conn.settimeout(max(0.1, deadline - time.time()))
        try:
            chunk = conn.recv(4096)
            if not chunk:
                break
            buf += chunk
            if needle.encode() in buf:
                return buf
        except socket.timeout:
            pass
    print(f"[deploy] WARNING: '{needle}' not found (got {len(buf)} bytes: {buf[-200:]})")
    return buf


def send_cmd(con_conn, cmd, expect, timeout=30):
    """Send a command on console, wait for expected response."""
    print(f"[deploy] sending: {cmd}")
    time.sleep(0.3)
    con_conn.sendall(cmd.encode() + b"\r")
    data = wait_for(con_conn, expect, timeout=timeout)
    found = expect.encode() in data
    print(f"[deploy]   {'OK' if found else 'MISSING'}: '{expect}' in {len(data)}B response")
    return data, found


def main():
    if len(sys.argv) < 2:
        print(f"usage: {sys.argv[0]} <hex_file> [console_port] [data_port]")
        return 1

    hex_path = sys.argv[1]
    hex_data = open(hex_path, "rb").read()
    print(f"[deploy] HEX file: {hex_path} ({len(hex_data)} bytes)")

    # Listen on both ports
    con_srv = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    con_srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    con_srv.bind(("127.0.0.1", CONSOLE_PORT))
    con_srv.listen(1)

    dat_srv = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    dat_srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    dat_srv.bind(("127.0.0.1", DATA_PORT))
    dat_srv.listen(1)

    print(f"[deploy] console port {CONSOLE_PORT}, data port {DATA_PORT}")

    # Accept MAME connections (bitb2 = console, bitb1 = data)
    print("[deploy] waiting for MAME connections...")
    con_conn, _ = con_srv.accept()
    con_conn.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
    print("[deploy] SIO-B console connected")

    dat_conn, _ = dat_srv.accept()
    dat_conn.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
    print("[deploy] SIO-A data connected")

    # Wait for trigger from Lua
    trigger = "/tmp/siob_deploy_trigger"
    print(f"[deploy] waiting for trigger {trigger}...")
    for _ in range(120):
        if os.path.exists(trigger):
            os.unlink(trigger)
            break
        time.sleep(0.5)
    else:
        print("[deploy] trigger timeout!")
        return 2
    print("[deploy] trigger received")

    # Drain boot output from console
    con_conn.settimeout(0.5)
    try:
        while True:
            con_conn.recv(4096)
    except socket.timeout:
        pass
    con_conn.settimeout(None)

    # Step 1: PIP CPM56.HEX=RDR:
    print("[deploy] sending: PIP CPM56.HEX=RDR:")
    time.sleep(0.3)
    con_conn.sendall(b"PIP CPM56.HEX=RDR:\r")

    # Brief pause for PIP to initialize and start reading from SIO-A
    time.sleep(1.0)

    # Step 2: Send HEX data on SIO-A data port
    # RTS flow control in MAME null_modem handles pacing.
    print(f"[deploy] sending {len(hex_data)} bytes of HEX on data port...")
    lines = hex_data.split(b"\n")
    sent_lines = 0
    for line in lines:
        line = line.rstrip(b"\r")
        if not line:
            continue
        dat_conn.sendall(line + b"\r\n")
        sent_lines += 1
        if sent_lines % 100 == 0:
            print(f"[deploy]   sent {sent_lines} lines")
    # Send ^Z to end PIP input
    time.sleep(0.2)
    dat_conn.sendall(b"\x1a")
    print(f"[deploy] HEX transfer complete ({sent_lines} lines), waiting for A>...")

    data = wait_for(con_conn, "A>", timeout=120)
    if b"A>" not in data:
        print("[deploy] FAIL: PIP did not complete")
        return 3

    # Step 3: MLOAD — overlay BIOS hex onto CCP+BDOS base
    data, ok = send_cmd(con_conn, "MLOAD CPM56.COM=BDOSCCP.COM,CPM56.HEX", "A>", timeout=30)
    if not ok:
        print("[deploy] FAIL: MLOAD did not complete")
        return 4

    # Step 4: Verify checksum
    data, ok = send_cmd(con_conn, "CPM56", "OK", timeout=10)
    if not ok:
        print(f"[deploy] WARNING: checksum verify did not return OK")
        # Continue anyway — MLOAD output will show what happened

    # Step 5: SYSGEN CPM56.COM
    data, ok = send_cmd(con_conn, "SYSGEN CPM56.COM", "DESTINATION DRIVE", timeout=30)
    if not ok:
        print("[deploy] FAIL: SYSGEN did not start")
        return 5

    time.sleep(0.3)
    con_conn.sendall(b"A\r")
    data = wait_for(con_conn, "DESTINATION ON A", timeout=10)

    time.sleep(0.3)
    con_conn.sendall(b"\r")
    data = wait_for(con_conn, "FUNCTION COMPLETE", timeout=30)
    if b"FUNCTION COMPLETE" in data:
        print("[deploy] SYSGEN complete!")
    else:
        print("[deploy] WARNING: FUNCTION COMPLETE not seen")

    # Signal Lua
    with open("/tmp/siob_deploy_done", "w") as f:
        f.write("done\n")
    print("[deploy] signaled Lua, waiting for MAME to exit...")

    # Keep sockets open until MAME exits
    try:
        while True:
            d = con_conn.recv(1024)
            if not d:
                break
    except (ConnectionResetError, BrokenPipeError):
        pass

    con_conn.close()
    dat_conn.close()
    con_srv.close()
    dat_srv.close()
    print("[deploy] done")
    return 0


if __name__ == "__main__":
    sys.exit(main())

#!/usr/bin/env python3
"""Bidirectional smoke test for MAME SIO-B debug console.

Listens on a TCP port, waits for MAME to connect. After the A> prompt
appears, sends 'DIR\\r' and captures output for 5 seconds. Reports whether
filenames were seen.
"""
import os, sys, socket, select, time

port = int(sys.argv[1]) if len(sys.argv) > 1 else 4023

srv = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
srv.bind(("127.0.0.1", port))
srv.listen(1)
srv.settimeout(60)
print(f"[bridge] listening on :{port}", flush=True)

try:
    conn, addr = srv.accept()
except socket.timeout:
    print("[bridge] no MAME connection within 60s")
    sys.exit(2)

print(f"[bridge] MAME connected {addr}", flush=True)
conn.setblocking(False)

buf = bytearray()
sent_dir = False
start = time.time()
end = start + 15.0

while time.time() < end:
    r, _, _ = select.select([conn], [], [], 0.2)
    if r:
        try:
            data = conn.recv(4096)
            if not data:
                break
            buf.extend(data)
            sys.stdout.write(data.decode("ascii", errors="replace"))
            sys.stdout.flush()
        except OSError:
            break
    text = buf.decode("ascii", errors="replace")
    if not sent_dir and "A>" in text:
        time.sleep(0.3)
        conn.sendall(b"DIR\r")
        sent_dir = True
        print("\n[bridge] sent DIR\\r", flush=True)

print("\n[bridge] captured:", flush=True)
print(buf.decode("ascii", errors="replace"))

has_prompt = b"A>" in buf
has_dir_echo = b"DIR" in buf
has_asm = b"ASM" in buf or b"asm" in buf
print(f"\n[bridge] has_A_prompt={has_prompt} has_DIR_echo={has_dir_echo} has_ASM_listing={has_asm}")

if has_prompt and has_dir_echo and has_asm:
    print("=== PASS ===")
    sys.exit(0)
else:
    print("=== FAIL ===")
    sys.exit(1)

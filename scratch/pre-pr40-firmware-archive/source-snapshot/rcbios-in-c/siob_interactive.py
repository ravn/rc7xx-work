#!/usr/bin/env python3
"""Interactive stdio <-> TCP bridge for MAME SIO-B debug console.

MAME connects via `-bitb2 socket.127.0.0.1:PORT` (MAME = client).
This script listens on PORT, then bridges:
    host stdin  -> TCP (with \\r for <CR>)
    TCP         -> host stdout

Usage:
    python3 siob_interactive.py [port]

Terminal is put in raw mode so each keystroke is sent immediately.
Exit with Ctrl-] followed by 'q'.  Ctrl-C is forwarded to CP/M.
"""
import os
import select
import socket
import sys
import termios
import tty

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 4023
ESC = 0x1D  # Ctrl-]

def main():
    srv = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    srv.bind(("127.0.0.1", PORT))
    srv.listen(1)
    print(f"[siob] listening on :{PORT}, waiting for MAME", flush=True)
    srv.settimeout(60)
    try:
        conn, addr = srv.accept()
    except socket.timeout:
        print("[siob] MAME did not connect within 60s", flush=True)
        return 2
    conn.setblocking(False)
    srv.close()
    print(f"[siob] MAME connected: {addr}. Ctrl-] then q to quit.", flush=True)

    stdin_fd = sys.stdin.fileno()
    is_tty = os.isatty(stdin_fd)
    old_attr = termios.tcgetattr(stdin_fd) if is_tty else None
    try:
        if is_tty:
            tty.setraw(stdin_fd)
        escape_pending = False
        while True:
            r, _, _ = select.select([stdin_fd, conn], [], [], 0.1)
            if stdin_fd in r:
                try:
                    data = os.read(stdin_fd, 256)
                except OSError:
                    break
                if not data:
                    break
                out = bytearray()
                for b in data:
                    if escape_pending:
                        escape_pending = False
                        if b in (ord('q'), ord('Q')):
                            return 0
                        out.append(ESC)
                        out.append(b)
                    elif b == ESC:
                        escape_pending = True
                    elif b == 0x0A:   # LF -> CR for CP/M
                        out.append(0x0D)
                    else:
                        out.append(b)
                if out:
                    try:
                        conn.sendall(bytes(out))
                    except OSError:
                        break
            if conn in r:
                try:
                    chunk = conn.recv(4096)
                except OSError:
                    break
                if not chunk:
                    print("\r\n[siob] MAME closed connection", flush=True)
                    break
                os.write(1, chunk)
    finally:
        if is_tty and old_attr is not None:
            termios.tcsetattr(stdin_fd, termios.TCSADRAIN, old_attr)
    return 0

if __name__ == "__main__":
    sys.exit(main())

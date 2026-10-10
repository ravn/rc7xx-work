#!/usr/bin/env python3
"""SIO-B console daemon for the RC700.

Holds /dev/ttyUSB1 open. Reads serial → stdout + /tmp/siob_console.log.
Reads /tmp/siob_cmd FIFO → serial. Responds to the BIOS ENQ probe so
that on cold boot, the BIOS routes CON: to SIO-B (IOBYTE = 0x96).

Session-17 companion to the SIO-B shadow-console BIOS feature. See
`tasks/session17-siob-console.md` for the full picture.

Usage:
    mkfifo /tmp/siob_cmd                       # once
    nohup python3 -u siob_daemon.py \\
        > /tmp/siob_daemon_out.log 2>&1 &
    disown $!

Send commands via the FIFO:
    echo -ne 'DIR\\r' > /tmp/siob_cmd

Watch console output:
    tail -f /tmp/siob_console.log

Stop:
    kill $(cat /tmp/siob_daemon.pid)
"""

import os
import select
import serial
import sys
import time

PORT = os.environ.get('RC700_PORT_B', '/dev/ttyUSB1')
BAUD = 38400
CMD_FIFO = '/tmp/siob_cmd'
LOG_FILE = '/tmp/siob_console.log'
PID_FILE = '/tmp/siob_daemon.pid'


def main():
    with open(PID_FILE, 'w') as f:
        f.write(str(os.getpid()) + '\n')

    ser = serial.Serial(PORT, BAUD, timeout=0, rtscts=False)
    ser.dtr = True

    log = open(LOG_FILE, 'a')

    def output(text):
        sys.stdout.write(text)
        sys.stdout.flush()
        log.write(text)
        log.flush()

    output(f"[siob] daemon started on {PORT} @ {BAUD}\n")

    if not os.path.exists(CMD_FIFO):
        os.mkfifo(CMD_FIFO)
    fifo_fd = os.open(CMD_FIFO, os.O_RDONLY | os.O_NONBLOCK)

    try:
        while True:
            ser_fd = ser.fileno()
            try:
                readable, _, _ = select.select([ser_fd, fifo_fd], [], [], 0.05)
            except (ValueError, OSError):
                try:
                    fifo_fd = os.open(CMD_FIFO, os.O_RDONLY | os.O_NONBLOCK)
                except OSError:
                    pass
                continue

            if ser_fd in readable or ser.in_waiting:
                data = ser.read(ser.in_waiting or 1)
                if data:
                    for b in data:
                        if b == 0x05:  # ENQ from BIOS probe
                            ser.write(b'\x06')  # ACK
                            ser.flush()
                            output("[siob] ENQ\u2192ACK (boot probe)\n")
                    text = data.replace(b'\x05', b'').decode('ascii', errors='replace')
                    if text:
                        output(text)

            if fifo_fd in readable:
                try:
                    cmd = os.read(fifo_fd, 4096)
                    if cmd:
                        ser.write(cmd)
                        ser.flush()
                    else:
                        os.close(fifo_fd)
                        fifo_fd = os.open(CMD_FIFO, os.O_RDONLY | os.O_NONBLOCK)
                except OSError:
                    os.close(fifo_fd)
                    fifo_fd = os.open(CMD_FIFO, os.O_RDONLY | os.O_NONBLOCK)

    except KeyboardInterrupt:
        pass
    finally:
        output("[siob] daemon stopping\n")
        ser.close()
        log.close()
        try:
            os.close(fifo_fd)
        except OSError:
            pass
        try:
            os.unlink(PID_FILE)
        except OSError:
            pass


if __name__ == '__main__':
    main()

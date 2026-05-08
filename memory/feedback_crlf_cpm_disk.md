---
name: CRLF required on CP/M disk image text
description: Always use CR+LF line endings when writing text files into a CP/M disk image
type: feedback
originSessionId: b07ba379-19bf-4244-a50b-7118b0bab69d
---
Always convert text files to CR+LF line endings (0x0D 0x0A) before
injecting into a CP/M disk image with `cpmcp`.  Unix `\n`-only
files cause period-era tools (M80, ED, ASM) to fail silently or
produce wrong output.

**Why:** M80 with LF-only source printed "No END statement" and
emitted a 3-byte stub even though the file contained a valid END
directive — the scanner didn't recognize the line boundaries.  See
rc700-gensmedet/tasks/timeline.md Phase 17.

**How to apply:** Any `printf`, Python `open(..., 'w')`, or direct
cat-into-file should use `\r\n`.  In Python: `open(path, 'w',
newline='\r\n')`.  In shell: `printf 'line\r\n'`.

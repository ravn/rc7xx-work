DGROUP  group   _DATA
_TEXT   segment byte public 'CODE'
        assume  cs:_TEXT, ds:DGROUP
start_:
        mov     dx, offset DGROUP:msg
        mov     cl, 9
        int     0E0h            ; BDOS print string
        mov     cl, 0
        int     0E0h            ; BDOS exit
_TEXT   ends
_DATA   segment byte public 'DATA'
msg     db      'HELLO CP/M-86 FROM WLINK$'
        db      64 dup(0)       ; some BSS-ish tail
_DATA   ends
        end     start_

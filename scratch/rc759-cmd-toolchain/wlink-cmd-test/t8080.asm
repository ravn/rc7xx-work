CSEG    segment byte public 'CODE'
        assume  cs:CSEG, ds:CSEG, ss:CSEG
        org     100h
start_:
        mov     dx, offset msg
        mov     cl, 9
        int     0E0h            ; BDOS 9 = print string
        mov     cl, 0
        int     0E0h            ; BDOS 0 = exit
msg     db      'HELLO FROM A WLINK-BUILT CMD (8080 model)', 0Dh, 0Ah, '$'
CSEG    ends
        end     start_

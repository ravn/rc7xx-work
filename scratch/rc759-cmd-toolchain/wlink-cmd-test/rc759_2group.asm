_TEXT   segment byte public 'CODE'
        assume  cs:_TEXT, ds:_TEXT, ss:_TEXT
; RC759 CCP/M-86 enters CODE group at CS:0000; base page lives in the DATA
; group, so code at offset 0 is safe. Program sets DS=SS=CS and reads its
; strings from the CODE group (the verified-working HELLO.CMD pattern).
start_:
        mov     ax, cs
        mov     ds, ax
        mov     ss, ax
        mov     sp, offset stktop
        mov     dx, offset msg
        mov     cl, 9
        int     0E0h                    ; BDOS 9 print string
        mov     ax, 0AC57h              ; done-signal marker word
        mov     dx, 02FEh
        out     dx, ax
        mov     cl, 0
        int     0E0h                    ; BDOS 0 exit
msg     db      'HELLO FROM A WLINK format cpm86 CMD ON REAL RC759', 0Dh, 0Ah, '$'
stk     dw      64 dup(0)
stktop  label   word
_TEXT   ends

_DATA   segment byte public 'DATA'     ; data group -> absorbs the base page
        db      256 dup(0)              ; base page area (256 B, stored)
        db      0500h dup(?)            ; headroom (BSS, not stored in file)
_DATA   ends
        end     start_

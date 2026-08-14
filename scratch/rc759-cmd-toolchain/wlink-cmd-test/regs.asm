_TEXT   segment byte public 'CODE'
        assume  cs:_TEXT, ds:_TEXT, ss:_TEXT
; Capture the loader-supplied segment regs + SP at entry, BEFORE touching them.
start_:
        mov     bp, sp                  ; BP = entry SP
        mov     si, ds                  ; SI = entry DS
        mov     di, es                  ; DI = entry ES
        mov     cx, ss                  ; CX = entry SS
        mov     ax, cs                  ; AX = entry CS
        ; now establish a safe printing environment (DS=SS=CS)
        mov     ds, ax
        mov     ss, ax
        mov     sp, offset stktop
        mov     e_cs, ax
        mov     e_ds, si
        mov     e_es, di
        mov     e_ss, cx
        mov     e_sp, bp
        ; print "CS=xxxx DS=xxxx ES=xxxx SS=xxxx SP=xxxx"
        mov     dx, offset l_cs
        call    pmsg
        mov     ax, e_cs
        call    phex
        mov     dx, offset l_ds
        call    pmsg
        mov     ax, e_ds
        call    phex
        mov     dx, offset l_es
        call    pmsg
        mov     ax, e_es
        call    phex
        mov     dx, offset l_ss
        call    pmsg
        mov     ax, e_ss
        call    phex
        mov     dx, offset l_sp
        call    pmsg
        mov     ax, e_sp
        call    phex
        mov     dx, offset crlf
        call    pmsg
        mov     ax, 0AC57h              ; done signal
        mov     dx, 02FEh
        out     dx, ax
        mov     cl, 0
        int     0E0h

pmsg:                                   ; print $-string at DS:DX
        mov     cl, 9
        int     0E0h
        ret

phex:                                   ; print AX as 4 hex digits via BDOS 2
        mov     bx, ax
        mov     cx, 4
phl:
        rol     bx, 1
        rol     bx, 1
        rol     bx, 1
        rol     bx, 1
        mov     al, bl
        and     al, 0Fh
        add     al, '0'
        cmp     al, '9'
        jbe     pd
        add     al, 7
pd:
        mov     dl, al
        push    bx
        push    cx
        mov     cl, 2
        int     0E0h
        pop     cx
        pop     bx
        loop    phl
        ret

l_cs    db      'CS=$'
l_ds    db      ' DS=$'
l_es    db      ' ES=$'
l_ss    db      ' SS=$'
l_sp    db      ' SP=$'
crlf    db      0Dh,0Ah,'$'
e_cs    dw      0
e_ds    dw      0
e_es    dw      0
e_ss    dw      0
e_sp    dw      0
stk     dw      128 dup(0)
stktop  label   word
_TEXT   ends

_DATA   segment byte public 'DATA'
        db      256 dup(0)
        db      0500h dup(?)
_DATA   ends
        end     start_

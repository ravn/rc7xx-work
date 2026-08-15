        name    crt0sm
        extrn   main_ : near
        public  _cstart_
        public  _small_code_
_small_code_    equ     0
        public  __STK

; DGROUP includes the C++ static-init/fini table brackets XIB/XI/XIE and
; YIB/YI/YIE (class 'DATA').  The compiler places each global ctor's 6-byte
; rt_init record into segment XI (verified: WORD PUBLIC 'DATA', len 6); we bracket
; it with _Start_XI/_End_XI so the startup can walk and run them before main().
DGROUP  group   BEGDATA, _DATA, XIB, XI, XIE, YIB, YI, YIE, STACK

_TEXT   segment word public 'CODE'
        assume  cs:_TEXT, ds:DGROUP, ss:DGROUP
; Entry CS:0000. Loader already set DS=ES=data group + a 96-byte scratch stack.
; Do NOT touch DS/ES; just move SS to DS and set SP to the top of our DGROUP stack.
_cstart_:
        mov     ax, ds
        mov     ss, ax
        mov     sp, offset DGROUP:stktop
        call    __init_rtns             ; run C++/C static constructors (XI table)
        call    main_
        call    __fini_rtns             ; run C++ static destructors (YI table)
        xor     dx, dx
        mov     cl, 0
        int     0E0h

; __init_rtns -- replicate Watcom __InitRtns(255): run every XI entry in
; ascending-priority order (0 = highest, runs first).  An rt_init entry in the
; 16-bit small model is 6 bytes:
;   +0 rtn_type (0=near, 1=far, 2=PDONE)   +1 priority   +2 rtn (near)   +4 pad
; No-op when XI is empty (_Start_XI == _End_XI), so pure-C programs are unaffected.
__init_rtns:
i_outer:
        mov     bx, offset DGROUP:_End_XI       ; pnext = end (nothing-found sentinel)
        mov     ah, 0FFh                        ; working_limit = 255
        mov     si, offset DGROUP:_Start_XI     ; pcur
i_scan:
        cmp     si, offset DGROUP:_End_XI
        jae     i_pick
        cmp     byte ptr [si], 2                ; already run (PDONE)?
        je      i_next
        mov     al, [si+1]                      ; priority
        cmp     al, ah                          ; priority <= working_limit ?
        ja      i_next
        mov     ah, al                          ; working_limit = priority
        mov     bx, si                          ; pnext = pcur
i_next:
        add     si, 6
        jmp     i_scan
i_pick:
        cmp     bx, offset DGROUP:_End_XI
        je      i_done                          ; none left -> finished
        mov     ax, [bx+2]                      ; rtn (near offset)
        mov     byte ptr [bx], 2                ; mark PDONE before calling
        or      ax, ax
        jz      i_outer                         ; null routine -> just rescan
        push    bx
        push    ds
        call    ax                              ; near indirect call to the ctor
        pop     ds
        pop     bx
        jmp     i_outer
i_done:
        ret

; __fini_rtns -- replicate Watcom __FiniRtns(0,255): run every YI entry in
; DESCENDING-priority order (highest priority number first) after main returns,
; i.e. the reverse of construction (LIFO).  Same 6-byte rt_init layout as XI.
; No-op when YI is empty.
__fini_rtns:
f_outer:
        mov     bx, offset DGROUP:_End_YI       ; pnext = end sentinel
        xor     dl, dl                          ; working_limit = 0 (min)
        mov     si, offset DGROUP:_Start_YI     ; pcur
f_scan:
        cmp     si, offset DGROUP:_End_YI
        jae     f_pick
        cmp     byte ptr [si], 2                ; already run (PDONE)?
        je      f_next
        mov     al, [si+1]                      ; priority
        cmp     al, dl                          ; priority >= working_limit ?
        jb      f_next
        mov     dl, al                          ; working_limit = priority
        mov     bx, si                          ; pnext = pcur
f_next:
        add     si, 6
        jmp     f_scan
f_pick:
        cmp     bx, offset DGROUP:_End_YI
        je      f_done                          ; none left -> finished
        mov     ax, [bx+2]                      ; rtn (near offset)
        mov     byte ptr [bx], 2                ; mark PDONE before calling
        or      ax, ax
        jz      f_outer                         ; null routine -> just rescan
        push    bx
        push    ds
        call    ax                              ; near indirect call to the dtor
        pop     ds
        pop     bx
        jmp     f_outer
f_done:
        ret

; Watcom stack-overflow check helper — no-op stub (no clib on CP/M-86 yet)
__STK:
        ret
_TEXT   ends

BEGDATA segment word public 'BEGDATA'
        db      100h dup(0)             ; base page area DS:0000-00FF
BEGDATA ends

_DATA   segment word public 'DATA'
_DATA   ends

; --- C++ static ctor/dtor table brackets (mirror clib xiyi.asm) ---
XIB     segment word public 'DATA'
_Start_XI label byte
XIB     ends
XI      segment word public 'DATA'
XI      ends
XIE     segment word public 'DATA'
_End_XI label byte
XIE     ends
YIB     segment word public 'DATA'
_Start_YI label byte
YIB     ends
YI      segment word public 'DATA'
YI      ends
YIE     segment word public 'DATA'
_End_YI label byte
YIE     ends

STACK   segment word public 'STACK'
        db      512 dup(0)
stktop  label   word
STACK   ends
        end

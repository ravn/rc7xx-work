        .8086
        public  _small_code_
        public  cpm_start_
        extrn   cmain_:near
_small_code_ equ 0

DGROUP  group   _TEXT

_TEXT   segment byte public 'CODE'
        assume  cs:_TEXT, ds:DGROUP, ss:DGROUP
cpm_start_:
        mov     ax, cs          ; work entirely inside the CODE group
        mov     ds, ax          ; (do NOT trust loader DS/SS - proven convention)
        mov     es, ax
        mov     ss, ax
        mov     sp, 0600h        ; stack top, above our tiny code+data
        call    cmain_
        mov     cl, 0            ; BDOS func 0 = terminate
        xor     dx, dx
        int     0E0h
_TEXT   ends
        end

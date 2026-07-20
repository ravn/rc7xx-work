; llvm-z80 runtime helper: __memmove_rt
; custom register ABI emitted by clang-z80 for struct/aggregate copies:
;   HL = dest, DE = src, BC = count ; overlap-safe (memmove semantics)
; Not the standard C stack ABI, so it must be hand-written asm.
        SECTION code_compiler
        PUBLIC  ___memmove_rt
___memmove_rt:
        ld      a,b
        or      c
        ret     z               ; count == 0 -> done
        push    hl              ; save dest
        or      a               ; clear carry
        sbc     hl,de           ; HL = dest - src (flags only)
        pop     hl              ; restore dest (HL=dest, DE=src)
        jr      c,fwd           ; dest < src  -> forward copy
        jr      z,fwd           ; dest == src -> forward copy (harmless)
        ; dest > src -> copy backward to stay overlap-safe
        push    bc
        ex      de,hl           ; HL=src, DE=dest
        add     hl,bc
        dec     hl              ; HL = src_last
        ex      de,hl           ; HL=dest, DE=src_last
        add     hl,bc
        dec     hl              ; HL = dest_last
        ex      de,hl           ; HL=src_last, DE=dest_last
        pop     bc
        lddr                    ; (HL)->(DE), dec both
        ret
fwd:
        ex      de,hl           ; HL=src, DE=dest (LDIR: src=HL, dest=DE)
        ldir
        ret

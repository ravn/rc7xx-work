BITS 16
org 0
start:
    mov ax, cs
    mov ds, ax              ; DS = CS (self-contained)
    mov ss, ax
    mov sp, 0x0600
    mov si, msg
.next:
    mov dl, [cs:si]         ; read char from CODE group (CS override)
    cmp dl, '$'
    je .done
    mov cl, 2               ; BDOS func 2 = Console Output
    push si
    int 0E0h
    pop si
    inc si
    jmp .next
.done:
    mov cl, 0               ; func 0 = terminate
    xor dl, dl
    int 0E0h
msg: db 0Dh,0Ah,'>>>HELLO-NASM-CMD<<<',0Dh,0Ah,'$'

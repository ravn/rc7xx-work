; =============================================================================
; RC759 Piccoline — RASM-86 Instruction Encoding Compatibility Macros
; =============================================================================
; Digital Researchs RASM-86 assembler (brugt af Flemming Kraglund ved RC)
; genererer modsat direction-bit (d=1) for to-registers 8086-instruktioner
; i forhold til NASMs standard (d=0).
;
; Eksempel:
;   "add bp, bx"
;     RASM-86: 0x03, 0xEB (opcode 0x03: add reg, r/m med reg=bp, r/m=bx)
;     NASM:    0x01, 0xDD (opcode 0x01: add r/m, reg med r/m=bp, reg=bx)
; Begge udfører nøjagtig samme logiske operation (BP = BP + BX), men
; maskinkoden adskiller sig på direction-bitten.
;
; Disse makroer sikrer 100% binær lighed mod originalerne uden grimme "db"
; spredt i kildekoden.
; =============================================================================

%ifndef _RASM86_INC_
%define _RASM86_INC_

; --- ADD instruktioner (d=1) ---
%macro add_bp_bx 0
  db 0x03, 0xEB                                ; add bp, bx
%endmacro

%macro add_dx_bx 0
  db 0x03, 0xD3                                ; add dx, bx
%endmacro

%macro add_si_ax 0
  db 0x03, 0xF0                                ; add si, ax
%endmacro

%macro add_dl_cl 0
  db 0x02, 0xD1                                ; add dl, cl
%endmacro

; --- SUB instruktioner (d=1) ---
%macro sub_cx_dx 0
  db 0x2B, 0xCA                                ; sub cx, dx
%endmacro

%macro sub_bx_dx 0
  db 0x2B, 0xDA                                ; sub bx, dx
%endmacro

%macro sub_bx_ax 0
  db 0x2B, 0xD8                                ; sub bx, ax
%endmacro

%macro sub_dx_ax 0
  db 0x2B, 0xD0                                ; sub dx, ax
%endmacro

%macro sub_cx_dx_byte 0
  db 0x2A, 0xCA                                ; sub cl, dl
%endmacro

; --- CMP instruktioner (d=1) ---
%macro cmp_ch_al 0
  db 0x3A, 0xE8                                ; cmp ch, al
%endmacro

%macro cmp_dl_al 0
  db 0x3A, 0xD0                                ; cmp dl, al
%endmacro

%macro cmp_dh_ah 0
  db 0x3A, 0xF4                                ; cmp dh, ah
%endmacro

%macro cmp_al_dl 0
  db 0x3A, 0xC2                                ; cmp al, dl
%endmacro

; --- MOV instruktioner (d=1) ---
%macro mov_bp_dx 0
  db 0x8B, 0xEA                                ; mov bp, dx
%endmacro

%macro mov_dx_di 0
  db 0x8B, 0xD7                                ; mov dx, di
%endmacro

%macro mov_bx_di 0
  db 0x8B, 0xDF                                ; mov bx, di
%endmacro

%macro mov_bx_ax 0
  db 0x8B, 0xD8                                ; mov bx, ax
%endmacro

%macro mov_bx_dx 0
  db 0x8B, 0xDA                                ; mov bx, dx
%endmacro

%macro mov_bx_si 0
  db 0x8B, 0xDE                                ; mov bx, si
%endmacro

%macro mov_si_ax 0
  db 0x8B, 0xF0                                ; mov si, ax
%endmacro

%macro mov_bl_al 0
  db 0x8A, 0xD8                                ; mov bl, al
%endmacro

%macro mov_bl_dl 0
  db 0x8A, 0xDA                                ; mov bl, dl
%endmacro

%macro mov_bl_cl 0
  db 0x8A, 0xD9                                ; mov bl, cl
%endmacro

%macro mov_al_dl 0
  db 0x8A, 0xC2                                ; mov al, dl
%endmacro

%macro mov_al_cl 0
  db 0x8A, 0xC1                                ; mov al, cl
%endmacro

%macro mov_cl_al 0
  db 0x8A, 0xC8                                ; mov cl, al
%endmacro

%macro mov_ch_al 0
  db 0x8A, 0xE8                                ; mov ch, al
%endmacro

%macro mov_dl_al 0
  db 0x8A, 0xD0                                ; mov dl, al
%endmacro

; --- XOR instruktioner (d=1 hhv. mod=11) ---
%macro xor_bx_bx 0
  db 0x33, 0xDB                                ; xor bx, bx
%endmacro

%macro xor_di_di 0
  db 0x33, 0xFF                                ; xor di, di
%endmacro

%macro xor_si_si 0
  db 0x33, 0xF6                                ; xor si, si
%endmacro

%macro xor_al_al 0
  db 0x32, 0xC0                                ; xor al, al
%endmacro

%macro xor_ah_ah 0
  db 0x32, 0xE4                                ; xor ah, ah
%endmacro

%macro xor_bh_bh 0
  db 0x32, 0xFF                                ; xor bh, bh
%endmacro

%macro xor_ch_ch 0
  db 0x32, 0xED                                ; xor ch, ch
%endmacro

%macro xor_dh_dh 0
  db 0x32, 0xF6                                ; xor dh, dh
%endmacro

; --- OR instruktioner (d=1) ---
%macro or_al_al 0
  db 0x0A, 0xC0                                ; or al, al
%endmacro

%macro or_ax_ax 0
  db 0x0B, 0xC0                                ; or ax, ax
%endmacro

%macro or_dx_dx 0
  db 0x0B, 0xD2                                ; or dx, dx
%endmacro

%endif

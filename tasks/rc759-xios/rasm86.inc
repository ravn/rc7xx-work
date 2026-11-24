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


; --- Ekstra RASM-86 2-register makroer ---
%macro xor_ax_ax 0
  db 0x33, 0xC0
%endmacro
%macro mov_di_si 0
  db 0x8B, 0xFE
%endmacro
%macro xor_dx_dx 0
  db 0x33, 0xD2
%endmacro
%macro or_al_cl 0
  db 0x0A, 0xC1
%endmacro
%macro mov_dx_cx 0
  db 0x8B, 0xD1
%endmacro
%macro sub_dx_cx 0
  db 0x2B, 0xD1
%endmacro
%macro mov_cx_dx 0
  db 0x8B, 0xCA
%endmacro
%macro or_al_dl 0
  db 0x0A, 0xC2
%endmacro
%macro mov_di_cx 0
  db 0x8B, 0xF9
%endmacro
%macro cmp_di_si 0
  db 0x3B, 0xFE
%endmacro
%macro sub_di_dx 0
  db 0x2B, 0xFA
%endmacro
%macro or_cl_cl 0
  db 0x0A, 0xC9
%endmacro
%macro add_dx_di 0
  db 0x03, 0xD7
%endmacro
%macro add_di_dx 0
  db 0x03, 0xFA
%endmacro
%macro mov_ax_si 0
  db 0x8B, 0xC6
%endmacro
%macro mov_dx_si 0
  db 0x8B, 0xD6
%endmacro
%macro cmp_dx_si 0
  db 0x3B, 0xD6
%endmacro
%macro mov_di_ax 0
  db 0x8B, 0xF8
%endmacro
%macro mov_cx_di 0
  db 0x8B, 0xCF
%endmacro
%macro sub_cx_si 0
  db 0x2B, 0xCE
%endmacro
%macro add_si_bx 0
  db 0x03, 0xF3
%endmacro
%macro mov_si_dx 0
  db 0x8B, 0xF2
%endmacro
%macro add_di_bx 0
  db 0x03, 0xFB
%endmacro
%macro mov_si_di 0
  db 0x8B, 0xF7
%endmacro
%macro mov_si_cx 0
  db 0x8B, 0xF1
%endmacro
%macro cmp_cx_dx 0
  db 0x3B, 0xCA
%endmacro
%macro mov_si_bx 0
  db 0x8B, 0xF3
%endmacro
%macro mov_ax_bx 0
  db 0x8B, 0xC3
%endmacro
%macro mov_ax_cx 0
  db 0x8B, 0xC1
%endmacro
%macro mov_ax_dx 0
  db 0x8B, 0xC2
%endmacro
%macro mov_bx_cx 0
  db 0x8B, 0xD9
%endmacro
%macro and_dx_bp 0
  db 0x23, 0xD5
%endmacro
%macro or_dx_ax 0
  db 0x0B, 0xD0
%endmacro
%macro mov_dx_bp 0
  db 0x8B, 0xD5
%endmacro
%macro mov_ah_dl 0
  db 0x8A, 0xE2
%endmacro
%macro mov_ax_di 0
  db 0x8B, 0xC7
%endmacro
%macro sub_ax_si 0
  db 0x2B, 0xC6
%endmacro
%macro mov_cx_ax 0
  db 0x8B, 0xC8
%endmacro
%macro xor_cx_cx 0
  db 0x33, 0xC9
%endmacro
%macro add_si_cx 0
  db 0x03, 0xF1
%endmacro
%macro sub_cx_di 0
  db 0x2B, 0xCF
%endmacro
%macro xor_bp_bp 0
  db 0x33, 0xED
%endmacro
%macro mov_si_bp 0
  db 0x8B, 0xF5
%endmacro
%macro mov_di_bp 0
  db 0x8B, 0xFD
%endmacro
%macro mov_bp_sp 0
  db 0x8B, 0xEC
%endmacro
%macro cmp_al_ah 0
  db 0x3A, 0xC4
%endmacro
%macro cmp_al_dh 0
  db 0x3A, 0xC6
%endmacro
%macro mov_dh_al 0
  db 0x8A, 0xF0
%endmacro
%macro add_ax_dx 0
  db 0x03, 0xC2
%endmacro
%macro add_di_di 0
  db 0x03, 0xFF
%endmacro
%macro mov_al_dh 0
  db 0x8A, 0xC6
%endmacro
%macro add_si_dx 0
  db 0x03, 0xF2
%endmacro
%macro mov_ah_al 0
  db 0x8A, 0xE0
%endmacro
%macro mov_al_ah 0
  db 0x8A, 0xC4
%endmacro
%macro mov_ch_cl 0
  db 0x8A, 0xE9
%endmacro
%macro add_ax_bx 0
  db 0x03, 0xC3
%endmacro
%macro mov_cl_ch 0
  db 0x8A, 0xCD
%endmacro
%macro add_bx_ax 0
  db 0x03, 0xD8
%endmacro
%macro cmp_ax_dx 0
  db 0x3B, 0xC2
%endmacro
%macro mov_cl_ah 0
  db 0x8A, 0xCC
%endmacro
%macro or_al_ah 0
  db 0x0A, 0xC4
%endmacro
%macro and_al_ah 0
  db 0x22, 0xC4
%endmacro
%macro add_bx_cx 0
  db 0x03, 0xD9
%endmacro
%macro and_al_ch 0
  db 0x22, 0xC5
%endmacro
%macro or_al_bl 0
  db 0x0A, 0xC3
%endmacro
%macro sub_ah_dl 0
  db 0x2A, 0xE2
%endmacro
%macro mov_bh_al 0
  db 0x8A, 0xF8
%endmacro
%macro add_dx_ax 0
  db 0x03, 0xD0
%endmacro
%macro sub_bl_cl 0
  db 0x2A, 0xD9
%endmacro
%macro add_bh_bl 0
  db 0x02, 0xFB
%endmacro
%macro mov_al_bh 0
  db 0x8A, 0xC7
%endmacro
%macro add_bl_al 0
  db 0x02, 0xD8
%endmacro
%macro add_ax_di 0
  db 0x03, 0xC7
%endmacro
%macro sub_ax_bx 0
  db 0x2B, 0xC3
%endmacro
%macro cmp_ax_bx 0
  db 0x3B, 0xC3
%endmacro
%macro or_bx_bx 0
  db 0x0B, 0xDB
%endmacro
%macro cmp_cx_ax 0
  db 0x3B, 0xC8
%endmacro
%macro cmp_cl_dl 0
  db 0x3A, 0xCA
%endmacro
%macro mov_cl_dl 0
  db 0x8A, 0xCA
%endmacro
%macro mov_di_bx 0
  db 0x8B, 0xFB
%endmacro
%macro cmp_ax_cx 0
  db 0x3B, 0xC1
%endmacro
%macro sub_cx_ax 0
  db 0x2B, 0xC8
%endmacro
%macro xor_dl_dl 0
  db 0x32, 0xD2
%endmacro
%macro sub_dx_dx 0
  db 0x2B, 0xD2
%endmacro
%macro add_al_bl 0
  db 0x02, 0xC3
%endmacro
%macro mov_dx_bx 0
  db 0x8B, 0xD3
%endmacro
%macro or_cx_cx 0
  db 0x0B, 0xC9
%endmacro
%macro cmp_dx_bx 0
  db 0x3B, 0xD3
%endmacro
%macro mov_al_ch 0
  db 0x8A, 0xC5
%endmacro
%macro sub_ax_ax 0
  db 0x2B, 0xC0
%endmacro

%endif

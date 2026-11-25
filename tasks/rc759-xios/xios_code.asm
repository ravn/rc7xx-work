; =============================================================================
; Parametre for XIOS1 og XIOS4
; =============================================================================
%if NUM_VIR_CONS == 4
	%define XT_ALLOC_PARAS 0x0500                 ; 1280 paragraffer unlinked bufferplads til 4 konsoller
	%define ZORDER_LIST_SIZE 16                   ; 2^4 = 16 kombinationer for 4 konsoller
	%define xios_screen_state_buf (xios4_clip_map + 0x780)
%else
	%define XT_ALLOC_PARAS 0x01F4                 ; 500 paragraffer unlinked bufferplads til 1 konsol
	%define ZORDER_LIST_SIZE 2                    ; 2^1 = 2 kombinationer for 1 konsol
	%define xios_screen_state_buf xios1_screen_state_buf
%endif

; =============================================================================
; Keyboard Shift and Lock Bitmasks (kbd_shift_state / kbd_lock_state)
; =============================================================================
KBD_SHIFT_CTRL      equ 0x02                   ; Control key active
KBD_SHIFT_LEFTSHIFT equ 0x04                   ; Left shift active
KBD_SHIFT_RIGHTSHIFT equ 0x08                  ; Right shift active
KBD_SHIFT_SHIFTS    equ 0x0C                   ; Any shift active (Left | Right)
KBD_SHIFT_ALT       equ 0x10                   ; Alt key active
KBD_LOCK_CAPS       equ 0x20                   ; Caps Lock active

; =============================================================================
; Digital Research CCP/M-86 Process Descriptor (PD) Offsets
; =============================================================================
PD_FLAG             equ 0x06                   ; Process status flags
PD_NAME             equ 0x08                   ; Process name (8 ASCII characters)
PD_UDA              equ 0x10                   ; User Data Area segment
PD_CNS              equ 0x20                   ; Default console index (0..3)

; =============================================================================
; Console Control Block Flags Bitmasks (CCB_FLAGS)
; =============================================================================
CCB_FLG_SCROLL_LOCK equ 0x0001                 ; Bit 0: Scroll-lås / bufferopdatering aktiv
CCB_FLG_INACTIVE    equ 0x0002                 ; Bit 1: Baggrundskonsol (1=inaktiv/skjult, 0=aktiv)
CCB_FLG_WINDOW      equ 0x0004                 ; Bit 2: Virtuelt vindue aktivt (1=vindue, 0=fuld skærm)
CCB_FLG_ATTR_DIRTY  equ 0x0008                 ; Bit 3: Attribut ændret (afventer genberegning)
CCB_FLG_CLIPPED     equ 0x0010                 ; Bit 4: Vindue mindre end fuld skærm (clippet)
CCB_FLG_NOWRAP      equ 0x0100                 ; Bit 8: Kassér tegn ved linjeslut (ESC w / ESC v)
CCB_FLG_CUR_OFF     equ 0x0200                 ; Bit 9: Cursor skjult/deaktiveret (ESC f / ESC e)
CCB_FLG_REVERSE     equ 0x0400                 ; Bit 10: Invers video aktiv (ESC p / ESC q)
CCB_FLG_CHARCONV    equ 0x0800                 ; Bit 11: Funktionstast oversættelse (ESC 6 / ESC 7)
CCB_FLG_NONDISP     equ 0x1000                 ; Bit 12: Non-display mode / skjult tekst (ESC i / ESC x)

; =============================================================================
; Digital Research CCP/M-86 & RC759 Console Control Block (CCB / vc structure)
; Reference: PICCOLINE Programmer's Guide v2, Section 4.6 (Window Handling), p. 61-63
; =============================================================================
CCB_EXTRA_LINE      equ 0x34                   ; rw 1: Extra display line used when scrolling
CCB_CON_IDX         equ 0x36                   ; rb 1: Virtual console number (0..3)
CCB_ACTIVE          equ 0x37                   ; rb 1: Internal XIOS semaphore / active flag
CCB_WIN_LEFT        equ 0x36                   ; rb 1: Left column of window (XIOS 16-bit word at 0x36)
CCB_WIN_TOP         equ 0x38                   ; rb 1: Top row of window
CCB_LAST_TOP_LEFT   equ 0x3a                   ; rw 1: Last top-left corner
CCB_LAST_BOT_RIGHT  equ 0x3c                   ; rw 1: Last bottom-right corner
CCB_COLS            equ 0x42                   ; rb 1: Actual number of columns (f.eks. 80)
CCB_ROWS            equ 0x44                   ; rb 1: Actual number of rows (f.eks. 24)
CCB_SCROLL_BOTTOM   equ 0x48                   ; Window scroll bottom row limit
CCB_MASK            equ 0x4b                   ; Console bitmask (1 << con_index)
CCB_TRACKING_MODE   equ 0x4c                   ; Window cursor tracking mode (0=fixed, non-zero=tracking)
CCB_WRAP_COL        equ 0x4d                   ; Window wrap-around column (WW_WRAP_COLUMN)
CCB_ESC_HANDLER     equ 0x5e                   ; Escape sequence dispatch vector
CCB_LINE_TABLE      equ 0x62                   ; Line display table pointer
CCB_COL             equ 0x64                   ; Current cursor column (0-based)
CCB_ROW             equ 0x66                   ; Current cursor row (0-based)
CCB_ATTR            equ 0x6a                   ; Cursor / display attribute byte
CCB_ATTR_UNDERLINE   equ 0x01                   ; Bit 0: Understregning (ESC g / ESC h)
CCB_ATTR_ALT_CHARSET equ 0x02                   ; Bit 1: Alternativt tegnsæt (ESC P / ESC Q)
CCB_ATTR_BLINK       equ 0x04                   ; Bit 2: Blinkende tekst (ESC s / ESC t)
CCB_ATTR_COLOR_MASK  equ 0xf8                   ; Bits 3-7: Farvepalet-indeks (indeks = attr >> 3)
CCB_FLAGS           equ 0x6b                   ; Console control & mode flags
CCB_SCROLL_MODE     equ 0x71                   ; Console scroll / line mode
CCB_CURSOR_LINES    equ 0x72                   ; Cursor start scanline (word 0x72 = start/end scanlines)
CCB_CURSOR_HEIGHT   equ 0x73                   ; Cursor end scanline / height
CCB_BLINK_FLAG      equ 0x74                   ; Cursor blink enable flag
CCB_VIDEO_MODE      equ 0x7f                   ; Background color / video mode
CCB_CHAR_ATTR       equ 0x80                   ; Character attribute byte
CCB_COLOR_MODE      equ 0x83                   ; Virtual console color/mode setting
CCB_MAX_COL          equ 0x60                   ; Maksimal kolonne (f.eks. 79 i 80-kolonnetilstand)
CCB_SAVED_COL        equ 0x68                   ; Gemt cursorposition ved ESC j / ESC k
CCB_SAVED_FLAGS      equ 0x6d                   ; Gemte konsolflag ved ESC 2 / ESC 3
CCB_SAVED_ATTR       equ 0x6f                   ; Gemt tegnattribut ved ESC 2 / ESC 3
CCB_FKEY_TABLE       equ 0x76                   ; Funktionstast-tabel (pointer til fkey-definitioner)
CCB_ESC_PARAM_FN     equ 0x7b                   ; Escape-sekvens parameter handler/funktion
CCB_ESC_PARAM_BUF    equ 0x7d                   ; Escape-sekvens parameter-buffer
CCB_PALETTE          equ 0x84                   ; Farvepalet / attribut-tabel for konsol

; =============================================================================
; RC759 Piccoline XIOS Driver (Master Source)
; Fælles driver-kode for både XIOS1.CON (1 konsol) og XIOS4.CON (4 konsoller)
; =============================================================================

	jmp near xios_init_entry                     ; 00000000 / 077A0
	jmp near xios_fn_dispatch_entry                           ; 077A3

xios_sysdat_segment_val:
	dw 0x0000                                    ; SYSDAT segment (unlinked, sat af CCP/M loader ved CS:0C06)
xios_sysdat_entry_val:
	dw 0x0000                                    ; SYSDAT entry offset (unlinked, sat af loader ved CS:0C08)
xios_sup_para_base_val:
	dw 0x0000                                    ; Supervisor paragraph base (unlinked, ved CS:0C0A)

; ===========================================================================
; SYSDAT:0x0C0C — DRI struct xios_table
; ===========================================================================
xios_config_table:
xt_tick:
	db 0x00                                      ; xt_tick (system tick flag)
xt_ticks_sec:
	db 0x3C                                      ; xt_ticks_sec (60 Hz VSYNC ticks/sekund)
xt_door:
	db 0x00                                      ; xt_door (reserveret)
xt_rsvd:
	db 0x00                                      ; xt_rsvd (reserveret)
xt_xpcns:
	db 0x01                                      ; xt_xpcns (antal fysiske konsoller = 1)
xt_nvcns:
	db NUM_VIR_CONS                              ; xt_nvcns (antal virtuelle konsoller: 1 eller 4)
xt_nccbs:
	db 0x09                                      ; xt_nccbs (antal Console Control Blocks = 9)
xt_nlcbs:
	db 0x03                                      ; xt_nlcbs (antal List Control Blocks = 3)
xt_ccb:
	dw 0x0D49                                    ; xt_ccb (offset til CCB-array i SYSDAT)
xt_lcb:
	dw 0x0ED5                                    ; xt_lcb (offset til LCB-array i SYSDAT)
	; xt_dphtab: Disk Parameter Header pointere for drev A..P
xt_dphtab:
	dw dph_drive_a                               ; Drev A (Floppy 0 DPH)
	dw dph_drive_b                               ; Drev B (Floppy 1 DPH)
	dw 0x0000, 0x0000, 0x0000, 0x0000            ; Drev C, D, E, F
	dw 0x0000, 0x0000, 0x0000, 0x0000            ; Drev G, H, I, J
	dw 0x0000, 0x0000                            ; Drev K, L
	dw dph_drive_m                               ; Drev M (Memory Disk / M-Disk DPH)
	dw 0x0000, 0x0000, 0x0000                    ; Drev N, O, P
xt_alloc:
	dw XT_ALLOC_PARAS                            ; xt_alloc (unlinked bufferplads: 500 paras i XIOS1, 1280 paras i XIOS4)

xios_fn_dispatch_entry:
	cld
	cbw                                          ; 077DB
	shl al, 1
	xchg bx, ax
	call word [cs:bx + 0xc47]
	mov_bx_ax                                    ; 077E4
	retf

; =============================================================================
; Digital Research CCP/M-86 XIOS Function Dispatch Table (CS:0C47h, 37 entries)
; Reference: Digital Research CCP/M-86 XIOS-86 (xios.a86)
; Indgang: AL = funktionsnummer (0..13 standard + udvidede funktioner)
; =============================================================================
xios_function_table:
	dw io_const                                  ; Func  0: Console input status
	dw io_conin                                  ; Func  1: Console input character
	dw io_conout                                 ; Func  2: Console output character
	dw io_listst                                 ; Func  3: List/printer status
	dw io_list                                   ; Func  4: List/printer output
	dw io_auxin                                  ; Func  5: AUX/serial input
	dw io_auxout                                 ; Func  6: AUX/serial output
	dw io_switch                                 ; Func  7: Switch virtual console
	dw io_statline                               ; Func  8: Update console status line
	dw io_seldsk                                 ; Func  9: Select disk drive
	dw io_read                                   ; Func 10: Read logical disk sector
	dw io_write                                  ; Func 11: Write logical disk sector
	dw io_flushbuf                               ; Func 12: Flush disk buffers
	dw io_poll                                   ; Func 13: Poll hardware device
	dw int28_stub_ret                       ; Func 14: Uimplementeret
	dw int28_stub_ret                       ; Func 15: Uimplementeret
%if NUM_VIR_CONS == 4
	dw ww_pointer                 ; Func 16: Hent vindues-CCB
	dw ww_key            ; Func 17: Tjek konsol-hændelse
	dw ww_statline                      ; Func 18: Menukommando
	dw io_auxist                                 ; Func 19: AUX/konsol status
	dw ww_new_window                    ; Func 20: Vinduesopsætning
	dw ww_cursor_view                 ; Func 21: Vindueskonfiguration
	dw ww_wrap_column                   ; Func 22: Vinduestilstand
	dw ww_full_window                 ; Func 23: Vælg vindue
	dw ww_switch_display                    ; Func 24: Vindue retur
%else
	times 3 dw int28_stub_ret               ; Func 16..18: Uimplementeret i XIOS1
	dw io_auxist                                 ; Func 19: AUX input status
	times 5 dw int28_stub_ret               ; Func 20..24: Uimplementeret i XIOS1
%endif
	times 5 dw int28_stub_ret               ; Func 25..29: Reserveret
	dw io_setblank                               ; Func 30: Skærmblanking / skærmsluk
	times 6 dw int28_stub_ret               ; Func 31..36: Reserveret

; -----------------------------------------------------------------------------
; INT 28H Dispatcher (RC759 Udvidet Hardware/BIOS Funktioner)
; Reference: PICCOLINE Programmer's Guide v2, Appendix A (Funktioner 0-53)
; Indgang: AL = funktionsnummer (0..53)
; Udfører tabelopslag via [cs:bx + 0xcac] og afslutter med IRET.
; -----------------------------------------------------------------------------
int28h_dispatcher:
	push ds
	mov ds, [cs:xios_sysdat_segment_val]
	mov bx, [cs:sysdat_rlr]
	mov es, [bx + PD_UDA]
	xor_bx_bx                                    ; 0783F
	mov_bl_al                                    ; 07841
	shl bx, 1
	call word [cs:bx + 0xcac]
	pop ds
	iret

; =============================================================================
; INT 28H Function Dispatch Table (54 Funktioner: 0..53)
; Placering: CS:0CAC (filoffset 0x0784C - 0x078B7, 108 bytes = 54 words)
; Reference: PICCOLINE Programmer's Guide v2, Appendix A
; =============================================================================
int28h_jump_table:
	dw int28_fn_00_graphics_mode            ; Func  0: Changes console to graphics mode (Manual p. 193)
	dw int28_fn_01_char_mode                ; Func  1: Changes console to character mode (Manual p. 193)
	dw int28_fn_02_scroll_step              ; Func  2: Reserved / Soft scroll step (Manual p. 193)
	dw int28_fn_03_get_nvram                ; Func  3: Returns address of NVRAM copy (Manual p. 194)
	dw int28_fn_04_get_autoconfig           ; Func  4: Returns address of configuration description (Manual p. 194)
	dw int28_fn_05_recalibrate              ; Func  5: Recalibrate floppy disk drive (Manual p. 195)
	dw int28_fn_06_reserved                 ; Func  6: Reserved (Floppy seek)
	dw int28_fn_07_reserved                 ; Func  7: Reserved (Floppy format)
	dw int28_fn_08_step_in                  ; Func  8: Step floppy drive head one track in (Manual p. 195)
	dw int28_fn_09_step_out                 ; Func  9: Step floppy drive head one track out (Manual p. 196)
	dw int28_fn_10_write_track              ; Func 10: Write a track to floppy disk (Manual p. 196)
	dw int28_fn_11_read_track               ; Func 11: Read a track from floppy disk (Manual p. 197)
	dw int28_fn_12_sound                    ; Func 12: Write a byte to the sound generator (Manual p. 197)
	dw int28_fn_13_disk_stats               ; Func 13: Get address of disk driver statistics (Manual p. 197)
	dw int28_fn_14_reserved                 ; Func 14: Reserved
	dw int28_fn_15_reserved                 ; Func 15: Reserved
	dw int28_stub_ret                       ; Func 16: Reserved stub
	dw int28_stub_ret                       ; Func 17: Reserved stub
	dw int28_fn_18_reserved                 ; Func 18: Reserved
	dw int28_fn_19_timer                    ; Func 19: Returns 16 ms counter (Manual p. 199)
	dw int28_fn_20_def_alt_char             ; Func 20: Defines a character in alternative character set (Manual p. 200)
	dw int28_fn_21_get_disp_list            ; Func 21: Returns pointer to console display list (Manual p. 200)
	dw int28_fn_22_set_disp_list            ; Func 22: Returns current cursor position (Manual p. 200)
	dw int28_fn_23_isbx_status              ; Func 23: Returns status of iSBX351 controller (Manual p. 201)
	dw int28_fn_24_isbx_init                ; Func 24: Initializes iSBX351 controller (Manual p. 201)
	dw int28_fn_25_reserved                 ; Func 25: Reserved
	dw int28_fn_26_cas_read_hdr             ; Func 26: Read file header record from cassette tape (Manual p. 202)
	dw int28_fn_27_cas_write_hdr            ; Func 27: Write file header on cassette tape (Manual p. 202)
	dw int28_fn_28_cas_read_data            ; Func 28: Read next data record from cassette tape (Manual p. 203)
	dw int28_fn_29_cas_write_data           ; Func 29: Write next data record on cassette tape (Manual p. 204)
	dw int28_fn_30_mouse                    ; Func 30: Optical mouse driver interface (Manual p. 205)
	dw int28_fn_31_palette                  ; Func 31: Defines palette contents (Manual p. 206)
	dw int28_fn_32_reserved                 ; Func 32: Reserved
	dw int28_fn_33_reserved                 ; Func 33: Reserved
	dw int28_fn_34_reserved                 ; Func 34: Reserved
	dw int28_fn_35_write_str                ; Func 35: Write string direct to console buffer (Manual p. 207)
	dw int28_fn_36_cursor_pos               ; Func 36: Set cursor position (Manual p. 207)
	dw int28_fn_37_get_attr                 ; Func 37: Returns current attributes (Manual p. 207)
	dw int28_fn_38_set_attr                 ; Func 38: Set attributes (Manual p. 208)
	dw int28_fn_39_update_screen            ; Func 39: Update physical screen (Manual p. 208)
	dw int28_fn_40_cas_write_eof            ; Func 40: Write end of file record on cassette tape (Manual p. 208)
	dw int28_fn_41_dpc_parallel             ; Func 41: Reserve/release DPC parallel interface (Manual p. 209)
	dw int28_fn_42_shared_disk              ; Func 42: Reserve/release shared disk (Manual p. 209)
	dw int28_stub_ret                       ; Func 43: Reserved stub
	dw int28_stub_ret                       ; Func 44: Reserved stub
	dw int28_stub_ret                       ; Func 45: Reserved stub
	dw int28_stub_ret                       ; Func 46: Reserved stub
	dw int28_stub_ret                       ; Func 47: Reserved stub
	dw int28_stub_ret                       ; Func 48: Reserved stub
	dw int28_stub_ret                       ; Func 49: Reserved stub
	dw int28_fn_50_isbx_reset               ; Func 50: Reset iSBX351 controller (Manual p. 210)
	dw int28_fn_51_get_font                 ; Func 51: Get font from font RAM (Manual p. 211)
	dw int28_fn_52_def_font                 ; Func 52: Define font in font RAM (Manual p. 211)
	dw int28_fn_53_version                  ; Func 53: Get XIOS version (Manual p. 212)

int28_stub_ret:                            ; 078B8
	ret

int28_fn_53_version:                     ; 078B9
	mov ax, 0x8523
	mov bx, 0x206
	ret

rtm_call_helper:                               ; 078C0
	push dx
	mov cl, 0x85
	call xios_rtm_svc_call
	pop dx
	test ax, ax
	je .ret
	cmp cl, 0x2a
	je rtm_call_helper
.ret:                                     ; 078D0
	ret

rtm_timer_wait:                                ; 078D1
	mov cl, 0x84

rtm_timer_wait2:                               ; 078D3
	mov bx, [cs:sysdat_rlr]
	mov es, [cs:bx + PD_UDA]

xios_rtm_svc_call:                             ; 078DC
	xor_ch_ch                                    ; 078DC
	mov ds, [cs:xios_sysdat_segment_val]
	call far [cs:xios_sysdat_entry_val]
	ret
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF  ; 078E9  .........
	inc word [bx + si]
	times 4 db 0                                ; 078F4..078F6 (4 bytes padding)
	add [bx + si], dl
	times 22 db 0                                ; 078FA..0790E (22 bytes padding)
	add [di + 0xd], dh
	times 10 db 0                                ; 07913..0791B (10 bytes padding)
	db 0xFF                                      ; 0791D  .
	inc word [bx + si]
	add [bx + si], ax
	add [bp + si], al
	add [bx + si], dl
	times 22 db 0                                ; 07926..0793A (22 bytes padding)
	db 0x00, 0xA1, 0x0D, 0x00                    ; 0793C  add byte [bx + di + 0xd], ah
	times 8 db 0                                ; 07940..07946 (8 bytes padding)
	add bh, bh
	inc word [bx + si]
	db 0x02, 0x00                                ; 0794C  add al, byte [bx + si]
	add [bp + si], al
	add [bx + si], dl
	times 22 db 0                                ; 07952..07966 (22 bytes padding)
	add ch, cl
	or ax, strict word 0                         ; 0796A  0D 00 00
	times 8 db 0                                ; 0796D..07973 (8 bytes padding)
	db 0xFF                                      ; 07975  .
	inc word [bx + si]
	add ax, [bx + si]
	add [bp + si], al
	add [bx + si], dl
	times 22 db 0                                ; 0797E..07992 (22 bytes padding)
	add cl, bh
	or ax, strict word 0                         ; 07996  0D 00 00
	times 40 db 0                                ; 07999..079BF (40 bytes padding)
	and ax, strict word 0xe                      ; 079C1  25 0E 00
	times 40 db 0                                ; 079C4..079EA (40 bytes padding)
	add [bx + di + 0xe], dl
	times 42 db 0                                ; 079EF..07A17 (42 bytes padding)
	jge loc_07A29
	times 14 db 0                                ; 07A1B..07A27 (14 bytes padding)

loc_07A29:                                     ; 07A29
	times 28 db 0                                ; 07A29..07A43 (28 bytes padding)
	test ax, 0xe
	times 52 db 0                                ; 07A48..07A7A (52 bytes padding)
	add bh, bh
	inc word [bx + si]
	times 6 db 0                                ; 07A80..07A84 (6 bytes padding)
	add bh, bh
	inc word [bx + si]
	times 6 db 0                                ; 07A8A..07A8E (6 bytes padding)
	add bh, bh
	db 0xFF                                      ; 07A92  .
; -----------------------------------------------------------------------------
; Sektion 3A: Tastatur-ISR, CRT-ISR, Konsol-status og Konsol-input (CS:0EF4..118D)
; Fælles implementering for XIOS1 og XIOS4 (666 bytes kode & datatabeller)
; -----------------------------------------------------------------------------

i_keyboard:
kbd_handler:                                   ; 07A93 / 000002F3
	call xios_switch_to_priv_stack               ; Skift til intern XIOS stak
	cmp byte [cs:kbd_disabled_flag], 0xff       ; Tastatur deaktiveret?
	jne .kbd_not_disabled
	call crt_reset_blink_state                               ; Nulstil buffer

.kbd_not_disabled:
	push ds
	pop es
	call eoi_helper                              ; Send EOI til 8259 PIC
	in al, PORT_KBD_DATA                         ; Læs scancode fra tastatur-port (0x20)
	mov [cs:kbd_raw_scancode], al                          ; Gem rå scancode
	cmp byte [cs:kbd_prefix_flag], 0xff
	jne .check_mouse_packet
	test al, 0x80
	jne .check_scancode_valid
	mov byte [cs:kbd_prefix_flag], 0
	mov bx, kbd_translate_table                ; kbd_translate_table
	xlatb
	mov [cs:kbd_prefix_char], al
	mov dx, 0x13
	call rtm_call_helper
	jmp near .exit

.check_mouse_packet:
	cmp byte [cs:kbd_alt_flag], 0xff
	jne .check_mouse_prefix
	mov byte [cs:kbd_alt_flag], 0
	call mouse_process_packet_byte
	jmp near .exit

.check_mouse_prefix:
	cmp al, 0xe3
	jne .check_diag_keys
	mov byte [cs:kbd_alt_flag], 0xff
	jmp near .exit

.check_diag_keys:
	cmp al, 0x0e
	jne .check_scancode_valid
	test byte [cs:kbd_shift_state], KBD_SHIFT_CTRL
	je .check_scancode_valid
	test byte [cs:kbd_shift_state], KBD_SHIFT_ALT
	je .check_scancode_valid
	mov bx, fdc_drive_type_0
	jmp near loc_0B24F
	db 0xCC                                      ; int3 padding
	jmp near .exit

.check_scancode_valid:
	and al, 0x7f
	cmp al, 0x62
	jle .check_special_keys
	jmp near .exit

.check_special_keys:
	mov cx, 5
	mov ah, 2
	mov bx, kbd_special_keys_table

.special_keys_loop:
	cmp al, [bx]
	jne .next_special_key
	jmp near .handle_special_modifier

.next_special_key:
	shl ah, 1
	inc bx
	loop .special_keys_loop
	mov al, [cs:kbd_raw_scancode]
	or_al_al                                     ; 07B2F
	jns .translate_normal_key
	jmp near .exit

.translate_normal_key:
	mov bx, kbd_ctrl_translate_table                ; kbd_shift_translate_table
	test byte [cs:kbd_shift_state], KBD_SHIFT_CTRL
	jne .do_translate
	mov bx, kbd_shift_translate_table                ; kbd_ctrl_translate_table
	test byte [cs:kbd_shift_state], KBD_SHIFT_SHIFTS
	jne .do_translate
	mov bx, kbd_translate_table                ; kbd_translate_table

.do_translate:
	xlatb
	cmp al, 0xff
	je .exit
	cbw
	mov [cs:kbd_char_buffer_hi], ah
	test byte [cs:kbd_lock_state], KBD_LOCK_CAPS
	je .check_alt_modifier
	cmp al, '~'
	ja .check_alt_modifier
	cmp al, 'a'
	jae .toggle_caps_case
	cmp al, '^'
	ja .check_alt_modifier
	cmp al, 'A'
	jb .check_alt_modifier

.toggle_caps_case:
	xor al, 0x20

.check_alt_modifier:
	and al, 0x7f
	test byte [cs:kbd_shift_state], KBD_SHIFT_ALT
	je .store_char
	test ah, ah
	jns .set_alt_bit
	cmp al, 0x0b
	ja .store_char
	mov bx, 0x104e
	xlatb
	jmp short .store_char

.set_alt_bit:
	or al, 0x80

.store_char:
	mov [cs:kbd_char_buffer], al
	mov dx, [cs:kbd_con_dest]
	cmp dx, 0x18
	jne .send_char_event
	mov byte [cs:kbd_event_flag], 0xff

.send_char_event:
	call rtm_call_helper

.exit:
	jmp near xios_isr_exit_dispatch

.handle_special_modifier:
	cmp al, 0x28
	je .handle_caps_lock
	test byte [cs:kbd_raw_scancode], 0x80
	je .set_shift_modifier
	not ah
	and [cs:kbd_shift_state], ah
	jmp short .done_modifier

.set_shift_modifier:
	or [cs:kbd_shift_state], ah
	jmp short .done_modifier

.handle_caps_lock:
	test byte [cs:kbd_raw_scancode], 0x80
	jne .done_modifier
	xor [cs:kbd_lock_state], ah
	cmp byte [cs:vmenu_active_flag], 0xff
	je .done_modifier
	call io_statline_clear

.done_modifier:
	jmp short .exit

; --- Tastatur- og konsoldata (CS:0x103E..0x1059) ---
kbd_char_buffer:
	db 0x00                                      ; 0x103E (char lo)
kbd_char_buffer_hi:
	db 0x00                                      ; 0x103F (char hi / translated scan code)
kbd_prefix_char:
	db 0x00                                      ; 0x1040 (prefix character)
kbd_con_dest:
	dw 0x0005
kbd_event_flag:
	db 0x00
kbd_raw_scancode:
	db 0x00
kbd_shift_state:
	db 0x00
kbd_lock_state:
	db 0x00
kbd_prefix_flag:
	db 0x00
kbd_alt_flag:
	db 0x00
kbd_special_keys_table:
	db 0x1D, 0x36, 0x2A, 0x37, 0x28, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x1D

; -----------------------------------------------------------------------------
; CRT Afbrydelsesrutine (IRST, Vektor 0x88)
; -----------------------------------------------------------------------------
	push ds                                      ; 07BF9
	call xios_switch_to_priv_stack               ; 07BFA
	cld                                          ; 07BFD

i_crt:
crt_init_irst_ca:                              ; 07BFE
	mov dx, PORT_CRT_RESET                       ; 07BFE
	out dx, ax                                   ; 07C01
	mov dx, PORT_CRT_CA                          ; 07C02
	out dx, ax                                   ; 07C05
	inc byte [cs:crt_vsync_counter]                         ; 07C06
	cmp byte [cs:crt_timer_flag], 0                      ; 07C0B
	je .check_system_tick                                 ; 07C11
	mov dx, PORT_PCB_T1_CON                      ; 07C13
	cmp byte [cs:crt_timer_divider], 0                      ; 07C16
	jne .dec_timer_divider                                ; 07C1C
	mov byte [cs:crt_timer_divider], 8                      ; 07C1E
	mov ax, 0xc003                               ; 07C24
	out dx, ax                                   ; 07C27

.dec_timer_divider:
	dec byte [cs:crt_timer_divider]                         ; 07C28
	jne .check_system_tick                                ; 07C2D
	mov ax, 0xc002                               ; 07C2F
	out dx, ax                                   ; 07C32
	dec byte [cs:crt_timer_flag]                         ; 07C33

.check_system_tick:
	cmp byte [cs:xt_tick], 0                       ; 07C38
	je .call_timer_hook                                 ; 07C3E
	mov dx, 1                                    ; 07C40
	call rtm_call_helper                         ; 07C43

.call_timer_hook:
	call far [cs:xios_hook_timer_off]          ; 07C46
	call eoi_helper                              ; 07C4B
	jmp near xios_isr_exit_dispatch                           ; 07C4E

; --- Special- og funktionstast scanningstabel (CS:10B1..10F6, 70 bytes) ---
; Tastenummer-opslagstabel til tastatur-dekodning (scannes med repne scasb ved CS:17E2)
crt_timer_flag:
	db 0x00                                      ; 0x10B1: CRT timer aktiv flag
crt_timer_divider:
	db 0x00                                      ; 0x10B2: CRT timer divider (nedtæller fra 8)
crt_vsync_counter:
	db 0x00                                      ; 0x10B3: VSYNC / IRST tick tæller
	db 0x00                                      ; 0x10B4: reserveret / padding
key_scan_code_table:                           ; 07C55 (CS:10B5: 66 ASCII-tegn til ESC-sekvenser og tegnoversættelse)
	db ";<=>?@ABCDEFGHIJ"
	db "KLMNOPQRSTUVWXYZ"
	db "[\]^"
	db "abcdefghijklmnopqrstuvwxyz"
	db "{|}~T"

fkey_get_str_ptr:                                      ; 07C97
	mov si, [bx + CCB_FKEY_TABLE]                          ; 07C97
	mov cl, 0x14                                 ; 07C9A
	cmp al, 0x0c                                 ; 07C9C
	jb .calc_str_offset                                 ; 07C9E
	sub al, 0x0c                                 ; 07CA0
	add si, 0xf0                                 ; 07CA2
	mov cl, 4                                    ; 07CA6

.calc_str_offset:
	mul cl                                       ; 07CA8  F6 E1
	add_si_ax                                    ; 07CAA
	ret                                          ; 07CAC

int28_fn_15_reserved:                     ; 07CAD
	call get_cur_process_ccb                               ; 07CAD
	mov bx, [bx + CCB_FKEY_TABLE]                          ; 07CB0
	push ds                                      ; 07CB3
	pop es                                       ; 07CB4
	ret                                          ; 07CB5

io_const:                                      ; 07CB6
	jmp near sio_check_rx_status                           ; 07CB6

io_conin:
	cmp dl, NUM_VIR_CONS                         ; 07CB9
	jb conin_valid_con                                 ; 07CBC
	jmp near loc_0A7F1                           ; 07CBE

conin_valid_con:
	mov bx, [cs:xios4_cur_window_ptr]           ; 07CC1
	cmp byte [bx + 0x7a], 0                      ; 07CC6
	jne .read_fkey_char                                ; 07CCA

.wait_key:
	push bx                                      ; 07CCC
	mov dx, 5                                    ; 07CCD
	call rtm_timer_wait                          ; 07CD0
	pop bx                                       ; 07CD3
	mov ax, [cs:kbd_buf_head]                   ; 07CD4
	mov [cs:kbd_buf_tail], ax                   ; 07CD8
	mov ax, [cs:kbd_char_buffer]                          ; 07CDC
	test ah, ah                                  ; 07CE0
	je .ret                                 ; 07CE2
	cmp al, 'z'                                  ; 07CE4
	je xios_handle_con_switch_key                                 ; 07CE6
	cmp al, '{'                                  ; 07CE8
	je xios_handle_vir_con_switch                                 ; 07CEA (spring til virtuel konsol omskifter)
	cmp al, '}'                                  ; 07CEC
	je vmenu_display_menu_entry                                 ; 07CEE (je target_7d)
	cmp al, '~'                                  ; 07CF0
	jne .skip_7e                                 ; 07CF2
	jmp near loc_07EEC                           ; 07CF4 (jmp near target_7e)

.skip_7e:
	cmp al, 'p'                                  ; 07CF7
	jb .check_charconv                                 ; 07CF9
	and al, NUM_VIR_CONS - 1                     ; 07CFB

.ret:
	ret                                          ; 07CFD

.check_charconv:
	test word [bx + CCB_FLAGS], CCB_FLG_CHARCONV                 ; 07CFE
	je .get_fkey_def                                 ; 07D03
	mov bx, key_scan_code_table                               ; 07D05
	xlatb                                        ; 07D08
	xor_ah_ah                                    ; 07D09
	or al, 0x80                                  ; 07D0B
	jmp short .ret                          ; 07D0D

.get_fkey_def:
	call fkey_get_str_ptr                                ; 07D0F

.store_fkey_ptr:
	mov [bx + 0x78], si                          ; 07D12
	mov [bx + 0x7a], cl                          ; 07D15

.read_fkey_char:
	mov si, [bx + 0x78]                          ; 07D18
	lodsb                                        ; 07D1B
	mov [bx + 0x78], si                          ; 07D1C
	dec byte [bx + 0x7a]                         ; 07D1F
	xor_ah_ah                                    ; 07D22
	or_al_al                                     ; 07D24
	jne .ret                                ; 07D26
	mov [bx + 0x7a], al                          ; 07D28
	jmp short conin_valid_con.wait_key                          ; 07D2B

; -----------------------------------------------------------------------------
; Sektion 3B.1: Konsol-switch (Chunk 1), Skærmtrimning og Konsol-opdatering (Chunk 2)
; (CS:118D..12A6, 282 bytes i XIOS1, 353 bytes i XIOS4)
; -----------------------------------------------------------------------------

%if NUM_VIR_CONS == 4
xios_handle_con_switch_key:                                     ; 0000058D (XIOS4 konsol switch-tast)
	mov dl, [cs:xios4_active_vir_con]
	call ww_full_window
	jmp short conin_valid_con.wait_key

xios_handle_vir_con_switch:                                     ; 00000597 (XIOS4 virtuel konsol omskifter)
	cmp byte [cs:xios4_vir_con_mode], 1
	jc .skip_switch
	call ccb_check_background_active
	jnz .skip_switch
	mov byte [cs:xios4_vir_con_mode], 2
	mov dx, 0x18
	mov [cs:kbd_con_dest], dx
	mov byte [cs:kbd_event_flag], 0xff
	call rtm_call_helper
	pushf
	call far [cs:sysdat_dispatcher]
.skip_switch:
	jmp near conin_valid_con.wait_key
%else
xios_handle_con_switch_key:                                     ; 07D2D
	jmp short conin_valid_con.wait_key

xios_handle_vir_con_switch:                                     ; 07D2F
	jmp near conin_valid_con.wait_key
%endif

vmenu_retry_delay:                                     ; Fælles retur til menu-genopfriskning
	call rtm_delay_1_tick

; -----------------------------------------------------------------------------
; Skærmtrimningsmenu (VMenu / Display Trim Menu)
; -----------------------------------------------------------------------------
vmenu_display_menu_entry:                                     ; 07D35 / 000005C7
	mov al, 0xff
	xchg [cs:vmenu_active_flag], al           ; 07D37
	cmp al, 0xff
	je vmenu_retry_delay
	mov [cs:vmenu_saved_bx], bx            ; 07D40
	mov [cs:vmenu_active_flag], al            ; 07D45
	mov bp, es
	push cx
	push ds
	pop es
	mov di, xios_con_line_buffer_614a                  ; 07D4E
	push di
	mov ax, 0x820
	mov cx, 0x50
	rep stosw
	pop di
	mov si, xios_vmenu_title                ; 07D5B (vmenu titeltekst)
	lodsb
	call vmenu_render_string

.restart_items:                                     ; 07D62
	mov si, vmenu_item_table                     ; 07D62 (pointer til menupunkt-tabel)

.next_item:                                     ; 07D65
	lodsw
	or_ax_ax                                     ; 07D66
	je .restart_items
	xchg di, ax
	push si
	push di
	mov si, [di - 4]
	lodsb
	mov di, xios_con_line_buffer_6186                  ; 07D71
	call vmenu_render_string
	mov cx, 0x14
	mov al, 0x20
	rep stosw
	pop di
	mov bx, [cs:xios4_cur_window_ptr]           ; 07D7F
	mov si, [di - 6]
	mov bl, [bx + si]
	xor_bh_bh                                    ; 07D89
	shl bx, 1
	pop si
	jmp short .show_value

.wrap_value_zero:                                     ; 07D90
	xor_bx_bx                                    ; 07D90

.show_value:                                     ; 07D92
	mov ax, [bx + di]
	or_ax_ax                                     ; 07D94
	je .wrap_value_zero
	push si
	push di
	mov_si_ax                                    ; 07D9A
	mov al, [di - 7]
	mov di, xios_con_line_buffer_61b8                  ; 07D9F
	call vmenu_render_string
	mov cx, 8
	mov al, 0x20
	rep stosw
	mov dx, [cs:kbd_con_dest]
	push bx
	mov es, bp
	call rtm_timer_wait
	mov bp, es
	push ds
	pop es
	pop bx
	pop di
	pop si
	mov ax, [cs:kbd_char_buffer]
	cmp ax, 0xff7d
	je .apply_item_and_exit
	cmp ax, strict word 0x1b                     ; 07DC7  3D 1B 00
	je .next_item
	cmp ax, strict word 0xd                      ; 07DCC  3D 0D 00
	je .apply_item_next
	cmp ax, strict word 0x20                     ; 07DD1  3D 20 00
	jne .show_value
	inc bx
	inc bx
	jmp near .show_value

.apply_item_next:                                     ; 07DDB
	call vmenu_exec_action
	jmp near .next_item

.apply_item_and_exit:                                     ; 07DE1
	call vmenu_exec_action
	mov es, bp
	mov cx, 0xffff
	call io_statline
	pop cx
	jmp near io_conin

vmenu_exec_action:                                     ; 07DF0
	shr bx, 1
	xchg bx, ax
	push si
	mov bx, [cs:xios4_cur_window_ptr]           ; 07DF4
	call word [di - 2]
	pop si
	ret

vmenu_render_string:                                     ; 07DFE
	cbw
	xchg cx, ax
	mov ah, 8

.char_loop:                                     ; 07E02
	lodsb
	stosw
	loop .char_loop
	ret

vmenu_action_item_1:
	mov [bx + CCB_BLINK_FLAG], al
	jmp near crt_load_cursor_hardware_regs                           ; 07E0A

vmenu_action_item_2:
	mov_ch_al                                    ; 07E0D
	mov cl, 0xa

vmenu_set_cursor_lines:                                      ; 07E11
	mov [bx + CCB_CURSOR_LINES], cx
	jmp near crt_load_cursor_hardware_regs                           ; 07E14

vmenu_action_item_3:
	mov [bx + CCB_SCROLL_MODE], al
	mov [cs:xios_crt_font_alt_flag], al           ; 07E1A
	ret

vmenu_action_item_4:
	mov [bx + CCB_VIDEO_MODE], al
	ret

; -----------------------------------------------------------------------------
; Chunk 2: Opdatering af virtuel konsolindeks-mapping (CS:1288)
; -----------------------------------------------------------------------------
vmenu_action_item_5:
	push bx
	push cx
	xor_ah_ah                                    ; 07E25
	mov bx, ccb_console_0                        ; Konsol 0 CCB
	mov [bx + CCB_COLOR_MODE], al
%if NUM_VIR_CONS == 4
	mov bx, ccb_console_1                        ; Konsol 1 CCB
	mov [bx + CCB_COLOR_MODE], al
	mov bx, ccb_console_2                        ; Konsol 2 CCB
	mov [bx + CCB_COLOR_MODE], al
	mov bx, ccb_console_3                        ; Konsol 3 CCB
	mov [bx + CCB_COLOR_MODE], al
%endif
	mov_bx_ax                                    ; 07E2E
	mov cl, 4
	shl bx, cl
	sub_bx_ax                                    ; 07E34
	mov cl, 2
	shl bx, cl
	mov [cs:kbd_buf_head], bx                   ; 07E3A
	mov [cs:kbd_buf_tail], bx                   ; 07E3F
	pop cx
	pop bx
	ret



; =============================================================================
; Sektion 3B.2: Skærmtrimningsmenu Tabeller & Terminal/Konsol Output (CS:12A7..1500)
; Fælles for både XIOS1 og XIOS4 med parametriserede tabeller og symbolske instruktioner
; =============================================================================
; =============================================================================
; Virtuel Menu Tabeller og Element-definitioner
; Format for hvert menupunkt (7 bytes foran options-listen):
;   db <attr_color>     ; [di - 7] = Tekstfarve / skærmattribut for punktets værdi
;   dw <ccb_offset>     ; [di - 6] = Forskydning i aktuel CCB for den styrede parameter
;   dw <prompt_str>     ; [di - 4] = Pointer til menupunktets ledetekst
;   dw <action_handler> ; [di - 2] = Handler der kaldes når værdien ændres
;   dw opt1, opt2...    ; [di + 0] = Nul-termineret liste af valgmulighed-strenge
; =============================================================================
vmenu_item_table:                               ; 07E47 / 000006EE (Menupunkt-tabel)
	dw vmenu_item_2_options
	dw vmenu_item_1_options
	dw vmenu_item_3_options
	dw vmenu_item_5_options
	dw vmenu_item_4_options
	dw 0x0000                                    ; Nul-terminering / padding (2 bytes)

; Item 1: Markør blink (Ja/Nej)
vmenu_item_1:
	db 0x04                                      ; Farveattribut: Rød (4)
	dw CCB_BLINK_FLAG                            ; CCB offset 0x74: Markør blink-status
	dw xios_vmenu_str_blink                      ; Prompt: "Blink   "
	dw vmenu_action_item_1                       ; Handling: opdater CCB[0x74]
vmenu_item_1_options:
	dw xios_vmenu_opt_no
	dw xios_vmenu_opt_yes
	dw 0x0000                                    ; Afslutning af optionsliste

; Item 2: Markør højde / scanlines (1..10)
vmenu_item_2:
	db 0x02                                      ; Farveattribut: Grøn (2)
	dw CCB_CURSOR_HEIGHT                         ; CCB offset 0x73: Markør scanline-højde
	dw xios_vmenu_str_height                     ; Prompt: "Højde   "
	dw vmenu_action_item_2                       ; Handling: opdater CCB[0x72..0x73]
vmenu_item_2_options:
	dw vmenu_num_str_10
	dw vmenu_num_str_9
	dw vmenu_num_str_8
	dw vmenu_num_str_7
	dw vmenu_num_str_6
	dw vmenu_num_str_5
	dw vmenu_num_str_4
	dw vmenu_num_str_3
	dw vmenu_num_str_2
	dw vmenu_num_str_1
	dw 0x0000                                    ; Afslutning af optionsliste

; Item 3: Rulning / scroll (Ja/Nej)
vmenu_item_3:
	db 0x04                                      ; Farveattribut: Rød (4)
	dw CCB_SCROLL_MODE                           ; CCB offset 0x71: Rulnings-tilstand
	dw xios_vmenu_str_scroll                     ; Prompt: "Rulning "
	dw vmenu_action_item_3                       ; Handling: opdater CCB[0x71]
vmenu_item_3_options:
	dw xios_vmenu_opt_no
	dw xios_vmenu_opt_yes
	dw 0x0000                                    ; Afslutning af optionsliste

; Item 4: Baggrundsfarve (Sort..Hvid)
vmenu_item_4:
	db 0x07                                      ; Farveattribut: Hvid (7)
	dw CCB_VIDEO_MODE                            ; CCB offset 0x7F: Baggrundsfarve
	dw xios_vmenu_str_color                      ; Prompt: "Farve   "
	dw vmenu_action_item_4                       ; Handling: opdater CCB[CCB_VIDEO_MODE]
vmenu_item_4_options:
	dw xios_vmenu_opt_sort
	dw xios_vmenu_opt_blue
	dw xios_vmenu_opt_green
	dw xios_vmenu_opt_cyan
	dw xios_vmenu_opt_red
	dw xios_vmenu_opt_magenta
	dw xios_vmenu_opt_yellow
	dw xios_vmenu_opt_white
	dw 0x0000                                    ; Afslutning af optionsliste

; Item 5: Konsol-skærmblanking / timeout
vmenu_item_5:
	db 0x02                                      ; Farveattribut: Grøn (2)
	dw CCB_COLOR_MODE                            ; CCB offset 0x83: Blanking / tilstand
	dw xios_vmenu_str_blank                      ; Prompt: "Blank   "
	dw vmenu_action_item_5                       ; Handling: opdater CCB[CCB_COLOR_MODE]
vmenu_item_5_options:
	dw vmenu_num_str_space
	dw vmenu_num_str_1
	dw vmenu_num_str_2
	dw vmenu_num_str_3
	dw vmenu_num_str_4
	dw vmenu_num_str_5
	dw vmenu_num_str_6
	dw vmenu_num_str_7
	dw vmenu_num_str_8
	dw vmenu_num_str_9
	dw vmenu_num_str_10
	dw vmenu_num_str_11
	dw vmenu_num_str_12
	dw vmenu_num_str_13
	dw vmenu_num_str_14
	dw vmenu_num_str_15
	db 0x00, 0x00

; Tal-strenge (" 1".."15")
vmenu_num_str_1:      db "1 "
vmenu_num_str_2:      db "2 "
vmenu_num_str_3:      db "3 "
vmenu_num_str_4:      db "4 "
vmenu_num_str_5:      db "5 "
vmenu_num_str_6:      db "6 "
vmenu_num_str_7:      db "7 "
vmenu_num_str_8:      db "8 "
vmenu_num_str_9:      db "9 "
vmenu_num_str_10:     db "10"
vmenu_num_str_11:     db "11"
vmenu_num_str_12:     db "12"
vmenu_num_str_13:     db "13"
vmenu_num_str_14:     db "14"
vmenu_num_str_15:     db "15"
vmenu_num_str_space:  db 0x9B, 0x20

loc_07EEC:                                     ; 07EEC
	test byte [bx + CCB_FLAGS], CCB_FLG_WINDOW
	je loc_07EF5
	jmp near conin_valid_con

loc_07EF5:                                     ; 07EF5
	mov bx, [bx + 0x5c]
	mov si, [bx]
	mov dl, [si + 0x24]
	push dx
	mov cl, 0xa0
	call rtm_timer_wait2
	mov cl, 0xa1
	call rtm_timer_wait2
	pop dx
	mov si, boot_msg_printer_reserved
	or_ax_ax                                     ; 07F0C
	jne loc_07F59
	push dx
	call io_listst
	pop dx
	mov si, boot_msg_printer_not_ready
	or_al_al                                     ; 07F18
	je loc_07F59
	mov cl, 0xc
	call printer_out_char
	mov bx, [cs:xios4_cur_window_ptr]
	mov cx, [bx + CCB_SCROLL_BOTTOM]
	test byte [cs:xios4_window_clip_flag], 0xff
	jne loc_07F37
	mov bx, xios_vmenu_line_offsets
	mov cx, 0x18

loc_07F37:                                     ; 07F37
	mov si, [bx]
	push bx
	push cx
	push ds
	mov ds, [cs:xios_sysdat_segment_ptr]
	call printer_print_line
	pop ds
	pop cx
	pop bx
	inc bx
	inc bx
	loop loc_07F37
	mov si, xios_con_line_buffer_614a
	call printer_print_line

loc_07F51:                                     ; 07F51
	mov cl, 0x9f
	call rtm_timer_wait2
	jmp near conin_valid_con

loc_07F59:                                     ; 07F59
	call con_puts
	jmp short loc_07F51

printer_print_line:                                     ; 07F5E
	mov cx, 0x51
	mov_bx_si                                    ; 07F61
	add bx, 0xa0

loc_07F67:                                     ; 07F67
	dec cx
	je loc_07F7D
	dec bx
	dec bx
	cmp byte [bx], ' '
	je loc_07F67

loc_07F71:                                     ; 07F71
	lodsw
	push cx
	push si
	mov_cl_al                                    ; 07F74
	call printer_out_char
	pop si
	pop cx
	loop loc_07F71

loc_07F7D:                                     ; 07F7D
	mov cl, 0xd
	call printer_out_char
	mov cl, 0xa
	call printer_out_char
	ret

printer_out_char:                                     ; 07F88
	test cl, 0x80
	je loc_07F9D
	cmp dl, 1
	je loc_07F9B
	mov bx, xios_crt_table_4256
	test [cs:bx + 0x1c], cl
	je loc_07F9D

loc_07F9B:                                     ; 07F9B
	mov cl, 0x20

loc_07F9D:                                     ; 07F9D
	push dx
	push ds
	mov ds, [cs:xios_sysdat_segment_val]
	call io_list
	pop ds
	pop dx
	ret

ww_key:
	xor_ah_ah                                    ; 07FAA
	mov al, [cs:kbd_event_flag]
	cmp cl, 0xfe
	je ww_key_ret
	jb loc_07FBB
	test al, al
	je ww_key_ret

loc_07FBB:                                     ; 07FBB
	mov dx, 0x18
	call rtm_timer_wait
	mov byte [cs:kbd_event_flag], 0
	mov ax, [cs:kbd_char_buffer]

ww_key_ret:                                     ; 07FCB
	ret

io_conout:
	cmp dl, NUM_VIR_CONS
	jb loc_07FD4
	jmp near loc_0A8C5

loc_07FD4:                                     ; 07FD4
	push es
	push ds
	pop es
	xor_dh_dh                                    ; 07FD7
	mov_bx_dx                                    ; 07FD9
	shl bx, 1
	mov bx, [cs:bx + xios_ccb_table]
	call word [bx + CCB_ESC_HANDLER]
	mov ax, [cs:kbd_buf_head]
	mov [cs:kbd_buf_tail], ax
	pop es
	ret

crt_char_handler:
	cmp cl, ' '
	jae loc_08053
	cmp cl, 0
	jne loc_07FFA
	ret

loc_07FFA:                                     ; 07FFA
	cmp cl, 0xd
	jne loc_08002
	jmp near crt_cursor_home_row

loc_08002:                                     ; 08002
	cmp cl, 0xa
	jne loc_0801C
	test byte [bx + CCB_FLAGS], CCB_FLG_WINDOW
	jne loc_08013
	call crt_cursor_down
	jmp near crt_update_cursor

loc_08013:                                     ; 08013
	call crt_hide_cursor_graphics
	call crt_cursor_down
	jmp near crt_draw_cursor_graphics

loc_0801C:                                     ; 0801C
	cmp cl, 8
	jne loc_08037
	dec word [bx + CCB_ROW]
	jns loc_08034
	mov ax, [bx + CCB_MAX_COL]
	mov [bx + CCB_ROW], ax
	dec word [bx + CCB_COL]
	jns loc_08034
	jmp near crt_cursor_home

loc_08034:                                     ; 08034
	jmp near crt_update_cursor

loc_08037:                                     ; 08037
	cmp cl, 0x1b
	jne loc_08042
	mov word [bx + CCB_ESC_HANDLER], crt_esc_dispatch_normal
	ret

loc_08042:                                     ; 08042
	cmp cl, 7
	jne loc_08053
	test byte [bx + CCB_FLAGS], CCB_FLG_INACTIVE
	jne .ret
	inc byte [cs:crt_timer_flag]
.ret:                                     ; 08052
	ret

loc_08053:                                     ; 08053
	test byte [bx + CCB_FLAGS], CCB_FLG_WINDOW
	jne short loc_080C5
	test byte [bx + CCB_FLAGS], CCB_FLG_ATTR_DIRTY
	je loc_08062
	call crt_get_char_attr

loc_08062:                                     ; 08062
	test word [bx + CCB_FLAGS], CCB_FLG_NONDISP
	je loc_0806B
	mov cl, 0x20

loc_0806B:                                     ; 0806B
	mov di, [bx + CCB_LINE_TABLE]
	mov ch, [bx + CCB_ATTR]
	push es
	mov es, [cs:xios_sysdat_segment_ptr]
	mov [es:di], cx
	test byte [cs:xios4_window_clip_flag], 0xff
	jne loc_080BE
	call ccb_acquire_lock
	mov dh, [bx + CCB_COL]
	mov dl, [bx + CCB_ROW]
	call crt_calc_screen_offset
	add ax, [bx + 0x46]
	xchg si, ax
	call window_check_point_inside
	jb loc_080BA
; --- Chunk 3: Virtuel konsol-opslag for skærmposition (CS:14F6, +3 B) ---
%if NUM_VIR_CONS == 4
	mov al, [cs:si + xios4_clip_map]             ; Slå op i klippekort for skærmposition (0000093E)
%else
	mov al, 1                                    ; Konsol 0 er altid synlig og fuld skærm i XIOS1
%endif
	call window_zorder_lookup
	cmp al, [bx + CCB_CON_IDX]
	jne loc_080BA
	shl si, 1
	test byte [bx + CCB_FLAGS], CCB_FLG_INACTIVE
	je loc_080B7
	cmp byte [cs:xios_is_color_display], 0xff
	jne loc_080B7
	and ch, 0x87
	or ch, 8

loc_080B7:                                     ; 080B7
	mov [es:si], cx

loc_080BA:                                     ; 080BA
	mov byte [bx + CCB_ACTIVE], 0


loc_080BE:                                     ; 080BE
	pop es
	call crt_cursor_advance_col
	jmp near crt_update_hw_cursor

loc_080C5:                                     ; 080C5
	mov ax, [bx + CCB_COL]
	mov dx, [bx + CCB_ROW]
	call crt_render_char_bitmap
	call crt_cursor_advance_col
	jmp near crt_draw_cursor_graphics

crt_cursor_advance_col:                                     ; 080D4
	add word [bx + CCB_LINE_TABLE], 2
	mov ax, [bx + CCB_ROW]
	inc ax
	cmp al, [bx + CCB_WRAP_COL]
	jb loc_080FC
	sub word [bx + CCB_LINE_TABLE], 2
	dec ax
	test word [bx + CCB_FLAGS], CCB_FLG_NOWRAP
	jne loc_080FC
	call crt_cursor_down

crt_cursor_col_zero:                                     ; 080F0
	mov si, [bx + CCB_COL]
	shl si, 1
	mov si, [bx + si]
	mov [bx + CCB_LINE_TABLE], si
	xor_ax_ax                                    ; 080FA

loc_080FC:                                     ; 080FC
	mov [bx + CCB_ROW], ax
	ret

crt_esc_dispatch_reset:
	call crt_reset_blink_state
	mov word [bx + CCB_ESC_HANDLER], crt_char_handler
	jmp near crt_char_handler

crt_esc_dispatch_normal:
	mov word [bx + CCB_ESC_HANDLER], crt_char_handler
	mov di, crt_esc_table
	mov_al_cl                                    ; 08113
	call crt_dispatch_esc_char
crt_esc_jump_table:
	; --- Escape sequence jump table (62 word pointers) ---
	dw crt_esc_default_ret, crt_esc_254_rest_fkeys, crt_esc_253_save_fkeys, crt_esc_7_fkey_exp_on, crt_esc_6_fkey_exp_off, crt_esc_247_underl_on, crt_esc_246_underl_off, crt_esc_245_line_scroll
	dw crt_esc_244_soft_scroll, crt_esc_243_cur_shape, crt_esc_242_cur_steady, crt_esc_241_cur_blink, crt_esc_7_fkey_exp_on, crt_esc_6_fkey_exp_off, crt_esc_3_restore_attrs, crt_esc_2_save_attrs
	dw crt_esc_1_24_lines, crt_esc_0_25_lines, crt_esc_gt_scroll_dn, crt_esc_lt_scroll_up, crt_esc_colon_prog_fkeys, crt_esc_z_reset_attrs, crt_esc_x_nondisp_off, crt_esc_w_wrap_off
	dw crt_esc_v_wrap_on, crt_esc_u_intensify_off, crt_esc_r_intensify_on, crt_esc_t_blink_off, crt_esc_s_blink_on, crt_esc_q_reverse_off, crt_esc_p_reverse_on, crt_esc_o_erase_bol
	dw crt_esc_f_cur_off, crt_esc_e_cur_on, crt_esc_l_erase_line, crt_esc_k_restore_cursor, crt_esc_j_save_cursor, crt_esc_i_nondisp_on, crt_esc_h_underline_off, crt_esc_g_underline_on
	dw crt_esc_f_cur_off, crt_esc_e_cur_on, crt_esc_d_erase_bos, crt_esc_c_bg_color, crt_esc_b_fg_color, crt_esc_a_ignored, crt_esc_Y_pos_cursor, crt_esc_Q_std_cset
	dw crt_esc_P_alt_cset, crt_esc_O_ins_char, crt_esc_N_del_char, crt_esc_M_del_line, crt_esc_L_ins_line, crt_esc_K_erase_eol, crt_esc_J_erase_eos, crt_esc_I_rev_index
	dw crt_esc_E_cls, crt_esc_A_up, crt_esc_B_down, crt_esc_D_back, crt_esc_C_fwd, crt_esc_H_home
crt_esc_table:
	; --- Escape sequence character table (62 bytes) ---
	db "=HCDBAEIJKLMNOPQYabcdefghijklmnopqstruvwxz:<>012367", 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xfb, 0xfc, 0xfd, 0xfe
; ESC H - Cursor Home (s. 51 / App. F): Flyt cursor til øverste venstre hjørne
crt_esc_H_home:
	jmp near crt_cursor_home

; ESC C - Cursor Forward (s. 51 / App. F): Flyt cursor en kolonne frem (højre)
crt_esc_C_fwd:
	mov dx, [bx + CCB_ROW]
	cmp dx, [bx + CCB_MAX_COL]
	je loc_08203
	inc dx
	mov [bx + CCB_ROW], dx
	jmp near crt_update_cursor

; ESC D - Cursor Backward (s. 51 / App. F): Flyt cursor en kolonne tilbage (venstre)
crt_esc_D_back:
	dec word [bx + CCB_ROW]
	jns loc_08203
	inc word [bx + CCB_ROW]
	ret

; ESC B - Cursor Down (s. 51 / App. F): Flyt cursor en linje ned
crt_esc_B_down:
	jmp near loc_085BA

; ESC A - Cursor Up (s. 50 / App. F): Flyt cursor en linje op
crt_esc_A_up:
	dec word [bx + CCB_COL]
	jns loc_08203
	inc word [bx + CCB_COL]
	ret

; ESC I - Reverse Index (s. 51 / App. F): Cursor op; ruller skærm ned ved øverste linje
crt_esc_I_rev_index:
	mov si, [bx + CCB_COL]
	test si, si
	jne crt_esc_A_up
	call crt_scroll_lines_down

loc_08203:                                     ; 08203
	jmp near crt_update_cursor

; ESC E - Clear Screen, Cursor Home (s. 51 / App. F): Ryd skærm og sæt cursor til (0,0)
crt_esc_E_cls:
	test byte [bx + CCB_FLAGS], CCB_FLG_WINDOW
	jne loc_08216
	call palette_init_default_colors
	mov al, [bx + CCB_CHAR_ATTR]
	call crt_set_char_attr

loc_08216:                                     ; 08216
	call crt_cursor_home
; ESC J - Erase to End of Screen (s. 51 / App. F): Slet fra cursor til skærmens slutning
crt_esc_J_erase_eos:
	mov si, [bx + CCB_COL]
.loc_1680:
	inc si
	cmp si, [bx + CCB_SCROLL_BOTTOM]
	je .loc_1688
	mov dx, [bx + CCB_SCROLL_BOTTOM]
	call crt_clear_line_loop                               ; call 0x1ABF / 0x1B09
.loc_1688:
; ESC K - Erase to End of Line (s. 51 / App. F): Slet fra cursor til linjens slutning
crt_esc_K_erase_eol:
	mov cx, [bx + CCB_MAX_COL]
	mov dx, [bx + CCB_ROW]
	jmp near loc_0862E                           ; jmp 0x1A8E / 0x1AD8

; ESC L - Insert Line (s. 52 / App. F): Indsæt blank linje ved cursorposition
crt_esc_L_ins_line:
	call crt_hide_cursor_graphics                                ; call 0x1EB4 / 0x1EFE
	mov si, [bx + CCB_COL]
	call crt_scroll_lines_down                               ; call 0x1B4F / 0x1B99
	call crt_cursor_col_zero                               ; call 0x1550 / 0x159A
	jmp near crt_update_cursor_dispatch                           ; jmp 0x1A85 / 0x1ACF

; ESC M - Delete Line (s. 52 / App. F): Slet linjen ved cursorposition
crt_esc_M_del_line:
	call crt_hide_cursor_graphics                                ; call 0x1EB4 / 0x1EFE
	mov si, [bx + CCB_COL]
	call crt_scroll_lines_up                               ; call 0x1B26 / 0x1B70
	call crt_cursor_col_zero                               ; call 0x1550 / 0x159A
	jmp near crt_update_cursor_dispatch                           ; jmp 0x1A85 / 0x1ACF

; ESC O - Insert Character (s. 52 / App. F): Indsæt mellemrum ved cursor, skub linjen til højre
crt_esc_O_ins_char:
	test byte [bx + CCB_FLAGS], CCB_FLG_WINDOW
	jne loc_08297
	mov si, [bx + CCB_COL]
	shl si, 1
	mov si, [bx + si]
	mov ax, [bx + CCB_MAX_COL]
	shl ax, 1
	add_si_ax                                    ; 08261
	mov_di_si                                    ; 08263
	dec si
	dec si
	std
	jmp short loc_08277

; ESC N - Delete Character (s. 52 / App. F): Slet tegn ved cursor, træk resten til venstre
crt_esc_N_del_char:
	test byte [bx + CCB_FLAGS], CCB_FLG_WINDOW
	jne loc_08297
	mov si, [bx + CCB_LINE_TABLE]
	mov_di_si                                    ; 08273
	inc si
	inc si

loc_08277:                                     ; 08277
	mov cx, [bx + CCB_MAX_COL]
	mov dx, [bx + CCB_ROW]
	sub_cx_dx                                    ; 0827D
	push es
	mov es, [cs:xios_sysdat_segment_ptr]
	rep es movsw                                 ; 08285
	mov al, 0x20
	mov ah, [bx + CCB_ATTR]
	stosw
	pop es
	cld
	jmp near window_repaint_contents

; ESC P - Select Alternative Character Set (s. 51 / App. F): Vælg alternativt tegnsæt
crt_esc_P_alt_cset:
	or byte [bx + CCB_ATTR], CCB_ATTR_ALT_CHARSET

loc_08297:                                     ; 08297
	ret

; ESC Q - Select Standard Character Set (s. 52 / App. F): Vælg standard tegnsæt
crt_esc_Q_std_cset:
	and byte [bx + CCB_ATTR], ~CCB_ATTR_ALT_CHARSET & 0xff
	ret

; ESC a - Ignored (s. 53 / App. F): Ingen funktion (ignoreres)
crt_esc_a_ignored:
	mov word [bx + CCB_ESC_HANDLER], crt_esc_sub_19f7
	ret

; ESC b - Set Foreground Colour (s. 53 / App. F): Opsæt handler til modtagelse af forgrundsfarve
crt_esc_b_fg_color:
	mov word [bx + CCB_ESC_HANDLER], crt_esc_sub_1943
	ret

; ESC c - Set Background Colour (s. 54 / App. F): Opsæt handler til modtagelse af baggrundsfarve
crt_esc_c_bg_color:
	mov word [bx + CCB_ESC_HANDLER], crt_esc_sub_194c
	ret

; ESC d - Erase Beginning of Screen (s. 54 / App. F): Slet fra skærmstart til cursor
crt_esc_d_erase_bos:
	xor_si_si                                    ; 082AF
	mov dx, [bx + CCB_COL]
	or_dx_dx                                     ; 082B4
	je crt_esc_o_erase_bol
	call crt_clear_line_loop

; ESC o - Erase Beginning of Line (s. 56 / App. F): Slet fra linjestart til cursor
crt_esc_o_erase_bol:
	xor_dx_dx                                    ; 082BB
	mov cx, [bx + CCB_ROW]
	jmp near loc_0862E

; ESC e / ESC m - Enable Cursor (s. 54, 55 / App. F): Gør tekstcursoren synlig
crt_esc_e_cur_on:
	test word [bx + CCB_FLAGS], CCB_FLG_CUR_OFF
	je loc_082EE
	and word [bx + CCB_FLAGS], ~CCB_FLG_CUR_OFF & 0xffff
	jmp near crt_update_cursor_dispatch

; ESC f / ESC n - Disable Cursor (s. 54, 56 / App. F): Skjul tekstcursoren
crt_esc_f_cur_off:
	test word [bx + CCB_FLAGS], CCB_FLG_CUR_OFF
	jne loc_082EE
	call crt_hide_cursor_graphics
	or word [bx + CCB_FLAGS], CCB_FLG_CUR_OFF
	test byte [bx + CCB_FLAGS], CCB_FLG_INACTIVE
	jne loc_082EE
	mov word [cs:fdc_drive_cyl_0], 0xffff

loc_082EE:                                     ; 082EE
	ret

; ESC j - Save Cursor Position (s. 55 / App. F): Gem aktuel cursorposition i CCB
crt_esc_j_save_cursor:
	mov al, [bx + CCB_ROW]
	mov ah, [bx + CCB_COL]
	mov [bx + CCB_SAVED_COL], ax
	ret

; ESC k - Restore Cursor Position (s. 55 / App. F): Gendan gemt cursorposition fra CCB
crt_esc_k_restore_cursor:
	xor_ax_ax                                    ; 082F9
	xchg [bx + CCB_SAVED_COL], ax
	mov [bx + CCB_ROW], al
	mov [bx + CCB_COL], ah
	jmp near crt_update_cursor

; ESC l - Erase Line (s. 55 / App. F): Slet hele den aktuelle linje
crt_esc_l_erase_line:
	mov si, [bx + CCB_COL]
	jmp near crt_clear_line_range

; ESC g - Enter Underline Mode (s. 55 / App. F): Aktiver understregning
crt_esc_g_underline_on:
	or byte [bx + CCB_ATTR], CCB_ATTR_UNDERLINE
	ret

; ESC h - Exit Underline Mode (s. 55 / App. F): Deaktiver understregning
crt_esc_h_underline_off:
	and byte [bx + CCB_ATTR], ~CCB_ATTR_UNDERLINE & 0xff
	ret

; ESC p - Enter Reverse Video Mode (s. 56 / App. F): Aktiver invers video
crt_esc_p_reverse_on:
	or word [bx + CCB_FLAGS], CCB_FLG_REVERSE
	jmp short loc_08323

; ESC q - Exit Reverse Video Mode (s. 56 / App. F): Deaktiver invers video
crt_esc_q_reverse_off:
	and word [bx + CCB_FLAGS], ~CCB_FLG_REVERSE & 0xffff

loc_08323:                                     ; 08323
	mov al, [bx + CCB_CHAR_ATTR]
	jmp near crt_set_char_attr

; ESC s - Enter Blink Mode (s. 57 / App. F): Aktiver blinkende tekst
crt_esc_s_blink_on:
	or byte [bx + CCB_ATTR], CCB_ATTR_BLINK
	ret

; ESC t - Exit Blink Mode (s. 57 / App. F): Deaktiver blinkende tekst
crt_esc_t_blink_off:
	and byte [bx + CCB_ATTR], ~CCB_ATTR_BLINK & 0xff
	ret

; ESC i - Enter Non-Displayed Mode (s. 55 / App. F): Skjul output (usynlig skrift)
crt_esc_i_nondisp_on:
	or word [bx + CCB_FLAGS], CCB_FLG_NONDISP
	ret

; ESC x - Exit Non-Displayed Mode (s. 57 / App. F): Deaktiver usynlig skrift
crt_esc_x_nondisp_off:
	and word [bx + CCB_FLAGS], ~CCB_FLG_NONDISP & 0xffff
	ret

; ESC z - Reset Attributes (s. 57 / App. F): Nulstil alle visningsattributter til standard
crt_esc_z_reset_attrs:
	and word [bx + CCB_FLAGS], ~(CCB_FLG_NOWRAP | CCB_FLG_CUR_OFF | CCB_FLG_REVERSE | CCB_FLG_CHARCONV | CCB_FLG_NONDISP) & 0xffff
	and byte [bx + CCB_ATTR], ~(CCB_ATTR_UNDERLINE | CCB_ATTR_ALT_CHARSET | CCB_ATTR_BLINK) & 0xff
	mov byte [bx + 0x75], 0xf8
	mov al, [bx + 0x7f]
	ror al, 4
	call crt_set_char_attr
	jmp near crt_update_cursor_dispatch

; ESC r - Enter Intensify Mode (s. 56 / App. F): Aktiver fremhævet / høj intensitet
crt_esc_r_intensify_on:
	mov al, [bx + CCB_CHAR_ATTR]
	or al, 0x80
	jmp short crt_set_char_attr

; ESC u - Exit Intensify Mode (s. 57 / App. F): Deaktiver fremhævet / høj intensitet
crt_esc_u_intensify_off:
	mov al, [bx + CCB_CHAR_ATTR]
	and al, 0x7f
	jmp short crt_set_char_attr

crt_set_color_attr:                                     ; 08369
	mov al, [bx + CCB_CHAR_ATTR]
	and al, 0xf
	or_al_cl                                     ; 0836F

crt_set_char_attr:                                     ; 08371
	mov [bx + CCB_CHAR_ATTR], al
	or byte [bx + CCB_FLAGS], CCB_FLG_ATTR_DIRTY
	ret

crt_get_char_attr:                                     ; 0837A
	and byte [bx + CCB_FLAGS], ~CCB_FLG_ATTR_DIRTY & 0xff
	mov al, [bx + CCB_CHAR_ATTR]
	test word [bx + CCB_FLAGS], CCB_FLG_REVERSE
	je loc_0838C
	ror al, 4

loc_0838C:                                     ; 0838C
	push cx
	push di
	lea di, [bx + CCB_PALETTE]
	mov cx, [bx + 0x81]
	mov_dx_cx                                    ; 08396
	repne scasb
	pushf
	inc cx
	sub_dx_cx                                    ; 0839C
	popf
	je loc_083DE
	cmp word [bx + 0x81], 0x10
	jne loc_083BF
	mov al, [bx + CCB_ATTR]
	cbw                                          ; 083AB
	shr ax, 3
	xchg si, ax
	mov al, [bx + si + CCB_PALETTE]
	mov [bx + CCB_CHAR_ATTR], al
	and word [bx + CCB_FLAGS], ~CCB_FLG_REVERSE & 0xffff
	jmp short loc_083EB

loc_083BF:                                     ; 083BF
	inc dx
	mov [di], al
	inc word [bx + 0x81]
	test byte [bx + CCB_FLAGS], CCB_FLG_INACTIVE
	jne loc_083DE
	call palette_translate_mono_color
	mov_cx_dx                                    ; 083CF
	shl dx, 2
	add dx, 0x180
	out dx, al
	inc dx
	inc dx
	out dx, al
	mov_dx_cx                                    ; 083DC

loc_083DE:                                     ; 083DE
	shl dl, 3
	mov al, [bx + CCB_ATTR]
	and al, 7
	or_al_dl                                     ; 083E6
	mov [bx + CCB_ATTR], al

loc_083EB:                                     ; 083EB
	pop di
	pop cx
	ret

; ESC v - Wrap at End of Line (s. 57 / App. F): Aktiver automatisk linjeskift ved kant
crt_esc_v_wrap_on:
	and word [bx + CCB_FLAGS], ~CCB_FLG_NOWRAP & 0xffff
	ret

; ESC w - Discard at End of Line (s. 57 / App. F): Kassér tegn ud over højre margin
crt_esc_w_wrap_off:
	or word [bx + CCB_FLAGS], CCB_FLG_NOWRAP
	ret

; ESC < - Scroll Window Up (s. 61 / App. F): Rul angivet vinduesudsnit op
crt_esc_lt_scroll_up:
	mov word [bx + CCB_ESC_PARAM_FN], crt_esc_sub_1b2a
	jmp short loc_08406

; ESC > - Scroll Window Down (s. 61 / App. F): Rul angivet vinduesudsnit ned
crt_esc_gt_scroll_dn:
	mov word [bx + CCB_ESC_PARAM_FN], crt_esc_sub_1b53

loc_08406:                                     ; 08406
	mov word [bx + CCB_ESC_HANDLER], crt_esc_sub_195d
	ret

; ESC 0 - Status Line Off / 25 Line Mode (s. 58 / App. F): 25-linjers skærmtilstand
crt_esc_0_25_lines:
	mov si, 0x18
	call crt_clear_line_range
	call ccb_acquire_lock
	call rtm_delay_1_tick
	mov ax, 0x19
	call crt_update_scroll_bottom
	mov byte [bx + CCB_ACTIVE], 0
	ret

; ESC 1 - Status Line On / 24 Line Mode (s. 58 / App. F): 24-linjers skærmtilstand
crt_esc_1_24_lines:
	call ccb_acquire_lock
	call rtm_delay_1_tick
	cmp word [bx + CCB_COL], 0x18
	jne loc_08439
	dec word [bx + CCB_COL]
	mov byte [bx + CCB_ACTIVE], 0
	call crt_update_cursor

loc_08439:                                     ; 08439
	mov ax, 0x18
	call crt_update_scroll_bottom
	mov byte [bx + CCB_ACTIVE], 0
	ret

crt_update_scroll_bottom:                                     ; 08444
	mov [bx + CCB_SCROLL_BOTTOM], ax
	test byte [bx + CCB_FLAGS], CCB_FLG_INACTIVE | CCB_FLG_WINDOW | CCB_FLG_CLIPPED
	jne .ret
	call crt_refresh_all_lines
	xor byte [cs:fdc_drive_flags_0], 0x80
	call rtm_delay_1_tick
.ret:                                     ; 08459
	ret

; ESC 2 - Save Current Attributes (s. 58 / App. F): Gem aktuelle attributter i CCB
crt_esc_2_save_attrs:
	mov ax, [bx + CCB_FLAGS]
	mov al, [bx + CCB_ATTR]
	mov [bx + CCB_SAVED_FLAGS], ax
	mov al, [bx + CCB_CHAR_ATTR]
	mov [bx + CCB_SAVED_ATTR], al
	ret

; ESC 3 - Restore Attributes (s. 58 / App. F): Gendan gemte attributter fra CCB
crt_esc_3_restore_attrs:
	mov ax, [bx + CCB_SAVED_FLAGS]
	mov [bx + CCB_ATTR], al
	mov al, [bx + CCB_FLAGS]
	mov [bx + CCB_FLAGS], ax
	mov al, [bx + CCB_SAVED_ATTR]
	call crt_set_char_attr
	test byte [bx + CCB_FLAGS], CCB_FLG_INACTIVE
	je loc_08484
	ret

loc_08484:                                     ; 08484
	mov word [cs:fdc_drive_cyl_0], 0xffff
	jmp near crt_update_cursor_dispatch

; ESC 241 (0xF1) - Set Blinking Cursor (s. 62 / App. F): Sæt cursoren til at blinke
crt_esc_241_cur_blink:
	mov al, 1
	jmp near vmenu_action_item_1

; ESC 242 (0xF2) - Set Non-Blinking Cursor (s. 62 / App. F): Sæt cursoren til fast lys
crt_esc_242_cur_steady:
	xor_al_al                                    ; 08493
	jmp near vmenu_action_item_1

; ESC 243 (0xF3) - Set Cursor Representation (s. 62 / App. F): Sæt cursorens scanlinjer
crt_esc_243_cur_shape:
	mov word [bx + CCB_ESC_HANDLER], crt_esc_sub_1991
	ret

; ESC 244 (0xF4) - Set Soft Scroll (s. 63 / App. F): Aktiver blød rulning
crt_esc_244_soft_scroll:
	mov byte [bx + CCB_SCROLL_MODE], 1
	ret

; ESC 245 (0xF5) - Set Line Scroll (s. 63 / App. F): Aktiver linje-rulning
crt_esc_245_line_scroll:
	mov byte [bx + CCB_SCROLL_MODE], 0
	ret

; ESC 246 (0xF6) - Disable Underline Attribute (s. 63 / App. F): Slå understregning fra
crt_esc_246_underl_off:
	mov byte [bx + 0x75], 0xff
	jmp near crt_load_cursor_hardware_regs

; ESC 247 (0xF7) - Enable Underline Attribute (s. 63 / App. F): Slå understregning til
crt_esc_247_underl_on:
	mov byte [bx + 0x75], 0xf8
	jmp near crt_load_cursor_hardware_regs

; ESC 6 / ESC 0xFB (251) - Function Key Expansion Off / Cursor Left (s. 58 / App. F)
crt_esc_6_fkey_exp_off:
	or word [bx + CCB_FLAGS], CCB_FLG_CHARCONV
	ret

; ESC 7 / ESC 0xFC (252) - Function Key Expansion On / Cursor Right (s. 58 / App. F)
crt_esc_7_fkey_exp_on:
	and word [bx + CCB_FLAGS], ~CCB_FLG_CHARCONV & 0xffff
	ret

; ESC 253 (0xFD) - Save Function Keys (s. 63 / App. F): Gem funktionstaster i buffer (456 bytes)
crt_esc_253_save_fkeys:
	mov si, [bx + CCB_FKEY_TABLE]
	mov di, xios_screen_state_buf
	jmp short loc_084D0

; ESC 254 (0xFE) - Restore Function Keys (s. 64 / App. F): Gendan funktionstaster fra buffer (456 bytes)
crt_esc_254_rest_fkeys:
	mov di, [bx + CCB_FKEY_TABLE]
	mov si, xios_screen_state_buf

loc_084D0:                                     ; 084D0
	mov cx, 0x1c8
	rep movsb
	ret

; ESC Y - Position Cursor (s. 52 / App. F): Opsæt 2-trins modtagelse af række og kolonne
crt_esc_Y_pos_cursor:
	mov word [bx + CCB_ESC_HANDLER], crt_esc_sub_199d
	ret

; ESC : - Program Function Keys (s. 58 / App. F): Programmer funktionstast-streng
crt_esc_colon_prog_fkeys:
	mov word [bx + CCB_ESC_HANDLER], crt_esc_sub_19c3
	ret

; Standard-retur / ukendt escape-sekvens (App. F): Afslut uden handling (ret)
crt_esc_default_ret:
	ret

; Underhandler for ESC > (Scroll Window Down): Modtager start- og slutrække
crt_esc_sub_1943:
	shl cl, 4
	call crt_set_color_attr
	jmp near crt_esc_sub_19f7

; Underhandler for ESC < (Scroll Window Up): Modtager start- og slutrække
crt_esc_sub_194c:
	and cl, 0xf
	mov al, [bx + CCB_CHAR_ATTR]
	and al, 0xf0
	or_al_cl                                     ; 084F5
	call crt_set_char_attr
	jmp near crt_esc_sub_19f7

; Underhandler for ESC b / ESC c: Modtager farveværdi og gemmer i CCB
crt_esc_sub_195d:
	mov word [bx + CCB_ESC_HANDLER], crt_esc_sub_196b
	sub cl, 0x20
	xor_ch_ch                                    ; 08505
	mov [bx + CCB_ESC_PARAM_BUF], cx
	ret

; Underhandler for ESC 243 (Set Cursor Representation): Modtager rasterlinjer
crt_esc_sub_196b:
	sub cl, 0x20
	cmp cl, [bx + CCB_SCROLL_BOTTOM]
	jae loc_0854D
	xor_ch_ch                                    ; 08513
	mov_di_cx                                    ; 08515

rtm_al80_poll_console:                         ; 08517
	mov si, [bx + CCB_ESC_PARAM_BUF]
	cmp_di_si                                    ; 0851A
	jb loc_0854D

rtm_al87_blocking_read:                        ; 0851E
	push si
	push di
	call crt_hide_cursor_graphics
	pop di
	pop si
	call word [bx + CCB_ESC_PARAM_FN]
	call crt_draw_cursor_graphics
	call crt_update_cursor
	jmp near crt_esc_sub_19f7

; Underhandler for ESC : (Program Function Keys) trin 1: Modtager tast-id
crt_esc_sub_1991:
	ror cx, 4
	ror ch, 4
	call vmenu_set_cursor_lines
	jmp near crt_esc_sub_19f7

; Underhandler for ESC Y (Position Cursor) trin 1: Modtager række (row + 32)
crt_esc_sub_199d:
	mov word [bx + CCB_ESC_HANDLER], crt_esc_sub_19ae
	sub cl, 0x20
	cmp cl, [bx + CCB_SCROLL_BOTTOM]
	jae loc_0854D
	mov [bx + CCB_COL], cl

loc_0854D:                                     ; 0854D
	ret

; Underhandler for ESC Y (Position Cursor) trin 2: Modtager kolonne (col + 32) og flytter cursor
crt_esc_sub_19ae:
	mov word [bx + CCB_ESC_HANDLER], crt_char_handler
	sub cl, 0x20
	cmp cl, [bx + CCB_MAX_COL]
	ja crt_esc_sub_19f7
	mov [bx + CCB_ROW], cl
	call crt_update_cursor
	jmp short crt_esc_sub_19f7

; Underhandler for ESC : (Program Function Keys) trin 2: Indlæser definition indtil NULL
crt_esc_sub_19c3:
	xchg al, cl                                  ; 08563  86 C1
	mov di, key_scan_code_table                  ; CS:10B5 (start af funktionstast-tabel, 66 bytes)
	mov_dx_di                                    ; 08568
	mov cx, 0x42
	repne scasb
	jne crt_esc_sub_19f7
	dec di
	sub_di_dx                                    ; 08572
	xchg di, ax
	call fkey_get_str_ptr
	mov [bx + CCB_ESC_PARAM_FN], si
	mov [bx + CCB_ESC_PARAM_BUF], cl
	mov word [bx + CCB_ESC_HANDLER], crt_esc_sub_19e4
	ret

; Underhandler for funktionstast-definition: Gemmer tegn i funktionstast-buffer
crt_esc_sub_19e4:
	mov si, [bx + CCB_ESC_PARAM_FN]
	mov [si], cl
	inc si
	mov [bx + CCB_ESC_PARAM_FN], si
	or_cl_cl                                     ; 0858D
	je crt_esc_sub_19f7
	dec byte [bx + CCB_ESC_PARAM_BUF]
	je crt_esc_sub_19f7
	ret

; Afslut flertrins escape-sekvens og gendan normal tegn-handler (crt_char_handler)
crt_esc_sub_19f7:
	mov word [bx + CCB_ESC_HANDLER], crt_char_handler
	ret

crt_cursor_down:                                     ; 0859D
	mov si, [bx + CCB_COL]
	inc si
	cmp si, [bx + CCB_SCROLL_BOTTOM]
	jne loc_085AD
	mov si, 0
	call crt_scroll_lines_up
	ret

loc_085AD:                                     ; 085AD
	mov [bx + CCB_COL], si
	cmp byte [bx + CCB_TRACKING_MODE], 0
	je .ret
	call window_repaint_contents
.ret:                                     ; 085B9
	ret

loc_085BA:                                     ; 085BA
	mov dx, [bx + CCB_COL]
	inc dx
	cmp dx, [bx + CCB_SCROLL_BOTTOM]
	je .ret
	mov [bx + CCB_COL], dx
	jmp short crt_update_cursor
.ret:                                     ; 085C8
	ret

crt_cursor_home:                                     ; 085C9
	mov word [bx + CCB_COL], 0

crt_cursor_home_row:                                     ; 085CE
	mov word [bx + CCB_ROW], 0

crt_update_cursor:                                      ; 085D3
	mov di, [bx + CCB_ROW]
	mov si, [bx + CCB_COL]
	shl si, 1
	mov dx, [bx + si]
	shl di, 1
	add_dx_di                                    ; 085DF
	mov [bx + CCB_LINE_TABLE], dx
	test byte [bx + CCB_FLAGS], CCB_FLG_WINDOW
	je crt_update_hw_cursor
	jmp near loc_08A92

crt_update_hw_cursor:                                     ; 085ED
	test word [bx + CCB_FLAGS], CCB_FLG_SCROLL_LOCK | CCB_FLG_INACTIVE | CCB_FLG_CUR_OFF
	jne .ret
	mov dh, [bx + CCB_COL]
	mov dl, [bx + CCB_ROW]
	test byte [bx + CCB_FLAGS], CCB_FLG_CLIPPED
	je .store
	sub dh, [bx + CCB_MASK]
	jb .invalid
	sub dl, [bx + 0x4a]
	jb .invalid
	cmp dh, [bx + CCB_ROWS]
	jae .invalid
	cmp dl, [bx + CCB_COLS]
	jae .invalid
	add dx, [bx + CCB_WIN_LEFT]

.store:
	mov [cs:fdc_drive_cyl_0], dx
.ret:
	ret

.invalid:
	mov word [cs:fdc_drive_cyl_0], 0xffff
	ret

crt_update_cursor_dispatch:                                     ; 08625
	test byte [bx + CCB_FLAGS], CCB_FLG_WINDOW
	je crt_update_hw_cursor
	jmp near crt_draw_cursor_graphics

loc_0862E:                                     ; 0862E
	mov si, [bx + CCB_COL]
	shl si, 1
	mov di, [bx + si]
	shr si, 1
	add_di_dx                                    ; 08637
	add_di_dx                                    ; 08639
	sub_cx_dx                                    ; 0863B
	inc cx
	test byte [bx + CCB_FLAGS], CCB_FLG_WINDOW
	jne loc_08649
	call crt_fill_line_spaces
	jmp short loc_0866B

loc_08649:                                     ; 08649
	mov_ax_si                                    ; 08649

loc_0864B:                                     ; 0864B
	push ax
	push dx
	push cx
	mov cl, 0x20
	call crt_render_char_bitmap
	pop cx
	pop dx
	pop ax
	inc dx
	loop loc_0864B
	jmp near crt_draw_cursor_graphics

crt_clear_line_range:                                     ; 0865C
	mov_dx_si                                    ; 0865C
	inc dx

crt_clear_line_loop:                                     ; 0865F
	push si
	push dx
	call crt_clear_single_line
	pop dx
	pop si
	inc si
	cmp_dx_si                                    ; 08667
	jne crt_clear_line_loop

loc_0866B:                                     ; 0866B
	test byte [cs:xios4_window_clip_flag], 0xff
	jne .ret
	call window_repaint_contents
.ret:                                     ; 08676
	ret

crt_clear_single_line:                                     ; 08677
	test byte [bx + CCB_FLAGS], CCB_FLG_WINDOW
	jne loc_0869E
	shl si, 1
	mov di, [bx + si]
	shr si, 1
	mov cx, 0x50

crt_fill_line_spaces:                                     ; 08686
	test byte [bx + CCB_FLAGS], CCB_FLG_ATTR_DIRTY
	je loc_0868F
	call crt_get_char_attr

loc_0868F:                                     ; 0868F
	push es
	mov ah, [bx + CCB_ATTR]
	mov al, 0x20
	mov es, [cs:xios_sysdat_segment_ptr]
	rep stosw
	pop es
	ret

loc_0869E:                                     ; 0869E
	push ds
	mov_ax_si                                    ; 0869F
	mov ah, 0xa
	mul ah                                        ; 086A3
	mov_di_ax                                    ; 086A5
	shl di, 1
	call vram_setup_page_segments
	push ds
	pop es
	xor_ax_ax                                    ; 086AE
	mov cx, 0x23

loc_086B3:                                     ; 086B3
	push cx
	mov cx, 0xa
	rep stosw
	add di, 0x1ec
	pop cx
	loop loc_086B3
	pop ds
	mov byte [bx + CCB_ACTIVE], 0
	ret

crt_scroll_lines_up:                                     ; 086C6
	mov di, [bx + CCB_SCROLL_BOTTOM]
	dec di
; Hjælperutine for vinduesrulning (ESC < og ESC >)
crt_esc_sub_1b2a:
	test byte [bx + CCB_FLAGS], CCB_FLG_WINDOW
	je loc_086D3
	jmp near loc_08AEE

loc_086D3:                                     ; 086D3
	push si
	push di
	mov_cx_di                                    ; 086D5
	sub_cx_si                                    ; 086D7
	shl si, 1
	add_si_bx                                    ; 086DB
	mov_di_si                                    ; 086DD
	lodsw
	rep movsw
	xchg [bx + 0x32], ax
	stosw
	pop dx
	pop cx
	mov_si_dx                                    ; 086E8
	mov di, 0
	jmp short loc_08716

crt_scroll_lines_down:                                     ; 086EF
	mov di, [bx + CCB_SCROLL_BOTTOM]
	dec di
; Hjælperutine for farveberegning (ESC b forgrund / ESC c baggrund)
crt_esc_sub_1b53:
	test byte [bx + CCB_FLAGS], CCB_FLG_WINDOW
	je loc_086FA
	ret

loc_086FA:                                     ; 086FA
	push si
	push di
	mov_cx_di                                    ; 086FC
	sub_cx_si                                    ; 086FE
	shl di, 1
	add_di_bx                                    ; 08702
	mov_si_di                                    ; 08704
	std
	lodsw
	rep movsw
	xchg [bx + 0x32], ax
	stosw
	cld
	pop dx
	pop cx
	mov_si_cx                                    ; 08711
	mov di, 6

loc_08716:                                     ; 08716
	push ax
	call ccb_acquire_lock
	pop ax
	test byte [bx + CCB_FLAGS], CCB_FLG_INACTIVE | CCB_FLG_CLIPPED
	jne loc_0873E
	cmp byte [bx + CCB_SCROLL_MODE], 0
	je loc_08743
	cmp_cx_dx                                    ; 08727
	jne loc_08754
	call crt_clear_line_range
	call crt_refresh_all_lines
	xor byte [cs:fdc_drive_flags_0], 0x80
	mov ah, 0
	call xios_crt_trigger_ca
	jmp short loc_0874F

loc_0873E:                                     ; 0873E
	call crt_clear_line_range
	jmp short loc_0874F

loc_08743:                                     ; 08743
	call crt_clear_line_range
	call crt_refresh_all_lines
	xor byte [cs:fdc_drive_flags_0], 0x80

loc_0874F:                                     ; 0874F
	mov byte [bx + CCB_ACTIVE], 0
	ret

loc_08754:                                     ; 08754
	push di
	or byte [bx + CCB_FLAGS], CCB_FLG_SCROLL_LOCK
	call scroll_save_registers
	mov byte [cs:xios_scroll_dir_up_flag], 0xff
	call rtm_wait_scroll_delay
	mov byte [cs:xios_scroll_dir_up_flag], 0
	pop ax
	mov [cs:xios_scroll_step_counter], al
	mov [cs:xios_scroll_ccb_ptr], bx
	push bx
	mov dx, 4
	call rtm_call_helper
	mov cl, 0x8e
	call rtm_timer_wait2
	mov dx, 9
	call rtm_timer_wait
	pop bx
	ret

crt_scroll_sub_1be9:
	call scroll_restore_registers
	inc word [cs:xios_scroll_row_end]
	push ax
	call crt_clear_line_range
	mov_si_bx                                    ; 08795
	mov di, xios_scroll_line_save_buf
	mov cx, [bx + CCB_SCROLL_BOTTOM]
	rep movsw
	call scroll_shift_line_pointers
	pop ax
	mov di, [cs:xios_scroll_row_end]
	add di, 3
	mov cl, 1
	jmp near loc_087CD

crt_scroll_sub_1c10:
	call scroll_restore_registers
	push ax
	call crt_clear_line_range
	mov_si_bx                                    ; 087B7
	mov di, xios_scroll_line_save_buf
	mov cx, [bx + CCB_SCROLL_BOTTOM]
	rep movsw
	call scroll_shift_line_pointers
	pop ax
	mov di, [cs:xios_scroll_row_start]
	inc di
	mov cl, 7

loc_087CD:                                     ; 087CD
	mov [cs:bx + 0x80], cl
	inc cl
	mov [cs:bx + 0x7c], cl
	shl di, 1
	shl di, 1
	add_di_bx                                    ; 087DC
	mov dx, [cs:xios_sysdat_segment_ptr]
	call crt_dma_store_phys_desc
	mov word [cs:fdc_drive_cyl_0], 0xffff
	xor byte [cs:fdc_drive_flags_0], 0x80
	ret

rtm_wait_scroll_delay:                                     ; 087F4
	push bx
	mov dx, 0xa
	call rtm_timer_wait
	pop bx
	ret

scroll_save_registers:                                     ; 087FD
	mov di, xios_scroll_temp_offset
	stosw
	mov_ax_bx                                    ; 08801
	stosw
	mov_ax_cx                                    ; 08804
	stosw
	mov_ax_dx                                    ; 08807
	stosw
	mov_ax_si                                    ; 0880A
	stosw
	ret

scroll_restore_registers:                                     ; 0880E
	mov si, xios_scroll_param_block
	lodsw
	mov_bx_ax                                    ; 08812
	lodsw
	mov [cs:xios_scroll_row_start], ax
	lodsw
	mov [cs:xios_scroll_row_end], ax
	mov si, [si]
	mov ax, [cs:xios_scroll_temp_offset]
	ret

scroll_shift_line_pointers:                                     ; 08825
	mov cx, [bx + CCB_SCROLL_BOTTOM]
	mov dx, [cs:xios_scroll_row_end]
	sub_cx_dx                                    ; 0882D
	shl cx, 1
	push cx
	mov cx, [cs:xios_scroll_row_start]
	sub_dx_cx                                    ; 08837
	shl dx, 1
	push dx
	shl cx, 1
	call crt_swap_active_line_buffers
	rep movsw
	lea ax, [bx + 0x7c]
	call crt_dma_make_phys_desc
	mov ax, fdc_param_6140
	call crt_dma_make_phys_desc
	pop cx
	rep movsw
	lea ax, [bx + CCB_CHAR_ATTR]
	call crt_dma_make_phys_desc
	mov ax, fdc_param_6140
	call crt_dma_make_phys_desc
	pop cx
	rep movsw
	push bx
	mov bx, [cs:xios_scroll_ccb_ptr]
	mov cx, [bx + CCB_SCROLL_BOTTOM]
	pop bx
	jmp near loc_08960

crt_scroll_sub_1ccf:
	mov al, 5
	jmp short loc_08875

crt_scroll_sub_1cd3:
	mov al, 3

loc_08875:                                     ; 08875
	call crt_swap_active_line_buffers
	mov cx, 0x3e
	rep movsw
	mov [cs:bx + 0x80], al
	inc al
	mov [cs:bx + 0x7c], al
	mov di, [cs:xios_scroll_row_start]
	shl di, 1
	shl di, 1
	add_di_bx                                    ; 08891
	lea ax, [bx + 0x7c]
	call crt_dma_make_phys_desc
	mov di, [cs:xios_scroll_row_end]
	inc di
	inc di
	shl di, 1
	shl di, 1
	add_di_bx                                    ; 088A4
	lea ax, [bx + CCB_CHAR_ATTR]
	call crt_dma_make_phys_desc
	xor byte [cs:fdc_drive_flags_0], 0x80
	ret

crt_scroll_sub_1d14:
	call crt_swap_active_line_buffers
	add byte [cs:bx + 0x7c], 4
	add byte [cs:bx + 0x80], 4
	xor byte [cs:fdc_drive_flags_0], 0x80
	ret

crt_scroll_sub_1d29:
	call crt_swap_active_line_buffers
	sub byte [cs:bx + 0x7c], 4
	sub byte [cs:bx + 0x80], 4
	xor byte [cs:fdc_drive_flags_0], 0x80
	ret

crt_scroll_sub_1d3e:
	mov bx, [cs:xios_scroll_ccb_ptr]
	mov cx, [bx + CCB_SCROLL_BOTTOM]
	push bx
	mov bx, xios_scroll_line_save_buf
	call crt_refresh_lines_loop
	xor byte [cs:fdc_drive_flags_0], 0x80
	pop bx
	mov byte [bx + CCB_ACTIVE], 0
	ret

crt_scroll_sub_1d59:
	mov bx, [cs:xios_scroll_ccb_ptr]
	mov al, [cs:xios_scroll_dir_up_flag]
	or_al_al                                     ; 08902
	jne .ret
	and byte [bx + CCB_FLAGS], ~CCB_FLG_SCROLL_LOCK & 0xff
	call crt_update_hw_cursor
	xor_al_al                                    ; 0890D
.ret:                                     ; 0890F
	ret

int28_fn_02_scroll_step:                ; 08910
	push ds
	pop es
	mov bl, [cs:xios_scroll_step_counter]
	xor_bh_bh                                    ; 08917
	shl bx, 1
	call word [cs:bx + crt_state_jump_table]
	inc byte [cs:xios_scroll_step_counter]
	ret

crt_state_jump_table:
	; --- State jump table (12 word pointers) ---
	dw crt_scroll_sub_1be9, crt_scroll_sub_1cd3, crt_scroll_sub_1d14, crt_scroll_sub_1d14, crt_scroll_sub_1d3e, crt_scroll_sub_1d59
	dw crt_scroll_sub_1c10, crt_scroll_sub_1ccf, crt_scroll_sub_1d29, crt_scroll_sub_1d29, crt_scroll_sub_1d3e, crt_scroll_sub_1d59
crt_refresh_all_lines:                                     ; 0893E
	mov cx, [bx + CCB_SCROLL_BOTTOM]

crt_refresh_lines_loop:                                     ; 08941
	push cx
	mov_si_bx                                    ; 08942
	mov di, fdc_drive_1_dpb_ptr
	test byte [cs:fdc_drive_flags_0], 0x80
	jne loc_08952
	mov di, fdc_drive_2_dpb_ptr

loc_08952:                                     ; 08952
	push cx
	lodsw
	mov dx, [cs:xios_sysdat_segment_ptr]
	call crt_dma_store_phys_desc
	pop cx
	loop loc_08952
	pop cx

loc_08960:                                     ; 08960
	cmp cx, 0x18
	ja loc_0896B
	mov ax, xios_con_line_buffer_614a
	call crt_dma_make_phys_desc

loc_0896B:                                     ; 0896B
	mov ax, xios_crt_mode_line_table
	call crt_dma_make_phys_desc
	ret

crt_swap_active_line_buffers:                                     ; 08972
	mov si, fdc_drive_1_dpb_ptr
	mov di, fdc_drive_2_dpb_ptr
	test byte [cs:fdc_drive_flags_0], 0x80
	je loc_08982
	xchg si, di                                  ; 08980  87 F7

loc_08982:                                     ; 08982
	mov_bx_di                                    ; 08982
	ret

crt_render_char_bitmap:                                     ; 08985
	mov bp, [bx + CCB_FLAGS]
	mov [cs:crt_state_flags], bp
	push bx
	push ds
	call vram_setup_page_segments
	xor_ch_ch                                    ; 08992
	mov_bx_cx                                    ; 08994
	mov cl, 5
	shl bx, cl
	call vram_calc_char_offset
	cmp byte [cs:crt_mode_ah], 2
	je loc_089AC
	mov bp, 0x1ff
	ror bp, cl
	jmp short loc_089CB

loc_089AC:                                     ; 089AC
	cmp cl, 3
	jge loc_089BE
	mov bp, 3
	ror bp, cl
	mov byte [cs:crt_screen_attr], 0xff
	jmp short loc_089CB

loc_089BE:                                     ; 089BE
	mov bp, 0x3ff
	mov byte [cs:crt_screen_attr], 0
	ror bp, cl
	shr cl, 1

loc_089CB:                                     ; 089CB
	mov ch, 0xa

loc_089CD:                                     ; 089CD
	mov ax, [es:bx]
	test word [cs:crt_state_flags], 0x400                 ; 089D0  2E F7 06 CE 1F 00 04
	je loc_089DB
	not ax

loc_089DB:                                     ; 089DB
	and ax, 0xfe00
	cmp byte [cs:crt_mode_ah], 2
	jne loc_089F8
	cmp byte [cs:crt_screen_attr], 0
	je loc_089F8
	push cx
	mov cx, 8
	call crt_bitmap_expand_pixels
	mov_ax_dx                                    ; 089F5
	pop cx

loc_089F8:                                     ; 089F8
	ror ax, cl
	cmp byte [cs:crt_mode_ah], 2
	jne loc_08A0A
	cmp byte [cs:crt_screen_attr], 0
	je loc_08A18

loc_08A0A:                                     ; 08A0A
	mov dh, [si]
	mov dl, [di]
	and_dx_bp                                    ; 08A0E
	or_dx_ax                                     ; 08A10
	mov [si], dh
	mov [di], dl
	jmp short loc_08A38

loc_08A18:                                     ; 08A18
	mov_dx_bp                                    ; 08A18
	and [si], dh
	and [si + 0x200], dl
	push cx
	mov cx, 4
	call crt_bitmap_expand_pixels
	push dx
	mov cx, 8
	call crt_bitmap_expand_pixels
	pop ax
	pop cx
	or [si], al
	mov [di], dh
	or [si + 0x200], dl

loc_08A38:                                     ; 08A38
	inc bx
	inc bx
	inc si
	inc si
	inc di
	inc di
	dec ch
	jne loc_089CD
	pop ds
	pop bx
	mov byte [bx + CCB_ACTIVE], 0
	ret

crt_bitmap_expand_pixels:                                     ; 08A49
	xor_dx_dx                                    ; 08A49

loc_08A4B:                                     ; 08A4B
	shl ax, 1
	rcl dx, 1
	rol dx, 1
	loop loc_08A4B
	ret

crt_hide_cursor_graphics:                                      ; 08A54
	test byte [bx + CCB_FLAGS], CCB_FLG_WINDOW
	je loc_08A91
	test word [bx + CCB_FLAGS], CCB_FLG_CUR_OFF
	jne loc_08A91
	push ds
	call vram_setup_page_segments
	mov dx, [cs:crt_cursor_dx]
	mov si, [cs:crt_cursor_si]
	mov di, [cs:crt_cursor_di]
	xor [si], dh
	cmp byte [cs:crt_mode_ah], 2
	je loc_08A82
	xor [di], dl
	jmp short loc_08A8C

loc_08A82:                                     ; 08A82
	xor [di], dl
	mov al, [cs:crt_cursor_al]
	xor [si + 0x200], al

loc_08A8C:                                     ; 08A8C
	pop ds
	mov byte [bx + CCB_ACTIVE], 0

loc_08A91:                                     ; 08A91
	ret

loc_08A92:                                     ; 08A92
	call crt_hide_cursor_graphics

crt_draw_cursor_graphics:                                      ; 08A95
	test word [bx + CCB_FLAGS], CCB_FLG_CUR_OFF
	jne loc_08A91
	mov ax, [bx + CCB_COL]
	mov dx, [bx + CCB_ROW]
	push ds
	call vram_setup_page_segments
	call vram_calc_char_offset
	add si, 0x12
	add di, 0x12
	cmp byte [cs:crt_mode_ah], 2
	je loc_08AC2
	mov dx, 0xfe00
	ror dx, cl
	xor [si], dh
	xor [di], dl
	jmp short loc_08AD9

loc_08AC2:                                     ; 08AC2
	mov dx, 0xfffc
	mov_ah_dl                                    ; 08AC5
	xor_al_al                                    ; 08AC7
	shr dx, cl
	shr ax, cl
	xor [si], dh
	xor [di], dl
	xor [si + 0x200], al
	mov [cs:crt_cursor_al], al

loc_08AD9:                                     ; 08AD9
	mov [cs:crt_cursor_dx], dx
	mov [cs:crt_cursor_si], si
	mov [cs:crt_cursor_di], di
	pop ds
	mov byte [bx + CCB_ACTIVE], 0
	ret

loc_08AEE:                                     ; 08AEE
	push di
	push ds
	mov_ax_di                                    ; 08AF0
	sub_ax_si                                    ; 08AF2
	mov ah, 0xa
	mul ah                                        ; 08AF6
	mov_cx_ax                                    ; 08AF8
	mov_ax_si                                    ; 08AFA
	mov ah, 0xa
	mul ah                                        ; 08AFE
	shl ax, 1
	mov_di_ax                                    ; 08B02
	mov dx, 0x23
	call vram_setup_page_segments
	push ds
	pop es

loc_08B0C:                                     ; 08B0C
	mov_si_di                                    ; 08B0C
	add si, 0x14
	push di
	push cx
	rep movsw
	pop cx
	pop di
	add di, 0x200
	dec dx
	jne loc_08B0C
	pop ds
	pop si
	mov byte [bx + CCB_ACTIVE], 0
	jmp near crt_clear_line_range

vram_calc_char_offset:                                     ; 08B27
	mov ah, 0xa
	mul ah                                        ; 08B29
	mov_si_ax                                    ; 08B2B
	mov ax, 7
	mul dx                                        ; 08B30
	cmp byte [cs:crt_mode_ah], 2
	jne loc_08B3C
	shl ax, 1

loc_08B3C:                                     ; 08B3C
	mov_cx_ax                                    ; 08B3C
	and ax, strict word 0xfff0                   ; 08B3E  25 F0 FF
	mov dx, 0x10
	mul dx                                        ; 08B44
	add_si_ax                                    ; 08B46
	shl si, 1
	mov_di_si                                    ; 08B4A
	test cx, 8
	jne loc_08B55
	inc si
	jmp short loc_08B59

loc_08B55:                                     ; 08B55
	add di, 0x201

loc_08B59:                                     ; 08B59
	and cx, strict word 7                        ; 08B59  81 E1 07 00
	ret

vram_setup_page_segments:                                     ; 08B5E
	push ax
	call ccb_acquire_lock
	pop ax
	mov es, [cs:xios_vram_active_page]
	mov ds, [cs:xios_vram_back_page]
	ret

crt_state_flags:
	dw 0x0000
crt_cursor_dx:
	dw 0x0000
crt_cursor_al:
	db 0x00
crt_cursor_si:
	dw 0x0000
crt_cursor_di:
	dw 0x0000
crt_mode_ah:
	db 0x00
crt_screen_attr:
	db 0x00

crt_dispatch_esc_char:                                     ; 08B79
	xor_cx_cx                                    ; 08B79
	mov cl, [di]
	inc di
	inc cx
	repne scasb
	pop si
	shl cx, 1
	add_si_cx                                    ; 08B84
	jmp word [si]

io_switch:
	cmp dl, [cs:xios4_active_vir_con]
	jne loc_08B90
	ret

loc_08B90:                                     ; 08B90
	mov bx, [cs:xios4_cur_window_ptr]
	call ccb_check_background_active
	je loc_08B9B
	ret

loc_08B9B:                                     ; 08B9B
	cmp byte [cs:crt_timer_flag], 0
	je loc_08BA9
	mov byte [cs:crt_timer_flag], 1

loc_08BA9:                                     ; 08BA9
	call ccb_acquire_all_locks
	test byte [bx + CCB_FLAGS], CCB_FLG_SCROLL_LOCK
	je loc_08BB5
	call rtm_delay_1_tick

loc_08BB5:                                     ; 08BB5
	or byte [bx + CCB_FLAGS], CCB_FLG_INACTIVE
	mov cl, [bx + 0x70]
	call get_ccb_by_index
	mov [cs:xios4_cur_window_ptr], bx
	and byte [bx + CCB_FLAGS], ~CCB_FLG_INACTIVE & 0xff
	cmp cl, [bx + 0x70]
	je crt_switch_active_window
	push es
	les si, [cs:xios_graphics_gcb_offset]

loc_08BD3:                                     ; 08BD3
	mov al, 0xff
	xchg [es:si], al
	or_al_al                                     ; 08BD8
	je loc_08BE1
	call rtm_delay_1_tick
	jmp short loc_08BD3

loc_08BE1:                                     ; 08BE1
	push si
	push es
	mov ah, 3
	call xios_crt_trigger_ca
	call crt_set_display_mode_timings
	pop es
	pop si
	mov dx, [cs:xios_vram_back_page]
	mov [es:si + 1], dx
	mov byte [es:si], 0
	pop es

crt_switch_active_window:                                     ; 08BFB
	push es
	push ds
	pop es
	mov dl, [bx + CCB_CON_IDX]
	call window_zorder_promote_top
	mov word [cs:fdc_drive_cyl_0], 0xffff
	call palette_load_hardware_regs
	call window_update_clipped_flag
	mov cx, [bx + CCB_SCROLL_BOTTOM]
	push bx
	mov byte [cs:xios4_window_clip_flag], 0xff
	test byte [bx + CCB_FLAGS], CCB_FLG_WINDOW
	jne loc_08C36
	test byte [bx + CCB_FLAGS], CCB_FLG_CLIPPED
	je loc_08C36
	mov byte [cs:xios4_window_clip_flag], 0
	call xios_clip_repaint_windows
	mov bx, xios_vmenu_line_offsets
	mov cx, 0x18

loc_08C36:                                     ; 08C36
	call crt_refresh_lines_loop
	pop bx
	xor byte [cs:fdc_drive_flags_0], 0x80
	call crt_load_cursor_hardware_regs
	mov ah, 1
	call xios_crt_trigger_ca
	test byte [bx + CCB_FLAGS], CCB_FLG_WINDOW
	jne loc_08C51
	call crt_update_hw_cursor

loc_08C51:                                     ; 08C51
	call ccb_release_all_locks
	pop es
	ret

ccb_check_background_active:                                     ; 08C56
	mov si, [bx + 0x5c]
	test word [si + 0xe], 8
	ret

io_statline_clear:                                     ; 08C5F
	xor_cx_cx                                    ; 08C5F

io_statline:
	mov bx, vmenu_screen_buffer_b

.acquire_lock:                                     ; 08C64
	mov al, 0xff
	xchg [cs:vmenu_active_flag], al
	cmp al, 0xff
	jne .setup_buffer
	call rtm_delay_1_tick
	jmp short .acquire_lock

.setup_buffer:                                     ; 08C74
	cld
	push es
	push ds
	push bx
	mov ax, cs
	mov es, ax
	mov al, 0xff
	jcxz .check_saved_mode
	mov [cs:vmenu_saved_bx], cx

.check_saved_mode:                                     ; 08C85
	cmp word [cs:vmenu_saved_bx], -1
	je .render_default_line
	jcxz .exit_pop
	mov ds, dx
	mov_si_cx                                    ; 08C91
	jmp near .render_to_line_buffer

.exit_pop:                                     ; 08C96
	pop bx
	jmp near .release_and_exit

.render_default_line:                                     ; 08C9A
	mov di, xios_vmenu_buf_484d
	mov al, 0x20
	mov cx, xios_vmenu_str_printer
	sub_cx_di                                    ; 08CA2
	rep stosb
	mov di, xios_vmenu_buf_4884
	mov cx, xios_vmenu_str_time
	sub_cx_di                                    ; 08CAC
	rep stosb
	mov al, [cs:xios4_active_vir_con]
	add al, 0x30
	mov [cs:xios_vmenu_buf_484d], al
	mov word [cs:xios_vmenu_buf_4884], 0x2030
	mov bx, [cs:xios4_cur_window_ptr]
	mov bx, [bx + 0x5c]
	mov si, [bx]
	test si, si
	je .check_status_bits
	mov al, [si + 0x24]
	call vmenu_format_two_digits
	mov [cs:xios_vmenu_buf_4884], ax
	lea si, [si + PD_NAME]
	mov di, xios_vmenu_buf_4858
	mov cx, 4
	rep movsw

.check_status_bits:                                     ; 08CE4
	mov cx, [bx + 0xe]
	test cx, 0x80
	je .check_other_status
	mov word [cs:xios_vmenu_buf_4873], 0x5392
	jmp short .check_printer_status

.check_other_status:                                     ; 08CF6
	test cx, 0x100
	je .check_printer_status
	mov word [cs:xios_vmenu_buf_4873], 0x4f92

.check_printer_status:                                     ; 08D03
	test cx, 0x200
	je .select_window_opt_str
	mov di, xios_vmenu_buf_4876
	mov word [di], 0x5092
	mov byte [di + 2], '='
	mov al, [bx + 8]
	call vmenu_format_two_digits
	mov [di + 3], ax

.select_window_opt_str:                                     ; 08D1D
	mov si, xios_vmenu_opt_locked
	test cx, 8
	jne .render_disk_drive_letters
	mov si, xios_vmenu_opt_dynamic
	test cx, 1
	je .render_disk_drive_letters
	mov si, xios_vmenu_opt_buffered
	test cx, 4
	je .render_disk_drive_letters
	mov si, xios_vmenu_opt_buffer

.render_disk_drive_letters:                                     ; 08D3B
	mov di, xios_vmenu_buf_484f
	mov cx, 8
	rep movsb
	mov cx, 0x10
	mov ah, 'A'
	mov al, 0x20
	mov dx, [cs:sysdat_nlstdev]
	mov di, xios_vmenu_buf_4862

.drive_letter_loop:                                     ; 08D52
	shr dx, 1
	jae .skip_drive_letter
	xchg ah, al                                  ; 08D56  86 E0
	stosb
	xchg ah, al                                  ; 08D59  86 E0
	jmp short .next_drive_letter

.skip_drive_letter:                                     ; 08D5D
	stosb

.next_drive_letter:                                     ; 08D5E
	inc ah
	loop .drive_letter_loop
	mov si, 0x80
	mov di, xios_vmenu_str_time
	mov cx, 3

.time_digits_loop:                                     ; 08D6B
	lodsb
	call vmenu_format_single_digit
	stosw
	inc di
	loop .time_digits_loop
	mov al, [cs:kbd_lock_state]
	test al, 0x20
	je .check_window_mode_flag
	mov si, xios_vmenu_opt_lock
	mov di, xios_vmenu_buf_4887
	mov cx, 4
	rep movsb

.check_window_mode_flag:                                     ; 08D86
	cmp byte [cs:xios4_vir_con_mode], 0
	je .check_window_titles
	mov byte [cs:xios_vmenu_buf_4861], 7

.check_window_titles:                                     ; 08D94
	test byte [cs:xios4_window_clip_flag], 0xff
	jne .load_console_str
	mov cx, NUM_VIR_CONS
	mov si, xios_ccb_table

.window_title_loop:                                     ; 08DA2
	lodsw
	xchg bx, ax
	push cx
	push si
	push es
	call window_draw_title
	pop es
	pop si
	pop cx
	loop .window_title_loop

.load_console_str:                                     ; 08DAF
	mov si, xios_vmenu_str_console

.render_to_line_buffer:                                     ; 08DB2
	mov di, xios_con_line_buffer_614a
	mov ah, 8
	mov cx, 0x50
	pop bx

.output_char_loop:                                     ; 08DBB
	call bx
	stosw
	loop .output_char_loop
	xor_al_al                                    ; 08DC0

.release_and_exit:                                     ; 08DC2
	mov byte [cs:vmenu_active_flag], 0
	pop ds
	pop es
	ret

vmenu_screen_buffer_b:
	lodsb
	ret

vmenu_screen_buffer_d:
	lodsw
	ret

ww_statline:
	mov bx, vmenu_screen_buffer_d
	jmp near io_statline.acquire_lock

vmenu_format_single_digit:                                     ; 08DD5
	mov ah, '3'
	ror ax, 4
	ror ah, 4
	ret

vmenu_format_two_digits:                                     ; 08DDE
	aam 10                                       ; 08DDE
	add ax, 0x3030
	xchg al, ah                                  ; 08DE3  86 C4
	cmp al, '0'
	jne .ret
	mov al, 0x20
	xchg al, ah                                  ; 08DEB  86 C4
.ret:                                     ; 08DED
	ret

vmenu_active_flag:
	db 0x00
vmenu_saved_bx:
	dw 0xffff

con_puts:                                     ; 08DF1
	push es
	mov di, xios_vmenu_buf_48b9
	push di
	push di
	push ds
	pop es
	mov cx, 0x32
	mov al, 0x20
	rep stosb
	lodsb
	mov_cl_al                                    ; 08E01
	pop di
	rep movsb
	mov bx, [cs:xios4_cur_window_ptr]
	call ccb_acquire_lock
	call rtm_delay_1_tick
	mov word [cs:fdc_drive_cyl_0], 0xffff
	push word [bx + CCB_SCROLL_BOTTOM]
	mov ax, 0x18
	call crt_update_scroll_bottom
	pop ax
	pop cx
	mov dx, cs
	pop es
	push ax
	push bx
	call io_statline
	inc byte [cs:crt_timer_flag]
	mov byte [cs:kbd_prefix_flag], 0xff
	mov dx, 0x13
	call rtm_timer_wait
	mov cx, 0xffff
	call io_statline
	pop bx
	pop ax
	push es
	call crt_update_scroll_bottom
	mov byte [bx + CCB_ACTIVE], 0
	call crt_update_cursor_dispatch
	pop es
	mov al, [cs:kbd_prefix_char]
	ret

int28_fn_00_graphics_mode:              ; 08E55
	mov es, dx
	xchg si, cx                                  ; 08E57  87 F1
	call get_cur_process_ccb
	cmp word [cs:xios_graphics_gcb_segment], 0
	je .check_window_mode
	cmp dl, [cs:xios_graphics_owner_con]
	je .check_window_mode
	mov si, boot_msg_graphics_reserved
	call con_puts
	mov cl, 0
	call rtm_timer_wait2
	mov al, 0xff
	ret

.check_window_mode:                                     ; 08E79
	test byte [bx + CCB_FLAGS], CCB_FLG_WINDOW
	je .init_graphics_ccb
	mov dx, [cs:xios_vram_back_page]
	mov [es:si + 1], dx
	jmp near .exit_ok

.init_graphics_ccb:                                     ; 08E8B
	mov [cs:xios_graphics_owner_con], dl
	mov [cs:xios_graphics_gcb_offset], si
	mov [cs:xios_graphics_gcb_segment], es
	mov dx, [es:si + 1]
	mov [cs:xios_graphics_saved_buf_seg], dx
	mov [cs:crt_mode_ah], ah
	mov dx, 0x4f
	cmp ah, 2
	jne .setup_screen_cols
	mov dx, 0x27

.setup_screen_cols:                                     ; 08EB3
	mov [bx + CCB_MAX_COL], dx
	inc dx
	mov [bx + CCB_WRAP_COL], dl
	call ccb_acquire_all_locks
	call rtm_delay_1_tick
	or byte [bx + CCB_FLAGS], CCB_FLG_WINDOW
	mov byte [bx + 0x70], 0xc
	mov dx, [cs:xios_graphics_saved_buf_seg]
	mov [cs:xios_vram_back_page], dx
	test byte [bx + CCB_FLAGS], CCB_FLG_INACTIVE
	jne .setup_display_list
	mov ah, 3
	call xios_crt_trigger_ca
	call crt_set_graphics_timings

.setup_display_list:                                     ; 08EE0
	mov es, [cs:xios_sysdat_segment_ptr]
	xor_si_si                                    ; 08EE5
	mov dx, 0
	cmp byte [cs:crt_mode_ah], 1
	je .fill_display_list_loop
	mov dx, 0x4000

.fill_display_list_loop:                                     ; 08EF5
	mov di, [bx + si]
	mov_ax_dx                                    ; 08EF7
	mov cx, 0x23

.fill_entry_words:                                     ; 08EFC
	stosw
	add ax, strict word 0x10                     ; 08EFD  05 10 00
	loop .fill_entry_words
	mov word [es:di], 0x8200
	inc si
	inc si
	inc dx
	cmp dl, 0x10
	jb .fill_display_list_loop
	mov word [es:di], 0x8100
	mov ax, 0xccc0
	cmp byte [cs:xios_is_color_display], 0xff
	jne .setup_palette
	mov ax, 0x1240

.setup_palette:                                     ; 08F22
	cmp byte [cs:crt_mode_ah], 2
	je .clear_vram_and_done
	mov al, [bx + 0x7f]
	ror al, 4

.clear_vram_and_done:                                     ; 08F30
	lea si, [bx + CCB_PALETTE]
	mov [si], al
	mov [si + 8], ah
	mov ax, [cs:xios_vram_back_page]
	les si, [cs:xios_graphics_gcb_offset]
	mov [es:si + 1], ax
	mov es, ax
	mov cx, 0x4000
	xor_ax_ax                                    ; 08F4B
	xor_di_di                                    ; 08F4D
	rep stosw
	or word [bx + CCB_FLAGS], CCB_FLG_CUR_OFF
	mov bx, [cs:xios4_cur_window_ptr]
	call crt_switch_active_window

.exit_ok:                                     ; 08F5E
	lea bx, [bx + CCB_ACTIVE]
	mov dx, [cs:xios_sysdat_segment_val]
	ret

int28_fn_01_char_mode:                  ; 08F67
	cmp word [cs:xios_graphics_gcb_segment], 0
	je .ret
	call get_cur_process_ccb
	cmp dl, [cs:xios_graphics_owner_con]
	jne .ret
	les si, [cs:xios_graphics_gcb_offset]
	mov word [cs:xios_graphics_gcb_segment], 0
	mov ax, [cs:xios_graphics_saved_buf_seg]
	mov [es:si + 1], ax
	mov byte [es:si], 0
	test byte [bx + CCB_FLAGS], CCB_FLG_WINDOW
	je .ret
	and byte [bx + CCB_FLAGS], ~CCB_FLG_WINDOW & 0xff
	mov byte [bx + 0x70], 0xd
	call palette_init_default_colors
	mov ax, [bx + CCB_PALETTE]
	mov [bx + CCB_CHAR_ATTR], ah
	mov byte [bx + CCB_ATTR], 8
	test byte [bx + CCB_FLAGS], CCB_FLG_INACTIVE
	jne .restore_screen_size
	mov ah, 3
	call xios_crt_trigger_ca
	call crt_set_text_timings_and_flip
%if NUM_VIR_CONS == 1
	call crt_copy_vram_page_1con
%endif

.restore_screen_size:                                     ; 08FBF
	mov byte [bx + CCB_WRAP_COL], 0x50
	mov word [bx + CCB_MAX_COL], 0x4f
	call crt_esc_E_cls
	and word [bx + CCB_FLAGS], ~CCB_FLG_CUR_OFF & 0xffff
	call ccb_acquire_all_locks
	mov bx, [cs:xios4_cur_window_ptr]
	call crt_switch_active_window

.ret:                                     ; 08FDB
	ret

get_cur_process_ccb:                                     ; 08FDC
	mov bx, [cs:sysdat_rlr]
	mov dl, [bx + PD_CNS]
	jmp near get_ccb_by_index

crt_set_display_mode_timings:                                     ; 08FE7
	cmp byte [cs:bx + 0x70], 0xd
	je crt_set_text_timings_and_flip

crt_set_graphics_timings:                                     ; 08FEE
	mov word [cs:fdc_param_613c], 0x000f
	mov word [cs:fdc_param_613e], 0x8723
	mov si, fdc_dpb_alternate
	jmp short loc_09012

crt_set_text_timings_and_flip:                                     ; 09001
	mov word [cs:fdc_param_613c], 0x0009
	mov word [cs:fdc_param_613e], 0x8750
	mov si, fdc_dpb_standard

loc_09012:                                     ; 09012
	mov ax, [cs:xios_vram_back_page]
	mov dx, [cs:xios_vram_active_page]
	mov [cs:xios_vram_active_page], ax
	mov [cs:xios_vram_back_page], dx
	push ds
	push si
	xor_bp_bp                                    ; 09026
	mov cx, 4 * NUM_VIR_CONS

loc_0902B:                                     ; 0902B
	push cx
	mov_si_bp                                    ; 0902C
	xor_di_di                                    ; 0902E
	mov ds, ax
	mov es, [cs:xios_sysdat_segment_ptr]
	call vram_copy_1k_words
	mov_si_bp                                    ; 0903A
	mov_di_si                                    ; 0903C
	mov ds, dx
	mov es, ax
	call vram_copy_1k_words
	mov_di_bp                                    ; 09045
	xor_si_si                                    ; 09047
	mov ds, [cs:xios_sysdat_segment_ptr]
	mov es, dx
	call vram_copy_1k_words
	add bp, 0x800
	pop cx
	loop loc_0902B
	pop si
	pop ds
	push bx
	mov al, [bx + 0x70]
	mov dx, PORT_PPI_CTRL
	out dx, al
	mov di, fdc_drive_0_dpb_ptr
	mov_ax_si                                    ; 09067
	call crt_dma_make_phys_desc
	mov ah, 4
	call xios_crt_trigger_ca
	pop bx
	ret

vram_copy_1k_words:                                     ; 09073
	mov cx, 0x400
	rep movsw
	ret

%if NUM_VIR_CONS == 1
crt_copy_vram_page_1con:                                     ; 09079
	push ds
	push es
	push si
	push di
	push cx
	mov ax, [cs:xios_vram_base_seg]
	mov ds, ax
	mov es, ax
	mov di, 0x2000
	mov cx, 0x3000
	xor_si_si                                    ; 0908C
	rep movsw
	pop cx
	pop di
	pop si
	pop es
	pop ds
	ret
%endif
int28_fn_35_write_str:                  ; 09096
	mov_bp_sp                                    ; 09096
	push ds
	push dx
	push cx
	push si
	call get_cur_process_ccb
	test byte [bx + CCB_FLAGS], CCB_FLG_ATTR_DIRTY
	je loc_090AA
	push ds
	pop es
	call crt_get_char_attr

loc_090AA:                                     ; 090AA
	pop si
	pop cx
	pop dx
	mov es, [cs:xios_sysdat_segment_ptr]
	mov ds, [bp + 2]
	xor_ax_ax                                    ; 090B5
	xchg al, dh                                  ; 090B7  86 C6
	xchg bp, ax
	mov ah, [cs:bx + 0x6a]
	jmp short loc_090C3

loc_090C0:                                     ; 090C0
	inc bp
	xor_dx_dx                                    ; 090C1

loc_090C3:                                     ; 090C3
	mov_di_bp                                    ; 090C3
	shl di, 1
	mov di, [cs:bx + di]
	add_di_dx                                    ; 090CA
	add_di_dx                                    ; 090CC

loc_090CE:                                     ; 090CE
	cmp dx, 0x50
	je loc_090C0
	lodsb
	stosw
	inc dx
	loop loc_090CE
	pop ds
	jmp near window_repaint_contents

int28_fn_39_update_screen:              ; 090DC
	call get_cur_process_ccb
	jmp near window_repaint_contents

int28_fn_20_def_alt_char:               ; 090E2
	mov_bp_sp                                    ; 090E2
	mov bp, [bp + 2]
	mov ch, 2
	push cx
	push dx
	call vram_upload_font_char
	pop cx
	pop dx
	or ch, 1
int28_fn_52_def_font:                   ; 090F3
	mov_bp_sp                                    ; 090F3
	mov bp, [bp + 2]

vram_upload_font_char:                                     ; 090F8
	xchg si, dx                                  ; 090F8  87 F2
	xchg di, cx                                  ; 090FA  87 F9
	call vram_get_row_dest_ptr
	shl di, 5
	call vram_copy_16_words
	mov byte [bx + CCB_ACTIVE], 0
	ret

int28_fn_51_get_font:                   ; 0910A
	mov_bp_sp                                    ; 0910A
	mov bp, [bp + 2]
	shl cx, 5
	xchg si, cx                                  ; 09112  87 F1
	xchg di, dx                                  ; 09114  87 FA
	call vram_get_row_dest_ptr
	xchg dx, bp                                  ; 09119  87 D5
	call vram_copy_16_words
	mov byte [bx + CCB_ACTIVE], 0
	ret

vram_get_row_dest_ptr:                                     ; 09123
	call get_cur_process_ccb
	call ccb_acquire_lock
	push bx
	mov dx, [cs:xios_vram_active_page]
	pop bx
	ret

vram_copy_16_words:                                     ; 09131
	mov cx, 0x10
	push ds
	mov ds, bp
	mov es, dx
	push si
	push di
	rep movsw
	pop si
	pop di
	pop ds
	ret

int28_fn_21_get_disp_list:              ; 09141
	call get_cur_process_ccb
	mov si, fdc_drive_type_0
	jmp near loc_091B1

int28_fn_22_set_disp_list:              ; 0914A
	call get_cur_process_ccb
	mov dh, [bx + CCB_COL]
	mov dl, [bx + CCB_ROW]
	xchg bx, dx                                  ; 09153  87 DA
	ret

int28_fn_36_cursor_pos:                 ; 09156
	push bx
	call get_cur_process_ccb
	pop dx
	mov [bx + CCB_COL], dh
	mov [bx + CCB_ROW], dl
	jmp near crt_update_cursor

int28_fn_37_get_attr:                   ; 09164
	call get_cur_process_ccb
	mov ah, [bx + CCB_ATTR]
	ret

int28_fn_38_set_attr:                   ; 0916B
	call get_cur_process_ccb
	mov [bx + CCB_ATTR], ah
	ret

int28_fn_31_palette:                    ; 09172
	xchg si, dx                                  ; 09172  87 F2
	call get_cur_process_ccb
	lea di, [bx + CCB_PALETTE]
	mov_bp_sp                                    ; 0917B
	mov cx, 8
	push ds
	pop es
	mov ds, [bp + 2]
	cld
	rep movsw
	push cs
	pop ds
	test byte [bx + CCB_FLAGS], CCB_FLG_INACTIVE
	jne .ret
	cmp byte [cs:crt_mode_ah], 2
	jne .trigger_ca
	mov ah, 3
	call xios_crt_trigger_ca

.trigger_ca:
	call palette_load_hardware_regs
	mov ah, 1
	call xios_crt_trigger_ca
.ret:
	ret

ww_pointer:
	mov ax, xios4_vir_con_mode
	cmp dl, NUM_VIR_CONS
	jae loc_091BA
	call get_ccb_by_index

loc_091B1:                                     ; 091B1
	mov_ax_bx                                    ; 091B1
	push cs
	pop es
	mov dx, [cs:xios_sysdat_segment_ptr]

loc_091BA:                                     ; 091BA
	ret

; =============================================================================
; Sektion 4A: Funktion 16..24, Konsolskift & Vinduesmanager
; =============================================================================
io_auxist:
%if NUM_VIR_CONS == 1
	push ds
	push es
	push cx
	push dx
	push cs
	pop ds
	mov si, [cs:sysdat_rlr]
	mov es, [si + PD_UDA]
	mov si, 0x499b
	call con_puts
	mov si, [cs:sysdat_rlr]
	mov es, [si + PD_UDA]
	mov word [si + PD_FLAG], 0
	mov cx, 0x8f
	call rtm_timer_wait2
	pop dx
	pop cx
	pop es
	pop ds
	ret

loc_091E7:                                     ; 091E7
	ret
	ret
	ret
	jmp near loc_091E7
	ret
%else
xios4_fn_19_auxist:
	cmp cl, 3                                    ; 00001A45
	jnc .loc_1a5b                                ; 00001A48
	mov [cs:xios4_vir_con_mode], cl              ; 00001A4A
	cmp cl, 2                                    ; 00001A4F
	jz .loc_1a75                                 ; 00001A52
	mov word [cs:kbd_con_dest], 5                      ; 00001A54

.loc_1a5b:
	mov_al_dl                                    ; 00001A5B
	cmp al, 4                                    ; 00001A5D
	jnc .loc_1a75                                ; 00001A5F
	add al, 0x70                                 ; 00001A61
	mov ah, 0xff                                 ; 00001A63
	mov [cs:kbd_char_buffer], ax                          ; 00001A65
	mov dx, 5                                    ; 00001A69
	call rtm_call_helper                         ; 00001A6C
	pushf                                        ; 00001A6F
	call far [cs:sysdat_dispatcher]                           ; 00001A70

.loc_1a75:
	ret                                          ; 00001A75

ww_new_window:
	push ax                                      ; 00001A76
	call get_ccb_by_index                               ; 00001A77 (slå vindues-CCB op for konsol)
	call ccb_acquire_all_locks                               ; 00001A7A
	mov ax, [bx + CCB_WIN_LEFT]                          ; 00001A7D
	mov [bx + CCB_LAST_TOP_LEFT], ax                          ; 00001A80
	mov ax, [bx + CCB_WIN_TOP]                          ; 00001A83
	mov [bx + CCB_LAST_BOT_RIGHT], ax                          ; 00001A86
	mov [bx + CCB_WIN_LEFT], cx                          ; 00001A89
	pop cx                                       ; 00001A8C
	mov [bx + CCB_WIN_TOP], cx                          ; 00001A8D
	push es                                      ; 00001A90
	push ds                                      ; 00001A91
	pop es                                       ; 00001A92
	call window_calc_dimensions                               ; 00001A93 (beregn vinduesstørrelse)
	call window_clamp_to_screen                               ; 00001A96 (tjek vinduesgrænser)
	call xios4_clip_setup                        ; 00001A99 (genberegn klippekort)
	pop es                                       ; 00001A9C
	mov bx, [cs:xios4_cur_window_ptr]            ; 00001A9D
	call crt_switch_active_window                               ; 00001AA2
	ret                                          ; 00001AA5

ww_cursor_view:
	call get_ccb_by_index                               ; 00001AA6
	call ccb_acquire_lock                               ; 00001AA9
	mov [bx + CCB_TRACKING_MODE], dh                          ; 00001AAC
	mov [bx + 0x40], cx                          ; 00001AAF
	call window_clamp_to_screen                               ; 00001AB2
	call window_repaint_contents                               ; 00001AB5
	call crt_update_cursor_dispatch                               ; 00001AB8
	mov byte [bx + CCB_ACTIVE], 0                      ; 00001ABB
	ret                                          ; 00001ABF

ww_wrap_column:
	call get_ccb_by_index                               ; 00001AC0
	mov [bx + CCB_WRAP_COL], cl                          ; 00001AC3
	ret                                          ; 00001AC6

ww_full_window:
	push dx                                      ; 00001AC7
	call get_ccb_by_index                               ; 00001AC8
	mov cx, 0                                    ; 00001ACB
	mov ah, [bx + CCB_SCROLL_BOTTOM]                          ; 00001ACE
	dec ah                                       ; 00001AD1
	mov al, 0x4f                                 ; 00001AD3
	cmp [bx + CCB_WIN_LEFT], cx                          ; 00001AD5
	jnz .loc_1ae5                                ; 00001AD8
	cmp [bx + CCB_WIN_TOP], ax                          ; 00001ADA
	jnz .loc_1ae5                                ; 00001ADD
	mov cx, [bx + CCB_LAST_TOP_LEFT]                          ; 00001ADF
	mov ax, [bx + CCB_LAST_BOT_RIGHT]                          ; 00001AE2

.loc_1ae5:
	pop dx                                       ; 00001AE5
	jmp near ww_new_window              ; 00001AE6

ww_switch_display:
	ret                                          ; 00001AE9
%endif

io_setblank:
	mov ax, 0x5001                               ; 00001AEA / 091EE
	ret                                          ; 00001AED / 091F1

window_check_point_inside:                                     ; 091F2
	mov ax, [bx + 0x4a]
	cmp_dl_al                                    ; 091F5
	jb .ret
	cmp_dh_ah                                    ; 091F9
	jb .ret
	add al, [bx + CCB_COLS]
	add ah, [bx + CCB_ROWS]
	cmp_dl_al                                    ; 09203
	jae .cmc
	cmp_dh_ah                                    ; 09207

.cmc:
	cmc
.ret:
	ret

window_update_clipped_flag:                                     ; 0920B
	or byte [bx + CCB_FLAGS], CCB_FLG_CLIPPED
	cmp byte [bx + CCB_ROWS], 0x18
	jb .ret
	cmp byte [bx + CCB_COLS], 0x50
	jne .ret
	xor byte [bx + CCB_FLAGS], CCB_FLG_CLIPPED
.ret:                                     ; 0921F
	ret

ccb_acquire_lock:                                     ; 09220
	mov al, 0xff
	xchg [bx + CCB_ACTIVE], al
	test al, al
	je .ret
	call rtm_delay_1_tick
	jmp short ccb_acquire_lock
.ret:                                     ; 0922E
	ret

ccb_acquire_all_locks:                                     ; 0922F
	push bx
	push cx
	mov bx, ccb_console_0                        ; Konsol 0 CCB
	mov cx, NUM_VIR_CONS

loc_09237:                                     ; 09237
	call ccb_acquire_lock
	add bx, 0x94
	loop loc_09237
	pop cx
	pop bx
	ret

ccb_release_all_locks:                                     ; 09243
	push bx
	push cx
	mov bx, ccb_console_0                        ; Konsol 0 CCB
	mov cx, NUM_VIR_CONS

loc_0924B:                                     ; 0924B
	mov byte [bx + CCB_ACTIVE], 0
	add bx, 0x94
	loop loc_0924B
	pop cx
	pop bx
	ret

window_calc_tracking_offset:                                     ; 09258
	cmp byte [bx + CCB_TRACKING_MODE], 0
	je loc_09276
	mov ah, [bx + CCB_COL]
	mov al, [bx + CCB_MASK]
	cmp_al_ah                                    ; 09264
	ja loc_09273
	sub ah, [bx + CCB_ROWS]
	js loc_09276
	cmp_al_ah                                    ; 0926D
	ja loc_09276
	inc ah

loc_09273:                                     ; 09273
	mov [bx + CCB_MASK], ah

loc_09276:                                     ; 09276
	mov dx, [bx + CCB_WIN_LEFT]
	call crt_calc_screen_offset
	xchg dx, ax
	mov al, 0x50
	mul byte [bx + CCB_MASK]                         ; 0927F
	sub_dx_ax                                    ; 09282
	mov al, [bx + 0x4a]
	cbw                                          ; 09287
	sub_dx_ax                                    ; 09288
	mov [bx + 0x46], dx
	ret

window_zorder_promote_top:                                     ; 0928E
	mov di, xios4_vir_con_mode_p2
	mov cx, NUM_VIR_CONS
	mov_al_dl                                    ; 09294
	repne scasb
	jcxz window_zorder_update_table
	dec di

loc_0929B:                                     ; 0929B
	mov al, [di + 1]
	mov [di], al
	inc di
	loop loc_0929B
	mov [di], dl

window_zorder_update_table:                                     ; 092A5
	mov di, window_zorder_list
	mov al, [bx + 0x4e]
	mov ah, 0
	mov cx, ZORDER_LIST_SIZE                     ; Antal z-order kombinationer (2 i XIOS1, 16 i XIOS4)

loc_092B0:                                     ; 092B0
	test al, ah
	je loc_092B6
	mov [di], dl

loc_092B6:                                     ; 092B6
	inc ah
	inc di
	loop loc_092B0
	ret

window_calc_dimensions:                                     ; Beregn vinduesstørrelse (bredde/højde i dx)
	mov al, [bx + 0x39]
	sub al, [bx + 0x37]
	cbw                                          ; 092C2
	inc ax
	mov [bx + CCB_ROWS], ax
	mov al, [bx + CCB_WIN_TOP]
	sub al, [bx + CCB_WIN_LEFT]
	cbw                                          ; 092CD
	inc ax
	mov [bx + CCB_COLS], ax
	ret

window_clamp_to_screen:                                     ; Tjek vinduesgrænser mod skærmstørrelse
	mov dx, [bx + 0x40]
	mov al, [bx + CCB_SCROLL_BOTTOM]
	sub al, [bx + CCB_ROWS]
	cmp_al_dh                                    ; 092DC
	jae loc_092E2
	mov_dh_al                                    ; 092E0

loc_092E2:                                     ; 092E2
	mov al, 0x50
	sub al, [bx + CCB_COLS]
	cmp_al_dl                                    ; 092E7
	jae loc_092ED
	mov_dl_al                                    ; 092EB

loc_092ED:                                     ; 092ED
	mov [bx + 0x4a], dx
	ret
%if NUM_VIR_CONS == 4
xios4_clip_setup:
	mov di, xios4_clip_map
	mov cx, 0x780
	mov al, [bx + 0x4e]
	not al
.loc_27f8:
	and [es:di], al
	inc di
	loop .loc_27f8
	mov dx, [bx + CCB_WIN_LEFT]
	cmp dh, 0
	jz .loc_2808
	dec dh
.loc_2808:
	cmp dl, 0
	jz .loc_280f
	dec dl
.loc_280f:
	mov cx, [bx + CCB_WIN_TOP]
	mov al, [bx + CCB_SCROLL_BOTTOM]
	dec al
	cmp_ch_al
	jz .loc_281d
	inc ch
.loc_281d:
	cmp cl, 0x4f
	jz .loc_2824
	inc cl
.loc_2824:
	call crt_calc_screen_offset
	xchg ax, di
	add di, xios4_clip_map
	sub_cx_dx
	add cx, 0x101
	mov al, [bx + 0x4e]
.loc_2835:
	push di
	push cx
.loc_2837:
	or [di], al
	inc di
	dec cl
	jnz .loc_2837
	pop cx
	pop di
	add di, 0x50
	dec ch
	jnz .loc_2835
	ret
%else
	ret
%endif

get_ccb_by_index:                                     ; 092F2
	mov_bl_dl                                    ; 092F2
	xor_bh_bh                                    ; 092F4
	shl bx, 1
	mov bx, [cs:bx + xios_ccb_table]
	ret

crt_calc_screen_offset:                                     ; 092FE
	mov al, 0xb0
	mul dh                                        ; 09300
	neg ax
	add_ax_dx                                    ; 09304
	mov_di_ax                                    ; 09306
	add_di_di                                    ; 09308
	ret

window_zorder_lookup:                                     ; 0930B
	push bx
	mov bx, window_zorder_list
	xlatb
	pop bx
	ret

rtm_delay_1_tick:                                     ; 09312
	push bx
	push cx
	push dx
	push si
	push di
	push es
	mov cl, 0x8d
	mov dx, 1
	mov bx, [cs:sysdat_rlr]
	mov es, [bx + PD_UDA]
	call rtm_timer_wait2
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	ret
%if NUM_VIR_CONS == 4
sub_x4_clip_repaint_entry:
	push bx
	mov si, xios_boot_banner
	mov byte [cs:.xios4_clip_v2], 3
.loc_288f:
	mov dl, [cs:.xios4_clip_v2]
	call get_ccb_by_index
	mov [bx + 0x58], si
	mov dx, [bx + CCB_WIN_LEFT]
	mov cx, [bx + CCB_ROWS]
.loc_28a0:
	mov word [cs:.xios4_clip_v1], 0xffff
	push bx
	push cx
	push dx
	mov_bp_dx
	call crt_calc_screen_offset
	xchg ax, di
	add di, xios4_clip_map
	mov cx, [bx + CCB_COLS]
.loc_28b7:
	mov al, [es:di]
	mov_dx_di
	repe scasb
	jz .loc_28c2
	dec di
	inc cx
.loc_28c2:
	mov_bx_di
	sub_bx_dx
	call window_zorder_lookup
	cmp al, [cs:.xios4_clip_v2]
	jnz .loc_28ea
	cmp dx, [cs:.xios4_clip_v1]
	jz .loc_28e0
	mov [si], bl
	inc si
	mov [si], bp
	inc si
	inc si
	jmp short .loc_28e3

.loc_28e0:
	add [si - 3], bl
.loc_28e3:
	add_dx_bx
	mov [cs:.xios4_clip_v1], dx
.loc_28ea:
	add_bp_bx
	test cx, cx
	jnz .loc_28b7
	pop dx
	pop cx
	pop bx
	inc dh
	cmp dh, [bx + 0x39]
	jna .loc_28a0
	mov byte [si], 0
	inc si
	dec byte [cs:.xios4_clip_v2]
	jns .loc_288f
	pop bx
	ret

.xios4_clip_v1:
	dw 0
.xios4_clip_v2:
	db 0
xios_clip_repaint_windows:
	call near sub_x4_clip_repaint_entry
	push es
	mov si, xios4_clip_map
	mov es, [cs:xios_sysdat_segment_ptr]
	xor_di_di
	mov cx, 0x780
	mov ax, 0x820
	mov dl, 0xf
.loc_2920:
	test [si], dl
	jnz .loc_2927
	mov [es:di], ax
.loc_2927:
	inc di
	inc di
	inc si
	loop .loc_2920
	mov si, xios4_vir_con_mode + 2
	mov cx, NUM_VIR_CONS
.loc_2932:
	push si
	push cx
	mov dl, [si]
	call get_ccb_by_index
	call window_draw_borders
	call window_repaint_contents
	pop cx
	pop si
	inc si
	loop .loc_2932
	pop es
	ret
%else
	ret
	db 0x00, 0x00, 0x00                          ; 09330  ...
xios_clip_repaint_windows:
	ret
%endif

window_repaint_contents:                                     ; 09334
	test byte [cs:xios4_window_clip_flag], 0xff
	jne loc_093A2
	call window_calc_tracking_offset
	shl dx, 1
	mov si, [bx + 0x58]
	push ds
	push es
	mov ax, [cs:xios_sysdat_segment_ptr]
	mov ds, ax
	mov es, ax

loc_0934E:                                     ; 0934E
	db 0x2E, 0xAC                                ; 0934E  lodsb
	cbw                                          ; 09350
	xchg cx, ax
	jcxz loc_093A0
	db 0x2E, 0xAD                                ; 09354  lodsw
	xchg dx, ax
	call crt_calc_screen_offset
	sub dx, [cs:bx + 0x36]
	add dx, [cs:bx + 0x4a]
	mov_al_dh                                    ; 09362
	cbw                                          ; 09364
	shl ax, 1
	push si
	xchg si, ax
	mov si, [cs:bx + si]
	xor_dh_dh                                    ; 0936C
	shl dx, 1
	add_si_dx                                    ; 09370
	test byte [cs:bx + 0x6b], 4
	je loc_09380
	mov ax, 0x820
	rep stosw
	jmp short loc_0939D

loc_09380:                                     ; 09380
	test byte [cs:bx + 0x6b], 2
	je loc_0939B
	cmp byte [cs:xios_is_color_display], 0xff
	jne loc_0939B

loc_0938F:                                     ; 0938F
	lodsw
	and ah, 0x87
	or ah, 8
	stosw
	loop loc_0938F
	jmp short loc_0939D

loc_0939B:                                     ; 0939B
	rep movsw

loc_0939D:                                     ; 0939D
	pop si
	jmp short loc_0934E

loc_093A0:                                     ; 093A0
	pop es
	pop ds

loc_093A2:                                     ; 093A2
	ret

window_draw_borders:
	mov word [bx + 0x5a], 0xffff
	mov dx, [bx + CCB_WIN_LEFT]
	mov cx, [bx + CCB_COLS]
	dec dh
	js loc_093BE
	mov byte [cs:xios_char_mode_byte], 0xac
	mov ax, 0xccbc
	call window_draw_horiz_border

loc_093BE:                                     ; 093BE
	mov dh, [bx + 0x39]
	inc dh
	cmp dh, [bx + CCB_SCROLL_BOTTOM]
	je loc_093D4
	mov byte [cs:xios_char_mode_byte], 0xd0
	mov ax, 0xdad5
	call window_draw_horiz_border

loc_093D4:                                     ; 093D4
	mov dx, [bx + CCB_WIN_LEFT]
	mov cx, [bx + CCB_ROWS]
	dec dl
	js loc_093E3
	mov al, 0xb5
	call window_draw_vert_border

loc_093E3:                                     ; 093E3
	mov dl, [bx + CCB_WIN_TOP]
	inc dl
	cmp dl, 0x50
	je loc_093F2
	mov al, 0xca
	call window_draw_vert_border

loc_093F2:                                     ; 093F2
	call window_draw_title
	ret

window_draw_horiz_border:                                     ; 093F6
	push dx
	push cx
	push ax
	call crt_calc_screen_offset
	xchg si, ax
	pop ax
	push ax
	mov ah, 8
	cmp dl, 0
	je loc_0940C
	dec di
	dec di
	dec si
	call xios_clip_draw_char

loc_0940C:                                     ; 0940C
	add_dl_cl                                    ; 0940C
	dec dl
	cmp byte [cs:xios_char_mode_byte], 0xac
	jne loc_09440
	push ax
	push cx
	mov ah, 8
	mov al, 0x20
	call xios_clip_draw_char
	mov al, [bx + CCB_CON_IDX]
	add al, 0x30
	call xios_clip_draw_char
	mov al, ':'
	call xios_clip_draw_char
	mov [bx + 0x5a], si
	call window_draw_title
	mov al, 0x20
	call xios_clip_draw_char
	pop cx
	pop ax
	sub cx, 0xc
	jbe loc_09449

loc_09440:                                     ; 09440
	mov al, [cs:xios_char_mode_byte]

loc_09444:                                     ; 09444
	call xios_clip_draw_char
	loop loc_09444

loc_09449:                                     ; 09449
	pop cx
	xchg al, ch                                  ; 0944A  86 C5
	cmp dl, 0x4f
	je loc_09454
	call xios_clip_draw_char

loc_09454:                                     ; 09454
	pop cx
	pop dx
	ret

window_draw_vert_border:                                     ; 09457
	push cx
	push ax
	call crt_calc_screen_offset
	xchg si, ax
	pop ax
	mov ah, 8

loc_09460:                                     ; 09460
	call xios_clip_draw_char
	add di, 0x9e
	add si, 0x4f
	loop loc_09460
	pop cx
	ret

xios_char_mode_byte:
	db 0
xios_clip_draw_char:
%if NUM_VIR_CONS == 4
	push ax
	mov al, [cs:si + xios4_clip_map]
	inc si
	call window_zorder_lookup
	cmp al, [bx + CCB_CON_IDX]
	pop ax
	jnz .loc_2a93
	stosw
	ret

.loc_2a93:
	inc di
	inc di
	ret
%else
	ret
	inc di
	inc di
	ret
%endif
window_draw_title:                                     ; 09473
	mov es, [cs:xios_sysdat_segment_ptr]
	mov si, [bx + 0x5c]
	mov si, [si]
	test si, si
	je loc_0949F
	lea bp, [si + 8]
	mov si, [bx + 0x5a]
	cmp si, -1
	je loc_0949F
	mov_di_si                                    ; 0948C
	add_di_di                                    ; 0948E
	mov cx, 8
	mov ah, 8

loc_09495:                                     ; 09495
	xchg si, bp                                  ; 09495  87 F5
	lodsb
	xchg si, bp                                  ; 09498  87 F5
	call xios_clip_draw_char
	loop loc_09495

loc_0949F:                                     ; 0949F
	ret

; =============================================================================
; Sektion 4B: Fælles Mus- og CRT-driver (CS:2980..2BD0 / CS:2B43..2D93)
; =============================================================================
int28_fn_30_mouse:                      ; 094A0
	cmp cl, 4
	jb loc_094A8
	xor_al_al                                    ; 094A5
	ret

loc_094A8:                                     ; 094A8
	mov_bl_cl                                    ; 094A8
	xor_bh_bh                                    ; 094AA
	shl bx, 1
	jmp word [cs:bx + mouse_jump_table]

mouse_jump_table:
	dw mouse_fn_reset
	dw mouse_fn_init
	dw mouse_fn_nop
	dw mouse_fn_read
mouse_counter:
	db 0x05
mouse_pos_x:
	dw 0x0000
mouse_delta_x:
	dw 0x0000
mouse_delta_y:
	dw 0x0000
mouse_state:
	dw 0x0000
mouse_step_x:
	dw 0x0000
mouse_step_y:
	dw 0x0000
mouse_fn_reset:
	mov al, 0xff
	ret

mouse_fn_nop:
	ret

mouse_fn_init:
	mov byte [cs:mouse_counter], 5
mouse_fn_read:
	pushf
	cli
	xor_ax_ax                                    ; 094D4
	xor_bx_bx                                    ; 094D6
	xor_cx_cx                                    ; 094D8
	xchg [cs:mouse_pos_x], ax
	xchg [cs:mouse_delta_x], bx
	xchg [cs:mouse_delta_y], cx
	popf
	ret

mouse_process_packet_byte:                                     ; 094EB
	mov_ah_al                                    ; 094EB
	cmp byte [cs:mouse_counter], 5
	jne loc_0952E
	and ah, 0xf8
	cmp ah, 0x80
	jne loc_0952D
	not al
	and al, 7
	jne loc_0950C
mov word [cs:mouse_state], 2
	jmp short loc_09528

loc_0950C:                                     ; 0950C
	cmp word [cs:mouse_state], 1
	je loc_0952D
	mov ah, 0x20
	test al, 4
	jne loc_09522
	inc ah
	test al, 2
	jne loc_09522
	inc ah

loc_09522:                                     ; 09522
	mov al, 1
	mov [cs:mouse_state], ax

loc_09528:                                     ; 09528
	dec byte [cs:mouse_counter]

loc_0952D:                                     ; 0952D
	ret

loc_0952E:                                     ; 0952E
	mov_ah_al                                    ; 0952E
	and ah, 0xf8
	cmp ah, 0x80
	je loc_0957F
	cbw                                          ; 09538
	mov bl, [cs:mouse_counter]
	dec bl
	je loc_0955D
	dec bl
	je loc_09556
	dec bl
	je loc_09550
	mov [cs:mouse_step_x], ax
	jmp short loc_09528

loc_09550:                                     ; 09550
	mov [cs:mouse_step_y], ax
	jmp short loc_09528

loc_09556:                                     ; 09556
	add [cs:mouse_step_x], ax
	jmp short loc_09528

loc_0955D:                                     ; 0955D
	add ax, [cs:mouse_step_y]
	add [cs:mouse_delta_y], ax
	mov ax, [cs:mouse_step_x]
	add [cs:mouse_delta_x], ax
	mov ax, [cs:mouse_state]
	mov [cs:mouse_pos_x], ax
	mov byte [cs:mouse_counter], 5
	ret

loc_0957F:                                     ; 0957F
	mov byte [cs:mouse_counter], 5
	jmp near mouse_process_packet_byte

crt_check_cursor_blink_tick:                                     ; 09588
	mov bx, [cs:xios4_cur_window_ptr]
	cmp byte [bx + CCB_COLOR_MODE], 0
	je .ret
	test byte [bx + CCB_FLAGS], CCB_FLG_WINDOW
	jne .ret
	cmp byte [cs:kbd_disabled_flag], 0xff
	je .ret
	dec word [cs:kbd_buf_tail]
	jne .ret
	mov byte [cs:kbd_disabled_flag], 0xff
	call crt_swap_active_line_buffers
	mov ax, xios_crt_line_entry_61ec
	call crt_dma_make_phys_desc
	xor byte [cs:fdc_drive_flags_0], 0x80
mov word [cs:fdc_drive_cyl_0], 0xffff
	mov word [bx + CCB_ESC_HANDLER], crt_esc_dispatch_reset
.ret:                                     ; 095CA
	ret

crt_reset_blink_state:                                     ; 095CB
	push bx
	mov bx, [cs:xios4_cur_window_ptr]
	cmp byte [bx + CCB_COLOR_MODE], 0
	jne loc_095DA
	pop bx
	ret

loc_095DA:                                     ; 095DA
	mov bx, [cs:kbd_buf_head]
	mov [cs:kbd_buf_tail], bx
	push dx
	xor byte [cs:fdc_drive_flags_0], 0x80
	mov bx, [cs:xios4_cur_window_ptr]
	call crt_update_cursor_dispatch
	pop dx
	pop bx
	mov byte [cs:kbd_disabled_flag], 0
	ret

kbd_buf_head:
	dw 0x0384
kbd_buf_tail:
	dw 0x0384
kbd_disabled_flag:
	db 0x00

xios_crt_trigger_ca:                           ; 09601
	mov al, 1
	mov [cs:fdc_drive_type_0], ax

crt_post_cmd_wait:                             ; 09607
	mov dx, PORT_CRT_CA
	out dx, al

loc_0960B:                                     ; 0960B
	cmp [cs:fdc_drive_type_0], al
	je loc_0960B
	mov word [cs:fdc_drive_type_0], 0x900
	ret
	mov dx, [cs:xios_sysdat_segment_ptr]
	jmp short crt_dma_store_phys_desc

crt_dma_make_phys_desc:                                     ; 09621
	mov dx, cs

crt_dma_store_phys_desc:                                     ; 09623
	cld
	call crt_calc_20bit_phys_addr
	mov dx, cs
	mov es, dx
	stosw
	mov_ax_cx                                    ; 0962C
	stosw
	ret

crt_calc_20bit_phys_addr:                                     ; 09630
	mov cl, 4
	rol dx, cl
	mov_cx_dx                                    ; 09634
	and cx, strict word 0xf                      ; 09636  81 E1 0F 00
	and dl, 0xf0
	add_ax_dx                                    ; 0963D
	adc cx, 0
	ret

palette_init_default_colors:                                     ; 09643
	cmp byte [cs:xios_is_color_display], 0xff
	je loc_09660
	push es
	push ds
	pop es
	lea di, [bx + CCB_PALETTE]
	mov si, mouse_cursor_char_table
	mov cx, 0x10
	mov [bx + 0x81], cx
	rep movsb
	pop es
	ret

loc_09660:                                     ; 09660
	mov al, [cs:xios_default_fg_color]
	mov ah, [cs:xios_default_bg_color]
	mov [bx + CCB_PALETTE], ax
	mov word [bx + 0x81], 2
	ret

mouse_cursor_char_table:
	db 0x48, 0x40, 0x00, 0x04, 0x08, 0x0C, 0x44, 0x4C, 0x80, 0x84, 0x88, 0x8C, 0xC0, 0xC4, 0xC8, 0xCC
	db 0x0C, 0xC0, 0x00, 0x0C, 0x0C, 0x0C, 0xCC, 0x0C, 0xC0, 0xC0, 0xCC, 0x0C, 0xC0, 0xC0, 0xC0, 0xCC

palette_translate_mono_color:                                     ; 09694
	cmp byte [cs:xios_is_color_display], 0xff
	je .ret
	test byte [bx + CCB_FLAGS], CCB_FLG_WINDOW
	jne .ret
	push es
	push di
	push cx
	mov di, mouse_cursor_char_table
	push cs
	pop es
	mov cx, 0x10
	repne scasb
	add di, 0xf
	mov al, [di]
	pop cx
	pop di
	pop es
.ret:                                     ; 096B7
	ret

palette_load_hardware_regs:                                     ; 096B8
	lea si, [bx + CCB_PALETTE]
	mov dx, PORT_PALETTE_BASE
	mov cx, 0x10

loc_096C2:                                     ; 096C2
	lodsb
	call palette_translate_mono_color
	out dx, al
	inc dx
	inc dx
	out dx, al
	inc dx
	inc dx
	loop loc_096C2
	ret

crt_load_cursor_hardware_regs:                                     ; 096CF
	test byte [bx + CCB_FLAGS], CCB_FLG_INACTIVE
	jne .ret
	mov al, [bx + 0x75]
	mov [cs:fdc_dpb_std_al0], al
	mov al, [bx + 0x74]
	mov [cs:fdc_dpb_std_drm], al
	mov cx, [bx + 0x72]
	mov [cs:fdc_dpb_current_format], cx
	mov ah, 4
	call xios_crt_trigger_ca
.ret:                                     ; 096F0
	ret

; =============================================================================
; Sektion 4C: Display Lists, Konsol-deskriptorer (CCB) & CRT Output Buffere
; CS:2BD0..2D7B (XIOS1: 1 virtuel konsol) / CS:2D93..3108 (XIOS4: 4 virtuelle konsoller)
; =============================================================================
xios4_vir_con_mode:
	db 0x00, NUM_VIR_CONS
xios4_vir_con_mode_p2:
	db 0x03, 0x02, 0x01
xios4_active_vir_con:
	db 0x00
	db 0x00
xios4_cur_window_ptr:
	dw ccb_console_0
xios4_window_clip_flag:
	db 0xff

window_zorder_list:
	times ZORDER_LIST_SIZE db 0

%macro def_ccb 5
	times 0x34 db 0
	db %1
	times 3 db 0
	db 0x4f, 0x17, 0x00, 0x00, 0x4f, 0x17, 0x50, 0x18, 0x00, 0x00, 0x18, 0x00, 0x50, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00, 0x00, 0x50
	db %2
	times 0x0b db 0
	dw 0xffff
	dw %3
	dw crt_char_handler
	db 0x4f
	times 9 db 0
	dw %4
	times 4 db 0
	db 0x0d, 0x01, 0x0a, 0x00, 0x01, 0xf8
	dw %5
	times 9 db 0
	db 0x02, 0x00, 0x0f
	times 16 db 0
%endmacro

ccb_console_0:
%if NUM_VIR_CONS == 1
	def_ccb 0, 1, 0x0d49, 0x0008, 0x4d8c
%else
	def_ccb 0, 1, 0x0d49, 0x0008, 0x58e7
ccb_console_1:
	def_ccb 1, 2, 0x0d75, 0x1208, 0x5aaf
ccb_console_2:
	def_ccb 2, 4, 0x0da1, 0x1208, 0x5c77
ccb_console_3:
	def_ccb 3, 8, 0x0dcd, 0x1208, 0x5e3f
%endif

xios_sysdat_segment_ptr:
	dw 0x0000

xios_ccb_table:
%if NUM_VIR_CONS == 1
	dw ccb_console_0, ccb_console_0, ccb_console_0, ccb_console_0
%else
	dw ccb_console_0, ccb_console_1, ccb_console_2, ccb_console_3
%endif

xios_is_color_display:
	db 0x00
xios_font_height_scanlines:
	db 0x09
xios_crt_50hz_60hz_flag:
	db 0x01
xios_default_fg_color:
	db 0xc0
xios_default_bg_color:
	db 0xc0
xios_scroll_ccb_ptr:
	dw 0x0000
xios_scroll_row_start:
	dw 0x0000
xios_scroll_row_end:
	dw 0x0000
xios_scroll_dir_up_flag:
	db 0x00
xios_scroll_step_counter:
	db 0xff
xios_crt_font_alt_flag:
	db 0x01
xios_scroll_temp_offset:
	dw 0x0000
xios_scroll_param_block:
	times 8 db 0
xios_scroll_line_save_buf:
	times 50 db 0
xios_vram_base_seg:
	dw 0xd000
xios_graphics_saved_buf_seg:
	dw 0x0000
xios_graphics_gcb_offset:
	dw 0x0000
xios_graphics_gcb_segment:
	dw 0x0000
xios_graphics_owner_con:
	db 0x00
xios_vram_active_page:
	dw 0xd000
xios_vram_back_page:
	dw 0x0000

kbd_translate_table:
	db 0xff, 0x09, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x30, 0x2d, 0x60, 0x08, 0x1b
	db 0x71, 0x77, 0x65, 0x72, 0x74, 0x79, 0x75, 0x69, 0x6f, 0x70, 0x7b, 0x7d, 0x0d, 0xff, 0x61, 0x73
	db 0x64, 0x66, 0x67, 0x68, 0x6a, 0x6b, 0x6c, 0x3b, 0xff, 0x3a, 0xff, 0x7c, 0x7a, 0x78, 0x63, 0x76
	db 0x62, 0x6e, 0x6d, 0x2c, 0x2e, 0x2f, 0xff, 0xff, 0x7e, 0x20, 0xc1, 0x80, 0x81, 0x82, 0x83, 0x84
	db 0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x97, 0x8e, 0x8f, 0x93, 0x94, 0xff, 0x90, 0x92, 0x8d
	db 0x95, 0x8c, 0x98, 0x37, 0x38, 0x39, 0x2d, 0x2b, 0x34, 0x35, 0x36, 0x2c, 0x96, 0x31, 0x32, 0x33
	db 0x91, 0x30, 0x2e

kbd_shift_translate_table:
	db 0xff, 0x0c, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x5f, 0x3d, 0x40, 0x08, 0x1b
	db 0x51, 0x57, 0x45, 0x52, 0x54, 0x59, 0x55, 0x49, 0x4f, 0x50, 0x5b, 0x5d, 0x0d, 0xff, 0x41, 0x53
	db 0x44, 0x46, 0x47, 0x48, 0x4a, 0x4b, 0x4c, 0x2b, 0xff, 0x2a, 0xff, 0x5c, 0x5a, 0x58, 0x43, 0x56
	db 0x42, 0x4e, 0x4d, 0x3c, 0x3e, 0x3f, 0xff, 0xff, 0x5e, 0x20, 0xc1, 0xad, 0xae, 0xaf, 0xb0, 0xb1
	db 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0x9f, 0xa0, 0x97, 0x99, 0x9a, 0x9b, 0x9c, 0xff, 0x90, 0x92, 0x8d
	db 0x95, 0x8c, 0x98, 0x37, 0x38, 0x39, 0x2d, 0x2b, 0x34, 0x35, 0x36, 0x2c, 0x96, 0x31, 0x32, 0x33
	db 0x91, 0x30, 0x2e

kbd_ctrl_translate_table:
	db 0xff, 0x09, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x1f, 0xff, 0x00, 0x7f, 0x1b
	db 0x11, 0x17, 0x05, 0x12, 0x14, 0x19, 0x15, 0x09, 0x0f, 0x10, 0x1b, 0x1d, 0x0d, 0xff, 0x01, 0x13
	db 0x04, 0x06, 0x07, 0x08, 0x0a, 0x0b, 0x0c, 0xff, 0xff, 0xff, 0xff, 0x1c, 0x1a, 0x18, 0x03, 0x16
	db 0x02, 0x0e, 0x0d, 0xff, 0xff, 0xff, 0xff, 0xff, 0x1e, 0x20, 0xfe, 0xb7, 0xb8, 0xb9, 0xba, 0xbb
	db 0xbc, 0xbd, 0xbe, 0xbf, 0xc0, 0xa1, 0xa2, 0x97, 0xfd, 0xff, 0xfb, 0xfa, 0xff, 0x90, 0x92, 0x8d
	db 0x95, 0x8c, 0x98, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x96, 0xf1, 0xf2, 0xf3
	db 0x91, 0xf0, 0xff


; =============================================================================
; Sektion 5: Floppydisk Driver (Fælles for XIOS1 og XIOS4)
; =============================================================================
io_seldsk:
	mov ax, 0
	mov_al_cl                                    ; 0991E
	mov bx, fdc_scratch_3932
	xlatb
	cmp al, 0
	je loc_09976
	test dl, 1
	je loc_0993B
	mov dx, 0xfffe
	stc
	rcl dx, cl
	and [cs:fdc_param_377c], dx
	jmp near loc_09945

loc_0993B:                                     ; 0993B
	mov dx, 1
	shl dx, cl
	or [cs:fdc_param_377c], dx

loc_09945:                                     ; 09945
	and al, 0xf7
	mov_ah_al                                    ; 09947
	and al, 0xf0
	mov_al_ah                                    ; 0994B
	mov bx, fdc_dpb_drive_a
	mov_ch_cl                                    ; 09950
	je loc_0995B
	mov cl, 4
	shr al, cl
	mov bx, fdc_dpb_drive_b

loc_0995B:                                     ; 0995B
	dec al
	mov cl, 0x11
	mul cl                                        ; 0995F
	add_ax_bx                                    ; 09961
	push ax
	mov_cl_ch                                    ; 09964
	mov bx, dph_drive_a
	mov al, 0x14
	mul cl                                        ; 0996B
	add_bx_ax                                    ; 0996D
	pop ax
	mov [bx + 8], ax
	mov_ax_bx                                    ; 09973
	ret

loc_09976:                                     ; 09976
	mov_bx_ax                                    ; 09976
	ret

io_read:
	mov_bp_sp                                    ; 09979
	mov al, 1
	cmp byte [bp + 0xf], 0
	jne loc_09984
	ret

loc_09984:                                     ; 09984
	mov al, [bp + 0xe]
	mov bx, fdc_param_3785
	call fdc_inc_stats_counter
	mov al, [bp + 0xe]
	mov_cl_al                                    ; 09990
	mov bx, fdc_scratch_3932
	xlatb
	cmp al, 0
	jne loc_0999F
	mov al, 1
	mov_bl_al                                    ; 0999C
	ret

loc_0999F:                                     ; 0999F
	cmp al, 0xc0
	je loc_099AA
	cmp al, 0xd0
	je loc_099AD
	jmp near loc_099B0

loc_099AA:                                     ; 099AA
	jmp near loc_0A159

loc_099AD:                                     ; 099AD
	jmp near loc_0A1A4

loc_099B0:                                     ; 099B0
	mov byte [cs:fdc_param_3768], 8
	and [cs:fdc_param_3768], al
	and al, 0xf7
	push ax
	mov bx, dph_drive_a
	mov al, 0x14
	mul cl                                        ; 099C3
	add_ax_bx                                    ; 099C5
	mov [cs:fdc_param_3773], ax
	mov_si_ax                                    ; 099CB
	mov bx, [si + 8]
	mov ax, [bx]
	mov [cs:fdc_param_3775], ax
	mov al, [bx + 0xf]
	mov [cs:fdc_param_3777], al
	mov ax, [bp + 8]
	mov bx, [bp + 6]
	call fdc_calc_phys_address_pair
mov word [cs:fdc_param_373b], 0xae66
	pop ax
	and al, 0xf0
	mov bx, 0
	mov byte [cs:fdc_param_377e], 0
	je loc_09A04
	mov bx, 2
	mov byte [cs:fdc_param_377e], 0xa

loc_09A04:                                     ; 09A04
	call word [cs:bx + fdc_jump_table_2f59]
	cmp byte [cs:fdc_param_3756], 0
	je loc_09A32

loc_09A11:                                     ; 09A11
	cmp byte [cs:fdc_param_377e], 0xa
	jae loc_09A29
	mov al, [bp + 0xe]
	mov bx, fdc_param_3805
	call fdc_inc_stats_counter
	inc byte [cs:fdc_param_377e]
	jmp short loc_09A11

loc_09A29:                                     ; 09A29
	mov al, [bp + 0xe]
	mov bx, fdc_param_37c5
	call fdc_inc_stats_counter

loc_09A32:                                     ; 09A32
	mov al, [cs:fdc_param_3756]
	mov_bl_al                                    ; 09A36
	ret

io_write:
	mov_bp_sp                                    ; 09A39
	mov al, 1
	cmp byte [bp + 0xf], 0
	jne loc_09A44
	ret

loc_09A44:                                     ; 09A44
	mov al, [bp + 0xe]
	mov bx, fdc_param_37a5
	call fdc_inc_stats_counter
	mov al, [bp + 0xe]
	mov_cl_al                                    ; 09A50
	mov bx, fdc_scratch_3932
	xlatb
	cmp al, 0
	jne loc_09A5F
	mov al, 1
	mov_bl_al                                    ; 09A5C
	ret

loc_09A5F:                                     ; 09A5F
	cmp al, 0xc0
	je loc_09A6A
	cmp al, 0xd0
	je loc_09A6D
	jmp near loc_09A70

loc_09A6A:                                     ; 09A6A
	jmp near loc_0A16C

loc_09A6D:                                     ; 09A6D
	jmp near loc_0A1BB

loc_09A70:                                     ; 09A70
	mov byte [cs:fdc_param_3768], 8
	and [cs:fdc_param_3768], al
	and al, 0xf7
	push ax
	mov bx, dph_drive_a
	mov al, 0x14
	mul cl                                        ; 09A83
	add_ax_bx                                    ; 09A85
	mov [cs:fdc_param_3773], ax
	mov_si_ax                                    ; 09A8B
	mov bx, [si + 8]
	mov ax, [bx]
	mov [cs:fdc_param_3775], ax
	mov al, [bx + 0xf]
	mov [cs:fdc_param_3777], al
	mov ax, [bp + 8]
	mov bx, [bp + 6]
	call fdc_calc_phys_address_pair
mov word [cs:fdc_param_373b], 0x76a6
	pop ax
	and al, 0xf0
	mov bx, 0
	mov byte [cs:fdc_param_377e], 0
	je loc_09AC4
	mov bx, 2
	mov byte [cs:fdc_param_377e], 0xa

loc_09AC4:                                     ; 09AC4
	call word [cs:bx + fdc_jump_table_2f59]
	cmp byte [cs:fdc_param_3757], 0
	je loc_09AF2

loc_09AD1:                                     ; 09AD1
	cmp byte [cs:fdc_param_377e], 0xa
	jae loc_09AE9
	mov al, [bp + 0xe]
	mov bx, fdc_param_3825
	call fdc_inc_stats_counter
	inc byte [cs:fdc_param_377e]
	jmp short loc_09AD1

loc_09AE9:                                     ; 09AE9
	mov al, [bp + 0xe]
	mov bx, fdc_param_37e5
	call fdc_inc_stats_counter

loc_09AF2:                                     ; 09AF2
	mov al, [cs:fdc_param_3757]
	mov_bl_al                                    ; 09AF6
	ret

fdc_jump_table_2f59:
	dw fdc_op_2f5e
io_flushbuf:
	xor_al_al                                    ; 09AFB
	ret

fdc_op_2f5e:
	inc word [bp + 0xa]
	mov byte [cs:fdc_param_3781], 1
	mov ah, [bp + 0xe]
	call fdc_select_drive_unit
	mov byte [cs:fdc_param_3767], 0

loc_09B13:                                     ; 09B13
	mov ax, [cs:fdc_param_3775]
	sub ax, [bp + 0xa]
	inc ax
	mov dl, [bp + 0xf]
	xor_dh_dh                                    ; 09B1E
	cmp_ax_dx                                    ; 09B20
	jae loc_09B44
	mov [cs:fdc_param_3778], ax
	sub_dx_ax                                    ; 09B28
	push dx
	call fdc_exec_command_check
	pop dx
	jb loc_09B4C
	mov [bp + 0xf], dl
	mov word [bp + 0xa], 1
	inc word [bp + 0xc]
	inc byte [cs:fdc_param_3767]
	jmp near loc_09B13

loc_09B44:                                     ; 09B44
	mov [cs:fdc_param_3778], dx
	call fdc_exec_command_check

loc_09B4C:                                     ; 09B4C
	mov ah, [bp + 0xe]
	call fdc_load_drive_timing_byte
	mov byte [cs:fdc_param_3781], 0
	ret

fdc_exec_command_check:                                     ; 09B59
	call xios_fdc_test_busy
	jae loc_09B62
	call fdc_set_error_flags
	ret

loc_09B62:                                     ; 09B62
	mov ax, 1
	mov cl, [bp + 0xe]
	shl ax, cl
	and ax, [cs:fdc_param_377c]
	jne loc_09B7E
	mov bl, [bp + 0xe]
	xor_bh_bh                                    ; 09B74
	cmp byte [cs:bx + fdc_param_3771], 0xff
	jne loc_09B8E

loc_09B7E:                                     ; 09B7E
	not ax
	and [cs:fdc_param_377c], ax
	call xios_fdc_restore_track0
	jae loc_09B8E
	call fdc_set_error_flags
	ret

loc_09B8E:                                     ; 09B8E
	cmp byte [cs:fdc_param_3767], 0
	jne loc_09BB0
	mov ax, [cs:fdc_param_3778]
	mov [cs:fdc_param_377a], ax
	mov dx, PORT_FDC_DATA
	mov si, fdc_param_375b
	call fdc_setup_dma_transfer_size
	call fdc_seek_track
	jae loc_09BF2
	call fdc_set_error_flags
	ret

loc_09BB0:                                     ; 09BB0
	mov ax, [cs:fdc_param_377a]
	mov cl, [cs:fdc_param_3777]
	add cl, 7
	shl ax, cl
	add [cs:fdc_param_3758], ax
	adc byte [cs:fdc_param_375a], 0
	mov ax, [cs:fdc_param_3778]
	mov [cs:fdc_param_377a], ax
	mov dx, PORT_FDC_DATA
	mov si, fdc_param_375b
	call fdc_setup_dma_transfer_size
	and byte [cs:fdc_param_3768], 8
	jne loc_09BE9
	test word [bp + 0xc], 1
	jne loc_09BF2

loc_09BE9:                                     ; 09BE9
	call xios_fdc_step_in
	jae loc_09BF2
	call fdc_set_error_flags
	ret

loc_09BF2:                                     ; 09BF2
	mov byte [cs:fdc_param_3769], 1
	mov byte [cs:fdc_param_376b], 0
	mov bx, 0xfeff
	mov si, fdc_param_375b
	and [si + 0xa], bx
	cmp byte [bp + 0xf], 1
	je loc_09C34
	mov byte [cs:fdc_param_376b], 0x10
	inc byte [cs:fdc_param_3769]
	not bx
	mov si, fdc_param_375b
	or [si + 0xa], bx
	mov ax, [cs:fdc_param_3775]
	sub ax, [bp + 0xa]
	inc ax
	cmp ax, [cs:fdc_param_3778]
	je loc_09C34
	inc byte [cs:fdc_param_3769]

loc_09C34:                                     ; 09C34
	mov byte [cs:fdc_param_376a], 0
	test word [bp + 0xc], 1
	je loc_09C4F
	and byte [cs:fdc_param_3768], 8
	jne loc_09C4F
	mov byte [cs:fdc_param_376a], 2

loc_09C4F:                                     ; 09C4F
	mov cx, 0xa

loc_09C52:                                     ; 09C52
	push cx
	cmp cx, 5
	jne loc_09C65
	call fdc_set_motor_enable
	call fdc_seek_track
	jae loc_09C65
	pop cx
	call fdc_set_error_flags
	ret

loc_09C65:                                     ; 09C65
	cli
	call fdc_seek_track_zero
	sti
	xor_al_al                                    ; 09C6A
	call fdc_wait_dma_channel_ready
	xor_al_al                                    ; 09C6F
	call xios_dma_chan_ctrl
	mov ah, 4
	xor_al_al                                    ; 09C76
	call xios_dma_mask_reg
	mov si, fdc_param_375b
	xor_al_al                                    ; 09C7E
	call fdc_send_dma_param_block
cmp word [cs:fdc_param_373b], 0xae66
	jne loc_09C9F
	call xios_fdc_cmd_read_sector
	mov al, 0
	call fdc_release_dma_channel
	call fdc_check_status_register
	mov bx, fdc_param_3805
	jb loc_09CB2
	jmp near loc_09CC4

loc_09C9F:                                     ; 09C9F
	call xios_fdc_read_track_reg
	mov al, 0
	call fdc_release_dma_channel
	call fdc_check_completion_status
	mov bx, fdc_param_3825
	jb loc_09CB2
	jmp near loc_09CC4

loc_09CB2:                                     ; 09CB2
	mov al, [bp + 0xe]
	call fdc_inc_stats_counter
	inc byte [cs:fdc_param_377e]
	pop cx
	dec cx
	je loc_09CC7
	jmp near loc_09C52

loc_09CC4:                                     ; 09CC4
	pop cx
	clc
	ret

loc_09CC7:                                     ; 09CC7
	stc
	ret

fdc_set_error_flags:                                     ; 09CC9
	mov byte [cs:fdc_param_3756], 1
	mov byte [cs:fdc_param_3757], 1
	stc
	ret

fdc_inc_stats_counter:                                     ; 09CD7
	mov_cl_al                                    ; 09CD7
	mov ax, 1
	shl ax, cl
	test [cs:fdc_param_377f], ax
	je .ret
	shl cl, 1
	xor_ch_ch                                    ; 09CE7
	mov_si_cx                                    ; 09CE9
	inc word [bx + si]
.ret:                                     ; 09CED
	ret

fdc_clear_stats_counters:                                     ; 09CEE
	mov cl, [bp + 0xe]
	mov_al_cl                                    ; 09CF1
	mov ax, 1
	shl ax, cl
	test [cs:fdc_param_377f], ax
	je loc_09D1A
	shl cl, 1
	xor_ch_ch                                    ; 09D01
	mov_si_cx                                    ; 09D03
	mov cx, 8
	mov al, 1

loc_09D0A:                                     ; 09D0A
	test [cs:fdc_param_3782], al
	je loc_09D13
	inc word [bx + si]

loc_09D13:                                     ; 09D13
	add si, 4
	shl al, 1
	loop loc_09D0A

loc_09D1A:                                     ; 09D1A
	ret

fdc_select_drive_unit:                                     ; 09D1B
	cli
	push ax
	call dpc_reserve_fdc
	pop ax
	sti
	mov_cl_ah                                    ; 09D22
	mov ch, 2
	shl ch, cl
	and ch, [cs:fdc_param_376c]
	mov al, 2
	and ah, 1
	je loc_09D36
	shl al, 1

loc_09D36:                                     ; 09D36
	cli
	mov byte [cs:fdc_param_376d], 0
	sti
	or_al_ah                                     ; 09D3E
	mov ah, [cs:fdc_param_376c]
	and ah, 0xfe
	or_al_ah                                     ; 09D48
	mov [cs:fdc_param_376c], al

fdc_fcr_setup:                                 ; 09D4E
	mov dx, PORT_FDC_CTRL
	out dx, al
	cmp ch, 0
	jne .ret
	mov dx, 0x3c
	mov cl, 0x8d
	pusha                                        ; 09D5C  60
	call rtm_timer_wait2
	popa                                         ; 09D60  61
.ret:                                     ; 09D61
	ret

; -----------------------------------------------------------------------------
; Diskettedrev Motor Timeout Nedtælling (Kaldes hvert sekund af RTC-afbrydelsen)
; Tæller inaktivitetstimeren i cs:0x376D ned. Når timeren når 0, slukkes motoren
; for Drev A/B via PORT_FDC_CTRL (0x0288), jvf. NVRAM byte 20.
; -----------------------------------------------------------------------------
fdc_motor_timeout_tick:
	cmp byte [cs:fdc_param_376d], 0
	je loc_09DA3
	dec byte [cs:fdc_param_376d]
	jne loc_09DA3
	push bx
	push ax
	mov bx, xios_crt_table_4256
	mov al, [bx + 0x14]
	cmp al, 5
	pop ax
	pop bx
	jb loc_09D89
	mov ah, 0
	call fdc_deselect_drive_unit
	mov ah, 1
	call fdc_deselect_drive_unit

loc_09D89:                                     ; 09D89
	mov byte [cs:xt_door], 0xff
	mov di, dph_drive_a
	mov byte [di + 5], 0xff
	mov di, dph_drive_b
	mov byte [di + 5], 0xff
	mov byte [cs:xios_fdc_reserve_flag], 0xff

loc_09DA3:                                     ; 09DA3
	ret

fdc_deselect_drive_unit:                                     ; 09DA4
	mov al, 0xfd
	and ah, 1
	je loc_09DAD
	mov al, 0xfb

loc_09DAD:                                     ; 09DAD
	and al, [cs:fdc_param_376c]
	mov [cs:fdc_param_376c], al
	mov dx, PORT_FDC_CTRL
	out dx, al
	ret

fdc_load_drive_timing_byte:                                     ; 09DBB
	cli
	mov bx, xios_crt_table_4256
	mov al, [bx + 0x14]
	mov [cs:fdc_param_376d], al
	sti
	ret

fdc_recalibrate_all_drives:                                     ; 09DC8
	cmp byte [cs:fdc_param_3781], 1
	je loc_09E04

fdc_seek_track_zero:                                     ; 09DD0
	test byte [cs:fdc_scratch_3932], 0xf
	je loc_09DE6
	mov di, dph_drive_a
	mov al, [cs:fdc_param_376c]
	and al, 0xfe
	mov ah, 2
	call xios_fdc_select_drive

loc_09DE6:                                     ; 09DE6
	test byte [cs:fdc_scratch_3933], 0xf
	je loc_09DFC
	mov di, dph_drive_b
	mov al, [cs:fdc_param_376c]
	or al, 1
	mov ah, 4
	call xios_fdc_select_drive

loc_09DFC:                                     ; 09DFC
	mov al, [cs:fdc_param_376c]

fdc_fcr_write:                                 ; 09E00
	mov dx, PORT_FDC_CTRL
	out dx, al

loc_09E04:                                     ; 09E04
	ret

xios_fdc_select_drive:                         ; 09E05
	test ah, al
	je .ret
	mov dx, PORT_FDC_CTRL
	out dx, al
	mov dx, PORT_FDC_CMD
	in al, dx
	test al, 0x80
	je .ret
	mov byte [cs:xt_door], 0xff
	mov byte [di + 5], 0xff
	xor [cs:fdc_param_376c], ah
.ret:                                     ; 09E24
	ret

fdc_set_motor_enable:                                     ; 09E25
	mov ah, 0xfd
	cmp byte [bp + 0xe], 0
	je loc_09E2F
	mov ah, 0xfb

loc_09E2F:                                     ; 09E2F
	mov al, [cs:fdc_param_376c]
	mov dx, PORT_FDC_CTRL
	and_al_ah                                    ; 09E36
	out dx, al
	not ah
	or_al_ah                                     ; 09E3B
	out dx, al
	mov dx, 0x3c
	mov cl, 0x8d
	pusha                                        ; 09E43  60
	call rtm_timer_wait2
	popa                                         ; 09E47  61

xios_fdc_restore_track0:                       ; 09E48
	mov dx, PORT_FDC_CMD
	mov al, 0xc
	out dx, al
	call fdc_wait
	xor_bh_bh                                    ; 09E51
	test byte [cs:fdc_param_3782], 4
	mov bl, [bp + 0xe]
	mov byte [cs:bx + fdc_param_3771], 0
	jne loc_09E6A
	mov byte [cs:bx + fdc_param_3771], 0xff

loc_09E6A:                                     ; 09E6A
	clc
	test byte [cs:fdc_param_3782], 0x10
	je .ret
	stc
.ret:                                     ; 09E74
	ret

; -----------------------------------------------------------------------------
; WD2797 Søg Spor (Seek Track med op til 3 retries)
; Skriver målspor til PORT_FDC_DATA (0x286) og sender Type I SEEK-kommando (0x1C)
; til PORT_FDC_CMD (0x280) med 6 ms steprate og verifikation.
; -----------------------------------------------------------------------------
fdc_seek_track:
	mov cx, 3

loc_09E78:                                     ; 09E78
	push cx
	mov bl, [bp + 0xe]
	xor_bh_bh                                    ; 09E7C
	mov al, [cs:bx + fdc_param_3771]
	cmp al, 0xff
	je loc_09E8B
	mov dx, PORT_FDC_TRACK
	out dx, al

loc_09E8B:                                     ; 09E8B
	mov ax, [bp + 0xc]
	and byte [cs:fdc_param_3768], 8
	jne loc_09E98
	shr ax, 1

loc_09E98:                                     ; 09E98
	mov dx, PORT_FDC_DATA
	out dx, al
	push ax
	mov al, 0x1c
	mov dx, PORT_FDC_CMD
	out dx, al
	call fdc_wait
	xor_bh_bh                                    ; 09EA6
	pop ax
	mov bl, [bp + 0xe]
	mov [cs:bx + fdc_param_3771], al
	test byte [cs:fdc_param_3782], 0x99
	clc
	pop cx
	je .ret
	mov byte [cs:bx + fdc_param_3771], 0xff
	push cx
	call fdc_set_motor_enable
	pop cx
	loop loc_09E78
	stc
.ret:                                     ; 09EC9
	ret

xios_fdc_step_in:                              ; 09ECA
	mov al, 0x5c
	mov dx, PORT_FDC_CMD
	out dx, al
	call fdc_wait
	xor_bh_bh                                    ; 09ED3
	mov bl, [bp + 0xe]
	inc byte [cs:bx + fdc_param_3771]
	test byte [cs:fdc_param_3782], 0x99
	clc
	je .ret
	mov byte [cs:bx + fdc_param_3771], 0xff
	call xios_fdc_restore_track0
	call fdc_seek_track
.ret:                                     ; 09EF2
	ret

xios_fdc_cmd_read_sector:                      ; 09EF3
	mov ax, [bp + 0xa]
	mov dx, PORT_FDC_SECTOR
	out dx, al
	mov al, 0x88
	or al, [cs:fdc_param_376a]
	or al, [cs:fdc_param_376b]

fdc_send_cmd:                                  ; 09F06
	mov dx, PORT_FDC_CMD
	out dx, al
	call fdc_wait
	ret

xios_fdc_read_track_reg:                       ; 09F0E
	mov ah, [cs:fdc_param_376c]
	and ah, 0xef
	mov dx, PORT_FDC_TRACK
	in al, dx
	cmp al, 0x2a
	jb loc_09F21
	or ah, 0x10

loc_09F21:                                     ; 09F21
	mov_al_ah                                    ; 09F21
	mov [cs:fdc_param_376c], al
	mov dx, PORT_FDC_CTRL
	out dx, al
	mov ax, [bp + 0xa]
	mov dx, PORT_FDC_SECTOR
	out dx, al
	mov al, 0xa8
	or al, [cs:fdc_param_376a]
	or al, [cs:fdc_param_376b]
	mov dx, PORT_FDC_CMD
	out dx, al
	call fdc_wait
	ret
	mov al, 0xd8
	mov dx, PORT_FDC_CMD
	out dx, al
	ret

fdc_wait:                                      ; 09F4D
	mov byte [cs:fdc_param_376e], 1
	mov dx, 8
	call rtm_timer_wait
	ret

; -----------------------------------------------------------------------------
; WD2797 Diskettedrev Afbrydelsesrutine (Floppy ISR, IR0 / Vektor 0x80)
; 1. Læser FDC status fra PORT_FDC_CMD (0x280).
; 2. Sender Type IV FORCE INTERRUPT (0xD0) for at afslutte kommandoen.
; 3. Læser PORT_PCB_DMA0_CNT (0xFFC8) for at verificere fuldført DMA transfer.
; 4. Kvitterer med EOI via eoi_helper.
; 5. Vækker den ventende proces ved at signalere Flag 8 ("Floppy disk flag").
; -----------------------------------------------------------------------------
i_disk:
fdc_transfer_isr:
	call xios_switch_to_priv_stack
	mov ds, [cs:xios_sysdat_segment_val]
	mov dx, PORT_FDC_CMD
	in al, dx
	mov [cs:fdc_param_3782], al
	mov al, 0xd0
	out dx, al
	mov cx, 9

loc_09F70:                                     ; 09F70
	loop loc_09F70
	in al, dx
	mov dx, PORT_PCB_DMA0_CNT
	in ax, dx
	mov [cs:fdc_param_3783], ax
	call eoi_helper
	cmp byte [cs:fdc_param_376e], 1
	jne loc_09F92
	mov byte [cs:fdc_param_376e], 0
	mov dx, 8
	call rtm_call_helper

loc_09F92:                                     ; 09F92
	jmp near xios_isr_exit_dispatch

xios_fdc_test_busy:                            ; 09F95
	mov dx, PORT_FDC_CMD
	in al, dx
	and al, 0x81
	clc
	je .ret
	stc
.ret:                                     ; 09F9F
	ret

fdc_check_status_register:                                     ; 09FA0
	mov byte [cs:fdc_param_3756], 0
	mov al, [cs:fdc_param_3782]
	test al, 0xbf
	jne loc_09FB8
	cmp word [cs:fdc_param_3783], 0
	jne loc_09FB8
	clc
	ret

loc_09FB8:                                     ; 09FB8
	mov bx, fdc_param_3845
	call fdc_clear_stats_counters
	inc byte [cs:fdc_param_3756]
	stc
	ret

fdc_check_completion_status:                                     ; 09FC5
	mov byte [cs:fdc_param_3757], 0
	mov al, [cs:fdc_param_3782]
	test al, 0xff
	jne loc_09FDD
	cmp word [cs:fdc_param_3783], 0
	jne loc_09FDD
	clc
	ret

loc_09FDD:                                     ; 09FDD
	mov bx, fdc_param_3865
	call fdc_clear_stats_counters
	mov byte [cs:fdc_param_3757], 1
	mov al, [cs:fdc_param_3782]
	test al, 0x40
	je loc_09FF7
	mov byte [cs:fdc_param_3757], 2

loc_09FF7:                                     ; 09FF7
	stc
	ret

int28_fn_05_recalibrate:                ; 09FF9
	mov byte [cs:fdc_param_3781], 1
	mov_bp_sp                                    ; 09FFF
	mov ah, [bp + 0x14]
	call fdc_select_drive_unit
	mov al, 0xc
	and al, 0xfb

fdc_read_path:                                 ; 0A00B
	mov dx, PORT_FDC_CMD
	out dx, al
	call fdc_wait
	jmp near loc_0A13C

int28_fn_06_reserved:                   ; 0A015
	ret

int28_fn_07_reserved:                   ; 0A016
	ret

int28_fn_08_step_in:                    ; 0A017
	mov byte [cs:fdc_param_3781], 1
	mov_bp_sp                                    ; 0A01D
	mov ah, [bp + 0x14]
	call fdc_select_drive_unit
	mov al, 0x5c
	and al, 0xfb
	mov dx, PORT_FDC_CMD
	out dx, al
	call fdc_wait
	jmp near loc_0A13C

int28_fn_09_step_out:                   ; 0A033
	ret

int28_fn_10_write_track:                ; 0A034
	mov byte [cs:fdc_param_3781], 1
	mov_bp_sp                                    ; 0A03A
	mov ax, [bp + 0xc]
	mov bx, [bp + 0xa]
	call fdc_calc_phys_address_pair
mov word [cs:fdc_param_373b], 0x76a6
	xor_al_al                                    ; 0A04C
	call fdc_wait_dma_channel_ready
	xor_al_al                                    ; 0A051
	call xios_dma_chan_ctrl
	mov ah, 4
	xor_al_al                                    ; 0A058
	call xios_dma_mask_reg
	mov ah, [bp + 0x14]
	call fdc_select_drive_unit
	mov byte [cs:fdc_param_3757], 1
	call xios_fdc_test_busy
	jae loc_0A071
	jmp near loc_0A0A8

loc_0A071:                                     ; 0A071
	mov ax, [bp + 0xe]
	mov dx, PORT_FDC_DATA
	mov si, fdc_param_375b
	call fdc_setup_dma_descriptor
	mov byte [cs:fdc_param_376b], 0
	mov byte [cs:fdc_param_3769], 0
	mov byte [cs:fdc_param_376a], 0
	cmp byte [bp + 0x12], 0
	je loc_0A09B
	mov byte [cs:fdc_param_376a], 2

loc_0A09B:                                     ; 0A09B
	mov si, fdc_param_375b
	xor_al_al                                    ; 0A09E
	call fdc_send_dma_param_block
	mov al, 0xf4
	call xios_fdc_send_cmd_wait

loc_0A0A8:                                     ; 0A0A8
	xor_al_al                                    ; 0A0A8
	call fdc_release_dma_channel
	jmp near loc_0A13C

xios_fdc_send_cmd_wait:                        ; 0A0B0
	mov dl, [bp + 0x12]
	shl dl, 1
	or_al_dl                                     ; 0A0B5
	mov dx, PORT_FDC_CMD
	out dx, al
	call fdc_wait
	ret

int28_fn_11_read_track:                 ; 0A0BF
	mov byte [cs:fdc_param_3781], 1
	mov_bp_sp                                    ; 0A0C5
	mov ax, [bp + 0xc]
	mov bx, [bp + 0xa]
	call fdc_calc_phys_address_pair
mov word [cs:fdc_param_373b], 0xae66
	xor_al_al                                    ; 0A0D7
	call fdc_wait_dma_channel_ready
	xor_al_al                                    ; 0A0DC
	call xios_dma_chan_ctrl
	mov ah, 4
	xor_al_al                                    ; 0A0E3
	call xios_dma_mask_reg
	mov ah, [bp + 0x14]
	call fdc_select_drive_unit
	mov byte [cs:fdc_param_3757], 1
	call xios_fdc_test_busy
	jae loc_0A0FC
	jmp near loc_0A133

loc_0A0FC:                                     ; 0A0FC
	mov ax, [bp + 0xe]
	mov dx, PORT_FDC_DATA
	mov si, fdc_param_375b
	call fdc_setup_dma_descriptor
	mov byte [cs:fdc_param_376b], 0
	mov byte [cs:fdc_param_3769], 0
	mov byte [cs:fdc_param_376a], 0
	cmp byte [bp + 0x12], 0
	je loc_0A126
	mov byte [cs:fdc_param_376a], 2

loc_0A126:                                     ; 0A126
	mov si, fdc_param_375b
	xor_al_al                                    ; 0A129
	call fdc_send_dma_param_block
	mov al, 0xe4
	call xios_fdc_send_cmd_wait

loc_0A133:                                     ; 0A133
	xor_al_al                                    ; 0A133
	call fdc_release_dma_channel
	jmp near loc_0A13C
	ret

loc_0A13C:                                     ; 0A13C
	mov ah, [bp + 0x14]
	call fdc_load_drive_timing_byte
	mov al, [cs:fdc_param_3782]
	mov byte [cs:fdc_param_3781], 0
	ret

int28_fn_13_disk_stats:                 ; 0A14D
	mov es, [cs:xios_sysdat_segment_val]
	mov ax, fdc_param_3785
	ret

int28_fn_14_reserved:                   ; 0A156
	ret

fdc_dma_buffer_ptr_35b7:
	db 0x00, 0x00                                ; 0A157  ..

loc_0A159:                                     ; 0A159
	call fdc_calc_dma_buffer_offset
	push es
	les di, [bp + 6]
	xor_si_si                                    ; 0A160
	push ds
	mov ds, bx
	rep movsw
	pop ds
	pop es
	xor_ax_ax                                    ; 0A169
	ret

loc_0A16C:                                     ; 0A16C
	call fdc_calc_dma_buffer_offset
	push es
	mov es, bx
	xor_di_di                                    ; 0A172
	push ds
	lds si, [bp + 6]
	rep movsw
	pop ds
	pop es
	xor_ax_ax                                    ; 0A17C
	ret

fdc_calc_dma_buffer_offset:                                     ; 0A17F
	mov bx, [bp + 0xc]
	mov cl, 3
	shl bx, cl
	mov cx, [bp + 0xa]
	add_bx_cx                                    ; 0A189
	mov cl, 3
	shl bx, cl
	add bx, [cs:fdc_dma_buffer_ptr_35b7]
	mov cx, 0x40
	mov al, [bp + 0xf]
	xor_ah_ah                                    ; 0A19A
	mul cx                                        ; 0A19C
	mov_cx_ax                                    ; 0A19E
	cld
	ret

fdc_dma_buffer_ptr_3602:
	db 0x00                                      ; 0A1A2  .
	inc ax

loc_0A1A4:                                     ; 0A1A4
	call fdc_calc_dma_alt_buffer_offset
	push es
	les di, [bp + 6]
	xor_si_si                                    ; 0A1AB
	push ds
	mov ds, bx

loc_0A1B0:                                     ; 0A1B0
	mov ax, [si]
	lodsw
	stosw
	loop loc_0A1B0
	pop ds
	pop es
	xor_ax_ax                                    ; 0A1B8
	ret

loc_0A1BB:                                     ; 0A1BB
	mov ax, 1
	ret

fdc_calc_dma_alt_buffer_offset:                                     ; 0A1BF
	mov bx, [bp + 0xc]
	mov cl, 3
	shl bx, cl
	mov cx, [bp + 0xa]
	add_bx_cx                                    ; 0A1C9
	mov cl, 3
	shl bx, cl
	add bx, [cs:fdc_dma_buffer_ptr_3602]
	mov cx, 0x40
	mov al, [bp + 0xf]
	xor_ah_ah                                    ; 0A1DA
	mul cx                                        ; 0A1DC
	mov_cx_ax                                    ; 0A1DE
	cld
	ret

fdc_setup_dma_transfer_size:                                     ; 0A1E2
	mov cl, [cs:fdc_param_3777]
	add cl, 7
	shl ax, cl

fdc_setup_dma_descriptor:                                     ; 0A1EC
	mov [si + 8], ax
	mov ax, [cs:fdc_param_373b]
	mov [si + 0xa], ax
	mov bl, [cs:fdc_param_375a]
	xor_bh_bh                                    ; 0A1FB
	cmp ax, 0xae66
	mov ax, [cs:fdc_param_3758]
	je loc_0A214
	mov word [si], 0
	mov [si + 2], dx
	mov [si + 4], bx
	mov [si + 6], ax
	ret

loc_0A214:                                     ; 0A214
	mov [si], bx
	mov [si + 2], ax
	mov word [si + 4], 0
	mov [si + 6], dx
	ret

fdc_calc_phys_address_pair:                                     ; 0A222
	mov cl, 4
	rol ax, cl
	mov_ch_al                                    ; 0A226
	and al, 0xf0
	add_ax_bx                                    ; 0A22A
	adc ch, 0
	and ch, 0xf
	mov [cs:fdc_param_3758], ax
	mov [cs:fdc_param_375a], ch
	ret

fdc_send_dma_param_block:                                     ; 0A23C
	cli
	mov di, fdc_param_373d
	test al, 1
	je loc_0A247
	mov di, fdc_param_3749

loc_0A247:                                     ; 0A247
	mov cx, 6

loc_0A24A:                                     ; 0A24A
	mov dx, [di]
	mov ax, [si]
	out dx, ax
	inc di
	inc di
	inc si
	inc si
	loop loc_0A24A
	sti
	ret

fdc_wait_dma_channel_ready:                                     ; 0A257
	mov dx, xios_mx_dma0_msg
	or_al_al                                     ; 0A25A
	je loc_0A261
	mov dx, xios_mx_dma1_msg

loc_0A261:                                     ; 0A261
	pusha                                        ; 0A261  60
	mov cl, 0x89
	call rtm_timer_wait2
	popa                                         ; 0A267  61
	cli
	mov ah, 1
	mov_cl_al                                    ; 0A26B
	shl ah, cl
	xor [cs:fdc_param_3755], ah
	sti
	ret

fdc_release_dma_channel:                                     ; 0A276
	cli
	mov ah, 1
	mov_cl_al                                    ; 0A279
	shl ah, cl
	or [cs:fdc_param_3755], ah
	mov dx, xios_mx_dma0_msg
	or_al_al                                     ; 0A285
	je loc_0A28C
	mov dx, xios_mx_dma1_msg

loc_0A28C:                                     ; 0A28C
	pusha                                        ; 0A28C  60
	mov cl, 0x8b
	call rtm_timer_wait2
	popa                                         ; 0A292  61
	sti
	ret

xios_dma_chan_ctrl:                            ; 0A295
	or al, 0xa
	out PORT_PPI_CTRL, al
	ret

xios_dma_mask_reg:                             ; 0A29A
	cli
	mov ch, 0xf3
	cmp al, 0
	je loc_0A2A7
	mov ch, 0xc7
	mov cl, 3
	shl ah, cl

loc_0A2A7:                                     ; 0A2A7
	in al, PORT_PPI_PORTC
	and_al_ch                                    ; 0A2A9
	or_al_ah                                     ; 0A2AB
	out PORT_PPI_PORTC, al
	sti
	ret

fdc_int10_handler:
	push dx
	mov [cs:fdc_scratch_392f], ax
	cmp byte [cs:fdc_param_3781], 1
	jne loc_0A2C4

fdc_isr:                                       ; 0A2BE
	mov dx, PORT_FDC_CMD
	mov al, 0xd8
	out dx, al

loc_0A2C4:                                     ; 0A2C4
	pop dx
	mov ax, [cs:fdc_scratch_392f]
fdc_int11_handler:
	push dx
	mov [cs:fdc_scratch_392f], ax
	mov dx, PORT_PCB_EOI
	mov ax, 0x8000
	out dx, ax
	mov ax, [cs:fdc_scratch_392f]
	pop dx
	iret
; Floppy parameter tables & scratch buffers (CS:373B..3941)
fdc_param_373b:
	db 0x00, 0x00
fdc_param_373d:
	db 0xc6, 0xff, 0xc4, 0xff, 0xc2, 0xff, 0xc0, 0xff, 0xc8, 0xff, 0xca, 0xff
fdc_param_3749:
	db 0xd6, 0xff, 0xd4, 0xff, 0xd2, 0xff, 0xd0, 0xff, 0xd8, 0xff, 0xda, 0xff
fdc_param_3755:
	db 0x03
fdc_param_3756:
	db 0x00
fdc_param_3757:
	db 0x00
fdc_param_3758:
	db 0x00, 0x00
fdc_param_375a:
	db 0x00
fdc_param_375b:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
fdc_param_3767:
	db 0x00
fdc_param_3768:
	db 0x08
fdc_param_3769:
	db 0x00
fdc_param_376a:
	db 0x00
fdc_param_376b:
	db 0x00
fdc_param_376c:
	db 0x48
fdc_param_376d:
	db 0x00
fdc_param_376e:
	db 0x00, 0x00, 0x00
fdc_param_3771:
	db 0x00, 0x00
fdc_param_3773:
	db 0x00, 0x00
fdc_param_3775:
	db 0x00, 0x00
fdc_param_3777:
	db 0x00
fdc_param_3778:
	db 0x00, 0x00
fdc_param_377a:
	db 0x00, 0x00
fdc_param_377c:
	db 0x00, 0x00
fdc_param_377e:
	db 0x00
fdc_param_377f:
	db 0xff, 0x00
fdc_param_3781:
	db 0x00
fdc_param_3782:
	db 0x00
fdc_param_3783:
	db 0x00, 0x00
fdc_param_3785:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
fdc_param_37a5:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
fdc_param_37c5:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
fdc_param_37e5:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
fdc_param_3805:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
fdc_param_3825:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
fdc_param_3845:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
fdc_param_3865:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc
	db 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc
	db 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc
	db 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc
	db 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc
	db 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc
	db 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc
	db 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc
	db 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc
	db 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0x00, 0x00, 0x00, 0x00
fdc_scratch_392f:
	db 0x00, 0x00, 0x00
fdc_scratch_3932:
	db 0x00
fdc_scratch_3933:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

dph_drive_a:
	dw 0                                         ; XLT (Translation table: none)
	dw 0, 0, 0                                   ; Scratch words
	dw fdc_dpb_drive_a                     ; DPB (Disk Parameter Block)
	dw 0, 0                                      ; CSV, ALV (Checksum vector, Allocation vector)
	dw fdc_dirbcb_drive_a                     ; DIRBCB (Directory Buffer Control Block)
	dw fdc_dtabcb_drive_a                     ; DTABCB (Data Buffer Control Block)
	dw 0                                         ; HASH / reserveret

dph_drive_b:
	dw 0                                         ; XLT (Translation table: none)
	dw 0, 0, 0                                   ; Scratch words
	dw fdc_dpb_drive_a                     ; DPB (Disk Parameter Block)
	dw 0, 0                                      ; CSV, ALV (Checksum vector, Allocation vector)
	dw fdc_dirbcb_drive_a                     ; DIRBCB (Directory Buffer Control Block)
	dw fdc_dtabcb_drive_a                     ; DTABCB (Data Buffer Control Block)
	dw 0                                         ; HASH / reserveret

	times 200 db 0                               ; Disk buffere (CSV/ALV for Floppy A og B)

dph_drive_m:
	dw 0                                         ; XLT (Translation table: none)
	dw 0, 0, 0                                   ; Scratch words
	dw fdc_dpb_drive_m                     ; DPB (Disk Parameter Block for M-Disk)
	dw 0, 0                                      ; CSV, ALV
	dw fdc_dirbcb_drive_a                     ; DIRBCB (Directory Buffer Control Block)
	dw fdc_dtabcb_drive_a                     ; DTABCB (Data Buffer Control Block)
	dw 0                                         ; HASH / reserveret

	times 60 db 0                                ; Bufferområde for M-disk
fdc_dpb_drive_a:
	or [bx + si], al
	add al, 0xf
	add [bx + 2], dl
	inc word [bx + di]
	inc word [bx + si]
	db 0x80, 0x80, 0x04, 0x00, 0x03              ; 0A62D  add byte [bx + si + 4], 3
	pop es
	or [bx + si], al
	add al, 0xf
	add [bx + 2], dl
	inc word [bx + di]
	inc word [bx + si]
	db 0x80, 0x80, 0x04, 0x00, 0x03              ; 0A63E  add byte [bx + si + 4], 3
	pop es
fdc_dpb_drive_b:
	adc al, [bx + si]
	add ax, 0x11f
	mov al, 0xa
	inc word [si]
	inc ax                                         ; 0A64D
	db 0x00, 0x80, 0x04, 0x00                    ; 0A64F  add byte [bx + si + 4], al
	add al, [bp + di]
	adc al, [bx + si]
	add ax, strict word 0x1f                     ; 0A657  05 1F 00
	mov al, 0xa
	inc word [si]
	inc ax                                         ; 0A65E
	db 0x00, 0x80, 0x04, 0x00                    ; 0A660  add byte [bx + si + 4], al
	add al, [bp + di]
	times 152 db 0                                ; 0A666..0A6FC (152 bytes padding)
	db 0x00
fdc_dpb_drive_m:
	db 0x08, 0x00, 0x03, 0x07, 0x00
fdc_dpb_m_param:
	db 0x00, 0x00, 0x3f
	add al, al
	times 74 db 0                                ; 0A709..0A751 (74 bytes padding)
fdc_dirbcb_drive_a:
	times 15 db 0
fdc_dtabcb_drive_a:
	times 15 db 0
xios_nmi_handler:
	mov es, [cs:xios_auxin_es]
mov word [es:8], xios_auxin_handler
	mov [cs:xios_auxin_ds], ds
	mov [cs:xios_auxin_bx], bx
	xor_bx_bx                                    ; 0A787
	mov ds, bx
	mov bx, 0x200
	mov [bx], ax
	mov [bx + 2], dx
	mov [bx + 4], cx
	mov cx, 0xa

loc_0A799:                                     ; 0A799
	push cx
	mov cx, 0xffff

loc_0A79D:                                     ; 0A79D
	loop loc_0A79D
	pop cx
	loop loc_0A799
	mov ax, [cs:xios_auxin_bx]
	mov [bx + 6], ax
	mov [bx + 8], bp
	mov [bx + 0xa], si
	mov [bx + 0xc], di
	mov [bx + 0xe], sp
	mov [bx + 0x10], cs
	mov ax, [cs:xios_auxin_ds]
	mov [bx + 0x12], ax
	mov [bx + 0x14], ss
	mov [bx + 0x16], es
	pop ax
	mov [bx + 0x18], ax
	pop ax
	mov [bx + 0x1A], ax
	pop ax
	mov [bx + 0x1C], ax
	mov byte [0x67], 0x50
	mov ds, [cs:xios_sysdat_segment_val]
	mov es, [cs:xios_sysdat_segment_val]
	mov bx, fdc_drive_type_0
	jmp near loc_0B24F

xios_auxin_ds:
	dw 0x0000
xios_auxin_bx:
	dw 0x0000
xios_auxin_es:
	dw 0x0000
xios_auxin_handler:
	iret

io_auxin:
	mov al, 0x1a
	ret

io_auxout:
	ret

loc_0A7F1:                                     ; 0A7F1
	cmp dl, [cs:xt_nccbs]
	jb loc_0A7FB
	mov al, 0x1a
	ret

loc_0A7FB:                                     ; 0A7FB
	mov_bl_dl                                    ; 0A7FB
	sub bl, 4
	xor_bh_bh                                    ; 0A800
	shl bx, 1
	call word [cs:bx + xios_aux_jump_table]
	ret

xios_aux_jump_table:
		dw xios_aux_ret_3cbe
		dw xios_aux_ret_3cbe
		dw xios_aux_ret_3cbd
		dw xios_aux_ret_3cbd
xios_aux_state_word:
		dw xios_aux_fn_3c74
xios_aux_fn_3c74:
		push bx
	push cx
	mov dx, xios_aux_buf_3cad
	mov cl, 0x87
	call rtm_timer_wait2
	pop cx
	pop bx
	test ax, ax
	je loc_0A82C
mov word [cs:xios_aux_state_word], xios_aux_ret_3cbd
	ret

loc_0A82C:                                     ; 0A82C
mov word [cs:xios_aux_state_word], xios_aux_fn_3c93
xios_aux_fn_3c93:
	cmp byte [cs:xios_prn_flag_3d92], 0
	je loc_0A83E
	call printer_wait_completion

loc_0A83E:                                     ; 0A83E
	mov cl, 0x89
	mov dx, xios_aux_buf_3cad
	call rtm_timer_wait2
	mov al, [cs:xios_aux_data_3cab]
	ret

xios_aux_data_3cab:
	dw 0x0000
xios_aux_buf_3cad:
	times 6 db 0
		dw xios_aux_data_3cab
		db "NetConI "
xios_aux_ret_3cbd:
		ret

xios_aux_ret_3cbe:
	cli
	call sio_check_rx_status
	jne loc_0A870
	push bx
	or byte [bx + 0x1A], 4
	mov dx, [bx + 0x14]
	call rtm_timer_wait
	pop bx

loc_0A870:                                     ; 0A870
	mov ax, [bx + 2]
	sub ax, strict word 0xa                      ; 0A873  2D 0A 00
	cmp [bx + 8], ax
	jne loc_0A88E
	cmp byte [bx + 0x1d], 1
	jne loc_0A88E
	or byte [bx + 0x1b], 0x20
	test byte [bx + 0x1b], 1
	je loc_0A88E
	call sio_tx_byte_from_buffer

loc_0A88E:                                     ; 0A88E
	mov si, [bx + 4]
	push es
	mov es, [bx]
	mov al, [es:si]
	pop es
	mov ah, 0
	inc word [bx + 4]
	mov dx, [bx + 2]
	dec dx
	and [bx + 4], dx
	inc word [bx + 8]
	sti
	ret

sio_check_rx_status:                                     ; 0A8A9
	cmp dl, 8
	je .ret
	call sio_get_channel_b_struct
	mov ax, [bx + 2]
	cmp [bx + 8], ax
	mov ax, 0
	je .done
	mov ax, 0xff

.done:
	or_ax_ax                                     ; 0A8BF
	ret

.ret:
	ret
	dec ax
	ret

loc_0A8C5:                                     ; 0A8C5
	cmp dl, [cs:xt_nccbs]
	jb loc_0A8CD
	ret

loc_0A8CD:                                     ; 0A8CD
	mov_bl_dl                                    ; 0A8CD
	sub bl, 4
	xor_bh_bh                                    ; 0A8D2
	shl bx, 1
	call word [cs:bx + xios_prn_table_3d3c]
	ret

xios_prn_table_3d3c:
		dw xios_prn_isr
		dw xios_prn_isr
		dw xios_prn_ret_3d46
		dw xios_prn_ret_3d46
xios_prn_state_word:
		dw xios_prn_fn_3d47
xios_prn_ret_3d46:
		ret

xios_prn_fn_3d47:
		push bx
		push cx
	mov dx, xios_prn_buf_3e12
	mov cl, 0x87
	call rtm_timer_wait2
	pop cx
	pop bx
	test ax, ax
	je loc_0A8FF
mov word [cs:xios_prn_state_word], xios_prn_ret_3d46
	ret

loc_0A8FF:                                     ; 0A8FF
mov word [cs:xios_prn_state_word], xios_prn_fn_3d66
xios_prn_fn_3d66:
	mov bl, [cs:xios_prn_flag_3d92]
	xor_bh_bh                                    ; 0A90B
	mov [cs:bx + xios_prn_buf_3d93], cl
	inc bx
	mov [cs:xios_prn_flag_3d92], bl
	cmp cl, 0xd
	je printer_wait_completion
	cmp bx, 0x7f
	je printer_wait_completion
	ret

printer_wait_completion:                                     ; 0A923
	mov dx, xios_prn_buf_3e12
	mov cl, 0x8b
	call rtm_timer_wait2
	mov byte [cs:xios_prn_flag_3d92], 0
	ret

xios_prn_flag_3d92:
	db 0x00
xios_prn_buf_3d93:
	times 127 db 0
xios_prn_buf_3e12:
	times 6 db 0
		dw xios_prn_flag_3d92
		db "NetConO "

xios_prn_isr:
	call sio_get_channel_b_struct
	pushf
	cli
	cmp word [bx + 0x12], 0
	jne loc_0A9DB
	push bx
	push cx
	or byte [bx + 0x1b], 4
	mov dx, [bx + 0x16]
	call rtm_timer_wait
	pop cx
	pop bx

loc_0A9DB:                                     ; 0A9DB
	mov si, [bx + 0x10]
	push es
	mov es, [bx + 0xa]
	mov [es:si], cl
	pop es
	inc word [bx + 0x10]
	mov ax, [bx + 0xc]
	dec ax
	and [bx + 0x10], ax
	dec word [bx + 0x12]
	test byte [bx + 0x1b], 1
	je loc_0A9FC
	call sio_tx_byte_from_buffer

loc_0A9FC:                                     ; 0A9FC
	popf
	ret

int28_fn_25_reserved:                   ; 0A9FE
	db 0x2E, 0x3A, 0x16                          ; 0A9FE  .:.

loc_0AA01:                                     ; 0AA01
	adc cl, [si]
	jae .ret
	mov_bl_dl                                    ; 0AA05
	sub bl, 4
	xor_bh_bh                                    ; 0AA0A
	cmp bx, 2
	jb loc_0AA12
.ret:                                     ; 0AA11
	ret

loc_0AA12:                                     ; 0AA12
	call sio_get_channel_b_struct
	pushf
	cli
	mov [bx + 0x1C], cl
	or byte [bx + 0x1b], 8
	test byte [bx + 0x1b], 1
	je loc_0AA27
	call sio_tx_byte_from_buffer

loc_0AA27:                                     ; 0AA27
	mov dx, [bx + 0x18]
	call rtm_timer_wait
	popf
	ret
	call xios_switch_to_priv_stack
	mov bx, xios_crt_buf_402f
	jmp short loc_0AA3D

xios_timer_isr:
	call xios_switch_to_priv_stack
	mov bx, xios_crt_param_4058

loc_0AA3D:                                     ; 0AA3D
	mov dx, [bx + 0x25]
	call pic_send_eoi_command
	call sio_tx_byte_from_buffer
	cmp word [bx + 0x12], 0
	je loc_0AA5F
	test byte [bx + 0x1b], 4
	je loc_0AA5F
	and byte [bx + 0x1b], 0xfb
	mov dx, [bx + 0x16]
	call rtm_call_helper
	jmp near xios_isr_exit_dispatch

loc_0AA5F:                                     ; 0AA5F
	jmp near xios_isr_exit_iret

sio_tx_byte_from_buffer:                                     ; 0AA62
	test byte [bx + 0x1b], 8
	je loc_0AA7B
	mov al, [bx + 0x1C]
	call sio_write_tx_data_reg
	and byte [bx + 0x1b], 0xf7
	push bx
	mov dx, [bx + 0x18]
	call rtm_call_helper
	pop bx
	ret

loc_0AA7B:                                     ; 0AA7B
	test byte [bx + 0x1b], 0x10
	je loc_0AA8B
	mov al, 0x13
	call sio_write_tx_data_reg
	and byte [bx + 0x1b], 0xef
	ret

loc_0AA8B:                                     ; 0AA8B
	test byte [bx + 0x1b], 0x20
	je loc_0AA9B
	mov al, 0x11
	call sio_write_tx_data_reg
	and byte [bx + 0x1b], 0xdf
	ret

loc_0AA9B:                                     ; 0AA9B
	test byte [bx + 0x1b], 2
	je loc_0AAA6
	or byte [bx + 0x1b], 1
	ret

loc_0AAA6:                                     ; 0AAA6
	mov ax, [bx + 0x12]
	cmp ax, [bx + 0xc]
	jne loc_0AAB3
	or byte [bx + 0x1b], 1
	ret

loc_0AAB3:                                     ; 0AAB3
	mov si, [bx + 0xe]
	push es
	mov es, [bx + 0xa]
	mov al, [es:si]
	pop es
	inc word [bx + 0xe]
	mov dx, [bx + 0xc]
	dec dx
	and [bx + 0xe], dx
	inc word [bx + 0x12]
	call sio_write_tx_data_reg
	ret

sio_write_tx_data_reg:                                     ; 0AACF
	mov dx, [bx + 0x23]
	out dx, al
	and byte [bx + 0x1b], 0xfe
	ret
	call xios_switch_to_priv_stack
	mov bx, xios_crt_buf_402f
	jmp near loc_0AAE7
	call xios_switch_to_priv_stack
	mov bx, xios_crt_param_4058

loc_0AAE7:                                     ; 0AAE7
	mov dx, [bx + 0x27]
	in al, dx
	mov [bx + 0x1E], al
	mov al, 0x10
	out dx, al

loc_0AAF1:                                     ; 0AAF1
	call pic_send_eoi_command
	jmp near xios_isr_exit_iret
	call xios_switch_to_priv_stack
	mov bx, xios_crt_buf_402f
	jmp near loc_0AB06

xios_serial_isr:
	call xios_switch_to_priv_stack
	mov bx, xios_crt_param_4058

loc_0AB06:                                     ; 0AB06
	mov dx, [bx + 0x23]
	in al, dx
	push ax
	call pic_send_eoi_command
	pop ax
	cmp byte [bx + 0x1d], 1
	jne loc_0AB5D
	push ax
	and ax, strict word 0x7f                     ; 0AB16  25 7F 00
	cmp al, 0x13
	pop ax
	jne loc_0AB25
	or byte [bx + 0x1b], 2

loc_0AB22:                                     ; 0AB22
	jmp near xios_isr_exit_iret

loc_0AB25:                                     ; 0AB25
	cmp al, 0x11
	jne loc_0AB3E
	test byte [bx + 0x1b], 2
	je loc_0AB22
	and byte [bx + 0x1b], 0xfd
	test byte [bx + 0x1b], 1
	je loc_0AB22
	call sio_tx_byte_from_buffer
	jmp short loc_0AB22

loc_0AB3E:                                     ; 0AB3E
	cmp word [bx + 8], 0x21
	jne loc_0AB5D
	or byte [bx + 0x1b], 0x10
	test byte [bx + 0x1b], 1
	je loc_0AB5D
	push ax
	push dx
	mov dx, PORT_ISBX_MCS0_02

loc_0AB53:                                     ; 0AB53
	in al, dx
	and al, 1
	je loc_0AB53
	pop dx
	call sio_tx_byte_from_buffer
	pop ax

loc_0AB5D:                                     ; 0AB5D
	cmp word [bx + 8], 0
	ja loc_0AB6A
	inc byte [cs:crt_timer_flag]
	jmp short loc_0AB22

loc_0AB6A:                                     ; 0AB6A
	mov si, [bx + 6]
	push es
	mov es, [bx]
	mov [es:si], al
	pop es
	inc word [bx + 6]
	mov ax, [bx + 2]
	dec ax
	and [bx + 6], ax
	dec word [bx + 8]
	test byte [bx + 0x1A], 4
	je loc_0AB22
	mov dx, [bx + 0x14]
	push bx
	call rtm_call_helper
	pop bx
	and byte [bx + 0x1A], 0xfb
	jmp near xios_isr_exit_dispatch
	call xios_switch_to_priv_stack
	mov bx, xios_crt_buf_402f
	jmp near loc_0ABA5
	call xios_switch_to_priv_stack
	mov bx, xios_crt_param_4058

loc_0ABA5:                                     ; 0ABA5
	mov dx, [bx + 0x25]
	mov al, 1
	out dx, al
	in al, dx
	mov [bx + 0x1f], al
	mov al, 0x30
	out dx, al
	jmp near loc_0AAF1

pic_send_eoi_command:                                     ; 0ABB5
	mov dx, PORT_PCB_EOI
	mov ax, 0x8000
	out dx, ax
	ret

sio_get_channel_b_struct:                                     ; 0ABBD
	mov dx, 2
	mov bx, xios_crt_param_4058
	ret

int28_fn_18_reserved:                   ; 0ABC4
	mov bx, xios_crt_param_4058
	mov [bx + 0x1d], dl
	ret
		dw xios_crt_buf_402f
		dw xios_crt_param_4058
xios_crt_buf_402f:
	times 20 db 0                                ; 0ABCF..0ABE1 (20 bytes padding)
	or ax, 0xe00
	add [bx + di], dl
	add [bx + di], al
	add [bx + si], ax
	db 0x00, 0x00                                ; 0ABEC
	db 0x00, 0x7f, 0x14, 0x00, 0xfe, 0x02, 0x00, 0x03, 0x00, 0x03
xios_crt_param_4058:
	dw 0x0000
xios_crt_param_405a:
	times 6 db 0
xios_crt_param_4060:
	dw 0x0000
xios_crt_param_4062:
	dw 0x0000
xios_crt_param_4064:
	times 6 db 0
xios_crt_param_406a:
	db 0x00
	add [di], cl
	add [0x1100], cl
	add [bx + di], al
	add [bx + si], ax
	db 0x00, 0x00                                ; 0AC15
	add [bx + 0x14], bh
	db 0x00, 0x00                                ; 0AC1A
	add ax, [bp + si]
	add ax, [bp + si]
	db 0x03                                      ; 0AC20
io_poll:                                       ; 0AC21
	cmp dl, 2
	jne loc_0AC41
	push dx

floppy_ack:                                    ; 0AC27
	mov dx, PORT_PRN_RESERVE
	mov al, 0xff
	out dx, al
	in al, dx
	and al, 0x80
	pop dx
	jne loc_0AC3A
	mov al, 0xff
	mov_bl_al                                    ; 0AC35
	jmp near loc_0AC5E

loc_0AC3A:                                     ; 0AC3A
	mov al, 0
	mov_bl_al                                    ; 0AC3C
	jmp near loc_0AC5E

loc_0AC41:                                     ; 0AC41
	cmp dl, 1
	jne loc_0AC5E
	push dx
	mov dx, PORT_FDC_RESERVE
	mov al, 0xff
	out dx, al
	in al, dx
	and al, 0x80
	pop dx
	jne loc_0AC5A
	mov al, 0xff
	mov_bl_al                                    ; 0AC55
	jmp near loc_0AC5E

loc_0AC5A:                                     ; 0AC5A
	mov al, 0
	mov_bl_al                                    ; 0AC5C

loc_0AC5E:                                     ; 0AC5E
	ret




io_list:
	push cx
	push dx
	call io_listst
	pop dx
	pop cx
	or_ax_ax                                     ; 0AC66
	jne loc_0ACA4
	push ds
	push es
	push cx
	push dx
	push cs
	pop ds
	mov si, [cs:sysdat_rlr]
	mov es, [si + PD_UDA]
	mov si, boot_msg_printer_retry
	call con_puts
	pop dx
	pop cx
	pop es
	pop ds
	cmp al, '1'
	je io_list
	cmp al, '2'
	jne loc_0AC9F
	push ds
	push es
	push cs
	pop ds
	mov bx, [cs:sysdat_rlr]
	mov es, [bx + PD_UDA]
	mov cx, 0x8f
	call rtm_timer_wait2
	pop es
	pop ds
	ret

loc_0AC9F:                                     ; 0AC9F
	cmp al, '3'
	jne io_list
	ret

loc_0ACA4:                                     ; 0ACA4
	cmp dl, 0
	je prn_centronics_out
	cmp dl, 2
	jne loc_0ACFC
	cli
	cmp byte [cs:xios_prn_reserve_flag], 0xff
	mov byte [cs:xios_prn_reserve_timer], 0xa
	sti
	je prn_dpc_out
	push cx
	call dpc_reserve_printer
	pop cx

; -----------------------------------------------------------------------------
; Ekstern DPC Parallel Printer Output
; Skriver tegn i CL til PORT_DPC_PRN_DATA (0x28A) og pulser STROBE via PORT_DPC_PRN_CTRL.
; -----------------------------------------------------------------------------
prn_dpc_out:
	mov dx, PORT_DPC_PRN_CTRL
	mov al, 8
	out dx, al
	mov dx, 0x19
	push cx
	call rtm_timer_wait
	pop cx
	mov_al_cl                                    ; 0ACD1
	mov dx, PORT_DPC_PRN_DATA
	out dx, al
	mov al, 0x89
	mov dx, PORT_DPC_PRN_CTRL
	out dx, al
	mov al, 0x88
	out dx, al
	cli
	push ds
	mov ds, [cs:xios_sysdat_segment_val]
	mov bx, xios_crt_table_4256
	mov al, [bx + 0x14]
	cmp al, 5
	jae loc_0ACF3
	mov al, 5

loc_0ACF3:                                     ; 0ACF3
	mov [cs:xios_prn_reserve_timer], al
	pop ds
	sti
	jmp near loc_0AD2F

loc_0ACFC:                                     ; 0ACFC
	cmp dl, 1
	jne loc_0AD2F
	mov bx, xios_crt_table_4256
	mov al, [bx + 0xd]
	and al, 0xf
	cmp al, 1
	jne loc_0AD2F
	mov dl, 5
	jmp near xios_prn_isr

; -----------------------------------------------------------------------------
; Lokal Centronics Parallel Printer Output
; Skriver tegn i CL til PORT_PRN_DATA (0x250) og pulser STROBE lav/høj via PORT_PRN_CTRL.
; -----------------------------------------------------------------------------
prn_centronics_out:
	mov dx, PORT_PRN_CTRL
	mov al, 8
	out dx, al
	mov dx, 0xc
	push cx
	call rtm_timer_wait
	pop cx
	mov_al_cl                                    ; 0AD20
	mov dx, PORT_PRN_DATA
	out dx, al
	mov al, 0x89
	mov dx, PORT_PRN_CTRL
	out dx, al
	mov al, 0x88
	out dx, al

loc_0AD2F:                                     ; 0AD2F
	ret

io_listst:
	cmp dl, 0
	je loc_0AD7B
	cmp dl, 2
	jne loc_0AD73
	cmp byte [cs:xios_prn_reserve_flag], 0xff
	je floppy_status_check
	mov byte [cs:xios_prn_pending_flag], 0xff
	call dpc_reserve_printer
	cli
	push ds
	mov ds, [cs:xios_sysdat_segment_val]
	mov bx, xios_crt_table_4256
	mov al, [bx + 0x14]
	cmp al, 5
	jae loc_0AD5E
	mov al, 5

loc_0AD5E:                                     ; 0AD5E
	mov [cs:xios_prn_reserve_timer], al
	pop ds
	sti

floppy_status_check:                           ; 0AD64
	mov dx, PORT_DPC_PRN_CTRL
	in al, dx
	test al, 0x10
	jne loc_0AD8B
	test al, 8
	je loc_0AD8B
	jmp near loc_0AD87

loc_0AD73:                                     ; 0AD73
	cmp dl, 1
	jne loc_0AD8B
	jmp near con_status_poll

loc_0AD7B:                                     ; 0AD7B
	mov dx, PORT_PRN_CTRL
	in al, dx
	test al, 0x10
	jne loc_0AD8B
	test al, 8
	je loc_0AD8B

loc_0AD87:                                     ; 0AD87
	mov ax, 0xffff
	ret

loc_0AD8B:                                     ; 0AD8B
	xor_ax_ax                                    ; 0AD8B
	ret

con_status_poll:                               ; 0AD8E
	mov dx, PORT_ISBX_MCS0_02
	in al, dx
	test al, 0x80
	mov ax, 0xffff
	jne .ret
	inc ax
.ret:                                     ; 0AD9A
	ret

i_printer:
xios_crt_isr_41fb:
	call xios_switch_to_priv_stack
	mov al, 0x80
	mov dx, PORT_PRN_CTRL
	out dx, al
	call eoi_helper
	mov dx, 0xc
	call rtm_call_helper
	jmp near xios_isr_exit_dispatch

xios_crt_isr:
	call xios_switch_to_priv_stack
	mov al, 0x80
	mov dx, PORT_DPC_PRN_CTRL
	out dx, al
	call eoi_helper
	mov dx, 0x19
	call rtm_call_helper
	jmp near xios_isr_exit_dispatch

xios_crt_table_4225:
	db 0x00, 0x00, 0x04, 0x00, 0x00, 0x80, 0x04, 0x00
	times 10 db 0
	db 0x00, 0x01, 0x01, 0x00
	times 27 db 0
xios_crt_table_4256:
	times 7 db 0
	db 0x66, 0x00, 0x47, 0xAA                    ; 0ADFD  add byte [bx - 0x56], al
	pop ss
	db 0x61                                      ; 0AE02  popa
	db 0x60                                      ; 0AE03  pusha
	inc di
	stosb
	pop ss
	db 0x61                                      ; 0AE07  popa
	db 0x10, 0xA1, 0x3C, 0x00                    ; 0AE08  adc byte [bx + di + 0x3c], ah
	times 4 db 0                                ; 0AE0C..0AE0E (4 bytes padding)
	db 0x02, 0x00                                ; 0AE10  add al, byte [bx + si]
	inc word [bx + si]
	times 98 db 0                                ; 0AE14..0AE74 (98 bytes padding)
int28_fn_03_get_nvram:                  ; 0AE76
	mov es, [cs:xios_sysdat_segment_val]
	mov si, xios_crt_table_4256
	ret

int28_fn_04_get_autoconfig:             ; 0AE7F
	mov es, [cs:xios_sysdat_segment_val]
	mov si, xios_crt_table_4225
	ret

int28_fn_32_reserved:                   ; 0AE88
	pushf
	cli
	mov [cs:xios_hook_timer_off], dx
	mov [cs:xios_hook_timer_seg], cx
	popf
	ret

int28_fn_33_reserved:                   ; 0AE96
	pushf
	cli
	mov ax, dummy_far_hook_ret
	mov [cs:xios_hook_timer_off], ax
	mov [cs:xios_hook_timer_seg], cs
	popf
	ret

int28_fn_34_reserved:                   ; 0AEA6
	pushf
	cli
	mov [cs:xios_hook_sec_off], dx
	mov [cs:xios_hook_sec_seg], cx
	popf
	ret
	pushf
	cli
	mov ax, dummy_far_hook_ret
	mov [cs:xios_hook_sec_off], ax
	mov [cs:xios_hook_sec_seg], cs
	popf
	ret

dummy_far_hook_ret:
	retf

xios_hook_timer_off:
	dw dummy_far_hook_ret
xios_fixup_target_1:
xios_hook_timer_seg:
	dw 0x0000                                    ; 0AEC7  Segment (fixed up at load time)
xios_hook_sec_off:
	dw dummy_far_hook_ret
xios_fixup_target_2:
xios_hook_sec_seg:
	dw 0x0000                                    ; 0AECB  Segment (fixed up at load time)
i_tick:
	call xios_switch_to_priv_stack
	inc word [cs:xios_tick_low]
	jne rtc_1sec_isr
	inc word [cs:xios_tick_high]

; -----------------------------------------------------------------------------
; Realtidsur (RTC) 1-Sekunds Afbrydelsesrutine (IR3 / Vektor 0x8C)
; Drevet af MM58167A:
; - Tæller floppy-motor timer ned (fdc_motor_timeout_tick / fdc_motor_timeout_tick).
; - Sender EOI via eoi_helper.
; - Signalerer CCP/M-86 Flag 2 ("Second"), som opdaterer systemtid og tidsstyring.
; -----------------------------------------------------------------------------
rtc_1sec_isr:
	mov byte [cs:crt_vsync_counter], 0
	call crt_check_cursor_blink_tick
	call fdc_motor_timeout_tick
	call fdc_recalibrate_all_drives
	call dpc_release_shared_devices
	mov bx, xios_crt_table_4225
	cmp byte [bx + 0xc], 0xff
	je loc_0AEFE
	mov al, 0x10
	call rtc_write_reg
	jmp short loc_0AF05

loc_0AEFE:                                     ; 0AEFE
	mov al, 7
	mov ah, 0xc4
	call rtc_write_reg_direct

loc_0AF05:                                     ; 0AF05
	call eoi_helper
	mov dx, 2
	call rtm_call_helper
	jmp near xios_isr_exit_iret

; -----------------------------------------------------------------------------
; Fælles End-Of-Interrupt (EOI) Hjælperutine
; Sender non-specific EOI (0x20) til ekstern Intel 8259A PIC (PORT_PIC_CMD 0x0000)
; og non-specific EOI (0x8000) til 80186 intern ICU (PORT_PCB_EOI 0xFF22).
; -----------------------------------------------------------------------------
eoi_helper:                                    ; 0AF11
	mov al, 0x20
	out PORT_PIC_CMD, al
	mov dx, PORT_PCB_EOI
	mov ax, 0x8000
	out dx, ax
	ret

xios_switch_to_priv_stack:                     ; 0AF1D
	pop word [cs:xios_tick_subcount]
	mov [cs:xios_saved_ss], ss
	mov [cs:xios_saved_sp], sp
	push cs
	pop ss
	mov sp, xios_saved_stack_guard
	push ds
	push es
	pusha                                        ; 0AF33  60
	mov ds, [cs:xios_sysdat_segment_val]
	jmp word [cs:xios_tick_subcount]

xios_isr_exit_dispatch:                                     ; 0AF3E
	popa                                         ; 0AF3E  61
	pop es
	pop ds
	mov ss, [cs:xios_saved_ss]
	mov sp, [cs:xios_saved_sp]
	jmp far [cs:sysdat_dispatcher]

xios_isr_exit_iret:                                     ; 0AF50
	popa                                         ; 0AF50  61
	pop es
	pop ds
	mov ss, [cs:xios_saved_ss]
	mov sp, [cs:xios_saved_sp]
	iret
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0AF5E  ................
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0AF6E  ................
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0AF7E  ................
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0AF8E  ................
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0AF9E  ................
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0AFAE  ................
xios_saved_stack_guard:
	dw 0x0000
xios_saved_ss:
	dw 0x0000
xios_saved_sp:
	dw 0x0000
xios_tick_subcount:
	dw 0x0000
xios_tick_low:
	dw 0x0000
xios_tick_high:
	dw 0x0000

rtc_write_reg_direct:                                     ; 0AFCA
	mov dx, PORT_RTC_ADDR
	and al, 0x1f
	out dx, al
	sub dx, 2
	xchg ah, al                                  ; 0AFD3  86 E0
	out dx, al
	xchg ah, al                                  ; 0AFD6  86 E0
	add dx, 2
	or al, 0x40
	out dx, al
	nop
	nop
	nop
	nop
	and al, 0x1f
	out dx, al
	ret

rtc_write_reg:                                     ; 0AFE6
	mov dx, PORT_RTC_ADDR
	or al, 0x80
	out dx, al
	or al, 0xa0
	out dx, al
	nop
	nop
	nop
	nop
	xchg ah, al                                  ; 0AFF3  86 E0
	in al, dx
	xchg ah, al                                  ; 0AFF6  86 E0
	and al, 0x9f
	out dx, al
	xchg ah, al                                  ; 0AFFB  86 E0
	ret

int28_fn_12_sound:                      ; 0AFFE
	mov_ah_dl                                    ; 0AFFE
	in al, PORT_SOUND
	call io_bus_delay
	xor_al_al                                    ; 0B005
	out PORT_RTC_ADDR, al
	call io_bus_delay
	xchg ah, al                                  ; 0B00C  86 E0
	out PORT_RTC_DATA, al
	call io_bus_delay
	out PORT_SOUND, al
	call io_bus_delay
	ret

; -----------------------------------------------------------------------------
; Bus-Genopretningsforsinkelse for langsomme NMOS/CMOS periferikredsløb
; (MM58167A RTC og SN76494 lydgenerator kræver settling time mellem I/O-adgange).
; -----------------------------------------------------------------------------
io_bus_delay:                                     ; 0B019
	mov cx, 0x1e

.delay_loop:                                     ; 0B01C
	loop .delay_loop
	ret

int28_fn_19_timer:                      ; 0B01F
	mov dx, [cs:xios_tick_high]
	mov ax, [cs:xios_tick_low]
	mov cl, [cs:crt_vsync_counter]
	xor_ch_ch                                    ; 0B02D
	mov_bx_ax                                    ; 0B02F
	ret

int28_fn_23_isbx_status:                ; 0B032
con_data_read:                                 ; 0B032
	mov dx, PORT_ISBX_MCS0_02
	in al, dx
	mov_bl_al                                    ; 0B036
	xchg al, ah                                  ; 0B038  86 C4
	xor_al_al                                    ; 0B03A
	shl ah, 1
	and ah, 0x70
	test bl, 1
	je loc_0B048
	or al, 0x20

loc_0B048:                                     ; 0B048
	test bl, 2
	je loc_0B04F
	or al, 1

loc_0B04F:                                     ; 0B04F
	test bl, 4
	je loc_0B056
	or al, 4

loc_0B056:                                     ; 0B056
	test bl, 0x80
	je .ret
	or al, 8
.ret:                                     ; 0B05D
	ret

int28_fn_50_isbx_reset:                 ; 0B05E
	mov al, 1
	call diag_format_error_record
	push cs
	push di
	mov ax, 0x18
	int 0x28
	add sp, 4
	ret

diag_format_error_record:                                     ; 0B06E
	mov di, xios_diag_buf_4573
	mov [di], al
	mov bx, xios_crt_table_4256
	or_al_al                                     ; 0B076
	jne loc_0B0C3
	mov byte [di + 1], 0
	mov byte [di + 2], 0
	mov al, [bx + 7]
	mov_ah_al                                    ; 0B085
	and al, 0xf0
	mov cl, 4
	shr al, cl
	mov [di + 3], al
	and ah, 0xf
	mov [di + 4], ah
	mov byte [di + 5], 4
	mov byte [di + 6], 4
	mov al, [bx + 9]
	mov [di + 7], al
	mov byte [di + 8], 5
	mov al, [bx + 0xa]
	mov [di + 9], al
	mov byte [di + 0xa], 1
	mov al, [bx + 0xb]
	mov [di + 0xb], al
	mov byte [di + 0xc], 3
	mov al, [bx + 0xc]
	mov [di + 0xd], al
	ret

loc_0B0C3:                                     ; 0B0C3
	mov al, [bx + 0xd]
	mov_ah_al                                    ; 0B0C6
	and al, 0xf
	mov [di + 1], al
	mov byte [di + 2], 0
	and ah, 0xf0
	mov cl, 4
	shr ah, cl
	mov [di + 3], ah
	mov [di + 4], ah
	mov byte [di + 5], 5
	mov byte [di + 6], 4
	mov al, [bx + 0xe]
	mov [di + 7], al
	mov byte [di + 8], 5
	mov al, [bx + 0xf]
	mov [di + 9], al
	mov byte [di + 0xa], 2
	mov byte [di + 0xb], 0x40
	mov byte [di + 0xc], 1
	mov al, [bx + 0x10]
	mov [di + 0xd], al
	mov byte [di + 0xe], 3
	mov al, [bx + 0x11]
	mov [di + 0xf], al
	ret

xios_diag_buf_4573:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0B113  ................
int28_fn_24_isbx_init:                  ; 0B123
	push bp
	mov_bp_sp                                    ; 0B124
	add bp, 2
	les di, [bp + 0xa]
	mov cl, [es:di]
	mov dl, [es:di + 2]
	call int28_fn_18_reserved
	mov bl, [es:di + 3]
	xor_bh_bh                                    ; 0B13A
	shl bx, 1
	mov ax, [cs:bx + xios_diag_fn_4695]
	push ax
	mov dx, PORT_ISBX_MCS1_06
	mov al, 0xb6
	out dx, al
	pop ax
	mov dx, PORT_ISBX_MCS1_04
	out dx, al
	xchg ah, al                                  ; 0B14F  86 E0
	out dx, al
	mov cl, [es:di + 5]
	xor_ch_ch                                    ; 0B156
	add di, 6
	cmp cx, 0
	je xios_jmp_entry
	mov bx, xios_crt_table_4256

xios_jmp_init:                                 ; 0B163
	jmp near xios_init

xios_jmp_entry:                                ; 0B166
	jmp near xios_entry_0x8C


xios_init:                                     ; 0B169
	mov al, [es:di]
	inc di
	mov ah, [es:di]
	inc di
	cmp al, 3
	jne loc_0B17A
	mov [bx + 0x11], ah
	jmp short loc_0B18A

loc_0B17A:                                     ; 0B17A
	cmp al, 4
	jne loc_0B183
	mov [bx + 0xe], ah
	jmp short loc_0B18A

loc_0B183:                                     ; 0B183
	cmp al, 5
	jne loc_0B18A
	mov [bx + 0xf], ah

loc_0B18A:                                     ; 0B18A
	loop xios_init
	mov dx, PORT_ISBX_MCS0_02
	mov al, 2
	out dx, al
	nop
	nop
	nop
	out dx, al
	nop
	nop
	nop
	add al, 0x40
	out dx, al
	push bx
	mov al, [bx + 0xe]
	mov bl, [bx + 0x11]
	mov cl, 6
	shr bl, cl
	cmp bl, 1
	je loc_0B1B5
	cmp bl, 2
	jne loc_0B1B7
	mov bl, 1
	jmp short loc_0B1B7

loc_0B1B5:                                     ; 0B1B5
	mov bl, 2

loc_0B1B7:                                     ; 0B1B7
	mov cl, 2
	shl bl, cl
	or bl, 2
	mov cl, 4
	shl al, cl
	or_al_bl                                     ; 0B1C2
	out dx, al
	pop bx
	mov al, [bx + 0x11]
	mov cl, 2
	shl al, cl
	mov bl, [bx + 0xf]
	test bl, 0x80
	je loc_0B1D7
	or al, 2

loc_0B1D7:                                     ; 0B1D7
	test bl, 0x10
	je loc_0B1DE
	or al, 8

loc_0B1DE:                                     ; 0B1DE
	test bl, 8
	je loc_0B1E5
	or al, 1

loc_0B1E5:                                     ; 0B1E5
	test bl, 2
	je loc_0B1EC
	or al, 0x20

loc_0B1EC:                                     ; 0B1EC
	or al, 0x10
	out dx, al

xios_entry_0x8C:                               ; 0B1EF
	pop bp
	ret

xios_diag_fn_4651:
	test al, 3
	db 0x70, 0x02                                ; 0B1F3  jo 0xb1f7
	stosb
	add [bx + si], di
	add [si + 0x4e00], bx
	add [bx], ah
	add [bp + di], dl
	add [bp + si], cl
	add [di], al
	add [di], al
	db 0x00                                      ; 0B206
xios_diag_fn_4667:
	db 0xE0                                      ; 0B207 (add al, ah opcode 00 E0)
	add al, 0x40
	add di, [bx + si]
	add ah, [bx + si - 0x2fff]
	db 0x00, 0x68, 0x00                          ; 0B210  add byte [bx + si], ch
	xor al, 0
	sbb al, [bx + si]
	or ax, 0x600
	add [bp + di], al
	db 0x00
xios_diag_ptr_467d:
	dw xios_diag_fn_4651
	mov [bp + di], dl
	add ax, 0xe10d
	or [bp + di + 0x4106], al
	add sp, [bx + si - 0x2fff]
	db 0x00, 0x68, 0x00                          ; 0B22C  add byte [bx + si], ch
	xor al, 0
	sbb al, [bx + si]
	db 0x0D, 0x00                                ; 0B233 (or ax, strict word 0 opcode 0D 00 00)
xios_diag_fn_4695:
	db 0x00                                      ; 0B235
	add al, 0
	add al, 0xba
	db 0x02, 0x00                                ; 0B23A  add al, byte [bx + si]
	db 0x02, 0x00                                ; 0B23C  add al, byte [bx + si]
	add [bx + si + 0x4000], ax
	add [bx + si], ah
	add [bx + si], dl
	add [bx + si], cl
	db 0x00                                      ; 0B248
xios_diag_fn_46a9:
	db 0xF3                                      ; 0B249 (add bl, dh opcode 00 F3)
	movsb
	iret

xios_diag_fn_46ac:
	rep movsw
	iret

loc_0B24F:                                     ; 0B24F
	push bx
	call far [cs:xios_hook_sec_off]
	pop bx
	stc
	jmp far [cs:xios_diag_hook_46bc]

xios_diag_hook_46bc:
	db 0x00, 0x00, 0xFF                          ; 0B25C  ...
	db 0xFF                                      ; 0B25F (call far [0x8e2e] opcode FF 1E 2E 8E)
xios_diag_hook_target_46c0:
	db 0x1E, 0x2E, 0x8E                          ; 0B260
	push ds
	push es
	or al, 0x2e
	mov [xios_saved_ss], ss
	mov [cs:xios_saved_sp], sp
	mov ss, [cs:xios_sysdat_segment_val]
	mov sp, xios_saved_stack_guard
	push ax
	push bx
	push si
	xor_ax_ax                                    ; 0B27B
	call eoi_helper
	mov bx, [cs:sysdat_openvec]
	test bx, bx
	je loc_0B29D
	mov si, xios_diag_buf_4710
	mov al, [si + 2]
	test al, 0x3a
	jne loc_0B29D
	and word [bx + 6], strict word 0xfffd        ; 0B293  81 67 06 FD FF
	or word [bx + 6], 0x80

loc_0B29D:                                     ; 0B29D
	mov byte [si + 2], 0
	pop si
	pop bx
	pop ax
	mov ss, [cs:xios_saved_ss]
	mov sp, [cs:xios_saved_sp]
	pop ds
	iret

xios_diag_buf_4710:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0B2B0  ..............
xios_int3_handler:
	cli
	mov ax, cs
	mov es, ax
	mov ds, ax
	mov si, [cs:sysdat_rlr]
	mov bp, [si + PD_UDA]
	lea si, [si + PD_NAME]
	mov di, xios_diag_slot_process
	mov cx, 4
	rep movsw
	pop ax
	sub ax, strict word 1                        ; 0B2D9  2D 01 00
	mov di, xios_diag_slot_int_num
	call hex_to_ascii_word
	pop ax
	pop ax
	pop ax
	mov di, xios_diag_slot_ip
	call hex_to_ascii_word
	pop ax
	mov di, xios_diag_slot_cs
	call hex_to_ascii_word
	mov si, xios_diag_str_interrupt
	mov es, bp
	call con_puts
	mov bx, [cs:sysdat_rlr]
	and word [bx + PD_FLAG], 0xfdfd
	mov cx, 0x8f
	mov dx, 0xffff
	jmp near rtm_timer_wait2

xios_diag_str_interrupt:
	db 0x22, "Interrupt="
xios_diag_slot_int_num:
	times 6 db " "
xios_diag_slot_process:
	times 9 db " "
xios_diag_slot_cs:
	db "    :"
xios_diag_slot_ip:
	db "    "

hex_to_ascii_word:                                     ; 0B330
	cld
	push ax
	mov_al_ah                                    ; 0B332
	call hex_to_ascii_byte
	pop ax

hex_to_ascii_byte:                                     ; 0B338
	push ax
	mov cl, 4
	shr al, cl
	call hex_to_ascii_nibble
	pop ax

hex_to_ascii_nibble:                                     ; 0B341
	and al, 0xf
	add al, 0x90
	daa                                          ; 0B345
	adc al, 0x40
	daa                                          ; 0B348
	stosb
	ret
; =============================================================================
; RC759 Piccoline Skærmtrimning & Diagnostic Menu (0x0B34B - 0x0B4FC)
; =============================================================================
xios_vmenu_title:
	db 0x14, 0x20, 0xFF                          ; 0B34B
	db_dk "759 SKÆRMTRIMNING "
xios_vmenu_str_blink:
	db 0x0C                                      ; 0B361
	db_dk "Markør Blink"
xios_vmenu_str_height:
	db 0x0C                                      ; 0B36E
	db_dk "Markør Højde"
xios_vmenu_str_scroll:
	db 0x0C                                      ; 0B37B
	db_dk "Blød Rulning"
xios_vmenu_str_color:
	db 0x0E                                      ; 0B388
	db_dk "Standard Farve"
xios_vmenu_str_blank:
	db 0x0E                                      ; 0B397
	db_dk "Sluk Skærm"
	db "    "
xios_vmenu_opt_sort:
	db "sort   "
xios_vmenu_opt_blue:
	db_dk "blå    "
xios_vmenu_opt_green:
	db_dk "grøn   "
xios_vmenu_opt_cyan:
	db "cyan   "
xios_vmenu_opt_red:
	db_dk "rød    "
xios_vmenu_opt_magenta:
	db "magenta"
xios_vmenu_opt_yellow:
	db "gul    "
xios_vmenu_opt_white:
	db "hvid   "
xios_vmenu_opt_no:
	db "NEJ "
xios_vmenu_opt_yes:
	db "JA  "
xios_vmenu_str_console:
	db " Konsol="
xios_vmenu_buf_484d:
	db 0x00, " "
xios_vmenu_buf_484f:
	times 8 db 0x00
	db " "
xios_vmenu_buf_4858:
	times 8 db 0x00
	db " "
xios_vmenu_buf_4861:
	db 0x00
xios_vmenu_buf_4862:
	times 16 db 0x00
	db " "
xios_vmenu_buf_4873:
	times 3 db 0x00
xios_vmenu_buf_4876:
	times 5 db 0x00
	db " "
xios_vmenu_str_printer:
	db "Skriver="
xios_vmenu_buf_4884:
	db 0x00, 0x00, " "
xios_vmenu_buf_4887:
	times 4 db 0x00
	db " "
xios_vmenu_str_time:
	db "00:00:00 "
xios_vmenu_opt_dynamic:
	db "Dynamisk"
xios_vmenu_opt_buffered:
	db "Bufferet"
xios_vmenu_opt_buffer:
	db "Buffer  "
xios_vmenu_opt_locked:
	db_dk "Låst    "
xios_vmenu_opt_lock:
	db_dk "LÅS "
xios_vmenu_buf_48b9:
	times 51 db " "                              ; 0B458
	db_dk "- Tryk på en tast            "        ; 0B48C
xios_vmenu_line_buf_4909:
	times 80 db 0                                ; 0B4A9
xios_boot_msg_dollar:
	db "$ **"                                    ; 0B4F9

; =============================================================================
; RC759 Piccoline XIOS Status- og Fejlbeskeder (0x0B4FD - 0x0B5E0)
; =============================================================================
	db_dk " Venter på fælles diskettestation"     ; 0B4FD
xios_boot_msg_shared_prn1:
%if NUM_VIR_CONS == 4
	db 0x1C
	db_dk " ** Venter på fælles skriver"
%else
	db 0x1C                                      ; 0B521
	db_dk " ** Venter på fælles skriver1"
	db_dk "** Kun 1 konsol - Vinduesstyring ikke installeret"  ; 0B53E
%endif
boot_msg_printer_not_ready:
	db 0x15                                      ; 0B570
	db_dk " ** Skriver ikke klar"
boot_msg_printer_reserved:
	db 0x16                                      ; 0B586
	db_dk " ** Skriver Reserveret"
boot_msg_graphics_reserved:
	db 0x1A                                      ; 0B59D
	db_dk " ** Grafikskærm reserveret"
boot_msg_printer_retry:
	db_dk "2 ** Skriver ikke klar. 1=gentag,2=afbryd,3=ignorer"  ; 0B5B6

; =============================================================================
; RC759 Piccoline Boot Banner & Hardware Rapport (0x0B5E1 - 0x0B79D)
; =============================================================================
xios_boot_banner:
	db_dk "PICCOLINE XIOS version 2.3 - Marts 1985 "  ; 0B5E1
	db 0x0D, 0x0A, 0x0A
boot_msg_main_memory:
	db_dk "      K bytes hoved lager"            ; 0B613
	db 0x0D, 0x0A, 0
boot_msg_user_memory:
	db_dk "      K bytes bruger lager"           ; 0B62F
	db 0x0D, 0x0A, 0
boot_msg_floppy_drives:
	db_dk "      Diskette station(er)"           ; 0B64C
	db 0x0D, 0x0A, 0
boot_msg_winchester_drives:
	db_dk "      Winchester disk station(er)"    ; 0B669
	db 0x0D, 0x0A, 0
boot_msg_data_buffers:
	db_dk "      Data buffer(e)"                 ; 0B68D
	db 0x0D, 0x0A, 0
boot_msg_dir_buffers:
	db_dk "      Katalog buffer(e)"              ; 0B6A4
	db 0x0D, 0x0A, 0
boot_msg_mdisk_kbytes:
	db_dk "      K bytes M-disk"                 ; 0B6BE
	db 0x0D, 0x0A, 0
boot_msg_mdisk_low_mem:
	db_dk "  *** For lidt lager til M-disk"      ; 0B6DA
	db 0x0D, 0x0A, 0
boot_msg_crlf_lan:
	db 0x0D, 0x0A                                ; 0B6F7
	db_dk "Lokalnet adaptor installeret"
	db 0x0D, 0x0A, 0
boot_msg_crlf_fpu:
	db 0x0D, 0x0A                                ; 0B718
	db_dk "Numerisk Regneenhed installeret"
	db 0x0D, 0x0A, 0
	db_dk "Winchester disk  X er ikke initialiseret"  ; 0B73A
xios1_screen_state_buf:
	db 0x0D, 0x0A, 0
	db_dk "Winchester disk  x har dårlig konfigurations sektor"  ; 0B765
	db 0x0D, 0x0A, 0
loc_0B79D:
%if NUM_VIR_CONS == 4
	times 71 db 0
xios4_clip_map:
	times (3300 - 71) db 0
%else
	times 500 db 0
%endif

crt_init_hardware_display:                                     ; 0B991
	push cs
	pop ds
	cld
mov bx, xios_crt_table_4225
	mov dx, [bx + 0xa]
	mov cl, 0xc
	shl dx, cl
	mov es, dx
	mov di, [bx + 8]
	mov byte [es:di + 1], 5
	mov dx, cs
mov ax, fdc_drive_type_0
	call crt_calc_20bit_phys_addr
	add di, 0xe
	stosw
	mov_ax_cx                                    ; 0B9B4
	stosw

crt_mode_switch:                               ; 0B9B7
	mov dx, PORT_CRT_CA
	out dx, al
	push cs
	pop es
mov di, fdc_drive_dph_0
mov ax, fdc_drive_dph_1
	call crt_dma_make_phys_desc
mov ax, fdc_drive_dph_2
	call crt_dma_make_phys_desc
mov di, fdc_drive_0_dpb_ptr
mov ax, fdc_dpb_standard
	call crt_dma_make_phys_desc
mov ax, fdc_param_6142
	call crt_dma_make_phys_desc
mov ax, fdc_dpb_3_ptr
	push ax
mov di, fdc_drive_dph_1
	call crt_dma_make_phys_desc
	pop ax
mov di, fdc_drive_dph_2
	call crt_dma_make_phys_desc
mov ax, [cs:xios_vram_base_seg]
	mov es, ax
	xor_di_di                                    ; 0B9F2
	mov cx, 0x4000
	mov ax, 0xff
	rep stosw
	push ds
mov ax, [cs:xios_vram_base_seg]
	mov es, ax
lds bx, [cs:xios_crt_font_ptr]
	lds si, [bx]
	lodsb

loc_0BA0B:                                     ; 0BA0B
	mov cl, 5
	xor_ah_ah                                    ; 0BA0D
	shl ax, cl
	mov_di_ax                                    ; 0BA11
	mov cx, 0xa
	mov al, 0xff

loc_0BA18:                                     ; 0BA18
	mov ah, [si]
	stosw
	inc si
	loop loc_0BA18
	lodsb
	or_al_al                                     ; 0BA1F
	jne loc_0BA0B
	push es
	push ds
	push cs
	pop ds
	mov al, 0x33
	mov cx, 0x97
mov dx, int_vec_backup_97
	int 0x28
	mov cx, 0x98
	mov al, 0x33
mov dx, int_vec_backup_98
	int 0x28
	mov al, 0x34
	mov cx, 0x97
mov dx, int_vec_backup_98
	int 0x28
	mov al, 0x34
	mov cx, 0x98
mov dx, int_vec_backup_97
	int 0x28
	pop ds
	pop es
	mov ax, es
	mov ds, ax
	xor_si_si                                    ; 0BA55
	mov di, 0x2000
	mov cx, 0x3000
	rep movsw
	pop ds
mov bx, xios_crt_table_4225
	test byte [bx + 0x12], 1
	jne loc_0BA8B
mov byte [cs:xios_is_color_display], 0xff
mov byte [cs:xios_default_fg_color], 0x38
mov bx, xios_crt_table_4256
	mov al, [bx + 0x16]
	mov cl, 4
	rol al, cl
	and al, 0xf0
	jne loc_0BA85
	mov al, 0x60

loc_0BA85:                                     ; 0BA85
mov [cs:xios_default_bg_color], al
	jmp short loc_0BA92

loc_0BA8B:                                     ; 0BA8B
mov word [cs:vmenu_item_table + 8], 0; 0BA8B  mov word [cs:0x12af], 0

loc_0BA92:                                     ; 0BA92
mov bx, xios_crt_table_4256
	mov al, [bx + 0x13]
	mov_dl_al                                    ; 0BA98
	and al, 1
mov [cs:xios_crt_50hz_60hz_flag], al
	mov cl, 4
	shr dl, cl
	dec dl
	cmp dl, 9
	jbe loc_0BAAD
	mov dl, 9

loc_0BAAD:                                     ; 0BAAD
mov [cs:xios_font_height_scanlines], dl
	mov al, 0xa
	mov ah, 9
	sub_ah_dl                                    ; 0BAB6
mov [cs:fdc_dpb_current_format], ax
	mov al, 0
	test byte [bx + 0x12], 0xf0
	je loc_0BAC6
	mov al, 1

loc_0BAC6:                                     ; 0BAC6
mov [cs:xios_crt_font_alt_flag], al
	mov dx, [cs:xt_alloc]
mov [cs:xios_sysdat_segment_ptr], dx
	mov es, dx
mov cx, NUM_VIR_CONS
	mov bx, ccb_console_0                        ; Konsol 0 CCB
	mov di, 0xf00

loc_0BADF:                                     ; 0BADF
	xor_si_si                                    ; 0BADF
	push cx
	mov cx, 0x1a
	mov [bx + CCB_LINE_TABLE], di

loc_0BAE8:                                     ; 0BAE8
	mov [bx + si], di
	push cx
	mov cx, 0x50
	mov ax, 0x820
	cld
	rep stosw
	inc si
	inc si
	pop cx
	loop loc_0BAE8
	push di
	call palette_init_default_colors
mov al, [cs:xios_default_bg_color]
	mov [bx + CCB_CHAR_ATTR], al
	or byte [bx + CCB_FLAGS], CCB_FLG_ATTR_DIRTY
	shr al, 4
	mov [bx + CCB_VIDEO_MODE], al
mov al, [cs:xios_crt_font_alt_flag]
	mov [bx + CCB_SCROLL_MODE], al
mov al, [cs:xios_crt_50hz_60hz_flag]
	mov [bx + CCB_BLINK_FLAG], al
mov ax, [cs:fdc_dpb_current_format]
	mov [bx + 0x72], ax
	pop di
	add bx, 0x94
	pop cx
	loop loc_0BADF
	push ds
	pop es
%if NUM_VIR_CONS == 4
	mov di, xios4_clip_map
	mov cx, 0x780
	mov al, 0xf
	rep stosb
%endif
	mov di, window_zorder_list
	mov cx, ZORDER_LIST_SIZE
	xor_al_al
	rep stosb
	mov di, window_zorder_list
	mov dx, NUM_VIR_CONS - 1

loc_0BB3E:                                     ; 0BB3E
	mov_bx_dx                                    ; 0BB3E
	shl bx, 1
mov bx, [cs:bx + xios_ccb_table]
	call window_zorder_update_table
	dec dl
	jns loc_0BB3E
mov di, xios_screen_state_buf
	push di
	xor_ax_ax                                    ; 0BB52
	mov cx, 0x1c8
	rep stosw
	pop di
	add di, 0xf0
mov si, kbd_init_seq
	mov cx, 0x34
	rep movsb

loc_0BB66:                                     ; 0BB66
cmp byte [cs:fdc_drive_type_0], 1
	je loc_0BB66
	mov ah, 4
	call xios_crt_trigger_ca
	mov ah, 6
	call xios_crt_trigger_ca
	mov bx, ccb_console_0                        ; Konsol 0 CCB
	call crt_switch_active_window
	call io_statline_clear
	mov dx, PORT_PCB_T1_CON
	mov ax, 0x200
	sub dx, 2
	out dx, ax
	sub dx, 2
	out dx, ax
	ret

kbd_init_seq:
	db 0x1B, 0x48, 0x00                          ; 0BB90  sbb cx, word [bx + si]
	add [bp + di], bl
	inc cx
	times 10 db 0                                ; 0BB96..0BB9E (10 bytes padding)
	db 0x1B, 0x44, 0x00                          ; 0BBA0  sbb ax, word [si]
	add [di], cl
	db 0x00, 0x00                                ; 0BBA5
	add [bp + di], bl
	inc bx
	times 10 db 0                                ; 0BBAA..0BBB2 (10 bytes padding)
	db 0x1B, 0x42, 0x00                          ; 0BBB4  sbb ax, word [bp + si]
	add [bx + di], cl
	db 0x00, 0x00                                ; 0BBB9
	add [bx + CCB_TRACKING_MODE], bh
	db 0x00, 0x00                                ; 0BBBE
	jg loc_0BBC2

loc_0BBC2:                                     ; 0BBC2
	db 0x00, 0x00                                ; 0BBC2
int_vec_backup_97:
	times 32 db 0                                ; 0BBC4..0BBE2 (32 bytes padding)
int_vec_backup_98:
	times 32 db 0                                ; 0BBE4..0BC02 (32 bytes padding)
rtc_time_buf_seg:
	dw 0x0000                                    ; 0BC04 (CS:5064)
rtc_time_buf_val:
	db 0x00                                      ; 0BC06 (CS:5066)
rtc_day_of_year:
	dw 0x0000                                    ; 0BC07 (CS:5067)
rtc_is_leap_year:
	db 0x00                                      ; 0BC09 (CS:5069)
rtc_cur_day:
	db 0x01                                      ; 0BC0A (CS:506A)
rtc_cur_month:
	db 0x01                                      ; 0BC0B (CS:506B)
rtc_cur_year:
	db 0x00                                      ; 0BC0C (CS:506C)
rtc_days_in_month_norm:
	db 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ; 0BC0D (CS:506D)
rtc_days_in_month_leap:
	db 0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ; 0BC1A (CS:507A)
rtc_spare_buf_5087:
	times 12 db 0x00                             ; 0BC27 (CS:5087)
rtc_timer_params:
	db 0x04, 0x00, 0x0C, 0x00, 0x84, 0x03        ; 0BC33 (CS:5093)

rtc_read_current_date_time:                                     ; 0BC39
	push es
	mov ax, [cs:xios_sysdat_segment_val]
	mov es, ax
	mov bx, 0
	mov al, 2
	call rtc_write_reg
	mov [es:bx + 0x82], al
	mov al, 3
	call rtc_write_reg
	mov [es:bx + 0x81], al
	mov al, 4
	call rtc_write_reg
	mov [es:bx + 0x80], al
	mov al, 7
	call rtc_write_reg
	call bcd_to_binary_byte
mov [cs:rtc_cur_month], al
	mov al, 6
	call rtc_write_reg
	call bcd_to_binary_byte
mov [cs:rtc_cur_day], al
	pop es
	ret

bcd_to_binary_byte:                                     ; 0BC7B
	mov_ah_al                                    ; 0BC7B
	and ah, 0xf0
	mov cl, 4
	shr ah, cl
	and al, 0xf
	aad 10                                       ; 0BC86
	ret

rtc_set_current_date_time:                                     ; 0BC89
	push es
	mov ax, [cs:xios_sysdat_segment_val]
	mov es, ax
	mov bx, 0
	mov al, 2
	call rtc_write_reg
	mov [es:bx + 0x82], al
	mov al, 3
	call rtc_write_reg
	mov [es:bx + 0x81], al
	mov al, 4
	call rtc_write_reg
	and al, 0x7f
	mov [es:bx + 0x80], al
	mov al, 6
	call rtc_write_reg
	call bcd_to_binary_byte
mov [cs:rtc_cur_month], al
	mov al, 5
	call rtc_write_reg
	call bcd_to_binary_byte
mov [cs:rtc_cur_day], al
	pop es
	ret

nvram_read_byte:                                     ; 0BCCD
	push dx
	push bx
	push cx
	push ax
	call nvram_write_byte
	mov_bl_al                                    ; 0BCD4
	mov ah, 0
	mov al, 0
	call nvram_write_byte
	mov_bh_al                                    ; 0BCDD
	pop ax
	push ax
	call ppi_set_nvram_bank
	pop ax
	mov dx, PORT_NVRAM_BASE
	shl al, 1
	shl al, 1
	xor_ah_ah                                    ; 0BCEC
	add_dx_ax                                    ; 0BCEE
	pop cx
	push cx
	mov_al_cl                                    ; 0BCF2
	mov cl, 4
	shr al, cl
	out dx, al
	pop cx
	mov_al_cl                                    ; 0BCFA
	and al, 0xf
	add dx, 2
	out dx, al
	sub_bl_cl                                    ; 0BD02
	add_bh_bl                                    ; 0BD04
	mov ah, 0
	call ppi_set_nvram_bank
	mov dx, PORT_NVRAM_BASE
	mov_al_bh                                    ; 0BD0E
	mov cl, 4
	shr al, cl
	out dx, al
	mov_al_bh                                    ; 0BD15
	and al, 0xf
	add dx, 2
	out dx, al
	pop bx
	pop dx
	ret

nvram_write_byte:                                     ; 0BD20
	push dx
	push cx
	push ax
	call ppi_set_nvram_bank
	mov dx, PORT_NVRAM_BASE
	pop ax
	shl al, 1
	shl al, 1
	xor_ah_ah                                    ; 0BD2E
	add_dx_ax                                    ; 0BD30
	in al, dx
	add dx, 2
	xchg ah, al                                  ; 0BD36  86 E0
	in al, dx
	mov cl, 4
	shl ah, cl
	and al, 0xf
	or_al_ah                                     ; 0BD3F
	pop cx
	pop dx
	ret

ppi_set_nvram_bank:                                     ; 0BD44
	mov dx, PORT_PPI_PORTC
	in al, dx
	and al, 0xcf
	mov cl, 4
	shl ah, cl
	or_al_ah                                     ; 0BD4E
	out dx, al
	ret

xios_init_entry:
	cli
	cld
mov [cs:rtc_time_buf_seg], es
	mov si, 0x50
mov di, xios_crt_table_4225
	push ds
	pop es
	push ds
	xor_ax_ax                                    ; 0BD62
	mov ds, ax
	mov cx, 0x30
	cld
	rep movsb
	pop ds
	mov ax, 0
	mov bl, 0
	mov bh, 3
	mov cx, 0x20

loc_0BD77:                                     ; 0BD77
	push ax
	call nvram_write_byte
	add_bl_al                                    ; 0BD7B
	pop ax
	inc al
	loop loc_0BD77
	inc ah
	mov al, 0
	mov cx, 0x20
	dec bh
	jne loc_0BD77
	cmp bl, 0xaa
	jne loc_0BDAF
mov bx, xios_crt_table_4256
	mov ax, 0

loc_0BD98:                                     ; 0BD98
	push ax
	call nvram_write_byte
	mov [bx], al
	inc bx
	pop ax
	inc al
	cmp al, ' '
	jne loc_0BD98
	mov al, 0
	inc ah
	cmp ah, 4
	jne loc_0BD98

loc_0BDAF:                                     ; 0BDAF
	mov ah, 3
	call ppi_set_nvram_bank
mov bx, xios_crt_table_4225
	and byte [bx + 0x17], 0xdf
	cmp byte [bx + 0x17], 0x50
	jne loc_0BDDA
	xor_ax_ax                                    ; 0BDC1
	push ds
	pop es
mov di, rtc_spare_buf_5087
	mov cx, 3
mov bx, rtc_timer_params

loc_0BDCE:                                     ; 0BDCE
	mov si, [bx]
	push ds
	mov ds, ax
	movsw
	movsw
	pop ds
	inc bx
	inc bx
	loop loc_0BDCE

loc_0BDDA:                                     ; 0BDDA
	xor_ax_ax                                    ; 0BDDA
	mov_di_ax                                    ; 0BDDC
	mov es, ax
	mov bx, cs
	mov ax, xios_int3_padding                    ; Start af int3 padding
	mov cl, 4
	shr ax, cl
	add_bx_ax                                    ; 0BDE9
	xor_ax_ax                                    ; 0BDEB
	mov cx, 0x100

loc_0BDF0:                                     ; 0BDF0
	stosw
	inc ax
	xchg bx, ax
	stosw
	xchg bx, ax
	loop loc_0BDF0
mov bx, xios_crt_table_4225
	and byte [bx + 0x17], 0xdf
	cmp byte [bx + 0x17], 0x50
	jne loc_0BE16
	xor_ax_ax                                    ; 0BE04
	mov es, ax
	mov cx, 3
mov bx, rtc_timer_params

loc_0BE0E:                                     ; 0BE0E
	mov di, [bx]
	movsw
	movsw
	inc bx
	inc bx
	loop loc_0BE0E

loc_0BE16:                                     ; 0BE16
mov bx, xios_crt_table_4225
	and byte [bx + 0x17], 0xdf
	cmp byte [bx + 0x17], 0x50
	je loc_0BE2F
	mov bx, cs
	mov di, 0xc
mov ax, xios_int3_handler
	stosw
	mov_ax_bx                                    ; 0BE2C
	stosw

loc_0BE2F:                                     ; 0BE2F
	mov bx, cs
	mov di, 8
mov ax, xios_nmi_handler
	stosw
	mov_ax_bx                                    ; 0BE38
	stosw
	mov di, 0x28
mov ax, fdc_int10_handler
	stosw
	mov_ax_bx                                    ; 0BE42
	stosw
	mov di, 0x2c
mov ax, fdc_int11_handler
	stosw
	mov_ax_bx                                    ; 0BE4C
	stosw
	mov di, 0x34
mov ax, xios_serial_isr
	stosw
	mov_ax_bx                                    ; 0BE56
	stosw
	mov di, 0x3c
mov ax, xios_timer_isr
	stosw
	mov_ax_bx                                    ; 0BE60
	stosw
	mov di, 0x80
mov ax, fdc_transfer_isr
	stosw
	mov_ax_bx                                    ; 0BE6A
	stosw
	mov di, 0x84
	mov ax, 0xef3
	stosw
	mov_ax_bx                                    ; 0BE74
	stosw
	mov di, 0x8c
mov ax, i_tick
	stosw
	mov_ax_bx                                    ; 0BE7E
	stosw
	mov di, 0x88
mov ax, xios_crt_isr
	stosw
	mov_ax_bx                                    ; 0BE88
	stosw
	mov di, 0x90
	mov ax, 0x105a
	stosw
	mov_ax_bx                                    ; 0BE92
	stosw
	mov di, 0x98
mov ax, xios_crt_isr_41fb
	stosw
	mov_ax_bx                                    ; 0BE9C
	stosw
	mov di, 0x9c
mov ax, xios_crt_isr_41fb
	stosw
	mov_ax_bx                                    ; 0BEA6
	stosw
	mov di, 0x388
mov ax, xios_diag_fn_46a9
	stosw
	mov_ax_bx                                    ; 0BEB0
	stosw
	mov di, 0x38c
mov ax, xios_diag_fn_46ac
	stosw
	mov_ax_bx                                    ; 0BEBA
	stosw
	mov di, 0xa0
	mov ax, 0xc91
	stosw
	mov_ax_bx                                    ; 0BEC4
	stosw
mov [cs:xios_hook_sec_seg], cs
mov [cs:xios_hook_timer_seg], cs
mov bx, xios_crt_table_4225
	cmp byte [bx + 0xc], 0xff
	je loc_0BEE6
	mov ah, 4
	mov al, 0x11
	call rtc_write_reg_direct
	call rtc_read_current_date_time
	jmp short loc_0BEF3

loc_0BEE6:                                     ; 0BEE6
	mov dx, PORT_RTC_ADDR
	mov al, 7
	mov ah, 0xc4
	call rtc_write_reg_direct
	call rtc_set_current_date_time

loc_0BEF3:                                     ; 0BEF3
mov word [cs:rtc_day_of_year], 0; 0BEF3  mov word [cs:0x5067], 0
mov bx, xios_crt_table_4256
	mov al, [bx + 0x18]
	call bcd_to_binary_byte
mov [cs:rtc_cur_year], al
	mov al, [bx + 0x17]
	call bcd_to_binary_byte
cmp al, [cs:rtc_cur_month]
	jb loc_0BF2E
	je loc_0BF3E
inc byte [cs:rtc_cur_year]
mov al, [cs:rtc_cur_year]
	call binary_to_bcd_byte
	mov [bx + 0x18], al
	mov_cl_al                                    ; 0BF25
	mov ah, 0
	mov al, 0x18
	call nvram_read_byte

loc_0BF2E:                                     ; 0BF2E
mov al, [cs:rtc_cur_month]
	call binary_to_bcd_byte
	mov_cl_al                                    ; 0BF35
	mov ah, 0
	mov al, 0x17
	call nvram_read_byte

loc_0BF3E:                                     ; 0BF3E
	mov ax, 0x4e

loc_0BF41:                                     ; 0BF41
cmp al, [cs:rtc_cur_year]
	je loc_0BF60
	test al, 3
	je loc_0BF56
add word [cs:rtc_day_of_year], 0x16d; 0BF4C  add word [cs:0x5067], 0x16d
	inc ax
	jmp short loc_0BF41

loc_0BF56:                                     ; 0BF56
add word [cs:rtc_day_of_year], 0x16e; 0BF56  add word [cs:0x5067], 0x16e
	inc ax
	jmp short loc_0BF41

loc_0BF60:                                     ; 0BF60
test byte [cs:rtc_cur_year], 3
	je loc_0BF70
mov byte [cs:rtc_is_leap_year], 0
	jmp short loc_0BF76

loc_0BF70:                                     ; 0BF70
mov byte [cs:rtc_is_leap_year], 0xff

loc_0BF76:                                     ; 0BF76
	mov bx, 1

loc_0BF79:                                     ; 0BF79
cmp bl, [cs:rtc_cur_month]
	je loc_0BF9E
cmp byte [cs:rtc_is_leap_year], 0xff
	je loc_0BF8F
mov al, [cs:bx + rtc_days_in_month_norm]
	jmp short loc_0BF94

loc_0BF8F:                                     ; 0BF8F
mov al, [cs:bx + rtc_days_in_month_leap]

loc_0BF94:                                     ; 0BF94
	xor_ah_ah                                    ; 0BF94
add [cs:rtc_day_of_year], ax
	inc bx
	jmp short loc_0BF79

loc_0BF9E:                                     ; 0BF9E
mov al, [cs:rtc_cur_day]
	xor_ah_ah                                    ; 0BFA2
add ax, [cs:rtc_day_of_year]
	push es
	mov es, [cs:xios_sysdat_segment_val]
	mov [es:0x7e], ax
	pop es
	mov dx, PORT_PCB_T0_MAXA
	in ax, dx
mov si, xios_diag_fn_4667
	cmp ax, strict word 0x1a                     ; 0BFBB  3D 1A 00
	je loc_0BFC3
mov si, xios_diag_fn_4651

loc_0BFC3:                                     ; 0BFC3
mov [cs:xios_diag_ptr_467d], si
	call crt_init_hardware_display
mov bx, xios_crt_table_4225
	and byte [bx + 0x17], 0xdf
	cmp byte [bx + 0x17], 0x50
	jne loc_0BFE1
mov word [cs:xios_mx_param_593d], 0x18; 0BFD8  mov word [cs:0x593d], 0x18
	jmp short loc_0BFE1

loc_0BFE1:                                     ; 0BFE1
mov bx, xios_crt_table_4256
	cmp byte [bx + 0x33], 1
	jne loc_0BFF9
	mov dl, 5
	call int28_fn_50_isbx_reset
mov bx, xios_crt_param_4058
	mov dx, PORT_ISBX_MCS0_02
	in al, dx
	mov [bx + 0x1E], al

loc_0BFF9:                                     ; 0BFF9
mov es, [cs:rtc_time_buf_seg]
	mov cl, 0x86
mov dx, xios_mx_sound_qcb
	call rtm_timer_wait2
	mov cl, 0x87
mov dx, xios_mx_sound_msg
	call rtm_timer_wait2
	mov cl, 0x8b
mov dx, xios_mx_sound_msg
	call rtm_timer_wait2
	mov cl, 0x86
mov dx, xios_mx_dma0_qcb
	call rtm_timer_wait2
	mov cl, 0x87
mov dx, xios_mx_dma0_msg
	call rtm_timer_wait2
	mov cl, 0x8b
mov dx, xios_mx_dma0_msg
	call rtm_timer_wait2
	mov cl, 0x86
mov dx, xios_mx_dma1_qcb
	call rtm_timer_wait2
	mov cl, 0x87
mov dx, xios_mx_dma1_msg
	call rtm_timer_wait2
	mov cl, 0x8b
mov dx, xios_mx_dma1_msg
	call rtm_timer_wait2
	mov cl, 0x86
mov dx, xios_mx_cass_qcb
	call rtm_timer_wait2
	mov cl, 0x87
mov dx, xios_mx_cass_msg
	call rtm_timer_wait2
	mov cl, 0x8b
mov dx, xios_mx_cass_msg
	call rtm_timer_wait2
	mov cl, 0x86
mov dx, xios_qcb_link_req
	call rtm_timer_wait2
	mov cl, 0x86
mov dx, xios_qcb_xmit_req
	call rtm_timer_wait2
	mov cl, 0x86
mov dx, xios_mx_alt_qcb
	call rtm_timer_wait2
	mov cl, 0x87
mov dx, xios_mx_alt_msg
	call rtm_timer_wait2
	mov cl, 0x8b
mov dx, xios_mx_alt_msg
	call rtm_timer_wait2
mov al, [cs:fdc_param_376c]

fdc_dma_scroll_cmd:                            ; 0C08A
	mov dx, PORT_FDC_CTRL
	out dx, al
	mov dx, PORT_FDC_CMD
	in al, dx
	mov dx, PORT_PRN_RELEASE
	out dx, al
mov bx, xios_crt_table_4225
	mov cl, [bx + 0x13]
	mov bx, 0

loc_0C09F:                                     ; 0C09F
	cmp cl, 0
	je loc_0C0AF
mov byte [cs:bx + fdc_scratch_3932], 1
	inc bx
	dec cl
	jmp short loc_0C09F

loc_0C0AF:                                     ; 0C0AF
mov bx, xios_crt_table_4225
	les di, [bx]
	mov ax, es
	mov cl, 6
	shl ax, cl
	mov cl, 0xa
	shr di, cl
	add_ax_di                                    ; 0C0BE
mov [cs:xios_mx_mem_avail], ax
mov bx, [cs:xios_mx_param_593d]
sub [cs:xios_mx_mem_avail], bx
mov di, boot_msg_main_memory
	call boot_format_dec
mov si, xios_boot_banner
	call boot_print_str
mov bx, xios_crt_table_4225
	mov al, [bx + 0x13]
	xor_ah_ah                                    ; 0C0E0
	or_al_al                                     ; 0C0E2
	je loc_0C0FD
	cmp al, 1
	jne loc_0C0F1
mov bx, fdc_scratch_3932
	mov byte [bx + 1], 0

loc_0C0F1:                                     ; 0C0F1
mov di, boot_msg_floppy_drives
	call boot_format_dec
mov si, boot_msg_floppy_drives
	call boot_print_str

loc_0C0FD:                                     ; 0C0FD
	jmp near loc_0C11A
mov bx, xios_crt_table_4225
mov al, [cs:rtc_time_buf_val]
	sub al, [bx + 0x13]
	je loc_0C11A
	xor_ah_ah                                    ; 0C10C
mov di, boot_msg_winchester_drives
	call boot_format_dec
mov si, boot_msg_winchester_drives
	call boot_print_str

loc_0C11A:                                     ; 0C11A
mov bx, xios_crt_table_4256
	mov al, [bx + CCB_CON_IDX]
	mov [cs:sysdat_srchdisk], al
	mov [cs:sysdat_tempdisk], al
mov bx, xios_crt_table_4256
mov ax, [cs:xios_mx_mem_avail]
	mov bl, [bx + 0x1b]
	mov bh, 0
	mov cl, 6
	shl bx, cl
	sub_ax_bx                                    ; 0C138
	mov bx, [cs:sysdat_endseg]
	mov cl, 6
	shr bx, cl
	add bx, 0x40
	cmp_ax_bx                                    ; 0C146
	ja loc_0C153
mov si, boot_msg_mdisk_low_mem
	call boot_print_str
	jmp near loc_0C1A5

loc_0C153:                                     ; 0C153
mov [cs:xios_mx_mem_avail], ax
	push es
	mov cl, 6
	shl ax, cl
mov [cs:fdc_dma_buffer_ptr_35b7], ax
mov bx, xios_crt_table_4256
	mov al, [bx + 0x1b]
	or_al_al                                     ; 0C166
	je loc_0C1A4
	xor_ah_ah                                    ; 0C16A
	mov cl, 6
	shl ax, cl
	dec ax
mov [cs:fdc_dpb_m_param], ax
	inc ax
mov di, boot_msg_mdisk_kbytes
	call boot_format_dec
mov si, boot_msg_mdisk_kbytes
	call boot_print_str
	mov byte [cs:sysdat_tempdisk], 0xc
mov bx, fdc_scratch_3932
	mov byte [bx + 0xc], 0xc0
mov ax, [cs:fdc_dma_buffer_ptr_35b7]
	mov es, ax
	xor_di_di                                    ; 0C195
	mov ax, 0xe5e5
	cmp [es:di], ax
	je loc_0C1A4
	mov cx, 0x2000
	rep stosw

loc_0C1A4:                                     ; 0C1A4
	pop es

loc_0C1A5:                                     ; 0C1A5
	mov cx, 0x10

loc_0C1A8:                                     ; 0C1A8
	push cx
	dec cl
	mov dl, 0
	call io_seldsk
	or_bx_bx                                     ; 0C1B0
	je loc_0C220
mov ax, [cs:xios_mx_alloc_ptr]
	mov [bx + 0xa], ax
	push bx
	mov bx, [bx + 8]
	mov ax, [bx + 0xb]
	and ax, 0x7fff
	pop bx
	jne loc_0C1CF
	mov word [bx + 0xa], 0
	jmp short loc_0C1E1

loc_0C1CF:                                     ; 0C1CF
	push bx
	mov bx, [bx + 8]
	mov ax, [bx + 7]
	mov cl, 2
	shr ax, cl
	inc ax
add [cs:xios_mx_alloc_ptr], ax
	pop bx

loc_0C1E1:                                     ; 0C1E1
	push bx
	mov bx, [bx + 8]
	mov ax, [bx + 7]
	inc ax
	mov cl, 2
	shl ax, cl
	add ax, 0x3ff
	mov cl, 0xa
	shr ax, cl
sub [cs:xios_mx_mem_avail], ax
	pop bx
mov ax, [cs:xios_mx_mem_avail]
	mov cl, 6
	shl ax, cl
	mov [bx + 0x12], ax
mov ax, [cs:xios_mx_alloc_ptr]
	mov [bx + 0xc], ax
	push bx
	mov bx, [bx + 8]
	mov ax, [bx + 5]
	pop bx
	mov cl, 3
	shr ax, cl
	inc ax
	shl ax, 1
add [cs:xios_mx_alloc_ptr], ax

loc_0C220:                                     ; 0C220
	pop cx
	dec cx
	je loc_0C227
	jmp near loc_0C1A8

loc_0C227:                                     ; 0C227
mov bx, xios_crt_table_4225
mov dl, [cs:rtc_time_buf_val]
mov word [cs:xios_mx_mem_limit], 0x420; 0C22F  mov word [cs:0x594f], 0x420
mov bx, xios_crt_table_4256
	mov cl, [bx + 0x1A]
	mov ch, 0
	push cx
	mov bx, [cs:sysdat_endseg]
	mov cl, 6
	shr bx, cl
	pop cx
mov ax, [cs:xios_mx_mem_avail]
	sub_ax_bx                                    ; 0C24D
	sub ax, strict word 0x40                     ; 0C24F  2D 40 00

loc_0C252:                                     ; 0C252
	cmp_cx_ax                                    ; 0C252
	jb loc_0C259
	dec cx
	jmp short loc_0C252

loc_0C259:                                     ; 0C259
	cmp_cl_dl                                    ; 0C259
	jb loc_0C25F
	jmp short loc_0C261

loc_0C25F:                                     ; 0C25F
	mov_cl_dl                                    ; 0C25F

loc_0C261:                                     ; 0C261
sub [cs:xios_mx_mem_avail], cx
mov ax, [cs:xios_mx_mem_avail]
	push cx
	mov cl, 6
	shl ax, cl
mov [cs:xios_mx_mem_free], ax
	pop cx
mov bx, fdc_dtabcb_drive_a
mov ax, [cs:xios_mx_alloc_ptr]
	mov [bx], ax
	mov [bx + 2], cl
	or_cl_cl                                     ; 0C280
	je loc_0C2C9

loc_0C284:                                     ; 0C284
	push ax
mov ax, [cs:xios_mx_free_ptr]
sub ax, [cs:xios_mx_alloc_ptr]
cmp ax, [cs:xios_mx_mem_limit]
	pop ax
	jb loc_0C2C4
add word [cs:xios_mx_alloc_ptr], 0x10
	mov_bx_ax                                    ; 0C29C
	mov_di_bx                                    ; 0C29E
	push cx
	mov cx, 8
	xor_ax_ax                                    ; 0C2A4
	push ds
	pop es
	rep stosw
	pop cx
	mov byte [bx], 0xff
mov ax, [cs:xios_mx_mem_free]
	mov [bx + 0xa], ax
add word [cs:xios_mx_mem_free], 0x40
mov ax, [cs:xios_mx_alloc_ptr]
	mov [bx + 0xc], ax
	loop loc_0C284

loc_0C2C4:                                     ; 0C2C4
	mov word [bx + 0xc], 0

loc_0C2C9:                                     ; 0C2C9
mov bx, fdc_dtabcb_drive_a
	sub [bx + 2], cl
	mov al, [bx + 2]
	xor_ah_ah                                    ; 0C2D2
	or_ax_ax                                     ; 0C2D4
	je loc_0C33F
mov di, boot_msg_data_buffers
	call boot_format_dec
mov si, boot_msg_data_buffers
	call boot_print_str
mov bx, fdc_dirbcb_drive_a
mov ax, [cs:xios_mx_alloc_ptr]
	mov [bx], ax
	mov cl, 0

loc_0C2EF:                                     ; 0C2EF
mov ax, [cs:xios_mx_alloc_ptr]
	add ax, 0x410
cmp ax, [cs:xios_mx_free_ptr]
	ja loc_0C324
mov bx, [cs:xios_mx_alloc_ptr]
add word [cs:xios_mx_alloc_ptr], 0x10
	mov byte [bx], 0xff
mov ax, [cs:xios_mx_alloc_ptr]
	mov [bx + 0xa], ax
add word [cs:xios_mx_alloc_ptr], 0x400; 0C312  add word [cs:0x5941], 0x400
mov ax, [cs:xios_mx_alloc_ptr]
	mov [bx + 0xc], ax
	inc cl
	jmp short loc_0C2EF

loc_0C324:                                     ; 0C324
	mov word [bx + 0xc], 0
mov bx, fdc_dirbcb_drive_a
	mov [bx + 2], cl
	mov_al_cl                                    ; 0C32F
	xor_ah_ah                                    ; 0C331
mov di, boot_msg_dir_buffers
	call boot_format_dec
mov si, boot_msg_dir_buffers
	call boot_print_str

loc_0C33F:                                     ; 0C33F
mov ax, [cs:xios_mx_mem_avail]
	mov cl, 6
	shl ax, cl
	sub ax, strict word 0x10                     ; 0C347  2D 10 00
mov [cs:xios_crt_param_4058], ax
mov word [cs:xios_crt_param_405a], 0x100; 0C34E  mov word [cs:0x405a], 0x100
mov word [cs:xios_crt_param_4060], 0x100; 0C355  mov word [cs:0x4060], 0x100
	sub ax, strict word 1                        ; 0C35C  2D 01 00
mov [cs:xios_crt_param_4062], ax
mov word [cs:xios_crt_param_4064], 0x10; 0C363  mov word [cs:0x4064], 0x10
mov word [cs:xios_crt_param_406a], 0x10; 0C36A  mov word [cs:0x406a], 0x10
	push ax
	mov cl, 6
	shr ax, cl
mov [cs:xios_mx_mem_avail], ax
	pop cx
	mov bx, 0x5a

loc_0C37E:                                     ; 0C37E
	mov_si_bx                                    ; 0C37E
	mov bx, [bx]
	test bx, bx
	je loc_0C3C1
	mov ax, [bx + 2]
	add ax, [bx + 4]
	cmp_ax_cx                                    ; 0C38C
	jbe loc_0C37E
	mov ax, [bx + 2]
	sub_cx_ax                                    ; 0C393
	jbe loc_0C3A8
	mov [bx + 4], cx
	mov si, [bx]
	test si, si
	je loc_0C3C1
	mov word [bx], 0
	mov_bx_si                                    ; 0C3A4
	jmp short loc_0C3AE

loc_0C3A8:                                     ; 0C3A8
	mov word [si], 0
	mov_si_bx                                    ; 0C3AC

loc_0C3AE:                                     ; 0C3AE
	mov_di_bx                                    ; 0C3AE
	mov bx, [bx]
	test bx, bx
	jne loc_0C3AE
	mov ax, [cs:sysdat_mdul]
	mov [cs:sysdat_mdul], si
	mov [di], ax

loc_0C3C1:                                     ; 0C3C1
mov ax, [cs:xios_mx_mem_avail]
	mov bx, [cs:sysdat_endseg]
	mov cl, 6
	shr bx, cl
	sub_ax_bx                                    ; 0C3CE
mov di, boot_msg_user_memory
	call boot_format_dec
mov si, boot_msg_user_memory
	call boot_print_str
	xor_ax_ax                                    ; 0C3DC
or ax, [cs:xios_boot_fpu_lan_flag]
	mov ax, 0xa0
	je loc_0C420
	xor_ax_ax                                    ; 0C3E8
	mov es, ax
	mov di, 0x94
mov ax, xios_diag_hook_target_46c0
	stosw
	mov ax, cs
	stosw
	db 0x2E, 0xC7, 0x06, 0x8C, 0x00, 0x00, 0x00  ; 0C3F6  mov word [cs:sysdat_openvec], 0
	db 0x2E, 0xC7, 0x06, 0xA2, 0x00, 0x00, 0x00  ; 0C3FD  mov word [cs:sysdat_int_vec], 0
	db 0x2E, 0xC7, 0x06, 0xA0, 0x00, 0x94, 0x00  ; 0C404  mov word [cs:sysdat_abort_vec], 0x94
	mov [cs:sysdat_err_intercept_seg], cs
mov word [cs:sysdat_err_intercept], xios_diag_hook_target_46c0; 0C410  mov word [cs:sysdat_err_intercept], 0x46c0
mov si, boot_msg_crlf_fpu
	call boot_print_str
	mov ax, 0x80

loc_0C420:                                     ; 0C420
	push ax
mov bx, xios_crt_table_4225
	cmp byte [bx + 0xd], 0xff
	jne loc_0C430
mov si, boot_msg_crlf_lan
	call boot_print_str

loc_0C430:                                     ; 0C430
	mov dx, PORT_PCB_IMR
	mov ax, 0x41
	out dx, ax
	pop ax
	mov dx, 2
	out dx, ax
	retf

xios_boot_fpu_lan_flag:
	dw 0x0000                                    ; 0C43D  FPU / LAN boot-flag (CS:589D)

boot_print_str:                                     ; 0C43F
	xor_dl_dl                                    ; 0C43F

.loop:                                     ; 0C441
	mov cl, [si]
	test cl, cl
	je .done
	push dx
	push si
	call io_conout
	pop si
	pop dx
	inc si
	jmp short .loop

.done:                                     ; 0C451
	ret

binary_to_bcd_byte:                                     ; 0C452
	push dx
	push bx
	push cx
	xor_dx_dx                                    ; 0C455
	xor_ah_ah                                    ; 0C457
	mov bx, 0xa
	idiv bx                                       ; 0C45C
	mov cl, 4
	shl al, cl
	or_al_dl                                     ; 0C462
	pop cx
	pop bx
	pop dx
	ret

boot_format_dec:                                     ; 0C468
	push cx
	push bx
	push dx
	push si
	push di
	mov si, 0

.div_loop:                                     ; 0C470
	sub_dx_dx                                    ; 0C470
idiv word [cs:si + xios_mx_div_table]          ; 0C472
	mov bl, 0x30
	add_al_bl                                    ; 0C479
	mov [di], al
	inc si
	inc si
	inc di
	mov_ax_dx                                    ; 0C480
	cmp si, 0xa
	jne .div_loop
	mov cx, 5
	pop di

.suppress_zeros:                                     ; 0C48B
	cmp byte [di], '0'
	jne .done
	mov byte [di], ' '
	inc di
	loop .suppress_zeros

.done:                                     ; 0C496
	pop si
	pop dx
	pop bx
	pop cx
	ret
; CCP/M-86 Queue og Mutual Exclusion (MX) Deskriptorer
	times 64 db 0x00
xios_mx_mem_free:
	dw 0x0000
xios_mx_param_593d:
	dw 0x0000
xios_mx_mem_avail:
	dw 0x0000
xios_mx_alloc_ptr:
%if NUM_VIR_CONS == 4
	dw 0x6007
%else
	dw 0x4F54
%endif
xios_mx_free_ptr:
	dw xios_mx_mem_free
xios_mx_div_table:
	db 0x10, 0x27, 0xE8, 0x03, 0x64, 0x00, 0x0A, 0x00, 0x01, 0x00
xios_mx_mem_limit:
	db 0x00, 0x00
xios_mx_sound_qcb:
	db 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x4D, 0x58, 0x73, 0x6F, 0x75, 0x6E, 0x64, 0x20, 0x00, 0x00
	db 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
xios_mx_sound_msg:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x4D, 0x58, 0x73, 0x6F, 0x75, 0x6E, 0x64, 0x20
xios_mx_dma0_qcb:
	db 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x4D, 0x58, 0x64, 0x6D, 0x61, 0x30, 0x20, 0x20, 0x00, 0x00
	db 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
xios_mx_dma0_msg:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x4D, 0x58, 0x64, 0x6D, 0x61, 0x30, 0x20, 0x20
xios_mx_dma1_qcb:
	db 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x4D, 0x58, 0x64, 0x6D, 0x61, 0x31, 0x20, 0x20, 0x00, 0x00
	db 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
xios_mx_dma1_msg:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x4D, 0x58, 0x64, 0x6D, 0x61, 0x31, 0x20, 0x20
xios_qcb_link_req:
	db 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x6C, 0x69, 0x6E, 0x6B, 0x5F, 0x72, 0x65, 0x71, 0x0F, 0x00
	db 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	dw xios_q_link_buf
xios_qcb_xmit_req:
	db 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x58, 0x4D, 0x49, 0x54, 0x5F, 0x52, 0x45, 0x51, 0x0F, 0x00
	db 0x0A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	dw xios_q_xmit_buf
xios_q_link_buf:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
xios_q_xmit_buf:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
xios_mx_alt_qcb:
	db 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x4D, 0x58, 0x61, 0x6C, 0x74, 0x20, 0x20, 0x20, 0x00, 0x00
	db 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
xios_mx_alt_msg:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x4D, 0x58, 0x61, 0x6C, 0x74, 0x20, 0x20, 0x20
xios_mx_cass_qcb:
	db 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x4D, 0x58, 0x63, 0x61, 0x73, 0x73, 0x20, 0x20, 0x00, 0x00
	db 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
xios_mx_cass_msg:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x4D, 0x58, 0x63, 0x61, 0x73, 0x73, 0x20, 0x20
xios_cas_timeout_counter:
	db 0xFF, 0xFF
xios_cas_buf_ptr:
	db 0x00, 0x00
xios_cas_last_bit:
	db 0x00, 0x00, 0x00
xios_cas_byte_count:
	db 0x00, 0x00
xios_cas_block_num:
	db 0x00, 0x00
xios_cas_state:
	db 0x01
int28_fn_26_cas_read_hdr:                 ; 0C6B6 (Båndoptager læs filhoved)
	call stack_swap_context
	mov_bx_dx                                    ; 0C6B9
mov word [cs:xios_cas_block_num], 0; 0C6BB  mov word [cs:0x5b13], 0
mov byte [cs:xios_cas_state], 1
mov [cs:xios_cas_byte_count], cx
	call cas_stop_motor_and_timer
	xchg bx, dx                                  ; 0C6D0  87 DA
	xchg bx, cx                                  ; 0C6D2  87 D9
	ret

int28_fn_27_cas_write_hdr:                ; 0C6D5 (Båndoptager skriv filhoved)
	call stack_swap_context
	mov_bx_dx                                    ; 0C6D8
mov word [cs:xios_cas_block_num], 0; 0C6DA  mov word [cs:0x5b13], 0
mov [cs:xios_cas_byte_count], cx
mov byte [cs:xios_cas_state], 1
	call cas_write_leader_and_header
	mov_dx_bx                                    ; 0C6EF
	ret

int28_fn_28_cas_read_data:               ; 0C6F2 (Båndoptager læs datablok)
	call stack_swap_context
	mov_bx_dx                                    ; 0C6F5
mov byte [cs:xios_cas_state], 2
inc word [cs:xios_cas_block_num]
mov [cs:xios_cas_byte_count], cx
	call cas_stop_motor_and_timer
	xchg bx, dx                                  ; 0C70A  87 DA
	xchg bx, cx                                  ; 0C70C  87 D9
	ret

int28_fn_29_cas_write_data:              ; 0C70F (Båndoptager skriv datablok)
	call stack_swap_context
	mov_bx_dx                                    ; 0C712
mov byte [cs:xios_cas_state], 2
mov [cs:xios_cas_byte_count], cx
inc word [cs:xios_cas_block_num]
	call cas_write_leader_and_header
	mov_dx_bx                                    ; 0C727
	ret

int28_fn_40_cas_write_eof:               ; 0C72A (Båndoptager skriv EOF-blok)
	call stack_swap_context
	mov_bx_dx                                    ; 0C72D
mov byte [cs:xios_cas_state], 3
mov word [cs:xios_cas_byte_count], 0; 0C735  mov word [cs:0x5b11], 0
inc word [cs:xios_cas_block_num]
	call cas_write_leader_and_header
	mov_dx_bx                                    ; 0C744
	ret

cas_stop_motor_and_timer:                                     ; 0C747
	cli
	push bx
	push cx
	push si
	mov si, 0xa
	call cas_delay_motor_settle
	mov ax, 0xffff
	mov dx, PORT_PCB_T0_MAXA
	out dx, ax
	mov dx, PORT_PCB_T0_MAXB
	out dx, ax
	mov ax, 0xc013
	mov dx, PORT_PCB_T0_CON
	out dx, ax
	mov ax, 1
	out PORT_PPI_CTRL, ax

loc_0C768:                                     ; 0C768
	in al, PORT_PPI_PORTA
	and al, 1
mov [cs:xios_cas_last_bit], al
	mov dx, 0x3f7a

loc_0C773:                                     ; 0C773
	dec dx
	jne loc_0C779
	jmp near loc_0C81A

loc_0C779:                                     ; 0C779
	call cas_read_bit_period
	jcxz loc_0C773
	mov cx, 0x512
	mov dx, 0x465

loc_0C784:                                     ; 0C784
	push cx
	call cas_read_bit_period
	or_cx_cx                                     ; 0C788
	pop cx
	je loc_0C768
	cmp_dx_bx                                    ; 0C78D
	jcxz loc_0C795
	jae loc_0C768
	loop loc_0C784

loc_0C795:                                     ; 0C795
	jb loc_0C784
	call cas_read_bit_period
	call cas_read_byte
	cmp al, 3
	je loc_0C81F
cmp al, [cs:xios_cas_state]
	jne loc_0C814
	pop si
	pop cx
	pop bx
	call cas_read_byte
	mov_ah_al                                    ; 0C7AE
	call cas_read_byte
cmp ax, [cs:xios_cas_block_num]
	mov al, 4
	push ax
	jne loc_0C82F
	pop ax
	call cas_read_byte
	mov_ah_al                                    ; 0C7C1
	call cas_read_byte
	cmp_ax_cx                                    ; 0C7C6
	jae loc_0C7CC
	mov_cx_ax                                    ; 0C7CA

loc_0C7CC:                                     ; 0C7CC
	push cx

loc_0C7CD:                                     ; 0C7CD
	mov ax, 0
mov word [cs:xios_cas_timeout_counter], 0xffff; 0C7D0  mov word [cs:0x5b0a], 0xffff
	mov dx, PORT_NVRAM_BASE

loc_0C7DA:                                     ; 0C7DA
	call cas_read_byte
	jb loc_0C802
	jcxz loc_0C7E5
	mov [bx], al
	inc bx
	dec cx

loc_0C7E5:                                     ; 0C7E5
	dec dx
	jg loc_0C7DA
	call cas_read_byte
	mov_ah_al                                    ; 0C7EB
	call cas_read_byte
	not ax
cmp word [cs:xios_cas_timeout_counter], 0x1d0f; 0C7F2  cmp word [cs:0x5b0a], 0x1d0f
	mov al, 0
	jne loc_0C804
	jcxz loc_0C806
	jmp near loc_0C7CD

loc_0C802:                                     ; 0C802
	mov al, 1

loc_0C804:                                     ; 0C804
	inc al

loc_0C806:                                     ; 0C806
	pop dx
	sub_dx_cx                                    ; 0C807
	push ax
	test al, 3
	jne loc_0C82F
	call cas_read_byte
	jmp near loc_0C82F

loc_0C814:                                     ; 0C814
	dec si
	je loc_0C81A
	jmp near loc_0C768

loc_0C81A:                                     ; 0C81A
	mov al, 3
	jmp near loc_0C829

loc_0C81F:                                     ; 0C81F
cmp byte [cs:xios_cas_state], 1
	je loc_0C814
	mov al, 5

loc_0C829:                                     ; 0C829
	pop si
	pop cx
	pop bx
	sub_dx_dx                                    ; 0C82C
	push ax

loc_0C82F:                                     ; 0C82F
	mov ax, 3
	out PORT_PPI_CTRL, ax
	pop ax
	cmp ah, 1
	cmc
	call rtc_sync_sysdat_clock
	sti
	ret

cas_read_byte:                                     ; 0C83E
	push bx
	push cx
	push ax
	mov cl, 8

loc_0C843:                                     ; 0C843
	push cx
	call cas_read_bit_period
	jcxz loc_0C86A
	push bx
	call cas_read_bit_period
	pop ax
	jcxz loc_0C86A
	add_bx_ax                                    ; 0C850
	cmp bx, 0x8ca
	cmc
	lahf
	pop cx
	rcl ch, 1
	sahf
	call cas_calc_crc_step
	dec cl
	jne loc_0C843
	pop ax
	mov_al_ch                                    ; 0C864
	clc

loc_0C867:                                     ; 0C867
	pop cx
	pop bx
	ret

loc_0C86A:                                     ; 0C86A
	pop cx
	pop ax
	stc
	jmp near loc_0C867

cas_read_bit_period:                                     ; 0C870
	mov cx, 0x190
mov ah, [cs:xios_cas_last_bit]

.wait_edge:                                     ; 0C878
	in al, PORT_PPI_PORTA
	and al, 1
	cmp_al_ah                                    ; 0C87C
	loope .wait_edge
mov [cs:xios_cas_last_bit], al
	push dx
	mov dx, PORT_PCB_T0_CNT
	in ax, dx
	pop dx
	mov_bx_ax                                    ; 0C88A
mov ax, [cs:xios_cas_buf_ptr]
mov [cs:xios_cas_buf_ptr], bx
	sub_bx_ax                                    ; 0C895
	ret

cas_write_leader_and_header:                                     ; 0C898
	cli
	push bx
	push cx
	mov ax, 0xc013
	mov dx, PORT_PCB_T0_CON
	out dx, ax
	mov ax, 0x5dc
	mov dx, PORT_PCB_T0_MAXA
	out dx, ax
	mov dx, PORT_PCB_T0_MAXB
	out dx, ax
	call cas_delay_motor_settle
	mov ax, 1
	out PORT_PPI_CTRL, ax
	mov cx, 0x7e8

loc_0C8B8:                                     ; 0C8B8
	stc
	call cas_write_bit
	loop loc_0C8B8
	clc
	call cas_write_bit
mov al, [cs:xios_cas_state]
	push ax
	call cas_write_byte
	pop ax
	cmp al, 3
	je loc_0C925
mov ax, [cs:xios_cas_block_num]
	push ax
	xchg ah, al                                  ; 0C8D4  86 E0
	call cas_write_byte
	pop ax
	call cas_write_byte
mov ax, [cs:xios_cas_byte_count]
	push ax
	xchg ah, al                                  ; 0C8E2  86 E0
	call cas_write_byte
	pop ax
	call cas_write_byte
	pop cx
	pop bx

loc_0C8ED:                                     ; 0C8ED
mov word [cs:xios_cas_timeout_counter], 0xffff; 0C8ED  mov word [cs:0x5b0a], 0xffff
	mov dx, PORT_NVRAM_BASE

loc_0C8F7:                                     ; 0C8F7
	mov al, [bx]
	call cas_write_byte
	jcxz loc_0C900
	inc bx
	dec cx

loc_0C900:                                     ; 0C900
	dec dx
	jg loc_0C8F7
mov ax, [cs:xios_cas_timeout_counter]
	not ax
	push ax
	xchg ah, al                                  ; 0C90A  86 E0
	call cas_write_byte
	pop ax
	call cas_write_byte
	or_cx_cx                                     ; 0C913
	jne loc_0C8ED
	push cx
	mov cx, 0x20

loc_0C91B:                                     ; 0C91B
	stc
	call cas_write_bit
	loop loc_0C91B
	pop cx
	jmp near loc_0C927

loc_0C925:                                     ; 0C925
	pop cx
	pop bx

loc_0C927:                                     ; 0C927
	mov ax, 0
	out PORT_PPI_CTRL, ax
	mov ax, 3
	out PORT_PPI_CTRL, ax
	sub_ax_ax                                    ; 0C931
	call rtc_sync_sysdat_clock
	sti
	ret

cas_write_byte:                                     ; 0C938
	push cx
	push ax
	mov_ch_al                                    ; 0C93A
	mov cl, 8

loc_0C93E:                                     ; 0C93E
	rcl ch, 1
	pushf
	call cas_write_bit
	popf
	call cas_calc_crc_step
	dec cl
	jne loc_0C93E
	pop ax
	pop cx
	ret

cas_write_bit:                                     ; 0C94F
	mov ax, 0x5dc
	jb loc_0C957
	mov ax, 0x2ee

loc_0C957:                                     ; 0C957
	push dx
	push ax

loc_0C959:                                     ; 0C959
	mov dx, PORT_PCB_T0_CON
	in ax, dx
	and ax, strict word 0x20                     ; 0C95D  25 20 00
	je loc_0C959
	in ax, dx
	and ax, strict word 0xffdf                   ; 0C963  25 DF FF
	out dx, ax
	pop ax
	push ax
	mov dx, PORT_PCB_T0_MAXA
	out dx, ax

loc_0C96D:                                     ; 0C96D
	mov dx, PORT_PCB_T0_CON
	in ax, dx
	and ax, strict word 0x20                     ; 0C971  25 20 00
	je loc_0C96D
	in ax, dx
	and ax, strict word 0xffdf                   ; 0C977  25 DF FF
	out dx, ax
	pop ax
	mov dx, PORT_PCB_T0_MAXB
	out dx, ax
	pop dx
	ret

cas_calc_crc_step:                                     ; 0C982
mov ax, [cs:xios_cas_timeout_counter]
	rcr ax, 1
	rcl ax, 1
	clc
	jno loc_0C991
	xor ax, 0x810
	stc

loc_0C991:                                     ; 0C991
	rcl ax, 1
mov [cs:xios_cas_timeout_counter], ax
	ret

cas_delay_motor_settle:                                     ; 0C998
	mov ax, 2
	out PORT_PPI_CTRL, ax
	mov bl, 0x96

loc_0C99F:                                     ; 0C99F
	mov cx, 0xfa0

loc_0C9A2:                                     ; 0C9A2
	loop loc_0C9A2
	dec bl
	jne loc_0C99F
	ret

rtc_sync_sysdat_clock:                                     ; 0C9A9
	push dx
	push ax
	push es
	push bx
	mov ax, [cs:xios_sysdat_segment_val]
	mov es, ax
	mov bx, 0
	mov al, 2
	call rtc_write_reg
	mov [es:bx + 0x82], al
	mov al, 3
	call rtc_write_reg
	mov [es:bx + 0x81], al
	mov al, 4
	call rtc_write_reg
	mov [es:bx + 0x80], al
	pop bx
	pop es
	pop ax
	pop dx
	ret

stack_swap_context:                                     ; 0C9D9
	pop ax
	pop bx
	pop ds
	push ds
	push bx
	push ax
	ret

xios_prn_reserve_flag:
	db 0x00                                      ; 0C9E0 (CS:5E40)
xios_prn_reserve_timer:
	db 0x00                                      ; 0C9E1 (CS:5E41)
xios_fdc_reserve_flag:
	db 0x00                                      ; 0C9E2 (CS:5E42)
xios_prn_client_mode:
	db 0x00                                      ; 0C9E3 (CS:5E43)
xios_fdc_client_mode:
	db 0x00                                      ; 0C9E4 (CS:5E44)
xios_prn_pending_flag:
	db 0x00                                      ; 0C9E5 (CS:5E45)

vmenu_clear_line_buffer:                                     ; 0C9E6
	push es
mov di, xios_vmenu_line_buf_4909
	push di
	push di
	push ds
	pop es
	mov cx, 0x50
	mov al, 0x20
	rep stosb
	lodsb
	mov_cl_al                                    ; 0C9F6
	pop di
	rep movsb
	pop cx
	mov dx, cs
	pop es
	call io_statline
	ret

int28_fn_41_dpc_parallel:               ; 0CA03 (Reserver/frigiv DPC interface)
	push ax
	push es
	call int28_fn_04_get_autoconfig
	add si, 0x13
	mov al, [si]
	cmp al, 0
	pop es
	pop ax
	je loc_0CA7E
	cmp ah, 1
	jne loc_0CA72
mov byte [cs:xios_prn_client_mode], 0xff

dpc_reserve_printer:                                     ; 0CA1E
	mov dx, PORT_PRN_RESERVE
	mov al, 0xff
	out dx, al
	in al, dx
	and al, 0x80
	je loc_0CA54
	push ds
	push es
	push cx
	push dx
	push cs
	pop ds
	mov si, [cs:sysdat_rlr]
	mov es, [si + PD_UDA]
mov si, xios_boot_msg_shared_prn1
	call vmenu_clear_line_buffer
	pop dx
	pop cx
	pop es
	pop ds
	mov cl, 0x83
	mov dl, 2
	call rtm_timer_wait2
mov byte [cs:xios_prn_reserve_flag], 0xff
	mov cx, 0xffff
	call io_statline

loc_0CA54:                                     ; 0CA54
cmp byte [cs:xios_prn_pending_flag], 0xff
mov byte [cs:xios_prn_pending_flag], 0
mov byte [cs:xios_prn_reserve_flag], 0xff
mov byte [cs:xios_prn_reserve_timer], 0xa
	jne loc_0CA6F
	ret

loc_0CA6F:                                     ; 0CA6F
	xor_ax_ax                                    ; 0CA6F
	ret

loc_0CA72:                                     ; 0CA72
	cmp ah, 2
	jne loc_0CA7E
mov byte [cs:xios_prn_client_mode], 0
	ret

loc_0CA7E:                                     ; 0CA7E
	mov ax, 0xffff
	ret

dpc_release_printer:                                     ; 0CA82
cmp byte [cs:xios_prn_reserve_flag], 0xff
	jne .ret
cmp byte [cs:xios_prn_reserve_timer], 0
	je .release
dec byte [cs:xios_prn_reserve_timer]
	jmp short .ret

.release:
cmp byte [cs:xios_prn_client_mode], 0xff
	je .ret
	mov dx, PORT_PRN_RELEASE
	out dx, al
	xor_ax_ax                                    ; 0CAA6
mov byte [cs:xios_prn_reserve_flag], 0
mov byte [cs:xios_prn_reserve_timer], 0
.ret:
	ret

int28_fn_42_shared_disk:                ; 0CAB5 (Reserver/frigiv delt disk)
	push ax
	push es
	call int28_fn_04_get_autoconfig
	add si, 0x13
	mov al, [es:si]
	cmp al, 0
	pop es
	pop ax
	je loc_0CB14
	cmp ah, 1
	jne loc_0CB08
mov byte [cs:xios_fdc_client_mode], 0xff

dpc_reserve_fdc:                                     ; 0CAD1
mov byte [cs:xios_fdc_reserve_flag], 0
	mov dx, PORT_FDC_RESERVE
	mov al, 0xff
	out dx, al
	in al, dx
	and al, 0x80
	je .ret
	push ds
	push es
	push cx
	push dx
	push cs
	pop ds
	mov si, [cs:sysdat_rlr]
	mov es, [si + PD_UDA]
mov si, xios_boot_msg_dollar
	call vmenu_clear_line_buffer
	pop dx
	pop cx
	pop es
	pop ds
	mov dl, 1
	mov cl, 0x83
	call rtm_timer_wait2
	mov cx, 0xffff
	call io_statline
.ret:                                     ; 0CB07
	ret

loc_0CB08:                                     ; 0CB08
	cmp ah, 2
	jne loc_0CB14
mov byte [cs:xios_fdc_client_mode], 0
	ret

loc_0CB14:                                     ; 0CB14
	mov ax, 0xffff
	ret

dpc_check_fdc_release:                                     ; 0CB18
cmp byte [cs:xios_fdc_reserve_flag], 0xff
	jne .ret
cmp byte [cs:xios_fdc_client_mode], 0xff
	je .ret
	mov ax, [cs:sysdat_nlstdev]
	and ax, 0xefff
	jne .ret

.release:
	mov dx, PORT_FDC_RELEASE
	out dx, al
mov byte [cs:xios_fdc_reserve_flag], 0
.ret:
	ret

dpc_release_shared_devices:                                     ; 0CB3C
	call dpc_check_fdc_release
	call dpc_release_printer
	ret
	align 2, db 0
fdc_drive_type_0:
	db 0x01, 0x03
fdc_drive_flags_0:
	db 0x00, 0x00, 0x50, 0x00
fdc_drive_dph_0:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0xF7, 0xFF, 0x00, 0x00
fdc_drive_cyl_0:
	db 0xFF, 0xFF, 0xFF, 0xFF
fdc_drive_0_dpb_ptr:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
fdc_dpb_standard:
	db 0x00, 0x10, 0x03, 0x2F, 0x29, 0x06, 0x29, 0x06, 0x00, 0x00, 0x09, 0x00, 0x0A, 0x00, 0x05, 0x00
	db 0x09, 0x06
fdc_dpb_current_format:
	db 0x09, 0x00, 0x09, 0x00, 0x09, 0x09, 0x00, 0x00, 0x38, 0x01, 0x05, 0x00, 0x24, 0x00, 0x1E, 0x01
	db 0x00, 0x00, 0x00, 0x00, 0x01, 0x47
fdc_dpb_std_drm:
	db 0x03, 0x47, 0x04, 0xFA
fdc_dpb_std_al0:
	db 0xF9, 0xFF
fdc_dpb_alternate:
	db 0x00, 0x10, 0x03, 0x2F, 0x29, 0x06, 0x29, 0x06, 0x00, 0x00, 0x0F, 0x00, 0x10, 0x00, 0x05, 0x00
	db 0x09, 0x06, 0x09, 0x08, 0x09, 0x00, 0x09, 0x09, 0x00, 0x00, 0x38, 0x01, 0x05, 0x00, 0x20, 0x00
	db 0x20, 0x01, 0x00, 0x00, 0x00, 0x00, 0x01, 0x47, 0x03, 0x47, 0x00, 0xFF, 0xFF, 0xFF
fdc_drive_dph_1:
	db 0x00, 0x00, 0x00, 0x00
fdc_drive_1_dpb_ptr:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x84, 0x00, 0x88
	db 0x00, 0x85, 0x00, 0x88
fdc_drive_dph_2:
	db 0x00, 0x00, 0x00, 0x00
fdc_drive_2_dpb_ptr:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x84, 0x00, 0x88
	db 0x00, 0x85, 0x00, 0x88
fdc_dpb_3_ptr:
	db 0x00, 0x8E, 0x00, 0x00, 0x01, 0x83
fdc_param_613c:
	db 0x09, 0x00
fdc_param_613e:
	db 0x50, 0x87
fdc_param_6140:
	db 0x00, 0x88
fdc_param_6142:
	db 0x01, 0x83, 0x00, 0x04, 0x50, 0x8A, 0x00, 0x00

xios_con_line_buffer_614a:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
xios_con_line_buffer_6186:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00
xios_con_line_buffer_61b8:
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00
xios_crt_mode_line_table:
	db 0x00, 0x81
xios_crt_line_entry_61ec:
	db 0x52, 0x87, 0xFF, 0x0C, 0x50, 0x8A, 0x20, 0x08, 0x00, 0x81
xios_vmenu_line_offsets:
	db 0x00, 0x00, 0xA0, 0x00, 0x40, 0x01, 0xE0, 0x01, 0x80, 0x02, 0x20, 0x03, 0xC0, 0x03, 0x60, 0x04
	db 0x00, 0x05, 0xA0, 0x05, 0x40, 0x06, 0xE0, 0x06, 0x80, 0x07

; -----------------------------------------------------------------------------
; Terminal Linje-Tabel & int3 Padding
; -----------------------------------------------------------------------------
vmenu_screen_line_table:
	dw 0x0820, 0x08C0, 0x0960, 0x0A00, 0x0AA0, 0x0B40, 0x0BE0, 0x0C80, 0x0D20, 0x0DC0, 0x0E60
	dw xios_con_line_buffer_614a
xios_crt_font_ptr:
	dw 0x0000, 0xFFF8, 0x0000, 0x0000
%if NUM_VIR_CONS == 4
	times 6 dw 0x0000
%endif

xios_int3_padding:
	times 256 db 0xCC                            ; int3 padding

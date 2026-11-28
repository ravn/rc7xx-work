; ===========================================================================
; Regnecentralen RC759 Piccoline — VOUT.RSP Data Segment
;
; Rekonstrueret datasegment for VOUT.RSP (58 paragraphs = 928 bytes)
; Indeholder ulinket Process Descriptor for VOUT, User Data Area (UDA),
; initialiseringsstak, kø-deskriptorer (VOUTQ, VINQ, VCMXQ) og arbejdsbuffere.
; ===========================================================================

; ---------------------------------------------------------------------------
; VOUT lokale variabler (DS-relative offsets)
; ---------------------------------------------------------------------------
vout_sysdat_ptr equ 0x0140  ; far ptr (off:seg): CCB-tabel / SYSDAT-base (LES BX)
vout_sysdat_seg equ 0x0142  ; word segment: segment-del af vout_sysdat_ptr
vout_cur_ccb    equ 0x0144  ; word offset: aktuel CCB (kombineret m. vout_ccb_seg → LES BX)
vout_ccb_seg    equ 0x0146  ; word segment: CCB-tabel segment (hi-del af vout_cur_ccb LES)
vout_ccb_state  equ 0x014c  ; byte: tilstandsværdi fra aktuel CCB
vout_ccb_busy   equ 0x014d  ; byte: 0=ledig, 0xFF=optaget
vout_q_start    equ 0x014e  ; word: kø/buffer start-position (sammenlignes m. vout_q_end)
vout_q_end      equ 0x0150  ; word: kø/buffer slut-position
vout_char_pend  equ 0x0152  ; word: afventende tegn/index (0xFFFF = ingen)
vout_ccb_ptr2   equ 0x015a  ; word offset: 2. CCB far ptr (fra BDOS-retur BX)
vout_ccb_seg2   equ 0x015c  ; word segment: 2. CCB far ptr segment (fra BDOS-retur ES)
vout_attr_pend  equ 0x0154  ; word: afventende attribut (0xFFFF = ingen)
vout_attr_limit equ 0x0156  ; word: attribut-grænse (default 0x80)
vout_mxq_msg    equ 0x0234  ; word: CCB mutex-kø besked (fra CCB+0x16)
vout_ccb_state_ptr equ 0x0238 ; word: pointer til vout_ccb_state (initialiseret til 0x14c)
; VCMXQ tilstandsbytes (inde i VCMXQ kø-deskriptor, 0x0244-0x0247):
vout_vcmxq_data equ 0x0244  ; byte: VCMXQ intern data-byte
vout_vcmxq_flag1 equ 0x0245 ; byte: VCMXQ flag 1 (0xFF=aktiv, 0x00=inaktiv)
vout_vcmxq_flag2 equ 0x0246 ; byte: VCMXQ flag 2
vout_vcmxq_flag3 equ 0x0247 ; byte: VCMXQ flag 3
; VOUT output kontroltilstand (i kø-buffer-området, 0x0348-0x034f):
vout_ostate     equ 0x0348  ; byte: output tilstand
vout_active     equ 0x0349  ; byte: 0xFF=aktiv udskriv, 0x00=inaktiv
vout_col        equ 0x034a  ; byte: aktuel kolonneposition (nulstilles ved linjeskift)
vout_row        equ 0x034b  ; byte: aktuel rækkeposition
vout_omode      equ 0x034c  ; byte: output-tilstandsmaskine
vout_saved_char equ 0x034d  ; byte: gemt tegn
vout_line_cnt   equ 0x034e  ; byte: linjetegn-tæller (sammenlignes mod 0x28=40)
vout_line_attr  equ 0x034f  ; byte: linjeattribut (lo-byte)
vout_line_attr2 equ 0x0350  ; byte: linjeattribut (hi-byte / ekstra flag)
vout_line_flags equ 0x0351  ; byte: linjeflag
vout_buf_last   equ 0x0372  ; byte: sidste byte i kø-buffer-området
vout_prompt_str equ 0x0373  ; byte[]: prompt-streng "        $$$" (11 bytes)
vout_work_buf   equ 0x037e  ; byte[]: arbejdsbuffer (terminaltilstand, 24 bytes)
vout_ws1        equ 0x0393  ; byte: arbejdsbuffer tilstandsbyte 1
vout_ws2        equ 0x0394  ; byte: arbejdsbuffer tilstandsbyte 2
; Kø-deskriptor-adresser i VOUT-datasegment:
VOUT_VCMXQ_OFF  equ 0x0232  ; VCMXQ kø-descriptor offset i DS

vout_data_start:
  ; -------------------------------------------------------------------------
  ; RSP Header (4 bytes)
  ; -------------------------------------------------------------------------
%ifdef CCPM_SYS
  dw 0x119f                                     ; +0x0000: Link field (p_link til næste RSP: PIN0)
%else
  dw 0x0000                                     ; +0x0000: Link field (0 = ulinket)
%endif
  dw 0x0047                                     ; +0x0002: RSP Code segment size / entry
  times 17 db 0                                 ; +0x0004..+0x0014: Reserveret

  ; -------------------------------------------------------------------------
  ; Process Descriptor (PD): "VOUT    " / "VOUT0   "
  ; -------------------------------------------------------------------------
  db 0xb4                                       ; +0x0015: Standard prioritet = 180 (0xB4)
  dw 0x0003                                     ; +0x0016: Status / pf_keep = 3
%ifdef CCPM_SYS
  db "VOUT0   "                                 ; +0x0018: Procesnavn (VOUT0)
%else
  db "VOUT    "                                 ; +0x0018: Procesnavn (8 tegn, uinitialiseret konsolnr)
%endif
  db 0x04                                       ; +0x0020: Processtatus
  times 5 db 0                                  ; +0x0021..+0x0025: Reserveret
%ifdef CCPM_SYS
  dw 0x0008                                     ; +0x0026: p_uda = 8 paragraffer
%else
  dw 0x00ff                                     ; +0x0026: Parent / console mask (0xFF = alle konsoller)
%endif
  times 76 db 0                                 ; +0x0028..+0x0073: Reserveret PD felter

  ; -------------------------------------------------------------------------
  ; User Data Area (UDA): Stak og kontekst
  ; -------------------------------------------------------------------------
  dw 0x013a                                     ; +0x0074: Initial stack pointer SP = 0x013A
  times 26 db 0                                 ; +0x0076..+0x008F: Reserveret UDA felter
%ifdef CCPM_SYS
  dw 0x129e, 0x1264, 0x1264, 0x1264             ; +0x0090: Runtime segmenter patched af GENCCPM
%else
  times 8 db 0                                  ; +0x0090..+0x0097
%endif
  times 8 db 0                                  ; +0x0098..+0x009F
  dw 0x0001                                     ; +0x00a0: INSYS flag = 1
  times 5 db 0                                  ; +0x00a2..+0x00a6: Reserveret
  times 147 db 0xcc                             ; +0x00a7..+0x0139: INT3 stak-fyld op til SP=0x013A

  ; Initialiserings-kontekst på stakken (pop'es af dispatcher ved start)
  dw 0x0603                                     ; +0x013a: Initial IP = 0x0603 (entry point i VOUT)
  times 22 db 0                                 ; +0x013c..+0x0151: Reserveret kontekst
  db 0xff, 0xff, 0xff, 0xff                     ; +0x0152..+0x0155: Initialiserings-maske
  times 12 db 0                                 ; +0x0156..+0x0161: Reserveret

  ; -------------------------------------------------------------------------
  ; Queue: VOUTQ — Virtual Output Queue (16 beskeder á 2 bytes)
  ; -------------------------------------------------------------------------
  dw 0x0006                                     ; +0x0162: Queue link field
  db "VOUTQ   "                                 ; +0x0164: Queue name
  dw 0x0002                                     ; +0x016c: Beskedlængde (2 bytes)
  dw 0x0010                                     ; +0x016e: Antal beskeder (16 beskeder)
  times 8 db 0                                  ; +0x0170..+0x0177: Reserveret
  dw 0x0352                                     ; +0x0178: Buffer pointer (0x0352)
  times 132 db 0                                ; +0x017a..+0x01fd: VOUTQ buffer

  ; -------------------------------------------------------------------------
  ; Queue: VINQ — Virtual Input Queue (64 beskeder á 2 bytes)
  ; -------------------------------------------------------------------------
  dw 0x0006                                     ; +0x01fe: Queue link field
  db "VINQ    "                                 ; +0x0200: Queue name
  dw 0x0002                                     ; +0x0208: Beskedlængde (2 bytes)
  dw 0x0040                                     ; +0x020a: Antal beskeder (64 beskeder)
  times 8 db 0                                  ; +0x020c..+0x0213: Reserveret
  dw 0x017a                                     ; +0x0214: Buffer pointer (0x017A)
  times 4 db 0                                  ; +0x0216..+0x0219: Reserveret

  ; -------------------------------------------------------------------------
  ; Queue: VCMXQ — Virtual Console Mutex Queue (1 besked á 0 bytes = semafor)
  ; -------------------------------------------------------------------------
  dw 0x0007                                     ; +0x021a: Queue link field
  db "VCMXQ   "                                 ; +0x021c: Queue name
  dw 0x0000                                     ; +0x0224: Beskedlængde (0 bytes = semafor)
  dw 0x0001                                     ; +0x0226: Antal beskeder (1 besked)
  times 29 db 0                                 ; +0x0228..+0x0244: Reserveret
  db 0xff, 0xff, 0xff                           ; +0x0245..+0x0247: Mutex flag
  times 299 db 0                                ; +0x0248..+0x0372: Reserveret bufferområde

  ; -------------------------------------------------------------------------
  ; Buffere og terminal-indstillinger
  ; -------------------------------------------------------------------------
  db "        $$$"                              ; +0x0373..+0x037d: Standard prompt / trailer
  times 24 db 0                                 ; +0x037e..+0x0395: Reserveret
  dw 0x005a                                     ; +0x0396..+0x0397: Kontrolværdi
  times 8 db 0                                  ; +0x0398..+0x039f: Slutjustering til 928 bytes (0x3A0)
vout_data_end:

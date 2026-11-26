; ===========================================================================
; Regnecentralen RC759 Piccoline — PIN.RSP Data Segment
;
; Rekonstrueret datasegment for PIN.RSP (30 paragraphs = 480 bytes)
; Indeholder ulinket Process Descriptor for PIN, User Data Area (UDA),
; initialiseringsstak samt drev- og printerfejlmeddelelser.
; ===========================================================================

; ---------------------------------------------------------------------------
; PIN lokale variabler i datasegmentet (DS-relative offsets, 0x140-0x1A5)
; Disse er i "Initialiserings-kontekst"-området, men IKKE stak — de er
; PIN's arbejdsvariabler. Se rsp_pin_code.asm for brug.
; ---------------------------------------------------------------------------
pin_sysdat_ptr  equ 0x0140  ; far ptr (off:seg): CCB-tabel / SYSDAT-base (LES BX)
pin_pd_ptr      equ 0x0144  ; word offset: pointer til Process Descriptor
pin_pd_seg      equ 0x0146  ; word segment: segment-del af pin_pd_ptr (LES SI, [0x144])
pin_flags       equ 0x0148  ; word: tilstandsflags
pin_uda_seg     equ 0x014a  ; word: UDA-segment fra PD (PD_UDA)
pin_cur_ccb     equ 0x0158  ; far ptr (off:seg): aktuel CCB (LES BX → [es:bx+0xA]=konsolnr)
pin_prev_ccb    equ 0x015c  ; word offset: gemt forrige CCB-offset (ved konsol-skift)
pin_prev_ccb_seg equ 0x015e ; word segment: segment-del af pin_prev_ccb
pin_cnmode      equ 0x0166  ; word: konsoltilstand (fra pin_get_cons_mode / XIOS pxios1)
pin_listroot    equ 0x016a  ; word: liste-rod-parameter til sleep/wake-kald
pin_drvmask_ptr equ 0x016e  ; word: pointer ind i drev-maske-tabellen (init: 0x1A6)
pin_cword       equ 0x017e  ; word: sidst læst konsol-input-tegn / konsol-word
pin_drive_idx   equ 0x0188  ; word: drev-index tæller (0-15 i drev-scanneloop)
pin_drive_mask  equ 0x018a  ; word: nuværende drev-bitmask-bit (venstre-skippes pr. iter.)
pin_drive_avail equ 0x018c  ; word: tilgængelige drev bitmask (fra BDOS)
pin_scan_max    equ 0x018e  ; byte: øvre grænse for cword-scanning (max. konsolantal?)
pin_scan_step   equ 0x018f  ; byte: tilvækst for cword-scanning
pin_scan_char   equ 0x0190  ; byte: scannet tegn / tastaturtilstand
pin_scan_state  equ 0x0191  ; byte: tilstandsmaskine-værdi for scanning
pin_mxq_count   equ 0x0192  ; byte: antal mutex-queue beskeder behandlet
pin_suspend_flag equ 0x0193 ; byte: 0xFF=suspenderet, 0x00=kørende
pin_drive_list  equ 0x0194  ; byte[]: liste af tilgængelige drev-bogstaver (ASCII)
pin_drive_count equ 0x01a5  ; byte: antal fundne tilgængelige drev

data_start:
  ; -------------------------------------------------------------------------
  ; RSP Header (4 bytes)
  ; -------------------------------------------------------------------------
  dw 0x0000                                     ; +0x0000: Link field (0 = ulinket)
  dw 0x009f                                     ; +0x0002: RSP Code segment size / entry
  times 17 db 0                                 ; +0x0004..+0x0014: Reserveret

  ; -------------------------------------------------------------------------
  ; Process Descriptor (PD): "PIN     "
  ; -------------------------------------------------------------------------
  db 0x60                                       ; +0x0015: Standard prioritet = 96 (0x60)
  dw 0x0003                                     ; +0x0016: Status / pf_keep = 3
  db "PIN     "                                 ; +0x0018: Procesnavn (8 tegn, uinitialiseret konsolnr)
  db 0x04                                       ; +0x0020: Processtatus
  times 5 db 0                                  ; +0x0021..+0x0025: Reserveret
  dw 0x00ff                                     ; +0x0026: Parent / console mask (0xFF = alle konsoller)
  times 76 db 0                                 ; +0x0028..+0x0073: Reserveret PD felter

  ; -------------------------------------------------------------------------
  ; User Data Area (UDA): Stak og kontekst
  ; -------------------------------------------------------------------------
  dw 0x013a                                     ; +0x0074: Initial stack pointer SP = 0x013A
  times 42 db 0                                 ; +0x0076..+0x009F: Reserveret UDA felter
  dw 0x0001                                     ; +0x00a0: INSYS flag = 1
  times 5 db 0                                  ; +0x00a2..+0x00a6: Reserveret
  times 147 db 0xcc                             ; +0x00a7..+0x0139: INT3 stak-fyld op til SP=0x013A

  ; Initialiserings-kontekst på stakken (pop'es af dispatcher ved start)
  dw 0x0900                                     ; +0x013a: Initial IP = 0x0900 (entry point i PIN)
  dw 0x0000                                     ; +0x013c: Initial CS
  dw 0x0000                                     ; +0x013e: Initial Flags
  times 84 db 0                                 ; +0x0140..+0x0193: Reserveret stak/buffer

  ; -------------------------------------------------------------------------
  ; Drev- og printerfejlmeddelelser
  ; -------------------------------------------------------------------------
  db "ABCDEFGHIJKLMNOP ", 0                     ; +0x0194: Tilladte drevnavne (A..P)
  dw 0xffff                                     ; +0x01a6: Drevmaske-terminator
  db 0x0d, 0x0a, "Open file on drive(s) ", 0    ; +0x01a8: "Open file on drive(s) "
  db ",", 0x0d, 0x0a, 0x0d, 0x0a, "Printer Busy", 0x0d, 0x0a, 0 ; +0x01c2: Printer optaget streng
  times 11 db 0                                 ; +0x01d5..+0x01df: Slutjustering til 480 bytes (0x1E0)
data_end:

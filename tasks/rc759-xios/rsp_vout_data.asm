; ===========================================================================
; Regnecentralen RC759 Piccoline — VOUT.RSP Data Segment
;
; Rekonstrueret datasegment for VOUT.RSP (58 paragraphs = 928 bytes)
; Indeholder ulinket Process Descriptor for VOUT, User Data Area (UDA),
; initialiseringsstak, kø-deskriptorer (VOUTQ, VINQ, VCMXQ) og arbejdsbuffere.
; ===========================================================================

data_start:
  ; -------------------------------------------------------------------------
  ; RSP Header (4 bytes)
  ; -------------------------------------------------------------------------
  dw 0x0000                                     ; +0x0000: Link field (0 = ulinket)
  dw 0x0047                                     ; +0x0002: RSP Code segment size / entry
  times 17 db 0                                 ; +0x0004..+0x0014: Reserveret

  ; -------------------------------------------------------------------------
  ; Process Descriptor (PD): "VOUT    "
  ; -------------------------------------------------------------------------
  db 0xb4                                       ; +0x0015: Standard prioritet = 180 (0xB4)
  dw 0x0003                                     ; +0x0016: Status / pf_keep = 3
  db "VOUT    "                                 ; +0x0018: Procesnavn (8 tegn, uinitialiseret konsolnr)
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
data_end:

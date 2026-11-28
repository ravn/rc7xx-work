; ===========================================================================
; Regnecentralen RC759 Piccoline — TMP759.RSP Data Segment
;
; Rekonstrueret datasegment for TMP759.RSP (70 paragraphs = 1.120 bytes)
; Indeholder Process Descriptor, User Data Area (UDA), køer for input/display,
; filnavneskabeloner og netværkskonfiguration.
; ===========================================================================

data_start:
  db 0x00, 0x00, 0x47                           ; +0x0000: Link fields
  times 18 db 0                                 ; +0x0003: Reserved
  db 0xc6, 0x03                                 ; +0x0015: Thread / state
  db 0x00                                       ; +0x0017: Status

; ---------------------------------------------------------------------------
; Process Descriptor (PD): "Tmp     "
; ---------------------------------------------------------------------------
  db "Tmp     "                                 ; +0x0018: Procesnavn (8 tegn)
  db 0x04                                       ; +0x0020: Priority / flags
  times 5 db 0                                  ; +0x0021
  db 0xff, 0xff                                 ; +0x0026: Parent / abort mask
  times 76 db 0                                 ; +0x0028: PD reserveret

; ---------------------------------------------------------------------------
; User Data Area (UDA): Stak og kontekst
; ---------------------------------------------------------------------------
  db 0x3a, 0x01                                 ; +0x0074: Initial stack pointer SP = 0x013A
  times 42 db 0                                 ; +0x0076: UDA headers
  db 0x01                                       ; +0x00a0: Initial status
  times 7 db 0                                  ; +0x00a1
  db 0xbb, 0xbb, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc ; +0x00a8: Stakbund
  db 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc
  times 130 db 0xcc                             ; +0x00b8: UDA INT3 stak-fyld op til 0x013A
  times 14 db 0                                 ; +0x013a: Staktop / justering

; ---------------------------------------------------------------------------
; Buffere og kommandotilstand
; ---------------------------------------------------------------------------
  db 0x80                                       ; +0x0148: Standard bufferstørrelse (128 bytes)
  times 139 db 0                                ; +0x0149: Primær I/O buffer
  db 0x80                                       ; +0x01d4: Sekundær bufferstørrelse (128 bytes)
  times 135 db 0                                ; +0x01d5: Sekundær buffer

; ---------------------------------------------------------------------------
; Systemfiler og konfigurationsskabeloner
; ---------------------------------------------------------------------------
  db 0xd2, 0x02, 0xaf, 0x02, 0x4a, 0x01         ; +0x025c: Interne funktionspointere
  db 0x00, 0x00, 0x80, 0x00, 0x00               ; +0x0262
  db "FUNCTIONSYS"                              ; +0x0267: Funktionstast- og systemdefinitioner
  times 25 db 0                                 ; +0x0272
  db "STARTUP x  "                              ; +0x028b: Konsol-startfil (x erstattes med konsolnr 0..3)
  times 24 db 0                                 ; +0x0296
  db 0x3f                                       ; +0x02ae: Drevmaske / standard
  times 171 db 0                                ; +0x02af: Parse-arbejdsområde

; ---------------------------------------------------------------------------
; Interprocess-køer (Queues)
; ---------------------------------------------------------------------------
  db "Tmp     p"                                ; +0x035a: Queue Descriptor: TMP Pipe / Prompt
  db 0x00, 0x01                                 ; +0x0363: Beskedtæller / kapacitet
  times 9 db 0                                  ; +0x0365
  db 0x70, 0x03                                 ; +0x036e: Bufferpointer (0x0370)
  times 118 db 0                                ; +0x0370: Kø-buffer

  db 0x48, 0x01                                 ; +0x03e6: Link / status
  db "Tmp     d"                                ; +0x03e8: Queue Descriptor: TMP Display / Output
  db 0x00, 0x0a, 0x00, 0x01, 0x00               ; +0x03f1: Kø-egenskaber (5 bytes)

; ---------------------------------------------------------------------------
; Skærm- og formatstrenge
; ---------------------------------------------------------------------------
  db 0x1b, "Y  ", 0                             ; +0x03f6: VT100 cursor-positionering
  db "Size =     K bytes", 0x0d, 0x0a, 0        ; +0x03fb: SIZE kommando svarstreng

; ---------------------------------------------------------------------------
; RC-Net konfiguration og navnetabel
; ---------------------------------------------------------------------------
  db 0x00, 0xc0, 0x00, 0x00                     ; +0x0410: Netværkstilstandsflag
  db "PASSWORD"                                 ; +0x0414: RC-Net adgangskodefil
  db 0x00, 0x00, 0x00, 0x00                     ; +0x041c
  db 0x10                                       ; +0x0420: Attribut
  db "NAMSVR  DAT"                              ; +0x0421: RC-Net navneserver datafil
  times 24 db 0                                 ; +0x042c: FCB-felter (24 bytes)
  db "                  "                       ; +0x0444: Reserveret arbejdsplads
  times 10 db 0                                 ; +0x0456: Slutjustering

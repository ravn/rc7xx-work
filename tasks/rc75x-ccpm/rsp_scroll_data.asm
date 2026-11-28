; ===========================================================================
; Regnecentralen RC759 Piccoline — SCROLL.RSP Data Segment
; RSPHDR + PD + UDA + MXdma0 koe (20 paragraphs = 320 bytes)
; ===========================================================================

scroll_data_start:

; --- RSP Header ---
scroll_rsphdr:
%ifdef CCPM_SYS
  dw 0x1264                                    ; p_link i CCPM.SYS
%else
  dw 0x0000                                    ; ulinket i standalone .RSP
%endif
  times 7 dw 0                                 ; Reserveret / ubrugt

; --- Process Descriptor (PD): "SCROLL  " ---
scroll_pd:
  dw 0, 0                                      ; p_link, p_thread
  db 0                                         ; p_stat
  db 0xb0                                      ; p_prior = 176 (højere end normale processer)
  dw 2                                         ; p_flag = pf_keep (må ikke dræbes)
  db "SCROLL  "                                ; p_name (8 tegn)
  dw 4                                         ; p_uda (UDA paragraf-offset = 4 paragraffer = 64 bytes)
  times 46 db 0                                ; Resterende PD-felter

; --- User Data Area (UDA): Stak og kontekst ---
scroll_uda:
  times 36 db 0                                ; +0x50: UDA headers
  dw 0x013a                                    ; +0x74: Initial stak-top pointer (offset 0x013A)
  times 26 db 0                                ; +0x76..+0x8F: Reserveret UDA plads (26 bytes)
%ifdef CCPM_SYS
  dw 0x1326, 0x1312, 0x1312, 0x1312             ; +0x90..+0x97: Runtime segmenter patched af GENCCPM
  times 8 db 0                                 ; +0x98..+0x9F
%else
  times 16 db 0                                ; +0x90..+0x9F: Unlinked segmentplads
%endif
  dw 0x0001                                    ; +0xA0: Initial aktiv status (INSYS)
  dw 0xcccc, 0xcccc, 0xcccc                    ; +0xA2: UDA INT3 stak-fyld
  times 8 db 0                                 ; +0xA8..+0xAF: Mellemrum

; --- MXdma0 Queue Descriptor ---
mxdma0_queue:
  db "MXdma0  "                                ; +0xB0: Mutex-navn: Mutual Exclusion DMA kanal 0
mxdma0_qd:
  times 65 dw 0xcccc                           ; +0xB8: 130 bytes INT3 fyld / Queue Descriptor buffer
  times 6 db 0                                 ; +0x13A..+0x13F: Afsluttende nuller (320 bytes i alt)

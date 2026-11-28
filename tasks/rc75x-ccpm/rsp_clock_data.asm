; ===========================================================================
; Regnecentralen RC759 Piccoline — CLOCK.RSP Data Segment
; RSPHDR + PD + UDA (20 paragraphs = 320 bytes)
; ===========================================================================

clock_data_start:

; --- RSP Header ---
clock_rsphdr:
%ifdef CCPM_SYS
  dw 0x0FCE                                    ; p_link (GENCCPM pointer til næste RSP: PIN0)
%else
  dw 0x0000                                    ; ulinket i standalone .RSP
%endif
  times 7 dw 0                                 ; Reserveret / ubrugt

; --- Process Descriptor (PD) for CLOCK ---
clock_pd:
  dw 0, 0                                      ; p_link, p_thread
  db 0                                         ; p_stat (0 = ps_run)
  db 190                                       ; p_prior (prioritet 190, høj prioritet for tidsstyring)
  dw 2                                         ; p_flag (2 = pf_keep, må aldrig termineres)
  db "CLOCK   "                                ; p_name (8 tegn, rum-padded)
  dw 4                                         ; p_uda (UDA paragraf offset = 4 paragraffer = 0x40 bytes)
  db 0, 0, 0, 0                                ; p_dsk, p_usr, p_ldsk, p_luser
  dw 0                                         ; p_mem (hukommelsespartition)
  dw 0, 0                                      ; p_dvract, p_wait
  db 0, 0                                      ; p_org, p_net
  dw 0                                         ; p_parent
  db 0, 0, 0, 0                                ; p_cns, p_abort, p_cin, p_cout
  db 0, 0, 0, 0                                ; p_lst, p_sf3, p_sf4, p_sf5
  dw 0, 0, 0, 0                                ; p_reserved, p_pret, p_scratch

; --- User Data Area (UDA) ---
clock_uda:
  times 26 dw 0                                ; Default DMA buffer og scratch (52 bytes)
  dw 0x013A                                    ; p_sp (initial stakpeger = 0x013A)
  times 13 dw 0                                ; Reserveret UDA plads (26 bytes)
%ifdef CCPM_SYS
  dw 0x1197, 0x1183, 0x1183, 0x1183            ; Runtime segmenter patched af GENCCPM
%else
  times 4 dw 0                                 ; Upatched i standalone .RSP
%endif
  times 4 dw 0
  db 1, 0                                      ; UDA flag (INSYS <> 0: bliv på UDA stak ved SUP-kald)

; --- UDA Stakområde fyldt med 0xCC ---
clock_stack:
  times 152 db 0xCC

; --- Initial Stack Frame ---
clock_stack_top:
  dw 0x0003                                    ; Initial IP (clock_entry)
  dw 0                                         ; Initial CS (sat af GENCCPM)
  dw 0                                         ; Initiale flag (sat af GENCCPM)

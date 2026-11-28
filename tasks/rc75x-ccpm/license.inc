; =============================================================================
; license.inc — DRI-licensnummer + serienummer i copyright-strengen
; =============================================================================
; HVER MODUL (MEMIF) i CCP/M-86 bærer en copyright-streng der slutter med
; licensnummer + serienummer. I DRI's kilde (ccpmv31 D1/INIT.SUP l.21-25) står
; der:
;     db 'COPYRIGHT (C) 1982,1983,1984'
;     db ' DIGITAL RESEARCH '
;     db 'XXXX-0000-'
; serial  db '654321'          ; placeholder
; GENCCPM patcher placeholderen pr. licensager ved systemgenerering
; (D7/GENC1.C: copynote "COPYRIGHT (C) 1983, DIGITAL RESEARCH XXXX-0000-654321").
; Der er INGEN runtime-validering — strengen er udelukkende licens-identifikation.
;
; RC759 Piccoline-distributionen (SW1400): Regnecentralens DRI-licens
; 1034-0261, serienummer 007041.
;
; Overskriv ved generering af en variant (svarende til GENCCPMs patch):
;   nasm -f bin -DLICENSE_NO='"1034-0261-"' -DSERIAL='"007042"' -o ccpm_out.sys ccpm.asm
; Værdierne SKAL medleveres med indre anførselstegn som vist.

%ifndef LICENSE_NO
  %define LICENSE_NO "1034-0261-"
%endif

%ifndef SERIAL
  %define SERIAL "007041"
%endif

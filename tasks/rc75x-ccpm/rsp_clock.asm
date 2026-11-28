; ===========================================================================
; RSP 2: CLOCK — Tids- og datostyring via system-tick (Digital Research)
; Placering i ccpm.sys: 0x11430 - 0x115EF (448 bytes = 28 paragraffer)
;   - Del 1: Data Segment (0x11430 - 0x1156F, 320 bytes: RSPHDR + PD + UDA)
;   - Del 2: Code Segment (0x11570 - 0x115EF, 128 bytes: kode)
; ===========================================================================

%define CCPM_SYS 1
%include "rsp_clock_data.asm"
%include "rsp_clock_code.asm"

; ===========================================================================
; RSP 5: SCROLL — Bloed rulning via Intel 82730 tekstprocessor og MXdma0
; Offset range: 0x12E60 - 0x12EFF (160 bytes: 112 bytes kode + 48 bytes trailer)
; ===========================================================================

%include "rsp_scroll_code.asm"

; --- GENCCPM trailer og sektor-padding (48 bytes: 0x12ED0 - 0x12EFF) ---
genccpm_trailer:
  db "GENCCPM  v3.1  [2/7/84]", 0x0A, 0x00    ; 12ED0: GENCCPM versionsstempel
  times 23 db 0x00                             ; 12EE9: Nul-fyld frem til 77.568 bytes

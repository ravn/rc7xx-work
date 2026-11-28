; SCROLL.RSP — standalone .CMD-byg (NASM, -f bin)
; Oracle: dist/genccpm-kit/scroll.rsp (640 B) — SW1400 disk 2 (Bits:30005381)
; Byg:    nasm -f bin -o scroll.rsp scroll_rsp.asm
; Layout: [128 B .CMD-header][Kodegruppe][Datagruppe][nulpadding til multiplum af 128]
; RASM-86-linket færdigbillede: faste segmentvaerdier, INGEN fixup-records.
; Kilder: kode=annoteret (uaendret), data=annoteret (uaendret)

%include "rspsrc/scroll_cmdhdr.asm"
%include "rsp_scroll_code.asm"
%include "rsp_scroll_data.asm"

align 128, db 0

; TMP759.RSP — standalone .CMD-byg (NASM, -f bin)
; Oracle: dist/genccpm-kit/tmp759.rsp (7168 B) — SW1400 disk 2 (Bits:30005381)
; Byg:    nasm -f bin -o tmp759.rsp tmp759_rsp.asm
; Layout: [128 B .CMD-header][Kodegruppe][Datagruppe][nulpadding til multiplum af 128]
; RASM-86-linket færdigbillede: faste segmentvaerdier, INGEN fixup-records.
; Kilder: kode=annoteret (uaendret), data=annoteret (uaendret)

%include "rspsrc/tmp759_cmdhdr.asm"
%include "rsp_tmp759.asm"
%include "rsp_tmp759_data.asm"

align 128, db 0

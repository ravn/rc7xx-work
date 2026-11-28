; VOUT.RSP — standalone .CMD-byg (NASM, -f bin)
; Oracle: dist/genccpm-kit/vout.rsp (2944 B) — SW1400 disk 2 (Bits:30005381)
; Byg:    nasm -f bin -o vout.rsp vout_rsp.asm
; Layout: [128 B .CMD-header][Kodegruppe][Datagruppe][nulpadding til multiplum af 128]
; RASM-86-linket færdigbillede: faste segmentvaerdier, INGEN fixup-records.
; Kilder: kode=annoteret (uaendret), data=annoteret (uaendret)

%include "rspsrc/vout_cmdhdr.asm"
%include "rsp_vout_code.asm"
%include "rsp_vout_data.asm"

align 128, db 0

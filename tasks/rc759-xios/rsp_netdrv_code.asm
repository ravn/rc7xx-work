; ===========================================================================
; Regnecentralen RC759 Piccoline — NETDRV.RSP Code Segment
; RC-Net Datalink Driver for Intel 82586 Ethernet LAN Controller
; Indeholder processerne NETDRV, REC og XMIT samt link_req og XMIT_REQ koer
; 1095 paragraffer = 17.520 bytes
; ===========================================================================

  db 0x00, 0x00                ; 00000000  add [bx+si],al
  db 0x00, 0x00                ; 00000002  add [bx+si],al
  db 0x00, 0x00                ; 00000004  add [bx+si],al
  db 0x00, 0x00                ; 00000006  add [bx+si],al
  db 0x00, 0x00                ; 00000008  add [bx+si],al
  db 0x00, 0x00                ; 0000000A  add [bx+si],al
  db 0x00, 0x00                ; 0000000C  add [bx+si],al
  db 0x00, 0x00                ; 0000000E  add [bx+si],al
  db 0x00, 0x00                ; 00000010  add [bx+si],al
  db 0x00, 0x00                ; 00000012  add [bx+si],al
  db 0x00, 0x20                ; 00000014  add [bx+si],ah
  db 0x03, 0x00                ; 00000016  add ax,[bx+si]
  db 0x4E                      ; 00000018  dec si
  db 0x45                      ; 00000019  inc bp
  db 0x54                      ; 0000001A  push sp
  db 0x44                      ; 0000001B  inc sp
  db 0x52                      ; 0000001C  push dx
  db 0x56                      ; 0000001D  push si
  db 0x20, 0x20                ; 0000001E  and [bx+si],ah
  db 0x04, 0x00                ; 00000020  add al,0x0
  db 0x00, 0x00                ; 00000022  add [bx+si],al
  db 0x00, 0x00                ; 00000024  add [bx+si],al
  db 0x00, 0x00                ; 00000026  add [bx+si],al
  db 0x00, 0x00                ; 00000028  add [bx+si],al
  db 0x00, 0x00                ; 0000002A  add [bx+si],al
  db 0x00, 0x00                ; 0000002C  add [bx+si],al
  db 0x00, 0x00                ; 0000002E  add [bx+si],al
  db 0x00, 0x00                ; 00000030  add [bx+si],al
  db 0x00, 0x00                ; 00000032  add [bx+si],al
  db 0x00, 0x00                ; 00000034  add [bx+si],al
  db 0x00, 0x00                ; 00000036  add [bx+si],al
  db 0x00, 0x00                ; 00000038  add [bx+si],al
  db 0x00, 0x00                ; 0000003A  add [bx+si],al
  db 0x00, 0x00                ; 0000003C  add [bx+si],al
  db 0x00, 0x00                ; 0000003E  add [bx+si],al
  db 0x00, 0x00                ; 00000040  add [bx+si],al
  db 0x00, 0x00                ; 00000042  add [bx+si],al
  db 0x00, 0x00                ; 00000044  add [bx+si],al
  db 0x00, 0x00                ; 00000046  add [bx+si],al
  db 0x00, 0x00                ; 00000048  add [bx+si],al
  db 0x00, 0x00                ; 0000004A  add [bx+si],al
  db 0x00, 0x00                ; 0000004C  add [bx+si],al
  db 0x00, 0x00                ; 0000004E  add [bx+si],al
  db 0x00, 0x00                ; 00000050  add [bx+si],al
  db 0x00, 0x00                ; 00000052  add [bx+si],al
  db 0x00, 0x00                ; 00000054  add [bx+si],al
  db 0x00, 0x00                ; 00000056  add [bx+si],al
  db 0x00, 0x00                ; 00000058  add [bx+si],al
  db 0x00, 0x00                ; 0000005A  add [bx+si],al
  db 0x00, 0x00                ; 0000005C  add [bx+si],al
  db 0x00, 0x00                ; 0000005E  add [bx+si],al
  db 0x00, 0x00                ; 00000060  add [bx+si],al
  db 0x00, 0x00                ; 00000062  add [bx+si],al
  db 0x00, 0x00                ; 00000064  add [bx+si],al
  db 0x00, 0x00                ; 00000066  add [bx+si],al
  db 0x00, 0x00                ; 00000068  add [bx+si],al
  db 0x00, 0x00                ; 0000006A  add [bx+si],al
  db 0x00, 0x00                ; 0000006C  add [bx+si],al
  db 0x00, 0x00                ; 0000006E  add [bx+si],al
  db 0x00, 0x00                ; 00000070  add [bx+si],al
  db 0x00, 0x00                ; 00000072  add [bx+si],al
  db 0x5E                      ; 00000074  pop si
  db 0x01, 0x00                ; 00000075  add [bx+si],ax
  db 0x00, 0x00                ; 00000077  add [bx+si],al
  db 0x00, 0x00                ; 00000079  add [bx+si],al
  db 0x00, 0x00                ; 0000007B  add [bx+si],al
  db 0x00, 0x00                ; 0000007D  add [bx+si],al
  db 0x00, 0x00                ; 0000007F  add [bx+si],al
  db 0x00, 0x00                ; 00000081  add [bx+si],al
  db 0x00, 0x00                ; 00000083  add [bx+si],al
  db 0x00, 0x00                ; 00000085  add [bx+si],al
  db 0x00, 0x00                ; 00000087  add [bx+si],al
  db 0x00, 0x00                ; 00000089  add [bx+si],al
  db 0x00, 0x00                ; 0000008B  add [bx+si],al
  db 0x00, 0x00                ; 0000008D  add [bx+si],al
  db 0x00, 0x00                ; 0000008F  add [bx+si],al
  db 0x00, 0x00                ; 00000091  add [bx+si],al
  db 0x00, 0x00                ; 00000093  add [bx+si],al
  db 0x00, 0x00                ; 00000095  add [bx+si],al
  db 0x00, 0x00                ; 00000097  add [bx+si],al
  db 0x00, 0x00                ; 00000099  add [bx+si],al
  db 0x00, 0x00                ; 0000009B  add [bx+si],al
  db 0x00, 0x00                ; 0000009D  add [bx+si],al
  db 0x00, 0x00                ; 0000009F  add [bx+si],al
  db 0x00, 0x00                ; 000000A1  add [bx+si],al
  db 0x00, 0x00                ; 000000A3  add [bx+si],al
  db 0x00, 0x00                ; 000000A5  add [bx+si],al
  db 0x00, 0x00                ; 000000A7  add [bx+si],al
  db 0x00, 0x00                ; 000000A9  add [bx+si],al
  db 0x00, 0x00                ; 000000AB  add [bx+si],al
  db 0x00, 0x00                ; 000000AD  add [bx+si],al
  db 0x00, 0x00                ; 000000AF  add [bx+si],al
  db 0x00, 0x00                ; 000000B1  add [bx+si],al
  db 0x00, 0x00                ; 000000B3  add [bx+si],al
  db 0x00, 0x00                ; 000000B5  add [bx+si],al
  db 0x00, 0x00                ; 000000B7  add [bx+si],al
  db 0x00, 0x00                ; 000000B9  add [bx+si],al
  db 0x00, 0x00                ; 000000BB  add [bx+si],al
  db 0x00, 0x00                ; 000000BD  add [bx+si],al
  db 0x00, 0x00                ; 000000BF  add [bx+si],al
  db 0x00, 0x00                ; 000000C1  add [bx+si],al
  db 0x00, 0x00                ; 000000C3  add [bx+si],al
  db 0x00, 0x00                ; 000000C5  add [bx+si],al
  db 0x00, 0x00                ; 000000C7  add [bx+si],al
  db 0x00, 0x00                ; 000000C9  add [bx+si],al
  db 0x00, 0x00                ; 000000CB  add [bx+si],al
  db 0x00, 0x00                ; 000000CD  add [bx+si],al
  db 0x00, 0x00                ; 000000CF  add [bx+si],al
  db 0x00, 0x00                ; 000000D1  add [bx+si],al
  db 0x00, 0x00                ; 000000D3  add [bx+si],al
  db 0x00, 0x00                ; 000000D5  add [bx+si],al
  db 0x00, 0x00                ; 000000D7  add [bx+si],al
  db 0x00, 0x00                ; 000000D9  add [bx+si],al
  db 0x00, 0x00                ; 000000DB  add [bx+si],al
  db 0x00, 0x00                ; 000000DD  add [bx+si],al
  db 0x00, 0x00                ; 000000DF  add [bx+si],al
  db 0x00, 0x00                ; 000000E1  add [bx+si],al
  db 0x00, 0x00                ; 000000E3  add [bx+si],al
  db 0x00, 0x00                ; 000000E5  add [bx+si],al
  db 0x00, 0x00                ; 000000E7  add [bx+si],al
  db 0x00, 0x00                ; 000000E9  add [bx+si],al
  db 0x00, 0x00                ; 000000EB  add [bx+si],al
  db 0x00, 0x00                ; 000000ED  add [bx+si],al
  db 0x00, 0x00                ; 000000EF  add [bx+si],al
  db 0x00, 0x00                ; 000000F1  add [bx+si],al
  db 0x00, 0x00                ; 000000F3  add [bx+si],al
  db 0x00, 0x00                ; 000000F5  add [bx+si],al
  db 0x00, 0x00                ; 000000F7  add [bx+si],al
  db 0x00, 0x00                ; 000000F9  add [bx+si],al
  db 0x00, 0x00                ; 000000FB  add [bx+si],al
  db 0x00, 0x00                ; 000000FD  add [bx+si],al
  db 0x00, 0x00                ; 000000FF  add [bx+si],al
  db 0x00, 0x00                ; 00000101  add [bx+si],al
  db 0x00, 0x00                ; 00000103  add [bx+si],al
  db 0x00, 0x00                ; 00000105  add [bx+si],al
  db 0x00, 0x00                ; 00000107  add [bx+si],al
  db 0x00, 0x00                ; 00000109  add [bx+si],al
  db 0x00, 0x00                ; 0000010B  add [bx+si],al
  db 0x00, 0x00                ; 0000010D  add [bx+si],al
  db 0x00, 0x00                ; 0000010F  add [bx+si],al
  db 0x00, 0x00                ; 00000111  add [bx+si],al
  db 0x00, 0x00                ; 00000113  add [bx+si],al
  db 0x00, 0x00                ; 00000115  add [bx+si],al
  db 0x00, 0x00                ; 00000117  add [bx+si],al
  db 0x00, 0x00                ; 00000119  add [bx+si],al
  db 0x00, 0x00                ; 0000011B  add [bx+si],al
  db 0x00, 0x00                ; 0000011D  add [bx+si],al
  db 0x00, 0x00                ; 0000011F  add [bx+si],al
  db 0x00, 0x00                ; 00000121  add [bx+si],al
  db 0x00, 0x00                ; 00000123  add [bx+si],al
  db 0x00, 0x00                ; 00000125  add [bx+si],al
  db 0x00, 0x00                ; 00000127  add [bx+si],al
  db 0x00, 0x00                ; 00000129  add [bx+si],al
  db 0x00, 0x00                ; 0000012B  add [bx+si],al
  db 0x00, 0x00                ; 0000012D  add [bx+si],al
  db 0x00, 0x00                ; 0000012F  add [bx+si],al
  db 0x00, 0x00                ; 00000131  add [bx+si],al
  db 0x00, 0x00                ; 00000133  add [bx+si],al
  db 0x00, 0x00                ; 00000135  add [bx+si],al
  db 0x00, 0x00                ; 00000137  add [bx+si],al
  db 0x00, 0x00                ; 00000139  add [bx+si],al
  db 0x00, 0x00                ; 0000013B  add [bx+si],al
  db 0x00, 0x00                ; 0000013D  add [bx+si],al
  db 0x00, 0xCC                ; 0000013F  add ah,cl
  db 0xCC                      ; 00000141  int3
  db 0xCC                      ; 00000142  int3
  db 0xCC                      ; 00000143  int3
  db 0xCC                      ; 00000144  int3
  db 0xCC                      ; 00000145  int3
  db 0xCC                      ; 00000146  int3
  db 0xCC                      ; 00000147  int3
  db 0xCC                      ; 00000148  int3
  db 0xCC                      ; 00000149  int3
  db 0xCC                      ; 0000014A  int3
  db 0xCC                      ; 0000014B  int3
  db 0xCC                      ; 0000014C  int3
  db 0xCC                      ; 0000014D  int3
  db 0xCC                      ; 0000014E  int3
  db 0xCC                      ; 0000014F  int3
  db 0xCC                      ; 00000150  int3
  db 0xCC                      ; 00000151  int3
  db 0xCC                      ; 00000152  int3
  db 0xCC                      ; 00000153  int3
  db 0xCC                      ; 00000154  int3
  db 0xCC                      ; 00000155  int3
  db 0xCC                      ; 00000156  int3
  db 0xCC                      ; 00000157  int3
  db 0xCC                      ; 00000158  int3
  db 0xCC                      ; 00000159  int3
  db 0xCC                      ; 0000015A  int3
  db 0xCC                      ; 0000015B  int3
  db 0xCC                      ; 0000015C  int3
  db 0xCC                      ; 0000015D  int3
  db 0x26, 0x07                ; 0000015E  es pop es
  db 0x00, 0x00                ; 00000160  add [bx+si],al
  db 0x00, 0x00                ; 00000162  add [bx+si],al
  db 0x00, 0x00                ; 00000164  add [bx+si],al
  db 0x00, 0x00                ; 00000166  add [bx+si],al
  db 0x00, 0x00                ; 00000168  add [bx+si],al
  db 0x00, 0x00                ; 0000016A  add [bx+si],al
  db 0x00, 0x00                ; 0000016C  add [bx+si],al
  db 0x00, 0x00                ; 0000016E  add [bx+si],al
  db 0x00, 0x00                ; 00000170  add [bx+si],al
  db 0x00, 0x00                ; 00000172  add [bx+si],al
  db 0x00, 0x00                ; 00000174  add [bx+si],al
  db 0x00, 0x00                ; 00000176  add [bx+si],al
  db 0x00, 0x00                ; 00000178  add [bx+si],al
  db 0x00, 0x00                ; 0000017A  add [bx+si],al
  db 0x00, 0x00                ; 0000017C  add [bx+si],al
  db 0x00, 0x00                ; 0000017E  add [bx+si],al
  db 0x00, 0x00                ; 00000180  add [bx+si],al
  db 0x00, 0x00                ; 00000182  add [bx+si],al
  db 0x00, 0x00                ; 00000184  add [bx+si],al
  db 0x00, 0x00                ; 00000186  add [bx+si],al
  db 0x00, 0x00                ; 00000188  add [bx+si],al
  db 0x00, 0x00                ; 0000018A  add [bx+si],al
  db 0x00, 0x00                ; 0000018C  add [bx+si],al
  db 0x00, 0x00                ; 0000018E  add [bx+si],al
  db 0x00, 0x00                ; 00000190  add [bx+si],al
  db 0x00, 0x00                ; 00000192  add [bx+si],al
  db 0x00, 0x00                ; 00000194  add [bx+si],al
  db 0x00, 0x00                ; 00000196  add [bx+si],al
  db 0x00, 0x00                ; 00000198  add [bx+si],al
  db 0x00, 0x00                ; 0000019A  add [bx+si],al
  db 0x00, 0x00                ; 0000019C  add [bx+si],al
  db 0x00, 0x00                ; 0000019E  add [bx+si],al
  db 0x00, 0x00                ; 000001A0  add [bx+si],al
  db 0x00, 0x00                ; 000001A2  add [bx+si],al
  db 0x00, 0x00                ; 000001A4  add [bx+si],al
  db 0x00, 0x00                ; 000001A6  add [bx+si],al
  db 0x00, 0x00                ; 000001A8  add [bx+si],al
  db 0x00, 0x00                ; 000001AA  add [bx+si],al
  db 0x00, 0x00                ; 000001AC  add [bx+si],al
  db 0x00, 0x00                ; 000001AE  add [bx+si],al
  db 0x00, 0x00                ; 000001B0  add [bx+si],al
  db 0x00, 0x00                ; 000001B2  add [bx+si],al
  db 0x00, 0x00                ; 000001B4  add [bx+si],al
  db 0x00, 0x00                ; 000001B6  add [bx+si],al
  db 0x00, 0x00                ; 000001B8  add [bx+si],al
  db 0x00, 0x00                ; 000001BA  add [bx+si],al
  db 0x00, 0x00                ; 000001BC  add [bx+si],al
  db 0x00, 0x00                ; 000001BE  add [bx+si],al
  db 0x00, 0x00                ; 000001C0  add [bx+si],al
  db 0x00, 0x00                ; 000001C2  add [bx+si],al
  db 0x00, 0x00                ; 000001C4  add [bx+si],al
  db 0x00, 0x00                ; 000001C6  add [bx+si],al
  db 0x00, 0x00                ; 000001C8  add [bx+si],al
  db 0x00, 0x00                ; 000001CA  add [bx+si],al
  db 0x00, 0x00                ; 000001CC  add [bx+si],al
  db 0x00, 0x00                ; 000001CE  add [bx+si],al
  db 0x00, 0x00                ; 000001D0  add [bx+si],al
  db 0x00, 0x00                ; 000001D2  add [bx+si],al
  db 0x00, 0x00                ; 000001D4  add [bx+si],al
  db 0x00, 0x00                ; 000001D6  add [bx+si],al
  db 0x00, 0x00                ; 000001D8  add [bx+si],al
  db 0x00, 0x00                ; 000001DA  add [bx+si],al
  db 0x00, 0x00                ; 000001DC  add [bx+si],al
  db 0x00, 0x00                ; 000001DE  add [bx+si],al
  db 0x00, 0x00                ; 000001E0  add [bx+si],al
  db 0x00, 0x00                ; 000001E2  add [bx+si],al
  db 0x00, 0x00                ; 000001E4  add [bx+si],al
  db 0x00, 0x00                ; 000001E6  add [bx+si],al
  db 0x00, 0x00                ; 000001E8  add [bx+si],al
  db 0x00, 0x00                ; 000001EA  add [bx+si],al
  db 0x00, 0x00                ; 000001EC  add [bx+si],al
  db 0x00, 0x00                ; 000001EE  add [bx+si],al
  db 0x00, 0x00                ; 000001F0  add [bx+si],al
  db 0x00, 0x00                ; 000001F2  add [bx+si],al
  db 0x00, 0x00                ; 000001F4  add [bx+si],al
  db 0x00, 0x00                ; 000001F6  add [bx+si],al
  db 0x00, 0x00                ; 000001F8  add [bx+si],al
  db 0x00, 0x00                ; 000001FA  add [bx+si],al
  db 0x00, 0x00                ; 000001FC  add [bx+si],al
  db 0x00, 0x00                ; 000001FE  add [bx+si],al
  db 0x00, 0x00                ; 00000200  add [bx+si],al
  db 0x00, 0x00                ; 00000202  add [bx+si],al
  db 0x00, 0x00                ; 00000204  add [bx+si],al
  db 0x00, 0x00                ; 00000206  add [bx+si],al
  db 0x00, 0x00                ; 00000208  add [bx+si],al
  db 0x00, 0x00                ; 0000020A  add [bx+si],al
  db 0x00, 0x00                ; 0000020C  add [bx+si],al
  db 0x00, 0x00                ; 0000020E  add [bx+si],al
  db 0x00, 0x00                ; 00000210  add [bx+si],al
  db 0x00, 0x00                ; 00000212  add [bx+si],al
  db 0x00, 0x00                ; 00000214  add [bx+si],al
  db 0x00, 0x00                ; 00000216  add [bx+si],al
  db 0x00, 0x00                ; 00000218  add [bx+si],al
  db 0x00, 0x00                ; 0000021A  add [bx+si],al
  db 0x00, 0x00                ; 0000021C  add [bx+si],al
  db 0x00, 0x00                ; 0000021E  add [bx+si],al
  db 0x00, 0x00                ; 00000220  add [bx+si],al
  db 0x00, 0x00                ; 00000222  add [bx+si],al
  db 0x00, 0x00                ; 00000224  add [bx+si],al
  db 0x00, 0x00                ; 00000226  add [bx+si],al
  db 0x00, 0x00                ; 00000228  add [bx+si],al
  db 0x00, 0x00                ; 0000022A  add [bx+si],al
  db 0x00, 0x00                ; 0000022C  add [bx+si],al
  db 0x00, 0x00                ; 0000022E  add [bx+si],al
  db 0x00, 0x00                ; 00000230  add [bx+si],al
  db 0x00, 0x00                ; 00000232  add [bx+si],al
  db 0x00, 0x00                ; 00000234  add [bx+si],al
  db 0x00, 0x00                ; 00000236  add [bx+si],al
  db 0x00, 0x00                ; 00000238  add [bx+si],al
  db 0x00, 0x00                ; 0000023A  add [bx+si],al
  db 0x00, 0x00                ; 0000023C  add [bx+si],al
  db 0x00, 0x00                ; 0000023E  add [bx+si],al
  db 0x00, 0x00                ; 00000240  add [bx+si],al
  db 0x00, 0x00                ; 00000242  add [bx+si],al
  db 0x00, 0x00                ; 00000244  add [bx+si],al
  db 0x00, 0x00                ; 00000246  add [bx+si],al
  db 0x00, 0x00                ; 00000248  add [bx+si],al
  db 0x00, 0x00                ; 0000024A  add [bx+si],al
  db 0x00, 0x00                ; 0000024C  add [bx+si],al
  db 0x00, 0x00                ; 0000024E  add [bx+si],al
  db 0x00, 0x00                ; 00000250  add [bx+si],al
  db 0x00, 0x00                ; 00000252  add [bx+si],al
  db 0x00, 0x00                ; 00000254  add [bx+si],al
  db 0x00, 0x00                ; 00000256  add [bx+si],al
  db 0x00, 0x00                ; 00000258  add [bx+si],al
  db 0x00, 0x00                ; 0000025A  add [bx+si],al
  db 0x00, 0x00                ; 0000025C  add [bx+si],al
  db 0x00, 0x00                ; 0000025E  add [bx+si],al
  db 0x00, 0x00                ; 00000260  add [bx+si],al
  db 0x00, 0x00                ; 00000262  add [bx+si],al
  db 0x00, 0x00                ; 00000264  add [bx+si],al
  db 0x00, 0x00                ; 00000266  add [bx+si],al
  db 0x00, 0x00                ; 00000268  add [bx+si],al
  db 0x00, 0x00                ; 0000026A  add [bx+si],al
  db 0x00, 0x00                ; 0000026C  add [bx+si],al
  db 0x00, 0x00                ; 0000026E  add [bx+si],al
  db 0xD0, 0x04                ; 00000270  rol byte [si],1
  db 0x00, 0x00                ; 00000272  add [bx+si],al
  db 0x00, 0x02                ; 00000274  add [bp+si],al
  db 0x03, 0x00                ; 00000276  add ax,[bx+si]
  db 0x52                      ; 00000278  push dx
  db 0x45                      ; 00000279  inc bp
  db 0x43                      ; 0000027A  inc bx
  db 0x20, 0x20                ; 0000027B  and [bx+si],ah
  db 0x20, 0x20                ; 0000027D  and [bx+si],ah
  db 0x20, 0x2A                ; 0000027F  and [bp+si],ch
  db 0x00, 0x00                ; 00000281  add [bx+si],al
  db 0x00, 0x00                ; 00000283  add [bx+si],al
  db 0x00, 0x00                ; 00000285  add [bx+si],al
  db 0x00, 0x00                ; 00000287  add [bx+si],al
  db 0x00, 0x00                ; 00000289  add [bx+si],al
  db 0x00, 0x00                ; 0000028B  add [bx+si],al
  db 0x00, 0x00                ; 0000028D  add [bx+si],al
  db 0x00, 0x00                ; 0000028F  add [bx+si],al
  db 0x00, 0x00                ; 00000291  add [bx+si],al
  db 0x00, 0x00                ; 00000293  add [bx+si],al
  db 0x00, 0x00                ; 00000295  add [bx+si],al
  db 0x00, 0x00                ; 00000297  add [bx+si],al
  db 0x00, 0x00                ; 00000299  add [bx+si],al
  db 0x00, 0x00                ; 0000029B  add [bx+si],al
  db 0x00, 0x00                ; 0000029D  add [bx+si],al
  db 0x00, 0x00                ; 0000029F  add [bx+si],al
  db 0x00, 0x00                ; 000002A1  add [bx+si],al
  db 0x00, 0x00                ; 000002A3  add [bx+si],al
  db 0x00, 0x00                ; 000002A5  add [bx+si],al
  db 0x00, 0x00                ; 000002A7  add [bx+si],al
  db 0x00, 0x00                ; 000002A9  add [bx+si],al
  db 0x00, 0x00                ; 000002AB  add [bx+si],al
  db 0x00, 0x00                ; 000002AD  add [bx+si],al
  db 0x00, 0x00                ; 000002AF  add [bx+si],al
  db 0x00, 0x00                ; 000002B1  add [bx+si],al
  db 0x00, 0x00                ; 000002B3  add [bx+si],al
  db 0x00, 0x00                ; 000002B5  add [bx+si],al
  db 0x00, 0x00                ; 000002B7  add [bx+si],al
  db 0x00, 0x00                ; 000002B9  add [bx+si],al
  db 0x00, 0x00                ; 000002BB  add [bx+si],al
  db 0x00, 0x00                ; 000002BD  add [bx+si],al
  db 0x00, 0x00                ; 000002BF  add [bx+si],al
  db 0x00, 0x00                ; 000002C1  add [bx+si],al
  db 0x00, 0x00                ; 000002C3  add [bx+si],al
  db 0x00, 0x00                ; 000002C5  add [bx+si],al
  db 0x00, 0x00                ; 000002C7  add [bx+si],al
  db 0x00, 0x00                ; 000002C9  add [bx+si],al
  db 0x00, 0x00                ; 000002CB  add [bx+si],al
  db 0x00, 0x00                ; 000002CD  add [bx+si],al
  db 0x00, 0x00                ; 000002CF  add [bx+si],al
  db 0x00, 0x00                ; 000002D1  add [bx+si],al
  db 0x00, 0xBE, 0x03, 0x00    ; 000002D3  add [bp+0x3],bh
  db 0x00, 0x00                ; 000002D7  add [bx+si],al
  db 0x00, 0x00                ; 000002D9  add [bx+si],al
  db 0x00, 0x00                ; 000002DB  add [bx+si],al
  db 0x00, 0x00                ; 000002DD  add [bx+si],al
  db 0x00, 0x00                ; 000002DF  add [bx+si],al
  db 0x00, 0x00                ; 000002E1  add [bx+si],al
  db 0x00, 0x00                ; 000002E3  add [bx+si],al
  db 0x00, 0x00                ; 000002E5  add [bx+si],al
  db 0x00, 0x00                ; 000002E7  add [bx+si],al
  db 0x00, 0x00                ; 000002E9  add [bx+si],al
  db 0x00, 0x00                ; 000002EB  add [bx+si],al
  db 0x00, 0x00                ; 000002ED  add [bx+si],al
  db 0x00, 0x00                ; 000002EF  add [bx+si],al
  db 0x00, 0x00                ; 000002F1  add [bx+si],al
  db 0x00, 0x00                ; 000002F3  add [bx+si],al
  db 0x00, 0x00                ; 000002F5  add [bx+si],al
  db 0x00, 0x00                ; 000002F7  add [bx+si],al
  db 0x00, 0x00                ; 000002F9  add [bx+si],al
  db 0x00, 0x00                ; 000002FB  add [bx+si],al
  db 0x00, 0x00                ; 000002FD  add [bx+si],al
  db 0x00, 0x00                ; 000002FF  add [bx+si],al
  db 0x00, 0x00                ; 00000301  add [bx+si],al
  db 0x00, 0x00                ; 00000303  add [bx+si],al
  db 0x00, 0x00                ; 00000305  add [bx+si],al
  db 0x00, 0x00                ; 00000307  add [bx+si],al
  db 0x00, 0x00                ; 00000309  add [bx+si],al
  db 0x00, 0x00                ; 0000030B  add [bx+si],al
  db 0x00, 0x00                ; 0000030D  add [bx+si],al
  db 0x00, 0x00                ; 0000030F  add [bx+si],al
  db 0x00, 0x00                ; 00000311  add [bx+si],al
  db 0x00, 0x00                ; 00000313  add [bx+si],al
  db 0x00, 0x00                ; 00000315  add [bx+si],al
  db 0x00, 0x00                ; 00000317  add [bx+si],al
  db 0x00, 0x00                ; 00000319  add [bx+si],al
  db 0x00, 0x00                ; 0000031B  add [bx+si],al
  db 0x00, 0x00                ; 0000031D  add [bx+si],al
  db 0x00, 0x00                ; 0000031F  add [bx+si],al
  db 0x00, 0x00                ; 00000321  add [bx+si],al
  db 0x00, 0x00                ; 00000323  add [bx+si],al
  db 0x00, 0x00                ; 00000325  add [bx+si],al
  db 0x00, 0x00                ; 00000327  add [bx+si],al
  db 0x00, 0x00                ; 00000329  add [bx+si],al
  db 0x00, 0x00                ; 0000032B  add [bx+si],al
  db 0x00, 0x00                ; 0000032D  add [bx+si],al
  db 0x00, 0x00                ; 0000032F  add [bx+si],al
  db 0x00, 0x00                ; 00000331  add [bx+si],al
  db 0x00, 0x00                ; 00000333  add [bx+si],al
  db 0x00, 0x00                ; 00000335  add [bx+si],al
  db 0x00, 0x00                ; 00000337  add [bx+si],al
  db 0x00, 0x00                ; 00000339  add [bx+si],al
  db 0x00, 0x00                ; 0000033B  add [bx+si],al
  db 0x00, 0x00                ; 0000033D  add [bx+si],al
  db 0x00, 0x00                ; 0000033F  add [bx+si],al
  db 0x00, 0x00                ; 00000341  add [bx+si],al
  db 0x00, 0x00                ; 00000343  add [bx+si],al
  db 0x00, 0x00                ; 00000345  add [bx+si],al
  db 0x00, 0x00                ; 00000347  add [bx+si],al
  db 0x00, 0x00                ; 00000349  add [bx+si],al
  db 0x00, 0x00                ; 0000034B  add [bx+si],al
  db 0x00, 0x00                ; 0000034D  add [bx+si],al
  db 0x00, 0x00                ; 0000034F  add [bx+si],al
  db 0x00, 0x00                ; 00000351  add [bx+si],al
  db 0x00, 0x00                ; 00000353  add [bx+si],al
  db 0x00, 0x00                ; 00000355  add [bx+si],al
  db 0x00, 0x00                ; 00000357  add [bx+si],al
  db 0x00, 0x00                ; 00000359  add [bx+si],al
  db 0x00, 0x00                ; 0000035B  add [bx+si],al
  db 0x00, 0x00                ; 0000035D  add [bx+si],al
  db 0x00, 0x00                ; 0000035F  add [bx+si],al
  db 0x00, 0x00                ; 00000361  add [bx+si],al
  db 0x00, 0x00                ; 00000363  add [bx+si],al
  db 0x00, 0x00                ; 00000365  add [bx+si],al
  db 0x00, 0x00                ; 00000367  add [bx+si],al
  db 0x00, 0x00                ; 00000369  add [bx+si],al
  db 0x00, 0x00                ; 0000036B  add [bx+si],al
  db 0x00, 0x00                ; 0000036D  add [bx+si],al
  db 0x00, 0x00                ; 0000036F  add [bx+si],al
  db 0x00, 0x00                ; 00000371  add [bx+si],al
  db 0x00, 0x00                ; 00000373  add [bx+si],al
  db 0x00, 0x00                ; 00000375  add [bx+si],al
  db 0x00, 0x00                ; 00000377  add [bx+si],al
  db 0x00, 0x00                ; 00000379  add [bx+si],al
  db 0x00, 0x00                ; 0000037B  add [bx+si],al
  db 0x00, 0x00                ; 0000037D  add [bx+si],al
  db 0x00, 0x00                ; 0000037F  add [bx+si],al
  db 0x00, 0x00                ; 00000381  add [bx+si],al
  db 0x00, 0x00                ; 00000383  add [bx+si],al
  db 0x00, 0x00                ; 00000385  add [bx+si],al
  db 0x00, 0x00                ; 00000387  add [bx+si],al
  db 0x00, 0x00                ; 00000389  add [bx+si],al
  db 0x00, 0x00                ; 0000038B  add [bx+si],al
  db 0x00, 0x00                ; 0000038D  add [bx+si],al
  db 0x00, 0x00                ; 0000038F  add [bx+si],al
  db 0x00, 0x00                ; 00000391  add [bx+si],al
  db 0x00, 0x00                ; 00000393  add [bx+si],al
  db 0x00, 0x00                ; 00000395  add [bx+si],al
  db 0x00, 0x00                ; 00000397  add [bx+si],al
  db 0x00, 0x00                ; 00000399  add [bx+si],al
  db 0x00, 0x00                ; 0000039B  add [bx+si],al
  db 0x00, 0x00                ; 0000039D  add [bx+si],al
  db 0x00, 0xCC                ; 0000039F  add ah,cl
  db 0xCC                      ; 000003A1  int3
  db 0xCC                      ; 000003A2  int3
  db 0xCC                      ; 000003A3  int3
  db 0xCC                      ; 000003A4  int3
  db 0xCC                      ; 000003A5  int3
  db 0xCC                      ; 000003A6  int3
  db 0xCC                      ; 000003A7  int3
  db 0xCC                      ; 000003A8  int3
  db 0xCC                      ; 000003A9  int3
  db 0xCC                      ; 000003AA  int3
  db 0xCC                      ; 000003AB  int3
  db 0xCC                      ; 000003AC  int3
  db 0xCC                      ; 000003AD  int3
  db 0xCC                      ; 000003AE  int3
  db 0xCC                      ; 000003AF  int3
  db 0xCC                      ; 000003B0  int3
  db 0xCC                      ; 000003B1  int3
  db 0xCC                      ; 000003B2  int3
  db 0xCC                      ; 000003B3  int3
  db 0xCC                      ; 000003B4  int3
  db 0xCC                      ; 000003B5  int3
  db 0xCC                      ; 000003B6  int3
  db 0xCC                      ; 000003B7  int3
  db 0xCC                      ; 000003B8  int3
  db 0xCC                      ; 000003B9  int3
  db 0xCC                      ; 000003BA  int3
  db 0xCC                      ; 000003BB  int3
  db 0xCC                      ; 000003BC  int3
  db 0xCC                      ; 000003BD  int3
  db 0x15, 0x0E, 0x00          ; 000003BE  adc ax,0xe
  db 0x00, 0x00                ; 000003C1  add [bx+si],al
  db 0x00, 0x00                ; 000003C3  add [bx+si],al
  db 0x00, 0x00                ; 000003C5  add [bx+si],al
  db 0x00, 0x00                ; 000003C7  add [bx+si],al
  db 0x00, 0x00                ; 000003C9  add [bx+si],al
  db 0x00, 0x00                ; 000003CB  add [bx+si],al
  db 0x00, 0x00                ; 000003CD  add [bx+si],al
  db 0x00, 0x00                ; 000003CF  add [bx+si],al
  db 0x00, 0x00                ; 000003D1  add [bx+si],al
  db 0x00, 0x00                ; 000003D3  add [bx+si],al
  db 0x00, 0x00                ; 000003D5  add [bx+si],al
  db 0x00, 0x00                ; 000003D7  add [bx+si],al
  db 0x00, 0x00                ; 000003D9  add [bx+si],al
  db 0x00, 0x00                ; 000003DB  add [bx+si],al
  db 0x00, 0x00                ; 000003DD  add [bx+si],al
  db 0x00, 0x00                ; 000003DF  add [bx+si],al
  db 0x00, 0x00                ; 000003E1  add [bx+si],al
  db 0x00, 0x00                ; 000003E3  add [bx+si],al
  db 0x00, 0x00                ; 000003E5  add [bx+si],al
  db 0x00, 0x00                ; 000003E7  add [bx+si],al
  db 0x00, 0x00                ; 000003E9  add [bx+si],al
  db 0x00, 0x00                ; 000003EB  add [bx+si],al
  db 0x00, 0x00                ; 000003ED  add [bx+si],al
  db 0x00, 0x00                ; 000003EF  add [bx+si],al
  db 0x00, 0x00                ; 000003F1  add [bx+si],al
  db 0x00, 0x00                ; 000003F3  add [bx+si],al
  db 0x00, 0x00                ; 000003F5  add [bx+si],al
  db 0x00, 0x00                ; 000003F7  add [bx+si],al
  db 0x00, 0x00                ; 000003F9  add [bx+si],al
  db 0x00, 0x00                ; 000003FB  add [bx+si],al
  db 0x00, 0x00                ; 000003FD  add [bx+si],al
  db 0x00, 0x00                ; 000003FF  add [bx+si],al
  db 0x00, 0x00                ; 00000401  add [bx+si],al
  db 0x00, 0x00                ; 00000403  add [bx+si],al
  db 0x00, 0x00                ; 00000405  add [bx+si],al
  db 0x00, 0x00                ; 00000407  add [bx+si],al
  db 0x00, 0x00                ; 00000409  add [bx+si],al
  db 0x00, 0x00                ; 0000040B  add [bx+si],al
  db 0x00, 0x00                ; 0000040D  add [bx+si],al
  db 0x00, 0x00                ; 0000040F  add [bx+si],al
  db 0x00, 0x00                ; 00000411  add [bx+si],al
  db 0x00, 0x00                ; 00000413  add [bx+si],al
  db 0x00, 0x00                ; 00000415  add [bx+si],al
  db 0x00, 0x00                ; 00000417  add [bx+si],al
  db 0x00, 0x00                ; 00000419  add [bx+si],al
  db 0x00, 0x00                ; 0000041B  add [bx+si],al
  db 0x00, 0x00                ; 0000041D  add [bx+si],al
  db 0x00, 0x00                ; 0000041F  add [bx+si],al
  db 0x00, 0x00                ; 00000421  add [bx+si],al
  db 0x00, 0x00                ; 00000423  add [bx+si],al
  db 0x00, 0x00                ; 00000425  add [bx+si],al
  db 0x00, 0x00                ; 00000427  add [bx+si],al
  db 0x00, 0x00                ; 00000429  add [bx+si],al
  db 0x00, 0x00                ; 0000042B  add [bx+si],al
  db 0x00, 0x00                ; 0000042D  add [bx+si],al
  db 0x00, 0x00                ; 0000042F  add [bx+si],al
  db 0x00, 0x00                ; 00000431  add [bx+si],al
  db 0x00, 0x00                ; 00000433  add [bx+si],al
  db 0x00, 0x00                ; 00000435  add [bx+si],al
  db 0x00, 0x00                ; 00000437  add [bx+si],al
  db 0x00, 0x00                ; 00000439  add [bx+si],al
  db 0x00, 0x00                ; 0000043B  add [bx+si],al
  db 0x00, 0x00                ; 0000043D  add [bx+si],al
  db 0x00, 0x00                ; 0000043F  add [bx+si],al
  db 0x00, 0x00                ; 00000441  add [bx+si],al
  db 0x00, 0x00                ; 00000443  add [bx+si],al
  db 0x00, 0x00                ; 00000445  add [bx+si],al
  db 0x00, 0x00                ; 00000447  add [bx+si],al
  db 0x00, 0x00                ; 00000449  add [bx+si],al
  db 0x00, 0x00                ; 0000044B  add [bx+si],al
  db 0x00, 0x00                ; 0000044D  add [bx+si],al
  db 0x00, 0x00                ; 0000044F  add [bx+si],al
  db 0x00, 0x00                ; 00000451  add [bx+si],al
  db 0x00, 0x00                ; 00000453  add [bx+si],al
  db 0x00, 0x00                ; 00000455  add [bx+si],al
  db 0x00, 0x00                ; 00000457  add [bx+si],al
  db 0x00, 0x00                ; 00000459  add [bx+si],al
  db 0x00, 0x00                ; 0000045B  add [bx+si],al
  db 0x00, 0x00                ; 0000045D  add [bx+si],al
  db 0x00, 0x00                ; 0000045F  add [bx+si],al
  db 0x00, 0x00                ; 00000461  add [bx+si],al
  db 0x00, 0x00                ; 00000463  add [bx+si],al
  db 0x00, 0x00                ; 00000465  add [bx+si],al
  db 0x00, 0x00                ; 00000467  add [bx+si],al
  db 0x00, 0x00                ; 00000469  add [bx+si],al
  db 0x00, 0x00                ; 0000046B  add [bx+si],al
  db 0x00, 0x00                ; 0000046D  add [bx+si],al
  db 0x00, 0x00                ; 0000046F  add [bx+si],al
  db 0x00, 0x00                ; 00000471  add [bx+si],al
  db 0x00, 0x00                ; 00000473  add [bx+si],al
  db 0x00, 0x00                ; 00000475  add [bx+si],al
  db 0x00, 0x00                ; 00000477  add [bx+si],al
  db 0x00, 0x00                ; 00000479  add [bx+si],al
  db 0x00, 0x00                ; 0000047B  add [bx+si],al
  db 0x00, 0x00                ; 0000047D  add [bx+si],al
  db 0x00, 0x00                ; 0000047F  add [bx+si],al
  db 0x00, 0x00                ; 00000481  add [bx+si],al
  db 0x00, 0x00                ; 00000483  add [bx+si],al
  db 0x00, 0x00                ; 00000485  add [bx+si],al
  db 0x00, 0x00                ; 00000487  add [bx+si],al
  db 0x00, 0x00                ; 00000489  add [bx+si],al
  db 0x00, 0x00                ; 0000048B  add [bx+si],al
  db 0x00, 0x00                ; 0000048D  add [bx+si],al
  db 0x00, 0x00                ; 0000048F  add [bx+si],al
  db 0x00, 0x00                ; 00000491  add [bx+si],al
  db 0x00, 0x00                ; 00000493  add [bx+si],al
  db 0x00, 0x00                ; 00000495  add [bx+si],al
  db 0x00, 0x00                ; 00000497  add [bx+si],al
  db 0x00, 0x00                ; 00000499  add [bx+si],al
  db 0x00, 0x00                ; 0000049B  add [bx+si],al
  db 0x00, 0x00                ; 0000049D  add [bx+si],al
  db 0x00, 0x00                ; 0000049F  add [bx+si],al
  db 0x00, 0x00                ; 000004A1  add [bx+si],al
  db 0x00, 0x00                ; 000004A3  add [bx+si],al
  db 0x00, 0x00                ; 000004A5  add [bx+si],al
  db 0x00, 0x00                ; 000004A7  add [bx+si],al
  db 0x00, 0x00                ; 000004A9  add [bx+si],al
  db 0x00, 0x00                ; 000004AB  add [bx+si],al
  db 0x00, 0x00                ; 000004AD  add [bx+si],al
  db 0x00, 0x00                ; 000004AF  add [bx+si],al
  db 0x00, 0x00                ; 000004B1  add [bx+si],al
  db 0x00, 0x00                ; 000004B3  add [bx+si],al
  db 0x00, 0x00                ; 000004B5  add [bx+si],al
  db 0x00, 0x00                ; 000004B7  add [bx+si],al
  db 0x00, 0x00                ; 000004B9  add [bx+si],al
  db 0x00, 0x00                ; 000004BB  add [bx+si],al
  db 0x00, 0x00                ; 000004BD  add [bx+si],al
  db 0x00, 0x00                ; 000004BF  add [bx+si],al
  db 0x00, 0x00                ; 000004C1  add [bx+si],al
  db 0x00, 0x00                ; 000004C3  add [bx+si],al
  db 0x00, 0x00                ; 000004C5  add [bx+si],al
  db 0x00, 0x00                ; 000004C7  add [bx+si],al
  db 0x00, 0x00                ; 000004C9  add [bx+si],al
  db 0x00, 0x00                ; 000004CB  add [bx+si],al
  db 0x00, 0x00                ; 000004CD  add [bx+si],al
  db 0x00, 0x00                ; 000004CF  add [bx+si],al
  db 0x00, 0x00                ; 000004D1  add [bx+si],al
  db 0x00, 0x00                ; 000004D3  add [bx+si],al
  db 0x03, 0x03                ; 000004D5  add ax,[bp+di]
  db 0x00, 0x58, 0x4D          ; 000004D7  add [bx+si+0x4d],bl
  db 0x49                      ; 000004DA  dec cx
  db 0x54                      ; 000004DB  push sp
  db 0x20, 0x20                ; 000004DC  and [bx+si],ah
  db 0x20, 0x20                ; 000004DE  and [bx+si],ah
  db 0x50                      ; 000004E0  push ax
  db 0x00, 0x00                ; 000004E1  add [bx+si],al
  db 0x00, 0x00                ; 000004E3  add [bx+si],al
  db 0x00, 0x00                ; 000004E5  add [bx+si],al
  db 0x00, 0x00                ; 000004E7  add [bx+si],al
  db 0x00, 0x00                ; 000004E9  add [bx+si],al
  db 0x00, 0x00                ; 000004EB  add [bx+si],al
  db 0x00, 0x00                ; 000004ED  add [bx+si],al
  db 0x00, 0x00                ; 000004EF  add [bx+si],al
  db 0x00, 0x00                ; 000004F1  add [bx+si],al
  db 0x00, 0x00                ; 000004F3  add [bx+si],al
  db 0x00, 0x00                ; 000004F5  add [bx+si],al
  db 0x00, 0x00                ; 000004F7  add [bx+si],al
  db 0x00, 0x00                ; 000004F9  add [bx+si],al
  db 0x00, 0x00                ; 000004FB  add [bx+si],al
  db 0x00, 0x00                ; 000004FD  add [bx+si],al
  db 0x00, 0x00                ; 000004FF  add [bx+si],al
  db 0x00, 0x00                ; 00000501  add [bx+si],al
  db 0x00, 0x00                ; 00000503  add [bx+si],al
  db 0x00, 0x00                ; 00000505  add [bx+si],al
  db 0x00, 0x00                ; 00000507  add [bx+si],al
  db 0x00, 0x00                ; 00000509  add [bx+si],al
  db 0x00, 0x00                ; 0000050B  add [bx+si],al
  db 0x00, 0x00                ; 0000050D  add [bx+si],al
  db 0x00, 0x00                ; 0000050F  add [bx+si],al
  db 0x00, 0x00                ; 00000511  add [bx+si],al
  db 0x00, 0x00                ; 00000513  add [bx+si],al
  db 0x00, 0x00                ; 00000515  add [bx+si],al
  db 0x00, 0x00                ; 00000517  add [bx+si],al
  db 0x00, 0x00                ; 00000519  add [bx+si],al
  db 0x00, 0x00                ; 0000051B  add [bx+si],al
  db 0x00, 0x00                ; 0000051D  add [bx+si],al
  db 0x00, 0x00                ; 0000051F  add [bx+si],al
  db 0x00, 0x00                ; 00000521  add [bx+si],al
  db 0x00, 0x00                ; 00000523  add [bx+si],al
  db 0x00, 0x00                ; 00000525  add [bx+si],al
  db 0x00, 0x00                ; 00000527  add [bx+si],al
  db 0x00, 0x00                ; 00000529  add [bx+si],al
  db 0x00, 0x00                ; 0000052B  add [bx+si],al
  db 0x00, 0x00                ; 0000052D  add [bx+si],al
  db 0x00, 0x00                ; 0000052F  add [bx+si],al
  db 0x00, 0x00                ; 00000531  add [bx+si],al
  db 0x00, 0x1E, 0x06, 0x00    ; 00000533  add [0x6],bl
  db 0x00, 0x00                ; 00000537  add [bx+si],al
  db 0x00, 0x00                ; 00000539  add [bx+si],al
  db 0x00, 0x00                ; 0000053B  add [bx+si],al
  db 0x00, 0x00                ; 0000053D  add [bx+si],al
  db 0x00, 0x00                ; 0000053F  add [bx+si],al
  db 0x00, 0x00                ; 00000541  add [bx+si],al
  db 0x00, 0x00                ; 00000543  add [bx+si],al
  db 0x00, 0x00                ; 00000545  add [bx+si],al
  db 0x00, 0x00                ; 00000547  add [bx+si],al
  db 0x00, 0x00                ; 00000549  add [bx+si],al
  db 0x00, 0x00                ; 0000054B  add [bx+si],al
  db 0x00, 0x00                ; 0000054D  add [bx+si],al
  db 0x00, 0x00                ; 0000054F  add [bx+si],al
  db 0x00, 0x00                ; 00000551  add [bx+si],al
  db 0x00, 0x00                ; 00000553  add [bx+si],al
  db 0x00, 0x00                ; 00000555  add [bx+si],al
  db 0x00, 0x00                ; 00000557  add [bx+si],al
  db 0x00, 0x00                ; 00000559  add [bx+si],al
  db 0x00, 0x00                ; 0000055B  add [bx+si],al
  db 0x00, 0x00                ; 0000055D  add [bx+si],al
  db 0x00, 0x00                ; 0000055F  add [bx+si],al
  db 0x00, 0x00                ; 00000561  add [bx+si],al
  db 0x00, 0x00                ; 00000563  add [bx+si],al
  db 0x00, 0x00                ; 00000565  add [bx+si],al
  db 0x00, 0x00                ; 00000567  add [bx+si],al
  db 0x00, 0x00                ; 00000569  add [bx+si],al
  db 0x00, 0x00                ; 0000056B  add [bx+si],al
  db 0x00, 0x00                ; 0000056D  add [bx+si],al
  db 0x00, 0x00                ; 0000056F  add [bx+si],al
  db 0x00, 0x00                ; 00000571  add [bx+si],al
  db 0x00, 0x00                ; 00000573  add [bx+si],al
  db 0x00, 0x00                ; 00000575  add [bx+si],al
  db 0x00, 0x00                ; 00000577  add [bx+si],al
  db 0x00, 0x00                ; 00000579  add [bx+si],al
  db 0x00, 0x00                ; 0000057B  add [bx+si],al
  db 0x00, 0x00                ; 0000057D  add [bx+si],al
  db 0x00, 0x00                ; 0000057F  add [bx+si],al
  db 0x00, 0x00                ; 00000581  add [bx+si],al
  db 0x00, 0x00                ; 00000583  add [bx+si],al
  db 0x00, 0x00                ; 00000585  add [bx+si],al
  db 0x00, 0x00                ; 00000587  add [bx+si],al
  db 0x00, 0x00                ; 00000589  add [bx+si],al
  db 0x00, 0x00                ; 0000058B  add [bx+si],al
  db 0x00, 0x00                ; 0000058D  add [bx+si],al
  db 0x00, 0x00                ; 0000058F  add [bx+si],al
  db 0x00, 0x00                ; 00000591  add [bx+si],al
  db 0x00, 0x00                ; 00000593  add [bx+si],al
  db 0x00, 0x00                ; 00000595  add [bx+si],al
  db 0x00, 0x00                ; 00000597  add [bx+si],al
  db 0x00, 0x00                ; 00000599  add [bx+si],al
  db 0x00, 0x00                ; 0000059B  add [bx+si],al
  db 0x00, 0x00                ; 0000059D  add [bx+si],al
  db 0x00, 0x00                ; 0000059F  add [bx+si],al
  db 0x00, 0x00                ; 000005A1  add [bx+si],al
  db 0x00, 0x00                ; 000005A3  add [bx+si],al
  db 0x00, 0x00                ; 000005A5  add [bx+si],al
  db 0x00, 0x00                ; 000005A7  add [bx+si],al
  db 0x00, 0x00                ; 000005A9  add [bx+si],al
  db 0x00, 0x00                ; 000005AB  add [bx+si],al
  db 0x00, 0x00                ; 000005AD  add [bx+si],al
  db 0x00, 0x00                ; 000005AF  add [bx+si],al
  db 0x00, 0x00                ; 000005B1  add [bx+si],al
  db 0x00, 0x00                ; 000005B3  add [bx+si],al
  db 0x00, 0x00                ; 000005B5  add [bx+si],al
  db 0x00, 0x00                ; 000005B7  add [bx+si],al
  db 0x00, 0x00                ; 000005B9  add [bx+si],al
  db 0x00, 0x00                ; 000005BB  add [bx+si],al
  db 0x00, 0x00                ; 000005BD  add [bx+si],al
  db 0x00, 0x00                ; 000005BF  add [bx+si],al
  db 0x00, 0x00                ; 000005C1  add [bx+si],al
  db 0x00, 0x00                ; 000005C3  add [bx+si],al
  db 0x00, 0x00                ; 000005C5  add [bx+si],al
  db 0x00, 0x00                ; 000005C7  add [bx+si],al
  db 0x00, 0x00                ; 000005C9  add [bx+si],al
  db 0x00, 0x00                ; 000005CB  add [bx+si],al
  db 0x00, 0x00                ; 000005CD  add [bx+si],al
  db 0x00, 0x00                ; 000005CF  add [bx+si],al
  db 0x00, 0x00                ; 000005D1  add [bx+si],al
  db 0x00, 0x00                ; 000005D3  add [bx+si],al
  db 0x00, 0x00                ; 000005D5  add [bx+si],al
  db 0x00, 0x00                ; 000005D7  add [bx+si],al
  db 0x00, 0x00                ; 000005D9  add [bx+si],al
  db 0x00, 0x00                ; 000005DB  add [bx+si],al
  db 0x00, 0x00                ; 000005DD  add [bx+si],al
  db 0x00, 0x00                ; 000005DF  add [bx+si],al
  db 0x00, 0x00                ; 000005E1  add [bx+si],al
  db 0x00, 0x00                ; 000005E3  add [bx+si],al
  db 0x00, 0x00                ; 000005E5  add [bx+si],al
  db 0x00, 0x00                ; 000005E7  add [bx+si],al
  db 0x00, 0x00                ; 000005E9  add [bx+si],al
  db 0x00, 0x00                ; 000005EB  add [bx+si],al
  db 0x00, 0x00                ; 000005ED  add [bx+si],al
  db 0x00, 0x00                ; 000005EF  add [bx+si],al
  db 0x00, 0x00                ; 000005F1  add [bx+si],al
  db 0x00, 0x00                ; 000005F3  add [bx+si],al
  db 0x00, 0x00                ; 000005F5  add [bx+si],al
  db 0x00, 0x00                ; 000005F7  add [bx+si],al
  db 0x00, 0x00                ; 000005F9  add [bx+si],al
  db 0x00, 0x00                ; 000005FB  add [bx+si],al
  db 0x00, 0x00                ; 000005FD  add [bx+si],al
  db 0x00, 0xCC                ; 000005FF  add ah,cl
  db 0xCC                      ; 00000601  int3
  db 0xCC                      ; 00000602  int3
  db 0xCC                      ; 00000603  int3
  db 0xCC                      ; 00000604  int3
  db 0xCC                      ; 00000605  int3
  db 0xCC                      ; 00000606  int3
  db 0xCC                      ; 00000607  int3
  db 0xCC                      ; 00000608  int3
  db 0xCC                      ; 00000609  int3
  db 0xCC                      ; 0000060A  int3
  db 0xCC                      ; 0000060B  int3
  db 0xCC                      ; 0000060C  int3
  db 0xCC                      ; 0000060D  int3
  db 0xCC                      ; 0000060E  int3
  db 0xCC                      ; 0000060F  int3
  db 0xCC                      ; 00000610  int3
  db 0xCC                      ; 00000611  int3
  db 0xCC                      ; 00000612  int3
  db 0xCC                      ; 00000613  int3
  db 0xCC                      ; 00000614  int3
  db 0xCC                      ; 00000615  int3
  db 0xCC                      ; 00000616  int3
  db 0xCC                      ; 00000617  int3
  db 0xCC                      ; 00000618  int3
  db 0xCC                      ; 00000619  int3
  db 0xCC                      ; 0000061A  int3
  db 0xCC                      ; 0000061B  int3
  db 0xCC                      ; 0000061C  int3
  db 0xCC                      ; 0000061D  int3
  db 0xF8                      ; 0000061E  clc
  db 0x0B, 0x00                ; 0000061F  or ax,[bx+si]
  db 0x00, 0x00                ; 00000621  add [bx+si],al
  db 0x00, 0x00                ; 00000623  add [bx+si],al
  db 0x00, 0x00                ; 00000625  add [bx+si],al
  db 0x00, 0x00                ; 00000627  add [bx+si],al
  db 0x00, 0x00                ; 00000629  add [bx+si],al
  db 0x00, 0x00                ; 0000062B  add [bx+si],al
  db 0x00, 0x00                ; 0000062D  add [bx+si],al
  db 0x00, 0x00                ; 0000062F  add [bx+si],al
  db 0x00, 0x00                ; 00000631  add [bx+si],al
  db 0x00, 0x00                ; 00000633  add [bx+si],al
  db 0x00, 0x00                ; 00000635  add [bx+si],al
  db 0x00, 0x00                ; 00000637  add [bx+si],al
  db 0x00, 0x00                ; 00000639  add [bx+si],al
  db 0x00, 0x00                ; 0000063B  add [bx+si],al
  db 0x00, 0x00                ; 0000063D  add [bx+si],al
  db 0x00, 0x00                ; 0000063F  add [bx+si],al
  db 0x00, 0x00                ; 00000641  add [bx+si],al
  db 0x00, 0x00                ; 00000643  add [bx+si],al
  db 0x00, 0x00                ; 00000645  add [bx+si],al
  db 0x00, 0x00                ; 00000647  add [bx+si],al
  db 0x00, 0x00                ; 00000649  add [bx+si],al
  db 0x00, 0x00                ; 0000064B  add [bx+si],al
  db 0x00, 0x00                ; 0000064D  add [bx+si],al
  db 0x00, 0x00                ; 0000064F  add [bx+si],al
  db 0x00, 0x00                ; 00000651  add [bx+si],al
  db 0x00, 0x00                ; 00000653  add [bx+si],al
  db 0x00, 0x00                ; 00000655  add [bx+si],al
  db 0x00, 0x00                ; 00000657  add [bx+si],al
  db 0x00, 0x00                ; 00000659  add [bx+si],al
  db 0x00, 0x00                ; 0000065B  add [bx+si],al
  db 0x00, 0x00                ; 0000065D  add [bx+si],al
  db 0x00, 0x00                ; 0000065F  add [bx+si],al
  db 0x00, 0x00                ; 00000661  add [bx+si],al
  db 0x00, 0x00                ; 00000663  add [bx+si],al
  db 0x00, 0x00                ; 00000665  add [bx+si],al
  db 0x00, 0x00                ; 00000667  add [bx+si],al
  db 0x00, 0x00                ; 00000669  add [bx+si],al
  db 0x00, 0x00                ; 0000066B  add [bx+si],al
  db 0x00, 0x00                ; 0000066D  add [bx+si],al
  db 0x00, 0x00                ; 0000066F  add [bx+si],al
  db 0x00, 0x00                ; 00000671  add [bx+si],al
  db 0x00, 0x00                ; 00000673  add [bx+si],al
  db 0x00, 0x00                ; 00000675  add [bx+si],al
  db 0x00, 0x00                ; 00000677  add [bx+si],al
  db 0x00, 0x00                ; 00000679  add [bx+si],al
  db 0x00, 0x00                ; 0000067B  add [bx+si],al
  db 0x00, 0x00                ; 0000067D  add [bx+si],al
  db 0x00, 0x00                ; 0000067F  add [bx+si],al
  db 0x00, 0x00                ; 00000681  add [bx+si],al
  db 0x00, 0x00                ; 00000683  add [bx+si],al
  db 0x00, 0x00                ; 00000685  add [bx+si],al
  db 0x00, 0x00                ; 00000687  add [bx+si],al
  db 0x00, 0x00                ; 00000689  add [bx+si],al
  db 0x00, 0x00                ; 0000068B  add [bx+si],al
  db 0x00, 0x00                ; 0000068D  add [bx+si],al
  db 0x00, 0x00                ; 0000068F  add [bx+si],al
  db 0x00, 0x00                ; 00000691  add [bx+si],al
  db 0x00, 0x00                ; 00000693  add [bx+si],al
  db 0x00, 0x00                ; 00000695  add [bx+si],al
  db 0x00, 0x00                ; 00000697  add [bx+si],al
  db 0x00, 0x00                ; 00000699  add [bx+si],al
  db 0x00, 0x00                ; 0000069B  add [bx+si],al
  db 0x00, 0x00                ; 0000069D  add [bx+si],al
  db 0x00, 0x00                ; 0000069F  add [bx+si],al
  db 0x00, 0x00                ; 000006A1  add [bx+si],al
  db 0x00, 0x00                ; 000006A3  add [bx+si],al
  db 0x00, 0x00                ; 000006A5  add [bx+si],al
  db 0x00, 0x00                ; 000006A7  add [bx+si],al
  db 0x00, 0x00                ; 000006A9  add [bx+si],al
  db 0x00, 0x00                ; 000006AB  add [bx+si],al
  db 0x00, 0x00                ; 000006AD  add [bx+si],al
  db 0x00, 0x00                ; 000006AF  add [bx+si],al
  db 0x00, 0x00                ; 000006B1  add [bx+si],al
  db 0x00, 0x00                ; 000006B3  add [bx+si],al
  db 0x00, 0x00                ; 000006B5  add [bx+si],al
  db 0x00, 0x00                ; 000006B7  add [bx+si],al
  db 0x00, 0x00                ; 000006B9  add [bx+si],al
  db 0x00, 0x00                ; 000006BB  add [bx+si],al
  db 0x00, 0x00                ; 000006BD  add [bx+si],al
  db 0x00, 0x00                ; 000006BF  add [bx+si],al
  db 0x00, 0x00                ; 000006C1  add [bx+si],al
  db 0x00, 0x00                ; 000006C3  add [bx+si],al
  db 0x00, 0x00                ; 000006C5  add [bx+si],al
  db 0x00, 0x00                ; 000006C7  add [bx+si],al
  db 0x00, 0x00                ; 000006C9  add [bx+si],al
  db 0x00, 0x00                ; 000006CB  add [bx+si],al
  db 0x00, 0x00                ; 000006CD  add [bx+si],al
  db 0x00, 0x00                ; 000006CF  add [bx+si],al
  db 0x00, 0x00                ; 000006D1  add [bx+si],al
  db 0x00, 0x00                ; 000006D3  add [bx+si],al
  db 0x00, 0x00                ; 000006D5  add [bx+si],al
  db 0x00, 0x00                ; 000006D7  add [bx+si],al
  db 0x00, 0x00                ; 000006D9  add [bx+si],al
  db 0x00, 0x00                ; 000006DB  add [bx+si],al
  db 0x00, 0x00                ; 000006DD  add [bx+si],al
  db 0x00, 0x00                ; 000006DF  add [bx+si],al
  db 0x00, 0x00                ; 000006E1  add [bx+si],al
  db 0x00, 0x00                ; 000006E3  add [bx+si],al
  db 0x00, 0x00                ; 000006E5  add [bx+si],al
  db 0x00, 0x00                ; 000006E7  add [bx+si],al
  db 0x00, 0x00                ; 000006E9  add [bx+si],al
  db 0x00, 0x00                ; 000006EB  add [bx+si],al
  db 0x00, 0x00                ; 000006ED  add [bx+si],al
  db 0x00, 0x00                ; 000006EF  add [bx+si],al
  db 0x00, 0x00                ; 000006F1  add [bx+si],al
  db 0x00, 0x00                ; 000006F3  add [bx+si],al
  db 0x00, 0x00                ; 000006F5  add [bx+si],al
  db 0x00, 0x00                ; 000006F7  add [bx+si],al
  db 0x00, 0x00                ; 000006F9  add [bx+si],al
  db 0x00, 0x00                ; 000006FB  add [bx+si],al
  db 0x00, 0x00                ; 000006FD  add [bx+si],al
  db 0x00, 0x00                ; 000006FF  add [bx+si],al
  db 0x00, 0x00                ; 00000701  add [bx+si],al
  db 0x00, 0x00                ; 00000703  add [bx+si],al
  db 0x00, 0x00                ; 00000705  add [bx+si],al
  db 0x00, 0x00                ; 00000707  add [bx+si],al
  db 0x00, 0x00                ; 00000709  add [bx+si],al
  db 0x00, 0x00                ; 0000070B  add [bx+si],al
  db 0x00, 0x00                ; 0000070D  add [bx+si],al
  db 0x00, 0x00                ; 0000070F  add [bx+si],al
  db 0x00, 0x00                ; 00000711  add [bx+si],al
  db 0x00, 0x00                ; 00000713  add [bx+si],al
  db 0x00, 0x00                ; 00000715  add [bx+si],al
  db 0x00, 0x00                ; 00000717  add [bx+si],al
  db 0x00, 0x00                ; 00000719  add [bx+si],al
  db 0x00, 0x00                ; 0000071B  add [bx+si],al
  db 0x00, 0x00                ; 0000071D  add [bx+si],al
  db 0x00, 0x00                ; 0000071F  add [bx+si],al
  db 0x00, 0x00                ; 00000721  add [bx+si],al
  db 0x00, 0x00                ; 00000723  add [bx+si],al
  db 0x00, 0xFA                ; 00000725  add dl,bh
  db 0xBC, 0x64, 0x02          ; 00000727  mov sp,0x264
  db 0x8C, 0xC8                ; 0000072A  mov ax,cs
  db 0x8E, 0xD0                ; 0000072C  mov ss,ax
  db 0xFB                      ; 0000072E  sti
  db 0x2E, 0x8C, 0x1E, 0x43, 0x42 ; 0000072F  mov [cs:0x4243],ds
  db 0xE8, 0x6D, 0x1D          ; 00000734  call 0x24a4
  db 0xBA, 0xBE, 0x0B          ; 00000737  mov dx,0xbbe
  db 0xB1, 0x87                ; 0000073A  mov cl,0x87
  db 0xCD, 0xE0                ; 0000073C  int 0xe0
  db 0xBA, 0xAE, 0x0B          ; 0000073E  mov dx,0xbae
  db 0xB1, 0x87                ; 00000741  mov cl,0x87
  db 0xCD, 0xE0                ; 00000743  int 0xe0
  db 0xB1, 0x89                ; 00000745  mov cl,0x89
  db 0xBA, 0xAE, 0x0B          ; 00000747  mov dx,0xbae
  db 0xCD, 0xE0                ; 0000074A  int 0xe0
  db 0x2E, 0x8A, 0x1E, 0xD6, 0x0B ; 0000074C  mov bl,[cs:0xbd6]
  db 0x80, 0xFB, 0x09          ; 00000751  cmp bl,0x9
  db 0x77, 0xEF                ; 00000754  ja 0x745
  db 0x32, 0xFF                ; 00000756  xor bh,bh
  db 0xD1, 0xE3                ; 00000758  shl bx,1
  db 0x81, 0xC3, 0x62, 0x07    ; 0000075A  add bx,0x762
  db 0xFF, 0x17                ; 0000075E  call [bx]
  db 0xEB, 0xE3                ; 00000760  jmp short 0x745
  db 0x76, 0x07                ; 00000762  jna 0x76b
  db 0x23, 0x08                ; 00000764  and cx,[bx+si]
  db 0xD4, 0x08                ; 00000766  aam 0x8
  db 0x41                      ; 00000768  inc cx
  db 0x09, 0x6B, 0x09          ; 00000769  or [bp+di+0x9],bp
  db 0xCD, 0x09                ; 0000076C  int 0x9
  db 0xB8, 0x0A, 0x22          ; 0000076E  mov ax,0x220a
  db 0x0B, 0x35                ; 00000771  or si,[di]
  db 0x0B, 0x66, 0x0B          ; 00000773  or sp,[bp+0xb]
  db 0xBB, 0xD7, 0x0B          ; 00000776  mov bx,0xbd7
  db 0x8A, 0x07                ; 00000779  mov al,[bx]
  db 0x3C, 0x00                ; 0000077B  cmp al,0x0
  db 0x74, 0x04                ; 0000077D  jz 0x783
  db 0x3C, 0x3F                ; 0000077F  cmp al,0x3f
  db 0x7E, 0x05                ; 00000781  jng 0x788
  db 0xB0, 0x08                ; 00000783  mov al,0x8
  db 0xE9, 0x88, 0x00          ; 00000785  jmp 0x810
  db 0xB1, 0x02                ; 00000788  mov cl,0x2
  db 0xD2, 0x27                ; 0000078A  shl byte [bx],cl
  db 0x32, 0xC0                ; 0000078C  xor al,al
  db 0xE8, 0x3C, 0x3B          ; 0000078E  call 0x42cd
  db 0x73, 0x05                ; 00000791  jnc 0x798
  db 0xB0, 0x07                ; 00000793  mov al,0x7
  db 0xE9, 0x78, 0x00          ; 00000795  jmp 0x810
  db 0x56                      ; 00000798  push si
  db 0x8A, 0x07                ; 00000799  mov al,[bx]
  db 0xE8, 0x2F, 0x3B          ; 0000079B  call 0x42cd
  db 0x5F                      ; 0000079E  pop di
  db 0x72, 0x05                ; 0000079F  jc 0x7a6
  db 0xB0, 0x06                ; 000007A1  mov al,0x6
  db 0xE9, 0x6A, 0x00          ; 000007A3  jmp 0x810
  db 0x83, 0x7F, 0x06, 0x2E    ; 000007A6  cmp word [bx+0x6],byte +0x2e
  db 0x7E, 0x05                ; 000007AA  jng 0x7b1
  db 0xB0, 0x09                ; 000007AC  mov al,0x9
  db 0xE9, 0x5F, 0x00          ; 000007AE  jmp 0x810
  db 0x8B, 0xF3                ; 000007B1  mov si,bx
  db 0x2E, 0x8E, 0x06, 0x43, 0x42 ; 000007B3  mov es,[cs:0x4243]
  db 0xB9, 0x03, 0x00          ; 000007B8  mov cx,0x3
  db 0x57                      ; 000007BB  push di
  db 0x9C                      ; 000007BC  pushf
  db 0xFA                      ; 000007BD  cli
  db 0xF3, 0xA5                ; 000007BE  rep movsw
  db 0x9D                      ; 000007C0  popf
  db 0x5F                      ; 000007C1  pop di
  db 0x80, 0x7F, 0x01, 0x00    ; 000007C2  cmp byte [bx+0x1],0x0
  db 0x74, 0x05                ; 000007C6  jz 0x7cd
  db 0xB0, 0x00                ; 000007C8  mov al,0x0
  db 0xE9, 0x43, 0x00          ; 000007CA  jmp 0x810
  db 0x1E                      ; 000007CD  push ds
  db 0xC5, 0x77, 0x08          ; 000007CE  lds si,[bx+0x8]
  db 0x26, 0x8A, 0x07          ; 000007D1  mov al,[es:bx]
  db 0x88, 0x04                ; 000007D4  mov [si],al
  db 0x88, 0x44, 0x01          ; 000007D6  mov [si+0x1],al
  db 0xC6, 0x44, 0x02, 0x03    ; 000007D9  mov byte [si+0x2],0x3
  db 0xC6, 0x44, 0x03, 0x00    ; 000007DD  mov byte [si+0x3],0x0
  db 0x26, 0x8B, 0x4F, 0x06    ; 000007E1  mov cx,[es:bx+0x6]
  db 0x26, 0x89, 0x4D, 0x09    ; 000007E5  mov [es:di+0x9],cx
  db 0x57                      ; 000007E9  push di
  db 0x83, 0xC7, 0x0B          ; 000007EA  add di,byte +0xb
  db 0x56                      ; 000007ED  push si
  db 0x51                      ; 000007EE  push cx
  db 0xF3, 0xA4                ; 000007EF  rep movsb
  db 0x59                      ; 000007F1  pop cx
  db 0x5E                      ; 000007F2  pop si
  db 0xC6, 0x44, 0x03, 0x01    ; 000007F3  mov byte [si+0x3],0x1
  db 0x5F                      ; 000007F7  pop di
  db 0x57                      ; 000007F8  push di
  db 0x83, 0xC7, 0x39          ; 000007F9  add di,byte +0x39
  db 0xF3, 0xA4                ; 000007FC  rep movsb
  db 0x5E                      ; 000007FE  pop si
  db 0x1F                      ; 000007FF  pop ds
  db 0xBA, 0xBE, 0x0B          ; 00000800  mov dx,0xbbe
  db 0xBF, 0xE5, 0x0B          ; 00000803  mov di,0xbe5
  db 0xE8, 0x08, 0x3B          ; 00000806  call 0x4311
  db 0xC7, 0x44, 0x07, 0x14, 0x00 ; 00000809  mov word [si+0x7],0x14
  db 0xB0, 0x00                ; 0000080E  mov al,0x0
  db 0xC4, 0x7F, 0x08          ; 00000810  les di,[bx+0x8]
  db 0x26, 0xC6, 0x45, 0x01, 0x00 ; 00000813  mov byte [es:di+0x1],0x0
  db 0x26, 0x88, 0x45, 0x02    ; 00000818  mov [es:di+0x2],al
  db 0x8B, 0x47, 0x04          ; 0000081C  mov ax,[bx+0x4]
  db 0xE8, 0x76, 0x03          ; 0000081F  call 0xb98
  db 0xC3                      ; 00000822  ret
  db 0xBB, 0xD7, 0x0B          ; 00000823  mov bx,0xbd7
  db 0xC4, 0x77, 0x01          ; 00000826  les si,[bx+0x1]
  db 0x26, 0xC6, 0x44, 0x01, 0x01 ; 00000829  mov byte [es:si+0x1],0x1
  db 0x26, 0xC6, 0x44, 0x02, 0x00 ; 0000082E  mov byte [es:si+0x2],0x0
  db 0x56                      ; 00000833  push si
  db 0x06                      ; 00000834  push es
  db 0xB1, 0x02                ; 00000835  mov cl,0x2
  db 0xD2, 0x27                ; 00000837  shl byte [bx],cl
  db 0x8A, 0x07                ; 00000839  mov al,[bx]
  db 0xE8, 0x8F, 0x3A          ; 0000083B  call 0x42cd
  db 0x72, 0x0E                ; 0000083E  jc 0x84e
  db 0x8B, 0x44, 0x04          ; 00000840  mov ax,[si+0x4]
  db 0x50                      ; 00000843  push ax
  db 0xE8, 0x0A, 0x00          ; 00000844  call 0x851
  db 0x58                      ; 00000847  pop ax
  db 0x07                      ; 00000848  pop es
  db 0x5F                      ; 00000849  pop di
  db 0xE8, 0x4B, 0x03          ; 0000084A  call 0xb98
  db 0xC3                      ; 0000084D  ret
  db 0x07                      ; 0000084E  pop es
  db 0x5E                      ; 0000084F  pop si
  db 0xC3                      ; 00000850  ret
  db 0x9C                      ; 00000851  pushf
  db 0xFA                      ; 00000852  cli
  db 0x80, 0x7C, 0x67, 0xFF    ; 00000853  cmp byte [si+0x67],0xff
  db 0x75, 0x0C                ; 00000857  jnz 0x865
  db 0x9D                      ; 00000859  popf
  db 0x56                      ; 0000085A  push si
  db 0xB1, 0x8D                ; 0000085B  mov cl,0x8d
  db 0xBA, 0x01, 0x00          ; 0000085D  mov dx,0x1
  db 0xCD, 0xE0                ; 00000860  int 0xe0
  db 0x5E                      ; 00000862  pop si
  db 0xEB, 0xEC                ; 00000863  jmp short 0x851
  db 0x8A, 0x54, 0x01          ; 00000865  mov dl,[si+0x1]
  db 0x8B, 0xFE                ; 00000868  mov di,si
  db 0x2E, 0x8E, 0x06, 0x43, 0x42 ; 0000086A  mov es,[cs:0x4243]
  db 0xB9, 0x68, 0x00          ; 0000086F  mov cx,0x68
  db 0x32, 0xC0                ; 00000872  xor al,al
  db 0xF3, 0xAA                ; 00000874  rep stosb
  db 0x80, 0xFA, 0x01          ; 00000876  cmp dl,0x1
  db 0x74, 0x27                ; 00000879  jz 0x8a2
  db 0xB9, 0x20, 0x00          ; 0000087B  mov cx,0x20
  db 0xBF, 0x45, 0x15          ; 0000087E  mov di,0x1545
  db 0x57                      ; 00000881  push di
  db 0x56                      ; 00000882  push si
  db 0x39, 0x75, 0x07          ; 00000883  cmp [di+0x7],si
  db 0x75, 0x08                ; 00000886  jnz 0x890
  db 0x83, 0xC7, 0x07          ; 00000888  add di,byte +0x7
  db 0xE8, 0x16, 0x00          ; 0000088B  call 0x8a4
  db 0xEB, 0x0B                ; 0000088E  jmp short 0x89b
  db 0x39, 0x75, 0x29          ; 00000890  cmp [di+0x29],si
  db 0x75, 0x06                ; 00000893  jnz 0x89b
  db 0x83, 0xC7, 0x29          ; 00000895  add di,byte +0x29
  db 0xE8, 0x09, 0x00          ; 00000898  call 0x8a4
  db 0x5E                      ; 0000089B  pop si
  db 0x5F                      ; 0000089C  pop di
  db 0x83, 0xC7, 0x4B          ; 0000089D  add di,byte +0x4b
  db 0xE2, 0xDF                ; 000008A0  loop 0x881
  db 0x9D                      ; 000008A2  popf
  db 0xC3                      ; 000008A3  ret
  db 0x51                      ; 000008A4  push cx
  db 0x50                      ; 000008A5  push ax
  db 0x83, 0x7D, 0x0E, 0x00    ; 000008A6  cmp word [di+0xe],byte +0x0
  db 0x75, 0x06                ; 000008AA  jnz 0x8b2
  db 0x83, 0x7D, 0x0C, 0x00    ; 000008AC  cmp word [di+0xc],byte +0x0
  db 0x74, 0x07                ; 000008B0  jz 0x8b9
  db 0x57                      ; 000008B2  push di
  db 0x8B, 0xF7                ; 000008B3  mov si,di
  db 0xE8, 0x8E, 0x35          ; 000008B5  call 0x3e46
  db 0x5F                      ; 000008B8  pop di
  db 0x83, 0x7D, 0x09, 0x00    ; 000008B9  cmp word [di+0x9],byte +0x0
  db 0x75, 0x06                ; 000008BD  jnz 0x8c5
  db 0x83, 0x7D, 0x07, 0x00    ; 000008BF  cmp word [di+0x7],byte +0x0
  db 0x74, 0x07                ; 000008C3  jz 0x8cc
  db 0x57                      ; 000008C5  push di
  db 0x8B, 0xF7                ; 000008C6  mov si,di
  db 0xE8, 0x5F, 0x36          ; 000008C8  call 0x3f2a
  db 0x5F                      ; 000008CB  pop di
  db 0x58                      ; 000008CC  pop ax
  db 0xB9, 0x22, 0x00          ; 000008CD  mov cx,0x22
  db 0xF3, 0xAA                ; 000008D0  rep stosb
  db 0x59                      ; 000008D2  pop cx
  db 0xC3                      ; 000008D3  ret
  db 0xBB, 0xD7, 0x0B          ; 000008D4  mov bx,0xbd7
  db 0xB1, 0x02                ; 000008D7  mov cl,0x2
  db 0xD2, 0x67, 0x01          ; 000008D9  shl byte [bx+0x1],cl
  db 0xD2, 0x27                ; 000008DC  shl byte [bx],cl
  db 0x8A, 0x47, 0x01          ; 000008DE  mov al,[bx+0x1]
  db 0xE8, 0xE9, 0x39          ; 000008E1  call 0x42cd
  db 0x72, 0x3C                ; 000008E4  jc 0x922
  db 0x80, 0x7C, 0x01, 0x01    ; 000008E6  cmp byte [si+0x1],0x1
  db 0x75, 0x3B                ; 000008EA  jnz 0x927
  db 0x81, 0x7F, 0x08, 0x34, 0x04 ; 000008EC  cmp word [bx+0x8],0x434
  db 0x77, 0x30                ; 000008F1  ja 0x923
  db 0xC4, 0x7F, 0x0A          ; 000008F3  les di,[bx+0xa]
  db 0x26, 0x88, 0x45, 0x01    ; 000008F6  mov [es:di+0x1],al
  db 0x8A, 0x07                ; 000008FA  mov al,[bx]
  db 0x26, 0x88, 0x05          ; 000008FC  mov [es:di],al
  db 0x26, 0xC6, 0x45, 0x02, 0x03 ; 000008FF  mov byte [es:di+0x2],0x3
  db 0x2E, 0x8E, 0x06, 0x43, 0x42 ; 00000904  mov es,[cs:0x4243]
  db 0xBF, 0xE5, 0x0B          ; 00000909  mov di,0xbe5
  db 0xB0, 0x01                ; 0000090C  mov al,0x1
  db 0xAA                      ; 0000090E  stosb
  db 0x56                      ; 0000090F  push si
  db 0x8B, 0xF3                ; 00000910  mov si,bx
  db 0x83, 0xC6, 0x02          ; 00000912  add si,byte +0x2
  db 0xB9, 0x06, 0x00          ; 00000915  mov cx,0x6
  db 0xF3, 0xA5                ; 00000918  rep movsw
  db 0x5E                      ; 0000091A  pop si
  db 0x8B, 0x44, 0x04          ; 0000091B  mov ax,[si+0x4]
  db 0xAB                      ; 0000091E  stosw
  db 0xE8, 0x6E, 0x02          ; 0000091F  call 0xb90
  db 0xC3                      ; 00000922  ret
  db 0xB0, 0x09                ; 00000923  mov al,0x9
  db 0xEB, 0x02                ; 00000925  jmp short 0x929
  db 0xB0, 0x05                ; 00000927  mov al,0x5
  db 0xC4, 0x7F, 0x0A          ; 00000929  les di,[bx+0xa]
  db 0x8A, 0x27                ; 0000092C  mov ah,[bx]
  db 0x26, 0x88, 0x25          ; 0000092E  mov [es:di],ah
  db 0x26, 0xC6, 0x45, 0x01, 0x02 ; 00000931  mov byte [es:di+0x1],0x2
  db 0x26, 0x88, 0x45, 0x02    ; 00000936  mov [es:di+0x2],al
  db 0x8B, 0x44, 0x04          ; 0000093A  mov ax,[si+0x4]
  db 0xE8, 0x58, 0x02          ; 0000093D  call 0xb98
  db 0xC3                      ; 00000940  ret
  db 0xBB, 0xD7, 0x0B          ; 00000941  mov bx,0xbd7
  db 0xB1, 0x02                ; 00000944  mov cl,0x2
  db 0xD2, 0x67, 0x07          ; 00000946  shl byte [bx+0x7],cl
  db 0xD2, 0x67, 0x06          ; 00000949  shl byte [bx+0x6],cl
  db 0x8A, 0x47, 0x07          ; 0000094C  mov al,[bx+0x7]
  db 0x72, 0x19                ; 0000094F  jc 0x96a
  db 0xC4, 0x7F, 0x0A          ; 00000951  les di,[bx+0xa]
  db 0x8A, 0x47, 0x06          ; 00000954  mov al,[bx+0x6]
  db 0x26, 0x88, 0x05          ; 00000957  mov [es:di],al
  db 0x26, 0xC6, 0x45, 0x01, 0x03 ; 0000095A  mov byte [es:di+0x1],0x3
  db 0x26, 0xC6, 0x45, 0x02, 0xFF ; 0000095F  mov byte [es:di+0x2],0xff
  db 0x8B, 0x44, 0x04          ; 00000964  mov ax,[si+0x4]
  db 0xE8, 0x2E, 0x02          ; 00000967  call 0xb98
  db 0xC3                      ; 0000096A  ret
  db 0xBB, 0xD7, 0x0B          ; 0000096B  mov bx,0xbd7
  db 0xB1, 0x02                ; 0000096E  mov cl,0x2
  db 0xD2, 0x67, 0x01          ; 00000970  shl byte [bx+0x1],cl
  db 0xD2, 0x27                ; 00000973  shl byte [bx],cl
  db 0x8A, 0x47, 0x01          ; 00000975  mov al,[bx+0x1]
  db 0xE8, 0x52, 0x39          ; 00000978  call 0x42cd
  db 0x72, 0x36                ; 0000097B  jc 0x9b3
  db 0x81, 0x7F, 0x08, 0x34, 0x04 ; 0000097D  cmp word [bx+0x8],0x434
  db 0x77, 0x30                ; 00000982  ja 0x9b4
  db 0xC4, 0x7F, 0x0A          ; 00000984  les di,[bx+0xa]
  db 0x26, 0x88, 0x45, 0x01    ; 00000987  mov [es:di+0x1],al
  db 0x8A, 0x07                ; 0000098B  mov al,[bx]
  db 0x26, 0x88, 0x05          ; 0000098D  mov [es:di],al
  db 0x26, 0xC6, 0x45, 0x02, 0xF3 ; 00000990  mov byte [es:di+0x2],0xf3
  db 0x2E, 0x8E, 0x06, 0x43, 0x42 ; 00000995  mov es,[cs:0x4243]
  db 0xBF, 0xE5, 0x0B          ; 0000099A  mov di,0xbe5
  db 0xB0, 0x01                ; 0000099D  mov al,0x1
  db 0xAA                      ; 0000099F  stosb
  db 0x56                      ; 000009A0  push si
  db 0x8B, 0xF3                ; 000009A1  mov si,bx
  db 0x83, 0xC6, 0x02          ; 000009A3  add si,byte +0x2
  db 0xB9, 0x06, 0x00          ; 000009A6  mov cx,0x6
  db 0xF3, 0xA5                ; 000009A9  rep movsw
  db 0x5E                      ; 000009AB  pop si
  db 0x8B, 0x44, 0x04          ; 000009AC  mov ax,[si+0x4]
  db 0xAB                      ; 000009AF  stosw
  db 0xE8, 0xDD, 0x01          ; 000009B0  call 0xb90
  db 0xC3                      ; 000009B3  ret
  db 0xC4, 0x7F, 0x0A          ; 000009B4  les di,[bx+0xa]
  db 0x8A, 0x27                ; 000009B7  mov ah,[bx]
  db 0x26, 0x88, 0x25          ; 000009B9  mov [es:di],ah
  db 0x26, 0xC6, 0x45, 0x01, 0x04 ; 000009BC  mov byte [es:di+0x1],0x4
  db 0x26, 0xC6, 0x45, 0x02, 0x09 ; 000009C1  mov byte [es:di+0x2],0x9
  db 0x8B, 0x44, 0x04          ; 000009C6  mov ax,[si+0x4]
  db 0xE8, 0xCC, 0x01          ; 000009C9  call 0xb98
  db 0xC3                      ; 000009CC  ret
  db 0xBB, 0xD7, 0x0B          ; 000009CD  mov bx,0xbd7
  db 0xB1, 0x02                ; 000009D0  mov cl,0x2
  db 0xD2, 0x67, 0x02          ; 000009D2  shl byte [bx+0x2],cl
  db 0xD2, 0x67, 0x01          ; 000009D5  shl byte [bx+0x1],cl
  db 0x8A, 0x47, 0x02          ; 000009D8  mov al,[bx+0x2]
  db 0xE8, 0xEF, 0x38          ; 000009DB  call 0x42cd
  db 0x73, 0x03                ; 000009DE  jnc 0x9e3
  db 0xE9, 0x7F, 0x00          ; 000009E0  jmp 0xa62
  db 0x80, 0x7C, 0x01, 0x00    ; 000009E3  cmp byte [si+0x1],0x0
  db 0x74, 0x05                ; 000009E7  jz 0x9ee
  db 0xB0, 0x04                ; 000009E9  mov al,0x4
  db 0xE9, 0x75, 0x00          ; 000009EB  jmp 0xa63
  db 0x81, 0x7F, 0x03, 0x34, 0x04 ; 000009EE  cmp word [bx+0x3],0x434
  db 0x76, 0x05                ; 000009F3  jna 0x9fa
  db 0xB0, 0x09                ; 000009F5  mov al,0x9
  db 0xE9, 0x69, 0x00          ; 000009F7  jmp 0xa63
  db 0x8A, 0x07                ; 000009FA  mov al,[bx]
  db 0xE8, 0xE8, 0x38          ; 000009FC  call 0x42e7
  db 0x73, 0x05                ; 000009FF  jnc 0xa06
  db 0xB0, 0x01                ; 00000A01  mov al,0x1
  db 0xE9, 0x5D, 0x00          ; 00000A03  jmp 0xa63
  db 0x53                      ; 00000A06  push bx
  db 0x32, 0xFF                ; 00000A07  xor bh,bh
  db 0x8A, 0x5C, 0x02          ; 00000A09  mov bl,[si+0x2]
  db 0x2E, 0xFF, 0xA7, 0x11, 0x0A ; 00000A0C  jmp [cs:bx+0xa11]
  db 0x24, 0x0A                ; 00000A11  and al,0xa
  db 0x2B, 0x0A                ; 00000A13  sub cx,[bp+si]
  db 0x41                      ; 00000A15  inc cx
  db 0x0A, 0x1D                ; 00000A16  or bl,[di]
  db 0x0A, 0x24                ; 00000A18  or ah,[si]
  db 0x0A, 0x1D                ; 00000A1A  or bl,[di]
  db 0x0A, 0x5B, 0x8B          ; 00000A1C  or bl,[bp+di-0x75]
  db 0x34, 0xB0                ; 00000A1F  xor al,0xb0
  db 0x02, 0xEB                ; 00000A21  add ch,bl
  db 0x3F                      ; 00000A23  aas
  db 0x5B                      ; 00000A24  pop bx
  db 0x8B, 0x34                ; 00000A25  mov si,[si]
  db 0xB0, 0x01                ; 00000A27  mov al,0x1
  db 0xEB, 0x38                ; 00000A29  jmp short 0xa63
  db 0x5B                      ; 00000A2B  pop bx
  db 0xE8, 0x52, 0x00          ; 00000A2C  call 0xa81
  db 0x89, 0x7C, 0x1D          ; 00000A2F  mov [si+0x1d],di
  db 0x8C, 0x44, 0x1F          ; 00000A32  mov [si+0x1f],es
  db 0x8B, 0x47, 0x03          ; 00000A35  mov ax,[bx+0x3]
  db 0x89, 0x44, 0x1B          ; 00000A38  mov [si+0x1b],ax
  db 0xC6, 0x44, 0x02, 0x0A    ; 00000A3B  mov byte [si+0x2],0xa
  db 0xEB, 0x21                ; 00000A3F  jmp short 0xa62
  db 0x5B                      ; 00000A41  pop bx
  db 0xE8, 0x3C, 0x00          ; 00000A42  call 0xa81
  db 0x89, 0x7C, 0x15          ; 00000A45  mov [si+0x15],di
  db 0x8C, 0x44, 0x17          ; 00000A48  mov [si+0x17],es
  db 0x8B, 0x47, 0x03          ; 00000A4B  mov ax,[bx+0x3]
  db 0x89, 0x44, 0x13          ; 00000A4E  mov [si+0x13],ax
  db 0xC6, 0x44, 0x10, 0x05    ; 00000A51  mov byte [si+0x10],0x5
  db 0xC6, 0x44, 0x02, 0x06    ; 00000A55  mov byte [si+0x2],0x6
  db 0xBA, 0xBE, 0x0B          ; 00000A59  mov dx,0xbbe
  db 0xBF, 0xE5, 0x0B          ; 00000A5C  mov di,0xbe5
  db 0xE8, 0xFB, 0x38          ; 00000A5F  call 0x435d
  db 0xC3                      ; 00000A62  ret
  db 0xC4, 0x7F, 0x05          ; 00000A63  les di,[bx+0x5]
  db 0xB1, 0x02                ; 00000A66  mov cl,0x2
  db 0x26, 0xD2, 0x2D          ; 00000A68  shr byte [es:di],cl
  db 0x26, 0x88, 0x45, 0x02    ; 00000A6B  mov [es:di+0x2],al
  db 0x26, 0xC6, 0x45, 0x01, 0x05 ; 00000A6F  mov byte [es:di+0x1],0x5
  db 0x8A, 0x47, 0x01          ; 00000A74  mov al,[bx+0x1]
  db 0x26, 0x88, 0x05          ; 00000A77  mov [es:di],al
  db 0x8B, 0x44, 0x04          ; 00000A7A  mov ax,[si+0x4]
  db 0xE8, 0x18, 0x01          ; 00000A7D  call 0xb98
  db 0xC3                      ; 00000A80  ret
  db 0xC4, 0x7F, 0x05          ; 00000A81  les di,[bx+0x5]
  db 0x8A, 0x47, 0x01          ; 00000A84  mov al,[bx+0x1]
  db 0x26, 0x88, 0x05          ; 00000A87  mov [es:di],al
  db 0x8A, 0x47, 0x02          ; 00000A8A  mov al,[bx+0x2]
  db 0x26, 0x88, 0x45, 0x01    ; 00000A8D  mov [es:di+0x1],al
  db 0x26, 0xC6, 0x45, 0x02, 0x03 ; 00000A91  mov byte [es:di+0x2],0x3
  db 0x26, 0xC6, 0x45, 0x03, 0x03 ; 00000A96  mov byte [es:di+0x3],0x3
  db 0x8A, 0x44, 0x11          ; 00000A9B  mov al,[si+0x11]
  db 0x26, 0x88, 0x45, 0x04    ; 00000A9E  mov [es:di+0x4],al
  db 0x8A, 0x44, 0x04          ; 00000AA2  mov al,[si+0x4]
  db 0x26, 0x88, 0x45, 0x05    ; 00000AA5  mov [es:di+0x5],al
  db 0x80, 0x7C, 0x11, 0x00    ; 00000AA9  cmp byte [si+0x11],0x0
  db 0x74, 0x05                ; 00000AAD  jz 0xab4
  db 0xFE, 0x4C, 0x11          ; 00000AAF  dec byte [si+0x11]
  db 0xEB, 0x03                ; 00000AB2  jmp short 0xab7
  db 0xFE, 0x44, 0x11          ; 00000AB4  inc byte [si+0x11]
  db 0xC3                      ; 00000AB7  ret
  db 0xBB, 0xD7, 0x0B          ; 00000AB8  mov bx,0xbd7
  db 0xB1, 0x02                ; 00000ABB  mov cl,0x2
  db 0xD2, 0x67, 0x02          ; 00000ABD  shl byte [bx+0x2],cl
  db 0xD2, 0x67, 0x01          ; 00000AC0  shl byte [bx+0x1],cl
  db 0x8A, 0x47, 0x02          ; 00000AC3  mov al,[bx+0x2]
  db 0xE8, 0x04, 0x38          ; 00000AC6  call 0x42cd
  db 0x72, 0x56                ; 00000AC9  jc 0xb21
  db 0x56                      ; 00000ACB  push si
  db 0x50                      ; 00000ACC  push ax
  db 0x8A, 0x07                ; 00000ACD  mov al,[bx]
  db 0xE8, 0x15, 0x38          ; 00000ACF  call 0x42e7
  db 0x72, 0x33                ; 00000AD2  jc 0xb07
  db 0x9C                      ; 00000AD4  pushf
  db 0xFA                      ; 00000AD5  cli
  db 0x80, 0x7C, 0x02, 0x08    ; 00000AD6  cmp byte [si+0x2],0x8
  db 0x75, 0x2A                ; 00000ADA  jnz 0xb06
  db 0x8B, 0xFE                ; 00000ADC  mov di,si
  db 0x2E, 0x8E, 0x06, 0x43, 0x42 ; 00000ADE  mov es,[cs:0x4243]
  db 0xB9, 0x22, 0x00          ; 00000AE3  mov cx,0x22
  db 0x32, 0xC0                ; 00000AE6  xor al,al
  db 0xF3, 0xAA                ; 00000AE8  rep stosb
  db 0x9D                      ; 00000AEA  popf
  db 0xC4, 0x7F, 0x05          ; 00000AEB  les di,[bx+0x5]
  db 0x26, 0xC6, 0x45, 0x01, 0x06 ; 00000AEE  mov byte [es:di+0x1],0x6
  db 0x26, 0xC6, 0x45, 0x02, 0x00 ; 00000AF3  mov byte [es:di+0x2],0x0
  db 0x58                      ; 00000AF8  pop ax
  db 0x5E                      ; 00000AF9  pop si
  db 0x3C, 0x08                ; 00000AFA  cmp al,0x8
  db 0x74, 0x23                ; 00000AFC  jz 0xb21
  db 0x8B, 0x44, 0x04          ; 00000AFE  mov ax,[si+0x4]
  db 0xE8, 0x94, 0x00          ; 00000B01  call 0xb98
  db 0xEB, 0x1B                ; 00000B04  jmp short 0xb21
  db 0x9D                      ; 00000B06  popf
  db 0x58                      ; 00000B07  pop ax
  db 0x5E                      ; 00000B08  pop si
  db 0x8B, 0x44, 0x04          ; 00000B09  mov ax,[si+0x4]
  db 0x50                      ; 00000B0C  push ax
  db 0xE8, 0x41, 0xFD          ; 00000B0D  call 0x851
  db 0xC4, 0x7F, 0x05          ; 00000B10  les di,[bx+0x5]
  db 0x26, 0xC6, 0x45, 0x01, 0x06 ; 00000B13  mov byte [es:di+0x1],0x6
  db 0x26, 0xC6, 0x45, 0x02, 0x0A ; 00000B18  mov byte [es:di+0x2],0xa
  db 0x58                      ; 00000B1D  pop ax
  db 0xE8, 0x77, 0x00          ; 00000B1E  call 0xb98
  db 0xC3                      ; 00000B21  ret
  db 0xBF, 0xBE, 0x0B          ; 00000B22  mov di,0xbbe
  db 0xC7, 0x45, 0x06, 0xD6, 0x0B ; 00000B25  mov word [di+0x6],0xbd6
  db 0x57                      ; 00000B2A  push di
  db 0xE8, 0x62, 0x00          ; 00000B2B  call 0xb90
  db 0x5F                      ; 00000B2E  pop di
  db 0xC7, 0x45, 0x06, 0xE5, 0x0B ; 00000B2F  mov word [di+0x6],0xbe5
  db 0xC3                      ; 00000B34  ret
  db 0xBB, 0xD7, 0x0B          ; 00000B35  mov bx,0xbd7
  db 0xB9, 0x20, 0x00          ; 00000B38  mov cx,0x20
  db 0x32, 0xC0                ; 00000B3B  xor al,al
  db 0xC4, 0x3F                ; 00000B3D  les di,[bx]
  db 0xBE, 0x45, 0x15          ; 00000B3F  mov si,0x1545
  db 0x47                      ; 00000B42  inc di
  db 0x80, 0x3C, 0x00          ; 00000B43  cmp byte [si],0x0
  db 0x74, 0x0D                ; 00000B46  jz 0xb55
  db 0x46                      ; 00000B48  inc si
  db 0x51                      ; 00000B49  push cx
  db 0xB9, 0x03, 0x00          ; 00000B4A  mov cx,0x3
  db 0xF3, 0xA5                ; 00000B4D  rep movsw
  db 0x83, 0xEE, 0x07          ; 00000B4F  sub si,byte +0x7
  db 0x59                      ; 00000B52  pop cx
  db 0xFE, 0xC0                ; 00000B53  inc al
  db 0x83, 0xC6, 0x4B          ; 00000B55  add si,byte +0x4b
  db 0xE2, 0xE9                ; 00000B58  loop 0xb43
  db 0xC4, 0x3F                ; 00000B5A  les di,[bx]
  db 0x26, 0x88, 0x05          ; 00000B5C  mov [es:di],al
  db 0x8B, 0x47, 0x04          ; 00000B5F  mov ax,[bx+0x4]
  db 0xE8, 0x33, 0x00          ; 00000B62  call 0xb98
  db 0xC3                      ; 00000B65  ret
  db 0xBB, 0xD7, 0x0B          ; 00000B66  mov bx,0xbd7
  db 0xC4, 0x3F                ; 00000B69  les di,[bx]
  db 0xBE, 0x90, 0x1F          ; 00000B6B  mov si,0x1f90
  db 0xB9, 0x04, 0x00          ; 00000B6E  mov cx,0x4
  db 0xF3, 0xA5                ; 00000B71  rep movsw
  db 0x2E, 0xA1, 0x41, 0x15    ; 00000B73  mov ax,[cs:0x1541]
  db 0xAB                      ; 00000B77  stosw
  db 0x2E, 0xA1, 0x12, 0x0E    ; 00000B78  mov ax,[cs:0xe12]
  db 0xAB                      ; 00000B7C  stosw
  db 0x2E, 0xA1, 0x43, 0x15    ; 00000B7D  mov ax,[cs:0x1543]
  db 0xAB                      ; 00000B81  stosw
  db 0x2E, 0xA1, 0x3F, 0x15    ; 00000B82  mov ax,[cs:0x153f]
  db 0xAB                      ; 00000B86  stosw
  db 0xC4, 0x3F                ; 00000B87  les di,[bx]
  db 0x8B, 0x47, 0x04          ; 00000B89  mov ax,[bx+0x4]
  db 0xE8, 0x09, 0x00          ; 00000B8C  call 0xb98
  db 0xC3                      ; 00000B8F  ret
  db 0xBA, 0xBE, 0x0B          ; 00000B90  mov dx,0xbbe
  db 0xB1, 0x8B                ; 00000B93  mov cl,0x8b
  db 0xCD, 0xE0                ; 00000B95  int 0xe0
  db 0xC3                      ; 00000B97  ret
  db 0x2E, 0xA3, 0xD0, 0x0B    ; 00000B98  mov [cs:0xbd0],ax
  db 0x2E, 0x89, 0x3E, 0xF4, 0x0B ; 00000B9C  mov [cs:0xbf4],di
  db 0x2E, 0x8C, 0x06, 0xF6, 0x0B ; 00000BA1  mov [cs:0xbf6],es
  db 0xBA, 0xCE, 0x0B          ; 00000BA6  mov dx,0xbce
  db 0xB1, 0x8B                ; 00000BA9  mov cl,0x8b
  db 0xCD, 0xE0                ; 00000BAB  int 0xe0
  db 0xC3                      ; 00000BAD  ret
  db 0x00, 0x00                ; 00000BAE  add [bx+si],al
  db 0x00, 0x00                ; 00000BB0  add [bx+si],al
  db 0x00, 0x00                ; 00000BB2  add [bx+si],al
  db 0xD6                      ; 00000BB4  salc
  db 0x0B, 0x6C, 0x69          ; 00000BB5  or bp,[si+0x69]
  db 0x6E                      ; 00000BB8  outsb
  db 0x6B, 0x5F, 0x72, 0x65    ; 00000BB9  imul bx,[bx+0x72],byte +0x65
  db 0x71, 0x00                ; 00000BBD  jno 0xbbf
  db 0x00, 0x00                ; 00000BBF  add [bx+si],al
  db 0x00, 0x00                ; 00000BC1  add [bx+si],al
  db 0x00, 0xE5                ; 00000BC3  add ch,ah
  db 0x0B, 0x58, 0x4D          ; 00000BC5  or bx,[bx+si+0x4d]
  db 0x49                      ; 00000BC8  dec cx
  db 0x54                      ; 00000BC9  push sp
  db 0x5F                      ; 00000BCA  pop di
  db 0x52                      ; 00000BCB  push dx
  db 0x45                      ; 00000BCC  inc bp
  db 0x51                      ; 00000BCD  push cx
  db 0x00, 0x00                ; 00000BCE  add [bx+si],al
  db 0x00, 0x00                ; 00000BD0  add [bx+si],al
  db 0x00, 0x00                ; 00000BD2  add [bx+si],al
  db 0xF4                      ; 00000BD4  hlt
  db 0x0B, 0x00                ; 00000BD5  or ax,[bx+si]
  db 0x00, 0x00                ; 00000BD7  add [bx+si],al
  db 0x00, 0x00                ; 00000BD9  add [bx+si],al
  db 0x00, 0x00                ; 00000BDB  add [bx+si],al
  db 0x00, 0x00                ; 00000BDD  add [bx+si],al
  db 0x00, 0x00                ; 00000BDF  add [bx+si],al
  db 0x00, 0x00                ; 00000BE1  add [bx+si],al
  db 0x00, 0x00                ; 00000BE3  add [bx+si],al
  db 0x00, 0x00                ; 00000BE5  add [bx+si],al
  db 0x00, 0x00                ; 00000BE7  add [bx+si],al
  db 0x00, 0x00                ; 00000BE9  add [bx+si],al
  db 0x00, 0x00                ; 00000BEB  add [bx+si],al
  db 0x00, 0x00                ; 00000BED  add [bx+si],al
  db 0x00, 0x00                ; 00000BEF  add [bx+si],al
  db 0x00, 0x00                ; 00000BF1  add [bx+si],al
  db 0x00, 0x00                ; 00000BF3  add [bx+si],al
  db 0x00, 0x00                ; 00000BF5  add [bx+si],al
  db 0x00, 0xFA                ; 00000BF7  add dl,bh
  db 0x8C, 0xC8                ; 00000BF9  mov ax,cs
  db 0x8E, 0xD0                ; 00000BFB  mov ss,ax
  db 0xBC, 0x24, 0x07          ; 00000BFD  mov sp,0x724
  db 0xFB                      ; 00000C00  sti
  db 0xB1, 0x87                ; 00000C01  mov cl,0x87
  db 0xBA, 0xE7, 0x0D          ; 00000C03  mov dx,0xde7
  db 0xCD, 0xE0                ; 00000C06  int 0xe0
  db 0xB1, 0x89                ; 00000C08  mov cl,0x89
  db 0xBA, 0xE7, 0x0D          ; 00000C0A  mov dx,0xde7
  db 0xCD, 0xE0                ; 00000C0D  int 0xe0
  db 0x2E, 0xA0, 0x03, 0x0E    ; 00000C0F  mov al,[cs:0xe03]
  db 0x3C, 0x07                ; 00000C13  cmp al,0x7
  db 0x7F, 0xF1                ; 00000C15  jg 0xc08
  db 0x32, 0xE4                ; 00000C17  xor ah,ah
  db 0x8B, 0xF0                ; 00000C19  mov si,ax
  db 0xD1, 0xE6                ; 00000C1B  shl si,1
  db 0xBB, 0x04, 0x0E          ; 00000C1D  mov bx,0xe04
  db 0x2E, 0xFF, 0xA4, 0x25, 0x0C ; 00000C20  jmp [cs:si+0xc25]
  db 0x35, 0x0C, 0x98          ; 00000C25  xor ax,0x980c
  db 0x0C, 0xC7                ; 00000C28  or al,0xc7
  db 0x0C, 0xDD                ; 00000C2A  or al,0xdd
  db 0x0C, 0x62                ; 00000C2C  or al,0x62
  db 0x0C, 0xEF                ; 00000C2E  or al,0xef
  db 0x0C, 0x08                ; 00000C30  or al,0x8
  db 0x0C, 0xF5                ; 00000C32  or al,0xf5
  db 0x0C, 0x9C                ; 00000C34  or al,0x9c
  db 0xFA                      ; 00000C36  cli
  db 0x8B, 0x37                ; 00000C37  mov si,[bx]
  db 0x80, 0x7C, 0x21, 0x01    ; 00000C39  cmp byte [si+0x21],0x1
  db 0x75, 0x1F                ; 00000C3D  jnz 0xc5e
  db 0x8A, 0x47, 0x02          ; 00000C3F  mov al,[bx+0x2]
  db 0x3A, 0x44, 0x11          ; 00000C42  cmp al,[si+0x11]
  db 0x75, 0x17                ; 00000C45  jnz 0xc5e
  db 0xC6, 0x44, 0x21, 0x02    ; 00000C47  mov byte [si+0x21],0x2
  db 0x9D                      ; 00000C4B  popf
  db 0x56                      ; 00000C4C  push si
  db 0xE8, 0xE6, 0x00          ; 00000C4D  call 0xd36
  db 0xE8, 0x27, 0x01          ; 00000C50  call 0xd7a
  db 0x5E                      ; 00000C53  pop si
  db 0xE8, 0xA0, 0x31          ; 00000C54  call 0x3df7
  db 0xC6, 0x44, 0x21, 0x01    ; 00000C57  mov byte [si+0x21],0x1
  db 0xE9, 0xAA, 0xFF          ; 00000C5B  jmp 0xc08
  db 0x9D                      ; 00000C5E  popf
  db 0xE9, 0xA6, 0xFF          ; 00000C5F  jmp 0xc08
  db 0x9C                      ; 00000C62  pushf
  db 0xFA                      ; 00000C63  cli
  db 0x8B, 0x37                ; 00000C64  mov si,[bx]
  db 0x80, 0x7C, 0x21, 0x01    ; 00000C66  cmp byte [si+0x21],0x1
  db 0x75, 0xF2                ; 00000C6A  jnz 0xc5e
  db 0x80, 0x7C, 0x02, 0x02    ; 00000C6C  cmp byte [si+0x2],0x2
  db 0x74, 0x06                ; 00000C70  jz 0xc78
  db 0x80, 0x7C, 0x02, 0x0A    ; 00000C72  cmp byte [si+0x2],0xa
  db 0x75, 0xE6                ; 00000C76  jnz 0xc5e
  db 0xC6, 0x44, 0x21, 0x02    ; 00000C78  mov byte [si+0x21],0x2
  db 0x9D                      ; 00000C7C  popf
  db 0x56                      ; 00000C7D  push si
  db 0xE8, 0xB5, 0x00          ; 00000C7E  call 0xd36
  db 0xBE, 0xB0, 0x1F          ; 00000C81  mov si,0x1fb0
  db 0x8A, 0x47, 0x02          ; 00000C84  mov al,[bx+0x2]
  db 0x88, 0x44, 0x04          ; 00000C87  mov [si+0x4],al
  db 0xE8, 0xED, 0x00          ; 00000C8A  call 0xd7a
  db 0x5E                      ; 00000C8D  pop si
  db 0xE8, 0x66, 0x31          ; 00000C8E  call 0x3df7
  db 0xC6, 0x44, 0x21, 0x01    ; 00000C91  mov byte [si+0x21],0x1
  db 0xE9, 0x70, 0xFF          ; 00000C95  jmp 0xc08
  db 0x53                      ; 00000C98  push bx
  db 0xE8, 0xB5, 0x00          ; 00000C99  call 0xd51
  db 0x5B                      ; 00000C9C  pop bx
  db 0xC4, 0x77, 0x08          ; 00000C9D  les si,[bx+0x8]
  db 0xB1, 0x02                ; 00000CA0  mov cl,0x2
  db 0x26, 0xD2, 0x2C          ; 00000CA2  shr byte [es:si],cl
  db 0x26, 0x8A, 0x44, 0x02    ; 00000CA5  mov al,[es:si+0x2]
  db 0x26, 0xC6, 0x44, 0x02, 0x00 ; 00000CA9  mov byte [es:si+0x2],0x0
  db 0x3C, 0x03                ; 00000CAE  cmp al,0x3
  db 0x75, 0x07                ; 00000CB0  jnz 0xcb9
  db 0x26, 0xC6, 0x44, 0x01, 0x02 ; 00000CB2  mov byte [es:si+0x1],0x2
  db 0xEB, 0x05                ; 00000CB7  jmp short 0xcbe
  db 0x26, 0xC6, 0x44, 0x01, 0x04 ; 00000CB9  mov byte [es:si+0x1],0x4
  db 0x8B, 0x47, 0x0C          ; 00000CBE  mov ax,[bx+0xc]
  db 0xE8, 0x0D, 0x01          ; 00000CC1  call 0xdd1
  db 0xE9, 0x41, 0xFF          ; 00000CC4  jmp 0xc08
  db 0x8B, 0xF3                ; 00000CC7  mov si,bx
  db 0xE8, 0xA0, 0x00          ; 00000CC9  call 0xd6c
  db 0xBF, 0xB0, 0x1F          ; 00000CCC  mov di,0x1fb0
  db 0xB9, 0x03, 0x00          ; 00000CCF  mov cx,0x3
  db 0xF3, 0xA5                ; 00000CD2  rep movsw
  db 0xB9, 0x06, 0x00          ; 00000CD4  mov cx,0x6
  db 0xE8, 0xA0, 0x00          ; 00000CD7  call 0xd7a
  db 0xE9, 0x2B, 0xFF          ; 00000CDA  jmp 0xc08
  db 0x53                      ; 00000CDD  push bx
  db 0xE8, 0x70, 0x00          ; 00000CDE  call 0xd51
  db 0x5B                      ; 00000CE1  pop bx
  db 0x8B, 0x47, 0x0C          ; 00000CE2  mov ax,[bx+0xc]
  db 0x1E                      ; 00000CE5  push ds
  db 0x50                      ; 00000CE6  push ax
  db 0xCD, 0x29                ; 00000CE7  int 0x29
  db 0x83, 0xC4, 0x04          ; 00000CE9  add sp,byte +0x4
  db 0xE9, 0x19, 0xFF          ; 00000CEC  jmp 0xc08
  db 0xE8, 0x5F, 0x00          ; 00000CEF  call 0xd51
  db 0xE9, 0x13, 0xFF          ; 00000CF2  jmp 0xc08
  db 0x53                      ; 00000CF5  push bx
  db 0x2E, 0xC7, 0x06, 0x9A, 0x1F, 0x05, 0x80 ; 00000CF6  mov word [cs:0x1f9a],0x8005
  db 0xB8, 0x00, 0x01          ; 00000CFD  mov ax,0x100
  db 0xE8, 0x19, 0x37          ; 00000D00  call 0x441c
  db 0x8C, 0xD8                ; 00000D03  mov ax,ds
  db 0x05, 0x50, 0x00          ; 00000D05  add ax,0x50
  db 0x8E, 0xC0                ; 00000D08  mov es,ax
  db 0xBA, 0x16, 0x00          ; 00000D0A  mov dx,0x16
  db 0xE8, 0x2E, 0x37          ; 00000D0D  call 0x443e
  db 0x5B                      ; 00000D10  pop bx
  db 0xC4, 0x37                ; 00000D11  les si,[bx]
  db 0x26, 0xC6, 0x04, 0x07    ; 00000D13  mov byte [es:si],0x7
  db 0x2E, 0xA1, 0x9E, 0x1F    ; 00000D17  mov ax,[cs:0x1f9e]
  db 0x26, 0x89, 0x44, 0x01    ; 00000D1B  mov [es:si+0x1],ax
  db 0x8B, 0x47, 0x04          ; 00000D1F  mov ax,[bx+0x4]
  db 0xE8, 0xAC, 0x00          ; 00000D22  call 0xdd1
  db 0x2E, 0xC7, 0x06, 0x9E, 0x1F, 0xA8, 0x1F ; 00000D25  mov word [cs:0x1f9e],0x1fa8
  db 0x2E, 0xC7, 0x06, 0x98, 0x1F, 0x00, 0x00 ; 00000D2C  mov word [cs:0x1f98],0x0
  db 0xE9, 0xD2, 0xFE          ; 00000D33  jmp 0xc08
  db 0x56                      ; 00000D36  push si
  db 0x8B, 0x74, 0x19          ; 00000D37  mov si,[si+0x19]
  db 0x46                      ; 00000D3A  inc si
  db 0xE8, 0x2E, 0x00          ; 00000D3B  call 0xd6c
  db 0x5E                      ; 00000D3E  pop si
  db 0x57                      ; 00000D3F  push di
  db 0x1E                      ; 00000D40  push ds
  db 0x8B, 0x4C, 0x13          ; 00000D41  mov cx,[si+0x13]
  db 0x51                      ; 00000D44  push cx
  db 0xC5, 0x74, 0x15          ; 00000D45  lds si,[si+0x15]
  db 0xBF, 0xB0, 0x1F          ; 00000D48  mov di,0x1fb0
  db 0xF3, 0xA4                ; 00000D4B  rep movsb
  db 0x59                      ; 00000D4D  pop cx
  db 0x1F                      ; 00000D4E  pop ds
  db 0x5F                      ; 00000D4F  pop di
  db 0xC3                      ; 00000D50  ret
  db 0x8B, 0xF3                ; 00000D51  mov si,bx
  db 0xE8, 0x16, 0x00          ; 00000D53  call 0xd6c
  db 0xBF, 0xB0, 0x1F          ; 00000D56  mov di,0x1fb0
  db 0x57                      ; 00000D59  push di
  db 0x1E                      ; 00000D5A  push ds
  db 0x8B, 0x4F, 0x06          ; 00000D5B  mov cx,[bx+0x6]
  db 0xC5, 0x77, 0x08          ; 00000D5E  lds si,[bx+0x8]
  db 0xF3, 0xA4                ; 00000D61  rep movsb
  db 0x1F                      ; 00000D63  pop ds
  db 0x5F                      ; 00000D64  pop di
  db 0x8B, 0x4F, 0x06          ; 00000D65  mov cx,[bx+0x6]
  db 0xE8, 0x0F, 0x00          ; 00000D68  call 0xd7a
  db 0xC3                      ; 00000D6B  ret
  db 0x2E, 0x8E, 0x06, 0x43, 0x42 ; 00000D6C  mov es,[cs:0x4243]
  db 0xBF, 0xA0, 0x1F          ; 00000D71  mov di,0x1fa0
  db 0xB9, 0x03, 0x00          ; 00000D74  mov cx,0x3
  db 0xF3, 0xA5                ; 00000D77  rep movsw
  db 0xC3                      ; 00000D79  ret
  db 0x86, 0xCD                ; 00000D7A  xchg cl,ch
  db 0x2E, 0x89, 0x0E, 0xA6, 0x1F ; 00000D7C  mov [cs:0x1fa6],cx
  db 0x86, 0xCD                ; 00000D81  xchg cl,ch
  db 0x83, 0xF9, 0x2E          ; 00000D83  cmp cx,byte +0x2e
  db 0x73, 0x03                ; 00000D86  jnc 0xd8b
  db 0xB9, 0x2E, 0x00          ; 00000D88  mov cx,0x2e
  db 0x81, 0xC9, 0x00, 0x80    ; 00000D8B  or cx,0x8000
  db 0x2E, 0x89, 0x0E, 0xA8, 0x1F ; 00000D8F  mov [cs:0x1fa8],cx
  db 0x2E, 0xC7, 0x06, 0x9A, 0x1F, 0x04, 0x80 ; 00000D94  mov word [cs:0x1f9a],0x8004
  db 0x2E, 0xC6, 0x06, 0x14, 0x0E, 0x02 ; 00000D9B  mov byte [cs:0xe14],0x2
  db 0xB8, 0x00, 0x01          ; 00000DA1  mov ax,0x100
  db 0xE8, 0x75, 0x36          ; 00000DA4  call 0x441c
  db 0x8C, 0xD8                ; 00000DA7  mov ax,ds
  db 0x05, 0x50, 0x00          ; 00000DA9  add ax,0x50
  db 0x8E, 0xC0                ; 00000DAC  mov es,ax
  db 0xBA, 0x16, 0x00          ; 00000DAE  mov dx,0x16
  db 0xE8, 0x8A, 0x36          ; 00000DB1  call 0x443e
  db 0x2E, 0xFF, 0x06, 0x12, 0x0E ; 00000DB4  inc word [cs:0xe12]
  db 0x2E, 0xA1, 0x98, 0x1F    ; 00000DB9  mov ax,[cs:0x1f98]
  db 0x2E, 0xC7, 0x06, 0x98, 0x1F, 0x00, 0x00 ; 00000DBD  mov word [cs:0x1f98],0x0
  db 0xA9, 0x00, 0xA0          ; 00000DC4  test ax,0xa000
  db 0x75, 0x07                ; 00000DC7  jnz 0xdd0
  db 0x2E, 0xFE, 0x0E, 0x14, 0x0E ; 00000DC9  dec byte [cs:0xe14]
  db 0x75, 0xD1                ; 00000DCE  jnz 0xda1
  db 0xC3                      ; 00000DD0  ret
  db 0x2E, 0xA3, 0xF9, 0x0D    ; 00000DD1  mov [cs:0xdf9],ax
  db 0x2E, 0x89, 0x36, 0xFF, 0x0D ; 00000DD5  mov [cs:0xdff],si
  db 0x2E, 0x8C, 0x06, 0x01, 0x0E ; 00000DDA  mov [cs:0xe01],es
  db 0xBA, 0xF7, 0x0D          ; 00000DDF  mov dx,0xdf7
  db 0xB1, 0x8B                ; 00000DE2  mov cl,0x8b
  db 0xCD, 0xE0                ; 00000DE4  int 0xe0
  db 0xC3                      ; 00000DE6  ret
  db 0x00, 0x00                ; 00000DE7  add [bx+si],al
  db 0x00, 0x00                ; 00000DE9  add [bx+si],al
  db 0x00, 0x00                ; 00000DEB  add [bx+si],al
  db 0x03, 0x0E, 0x58, 0x4D    ; 00000DED  add cx,[0x4d58]
  db 0x49                      ; 00000DF1  dec cx
  db 0x54                      ; 00000DF2  push sp
  db 0x5F                      ; 00000DF3  pop di
  db 0x52                      ; 00000DF4  push dx
  db 0x45                      ; 00000DF5  inc bp
  db 0x51                      ; 00000DF6  push cx
  db 0x00, 0x00                ; 00000DF7  add [bx+si],al
  db 0x00, 0x00                ; 00000DF9  add [bx+si],al
  db 0x00, 0x00                ; 00000DFB  add [bx+si],al
  db 0xFF, 0x0D                ; 00000DFD  dec word [di]
  db 0x00, 0x00                ; 00000DFF  add [bx+si],al
  db 0x00, 0x00                ; 00000E01  add [bx+si],al
  db 0x00, 0x00                ; 00000E03  add [bx+si],al
  db 0x00, 0x00                ; 00000E05  add [bx+si],al
  db 0x00, 0x00                ; 00000E07  add [bx+si],al
  db 0x00, 0x00                ; 00000E09  add [bx+si],al
  db 0x00, 0x00                ; 00000E0B  add [bx+si],al
  db 0x00, 0x00                ; 00000E0D  add [bx+si],al
  db 0x00, 0x00                ; 00000E0F  add [bx+si],al
  db 0x00, 0x00                ; 00000E11  add [bx+si],al
  db 0x00, 0x00                ; 00000E13  add [bx+si],al
  db 0xFA                      ; 00000E15  cli
  db 0x8C, 0xC8                ; 00000E16  mov ax,cs
  db 0x8E, 0xD0                ; 00000E18  mov ss,ax
  db 0xBC, 0xC4, 0x04          ; 00000E1A  mov sp,0x4c4
  db 0xFB                      ; 00000E1D  sti
  db 0xBA, 0x03, 0x15          ; 00000E1E  mov dx,0x1503
  db 0xB1, 0x87                ; 00000E21  mov cl,0x87
  db 0xCD, 0xE0                ; 00000E23  int 0xe0
  db 0x9C                      ; 00000E25  pushf
  db 0xFA                      ; 00000E26  cli
  db 0x2E, 0xC6, 0x06, 0xB8, 0x3F, 0xFF ; 00000E27  mov byte [cs:0x3fb8],0xff
  db 0x2E, 0xC6, 0x06, 0x0C, 0x1F, 0x00 ; 00000E2D  mov byte [cs:0x1f0c],0x0
  db 0x2E, 0xC6, 0x06, 0x74, 0x1F, 0x00 ; 00000E33  mov byte [cs:0x1f74],0x0
  db 0x9D                      ; 00000E39  popf
  db 0x8C, 0xD8                ; 00000E3A  mov ax,ds
  db 0x05, 0x2A, 0x00          ; 00000E3C  add ax,0x2a
  db 0x8E, 0xC0                ; 00000E3F  mov es,ax
  db 0xBA, 0x17, 0x00          ; 00000E41  mov dx,0x17
  db 0xE8, 0xF7, 0x35          ; 00000E44  call 0x443e
  db 0x9C                      ; 00000E47  pushf
  db 0xFA                      ; 00000E48  cli
  db 0x2E, 0xC6, 0x06, 0xB8, 0x3F, 0x00 ; 00000E49  mov byte [cs:0x3fb8],0x0
  db 0x2E, 0xC6, 0x06, 0x0C, 0x1F, 0xFF ; 00000E4F  mov byte [cs:0x1f0c],0xff
  db 0x2E, 0xC6, 0x06, 0x74, 0x1F, 0xFF ; 00000E55  mov byte [cs:0x1f74],0xff
  db 0x2E, 0x80, 0x3E, 0xCC, 0x42, 0xFF ; 00000E5B  cmp byte [cs:0x42cc],0xff
  db 0x74, 0x04                ; 00000E61  jz 0xe67
  db 0x9D                      ; 00000E63  popf
  db 0xE9, 0x9C, 0x00          ; 00000E64  jmp 0xf03
  db 0x2E, 0xC6, 0x06, 0xCC, 0x42, 0x00 ; 00000E67  mov byte [cs:0x42cc],0x0
  db 0x33, 0xC9                ; 00000E6D  xor cx,cx
  db 0x2E, 0x87, 0x0E, 0x2E, 0x15 ; 00000E6F  xchg cx,[cs:0x152e]
  db 0xBB, 0x00, 0x00          ; 00000E74  mov bx,0x0
  db 0x2E, 0x87, 0x1E, 0x30, 0x15 ; 00000E77  xchg bx,[cs:0x1530]
  db 0x2E, 0xC7, 0x06, 0x32, 0x15, 0x00, 0x00 ; 00000E7C  mov word [cs:0x1532],0x0
  db 0x9D                      ; 00000E83  popf
  db 0x2E, 0x01, 0x0E, 0x41, 0x15 ; 00000E84  add [cs:0x1541],cx
  db 0x0B, 0xC9                ; 00000E89  or cx,cx
  db 0x74, 0x03                ; 00000E8B  jz 0xe90
  db 0xE8, 0xAC, 0x01          ; 00000E8D  call 0x103c
  db 0x2E, 0x80, 0x3E, 0x34, 0x15, 0x00 ; 00000E90  cmp byte [cs:0x1534],0x0
  db 0x74, 0x6B                ; 00000E96  jz 0xf03
  db 0x9C                      ; 00000E98  pushf
  db 0xFA                      ; 00000E99  cli
  db 0x2E, 0x80, 0x3E, 0x35, 0x15, 0x00 ; 00000E9A  cmp byte [cs:0x1535],0x0
  db 0x74, 0x08                ; 00000EA0  jz 0xeaa
  db 0x2E, 0x80, 0x3E, 0x3A, 0x15, 0x00 ; 00000EA2  cmp byte [cs:0x153a],0x0
  db 0x75, 0x12                ; 00000EA8  jnz 0xebc
  db 0x2E, 0x80, 0x3E, 0xCC, 0x42, 0xFF ; 00000EAA  cmp byte [cs:0x42cc],0xff
  db 0x74, 0xB5                ; 00000EB0  jz 0xe67
  db 0x9D                      ; 00000EB2  popf
  db 0xB1, 0x8D                ; 00000EB3  mov cl,0x8d
  db 0xBA, 0x01, 0x00          ; 00000EB5  mov dx,0x1
  db 0xCD, 0xE0                ; 00000EB8  int 0xe0
  db 0xEB, 0xDC                ; 00000EBA  jmp short 0xe98
  db 0x2E, 0x8B, 0x36, 0x36, 0x15 ; 00000EBC  mov si,[cs:0x1536]
  db 0x2E, 0x8B, 0x3E, 0x3B, 0x15 ; 00000EC1  mov di,[cs:0x153b]
  db 0x89, 0x7C, 0x06          ; 00000EC6  mov [si+0x6],di
  db 0x2E, 0x89, 0x36, 0x8E, 0x1F ; 00000EC9  mov [cs:0x1f8e],si
  db 0x2E, 0xC6, 0x06, 0x35, 0x15, 0x00 ; 00000ECE  mov byte [cs:0x1535],0x0
  db 0x2E, 0xC7, 0x06, 0x36, 0x15, 0x00, 0x00 ; 00000ED4  mov word [cs:0x1536],0x0
  db 0x2E, 0xC7, 0x06, 0x38, 0x15, 0x00, 0x00 ; 00000EDB  mov word [cs:0x1538],0x0
  db 0x2E, 0xC6, 0x06, 0x3A, 0x15, 0x00 ; 00000EE2  mov byte [cs:0x153a],0x0
  db 0x2E, 0xC7, 0x06, 0x3B, 0x15, 0x00, 0x00 ; 00000EE8  mov word [cs:0x153b],0x0
  db 0x2E, 0xC7, 0x06, 0x3D, 0x15, 0x00, 0x00 ; 00000EEF  mov word [cs:0x153d],0x0
  db 0x2E, 0xC6, 0x06, 0x34, 0x15, 0x00 ; 00000EF6  mov byte [cs:0x1534],0x0
  db 0x9D                      ; 00000EFC  popf
  db 0xB8, 0x10, 0x00          ; 00000EFD  mov ax,0x10
  db 0xE8, 0x19, 0x35          ; 00000F00  call 0x441c
  db 0x32, 0xC0                ; 00000F03  xor al,al
  db 0x2E, 0x86, 0x06, 0xCB, 0x42 ; 00000F05  xchg al,[cs:0x42cb]
  db 0x3C, 0x00                ; 00000F0A  cmp al,0x0
  db 0x75, 0x03                ; 00000F0C  jnz 0xf11
  db 0xE9, 0x14, 0xFF          ; 00000F0E  jmp 0xe25
  db 0xA8, 0x01                ; 00000F11  test al,0x1
  db 0x74, 0x05                ; 00000F13  jz 0xf1a
  db 0x50                      ; 00000F15  push ax
  db 0xE8, 0x23, 0x00          ; 00000F16  call 0xf3c
  db 0x58                      ; 00000F19  pop ax
  db 0xA8, 0x02                ; 00000F1A  test al,0x2
  db 0x74, 0x05                ; 00000F1C  jz 0xf23
  db 0x50                      ; 00000F1E  push ax
  db 0xE8, 0x87, 0x00          ; 00000F1F  call 0xfa9
  db 0x58                      ; 00000F22  pop ax
  db 0xA8, 0x04                ; 00000F23  test al,0x4
  db 0x74, 0x08                ; 00000F25  jz 0xf2f
  db 0x50                      ; 00000F27  push ax
  db 0xBE, 0xA5, 0x1E          ; 00000F28  mov si,0x1ea5
  db 0xE8, 0x04, 0x01          ; 00000F2B  call 0x1032
  db 0x58                      ; 00000F2E  pop ax
  db 0xA8, 0x08                ; 00000F2F  test al,0x8
  db 0x74, 0x06                ; 00000F31  jz 0xf39
  db 0xBE, 0x0D, 0x1F          ; 00000F33  mov si,0x1f0d
  db 0xE8, 0xF9, 0x00          ; 00000F36  call 0x1032
  db 0xE9, 0xE9, 0xFE          ; 00000F39  jmp 0xe25
  db 0xE8, 0x65, 0x2F          ; 00000F3C  call 0x3ea4
  db 0x0B, 0xC9                ; 00000F3F  or cx,cx
  db 0x75, 0x01                ; 00000F41  jnz 0xf44
  db 0xC3                      ; 00000F43  ret
  db 0x51                      ; 00000F44  push cx
  db 0x8B, 0x7C, 0x0C          ; 00000F45  mov di,[si+0xc]
  db 0x57                      ; 00000F48  push di
  db 0x80, 0x7C, 0x02, 0x02    ; 00000F49  cmp byte [si+0x2],0x2
  db 0x74, 0x40                ; 00000F4D  jz 0xf8f
  db 0x80, 0x7C, 0x02, 0x0A    ; 00000F4F  cmp byte [si+0x2],0xa
  db 0x74, 0x3A                ; 00000F53  jz 0xf8f
  db 0xFE, 0x4C, 0x10          ; 00000F55  dec byte [si+0x10]
  db 0x74, 0x10                ; 00000F58  jz 0xf6a
  db 0xBF, 0x1F, 0x15          ; 00000F5A  mov di,0x151f
  db 0xBA, 0x03, 0x15          ; 00000F5D  mov dx,0x1503
  db 0x2E, 0xFF, 0x06, 0x43, 0x15 ; 00000F60  inc word [cs:0x1543]
  db 0xE8, 0xF5, 0x33          ; 00000F65  call 0x435d
  db 0xEB, 0x3A                ; 00000F68  jmp short 0xfa4
  db 0xC4, 0x7C, 0x15          ; 00000F6A  les di,[si+0x15]
  db 0xB1, 0x02                ; 00000F6D  mov cl,0x2
  db 0x26, 0xD2, 0x2D          ; 00000F6F  shr byte [es:di],cl
  db 0x26, 0xC6, 0x45, 0x01, 0x05 ; 00000F72  mov byte [es:di+0x1],0x5
  db 0x26, 0xC6, 0x45, 0x02, 0x01 ; 00000F77  mov byte [es:di+0x2],0x1
  db 0x56                      ; 00000F7C  push si
  db 0x8B, 0x34                ; 00000F7D  mov si,[si]
  db 0xE8, 0x4F, 0x05          ; 00000F7F  call 0x14d1
  db 0x5E                      ; 00000F82  pop si
  db 0xE8, 0xA4, 0x2F          ; 00000F83  call 0x3f2a
  db 0xC6, 0x44, 0x02, 0x08    ; 00000F86  mov byte [si+0x2],0x8
  db 0xE8, 0x3B, 0x00          ; 00000F8A  call 0xfc8
  db 0xEB, 0x15                ; 00000F8D  jmp short 0xfa4
  db 0xFE, 0x4C, 0x10          ; 00000F8F  dec byte [si+0x10]
  db 0x74, 0x0A                ; 00000F92  jz 0xf9e
  db 0x2E, 0xFF, 0x06, 0x43, 0x15 ; 00000F94  inc word [cs:0x1543]
  db 0xE8, 0xDB, 0x33          ; 00000F99  call 0x4377
  db 0xEB, 0x06                ; 00000F9C  jmp short 0xfa4
  db 0xE8, 0x89, 0x2F          ; 00000F9E  call 0x3f2a
  db 0xE8, 0x24, 0x00          ; 00000FA1  call 0xfc8
  db 0x5E                      ; 00000FA4  pop si
  db 0x59                      ; 00000FA5  pop cx
  db 0xE2, 0x9C                ; 00000FA6  loop 0xf44
  db 0xC3                      ; 00000FA8  ret
  db 0xE8, 0xDA, 0x2F          ; 00000FA9  call 0x3f86
  db 0x0B, 0xC9                ; 00000FAC  or cx,cx
  db 0x75, 0x01                ; 00000FAE  jnz 0xfb1
  db 0xC3                      ; 00000FB0  ret
  db 0x51                      ; 00000FB1  push cx
  db 0x8B, 0x7C, 0x07          ; 00000FB2  mov di,[si+0x7]
  db 0x57                      ; 00000FB5  push di
  db 0xE8, 0x0F, 0x00          ; 00000FB6  call 0xfc8
  db 0xC7, 0x44, 0x07, 0x00, 0x00 ; 00000FB9  mov word [si+0x7],0x0
  db 0xC7, 0x44, 0x09, 0x00, 0x00 ; 00000FBE  mov word [si+0x9],0x0
  db 0x5E                      ; 00000FC3  pop si
  db 0x59                      ; 00000FC4  pop cx
  db 0xE2, 0xEA                ; 00000FC5  loop 0xfb1
  db 0xC3                      ; 00000FC7  ret
  db 0x32, 0xFF                ; 00000FC8  xor bh,bh
  db 0x8A, 0x5C, 0x02          ; 00000FCA  mov bl,[si+0x2]
  db 0x2E, 0xFF, 0xA7, 0xD2, 0x0F ; 00000FCD  jmp [cs:bx+0xfd2]
  db 0x17                      ; 00000FD2  pop ss
  db 0x10, 0x17                ; 00000FD3  adc [bx],dl
  db 0x10, 0x17                ; 00000FD5  adc [bx],dl
  db 0x10, 0xF9                ; 00000FD7  adc cl,bh
  db 0x0F, 0x17, 0x10          ; 00000FD9  movhps qword [bx+si],xmm2
  db 0xDE, 0x0F                ; 00000FDC  fimul word [bx]
  db 0xC4, 0x7C, 0x1D          ; 00000FDE  les di,[si+0x1d]
  db 0xB1, 0x02                ; 00000FE1  mov cl,0x2
  db 0x26, 0xD2, 0x2D          ; 00000FE3  shr byte [es:di],cl
  db 0x26, 0xC6, 0x45, 0x01, 0x05 ; 00000FE6  mov byte [es:di+0x1],0x5
  db 0x26, 0xC6, 0x45, 0x02, 0x01 ; 00000FEB  mov byte [es:di+0x2],0x1
  db 0x56                      ; 00000FF0  push si
  db 0x8B, 0x34                ; 00000FF1  mov si,[si]
  db 0xE8, 0xDB, 0x04          ; 00000FF3  call 0x14d1
  db 0x5E                      ; 00000FF6  pop si
  db 0xEB, 0x1E                ; 00000FF7  jmp short 0x1017
  db 0x56                      ; 00000FF9  push si
  db 0xE8, 0x49, 0x2E          ; 00000FFA  call 0x3e46
  db 0x5E                      ; 00000FFD  pop si
  db 0xC4, 0x7C, 0x15          ; 00000FFE  les di,[si+0x15]
  db 0xB1, 0x02                ; 00001001  mov cl,0x2
  db 0x26, 0xD2, 0x2D          ; 00001003  shr byte [es:di],cl
  db 0x26, 0xC6, 0x45, 0x01, 0x05 ; 00001006  mov byte [es:di+0x1],0x5
  db 0x26, 0xC6, 0x45, 0x02, 0x01 ; 0000100B  mov byte [es:di+0x2],0x1
  db 0x56                      ; 00001010  push si
  db 0x8B, 0x34                ; 00001011  mov si,[si]
  db 0xE8, 0xBB, 0x04          ; 00001013  call 0x14d1
  db 0x5E                      ; 00001016  pop si
  db 0xC6, 0x44, 0x02, 0x08    ; 00001017  mov byte [si+0x2],0x8
  db 0xE8, 0x12, 0x34          ; 0000101B  call 0x4430
  db 0x88, 0x44, 0x04          ; 0000101E  mov [si+0x4],al
  db 0xC6, 0x44, 0x03, 0x00    ; 00001021  mov byte [si+0x3],0x0
  db 0x8B, 0xDE                ; 00001025  mov bx,si
  db 0x83, 0xC3, 0x03          ; 00001027  add bx,byte +0x3
  db 0x56                      ; 0000102A  push si
  db 0x8B, 0x34                ; 0000102B  mov si,[si]
  db 0xE8, 0xB4, 0x04          ; 0000102D  call 0x14e4
  db 0x5E                      ; 00001030  pop si
  db 0xC3                      ; 00001031  ret
  db 0xBA, 0x03, 0x15          ; 00001032  mov dx,0x1503
  db 0xBF, 0x1F, 0x15          ; 00001035  mov di,0x151f
  db 0xE8, 0xD6, 0x32          ; 00001038  call 0x4311
  db 0xC3                      ; 0000103B  ret
  db 0x51                      ; 0000103C  push cx
  db 0x8B, 0x77, 0x04          ; 0000103D  mov si,[bx+0x4]
  db 0x56                      ; 00001040  push si
  db 0x8B, 0x77, 0x06          ; 00001041  mov si,[bx+0x6]
  db 0xF7, 0x04, 0x00, 0x80    ; 00001044  test word [si],0x8000
  db 0x75, 0x05                ; 00001048  jnz 0x104f
  db 0xE8, 0xD8, 0x03          ; 0000104A  call 0x1425
  db 0xEB, 0x3F                ; 0000104D  jmp short 0x108e
  db 0x8B, 0x7C, 0x04          ; 0000104F  mov di,[si+0x4]
  db 0x8B, 0x44, 0x06          ; 00001052  mov ax,[si+0x6]
  db 0x57                      ; 00001055  push di
  db 0xB9, 0x04, 0x00          ; 00001056  mov cx,0x4
  db 0xF8                      ; 00001059  clc
  db 0xD1, 0xD8                ; 0000105A  rcr ax,1
  db 0xD1, 0xDF                ; 0000105C  rcr di,1
  db 0xE2, 0xF9                ; 0000105E  loop 0x1059
  db 0x8E, 0xC7                ; 00001060  mov es,di
  db 0x5F                      ; 00001062  pop di
  db 0x81, 0xE7, 0x0F, 0x00    ; 00001063  and di,0xf
  db 0x26, 0x80, 0x7D, 0x02, 0x03 ; 00001067  cmp byte [es:di+0x2],0x3
  db 0x75, 0x05                ; 0000106C  jnz 0x1073
  db 0xE8, 0x22, 0x00          ; 0000106E  call 0x1093
  db 0xEB, 0x1B                ; 00001071  jmp short 0x108e
  db 0x26, 0x80, 0x7D, 0x02, 0xF3 ; 00001073  cmp byte [es:di+0x2],0xf3
  db 0x75, 0x05                ; 00001078  jnz 0x107f
  db 0xE8, 0xA8, 0x02          ; 0000107A  call 0x1325
  db 0xEB, 0x0F                ; 0000107D  jmp short 0x108e
  db 0x26, 0x80, 0x7D, 0x02, 0xBF ; 0000107F  cmp byte [es:di+0x2],0xbf
  db 0x75, 0x05                ; 00001084  jnz 0x108b
  db 0xE8, 0x4D, 0x03          ; 00001086  call 0x13d6
  db 0xEB, 0x03                ; 00001089  jmp short 0x108e
  db 0xE8, 0x97, 0x03          ; 0000108B  call 0x1425
  db 0x5B                      ; 0000108E  pop bx
  db 0x59                      ; 0000108F  pop cx
  db 0xE2, 0xAA                ; 00001090  loop 0x103c
  db 0xC3                      ; 00001092  ret
  db 0x26, 0x8A, 0x05          ; 00001093  mov al,[es:di]
  db 0xE8, 0x34, 0x32          ; 00001096  call 0x42cd
  db 0x73, 0x06                ; 00001099  jnc 0x10a1
  db 0xE8, 0x87, 0x03          ; 0000109B  call 0x1425
  db 0xE9, 0x27, 0x00          ; 0000109E  jmp 0x10c8
  db 0x8B, 0x47, 0x14          ; 000010A1  mov ax,[bx+0x14]
  db 0x86, 0xC4                ; 000010A4  xchg al,ah
  db 0x89, 0x47, 0x02          ; 000010A6  mov [bx+0x2],ax
  db 0x89, 0x7F, 0x08          ; 000010A9  mov [bx+0x8],di
  db 0x8C, 0x47, 0x0A          ; 000010AC  mov [bx+0xa],es
  db 0x80, 0x7C, 0x01, 0x00    ; 000010AF  cmp byte [si+0x1],0x0
  db 0x74, 0x14                ; 000010B3  jz 0x10c9
  db 0x2E, 0x80, 0x3E, 0x34, 0x15, 0xFF ; 000010B5  cmp byte [cs:0x1534],0xff
  db 0x75, 0x05                ; 000010BB  jnz 0x10c2
  db 0xE8, 0x65, 0x03          ; 000010BD  call 0x1425
  db 0xEB, 0x06                ; 000010C0  jmp short 0x10c8
  db 0xC6, 0x07, 0x02          ; 000010C2  mov byte [bx],0x2
  db 0xE8, 0x1C, 0x04          ; 000010C5  call 0x14e4
  db 0xC3                      ; 000010C8  ret
  db 0x53                      ; 000010C9  push bx
  db 0x32, 0xFF                ; 000010CA  xor bh,bh
  db 0x26, 0x8A, 0x5D, 0x03    ; 000010CC  mov bl,[es:di+0x3]
  db 0x80, 0xFB, 0x04          ; 000010D0  cmp bl,0x4
  db 0x7E, 0x03                ; 000010D3  jng 0x10d8
  db 0xE9, 0x11, 0x00          ; 000010D5  jmp 0x10e9
  db 0xD1, 0xE3                ; 000010D8  shl bx,1
  db 0x2E, 0xFF, 0xA7, 0xDF, 0x10 ; 000010DA  jmp [cs:bx+0x10df]
  db 0xED                      ; 000010DF  in ax,dx
  db 0x10, 0x8B, 0x11, 0xF4    ; 000010E0  adc [bp+di-0xbef],cl
  db 0x11, 0x70, 0x12          ; 000010E4  adc [bx+si+0x12],si
  db 0xCF                      ; 000010E7  iret
  db 0x12, 0xE8                ; 000010E8  adc ch,al
  db 0x39, 0x03                ; 000010EA  cmp [bp+di],ax
  db 0xC3                      ; 000010EC  ret
  db 0x8B, 0x44, 0x11          ; 000010ED  mov ax,[si+0x11]
  db 0x26, 0x23, 0x45, 0x06    ; 000010F0  and ax,[es:di+0x6]
  db 0x75, 0x03                ; 000010F4  jnz 0x10f9
  db 0xE9, 0x8D, 0x00          ; 000010F6  jmp 0x1186
  db 0x5B                      ; 000010F9  pop bx
  db 0x57                      ; 000010FA  push di
  db 0x06                      ; 000010FB  push es
  db 0xE8, 0x30, 0x03          ; 000010FC  call 0x142f
  db 0x07                      ; 000010FF  pop es
  db 0x5F                      ; 00001100  pop di
  db 0x72, 0x04                ; 00001101  jc 0x1107
  db 0x53                      ; 00001103  push bx
  db 0xE9, 0x7F, 0x00          ; 00001104  jmp 0x1186
  db 0xC6, 0x07, 0x03          ; 00001107  mov byte [bx],0x3
  db 0x88, 0x47, 0x01          ; 0000110A  mov [bx+0x1],al
  db 0x53                      ; 0000110D  push bx
  db 0x32, 0xFF                ; 0000110E  xor bh,bh
  db 0x8A, 0x5C, 0x02          ; 00001110  mov bl,[si+0x2]
  db 0x2E, 0xFF, 0xA7, 0x18, 0x11 ; 00001113  jmp [cs:bx+0x1118]
  db 0x43                      ; 00001118  inc bx
  db 0x11, 0x24                ; 00001119  adc [si],sp
  db 0x11, 0x24                ; 0000111B  adc [si],sp
  db 0x11, 0x24                ; 0000111D  adc [si],sp
  db 0x11, 0x86, 0x11, 0x24    ; 0000111F  adc [bp+0x2411],ax
  db 0x11, 0xE8                ; 00001123  adc ax,bp
  db 0x03, 0x2E, 0x26, 0x8A    ; 00001125  add bp,[0x8a26]
  db 0x45                      ; 00001129  inc bp
  db 0x05, 0x0A, 0xC0          ; 0000112A  add ax,0xc00a
  db 0x75, 0x03                ; 0000112D  jnz 0x1132
  db 0xE9, 0x42, 0x00          ; 0000112F  jmp 0x1174
  db 0x3A, 0x44, 0x03          ; 00001132  cmp al,[si+0x3]
  db 0x73, 0x03                ; 00001135  jnc 0x113a
  db 0xE9, 0x3A, 0x00          ; 00001137  jmp 0x1174
  db 0x88, 0x44, 0x03          ; 0000113A  mov [si+0x3],al
  db 0xE8, 0x99, 0x2D          ; 0000113D  call 0x3ed9
  db 0xE9, 0x43, 0x00          ; 00001140  jmp 0x1186
  db 0x2E, 0x80, 0x3E, 0x34, 0x15, 0xFF ; 00001143  cmp byte [cs:0x1534],0xff
  db 0x74, 0x3B                ; 00001149  jz 0x1186
  db 0x5B                      ; 0000114B  pop bx
  db 0x56                      ; 0000114C  push si
  db 0x8B, 0x34                ; 0000114D  mov si,[si]
  db 0xE8, 0x92, 0x03          ; 0000114F  call 0x14e4
  db 0x5E                      ; 00001152  pop si
  db 0xC6, 0x44, 0x02, 0x02    ; 00001153  mov byte [si+0x2],0x2
  db 0xC6, 0x44, 0x10, 0x05    ; 00001157  mov byte [si+0x10],0x5
  db 0x8B, 0x1C                ; 0000115B  mov bx,[si]
  db 0x8B, 0x47, 0x09          ; 0000115D  mov ax,[bx+0x9]
  db 0x89, 0x44, 0x13          ; 00001160  mov [si+0x13],ax
  db 0x83, 0xC3, 0x39          ; 00001163  add bx,byte +0x39
  db 0x89, 0x5C, 0x15          ; 00001166  mov [si+0x15],bx
  db 0x8C, 0x5C, 0x17          ; 00001169  mov [si+0x17],ds
  db 0xE8, 0x08, 0x32          ; 0000116C  call 0x4377
  db 0xE8, 0x67, 0x2D          ; 0000116F  call 0x3ed9
  db 0xEB, 0x16                ; 00001172  jmp short 0x118a
  db 0x80, 0x7C, 0x02, 0x02    ; 00001174  cmp byte [si+0x2],0x2
  db 0x74, 0x06                ; 00001178  jz 0x1180
  db 0x80, 0x7C, 0x02, 0x0A    ; 0000117A  cmp byte [si+0x2],0xa
  db 0x75, 0x03                ; 0000117E  jnz 0x1183
  db 0xE8, 0xC3, 0x2C          ; 00001180  call 0x3e46
  db 0xE8, 0x42, 0xFE          ; 00001183  call 0xfc8
  db 0x5B                      ; 00001186  pop bx
  db 0xE8, 0x9B, 0x02          ; 00001187  call 0x1425
  db 0xC3                      ; 0000118A  ret
  db 0x5B                      ; 0000118B  pop bx
  db 0x57                      ; 0000118C  push di
  db 0x06                      ; 0000118D  push es
  db 0xE8, 0x9E, 0x02          ; 0000118E  call 0x142f
  db 0x07                      ; 00001191  pop es
  db 0x5F                      ; 00001192  pop di
  db 0x72, 0x04                ; 00001193  jc 0x1199
  db 0x53                      ; 00001195  push bx
  db 0xE9, 0x56, 0x00          ; 00001196  jmp 0x11ef
  db 0xC6, 0x07, 0x03          ; 00001199  mov byte [bx],0x3
  db 0x88, 0x47, 0x01          ; 0000119C  mov [bx+0x1],al
  db 0x53                      ; 0000119F  push bx
  db 0x32, 0xFF                ; 000011A0  xor bh,bh
  db 0x8A, 0x5C, 0x02          ; 000011A2  mov bl,[si+0x2]
  db 0x2E, 0xFF, 0xA7, 0xAA, 0x11 ; 000011A5  jmp [cs:bx+0x11aa]
  db 0xB6, 0x11                ; 000011AA  mov dh,0x11
  db 0xE0, 0x11                ; 000011AC  loopne 0x11bf
  db 0xE9, 0x11, 0xE9          ; 000011AE  jmp 0xfac2
  db 0x11, 0xEF                ; 000011B1  adc di,bp
  db 0x11, 0xE0                ; 000011B3  adc ax,sp
  db 0x11, 0x2E, 0x80, 0x3E    ; 000011B5  adc [0x3e80],bp
  db 0x34, 0x15                ; 000011B9  xor al,0x15
  db 0xFF, 0x74, 0x31          ; 000011BB  push word [si+0x31]
  db 0x26, 0x8A, 0x65, 0x05    ; 000011BE  mov ah,[es:di+0x5]
  db 0x88, 0x64, 0x03          ; 000011C2  mov [si+0x3],ah
  db 0x26, 0x8A, 0x65, 0x04    ; 000011C5  mov ah,[es:di+0x4]
  db 0x88, 0x64, 0x04          ; 000011C9  mov [si+0x4],ah
  db 0xC6, 0x44, 0x02, 0x04    ; 000011CC  mov byte [si+0x2],0x4
  db 0x5B                      ; 000011D0  pop bx
  db 0xE8, 0xCF, 0x31          ; 000011D1  call 0x43a3
  db 0x56                      ; 000011D4  push si
  db 0x8B, 0x34                ; 000011D5  mov si,[si]
  db 0xE8, 0x0A, 0x03          ; 000011D7  call 0x14e4
  db 0x5E                      ; 000011DA  pop si
  db 0xE8, 0xFB, 0x2C          ; 000011DB  call 0x3ed9
  db 0xEB, 0x13                ; 000011DE  jmp short 0x11f3
  db 0x26, 0x8A, 0x65, 0x04    ; 000011E0  mov ah,[es:di+0x4]
  db 0xE8, 0xBC, 0x31          ; 000011E4  call 0x43a3
  db 0xEB, 0x06                ; 000011E7  jmp short 0x11ef
  db 0xE8, 0x3E, 0x2D          ; 000011E9  call 0x3f2a
  db 0xE8, 0xD9, 0xFD          ; 000011EC  call 0xfc8
  db 0x5B                      ; 000011EF  pop bx
  db 0xE8, 0x32, 0x02          ; 000011F0  call 0x1425
  db 0xC3                      ; 000011F3  ret
  db 0x26, 0x8A, 0x45, 0x05    ; 000011F4  mov al,[es:di+0x5]
  db 0xE8, 0xEC, 0x30          ; 000011F8  call 0x42e7
  db 0x72, 0x54                ; 000011FB  jc 0x1251
  db 0x26, 0x8A, 0x45, 0x04    ; 000011FD  mov al,[es:di+0x4]
  db 0x88, 0x44, 0x04          ; 00001201  mov [si+0x4],al
  db 0x32, 0xFF                ; 00001204  xor bh,bh
  db 0x8A, 0x5C, 0x02          ; 00001206  mov bl,[si+0x2]
  db 0x2E, 0xFF, 0xA7, 0x0E, 0x12 ; 00001209  jmp [cs:bx+0x120e]
  db 0x51                      ; 0000120E  push cx
  db 0x12, 0x47, 0x12          ; 0000120F  adc al,[bx+0x12]
  db 0x51                      ; 00001212  push cx
  db 0x12, 0x51, 0x12          ; 00001213  adc dl,[bx+di+0x12]
  db 0x51                      ; 00001216  push cx
  db 0x12, 0x1A                ; 00001217  adc bl,[bp+si]
  db 0x12, 0xE8                ; 00001219  adc ch,al
  db 0x39, 0x00                ; 0000121B  cmp [bx+si],ax
  db 0xE8, 0x26, 0x2C          ; 0000121D  call 0x3e46
  db 0x56                      ; 00001220  push si
  db 0x2E, 0x8E, 0x06, 0x43, 0x42 ; 00001221  mov es,[cs:0x4243]
  db 0x8B, 0xFE                ; 00001226  mov di,si
  db 0x83, 0xC6, 0x1B          ; 00001228  add si,byte +0x1b
  db 0x83, 0xC7, 0x13          ; 0000122B  add di,byte +0x13
  db 0xB9, 0x03, 0x00          ; 0000122E  mov cx,0x3
  db 0xF3, 0xA5                ; 00001231  rep movsw
  db 0x5E                      ; 00001233  pop si
  db 0xC6, 0x44, 0x10, 0x05    ; 00001234  mov byte [si+0x10],0x5
  db 0xC6, 0x44, 0x02, 0x06    ; 00001238  mov byte [si+0x2],0x6
  db 0xBF, 0x1F, 0x15          ; 0000123C  mov di,0x151f
  db 0xBA, 0x03, 0x15          ; 0000123F  mov dx,0x1503
  db 0xE8, 0x18, 0x31          ; 00001242  call 0x435d
  db 0xEB, 0x0A                ; 00001245  jmp short 0x1251
  db 0xE8, 0x0C, 0x00          ; 00001247  call 0x1256
  db 0xE8, 0xF9, 0x2B          ; 0000124A  call 0x3e46
  db 0xC6, 0x44, 0x02, 0x04    ; 0000124D  mov byte [si+0x2],0x4
  db 0x5B                      ; 00001251  pop bx
  db 0xE8, 0xD0, 0x01          ; 00001252  call 0x1425
  db 0xC3                      ; 00001255  ret
  db 0x9C                      ; 00001256  pushf
  db 0xFA                      ; 00001257  cli
  db 0x80, 0x7C, 0x21, 0x02    ; 00001258  cmp byte [si+0x21],0x2
  db 0x74, 0x06                ; 0000125C  jz 0x1264
  db 0xC6, 0x44, 0x21, 0x00    ; 0000125E  mov byte [si+0x21],0x0
  db 0x9D                      ; 00001262  popf
  db 0xC3                      ; 00001263  ret
  db 0x9D                      ; 00001264  popf
  db 0x60                      ; 00001265  pusha
  db 0xB1, 0x8D                ; 00001266  mov cl,0x8d
  db 0xBA, 0x00, 0x00          ; 00001268  mov dx,0x0
  db 0xCD, 0xE0                ; 0000126B  int 0xe0
  db 0x61                      ; 0000126D  popa
  db 0xEB, 0xE6                ; 0000126E  jmp short 0x1256
  db 0x2E, 0x80, 0x3E, 0x34, 0x15, 0xFF ; 00001270  cmp byte [cs:0x1534],0xff
  db 0x74, 0x52                ; 00001276  jz 0x12ca
  db 0x5B                      ; 00001278  pop bx
  db 0xC6, 0x07, 0x04          ; 00001279  mov byte [bx],0x4
  db 0x26, 0x8A, 0x45, 0x05    ; 0000127C  mov al,[es:di+0x5]
  db 0x88, 0x47, 0x01          ; 00001280  mov [bx+0x1],al
  db 0x53                      ; 00001283  push bx
  db 0xE8, 0x60, 0x30          ; 00001284  call 0x42e7
  db 0x72, 0x41                ; 00001287  jc 0x12ca
  db 0x8A, 0x5C, 0x02          ; 00001289  mov bl,[si+0x2]
  db 0x32, 0xFF                ; 0000128C  xor bh,bh
  db 0x2E, 0xFF, 0xA7, 0x93, 0x12 ; 0000128E  jmp [cs:bx+0x1293]
  db 0xCA, 0x12, 0xCA          ; 00001293  retf 0xca12
  db 0x12, 0x9F, 0x12, 0x9F    ; 00001296  adc bl,[bx-0x60ee]
  db 0x12, 0xCA                ; 0000129A  adc cl,dl
  db 0x12, 0xCA                ; 0000129C  adc cl,dl
  db 0x12, 0x8A, 0x44, 0x12    ; 0000129E  adc cl,[bp+si+0x1244]
  db 0x26, 0x8A, 0x65, 0x04    ; 000012A2  mov ah,[es:di+0x4]
  db 0x3A, 0xC4                ; 000012A6  cmp al,ah
  db 0x75, 0x1B                ; 000012A8  jnz 0x12c5
  db 0x80, 0x7C, 0x12, 0x00    ; 000012AA  cmp byte [si+0x12],0x0
  db 0x74, 0x05                ; 000012AE  jz 0x12b5
  db 0xFE, 0x4C, 0x12          ; 000012B0  dec byte [si+0x12]
  db 0xEB, 0x03                ; 000012B3  jmp short 0x12b8
  db 0xFE, 0x44, 0x12          ; 000012B5  inc byte [si+0x12]
  db 0x5B                      ; 000012B8  pop bx
  db 0xE8, 0xFB, 0x30          ; 000012B9  call 0x43b7
  db 0x56                      ; 000012BC  push si
  db 0x8B, 0x34                ; 000012BD  mov si,[si]
  db 0xE8, 0x22, 0x02          ; 000012BF  call 0x14e4
  db 0x5E                      ; 000012C2  pop si
  db 0xEB, 0x09                ; 000012C3  jmp short 0x12ce
  db 0x5B                      ; 000012C5  pop bx
  db 0x53                      ; 000012C6  push bx
  db 0xE8, 0xED, 0x30          ; 000012C7  call 0x43b7
  db 0x5B                      ; 000012CA  pop bx
  db 0xE8, 0x57, 0x01          ; 000012CB  call 0x1425
  db 0xC3                      ; 000012CE  ret
  db 0x26, 0x8A, 0x45, 0x05    ; 000012CF  mov al,[es:di+0x5]
  db 0xE8, 0x11, 0x30          ; 000012D3  call 0x42e7
  db 0x72, 0x48                ; 000012D6  jc 0x1320
  db 0x8A, 0x44, 0x11          ; 000012D8  mov al,[si+0x11]
  db 0x26, 0x32, 0x45, 0x04    ; 000012DB  xor al,[es:di+0x4]
  db 0x74, 0x3F                ; 000012DF  jz 0x1320
  db 0x80, 0x7C, 0x02, 0x06    ; 000012E1  cmp byte [si+0x2],0x6
  db 0x75, 0x39                ; 000012E5  jnz 0x1320
  db 0x9C                      ; 000012E7  pushf
  db 0xFA                      ; 000012E8  cli
  db 0x80, 0x7C, 0x21, 0x02    ; 000012E9  cmp byte [si+0x21],0x2
  db 0x74, 0x07                ; 000012ED  jz 0x12f6
  db 0xC6, 0x44, 0x21, 0x00    ; 000012EF  mov byte [si+0x21],0x0
  db 0x9D                      ; 000012F3  popf
  db 0xEB, 0x0C                ; 000012F4  jmp short 0x1302
  db 0x9D                      ; 000012F6  popf
  db 0x60                      ; 000012F7  pusha
  db 0xB1, 0x8D                ; 000012F8  mov cl,0x8d
  db 0xBA, 0x00, 0x00          ; 000012FA  mov dx,0x0
  db 0xCD, 0xE0                ; 000012FD  int 0xe0
  db 0x61                      ; 000012FF  popa
  db 0xEB, 0xE5                ; 00001300  jmp short 0x12e7
  db 0xE8, 0x41, 0x2B          ; 00001302  call 0x3e46
  db 0xC4, 0x7C, 0x15          ; 00001305  les di,[si+0x15]
  db 0xB1, 0x02                ; 00001308  mov cl,0x2
  db 0x26, 0xD2, 0x2D          ; 0000130A  shr byte [es:di],cl
  db 0x26, 0xC6, 0x45, 0x01, 0x05 ; 0000130D  mov byte [es:di+0x1],0x5
  db 0x26, 0xC6, 0x45, 0x02, 0x00 ; 00001312  mov byte [es:di+0x2],0x0
  db 0xC6, 0x44, 0x02, 0x04    ; 00001317  mov byte [si+0x2],0x4
  db 0x8B, 0x34                ; 0000131B  mov si,[si]
  db 0xE8, 0xB1, 0x01          ; 0000131D  call 0x14d1
  db 0x5B                      ; 00001320  pop bx
  db 0xE8, 0x01, 0x01          ; 00001321  call 0x1425
  db 0xC3                      ; 00001324  ret
  db 0x26, 0xF6, 0x45, 0x01, 0x01 ; 00001325  test byte [es:di+0x1],0x1
  db 0x74, 0x03                ; 0000132A  jz 0x132f
  db 0xE9, 0x7D, 0x00          ; 0000132C  jmp 0x13ac
  db 0x26, 0x8A, 0x25          ; 0000132F  mov ah,[es:di]
  db 0x80, 0xFC, 0x00          ; 00001332  cmp ah,0x0
  db 0x74, 0x14                ; 00001335  jz 0x134b
  db 0x2E, 0x3A, 0x26, 0xA5, 0x1E ; 00001337  cmp ah,[cs:0x1ea5]
  db 0x74, 0x0D                ; 0000133C  jz 0x134b
  db 0x2E, 0x3A, 0x26, 0x0D, 0x1F ; 0000133E  cmp ah,[cs:0x1f0d]
  db 0x74, 0x06                ; 00001343  jz 0x134b
  db 0xE8, 0xDD, 0x00          ; 00001345  call 0x1425
  db 0xE9, 0x8A, 0x00          ; 00001348  jmp 0x13d5
  db 0x80, 0xCC, 0x01          ; 0000134B  or ah,0x1
  db 0x26, 0x8A, 0x45, 0x01    ; 0000134E  mov al,[es:di+0x1]
  db 0x26, 0x88, 0x05          ; 00001352  mov [es:di],al
  db 0x26, 0x88, 0x65, 0x01    ; 00001355  mov [es:di+0x1],ah
  db 0x06                      ; 00001359  push es
  db 0x57                      ; 0000135A  push di
  db 0x2E, 0x8E, 0x06, 0x43, 0x42 ; 0000135B  mov es,[cs:0x4243]
  db 0xBF, 0x1F, 0x15          ; 00001360  mov di,0x151f
  db 0x2E, 0x80, 0x3E, 0x34, 0x15, 0xFF ; 00001363  cmp byte [cs:0x1534],0xff
  db 0x74, 0x04                ; 00001369  jz 0x136f
  db 0xB0, 0x03                ; 0000136B  mov al,0x3
  db 0xEB, 0x02                ; 0000136D  jmp short 0x1371
  db 0xB0, 0x02                ; 0000136F  mov al,0x2
  db 0xAA                      ; 00001371  stosb
  db 0x8B, 0xF3                ; 00001372  mov si,bx
  db 0x83, 0xC6, 0x0E          ; 00001374  add si,byte +0xe
  db 0xB9, 0x03, 0x00          ; 00001377  mov cx,0x3
  db 0xF3, 0xA5                ; 0000137A  rep movsw
  db 0x2E, 0x80, 0x3E, 0x34, 0x15, 0xFF ; 0000137C  cmp byte [cs:0x1534],0xff
  db 0x74, 0x12                ; 00001382  jz 0x1396
  db 0x8B, 0x47, 0x14          ; 00001384  mov ax,[bx+0x14]
  db 0x86, 0xC4                ; 00001387  xchg al,ah
  db 0xAB                      ; 00001389  stosw
  db 0x58                      ; 0000138A  pop ax
  db 0xAB                      ; 0000138B  stosw
  db 0x58                      ; 0000138C  pop ax
  db 0xAB                      ; 0000138D  stosw
  db 0x8B, 0xC3                ; 0000138E  mov ax,bx
  db 0xAB                      ; 00001390  stosw
  db 0xC6, 0x07, 0xFF          ; 00001391  mov byte [bx],0xff
  db 0xEB, 0x0E                ; 00001394  jmp short 0x13a4
  db 0x8C, 0xD8                ; 00001396  mov ax,ds
  db 0x5E                      ; 00001398  pop si
  db 0x1F                      ; 00001399  pop ds
  db 0x50                      ; 0000139A  push ax
  db 0xB9, 0x03, 0x00          ; 0000139B  mov cx,0x3
  db 0xF3, 0xA4                ; 0000139E  rep movsb
  db 0x1F                      ; 000013A0  pop ds
  db 0xE8, 0x81, 0x00          ; 000013A1  call 0x1425
  db 0xBA, 0x03, 0x15          ; 000013A4  mov dx,0x1503
  db 0xB1, 0x8B                ; 000013A7  mov cl,0x8b
  db 0xCD, 0xE0                ; 000013A9  int 0xe0
  db 0xC3                      ; 000013AB  ret
  db 0x2E, 0x80, 0x3E, 0x34, 0x15, 0xFF ; 000013AC  cmp byte [cs:0x1534],0xff
  db 0x74, 0x1E                ; 000013B2  jz 0x13d2
  db 0x26, 0x8A, 0x05          ; 000013B4  mov al,[es:di]
  db 0xE8, 0x13, 0x2F          ; 000013B7  call 0x42cd
  db 0x72, 0x16                ; 000013BA  jc 0x13d2
  db 0xC6, 0x07, 0x01          ; 000013BC  mov byte [bx],0x1
  db 0x8B, 0x47, 0x14          ; 000013BF  mov ax,[bx+0x14]
  db 0x86, 0xC4                ; 000013C2  xchg al,ah
  db 0x89, 0x47, 0x02          ; 000013C4  mov [bx+0x2],ax
  db 0x89, 0x7F, 0x08          ; 000013C7  mov [bx+0x8],di
  db 0x8C, 0x47, 0x0A          ; 000013CA  mov [bx+0xa],es
  db 0xE8, 0x14, 0x01          ; 000013CD  call 0x14e4
  db 0xEB, 0x03                ; 000013D0  jmp short 0x13d5
  db 0xE8, 0x50, 0x00          ; 000013D2  call 0x1425
  db 0xC3                      ; 000013D5  ret
  db 0x26, 0xF6, 0x45, 0x01, 0x01 ; 000013D6  test byte [es:di+0x1],0x1
  db 0x74, 0x02                ; 000013DB  jz 0x13df
  db 0xEB, 0x42                ; 000013DD  jmp short 0x1421
  db 0xB0, 0x00                ; 000013DF  mov al,0x0
  db 0x3C, 0x00                ; 000013E1  cmp al,0x0
  db 0x74, 0x10                ; 000013E3  jz 0x13f5
  db 0x2E, 0x3A, 0x06, 0xA5, 0x1E ; 000013E5  cmp al,[cs:0x1ea5]
  db 0x74, 0x09                ; 000013EA  jz 0x13f5
  db 0x2E, 0x3A, 0x06, 0x0D, 0x1F ; 000013EC  cmp al,[cs:0x1f0d]
  db 0x74, 0x02                ; 000013F1  jz 0x13f5
  db 0xEB, 0x2C                ; 000013F3  jmp short 0x1421
  db 0xBE, 0x1F, 0x15          ; 000013F5  mov si,0x151f
  db 0x0C, 0x01                ; 000013F8  or al,0x1
  db 0x88, 0x44, 0x02          ; 000013FA  mov [si+0x2],al
  db 0xB0, 0x01                ; 000013FD  mov al,0x1
  db 0x88, 0x44, 0x01          ; 000013FF  mov [si+0x1],al
  db 0x26, 0x8A, 0x45, 0x02    ; 00001402  mov al,[es:di+0x2]
  db 0x88, 0x44, 0x03          ; 00001406  mov [si+0x3],al
  db 0xC6, 0x44, 0x04, 0x81    ; 00001409  mov byte [si+0x4],0x81
  db 0xC6, 0x44, 0x05, 0x00    ; 0000140D  mov byte [si+0x5],0x0
  db 0xC6, 0x44, 0x06, 0x00    ; 00001411  mov byte [si+0x6],0x0
  db 0xC6, 0x04, 0x02          ; 00001415  mov byte [si],0x2
  db 0x53                      ; 00001418  push bx
  db 0xBA, 0x03, 0x15          ; 00001419  mov dx,0x1503
  db 0xB1, 0x8B                ; 0000141C  mov cl,0x8b
  db 0xCD, 0xE0                ; 0000141E  int 0xe0
  db 0x5B                      ; 00001420  pop bx
  db 0xE8, 0x01, 0x00          ; 00001421  call 0x1425
  db 0xC3                      ; 00001424  ret
  db 0x1E                      ; 00001425  push ds
  db 0x53                      ; 00001426  push bx
  db 0xC6, 0x07, 0xFF          ; 00001427  mov byte [bx],0xff
  db 0xCD, 0x29                ; 0000142A  int 0x29
  db 0x5B                      ; 0000142C  pop bx
  db 0x1F                      ; 0000142D  pop ds
  db 0xC3                      ; 0000142E  ret
  db 0x2E, 0x8E, 0x06, 0x43, 0x42 ; 0000142F  mov es,[cs:0x4243]
  db 0x56                      ; 00001434  push si
  db 0x8B, 0xFB                ; 00001435  mov di,bx
  db 0x83, 0xC7, 0x0E          ; 00001437  add di,byte +0xe
  db 0xBE, 0x45, 0x15          ; 0000143A  mov si,0x1545
  db 0xB9, 0x20, 0x00          ; 0000143D  mov cx,0x20
  db 0x32, 0xC0                ; 00001440  xor al,al
  db 0x80, 0x3C, 0x00          ; 00001442  cmp byte [si],0x0
  db 0x74, 0x0E                ; 00001445  jz 0x1455
  db 0x51                      ; 00001447  push cx
  db 0x57                      ; 00001448  push di
  db 0x56                      ; 00001449  push si
  db 0x46                      ; 0000144A  inc si
  db 0xB9, 0x03, 0x00          ; 0000144B  mov cx,0x3
  db 0xF3, 0xA7                ; 0000144E  repe cmpsw
  db 0x5E                      ; 00001450  pop si
  db 0x5F                      ; 00001451  pop di
  db 0x59                      ; 00001452  pop cx
  db 0x74, 0x0A                ; 00001453  jz 0x145f
  db 0x83, 0xC6, 0x4B          ; 00001455  add si,byte +0x4b
  db 0xFE, 0xC0                ; 00001458  inc al
  db 0xE2, 0xE6                ; 0000145A  loop 0x1442
  db 0xE9, 0x3D, 0x00          ; 0000145C  jmp 0x149c
  db 0x5F                      ; 0000145F  pop di
  db 0x39, 0x7C, 0x07          ; 00001460  cmp [si+0x7],di
  db 0x75, 0x05                ; 00001463  jnz 0x146a
  db 0x83, 0xC6, 0x07          ; 00001465  add si,byte +0x7
  db 0xEB, 0x30                ; 00001468  jmp short 0x149a
  db 0x39, 0x7C, 0x29          ; 0000146A  cmp [si+0x29],di
  db 0x75, 0x05                ; 0000146D  jnz 0x1474
  db 0x83, 0xC6, 0x29          ; 0000146F  add si,byte +0x29
  db 0xEB, 0x26                ; 00001472  jmp short 0x149a
  db 0x83, 0x7C, 0x07, 0x00    ; 00001474  cmp word [si+0x7],byte +0x0
  db 0x75, 0x0C                ; 00001478  jnz 0x1486
  db 0x8B, 0xD6                ; 0000147A  mov dx,si
  db 0x83, 0xC6, 0x07          ; 0000147C  add si,byte +0x7
  db 0x89, 0x54, 0x19          ; 0000147F  mov [si+0x19],dx
  db 0x89, 0x3C                ; 00001482  mov [si],di
  db 0xEB, 0x14                ; 00001484  jmp short 0x149a
  db 0x83, 0x7C, 0x29, 0x00    ; 00001486  cmp word [si+0x29],byte +0x0
  db 0x75, 0x0C                ; 0000148A  jnz 0x1498
  db 0x8B, 0xD6                ; 0000148C  mov dx,si
  db 0x83, 0xC6, 0x29          ; 0000148E  add si,byte +0x29
  db 0x89, 0x54, 0x19          ; 00001491  mov [si+0x19],dx
  db 0x89, 0x3C                ; 00001494  mov [si],di
  db 0xEB, 0x02                ; 00001496  jmp short 0x149a
  db 0xF8                      ; 00001498  clc
  db 0xC3                      ; 00001499  ret
  db 0xF9                      ; 0000149A  stc
  db 0xC3                      ; 0000149B  ret
  db 0xB9, 0x20, 0x00          ; 0000149C  mov cx,0x20
  db 0xBE, 0x45, 0x15          ; 0000149F  mov si,0x1545
  db 0x32, 0xD2                ; 000014A2  xor dl,dl
  db 0x80, 0x3C, 0x00          ; 000014A4  cmp byte [si],0x0
  db 0x74, 0x0B                ; 000014A7  jz 0x14b4
  db 0x83, 0xC6, 0x4B          ; 000014A9  add si,byte +0x4b
  db 0xFE, 0xC2                ; 000014AC  inc dl
  db 0xE2, 0xF4                ; 000014AE  loop 0x14a4
  db 0x5E                      ; 000014B0  pop si
  db 0xF8                      ; 000014B1  clc
  db 0xEB, 0x1C                ; 000014B2  jmp short 0x14d0
  db 0x56                      ; 000014B4  push si
  db 0x8B, 0xFE                ; 000014B5  mov di,si
  db 0xB0, 0xFF                ; 000014B7  mov al,0xff
  db 0xAA                      ; 000014B9  stosb
  db 0x8B, 0xF3                ; 000014BA  mov si,bx
  db 0x83, 0xC6, 0x0E          ; 000014BC  add si,byte +0xe
  db 0xB9, 0x03, 0x00          ; 000014BF  mov cx,0x3
  db 0xF3, 0xA5                ; 000014C2  rep movsw
  db 0x5E                      ; 000014C4  pop si
  db 0x89, 0x75, 0x19          ; 000014C5  mov [di+0x19],si
  db 0x5E                      ; 000014C8  pop si
  db 0x89, 0x35                ; 000014C9  mov [di],si
  db 0x8B, 0xF7                ; 000014CB  mov si,di
  db 0x8A, 0xC2                ; 000014CD  mov al,dl
  db 0xF9                      ; 000014CF  stc
  db 0xC3                      ; 000014D0  ret
  db 0x8B, 0x44, 0x04          ; 000014D1  mov ax,[si+0x4]
  db 0x2E, 0xA3, 0x15, 0x15    ; 000014D4  mov [cs:0x1515],ax
  db 0x2E, 0x89, 0x3E, 0x1B, 0x15 ; 000014D8  mov [cs:0x151b],di
  db 0x2E, 0x8C, 0x06, 0x1D, 0x15 ; 000014DD  mov [cs:0x151d],es
  db 0xEB, 0x11                ; 000014E2  jmp short 0x14f5
  db 0x8B, 0x44, 0x02          ; 000014E4  mov ax,[si+0x2]
  db 0x2E, 0xA3, 0x15, 0x15    ; 000014E7  mov [cs:0x1515],ax
  db 0x2E, 0x89, 0x1E, 0x1B, 0x15 ; 000014EB  mov [cs:0x151b],bx
  db 0x2E, 0x8C, 0x1E, 0x1D, 0x15 ; 000014F0  mov [cs:0x151d],ds
  db 0x53                      ; 000014F5  push bx
  db 0x57                      ; 000014F6  push di
  db 0x56                      ; 000014F7  push si
  db 0xBA, 0x13, 0x15          ; 000014F8  mov dx,0x1513
  db 0xB1, 0x8B                ; 000014FB  mov cl,0x8b
  db 0xCD, 0xE0                ; 000014FD  int 0xe0
  db 0x5E                      ; 000014FF  pop si
  db 0x5F                      ; 00001500  pop di
  db 0x5B                      ; 00001501  pop bx
  db 0xC3                      ; 00001502  ret
  db 0x00, 0x00                ; 00001503  add [bx+si],al
  db 0x00, 0x00                ; 00001505  add [bx+si],al
  db 0x00, 0x00                ; 00001507  add [bx+si],al
  db 0x1F                      ; 00001509  pop ds
  db 0x15, 0x58, 0x4D          ; 0000150A  adc ax,0x4d58
  db 0x49                      ; 0000150D  dec cx
  db 0x54                      ; 0000150E  push sp
  db 0x5F                      ; 0000150F  pop di
  db 0x52                      ; 00001510  push dx
  db 0x45                      ; 00001511  inc bp
  db 0x51                      ; 00001512  push cx
  db 0x00, 0x00                ; 00001513  add [bx+si],al
  db 0x00, 0x00                ; 00001515  add [bx+si],al
  db 0x00, 0x00                ; 00001517  add [bx+si],al
  db 0x1B, 0x15                ; 00001519  sbb dx,[di]
  db 0x00, 0x00                ; 0000151B  add [bx+si],al
  db 0x00, 0x00                ; 0000151D  add [bx+si],al
  db 0x00, 0x00                ; 0000151F  add [bx+si],al
  db 0x00, 0x00                ; 00001521  add [bx+si],al
  db 0x00, 0x00                ; 00001523  add [bx+si],al
  db 0x00, 0x00                ; 00001525  add [bx+si],al
  db 0x00, 0x00                ; 00001527  add [bx+si],al
  db 0x00, 0x00                ; 00001529  add [bx+si],al
  db 0x00, 0x00                ; 0000152B  add [bx+si],al
  db 0x00, 0x00                ; 0000152D  add [bx+si],al
  db 0x00, 0x00                ; 0000152F  add [bx+si],al
  db 0x00, 0x00                ; 00001531  add [bx+si],al
  db 0x00, 0xFF                ; 00001533  add bh,bh
  db 0x06                      ; 00001535  push es
  db 0xE4, 0x23                ; 00001536  in al,0x23
  db 0x52                      ; 00001538  push dx
  db 0x24, 0x06                ; 00001539  and al,0x6
  db 0x68, 0x24, 0x9A          ; 0000153B  push word 0x9a24
  db 0x24, 0x00                ; 0000153E  and al,0x0
  db 0x00, 0x00                ; 00001540  add [bx+si],al
  db 0x00, 0x00                ; 00001542  add [bx+si],al
  db 0x00, 0x00                ; 00001544  add [bx+si],al
  db 0x00, 0x00                ; 00001546  add [bx+si],al
  db 0x00, 0x00                ; 00001548  add [bx+si],al
  db 0x00, 0x00                ; 0000154A  add [bx+si],al
  db 0x00, 0x00                ; 0000154C  add [bx+si],al
  db 0x00, 0x00                ; 0000154E  add [bx+si],al
  db 0x00, 0x00                ; 00001550  add [bx+si],al
  db 0x00, 0x00                ; 00001552  add [bx+si],al
  db 0x00, 0x00                ; 00001554  add [bx+si],al
  db 0x00, 0x00                ; 00001556  add [bx+si],al
  db 0x00, 0x00                ; 00001558  add [bx+si],al
  db 0x00, 0x00                ; 0000155A  add [bx+si],al
  db 0x00, 0x00                ; 0000155C  add [bx+si],al
  db 0x00, 0x00                ; 0000155E  add [bx+si],al
  db 0x00, 0x00                ; 00001560  add [bx+si],al
  db 0x00, 0x00                ; 00001562  add [bx+si],al
  db 0x00, 0x00                ; 00001564  add [bx+si],al
  db 0x00, 0x00                ; 00001566  add [bx+si],al
  db 0x00, 0x00                ; 00001568  add [bx+si],al
  db 0x00, 0x00                ; 0000156A  add [bx+si],al
  db 0x00, 0x00                ; 0000156C  add [bx+si],al
  db 0x00, 0x00                ; 0000156E  add [bx+si],al
  db 0x00, 0x00                ; 00001570  add [bx+si],al
  db 0x00, 0x00                ; 00001572  add [bx+si],al
  db 0x00, 0x00                ; 00001574  add [bx+si],al
  db 0x00, 0x00                ; 00001576  add [bx+si],al
  db 0x00, 0x00                ; 00001578  add [bx+si],al
  db 0x00, 0x00                ; 0000157A  add [bx+si],al
  db 0x00, 0x00                ; 0000157C  add [bx+si],al
  db 0x00, 0x00                ; 0000157E  add [bx+si],al
  db 0x00, 0x00                ; 00001580  add [bx+si],al
  db 0x00, 0x00                ; 00001582  add [bx+si],al
  db 0x00, 0x00                ; 00001584  add [bx+si],al
  db 0x00, 0x00                ; 00001586  add [bx+si],al
  db 0x00, 0x00                ; 00001588  add [bx+si],al
  db 0x00, 0x00                ; 0000158A  add [bx+si],al
  db 0x00, 0x00                ; 0000158C  add [bx+si],al
  db 0x00, 0x00                ; 0000158E  add [bx+si],al
  db 0x00, 0x00                ; 00001590  add [bx+si],al
  db 0x00, 0x00                ; 00001592  add [bx+si],al
  db 0x00, 0x00                ; 00001594  add [bx+si],al
  db 0x00, 0x00                ; 00001596  add [bx+si],al
  db 0x00, 0x00                ; 00001598  add [bx+si],al
  db 0x00, 0x00                ; 0000159A  add [bx+si],al
  db 0x00, 0x00                ; 0000159C  add [bx+si],al
  db 0x00, 0x00                ; 0000159E  add [bx+si],al
  db 0x00, 0x00                ; 000015A0  add [bx+si],al
  db 0x00, 0x00                ; 000015A2  add [bx+si],al
  db 0x00, 0x00                ; 000015A4  add [bx+si],al
  db 0x00, 0x00                ; 000015A6  add [bx+si],al
  db 0x00, 0x00                ; 000015A8  add [bx+si],al
  db 0x00, 0x00                ; 000015AA  add [bx+si],al
  db 0x00, 0x00                ; 000015AC  add [bx+si],al
  db 0x00, 0x00                ; 000015AE  add [bx+si],al
  db 0x00, 0x00                ; 000015B0  add [bx+si],al
  db 0x00, 0x00                ; 000015B2  add [bx+si],al
  db 0x00, 0x00                ; 000015B4  add [bx+si],al
  db 0x00, 0x00                ; 000015B6  add [bx+si],al
  db 0x00, 0x00                ; 000015B8  add [bx+si],al
  db 0x00, 0x00                ; 000015BA  add [bx+si],al
  db 0x00, 0x00                ; 000015BC  add [bx+si],al
  db 0x00, 0x00                ; 000015BE  add [bx+si],al
  db 0x00, 0x00                ; 000015C0  add [bx+si],al
  db 0x00, 0x00                ; 000015C2  add [bx+si],al
  db 0x00, 0x00                ; 000015C4  add [bx+si],al
  db 0x00, 0x00                ; 000015C6  add [bx+si],al
  db 0x00, 0x00                ; 000015C8  add [bx+si],al
  db 0x00, 0x00                ; 000015CA  add [bx+si],al
  db 0x00, 0x00                ; 000015CC  add [bx+si],al
  db 0x00, 0x00                ; 000015CE  add [bx+si],al
  db 0x00, 0x00                ; 000015D0  add [bx+si],al
  db 0x00, 0x00                ; 000015D2  add [bx+si],al
  db 0x00, 0x00                ; 000015D4  add [bx+si],al
  db 0x00, 0x00                ; 000015D6  add [bx+si],al
  db 0x00, 0x00                ; 000015D8  add [bx+si],al
  db 0x00, 0x00                ; 000015DA  add [bx+si],al
  db 0x00, 0x00                ; 000015DC  add [bx+si],al
  db 0x00, 0x00                ; 000015DE  add [bx+si],al
  db 0x00, 0x00                ; 000015E0  add [bx+si],al
  db 0x00, 0x00                ; 000015E2  add [bx+si],al
  db 0x00, 0x00                ; 000015E4  add [bx+si],al
  db 0x00, 0x00                ; 000015E6  add [bx+si],al
  db 0x00, 0x00                ; 000015E8  add [bx+si],al
  db 0x00, 0x00                ; 000015EA  add [bx+si],al
  db 0x00, 0x00                ; 000015EC  add [bx+si],al
  db 0x00, 0x00                ; 000015EE  add [bx+si],al
  db 0x00, 0x00                ; 000015F0  add [bx+si],al
  db 0x00, 0x00                ; 000015F2  add [bx+si],al
  db 0x00, 0x00                ; 000015F4  add [bx+si],al
  db 0x00, 0x00                ; 000015F6  add [bx+si],al
  db 0x00, 0x00                ; 000015F8  add [bx+si],al
  db 0x00, 0x00                ; 000015FA  add [bx+si],al
  db 0x00, 0x00                ; 000015FC  add [bx+si],al
  db 0x00, 0x00                ; 000015FE  add [bx+si],al
  db 0x00, 0x00                ; 00001600  add [bx+si],al
  db 0x00, 0x00                ; 00001602  add [bx+si],al
  db 0x00, 0x00                ; 00001604  add [bx+si],al
  db 0x00, 0x00                ; 00001606  add [bx+si],al
  db 0x00, 0x00                ; 00001608  add [bx+si],al
  db 0x00, 0x00                ; 0000160A  add [bx+si],al
  db 0x00, 0x00                ; 0000160C  add [bx+si],al
  db 0x00, 0x00                ; 0000160E  add [bx+si],al
  db 0x00, 0x00                ; 00001610  add [bx+si],al
  db 0x00, 0x00                ; 00001612  add [bx+si],al
  db 0x00, 0x00                ; 00001614  add [bx+si],al
  db 0x00, 0x00                ; 00001616  add [bx+si],al
  db 0x00, 0x00                ; 00001618  add [bx+si],al
  db 0x00, 0x00                ; 0000161A  add [bx+si],al
  db 0x00, 0x00                ; 0000161C  add [bx+si],al
  db 0x00, 0x00                ; 0000161E  add [bx+si],al
  db 0x00, 0x00                ; 00001620  add [bx+si],al
  db 0x00, 0x00                ; 00001622  add [bx+si],al
  db 0x00, 0x00                ; 00001624  add [bx+si],al
  db 0x00, 0x00                ; 00001626  add [bx+si],al
  db 0x00, 0x00                ; 00001628  add [bx+si],al
  db 0x00, 0x00                ; 0000162A  add [bx+si],al
  db 0x00, 0x00                ; 0000162C  add [bx+si],al
  db 0x00, 0x00                ; 0000162E  add [bx+si],al
  db 0x00, 0x00                ; 00001630  add [bx+si],al
  db 0x00, 0x00                ; 00001632  add [bx+si],al
  db 0x00, 0x00                ; 00001634  add [bx+si],al
  db 0x00, 0x00                ; 00001636  add [bx+si],al
  db 0x00, 0x00                ; 00001638  add [bx+si],al
  db 0x00, 0x00                ; 0000163A  add [bx+si],al
  db 0x00, 0x00                ; 0000163C  add [bx+si],al
  db 0x00, 0x00                ; 0000163E  add [bx+si],al
  db 0x00, 0x00                ; 00001640  add [bx+si],al
  db 0x00, 0x00                ; 00001642  add [bx+si],al
  db 0x00, 0x00                ; 00001644  add [bx+si],al
  db 0x00, 0x00                ; 00001646  add [bx+si],al
  db 0x00, 0x00                ; 00001648  add [bx+si],al
  db 0x00, 0x00                ; 0000164A  add [bx+si],al
  db 0x00, 0x00                ; 0000164C  add [bx+si],al
  db 0x00, 0x00                ; 0000164E  add [bx+si],al
  db 0x00, 0x00                ; 00001650  add [bx+si],al
  db 0x00, 0x00                ; 00001652  add [bx+si],al
  db 0x00, 0x00                ; 00001654  add [bx+si],al
  db 0x00, 0x00                ; 00001656  add [bx+si],al
  db 0x00, 0x00                ; 00001658  add [bx+si],al
  db 0x00, 0x00                ; 0000165A  add [bx+si],al
  db 0x00, 0x00                ; 0000165C  add [bx+si],al
  db 0x00, 0x00                ; 0000165E  add [bx+si],al
  db 0x00, 0x00                ; 00001660  add [bx+si],al
  db 0x00, 0x00                ; 00001662  add [bx+si],al
  db 0x00, 0x00                ; 00001664  add [bx+si],al
  db 0x00, 0x00                ; 00001666  add [bx+si],al
  db 0x00, 0x00                ; 00001668  add [bx+si],al
  db 0x00, 0x00                ; 0000166A  add [bx+si],al
  db 0x00, 0x00                ; 0000166C  add [bx+si],al
  db 0x00, 0x00                ; 0000166E  add [bx+si],al
  db 0x00, 0x00                ; 00001670  add [bx+si],al
  db 0x00, 0x00                ; 00001672  add [bx+si],al
  db 0x00, 0x00                ; 00001674  add [bx+si],al
  db 0x00, 0x00                ; 00001676  add [bx+si],al
  db 0x00, 0x00                ; 00001678  add [bx+si],al
  db 0x00, 0x00                ; 0000167A  add [bx+si],al
  db 0x00, 0x00                ; 0000167C  add [bx+si],al
  db 0x00, 0x00                ; 0000167E  add [bx+si],al
  db 0x00, 0x00                ; 00001680  add [bx+si],al
  db 0x00, 0x00                ; 00001682  add [bx+si],al
  db 0x00, 0x00                ; 00001684  add [bx+si],al
  db 0x00, 0x00                ; 00001686  add [bx+si],al
  db 0x00, 0x00                ; 00001688  add [bx+si],al
  db 0x00, 0x00                ; 0000168A  add [bx+si],al
  db 0x00, 0x00                ; 0000168C  add [bx+si],al
  db 0x00, 0x00                ; 0000168E  add [bx+si],al
  db 0x00, 0x00                ; 00001690  add [bx+si],al
  db 0x00, 0x00                ; 00001692  add [bx+si],al
  db 0x00, 0x00                ; 00001694  add [bx+si],al
  db 0x00, 0x00                ; 00001696  add [bx+si],al
  db 0x00, 0x00                ; 00001698  add [bx+si],al
  db 0x00, 0x00                ; 0000169A  add [bx+si],al
  db 0x00, 0x00                ; 0000169C  add [bx+si],al
  db 0x00, 0x00                ; 0000169E  add [bx+si],al
  db 0x00, 0x00                ; 000016A0  add [bx+si],al
  db 0x00, 0x00                ; 000016A2  add [bx+si],al
  db 0x00, 0x00                ; 000016A4  add [bx+si],al
  db 0x00, 0x00                ; 000016A6  add [bx+si],al
  db 0x00, 0x00                ; 000016A8  add [bx+si],al
  db 0x00, 0x00                ; 000016AA  add [bx+si],al
  db 0x00, 0x00                ; 000016AC  add [bx+si],al
  db 0x00, 0x00                ; 000016AE  add [bx+si],al
  db 0x00, 0x00                ; 000016B0  add [bx+si],al
  db 0x00, 0x00                ; 000016B2  add [bx+si],al
  db 0x00, 0x00                ; 000016B4  add [bx+si],al
  db 0x00, 0x00                ; 000016B6  add [bx+si],al
  db 0x00, 0x00                ; 000016B8  add [bx+si],al
  db 0x00, 0x00                ; 000016BA  add [bx+si],al
  db 0x00, 0x00                ; 000016BC  add [bx+si],al
  db 0x00, 0x00                ; 000016BE  add [bx+si],al
  db 0x00, 0x00                ; 000016C0  add [bx+si],al
  db 0x00, 0x00                ; 000016C2  add [bx+si],al
  db 0x00, 0x00                ; 000016C4  add [bx+si],al
  db 0x00, 0x00                ; 000016C6  add [bx+si],al
  db 0x00, 0x00                ; 000016C8  add [bx+si],al
  db 0x00, 0x00                ; 000016CA  add [bx+si],al
  db 0x00, 0x00                ; 000016CC  add [bx+si],al
  db 0x00, 0x00                ; 000016CE  add [bx+si],al
  db 0x00, 0x00                ; 000016D0  add [bx+si],al
  db 0x00, 0x00                ; 000016D2  add [bx+si],al
  db 0x00, 0x00                ; 000016D4  add [bx+si],al
  db 0x00, 0x00                ; 000016D6  add [bx+si],al
  db 0x00, 0x00                ; 000016D8  add [bx+si],al
  db 0x00, 0x00                ; 000016DA  add [bx+si],al
  db 0x00, 0x00                ; 000016DC  add [bx+si],al
  db 0x00, 0x00                ; 000016DE  add [bx+si],al
  db 0x00, 0x00                ; 000016E0  add [bx+si],al
  db 0x00, 0x00                ; 000016E2  add [bx+si],al
  db 0x00, 0x00                ; 000016E4  add [bx+si],al
  db 0x00, 0x00                ; 000016E6  add [bx+si],al
  db 0x00, 0x00                ; 000016E8  add [bx+si],al
  db 0x00, 0x00                ; 000016EA  add [bx+si],al
  db 0x00, 0x00                ; 000016EC  add [bx+si],al
  db 0x00, 0x00                ; 000016EE  add [bx+si],al
  db 0x00, 0x00                ; 000016F0  add [bx+si],al
  db 0x00, 0x00                ; 000016F2  add [bx+si],al
  db 0x00, 0x00                ; 000016F4  add [bx+si],al
  db 0x00, 0x00                ; 000016F6  add [bx+si],al
  db 0x00, 0x00                ; 000016F8  add [bx+si],al
  db 0x00, 0x00                ; 000016FA  add [bx+si],al
  db 0x00, 0x00                ; 000016FC  add [bx+si],al
  db 0x00, 0x00                ; 000016FE  add [bx+si],al
  db 0x00, 0x00                ; 00001700  add [bx+si],al
  db 0x00, 0x00                ; 00001702  add [bx+si],al
  db 0x00, 0x00                ; 00001704  add [bx+si],al
  db 0x00, 0x00                ; 00001706  add [bx+si],al
  db 0x00, 0x00                ; 00001708  add [bx+si],al
  db 0x00, 0x00                ; 0000170A  add [bx+si],al
  db 0x00, 0x00                ; 0000170C  add [bx+si],al
  db 0x00, 0x00                ; 0000170E  add [bx+si],al
  db 0x00, 0x00                ; 00001710  add [bx+si],al
  db 0x00, 0x00                ; 00001712  add [bx+si],al
  db 0x00, 0x00                ; 00001714  add [bx+si],al
  db 0x00, 0x00                ; 00001716  add [bx+si],al
  db 0x00, 0x00                ; 00001718  add [bx+si],al
  db 0x00, 0x00                ; 0000171A  add [bx+si],al
  db 0x00, 0x00                ; 0000171C  add [bx+si],al
  db 0x00, 0x00                ; 0000171E  add [bx+si],al
  db 0x00, 0x00                ; 00001720  add [bx+si],al
  db 0x00, 0x00                ; 00001722  add [bx+si],al
  db 0x00, 0x00                ; 00001724  add [bx+si],al
  db 0x00, 0x00                ; 00001726  add [bx+si],al
  db 0x00, 0x00                ; 00001728  add [bx+si],al
  db 0x00, 0x00                ; 0000172A  add [bx+si],al
  db 0x00, 0x00                ; 0000172C  add [bx+si],al
  db 0x00, 0x00                ; 0000172E  add [bx+si],al
  db 0x00, 0x00                ; 00001730  add [bx+si],al
  db 0x00, 0x00                ; 00001732  add [bx+si],al
  db 0x00, 0x00                ; 00001734  add [bx+si],al
  db 0x00, 0x00                ; 00001736  add [bx+si],al
  db 0x00, 0x00                ; 00001738  add [bx+si],al
  db 0x00, 0x00                ; 0000173A  add [bx+si],al
  db 0x00, 0x00                ; 0000173C  add [bx+si],al
  db 0x00, 0x00                ; 0000173E  add [bx+si],al
  db 0x00, 0x00                ; 00001740  add [bx+si],al
  db 0x00, 0x00                ; 00001742  add [bx+si],al
  db 0x00, 0x00                ; 00001744  add [bx+si],al
  db 0x00, 0x00                ; 00001746  add [bx+si],al
  db 0x00, 0x00                ; 00001748  add [bx+si],al
  db 0x00, 0x00                ; 0000174A  add [bx+si],al
  db 0x00, 0x00                ; 0000174C  add [bx+si],al
  db 0x00, 0x00                ; 0000174E  add [bx+si],al
  db 0x00, 0x00                ; 00001750  add [bx+si],al
  db 0x00, 0x00                ; 00001752  add [bx+si],al
  db 0x00, 0x00                ; 00001754  add [bx+si],al
  db 0x00, 0x00                ; 00001756  add [bx+si],al
  db 0x00, 0x00                ; 00001758  add [bx+si],al
  db 0x00, 0x00                ; 0000175A  add [bx+si],al
  db 0x00, 0x00                ; 0000175C  add [bx+si],al
  db 0x00, 0x00                ; 0000175E  add [bx+si],al
  db 0x00, 0x00                ; 00001760  add [bx+si],al
  db 0x00, 0x00                ; 00001762  add [bx+si],al
  db 0x00, 0x00                ; 00001764  add [bx+si],al
  db 0x00, 0x00                ; 00001766  add [bx+si],al
  db 0x00, 0x00                ; 00001768  add [bx+si],al
  db 0x00, 0x00                ; 0000176A  add [bx+si],al
  db 0x00, 0x00                ; 0000176C  add [bx+si],al
  db 0x00, 0x00                ; 0000176E  add [bx+si],al
  db 0x00, 0x00                ; 00001770  add [bx+si],al
  db 0x00, 0x00                ; 00001772  add [bx+si],al
  db 0x00, 0x00                ; 00001774  add [bx+si],al
  db 0x00, 0x00                ; 00001776  add [bx+si],al
  db 0x00, 0x00                ; 00001778  add [bx+si],al
  db 0x00, 0x00                ; 0000177A  add [bx+si],al
  db 0x00, 0x00                ; 0000177C  add [bx+si],al
  db 0x00, 0x00                ; 0000177E  add [bx+si],al
  db 0x00, 0x00                ; 00001780  add [bx+si],al
  db 0x00, 0x00                ; 00001782  add [bx+si],al
  db 0x00, 0x00                ; 00001784  add [bx+si],al
  db 0x00, 0x00                ; 00001786  add [bx+si],al
  db 0x00, 0x00                ; 00001788  add [bx+si],al
  db 0x00, 0x00                ; 0000178A  add [bx+si],al
  db 0x00, 0x00                ; 0000178C  add [bx+si],al
  db 0x00, 0x00                ; 0000178E  add [bx+si],al
  db 0x00, 0x00                ; 00001790  add [bx+si],al
  db 0x00, 0x00                ; 00001792  add [bx+si],al
  db 0x00, 0x00                ; 00001794  add [bx+si],al
  db 0x00, 0x00                ; 00001796  add [bx+si],al
  db 0x00, 0x00                ; 00001798  add [bx+si],al
  db 0x00, 0x00                ; 0000179A  add [bx+si],al
  db 0x00, 0x00                ; 0000179C  add [bx+si],al
  db 0x00, 0x00                ; 0000179E  add [bx+si],al
  db 0x00, 0x00                ; 000017A0  add [bx+si],al
  db 0x00, 0x00                ; 000017A2  add [bx+si],al
  db 0x00, 0x00                ; 000017A4  add [bx+si],al
  db 0x00, 0x00                ; 000017A6  add [bx+si],al
  db 0x00, 0x00                ; 000017A8  add [bx+si],al
  db 0x00, 0x00                ; 000017AA  add [bx+si],al
  db 0x00, 0x00                ; 000017AC  add [bx+si],al
  db 0x00, 0x00                ; 000017AE  add [bx+si],al
  db 0x00, 0x00                ; 000017B0  add [bx+si],al
  db 0x00, 0x00                ; 000017B2  add [bx+si],al
  db 0x00, 0x00                ; 000017B4  add [bx+si],al
  db 0x00, 0x00                ; 000017B6  add [bx+si],al
  db 0x00, 0x00                ; 000017B8  add [bx+si],al
  db 0x00, 0x00                ; 000017BA  add [bx+si],al
  db 0x00, 0x00                ; 000017BC  add [bx+si],al
  db 0x00, 0x00                ; 000017BE  add [bx+si],al
  db 0x00, 0x00                ; 000017C0  add [bx+si],al
  db 0x00, 0x00                ; 000017C2  add [bx+si],al
  db 0x00, 0x00                ; 000017C4  add [bx+si],al
  db 0x00, 0x00                ; 000017C6  add [bx+si],al
  db 0x00, 0x00                ; 000017C8  add [bx+si],al
  db 0x00, 0x00                ; 000017CA  add [bx+si],al
  db 0x00, 0x00                ; 000017CC  add [bx+si],al
  db 0x00, 0x00                ; 000017CE  add [bx+si],al
  db 0x00, 0x00                ; 000017D0  add [bx+si],al
  db 0x00, 0x00                ; 000017D2  add [bx+si],al
  db 0x00, 0x00                ; 000017D4  add [bx+si],al
  db 0x00, 0x00                ; 000017D6  add [bx+si],al
  db 0x00, 0x00                ; 000017D8  add [bx+si],al
  db 0x00, 0x00                ; 000017DA  add [bx+si],al
  db 0x00, 0x00                ; 000017DC  add [bx+si],al
  db 0x00, 0x00                ; 000017DE  add [bx+si],al
  db 0x00, 0x00                ; 000017E0  add [bx+si],al
  db 0x00, 0x00                ; 000017E2  add [bx+si],al
  db 0x00, 0x00                ; 000017E4  add [bx+si],al
  db 0x00, 0x00                ; 000017E6  add [bx+si],al
  db 0x00, 0x00                ; 000017E8  add [bx+si],al
  db 0x00, 0x00                ; 000017EA  add [bx+si],al
  db 0x00, 0x00                ; 000017EC  add [bx+si],al
  db 0x00, 0x00                ; 000017EE  add [bx+si],al
  db 0x00, 0x00                ; 000017F0  add [bx+si],al
  db 0x00, 0x00                ; 000017F2  add [bx+si],al
  db 0x00, 0x00                ; 000017F4  add [bx+si],al
  db 0x00, 0x00                ; 000017F6  add [bx+si],al
  db 0x00, 0x00                ; 000017F8  add [bx+si],al
  db 0x00, 0x00                ; 000017FA  add [bx+si],al
  db 0x00, 0x00                ; 000017FC  add [bx+si],al
  db 0x00, 0x00                ; 000017FE  add [bx+si],al
  db 0x00, 0x00                ; 00001800  add [bx+si],al
  db 0x00, 0x00                ; 00001802  add [bx+si],al
  db 0x00, 0x00                ; 00001804  add [bx+si],al
  db 0x00, 0x00                ; 00001806  add [bx+si],al
  db 0x00, 0x00                ; 00001808  add [bx+si],al
  db 0x00, 0x00                ; 0000180A  add [bx+si],al
  db 0x00, 0x00                ; 0000180C  add [bx+si],al
  db 0x00, 0x00                ; 0000180E  add [bx+si],al
  db 0x00, 0x00                ; 00001810  add [bx+si],al
  db 0x00, 0x00                ; 00001812  add [bx+si],al
  db 0x00, 0x00                ; 00001814  add [bx+si],al
  db 0x00, 0x00                ; 00001816  add [bx+si],al
  db 0x00, 0x00                ; 00001818  add [bx+si],al
  db 0x00, 0x00                ; 0000181A  add [bx+si],al
  db 0x00, 0x00                ; 0000181C  add [bx+si],al
  db 0x00, 0x00                ; 0000181E  add [bx+si],al
  db 0x00, 0x00                ; 00001820  add [bx+si],al
  db 0x00, 0x00                ; 00001822  add [bx+si],al
  db 0x00, 0x00                ; 00001824  add [bx+si],al
  db 0x00, 0x00                ; 00001826  add [bx+si],al
  db 0x00, 0x00                ; 00001828  add [bx+si],al
  db 0x00, 0x00                ; 0000182A  add [bx+si],al
  db 0x00, 0x00                ; 0000182C  add [bx+si],al
  db 0x00, 0x00                ; 0000182E  add [bx+si],al
  db 0x00, 0x00                ; 00001830  add [bx+si],al
  db 0x00, 0x00                ; 00001832  add [bx+si],al
  db 0x00, 0x00                ; 00001834  add [bx+si],al
  db 0x00, 0x00                ; 00001836  add [bx+si],al
  db 0x00, 0x00                ; 00001838  add [bx+si],al
  db 0x00, 0x00                ; 0000183A  add [bx+si],al
  db 0x00, 0x00                ; 0000183C  add [bx+si],al
  db 0x00, 0x00                ; 0000183E  add [bx+si],al
  db 0x00, 0x00                ; 00001840  add [bx+si],al
  db 0x00, 0x00                ; 00001842  add [bx+si],al
  db 0x00, 0x00                ; 00001844  add [bx+si],al
  db 0x00, 0x00                ; 00001846  add [bx+si],al
  db 0x00, 0x00                ; 00001848  add [bx+si],al
  db 0x00, 0x00                ; 0000184A  add [bx+si],al
  db 0x00, 0x00                ; 0000184C  add [bx+si],al
  db 0x00, 0x00                ; 0000184E  add [bx+si],al
  db 0x00, 0x00                ; 00001850  add [bx+si],al
  db 0x00, 0x00                ; 00001852  add [bx+si],al
  db 0x00, 0x00                ; 00001854  add [bx+si],al
  db 0x00, 0x00                ; 00001856  add [bx+si],al
  db 0x00, 0x00                ; 00001858  add [bx+si],al
  db 0x00, 0x00                ; 0000185A  add [bx+si],al
  db 0x00, 0x00                ; 0000185C  add [bx+si],al
  db 0x00, 0x00                ; 0000185E  add [bx+si],al
  db 0x00, 0x00                ; 00001860  add [bx+si],al
  db 0x00, 0x00                ; 00001862  add [bx+si],al
  db 0x00, 0x00                ; 00001864  add [bx+si],al
  db 0x00, 0x00                ; 00001866  add [bx+si],al
  db 0x00, 0x00                ; 00001868  add [bx+si],al
  db 0x00, 0x00                ; 0000186A  add [bx+si],al
  db 0x00, 0x00                ; 0000186C  add [bx+si],al
  db 0x00, 0x00                ; 0000186E  add [bx+si],al
  db 0x00, 0x00                ; 00001870  add [bx+si],al
  db 0x00, 0x00                ; 00001872  add [bx+si],al
  db 0x00, 0x00                ; 00001874  add [bx+si],al
  db 0x00, 0x00                ; 00001876  add [bx+si],al
  db 0x00, 0x00                ; 00001878  add [bx+si],al
  db 0x00, 0x00                ; 0000187A  add [bx+si],al
  db 0x00, 0x00                ; 0000187C  add [bx+si],al
  db 0x00, 0x00                ; 0000187E  add [bx+si],al
  db 0x00, 0x00                ; 00001880  add [bx+si],al
  db 0x00, 0x00                ; 00001882  add [bx+si],al
  db 0x00, 0x00                ; 00001884  add [bx+si],al
  db 0x00, 0x00                ; 00001886  add [bx+si],al
  db 0x00, 0x00                ; 00001888  add [bx+si],al
  db 0x00, 0x00                ; 0000188A  add [bx+si],al
  db 0x00, 0x00                ; 0000188C  add [bx+si],al
  db 0x00, 0x00                ; 0000188E  add [bx+si],al
  db 0x00, 0x00                ; 00001890  add [bx+si],al
  db 0x00, 0x00                ; 00001892  add [bx+si],al
  db 0x00, 0x00                ; 00001894  add [bx+si],al
  db 0x00, 0x00                ; 00001896  add [bx+si],al
  db 0x00, 0x00                ; 00001898  add [bx+si],al
  db 0x00, 0x00                ; 0000189A  add [bx+si],al
  db 0x00, 0x00                ; 0000189C  add [bx+si],al
  db 0x00, 0x00                ; 0000189E  add [bx+si],al
  db 0x00, 0x00                ; 000018A0  add [bx+si],al
  db 0x00, 0x00                ; 000018A2  add [bx+si],al
  db 0x00, 0x00                ; 000018A4  add [bx+si],al
  db 0x00, 0x00                ; 000018A6  add [bx+si],al
  db 0x00, 0x00                ; 000018A8  add [bx+si],al
  db 0x00, 0x00                ; 000018AA  add [bx+si],al
  db 0x00, 0x00                ; 000018AC  add [bx+si],al
  db 0x00, 0x00                ; 000018AE  add [bx+si],al
  db 0x00, 0x00                ; 000018B0  add [bx+si],al
  db 0x00, 0x00                ; 000018B2  add [bx+si],al
  db 0x00, 0x00                ; 000018B4  add [bx+si],al
  db 0x00, 0x00                ; 000018B6  add [bx+si],al
  db 0x00, 0x00                ; 000018B8  add [bx+si],al
  db 0x00, 0x00                ; 000018BA  add [bx+si],al
  db 0x00, 0x00                ; 000018BC  add [bx+si],al
  db 0x00, 0x00                ; 000018BE  add [bx+si],al
  db 0x00, 0x00                ; 000018C0  add [bx+si],al
  db 0x00, 0x00                ; 000018C2  add [bx+si],al
  db 0x00, 0x00                ; 000018C4  add [bx+si],al
  db 0x00, 0x00                ; 000018C6  add [bx+si],al
  db 0x00, 0x00                ; 000018C8  add [bx+si],al
  db 0x00, 0x00                ; 000018CA  add [bx+si],al
  db 0x00, 0x00                ; 000018CC  add [bx+si],al
  db 0x00, 0x00                ; 000018CE  add [bx+si],al
  db 0x00, 0x00                ; 000018D0  add [bx+si],al
  db 0x00, 0x00                ; 000018D2  add [bx+si],al
  db 0x00, 0x00                ; 000018D4  add [bx+si],al
  db 0x00, 0x00                ; 000018D6  add [bx+si],al
  db 0x00, 0x00                ; 000018D8  add [bx+si],al
  db 0x00, 0x00                ; 000018DA  add [bx+si],al
  db 0x00, 0x00                ; 000018DC  add [bx+si],al
  db 0x00, 0x00                ; 000018DE  add [bx+si],al
  db 0x00, 0x00                ; 000018E0  add [bx+si],al
  db 0x00, 0x00                ; 000018E2  add [bx+si],al
  db 0x00, 0x00                ; 000018E4  add [bx+si],al
  db 0x00, 0x00                ; 000018E6  add [bx+si],al
  db 0x00, 0x00                ; 000018E8  add [bx+si],al
  db 0x00, 0x00                ; 000018EA  add [bx+si],al
  db 0x00, 0x00                ; 000018EC  add [bx+si],al
  db 0x00, 0x00                ; 000018EE  add [bx+si],al
  db 0x00, 0x00                ; 000018F0  add [bx+si],al
  db 0x00, 0x00                ; 000018F2  add [bx+si],al
  db 0x00, 0x00                ; 000018F4  add [bx+si],al
  db 0x00, 0x00                ; 000018F6  add [bx+si],al
  db 0x00, 0x00                ; 000018F8  add [bx+si],al
  db 0x00, 0x00                ; 000018FA  add [bx+si],al
  db 0x00, 0x00                ; 000018FC  add [bx+si],al
  db 0x00, 0x00                ; 000018FE  add [bx+si],al
  db 0x00, 0x00                ; 00001900  add [bx+si],al
  db 0x00, 0x00                ; 00001902  add [bx+si],al
  db 0x00, 0x00                ; 00001904  add [bx+si],al
  db 0x00, 0x00                ; 00001906  add [bx+si],al
  db 0x00, 0x00                ; 00001908  add [bx+si],al
  db 0x00, 0x00                ; 0000190A  add [bx+si],al
  db 0x00, 0x00                ; 0000190C  add [bx+si],al
  db 0x00, 0x00                ; 0000190E  add [bx+si],al
  db 0x00, 0x00                ; 00001910  add [bx+si],al
  db 0x00, 0x00                ; 00001912  add [bx+si],al
  db 0x00, 0x00                ; 00001914  add [bx+si],al
  db 0x00, 0x00                ; 00001916  add [bx+si],al
  db 0x00, 0x00                ; 00001918  add [bx+si],al
  db 0x00, 0x00                ; 0000191A  add [bx+si],al
  db 0x00, 0x00                ; 0000191C  add [bx+si],al
  db 0x00, 0x00                ; 0000191E  add [bx+si],al
  db 0x00, 0x00                ; 00001920  add [bx+si],al
  db 0x00, 0x00                ; 00001922  add [bx+si],al
  db 0x00, 0x00                ; 00001924  add [bx+si],al
  db 0x00, 0x00                ; 00001926  add [bx+si],al
  db 0x00, 0x00                ; 00001928  add [bx+si],al
  db 0x00, 0x00                ; 0000192A  add [bx+si],al
  db 0x00, 0x00                ; 0000192C  add [bx+si],al
  db 0x00, 0x00                ; 0000192E  add [bx+si],al
  db 0x00, 0x00                ; 00001930  add [bx+si],al
  db 0x00, 0x00                ; 00001932  add [bx+si],al
  db 0x00, 0x00                ; 00001934  add [bx+si],al
  db 0x00, 0x00                ; 00001936  add [bx+si],al
  db 0x00, 0x00                ; 00001938  add [bx+si],al
  db 0x00, 0x00                ; 0000193A  add [bx+si],al
  db 0x00, 0x00                ; 0000193C  add [bx+si],al
  db 0x00, 0x00                ; 0000193E  add [bx+si],al
  db 0x00, 0x00                ; 00001940  add [bx+si],al
  db 0x00, 0x00                ; 00001942  add [bx+si],al
  db 0x00, 0x00                ; 00001944  add [bx+si],al
  db 0x00, 0x00                ; 00001946  add [bx+si],al
  db 0x00, 0x00                ; 00001948  add [bx+si],al
  db 0x00, 0x00                ; 0000194A  add [bx+si],al
  db 0x00, 0x00                ; 0000194C  add [bx+si],al
  db 0x00, 0x00                ; 0000194E  add [bx+si],al
  db 0x00, 0x00                ; 00001950  add [bx+si],al
  db 0x00, 0x00                ; 00001952  add [bx+si],al
  db 0x00, 0x00                ; 00001954  add [bx+si],al
  db 0x00, 0x00                ; 00001956  add [bx+si],al
  db 0x00, 0x00                ; 00001958  add [bx+si],al
  db 0x00, 0x00                ; 0000195A  add [bx+si],al
  db 0x00, 0x00                ; 0000195C  add [bx+si],al
  db 0x00, 0x00                ; 0000195E  add [bx+si],al
  db 0x00, 0x00                ; 00001960  add [bx+si],al
  db 0x00, 0x00                ; 00001962  add [bx+si],al
  db 0x00, 0x00                ; 00001964  add [bx+si],al
  db 0x00, 0x00                ; 00001966  add [bx+si],al
  db 0x00, 0x00                ; 00001968  add [bx+si],al
  db 0x00, 0x00                ; 0000196A  add [bx+si],al
  db 0x00, 0x00                ; 0000196C  add [bx+si],al
  db 0x00, 0x00                ; 0000196E  add [bx+si],al
  db 0x00, 0x00                ; 00001970  add [bx+si],al
  db 0x00, 0x00                ; 00001972  add [bx+si],al
  db 0x00, 0x00                ; 00001974  add [bx+si],al
  db 0x00, 0x00                ; 00001976  add [bx+si],al
  db 0x00, 0x00                ; 00001978  add [bx+si],al
  db 0x00, 0x00                ; 0000197A  add [bx+si],al
  db 0x00, 0x00                ; 0000197C  add [bx+si],al
  db 0x00, 0x00                ; 0000197E  add [bx+si],al
  db 0x00, 0x00                ; 00001980  add [bx+si],al
  db 0x00, 0x00                ; 00001982  add [bx+si],al
  db 0x00, 0x00                ; 00001984  add [bx+si],al
  db 0x00, 0x00                ; 00001986  add [bx+si],al
  db 0x00, 0x00                ; 00001988  add [bx+si],al
  db 0x00, 0x00                ; 0000198A  add [bx+si],al
  db 0x00, 0x00                ; 0000198C  add [bx+si],al
  db 0x00, 0x00                ; 0000198E  add [bx+si],al
  db 0x00, 0x00                ; 00001990  add [bx+si],al
  db 0x00, 0x00                ; 00001992  add [bx+si],al
  db 0x00, 0x00                ; 00001994  add [bx+si],al
  db 0x00, 0x00                ; 00001996  add [bx+si],al
  db 0x00, 0x00                ; 00001998  add [bx+si],al
  db 0x00, 0x00                ; 0000199A  add [bx+si],al
  db 0x00, 0x00                ; 0000199C  add [bx+si],al
  db 0x00, 0x00                ; 0000199E  add [bx+si],al
  db 0x00, 0x00                ; 000019A0  add [bx+si],al
  db 0x00, 0x00                ; 000019A2  add [bx+si],al
  db 0x00, 0x00                ; 000019A4  add [bx+si],al
  db 0x00, 0x00                ; 000019A6  add [bx+si],al
  db 0x00, 0x00                ; 000019A8  add [bx+si],al
  db 0x00, 0x00                ; 000019AA  add [bx+si],al
  db 0x00, 0x00                ; 000019AC  add [bx+si],al
  db 0x00, 0x00                ; 000019AE  add [bx+si],al
  db 0x00, 0x00                ; 000019B0  add [bx+si],al
  db 0x00, 0x00                ; 000019B2  add [bx+si],al
  db 0x00, 0x00                ; 000019B4  add [bx+si],al
  db 0x00, 0x00                ; 000019B6  add [bx+si],al
  db 0x00, 0x00                ; 000019B8  add [bx+si],al
  db 0x00, 0x00                ; 000019BA  add [bx+si],al
  db 0x00, 0x00                ; 000019BC  add [bx+si],al
  db 0x00, 0x00                ; 000019BE  add [bx+si],al
  db 0x00, 0x00                ; 000019C0  add [bx+si],al
  db 0x00, 0x00                ; 000019C2  add [bx+si],al
  db 0x00, 0x00                ; 000019C4  add [bx+si],al
  db 0x00, 0x00                ; 000019C6  add [bx+si],al
  db 0x00, 0x00                ; 000019C8  add [bx+si],al
  db 0x00, 0x00                ; 000019CA  add [bx+si],al
  db 0x00, 0x00                ; 000019CC  add [bx+si],al
  db 0x00, 0x00                ; 000019CE  add [bx+si],al
  db 0x00, 0x00                ; 000019D0  add [bx+si],al
  db 0x00, 0x00                ; 000019D2  add [bx+si],al
  db 0x00, 0x00                ; 000019D4  add [bx+si],al
  db 0x00, 0x00                ; 000019D6  add [bx+si],al
  db 0x00, 0x00                ; 000019D8  add [bx+si],al
  db 0x00, 0x00                ; 000019DA  add [bx+si],al
  db 0x00, 0x00                ; 000019DC  add [bx+si],al
  db 0x00, 0x00                ; 000019DE  add [bx+si],al
  db 0x00, 0x00                ; 000019E0  add [bx+si],al
  db 0x00, 0x00                ; 000019E2  add [bx+si],al
  db 0x00, 0x00                ; 000019E4  add [bx+si],al
  db 0x00, 0x00                ; 000019E6  add [bx+si],al
  db 0x00, 0x00                ; 000019E8  add [bx+si],al
  db 0x00, 0x00                ; 000019EA  add [bx+si],al
  db 0x00, 0x00                ; 000019EC  add [bx+si],al
  db 0x00, 0x00                ; 000019EE  add [bx+si],al
  db 0x00, 0x00                ; 000019F0  add [bx+si],al
  db 0x00, 0x00                ; 000019F2  add [bx+si],al
  db 0x00, 0x00                ; 000019F4  add [bx+si],al
  db 0x00, 0x00                ; 000019F6  add [bx+si],al
  db 0x00, 0x00                ; 000019F8  add [bx+si],al
  db 0x00, 0x00                ; 000019FA  add [bx+si],al
  db 0x00, 0x00                ; 000019FC  add [bx+si],al
  db 0x00, 0x00                ; 000019FE  add [bx+si],al
  db 0x00, 0x00                ; 00001A00  add [bx+si],al
  db 0x00, 0x00                ; 00001A02  add [bx+si],al
  db 0x00, 0x00                ; 00001A04  add [bx+si],al
  db 0x00, 0x00                ; 00001A06  add [bx+si],al
  db 0x00, 0x00                ; 00001A08  add [bx+si],al
  db 0x00, 0x00                ; 00001A0A  add [bx+si],al
  db 0x00, 0x00                ; 00001A0C  add [bx+si],al
  db 0x00, 0x00                ; 00001A0E  add [bx+si],al
  db 0x00, 0x00                ; 00001A10  add [bx+si],al
  db 0x00, 0x00                ; 00001A12  add [bx+si],al
  db 0x00, 0x00                ; 00001A14  add [bx+si],al
  db 0x00, 0x00                ; 00001A16  add [bx+si],al
  db 0x00, 0x00                ; 00001A18  add [bx+si],al
  db 0x00, 0x00                ; 00001A1A  add [bx+si],al
  db 0x00, 0x00                ; 00001A1C  add [bx+si],al
  db 0x00, 0x00                ; 00001A1E  add [bx+si],al
  db 0x00, 0x00                ; 00001A20  add [bx+si],al
  db 0x00, 0x00                ; 00001A22  add [bx+si],al
  db 0x00, 0x00                ; 00001A24  add [bx+si],al
  db 0x00, 0x00                ; 00001A26  add [bx+si],al
  db 0x00, 0x00                ; 00001A28  add [bx+si],al
  db 0x00, 0x00                ; 00001A2A  add [bx+si],al
  db 0x00, 0x00                ; 00001A2C  add [bx+si],al
  db 0x00, 0x00                ; 00001A2E  add [bx+si],al
  db 0x00, 0x00                ; 00001A30  add [bx+si],al
  db 0x00, 0x00                ; 00001A32  add [bx+si],al
  db 0x00, 0x00                ; 00001A34  add [bx+si],al
  db 0x00, 0x00                ; 00001A36  add [bx+si],al
  db 0x00, 0x00                ; 00001A38  add [bx+si],al
  db 0x00, 0x00                ; 00001A3A  add [bx+si],al
  db 0x00, 0x00                ; 00001A3C  add [bx+si],al
  db 0x00, 0x00                ; 00001A3E  add [bx+si],al
  db 0x00, 0x00                ; 00001A40  add [bx+si],al
  db 0x00, 0x00                ; 00001A42  add [bx+si],al
  db 0x00, 0x00                ; 00001A44  add [bx+si],al
  db 0x00, 0x00                ; 00001A46  add [bx+si],al
  db 0x00, 0x00                ; 00001A48  add [bx+si],al
  db 0x00, 0x00                ; 00001A4A  add [bx+si],al
  db 0x00, 0x00                ; 00001A4C  add [bx+si],al
  db 0x00, 0x00                ; 00001A4E  add [bx+si],al
  db 0x00, 0x00                ; 00001A50  add [bx+si],al
  db 0x00, 0x00                ; 00001A52  add [bx+si],al
  db 0x00, 0x00                ; 00001A54  add [bx+si],al
  db 0x00, 0x00                ; 00001A56  add [bx+si],al
  db 0x00, 0x00                ; 00001A58  add [bx+si],al
  db 0x00, 0x00                ; 00001A5A  add [bx+si],al
  db 0x00, 0x00                ; 00001A5C  add [bx+si],al
  db 0x00, 0x00                ; 00001A5E  add [bx+si],al
  db 0x00, 0x00                ; 00001A60  add [bx+si],al
  db 0x00, 0x00                ; 00001A62  add [bx+si],al
  db 0x00, 0x00                ; 00001A64  add [bx+si],al
  db 0x00, 0x00                ; 00001A66  add [bx+si],al
  db 0x00, 0x00                ; 00001A68  add [bx+si],al
  db 0x00, 0x00                ; 00001A6A  add [bx+si],al
  db 0x00, 0x00                ; 00001A6C  add [bx+si],al
  db 0x00, 0x00                ; 00001A6E  add [bx+si],al
  db 0x00, 0x00                ; 00001A70  add [bx+si],al
  db 0x00, 0x00                ; 00001A72  add [bx+si],al
  db 0x00, 0x00                ; 00001A74  add [bx+si],al
  db 0x00, 0x00                ; 00001A76  add [bx+si],al
  db 0x00, 0x00                ; 00001A78  add [bx+si],al
  db 0x00, 0x00                ; 00001A7A  add [bx+si],al
  db 0x00, 0x00                ; 00001A7C  add [bx+si],al
  db 0x00, 0x00                ; 00001A7E  add [bx+si],al
  db 0x00, 0x00                ; 00001A80  add [bx+si],al
  db 0x00, 0x00                ; 00001A82  add [bx+si],al
  db 0x00, 0x00                ; 00001A84  add [bx+si],al
  db 0x00, 0x00                ; 00001A86  add [bx+si],al
  db 0x00, 0x00                ; 00001A88  add [bx+si],al
  db 0x00, 0x00                ; 00001A8A  add [bx+si],al
  db 0x00, 0x00                ; 00001A8C  add [bx+si],al
  db 0x00, 0x00                ; 00001A8E  add [bx+si],al
  db 0x00, 0x00                ; 00001A90  add [bx+si],al
  db 0x00, 0x00                ; 00001A92  add [bx+si],al
  db 0x00, 0x00                ; 00001A94  add [bx+si],al
  db 0x00, 0x00                ; 00001A96  add [bx+si],al
  db 0x00, 0x00                ; 00001A98  add [bx+si],al
  db 0x00, 0x00                ; 00001A9A  add [bx+si],al
  db 0x00, 0x00                ; 00001A9C  add [bx+si],al
  db 0x00, 0x00                ; 00001A9E  add [bx+si],al
  db 0x00, 0x00                ; 00001AA0  add [bx+si],al
  db 0x00, 0x00                ; 00001AA2  add [bx+si],al
  db 0x00, 0x00                ; 00001AA4  add [bx+si],al
  db 0x00, 0x00                ; 00001AA6  add [bx+si],al
  db 0x00, 0x00                ; 00001AA8  add [bx+si],al
  db 0x00, 0x00                ; 00001AAA  add [bx+si],al
  db 0x00, 0x00                ; 00001AAC  add [bx+si],al
  db 0x00, 0x00                ; 00001AAE  add [bx+si],al
  db 0x00, 0x00                ; 00001AB0  add [bx+si],al
  db 0x00, 0x00                ; 00001AB2  add [bx+si],al
  db 0x00, 0x00                ; 00001AB4  add [bx+si],al
  db 0x00, 0x00                ; 00001AB6  add [bx+si],al
  db 0x00, 0x00                ; 00001AB8  add [bx+si],al
  db 0x00, 0x00                ; 00001ABA  add [bx+si],al
  db 0x00, 0x00                ; 00001ABC  add [bx+si],al
  db 0x00, 0x00                ; 00001ABE  add [bx+si],al
  db 0x00, 0x00                ; 00001AC0  add [bx+si],al
  db 0x00, 0x00                ; 00001AC2  add [bx+si],al
  db 0x00, 0x00                ; 00001AC4  add [bx+si],al
  db 0x00, 0x00                ; 00001AC6  add [bx+si],al
  db 0x00, 0x00                ; 00001AC8  add [bx+si],al
  db 0x00, 0x00                ; 00001ACA  add [bx+si],al
  db 0x00, 0x00                ; 00001ACC  add [bx+si],al
  db 0x00, 0x00                ; 00001ACE  add [bx+si],al
  db 0x00, 0x00                ; 00001AD0  add [bx+si],al
  db 0x00, 0x00                ; 00001AD2  add [bx+si],al
  db 0x00, 0x00                ; 00001AD4  add [bx+si],al
  db 0x00, 0x00                ; 00001AD6  add [bx+si],al
  db 0x00, 0x00                ; 00001AD8  add [bx+si],al
  db 0x00, 0x00                ; 00001ADA  add [bx+si],al
  db 0x00, 0x00                ; 00001ADC  add [bx+si],al
  db 0x00, 0x00                ; 00001ADE  add [bx+si],al
  db 0x00, 0x00                ; 00001AE0  add [bx+si],al
  db 0x00, 0x00                ; 00001AE2  add [bx+si],al
  db 0x00, 0x00                ; 00001AE4  add [bx+si],al
  db 0x00, 0x00                ; 00001AE6  add [bx+si],al
  db 0x00, 0x00                ; 00001AE8  add [bx+si],al
  db 0x00, 0x00                ; 00001AEA  add [bx+si],al
  db 0x00, 0x00                ; 00001AEC  add [bx+si],al
  db 0x00, 0x00                ; 00001AEE  add [bx+si],al
  db 0x00, 0x00                ; 00001AF0  add [bx+si],al
  db 0x00, 0x00                ; 00001AF2  add [bx+si],al
  db 0x00, 0x00                ; 00001AF4  add [bx+si],al
  db 0x00, 0x00                ; 00001AF6  add [bx+si],al
  db 0x00, 0x00                ; 00001AF8  add [bx+si],al
  db 0x00, 0x00                ; 00001AFA  add [bx+si],al
  db 0x00, 0x00                ; 00001AFC  add [bx+si],al
  db 0x00, 0x00                ; 00001AFE  add [bx+si],al
  db 0x00, 0x00                ; 00001B00  add [bx+si],al
  db 0x00, 0x00                ; 00001B02  add [bx+si],al
  db 0x00, 0x00                ; 00001B04  add [bx+si],al
  db 0x00, 0x00                ; 00001B06  add [bx+si],al
  db 0x00, 0x00                ; 00001B08  add [bx+si],al
  db 0x00, 0x00                ; 00001B0A  add [bx+si],al
  db 0x00, 0x00                ; 00001B0C  add [bx+si],al
  db 0x00, 0x00                ; 00001B0E  add [bx+si],al
  db 0x00, 0x00                ; 00001B10  add [bx+si],al
  db 0x00, 0x00                ; 00001B12  add [bx+si],al
  db 0x00, 0x00                ; 00001B14  add [bx+si],al
  db 0x00, 0x00                ; 00001B16  add [bx+si],al
  db 0x00, 0x00                ; 00001B18  add [bx+si],al
  db 0x00, 0x00                ; 00001B1A  add [bx+si],al
  db 0x00, 0x00                ; 00001B1C  add [bx+si],al
  db 0x00, 0x00                ; 00001B1E  add [bx+si],al
  db 0x00, 0x00                ; 00001B20  add [bx+si],al
  db 0x00, 0x00                ; 00001B22  add [bx+si],al
  db 0x00, 0x00                ; 00001B24  add [bx+si],al
  db 0x00, 0x00                ; 00001B26  add [bx+si],al
  db 0x00, 0x00                ; 00001B28  add [bx+si],al
  db 0x00, 0x00                ; 00001B2A  add [bx+si],al
  db 0x00, 0x00                ; 00001B2C  add [bx+si],al
  db 0x00, 0x00                ; 00001B2E  add [bx+si],al
  db 0x00, 0x00                ; 00001B30  add [bx+si],al
  db 0x00, 0x00                ; 00001B32  add [bx+si],al
  db 0x00, 0x00                ; 00001B34  add [bx+si],al
  db 0x00, 0x00                ; 00001B36  add [bx+si],al
  db 0x00, 0x00                ; 00001B38  add [bx+si],al
  db 0x00, 0x00                ; 00001B3A  add [bx+si],al
  db 0x00, 0x00                ; 00001B3C  add [bx+si],al
  db 0x00, 0x00                ; 00001B3E  add [bx+si],al
  db 0x00, 0x00                ; 00001B40  add [bx+si],al
  db 0x00, 0x00                ; 00001B42  add [bx+si],al
  db 0x00, 0x00                ; 00001B44  add [bx+si],al
  db 0x00, 0x00                ; 00001B46  add [bx+si],al
  db 0x00, 0x00                ; 00001B48  add [bx+si],al
  db 0x00, 0x00                ; 00001B4A  add [bx+si],al
  db 0x00, 0x00                ; 00001B4C  add [bx+si],al
  db 0x00, 0x00                ; 00001B4E  add [bx+si],al
  db 0x00, 0x00                ; 00001B50  add [bx+si],al
  db 0x00, 0x00                ; 00001B52  add [bx+si],al
  db 0x00, 0x00                ; 00001B54  add [bx+si],al
  db 0x00, 0x00                ; 00001B56  add [bx+si],al
  db 0x00, 0x00                ; 00001B58  add [bx+si],al
  db 0x00, 0x00                ; 00001B5A  add [bx+si],al
  db 0x00, 0x00                ; 00001B5C  add [bx+si],al
  db 0x00, 0x00                ; 00001B5E  add [bx+si],al
  db 0x00, 0x00                ; 00001B60  add [bx+si],al
  db 0x00, 0x00                ; 00001B62  add [bx+si],al
  db 0x00, 0x00                ; 00001B64  add [bx+si],al
  db 0x00, 0x00                ; 00001B66  add [bx+si],al
  db 0x00, 0x00                ; 00001B68  add [bx+si],al
  db 0x00, 0x00                ; 00001B6A  add [bx+si],al
  db 0x00, 0x00                ; 00001B6C  add [bx+si],al
  db 0x00, 0x00                ; 00001B6E  add [bx+si],al
  db 0x00, 0x00                ; 00001B70  add [bx+si],al
  db 0x00, 0x00                ; 00001B72  add [bx+si],al
  db 0x00, 0x00                ; 00001B74  add [bx+si],al
  db 0x00, 0x00                ; 00001B76  add [bx+si],al
  db 0x00, 0x00                ; 00001B78  add [bx+si],al
  db 0x00, 0x00                ; 00001B7A  add [bx+si],al
  db 0x00, 0x00                ; 00001B7C  add [bx+si],al
  db 0x00, 0x00                ; 00001B7E  add [bx+si],al
  db 0x00, 0x00                ; 00001B80  add [bx+si],al
  db 0x00, 0x00                ; 00001B82  add [bx+si],al
  db 0x00, 0x00                ; 00001B84  add [bx+si],al
  db 0x00, 0x00                ; 00001B86  add [bx+si],al
  db 0x00, 0x00                ; 00001B88  add [bx+si],al
  db 0x00, 0x00                ; 00001B8A  add [bx+si],al
  db 0x00, 0x00                ; 00001B8C  add [bx+si],al
  db 0x00, 0x00                ; 00001B8E  add [bx+si],al
  db 0x00, 0x00                ; 00001B90  add [bx+si],al
  db 0x00, 0x00                ; 00001B92  add [bx+si],al
  db 0x00, 0x00                ; 00001B94  add [bx+si],al
  db 0x00, 0x00                ; 00001B96  add [bx+si],al
  db 0x00, 0x00                ; 00001B98  add [bx+si],al
  db 0x00, 0x00                ; 00001B9A  add [bx+si],al
  db 0x00, 0x00                ; 00001B9C  add [bx+si],al
  db 0x00, 0x00                ; 00001B9E  add [bx+si],al
  db 0x00, 0x00                ; 00001BA0  add [bx+si],al
  db 0x00, 0x00                ; 00001BA2  add [bx+si],al
  db 0x00, 0x00                ; 00001BA4  add [bx+si],al
  db 0x00, 0x00                ; 00001BA6  add [bx+si],al
  db 0x00, 0x00                ; 00001BA8  add [bx+si],al
  db 0x00, 0x00                ; 00001BAA  add [bx+si],al
  db 0x00, 0x00                ; 00001BAC  add [bx+si],al
  db 0x00, 0x00                ; 00001BAE  add [bx+si],al
  db 0x00, 0x00                ; 00001BB0  add [bx+si],al
  db 0x00, 0x00                ; 00001BB2  add [bx+si],al
  db 0x00, 0x00                ; 00001BB4  add [bx+si],al
  db 0x00, 0x00                ; 00001BB6  add [bx+si],al
  db 0x00, 0x00                ; 00001BB8  add [bx+si],al
  db 0x00, 0x00                ; 00001BBA  add [bx+si],al
  db 0x00, 0x00                ; 00001BBC  add [bx+si],al
  db 0x00, 0x00                ; 00001BBE  add [bx+si],al
  db 0x00, 0x00                ; 00001BC0  add [bx+si],al
  db 0x00, 0x00                ; 00001BC2  add [bx+si],al
  db 0x00, 0x00                ; 00001BC4  add [bx+si],al
  db 0x00, 0x00                ; 00001BC6  add [bx+si],al
  db 0x00, 0x00                ; 00001BC8  add [bx+si],al
  db 0x00, 0x00                ; 00001BCA  add [bx+si],al
  db 0x00, 0x00                ; 00001BCC  add [bx+si],al
  db 0x00, 0x00                ; 00001BCE  add [bx+si],al
  db 0x00, 0x00                ; 00001BD0  add [bx+si],al
  db 0x00, 0x00                ; 00001BD2  add [bx+si],al
  db 0x00, 0x00                ; 00001BD4  add [bx+si],al
  db 0x00, 0x00                ; 00001BD6  add [bx+si],al
  db 0x00, 0x00                ; 00001BD8  add [bx+si],al
  db 0x00, 0x00                ; 00001BDA  add [bx+si],al
  db 0x00, 0x00                ; 00001BDC  add [bx+si],al
  db 0x00, 0x00                ; 00001BDE  add [bx+si],al
  db 0x00, 0x00                ; 00001BE0  add [bx+si],al
  db 0x00, 0x00                ; 00001BE2  add [bx+si],al
  db 0x00, 0x00                ; 00001BE4  add [bx+si],al
  db 0x00, 0x00                ; 00001BE6  add [bx+si],al
  db 0x00, 0x00                ; 00001BE8  add [bx+si],al
  db 0x00, 0x00                ; 00001BEA  add [bx+si],al
  db 0x00, 0x00                ; 00001BEC  add [bx+si],al
  db 0x00, 0x00                ; 00001BEE  add [bx+si],al
  db 0x00, 0x00                ; 00001BF0  add [bx+si],al
  db 0x00, 0x00                ; 00001BF2  add [bx+si],al
  db 0x00, 0x00                ; 00001BF4  add [bx+si],al
  db 0x00, 0x00                ; 00001BF6  add [bx+si],al
  db 0x00, 0x00                ; 00001BF8  add [bx+si],al
  db 0x00, 0x00                ; 00001BFA  add [bx+si],al
  db 0x00, 0x00                ; 00001BFC  add [bx+si],al
  db 0x00, 0x00                ; 00001BFE  add [bx+si],al
  db 0x00, 0x00                ; 00001C00  add [bx+si],al
  db 0x00, 0x00                ; 00001C02  add [bx+si],al
  db 0x00, 0x00                ; 00001C04  add [bx+si],al
  db 0x00, 0x00                ; 00001C06  add [bx+si],al
  db 0x00, 0x00                ; 00001C08  add [bx+si],al
  db 0x00, 0x00                ; 00001C0A  add [bx+si],al
  db 0x00, 0x00                ; 00001C0C  add [bx+si],al
  db 0x00, 0x00                ; 00001C0E  add [bx+si],al
  db 0x00, 0x00                ; 00001C10  add [bx+si],al
  db 0x00, 0x00                ; 00001C12  add [bx+si],al
  db 0x00, 0x00                ; 00001C14  add [bx+si],al
  db 0x00, 0x00                ; 00001C16  add [bx+si],al
  db 0x00, 0x00                ; 00001C18  add [bx+si],al
  db 0x00, 0x00                ; 00001C1A  add [bx+si],al
  db 0x00, 0x00                ; 00001C1C  add [bx+si],al
  db 0x00, 0x00                ; 00001C1E  add [bx+si],al
  db 0x00, 0x00                ; 00001C20  add [bx+si],al
  db 0x00, 0x00                ; 00001C22  add [bx+si],al
  db 0x00, 0x00                ; 00001C24  add [bx+si],al
  db 0x00, 0x00                ; 00001C26  add [bx+si],al
  db 0x00, 0x00                ; 00001C28  add [bx+si],al
  db 0x00, 0x00                ; 00001C2A  add [bx+si],al
  db 0x00, 0x00                ; 00001C2C  add [bx+si],al
  db 0x00, 0x00                ; 00001C2E  add [bx+si],al
  db 0x00, 0x00                ; 00001C30  add [bx+si],al
  db 0x00, 0x00                ; 00001C32  add [bx+si],al
  db 0x00, 0x00                ; 00001C34  add [bx+si],al
  db 0x00, 0x00                ; 00001C36  add [bx+si],al
  db 0x00, 0x00                ; 00001C38  add [bx+si],al
  db 0x00, 0x00                ; 00001C3A  add [bx+si],al
  db 0x00, 0x00                ; 00001C3C  add [bx+si],al
  db 0x00, 0x00                ; 00001C3E  add [bx+si],al
  db 0x00, 0x00                ; 00001C40  add [bx+si],al
  db 0x00, 0x00                ; 00001C42  add [bx+si],al
  db 0x00, 0x00                ; 00001C44  add [bx+si],al
  db 0x00, 0x00                ; 00001C46  add [bx+si],al
  db 0x00, 0x00                ; 00001C48  add [bx+si],al
  db 0x00, 0x00                ; 00001C4A  add [bx+si],al
  db 0x00, 0x00                ; 00001C4C  add [bx+si],al
  db 0x00, 0x00                ; 00001C4E  add [bx+si],al
  db 0x00, 0x00                ; 00001C50  add [bx+si],al
  db 0x00, 0x00                ; 00001C52  add [bx+si],al
  db 0x00, 0x00                ; 00001C54  add [bx+si],al
  db 0x00, 0x00                ; 00001C56  add [bx+si],al
  db 0x00, 0x00                ; 00001C58  add [bx+si],al
  db 0x00, 0x00                ; 00001C5A  add [bx+si],al
  db 0x00, 0x00                ; 00001C5C  add [bx+si],al
  db 0x00, 0x00                ; 00001C5E  add [bx+si],al
  db 0x00, 0x00                ; 00001C60  add [bx+si],al
  db 0x00, 0x00                ; 00001C62  add [bx+si],al
  db 0x00, 0x00                ; 00001C64  add [bx+si],al
  db 0x00, 0x00                ; 00001C66  add [bx+si],al
  db 0x00, 0x00                ; 00001C68  add [bx+si],al
  db 0x00, 0x00                ; 00001C6A  add [bx+si],al
  db 0x00, 0x00                ; 00001C6C  add [bx+si],al
  db 0x00, 0x00                ; 00001C6E  add [bx+si],al
  db 0x00, 0x00                ; 00001C70  add [bx+si],al
  db 0x00, 0x00                ; 00001C72  add [bx+si],al
  db 0x00, 0x00                ; 00001C74  add [bx+si],al
  db 0x00, 0x00                ; 00001C76  add [bx+si],al
  db 0x00, 0x00                ; 00001C78  add [bx+si],al
  db 0x00, 0x00                ; 00001C7A  add [bx+si],al
  db 0x00, 0x00                ; 00001C7C  add [bx+si],al
  db 0x00, 0x00                ; 00001C7E  add [bx+si],al
  db 0x00, 0x00                ; 00001C80  add [bx+si],al
  db 0x00, 0x00                ; 00001C82  add [bx+si],al
  db 0x00, 0x00                ; 00001C84  add [bx+si],al
  db 0x00, 0x00                ; 00001C86  add [bx+si],al
  db 0x00, 0x00                ; 00001C88  add [bx+si],al
  db 0x00, 0x00                ; 00001C8A  add [bx+si],al
  db 0x00, 0x00                ; 00001C8C  add [bx+si],al
  db 0x00, 0x00                ; 00001C8E  add [bx+si],al
  db 0x00, 0x00                ; 00001C90  add [bx+si],al
  db 0x00, 0x00                ; 00001C92  add [bx+si],al
  db 0x00, 0x00                ; 00001C94  add [bx+si],al
  db 0x00, 0x00                ; 00001C96  add [bx+si],al
  db 0x00, 0x00                ; 00001C98  add [bx+si],al
  db 0x00, 0x00                ; 00001C9A  add [bx+si],al
  db 0x00, 0x00                ; 00001C9C  add [bx+si],al
  db 0x00, 0x00                ; 00001C9E  add [bx+si],al
  db 0x00, 0x00                ; 00001CA0  add [bx+si],al
  db 0x00, 0x00                ; 00001CA2  add [bx+si],al
  db 0x00, 0x00                ; 00001CA4  add [bx+si],al
  db 0x00, 0x00                ; 00001CA6  add [bx+si],al
  db 0x00, 0x00                ; 00001CA8  add [bx+si],al
  db 0x00, 0x00                ; 00001CAA  add [bx+si],al
  db 0x00, 0x00                ; 00001CAC  add [bx+si],al
  db 0x00, 0x00                ; 00001CAE  add [bx+si],al
  db 0x00, 0x00                ; 00001CB0  add [bx+si],al
  db 0x00, 0x00                ; 00001CB2  add [bx+si],al
  db 0x00, 0x00                ; 00001CB4  add [bx+si],al
  db 0x00, 0x00                ; 00001CB6  add [bx+si],al
  db 0x00, 0x00                ; 00001CB8  add [bx+si],al
  db 0x00, 0x00                ; 00001CBA  add [bx+si],al
  db 0x00, 0x00                ; 00001CBC  add [bx+si],al
  db 0x00, 0x00                ; 00001CBE  add [bx+si],al
  db 0x00, 0x00                ; 00001CC0  add [bx+si],al
  db 0x00, 0x00                ; 00001CC2  add [bx+si],al
  db 0x00, 0x00                ; 00001CC4  add [bx+si],al
  db 0x00, 0x00                ; 00001CC6  add [bx+si],al
  db 0x00, 0x00                ; 00001CC8  add [bx+si],al
  db 0x00, 0x00                ; 00001CCA  add [bx+si],al
  db 0x00, 0x00                ; 00001CCC  add [bx+si],al
  db 0x00, 0x00                ; 00001CCE  add [bx+si],al
  db 0x00, 0x00                ; 00001CD0  add [bx+si],al
  db 0x00, 0x00                ; 00001CD2  add [bx+si],al
  db 0x00, 0x00                ; 00001CD4  add [bx+si],al
  db 0x00, 0x00                ; 00001CD6  add [bx+si],al
  db 0x00, 0x00                ; 00001CD8  add [bx+si],al
  db 0x00, 0x00                ; 00001CDA  add [bx+si],al
  db 0x00, 0x00                ; 00001CDC  add [bx+si],al
  db 0x00, 0x00                ; 00001CDE  add [bx+si],al
  db 0x00, 0x00                ; 00001CE0  add [bx+si],al
  db 0x00, 0x00                ; 00001CE2  add [bx+si],al
  db 0x00, 0x00                ; 00001CE4  add [bx+si],al
  db 0x00, 0x00                ; 00001CE6  add [bx+si],al
  db 0x00, 0x00                ; 00001CE8  add [bx+si],al
  db 0x00, 0x00                ; 00001CEA  add [bx+si],al
  db 0x00, 0x00                ; 00001CEC  add [bx+si],al
  db 0x00, 0x00                ; 00001CEE  add [bx+si],al
  db 0x00, 0x00                ; 00001CF0  add [bx+si],al
  db 0x00, 0x00                ; 00001CF2  add [bx+si],al
  db 0x00, 0x00                ; 00001CF4  add [bx+si],al
  db 0x00, 0x00                ; 00001CF6  add [bx+si],al
  db 0x00, 0x00                ; 00001CF8  add [bx+si],al
  db 0x00, 0x00                ; 00001CFA  add [bx+si],al
  db 0x00, 0x00                ; 00001CFC  add [bx+si],al
  db 0x00, 0x00                ; 00001CFE  add [bx+si],al
  db 0x00, 0x00                ; 00001D00  add [bx+si],al
  db 0x00, 0x00                ; 00001D02  add [bx+si],al
  db 0x00, 0x00                ; 00001D04  add [bx+si],al
  db 0x00, 0x00                ; 00001D06  add [bx+si],al
  db 0x00, 0x00                ; 00001D08  add [bx+si],al
  db 0x00, 0x00                ; 00001D0A  add [bx+si],al
  db 0x00, 0x00                ; 00001D0C  add [bx+si],al
  db 0x00, 0x00                ; 00001D0E  add [bx+si],al
  db 0x00, 0x00                ; 00001D10  add [bx+si],al
  db 0x00, 0x00                ; 00001D12  add [bx+si],al
  db 0x00, 0x00                ; 00001D14  add [bx+si],al
  db 0x00, 0x00                ; 00001D16  add [bx+si],al
  db 0x00, 0x00                ; 00001D18  add [bx+si],al
  db 0x00, 0x00                ; 00001D1A  add [bx+si],al
  db 0x00, 0x00                ; 00001D1C  add [bx+si],al
  db 0x00, 0x00                ; 00001D1E  add [bx+si],al
  db 0x00, 0x00                ; 00001D20  add [bx+si],al
  db 0x00, 0x00                ; 00001D22  add [bx+si],al
  db 0x00, 0x00                ; 00001D24  add [bx+si],al
  db 0x00, 0x00                ; 00001D26  add [bx+si],al
  db 0x00, 0x00                ; 00001D28  add [bx+si],al
  db 0x00, 0x00                ; 00001D2A  add [bx+si],al
  db 0x00, 0x00                ; 00001D2C  add [bx+si],al
  db 0x00, 0x00                ; 00001D2E  add [bx+si],al
  db 0x00, 0x00                ; 00001D30  add [bx+si],al
  db 0x00, 0x00                ; 00001D32  add [bx+si],al
  db 0x00, 0x00                ; 00001D34  add [bx+si],al
  db 0x00, 0x00                ; 00001D36  add [bx+si],al
  db 0x00, 0x00                ; 00001D38  add [bx+si],al
  db 0x00, 0x00                ; 00001D3A  add [bx+si],al
  db 0x00, 0x00                ; 00001D3C  add [bx+si],al
  db 0x00, 0x00                ; 00001D3E  add [bx+si],al
  db 0x00, 0x00                ; 00001D40  add [bx+si],al
  db 0x00, 0x00                ; 00001D42  add [bx+si],al
  db 0x00, 0x00                ; 00001D44  add [bx+si],al
  db 0x00, 0x00                ; 00001D46  add [bx+si],al
  db 0x00, 0x00                ; 00001D48  add [bx+si],al
  db 0x00, 0x00                ; 00001D4A  add [bx+si],al
  db 0x00, 0x00                ; 00001D4C  add [bx+si],al
  db 0x00, 0x00                ; 00001D4E  add [bx+si],al
  db 0x00, 0x00                ; 00001D50  add [bx+si],al
  db 0x00, 0x00                ; 00001D52  add [bx+si],al
  db 0x00, 0x00                ; 00001D54  add [bx+si],al
  db 0x00, 0x00                ; 00001D56  add [bx+si],al
  db 0x00, 0x00                ; 00001D58  add [bx+si],al
  db 0x00, 0x00                ; 00001D5A  add [bx+si],al
  db 0x00, 0x00                ; 00001D5C  add [bx+si],al
  db 0x00, 0x00                ; 00001D5E  add [bx+si],al
  db 0x00, 0x00                ; 00001D60  add [bx+si],al
  db 0x00, 0x00                ; 00001D62  add [bx+si],al
  db 0x00, 0x00                ; 00001D64  add [bx+si],al
  db 0x00, 0x00                ; 00001D66  add [bx+si],al
  db 0x00, 0x00                ; 00001D68  add [bx+si],al
  db 0x00, 0x00                ; 00001D6A  add [bx+si],al
  db 0x00, 0x00                ; 00001D6C  add [bx+si],al
  db 0x00, 0x00                ; 00001D6E  add [bx+si],al
  db 0x00, 0x00                ; 00001D70  add [bx+si],al
  db 0x00, 0x00                ; 00001D72  add [bx+si],al
  db 0x00, 0x00                ; 00001D74  add [bx+si],al
  db 0x00, 0x00                ; 00001D76  add [bx+si],al
  db 0x00, 0x00                ; 00001D78  add [bx+si],al
  db 0x00, 0x00                ; 00001D7A  add [bx+si],al
  db 0x00, 0x00                ; 00001D7C  add [bx+si],al
  db 0x00, 0x00                ; 00001D7E  add [bx+si],al
  db 0x00, 0x00                ; 00001D80  add [bx+si],al
  db 0x00, 0x00                ; 00001D82  add [bx+si],al
  db 0x00, 0x00                ; 00001D84  add [bx+si],al
  db 0x00, 0x00                ; 00001D86  add [bx+si],al
  db 0x00, 0x00                ; 00001D88  add [bx+si],al
  db 0x00, 0x00                ; 00001D8A  add [bx+si],al
  db 0x00, 0x00                ; 00001D8C  add [bx+si],al
  db 0x00, 0x00                ; 00001D8E  add [bx+si],al
  db 0x00, 0x00                ; 00001D90  add [bx+si],al
  db 0x00, 0x00                ; 00001D92  add [bx+si],al
  db 0x00, 0x00                ; 00001D94  add [bx+si],al
  db 0x00, 0x00                ; 00001D96  add [bx+si],al
  db 0x00, 0x00                ; 00001D98  add [bx+si],al
  db 0x00, 0x00                ; 00001D9A  add [bx+si],al
  db 0x00, 0x00                ; 00001D9C  add [bx+si],al
  db 0x00, 0x00                ; 00001D9E  add [bx+si],al
  db 0x00, 0x00                ; 00001DA0  add [bx+si],al
  db 0x00, 0x00                ; 00001DA2  add [bx+si],al
  db 0x00, 0x00                ; 00001DA4  add [bx+si],al
  db 0x00, 0x00                ; 00001DA6  add [bx+si],al
  db 0x00, 0x00                ; 00001DA8  add [bx+si],al
  db 0x00, 0x00                ; 00001DAA  add [bx+si],al
  db 0x00, 0x00                ; 00001DAC  add [bx+si],al
  db 0x00, 0x00                ; 00001DAE  add [bx+si],al
  db 0x00, 0x00                ; 00001DB0  add [bx+si],al
  db 0x00, 0x00                ; 00001DB2  add [bx+si],al
  db 0x00, 0x00                ; 00001DB4  add [bx+si],al
  db 0x00, 0x00                ; 00001DB6  add [bx+si],al
  db 0x00, 0x00                ; 00001DB8  add [bx+si],al
  db 0x00, 0x00                ; 00001DBA  add [bx+si],al
  db 0x00, 0x00                ; 00001DBC  add [bx+si],al
  db 0x00, 0x00                ; 00001DBE  add [bx+si],al
  db 0x00, 0x00                ; 00001DC0  add [bx+si],al
  db 0x00, 0x00                ; 00001DC2  add [bx+si],al
  db 0x00, 0x00                ; 00001DC4  add [bx+si],al
  db 0x00, 0x00                ; 00001DC6  add [bx+si],al
  db 0x00, 0x00                ; 00001DC8  add [bx+si],al
  db 0x00, 0x00                ; 00001DCA  add [bx+si],al
  db 0x00, 0x00                ; 00001DCC  add [bx+si],al
  db 0x00, 0x00                ; 00001DCE  add [bx+si],al
  db 0x00, 0x00                ; 00001DD0  add [bx+si],al
  db 0x00, 0x00                ; 00001DD2  add [bx+si],al
  db 0x00, 0x00                ; 00001DD4  add [bx+si],al
  db 0x00, 0x00                ; 00001DD6  add [bx+si],al
  db 0x00, 0x00                ; 00001DD8  add [bx+si],al
  db 0x00, 0x00                ; 00001DDA  add [bx+si],al
  db 0x00, 0x00                ; 00001DDC  add [bx+si],al
  db 0x00, 0x00                ; 00001DDE  add [bx+si],al
  db 0x00, 0x00                ; 00001DE0  add [bx+si],al
  db 0x00, 0x00                ; 00001DE2  add [bx+si],al
  db 0x00, 0x00                ; 00001DE4  add [bx+si],al
  db 0x00, 0x00                ; 00001DE6  add [bx+si],al
  db 0x00, 0x00                ; 00001DE8  add [bx+si],al
  db 0x00, 0x00                ; 00001DEA  add [bx+si],al
  db 0x00, 0x00                ; 00001DEC  add [bx+si],al
  db 0x00, 0x00                ; 00001DEE  add [bx+si],al
  db 0x00, 0x00                ; 00001DF0  add [bx+si],al
  db 0x00, 0x00                ; 00001DF2  add [bx+si],al
  db 0x00, 0x00                ; 00001DF4  add [bx+si],al
  db 0x00, 0x00                ; 00001DF6  add [bx+si],al
  db 0x00, 0x00                ; 00001DF8  add [bx+si],al
  db 0x00, 0x00                ; 00001DFA  add [bx+si],al
  db 0x00, 0x00                ; 00001DFC  add [bx+si],al
  db 0x00, 0x00                ; 00001DFE  add [bx+si],al
  db 0x00, 0x00                ; 00001E00  add [bx+si],al
  db 0x00, 0x00                ; 00001E02  add [bx+si],al
  db 0x00, 0x00                ; 00001E04  add [bx+si],al
  db 0x00, 0x00                ; 00001E06  add [bx+si],al
  db 0x00, 0x00                ; 00001E08  add [bx+si],al
  db 0x00, 0x00                ; 00001E0A  add [bx+si],al
  db 0x00, 0x00                ; 00001E0C  add [bx+si],al
  db 0x00, 0x00                ; 00001E0E  add [bx+si],al
  db 0x00, 0x00                ; 00001E10  add [bx+si],al
  db 0x00, 0x00                ; 00001E12  add [bx+si],al
  db 0x00, 0x00                ; 00001E14  add [bx+si],al
  db 0x00, 0x00                ; 00001E16  add [bx+si],al
  db 0x00, 0x00                ; 00001E18  add [bx+si],al
  db 0x00, 0x00                ; 00001E1A  add [bx+si],al
  db 0x00, 0x00                ; 00001E1C  add [bx+si],al
  db 0x00, 0x00                ; 00001E1E  add [bx+si],al
  db 0x00, 0x00                ; 00001E20  add [bx+si],al
  db 0x00, 0x00                ; 00001E22  add [bx+si],al
  db 0x00, 0x00                ; 00001E24  add [bx+si],al
  db 0x00, 0x00                ; 00001E26  add [bx+si],al
  db 0x00, 0x00                ; 00001E28  add [bx+si],al
  db 0x00, 0x00                ; 00001E2A  add [bx+si],al
  db 0x00, 0x00                ; 00001E2C  add [bx+si],al
  db 0x00, 0x00                ; 00001E2E  add [bx+si],al
  db 0x00, 0x00                ; 00001E30  add [bx+si],al
  db 0x00, 0x00                ; 00001E32  add [bx+si],al
  db 0x00, 0x00                ; 00001E34  add [bx+si],al
  db 0x00, 0x00                ; 00001E36  add [bx+si],al
  db 0x00, 0x00                ; 00001E38  add [bx+si],al
  db 0x00, 0x00                ; 00001E3A  add [bx+si],al
  db 0x00, 0x00                ; 00001E3C  add [bx+si],al
  db 0x00, 0x00                ; 00001E3E  add [bx+si],al
  db 0x00, 0x00                ; 00001E40  add [bx+si],al
  db 0x00, 0x00                ; 00001E42  add [bx+si],al
  db 0x00, 0x00                ; 00001E44  add [bx+si],al
  db 0x00, 0x00                ; 00001E46  add [bx+si],al
  db 0x00, 0x00                ; 00001E48  add [bx+si],al
  db 0x00, 0x00                ; 00001E4A  add [bx+si],al
  db 0x00, 0x00                ; 00001E4C  add [bx+si],al
  db 0x00, 0x00                ; 00001E4E  add [bx+si],al
  db 0x00, 0x00                ; 00001E50  add [bx+si],al
  db 0x00, 0x00                ; 00001E52  add [bx+si],al
  db 0x00, 0x00                ; 00001E54  add [bx+si],al
  db 0x00, 0x00                ; 00001E56  add [bx+si],al
  db 0x00, 0x00                ; 00001E58  add [bx+si],al
  db 0x00, 0x00                ; 00001E5A  add [bx+si],al
  db 0x00, 0x00                ; 00001E5C  add [bx+si],al
  db 0x00, 0x00                ; 00001E5E  add [bx+si],al
  db 0x00, 0x00                ; 00001E60  add [bx+si],al
  db 0x00, 0x00                ; 00001E62  add [bx+si],al
  db 0x00, 0x00                ; 00001E64  add [bx+si],al
  db 0x00, 0x00                ; 00001E66  add [bx+si],al
  db 0x00, 0x00                ; 00001E68  add [bx+si],al
  db 0x00, 0x00                ; 00001E6A  add [bx+si],al
  db 0x00, 0x00                ; 00001E6C  add [bx+si],al
  db 0x00, 0x00                ; 00001E6E  add [bx+si],al
  db 0x00, 0x00                ; 00001E70  add [bx+si],al
  db 0x00, 0x00                ; 00001E72  add [bx+si],al
  db 0x00, 0x00                ; 00001E74  add [bx+si],al
  db 0x00, 0x00                ; 00001E76  add [bx+si],al
  db 0x00, 0x00                ; 00001E78  add [bx+si],al
  db 0x00, 0x00                ; 00001E7A  add [bx+si],al
  db 0x00, 0x00                ; 00001E7C  add [bx+si],al
  db 0x00, 0x00                ; 00001E7E  add [bx+si],al
  db 0x00, 0x00                ; 00001E80  add [bx+si],al
  db 0x00, 0x00                ; 00001E82  add [bx+si],al
  db 0x00, 0x00                ; 00001E84  add [bx+si],al
  db 0x00, 0x00                ; 00001E86  add [bx+si],al
  db 0x00, 0x00                ; 00001E88  add [bx+si],al
  db 0x00, 0x00                ; 00001E8A  add [bx+si],al
  db 0x00, 0x00                ; 00001E8C  add [bx+si],al
  db 0x00, 0x00                ; 00001E8E  add [bx+si],al
  db 0x00, 0x00                ; 00001E90  add [bx+si],al
  db 0x00, 0x00                ; 00001E92  add [bx+si],al
  db 0x00, 0x00                ; 00001E94  add [bx+si],al
  db 0x00, 0x00                ; 00001E96  add [bx+si],al
  db 0x00, 0x00                ; 00001E98  add [bx+si],al
  db 0x00, 0x00                ; 00001E9A  add [bx+si],al
  db 0x00, 0x00                ; 00001E9C  add [bx+si],al
  db 0x00, 0x00                ; 00001E9E  add [bx+si],al
  db 0x00, 0x00                ; 00001EA0  add [bx+si],al
  db 0x00, 0x00                ; 00001EA2  add [bx+si],al
  db 0x00, 0x00                ; 00001EA4  add [bx+si],al
  db 0x00, 0x00                ; 00001EA6  add [bx+si],al
  db 0x00, 0x00                ; 00001EA8  add [bx+si],al
  db 0x00, 0x00                ; 00001EAA  add [bx+si],al
  db 0x00, 0x00                ; 00001EAC  add [bx+si],al
  db 0x00, 0x00                ; 00001EAE  add [bx+si],al
  db 0x00, 0x00                ; 00001EB0  add [bx+si],al
  db 0x00, 0x00                ; 00001EB2  add [bx+si],al
  db 0x00, 0x00                ; 00001EB4  add [bx+si],al
  db 0x00, 0x00                ; 00001EB6  add [bx+si],al
  db 0x00, 0x00                ; 00001EB8  add [bx+si],al
  db 0x00, 0x00                ; 00001EBA  add [bx+si],al
  db 0x00, 0x00                ; 00001EBC  add [bx+si],al
  db 0x00, 0x00                ; 00001EBE  add [bx+si],al
  db 0x00, 0x00                ; 00001EC0  add [bx+si],al
  db 0x00, 0x00                ; 00001EC2  add [bx+si],al
  db 0x00, 0x00                ; 00001EC4  add [bx+si],al
  db 0x00, 0x00                ; 00001EC6  add [bx+si],al
  db 0x00, 0x00                ; 00001EC8  add [bx+si],al
  db 0x00, 0x00                ; 00001ECA  add [bx+si],al
  db 0x00, 0x00                ; 00001ECC  add [bx+si],al
  db 0x00, 0x00                ; 00001ECE  add [bx+si],al
  db 0x00, 0x00                ; 00001ED0  add [bx+si],al
  db 0x00, 0x00                ; 00001ED2  add [bx+si],al
  db 0x00, 0x00                ; 00001ED4  add [bx+si],al
  db 0x00, 0x00                ; 00001ED6  add [bx+si],al
  db 0x00, 0x00                ; 00001ED8  add [bx+si],al
  db 0x00, 0x00                ; 00001EDA  add [bx+si],al
  db 0x00, 0x00                ; 00001EDC  add [bx+si],al
  db 0x00, 0x00                ; 00001EDE  add [bx+si],al
  db 0x00, 0x00                ; 00001EE0  add [bx+si],al
  db 0x00, 0x00                ; 00001EE2  add [bx+si],al
  db 0x00, 0x00                ; 00001EE4  add [bx+si],al
  db 0x00, 0x00                ; 00001EE6  add [bx+si],al
  db 0x00, 0x00                ; 00001EE8  add [bx+si],al
  db 0x00, 0x00                ; 00001EEA  add [bx+si],al
  db 0x00, 0x00                ; 00001EEC  add [bx+si],al
  db 0x00, 0x00                ; 00001EEE  add [bx+si],al
  db 0x00, 0x00                ; 00001EF0  add [bx+si],al
  db 0x00, 0x00                ; 00001EF2  add [bx+si],al
  db 0x00, 0x00                ; 00001EF4  add [bx+si],al
  db 0x00, 0x00                ; 00001EF6  add [bx+si],al
  db 0x00, 0x00                ; 00001EF8  add [bx+si],al
  db 0x00, 0x00                ; 00001EFA  add [bx+si],al
  db 0x00, 0x00                ; 00001EFC  add [bx+si],al
  db 0x00, 0x00                ; 00001EFE  add [bx+si],al
  db 0x00, 0x00                ; 00001F00  add [bx+si],al
  db 0x00, 0x00                ; 00001F02  add [bx+si],al
  db 0x00, 0x00                ; 00001F04  add [bx+si],al
  db 0x00, 0x00                ; 00001F06  add [bx+si],al
  db 0x00, 0x00                ; 00001F08  add [bx+si],al
  db 0x00, 0x00                ; 00001F0A  add [bx+si],al
  db 0x00, 0x00                ; 00001F0C  add [bx+si],al
  db 0x00, 0x00                ; 00001F0E  add [bx+si],al
  db 0x00, 0x00                ; 00001F10  add [bx+si],al
  db 0x00, 0x00                ; 00001F12  add [bx+si],al
  db 0x00, 0x00                ; 00001F14  add [bx+si],al
  db 0x00, 0x00                ; 00001F16  add [bx+si],al
  db 0x00, 0x00                ; 00001F18  add [bx+si],al
  db 0x00, 0x00                ; 00001F1A  add [bx+si],al
  db 0x00, 0x00                ; 00001F1C  add [bx+si],al
  db 0x00, 0x00                ; 00001F1E  add [bx+si],al
  db 0x00, 0x00                ; 00001F20  add [bx+si],al
  db 0x00, 0x00                ; 00001F22  add [bx+si],al
  db 0x00, 0x00                ; 00001F24  add [bx+si],al
  db 0x00, 0x00                ; 00001F26  add [bx+si],al
  db 0x00, 0x00                ; 00001F28  add [bx+si],al
  db 0x00, 0x00                ; 00001F2A  add [bx+si],al
  db 0x00, 0x00                ; 00001F2C  add [bx+si],al
  db 0x00, 0x00                ; 00001F2E  add [bx+si],al
  db 0x00, 0x00                ; 00001F30  add [bx+si],al
  db 0x00, 0x00                ; 00001F32  add [bx+si],al
  db 0x00, 0x00                ; 00001F34  add [bx+si],al
  db 0x00, 0x00                ; 00001F36  add [bx+si],al
  db 0x00, 0x00                ; 00001F38  add [bx+si],al
  db 0x00, 0x00                ; 00001F3A  add [bx+si],al
  db 0x00, 0x00                ; 00001F3C  add [bx+si],al
  db 0x00, 0x00                ; 00001F3E  add [bx+si],al
  db 0x00, 0x00                ; 00001F40  add [bx+si],al
  db 0x00, 0x00                ; 00001F42  add [bx+si],al
  db 0x00, 0x00                ; 00001F44  add [bx+si],al
  db 0x00, 0x00                ; 00001F46  add [bx+si],al
  db 0x00, 0x00                ; 00001F48  add [bx+si],al
  db 0x00, 0x00                ; 00001F4A  add [bx+si],al
  db 0x00, 0x00                ; 00001F4C  add [bx+si],al
  db 0x00, 0x00                ; 00001F4E  add [bx+si],al
  db 0x00, 0x00                ; 00001F50  add [bx+si],al
  db 0x00, 0x00                ; 00001F52  add [bx+si],al
  db 0x00, 0x00                ; 00001F54  add [bx+si],al
  db 0x00, 0x00                ; 00001F56  add [bx+si],al
  db 0x00, 0x00                ; 00001F58  add [bx+si],al
  db 0x00, 0x00                ; 00001F5A  add [bx+si],al
  db 0x00, 0x00                ; 00001F5C  add [bx+si],al
  db 0x00, 0x00                ; 00001F5E  add [bx+si],al
  db 0x00, 0x00                ; 00001F60  add [bx+si],al
  db 0x00, 0x00                ; 00001F62  add [bx+si],al
  db 0x00, 0x00                ; 00001F64  add [bx+si],al
  db 0x00, 0x00                ; 00001F66  add [bx+si],al
  db 0x00, 0x00                ; 00001F68  add [bx+si],al
  db 0x00, 0x00                ; 00001F6A  add [bx+si],al
  db 0x00, 0x00                ; 00001F6C  add [bx+si],al
  db 0x00, 0x00                ; 00001F6E  add [bx+si],al
  db 0x00, 0x00                ; 00001F70  add [bx+si],al
  db 0x00, 0x00                ; 00001F72  add [bx+si],al
  db 0x00, 0x03                ; 00001F74  add [bp+di],al
  db 0x00, 0x00                ; 00001F76  add [bx+si],al
  db 0x00, 0x00                ; 00001F78  add [bx+si],al
  db 0x00, 0x01                ; 00001F7A  add [bx+di],al
  db 0x00, 0x00                ; 00001F7C  add [bx+si],al
  db 0x00, 0x00                ; 00001F7E  add [bx+si],al
  db 0x00, 0xFF                ; 00001F80  add bh,bh
  db 0xFF                      ; 00001F82  db 0xff
  db 0xFF                      ; 00001F83  db 0xff
  db 0xFF                      ; 00001F84  db 0xff
  db 0xFF                      ; 00001F85  db 0xff
  db 0xFF, 0x00                ; 00001F86  inc word [bx+si]
  db 0x00, 0x00                ; 00001F88  add [bx+si],al
  db 0x00, 0x00                ; 00001F8A  add [bx+si],al
  db 0x8E, 0x27                ; 00001F8C  mov fs,[bx]
  db 0xE4, 0x23                ; 00001F8E  in al,0x23
  db 0x00, 0x00                ; 00001F90  add [bx+si],al
  db 0x00, 0x00                ; 00001F92  add [bx+si],al
  db 0x00, 0x00                ; 00001F94  add [bx+si],al
  db 0x00, 0x00                ; 00001F96  add [bx+si],al
  db 0x00, 0x00                ; 00001F98  add [bx+si],al
  db 0x00, 0x00                ; 00001F9A  add [bx+si],al
  db 0x00, 0x00                ; 00001F9C  add [bx+si],al
  db 0xA8, 0x1F                ; 00001F9E  test al,0x1f
  db 0x00, 0x00                ; 00001FA0  add [bx+si],al
  db 0x00, 0x00                ; 00001FA2  add [bx+si],al
  db 0x00, 0x00                ; 00001FA4  add [bx+si],al
  db 0x00, 0x00                ; 00001FA6  add [bx+si],al
  db 0x00, 0x80, 0x00, 0x00    ; 00001FA8  add [bx+si+0x0],al
  db 0x00, 0x00                ; 00001FAC  add [bx+si],al
  db 0x00, 0x00                ; 00001FAE  add [bx+si],al
  db 0x00, 0x00                ; 00001FB0  add [bx+si],al
  db 0x00, 0x00                ; 00001FB2  add [bx+si],al
  db 0x00, 0x00                ; 00001FB4  add [bx+si],al
  db 0x00, 0x00                ; 00001FB6  add [bx+si],al
  db 0x00, 0x00                ; 00001FB8  add [bx+si],al
  db 0x00, 0x00                ; 00001FBA  add [bx+si],al
  db 0x00, 0x00                ; 00001FBC  add [bx+si],al
  db 0x00, 0x00                ; 00001FBE  add [bx+si],al
  db 0x00, 0x00                ; 00001FC0  add [bx+si],al
  db 0x00, 0x00                ; 00001FC2  add [bx+si],al
  db 0x00, 0x00                ; 00001FC4  add [bx+si],al
  db 0x00, 0x00                ; 00001FC6  add [bx+si],al
  db 0x00, 0x00                ; 00001FC8  add [bx+si],al
  db 0x00, 0x00                ; 00001FCA  add [bx+si],al
  db 0x00, 0x00                ; 00001FCC  add [bx+si],al
  db 0x00, 0x00                ; 00001FCE  add [bx+si],al
  db 0x00, 0x00                ; 00001FD0  add [bx+si],al
  db 0x00, 0x00                ; 00001FD2  add [bx+si],al
  db 0x00, 0x00                ; 00001FD4  add [bx+si],al
  db 0x00, 0x00                ; 00001FD6  add [bx+si],al
  db 0x00, 0x00                ; 00001FD8  add [bx+si],al
  db 0x00, 0x00                ; 00001FDA  add [bx+si],al
  db 0x00, 0x00                ; 00001FDC  add [bx+si],al
  db 0x00, 0x00                ; 00001FDE  add [bx+si],al
  db 0x00, 0x00                ; 00001FE0  add [bx+si],al
  db 0x00, 0x00                ; 00001FE2  add [bx+si],al
  db 0x00, 0x00                ; 00001FE4  add [bx+si],al
  db 0x00, 0x00                ; 00001FE6  add [bx+si],al
  db 0x00, 0x00                ; 00001FE8  add [bx+si],al
  db 0x00, 0x00                ; 00001FEA  add [bx+si],al
  db 0x00, 0x00                ; 00001FEC  add [bx+si],al
  db 0x00, 0x00                ; 00001FEE  add [bx+si],al
  db 0x00, 0x00                ; 00001FF0  add [bx+si],al
  db 0x00, 0x00                ; 00001FF2  add [bx+si],al
  db 0x00, 0x00                ; 00001FF4  add [bx+si],al
  db 0x00, 0x00                ; 00001FF6  add [bx+si],al
  db 0x00, 0x00                ; 00001FF8  add [bx+si],al
  db 0x00, 0x00                ; 00001FFA  add [bx+si],al
  db 0x00, 0x00                ; 00001FFC  add [bx+si],al
  db 0x00, 0x00                ; 00001FFE  add [bx+si],al
  db 0x00, 0x00                ; 00002000  add [bx+si],al
  db 0x00, 0x00                ; 00002002  add [bx+si],al
  db 0x00, 0x00                ; 00002004  add [bx+si],al
  db 0x00, 0x00                ; 00002006  add [bx+si],al
  db 0x00, 0x00                ; 00002008  add [bx+si],al
  db 0x00, 0x00                ; 0000200A  add [bx+si],al
  db 0x00, 0x00                ; 0000200C  add [bx+si],al
  db 0x00, 0x00                ; 0000200E  add [bx+si],al
  db 0x00, 0x00                ; 00002010  add [bx+si],al
  db 0x00, 0x00                ; 00002012  add [bx+si],al
  db 0x00, 0x00                ; 00002014  add [bx+si],al
  db 0x00, 0x00                ; 00002016  add [bx+si],al
  db 0x00, 0x00                ; 00002018  add [bx+si],al
  db 0x00, 0x00                ; 0000201A  add [bx+si],al
  db 0x00, 0x00                ; 0000201C  add [bx+si],al
  db 0x00, 0x00                ; 0000201E  add [bx+si],al
  db 0x00, 0x00                ; 00002020  add [bx+si],al
  db 0x00, 0x00                ; 00002022  add [bx+si],al
  db 0x00, 0x00                ; 00002024  add [bx+si],al
  db 0x00, 0x00                ; 00002026  add [bx+si],al
  db 0x00, 0x00                ; 00002028  add [bx+si],al
  db 0x00, 0x00                ; 0000202A  add [bx+si],al
  db 0x00, 0x00                ; 0000202C  add [bx+si],al
  db 0x00, 0x00                ; 0000202E  add [bx+si],al
  db 0x00, 0x00                ; 00002030  add [bx+si],al
  db 0x00, 0x00                ; 00002032  add [bx+si],al
  db 0x00, 0x00                ; 00002034  add [bx+si],al
  db 0x00, 0x00                ; 00002036  add [bx+si],al
  db 0x00, 0x00                ; 00002038  add [bx+si],al
  db 0x00, 0x00                ; 0000203A  add [bx+si],al
  db 0x00, 0x00                ; 0000203C  add [bx+si],al
  db 0x00, 0x00                ; 0000203E  add [bx+si],al
  db 0x00, 0x00                ; 00002040  add [bx+si],al
  db 0x00, 0x00                ; 00002042  add [bx+si],al
  db 0x00, 0x00                ; 00002044  add [bx+si],al
  db 0x00, 0x00                ; 00002046  add [bx+si],al
  db 0x00, 0x00                ; 00002048  add [bx+si],al
  db 0x00, 0x00                ; 0000204A  add [bx+si],al
  db 0x00, 0x00                ; 0000204C  add [bx+si],al
  db 0x00, 0x00                ; 0000204E  add [bx+si],al
  db 0x00, 0x00                ; 00002050  add [bx+si],al
  db 0x00, 0x00                ; 00002052  add [bx+si],al
  db 0x00, 0x00                ; 00002054  add [bx+si],al
  db 0x00, 0x00                ; 00002056  add [bx+si],al
  db 0x00, 0x00                ; 00002058  add [bx+si],al
  db 0x00, 0x00                ; 0000205A  add [bx+si],al
  db 0x00, 0x00                ; 0000205C  add [bx+si],al
  db 0x00, 0x00                ; 0000205E  add [bx+si],al
  db 0x00, 0x00                ; 00002060  add [bx+si],al
  db 0x00, 0x00                ; 00002062  add [bx+si],al
  db 0x00, 0x00                ; 00002064  add [bx+si],al
  db 0x00, 0x00                ; 00002066  add [bx+si],al
  db 0x00, 0x00                ; 00002068  add [bx+si],al
  db 0x00, 0x00                ; 0000206A  add [bx+si],al
  db 0x00, 0x00                ; 0000206C  add [bx+si],al
  db 0x00, 0x00                ; 0000206E  add [bx+si],al
  db 0x00, 0x00                ; 00002070  add [bx+si],al
  db 0x00, 0x00                ; 00002072  add [bx+si],al
  db 0x00, 0x00                ; 00002074  add [bx+si],al
  db 0x00, 0x00                ; 00002076  add [bx+si],al
  db 0x00, 0x00                ; 00002078  add [bx+si],al
  db 0x00, 0x00                ; 0000207A  add [bx+si],al
  db 0x00, 0x00                ; 0000207C  add [bx+si],al
  db 0x00, 0x00                ; 0000207E  add [bx+si],al
  db 0x00, 0x00                ; 00002080  add [bx+si],al
  db 0x00, 0x00                ; 00002082  add [bx+si],al
  db 0x00, 0x00                ; 00002084  add [bx+si],al
  db 0x00, 0x00                ; 00002086  add [bx+si],al
  db 0x00, 0x00                ; 00002088  add [bx+si],al
  db 0x00, 0x00                ; 0000208A  add [bx+si],al
  db 0x00, 0x00                ; 0000208C  add [bx+si],al
  db 0x00, 0x00                ; 0000208E  add [bx+si],al
  db 0x00, 0x00                ; 00002090  add [bx+si],al
  db 0x00, 0x00                ; 00002092  add [bx+si],al
  db 0x00, 0x00                ; 00002094  add [bx+si],al
  db 0x00, 0x00                ; 00002096  add [bx+si],al
  db 0x00, 0x00                ; 00002098  add [bx+si],al
  db 0x00, 0x00                ; 0000209A  add [bx+si],al
  db 0x00, 0x00                ; 0000209C  add [bx+si],al
  db 0x00, 0x00                ; 0000209E  add [bx+si],al
  db 0x00, 0x00                ; 000020A0  add [bx+si],al
  db 0x00, 0x00                ; 000020A2  add [bx+si],al
  db 0x00, 0x00                ; 000020A4  add [bx+si],al
  db 0x00, 0x00                ; 000020A6  add [bx+si],al
  db 0x00, 0x00                ; 000020A8  add [bx+si],al
  db 0x00, 0x00                ; 000020AA  add [bx+si],al
  db 0x00, 0x00                ; 000020AC  add [bx+si],al
  db 0x00, 0x00                ; 000020AE  add [bx+si],al
  db 0x00, 0x00                ; 000020B0  add [bx+si],al
  db 0x00, 0x00                ; 000020B2  add [bx+si],al
  db 0x00, 0x00                ; 000020B4  add [bx+si],al
  db 0x00, 0x00                ; 000020B6  add [bx+si],al
  db 0x00, 0x00                ; 000020B8  add [bx+si],al
  db 0x00, 0x00                ; 000020BA  add [bx+si],al
  db 0x00, 0x00                ; 000020BC  add [bx+si],al
  db 0x00, 0x00                ; 000020BE  add [bx+si],al
  db 0x00, 0x00                ; 000020C0  add [bx+si],al
  db 0x00, 0x00                ; 000020C2  add [bx+si],al
  db 0x00, 0x00                ; 000020C4  add [bx+si],al
  db 0x00, 0x00                ; 000020C6  add [bx+si],al
  db 0x00, 0x00                ; 000020C8  add [bx+si],al
  db 0x00, 0x00                ; 000020CA  add [bx+si],al
  db 0x00, 0x00                ; 000020CC  add [bx+si],al
  db 0x00, 0x00                ; 000020CE  add [bx+si],al
  db 0x00, 0x00                ; 000020D0  add [bx+si],al
  db 0x00, 0x00                ; 000020D2  add [bx+si],al
  db 0x00, 0x00                ; 000020D4  add [bx+si],al
  db 0x00, 0x00                ; 000020D6  add [bx+si],al
  db 0x00, 0x00                ; 000020D8  add [bx+si],al
  db 0x00, 0x00                ; 000020DA  add [bx+si],al
  db 0x00, 0x00                ; 000020DC  add [bx+si],al
  db 0x00, 0x00                ; 000020DE  add [bx+si],al
  db 0x00, 0x00                ; 000020E0  add [bx+si],al
  db 0x00, 0x00                ; 000020E2  add [bx+si],al
  db 0x00, 0x00                ; 000020E4  add [bx+si],al
  db 0x00, 0x00                ; 000020E6  add [bx+si],al
  db 0x00, 0x00                ; 000020E8  add [bx+si],al
  db 0x00, 0x00                ; 000020EA  add [bx+si],al
  db 0x00, 0x00                ; 000020EC  add [bx+si],al
  db 0x00, 0x00                ; 000020EE  add [bx+si],al
  db 0x00, 0x00                ; 000020F0  add [bx+si],al
  db 0x00, 0x00                ; 000020F2  add [bx+si],al
  db 0x00, 0x00                ; 000020F4  add [bx+si],al
  db 0x00, 0x00                ; 000020F6  add [bx+si],al
  db 0x00, 0x00                ; 000020F8  add [bx+si],al
  db 0x00, 0x00                ; 000020FA  add [bx+si],al
  db 0x00, 0x00                ; 000020FC  add [bx+si],al
  db 0x00, 0x00                ; 000020FE  add [bx+si],al
  db 0x00, 0x00                ; 00002100  add [bx+si],al
  db 0x00, 0x00                ; 00002102  add [bx+si],al
  db 0x00, 0x00                ; 00002104  add [bx+si],al
  db 0x00, 0x00                ; 00002106  add [bx+si],al
  db 0x00, 0x00                ; 00002108  add [bx+si],al
  db 0x00, 0x00                ; 0000210A  add [bx+si],al
  db 0x00, 0x00                ; 0000210C  add [bx+si],al
  db 0x00, 0x00                ; 0000210E  add [bx+si],al
  db 0x00, 0x00                ; 00002110  add [bx+si],al
  db 0x00, 0x00                ; 00002112  add [bx+si],al
  db 0x00, 0x00                ; 00002114  add [bx+si],al
  db 0x00, 0x00                ; 00002116  add [bx+si],al
  db 0x00, 0x00                ; 00002118  add [bx+si],al
  db 0x00, 0x00                ; 0000211A  add [bx+si],al
  db 0x00, 0x00                ; 0000211C  add [bx+si],al
  db 0x00, 0x00                ; 0000211E  add [bx+si],al
  db 0x00, 0x00                ; 00002120  add [bx+si],al
  db 0x00, 0x00                ; 00002122  add [bx+si],al
  db 0x00, 0x00                ; 00002124  add [bx+si],al
  db 0x00, 0x00                ; 00002126  add [bx+si],al
  db 0x00, 0x00                ; 00002128  add [bx+si],al
  db 0x00, 0x00                ; 0000212A  add [bx+si],al
  db 0x00, 0x00                ; 0000212C  add [bx+si],al
  db 0x00, 0x00                ; 0000212E  add [bx+si],al
  db 0x00, 0x00                ; 00002130  add [bx+si],al
  db 0x00, 0x00                ; 00002132  add [bx+si],al
  db 0x00, 0x00                ; 00002134  add [bx+si],al
  db 0x00, 0x00                ; 00002136  add [bx+si],al
  db 0x00, 0x00                ; 00002138  add [bx+si],al
  db 0x00, 0x00                ; 0000213A  add [bx+si],al
  db 0x00, 0x00                ; 0000213C  add [bx+si],al
  db 0x00, 0x00                ; 0000213E  add [bx+si],al
  db 0x00, 0x00                ; 00002140  add [bx+si],al
  db 0x00, 0x00                ; 00002142  add [bx+si],al
  db 0x00, 0x00                ; 00002144  add [bx+si],al
  db 0x00, 0x00                ; 00002146  add [bx+si],al
  db 0x00, 0x00                ; 00002148  add [bx+si],al
  db 0x00, 0x00                ; 0000214A  add [bx+si],al
  db 0x00, 0x00                ; 0000214C  add [bx+si],al
  db 0x00, 0x00                ; 0000214E  add [bx+si],al
  db 0x00, 0x00                ; 00002150  add [bx+si],al
  db 0x00, 0x00                ; 00002152  add [bx+si],al
  db 0x00, 0x00                ; 00002154  add [bx+si],al
  db 0x00, 0x00                ; 00002156  add [bx+si],al
  db 0x00, 0x00                ; 00002158  add [bx+si],al
  db 0x00, 0x00                ; 0000215A  add [bx+si],al
  db 0x00, 0x00                ; 0000215C  add [bx+si],al
  db 0x00, 0x00                ; 0000215E  add [bx+si],al
  db 0x00, 0x00                ; 00002160  add [bx+si],al
  db 0x00, 0x00                ; 00002162  add [bx+si],al
  db 0x00, 0x00                ; 00002164  add [bx+si],al
  db 0x00, 0x00                ; 00002166  add [bx+si],al
  db 0x00, 0x00                ; 00002168  add [bx+si],al
  db 0x00, 0x00                ; 0000216A  add [bx+si],al
  db 0x00, 0x00                ; 0000216C  add [bx+si],al
  db 0x00, 0x00                ; 0000216E  add [bx+si],al
  db 0x00, 0x00                ; 00002170  add [bx+si],al
  db 0x00, 0x00                ; 00002172  add [bx+si],al
  db 0x00, 0x00                ; 00002174  add [bx+si],al
  db 0x00, 0x00                ; 00002176  add [bx+si],al
  db 0x00, 0x00                ; 00002178  add [bx+si],al
  db 0x00, 0x00                ; 0000217A  add [bx+si],al
  db 0x00, 0x00                ; 0000217C  add [bx+si],al
  db 0x00, 0x00                ; 0000217E  add [bx+si],al
  db 0x00, 0x00                ; 00002180  add [bx+si],al
  db 0x00, 0x00                ; 00002182  add [bx+si],al
  db 0x00, 0x00                ; 00002184  add [bx+si],al
  db 0x00, 0x00                ; 00002186  add [bx+si],al
  db 0x00, 0x00                ; 00002188  add [bx+si],al
  db 0x00, 0x00                ; 0000218A  add [bx+si],al
  db 0x00, 0x00                ; 0000218C  add [bx+si],al
  db 0x00, 0x00                ; 0000218E  add [bx+si],al
  db 0x00, 0x00                ; 00002190  add [bx+si],al
  db 0x00, 0x00                ; 00002192  add [bx+si],al
  db 0x00, 0x00                ; 00002194  add [bx+si],al
  db 0x00, 0x00                ; 00002196  add [bx+si],al
  db 0x00, 0x00                ; 00002198  add [bx+si],al
  db 0x00, 0x00                ; 0000219A  add [bx+si],al
  db 0x00, 0x00                ; 0000219C  add [bx+si],al
  db 0x00, 0x00                ; 0000219E  add [bx+si],al
  db 0x00, 0x00                ; 000021A0  add [bx+si],al
  db 0x00, 0x00                ; 000021A2  add [bx+si],al
  db 0x00, 0x00                ; 000021A4  add [bx+si],al
  db 0x00, 0x00                ; 000021A6  add [bx+si],al
  db 0x00, 0x00                ; 000021A8  add [bx+si],al
  db 0x00, 0x00                ; 000021AA  add [bx+si],al
  db 0x00, 0x00                ; 000021AC  add [bx+si],al
  db 0x00, 0x00                ; 000021AE  add [bx+si],al
  db 0x00, 0x00                ; 000021B0  add [bx+si],al
  db 0x00, 0x00                ; 000021B2  add [bx+si],al
  db 0x00, 0x00                ; 000021B4  add [bx+si],al
  db 0x00, 0x00                ; 000021B6  add [bx+si],al
  db 0x00, 0x00                ; 000021B8  add [bx+si],al
  db 0x00, 0x00                ; 000021BA  add [bx+si],al
  db 0x00, 0x00                ; 000021BC  add [bx+si],al
  db 0x00, 0x00                ; 000021BE  add [bx+si],al
  db 0x00, 0x00                ; 000021C0  add [bx+si],al
  db 0x00, 0x00                ; 000021C2  add [bx+si],al
  db 0x00, 0x00                ; 000021C4  add [bx+si],al
  db 0x00, 0x00                ; 000021C6  add [bx+si],al
  db 0x00, 0x00                ; 000021C8  add [bx+si],al
  db 0x00, 0x00                ; 000021CA  add [bx+si],al
  db 0x00, 0x00                ; 000021CC  add [bx+si],al
  db 0x00, 0x00                ; 000021CE  add [bx+si],al
  db 0x00, 0x00                ; 000021D0  add [bx+si],al
  db 0x00, 0x00                ; 000021D2  add [bx+si],al
  db 0x00, 0x00                ; 000021D4  add [bx+si],al
  db 0x00, 0x00                ; 000021D6  add [bx+si],al
  db 0x00, 0x00                ; 000021D8  add [bx+si],al
  db 0x00, 0x00                ; 000021DA  add [bx+si],al
  db 0x00, 0x00                ; 000021DC  add [bx+si],al
  db 0x00, 0x00                ; 000021DE  add [bx+si],al
  db 0x00, 0x00                ; 000021E0  add [bx+si],al
  db 0x00, 0x00                ; 000021E2  add [bx+si],al
  db 0x00, 0x00                ; 000021E4  add [bx+si],al
  db 0x00, 0x00                ; 000021E6  add [bx+si],al
  db 0x00, 0x00                ; 000021E8  add [bx+si],al
  db 0x00, 0x00                ; 000021EA  add [bx+si],al
  db 0x00, 0x00                ; 000021EC  add [bx+si],al
  db 0x00, 0x00                ; 000021EE  add [bx+si],al
  db 0x00, 0x00                ; 000021F0  add [bx+si],al
  db 0x00, 0x00                ; 000021F2  add [bx+si],al
  db 0x00, 0x00                ; 000021F4  add [bx+si],al
  db 0x00, 0x00                ; 000021F6  add [bx+si],al
  db 0x00, 0x00                ; 000021F8  add [bx+si],al
  db 0x00, 0x00                ; 000021FA  add [bx+si],al
  db 0x00, 0x00                ; 000021FC  add [bx+si],al
  db 0x00, 0x00                ; 000021FE  add [bx+si],al
  db 0x00, 0x00                ; 00002200  add [bx+si],al
  db 0x00, 0x00                ; 00002202  add [bx+si],al
  db 0x00, 0x00                ; 00002204  add [bx+si],al
  db 0x00, 0x00                ; 00002206  add [bx+si],al
  db 0x00, 0x00                ; 00002208  add [bx+si],al
  db 0x00, 0x00                ; 0000220A  add [bx+si],al
  db 0x00, 0x00                ; 0000220C  add [bx+si],al
  db 0x00, 0x00                ; 0000220E  add [bx+si],al
  db 0x00, 0x00                ; 00002210  add [bx+si],al
  db 0x00, 0x00                ; 00002212  add [bx+si],al
  db 0x00, 0x00                ; 00002214  add [bx+si],al
  db 0x00, 0x00                ; 00002216  add [bx+si],al
  db 0x00, 0x00                ; 00002218  add [bx+si],al
  db 0x00, 0x00                ; 0000221A  add [bx+si],al
  db 0x00, 0x00                ; 0000221C  add [bx+si],al
  db 0x00, 0x00                ; 0000221E  add [bx+si],al
  db 0x00, 0x00                ; 00002220  add [bx+si],al
  db 0x00, 0x00                ; 00002222  add [bx+si],al
  db 0x00, 0x00                ; 00002224  add [bx+si],al
  db 0x00, 0x00                ; 00002226  add [bx+si],al
  db 0x00, 0x00                ; 00002228  add [bx+si],al
  db 0x00, 0x00                ; 0000222A  add [bx+si],al
  db 0x00, 0x00                ; 0000222C  add [bx+si],al
  db 0x00, 0x00                ; 0000222E  add [bx+si],al
  db 0x00, 0x00                ; 00002230  add [bx+si],al
  db 0x00, 0x00                ; 00002232  add [bx+si],al
  db 0x00, 0x00                ; 00002234  add [bx+si],al
  db 0x00, 0x00                ; 00002236  add [bx+si],al
  db 0x00, 0x00                ; 00002238  add [bx+si],al
  db 0x00, 0x00                ; 0000223A  add [bx+si],al
  db 0x00, 0x00                ; 0000223C  add [bx+si],al
  db 0x00, 0x00                ; 0000223E  add [bx+si],al
  db 0x00, 0x00                ; 00002240  add [bx+si],al
  db 0x00, 0x00                ; 00002242  add [bx+si],al
  db 0x00, 0x00                ; 00002244  add [bx+si],al
  db 0x00, 0x00                ; 00002246  add [bx+si],al
  db 0x00, 0x00                ; 00002248  add [bx+si],al
  db 0x00, 0x00                ; 0000224A  add [bx+si],al
  db 0x00, 0x00                ; 0000224C  add [bx+si],al
  db 0x00, 0x00                ; 0000224E  add [bx+si],al
  db 0x00, 0x00                ; 00002250  add [bx+si],al
  db 0x00, 0x00                ; 00002252  add [bx+si],al
  db 0x00, 0x00                ; 00002254  add [bx+si],al
  db 0x00, 0x00                ; 00002256  add [bx+si],al
  db 0x00, 0x00                ; 00002258  add [bx+si],al
  db 0x00, 0x00                ; 0000225A  add [bx+si],al
  db 0x00, 0x00                ; 0000225C  add [bx+si],al
  db 0x00, 0x00                ; 0000225E  add [bx+si],al
  db 0x00, 0x00                ; 00002260  add [bx+si],al
  db 0x00, 0x00                ; 00002262  add [bx+si],al
  db 0x00, 0x00                ; 00002264  add [bx+si],al
  db 0x00, 0x00                ; 00002266  add [bx+si],al
  db 0x00, 0x00                ; 00002268  add [bx+si],al
  db 0x00, 0x00                ; 0000226A  add [bx+si],al
  db 0x00, 0x00                ; 0000226C  add [bx+si],al
  db 0x00, 0x00                ; 0000226E  add [bx+si],al
  db 0x00, 0x00                ; 00002270  add [bx+si],al
  db 0x00, 0x00                ; 00002272  add [bx+si],al
  db 0x00, 0x00                ; 00002274  add [bx+si],al
  db 0x00, 0x00                ; 00002276  add [bx+si],al
  db 0x00, 0x00                ; 00002278  add [bx+si],al
  db 0x00, 0x00                ; 0000227A  add [bx+si],al
  db 0x00, 0x00                ; 0000227C  add [bx+si],al
  db 0x00, 0x00                ; 0000227E  add [bx+si],al
  db 0x00, 0x00                ; 00002280  add [bx+si],al
  db 0x00, 0x00                ; 00002282  add [bx+si],al
  db 0x00, 0x00                ; 00002284  add [bx+si],al
  db 0x00, 0x00                ; 00002286  add [bx+si],al
  db 0x00, 0x00                ; 00002288  add [bx+si],al
  db 0x00, 0x00                ; 0000228A  add [bx+si],al
  db 0x00, 0x00                ; 0000228C  add [bx+si],al
  db 0x00, 0x00                ; 0000228E  add [bx+si],al
  db 0x00, 0x00                ; 00002290  add [bx+si],al
  db 0x00, 0x00                ; 00002292  add [bx+si],al
  db 0x00, 0x00                ; 00002294  add [bx+si],al
  db 0x00, 0x00                ; 00002296  add [bx+si],al
  db 0x00, 0x00                ; 00002298  add [bx+si],al
  db 0x00, 0x00                ; 0000229A  add [bx+si],al
  db 0x00, 0x00                ; 0000229C  add [bx+si],al
  db 0x00, 0x00                ; 0000229E  add [bx+si],al
  db 0x00, 0x00                ; 000022A0  add [bx+si],al
  db 0x00, 0x00                ; 000022A2  add [bx+si],al
  db 0x00, 0x00                ; 000022A4  add [bx+si],al
  db 0x00, 0x00                ; 000022A6  add [bx+si],al
  db 0x00, 0x00                ; 000022A8  add [bx+si],al
  db 0x00, 0x00                ; 000022AA  add [bx+si],al
  db 0x00, 0x00                ; 000022AC  add [bx+si],al
  db 0x00, 0x00                ; 000022AE  add [bx+si],al
  db 0x00, 0x00                ; 000022B0  add [bx+si],al
  db 0x00, 0x00                ; 000022B2  add [bx+si],al
  db 0x00, 0x00                ; 000022B4  add [bx+si],al
  db 0x00, 0x00                ; 000022B6  add [bx+si],al
  db 0x00, 0x00                ; 000022B8  add [bx+si],al
  db 0x00, 0x00                ; 000022BA  add [bx+si],al
  db 0x00, 0x00                ; 000022BC  add [bx+si],al
  db 0x00, 0x00                ; 000022BE  add [bx+si],al
  db 0x00, 0x00                ; 000022C0  add [bx+si],al
  db 0x00, 0x00                ; 000022C2  add [bx+si],al
  db 0x00, 0x00                ; 000022C4  add [bx+si],al
  db 0x00, 0x00                ; 000022C6  add [bx+si],al
  db 0x00, 0x00                ; 000022C8  add [bx+si],al
  db 0x00, 0x00                ; 000022CA  add [bx+si],al
  db 0x00, 0x00                ; 000022CC  add [bx+si],al
  db 0x00, 0x00                ; 000022CE  add [bx+si],al
  db 0x00, 0x00                ; 000022D0  add [bx+si],al
  db 0x00, 0x00                ; 000022D2  add [bx+si],al
  db 0x00, 0x00                ; 000022D4  add [bx+si],al
  db 0x00, 0x00                ; 000022D6  add [bx+si],al
  db 0x00, 0x00                ; 000022D8  add [bx+si],al
  db 0x00, 0x00                ; 000022DA  add [bx+si],al
  db 0x00, 0x00                ; 000022DC  add [bx+si],al
  db 0x00, 0x00                ; 000022DE  add [bx+si],al
  db 0x00, 0x00                ; 000022E0  add [bx+si],al
  db 0x00, 0x00                ; 000022E2  add [bx+si],al
  db 0x00, 0x00                ; 000022E4  add [bx+si],al
  db 0x00, 0x00                ; 000022E6  add [bx+si],al
  db 0x00, 0x00                ; 000022E8  add [bx+si],al
  db 0x00, 0x00                ; 000022EA  add [bx+si],al
  db 0x00, 0x00                ; 000022EC  add [bx+si],al
  db 0x00, 0x00                ; 000022EE  add [bx+si],al
  db 0x00, 0x00                ; 000022F0  add [bx+si],al
  db 0x00, 0x00                ; 000022F2  add [bx+si],al
  db 0x00, 0x00                ; 000022F4  add [bx+si],al
  db 0x00, 0x00                ; 000022F6  add [bx+si],al
  db 0x00, 0x00                ; 000022F8  add [bx+si],al
  db 0x00, 0x00                ; 000022FA  add [bx+si],al
  db 0x00, 0x00                ; 000022FC  add [bx+si],al
  db 0x00, 0x00                ; 000022FE  add [bx+si],al
  db 0x00, 0x00                ; 00002300  add [bx+si],al
  db 0x00, 0x00                ; 00002302  add [bx+si],al
  db 0x00, 0x00                ; 00002304  add [bx+si],al
  db 0x00, 0x00                ; 00002306  add [bx+si],al
  db 0x00, 0x00                ; 00002308  add [bx+si],al
  db 0x00, 0x00                ; 0000230A  add [bx+si],al
  db 0x00, 0x00                ; 0000230C  add [bx+si],al
  db 0x00, 0x00                ; 0000230E  add [bx+si],al
  db 0x00, 0x00                ; 00002310  add [bx+si],al
  db 0x00, 0x00                ; 00002312  add [bx+si],al
  db 0x00, 0x00                ; 00002314  add [bx+si],al
  db 0x00, 0x00                ; 00002316  add [bx+si],al
  db 0x00, 0x00                ; 00002318  add [bx+si],al
  db 0x00, 0x00                ; 0000231A  add [bx+si],al
  db 0x00, 0x00                ; 0000231C  add [bx+si],al
  db 0x00, 0x00                ; 0000231E  add [bx+si],al
  db 0x00, 0x00                ; 00002320  add [bx+si],al
  db 0x00, 0x00                ; 00002322  add [bx+si],al
  db 0x00, 0x00                ; 00002324  add [bx+si],al
  db 0x00, 0x00                ; 00002326  add [bx+si],al
  db 0x00, 0x00                ; 00002328  add [bx+si],al
  db 0x00, 0x00                ; 0000232A  add [bx+si],al
  db 0x00, 0x00                ; 0000232C  add [bx+si],al
  db 0x00, 0x00                ; 0000232E  add [bx+si],al
  db 0x00, 0x00                ; 00002330  add [bx+si],al
  db 0x00, 0x00                ; 00002332  add [bx+si],al
  db 0x00, 0x00                ; 00002334  add [bx+si],al
  db 0x00, 0x00                ; 00002336  add [bx+si],al
  db 0x00, 0x00                ; 00002338  add [bx+si],al
  db 0x00, 0x00                ; 0000233A  add [bx+si],al
  db 0x00, 0x00                ; 0000233C  add [bx+si],al
  db 0x00, 0x00                ; 0000233E  add [bx+si],al
  db 0x00, 0x00                ; 00002340  add [bx+si],al
  db 0x00, 0x00                ; 00002342  add [bx+si],al
  db 0x00, 0x00                ; 00002344  add [bx+si],al
  db 0x00, 0x00                ; 00002346  add [bx+si],al
  db 0x00, 0x00                ; 00002348  add [bx+si],al
  db 0x00, 0x00                ; 0000234A  add [bx+si],al
  db 0x00, 0x00                ; 0000234C  add [bx+si],al
  db 0x00, 0x00                ; 0000234E  add [bx+si],al
  db 0x00, 0x00                ; 00002350  add [bx+si],al
  db 0x00, 0x00                ; 00002352  add [bx+si],al
  db 0x00, 0x00                ; 00002354  add [bx+si],al
  db 0x00, 0x00                ; 00002356  add [bx+si],al
  db 0x00, 0x00                ; 00002358  add [bx+si],al
  db 0x00, 0x00                ; 0000235A  add [bx+si],al
  db 0x00, 0x00                ; 0000235C  add [bx+si],al
  db 0x00, 0x00                ; 0000235E  add [bx+si],al
  db 0x00, 0x00                ; 00002360  add [bx+si],al
  db 0x00, 0x00                ; 00002362  add [bx+si],al
  db 0x00, 0x00                ; 00002364  add [bx+si],al
  db 0x00, 0x00                ; 00002366  add [bx+si],al
  db 0x00, 0x00                ; 00002368  add [bx+si],al
  db 0x00, 0x00                ; 0000236A  add [bx+si],al
  db 0x00, 0x00                ; 0000236C  add [bx+si],al
  db 0x00, 0x00                ; 0000236E  add [bx+si],al
  db 0x00, 0x00                ; 00002370  add [bx+si],al
  db 0x00, 0x00                ; 00002372  add [bx+si],al
  db 0x00, 0x00                ; 00002374  add [bx+si],al
  db 0x00, 0x00                ; 00002376  add [bx+si],al
  db 0x00, 0x00                ; 00002378  add [bx+si],al
  db 0x00, 0x00                ; 0000237A  add [bx+si],al
  db 0x00, 0x00                ; 0000237C  add [bx+si],al
  db 0x00, 0x00                ; 0000237E  add [bx+si],al
  db 0x00, 0x00                ; 00002380  add [bx+si],al
  db 0x00, 0x00                ; 00002382  add [bx+si],al
  db 0x00, 0x00                ; 00002384  add [bx+si],al
  db 0x00, 0x00                ; 00002386  add [bx+si],al
  db 0x00, 0x00                ; 00002388  add [bx+si],al
  db 0x00, 0x00                ; 0000238A  add [bx+si],al
  db 0x00, 0x00                ; 0000238C  add [bx+si],al
  db 0x00, 0x00                ; 0000238E  add [bx+si],al
  db 0x00, 0x00                ; 00002390  add [bx+si],al
  db 0x00, 0x00                ; 00002392  add [bx+si],al
  db 0x00, 0x00                ; 00002394  add [bx+si],al
  db 0x00, 0x00                ; 00002396  add [bx+si],al
  db 0x00, 0x00                ; 00002398  add [bx+si],al
  db 0x00, 0x00                ; 0000239A  add [bx+si],al
  db 0x00, 0x00                ; 0000239C  add [bx+si],al
  db 0x00, 0x00                ; 0000239E  add [bx+si],al
  db 0x00, 0x00                ; 000023A0  add [bx+si],al
  db 0x00, 0x00                ; 000023A2  add [bx+si],al
  db 0x00, 0x00                ; 000023A4  add [bx+si],al
  db 0x00, 0x00                ; 000023A6  add [bx+si],al
  db 0x00, 0x00                ; 000023A8  add [bx+si],al
  db 0x00, 0x00                ; 000023AA  add [bx+si],al
  db 0x00, 0x00                ; 000023AC  add [bx+si],al
  db 0x00, 0x00                ; 000023AE  add [bx+si],al
  db 0x00, 0x00                ; 000023B0  add [bx+si],al
  db 0x00, 0x00                ; 000023B2  add [bx+si],al
  db 0x00, 0x00                ; 000023B4  add [bx+si],al
  db 0x00, 0x00                ; 000023B6  add [bx+si],al
  db 0x00, 0x00                ; 000023B8  add [bx+si],al
  db 0x00, 0x00                ; 000023BA  add [bx+si],al
  db 0x00, 0x00                ; 000023BC  add [bx+si],al
  db 0x00, 0x00                ; 000023BE  add [bx+si],al
  db 0x00, 0x00                ; 000023C0  add [bx+si],al
  db 0x00, 0x00                ; 000023C2  add [bx+si],al
  db 0x00, 0x00                ; 000023C4  add [bx+si],al
  db 0x00, 0x00                ; 000023C6  add [bx+si],al
  db 0x00, 0x00                ; 000023C8  add [bx+si],al
  db 0x00, 0x00                ; 000023CA  add [bx+si],al
  db 0x00, 0x00                ; 000023CC  add [bx+si],al
  db 0x00, 0x00                ; 000023CE  add [bx+si],al
  db 0x00, 0x00                ; 000023D0  add [bx+si],al
  db 0x00, 0x00                ; 000023D2  add [bx+si],al
  db 0x00, 0x00                ; 000023D4  add [bx+si],al
  db 0x00, 0x00                ; 000023D6  add [bx+si],al
  db 0x00, 0x00                ; 000023D8  add [bx+si],al
  db 0x00, 0x00                ; 000023DA  add [bx+si],al
  db 0x00, 0x00                ; 000023DC  add [bx+si],al
  db 0x00, 0x00                ; 000023DE  add [bx+si],al
  db 0x00, 0x00                ; 000023E0  add [bx+si],al
  db 0x00, 0x00                ; 000023E2  add [bx+si],al
  db 0x00, 0x00                ; 000023E4  add [bx+si],al
  db 0x00, 0x00                ; 000023E6  add [bx+si],al
  db 0xFA                      ; 000023E8  cli
  db 0x23, 0xFF                ; 000023E9  and di,di
  db 0xFF, 0x00                ; 000023EB  inc word [bx+si]
  db 0x00, 0x00                ; 000023ED  add [bx+si],al
  db 0x00, 0x00                ; 000023EF  add [bx+si],al
  db 0x00, 0x00                ; 000023F1  add [bx+si],al
  db 0x00, 0x00                ; 000023F3  add [bx+si],al
  db 0x00, 0x00                ; 000023F5  add [bx+si],al
  db 0x00, 0x00                ; 000023F7  add [bx+si],al
  db 0x00, 0x00                ; 000023F9  add [bx+si],al
  db 0x00, 0x00                ; 000023FB  add [bx+si],al
  db 0x00, 0x10                ; 000023FD  add [bx+si],dl
  db 0x24, 0xFF                ; 000023FF  and al,0xff
  db 0xFF, 0x00                ; 00002401  inc word [bx+si]
  db 0x00, 0x00                ; 00002403  add [bx+si],al
  db 0x00, 0x00                ; 00002405  add [bx+si],al
  db 0x00, 0x00                ; 00002407  add [bx+si],al
  db 0x00, 0x00                ; 00002409  add [bx+si],al
  db 0x00, 0x00                ; 0000240B  add [bx+si],al
  db 0x00, 0x00                ; 0000240D  add [bx+si],al
  db 0x00, 0x00                ; 0000240F  add [bx+si],al
  db 0x00, 0x00                ; 00002411  add [bx+si],al
  db 0x00, 0x26, 0x24, 0xFF    ; 00002413  add [0xff24],ah
  db 0xFF, 0x00                ; 00002417  inc word [bx+si]
  db 0x00, 0x00                ; 00002419  add [bx+si],al
  db 0x00, 0x00                ; 0000241B  add [bx+si],al
  db 0x00, 0x00                ; 0000241D  add [bx+si],al
  db 0x00, 0x00                ; 0000241F  add [bx+si],al
  db 0x00, 0x00                ; 00002421  add [bx+si],al
  db 0x00, 0x00                ; 00002423  add [bx+si],al
  db 0x00, 0x00                ; 00002425  add [bx+si],al
  db 0x00, 0x00                ; 00002427  add [bx+si],al
  db 0x00, 0x3C                ; 00002429  add [si],bh
  db 0x24, 0xFF                ; 0000242B  and al,0xff
  db 0xFF, 0x00                ; 0000242D  inc word [bx+si]
  db 0x00, 0x00                ; 0000242F  add [bx+si],al
  db 0x00, 0x00                ; 00002431  add [bx+si],al
  db 0x00, 0x00                ; 00002433  add [bx+si],al
  db 0x00, 0x00                ; 00002435  add [bx+si],al
  db 0x00, 0x00                ; 00002437  add [bx+si],al
  db 0x00, 0x00                ; 00002439  add [bx+si],al
  db 0x00, 0x00                ; 0000243B  add [bx+si],al
  db 0x00, 0x00                ; 0000243D  add [bx+si],al
  db 0x00, 0x52, 0x24          ; 0000243F  add [bp+si+0x24],dl
  db 0xFF                      ; 00002442  db 0xff
  db 0xFF, 0x00                ; 00002443  inc word [bx+si]
  db 0x00, 0x00                ; 00002445  add [bx+si],al
  db 0x00, 0x00                ; 00002447  add [bx+si],al
  db 0x00, 0x00                ; 00002449  add [bx+si],al
  db 0x00, 0x00                ; 0000244B  add [bx+si],al
  db 0x00, 0x00                ; 0000244D  add [bx+si],al
  db 0x00, 0x00                ; 0000244F  add [bx+si],al
  db 0x00, 0x00                ; 00002451  add [bx+si],al
  db 0x00, 0x00                ; 00002453  add [bx+si],al
  db 0x80, 0x00, 0x00          ; 00002455  add byte [bx+si],0x0
  db 0xFF                      ; 00002458  db 0xff
  db 0xFF, 0x00                ; 00002459  inc word [bx+si]
  db 0x00, 0x00                ; 0000245B  add [bx+si],al
  db 0x00, 0x00                ; 0000245D  add [bx+si],al
  db 0x00, 0x00                ; 0000245F  add [bx+si],al
  db 0x00, 0x00                ; 00002461  add [bx+si],al
  db 0x00, 0x00                ; 00002463  add [bx+si],al
  db 0x00, 0x00                ; 00002465  add [bx+si],al
  db 0x00, 0x00                ; 00002467  add [bx+si],al
  db 0x00, 0x72, 0x24          ; 00002469  add [bp+si+0x24],dh
  db 0x00, 0x00                ; 0000246C  add [bx+si],al
  db 0x00, 0x00                ; 0000246E  add [bx+si],al
  db 0x38, 0x04                ; 00002470  cmp [si],al
  db 0x00, 0x00                ; 00002472  add [bx+si],al
  db 0x7C, 0x24                ; 00002474  jl 0x249a
  db 0x00, 0x00                ; 00002476  add [bx+si],al
  db 0x00, 0x00                ; 00002478  add [bx+si],al
  db 0x38, 0x04                ; 0000247A  cmp [si],al
  db 0x00, 0x00                ; 0000247C  add [bx+si],al
  db 0x86, 0x24                ; 0000247E  xchg ah,[si]
  db 0x00, 0x00                ; 00002480  add [bx+si],al
  db 0x00, 0x00                ; 00002482  add [bx+si],al
  db 0x38, 0x04                ; 00002484  cmp [si],al
  db 0x00, 0x00                ; 00002486  add [bx+si],al
  db 0x90                      ; 00002488  nop
  db 0x24, 0x00                ; 00002489  and al,0x0
  db 0x00, 0x00                ; 0000248B  add [bx+si],al
  db 0x00, 0x38                ; 0000248D  add [bx+si],bh
  db 0x04, 0x00                ; 0000248F  add al,0x0
  db 0x00, 0x9A, 0x24, 0x00    ; 00002491  add [bp+si+0x24],bl
  db 0x00, 0x00                ; 00002495  add [bx+si],al
  db 0x00, 0x38                ; 00002497  add [bx+si],bh
  db 0x04, 0x00                ; 00002499  add al,0x0
  db 0x00, 0x00                ; 0000249B  add [bx+si],al
  db 0x00, 0x00                ; 0000249D  add [bx+si],al
  db 0x00, 0x00                ; 0000249F  add [bx+si],al
  db 0x00, 0x38                ; 000024A1  add [bx+si],bh
  db 0x84, 0xB8, 0x04, 0x00    ; 000024A3  test [bx+si+0x4],bh
  db 0xCD, 0x28                ; 000024A7  int 0x28
  db 0x26, 0x80, 0x7C, 0x0D, 0xFF ; 000024A9  cmp byte [es:si+0xd],0xff
  db 0x74, 0x03                ; 000024AE  jz 0x24b3
  db 0xE9, 0x06, 0x02          ; 000024B0  jmp 0x26b9
  db 0xB1, 0x9A                ; 000024B3  mov cl,0x9a
  db 0xCD, 0xE0                ; 000024B5  int 0xe0
  db 0x2E, 0x8C, 0x06, 0x39, 0x42 ; 000024B7  mov [cs:0x4239],es
  db 0x26, 0x8B, 0x47, 0x38    ; 000024BC  mov ax,[es:bx+0x38]
  db 0x2E, 0xA3, 0x3F, 0x42    ; 000024C0  mov [cs:0x423f],ax
  db 0x26, 0x8B, 0x47, 0x3A    ; 000024C4  mov ax,[es:bx+0x3a]
  db 0x2E, 0xA3, 0x41, 0x42    ; 000024C8  mov [cs:0x4241],ax
  db 0x26, 0x8B, 0x07          ; 000024CC  mov ax,[es:bx]
  db 0x2E, 0xA3, 0x3B, 0x42    ; 000024CF  mov [cs:0x423b],ax
  db 0x26, 0x8B, 0x47, 0x02    ; 000024D3  mov ax,[es:bx+0x2]
  db 0x2E, 0xA3, 0x3D, 0x42    ; 000024D7  mov [cs:0x423d],ax
  db 0x2E, 0x8E, 0x06, 0x43, 0x42 ; 000024DB  mov es,[cs:0x4243]
  db 0x8C, 0xD8                ; 000024E0  mov ax,ds
  db 0x8E, 0xC0                ; 000024E2  mov es,ax
  db 0xBF, 0x45, 0x15          ; 000024E4  mov di,0x1545
  db 0xB9, 0x60, 0x09          ; 000024E7  mov cx,0x960
  db 0x32, 0xC0                ; 000024EA  xor al,al
  db 0xF3, 0xAA                ; 000024EC  rep stosb
  db 0xBB, 0xB0, 0x1F          ; 000024EE  mov bx,0x1fb0
  db 0xBF, 0xA8, 0x1F          ; 000024F1  mov di,0x1fa8
  db 0xE8, 0xEC, 0x01          ; 000024F4  call 0x26e3
  db 0xBB, 0xA4, 0x24          ; 000024F7  mov bx,0x24a4
  db 0xB9, 0x06, 0x00          ; 000024FA  mov cx,0x6
  db 0xBF, 0x68, 0x24          ; 000024FD  mov di,0x2468
  db 0x51                      ; 00002500  push cx
  db 0xE8, 0xDF, 0x01          ; 00002501  call 0x26e3
  db 0x59                      ; 00002504  pop cx
  db 0x83, 0xC7, 0x0A          ; 00002505  add di,byte +0xa
  db 0x81, 0xC3, 0x38, 0x04    ; 00002508  add bx,0x438
  db 0xE2, 0xF2                ; 0000250C  loop 0x2500
  db 0xB8, 0x00, 0x30          ; 0000250E  mov ax,0x3000
  db 0x8E, 0xC0                ; 00002511  mov es,ax
  db 0xBF, 0xF6, 0xFF          ; 00002513  mov di,0xfff6
  db 0x26, 0xC7, 0x05, 0x00, 0x00 ; 00002516  mov word [es:di],0x0
  db 0xB8, 0x00, 0x30          ; 0000251B  mov ax,0x3000
  db 0xBB, 0xE0, 0xFF          ; 0000251E  mov bx,0xffe0
  db 0xB1, 0x04                ; 00002521  mov cl,0x4
  db 0xD3, 0xC0                ; 00002523  rol ax,cl
  db 0x8A, 0xE8                ; 00002525  mov ch,al
  db 0x24, 0xF0                ; 00002527  and al,0xf0
  db 0x03, 0xC3                ; 00002529  add ax,bx
  db 0x80, 0xD5, 0x00          ; 0000252B  adc ch,0x0
  db 0x80, 0xE5, 0x0F          ; 0000252E  and ch,0xf
  db 0x86, 0xE9                ; 00002531  xchg ch,cl
  db 0x32, 0xED                ; 00002533  xor ch,ch
  db 0x26, 0x89, 0x45, 0x06    ; 00002535  mov [es:di+0x6],ax
  db 0x26, 0x89, 0x4D, 0x08    ; 00002539  mov [es:di+0x8],cx
  db 0x1E                      ; 0000253D  push ds
  db 0xB8, 0x00, 0xF0          ; 0000253E  mov ax,0xf000
  db 0x8E, 0xD8                ; 00002541  mov ds,ax
  db 0x2E, 0x8E, 0x06, 0x43, 0x42 ; 00002543  mov es,[cs:0x4243]
  db 0xBF, 0xC2, 0x27          ; 00002548  mov di,0x27c2
  db 0xBE, 0x00, 0x60          ; 0000254B  mov si,0x6000
  db 0xB9, 0x04, 0x00          ; 0000254E  mov cx,0x4
  db 0xF3, 0xA5                ; 00002551  rep movsw
  db 0x8C, 0xD8                ; 00002553  mov ax,ds
  db 0x1F                      ; 00002555  pop ds
  db 0x8E, 0xC0                ; 00002556  mov es,ax
  db 0xBF, 0x00, 0x60          ; 00002558  mov di,0x6000
  db 0x26, 0xC7, 0x05, 0x01, 0x00 ; 0000255B  mov word [es:di],0x1
  db 0x26, 0xC7, 0x45, 0x02, 0x88, 0x1F ; 00002560  mov word [es:di+0x2],0x1f88
  db 0x8C, 0xD8                ; 00002566  mov ax,ds
  db 0xB1, 0x04                ; 00002568  mov cl,0x4
  db 0xD3, 0xE0                ; 0000256A  shl ax,cl
  db 0x26, 0x89, 0x45, 0x04    ; 0000256C  mov [es:di+0x4],ax
  db 0x8C, 0xD8                ; 00002570  mov ax,ds
  db 0xB1, 0x0C                ; 00002572  mov cl,0xc
  db 0xD3, 0xE8                ; 00002574  shr ax,cl
  db 0x26, 0x89, 0x45, 0x06    ; 00002576  mov [es:di+0x6],ax
  db 0xB8, 0x00, 0x30          ; 0000257A  mov ax,0x3000
  db 0x8E, 0xC0                ; 0000257D  mov es,ax
  db 0xBF, 0xE0, 0xFF          ; 0000257F  mov di,0xffe0
  db 0x26, 0xC7, 0x05, 0x01, 0x00 ; 00002582  mov word [es:di],0x1
  db 0x26, 0xC7, 0x45, 0x02, 0x88, 0x1F ; 00002587  mov word [es:di+0x2],0x1f88
  db 0x8C, 0xD8                ; 0000258D  mov ax,ds
  db 0xB1, 0x04                ; 0000258F  mov cl,0x4
  db 0xD3, 0xE0                ; 00002591  shl ax,cl
  db 0x26, 0x89, 0x45, 0x04    ; 00002593  mov [es:di+0x4],ax
  db 0x8C, 0xD8                ; 00002597  mov ax,ds
  db 0xB1, 0x0C                ; 00002599  mov cl,0xc
  db 0xD3, 0xE8                ; 0000259B  shr ax,cl
  db 0x26, 0x89, 0x45, 0x06    ; 0000259D  mov [es:di+0x6],ax
  db 0xFA                      ; 000025A1  cli
  db 0x33, 0xC0                ; 000025A2  xor ax,ax
  db 0x8E, 0xC0                ; 000025A4  mov es,ax
  db 0xB8, 0x38, 0x27          ; 000025A6  mov ax,0x2738
  db 0xBF, 0x94, 0x00          ; 000025A9  mov di,0x94
  db 0xAB                      ; 000025AC  stosw
  db 0x8C, 0xC8                ; 000025AD  mov ax,cs
  db 0xAB                      ; 000025AF  stosw
  db 0xB8, 0x9B, 0x41          ; 000025B0  mov ax,0x419b
  db 0xBF, 0xA4, 0x00          ; 000025B3  mov di,0xa4
  db 0xAB                      ; 000025B6  stosw
  db 0x8C, 0xC8                ; 000025B7  mov ax,cs
  db 0xAB                      ; 000025B9  stosw
  db 0xBA, 0x02, 0x00          ; 000025BA  mov dx,0x2
  db 0xB0, 0x80                ; 000025BD  mov al,0x80
  db 0xEE                      ; 000025BF  out dx,al
  db 0xFB                      ; 000025C0  sti
  db 0x8C, 0xD8                ; 000025C1  mov ax,ds
  db 0x8E, 0xC0                ; 000025C3  mov es,ax
  db 0xBA, 0x00, 0x01          ; 000025C5  mov dx,0x100
  db 0xEC                      ; 000025C8  in al,dx
  db 0x8C, 0xD8                ; 000025C9  mov ax,ds
  db 0x05, 0x04, 0x00          ; 000025CB  add ax,0x4
  db 0x8E, 0xC0                ; 000025CE  mov es,ax
  db 0xBA, 0x16, 0x00          ; 000025D0  mov dx,0x16
  db 0xE8, 0x68, 0x1E          ; 000025D3  call 0x443e
  db 0xBF, 0x00, 0x60          ; 000025D6  mov di,0x6000
  db 0xBE, 0xC2, 0x27          ; 000025D9  mov si,0x27c2
  db 0xB9, 0x04, 0x00          ; 000025DC  mov cx,0x4
  db 0xB8, 0x00, 0xF0          ; 000025DF  mov ax,0xf000
  db 0x8E, 0xC0                ; 000025E2  mov es,ax
  db 0xF3, 0xA5                ; 000025E4  rep movsw
  db 0x8C, 0xD8                ; 000025E6  mov ax,ds
  db 0x8E, 0xC0                ; 000025E8  mov es,ax
  db 0xBF, 0x9E, 0x27          ; 000025EA  mov di,0x279e
  db 0xE8, 0x10, 0x01          ; 000025ED  call 0x2700
  db 0xB8, 0x00, 0x01          ; 000025F0  mov ax,0x100
  db 0xE8, 0x26, 0x1E          ; 000025F3  call 0x441c
  db 0x8C, 0xD8                ; 000025F6  mov ax,ds
  db 0x05, 0x04, 0x00          ; 000025F8  add ax,0x4
  db 0x8E, 0xC0                ; 000025FB  mov es,ax
  db 0xBA, 0x16, 0x00          ; 000025FD  mov dx,0x16
  db 0xE8, 0x3B, 0x1E          ; 00002600  call 0x443e
  db 0xBE, 0x98, 0x27          ; 00002603  mov si,0x2798
  db 0x81, 0x3C, 0x00, 0xA0    ; 00002606  cmp word [si],0xa000
  db 0x74, 0x03                ; 0000260A  jz 0x260f
  db 0xE9, 0xAA, 0x00          ; 0000260C  jmp 0x26b9
  db 0xBE, 0xA4, 0x27          ; 0000260F  mov si,0x27a4
  db 0x81, 0x3C, 0x00, 0xA0    ; 00002612  cmp word [si],0xa000
  db 0x74, 0x03                ; 00002616  jz 0x261b
  db 0xE9, 0x9E, 0x00          ; 00002618  jmp 0x26b9
  db 0xFA                      ; 0000261B  cli
  db 0x33, 0xC0                ; 0000261C  xor ax,ax
  db 0x8E, 0xC0                ; 0000261E  mov es,ax
  db 0xB8, 0x3A, 0x40          ; 00002620  mov ax,0x403a
  db 0xBF, 0x94, 0x00          ; 00002623  mov di,0x94
  db 0xAB                      ; 00002626  stosw
  db 0x8C, 0xC8                ; 00002627  mov ax,cs
  db 0xAB                      ; 00002629  stosw
  db 0xFB                      ; 0000262A  sti
  db 0xB8, 0x20, 0x00          ; 0000262B  mov ax,0x20
  db 0xBA, 0xB9, 0x3F          ; 0000262E  mov dx,0x3fb9
  db 0x8C, 0xC9                ; 00002631  mov cx,cs
  db 0xCD, 0x28                ; 00002633  int 0x28
  db 0xB8, 0x22, 0x00          ; 00002635  mov ax,0x22
  db 0xBA, 0x0D, 0x44          ; 00002638  mov dx,0x440d
  db 0x8C, 0xC9                ; 0000263B  mov cx,cs
  db 0xCD, 0x28                ; 0000263D  int 0x28
  db 0x8C, 0xD8                ; 0000263F  mov ax,ds
  db 0x8E, 0xC0                ; 00002641  mov es,ax
  db 0x2E, 0xC7, 0x06, 0x8C, 0x1F, 0x98, 0x1F ; 00002643  mov word [cs:0x1f8c],0x1f98
  db 0xBE, 0x00, 0x05          ; 0000264A  mov si,0x500
  db 0x8C, 0x4C, 0x50          ; 0000264D  mov [si+0x50],cs
  db 0x8C, 0x5C, 0x52          ; 00002650  mov [si+0x52],ds
  db 0x8C, 0x44, 0x54          ; 00002653  mov [si+0x54],es
  db 0x8C, 0x54, 0x56          ; 00002656  mov [si+0x56],ss
  db 0xBE, 0xA0, 0x02          ; 00002659  mov si,0x2a0
  db 0x8C, 0x4C, 0x50          ; 0000265C  mov [si+0x50],cs
  db 0x8C, 0x5C, 0x52          ; 0000265F  mov [si+0x52],ds
  db 0x8C, 0x44, 0x54          ; 00002662  mov [si+0x54],es
  db 0x8C, 0x54, 0x56          ; 00002665  mov [si+0x56],ss
  db 0xBA, 0x70, 0x02          ; 00002668  mov dx,0x270
  db 0xB1, 0x90                ; 0000266B  mov cl,0x90
  db 0xCD, 0xE0                ; 0000266D  int 0xe0
  db 0x9C                      ; 0000266F  pushf
  db 0xFA                      ; 00002670  cli
  db 0x2E, 0x8B, 0x36, 0x36, 0x15 ; 00002671  mov si,[cs:0x1536]
  db 0x2E, 0x8B, 0x3E, 0x3B, 0x15 ; 00002676  mov di,[cs:0x153b]
  db 0x89, 0x7C, 0x06          ; 0000267B  mov [si+0x6],di
  db 0x2E, 0x89, 0x36, 0x8E, 0x1F ; 0000267E  mov [cs:0x1f8e],si
  db 0x2E, 0xC6, 0x06, 0x35, 0x15, 0x00 ; 00002683  mov byte [cs:0x1535],0x0
  db 0x2E, 0xC7, 0x06, 0x36, 0x15, 0x00, 0x00 ; 00002689  mov word [cs:0x1536],0x0
  db 0x2E, 0xC7, 0x06, 0x38, 0x15, 0x00, 0x00 ; 00002690  mov word [cs:0x1538],0x0
  db 0x2E, 0xC6, 0x06, 0x3A, 0x15, 0x00 ; 00002697  mov byte [cs:0x153a],0x0
  db 0x2E, 0xC7, 0x06, 0x3B, 0x15, 0x00, 0x00 ; 0000269D  mov word [cs:0x153b],0x0
  db 0x2E, 0xC7, 0x06, 0x3D, 0x15, 0x00, 0x00 ; 000026A4  mov word [cs:0x153d],0x0
  db 0x2E, 0xC6, 0x06, 0x34, 0x15, 0x00 ; 000026AB  mov byte [cs:0x1534],0x0
  db 0x9D                      ; 000026B1  popf
  db 0xB8, 0x10, 0x00          ; 000026B2  mov ax,0x10
  db 0xE8, 0x64, 0x1D          ; 000026B5  call 0x441c
  db 0xC3                      ; 000026B8  ret
  db 0xBA, 0xAE, 0x0B          ; 000026B9  mov dx,0xbae
  db 0xB1, 0x87                ; 000026BC  mov cl,0x87
  db 0xCD, 0xE0                ; 000026BE  int 0xe0
  db 0x0B, 0xC0                ; 000026C0  or ax,ax
  db 0x75, 0x07                ; 000026C2  jnz 0x26cb
  db 0xBA, 0xAE, 0x0B          ; 000026C4  mov dx,0xbae
  db 0xB1, 0x88                ; 000026C7  mov cl,0x88
  db 0xCD, 0xE0                ; 000026C9  int 0xe0
  db 0xBA, 0xBE, 0x0B          ; 000026CB  mov dx,0xbbe
  db 0xB1, 0x87                ; 000026CE  mov cl,0x87
  db 0xCD, 0xE0                ; 000026D0  int 0xe0
  db 0x0B, 0xC0                ; 000026D2  or ax,ax
  db 0x75, 0x07                ; 000026D4  jnz 0x26dd
  db 0xBA, 0xBE, 0x0B          ; 000026D6  mov dx,0xbbe
  db 0xB1, 0x88                ; 000026D9  mov cl,0x88
  db 0xCD, 0xE0                ; 000026DB  int 0xe0
  db 0xB1, 0x8F                ; 000026DD  mov cl,0x8f
  db 0xB2, 0xFF                ; 000026DF  mov dl,0xff
  db 0xCD, 0xE0                ; 000026E1  int 0xe0
  db 0x8C, 0xD8                ; 000026E3  mov ax,ds
  db 0xB1, 0x04                ; 000026E5  mov cl,0x4
  db 0xD3, 0xC0                ; 000026E7  rol ax,cl
  db 0x8A, 0xE8                ; 000026E9  mov ch,al
  db 0x24, 0xF0                ; 000026EB  and al,0xf0
  db 0x03, 0xC3                ; 000026ED  add ax,bx
  db 0x80, 0xD5, 0x00          ; 000026EF  adc ch,0x0
  db 0x80, 0xE5, 0x0F          ; 000026F2  and ch,0xf
  db 0x86, 0xE9                ; 000026F5  xchg ch,cl
  db 0x32, 0xED                ; 000026F7  xor ch,ch
  db 0x89, 0x45, 0x04          ; 000026F9  mov [di+0x4],ax
  db 0x89, 0x4D, 0x06          ; 000026FC  mov [di+0x6],cx
  db 0xC3                      ; 000026FF  ret
  db 0x57                      ; 00002700  push di
  db 0xB8, 0x03, 0x00          ; 00002701  mov ax,0x3
  db 0xCD, 0x28                ; 00002704  int 0x28
  db 0x5F                      ; 00002706  pop di
  db 0x26, 0x8B, 0x44, 0x05    ; 00002707  mov ax,[es:si+0x5]
  db 0x26, 0x8B, 0x54, 0x01    ; 0000270B  mov dx,[es:si+0x1]
  db 0xD1, 0xE2                ; 0000270F  shl dx,1
  db 0xF8                      ; 00002711  clc
  db 0xD1, 0xD0                ; 00002712  rcl ax,1
  db 0x73, 0x01                ; 00002714  jnc 0x2717
  db 0x42                      ; 00002716  inc dx
  db 0xBE, 0x32, 0x27          ; 00002717  mov si,0x2732
  db 0x03, 0x04                ; 0000271A  add ax,[si]
  db 0x89, 0x05                ; 0000271C  mov [di],ax
  db 0x13, 0x54, 0x02          ; 0000271E  adc dx,[si+0x2]
  db 0x89, 0x55, 0x02          ; 00002721  mov [di+0x2],dx
  db 0xB8, 0x00, 0x00          ; 00002724  mov ax,0x0
  db 0x13, 0x44, 0x04          ; 00002727  adc ax,[si+0x4]
  db 0x89, 0x45, 0x04          ; 0000272A  mov [di+0x4],ax
  db 0x8C, 0xD8                ; 0000272D  mov ax,ds
  db 0x8E, 0xC0                ; 0000272F  mov es,ax
  db 0xC3                      ; 00002731  ret
  db 0x00, 0x00                ; 00002732  add [bx+si],al
  db 0x00, 0x00                ; 00002734  add [bx+si],al
  db 0x00, 0x00                ; 00002736  add [bx+si],al
  db 0x50                      ; 00002738  push ax
  db 0x2E, 0x8C, 0x16, 0x45, 0x42 ; 00002739  mov [cs:0x4245],ss
  db 0x2E, 0x89, 0x26, 0x47, 0x42 ; 0000273E  mov [cs:0x4247],sp
  db 0xBC, 0xC9, 0x42          ; 00002743  mov sp,0x42c9
  db 0x8C, 0xC8                ; 00002746  mov ax,cs
  db 0x8E, 0xD0                ; 00002748  mov ss,ax
  db 0x60                      ; 0000274A  pusha
  db 0x1E                      ; 0000274B  push ds
  db 0x8E, 0xD8                ; 0000274C  mov ds,ax
  db 0x2E, 0xA1, 0x88, 0x1F    ; 0000274E  mov ax,[cs:0x1f88]
  db 0x25, 0x00, 0xF0          ; 00002752  and ax,0xf000
  db 0x2E, 0xA3, 0x8A, 0x1F    ; 00002755  mov [cs:0x1f8a],ax
  db 0xBA, 0x16, 0x00          ; 00002759  mov dx,0x16
  db 0xE8, 0xF3, 0x1C          ; 0000275C  call 0x4452
  db 0x2E, 0xC6, 0x06, 0x0C, 0x44, 0xFF ; 0000275F  mov byte [cs:0x440c],0xff
  db 0x2E, 0x81, 0x0E, 0x8A, 0x1F, 0x00, 0x00 ; 00002765  or word [cs:0x1f8a],0x0
  db 0xBA, 0x00, 0x01          ; 0000276C  mov dx,0x100
  db 0xEC                      ; 0000276F  in al,dx
  db 0xB0, 0x20                ; 00002770  mov al,0x20
  db 0xE6, 0x00                ; 00002772  out 0x0,al
  db 0xBA, 0x22, 0xFF          ; 00002774  mov dx,0xff22
  db 0xB8, 0x00, 0x80          ; 00002777  mov ax,0x8000
  db 0xEF                      ; 0000277A  out dx,ax
  db 0x1F                      ; 0000277B  pop ds
  db 0x61                      ; 0000277C  popa
  db 0x2E, 0x8B, 0x26, 0x47, 0x42 ; 0000277D  mov sp,[cs:0x4247]
  db 0x2E, 0x8E, 0x16, 0x45, 0x42 ; 00002782  mov ss,[cs:0x4245]
  db 0x58                      ; 00002787  pop ax
  db 0x2E, 0xFF, 0x2E, 0x3F, 0x42 ; 00002788  jmp far [cs:0x423f]
  db 0x00, 0x00                ; 0000278D  add [bx+si],al
  db 0x00, 0x02                ; 0000278F  add [bp+si],al
  db 0x00, 0x98, 0x27, 0x04    ; 00002791  add [bx+si+0x427],bl
  db 0x08, 0x00                ; 00002795  or [bx+si],al
  db 0x66, 0x00, 0x00          ; 00002797  o32 add [bx+si],al
  db 0x01, 0x00                ; 0000279A  add [bx+si],ax
  db 0xA4                      ; 0000279C  movsb
  db 0x27                      ; 0000279D  daa
  db 0x00, 0x00                ; 0000279E  add [bx+si],al
  db 0x00, 0x00                ; 000027A0  add [bx+si],al
  db 0x00, 0x00                ; 000027A2  add [bx+si],al
  db 0x00, 0x00                ; 000027A4  add [bx+si],al
  db 0x03, 0x00                ; 000027A6  add ax,[bx+si]
  db 0xB8, 0x27, 0x0C          ; 000027A8  mov ax,0xc27
  db 0x00, 0x03                ; 000027AB  add [bp+di],al
  db 0x00, 0x00                ; 000027AD  add [bx+si],al
  db 0x00, 0x00                ; 000027AF  add [bx+si],al
  db 0x00, 0x01                ; 000027B1  add [bx+di],al
  db 0x00, 0x00                ; 000027B3  add [bx+si],al
  db 0x00, 0x00                ; 000027B5  add [bx+si],al
  db 0x00, 0x00                ; 000027B7  add [bx+si],al
  db 0x00, 0x02                ; 000027B9  add [bp+si],al
  db 0x80, 0x98, 0x27, 0x04, 0x08 ; 000027BB  sbb byte [bx+si+0x427],0x8
  db 0x00, 0x26, 0x00, 0x00    ; 000027C0  add [0x0],ah
  db 0x00, 0x00                ; 000027C4  add [bx+si],al
  db 0x00, 0x00                ; 000027C6  add [bx+si],al
  db 0x00, 0x00                ; 000027C8  add [bx+si],al
  db 0x00, 0x00                ; 000027CA  add [bx+si],al
  db 0x00, 0x00                ; 000027CC  add [bx+si],al
  db 0x00, 0x00                ; 000027CE  add [bx+si],al
  db 0x00, 0x00                ; 000027D0  add [bx+si],al
  db 0x00, 0x00                ; 000027D2  add [bx+si],al
  db 0x00, 0x00                ; 000027D4  add [bx+si],al
  db 0x00, 0x00                ; 000027D6  add [bx+si],al
  db 0x00, 0x00                ; 000027D8  add [bx+si],al
  db 0x00, 0x00                ; 000027DA  add [bx+si],al
  db 0x00, 0x00                ; 000027DC  add [bx+si],al
  db 0x00, 0x00                ; 000027DE  add [bx+si],al
  db 0x00, 0x00                ; 000027E0  add [bx+si],al
  db 0x00, 0x00                ; 000027E2  add [bx+si],al
  db 0x00, 0x00                ; 000027E4  add [bx+si],al
  db 0x00, 0x00                ; 000027E6  add [bx+si],al
  db 0x00, 0x00                ; 000027E8  add [bx+si],al
  db 0x00, 0x00                ; 000027EA  add [bx+si],al
  db 0x00, 0x00                ; 000027EC  add [bx+si],al
  db 0x00, 0x00                ; 000027EE  add [bx+si],al
  db 0x00, 0x00                ; 000027F0  add [bx+si],al
  db 0x00, 0x00                ; 000027F2  add [bx+si],al
  db 0x00, 0x00                ; 000027F4  add [bx+si],al
  db 0x00, 0x00                ; 000027F6  add [bx+si],al
  db 0x00, 0x00                ; 000027F8  add [bx+si],al
  db 0x00, 0x00                ; 000027FA  add [bx+si],al
  db 0x00, 0x00                ; 000027FC  add [bx+si],al
  db 0x00, 0x00                ; 000027FE  add [bx+si],al
  db 0x00, 0x00                ; 00002800  add [bx+si],al
  db 0x00, 0x00                ; 00002802  add [bx+si],al
  db 0x00, 0x00                ; 00002804  add [bx+si],al
  db 0x00, 0x00                ; 00002806  add [bx+si],al
  db 0x00, 0x00                ; 00002808  add [bx+si],al
  db 0x00, 0x00                ; 0000280A  add [bx+si],al
  db 0x00, 0x00                ; 0000280C  add [bx+si],al
  db 0x00, 0x00                ; 0000280E  add [bx+si],al
  db 0x00, 0x00                ; 00002810  add [bx+si],al
  db 0x00, 0x00                ; 00002812  add [bx+si],al
  db 0x00, 0x00                ; 00002814  add [bx+si],al
  db 0x00, 0x00                ; 00002816  add [bx+si],al
  db 0x00, 0x00                ; 00002818  add [bx+si],al
  db 0x00, 0x00                ; 0000281A  add [bx+si],al
  db 0x00, 0x00                ; 0000281C  add [bx+si],al
  db 0x00, 0x00                ; 0000281E  add [bx+si],al
  db 0x00, 0x00                ; 00002820  add [bx+si],al
  db 0x00, 0x00                ; 00002822  add [bx+si],al
  db 0x00, 0x00                ; 00002824  add [bx+si],al
  db 0x00, 0x00                ; 00002826  add [bx+si],al
  db 0x00, 0x00                ; 00002828  add [bx+si],al
  db 0x00, 0x00                ; 0000282A  add [bx+si],al
  db 0x00, 0x00                ; 0000282C  add [bx+si],al
  db 0x00, 0x00                ; 0000282E  add [bx+si],al
  db 0x00, 0x00                ; 00002830  add [bx+si],al
  db 0x00, 0x00                ; 00002832  add [bx+si],al
  db 0x00, 0x00                ; 00002834  add [bx+si],al
  db 0x00, 0x00                ; 00002836  add [bx+si],al
  db 0x00, 0x00                ; 00002838  add [bx+si],al
  db 0x00, 0x00                ; 0000283A  add [bx+si],al
  db 0x00, 0x00                ; 0000283C  add [bx+si],al
  db 0x00, 0x00                ; 0000283E  add [bx+si],al
  db 0x00, 0x00                ; 00002840  add [bx+si],al
  db 0x00, 0x00                ; 00002842  add [bx+si],al
  db 0x00, 0x00                ; 00002844  add [bx+si],al
  db 0x00, 0x00                ; 00002846  add [bx+si],al
  db 0x00, 0x00                ; 00002848  add [bx+si],al
  db 0x00, 0x00                ; 0000284A  add [bx+si],al
  db 0x00, 0x00                ; 0000284C  add [bx+si],al
  db 0x00, 0x00                ; 0000284E  add [bx+si],al
  db 0x00, 0x00                ; 00002850  add [bx+si],al
  db 0x00, 0x00                ; 00002852  add [bx+si],al
  db 0x00, 0x00                ; 00002854  add [bx+si],al
  db 0x00, 0x00                ; 00002856  add [bx+si],al
  db 0x00, 0x00                ; 00002858  add [bx+si],al
  db 0x00, 0x00                ; 0000285A  add [bx+si],al
  db 0x00, 0x00                ; 0000285C  add [bx+si],al
  db 0x00, 0x00                ; 0000285E  add [bx+si],al
  db 0x00, 0x00                ; 00002860  add [bx+si],al
  db 0x00, 0x00                ; 00002862  add [bx+si],al
  db 0x00, 0x00                ; 00002864  add [bx+si],al
  db 0x00, 0x00                ; 00002866  add [bx+si],al
  db 0x00, 0x00                ; 00002868  add [bx+si],al
  db 0x00, 0x00                ; 0000286A  add [bx+si],al
  db 0x00, 0x00                ; 0000286C  add [bx+si],al
  db 0x00, 0x00                ; 0000286E  add [bx+si],al
  db 0x00, 0x00                ; 00002870  add [bx+si],al
  db 0x00, 0x00                ; 00002872  add [bx+si],al
  db 0x00, 0x00                ; 00002874  add [bx+si],al
  db 0x00, 0x00                ; 00002876  add [bx+si],al
  db 0x00, 0x00                ; 00002878  add [bx+si],al
  db 0x00, 0x00                ; 0000287A  add [bx+si],al
  db 0x00, 0x00                ; 0000287C  add [bx+si],al
  db 0x00, 0x00                ; 0000287E  add [bx+si],al
  db 0x00, 0x00                ; 00002880  add [bx+si],al
  db 0x00, 0x00                ; 00002882  add [bx+si],al
  db 0x00, 0x00                ; 00002884  add [bx+si],al
  db 0x00, 0x00                ; 00002886  add [bx+si],al
  db 0x00, 0x00                ; 00002888  add [bx+si],al
  db 0x00, 0x00                ; 0000288A  add [bx+si],al
  db 0x00, 0x00                ; 0000288C  add [bx+si],al
  db 0x00, 0x00                ; 0000288E  add [bx+si],al
  db 0x00, 0x00                ; 00002890  add [bx+si],al
  db 0x00, 0x00                ; 00002892  add [bx+si],al
  db 0x00, 0x00                ; 00002894  add [bx+si],al
  db 0x00, 0x00                ; 00002896  add [bx+si],al
  db 0x00, 0x00                ; 00002898  add [bx+si],al
  db 0x00, 0x00                ; 0000289A  add [bx+si],al
  db 0x00, 0x00                ; 0000289C  add [bx+si],al
  db 0x00, 0x00                ; 0000289E  add [bx+si],al
  db 0x00, 0x00                ; 000028A0  add [bx+si],al
  db 0x00, 0x00                ; 000028A2  add [bx+si],al
  db 0x00, 0x00                ; 000028A4  add [bx+si],al
  db 0x00, 0x00                ; 000028A6  add [bx+si],al
  db 0x00, 0x00                ; 000028A8  add [bx+si],al
  db 0x00, 0x00                ; 000028AA  add [bx+si],al
  db 0x00, 0x00                ; 000028AC  add [bx+si],al
  db 0x00, 0x00                ; 000028AE  add [bx+si],al
  db 0x00, 0x00                ; 000028B0  add [bx+si],al
  db 0x00, 0x00                ; 000028B2  add [bx+si],al
  db 0x00, 0x00                ; 000028B4  add [bx+si],al
  db 0x00, 0x00                ; 000028B6  add [bx+si],al
  db 0x00, 0x00                ; 000028B8  add [bx+si],al
  db 0x00, 0x00                ; 000028BA  add [bx+si],al
  db 0x00, 0x00                ; 000028BC  add [bx+si],al
  db 0x00, 0x00                ; 000028BE  add [bx+si],al
  db 0x00, 0x00                ; 000028C0  add [bx+si],al
  db 0x00, 0x00                ; 000028C2  add [bx+si],al
  db 0x00, 0x00                ; 000028C4  add [bx+si],al
  db 0x00, 0x00                ; 000028C6  add [bx+si],al
  db 0x00, 0x00                ; 000028C8  add [bx+si],al
  db 0x00, 0x00                ; 000028CA  add [bx+si],al
  db 0x00, 0x00                ; 000028CC  add [bx+si],al
  db 0x00, 0x00                ; 000028CE  add [bx+si],al
  db 0x00, 0x00                ; 000028D0  add [bx+si],al
  db 0x00, 0x00                ; 000028D2  add [bx+si],al
  db 0x00, 0x00                ; 000028D4  add [bx+si],al
  db 0x00, 0x00                ; 000028D6  add [bx+si],al
  db 0x00, 0x00                ; 000028D8  add [bx+si],al
  db 0x00, 0x00                ; 000028DA  add [bx+si],al
  db 0x00, 0x00                ; 000028DC  add [bx+si],al
  db 0x00, 0x00                ; 000028DE  add [bx+si],al
  db 0x00, 0x00                ; 000028E0  add [bx+si],al
  db 0x00, 0x00                ; 000028E2  add [bx+si],al
  db 0x00, 0x00                ; 000028E4  add [bx+si],al
  db 0x00, 0x00                ; 000028E6  add [bx+si],al
  db 0x00, 0x00                ; 000028E8  add [bx+si],al
  db 0x00, 0x00                ; 000028EA  add [bx+si],al
  db 0x00, 0x00                ; 000028EC  add [bx+si],al
  db 0x00, 0x00                ; 000028EE  add [bx+si],al
  db 0x00, 0x00                ; 000028F0  add [bx+si],al
  db 0x00, 0x00                ; 000028F2  add [bx+si],al
  db 0x00, 0x00                ; 000028F4  add [bx+si],al
  db 0x00, 0x00                ; 000028F6  add [bx+si],al
  db 0x00, 0x00                ; 000028F8  add [bx+si],al
  db 0x00, 0x00                ; 000028FA  add [bx+si],al
  db 0x00, 0x00                ; 000028FC  add [bx+si],al
  db 0x00, 0x00                ; 000028FE  add [bx+si],al
  db 0x00, 0x00                ; 00002900  add [bx+si],al
  db 0x00, 0x00                ; 00002902  add [bx+si],al
  db 0x00, 0x00                ; 00002904  add [bx+si],al
  db 0x00, 0x00                ; 00002906  add [bx+si],al
  db 0x00, 0x00                ; 00002908  add [bx+si],al
  db 0x00, 0x00                ; 0000290A  add [bx+si],al
  db 0x00, 0x00                ; 0000290C  add [bx+si],al
  db 0x00, 0x00                ; 0000290E  add [bx+si],al
  db 0x00, 0x00                ; 00002910  add [bx+si],al
  db 0x00, 0x00                ; 00002912  add [bx+si],al
  db 0x00, 0x00                ; 00002914  add [bx+si],al
  db 0x00, 0x00                ; 00002916  add [bx+si],al
  db 0x00, 0x00                ; 00002918  add [bx+si],al
  db 0x00, 0x00                ; 0000291A  add [bx+si],al
  db 0x00, 0x00                ; 0000291C  add [bx+si],al
  db 0x00, 0x00                ; 0000291E  add [bx+si],al
  db 0x00, 0x00                ; 00002920  add [bx+si],al
  db 0x00, 0x00                ; 00002922  add [bx+si],al
  db 0x00, 0x00                ; 00002924  add [bx+si],al
  db 0x00, 0x00                ; 00002926  add [bx+si],al
  db 0x00, 0x00                ; 00002928  add [bx+si],al
  db 0x00, 0x00                ; 0000292A  add [bx+si],al
  db 0x00, 0x00                ; 0000292C  add [bx+si],al
  db 0x00, 0x00                ; 0000292E  add [bx+si],al
  db 0x00, 0x00                ; 00002930  add [bx+si],al
  db 0x00, 0x00                ; 00002932  add [bx+si],al
  db 0x00, 0x00                ; 00002934  add [bx+si],al
  db 0x00, 0x00                ; 00002936  add [bx+si],al
  db 0x00, 0x00                ; 00002938  add [bx+si],al
  db 0x00, 0x00                ; 0000293A  add [bx+si],al
  db 0x00, 0x00                ; 0000293C  add [bx+si],al
  db 0x00, 0x00                ; 0000293E  add [bx+si],al
  db 0x00, 0x00                ; 00002940  add [bx+si],al
  db 0x00, 0x00                ; 00002942  add [bx+si],al
  db 0x00, 0x00                ; 00002944  add [bx+si],al
  db 0x00, 0x00                ; 00002946  add [bx+si],al
  db 0x00, 0x00                ; 00002948  add [bx+si],al
  db 0x00, 0x00                ; 0000294A  add [bx+si],al
  db 0x00, 0x00                ; 0000294C  add [bx+si],al
  db 0x00, 0x00                ; 0000294E  add [bx+si],al
  db 0x00, 0x00                ; 00002950  add [bx+si],al
  db 0x00, 0x00                ; 00002952  add [bx+si],al
  db 0x00, 0x00                ; 00002954  add [bx+si],al
  db 0x00, 0x00                ; 00002956  add [bx+si],al
  db 0x00, 0x00                ; 00002958  add [bx+si],al
  db 0x00, 0x00                ; 0000295A  add [bx+si],al
  db 0x00, 0x00                ; 0000295C  add [bx+si],al
  db 0x00, 0x00                ; 0000295E  add [bx+si],al
  db 0x00, 0x00                ; 00002960  add [bx+si],al
  db 0x00, 0x00                ; 00002962  add [bx+si],al
  db 0x00, 0x00                ; 00002964  add [bx+si],al
  db 0x00, 0x00                ; 00002966  add [bx+si],al
  db 0x00, 0x00                ; 00002968  add [bx+si],al
  db 0x00, 0x00                ; 0000296A  add [bx+si],al
  db 0x00, 0x00                ; 0000296C  add [bx+si],al
  db 0x00, 0x00                ; 0000296E  add [bx+si],al
  db 0x00, 0x00                ; 00002970  add [bx+si],al
  db 0x00, 0x00                ; 00002972  add [bx+si],al
  db 0x00, 0x00                ; 00002974  add [bx+si],al
  db 0x00, 0x00                ; 00002976  add [bx+si],al
  db 0x00, 0x00                ; 00002978  add [bx+si],al
  db 0x00, 0x00                ; 0000297A  add [bx+si],al
  db 0x00, 0x00                ; 0000297C  add [bx+si],al
  db 0x00, 0x00                ; 0000297E  add [bx+si],al
  db 0x00, 0x00                ; 00002980  add [bx+si],al
  db 0x00, 0x00                ; 00002982  add [bx+si],al
  db 0x00, 0x00                ; 00002984  add [bx+si],al
  db 0x00, 0x00                ; 00002986  add [bx+si],al
  db 0x00, 0x00                ; 00002988  add [bx+si],al
  db 0x00, 0x00                ; 0000298A  add [bx+si],al
  db 0x00, 0x00                ; 0000298C  add [bx+si],al
  db 0x00, 0x00                ; 0000298E  add [bx+si],al
  db 0x00, 0x00                ; 00002990  add [bx+si],al
  db 0x00, 0x00                ; 00002992  add [bx+si],al
  db 0x00, 0x00                ; 00002994  add [bx+si],al
  db 0x00, 0x00                ; 00002996  add [bx+si],al
  db 0x00, 0x00                ; 00002998  add [bx+si],al
  db 0x00, 0x00                ; 0000299A  add [bx+si],al
  db 0x00, 0x00                ; 0000299C  add [bx+si],al
  db 0x00, 0x00                ; 0000299E  add [bx+si],al
  db 0x00, 0x00                ; 000029A0  add [bx+si],al
  db 0x00, 0x00                ; 000029A2  add [bx+si],al
  db 0x00, 0x00                ; 000029A4  add [bx+si],al
  db 0x00, 0x00                ; 000029A6  add [bx+si],al
  db 0x00, 0x00                ; 000029A8  add [bx+si],al
  db 0x00, 0x00                ; 000029AA  add [bx+si],al
  db 0x00, 0x00                ; 000029AC  add [bx+si],al
  db 0x00, 0x00                ; 000029AE  add [bx+si],al
  db 0x00, 0x00                ; 000029B0  add [bx+si],al
  db 0x00, 0x00                ; 000029B2  add [bx+si],al
  db 0x00, 0x00                ; 000029B4  add [bx+si],al
  db 0x00, 0x00                ; 000029B6  add [bx+si],al
  db 0x00, 0x00                ; 000029B8  add [bx+si],al
  db 0x00, 0x00                ; 000029BA  add [bx+si],al
  db 0x00, 0x00                ; 000029BC  add [bx+si],al
  db 0x00, 0x00                ; 000029BE  add [bx+si],al
  db 0x00, 0x00                ; 000029C0  add [bx+si],al
  db 0x00, 0x00                ; 000029C2  add [bx+si],al
  db 0x00, 0x00                ; 000029C4  add [bx+si],al
  db 0x00, 0x00                ; 000029C6  add [bx+si],al
  db 0x00, 0x00                ; 000029C8  add [bx+si],al
  db 0x00, 0x00                ; 000029CA  add [bx+si],al
  db 0x00, 0x00                ; 000029CC  add [bx+si],al
  db 0x00, 0x00                ; 000029CE  add [bx+si],al
  db 0x00, 0x00                ; 000029D0  add [bx+si],al
  db 0x00, 0x00                ; 000029D2  add [bx+si],al
  db 0x00, 0x00                ; 000029D4  add [bx+si],al
  db 0x00, 0x00                ; 000029D6  add [bx+si],al
  db 0x00, 0x00                ; 000029D8  add [bx+si],al
  db 0x00, 0x00                ; 000029DA  add [bx+si],al
  db 0x00, 0x00                ; 000029DC  add [bx+si],al
  db 0x00, 0x00                ; 000029DE  add [bx+si],al
  db 0x00, 0x00                ; 000029E0  add [bx+si],al
  db 0x00, 0x00                ; 000029E2  add [bx+si],al
  db 0x00, 0x00                ; 000029E4  add [bx+si],al
  db 0x00, 0x00                ; 000029E6  add [bx+si],al
  db 0x00, 0x00                ; 000029E8  add [bx+si],al
  db 0x00, 0x00                ; 000029EA  add [bx+si],al
  db 0x00, 0x00                ; 000029EC  add [bx+si],al
  db 0x00, 0x00                ; 000029EE  add [bx+si],al
  db 0x00, 0x00                ; 000029F0  add [bx+si],al
  db 0x00, 0x00                ; 000029F2  add [bx+si],al
  db 0x00, 0x00                ; 000029F4  add [bx+si],al
  db 0x00, 0x00                ; 000029F6  add [bx+si],al
  db 0x00, 0x00                ; 000029F8  add [bx+si],al
  db 0x00, 0x00                ; 000029FA  add [bx+si],al
  db 0x00, 0x00                ; 000029FC  add [bx+si],al
  db 0x00, 0x00                ; 000029FE  add [bx+si],al
  db 0x00, 0x00                ; 00002A00  add [bx+si],al
  db 0x00, 0x00                ; 00002A02  add [bx+si],al
  db 0x00, 0x00                ; 00002A04  add [bx+si],al
  db 0x00, 0x00                ; 00002A06  add [bx+si],al
  db 0x00, 0x00                ; 00002A08  add [bx+si],al
  db 0x00, 0x00                ; 00002A0A  add [bx+si],al
  db 0x00, 0x00                ; 00002A0C  add [bx+si],al
  db 0x00, 0x00                ; 00002A0E  add [bx+si],al
  db 0x00, 0x00                ; 00002A10  add [bx+si],al
  db 0x00, 0x00                ; 00002A12  add [bx+si],al
  db 0x00, 0x00                ; 00002A14  add [bx+si],al
  db 0x00, 0x00                ; 00002A16  add [bx+si],al
  db 0x00, 0x00                ; 00002A18  add [bx+si],al
  db 0x00, 0x00                ; 00002A1A  add [bx+si],al
  db 0x00, 0x00                ; 00002A1C  add [bx+si],al
  db 0x00, 0x00                ; 00002A1E  add [bx+si],al
  db 0x00, 0x00                ; 00002A20  add [bx+si],al
  db 0x00, 0x00                ; 00002A22  add [bx+si],al
  db 0x00, 0x00                ; 00002A24  add [bx+si],al
  db 0x00, 0x00                ; 00002A26  add [bx+si],al
  db 0x00, 0x00                ; 00002A28  add [bx+si],al
  db 0x00, 0x00                ; 00002A2A  add [bx+si],al
  db 0x00, 0x00                ; 00002A2C  add [bx+si],al
  db 0x00, 0x00                ; 00002A2E  add [bx+si],al
  db 0x00, 0x00                ; 00002A30  add [bx+si],al
  db 0x00, 0x00                ; 00002A32  add [bx+si],al
  db 0x00, 0x00                ; 00002A34  add [bx+si],al
  db 0x00, 0x00                ; 00002A36  add [bx+si],al
  db 0x00, 0x00                ; 00002A38  add [bx+si],al
  db 0x00, 0x00                ; 00002A3A  add [bx+si],al
  db 0x00, 0x00                ; 00002A3C  add [bx+si],al
  db 0x00, 0x00                ; 00002A3E  add [bx+si],al
  db 0x00, 0x00                ; 00002A40  add [bx+si],al
  db 0x00, 0x00                ; 00002A42  add [bx+si],al
  db 0x00, 0x00                ; 00002A44  add [bx+si],al
  db 0x00, 0x00                ; 00002A46  add [bx+si],al
  db 0x00, 0x00                ; 00002A48  add [bx+si],al
  db 0x00, 0x00                ; 00002A4A  add [bx+si],al
  db 0x00, 0x00                ; 00002A4C  add [bx+si],al
  db 0x00, 0x00                ; 00002A4E  add [bx+si],al
  db 0x00, 0x00                ; 00002A50  add [bx+si],al
  db 0x00, 0x00                ; 00002A52  add [bx+si],al
  db 0x00, 0x00                ; 00002A54  add [bx+si],al
  db 0x00, 0x00                ; 00002A56  add [bx+si],al
  db 0x00, 0x00                ; 00002A58  add [bx+si],al
  db 0x00, 0x00                ; 00002A5A  add [bx+si],al
  db 0x00, 0x00                ; 00002A5C  add [bx+si],al
  db 0x00, 0x00                ; 00002A5E  add [bx+si],al
  db 0x00, 0x00                ; 00002A60  add [bx+si],al
  db 0x00, 0x00                ; 00002A62  add [bx+si],al
  db 0x00, 0x00                ; 00002A64  add [bx+si],al
  db 0x00, 0x00                ; 00002A66  add [bx+si],al
  db 0x00, 0x00                ; 00002A68  add [bx+si],al
  db 0x00, 0x00                ; 00002A6A  add [bx+si],al
  db 0x00, 0x00                ; 00002A6C  add [bx+si],al
  db 0x00, 0x00                ; 00002A6E  add [bx+si],al
  db 0x00, 0x00                ; 00002A70  add [bx+si],al
  db 0x00, 0x00                ; 00002A72  add [bx+si],al
  db 0x00, 0x00                ; 00002A74  add [bx+si],al
  db 0x00, 0x00                ; 00002A76  add [bx+si],al
  db 0x00, 0x00                ; 00002A78  add [bx+si],al
  db 0x00, 0x00                ; 00002A7A  add [bx+si],al
  db 0x00, 0x00                ; 00002A7C  add [bx+si],al
  db 0x00, 0x00                ; 00002A7E  add [bx+si],al
  db 0x00, 0x00                ; 00002A80  add [bx+si],al
  db 0x00, 0x00                ; 00002A82  add [bx+si],al
  db 0x00, 0x00                ; 00002A84  add [bx+si],al
  db 0x00, 0x00                ; 00002A86  add [bx+si],al
  db 0x00, 0x00                ; 00002A88  add [bx+si],al
  db 0x00, 0x00                ; 00002A8A  add [bx+si],al
  db 0x00, 0x00                ; 00002A8C  add [bx+si],al
  db 0x00, 0x00                ; 00002A8E  add [bx+si],al
  db 0x00, 0x00                ; 00002A90  add [bx+si],al
  db 0x00, 0x00                ; 00002A92  add [bx+si],al
  db 0x00, 0x00                ; 00002A94  add [bx+si],al
  db 0x00, 0x00                ; 00002A96  add [bx+si],al
  db 0x00, 0x00                ; 00002A98  add [bx+si],al
  db 0x00, 0x00                ; 00002A9A  add [bx+si],al
  db 0x00, 0x00                ; 00002A9C  add [bx+si],al
  db 0x00, 0x00                ; 00002A9E  add [bx+si],al
  db 0x00, 0x00                ; 00002AA0  add [bx+si],al
  db 0x00, 0x00                ; 00002AA2  add [bx+si],al
  db 0x00, 0x00                ; 00002AA4  add [bx+si],al
  db 0x00, 0x00                ; 00002AA6  add [bx+si],al
  db 0x00, 0x00                ; 00002AA8  add [bx+si],al
  db 0x00, 0x00                ; 00002AAA  add [bx+si],al
  db 0x00, 0x00                ; 00002AAC  add [bx+si],al
  db 0x00, 0x00                ; 00002AAE  add [bx+si],al
  db 0x00, 0x00                ; 00002AB0  add [bx+si],al
  db 0x00, 0x00                ; 00002AB2  add [bx+si],al
  db 0x00, 0x00                ; 00002AB4  add [bx+si],al
  db 0x00, 0x00                ; 00002AB6  add [bx+si],al
  db 0x00, 0x00                ; 00002AB8  add [bx+si],al
  db 0x00, 0x00                ; 00002ABA  add [bx+si],al
  db 0x00, 0x00                ; 00002ABC  add [bx+si],al
  db 0x00, 0x00                ; 00002ABE  add [bx+si],al
  db 0x00, 0x00                ; 00002AC0  add [bx+si],al
  db 0x00, 0x00                ; 00002AC2  add [bx+si],al
  db 0x00, 0x00                ; 00002AC4  add [bx+si],al
  db 0x00, 0x00                ; 00002AC6  add [bx+si],al
  db 0x00, 0x00                ; 00002AC8  add [bx+si],al
  db 0x00, 0x00                ; 00002ACA  add [bx+si],al
  db 0x00, 0x00                ; 00002ACC  add [bx+si],al
  db 0x00, 0x00                ; 00002ACE  add [bx+si],al
  db 0x00, 0x00                ; 00002AD0  add [bx+si],al
  db 0x00, 0x00                ; 00002AD2  add [bx+si],al
  db 0x00, 0x00                ; 00002AD4  add [bx+si],al
  db 0x00, 0x00                ; 00002AD6  add [bx+si],al
  db 0x00, 0x00                ; 00002AD8  add [bx+si],al
  db 0x00, 0x00                ; 00002ADA  add [bx+si],al
  db 0x00, 0x00                ; 00002ADC  add [bx+si],al
  db 0x00, 0x00                ; 00002ADE  add [bx+si],al
  db 0x00, 0x00                ; 00002AE0  add [bx+si],al
  db 0x00, 0x00                ; 00002AE2  add [bx+si],al
  db 0x00, 0x00                ; 00002AE4  add [bx+si],al
  db 0x00, 0x00                ; 00002AE6  add [bx+si],al
  db 0x00, 0x00                ; 00002AE8  add [bx+si],al
  db 0x00, 0x00                ; 00002AEA  add [bx+si],al
  db 0x00, 0x00                ; 00002AEC  add [bx+si],al
  db 0x00, 0x00                ; 00002AEE  add [bx+si],al
  db 0x00, 0x00                ; 00002AF0  add [bx+si],al
  db 0x00, 0x00                ; 00002AF2  add [bx+si],al
  db 0x00, 0x00                ; 00002AF4  add [bx+si],al
  db 0x00, 0x00                ; 00002AF6  add [bx+si],al
  db 0x00, 0x00                ; 00002AF8  add [bx+si],al
  db 0x00, 0x00                ; 00002AFA  add [bx+si],al
  db 0x00, 0x00                ; 00002AFC  add [bx+si],al
  db 0x00, 0x00                ; 00002AFE  add [bx+si],al
  db 0x00, 0x00                ; 00002B00  add [bx+si],al
  db 0x00, 0x00                ; 00002B02  add [bx+si],al
  db 0x00, 0x00                ; 00002B04  add [bx+si],al
  db 0x00, 0x00                ; 00002B06  add [bx+si],al
  db 0x00, 0x00                ; 00002B08  add [bx+si],al
  db 0x00, 0x00                ; 00002B0A  add [bx+si],al
  db 0x00, 0x00                ; 00002B0C  add [bx+si],al
  db 0x00, 0x00                ; 00002B0E  add [bx+si],al
  db 0x00, 0x00                ; 00002B10  add [bx+si],al
  db 0x00, 0x00                ; 00002B12  add [bx+si],al
  db 0x00, 0x00                ; 00002B14  add [bx+si],al
  db 0x00, 0x00                ; 00002B16  add [bx+si],al
  db 0x00, 0x00                ; 00002B18  add [bx+si],al
  db 0x00, 0x00                ; 00002B1A  add [bx+si],al
  db 0x00, 0x00                ; 00002B1C  add [bx+si],al
  db 0x00, 0x00                ; 00002B1E  add [bx+si],al
  db 0x00, 0x00                ; 00002B20  add [bx+si],al
  db 0x00, 0x00                ; 00002B22  add [bx+si],al
  db 0x00, 0x00                ; 00002B24  add [bx+si],al
  db 0x00, 0x00                ; 00002B26  add [bx+si],al
  db 0x00, 0x00                ; 00002B28  add [bx+si],al
  db 0x00, 0x00                ; 00002B2A  add [bx+si],al
  db 0x00, 0x00                ; 00002B2C  add [bx+si],al
  db 0x00, 0x00                ; 00002B2E  add [bx+si],al
  db 0x00, 0x00                ; 00002B30  add [bx+si],al
  db 0x00, 0x00                ; 00002B32  add [bx+si],al
  db 0x00, 0x00                ; 00002B34  add [bx+si],al
  db 0x00, 0x00                ; 00002B36  add [bx+si],al
  db 0x00, 0x00                ; 00002B38  add [bx+si],al
  db 0x00, 0x00                ; 00002B3A  add [bx+si],al
  db 0x00, 0x00                ; 00002B3C  add [bx+si],al
  db 0x00, 0x00                ; 00002B3E  add [bx+si],al
  db 0x00, 0x00                ; 00002B40  add [bx+si],al
  db 0x00, 0x00                ; 00002B42  add [bx+si],al
  db 0x00, 0x00                ; 00002B44  add [bx+si],al
  db 0x00, 0x00                ; 00002B46  add [bx+si],al
  db 0x00, 0x00                ; 00002B48  add [bx+si],al
  db 0x00, 0x00                ; 00002B4A  add [bx+si],al
  db 0x00, 0x00                ; 00002B4C  add [bx+si],al
  db 0x00, 0x00                ; 00002B4E  add [bx+si],al
  db 0x00, 0x00                ; 00002B50  add [bx+si],al
  db 0x00, 0x00                ; 00002B52  add [bx+si],al
  db 0x00, 0x00                ; 00002B54  add [bx+si],al
  db 0x00, 0x00                ; 00002B56  add [bx+si],al
  db 0x00, 0x00                ; 00002B58  add [bx+si],al
  db 0x00, 0x00                ; 00002B5A  add [bx+si],al
  db 0x00, 0x00                ; 00002B5C  add [bx+si],al
  db 0x00, 0x00                ; 00002B5E  add [bx+si],al
  db 0x00, 0x00                ; 00002B60  add [bx+si],al
  db 0x00, 0x00                ; 00002B62  add [bx+si],al
  db 0x00, 0x00                ; 00002B64  add [bx+si],al
  db 0x00, 0x00                ; 00002B66  add [bx+si],al
  db 0x00, 0x00                ; 00002B68  add [bx+si],al
  db 0x00, 0x00                ; 00002B6A  add [bx+si],al
  db 0x00, 0x00                ; 00002B6C  add [bx+si],al
  db 0x00, 0x00                ; 00002B6E  add [bx+si],al
  db 0x00, 0x00                ; 00002B70  add [bx+si],al
  db 0x00, 0x00                ; 00002B72  add [bx+si],al
  db 0x00, 0x00                ; 00002B74  add [bx+si],al
  db 0x00, 0x00                ; 00002B76  add [bx+si],al
  db 0x00, 0x00                ; 00002B78  add [bx+si],al
  db 0x00, 0x00                ; 00002B7A  add [bx+si],al
  db 0x00, 0x00                ; 00002B7C  add [bx+si],al
  db 0x00, 0x00                ; 00002B7E  add [bx+si],al
  db 0x00, 0x00                ; 00002B80  add [bx+si],al
  db 0x00, 0x00                ; 00002B82  add [bx+si],al
  db 0x00, 0x00                ; 00002B84  add [bx+si],al
  db 0x00, 0x00                ; 00002B86  add [bx+si],al
  db 0x00, 0x00                ; 00002B88  add [bx+si],al
  db 0x00, 0x00                ; 00002B8A  add [bx+si],al
  db 0x00, 0x00                ; 00002B8C  add [bx+si],al
  db 0x00, 0x00                ; 00002B8E  add [bx+si],al
  db 0x00, 0x00                ; 00002B90  add [bx+si],al
  db 0x00, 0x00                ; 00002B92  add [bx+si],al
  db 0x00, 0x00                ; 00002B94  add [bx+si],al
  db 0x00, 0x00                ; 00002B96  add [bx+si],al
  db 0x00, 0x00                ; 00002B98  add [bx+si],al
  db 0x00, 0x00                ; 00002B9A  add [bx+si],al
  db 0x00, 0x00                ; 00002B9C  add [bx+si],al
  db 0x00, 0x00                ; 00002B9E  add [bx+si],al
  db 0x00, 0x00                ; 00002BA0  add [bx+si],al
  db 0x00, 0x00                ; 00002BA2  add [bx+si],al
  db 0x00, 0x00                ; 00002BA4  add [bx+si],al
  db 0x00, 0x00                ; 00002BA6  add [bx+si],al
  db 0x00, 0x00                ; 00002BA8  add [bx+si],al
  db 0x00, 0x00                ; 00002BAA  add [bx+si],al
  db 0x00, 0x00                ; 00002BAC  add [bx+si],al
  db 0x00, 0x00                ; 00002BAE  add [bx+si],al
  db 0x00, 0x00                ; 00002BB0  add [bx+si],al
  db 0x00, 0x00                ; 00002BB2  add [bx+si],al
  db 0x00, 0x00                ; 00002BB4  add [bx+si],al
  db 0x00, 0x00                ; 00002BB6  add [bx+si],al
  db 0x00, 0x00                ; 00002BB8  add [bx+si],al
  db 0x00, 0x00                ; 00002BBA  add [bx+si],al
  db 0x00, 0x00                ; 00002BBC  add [bx+si],al
  db 0x00, 0x00                ; 00002BBE  add [bx+si],al
  db 0x00, 0x00                ; 00002BC0  add [bx+si],al
  db 0x00, 0x00                ; 00002BC2  add [bx+si],al
  db 0x00, 0x00                ; 00002BC4  add [bx+si],al
  db 0x00, 0x00                ; 00002BC6  add [bx+si],al
  db 0x00, 0x00                ; 00002BC8  add [bx+si],al
  db 0x00, 0x00                ; 00002BCA  add [bx+si],al
  db 0x00, 0x00                ; 00002BCC  add [bx+si],al
  db 0x00, 0x00                ; 00002BCE  add [bx+si],al
  db 0x00, 0x00                ; 00002BD0  add [bx+si],al
  db 0x00, 0x00                ; 00002BD2  add [bx+si],al
  db 0x00, 0x00                ; 00002BD4  add [bx+si],al
  db 0x00, 0x00                ; 00002BD6  add [bx+si],al
  db 0x00, 0x00                ; 00002BD8  add [bx+si],al
  db 0x00, 0x00                ; 00002BDA  add [bx+si],al
  db 0x00, 0x00                ; 00002BDC  add [bx+si],al
  db 0x00, 0x00                ; 00002BDE  add [bx+si],al
  db 0x00, 0x00                ; 00002BE0  add [bx+si],al
  db 0x00, 0x00                ; 00002BE2  add [bx+si],al
  db 0x00, 0x00                ; 00002BE4  add [bx+si],al
  db 0x00, 0x00                ; 00002BE6  add [bx+si],al
  db 0x00, 0x00                ; 00002BE8  add [bx+si],al
  db 0x00, 0x00                ; 00002BEA  add [bx+si],al
  db 0x00, 0x00                ; 00002BEC  add [bx+si],al
  db 0x00, 0x00                ; 00002BEE  add [bx+si],al
  db 0x00, 0x00                ; 00002BF0  add [bx+si],al
  db 0x00, 0x00                ; 00002BF2  add [bx+si],al
  db 0x00, 0x00                ; 00002BF4  add [bx+si],al
  db 0x00, 0x00                ; 00002BF6  add [bx+si],al
  db 0x00, 0x00                ; 00002BF8  add [bx+si],al
  db 0x00, 0x00                ; 00002BFA  add [bx+si],al
  db 0x00, 0x00                ; 00002BFC  add [bx+si],al
  db 0x00, 0x00                ; 00002BFE  add [bx+si],al
  db 0x00, 0x00                ; 00002C00  add [bx+si],al
  db 0x00, 0x00                ; 00002C02  add [bx+si],al
  db 0x00, 0x00                ; 00002C04  add [bx+si],al
  db 0x00, 0x00                ; 00002C06  add [bx+si],al
  db 0x00, 0x00                ; 00002C08  add [bx+si],al
  db 0x00, 0x00                ; 00002C0A  add [bx+si],al
  db 0x00, 0x00                ; 00002C0C  add [bx+si],al
  db 0x00, 0x00                ; 00002C0E  add [bx+si],al
  db 0x00, 0x00                ; 00002C10  add [bx+si],al
  db 0x00, 0x00                ; 00002C12  add [bx+si],al
  db 0x00, 0x00                ; 00002C14  add [bx+si],al
  db 0x00, 0x00                ; 00002C16  add [bx+si],al
  db 0x00, 0x00                ; 00002C18  add [bx+si],al
  db 0x00, 0x00                ; 00002C1A  add [bx+si],al
  db 0x00, 0x00                ; 00002C1C  add [bx+si],al
  db 0x00, 0x00                ; 00002C1E  add [bx+si],al
  db 0x00, 0x00                ; 00002C20  add [bx+si],al
  db 0x00, 0x00                ; 00002C22  add [bx+si],al
  db 0x00, 0x00                ; 00002C24  add [bx+si],al
  db 0x00, 0x00                ; 00002C26  add [bx+si],al
  db 0x00, 0x00                ; 00002C28  add [bx+si],al
  db 0x00, 0x00                ; 00002C2A  add [bx+si],al
  db 0x00, 0x00                ; 00002C2C  add [bx+si],al
  db 0x00, 0x00                ; 00002C2E  add [bx+si],al
  db 0x00, 0x00                ; 00002C30  add [bx+si],al
  db 0x00, 0x00                ; 00002C32  add [bx+si],al
  db 0x00, 0x00                ; 00002C34  add [bx+si],al
  db 0x00, 0x00                ; 00002C36  add [bx+si],al
  db 0x00, 0x00                ; 00002C38  add [bx+si],al
  db 0x00, 0x00                ; 00002C3A  add [bx+si],al
  db 0x00, 0x00                ; 00002C3C  add [bx+si],al
  db 0x00, 0x00                ; 00002C3E  add [bx+si],al
  db 0x00, 0x00                ; 00002C40  add [bx+si],al
  db 0x00, 0x00                ; 00002C42  add [bx+si],al
  db 0x00, 0x00                ; 00002C44  add [bx+si],al
  db 0x00, 0x00                ; 00002C46  add [bx+si],al
  db 0x00, 0x00                ; 00002C48  add [bx+si],al
  db 0x00, 0x00                ; 00002C4A  add [bx+si],al
  db 0x00, 0x00                ; 00002C4C  add [bx+si],al
  db 0x00, 0x00                ; 00002C4E  add [bx+si],al
  db 0x00, 0x00                ; 00002C50  add [bx+si],al
  db 0x00, 0x00                ; 00002C52  add [bx+si],al
  db 0x00, 0x00                ; 00002C54  add [bx+si],al
  db 0x00, 0x00                ; 00002C56  add [bx+si],al
  db 0x00, 0x00                ; 00002C58  add [bx+si],al
  db 0x00, 0x00                ; 00002C5A  add [bx+si],al
  db 0x00, 0x00                ; 00002C5C  add [bx+si],al
  db 0x00, 0x00                ; 00002C5E  add [bx+si],al
  db 0x00, 0x00                ; 00002C60  add [bx+si],al
  db 0x00, 0x00                ; 00002C62  add [bx+si],al
  db 0x00, 0x00                ; 00002C64  add [bx+si],al
  db 0x00, 0x00                ; 00002C66  add [bx+si],al
  db 0x00, 0x00                ; 00002C68  add [bx+si],al
  db 0x00, 0x00                ; 00002C6A  add [bx+si],al
  db 0x00, 0x00                ; 00002C6C  add [bx+si],al
  db 0x00, 0x00                ; 00002C6E  add [bx+si],al
  db 0x00, 0x00                ; 00002C70  add [bx+si],al
  db 0x00, 0x00                ; 00002C72  add [bx+si],al
  db 0x00, 0x00                ; 00002C74  add [bx+si],al
  db 0x00, 0x00                ; 00002C76  add [bx+si],al
  db 0x00, 0x00                ; 00002C78  add [bx+si],al
  db 0x00, 0x00                ; 00002C7A  add [bx+si],al
  db 0x00, 0x00                ; 00002C7C  add [bx+si],al
  db 0x00, 0x00                ; 00002C7E  add [bx+si],al
  db 0x00, 0x00                ; 00002C80  add [bx+si],al
  db 0x00, 0x00                ; 00002C82  add [bx+si],al
  db 0x00, 0x00                ; 00002C84  add [bx+si],al
  db 0x00, 0x00                ; 00002C86  add [bx+si],al
  db 0x00, 0x00                ; 00002C88  add [bx+si],al
  db 0x00, 0x00                ; 00002C8A  add [bx+si],al
  db 0x00, 0x00                ; 00002C8C  add [bx+si],al
  db 0x00, 0x00                ; 00002C8E  add [bx+si],al
  db 0x00, 0x00                ; 00002C90  add [bx+si],al
  db 0x00, 0x00                ; 00002C92  add [bx+si],al
  db 0x00, 0x00                ; 00002C94  add [bx+si],al
  db 0x00, 0x00                ; 00002C96  add [bx+si],al
  db 0x00, 0x00                ; 00002C98  add [bx+si],al
  db 0x00, 0x00                ; 00002C9A  add [bx+si],al
  db 0x00, 0x00                ; 00002C9C  add [bx+si],al
  db 0x00, 0x00                ; 00002C9E  add [bx+si],al
  db 0x00, 0x00                ; 00002CA0  add [bx+si],al
  db 0x00, 0x00                ; 00002CA2  add [bx+si],al
  db 0x00, 0x00                ; 00002CA4  add [bx+si],al
  db 0x00, 0x00                ; 00002CA6  add [bx+si],al
  db 0x00, 0x00                ; 00002CA8  add [bx+si],al
  db 0x00, 0x00                ; 00002CAA  add [bx+si],al
  db 0x00, 0x00                ; 00002CAC  add [bx+si],al
  db 0x00, 0x00                ; 00002CAE  add [bx+si],al
  db 0x00, 0x00                ; 00002CB0  add [bx+si],al
  db 0x00, 0x00                ; 00002CB2  add [bx+si],al
  db 0x00, 0x00                ; 00002CB4  add [bx+si],al
  db 0x00, 0x00                ; 00002CB6  add [bx+si],al
  db 0x00, 0x00                ; 00002CB8  add [bx+si],al
  db 0x00, 0x00                ; 00002CBA  add [bx+si],al
  db 0x00, 0x00                ; 00002CBC  add [bx+si],al
  db 0x00, 0x00                ; 00002CBE  add [bx+si],al
  db 0x00, 0x00                ; 00002CC0  add [bx+si],al
  db 0x00, 0x00                ; 00002CC2  add [bx+si],al
  db 0x00, 0x00                ; 00002CC4  add [bx+si],al
  db 0x00, 0x00                ; 00002CC6  add [bx+si],al
  db 0x00, 0x00                ; 00002CC8  add [bx+si],al
  db 0x00, 0x00                ; 00002CCA  add [bx+si],al
  db 0x00, 0x00                ; 00002CCC  add [bx+si],al
  db 0x00, 0x00                ; 00002CCE  add [bx+si],al
  db 0x00, 0x00                ; 00002CD0  add [bx+si],al
  db 0x00, 0x00                ; 00002CD2  add [bx+si],al
  db 0x00, 0x00                ; 00002CD4  add [bx+si],al
  db 0x00, 0x00                ; 00002CD6  add [bx+si],al
  db 0x00, 0x00                ; 00002CD8  add [bx+si],al
  db 0x00, 0x00                ; 00002CDA  add [bx+si],al
  db 0x00, 0x00                ; 00002CDC  add [bx+si],al
  db 0x00, 0x00                ; 00002CDE  add [bx+si],al
  db 0x00, 0x00                ; 00002CE0  add [bx+si],al
  db 0x00, 0x00                ; 00002CE2  add [bx+si],al
  db 0x00, 0x00                ; 00002CE4  add [bx+si],al
  db 0x00, 0x00                ; 00002CE6  add [bx+si],al
  db 0x00, 0x00                ; 00002CE8  add [bx+si],al
  db 0x00, 0x00                ; 00002CEA  add [bx+si],al
  db 0x00, 0x00                ; 00002CEC  add [bx+si],al
  db 0x00, 0x00                ; 00002CEE  add [bx+si],al
  db 0x00, 0x00                ; 00002CF0  add [bx+si],al
  db 0x00, 0x00                ; 00002CF2  add [bx+si],al
  db 0x00, 0x00                ; 00002CF4  add [bx+si],al
  db 0x00, 0x00                ; 00002CF6  add [bx+si],al
  db 0x00, 0x00                ; 00002CF8  add [bx+si],al
  db 0x00, 0x00                ; 00002CFA  add [bx+si],al
  db 0x00, 0x00                ; 00002CFC  add [bx+si],al
  db 0x00, 0x00                ; 00002CFE  add [bx+si],al
  db 0x00, 0x00                ; 00002D00  add [bx+si],al
  db 0x00, 0x00                ; 00002D02  add [bx+si],al
  db 0x00, 0x00                ; 00002D04  add [bx+si],al
  db 0x00, 0x00                ; 00002D06  add [bx+si],al
  db 0x00, 0x00                ; 00002D08  add [bx+si],al
  db 0x00, 0x00                ; 00002D0A  add [bx+si],al
  db 0x00, 0x00                ; 00002D0C  add [bx+si],al
  db 0x00, 0x00                ; 00002D0E  add [bx+si],al
  db 0x00, 0x00                ; 00002D10  add [bx+si],al
  db 0x00, 0x00                ; 00002D12  add [bx+si],al
  db 0x00, 0x00                ; 00002D14  add [bx+si],al
  db 0x00, 0x00                ; 00002D16  add [bx+si],al
  db 0x00, 0x00                ; 00002D18  add [bx+si],al
  db 0x00, 0x00                ; 00002D1A  add [bx+si],al
  db 0x00, 0x00                ; 00002D1C  add [bx+si],al
  db 0x00, 0x00                ; 00002D1E  add [bx+si],al
  db 0x00, 0x00                ; 00002D20  add [bx+si],al
  db 0x00, 0x00                ; 00002D22  add [bx+si],al
  db 0x00, 0x00                ; 00002D24  add [bx+si],al
  db 0x00, 0x00                ; 00002D26  add [bx+si],al
  db 0x00, 0x00                ; 00002D28  add [bx+si],al
  db 0x00, 0x00                ; 00002D2A  add [bx+si],al
  db 0x00, 0x00                ; 00002D2C  add [bx+si],al
  db 0x00, 0x00                ; 00002D2E  add [bx+si],al
  db 0x00, 0x00                ; 00002D30  add [bx+si],al
  db 0x00, 0x00                ; 00002D32  add [bx+si],al
  db 0x00, 0x00                ; 00002D34  add [bx+si],al
  db 0x00, 0x00                ; 00002D36  add [bx+si],al
  db 0x00, 0x00                ; 00002D38  add [bx+si],al
  db 0x00, 0x00                ; 00002D3A  add [bx+si],al
  db 0x00, 0x00                ; 00002D3C  add [bx+si],al
  db 0x00, 0x00                ; 00002D3E  add [bx+si],al
  db 0x00, 0x00                ; 00002D40  add [bx+si],al
  db 0x00, 0x00                ; 00002D42  add [bx+si],al
  db 0x00, 0x00                ; 00002D44  add [bx+si],al
  db 0x00, 0x00                ; 00002D46  add [bx+si],al
  db 0x00, 0x00                ; 00002D48  add [bx+si],al
  db 0x00, 0x00                ; 00002D4A  add [bx+si],al
  db 0x00, 0x00                ; 00002D4C  add [bx+si],al
  db 0x00, 0x00                ; 00002D4E  add [bx+si],al
  db 0x00, 0x00                ; 00002D50  add [bx+si],al
  db 0x00, 0x00                ; 00002D52  add [bx+si],al
  db 0x00, 0x00                ; 00002D54  add [bx+si],al
  db 0x00, 0x00                ; 00002D56  add [bx+si],al
  db 0x00, 0x00                ; 00002D58  add [bx+si],al
  db 0x00, 0x00                ; 00002D5A  add [bx+si],al
  db 0x00, 0x00                ; 00002D5C  add [bx+si],al
  db 0x00, 0x00                ; 00002D5E  add [bx+si],al
  db 0x00, 0x00                ; 00002D60  add [bx+si],al
  db 0x00, 0x00                ; 00002D62  add [bx+si],al
  db 0x00, 0x00                ; 00002D64  add [bx+si],al
  db 0x00, 0x00                ; 00002D66  add [bx+si],al
  db 0x00, 0x00                ; 00002D68  add [bx+si],al
  db 0x00, 0x00                ; 00002D6A  add [bx+si],al
  db 0x00, 0x00                ; 00002D6C  add [bx+si],al
  db 0x00, 0x00                ; 00002D6E  add [bx+si],al
  db 0x00, 0x00                ; 00002D70  add [bx+si],al
  db 0x00, 0x00                ; 00002D72  add [bx+si],al
  db 0x00, 0x00                ; 00002D74  add [bx+si],al
  db 0x00, 0x00                ; 00002D76  add [bx+si],al
  db 0x00, 0x00                ; 00002D78  add [bx+si],al
  db 0x00, 0x00                ; 00002D7A  add [bx+si],al
  db 0x00, 0x00                ; 00002D7C  add [bx+si],al
  db 0x00, 0x00                ; 00002D7E  add [bx+si],al
  db 0x00, 0x00                ; 00002D80  add [bx+si],al
  db 0x00, 0x00                ; 00002D82  add [bx+si],al
  db 0x00, 0x00                ; 00002D84  add [bx+si],al
  db 0x00, 0x00                ; 00002D86  add [bx+si],al
  db 0x00, 0x00                ; 00002D88  add [bx+si],al
  db 0x00, 0x00                ; 00002D8A  add [bx+si],al
  db 0x00, 0x00                ; 00002D8C  add [bx+si],al
  db 0x00, 0x00                ; 00002D8E  add [bx+si],al
  db 0x00, 0x00                ; 00002D90  add [bx+si],al
  db 0x00, 0x00                ; 00002D92  add [bx+si],al
  db 0x00, 0x00                ; 00002D94  add [bx+si],al
  db 0x00, 0x00                ; 00002D96  add [bx+si],al
  db 0x00, 0x00                ; 00002D98  add [bx+si],al
  db 0x00, 0x00                ; 00002D9A  add [bx+si],al
  db 0x00, 0x00                ; 00002D9C  add [bx+si],al
  db 0x00, 0x00                ; 00002D9E  add [bx+si],al
  db 0x00, 0x00                ; 00002DA0  add [bx+si],al
  db 0x00, 0x00                ; 00002DA2  add [bx+si],al
  db 0x00, 0x00                ; 00002DA4  add [bx+si],al
  db 0x00, 0x00                ; 00002DA6  add [bx+si],al
  db 0x00, 0x00                ; 00002DA8  add [bx+si],al
  db 0x00, 0x00                ; 00002DAA  add [bx+si],al
  db 0x00, 0x00                ; 00002DAC  add [bx+si],al
  db 0x00, 0x00                ; 00002DAE  add [bx+si],al
  db 0x00, 0x00                ; 00002DB0  add [bx+si],al
  db 0x00, 0x00                ; 00002DB2  add [bx+si],al
  db 0x00, 0x00                ; 00002DB4  add [bx+si],al
  db 0x00, 0x00                ; 00002DB6  add [bx+si],al
  db 0x00, 0x00                ; 00002DB8  add [bx+si],al
  db 0x00, 0x00                ; 00002DBA  add [bx+si],al
  db 0x00, 0x00                ; 00002DBC  add [bx+si],al
  db 0x00, 0x00                ; 00002DBE  add [bx+si],al
  db 0x00, 0x00                ; 00002DC0  add [bx+si],al
  db 0x00, 0x00                ; 00002DC2  add [bx+si],al
  db 0x00, 0x00                ; 00002DC4  add [bx+si],al
  db 0x00, 0x00                ; 00002DC6  add [bx+si],al
  db 0x00, 0x00                ; 00002DC8  add [bx+si],al
  db 0x00, 0x00                ; 00002DCA  add [bx+si],al
  db 0x00, 0x00                ; 00002DCC  add [bx+si],al
  db 0x00, 0x00                ; 00002DCE  add [bx+si],al
  db 0x00, 0x00                ; 00002DD0  add [bx+si],al
  db 0x00, 0x00                ; 00002DD2  add [bx+si],al
  db 0x00, 0x00                ; 00002DD4  add [bx+si],al
  db 0x00, 0x00                ; 00002DD6  add [bx+si],al
  db 0x00, 0x00                ; 00002DD8  add [bx+si],al
  db 0x00, 0x00                ; 00002DDA  add [bx+si],al
  db 0x00, 0x00                ; 00002DDC  add [bx+si],al
  db 0x00, 0x00                ; 00002DDE  add [bx+si],al
  db 0x00, 0x00                ; 00002DE0  add [bx+si],al
  db 0x00, 0x00                ; 00002DE2  add [bx+si],al
  db 0x00, 0x00                ; 00002DE4  add [bx+si],al
  db 0x00, 0x00                ; 00002DE6  add [bx+si],al
  db 0x00, 0x00                ; 00002DE8  add [bx+si],al
  db 0x00, 0x00                ; 00002DEA  add [bx+si],al
  db 0x00, 0x00                ; 00002DEC  add [bx+si],al
  db 0x00, 0x00                ; 00002DEE  add [bx+si],al
  db 0x00, 0x00                ; 00002DF0  add [bx+si],al
  db 0x00, 0x00                ; 00002DF2  add [bx+si],al
  db 0x00, 0x00                ; 00002DF4  add [bx+si],al
  db 0x00, 0x00                ; 00002DF6  add [bx+si],al
  db 0x00, 0x00                ; 00002DF8  add [bx+si],al
  db 0x00, 0x00                ; 00002DFA  add [bx+si],al
  db 0x00, 0x00                ; 00002DFC  add [bx+si],al
  db 0x00, 0x00                ; 00002DFE  add [bx+si],al
  db 0x00, 0x00                ; 00002E00  add [bx+si],al
  db 0x00, 0x00                ; 00002E02  add [bx+si],al
  db 0x00, 0x00                ; 00002E04  add [bx+si],al
  db 0x00, 0x00                ; 00002E06  add [bx+si],al
  db 0x00, 0x00                ; 00002E08  add [bx+si],al
  db 0x00, 0x00                ; 00002E0A  add [bx+si],al
  db 0x00, 0x00                ; 00002E0C  add [bx+si],al
  db 0x00, 0x00                ; 00002E0E  add [bx+si],al
  db 0x00, 0x00                ; 00002E10  add [bx+si],al
  db 0x00, 0x00                ; 00002E12  add [bx+si],al
  db 0x00, 0x00                ; 00002E14  add [bx+si],al
  db 0x00, 0x00                ; 00002E16  add [bx+si],al
  db 0x00, 0x00                ; 00002E18  add [bx+si],al
  db 0x00, 0x00                ; 00002E1A  add [bx+si],al
  db 0x00, 0x00                ; 00002E1C  add [bx+si],al
  db 0x00, 0x00                ; 00002E1E  add [bx+si],al
  db 0x00, 0x00                ; 00002E20  add [bx+si],al
  db 0x00, 0x00                ; 00002E22  add [bx+si],al
  db 0x00, 0x00                ; 00002E24  add [bx+si],al
  db 0x00, 0x00                ; 00002E26  add [bx+si],al
  db 0x00, 0x00                ; 00002E28  add [bx+si],al
  db 0x00, 0x00                ; 00002E2A  add [bx+si],al
  db 0x00, 0x00                ; 00002E2C  add [bx+si],al
  db 0x00, 0x00                ; 00002E2E  add [bx+si],al
  db 0x00, 0x00                ; 00002E30  add [bx+si],al
  db 0x00, 0x00                ; 00002E32  add [bx+si],al
  db 0x00, 0x00                ; 00002E34  add [bx+si],al
  db 0x00, 0x00                ; 00002E36  add [bx+si],al
  db 0x00, 0x00                ; 00002E38  add [bx+si],al
  db 0x00, 0x00                ; 00002E3A  add [bx+si],al
  db 0x00, 0x00                ; 00002E3C  add [bx+si],al
  db 0x00, 0x00                ; 00002E3E  add [bx+si],al
  db 0x00, 0x00                ; 00002E40  add [bx+si],al
  db 0x00, 0x00                ; 00002E42  add [bx+si],al
  db 0x00, 0x00                ; 00002E44  add [bx+si],al
  db 0x00, 0x00                ; 00002E46  add [bx+si],al
  db 0x00, 0x00                ; 00002E48  add [bx+si],al
  db 0x00, 0x00                ; 00002E4A  add [bx+si],al
  db 0x00, 0x00                ; 00002E4C  add [bx+si],al
  db 0x00, 0x00                ; 00002E4E  add [bx+si],al
  db 0x00, 0x00                ; 00002E50  add [bx+si],al
  db 0x00, 0x00                ; 00002E52  add [bx+si],al
  db 0x00, 0x00                ; 00002E54  add [bx+si],al
  db 0x00, 0x00                ; 00002E56  add [bx+si],al
  db 0x00, 0x00                ; 00002E58  add [bx+si],al
  db 0x00, 0x00                ; 00002E5A  add [bx+si],al
  db 0x00, 0x00                ; 00002E5C  add [bx+si],al
  db 0x00, 0x00                ; 00002E5E  add [bx+si],al
  db 0x00, 0x00                ; 00002E60  add [bx+si],al
  db 0x00, 0x00                ; 00002E62  add [bx+si],al
  db 0x00, 0x00                ; 00002E64  add [bx+si],al
  db 0x00, 0x00                ; 00002E66  add [bx+si],al
  db 0x00, 0x00                ; 00002E68  add [bx+si],al
  db 0x00, 0x00                ; 00002E6A  add [bx+si],al
  db 0x00, 0x00                ; 00002E6C  add [bx+si],al
  db 0x00, 0x00                ; 00002E6E  add [bx+si],al
  db 0x00, 0x00                ; 00002E70  add [bx+si],al
  db 0x00, 0x00                ; 00002E72  add [bx+si],al
  db 0x00, 0x00                ; 00002E74  add [bx+si],al
  db 0x00, 0x00                ; 00002E76  add [bx+si],al
  db 0x00, 0x00                ; 00002E78  add [bx+si],al
  db 0x00, 0x00                ; 00002E7A  add [bx+si],al
  db 0x00, 0x00                ; 00002E7C  add [bx+si],al
  db 0x00, 0x00                ; 00002E7E  add [bx+si],al
  db 0x00, 0x00                ; 00002E80  add [bx+si],al
  db 0x00, 0x00                ; 00002E82  add [bx+si],al
  db 0x00, 0x00                ; 00002E84  add [bx+si],al
  db 0x00, 0x00                ; 00002E86  add [bx+si],al
  db 0x00, 0x00                ; 00002E88  add [bx+si],al
  db 0x00, 0x00                ; 00002E8A  add [bx+si],al
  db 0x00, 0x00                ; 00002E8C  add [bx+si],al
  db 0x00, 0x00                ; 00002E8E  add [bx+si],al
  db 0x00, 0x00                ; 00002E90  add [bx+si],al
  db 0x00, 0x00                ; 00002E92  add [bx+si],al
  db 0x00, 0x00                ; 00002E94  add [bx+si],al
  db 0x00, 0x00                ; 00002E96  add [bx+si],al
  db 0x00, 0x00                ; 00002E98  add [bx+si],al
  db 0x00, 0x00                ; 00002E9A  add [bx+si],al
  db 0x00, 0x00                ; 00002E9C  add [bx+si],al
  db 0x00, 0x00                ; 00002E9E  add [bx+si],al
  db 0x00, 0x00                ; 00002EA0  add [bx+si],al
  db 0x00, 0x00                ; 00002EA2  add [bx+si],al
  db 0x00, 0x00                ; 00002EA4  add [bx+si],al
  db 0x00, 0x00                ; 00002EA6  add [bx+si],al
  db 0x00, 0x00                ; 00002EA8  add [bx+si],al
  db 0x00, 0x00                ; 00002EAA  add [bx+si],al
  db 0x00, 0x00                ; 00002EAC  add [bx+si],al
  db 0x00, 0x00                ; 00002EAE  add [bx+si],al
  db 0x00, 0x00                ; 00002EB0  add [bx+si],al
  db 0x00, 0x00                ; 00002EB2  add [bx+si],al
  db 0x00, 0x00                ; 00002EB4  add [bx+si],al
  db 0x00, 0x00                ; 00002EB6  add [bx+si],al
  db 0x00, 0x00                ; 00002EB8  add [bx+si],al
  db 0x00, 0x00                ; 00002EBA  add [bx+si],al
  db 0x00, 0x00                ; 00002EBC  add [bx+si],al
  db 0x00, 0x00                ; 00002EBE  add [bx+si],al
  db 0x00, 0x00                ; 00002EC0  add [bx+si],al
  db 0x00, 0x00                ; 00002EC2  add [bx+si],al
  db 0x00, 0x00                ; 00002EC4  add [bx+si],al
  db 0x00, 0x00                ; 00002EC6  add [bx+si],al
  db 0x00, 0x00                ; 00002EC8  add [bx+si],al
  db 0x00, 0x00                ; 00002ECA  add [bx+si],al
  db 0x00, 0x00                ; 00002ECC  add [bx+si],al
  db 0x00, 0x00                ; 00002ECE  add [bx+si],al
  db 0x00, 0x00                ; 00002ED0  add [bx+si],al
  db 0x00, 0x00                ; 00002ED2  add [bx+si],al
  db 0x00, 0x00                ; 00002ED4  add [bx+si],al
  db 0x00, 0x00                ; 00002ED6  add [bx+si],al
  db 0x00, 0x00                ; 00002ED8  add [bx+si],al
  db 0x00, 0x00                ; 00002EDA  add [bx+si],al
  db 0x00, 0x00                ; 00002EDC  add [bx+si],al
  db 0x00, 0x00                ; 00002EDE  add [bx+si],al
  db 0x00, 0x00                ; 00002EE0  add [bx+si],al
  db 0x00, 0x00                ; 00002EE2  add [bx+si],al
  db 0x00, 0x00                ; 00002EE4  add [bx+si],al
  db 0x00, 0x00                ; 00002EE6  add [bx+si],al
  db 0x00, 0x00                ; 00002EE8  add [bx+si],al
  db 0x00, 0x00                ; 00002EEA  add [bx+si],al
  db 0x00, 0x00                ; 00002EEC  add [bx+si],al
  db 0x00, 0x00                ; 00002EEE  add [bx+si],al
  db 0x00, 0x00                ; 00002EF0  add [bx+si],al
  db 0x00, 0x00                ; 00002EF2  add [bx+si],al
  db 0x00, 0x00                ; 00002EF4  add [bx+si],al
  db 0x00, 0x00                ; 00002EF6  add [bx+si],al
  db 0x00, 0x00                ; 00002EF8  add [bx+si],al
  db 0x00, 0x00                ; 00002EFA  add [bx+si],al
  db 0x00, 0x00                ; 00002EFC  add [bx+si],al
  db 0x00, 0x00                ; 00002EFE  add [bx+si],al
  db 0x00, 0x00                ; 00002F00  add [bx+si],al
  db 0x00, 0x00                ; 00002F02  add [bx+si],al
  db 0x00, 0x00                ; 00002F04  add [bx+si],al
  db 0x00, 0x00                ; 00002F06  add [bx+si],al
  db 0x00, 0x00                ; 00002F08  add [bx+si],al
  db 0x00, 0x00                ; 00002F0A  add [bx+si],al
  db 0x00, 0x00                ; 00002F0C  add [bx+si],al
  db 0x00, 0x00                ; 00002F0E  add [bx+si],al
  db 0x00, 0x00                ; 00002F10  add [bx+si],al
  db 0x00, 0x00                ; 00002F12  add [bx+si],al
  db 0x00, 0x00                ; 00002F14  add [bx+si],al
  db 0x00, 0x00                ; 00002F16  add [bx+si],al
  db 0x00, 0x00                ; 00002F18  add [bx+si],al
  db 0x00, 0x00                ; 00002F1A  add [bx+si],al
  db 0x00, 0x00                ; 00002F1C  add [bx+si],al
  db 0x00, 0x00                ; 00002F1E  add [bx+si],al
  db 0x00, 0x00                ; 00002F20  add [bx+si],al
  db 0x00, 0x00                ; 00002F22  add [bx+si],al
  db 0x00, 0x00                ; 00002F24  add [bx+si],al
  db 0x00, 0x00                ; 00002F26  add [bx+si],al
  db 0x00, 0x00                ; 00002F28  add [bx+si],al
  db 0x00, 0x00                ; 00002F2A  add [bx+si],al
  db 0x00, 0x00                ; 00002F2C  add [bx+si],al
  db 0x00, 0x00                ; 00002F2E  add [bx+si],al
  db 0x00, 0x00                ; 00002F30  add [bx+si],al
  db 0x00, 0x00                ; 00002F32  add [bx+si],al
  db 0x00, 0x00                ; 00002F34  add [bx+si],al
  db 0x00, 0x00                ; 00002F36  add [bx+si],al
  db 0x00, 0x00                ; 00002F38  add [bx+si],al
  db 0x00, 0x00                ; 00002F3A  add [bx+si],al
  db 0x00, 0x00                ; 00002F3C  add [bx+si],al
  db 0x00, 0x00                ; 00002F3E  add [bx+si],al
  db 0x00, 0x00                ; 00002F40  add [bx+si],al
  db 0x00, 0x00                ; 00002F42  add [bx+si],al
  db 0x00, 0x00                ; 00002F44  add [bx+si],al
  db 0x00, 0x00                ; 00002F46  add [bx+si],al
  db 0x00, 0x00                ; 00002F48  add [bx+si],al
  db 0x00, 0x00                ; 00002F4A  add [bx+si],al
  db 0x00, 0x00                ; 00002F4C  add [bx+si],al
  db 0x00, 0x00                ; 00002F4E  add [bx+si],al
  db 0x00, 0x00                ; 00002F50  add [bx+si],al
  db 0x00, 0x00                ; 00002F52  add [bx+si],al
  db 0x00, 0x00                ; 00002F54  add [bx+si],al
  db 0x00, 0x00                ; 00002F56  add [bx+si],al
  db 0x00, 0x00                ; 00002F58  add [bx+si],al
  db 0x00, 0x00                ; 00002F5A  add [bx+si],al
  db 0x00, 0x00                ; 00002F5C  add [bx+si],al
  db 0x00, 0x00                ; 00002F5E  add [bx+si],al
  db 0x00, 0x00                ; 00002F60  add [bx+si],al
  db 0x00, 0x00                ; 00002F62  add [bx+si],al
  db 0x00, 0x00                ; 00002F64  add [bx+si],al
  db 0x00, 0x00                ; 00002F66  add [bx+si],al
  db 0x00, 0x00                ; 00002F68  add [bx+si],al
  db 0x00, 0x00                ; 00002F6A  add [bx+si],al
  db 0x00, 0x00                ; 00002F6C  add [bx+si],al
  db 0x00, 0x00                ; 00002F6E  add [bx+si],al
  db 0x00, 0x00                ; 00002F70  add [bx+si],al
  db 0x00, 0x00                ; 00002F72  add [bx+si],al
  db 0x00, 0x00                ; 00002F74  add [bx+si],al
  db 0x00, 0x00                ; 00002F76  add [bx+si],al
  db 0x00, 0x00                ; 00002F78  add [bx+si],al
  db 0x00, 0x00                ; 00002F7A  add [bx+si],al
  db 0x00, 0x00                ; 00002F7C  add [bx+si],al
  db 0x00, 0x00                ; 00002F7E  add [bx+si],al
  db 0x00, 0x00                ; 00002F80  add [bx+si],al
  db 0x00, 0x00                ; 00002F82  add [bx+si],al
  db 0x00, 0x00                ; 00002F84  add [bx+si],al
  db 0x00, 0x00                ; 00002F86  add [bx+si],al
  db 0x00, 0x00                ; 00002F88  add [bx+si],al
  db 0x00, 0x00                ; 00002F8A  add [bx+si],al
  db 0x00, 0x00                ; 00002F8C  add [bx+si],al
  db 0x00, 0x00                ; 00002F8E  add [bx+si],al
  db 0x00, 0x00                ; 00002F90  add [bx+si],al
  db 0x00, 0x00                ; 00002F92  add [bx+si],al
  db 0x00, 0x00                ; 00002F94  add [bx+si],al
  db 0x00, 0x00                ; 00002F96  add [bx+si],al
  db 0x00, 0x00                ; 00002F98  add [bx+si],al
  db 0x00, 0x00                ; 00002F9A  add [bx+si],al
  db 0x00, 0x00                ; 00002F9C  add [bx+si],al
  db 0x00, 0x00                ; 00002F9E  add [bx+si],al
  db 0x00, 0x00                ; 00002FA0  add [bx+si],al
  db 0x00, 0x00                ; 00002FA2  add [bx+si],al
  db 0x00, 0x00                ; 00002FA4  add [bx+si],al
  db 0x00, 0x00                ; 00002FA6  add [bx+si],al
  db 0x00, 0x00                ; 00002FA8  add [bx+si],al
  db 0x00, 0x00                ; 00002FAA  add [bx+si],al
  db 0x00, 0x00                ; 00002FAC  add [bx+si],al
  db 0x00, 0x00                ; 00002FAE  add [bx+si],al
  db 0x00, 0x00                ; 00002FB0  add [bx+si],al
  db 0x00, 0x00                ; 00002FB2  add [bx+si],al
  db 0x00, 0x00                ; 00002FB4  add [bx+si],al
  db 0x00, 0x00                ; 00002FB6  add [bx+si],al
  db 0x00, 0x00                ; 00002FB8  add [bx+si],al
  db 0x00, 0x00                ; 00002FBA  add [bx+si],al
  db 0x00, 0x00                ; 00002FBC  add [bx+si],al
  db 0x00, 0x00                ; 00002FBE  add [bx+si],al
  db 0x00, 0x00                ; 00002FC0  add [bx+si],al
  db 0x00, 0x00                ; 00002FC2  add [bx+si],al
  db 0x00, 0x00                ; 00002FC4  add [bx+si],al
  db 0x00, 0x00                ; 00002FC6  add [bx+si],al
  db 0x00, 0x00                ; 00002FC8  add [bx+si],al
  db 0x00, 0x00                ; 00002FCA  add [bx+si],al
  db 0x00, 0x00                ; 00002FCC  add [bx+si],al
  db 0x00, 0x00                ; 00002FCE  add [bx+si],al
  db 0x00, 0x00                ; 00002FD0  add [bx+si],al
  db 0x00, 0x00                ; 00002FD2  add [bx+si],al
  db 0x00, 0x00                ; 00002FD4  add [bx+si],al
  db 0x00, 0x00                ; 00002FD6  add [bx+si],al
  db 0x00, 0x00                ; 00002FD8  add [bx+si],al
  db 0x00, 0x00                ; 00002FDA  add [bx+si],al
  db 0x00, 0x00                ; 00002FDC  add [bx+si],al
  db 0x00, 0x00                ; 00002FDE  add [bx+si],al
  db 0x00, 0x00                ; 00002FE0  add [bx+si],al
  db 0x00, 0x00                ; 00002FE2  add [bx+si],al
  db 0x00, 0x00                ; 00002FE4  add [bx+si],al
  db 0x00, 0x00                ; 00002FE6  add [bx+si],al
  db 0x00, 0x00                ; 00002FE8  add [bx+si],al
  db 0x00, 0x00                ; 00002FEA  add [bx+si],al
  db 0x00, 0x00                ; 00002FEC  add [bx+si],al
  db 0x00, 0x00                ; 00002FEE  add [bx+si],al
  db 0x00, 0x00                ; 00002FF0  add [bx+si],al
  db 0x00, 0x00                ; 00002FF2  add [bx+si],al
  db 0x00, 0x00                ; 00002FF4  add [bx+si],al
  db 0x00, 0x00                ; 00002FF6  add [bx+si],al
  db 0x00, 0x00                ; 00002FF8  add [bx+si],al
  db 0x00, 0x00                ; 00002FFA  add [bx+si],al
  db 0x00, 0x00                ; 00002FFC  add [bx+si],al
  db 0x00, 0x00                ; 00002FFE  add [bx+si],al
  db 0x00, 0x00                ; 00003000  add [bx+si],al
  db 0x00, 0x00                ; 00003002  add [bx+si],al
  db 0x00, 0x00                ; 00003004  add [bx+si],al
  db 0x00, 0x00                ; 00003006  add [bx+si],al
  db 0x00, 0x00                ; 00003008  add [bx+si],al
  db 0x00, 0x00                ; 0000300A  add [bx+si],al
  db 0x00, 0x00                ; 0000300C  add [bx+si],al
  db 0x00, 0x00                ; 0000300E  add [bx+si],al
  db 0x00, 0x00                ; 00003010  add [bx+si],al
  db 0x00, 0x00                ; 00003012  add [bx+si],al
  db 0x00, 0x00                ; 00003014  add [bx+si],al
  db 0x00, 0x00                ; 00003016  add [bx+si],al
  db 0x00, 0x00                ; 00003018  add [bx+si],al
  db 0x00, 0x00                ; 0000301A  add [bx+si],al
  db 0x00, 0x00                ; 0000301C  add [bx+si],al
  db 0x00, 0x00                ; 0000301E  add [bx+si],al
  db 0x00, 0x00                ; 00003020  add [bx+si],al
  db 0x00, 0x00                ; 00003022  add [bx+si],al
  db 0x00, 0x00                ; 00003024  add [bx+si],al
  db 0x00, 0x00                ; 00003026  add [bx+si],al
  db 0x00, 0x00                ; 00003028  add [bx+si],al
  db 0x00, 0x00                ; 0000302A  add [bx+si],al
  db 0x00, 0x00                ; 0000302C  add [bx+si],al
  db 0x00, 0x00                ; 0000302E  add [bx+si],al
  db 0x00, 0x00                ; 00003030  add [bx+si],al
  db 0x00, 0x00                ; 00003032  add [bx+si],al
  db 0x00, 0x00                ; 00003034  add [bx+si],al
  db 0x00, 0x00                ; 00003036  add [bx+si],al
  db 0x00, 0x00                ; 00003038  add [bx+si],al
  db 0x00, 0x00                ; 0000303A  add [bx+si],al
  db 0x00, 0x00                ; 0000303C  add [bx+si],al
  db 0x00, 0x00                ; 0000303E  add [bx+si],al
  db 0x00, 0x00                ; 00003040  add [bx+si],al
  db 0x00, 0x00                ; 00003042  add [bx+si],al
  db 0x00, 0x00                ; 00003044  add [bx+si],al
  db 0x00, 0x00                ; 00003046  add [bx+si],al
  db 0x00, 0x00                ; 00003048  add [bx+si],al
  db 0x00, 0x00                ; 0000304A  add [bx+si],al
  db 0x00, 0x00                ; 0000304C  add [bx+si],al
  db 0x00, 0x00                ; 0000304E  add [bx+si],al
  db 0x00, 0x00                ; 00003050  add [bx+si],al
  db 0x00, 0x00                ; 00003052  add [bx+si],al
  db 0x00, 0x00                ; 00003054  add [bx+si],al
  db 0x00, 0x00                ; 00003056  add [bx+si],al
  db 0x00, 0x00                ; 00003058  add [bx+si],al
  db 0x00, 0x00                ; 0000305A  add [bx+si],al
  db 0x00, 0x00                ; 0000305C  add [bx+si],al
  db 0x00, 0x00                ; 0000305E  add [bx+si],al
  db 0x00, 0x00                ; 00003060  add [bx+si],al
  db 0x00, 0x00                ; 00003062  add [bx+si],al
  db 0x00, 0x00                ; 00003064  add [bx+si],al
  db 0x00, 0x00                ; 00003066  add [bx+si],al
  db 0x00, 0x00                ; 00003068  add [bx+si],al
  db 0x00, 0x00                ; 0000306A  add [bx+si],al
  db 0x00, 0x00                ; 0000306C  add [bx+si],al
  db 0x00, 0x00                ; 0000306E  add [bx+si],al
  db 0x00, 0x00                ; 00003070  add [bx+si],al
  db 0x00, 0x00                ; 00003072  add [bx+si],al
  db 0x00, 0x00                ; 00003074  add [bx+si],al
  db 0x00, 0x00                ; 00003076  add [bx+si],al
  db 0x00, 0x00                ; 00003078  add [bx+si],al
  db 0x00, 0x00                ; 0000307A  add [bx+si],al
  db 0x00, 0x00                ; 0000307C  add [bx+si],al
  db 0x00, 0x00                ; 0000307E  add [bx+si],al
  db 0x00, 0x00                ; 00003080  add [bx+si],al
  db 0x00, 0x00                ; 00003082  add [bx+si],al
  db 0x00, 0x00                ; 00003084  add [bx+si],al
  db 0x00, 0x00                ; 00003086  add [bx+si],al
  db 0x00, 0x00                ; 00003088  add [bx+si],al
  db 0x00, 0x00                ; 0000308A  add [bx+si],al
  db 0x00, 0x00                ; 0000308C  add [bx+si],al
  db 0x00, 0x00                ; 0000308E  add [bx+si],al
  db 0x00, 0x00                ; 00003090  add [bx+si],al
  db 0x00, 0x00                ; 00003092  add [bx+si],al
  db 0x00, 0x00                ; 00003094  add [bx+si],al
  db 0x00, 0x00                ; 00003096  add [bx+si],al
  db 0x00, 0x00                ; 00003098  add [bx+si],al
  db 0x00, 0x00                ; 0000309A  add [bx+si],al
  db 0x00, 0x00                ; 0000309C  add [bx+si],al
  db 0x00, 0x00                ; 0000309E  add [bx+si],al
  db 0x00, 0x00                ; 000030A0  add [bx+si],al
  db 0x00, 0x00                ; 000030A2  add [bx+si],al
  db 0x00, 0x00                ; 000030A4  add [bx+si],al
  db 0x00, 0x00                ; 000030A6  add [bx+si],al
  db 0x00, 0x00                ; 000030A8  add [bx+si],al
  db 0x00, 0x00                ; 000030AA  add [bx+si],al
  db 0x00, 0x00                ; 000030AC  add [bx+si],al
  db 0x00, 0x00                ; 000030AE  add [bx+si],al
  db 0x00, 0x00                ; 000030B0  add [bx+si],al
  db 0x00, 0x00                ; 000030B2  add [bx+si],al
  db 0x00, 0x00                ; 000030B4  add [bx+si],al
  db 0x00, 0x00                ; 000030B6  add [bx+si],al
  db 0x00, 0x00                ; 000030B8  add [bx+si],al
  db 0x00, 0x00                ; 000030BA  add [bx+si],al
  db 0x00, 0x00                ; 000030BC  add [bx+si],al
  db 0x00, 0x00                ; 000030BE  add [bx+si],al
  db 0x00, 0x00                ; 000030C0  add [bx+si],al
  db 0x00, 0x00                ; 000030C2  add [bx+si],al
  db 0x00, 0x00                ; 000030C4  add [bx+si],al
  db 0x00, 0x00                ; 000030C6  add [bx+si],al
  db 0x00, 0x00                ; 000030C8  add [bx+si],al
  db 0x00, 0x00                ; 000030CA  add [bx+si],al
  db 0x00, 0x00                ; 000030CC  add [bx+si],al
  db 0x00, 0x00                ; 000030CE  add [bx+si],al
  db 0x00, 0x00                ; 000030D0  add [bx+si],al
  db 0x00, 0x00                ; 000030D2  add [bx+si],al
  db 0x00, 0x00                ; 000030D4  add [bx+si],al
  db 0x00, 0x00                ; 000030D6  add [bx+si],al
  db 0x00, 0x00                ; 000030D8  add [bx+si],al
  db 0x00, 0x00                ; 000030DA  add [bx+si],al
  db 0x00, 0x00                ; 000030DC  add [bx+si],al
  db 0x00, 0x00                ; 000030DE  add [bx+si],al
  db 0x00, 0x00                ; 000030E0  add [bx+si],al
  db 0x00, 0x00                ; 000030E2  add [bx+si],al
  db 0x00, 0x00                ; 000030E4  add [bx+si],al
  db 0x00, 0x00                ; 000030E6  add [bx+si],al
  db 0x00, 0x00                ; 000030E8  add [bx+si],al
  db 0x00, 0x00                ; 000030EA  add [bx+si],al
  db 0x00, 0x00                ; 000030EC  add [bx+si],al
  db 0x00, 0x00                ; 000030EE  add [bx+si],al
  db 0x00, 0x00                ; 000030F0  add [bx+si],al
  db 0x00, 0x00                ; 000030F2  add [bx+si],al
  db 0x00, 0x00                ; 000030F4  add [bx+si],al
  db 0x00, 0x00                ; 000030F6  add [bx+si],al
  db 0x00, 0x00                ; 000030F8  add [bx+si],al
  db 0x00, 0x00                ; 000030FA  add [bx+si],al
  db 0x00, 0x00                ; 000030FC  add [bx+si],al
  db 0x00, 0x00                ; 000030FE  add [bx+si],al
  db 0x00, 0x00                ; 00003100  add [bx+si],al
  db 0x00, 0x00                ; 00003102  add [bx+si],al
  db 0x00, 0x00                ; 00003104  add [bx+si],al
  db 0x00, 0x00                ; 00003106  add [bx+si],al
  db 0x00, 0x00                ; 00003108  add [bx+si],al
  db 0x00, 0x00                ; 0000310A  add [bx+si],al
  db 0x00, 0x00                ; 0000310C  add [bx+si],al
  db 0x00, 0x00                ; 0000310E  add [bx+si],al
  db 0x00, 0x00                ; 00003110  add [bx+si],al
  db 0x00, 0x00                ; 00003112  add [bx+si],al
  db 0x00, 0x00                ; 00003114  add [bx+si],al
  db 0x00, 0x00                ; 00003116  add [bx+si],al
  db 0x00, 0x00                ; 00003118  add [bx+si],al
  db 0x00, 0x00                ; 0000311A  add [bx+si],al
  db 0x00, 0x00                ; 0000311C  add [bx+si],al
  db 0x00, 0x00                ; 0000311E  add [bx+si],al
  db 0x00, 0x00                ; 00003120  add [bx+si],al
  db 0x00, 0x00                ; 00003122  add [bx+si],al
  db 0x00, 0x00                ; 00003124  add [bx+si],al
  db 0x00, 0x00                ; 00003126  add [bx+si],al
  db 0x00, 0x00                ; 00003128  add [bx+si],al
  db 0x00, 0x00                ; 0000312A  add [bx+si],al
  db 0x00, 0x00                ; 0000312C  add [bx+si],al
  db 0x00, 0x00                ; 0000312E  add [bx+si],al
  db 0x00, 0x00                ; 00003130  add [bx+si],al
  db 0x00, 0x00                ; 00003132  add [bx+si],al
  db 0x00, 0x00                ; 00003134  add [bx+si],al
  db 0x00, 0x00                ; 00003136  add [bx+si],al
  db 0x00, 0x00                ; 00003138  add [bx+si],al
  db 0x00, 0x00                ; 0000313A  add [bx+si],al
  db 0x00, 0x00                ; 0000313C  add [bx+si],al
  db 0x00, 0x00                ; 0000313E  add [bx+si],al
  db 0x00, 0x00                ; 00003140  add [bx+si],al
  db 0x00, 0x00                ; 00003142  add [bx+si],al
  db 0x00, 0x00                ; 00003144  add [bx+si],al
  db 0x00, 0x00                ; 00003146  add [bx+si],al
  db 0x00, 0x00                ; 00003148  add [bx+si],al
  db 0x00, 0x00                ; 0000314A  add [bx+si],al
  db 0x00, 0x00                ; 0000314C  add [bx+si],al
  db 0x00, 0x00                ; 0000314E  add [bx+si],al
  db 0x00, 0x00                ; 00003150  add [bx+si],al
  db 0x00, 0x00                ; 00003152  add [bx+si],al
  db 0x00, 0x00                ; 00003154  add [bx+si],al
  db 0x00, 0x00                ; 00003156  add [bx+si],al
  db 0x00, 0x00                ; 00003158  add [bx+si],al
  db 0x00, 0x00                ; 0000315A  add [bx+si],al
  db 0x00, 0x00                ; 0000315C  add [bx+si],al
  db 0x00, 0x00                ; 0000315E  add [bx+si],al
  db 0x00, 0x00                ; 00003160  add [bx+si],al
  db 0x00, 0x00                ; 00003162  add [bx+si],al
  db 0x00, 0x00                ; 00003164  add [bx+si],al
  db 0x00, 0x00                ; 00003166  add [bx+si],al
  db 0x00, 0x00                ; 00003168  add [bx+si],al
  db 0x00, 0x00                ; 0000316A  add [bx+si],al
  db 0x00, 0x00                ; 0000316C  add [bx+si],al
  db 0x00, 0x00                ; 0000316E  add [bx+si],al
  db 0x00, 0x00                ; 00003170  add [bx+si],al
  db 0x00, 0x00                ; 00003172  add [bx+si],al
  db 0x00, 0x00                ; 00003174  add [bx+si],al
  db 0x00, 0x00                ; 00003176  add [bx+si],al
  db 0x00, 0x00                ; 00003178  add [bx+si],al
  db 0x00, 0x00                ; 0000317A  add [bx+si],al
  db 0x00, 0x00                ; 0000317C  add [bx+si],al
  db 0x00, 0x00                ; 0000317E  add [bx+si],al
  db 0x00, 0x00                ; 00003180  add [bx+si],al
  db 0x00, 0x00                ; 00003182  add [bx+si],al
  db 0x00, 0x00                ; 00003184  add [bx+si],al
  db 0x00, 0x00                ; 00003186  add [bx+si],al
  db 0x00, 0x00                ; 00003188  add [bx+si],al
  db 0x00, 0x00                ; 0000318A  add [bx+si],al
  db 0x00, 0x00                ; 0000318C  add [bx+si],al
  db 0x00, 0x00                ; 0000318E  add [bx+si],al
  db 0x00, 0x00                ; 00003190  add [bx+si],al
  db 0x00, 0x00                ; 00003192  add [bx+si],al
  db 0x00, 0x00                ; 00003194  add [bx+si],al
  db 0x00, 0x00                ; 00003196  add [bx+si],al
  db 0x00, 0x00                ; 00003198  add [bx+si],al
  db 0x00, 0x00                ; 0000319A  add [bx+si],al
  db 0x00, 0x00                ; 0000319C  add [bx+si],al
  db 0x00, 0x00                ; 0000319E  add [bx+si],al
  db 0x00, 0x00                ; 000031A0  add [bx+si],al
  db 0x00, 0x00                ; 000031A2  add [bx+si],al
  db 0x00, 0x00                ; 000031A4  add [bx+si],al
  db 0x00, 0x00                ; 000031A6  add [bx+si],al
  db 0x00, 0x00                ; 000031A8  add [bx+si],al
  db 0x00, 0x00                ; 000031AA  add [bx+si],al
  db 0x00, 0x00                ; 000031AC  add [bx+si],al
  db 0x00, 0x00                ; 000031AE  add [bx+si],al
  db 0x00, 0x00                ; 000031B0  add [bx+si],al
  db 0x00, 0x00                ; 000031B2  add [bx+si],al
  db 0x00, 0x00                ; 000031B4  add [bx+si],al
  db 0x00, 0x00                ; 000031B6  add [bx+si],al
  db 0x00, 0x00                ; 000031B8  add [bx+si],al
  db 0x00, 0x00                ; 000031BA  add [bx+si],al
  db 0x00, 0x00                ; 000031BC  add [bx+si],al
  db 0x00, 0x00                ; 000031BE  add [bx+si],al
  db 0x00, 0x00                ; 000031C0  add [bx+si],al
  db 0x00, 0x00                ; 000031C2  add [bx+si],al
  db 0x00, 0x00                ; 000031C4  add [bx+si],al
  db 0x00, 0x00                ; 000031C6  add [bx+si],al
  db 0x00, 0x00                ; 000031C8  add [bx+si],al
  db 0x00, 0x00                ; 000031CA  add [bx+si],al
  db 0x00, 0x00                ; 000031CC  add [bx+si],al
  db 0x00, 0x00                ; 000031CE  add [bx+si],al
  db 0x00, 0x00                ; 000031D0  add [bx+si],al
  db 0x00, 0x00                ; 000031D2  add [bx+si],al
  db 0x00, 0x00                ; 000031D4  add [bx+si],al
  db 0x00, 0x00                ; 000031D6  add [bx+si],al
  db 0x00, 0x00                ; 000031D8  add [bx+si],al
  db 0x00, 0x00                ; 000031DA  add [bx+si],al
  db 0x00, 0x00                ; 000031DC  add [bx+si],al
  db 0x00, 0x00                ; 000031DE  add [bx+si],al
  db 0x00, 0x00                ; 000031E0  add [bx+si],al
  db 0x00, 0x00                ; 000031E2  add [bx+si],al
  db 0x00, 0x00                ; 000031E4  add [bx+si],al
  db 0x00, 0x00                ; 000031E6  add [bx+si],al
  db 0x00, 0x00                ; 000031E8  add [bx+si],al
  db 0x00, 0x00                ; 000031EA  add [bx+si],al
  db 0x00, 0x00                ; 000031EC  add [bx+si],al
  db 0x00, 0x00                ; 000031EE  add [bx+si],al
  db 0x00, 0x00                ; 000031F0  add [bx+si],al
  db 0x00, 0x00                ; 000031F2  add [bx+si],al
  db 0x00, 0x00                ; 000031F4  add [bx+si],al
  db 0x00, 0x00                ; 000031F6  add [bx+si],al
  db 0x00, 0x00                ; 000031F8  add [bx+si],al
  db 0x00, 0x00                ; 000031FA  add [bx+si],al
  db 0x00, 0x00                ; 000031FC  add [bx+si],al
  db 0x00, 0x00                ; 000031FE  add [bx+si],al
  db 0x00, 0x00                ; 00003200  add [bx+si],al
  db 0x00, 0x00                ; 00003202  add [bx+si],al
  db 0x00, 0x00                ; 00003204  add [bx+si],al
  db 0x00, 0x00                ; 00003206  add [bx+si],al
  db 0x00, 0x00                ; 00003208  add [bx+si],al
  db 0x00, 0x00                ; 0000320A  add [bx+si],al
  db 0x00, 0x00                ; 0000320C  add [bx+si],al
  db 0x00, 0x00                ; 0000320E  add [bx+si],al
  db 0x00, 0x00                ; 00003210  add [bx+si],al
  db 0x00, 0x00                ; 00003212  add [bx+si],al
  db 0x00, 0x00                ; 00003214  add [bx+si],al
  db 0x00, 0x00                ; 00003216  add [bx+si],al
  db 0x00, 0x00                ; 00003218  add [bx+si],al
  db 0x00, 0x00                ; 0000321A  add [bx+si],al
  db 0x00, 0x00                ; 0000321C  add [bx+si],al
  db 0x00, 0x00                ; 0000321E  add [bx+si],al
  db 0x00, 0x00                ; 00003220  add [bx+si],al
  db 0x00, 0x00                ; 00003222  add [bx+si],al
  db 0x00, 0x00                ; 00003224  add [bx+si],al
  db 0x00, 0x00                ; 00003226  add [bx+si],al
  db 0x00, 0x00                ; 00003228  add [bx+si],al
  db 0x00, 0x00                ; 0000322A  add [bx+si],al
  db 0x00, 0x00                ; 0000322C  add [bx+si],al
  db 0x00, 0x00                ; 0000322E  add [bx+si],al
  db 0x00, 0x00                ; 00003230  add [bx+si],al
  db 0x00, 0x00                ; 00003232  add [bx+si],al
  db 0x00, 0x00                ; 00003234  add [bx+si],al
  db 0x00, 0x00                ; 00003236  add [bx+si],al
  db 0x00, 0x00                ; 00003238  add [bx+si],al
  db 0x00, 0x00                ; 0000323A  add [bx+si],al
  db 0x00, 0x00                ; 0000323C  add [bx+si],al
  db 0x00, 0x00                ; 0000323E  add [bx+si],al
  db 0x00, 0x00                ; 00003240  add [bx+si],al
  db 0x00, 0x00                ; 00003242  add [bx+si],al
  db 0x00, 0x00                ; 00003244  add [bx+si],al
  db 0x00, 0x00                ; 00003246  add [bx+si],al
  db 0x00, 0x00                ; 00003248  add [bx+si],al
  db 0x00, 0x00                ; 0000324A  add [bx+si],al
  db 0x00, 0x00                ; 0000324C  add [bx+si],al
  db 0x00, 0x00                ; 0000324E  add [bx+si],al
  db 0x00, 0x00                ; 00003250  add [bx+si],al
  db 0x00, 0x00                ; 00003252  add [bx+si],al
  db 0x00, 0x00                ; 00003254  add [bx+si],al
  db 0x00, 0x00                ; 00003256  add [bx+si],al
  db 0x00, 0x00                ; 00003258  add [bx+si],al
  db 0x00, 0x00                ; 0000325A  add [bx+si],al
  db 0x00, 0x00                ; 0000325C  add [bx+si],al
  db 0x00, 0x00                ; 0000325E  add [bx+si],al
  db 0x00, 0x00                ; 00003260  add [bx+si],al
  db 0x00, 0x00                ; 00003262  add [bx+si],al
  db 0x00, 0x00                ; 00003264  add [bx+si],al
  db 0x00, 0x00                ; 00003266  add [bx+si],al
  db 0x00, 0x00                ; 00003268  add [bx+si],al
  db 0x00, 0x00                ; 0000326A  add [bx+si],al
  db 0x00, 0x00                ; 0000326C  add [bx+si],al
  db 0x00, 0x00                ; 0000326E  add [bx+si],al
  db 0x00, 0x00                ; 00003270  add [bx+si],al
  db 0x00, 0x00                ; 00003272  add [bx+si],al
  db 0x00, 0x00                ; 00003274  add [bx+si],al
  db 0x00, 0x00                ; 00003276  add [bx+si],al
  db 0x00, 0x00                ; 00003278  add [bx+si],al
  db 0x00, 0x00                ; 0000327A  add [bx+si],al
  db 0x00, 0x00                ; 0000327C  add [bx+si],al
  db 0x00, 0x00                ; 0000327E  add [bx+si],al
  db 0x00, 0x00                ; 00003280  add [bx+si],al
  db 0x00, 0x00                ; 00003282  add [bx+si],al
  db 0x00, 0x00                ; 00003284  add [bx+si],al
  db 0x00, 0x00                ; 00003286  add [bx+si],al
  db 0x00, 0x00                ; 00003288  add [bx+si],al
  db 0x00, 0x00                ; 0000328A  add [bx+si],al
  db 0x00, 0x00                ; 0000328C  add [bx+si],al
  db 0x00, 0x00                ; 0000328E  add [bx+si],al
  db 0x00, 0x00                ; 00003290  add [bx+si],al
  db 0x00, 0x00                ; 00003292  add [bx+si],al
  db 0x00, 0x00                ; 00003294  add [bx+si],al
  db 0x00, 0x00                ; 00003296  add [bx+si],al
  db 0x00, 0x00                ; 00003298  add [bx+si],al
  db 0x00, 0x00                ; 0000329A  add [bx+si],al
  db 0x00, 0x00                ; 0000329C  add [bx+si],al
  db 0x00, 0x00                ; 0000329E  add [bx+si],al
  db 0x00, 0x00                ; 000032A0  add [bx+si],al
  db 0x00, 0x00                ; 000032A2  add [bx+si],al
  db 0x00, 0x00                ; 000032A4  add [bx+si],al
  db 0x00, 0x00                ; 000032A6  add [bx+si],al
  db 0x00, 0x00                ; 000032A8  add [bx+si],al
  db 0x00, 0x00                ; 000032AA  add [bx+si],al
  db 0x00, 0x00                ; 000032AC  add [bx+si],al
  db 0x00, 0x00                ; 000032AE  add [bx+si],al
  db 0x00, 0x00                ; 000032B0  add [bx+si],al
  db 0x00, 0x00                ; 000032B2  add [bx+si],al
  db 0x00, 0x00                ; 000032B4  add [bx+si],al
  db 0x00, 0x00                ; 000032B6  add [bx+si],al
  db 0x00, 0x00                ; 000032B8  add [bx+si],al
  db 0x00, 0x00                ; 000032BA  add [bx+si],al
  db 0x00, 0x00                ; 000032BC  add [bx+si],al
  db 0x00, 0x00                ; 000032BE  add [bx+si],al
  db 0x00, 0x00                ; 000032C0  add [bx+si],al
  db 0x00, 0x00                ; 000032C2  add [bx+si],al
  db 0x00, 0x00                ; 000032C4  add [bx+si],al
  db 0x00, 0x00                ; 000032C6  add [bx+si],al
  db 0x00, 0x00                ; 000032C8  add [bx+si],al
  db 0x00, 0x00                ; 000032CA  add [bx+si],al
  db 0x00, 0x00                ; 000032CC  add [bx+si],al
  db 0x00, 0x00                ; 000032CE  add [bx+si],al
  db 0x00, 0x00                ; 000032D0  add [bx+si],al
  db 0x00, 0x00                ; 000032D2  add [bx+si],al
  db 0x00, 0x00                ; 000032D4  add [bx+si],al
  db 0x00, 0x00                ; 000032D6  add [bx+si],al
  db 0x00, 0x00                ; 000032D8  add [bx+si],al
  db 0x00, 0x00                ; 000032DA  add [bx+si],al
  db 0x00, 0x00                ; 000032DC  add [bx+si],al
  db 0x00, 0x00                ; 000032DE  add [bx+si],al
  db 0x00, 0x00                ; 000032E0  add [bx+si],al
  db 0x00, 0x00                ; 000032E2  add [bx+si],al
  db 0x00, 0x00                ; 000032E4  add [bx+si],al
  db 0x00, 0x00                ; 000032E6  add [bx+si],al
  db 0x00, 0x00                ; 000032E8  add [bx+si],al
  db 0x00, 0x00                ; 000032EA  add [bx+si],al
  db 0x00, 0x00                ; 000032EC  add [bx+si],al
  db 0x00, 0x00                ; 000032EE  add [bx+si],al
  db 0x00, 0x00                ; 000032F0  add [bx+si],al
  db 0x00, 0x00                ; 000032F2  add [bx+si],al
  db 0x00, 0x00                ; 000032F4  add [bx+si],al
  db 0x00, 0x00                ; 000032F6  add [bx+si],al
  db 0x00, 0x00                ; 000032F8  add [bx+si],al
  db 0x00, 0x00                ; 000032FA  add [bx+si],al
  db 0x00, 0x00                ; 000032FC  add [bx+si],al
  db 0x00, 0x00                ; 000032FE  add [bx+si],al
  db 0x00, 0x00                ; 00003300  add [bx+si],al
  db 0x00, 0x00                ; 00003302  add [bx+si],al
  db 0x00, 0x00                ; 00003304  add [bx+si],al
  db 0x00, 0x00                ; 00003306  add [bx+si],al
  db 0x00, 0x00                ; 00003308  add [bx+si],al
  db 0x00, 0x00                ; 0000330A  add [bx+si],al
  db 0x00, 0x00                ; 0000330C  add [bx+si],al
  db 0x00, 0x00                ; 0000330E  add [bx+si],al
  db 0x00, 0x00                ; 00003310  add [bx+si],al
  db 0x00, 0x00                ; 00003312  add [bx+si],al
  db 0x00, 0x00                ; 00003314  add [bx+si],al
  db 0x00, 0x00                ; 00003316  add [bx+si],al
  db 0x00, 0x00                ; 00003318  add [bx+si],al
  db 0x00, 0x00                ; 0000331A  add [bx+si],al
  db 0x00, 0x00                ; 0000331C  add [bx+si],al
  db 0x00, 0x00                ; 0000331E  add [bx+si],al
  db 0x00, 0x00                ; 00003320  add [bx+si],al
  db 0x00, 0x00                ; 00003322  add [bx+si],al
  db 0x00, 0x00                ; 00003324  add [bx+si],al
  db 0x00, 0x00                ; 00003326  add [bx+si],al
  db 0x00, 0x00                ; 00003328  add [bx+si],al
  db 0x00, 0x00                ; 0000332A  add [bx+si],al
  db 0x00, 0x00                ; 0000332C  add [bx+si],al
  db 0x00, 0x00                ; 0000332E  add [bx+si],al
  db 0x00, 0x00                ; 00003330  add [bx+si],al
  db 0x00, 0x00                ; 00003332  add [bx+si],al
  db 0x00, 0x00                ; 00003334  add [bx+si],al
  db 0x00, 0x00                ; 00003336  add [bx+si],al
  db 0x00, 0x00                ; 00003338  add [bx+si],al
  db 0x00, 0x00                ; 0000333A  add [bx+si],al
  db 0x00, 0x00                ; 0000333C  add [bx+si],al
  db 0x00, 0x00                ; 0000333E  add [bx+si],al
  db 0x00, 0x00                ; 00003340  add [bx+si],al
  db 0x00, 0x00                ; 00003342  add [bx+si],al
  db 0x00, 0x00                ; 00003344  add [bx+si],al
  db 0x00, 0x00                ; 00003346  add [bx+si],al
  db 0x00, 0x00                ; 00003348  add [bx+si],al
  db 0x00, 0x00                ; 0000334A  add [bx+si],al
  db 0x00, 0x00                ; 0000334C  add [bx+si],al
  db 0x00, 0x00                ; 0000334E  add [bx+si],al
  db 0x00, 0x00                ; 00003350  add [bx+si],al
  db 0x00, 0x00                ; 00003352  add [bx+si],al
  db 0x00, 0x00                ; 00003354  add [bx+si],al
  db 0x00, 0x00                ; 00003356  add [bx+si],al
  db 0x00, 0x00                ; 00003358  add [bx+si],al
  db 0x00, 0x00                ; 0000335A  add [bx+si],al
  db 0x00, 0x00                ; 0000335C  add [bx+si],al
  db 0x00, 0x00                ; 0000335E  add [bx+si],al
  db 0x00, 0x00                ; 00003360  add [bx+si],al
  db 0x00, 0x00                ; 00003362  add [bx+si],al
  db 0x00, 0x00                ; 00003364  add [bx+si],al
  db 0x00, 0x00                ; 00003366  add [bx+si],al
  db 0x00, 0x00                ; 00003368  add [bx+si],al
  db 0x00, 0x00                ; 0000336A  add [bx+si],al
  db 0x00, 0x00                ; 0000336C  add [bx+si],al
  db 0x00, 0x00                ; 0000336E  add [bx+si],al
  db 0x00, 0x00                ; 00003370  add [bx+si],al
  db 0x00, 0x00                ; 00003372  add [bx+si],al
  db 0x00, 0x00                ; 00003374  add [bx+si],al
  db 0x00, 0x00                ; 00003376  add [bx+si],al
  db 0x00, 0x00                ; 00003378  add [bx+si],al
  db 0x00, 0x00                ; 0000337A  add [bx+si],al
  db 0x00, 0x00                ; 0000337C  add [bx+si],al
  db 0x00, 0x00                ; 0000337E  add [bx+si],al
  db 0x00, 0x00                ; 00003380  add [bx+si],al
  db 0x00, 0x00                ; 00003382  add [bx+si],al
  db 0x00, 0x00                ; 00003384  add [bx+si],al
  db 0x00, 0x00                ; 00003386  add [bx+si],al
  db 0x00, 0x00                ; 00003388  add [bx+si],al
  db 0x00, 0x00                ; 0000338A  add [bx+si],al
  db 0x00, 0x00                ; 0000338C  add [bx+si],al
  db 0x00, 0x00                ; 0000338E  add [bx+si],al
  db 0x00, 0x00                ; 00003390  add [bx+si],al
  db 0x00, 0x00                ; 00003392  add [bx+si],al
  db 0x00, 0x00                ; 00003394  add [bx+si],al
  db 0x00, 0x00                ; 00003396  add [bx+si],al
  db 0x00, 0x00                ; 00003398  add [bx+si],al
  db 0x00, 0x00                ; 0000339A  add [bx+si],al
  db 0x00, 0x00                ; 0000339C  add [bx+si],al
  db 0x00, 0x00                ; 0000339E  add [bx+si],al
  db 0x00, 0x00                ; 000033A0  add [bx+si],al
  db 0x00, 0x00                ; 000033A2  add [bx+si],al
  db 0x00, 0x00                ; 000033A4  add [bx+si],al
  db 0x00, 0x00                ; 000033A6  add [bx+si],al
  db 0x00, 0x00                ; 000033A8  add [bx+si],al
  db 0x00, 0x00                ; 000033AA  add [bx+si],al
  db 0x00, 0x00                ; 000033AC  add [bx+si],al
  db 0x00, 0x00                ; 000033AE  add [bx+si],al
  db 0x00, 0x00                ; 000033B0  add [bx+si],al
  db 0x00, 0x00                ; 000033B2  add [bx+si],al
  db 0x00, 0x00                ; 000033B4  add [bx+si],al
  db 0x00, 0x00                ; 000033B6  add [bx+si],al
  db 0x00, 0x00                ; 000033B8  add [bx+si],al
  db 0x00, 0x00                ; 000033BA  add [bx+si],al
  db 0x00, 0x00                ; 000033BC  add [bx+si],al
  db 0x00, 0x00                ; 000033BE  add [bx+si],al
  db 0x00, 0x00                ; 000033C0  add [bx+si],al
  db 0x00, 0x00                ; 000033C2  add [bx+si],al
  db 0x00, 0x00                ; 000033C4  add [bx+si],al
  db 0x00, 0x00                ; 000033C6  add [bx+si],al
  db 0x00, 0x00                ; 000033C8  add [bx+si],al
  db 0x00, 0x00                ; 000033CA  add [bx+si],al
  db 0x00, 0x00                ; 000033CC  add [bx+si],al
  db 0x00, 0x00                ; 000033CE  add [bx+si],al
  db 0x00, 0x00                ; 000033D0  add [bx+si],al
  db 0x00, 0x00                ; 000033D2  add [bx+si],al
  db 0x00, 0x00                ; 000033D4  add [bx+si],al
  db 0x00, 0x00                ; 000033D6  add [bx+si],al
  db 0x00, 0x00                ; 000033D8  add [bx+si],al
  db 0x00, 0x00                ; 000033DA  add [bx+si],al
  db 0x00, 0x00                ; 000033DC  add [bx+si],al
  db 0x00, 0x00                ; 000033DE  add [bx+si],al
  db 0x00, 0x00                ; 000033E0  add [bx+si],al
  db 0x00, 0x00                ; 000033E2  add [bx+si],al
  db 0x00, 0x00                ; 000033E4  add [bx+si],al
  db 0x00, 0x00                ; 000033E6  add [bx+si],al
  db 0x00, 0x00                ; 000033E8  add [bx+si],al
  db 0x00, 0x00                ; 000033EA  add [bx+si],al
  db 0x00, 0x00                ; 000033EC  add [bx+si],al
  db 0x00, 0x00                ; 000033EE  add [bx+si],al
  db 0x00, 0x00                ; 000033F0  add [bx+si],al
  db 0x00, 0x00                ; 000033F2  add [bx+si],al
  db 0x00, 0x00                ; 000033F4  add [bx+si],al
  db 0x00, 0x00                ; 000033F6  add [bx+si],al
  db 0x00, 0x00                ; 000033F8  add [bx+si],al
  db 0x00, 0x00                ; 000033FA  add [bx+si],al
  db 0x00, 0x00                ; 000033FC  add [bx+si],al
  db 0x00, 0x00                ; 000033FE  add [bx+si],al
  db 0x00, 0x00                ; 00003400  add [bx+si],al
  db 0x00, 0x00                ; 00003402  add [bx+si],al
  db 0x00, 0x00                ; 00003404  add [bx+si],al
  db 0x00, 0x00                ; 00003406  add [bx+si],al
  db 0x00, 0x00                ; 00003408  add [bx+si],al
  db 0x00, 0x00                ; 0000340A  add [bx+si],al
  db 0x00, 0x00                ; 0000340C  add [bx+si],al
  db 0x00, 0x00                ; 0000340E  add [bx+si],al
  db 0x00, 0x00                ; 00003410  add [bx+si],al
  db 0x00, 0x00                ; 00003412  add [bx+si],al
  db 0x00, 0x00                ; 00003414  add [bx+si],al
  db 0x00, 0x00                ; 00003416  add [bx+si],al
  db 0x00, 0x00                ; 00003418  add [bx+si],al
  db 0x00, 0x00                ; 0000341A  add [bx+si],al
  db 0x00, 0x00                ; 0000341C  add [bx+si],al
  db 0x00, 0x00                ; 0000341E  add [bx+si],al
  db 0x00, 0x00                ; 00003420  add [bx+si],al
  db 0x00, 0x00                ; 00003422  add [bx+si],al
  db 0x00, 0x00                ; 00003424  add [bx+si],al
  db 0x00, 0x00                ; 00003426  add [bx+si],al
  db 0x00, 0x00                ; 00003428  add [bx+si],al
  db 0x00, 0x00                ; 0000342A  add [bx+si],al
  db 0x00, 0x00                ; 0000342C  add [bx+si],al
  db 0x00, 0x00                ; 0000342E  add [bx+si],al
  db 0x00, 0x00                ; 00003430  add [bx+si],al
  db 0x00, 0x00                ; 00003432  add [bx+si],al
  db 0x00, 0x00                ; 00003434  add [bx+si],al
  db 0x00, 0x00                ; 00003436  add [bx+si],al
  db 0x00, 0x00                ; 00003438  add [bx+si],al
  db 0x00, 0x00                ; 0000343A  add [bx+si],al
  db 0x00, 0x00                ; 0000343C  add [bx+si],al
  db 0x00, 0x00                ; 0000343E  add [bx+si],al
  db 0x00, 0x00                ; 00003440  add [bx+si],al
  db 0x00, 0x00                ; 00003442  add [bx+si],al
  db 0x00, 0x00                ; 00003444  add [bx+si],al
  db 0x00, 0x00                ; 00003446  add [bx+si],al
  db 0x00, 0x00                ; 00003448  add [bx+si],al
  db 0x00, 0x00                ; 0000344A  add [bx+si],al
  db 0x00, 0x00                ; 0000344C  add [bx+si],al
  db 0x00, 0x00                ; 0000344E  add [bx+si],al
  db 0x00, 0x00                ; 00003450  add [bx+si],al
  db 0x00, 0x00                ; 00003452  add [bx+si],al
  db 0x00, 0x00                ; 00003454  add [bx+si],al
  db 0x00, 0x00                ; 00003456  add [bx+si],al
  db 0x00, 0x00                ; 00003458  add [bx+si],al
  db 0x00, 0x00                ; 0000345A  add [bx+si],al
  db 0x00, 0x00                ; 0000345C  add [bx+si],al
  db 0x00, 0x00                ; 0000345E  add [bx+si],al
  db 0x00, 0x00                ; 00003460  add [bx+si],al
  db 0x00, 0x00                ; 00003462  add [bx+si],al
  db 0x00, 0x00                ; 00003464  add [bx+si],al
  db 0x00, 0x00                ; 00003466  add [bx+si],al
  db 0x00, 0x00                ; 00003468  add [bx+si],al
  db 0x00, 0x00                ; 0000346A  add [bx+si],al
  db 0x00, 0x00                ; 0000346C  add [bx+si],al
  db 0x00, 0x00                ; 0000346E  add [bx+si],al
  db 0x00, 0x00                ; 00003470  add [bx+si],al
  db 0x00, 0x00                ; 00003472  add [bx+si],al
  db 0x00, 0x00                ; 00003474  add [bx+si],al
  db 0x00, 0x00                ; 00003476  add [bx+si],al
  db 0x00, 0x00                ; 00003478  add [bx+si],al
  db 0x00, 0x00                ; 0000347A  add [bx+si],al
  db 0x00, 0x00                ; 0000347C  add [bx+si],al
  db 0x00, 0x00                ; 0000347E  add [bx+si],al
  db 0x00, 0x00                ; 00003480  add [bx+si],al
  db 0x00, 0x00                ; 00003482  add [bx+si],al
  db 0x00, 0x00                ; 00003484  add [bx+si],al
  db 0x00, 0x00                ; 00003486  add [bx+si],al
  db 0x00, 0x00                ; 00003488  add [bx+si],al
  db 0x00, 0x00                ; 0000348A  add [bx+si],al
  db 0x00, 0x00                ; 0000348C  add [bx+si],al
  db 0x00, 0x00                ; 0000348E  add [bx+si],al
  db 0x00, 0x00                ; 00003490  add [bx+si],al
  db 0x00, 0x00                ; 00003492  add [bx+si],al
  db 0x00, 0x00                ; 00003494  add [bx+si],al
  db 0x00, 0x00                ; 00003496  add [bx+si],al
  db 0x00, 0x00                ; 00003498  add [bx+si],al
  db 0x00, 0x00                ; 0000349A  add [bx+si],al
  db 0x00, 0x00                ; 0000349C  add [bx+si],al
  db 0x00, 0x00                ; 0000349E  add [bx+si],al
  db 0x00, 0x00                ; 000034A0  add [bx+si],al
  db 0x00, 0x00                ; 000034A2  add [bx+si],al
  db 0x00, 0x00                ; 000034A4  add [bx+si],al
  db 0x00, 0x00                ; 000034A6  add [bx+si],al
  db 0x00, 0x00                ; 000034A8  add [bx+si],al
  db 0x00, 0x00                ; 000034AA  add [bx+si],al
  db 0x00, 0x00                ; 000034AC  add [bx+si],al
  db 0x00, 0x00                ; 000034AE  add [bx+si],al
  db 0x00, 0x00                ; 000034B0  add [bx+si],al
  db 0x00, 0x00                ; 000034B2  add [bx+si],al
  db 0x00, 0x00                ; 000034B4  add [bx+si],al
  db 0x00, 0x00                ; 000034B6  add [bx+si],al
  db 0x00, 0x00                ; 000034B8  add [bx+si],al
  db 0x00, 0x00                ; 000034BA  add [bx+si],al
  db 0x00, 0x00                ; 000034BC  add [bx+si],al
  db 0x00, 0x00                ; 000034BE  add [bx+si],al
  db 0x00, 0x00                ; 000034C0  add [bx+si],al
  db 0x00, 0x00                ; 000034C2  add [bx+si],al
  db 0x00, 0x00                ; 000034C4  add [bx+si],al
  db 0x00, 0x00                ; 000034C6  add [bx+si],al
  db 0x00, 0x00                ; 000034C8  add [bx+si],al
  db 0x00, 0x00                ; 000034CA  add [bx+si],al
  db 0x00, 0x00                ; 000034CC  add [bx+si],al
  db 0x00, 0x00                ; 000034CE  add [bx+si],al
  db 0x00, 0x00                ; 000034D0  add [bx+si],al
  db 0x00, 0x00                ; 000034D2  add [bx+si],al
  db 0x00, 0x00                ; 000034D4  add [bx+si],al
  db 0x00, 0x00                ; 000034D6  add [bx+si],al
  db 0x00, 0x00                ; 000034D8  add [bx+si],al
  db 0x00, 0x00                ; 000034DA  add [bx+si],al
  db 0x00, 0x00                ; 000034DC  add [bx+si],al
  db 0x00, 0x00                ; 000034DE  add [bx+si],al
  db 0x00, 0x00                ; 000034E0  add [bx+si],al
  db 0x00, 0x00                ; 000034E2  add [bx+si],al
  db 0x00, 0x00                ; 000034E4  add [bx+si],al
  db 0x00, 0x00                ; 000034E6  add [bx+si],al
  db 0x00, 0x00                ; 000034E8  add [bx+si],al
  db 0x00, 0x00                ; 000034EA  add [bx+si],al
  db 0x00, 0x00                ; 000034EC  add [bx+si],al
  db 0x00, 0x00                ; 000034EE  add [bx+si],al
  db 0x00, 0x00                ; 000034F0  add [bx+si],al
  db 0x00, 0x00                ; 000034F2  add [bx+si],al
  db 0x00, 0x00                ; 000034F4  add [bx+si],al
  db 0x00, 0x00                ; 000034F6  add [bx+si],al
  db 0x00, 0x00                ; 000034F8  add [bx+si],al
  db 0x00, 0x00                ; 000034FA  add [bx+si],al
  db 0x00, 0x00                ; 000034FC  add [bx+si],al
  db 0x00, 0x00                ; 000034FE  add [bx+si],al
  db 0x00, 0x00                ; 00003500  add [bx+si],al
  db 0x00, 0x00                ; 00003502  add [bx+si],al
  db 0x00, 0x00                ; 00003504  add [bx+si],al
  db 0x00, 0x00                ; 00003506  add [bx+si],al
  db 0x00, 0x00                ; 00003508  add [bx+si],al
  db 0x00, 0x00                ; 0000350A  add [bx+si],al
  db 0x00, 0x00                ; 0000350C  add [bx+si],al
  db 0x00, 0x00                ; 0000350E  add [bx+si],al
  db 0x00, 0x00                ; 00003510  add [bx+si],al
  db 0x00, 0x00                ; 00003512  add [bx+si],al
  db 0x00, 0x00                ; 00003514  add [bx+si],al
  db 0x00, 0x00                ; 00003516  add [bx+si],al
  db 0x00, 0x00                ; 00003518  add [bx+si],al
  db 0x00, 0x00                ; 0000351A  add [bx+si],al
  db 0x00, 0x00                ; 0000351C  add [bx+si],al
  db 0x00, 0x00                ; 0000351E  add [bx+si],al
  db 0x00, 0x00                ; 00003520  add [bx+si],al
  db 0x00, 0x00                ; 00003522  add [bx+si],al
  db 0x00, 0x00                ; 00003524  add [bx+si],al
  db 0x00, 0x00                ; 00003526  add [bx+si],al
  db 0x00, 0x00                ; 00003528  add [bx+si],al
  db 0x00, 0x00                ; 0000352A  add [bx+si],al
  db 0x00, 0x00                ; 0000352C  add [bx+si],al
  db 0x00, 0x00                ; 0000352E  add [bx+si],al
  db 0x00, 0x00                ; 00003530  add [bx+si],al
  db 0x00, 0x00                ; 00003532  add [bx+si],al
  db 0x00, 0x00                ; 00003534  add [bx+si],al
  db 0x00, 0x00                ; 00003536  add [bx+si],al
  db 0x00, 0x00                ; 00003538  add [bx+si],al
  db 0x00, 0x00                ; 0000353A  add [bx+si],al
  db 0x00, 0x00                ; 0000353C  add [bx+si],al
  db 0x00, 0x00                ; 0000353E  add [bx+si],al
  db 0x00, 0x00                ; 00003540  add [bx+si],al
  db 0x00, 0x00                ; 00003542  add [bx+si],al
  db 0x00, 0x00                ; 00003544  add [bx+si],al
  db 0x00, 0x00                ; 00003546  add [bx+si],al
  db 0x00, 0x00                ; 00003548  add [bx+si],al
  db 0x00, 0x00                ; 0000354A  add [bx+si],al
  db 0x00, 0x00                ; 0000354C  add [bx+si],al
  db 0x00, 0x00                ; 0000354E  add [bx+si],al
  db 0x00, 0x00                ; 00003550  add [bx+si],al
  db 0x00, 0x00                ; 00003552  add [bx+si],al
  db 0x00, 0x00                ; 00003554  add [bx+si],al
  db 0x00, 0x00                ; 00003556  add [bx+si],al
  db 0x00, 0x00                ; 00003558  add [bx+si],al
  db 0x00, 0x00                ; 0000355A  add [bx+si],al
  db 0x00, 0x00                ; 0000355C  add [bx+si],al
  db 0x00, 0x00                ; 0000355E  add [bx+si],al
  db 0x00, 0x00                ; 00003560  add [bx+si],al
  db 0x00, 0x00                ; 00003562  add [bx+si],al
  db 0x00, 0x00                ; 00003564  add [bx+si],al
  db 0x00, 0x00                ; 00003566  add [bx+si],al
  db 0x00, 0x00                ; 00003568  add [bx+si],al
  db 0x00, 0x00                ; 0000356A  add [bx+si],al
  db 0x00, 0x00                ; 0000356C  add [bx+si],al
  db 0x00, 0x00                ; 0000356E  add [bx+si],al
  db 0x00, 0x00                ; 00003570  add [bx+si],al
  db 0x00, 0x00                ; 00003572  add [bx+si],al
  db 0x00, 0x00                ; 00003574  add [bx+si],al
  db 0x00, 0x00                ; 00003576  add [bx+si],al
  db 0x00, 0x00                ; 00003578  add [bx+si],al
  db 0x00, 0x00                ; 0000357A  add [bx+si],al
  db 0x00, 0x00                ; 0000357C  add [bx+si],al
  db 0x00, 0x00                ; 0000357E  add [bx+si],al
  db 0x00, 0x00                ; 00003580  add [bx+si],al
  db 0x00, 0x00                ; 00003582  add [bx+si],al
  db 0x00, 0x00                ; 00003584  add [bx+si],al
  db 0x00, 0x00                ; 00003586  add [bx+si],al
  db 0x00, 0x00                ; 00003588  add [bx+si],al
  db 0x00, 0x00                ; 0000358A  add [bx+si],al
  db 0x00, 0x00                ; 0000358C  add [bx+si],al
  db 0x00, 0x00                ; 0000358E  add [bx+si],al
  db 0x00, 0x00                ; 00003590  add [bx+si],al
  db 0x00, 0x00                ; 00003592  add [bx+si],al
  db 0x00, 0x00                ; 00003594  add [bx+si],al
  db 0x00, 0x00                ; 00003596  add [bx+si],al
  db 0x00, 0x00                ; 00003598  add [bx+si],al
  db 0x00, 0x00                ; 0000359A  add [bx+si],al
  db 0x00, 0x00                ; 0000359C  add [bx+si],al
  db 0x00, 0x00                ; 0000359E  add [bx+si],al
  db 0x00, 0x00                ; 000035A0  add [bx+si],al
  db 0x00, 0x00                ; 000035A2  add [bx+si],al
  db 0x00, 0x00                ; 000035A4  add [bx+si],al
  db 0x00, 0x00                ; 000035A6  add [bx+si],al
  db 0x00, 0x00                ; 000035A8  add [bx+si],al
  db 0x00, 0x00                ; 000035AA  add [bx+si],al
  db 0x00, 0x00                ; 000035AC  add [bx+si],al
  db 0x00, 0x00                ; 000035AE  add [bx+si],al
  db 0x00, 0x00                ; 000035B0  add [bx+si],al
  db 0x00, 0x00                ; 000035B2  add [bx+si],al
  db 0x00, 0x00                ; 000035B4  add [bx+si],al
  db 0x00, 0x00                ; 000035B6  add [bx+si],al
  db 0x00, 0x00                ; 000035B8  add [bx+si],al
  db 0x00, 0x00                ; 000035BA  add [bx+si],al
  db 0x00, 0x00                ; 000035BC  add [bx+si],al
  db 0x00, 0x00                ; 000035BE  add [bx+si],al
  db 0x00, 0x00                ; 000035C0  add [bx+si],al
  db 0x00, 0x00                ; 000035C2  add [bx+si],al
  db 0x00, 0x00                ; 000035C4  add [bx+si],al
  db 0x00, 0x00                ; 000035C6  add [bx+si],al
  db 0x00, 0x00                ; 000035C8  add [bx+si],al
  db 0x00, 0x00                ; 000035CA  add [bx+si],al
  db 0x00, 0x00                ; 000035CC  add [bx+si],al
  db 0x00, 0x00                ; 000035CE  add [bx+si],al
  db 0x00, 0x00                ; 000035D0  add [bx+si],al
  db 0x00, 0x00                ; 000035D2  add [bx+si],al
  db 0x00, 0x00                ; 000035D4  add [bx+si],al
  db 0x00, 0x00                ; 000035D6  add [bx+si],al
  db 0x00, 0x00                ; 000035D8  add [bx+si],al
  db 0x00, 0x00                ; 000035DA  add [bx+si],al
  db 0x00, 0x00                ; 000035DC  add [bx+si],al
  db 0x00, 0x00                ; 000035DE  add [bx+si],al
  db 0x00, 0x00                ; 000035E0  add [bx+si],al
  db 0x00, 0x00                ; 000035E2  add [bx+si],al
  db 0x00, 0x00                ; 000035E4  add [bx+si],al
  db 0x00, 0x00                ; 000035E6  add [bx+si],al
  db 0x00, 0x00                ; 000035E8  add [bx+si],al
  db 0x00, 0x00                ; 000035EA  add [bx+si],al
  db 0x00, 0x00                ; 000035EC  add [bx+si],al
  db 0x00, 0x00                ; 000035EE  add [bx+si],al
  db 0x00, 0x00                ; 000035F0  add [bx+si],al
  db 0x00, 0x00                ; 000035F2  add [bx+si],al
  db 0x00, 0x00                ; 000035F4  add [bx+si],al
  db 0x00, 0x00                ; 000035F6  add [bx+si],al
  db 0x00, 0x00                ; 000035F8  add [bx+si],al
  db 0x00, 0x00                ; 000035FA  add [bx+si],al
  db 0x00, 0x00                ; 000035FC  add [bx+si],al
  db 0x00, 0x00                ; 000035FE  add [bx+si],al
  db 0x00, 0x00                ; 00003600  add [bx+si],al
  db 0x00, 0x00                ; 00003602  add [bx+si],al
  db 0x00, 0x00                ; 00003604  add [bx+si],al
  db 0x00, 0x00                ; 00003606  add [bx+si],al
  db 0x00, 0x00                ; 00003608  add [bx+si],al
  db 0x00, 0x00                ; 0000360A  add [bx+si],al
  db 0x00, 0x00                ; 0000360C  add [bx+si],al
  db 0x00, 0x00                ; 0000360E  add [bx+si],al
  db 0x00, 0x00                ; 00003610  add [bx+si],al
  db 0x00, 0x00                ; 00003612  add [bx+si],al
  db 0x00, 0x00                ; 00003614  add [bx+si],al
  db 0x00, 0x00                ; 00003616  add [bx+si],al
  db 0x00, 0x00                ; 00003618  add [bx+si],al
  db 0x00, 0x00                ; 0000361A  add [bx+si],al
  db 0x00, 0x00                ; 0000361C  add [bx+si],al
  db 0x00, 0x00                ; 0000361E  add [bx+si],al
  db 0x00, 0x00                ; 00003620  add [bx+si],al
  db 0x00, 0x00                ; 00003622  add [bx+si],al
  db 0x00, 0x00                ; 00003624  add [bx+si],al
  db 0x00, 0x00                ; 00003626  add [bx+si],al
  db 0x00, 0x00                ; 00003628  add [bx+si],al
  db 0x00, 0x00                ; 0000362A  add [bx+si],al
  db 0x00, 0x00                ; 0000362C  add [bx+si],al
  db 0x00, 0x00                ; 0000362E  add [bx+si],al
  db 0x00, 0x00                ; 00003630  add [bx+si],al
  db 0x00, 0x00                ; 00003632  add [bx+si],al
  db 0x00, 0x00                ; 00003634  add [bx+si],al
  db 0x00, 0x00                ; 00003636  add [bx+si],al
  db 0x00, 0x00                ; 00003638  add [bx+si],al
  db 0x00, 0x00                ; 0000363A  add [bx+si],al
  db 0x00, 0x00                ; 0000363C  add [bx+si],al
  db 0x00, 0x00                ; 0000363E  add [bx+si],al
  db 0x00, 0x00                ; 00003640  add [bx+si],al
  db 0x00, 0x00                ; 00003642  add [bx+si],al
  db 0x00, 0x00                ; 00003644  add [bx+si],al
  db 0x00, 0x00                ; 00003646  add [bx+si],al
  db 0x00, 0x00                ; 00003648  add [bx+si],al
  db 0x00, 0x00                ; 0000364A  add [bx+si],al
  db 0x00, 0x00                ; 0000364C  add [bx+si],al
  db 0x00, 0x00                ; 0000364E  add [bx+si],al
  db 0x00, 0x00                ; 00003650  add [bx+si],al
  db 0x00, 0x00                ; 00003652  add [bx+si],al
  db 0x00, 0x00                ; 00003654  add [bx+si],al
  db 0x00, 0x00                ; 00003656  add [bx+si],al
  db 0x00, 0x00                ; 00003658  add [bx+si],al
  db 0x00, 0x00                ; 0000365A  add [bx+si],al
  db 0x00, 0x00                ; 0000365C  add [bx+si],al
  db 0x00, 0x00                ; 0000365E  add [bx+si],al
  db 0x00, 0x00                ; 00003660  add [bx+si],al
  db 0x00, 0x00                ; 00003662  add [bx+si],al
  db 0x00, 0x00                ; 00003664  add [bx+si],al
  db 0x00, 0x00                ; 00003666  add [bx+si],al
  db 0x00, 0x00                ; 00003668  add [bx+si],al
  db 0x00, 0x00                ; 0000366A  add [bx+si],al
  db 0x00, 0x00                ; 0000366C  add [bx+si],al
  db 0x00, 0x00                ; 0000366E  add [bx+si],al
  db 0x00, 0x00                ; 00003670  add [bx+si],al
  db 0x00, 0x00                ; 00003672  add [bx+si],al
  db 0x00, 0x00                ; 00003674  add [bx+si],al
  db 0x00, 0x00                ; 00003676  add [bx+si],al
  db 0x00, 0x00                ; 00003678  add [bx+si],al
  db 0x00, 0x00                ; 0000367A  add [bx+si],al
  db 0x00, 0x00                ; 0000367C  add [bx+si],al
  db 0x00, 0x00                ; 0000367E  add [bx+si],al
  db 0x00, 0x00                ; 00003680  add [bx+si],al
  db 0x00, 0x00                ; 00003682  add [bx+si],al
  db 0x00, 0x00                ; 00003684  add [bx+si],al
  db 0x00, 0x00                ; 00003686  add [bx+si],al
  db 0x00, 0x00                ; 00003688  add [bx+si],al
  db 0x00, 0x00                ; 0000368A  add [bx+si],al
  db 0x00, 0x00                ; 0000368C  add [bx+si],al
  db 0x00, 0x00                ; 0000368E  add [bx+si],al
  db 0x00, 0x00                ; 00003690  add [bx+si],al
  db 0x00, 0x00                ; 00003692  add [bx+si],al
  db 0x00, 0x00                ; 00003694  add [bx+si],al
  db 0x00, 0x00                ; 00003696  add [bx+si],al
  db 0x00, 0x00                ; 00003698  add [bx+si],al
  db 0x00, 0x00                ; 0000369A  add [bx+si],al
  db 0x00, 0x00                ; 0000369C  add [bx+si],al
  db 0x00, 0x00                ; 0000369E  add [bx+si],al
  db 0x00, 0x00                ; 000036A0  add [bx+si],al
  db 0x00, 0x00                ; 000036A2  add [bx+si],al
  db 0x00, 0x00                ; 000036A4  add [bx+si],al
  db 0x00, 0x00                ; 000036A6  add [bx+si],al
  db 0x00, 0x00                ; 000036A8  add [bx+si],al
  db 0x00, 0x00                ; 000036AA  add [bx+si],al
  db 0x00, 0x00                ; 000036AC  add [bx+si],al
  db 0x00, 0x00                ; 000036AE  add [bx+si],al
  db 0x00, 0x00                ; 000036B0  add [bx+si],al
  db 0x00, 0x00                ; 000036B2  add [bx+si],al
  db 0x00, 0x00                ; 000036B4  add [bx+si],al
  db 0x00, 0x00                ; 000036B6  add [bx+si],al
  db 0x00, 0x00                ; 000036B8  add [bx+si],al
  db 0x00, 0x00                ; 000036BA  add [bx+si],al
  db 0x00, 0x00                ; 000036BC  add [bx+si],al
  db 0x00, 0x00                ; 000036BE  add [bx+si],al
  db 0x00, 0x00                ; 000036C0  add [bx+si],al
  db 0x00, 0x00                ; 000036C2  add [bx+si],al
  db 0x00, 0x00                ; 000036C4  add [bx+si],al
  db 0x00, 0x00                ; 000036C6  add [bx+si],al
  db 0x00, 0x00                ; 000036C8  add [bx+si],al
  db 0x00, 0x00                ; 000036CA  add [bx+si],al
  db 0x00, 0x00                ; 000036CC  add [bx+si],al
  db 0x00, 0x00                ; 000036CE  add [bx+si],al
  db 0x00, 0x00                ; 000036D0  add [bx+si],al
  db 0x00, 0x00                ; 000036D2  add [bx+si],al
  db 0x00, 0x00                ; 000036D4  add [bx+si],al
  db 0x00, 0x00                ; 000036D6  add [bx+si],al
  db 0x00, 0x00                ; 000036D8  add [bx+si],al
  db 0x00, 0x00                ; 000036DA  add [bx+si],al
  db 0x00, 0x00                ; 000036DC  add [bx+si],al
  db 0x00, 0x00                ; 000036DE  add [bx+si],al
  db 0x00, 0x00                ; 000036E0  add [bx+si],al
  db 0x00, 0x00                ; 000036E2  add [bx+si],al
  db 0x00, 0x00                ; 000036E4  add [bx+si],al
  db 0x00, 0x00                ; 000036E6  add [bx+si],al
  db 0x00, 0x00                ; 000036E8  add [bx+si],al
  db 0x00, 0x00                ; 000036EA  add [bx+si],al
  db 0x00, 0x00                ; 000036EC  add [bx+si],al
  db 0x00, 0x00                ; 000036EE  add [bx+si],al
  db 0x00, 0x00                ; 000036F0  add [bx+si],al
  db 0x00, 0x00                ; 000036F2  add [bx+si],al
  db 0x00, 0x00                ; 000036F4  add [bx+si],al
  db 0x00, 0x00                ; 000036F6  add [bx+si],al
  db 0x00, 0x00                ; 000036F8  add [bx+si],al
  db 0x00, 0x00                ; 000036FA  add [bx+si],al
  db 0x00, 0x00                ; 000036FC  add [bx+si],al
  db 0x00, 0x00                ; 000036FE  add [bx+si],al
  db 0x00, 0x00                ; 00003700  add [bx+si],al
  db 0x00, 0x00                ; 00003702  add [bx+si],al
  db 0x00, 0x00                ; 00003704  add [bx+si],al
  db 0x00, 0x00                ; 00003706  add [bx+si],al
  db 0x00, 0x00                ; 00003708  add [bx+si],al
  db 0x00, 0x00                ; 0000370A  add [bx+si],al
  db 0x00, 0x00                ; 0000370C  add [bx+si],al
  db 0x00, 0x00                ; 0000370E  add [bx+si],al
  db 0x00, 0x00                ; 00003710  add [bx+si],al
  db 0x00, 0x00                ; 00003712  add [bx+si],al
  db 0x00, 0x00                ; 00003714  add [bx+si],al
  db 0x00, 0x00                ; 00003716  add [bx+si],al
  db 0x00, 0x00                ; 00003718  add [bx+si],al
  db 0x00, 0x00                ; 0000371A  add [bx+si],al
  db 0x00, 0x00                ; 0000371C  add [bx+si],al
  db 0x00, 0x00                ; 0000371E  add [bx+si],al
  db 0x00, 0x00                ; 00003720  add [bx+si],al
  db 0x00, 0x00                ; 00003722  add [bx+si],al
  db 0x00, 0x00                ; 00003724  add [bx+si],al
  db 0x00, 0x00                ; 00003726  add [bx+si],al
  db 0x00, 0x00                ; 00003728  add [bx+si],al
  db 0x00, 0x00                ; 0000372A  add [bx+si],al
  db 0x00, 0x00                ; 0000372C  add [bx+si],al
  db 0x00, 0x00                ; 0000372E  add [bx+si],al
  db 0x00, 0x00                ; 00003730  add [bx+si],al
  db 0x00, 0x00                ; 00003732  add [bx+si],al
  db 0x00, 0x00                ; 00003734  add [bx+si],al
  db 0x00, 0x00                ; 00003736  add [bx+si],al
  db 0x00, 0x00                ; 00003738  add [bx+si],al
  db 0x00, 0x00                ; 0000373A  add [bx+si],al
  db 0x00, 0x00                ; 0000373C  add [bx+si],al
  db 0x00, 0x00                ; 0000373E  add [bx+si],al
  db 0x00, 0x00                ; 00003740  add [bx+si],al
  db 0x00, 0x00                ; 00003742  add [bx+si],al
  db 0x00, 0x00                ; 00003744  add [bx+si],al
  db 0x00, 0x00                ; 00003746  add [bx+si],al
  db 0x00, 0x00                ; 00003748  add [bx+si],al
  db 0x00, 0x00                ; 0000374A  add [bx+si],al
  db 0x00, 0x00                ; 0000374C  add [bx+si],al
  db 0x00, 0x00                ; 0000374E  add [bx+si],al
  db 0x00, 0x00                ; 00003750  add [bx+si],al
  db 0x00, 0x00                ; 00003752  add [bx+si],al
  db 0x00, 0x00                ; 00003754  add [bx+si],al
  db 0x00, 0x00                ; 00003756  add [bx+si],al
  db 0x00, 0x00                ; 00003758  add [bx+si],al
  db 0x00, 0x00                ; 0000375A  add [bx+si],al
  db 0x00, 0x00                ; 0000375C  add [bx+si],al
  db 0x00, 0x00                ; 0000375E  add [bx+si],al
  db 0x00, 0x00                ; 00003760  add [bx+si],al
  db 0x00, 0x00                ; 00003762  add [bx+si],al
  db 0x00, 0x00                ; 00003764  add [bx+si],al
  db 0x00, 0x00                ; 00003766  add [bx+si],al
  db 0x00, 0x00                ; 00003768  add [bx+si],al
  db 0x00, 0x00                ; 0000376A  add [bx+si],al
  db 0x00, 0x00                ; 0000376C  add [bx+si],al
  db 0x00, 0x00                ; 0000376E  add [bx+si],al
  db 0x00, 0x00                ; 00003770  add [bx+si],al
  db 0x00, 0x00                ; 00003772  add [bx+si],al
  db 0x00, 0x00                ; 00003774  add [bx+si],al
  db 0x00, 0x00                ; 00003776  add [bx+si],al
  db 0x00, 0x00                ; 00003778  add [bx+si],al
  db 0x00, 0x00                ; 0000377A  add [bx+si],al
  db 0x00, 0x00                ; 0000377C  add [bx+si],al
  db 0x00, 0x00                ; 0000377E  add [bx+si],al
  db 0x00, 0x00                ; 00003780  add [bx+si],al
  db 0x00, 0x00                ; 00003782  add [bx+si],al
  db 0x00, 0x00                ; 00003784  add [bx+si],al
  db 0x00, 0x00                ; 00003786  add [bx+si],al
  db 0x00, 0x00                ; 00003788  add [bx+si],al
  db 0x00, 0x00                ; 0000378A  add [bx+si],al
  db 0x00, 0x00                ; 0000378C  add [bx+si],al
  db 0x00, 0x00                ; 0000378E  add [bx+si],al
  db 0x00, 0x00                ; 00003790  add [bx+si],al
  db 0x00, 0x00                ; 00003792  add [bx+si],al
  db 0x00, 0x00                ; 00003794  add [bx+si],al
  db 0x00, 0x00                ; 00003796  add [bx+si],al
  db 0x00, 0x00                ; 00003798  add [bx+si],al
  db 0x00, 0x00                ; 0000379A  add [bx+si],al
  db 0x00, 0x00                ; 0000379C  add [bx+si],al
  db 0x00, 0x00                ; 0000379E  add [bx+si],al
  db 0x00, 0x00                ; 000037A0  add [bx+si],al
  db 0x00, 0x00                ; 000037A2  add [bx+si],al
  db 0x00, 0x00                ; 000037A4  add [bx+si],al
  db 0x00, 0x00                ; 000037A6  add [bx+si],al
  db 0x00, 0x00                ; 000037A8  add [bx+si],al
  db 0x00, 0x00                ; 000037AA  add [bx+si],al
  db 0x00, 0x00                ; 000037AC  add [bx+si],al
  db 0x00, 0x00                ; 000037AE  add [bx+si],al
  db 0x00, 0x00                ; 000037B0  add [bx+si],al
  db 0x00, 0x00                ; 000037B2  add [bx+si],al
  db 0x00, 0x00                ; 000037B4  add [bx+si],al
  db 0x00, 0x00                ; 000037B6  add [bx+si],al
  db 0x00, 0x00                ; 000037B8  add [bx+si],al
  db 0x00, 0x00                ; 000037BA  add [bx+si],al
  db 0x00, 0x00                ; 000037BC  add [bx+si],al
  db 0x00, 0x00                ; 000037BE  add [bx+si],al
  db 0x00, 0x00                ; 000037C0  add [bx+si],al
  db 0x00, 0x00                ; 000037C2  add [bx+si],al
  db 0x00, 0x00                ; 000037C4  add [bx+si],al
  db 0x00, 0x00                ; 000037C6  add [bx+si],al
  db 0x00, 0x00                ; 000037C8  add [bx+si],al
  db 0x00, 0x00                ; 000037CA  add [bx+si],al
  db 0x00, 0x00                ; 000037CC  add [bx+si],al
  db 0x00, 0x00                ; 000037CE  add [bx+si],al
  db 0x00, 0x00                ; 000037D0  add [bx+si],al
  db 0x00, 0x00                ; 000037D2  add [bx+si],al
  db 0x00, 0x00                ; 000037D4  add [bx+si],al
  db 0x00, 0x00                ; 000037D6  add [bx+si],al
  db 0x00, 0x00                ; 000037D8  add [bx+si],al
  db 0x00, 0x00                ; 000037DA  add [bx+si],al
  db 0x00, 0x00                ; 000037DC  add [bx+si],al
  db 0x00, 0x00                ; 000037DE  add [bx+si],al
  db 0x00, 0x00                ; 000037E0  add [bx+si],al
  db 0x00, 0x00                ; 000037E2  add [bx+si],al
  db 0x00, 0x00                ; 000037E4  add [bx+si],al
  db 0x00, 0x00                ; 000037E6  add [bx+si],al
  db 0x00, 0x00                ; 000037E8  add [bx+si],al
  db 0x00, 0x00                ; 000037EA  add [bx+si],al
  db 0x00, 0x00                ; 000037EC  add [bx+si],al
  db 0x00, 0x00                ; 000037EE  add [bx+si],al
  db 0x00, 0x00                ; 000037F0  add [bx+si],al
  db 0x00, 0x00                ; 000037F2  add [bx+si],al
  db 0x00, 0x00                ; 000037F4  add [bx+si],al
  db 0x00, 0x00                ; 000037F6  add [bx+si],al
  db 0x00, 0x00                ; 000037F8  add [bx+si],al
  db 0x00, 0x00                ; 000037FA  add [bx+si],al
  db 0x00, 0x00                ; 000037FC  add [bx+si],al
  db 0x00, 0x00                ; 000037FE  add [bx+si],al
  db 0x00, 0x00                ; 00003800  add [bx+si],al
  db 0x00, 0x00                ; 00003802  add [bx+si],al
  db 0x00, 0x00                ; 00003804  add [bx+si],al
  db 0x00, 0x00                ; 00003806  add [bx+si],al
  db 0x00, 0x00                ; 00003808  add [bx+si],al
  db 0x00, 0x00                ; 0000380A  add [bx+si],al
  db 0x00, 0x00                ; 0000380C  add [bx+si],al
  db 0x00, 0x00                ; 0000380E  add [bx+si],al
  db 0x00, 0x00                ; 00003810  add [bx+si],al
  db 0x00, 0x00                ; 00003812  add [bx+si],al
  db 0x00, 0x00                ; 00003814  add [bx+si],al
  db 0x00, 0x00                ; 00003816  add [bx+si],al
  db 0x00, 0x00                ; 00003818  add [bx+si],al
  db 0x00, 0x00                ; 0000381A  add [bx+si],al
  db 0x00, 0x00                ; 0000381C  add [bx+si],al
  db 0x00, 0x00                ; 0000381E  add [bx+si],al
  db 0x00, 0x00                ; 00003820  add [bx+si],al
  db 0x00, 0x00                ; 00003822  add [bx+si],al
  db 0x00, 0x00                ; 00003824  add [bx+si],al
  db 0x00, 0x00                ; 00003826  add [bx+si],al
  db 0x00, 0x00                ; 00003828  add [bx+si],al
  db 0x00, 0x00                ; 0000382A  add [bx+si],al
  db 0x00, 0x00                ; 0000382C  add [bx+si],al
  db 0x00, 0x00                ; 0000382E  add [bx+si],al
  db 0x00, 0x00                ; 00003830  add [bx+si],al
  db 0x00, 0x00                ; 00003832  add [bx+si],al
  db 0x00, 0x00                ; 00003834  add [bx+si],al
  db 0x00, 0x00                ; 00003836  add [bx+si],al
  db 0x00, 0x00                ; 00003838  add [bx+si],al
  db 0x00, 0x00                ; 0000383A  add [bx+si],al
  db 0x00, 0x00                ; 0000383C  add [bx+si],al
  db 0x00, 0x00                ; 0000383E  add [bx+si],al
  db 0x00, 0x00                ; 00003840  add [bx+si],al
  db 0x00, 0x00                ; 00003842  add [bx+si],al
  db 0x00, 0x00                ; 00003844  add [bx+si],al
  db 0x00, 0x00                ; 00003846  add [bx+si],al
  db 0x00, 0x00                ; 00003848  add [bx+si],al
  db 0x00, 0x00                ; 0000384A  add [bx+si],al
  db 0x00, 0x00                ; 0000384C  add [bx+si],al
  db 0x00, 0x00                ; 0000384E  add [bx+si],al
  db 0x00, 0x00                ; 00003850  add [bx+si],al
  db 0x00, 0x00                ; 00003852  add [bx+si],al
  db 0x00, 0x00                ; 00003854  add [bx+si],al
  db 0x00, 0x00                ; 00003856  add [bx+si],al
  db 0x00, 0x00                ; 00003858  add [bx+si],al
  db 0x00, 0x00                ; 0000385A  add [bx+si],al
  db 0x00, 0x00                ; 0000385C  add [bx+si],al
  db 0x00, 0x00                ; 0000385E  add [bx+si],al
  db 0x00, 0x00                ; 00003860  add [bx+si],al
  db 0x00, 0x00                ; 00003862  add [bx+si],al
  db 0x00, 0x00                ; 00003864  add [bx+si],al
  db 0x00, 0x00                ; 00003866  add [bx+si],al
  db 0x00, 0x00                ; 00003868  add [bx+si],al
  db 0x00, 0x00                ; 0000386A  add [bx+si],al
  db 0x00, 0x00                ; 0000386C  add [bx+si],al
  db 0x00, 0x00                ; 0000386E  add [bx+si],al
  db 0x00, 0x00                ; 00003870  add [bx+si],al
  db 0x00, 0x00                ; 00003872  add [bx+si],al
  db 0x00, 0x00                ; 00003874  add [bx+si],al
  db 0x00, 0x00                ; 00003876  add [bx+si],al
  db 0x00, 0x00                ; 00003878  add [bx+si],al
  db 0x00, 0x00                ; 0000387A  add [bx+si],al
  db 0x00, 0x00                ; 0000387C  add [bx+si],al
  db 0x00, 0x00                ; 0000387E  add [bx+si],al
  db 0x00, 0x00                ; 00003880  add [bx+si],al
  db 0x00, 0x00                ; 00003882  add [bx+si],al
  db 0x00, 0x00                ; 00003884  add [bx+si],al
  db 0x00, 0x00                ; 00003886  add [bx+si],al
  db 0x00, 0x00                ; 00003888  add [bx+si],al
  db 0x00, 0x00                ; 0000388A  add [bx+si],al
  db 0x00, 0x00                ; 0000388C  add [bx+si],al
  db 0x00, 0x00                ; 0000388E  add [bx+si],al
  db 0x00, 0x00                ; 00003890  add [bx+si],al
  db 0x00, 0x00                ; 00003892  add [bx+si],al
  db 0x00, 0x00                ; 00003894  add [bx+si],al
  db 0x00, 0x00                ; 00003896  add [bx+si],al
  db 0x00, 0x00                ; 00003898  add [bx+si],al
  db 0x00, 0x00                ; 0000389A  add [bx+si],al
  db 0x00, 0x00                ; 0000389C  add [bx+si],al
  db 0x00, 0x00                ; 0000389E  add [bx+si],al
  db 0x00, 0x00                ; 000038A0  add [bx+si],al
  db 0x00, 0x00                ; 000038A2  add [bx+si],al
  db 0x00, 0x00                ; 000038A4  add [bx+si],al
  db 0x00, 0x00                ; 000038A6  add [bx+si],al
  db 0x00, 0x00                ; 000038A8  add [bx+si],al
  db 0x00, 0x00                ; 000038AA  add [bx+si],al
  db 0x00, 0x00                ; 000038AC  add [bx+si],al
  db 0x00, 0x00                ; 000038AE  add [bx+si],al
  db 0x00, 0x00                ; 000038B0  add [bx+si],al
  db 0x00, 0x00                ; 000038B2  add [bx+si],al
  db 0x00, 0x00                ; 000038B4  add [bx+si],al
  db 0x00, 0x00                ; 000038B6  add [bx+si],al
  db 0x00, 0x00                ; 000038B8  add [bx+si],al
  db 0x00, 0x00                ; 000038BA  add [bx+si],al
  db 0x00, 0x00                ; 000038BC  add [bx+si],al
  db 0x00, 0x00                ; 000038BE  add [bx+si],al
  db 0x00, 0x00                ; 000038C0  add [bx+si],al
  db 0x00, 0x00                ; 000038C2  add [bx+si],al
  db 0x00, 0x00                ; 000038C4  add [bx+si],al
  db 0x00, 0x00                ; 000038C6  add [bx+si],al
  db 0x00, 0x00                ; 000038C8  add [bx+si],al
  db 0x00, 0x00                ; 000038CA  add [bx+si],al
  db 0x00, 0x00                ; 000038CC  add [bx+si],al
  db 0x00, 0x00                ; 000038CE  add [bx+si],al
  db 0x00, 0x00                ; 000038D0  add [bx+si],al
  db 0x00, 0x00                ; 000038D2  add [bx+si],al
  db 0x00, 0x00                ; 000038D4  add [bx+si],al
  db 0x00, 0x00                ; 000038D6  add [bx+si],al
  db 0x00, 0x00                ; 000038D8  add [bx+si],al
  db 0x00, 0x00                ; 000038DA  add [bx+si],al
  db 0x00, 0x00                ; 000038DC  add [bx+si],al
  db 0x00, 0x00                ; 000038DE  add [bx+si],al
  db 0x00, 0x00                ; 000038E0  add [bx+si],al
  db 0x00, 0x00                ; 000038E2  add [bx+si],al
  db 0x00, 0x00                ; 000038E4  add [bx+si],al
  db 0x00, 0x00                ; 000038E6  add [bx+si],al
  db 0x00, 0x00                ; 000038E8  add [bx+si],al
  db 0x00, 0x00                ; 000038EA  add [bx+si],al
  db 0x00, 0x00                ; 000038EC  add [bx+si],al
  db 0x00, 0x00                ; 000038EE  add [bx+si],al
  db 0x00, 0x00                ; 000038F0  add [bx+si],al
  db 0x00, 0x00                ; 000038F2  add [bx+si],al
  db 0x00, 0x00                ; 000038F4  add [bx+si],al
  db 0x00, 0x00                ; 000038F6  add [bx+si],al
  db 0x00, 0x00                ; 000038F8  add [bx+si],al
  db 0x00, 0x00                ; 000038FA  add [bx+si],al
  db 0x00, 0x00                ; 000038FC  add [bx+si],al
  db 0x00, 0x00                ; 000038FE  add [bx+si],al
  db 0x00, 0x00                ; 00003900  add [bx+si],al
  db 0x00, 0x00                ; 00003902  add [bx+si],al
  db 0x00, 0x00                ; 00003904  add [bx+si],al
  db 0x00, 0x00                ; 00003906  add [bx+si],al
  db 0x00, 0x00                ; 00003908  add [bx+si],al
  db 0x00, 0x00                ; 0000390A  add [bx+si],al
  db 0x00, 0x00                ; 0000390C  add [bx+si],al
  db 0x00, 0x00                ; 0000390E  add [bx+si],al
  db 0x00, 0x00                ; 00003910  add [bx+si],al
  db 0x00, 0x00                ; 00003912  add [bx+si],al
  db 0x00, 0x00                ; 00003914  add [bx+si],al
  db 0x00, 0x00                ; 00003916  add [bx+si],al
  db 0x00, 0x00                ; 00003918  add [bx+si],al
  db 0x00, 0x00                ; 0000391A  add [bx+si],al
  db 0x00, 0x00                ; 0000391C  add [bx+si],al
  db 0x00, 0x00                ; 0000391E  add [bx+si],al
  db 0x00, 0x00                ; 00003920  add [bx+si],al
  db 0x00, 0x00                ; 00003922  add [bx+si],al
  db 0x00, 0x00                ; 00003924  add [bx+si],al
  db 0x00, 0x00                ; 00003926  add [bx+si],al
  db 0x00, 0x00                ; 00003928  add [bx+si],al
  db 0x00, 0x00                ; 0000392A  add [bx+si],al
  db 0x00, 0x00                ; 0000392C  add [bx+si],al
  db 0x00, 0x00                ; 0000392E  add [bx+si],al
  db 0x00, 0x00                ; 00003930  add [bx+si],al
  db 0x00, 0x00                ; 00003932  add [bx+si],al
  db 0x00, 0x00                ; 00003934  add [bx+si],al
  db 0x00, 0x00                ; 00003936  add [bx+si],al
  db 0x00, 0x00                ; 00003938  add [bx+si],al
  db 0x00, 0x00                ; 0000393A  add [bx+si],al
  db 0x00, 0x00                ; 0000393C  add [bx+si],al
  db 0x00, 0x00                ; 0000393E  add [bx+si],al
  db 0x00, 0x00                ; 00003940  add [bx+si],al
  db 0x00, 0x00                ; 00003942  add [bx+si],al
  db 0x00, 0x00                ; 00003944  add [bx+si],al
  db 0x00, 0x00                ; 00003946  add [bx+si],al
  db 0x00, 0x00                ; 00003948  add [bx+si],al
  db 0x00, 0x00                ; 0000394A  add [bx+si],al
  db 0x00, 0x00                ; 0000394C  add [bx+si],al
  db 0x00, 0x00                ; 0000394E  add [bx+si],al
  db 0x00, 0x00                ; 00003950  add [bx+si],al
  db 0x00, 0x00                ; 00003952  add [bx+si],al
  db 0x00, 0x00                ; 00003954  add [bx+si],al
  db 0x00, 0x00                ; 00003956  add [bx+si],al
  db 0x00, 0x00                ; 00003958  add [bx+si],al
  db 0x00, 0x00                ; 0000395A  add [bx+si],al
  db 0x00, 0x00                ; 0000395C  add [bx+si],al
  db 0x00, 0x00                ; 0000395E  add [bx+si],al
  db 0x00, 0x00                ; 00003960  add [bx+si],al
  db 0x00, 0x00                ; 00003962  add [bx+si],al
  db 0x00, 0x00                ; 00003964  add [bx+si],al
  db 0x00, 0x00                ; 00003966  add [bx+si],al
  db 0x00, 0x00                ; 00003968  add [bx+si],al
  db 0x00, 0x00                ; 0000396A  add [bx+si],al
  db 0x00, 0x00                ; 0000396C  add [bx+si],al
  db 0x00, 0x00                ; 0000396E  add [bx+si],al
  db 0x00, 0x00                ; 00003970  add [bx+si],al
  db 0x00, 0x00                ; 00003972  add [bx+si],al
  db 0x00, 0x00                ; 00003974  add [bx+si],al
  db 0x00, 0x00                ; 00003976  add [bx+si],al
  db 0x00, 0x00                ; 00003978  add [bx+si],al
  db 0x00, 0x00                ; 0000397A  add [bx+si],al
  db 0x00, 0x00                ; 0000397C  add [bx+si],al
  db 0x00, 0x00                ; 0000397E  add [bx+si],al
  db 0x00, 0x00                ; 00003980  add [bx+si],al
  db 0x00, 0x00                ; 00003982  add [bx+si],al
  db 0x00, 0x00                ; 00003984  add [bx+si],al
  db 0x00, 0x00                ; 00003986  add [bx+si],al
  db 0x00, 0x00                ; 00003988  add [bx+si],al
  db 0x00, 0x00                ; 0000398A  add [bx+si],al
  db 0x00, 0x00                ; 0000398C  add [bx+si],al
  db 0x00, 0x00                ; 0000398E  add [bx+si],al
  db 0x00, 0x00                ; 00003990  add [bx+si],al
  db 0x00, 0x00                ; 00003992  add [bx+si],al
  db 0x00, 0x00                ; 00003994  add [bx+si],al
  db 0x00, 0x00                ; 00003996  add [bx+si],al
  db 0x00, 0x00                ; 00003998  add [bx+si],al
  db 0x00, 0x00                ; 0000399A  add [bx+si],al
  db 0x00, 0x00                ; 0000399C  add [bx+si],al
  db 0x00, 0x00                ; 0000399E  add [bx+si],al
  db 0x00, 0x00                ; 000039A0  add [bx+si],al
  db 0x00, 0x00                ; 000039A2  add [bx+si],al
  db 0x00, 0x00                ; 000039A4  add [bx+si],al
  db 0x00, 0x00                ; 000039A6  add [bx+si],al
  db 0x00, 0x00                ; 000039A8  add [bx+si],al
  db 0x00, 0x00                ; 000039AA  add [bx+si],al
  db 0x00, 0x00                ; 000039AC  add [bx+si],al
  db 0x00, 0x00                ; 000039AE  add [bx+si],al
  db 0x00, 0x00                ; 000039B0  add [bx+si],al
  db 0x00, 0x00                ; 000039B2  add [bx+si],al
  db 0x00, 0x00                ; 000039B4  add [bx+si],al
  db 0x00, 0x00                ; 000039B6  add [bx+si],al
  db 0x00, 0x00                ; 000039B8  add [bx+si],al
  db 0x00, 0x00                ; 000039BA  add [bx+si],al
  db 0x00, 0x00                ; 000039BC  add [bx+si],al
  db 0x00, 0x00                ; 000039BE  add [bx+si],al
  db 0x00, 0x00                ; 000039C0  add [bx+si],al
  db 0x00, 0x00                ; 000039C2  add [bx+si],al
  db 0x00, 0x00                ; 000039C4  add [bx+si],al
  db 0x00, 0x00                ; 000039C6  add [bx+si],al
  db 0x00, 0x00                ; 000039C8  add [bx+si],al
  db 0x00, 0x00                ; 000039CA  add [bx+si],al
  db 0x00, 0x00                ; 000039CC  add [bx+si],al
  db 0x00, 0x00                ; 000039CE  add [bx+si],al
  db 0x00, 0x00                ; 000039D0  add [bx+si],al
  db 0x00, 0x00                ; 000039D2  add [bx+si],al
  db 0x00, 0x00                ; 000039D4  add [bx+si],al
  db 0x00, 0x00                ; 000039D6  add [bx+si],al
  db 0x00, 0x00                ; 000039D8  add [bx+si],al
  db 0x00, 0x00                ; 000039DA  add [bx+si],al
  db 0x00, 0x00                ; 000039DC  add [bx+si],al
  db 0x00, 0x00                ; 000039DE  add [bx+si],al
  db 0x00, 0x00                ; 000039E0  add [bx+si],al
  db 0x00, 0x00                ; 000039E2  add [bx+si],al
  db 0x00, 0x00                ; 000039E4  add [bx+si],al
  db 0x00, 0x00                ; 000039E6  add [bx+si],al
  db 0x00, 0x00                ; 000039E8  add [bx+si],al
  db 0x00, 0x00                ; 000039EA  add [bx+si],al
  db 0x00, 0x00                ; 000039EC  add [bx+si],al
  db 0x00, 0x00                ; 000039EE  add [bx+si],al
  db 0x00, 0x00                ; 000039F0  add [bx+si],al
  db 0x00, 0x00                ; 000039F2  add [bx+si],al
  db 0x00, 0x00                ; 000039F4  add [bx+si],al
  db 0x00, 0x00                ; 000039F6  add [bx+si],al
  db 0x00, 0x00                ; 000039F8  add [bx+si],al
  db 0x00, 0x00                ; 000039FA  add [bx+si],al
  db 0x00, 0x00                ; 000039FC  add [bx+si],al
  db 0x00, 0x00                ; 000039FE  add [bx+si],al
  db 0x00, 0x00                ; 00003A00  add [bx+si],al
  db 0x00, 0x00                ; 00003A02  add [bx+si],al
  db 0x00, 0x00                ; 00003A04  add [bx+si],al
  db 0x00, 0x00                ; 00003A06  add [bx+si],al
  db 0x00, 0x00                ; 00003A08  add [bx+si],al
  db 0x00, 0x00                ; 00003A0A  add [bx+si],al
  db 0x00, 0x00                ; 00003A0C  add [bx+si],al
  db 0x00, 0x00                ; 00003A0E  add [bx+si],al
  db 0x00, 0x00                ; 00003A10  add [bx+si],al
  db 0x00, 0x00                ; 00003A12  add [bx+si],al
  db 0x00, 0x00                ; 00003A14  add [bx+si],al
  db 0x00, 0x00                ; 00003A16  add [bx+si],al
  db 0x00, 0x00                ; 00003A18  add [bx+si],al
  db 0x00, 0x00                ; 00003A1A  add [bx+si],al
  db 0x00, 0x00                ; 00003A1C  add [bx+si],al
  db 0x00, 0x00                ; 00003A1E  add [bx+si],al
  db 0x00, 0x00                ; 00003A20  add [bx+si],al
  db 0x00, 0x00                ; 00003A22  add [bx+si],al
  db 0x00, 0x00                ; 00003A24  add [bx+si],al
  db 0x00, 0x00                ; 00003A26  add [bx+si],al
  db 0x00, 0x00                ; 00003A28  add [bx+si],al
  db 0x00, 0x00                ; 00003A2A  add [bx+si],al
  db 0x00, 0x00                ; 00003A2C  add [bx+si],al
  db 0x00, 0x00                ; 00003A2E  add [bx+si],al
  db 0x00, 0x00                ; 00003A30  add [bx+si],al
  db 0x00, 0x00                ; 00003A32  add [bx+si],al
  db 0x00, 0x00                ; 00003A34  add [bx+si],al
  db 0x00, 0x00                ; 00003A36  add [bx+si],al
  db 0x00, 0x00                ; 00003A38  add [bx+si],al
  db 0x00, 0x00                ; 00003A3A  add [bx+si],al
  db 0x00, 0x00                ; 00003A3C  add [bx+si],al
  db 0x00, 0x00                ; 00003A3E  add [bx+si],al
  db 0x00, 0x00                ; 00003A40  add [bx+si],al
  db 0x00, 0x00                ; 00003A42  add [bx+si],al
  db 0x00, 0x00                ; 00003A44  add [bx+si],al
  db 0x00, 0x00                ; 00003A46  add [bx+si],al
  db 0x00, 0x00                ; 00003A48  add [bx+si],al
  db 0x00, 0x00                ; 00003A4A  add [bx+si],al
  db 0x00, 0x00                ; 00003A4C  add [bx+si],al
  db 0x00, 0x00                ; 00003A4E  add [bx+si],al
  db 0x00, 0x00                ; 00003A50  add [bx+si],al
  db 0x00, 0x00                ; 00003A52  add [bx+si],al
  db 0x00, 0x00                ; 00003A54  add [bx+si],al
  db 0x00, 0x00                ; 00003A56  add [bx+si],al
  db 0x00, 0x00                ; 00003A58  add [bx+si],al
  db 0x00, 0x00                ; 00003A5A  add [bx+si],al
  db 0x00, 0x00                ; 00003A5C  add [bx+si],al
  db 0x00, 0x00                ; 00003A5E  add [bx+si],al
  db 0x00, 0x00                ; 00003A60  add [bx+si],al
  db 0x00, 0x00                ; 00003A62  add [bx+si],al
  db 0x00, 0x00                ; 00003A64  add [bx+si],al
  db 0x00, 0x00                ; 00003A66  add [bx+si],al
  db 0x00, 0x00                ; 00003A68  add [bx+si],al
  db 0x00, 0x00                ; 00003A6A  add [bx+si],al
  db 0x00, 0x00                ; 00003A6C  add [bx+si],al
  db 0x00, 0x00                ; 00003A6E  add [bx+si],al
  db 0x00, 0x00                ; 00003A70  add [bx+si],al
  db 0x00, 0x00                ; 00003A72  add [bx+si],al
  db 0x00, 0x00                ; 00003A74  add [bx+si],al
  db 0x00, 0x00                ; 00003A76  add [bx+si],al
  db 0x00, 0x00                ; 00003A78  add [bx+si],al
  db 0x00, 0x00                ; 00003A7A  add [bx+si],al
  db 0x00, 0x00                ; 00003A7C  add [bx+si],al
  db 0x00, 0x00                ; 00003A7E  add [bx+si],al
  db 0x00, 0x00                ; 00003A80  add [bx+si],al
  db 0x00, 0x00                ; 00003A82  add [bx+si],al
  db 0x00, 0x00                ; 00003A84  add [bx+si],al
  db 0x00, 0x00                ; 00003A86  add [bx+si],al
  db 0x00, 0x00                ; 00003A88  add [bx+si],al
  db 0x00, 0x00                ; 00003A8A  add [bx+si],al
  db 0x00, 0x00                ; 00003A8C  add [bx+si],al
  db 0x00, 0x00                ; 00003A8E  add [bx+si],al
  db 0x00, 0x00                ; 00003A90  add [bx+si],al
  db 0x00, 0x00                ; 00003A92  add [bx+si],al
  db 0x00, 0x00                ; 00003A94  add [bx+si],al
  db 0x00, 0x00                ; 00003A96  add [bx+si],al
  db 0x00, 0x00                ; 00003A98  add [bx+si],al
  db 0x00, 0x00                ; 00003A9A  add [bx+si],al
  db 0x00, 0x00                ; 00003A9C  add [bx+si],al
  db 0x00, 0x00                ; 00003A9E  add [bx+si],al
  db 0x00, 0x00                ; 00003AA0  add [bx+si],al
  db 0x00, 0x00                ; 00003AA2  add [bx+si],al
  db 0x00, 0x00                ; 00003AA4  add [bx+si],al
  db 0x00, 0x00                ; 00003AA6  add [bx+si],al
  db 0x00, 0x00                ; 00003AA8  add [bx+si],al
  db 0x00, 0x00                ; 00003AAA  add [bx+si],al
  db 0x00, 0x00                ; 00003AAC  add [bx+si],al
  db 0x00, 0x00                ; 00003AAE  add [bx+si],al
  db 0x00, 0x00                ; 00003AB0  add [bx+si],al
  db 0x00, 0x00                ; 00003AB2  add [bx+si],al
  db 0x00, 0x00                ; 00003AB4  add [bx+si],al
  db 0x00, 0x00                ; 00003AB6  add [bx+si],al
  db 0x00, 0x00                ; 00003AB8  add [bx+si],al
  db 0x00, 0x00                ; 00003ABA  add [bx+si],al
  db 0x00, 0x00                ; 00003ABC  add [bx+si],al
  db 0x00, 0x00                ; 00003ABE  add [bx+si],al
  db 0x00, 0x00                ; 00003AC0  add [bx+si],al
  db 0x00, 0x00                ; 00003AC2  add [bx+si],al
  db 0x00, 0x00                ; 00003AC4  add [bx+si],al
  db 0x00, 0x00                ; 00003AC6  add [bx+si],al
  db 0x00, 0x00                ; 00003AC8  add [bx+si],al
  db 0x00, 0x00                ; 00003ACA  add [bx+si],al
  db 0x00, 0x00                ; 00003ACC  add [bx+si],al
  db 0x00, 0x00                ; 00003ACE  add [bx+si],al
  db 0x00, 0x00                ; 00003AD0  add [bx+si],al
  db 0x00, 0x00                ; 00003AD2  add [bx+si],al
  db 0x00, 0x00                ; 00003AD4  add [bx+si],al
  db 0x00, 0x00                ; 00003AD6  add [bx+si],al
  db 0x00, 0x00                ; 00003AD8  add [bx+si],al
  db 0x00, 0x00                ; 00003ADA  add [bx+si],al
  db 0x00, 0x00                ; 00003ADC  add [bx+si],al
  db 0x00, 0x00                ; 00003ADE  add [bx+si],al
  db 0x00, 0x00                ; 00003AE0  add [bx+si],al
  db 0x00, 0x00                ; 00003AE2  add [bx+si],al
  db 0x00, 0x00                ; 00003AE4  add [bx+si],al
  db 0x00, 0x00                ; 00003AE6  add [bx+si],al
  db 0x00, 0x00                ; 00003AE8  add [bx+si],al
  db 0x00, 0x00                ; 00003AEA  add [bx+si],al
  db 0x00, 0x00                ; 00003AEC  add [bx+si],al
  db 0x00, 0x00                ; 00003AEE  add [bx+si],al
  db 0x00, 0x00                ; 00003AF0  add [bx+si],al
  db 0x00, 0x00                ; 00003AF2  add [bx+si],al
  db 0x00, 0x00                ; 00003AF4  add [bx+si],al
  db 0x00, 0x00                ; 00003AF6  add [bx+si],al
  db 0x00, 0x00                ; 00003AF8  add [bx+si],al
  db 0x00, 0x00                ; 00003AFA  add [bx+si],al
  db 0x00, 0x00                ; 00003AFC  add [bx+si],al
  db 0x00, 0x00                ; 00003AFE  add [bx+si],al
  db 0x00, 0x00                ; 00003B00  add [bx+si],al
  db 0x00, 0x00                ; 00003B02  add [bx+si],al
  db 0x00, 0x00                ; 00003B04  add [bx+si],al
  db 0x00, 0x00                ; 00003B06  add [bx+si],al
  db 0x00, 0x00                ; 00003B08  add [bx+si],al
  db 0x00, 0x00                ; 00003B0A  add [bx+si],al
  db 0x00, 0x00                ; 00003B0C  add [bx+si],al
  db 0x00, 0x00                ; 00003B0E  add [bx+si],al
  db 0x00, 0x00                ; 00003B10  add [bx+si],al
  db 0x00, 0x00                ; 00003B12  add [bx+si],al
  db 0x00, 0x00                ; 00003B14  add [bx+si],al
  db 0x00, 0x00                ; 00003B16  add [bx+si],al
  db 0x00, 0x00                ; 00003B18  add [bx+si],al
  db 0x00, 0x00                ; 00003B1A  add [bx+si],al
  db 0x00, 0x00                ; 00003B1C  add [bx+si],al
  db 0x00, 0x00                ; 00003B1E  add [bx+si],al
  db 0x00, 0x00                ; 00003B20  add [bx+si],al
  db 0x00, 0x00                ; 00003B22  add [bx+si],al
  db 0x00, 0x00                ; 00003B24  add [bx+si],al
  db 0x00, 0x00                ; 00003B26  add [bx+si],al
  db 0x00, 0x00                ; 00003B28  add [bx+si],al
  db 0x00, 0x00                ; 00003B2A  add [bx+si],al
  db 0x00, 0x00                ; 00003B2C  add [bx+si],al
  db 0x00, 0x00                ; 00003B2E  add [bx+si],al
  db 0x00, 0x00                ; 00003B30  add [bx+si],al
  db 0x00, 0x00                ; 00003B32  add [bx+si],al
  db 0x00, 0x00                ; 00003B34  add [bx+si],al
  db 0x00, 0x00                ; 00003B36  add [bx+si],al
  db 0x00, 0x00                ; 00003B38  add [bx+si],al
  db 0x00, 0x00                ; 00003B3A  add [bx+si],al
  db 0x00, 0x00                ; 00003B3C  add [bx+si],al
  db 0x00, 0x00                ; 00003B3E  add [bx+si],al
  db 0x00, 0x00                ; 00003B40  add [bx+si],al
  db 0x00, 0x00                ; 00003B42  add [bx+si],al
  db 0x00, 0x00                ; 00003B44  add [bx+si],al
  db 0x00, 0x00                ; 00003B46  add [bx+si],al
  db 0x00, 0x00                ; 00003B48  add [bx+si],al
  db 0x00, 0x00                ; 00003B4A  add [bx+si],al
  db 0x00, 0x00                ; 00003B4C  add [bx+si],al
  db 0x00, 0x00                ; 00003B4E  add [bx+si],al
  db 0x00, 0x00                ; 00003B50  add [bx+si],al
  db 0x00, 0x00                ; 00003B52  add [bx+si],al
  db 0x00, 0x00                ; 00003B54  add [bx+si],al
  db 0x00, 0x00                ; 00003B56  add [bx+si],al
  db 0x00, 0x00                ; 00003B58  add [bx+si],al
  db 0x00, 0x00                ; 00003B5A  add [bx+si],al
  db 0x00, 0x00                ; 00003B5C  add [bx+si],al
  db 0x00, 0x00                ; 00003B5E  add [bx+si],al
  db 0x00, 0x00                ; 00003B60  add [bx+si],al
  db 0x00, 0x00                ; 00003B62  add [bx+si],al
  db 0x00, 0x00                ; 00003B64  add [bx+si],al
  db 0x00, 0x00                ; 00003B66  add [bx+si],al
  db 0x00, 0x00                ; 00003B68  add [bx+si],al
  db 0x00, 0x00                ; 00003B6A  add [bx+si],al
  db 0x00, 0x00                ; 00003B6C  add [bx+si],al
  db 0x00, 0x00                ; 00003B6E  add [bx+si],al
  db 0x00, 0x00                ; 00003B70  add [bx+si],al
  db 0x00, 0x00                ; 00003B72  add [bx+si],al
  db 0x00, 0x00                ; 00003B74  add [bx+si],al
  db 0x00, 0x00                ; 00003B76  add [bx+si],al
  db 0x00, 0x00                ; 00003B78  add [bx+si],al
  db 0x00, 0x00                ; 00003B7A  add [bx+si],al
  db 0x00, 0x00                ; 00003B7C  add [bx+si],al
  db 0x00, 0x00                ; 00003B7E  add [bx+si],al
  db 0x00, 0x00                ; 00003B80  add [bx+si],al
  db 0x00, 0x00                ; 00003B82  add [bx+si],al
  db 0x00, 0x00                ; 00003B84  add [bx+si],al
  db 0x00, 0x00                ; 00003B86  add [bx+si],al
  db 0x00, 0x00                ; 00003B88  add [bx+si],al
  db 0x00, 0x00                ; 00003B8A  add [bx+si],al
  db 0x00, 0x00                ; 00003B8C  add [bx+si],al
  db 0x00, 0x00                ; 00003B8E  add [bx+si],al
  db 0x00, 0x00                ; 00003B90  add [bx+si],al
  db 0x00, 0x00                ; 00003B92  add [bx+si],al
  db 0x00, 0x00                ; 00003B94  add [bx+si],al
  db 0x00, 0x00                ; 00003B96  add [bx+si],al
  db 0x00, 0x00                ; 00003B98  add [bx+si],al
  db 0x00, 0x00                ; 00003B9A  add [bx+si],al
  db 0x00, 0x00                ; 00003B9C  add [bx+si],al
  db 0x00, 0x00                ; 00003B9E  add [bx+si],al
  db 0x00, 0x00                ; 00003BA0  add [bx+si],al
  db 0x00, 0x00                ; 00003BA2  add [bx+si],al
  db 0x00, 0x00                ; 00003BA4  add [bx+si],al
  db 0x00, 0x00                ; 00003BA6  add [bx+si],al
  db 0x00, 0x00                ; 00003BA8  add [bx+si],al
  db 0x00, 0x00                ; 00003BAA  add [bx+si],al
  db 0x00, 0x00                ; 00003BAC  add [bx+si],al
  db 0x00, 0x00                ; 00003BAE  add [bx+si],al
  db 0x00, 0x00                ; 00003BB0  add [bx+si],al
  db 0x00, 0x00                ; 00003BB2  add [bx+si],al
  db 0x00, 0x00                ; 00003BB4  add [bx+si],al
  db 0x00, 0x00                ; 00003BB6  add [bx+si],al
  db 0x00, 0x00                ; 00003BB8  add [bx+si],al
  db 0x00, 0x00                ; 00003BBA  add [bx+si],al
  db 0x00, 0x00                ; 00003BBC  add [bx+si],al
  db 0x00, 0x00                ; 00003BBE  add [bx+si],al
  db 0x00, 0x00                ; 00003BC0  add [bx+si],al
  db 0x00, 0x00                ; 00003BC2  add [bx+si],al
  db 0x00, 0x00                ; 00003BC4  add [bx+si],al
  db 0x00, 0x00                ; 00003BC6  add [bx+si],al
  db 0x00, 0x00                ; 00003BC8  add [bx+si],al
  db 0x00, 0x00                ; 00003BCA  add [bx+si],al
  db 0x00, 0x00                ; 00003BCC  add [bx+si],al
  db 0x00, 0x00                ; 00003BCE  add [bx+si],al
  db 0x00, 0x00                ; 00003BD0  add [bx+si],al
  db 0x00, 0x00                ; 00003BD2  add [bx+si],al
  db 0x00, 0x00                ; 00003BD4  add [bx+si],al
  db 0x00, 0x00                ; 00003BD6  add [bx+si],al
  db 0x00, 0x00                ; 00003BD8  add [bx+si],al
  db 0x00, 0x00                ; 00003BDA  add [bx+si],al
  db 0x00, 0x00                ; 00003BDC  add [bx+si],al
  db 0x00, 0x00                ; 00003BDE  add [bx+si],al
  db 0x00, 0x00                ; 00003BE0  add [bx+si],al
  db 0x00, 0x00                ; 00003BE2  add [bx+si],al
  db 0x00, 0x00                ; 00003BE4  add [bx+si],al
  db 0x00, 0x00                ; 00003BE6  add [bx+si],al
  db 0x00, 0x00                ; 00003BE8  add [bx+si],al
  db 0x00, 0x00                ; 00003BEA  add [bx+si],al
  db 0x00, 0x00                ; 00003BEC  add [bx+si],al
  db 0x00, 0x00                ; 00003BEE  add [bx+si],al
  db 0x00, 0x00                ; 00003BF0  add [bx+si],al
  db 0x00, 0x00                ; 00003BF2  add [bx+si],al
  db 0x00, 0x00                ; 00003BF4  add [bx+si],al
  db 0x00, 0x00                ; 00003BF6  add [bx+si],al
  db 0x00, 0x00                ; 00003BF8  add [bx+si],al
  db 0x00, 0x00                ; 00003BFA  add [bx+si],al
  db 0x00, 0x00                ; 00003BFC  add [bx+si],al
  db 0x00, 0x00                ; 00003BFE  add [bx+si],al
  db 0x00, 0x00                ; 00003C00  add [bx+si],al
  db 0x00, 0x00                ; 00003C02  add [bx+si],al
  db 0x00, 0x00                ; 00003C04  add [bx+si],al
  db 0x00, 0x00                ; 00003C06  add [bx+si],al
  db 0x00, 0x00                ; 00003C08  add [bx+si],al
  db 0x00, 0x00                ; 00003C0A  add [bx+si],al
  db 0x00, 0x00                ; 00003C0C  add [bx+si],al
  db 0x00, 0x00                ; 00003C0E  add [bx+si],al
  db 0x00, 0x00                ; 00003C10  add [bx+si],al
  db 0x00, 0x00                ; 00003C12  add [bx+si],al
  db 0x00, 0x00                ; 00003C14  add [bx+si],al
  db 0x00, 0x00                ; 00003C16  add [bx+si],al
  db 0x00, 0x00                ; 00003C18  add [bx+si],al
  db 0x00, 0x00                ; 00003C1A  add [bx+si],al
  db 0x00, 0x00                ; 00003C1C  add [bx+si],al
  db 0x00, 0x00                ; 00003C1E  add [bx+si],al
  db 0x00, 0x00                ; 00003C20  add [bx+si],al
  db 0x00, 0x00                ; 00003C22  add [bx+si],al
  db 0x00, 0x00                ; 00003C24  add [bx+si],al
  db 0x00, 0x00                ; 00003C26  add [bx+si],al
  db 0x00, 0x00                ; 00003C28  add [bx+si],al
  db 0x00, 0x00                ; 00003C2A  add [bx+si],al
  db 0x00, 0x00                ; 00003C2C  add [bx+si],al
  db 0x00, 0x00                ; 00003C2E  add [bx+si],al
  db 0x00, 0x00                ; 00003C30  add [bx+si],al
  db 0x00, 0x00                ; 00003C32  add [bx+si],al
  db 0x00, 0x00                ; 00003C34  add [bx+si],al
  db 0x00, 0x00                ; 00003C36  add [bx+si],al
  db 0x00, 0x00                ; 00003C38  add [bx+si],al
  db 0x00, 0x00                ; 00003C3A  add [bx+si],al
  db 0x00, 0x00                ; 00003C3C  add [bx+si],al
  db 0x00, 0x00                ; 00003C3E  add [bx+si],al
  db 0x00, 0x00                ; 00003C40  add [bx+si],al
  db 0x00, 0x00                ; 00003C42  add [bx+si],al
  db 0x00, 0x00                ; 00003C44  add [bx+si],al
  db 0x00, 0x00                ; 00003C46  add [bx+si],al
  db 0x00, 0x00                ; 00003C48  add [bx+si],al
  db 0x00, 0x00                ; 00003C4A  add [bx+si],al
  db 0x00, 0x00                ; 00003C4C  add [bx+si],al
  db 0x00, 0x00                ; 00003C4E  add [bx+si],al
  db 0x00, 0x00                ; 00003C50  add [bx+si],al
  db 0x00, 0x00                ; 00003C52  add [bx+si],al
  db 0x00, 0x00                ; 00003C54  add [bx+si],al
  db 0x00, 0x00                ; 00003C56  add [bx+si],al
  db 0x00, 0x00                ; 00003C58  add [bx+si],al
  db 0x00, 0x00                ; 00003C5A  add [bx+si],al
  db 0x00, 0x00                ; 00003C5C  add [bx+si],al
  db 0x00, 0x00                ; 00003C5E  add [bx+si],al
  db 0x00, 0x00                ; 00003C60  add [bx+si],al
  db 0x00, 0x00                ; 00003C62  add [bx+si],al
  db 0x00, 0x00                ; 00003C64  add [bx+si],al
  db 0x00, 0x00                ; 00003C66  add [bx+si],al
  db 0x00, 0x00                ; 00003C68  add [bx+si],al
  db 0x00, 0x00                ; 00003C6A  add [bx+si],al
  db 0x00, 0x00                ; 00003C6C  add [bx+si],al
  db 0x00, 0x00                ; 00003C6E  add [bx+si],al
  db 0x00, 0x00                ; 00003C70  add [bx+si],al
  db 0x00, 0x00                ; 00003C72  add [bx+si],al
  db 0x00, 0x00                ; 00003C74  add [bx+si],al
  db 0x00, 0x00                ; 00003C76  add [bx+si],al
  db 0x00, 0x00                ; 00003C78  add [bx+si],al
  db 0x00, 0x00                ; 00003C7A  add [bx+si],al
  db 0x00, 0x00                ; 00003C7C  add [bx+si],al
  db 0x00, 0x00                ; 00003C7E  add [bx+si],al
  db 0x00, 0x00                ; 00003C80  add [bx+si],al
  db 0x00, 0x00                ; 00003C82  add [bx+si],al
  db 0x00, 0x00                ; 00003C84  add [bx+si],al
  db 0x00, 0x00                ; 00003C86  add [bx+si],al
  db 0x00, 0x00                ; 00003C88  add [bx+si],al
  db 0x00, 0x00                ; 00003C8A  add [bx+si],al
  db 0x00, 0x00                ; 00003C8C  add [bx+si],al
  db 0x00, 0x00                ; 00003C8E  add [bx+si],al
  db 0x00, 0x00                ; 00003C90  add [bx+si],al
  db 0x00, 0x00                ; 00003C92  add [bx+si],al
  db 0x00, 0x00                ; 00003C94  add [bx+si],al
  db 0x00, 0x00                ; 00003C96  add [bx+si],al
  db 0x00, 0x00                ; 00003C98  add [bx+si],al
  db 0x00, 0x00                ; 00003C9A  add [bx+si],al
  db 0x00, 0x00                ; 00003C9C  add [bx+si],al
  db 0x00, 0x00                ; 00003C9E  add [bx+si],al
  db 0x00, 0x00                ; 00003CA0  add [bx+si],al
  db 0x00, 0x00                ; 00003CA2  add [bx+si],al
  db 0x00, 0x00                ; 00003CA4  add [bx+si],al
  db 0x00, 0x00                ; 00003CA6  add [bx+si],al
  db 0x00, 0x00                ; 00003CA8  add [bx+si],al
  db 0x00, 0x00                ; 00003CAA  add [bx+si],al
  db 0x00, 0x00                ; 00003CAC  add [bx+si],al
  db 0x00, 0x00                ; 00003CAE  add [bx+si],al
  db 0x00, 0x00                ; 00003CB0  add [bx+si],al
  db 0x00, 0x00                ; 00003CB2  add [bx+si],al
  db 0x00, 0x00                ; 00003CB4  add [bx+si],al
  db 0x00, 0x00                ; 00003CB6  add [bx+si],al
  db 0x00, 0x00                ; 00003CB8  add [bx+si],al
  db 0x00, 0x00                ; 00003CBA  add [bx+si],al
  db 0x00, 0x00                ; 00003CBC  add [bx+si],al
  db 0x00, 0x00                ; 00003CBE  add [bx+si],al
  db 0x00, 0x00                ; 00003CC0  add [bx+si],al
  db 0x00, 0x00                ; 00003CC2  add [bx+si],al
  db 0x00, 0x00                ; 00003CC4  add [bx+si],al
  db 0x00, 0x00                ; 00003CC6  add [bx+si],al
  db 0x00, 0x00                ; 00003CC8  add [bx+si],al
  db 0x00, 0x00                ; 00003CCA  add [bx+si],al
  db 0x00, 0x00                ; 00003CCC  add [bx+si],al
  db 0x00, 0x00                ; 00003CCE  add [bx+si],al
  db 0x00, 0x00                ; 00003CD0  add [bx+si],al
  db 0x00, 0x00                ; 00003CD2  add [bx+si],al
  db 0x00, 0x00                ; 00003CD4  add [bx+si],al
  db 0x00, 0x00                ; 00003CD6  add [bx+si],al
  db 0x00, 0x00                ; 00003CD8  add [bx+si],al
  db 0x00, 0x00                ; 00003CDA  add [bx+si],al
  db 0x00, 0x00                ; 00003CDC  add [bx+si],al
  db 0x00, 0x00                ; 00003CDE  add [bx+si],al
  db 0x00, 0x00                ; 00003CE0  add [bx+si],al
  db 0x00, 0x00                ; 00003CE2  add [bx+si],al
  db 0x00, 0x00                ; 00003CE4  add [bx+si],al
  db 0x00, 0x00                ; 00003CE6  add [bx+si],al
  db 0x00, 0x00                ; 00003CE8  add [bx+si],al
  db 0x00, 0x00                ; 00003CEA  add [bx+si],al
  db 0x00, 0x00                ; 00003CEC  add [bx+si],al
  db 0x00, 0x00                ; 00003CEE  add [bx+si],al
  db 0x00, 0x00                ; 00003CF0  add [bx+si],al
  db 0x00, 0x00                ; 00003CF2  add [bx+si],al
  db 0x00, 0x00                ; 00003CF4  add [bx+si],al
  db 0x00, 0x00                ; 00003CF6  add [bx+si],al
  db 0x00, 0x00                ; 00003CF8  add [bx+si],al
  db 0x00, 0x00                ; 00003CFA  add [bx+si],al
  db 0x00, 0x00                ; 00003CFC  add [bx+si],al
  db 0x00, 0x00                ; 00003CFE  add [bx+si],al
  db 0x00, 0x00                ; 00003D00  add [bx+si],al
  db 0x00, 0x00                ; 00003D02  add [bx+si],al
  db 0x00, 0x00                ; 00003D04  add [bx+si],al
  db 0x00, 0x00                ; 00003D06  add [bx+si],al
  db 0x00, 0x00                ; 00003D08  add [bx+si],al
  db 0x00, 0x00                ; 00003D0A  add [bx+si],al
  db 0x00, 0x00                ; 00003D0C  add [bx+si],al
  db 0x00, 0x00                ; 00003D0E  add [bx+si],al
  db 0x00, 0x00                ; 00003D10  add [bx+si],al
  db 0x00, 0x00                ; 00003D12  add [bx+si],al
  db 0x00, 0x00                ; 00003D14  add [bx+si],al
  db 0x00, 0x00                ; 00003D16  add [bx+si],al
  db 0x00, 0x00                ; 00003D18  add [bx+si],al
  db 0x00, 0x00                ; 00003D1A  add [bx+si],al
  db 0x00, 0x00                ; 00003D1C  add [bx+si],al
  db 0x00, 0x00                ; 00003D1E  add [bx+si],al
  db 0x00, 0x00                ; 00003D20  add [bx+si],al
  db 0x00, 0x00                ; 00003D22  add [bx+si],al
  db 0x00, 0x00                ; 00003D24  add [bx+si],al
  db 0x00, 0x00                ; 00003D26  add [bx+si],al
  db 0x00, 0x00                ; 00003D28  add [bx+si],al
  db 0x00, 0x00                ; 00003D2A  add [bx+si],al
  db 0x00, 0x00                ; 00003D2C  add [bx+si],al
  db 0x00, 0x00                ; 00003D2E  add [bx+si],al
  db 0x00, 0x00                ; 00003D30  add [bx+si],al
  db 0x00, 0x00                ; 00003D32  add [bx+si],al
  db 0x00, 0x00                ; 00003D34  add [bx+si],al
  db 0x00, 0x00                ; 00003D36  add [bx+si],al
  db 0x00, 0x00                ; 00003D38  add [bx+si],al
  db 0x00, 0x00                ; 00003D3A  add [bx+si],al
  db 0x00, 0x00                ; 00003D3C  add [bx+si],al
  db 0x00, 0x00                ; 00003D3E  add [bx+si],al
  db 0x00, 0x00                ; 00003D40  add [bx+si],al
  db 0x00, 0x00                ; 00003D42  add [bx+si],al
  db 0x00, 0x00                ; 00003D44  add [bx+si],al
  db 0x00, 0x00                ; 00003D46  add [bx+si],al
  db 0x00, 0x00                ; 00003D48  add [bx+si],al
  db 0x00, 0x00                ; 00003D4A  add [bx+si],al
  db 0x00, 0x00                ; 00003D4C  add [bx+si],al
  db 0x00, 0x00                ; 00003D4E  add [bx+si],al
  db 0x00, 0x00                ; 00003D50  add [bx+si],al
  db 0x00, 0x00                ; 00003D52  add [bx+si],al
  db 0x00, 0x00                ; 00003D54  add [bx+si],al
  db 0x00, 0x00                ; 00003D56  add [bx+si],al
  db 0x00, 0x00                ; 00003D58  add [bx+si],al
  db 0x00, 0x00                ; 00003D5A  add [bx+si],al
  db 0x00, 0x00                ; 00003D5C  add [bx+si],al
  db 0x00, 0x00                ; 00003D5E  add [bx+si],al
  db 0x00, 0x00                ; 00003D60  add [bx+si],al
  db 0x00, 0x00                ; 00003D62  add [bx+si],al
  db 0x00, 0x00                ; 00003D64  add [bx+si],al
  db 0x00, 0x00                ; 00003D66  add [bx+si],al
  db 0x00, 0x00                ; 00003D68  add [bx+si],al
  db 0x00, 0x00                ; 00003D6A  add [bx+si],al
  db 0x00, 0x00                ; 00003D6C  add [bx+si],al
  db 0x00, 0x00                ; 00003D6E  add [bx+si],al
  db 0x00, 0x00                ; 00003D70  add [bx+si],al
  db 0x00, 0x00                ; 00003D72  add [bx+si],al
  db 0x00, 0x00                ; 00003D74  add [bx+si],al
  db 0x00, 0x00                ; 00003D76  add [bx+si],al
  db 0x00, 0x00                ; 00003D78  add [bx+si],al
  db 0x00, 0x00                ; 00003D7A  add [bx+si],al
  db 0x00, 0x00                ; 00003D7C  add [bx+si],al
  db 0x00, 0x00                ; 00003D7E  add [bx+si],al
  db 0x00, 0x00                ; 00003D80  add [bx+si],al
  db 0x00, 0x00                ; 00003D82  add [bx+si],al
  db 0x00, 0x00                ; 00003D84  add [bx+si],al
  db 0x00, 0x00                ; 00003D86  add [bx+si],al
  db 0x00, 0x00                ; 00003D88  add [bx+si],al
  db 0x00, 0x00                ; 00003D8A  add [bx+si],al
  db 0x00, 0x00                ; 00003D8C  add [bx+si],al
  db 0x00, 0x00                ; 00003D8E  add [bx+si],al
  db 0x00, 0x00                ; 00003D90  add [bx+si],al
  db 0x00, 0x00                ; 00003D92  add [bx+si],al
  db 0x00, 0x00                ; 00003D94  add [bx+si],al
  db 0x00, 0x00                ; 00003D96  add [bx+si],al
  db 0x00, 0x00                ; 00003D98  add [bx+si],al
  db 0x00, 0x00                ; 00003D9A  add [bx+si],al
  db 0x00, 0x00                ; 00003D9C  add [bx+si],al
  db 0x00, 0x00                ; 00003D9E  add [bx+si],al
  db 0x00, 0x00                ; 00003DA0  add [bx+si],al
  db 0x00, 0x00                ; 00003DA2  add [bx+si],al
  db 0x00, 0x00                ; 00003DA4  add [bx+si],al
  db 0x00, 0x00                ; 00003DA6  add [bx+si],al
  db 0x00, 0x00                ; 00003DA8  add [bx+si],al
  db 0x00, 0x00                ; 00003DAA  add [bx+si],al
  db 0x00, 0x00                ; 00003DAC  add [bx+si],al
  db 0x00, 0x00                ; 00003DAE  add [bx+si],al
  db 0x00, 0x00                ; 00003DB0  add [bx+si],al
  db 0x00, 0x00                ; 00003DB2  add [bx+si],al
  db 0x00, 0x00                ; 00003DB4  add [bx+si],al
  db 0x00, 0x00                ; 00003DB6  add [bx+si],al
  db 0x00, 0x00                ; 00003DB8  add [bx+si],al
  db 0x00, 0x00                ; 00003DBA  add [bx+si],al
  db 0x00, 0x00                ; 00003DBC  add [bx+si],al
  db 0x00, 0x00                ; 00003DBE  add [bx+si],al
  db 0x00, 0x00                ; 00003DC0  add [bx+si],al
  db 0x00, 0x00                ; 00003DC2  add [bx+si],al
  db 0x00, 0x00                ; 00003DC4  add [bx+si],al
  db 0x00, 0x00                ; 00003DC6  add [bx+si],al
  db 0x00, 0x00                ; 00003DC8  add [bx+si],al
  db 0x00, 0x00                ; 00003DCA  add [bx+si],al
  db 0x00, 0x00                ; 00003DCC  add [bx+si],al
  db 0x00, 0x00                ; 00003DCE  add [bx+si],al
  db 0x00, 0x00                ; 00003DD0  add [bx+si],al
  db 0x00, 0x00                ; 00003DD2  add [bx+si],al
  db 0x00, 0x00                ; 00003DD4  add [bx+si],al
  db 0x00, 0x00                ; 00003DD6  add [bx+si],al
  db 0x00, 0x00                ; 00003DD8  add [bx+si],al
  db 0x00, 0x00                ; 00003DDA  add [bx+si],al
  db 0x00, 0x00                ; 00003DDC  add [bx+si],al
  db 0x00, 0x00                ; 00003DDE  add [bx+si],al
  db 0x00, 0x00                ; 00003DE0  add [bx+si],al
  db 0x00, 0x00                ; 00003DE2  add [bx+si],al
  db 0x00, 0x00                ; 00003DE4  add [bx+si],al
  db 0x00, 0x00                ; 00003DE6  add [bx+si],al
  db 0x00, 0x00                ; 00003DE8  add [bx+si],al
  db 0x00, 0x00                ; 00003DEA  add [bx+si],al
  db 0x00, 0x00                ; 00003DEC  add [bx+si],al
  db 0x00, 0x00                ; 00003DEE  add [bx+si],al
  db 0x00, 0x00                ; 00003DF0  add [bx+si],al
  db 0x00, 0x00                ; 00003DF2  add [bx+si],al
  db 0x00, 0x00                ; 00003DF4  add [bx+si],al
  db 0x00, 0x9C, 0xFA, 0x2E    ; 00003DF6  add [si+0x2efa],bl
  db 0xFE, 0x06, 0xF4, 0x3D    ; 00003DFA  inc byte [0x3df4]
  db 0x2E, 0x80, 0x3E, 0xF4, 0x3D, 0x01 ; 00003DFE  cmp byte [cs:0x3df4],0x1
  db 0x75, 0x15                ; 00003E04  jnz 0x3e1b
  db 0x2E, 0x89, 0x36, 0xF5, 0x3D ; 00003E06  mov [cs:0x3df5],si
  db 0xC6, 0x44, 0x0B, 0x3F    ; 00003E0B  mov byte [si+0xb],0x3f
  db 0xC7, 0x44, 0x0E, 0x00, 0x00 ; 00003E0F  mov word [si+0xe],0x0
  db 0xC7, 0x44, 0x0C, 0x00, 0x00 ; 00003E14  mov word [si+0xc],0x0
  db 0xEB, 0x29                ; 00003E19  jmp short 0x3e44
  db 0x57                      ; 00003E1B  push di
  db 0x32, 0xC0                ; 00003E1C  xor al,al
  db 0x2E, 0x8B, 0x3E, 0xF5, 0x3D ; 00003E1E  mov di,[cs:0x3df5]
  db 0x02, 0x45, 0x0B          ; 00003E23  add al,[di+0xb]
  db 0x83, 0x7D, 0x0C, 0x00    ; 00003E26  cmp word [di+0xc],byte +0x0
  db 0x74, 0x05                ; 00003E2A  jz 0x3e31
  db 0x8B, 0x7D, 0x0C          ; 00003E2C  mov di,[di+0xc]
  db 0xEB, 0xF2                ; 00003E2F  jmp short 0x3e23
  db 0xB4, 0x3F                ; 00003E31  mov ah,0x3f
  db 0x2A, 0xE0                ; 00003E33  sub ah,al
  db 0x88, 0x64, 0x0B          ; 00003E35  mov [si+0xb],ah
  db 0x89, 0x7C, 0x0E          ; 00003E38  mov [si+0xe],di
  db 0xC7, 0x44, 0x0C, 0x00, 0x00 ; 00003E3B  mov word [si+0xc],0x0
  db 0x89, 0x75, 0x0C          ; 00003E40  mov [di+0xc],si
  db 0x5F                      ; 00003E43  pop di
  db 0x9D                      ; 00003E44  popf
  db 0xC3                      ; 00003E45  ret
  db 0x9C                      ; 00003E46  pushf
  db 0xFA                      ; 00003E47  cli
  db 0x57                      ; 00003E48  push di
  db 0x53                      ; 00003E49  push bx
  db 0x2E, 0x80, 0x3E, 0xF4, 0x3D, 0x00 ; 00003E4A  cmp byte [cs:0x3df4],0x0
  db 0x74, 0x44                ; 00003E50  jz 0x3e96
  db 0x2E, 0xFE, 0x0E, 0xF4, 0x3D ; 00003E52  dec byte [cs:0x3df4]
  db 0x74, 0x3D                ; 00003E57  jz 0x3e96
  db 0x83, 0x7C, 0x0C, 0x00    ; 00003E59  cmp word [si+0xc],byte +0x0
  db 0x75, 0x0A                ; 00003E5D  jnz 0x3e69
  db 0x8B, 0x7C, 0x0E          ; 00003E5F  mov di,[si+0xe]
  db 0xC7, 0x45, 0x0C, 0x00, 0x00 ; 00003E62  mov word [di+0xc],0x0
  db 0xEB, 0x2D                ; 00003E67  jmp short 0x3e96
  db 0x83, 0x7C, 0x0E, 0x00    ; 00003E69  cmp word [si+0xe],byte +0x0
  db 0x74, 0x14                ; 00003E6D  jz 0x3e83
  db 0x8A, 0x44, 0x0B          ; 00003E6F  mov al,[si+0xb]
  db 0x8B, 0x7C, 0x0C          ; 00003E72  mov di,[si+0xc]
  db 0x00, 0x45, 0x0B          ; 00003E75  add [di+0xb],al
  db 0x8B, 0x5C, 0x0E          ; 00003E78  mov bx,[si+0xe]
  db 0x89, 0x5D, 0x0E          ; 00003E7B  mov [di+0xe],bx
  db 0x89, 0x7F, 0x0C          ; 00003E7E  mov [bx+0xc],di
  db 0xEB, 0x13                ; 00003E81  jmp short 0x3e96
  db 0x8B, 0x7C, 0x0C          ; 00003E83  mov di,[si+0xc]
  db 0x2E, 0x89, 0x3E, 0xF5, 0x3D ; 00003E86  mov [cs:0x3df5],di
  db 0x8A, 0x44, 0x0B          ; 00003E8B  mov al,[si+0xb]
  db 0x00, 0x45, 0x0B          ; 00003E8E  add [di+0xb],al
  db 0xC7, 0x45, 0x0E, 0x00, 0x00 ; 00003E91  mov word [di+0xe],0x0
  db 0x5B                      ; 00003E96  pop bx
  db 0x5F                      ; 00003E97  pop di
  db 0xC7, 0x44, 0x0C, 0x00, 0x00 ; 00003E98  mov word [si+0xc],0x0
  db 0xC7, 0x44, 0x0E, 0x00, 0x00 ; 00003E9D  mov word [si+0xe],0x0
  db 0x9D                      ; 00003EA2  popf
  db 0xC3                      ; 00003EA3  ret
  db 0x9C                      ; 00003EA4  pushf
  db 0xFA                      ; 00003EA5  cli
  db 0x33, 0xC9                ; 00003EA6  xor cx,cx
  db 0x2E, 0x80, 0x3E, 0xF4, 0x3D, 0x00 ; 00003EA8  cmp byte [cs:0x3df4],0x0
  db 0x74, 0x24                ; 00003EAE  jz 0x3ed4
  db 0x2E, 0x8B, 0x36, 0xF5, 0x3D ; 00003EB0  mov si,[cs:0x3df5]
  db 0x56                      ; 00003EB5  push si
  db 0x80, 0x7C, 0x0B, 0x00    ; 00003EB6  cmp byte [si+0xb],0x0
  db 0x75, 0x0D                ; 00003EBA  jnz 0x3ec9
  db 0x41                      ; 00003EBC  inc cx
  db 0x2E, 0xFE, 0x0E, 0xF4, 0x3D ; 00003EBD  dec byte [cs:0x3df4]
  db 0x74, 0x05                ; 00003EC2  jz 0x3ec9
  db 0x8B, 0x74, 0x0C          ; 00003EC4  mov si,[si+0xc]
  db 0xEB, 0xED                ; 00003EC7  jmp short 0x3eb6
  db 0x2E, 0x89, 0x36, 0xF5, 0x3D ; 00003EC9  mov [cs:0x3df5],si
  db 0xC7, 0x44, 0x0E, 0x00, 0x00 ; 00003ECE  mov word [si+0xe],0x0
  db 0x5E                      ; 00003ED3  pop si
  db 0x9D                      ; 00003ED4  popf
  db 0xC3                      ; 00003ED5  ret
  db 0x00, 0x00                ; 00003ED6  add [bx+si],al
  db 0x00, 0x9C, 0xFA, 0x2E    ; 00003ED8  add [si+0x2efa],bl
  db 0xFE, 0x06, 0xD6, 0x3E    ; 00003EDC  inc byte [0x3ed6]
  db 0x2E, 0x80, 0x3E, 0xD6, 0x3E, 0x01 ; 00003EE0  cmp byte [cs:0x3ed6],0x1
  db 0x75, 0x16                ; 00003EE6  jnz 0x3efe
  db 0x2E, 0x89, 0x36, 0xD7, 0x3E ; 00003EE8  mov [cs:0x3ed7],si
  db 0xC7, 0x44, 0x05, 0x68, 0x10 ; 00003EED  mov word [si+0x5],0x1068
  db 0xC7, 0x44, 0x09, 0x00, 0x00 ; 00003EF2  mov word [si+0x9],0x0
  db 0xC7, 0x44, 0x07, 0x00, 0x00 ; 00003EF7  mov word [si+0x7],0x0
  db 0xEB, 0x2A                ; 00003EFC  jmp short 0x3f28
  db 0x57                      ; 00003EFE  push di
  db 0x33, 0xC0                ; 00003EFF  xor ax,ax
  db 0x2E, 0x8B, 0x3E, 0xD7, 0x3E ; 00003F01  mov di,[cs:0x3ed7]
  db 0x03, 0x45, 0x05          ; 00003F06  add ax,[di+0x5]
  db 0x83, 0x7D, 0x07, 0x00    ; 00003F09  cmp word [di+0x7],byte +0x0
  db 0x74, 0x05                ; 00003F0D  jz 0x3f14
  db 0x8B, 0x7D, 0x07          ; 00003F0F  mov di,[di+0x7]
  db 0xEB, 0xF2                ; 00003F12  jmp short 0x3f06
  db 0xBA, 0x68, 0x10          ; 00003F14  mov dx,0x1068
  db 0x2B, 0xD0                ; 00003F17  sub dx,ax
  db 0x89, 0x54, 0x05          ; 00003F19  mov [si+0x5],dx
  db 0x89, 0x7C, 0x09          ; 00003F1C  mov [si+0x9],di
  db 0xC7, 0x44, 0x07, 0x00, 0x00 ; 00003F1F  mov word [si+0x7],0x0
  db 0x89, 0x75, 0x07          ; 00003F24  mov [di+0x7],si
  db 0x5F                      ; 00003F27  pop di
  db 0x9D                      ; 00003F28  popf
  db 0xC3                      ; 00003F29  ret
  db 0x9C                      ; 00003F2A  pushf
  db 0xFA                      ; 00003F2B  cli
  db 0x57                      ; 00003F2C  push di
  db 0x2E, 0x80, 0x3E, 0xD6, 0x3E, 0x00 ; 00003F2D  cmp byte [cs:0x3ed6],0x0
  db 0x74, 0x44                ; 00003F33  jz 0x3f79
  db 0x2E, 0xFE, 0x0E, 0xD6, 0x3E ; 00003F35  dec byte [cs:0x3ed6]
  db 0x74, 0x3D                ; 00003F3A  jz 0x3f79
  db 0x83, 0x7C, 0x07, 0x00    ; 00003F3C  cmp word [si+0x7],byte +0x0
  db 0x75, 0x0A                ; 00003F40  jnz 0x3f4c
  db 0x8B, 0x7C, 0x09          ; 00003F42  mov di,[si+0x9]
  db 0xC7, 0x45, 0x07, 0x00, 0x00 ; 00003F45  mov word [di+0x7],0x0
  db 0xEB, 0x2D                ; 00003F4A  jmp short 0x3f79
  db 0x83, 0x7C, 0x09, 0x00    ; 00003F4C  cmp word [si+0x9],byte +0x0
  db 0x74, 0x14                ; 00003F50  jz 0x3f66
  db 0x8B, 0x44, 0x05          ; 00003F52  mov ax,[si+0x5]
  db 0x8B, 0x7C, 0x07          ; 00003F55  mov di,[si+0x7]
  db 0x01, 0x45, 0x05          ; 00003F58  add [di+0x5],ax
  db 0x8B, 0x5C, 0x09          ; 00003F5B  mov bx,[si+0x9]
  db 0x89, 0x5D, 0x09          ; 00003F5E  mov [di+0x9],bx
  db 0x89, 0x7F, 0x07          ; 00003F61  mov [bx+0x7],di
  db 0xEB, 0x13                ; 00003F64  jmp short 0x3f79
  db 0x8B, 0x7C, 0x07          ; 00003F66  mov di,[si+0x7]
  db 0x2E, 0x89, 0x3E, 0xD7, 0x3E ; 00003F69  mov [cs:0x3ed7],di
  db 0x8B, 0x44, 0x05          ; 00003F6E  mov ax,[si+0x5]
  db 0x01, 0x45, 0x05          ; 00003F71  add [di+0x5],ax
  db 0xC7, 0x45, 0x09, 0x00, 0x00 ; 00003F74  mov word [di+0x9],0x0
  db 0x5F                      ; 00003F79  pop di
  db 0xC7, 0x44, 0x07, 0x00, 0x00 ; 00003F7A  mov word [si+0x7],0x0
  db 0xC7, 0x44, 0x09, 0x00, 0x00 ; 00003F7F  mov word [si+0x9],0x0
  db 0x9D                      ; 00003F84  popf
  db 0xC3                      ; 00003F85  ret
  db 0x9C                      ; 00003F86  pushf
  db 0xFA                      ; 00003F87  cli
  db 0x33, 0xC9                ; 00003F88  xor cx,cx
  db 0x2E, 0x80, 0x3E, 0xD6, 0x3E, 0x00 ; 00003F8A  cmp byte [cs:0x3ed6],0x0
  db 0x74, 0x24                ; 00003F90  jz 0x3fb6
  db 0x2E, 0x8B, 0x36, 0xD7, 0x3E ; 00003F92  mov si,[cs:0x3ed7]
  db 0x56                      ; 00003F97  push si
  db 0x83, 0x7C, 0x05, 0x00    ; 00003F98  cmp word [si+0x5],byte +0x0
  db 0x75, 0x0D                ; 00003F9C  jnz 0x3fab
  db 0x41                      ; 00003F9E  inc cx
  db 0x2E, 0xFE, 0x0E, 0xD6, 0x3E ; 00003F9F  dec byte [cs:0x3ed6]
  db 0x74, 0x05                ; 00003FA4  jz 0x3fab
  db 0x8B, 0x74, 0x07          ; 00003FA6  mov si,[si+0x7]
  db 0xEB, 0xED                ; 00003FA9  jmp short 0x3f98
  db 0x2E, 0x89, 0x36, 0xD7, 0x3E ; 00003FAB  mov [cs:0x3ed7],si
  db 0xC7, 0x44, 0x09, 0x00, 0x00 ; 00003FB0  mov word [si+0x9],0x0
  db 0x5E                      ; 00003FB5  pop si
  db 0x9D                      ; 00003FB6  popf
  db 0xC3                      ; 00003FB7  ret
  db 0xFF, 0x8C, 0xC8, 0x8E    ; 00003FB8  dec word [si-0x7138]
  db 0xD8, 0x2E, 0x80, 0x3E    ; 00003FBC  fsubr dword [0x3e80]
  db 0xF4                      ; 00003FC0  hlt
  db 0x3D, 0x00, 0x74          ; 00003FC1  cmp ax,0x7400
  db 0x16                      ; 00003FC4  push ss
  db 0x2E, 0x8B, 0x1E, 0xF5, 0x3D ; 00003FC5  mov bx,[cs:0x3df5]
  db 0x80, 0x7F, 0x0B, 0x00    ; 00003FCA  cmp byte [bx+0xb],0x0
  db 0x74, 0x0B                ; 00003FCE  jz 0x3fdb
  db 0xFE, 0x4F, 0x0B          ; 00003FD0  dec byte [bx+0xb]
  db 0x75, 0x06                ; 00003FD3  jnz 0x3fdb
  db 0x2E, 0x80, 0x0E, 0xCB, 0x42, 0x01 ; 00003FD5  or byte [cs:0x42cb],0x1
  db 0x2E, 0x80, 0x3E, 0xD6, 0x3E, 0x00 ; 00003FDB  cmp byte [cs:0x3ed6],0x0
  db 0x74, 0x16                ; 00003FE1  jz 0x3ff9
  db 0x2E, 0x8B, 0x1E, 0xD7, 0x3E ; 00003FE3  mov bx,[cs:0x3ed7]
  db 0x83, 0x7F, 0x05, 0x00    ; 00003FE8  cmp word [bx+0x5],byte +0x0
  db 0x74, 0x0B                ; 00003FEC  jz 0x3ff9
  db 0xFF, 0x4F, 0x05          ; 00003FEE  dec word [bx+0x5]
  db 0x75, 0x06                ; 00003FF1  jnz 0x3ff9
  db 0x2E, 0x80, 0x0E, 0xCB, 0x42, 0x02 ; 00003FF3  or byte [cs:0x42cb],0x2
  db 0x2E, 0x83, 0x3E, 0xAC, 0x1E, 0x00 ; 00003FF9  cmp word [cs:0x1eac],byte +0x0
  db 0x74, 0x0D                ; 00003FFF  jz 0x400e
  db 0x2E, 0xFF, 0x0E, 0xAC, 0x1E ; 00004001  dec word [cs:0x1eac]
  db 0x75, 0x06                ; 00004006  jnz 0x400e
  db 0x2E, 0x80, 0x0E, 0xCB, 0x42, 0x04 ; 00004008  or byte [cs:0x42cb],0x4
  db 0x2E, 0x83, 0x3E, 0x14, 0x1F, 0x00 ; 0000400E  cmp word [cs:0x1f14],byte +0x0
  db 0x74, 0x0D                ; 00004014  jz 0x4023
  db 0x2E, 0xFF, 0x0E, 0x14, 0x1F ; 00004016  dec word [cs:0x1f14]
  db 0x75, 0x06                ; 0000401B  jnz 0x4023
  db 0x2E, 0x80, 0x0E, 0xCB, 0x42, 0x08 ; 0000401D  or byte [cs:0x42cb],0x8
  db 0x2E, 0x80, 0x3E, 0xB8, 0x3F, 0x00 ; 00004023  cmp byte [cs:0x3fb8],0x0
  db 0x74, 0x0E                ; 00004029  jz 0x4039
  db 0x2E, 0x80, 0x3E, 0xCB, 0x42, 0x00 ; 0000402B  cmp byte [cs:0x42cb],0x0
  db 0x74, 0x06                ; 00004031  jz 0x4039
  db 0xBA, 0x17, 0x00          ; 00004033  mov dx,0x17
  db 0xE8, 0x19, 0x04          ; 00004036  call 0x4452
  db 0xCB                      ; 00004039  retf
  db 0x50                      ; 0000403A  push ax
  db 0x2E, 0x8C, 0x16, 0x45, 0x42 ; 0000403B  mov [cs:0x4245],ss
  db 0x2E, 0x89, 0x26, 0x47, 0x42 ; 00004040  mov [cs:0x4247],sp
  db 0xBC, 0xC9, 0x42          ; 00004045  mov sp,0x42c9
  db 0x8C, 0xC8                ; 00004048  mov ax,cs
  db 0x8E, 0xD0                ; 0000404A  mov ss,ax
  db 0x60                      ; 0000404C  pusha
  db 0x1E                      ; 0000404D  push ds
  db 0x8E, 0xD8                ; 0000404E  mov ds,ax
  db 0x2E, 0x83, 0x3E, 0x8A, 0x1F, 0x00 ; 00004050  cmp word [cs:0x1f8a],byte +0x0
  db 0x75, 0xF8                ; 00004056  jnz 0x4050
  db 0x2E, 0xA1, 0x88, 0x1F    ; 00004058  mov ax,[cs:0x1f88]
  db 0x25, 0x00, 0xF0          ; 0000405C  and ax,0xf000
  db 0x2E, 0xA3, 0x8A, 0x1F    ; 0000405F  mov [cs:0x1f8a],ax
  db 0x2E, 0xF7, 0x06, 0x8A, 0x1F, 0x00, 0xA0 ; 00004063  test word [cs:0x1f8a],0xa000
  db 0x74, 0x06                ; 0000406A  jz 0x4072
  db 0xBA, 0x16, 0x00          ; 0000406C  mov dx,0x16
  db 0xE8, 0xE0, 0x03          ; 0000406F  call 0x4452
  db 0x2E, 0xF7, 0x06, 0x8A, 0x1F, 0x00, 0x50 ; 00004072  test word [cs:0x1f8a],0x5000
  db 0x75, 0x0A                ; 00004079  jnz 0x4085
  db 0x2E, 0x81, 0x0E, 0x8A, 0x1F, 0x00, 0x00 ; 0000407B  or word [cs:0x1f8a],0x0
  db 0xE9, 0xF5, 0x00          ; 00004082  jmp 0x417a
  db 0x2E, 0x8B, 0x1E, 0x8E, 0x1F ; 00004085  mov bx,[cs:0x1f8e]
  db 0x83, 0xFB, 0x00          ; 0000408A  cmp bx,byte +0x0
  db 0x74, 0x78                ; 0000408D  jz 0x4107
  db 0xF7, 0x07, 0x00, 0x40    ; 0000408F  test word [bx],0x4000
  db 0x75, 0x61                ; 00004093  jnz 0x40f6
  db 0x81, 0x3F, 0x00, 0xA0    ; 00004095  cmp word [bx],0xa000
  db 0x75, 0x37                ; 00004099  jnz 0x40d2
  db 0x2E, 0xFF, 0x06, 0x2E, 0x15 ; 0000409B  inc word [cs:0x152e]
  db 0x2E, 0x83, 0x3E, 0x30, 0x15, 0x00 ; 000040A0  cmp word [cs:0x1530],byte +0x0
  db 0x75, 0x0C                ; 000040A6  jnz 0x40b4
  db 0x2E, 0x89, 0x1E, 0x30, 0x15 ; 000040A8  mov [cs:0x1530],bx
  db 0x2E, 0x89, 0x1E, 0x32, 0x15 ; 000040AD  mov [cs:0x1532],bx
  db 0xEB, 0x0D                ; 000040B2  jmp short 0x40c1
  db 0x2E, 0x8B, 0x36, 0x32, 0x15 ; 000040B4  mov si,[cs:0x1532]
  db 0x89, 0x5C, 0x04          ; 000040B9  mov [si+0x4],bx
  db 0x2E, 0x89, 0x1E, 0x32, 0x15 ; 000040BC  mov [cs:0x1532],bx
  db 0xF7, 0x47, 0x02, 0x00, 0x80 ; 000040C1  test word [bx+0x2],0x8000
  db 0x74, 0x05                ; 000040C6  jz 0x40cd
  db 0xBB, 0x00, 0x00          ; 000040C8  mov bx,0x0
  db 0xEB, 0x29                ; 000040CB  jmp short 0x40f6
  db 0x8B, 0x5F, 0x04          ; 000040CD  mov bx,[bx+0x4]
  db 0xEB, 0xBD                ; 000040D0  jmp short 0x408f
  db 0x2E, 0xFF, 0x06, 0x3F, 0x15 ; 000040D2  inc word [cs:0x153f]
  db 0x8B, 0x77, 0x04          ; 000040D7  mov si,[bx+0x4]
  db 0x8B, 0x47, 0x02          ; 000040DA  mov ax,[bx+0x2]
  db 0x1E                      ; 000040DD  push ds
  db 0x53                      ; 000040DE  push bx
  db 0xC7, 0x07, 0xFF, 0x00    ; 000040DF  mov word [bx],0xff
  db 0xCD, 0x29                ; 000040E3  int 0x29
  db 0x83, 0xC4, 0x04          ; 000040E5  add sp,byte +0x4
  db 0xA9, 0x00, 0x80          ; 000040E8  test ax,0x8000
  db 0x74, 0x05                ; 000040EB  jz 0x40f2
  db 0xBB, 0x00, 0x00          ; 000040ED  mov bx,0x0
  db 0xEB, 0x04                ; 000040F0  jmp short 0x40f6
  db 0x8B, 0xDE                ; 000040F2  mov bx,si
  db 0xEB, 0x99                ; 000040F4  jmp short 0x408f
  db 0x2E, 0x89, 0x1E, 0x8E, 0x1F ; 000040F6  mov [cs:0x1f8e],bx
  db 0xBA, 0x17, 0x00          ; 000040FB  mov dx,0x17
  db 0xE8, 0x51, 0x03          ; 000040FE  call 0x4452
  db 0x2E, 0xC6, 0x06, 0xCC, 0x42, 0xFF ; 00004101  mov byte [cs:0x42cc],0xff
  db 0x2E, 0xF7, 0x06, 0x8A, 0x1F, 0x00, 0x10 ; 00004107  test word [cs:0x1f8a],0x1000
  db 0x75, 0x0A                ; 0000410E  jnz 0x411a
  db 0x2E, 0x81, 0x0E, 0x8A, 0x1F, 0x00, 0x00 ; 00004110  or word [cs:0x1f8a],0x0
  db 0xE9, 0x60, 0x00          ; 00004117  jmp 0x417a
  db 0x2E, 0x80, 0x3E, 0x35, 0x15, 0x00 ; 0000411A  cmp byte [cs:0x1535],0x0
  db 0x74, 0x4B                ; 00004120  jz 0x416d
  db 0x2E, 0x80, 0x3E, 0x3A, 0x15, 0x00 ; 00004122  cmp byte [cs:0x153a],0x0
  db 0x74, 0x43                ; 00004128  jz 0x416d
  db 0x2E, 0x81, 0x0E, 0x8A, 0x1F, 0x10, 0x00 ; 0000412A  or word [cs:0x1f8a],0x10
  db 0x2E, 0x8B, 0x36, 0x36, 0x15 ; 00004131  mov si,[cs:0x1536]
  db 0x2E, 0x8B, 0x3E, 0x3B, 0x15 ; 00004136  mov di,[cs:0x153b]
  db 0x89, 0x7C, 0x06          ; 0000413B  mov [si+0x6],di
  db 0x2E, 0x89, 0x36, 0x8E, 0x1F ; 0000413E  mov [cs:0x1f8e],si
  db 0x2E, 0xC6, 0x06, 0x35, 0x15, 0x00 ; 00004143  mov byte [cs:0x1535],0x0
  db 0x2E, 0xC7, 0x06, 0x36, 0x15, 0x00, 0x00 ; 00004149  mov word [cs:0x1536],0x0
  db 0x2E, 0xC7, 0x06, 0x38, 0x15, 0x00, 0x00 ; 00004150  mov word [cs:0x1538],0x0
  db 0x2E, 0xC6, 0x06, 0x3A, 0x15, 0x00 ; 00004157  mov byte [cs:0x153a],0x0
  db 0x2E, 0xC7, 0x06, 0x3B, 0x15, 0x00, 0x00 ; 0000415D  mov word [cs:0x153b],0x0
  db 0x2E, 0xC7, 0x06, 0x3D, 0x15, 0x00, 0x00 ; 00004164  mov word [cs:0x153d],0x0
  db 0xEB, 0x0D                ; 0000416B  jmp short 0x417a
  db 0x2E, 0x81, 0x0E, 0x8A, 0x1F, 0x00, 0x00 ; 0000416D  or word [cs:0x1f8a],0x0
  db 0x2E, 0xC6, 0x06, 0x34, 0x15, 0xFF ; 00004174  mov byte [cs:0x1534],0xff
  db 0xBA, 0x00, 0x01          ; 0000417A  mov dx,0x100
  db 0xEC                      ; 0000417D  in al,dx
  db 0xB0, 0x20                ; 0000417E  mov al,0x20
  db 0xE6, 0x00                ; 00004180  out 0x0,al
  db 0xBA, 0x22, 0xFF          ; 00004182  mov dx,0xff22
  db 0xB8, 0x00, 0x80          ; 00004185  mov ax,0x8000
  db 0xEF                      ; 00004188  out dx,ax
  db 0x1F                      ; 00004189  pop ds
  db 0x61                      ; 0000418A  popa
  db 0x2E, 0x8B, 0x26, 0x47, 0x42 ; 0000418B  mov sp,[cs:0x4247]
  db 0x2E, 0x8E, 0x16, 0x45, 0x42 ; 00004190  mov ss,[cs:0x4245]
  db 0x58                      ; 00004195  pop ax
  db 0x2E, 0xFF, 0x2E, 0x3F, 0x42 ; 00004196  jmp far [cs:0x423f]
  db 0xFA                      ; 0000419B  cli
  db 0x60                      ; 0000419C  pusha
  db 0x8B, 0xEC                ; 0000419D  mov bp,sp
  db 0x1E                      ; 0000419F  push ds
  db 0xC5, 0x5E, 0x16          ; 000041A0  lds bx,[bp+0x16]
  db 0x80, 0x3F, 0x00          ; 000041A3  cmp byte [bx],0x0
  db 0x75, 0x03                ; 000041A6  jnz 0x41ab
  db 0xE9, 0x8B, 0x00          ; 000041A8  jmp 0x4236
  db 0x8B, 0x7F, 0x06          ; 000041AB  mov di,[bx+0x6]
  db 0x83, 0xFF, 0xFF          ; 000041AE  cmp di,byte -0x1
  db 0x74, 0x4A                ; 000041B1  jz 0x41fd
  db 0x2E, 0x80, 0x3E, 0x3A, 0x15, 0x00 ; 000041B3  cmp byte [cs:0x153a],0x0
  db 0x75, 0x07                ; 000041B9  jnz 0x41c2
  db 0x2E, 0x89, 0x3E, 0x3B, 0x15 ; 000041BB  mov [cs:0x153b],di
  db 0xEB, 0x0D                ; 000041C0  jmp short 0x41cf
  db 0x2E, 0x8B, 0x36, 0x3D, 0x15 ; 000041C2  mov si,[cs:0x153d]
  db 0x81, 0x64, 0x08, 0xFF, 0x7F ; 000041C7  and word [si+0x8],0x7fff
  db 0x89, 0x7C, 0x02          ; 000041CC  mov [si+0x2],di
  db 0x2E, 0xFE, 0x06, 0x3A, 0x15 ; 000041CF  inc byte [cs:0x153a]
  db 0xF7, 0x45, 0x08, 0x00, 0x80 ; 000041D4  test word [di+0x8],0x8000
  db 0x75, 0x14                ; 000041D9  jnz 0x41ef
  db 0xF7, 0x05, 0x00, 0x80    ; 000041DB  test word [di],0x8000
  db 0x75, 0x0E                ; 000041DF  jnz 0x41ef
  db 0x2E, 0xFE, 0x06, 0x3A, 0x15 ; 000041E1  inc byte [cs:0x153a]
  db 0xC7, 0x05, 0x00, 0x00    ; 000041E6  mov word [di],0x0
  db 0x8B, 0x7D, 0x02          ; 000041EA  mov di,[di+0x2]
  db 0xEB, 0xE5                ; 000041ED  jmp short 0x41d4
  db 0xC7, 0x05, 0x00, 0x00    ; 000041EF  mov word [di],0x0
  db 0x81, 0x4D, 0x08, 0x00, 0x80 ; 000041F3  or word [di+0x8],0x8000
  db 0x2E, 0x89, 0x3E, 0x3D, 0x15 ; 000041F8  mov [cs:0x153d],di
  db 0x2E, 0xFE, 0x06, 0x35, 0x15 ; 000041FD  inc byte [cs:0x1535]
  db 0xC7, 0x07, 0x00, 0x00    ; 00004202  mov word [bx],0x0
  db 0xC7, 0x47, 0x02, 0x00, 0x80 ; 00004206  mov word [bx+0x2],0x8000
  db 0xC7, 0x47, 0x06, 0xFF, 0xFF ; 0000420B  mov word [bx+0x6],0xffff
  db 0x2E, 0x80, 0x3E, 0x35, 0x15, 0x01 ; 00004210  cmp byte [cs:0x1535],0x1
  db 0x75, 0x0C                ; 00004216  jnz 0x4224
  db 0x2E, 0x89, 0x1E, 0x36, 0x15 ; 00004218  mov [cs:0x1536],bx
  db 0x2E, 0x89, 0x1E, 0x38, 0x15 ; 0000421D  mov [cs:0x1538],bx
  db 0xEB, 0x12                ; 00004222  jmp short 0x4236
  db 0x2E, 0x8B, 0x36, 0x38, 0x15 ; 00004224  mov si,[cs:0x1538]
  db 0xC7, 0x44, 0x02, 0x00, 0x00 ; 00004229  mov word [si+0x2],0x0
  db 0x89, 0x5C, 0x04          ; 0000422E  mov [si+0x4],bx
  db 0x2E, 0x89, 0x1E, 0x38, 0x15 ; 00004231  mov [cs:0x1538],bx
  db 0x1F                      ; 00004236  pop ds
  db 0x61                      ; 00004237  popa
  db 0xCF                      ; 00004238  iret
  db 0x00, 0x00                ; 00004239  add [bx+si],al
  db 0x00, 0x00                ; 0000423B  add [bx+si],al
  db 0x00, 0x00                ; 0000423D  add [bx+si],al
  db 0x00, 0x00                ; 0000423F  add [bx+si],al
  db 0x00, 0x00                ; 00004241  add [bx+si],al
  db 0x00, 0x00                ; 00004243  add [bx+si],al
  db 0x00, 0x00                ; 00004245  add [bx+si],al
  db 0x00, 0x00                ; 00004247  add [bx+si],al
  db 0xCC                      ; 00004249  int3
  db 0xCC                      ; 0000424A  int3
  db 0xCC                      ; 0000424B  int3
  db 0xCC                      ; 0000424C  int3
  db 0xCC                      ; 0000424D  int3
  db 0xCC                      ; 0000424E  int3
  db 0xCC                      ; 0000424F  int3
  db 0xCC                      ; 00004250  int3
  db 0xCC                      ; 00004251  int3
  db 0xCC                      ; 00004252  int3
  db 0xCC                      ; 00004253  int3
  db 0xCC                      ; 00004254  int3
  db 0xCC                      ; 00004255  int3
  db 0xCC                      ; 00004256  int3
  db 0xCC                      ; 00004257  int3
  db 0xCC                      ; 00004258  int3
  db 0xCC                      ; 00004259  int3
  db 0xCC                      ; 0000425A  int3
  db 0xCC                      ; 0000425B  int3
  db 0xCC                      ; 0000425C  int3
  db 0xCC                      ; 0000425D  int3
  db 0xCC                      ; 0000425E  int3
  db 0xCC                      ; 0000425F  int3
  db 0xCC                      ; 00004260  int3
  db 0xCC                      ; 00004261  int3
  db 0xCC                      ; 00004262  int3
  db 0xCC                      ; 00004263  int3
  db 0xCC                      ; 00004264  int3
  db 0xCC                      ; 00004265  int3
  db 0xCC                      ; 00004266  int3
  db 0xCC                      ; 00004267  int3
  db 0xCC                      ; 00004268  int3
  db 0xCC                      ; 00004269  int3
  db 0xCC                      ; 0000426A  int3
  db 0xCC                      ; 0000426B  int3
  db 0xCC                      ; 0000426C  int3
  db 0xCC                      ; 0000426D  int3
  db 0xCC                      ; 0000426E  int3
  db 0xCC                      ; 0000426F  int3
  db 0xCC                      ; 00004270  int3
  db 0xCC                      ; 00004271  int3
  db 0xCC                      ; 00004272  int3
  db 0xCC                      ; 00004273  int3
  db 0xCC                      ; 00004274  int3
  db 0xCC                      ; 00004275  int3
  db 0xCC                      ; 00004276  int3
  db 0xCC                      ; 00004277  int3
  db 0xCC                      ; 00004278  int3
  db 0xCC                      ; 00004279  int3
  db 0xCC                      ; 0000427A  int3
  db 0xCC                      ; 0000427B  int3
  db 0xCC                      ; 0000427C  int3
  db 0xCC                      ; 0000427D  int3
  db 0xCC                      ; 0000427E  int3
  db 0xCC                      ; 0000427F  int3
  db 0xCC                      ; 00004280  int3
  db 0xCC                      ; 00004281  int3
  db 0xCC                      ; 00004282  int3
  db 0xCC                      ; 00004283  int3
  db 0xCC                      ; 00004284  int3
  db 0xCC                      ; 00004285  int3
  db 0xCC                      ; 00004286  int3
  db 0xCC                      ; 00004287  int3
  db 0xCC                      ; 00004288  int3
  db 0xCC                      ; 00004289  int3
  db 0xCC                      ; 0000428A  int3
  db 0xCC                      ; 0000428B  int3
  db 0xCC                      ; 0000428C  int3
  db 0xCC                      ; 0000428D  int3
  db 0xCC                      ; 0000428E  int3
  db 0xCC                      ; 0000428F  int3
  db 0xCC                      ; 00004290  int3
  db 0xCC                      ; 00004291  int3
  db 0xCC                      ; 00004292  int3
  db 0xCC                      ; 00004293  int3
  db 0xCC                      ; 00004294  int3
  db 0xCC                      ; 00004295  int3
  db 0xCC                      ; 00004296  int3
  db 0xCC                      ; 00004297  int3
  db 0xCC                      ; 00004298  int3
  db 0xCC                      ; 00004299  int3
  db 0xCC                      ; 0000429A  int3
  db 0xCC                      ; 0000429B  int3
  db 0xCC                      ; 0000429C  int3
  db 0xCC                      ; 0000429D  int3
  db 0xCC                      ; 0000429E  int3
  db 0xCC                      ; 0000429F  int3
  db 0xCC                      ; 000042A0  int3
  db 0xCC                      ; 000042A1  int3
  db 0xCC                      ; 000042A2  int3
  db 0xCC                      ; 000042A3  int3
  db 0xCC                      ; 000042A4  int3
  db 0xCC                      ; 000042A5  int3
  db 0xCC                      ; 000042A6  int3
  db 0xCC                      ; 000042A7  int3
  db 0xCC                      ; 000042A8  int3
  db 0xCC                      ; 000042A9  int3
  db 0xCC                      ; 000042AA  int3
  db 0xCC                      ; 000042AB  int3
  db 0xCC                      ; 000042AC  int3
  db 0xCC                      ; 000042AD  int3
  db 0xCC                      ; 000042AE  int3
  db 0xCC                      ; 000042AF  int3
  db 0xCC                      ; 000042B0  int3
  db 0xCC                      ; 000042B1  int3
  db 0xCC                      ; 000042B2  int3
  db 0xCC                      ; 000042B3  int3
  db 0xCC                      ; 000042B4  int3
  db 0xCC                      ; 000042B5  int3
  db 0xCC                      ; 000042B6  int3
  db 0xCC                      ; 000042B7  int3
  db 0xCC                      ; 000042B8  int3
  db 0xCC                      ; 000042B9  int3
  db 0xCC                      ; 000042BA  int3
  db 0xCC                      ; 000042BB  int3
  db 0xCC                      ; 000042BC  int3
  db 0xCC                      ; 000042BD  int3
  db 0xCC                      ; 000042BE  int3
  db 0xCC                      ; 000042BF  int3
  db 0xCC                      ; 000042C0  int3
  db 0xCC                      ; 000042C1  int3
  db 0xCC                      ; 000042C2  int3
  db 0xCC                      ; 000042C3  int3
  db 0xCC                      ; 000042C4  int3
  db 0xCC                      ; 000042C5  int3
  db 0xCC                      ; 000042C6  int3
  db 0xCC                      ; 000042C7  int3
  db 0xCC                      ; 000042C8  int3
  db 0xCC                      ; 000042C9  int3
  db 0xCC                      ; 000042CA  int3
  db 0x00, 0x00                ; 000042CB  add [bx+si],al
  db 0x2E, 0x3A, 0x06, 0xA5, 0x1E ; 000042CD  cmp al,[cs:0x1ea5]
  db 0x75, 0x05                ; 000042D2  jnz 0x42d9
  db 0xBE, 0xA5, 0x1E          ; 000042D4  mov si,0x1ea5
  db 0xF8                      ; 000042D7  clc
  db 0xC3                      ; 000042D8  ret
  db 0x2E, 0x3A, 0x06, 0x0D, 0x1F ; 000042D9  cmp al,[cs:0x1f0d]
  db 0x75, 0x05                ; 000042DE  jnz 0x42e5
  db 0xBE, 0x0D, 0x1F          ; 000042E0  mov si,0x1f0d
  db 0xF8                      ; 000042E3  clc
  db 0xC3                      ; 000042E4  ret
  db 0xF9                      ; 000042E5  stc
  db 0xC3                      ; 000042E6  ret
  db 0x57                      ; 000042E7  push di
  db 0xBF, 0x45, 0x15          ; 000042E8  mov di,0x1545
  db 0x32, 0xE4                ; 000042EB  xor ah,ah
  db 0xB9, 0x4B, 0x00          ; 000042ED  mov cx,0x4b
  db 0xF7, 0xE1                ; 000042F0  mul cx
  db 0x03, 0xF8                ; 000042F2  add di,ax
  db 0x39, 0x75, 0x07          ; 000042F4  cmp [di+0x7],si
  db 0x75, 0x08                ; 000042F7  jnz 0x4301
  db 0x8B, 0xF7                ; 000042F9  mov si,di
  db 0x83, 0xC6, 0x07          ; 000042FB  add si,byte +0x7
  db 0xF8                      ; 000042FE  clc
  db 0xEB, 0x0E                ; 000042FF  jmp short 0x430f
  db 0x39, 0x75, 0x29          ; 00004301  cmp [di+0x29],si
  db 0x75, 0x08                ; 00004304  jnz 0x430e
  db 0x8B, 0xF7                ; 00004306  mov si,di
  db 0x83, 0xC6, 0x29          ; 00004308  add si,byte +0x29
  db 0xF8                      ; 0000430B  clc
  db 0xEB, 0x01                ; 0000430C  jmp short 0x430f
  db 0xF9                      ; 0000430E  stc
  db 0x5F                      ; 0000430F  pop di
  db 0xC3                      ; 00004310  ret
  db 0x8A, 0x44, 0x06          ; 00004311  mov al,[si+0x6]
  db 0x3C, 0xFE                ; 00004314  cmp al,0xfe
  db 0x74, 0x03                ; 00004316  jz 0x431b
  db 0xFE, 0x44, 0x06          ; 00004318  inc byte [si+0x6]
  db 0x88, 0x44, 0x10          ; 0000431B  mov [si+0x10],al
  db 0x2E, 0x8E, 0x06, 0x43, 0x42 ; 0000431E  mov es,[cs:0x4243]
  db 0xB0, 0x05                ; 00004323  mov al,0x5
  db 0xAA                      ; 00004325  stosb
  db 0x8A, 0x04                ; 00004326  mov al,[si]
  db 0x56                      ; 00004328  push si
  db 0xBE, 0x75, 0x1F          ; 00004329  mov si,0x1f75
  db 0x3C, 0x08                ; 0000432C  cmp al,0x8
  db 0x74, 0x0C                ; 0000432E  jz 0x433c
  db 0x3C, 0x04                ; 00004330  cmp al,0x4
  db 0x75, 0x05                ; 00004332  jnz 0x4339
  db 0xBE, 0x7B, 0x1F          ; 00004334  mov si,0x1f7b
  db 0xEB, 0x03                ; 00004337  jmp short 0x433c
  db 0xBE, 0x81, 0x1F          ; 00004339  mov si,0x1f81
  db 0xB9, 0x03, 0x00          ; 0000433C  mov cx,0x3
  db 0xF3, 0xA5                ; 0000433F  rep movsw
  db 0x5E                      ; 00004341  pop si
  db 0x8B, 0x44, 0x09          ; 00004342  mov ax,[si+0x9]
  db 0xAB                      ; 00004345  stosw
  db 0x8B, 0xC6                ; 00004346  mov ax,si
  db 0x05, 0x0B, 0x00          ; 00004348  add ax,0xb
  db 0xAB                      ; 0000434B  stosw
  db 0x8C, 0xD8                ; 0000434C  mov ax,ds
  db 0xAB                      ; 0000434E  stosw
  db 0x56                      ; 0000434F  push si
  db 0x53                      ; 00004350  push bx
  db 0xB1, 0x8B                ; 00004351  mov cl,0x8b
  db 0xCD, 0xE0                ; 00004353  int 0xe0
  db 0x5B                      ; 00004355  pop bx
  db 0x5E                      ; 00004356  pop si
  db 0xC7, 0x44, 0x07, 0xE8, 0x03 ; 00004357  mov word [si+0x7],0x3e8
  db 0xC3                      ; 0000435C  ret
  db 0x2E, 0x8E, 0x06, 0x43, 0x42 ; 0000435D  mov es,[cs:0x4243]
  db 0xB0, 0x00                ; 00004362  mov al,0x0
  db 0xAA                      ; 00004364  stosb
  db 0x8B, 0xC6                ; 00004365  mov ax,si
  db 0xAB                      ; 00004367  stosw
  db 0x8A, 0x44, 0x11          ; 00004368  mov al,[si+0x11]
  db 0xAA                      ; 0000436B  stosb
  db 0xC6, 0x44, 0x21, 0x01    ; 0000436C  mov byte [si+0x21],0x1
  db 0x56                      ; 00004370  push si
  db 0xB1, 0x8B                ; 00004371  mov cl,0x8b
  db 0xCD, 0xE0                ; 00004373  int 0xe0
  db 0x5E                      ; 00004375  pop si
  db 0xC3                      ; 00004376  ret
  db 0xC4, 0x7C, 0x15          ; 00004377  les di,[si+0x15]
  db 0x8B, 0x1C                ; 0000437A  mov bx,[si]
  db 0x8A, 0x47, 0x06          ; 0000437C  mov al,[bx+0x6]
  db 0x26, 0x88, 0x45, 0x05    ; 0000437F  mov [es:di+0x5],al
  db 0xBF, 0x1F, 0x15          ; 00004383  mov di,0x151f
  db 0x2E, 0x8E, 0x06, 0x43, 0x42 ; 00004386  mov es,[cs:0x4243]
  db 0xB0, 0x04                ; 0000438B  mov al,0x4
  db 0xAA                      ; 0000438D  stosb
  db 0x8B, 0xC6                ; 0000438E  mov ax,si
  db 0xAB                      ; 00004390  stosw
  db 0xE8, 0x9C, 0x00          ; 00004391  call 0x4430
  db 0xAA                      ; 00004394  stosb
  db 0xC6, 0x44, 0x21, 0x01    ; 00004395  mov byte [si+0x21],0x1
  db 0x56                      ; 00004399  push si
  db 0xBA, 0x03, 0x15          ; 0000439A  mov dx,0x1503
  db 0xB1, 0x8B                ; 0000439D  mov cl,0x8b
  db 0xCD, 0xE0                ; 0000439F  int 0xe0
  db 0x5E                      ; 000043A1  pop si
  db 0xC3                      ; 000043A2  ret
  db 0xE8, 0x32, 0x00          ; 000043A3  call 0x43d8
  db 0x53                      ; 000043A6  push bx
  db 0xBB, 0x1F, 0x15          ; 000043A7  mov bx,0x151f
  db 0xC6, 0x47, 0x0A, 0x02    ; 000043AA  mov byte [bx+0xa],0x2
  db 0x88, 0x47, 0x0B          ; 000043AE  mov [bx+0xb],al
  db 0x88, 0x67, 0x0C          ; 000043B1  mov [bx+0xc],ah
  db 0xE9, 0x14, 0x00          ; 000043B4  jmp 0x43cb
  db 0xE8, 0x1E, 0x00          ; 000043B7  call 0x43d8
  db 0x53                      ; 000043BA  push bx
  db 0xBB, 0x1F, 0x15          ; 000043BB  mov bx,0x151f
  db 0xC6, 0x47, 0x0A, 0x04    ; 000043BE  mov byte [bx+0xa],0x4
  db 0x88, 0x67, 0x0B          ; 000043C2  mov [bx+0xb],ah
  db 0x8A, 0x44, 0x04          ; 000043C5  mov al,[si+0x4]
  db 0x88, 0x47, 0x0C          ; 000043C8  mov [bx+0xc],al
  db 0x56                      ; 000043CB  push si
  db 0x57                      ; 000043CC  push di
  db 0xB1, 0x8B                ; 000043CD  mov cl,0x8b
  db 0xBA, 0x03, 0x15          ; 000043CF  mov dx,0x1503
  db 0xCD, 0xE0                ; 000043D2  int 0xe0
  db 0x5F                      ; 000043D4  pop di
  db 0x5E                      ; 000043D5  pop si
  db 0x5B                      ; 000043D6  pop bx
  db 0xC3                      ; 000043D7  ret
  db 0x50                      ; 000043D8  push ax
  db 0x53                      ; 000043D9  push bx
  db 0x56                      ; 000043DA  push si
  db 0x06                      ; 000043DB  push es
  db 0x57                      ; 000043DC  push di
  db 0xBF, 0x1F, 0x15          ; 000043DD  mov di,0x151f
  db 0x2E, 0x8E, 0x06, 0x43, 0x42 ; 000043E0  mov es,[cs:0x4243]
  db 0xB0, 0x02                ; 000043E5  mov al,0x2
  db 0xAA                      ; 000043E7  stosb
  db 0x8B, 0xF3                ; 000043E8  mov si,bx
  db 0x83, 0xC6, 0x0E          ; 000043EA  add si,byte +0xe
  db 0xB9, 0x03, 0x00          ; 000043ED  mov cx,0x3
  db 0xF3, 0xA5                ; 000043F0  rep movsw
  db 0x5F                      ; 000043F2  pop di
  db 0x07                      ; 000043F3  pop es
  db 0x5E                      ; 000043F4  pop si
  db 0x26, 0x8A, 0x45, 0x01    ; 000043F5  mov al,[es:di+0x1]
  db 0xBB, 0x1F, 0x15          ; 000043F9  mov bx,0x151f
  db 0x88, 0x47, 0x07          ; 000043FC  mov [bx+0x7],al
  db 0x26, 0x8A, 0x05          ; 000043FF  mov al,[es:di]
  db 0x88, 0x47, 0x08          ; 00004402  mov [bx+0x8],al
  db 0xC6, 0x47, 0x09, 0x03    ; 00004405  mov byte [bx+0x9],0x3
  db 0x5B                      ; 00004409  pop bx
  db 0x58                      ; 0000440A  pop ax
  db 0xC3                      ; 0000440B  ret
  db 0x00, 0x2E, 0x80, 0x3E    ; 0000440C  add [0x3e80],ch
  db 0x0C, 0x44                ; 00004410  or al,0x44
  db 0xFF, 0x75, 0x06          ; 00004412  push word [di+0x6]
  db 0xB8, 0x80, 0x00          ; 00004415  mov ax,0x80
  db 0xE8, 0x01, 0x00          ; 00004418  call 0x441c
  db 0xCB                      ; 0000441B  retf
  db 0x9C                      ; 0000441C  pushf
  db 0xFA                      ; 0000441D  cli
  db 0x2E, 0x83, 0x3E, 0x8A, 0x1F, 0x00 ; 0000441E  cmp word [cs:0x1f8a],byte +0x0
  db 0x75, 0xF8                ; 00004424  jnz 0x441e
  db 0x2E, 0xA3, 0x8A, 0x1F    ; 00004426  mov [cs:0x1f8a],ax
  db 0xBA, 0x00, 0x01          ; 0000442A  mov dx,0x100
  db 0xEC                      ; 0000442D  in al,dx
  db 0x9D                      ; 0000442E  popf
  db 0xC3                      ; 0000442F  ret
  db 0x8B, 0x44, 0x19          ; 00004430  mov ax,[si+0x19]
  db 0x2D, 0x45, 0x15          ; 00004433  sub ax,0x1545
  db 0x33, 0xD2                ; 00004436  xor dx,dx
  db 0xB9, 0x4B, 0x00          ; 00004438  mov cx,0x4b
  db 0xF7, 0xF1                ; 0000443B  div cx
  db 0xC3                      ; 0000443D  ret
  db 0x1E                      ; 0000443E  push ds
  db 0x2E, 0x8E, 0x1E, 0x39, 0x42 ; 0000443F  mov ds,[cs:0x4239]
  db 0xB9, 0x84, 0x00          ; 00004444  mov cx,0x84
  db 0x2E, 0xFF, 0x1E, 0x3B, 0x42 ; 00004447  call far [cs:0x423b]
  db 0x59                      ; 0000444C  pop cx
  db 0x8E, 0xD9                ; 0000444D  mov ds,cx
  db 0x8E, 0xC1                ; 0000444F  mov es,cx
  db 0xC3                      ; 00004451  ret
  db 0x1E                      ; 00004452  push ds
  db 0x2E, 0x8E, 0x1E, 0x39, 0x42 ; 00004453  mov ds,[cs:0x4239]
  db 0xB9, 0x85, 0x00          ; 00004458  mov cx,0x85
  db 0x2E, 0xFF, 0x1E, 0x3B, 0x42 ; 0000445B  call far [cs:0x423b]
  db 0x1F                      ; 00004460  pop ds
  db 0xC3                      ; 00004461  ret
  db 0x00, 0x00                ; 00004462  add [bx+si],al
  db 0x00, 0x00                ; 00004464  add [bx+si],al
  db 0x00, 0x00                ; 00004466  add [bx+si],al
  db 0x00, 0x00                ; 00004468  add [bx+si],al
  db 0x00, 0x00                ; 0000446A  add [bx+si],al
  db 0x00, 0x00                ; 0000446C  add [bx+si],al
  db 0x00, 0x00                ; 0000446E  add [bx+si],al

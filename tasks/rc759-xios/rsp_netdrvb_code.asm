; ===========================================================================
; Regnecentralen RC759 Piccoline — NETDRVB.RSP Code Segment
; RC-Net Datalink Driver for Intel 82586 Ethernet LAN Controller (Revision B)
; Indeholder processerne NETDRVB, REC og XMIT samt link_req og XMIT_REQ koer
; 1413 paragraffer = 22.608 bytes
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
  db 0x42                      ; 0000001E  inc dx
  db 0x20, 0x04                ; 0000001F  and [si],al
  db 0x00, 0x00                ; 00000021  add [bx+si],al
  db 0x00, 0x00                ; 00000023  add [bx+si],al
  db 0x00, 0x00                ; 00000025  add [bx+si],al
  db 0x00, 0x00                ; 00000027  add [bx+si],al
  db 0x00, 0x00                ; 00000029  add [bx+si],al
  db 0x00, 0x00                ; 0000002B  add [bx+si],al
  db 0x00, 0x00                ; 0000002D  add [bx+si],al
  db 0x00, 0x00                ; 0000002F  add [bx+si],al
  db 0x00, 0x00                ; 00000031  add [bx+si],al
  db 0x00, 0x00                ; 00000033  add [bx+si],al
  db 0x00, 0x00                ; 00000035  add [bx+si],al
  db 0x00, 0x00                ; 00000037  add [bx+si],al
  db 0x00, 0x00                ; 00000039  add [bx+si],al
  db 0x00, 0x00                ; 0000003B  add [bx+si],al
  db 0x00, 0x00                ; 0000003D  add [bx+si],al
  db 0x00, 0x00                ; 0000003F  add [bx+si],al
  db 0x00, 0x00                ; 00000041  add [bx+si],al
  db 0x00, 0x00                ; 00000043  add [bx+si],al
  db 0x00, 0x00                ; 00000045  add [bx+si],al
  db 0x00, 0x00                ; 00000047  add [bx+si],al
  db 0x00, 0x00                ; 00000049  add [bx+si],al
  db 0x00, 0x00                ; 0000004B  add [bx+si],al
  db 0x00, 0x00                ; 0000004D  add [bx+si],al
  db 0x00, 0x00                ; 0000004F  add [bx+si],al
  db 0x00, 0x00                ; 00000051  add [bx+si],al
  db 0x00, 0x00                ; 00000053  add [bx+si],al
  db 0x00, 0x00                ; 00000055  add [bx+si],al
  db 0x00, 0x00                ; 00000057  add [bx+si],al
  db 0x00, 0x00                ; 00000059  add [bx+si],al
  db 0x00, 0x00                ; 0000005B  add [bx+si],al
  db 0x00, 0x00                ; 0000005D  add [bx+si],al
  db 0x00, 0x00                ; 0000005F  add [bx+si],al
  db 0x00, 0x00                ; 00000061  add [bx+si],al
  db 0x00, 0x00                ; 00000063  add [bx+si],al
  db 0x00, 0x00                ; 00000065  add [bx+si],al
  db 0x00, 0x00                ; 00000067  add [bx+si],al
  db 0x00, 0x00                ; 00000069  add [bx+si],al
  db 0x00, 0x00                ; 0000006B  add [bx+si],al
  db 0x00, 0x00                ; 0000006D  add [bx+si],al
  db 0x00, 0x00                ; 0000006F  add [bx+si],al
  db 0x00, 0x00                ; 00000071  add [bx+si],al
  db 0x00, 0x5E, 0x01          ; 00000073  add [bp+0x1],bl
  db 0x00, 0x00                ; 00000076  add [bx+si],al
  db 0x00, 0x00                ; 00000078  add [bx+si],al
  db 0x00, 0x00                ; 0000007A  add [bx+si],al
  db 0x00, 0x00                ; 0000007C  add [bx+si],al
  db 0x00, 0x00                ; 0000007E  add [bx+si],al
  db 0x00, 0x00                ; 00000080  add [bx+si],al
  db 0x00, 0x00                ; 00000082  add [bx+si],al
  db 0x00, 0x00                ; 00000084  add [bx+si],al
  db 0x00, 0x00                ; 00000086  add [bx+si],al
  db 0x00, 0x00                ; 00000088  add [bx+si],al
  db 0x00, 0x00                ; 0000008A  add [bx+si],al
  db 0x00, 0x00                ; 0000008C  add [bx+si],al
  db 0x00, 0x00                ; 0000008E  add [bx+si],al
  db 0x00, 0x00                ; 00000090  add [bx+si],al
  db 0x00, 0x00                ; 00000092  add [bx+si],al
  db 0x00, 0x00                ; 00000094  add [bx+si],al
  db 0x00, 0x00                ; 00000096  add [bx+si],al
  db 0x00, 0x00                ; 00000098  add [bx+si],al
  db 0x00, 0x00                ; 0000009A  add [bx+si],al
  db 0x00, 0x00                ; 0000009C  add [bx+si],al
  db 0x00, 0x00                ; 0000009E  add [bx+si],al
  db 0x00, 0x00                ; 000000A0  add [bx+si],al
  db 0x00, 0x00                ; 000000A2  add [bx+si],al
  db 0x00, 0x00                ; 000000A4  add [bx+si],al
  db 0x00, 0x00                ; 000000A6  add [bx+si],al
  db 0x00, 0x00                ; 000000A8  add [bx+si],al
  db 0x00, 0x00                ; 000000AA  add [bx+si],al
  db 0x00, 0x00                ; 000000AC  add [bx+si],al
  db 0x00, 0x00                ; 000000AE  add [bx+si],al
  db 0x00, 0x00                ; 000000B0  add [bx+si],al
  db 0x00, 0x00                ; 000000B2  add [bx+si],al
  db 0x00, 0x00                ; 000000B4  add [bx+si],al
  db 0x00, 0x00                ; 000000B6  add [bx+si],al
  db 0x00, 0x00                ; 000000B8  add [bx+si],al
  db 0x00, 0x00                ; 000000BA  add [bx+si],al
  db 0x00, 0x00                ; 000000BC  add [bx+si],al
  db 0x00, 0x00                ; 000000BE  add [bx+si],al
  db 0x00, 0x00                ; 000000C0  add [bx+si],al
  db 0x00, 0x00                ; 000000C2  add [bx+si],al
  db 0x00, 0x00                ; 000000C4  add [bx+si],al
  db 0x00, 0x00                ; 000000C6  add [bx+si],al
  db 0x00, 0x00                ; 000000C8  add [bx+si],al
  db 0x00, 0x00                ; 000000CA  add [bx+si],al
  db 0x00, 0x00                ; 000000CC  add [bx+si],al
  db 0x00, 0x00                ; 000000CE  add [bx+si],al
  db 0x00, 0x00                ; 000000D0  add [bx+si],al
  db 0x00, 0x00                ; 000000D2  add [bx+si],al
  db 0x00, 0x00                ; 000000D4  add [bx+si],al
  db 0x00, 0x00                ; 000000D6  add [bx+si],al
  db 0x00, 0x00                ; 000000D8  add [bx+si],al
  db 0x00, 0x00                ; 000000DA  add [bx+si],al
  db 0x00, 0x00                ; 000000DC  add [bx+si],al
  db 0x00, 0x00                ; 000000DE  add [bx+si],al
  db 0x00, 0x00                ; 000000E0  add [bx+si],al
  db 0x00, 0x00                ; 000000E2  add [bx+si],al
  db 0x00, 0x00                ; 000000E4  add [bx+si],al
  db 0x00, 0x00                ; 000000E6  add [bx+si],al
  db 0x00, 0x00                ; 000000E8  add [bx+si],al
  db 0x00, 0x00                ; 000000EA  add [bx+si],al
  db 0x00, 0x00                ; 000000EC  add [bx+si],al
  db 0x00, 0x00                ; 000000EE  add [bx+si],al
  db 0x00, 0x00                ; 000000F0  add [bx+si],al
  db 0x00, 0x00                ; 000000F2  add [bx+si],al
  db 0x00, 0x00                ; 000000F4  add [bx+si],al
  db 0x00, 0x00                ; 000000F6  add [bx+si],al
  db 0x00, 0x00                ; 000000F8  add [bx+si],al
  db 0x00, 0x00                ; 000000FA  add [bx+si],al
  db 0x00, 0x00                ; 000000FC  add [bx+si],al
  db 0x00, 0x00                ; 000000FE  add [bx+si],al
  db 0x00, 0x00                ; 00000100  add [bx+si],al
  db 0x00, 0x00                ; 00000102  add [bx+si],al
  db 0x00, 0x00                ; 00000104  add [bx+si],al
  db 0x00, 0x00                ; 00000106  add [bx+si],al
  db 0x00, 0x00                ; 00000108  add [bx+si],al
  db 0x00, 0x00                ; 0000010A  add [bx+si],al
  db 0x00, 0x00                ; 0000010C  add [bx+si],al
  db 0x00, 0x00                ; 0000010E  add [bx+si],al
  db 0x00, 0x00                ; 00000110  add [bx+si],al
  db 0x00, 0x00                ; 00000112  add [bx+si],al
  db 0x00, 0x00                ; 00000114  add [bx+si],al
  db 0x00, 0x00                ; 00000116  add [bx+si],al
  db 0x00, 0x00                ; 00000118  add [bx+si],al
  db 0x00, 0x00                ; 0000011A  add [bx+si],al
  db 0x00, 0x00                ; 0000011C  add [bx+si],al
  db 0x00, 0x00                ; 0000011E  add [bx+si],al
  db 0x00, 0x00                ; 00000120  add [bx+si],al
  db 0x00, 0x00                ; 00000122  add [bx+si],al
  db 0x00, 0x00                ; 00000124  add [bx+si],al
  db 0x00, 0x00                ; 00000126  add [bx+si],al
  db 0x00, 0x00                ; 00000128  add [bx+si],al
  db 0x00, 0x00                ; 0000012A  add [bx+si],al
  db 0x00, 0x00                ; 0000012C  add [bx+si],al
  db 0x00, 0x00                ; 0000012E  add [bx+si],al
  db 0x00, 0x00                ; 00000130  add [bx+si],al
  db 0x00, 0x00                ; 00000132  add [bx+si],al
  db 0x00, 0x00                ; 00000134  add [bx+si],al
  db 0x00, 0x00                ; 00000136  add [bx+si],al
  db 0x00, 0x00                ; 00000138  add [bx+si],al
  db 0x00, 0x00                ; 0000013A  add [bx+si],al
  db 0x00, 0x00                ; 0000013C  add [bx+si],al
  db 0x00, 0x00                ; 0000013E  add [bx+si],al
  db 0xCC                      ; 00000140  int3
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
  db 0x2E, 0x8C, 0x1E, 0x2F, 0x56 ; 0000072F  mov [cs:0x562f],ds
  db 0xE8, 0x59, 0x31          ; 00000734  call 0x3890
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
  db 0xE8, 0x28, 0x4F          ; 0000078E  call 0x56b9
  db 0x73, 0x05                ; 00000791  jnc 0x798
  db 0xB0, 0x07                ; 00000793  mov al,0x7
  db 0xE9, 0x78, 0x00          ; 00000795  jmp 0x810
  db 0x56                      ; 00000798  push si
  db 0x8A, 0x07                ; 00000799  mov al,[bx]
  db 0xE8, 0x1B, 0x4F          ; 0000079B  call 0x56b9
  db 0x5F                      ; 0000079E  pop di
  db 0x72, 0x05                ; 0000079F  jc 0x7a6
  db 0xB0, 0x06                ; 000007A1  mov al,0x6
  db 0xE9, 0x6A, 0x00          ; 000007A3  jmp 0x810
  db 0x83, 0x7F, 0x06, 0x2E    ; 000007A6  cmp word [bx+0x6],byte +0x2e
  db 0x7E, 0x05                ; 000007AA  jng 0x7b1
  db 0xB0, 0x09                ; 000007AC  mov al,0x9
  db 0xE9, 0x5F, 0x00          ; 000007AE  jmp 0x810
  db 0x8B, 0xF3                ; 000007B1  mov si,bx
  db 0x2E, 0x8E, 0x06, 0x2F, 0x56 ; 000007B3  mov es,[cs:0x562f]
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
  db 0xE8, 0xF4, 0x4E          ; 00000806  call 0x56fd
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
  db 0xE8, 0x7B, 0x4E          ; 0000083B  call 0x56b9
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
  db 0x2E, 0x8E, 0x06, 0x2F, 0x56 ; 0000086A  mov es,[cs:0x562f]
  db 0xB9, 0x68, 0x00          ; 0000086F  mov cx,0x68
  db 0x32, 0xC0                ; 00000872  xor al,al
  db 0xF3, 0xAA                ; 00000874  rep stosb
  db 0x80, 0xFA, 0x01          ; 00000876  cmp dl,0x1
  db 0x74, 0x27                ; 00000879  jz 0x8a2
  db 0xB9, 0x64, 0x00          ; 0000087B  mov cx,0x64
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
  db 0xE8, 0x7A, 0x49          ; 000008B5  call 0x5232
  db 0x5F                      ; 000008B8  pop di
  db 0x83, 0x7D, 0x09, 0x00    ; 000008B9  cmp word [di+0x9],byte +0x0
  db 0x75, 0x06                ; 000008BD  jnz 0x8c5
  db 0x83, 0x7D, 0x07, 0x00    ; 000008BF  cmp word [di+0x7],byte +0x0
  db 0x74, 0x07                ; 000008C3  jz 0x8cc
  db 0x57                      ; 000008C5  push di
  db 0x8B, 0xF7                ; 000008C6  mov si,di
  db 0xE8, 0x4B, 0x4A          ; 000008C8  call 0x5316
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
  db 0xE8, 0xD5, 0x4D          ; 000008E1  call 0x56b9
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
  db 0x2E, 0x8E, 0x06, 0x2F, 0x56 ; 00000904  mov es,[cs:0x562f]
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
  db 0xE8, 0x3E, 0x4D          ; 00000978  call 0x56b9
  db 0x72, 0x36                ; 0000097B  jc 0x9b3
  db 0x81, 0x7F, 0x08, 0x34, 0x04 ; 0000097D  cmp word [bx+0x8],0x434
  db 0x77, 0x30                ; 00000982  ja 0x9b4
  db 0xC4, 0x7F, 0x0A          ; 00000984  les di,[bx+0xa]
  db 0x26, 0x88, 0x45, 0x01    ; 00000987  mov [es:di+0x1],al
  db 0x8A, 0x07                ; 0000098B  mov al,[bx]
  db 0x26, 0x88, 0x05          ; 0000098D  mov [es:di],al
  db 0x26, 0xC6, 0x45, 0x02, 0xF3 ; 00000990  mov byte [es:di+0x2],0xf3
  db 0x2E, 0x8E, 0x06, 0x2F, 0x56 ; 00000995  mov es,[cs:0x562f]
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
  db 0xE8, 0xDB, 0x4C          ; 000009DB  call 0x56b9
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
  db 0xE8, 0xD4, 0x4C          ; 000009FC  call 0x56d3
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
  db 0xE8, 0xE7, 0x4C          ; 00000A5F  call 0x5749
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
  db 0xE8, 0xF0, 0x4B          ; 00000AC6  call 0x56b9
  db 0x72, 0x56                ; 00000AC9  jc 0xb21
  db 0x56                      ; 00000ACB  push si
  db 0x50                      ; 00000ACC  push ax
  db 0x8A, 0x07                ; 00000ACD  mov al,[bx]
  db 0xE8, 0x01, 0x4C          ; 00000ACF  call 0x56d3
  db 0x72, 0x33                ; 00000AD2  jc 0xb07
  db 0x9C                      ; 00000AD4  pushf
  db 0xFA                      ; 00000AD5  cli
  db 0x80, 0x7C, 0x02, 0x08    ; 00000AD6  cmp byte [si+0x2],0x8
  db 0x75, 0x2A                ; 00000ADA  jnz 0xb06
  db 0x8B, 0xFE                ; 00000ADC  mov di,si
  db 0x2E, 0x8E, 0x06, 0x2F, 0x56 ; 00000ADE  mov es,[cs:0x562f]
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
  db 0xB9, 0x64, 0x00          ; 00000B38  mov cx,0x64
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
  db 0xBE, 0x7C, 0x33          ; 00000B6B  mov si,0x337c
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
  db 0xE8, 0x8C, 0x45          ; 00000C54  call 0x51e3
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
  db 0xBE, 0x9C, 0x33          ; 00000C81  mov si,0x339c
  db 0x8A, 0x47, 0x02          ; 00000C84  mov al,[bx+0x2]
  db 0x88, 0x44, 0x04          ; 00000C87  mov [si+0x4],al
  db 0xE8, 0xED, 0x00          ; 00000C8A  call 0xd7a
  db 0x5E                      ; 00000C8D  pop si
  db 0xE8, 0x52, 0x45          ; 00000C8E  call 0x51e3
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
  db 0xBF, 0x9C, 0x33          ; 00000CCC  mov di,0x339c
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
  db 0x2E, 0xC7, 0x06, 0x86, 0x33, 0x05, 0x80 ; 00000CF6  mov word [cs:0x3386],0x8005
  db 0xB8, 0x00, 0x01          ; 00000CFD  mov ax,0x100
  db 0xE8, 0x05, 0x4B          ; 00000D00  call 0x5808
  db 0x8C, 0xD8                ; 00000D03  mov ax,ds
  db 0x05, 0x50, 0x00          ; 00000D05  add ax,0x50
  db 0x8E, 0xC0                ; 00000D08  mov es,ax
  db 0xBA, 0x16, 0x00          ; 00000D0A  mov dx,0x16
  db 0xE8, 0x1A, 0x4B          ; 00000D0D  call 0x582a
  db 0x5B                      ; 00000D10  pop bx
  db 0xC4, 0x37                ; 00000D11  les si,[bx]
  db 0x26, 0xC6, 0x04, 0x07    ; 00000D13  mov byte [es:si],0x7
  db 0x2E, 0xA1, 0x8A, 0x33    ; 00000D17  mov ax,[cs:0x338a]
  db 0x26, 0x89, 0x44, 0x01    ; 00000D1B  mov [es:si+0x1],ax
  db 0x8B, 0x47, 0x04          ; 00000D1F  mov ax,[bx+0x4]
  db 0xE8, 0xAC, 0x00          ; 00000D22  call 0xdd1
  db 0x2E, 0xC7, 0x06, 0x8A, 0x33, 0x94, 0x33 ; 00000D25  mov word [cs:0x338a],0x3394
  db 0x2E, 0xC7, 0x06, 0x84, 0x33, 0x00, 0x00 ; 00000D2C  mov word [cs:0x3384],0x0
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
  db 0xBF, 0x9C, 0x33          ; 00000D48  mov di,0x339c
  db 0xF3, 0xA4                ; 00000D4B  rep movsb
  db 0x59                      ; 00000D4D  pop cx
  db 0x1F                      ; 00000D4E  pop ds
  db 0x5F                      ; 00000D4F  pop di
  db 0xC3                      ; 00000D50  ret
  db 0x8B, 0xF3                ; 00000D51  mov si,bx
  db 0xE8, 0x16, 0x00          ; 00000D53  call 0xd6c
  db 0xBF, 0x9C, 0x33          ; 00000D56  mov di,0x339c
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
  db 0x2E, 0x8E, 0x06, 0x2F, 0x56 ; 00000D6C  mov es,[cs:0x562f]
  db 0xBF, 0x8C, 0x33          ; 00000D71  mov di,0x338c
  db 0xB9, 0x03, 0x00          ; 00000D74  mov cx,0x3
  db 0xF3, 0xA5                ; 00000D77  rep movsw
  db 0xC3                      ; 00000D79  ret
  db 0x86, 0xCD                ; 00000D7A  xchg cl,ch
  db 0x2E, 0x89, 0x0E, 0x92, 0x33 ; 00000D7C  mov [cs:0x3392],cx
  db 0x86, 0xCD                ; 00000D81  xchg cl,ch
  db 0x83, 0xF9, 0x2E          ; 00000D83  cmp cx,byte +0x2e
  db 0x73, 0x03                ; 00000D86  jnc 0xd8b
  db 0xB9, 0x2E, 0x00          ; 00000D88  mov cx,0x2e
  db 0x81, 0xC9, 0x00, 0x80    ; 00000D8B  or cx,0x8000
  db 0x2E, 0x89, 0x0E, 0x94, 0x33 ; 00000D8F  mov [cs:0x3394],cx
  db 0x2E, 0xC7, 0x06, 0x86, 0x33, 0x04, 0x80 ; 00000D94  mov word [cs:0x3386],0x8004
  db 0x2E, 0xC6, 0x06, 0x14, 0x0E, 0x02 ; 00000D9B  mov byte [cs:0xe14],0x2
  db 0xB8, 0x00, 0x01          ; 00000DA1  mov ax,0x100
  db 0xE8, 0x61, 0x4A          ; 00000DA4  call 0x5808
  db 0x8C, 0xD8                ; 00000DA7  mov ax,ds
  db 0x05, 0x50, 0x00          ; 00000DA9  add ax,0x50
  db 0x8E, 0xC0                ; 00000DAC  mov es,ax
  db 0xBA, 0x16, 0x00          ; 00000DAE  mov dx,0x16
  db 0xE8, 0x76, 0x4A          ; 00000DB1  call 0x582a
  db 0x2E, 0xFF, 0x06, 0x12, 0x0E ; 00000DB4  inc word [cs:0xe12]
  db 0x2E, 0xA1, 0x84, 0x33    ; 00000DB9  mov ax,[cs:0x3384]
  db 0x2E, 0xC7, 0x06, 0x84, 0x33, 0x00, 0x00 ; 00000DBD  mov word [cs:0x3384],0x0
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
  db 0x2E, 0xC6, 0x06, 0xA4, 0x53, 0xFF ; 00000E27  mov byte [cs:0x53a4],0xff
  db 0x2E, 0xC6, 0x06, 0xF8, 0x32, 0x00 ; 00000E2D  mov byte [cs:0x32f8],0x0
  db 0x2E, 0xC6, 0x06, 0x60, 0x33, 0x00 ; 00000E33  mov byte [cs:0x3360],0x0
  db 0x9D                      ; 00000E39  popf
  db 0x8C, 0xD8                ; 00000E3A  mov ax,ds
  db 0x05, 0x2A, 0x00          ; 00000E3C  add ax,0x2a
  db 0x8E, 0xC0                ; 00000E3F  mov es,ax
  db 0xBA, 0x17, 0x00          ; 00000E41  mov dx,0x17
  db 0xE8, 0xE3, 0x49          ; 00000E44  call 0x582a
  db 0x9C                      ; 00000E47  pushf
  db 0xFA                      ; 00000E48  cli
  db 0x2E, 0xC6, 0x06, 0xA4, 0x53, 0x00 ; 00000E49  mov byte [cs:0x53a4],0x0
  db 0x2E, 0xC6, 0x06, 0xF8, 0x32, 0xFF ; 00000E4F  mov byte [cs:0x32f8],0xff
  db 0x2E, 0xC6, 0x06, 0x60, 0x33, 0xFF ; 00000E55  mov byte [cs:0x3360],0xff
  db 0x2E, 0x80, 0x3E, 0xB8, 0x56, 0xFF ; 00000E5B  cmp byte [cs:0x56b8],0xff
  db 0x74, 0x04                ; 00000E61  jz 0xe67
  db 0x9D                      ; 00000E63  popf
  db 0xE9, 0x9C, 0x00          ; 00000E64  jmp 0xf03
  db 0x2E, 0xC6, 0x06, 0xB8, 0x56, 0x00 ; 00000E67  mov byte [cs:0x56b8],0x0
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
  db 0x2E, 0x80, 0x3E, 0xB8, 0x56, 0xFF ; 00000EAA  cmp byte [cs:0x56b8],0xff
  db 0x74, 0xB5                ; 00000EB0  jz 0xe67
  db 0x9D                      ; 00000EB2  popf
  db 0xB1, 0x8D                ; 00000EB3  mov cl,0x8d
  db 0xBA, 0x01, 0x00          ; 00000EB5  mov dx,0x1
  db 0xCD, 0xE0                ; 00000EB8  int 0xe0
  db 0xEB, 0xDC                ; 00000EBA  jmp short 0xe98
  db 0x2E, 0x8B, 0x36, 0x36, 0x15 ; 00000EBC  mov si,[cs:0x1536]
  db 0x2E, 0x8B, 0x3E, 0x3B, 0x15 ; 00000EC1  mov di,[cs:0x153b]
  db 0x89, 0x7C, 0x06          ; 00000EC6  mov [si+0x6],di
  db 0x2E, 0x89, 0x36, 0x7A, 0x33 ; 00000EC9  mov [cs:0x337a],si
  db 0x2E, 0xC6, 0x06, 0x35, 0x15, 0x00 ; 00000ECE  mov byte [cs:0x1535],0x0
  db 0x2E, 0xC7, 0x06, 0x36, 0x15, 0x00, 0x00 ; 00000ED4  mov word [cs:0x1536],0x0
  db 0x2E, 0xC7, 0x06, 0x38, 0x15, 0x00, 0x00 ; 00000EDB  mov word [cs:0x1538],0x0
  db 0x2E, 0xC6, 0x06, 0x3A, 0x15, 0x00 ; 00000EE2  mov byte [cs:0x153a],0x0
  db 0x2E, 0xC7, 0x06, 0x3B, 0x15, 0x00, 0x00 ; 00000EE8  mov word [cs:0x153b],0x0
  db 0x2E, 0xC7, 0x06, 0x3D, 0x15, 0x00, 0x00 ; 00000EEF  mov word [cs:0x153d],0x0
  db 0x2E, 0xC6, 0x06, 0x34, 0x15, 0x00 ; 00000EF6  mov byte [cs:0x1534],0x0
  db 0x9D                      ; 00000EFC  popf
  db 0xB8, 0x10, 0x00          ; 00000EFD  mov ax,0x10
  db 0xE8, 0x05, 0x49          ; 00000F00  call 0x5808
  db 0x32, 0xC0                ; 00000F03  xor al,al
  db 0x2E, 0x86, 0x06, 0xB7, 0x56 ; 00000F05  xchg al,[cs:0x56b7]
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
  db 0xBE, 0x91, 0x32          ; 00000F28  mov si,0x3291
  db 0xE8, 0x04, 0x01          ; 00000F2B  call 0x1032
  db 0x58                      ; 00000F2E  pop ax
  db 0xA8, 0x08                ; 00000F2F  test al,0x8
  db 0x74, 0x06                ; 00000F31  jz 0xf39
  db 0xBE, 0xF9, 0x32          ; 00000F33  mov si,0x32f9
  db 0xE8, 0xF9, 0x00          ; 00000F36  call 0x1032
  db 0xE9, 0xE9, 0xFE          ; 00000F39  jmp 0xe25
  db 0xE8, 0x51, 0x43          ; 00000F3C  call 0x5290
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
  db 0xE8, 0xE1, 0x47          ; 00000F65  call 0x5749
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
  db 0xE8, 0x90, 0x43          ; 00000F83  call 0x5316
  db 0xC6, 0x44, 0x02, 0x08    ; 00000F86  mov byte [si+0x2],0x8
  db 0xE8, 0x3B, 0x00          ; 00000F8A  call 0xfc8
  db 0xEB, 0x15                ; 00000F8D  jmp short 0xfa4
  db 0xFE, 0x4C, 0x10          ; 00000F8F  dec byte [si+0x10]
  db 0x74, 0x0A                ; 00000F92  jz 0xf9e
  db 0x2E, 0xFF, 0x06, 0x43, 0x15 ; 00000F94  inc word [cs:0x1543]
  db 0xE8, 0xC7, 0x47          ; 00000F99  call 0x5763
  db 0xEB, 0x06                ; 00000F9C  jmp short 0xfa4
  db 0xE8, 0x75, 0x43          ; 00000F9E  call 0x5316
  db 0xE8, 0x24, 0x00          ; 00000FA1  call 0xfc8
  db 0x5E                      ; 00000FA4  pop si
  db 0x59                      ; 00000FA5  pop cx
  db 0xE2, 0x9C                ; 00000FA6  loop 0xf44
  db 0xC3                      ; 00000FA8  ret
  db 0xE8, 0xC6, 0x43          ; 00000FA9  call 0x5372
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
  db 0xE8, 0x35, 0x42          ; 00000FFA  call 0x5232
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
  db 0xE8, 0xFE, 0x47          ; 0000101B  call 0x581c
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
  db 0xE8, 0xC2, 0x46          ; 00001038  call 0x56fd
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
  db 0xE8, 0x20, 0x46          ; 00001096  call 0x56b9
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
  db 0xEF                      ; 00001125  out dx,ax
  db 0x41                      ; 00001126  inc cx
  db 0x26, 0x8A, 0x45, 0x05    ; 00001127  mov al,[es:di+0x5]
  db 0x0A, 0xC0                ; 0000112B  or al,al
  db 0x75, 0x03                ; 0000112D  jnz 0x1132
  db 0xE9, 0x42, 0x00          ; 0000112F  jmp 0x1174
  db 0x3A, 0x44, 0x03          ; 00001132  cmp al,[si+0x3]
  db 0x73, 0x03                ; 00001135  jnc 0x113a
  db 0xE9, 0x3A, 0x00          ; 00001137  jmp 0x1174
  db 0x88, 0x44, 0x03          ; 0000113A  mov [si+0x3],al
  db 0xE8, 0x85, 0x41          ; 0000113D  call 0x52c5
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
  db 0xE8, 0xF4, 0x45          ; 0000116C  call 0x5763
  db 0xE8, 0x53, 0x41          ; 0000116F  call 0x52c5
  db 0xEB, 0x16                ; 00001172  jmp short 0x118a
  db 0x80, 0x7C, 0x02, 0x02    ; 00001174  cmp byte [si+0x2],0x2
  db 0x74, 0x06                ; 00001178  jz 0x1180
  db 0x80, 0x7C, 0x02, 0x0A    ; 0000117A  cmp byte [si+0x2],0xa
  db 0x75, 0x03                ; 0000117E  jnz 0x1183
  db 0xE8, 0xAF, 0x40          ; 00001180  call 0x5232
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
  db 0xE8, 0xBB, 0x45          ; 000011D1  call 0x578f
  db 0x56                      ; 000011D4  push si
  db 0x8B, 0x34                ; 000011D5  mov si,[si]
  db 0xE8, 0x0A, 0x03          ; 000011D7  call 0x14e4
  db 0x5E                      ; 000011DA  pop si
  db 0xE8, 0xE7, 0x40          ; 000011DB  call 0x52c5
  db 0xEB, 0x13                ; 000011DE  jmp short 0x11f3
  db 0x26, 0x8A, 0x65, 0x04    ; 000011E0  mov ah,[es:di+0x4]
  db 0xE8, 0xA8, 0x45          ; 000011E4  call 0x578f
  db 0xEB, 0x06                ; 000011E7  jmp short 0x11ef
  db 0xE8, 0x2A, 0x41          ; 000011E9  call 0x5316
  db 0xE8, 0xD9, 0xFD          ; 000011EC  call 0xfc8
  db 0x5B                      ; 000011EF  pop bx
  db 0xE8, 0x32, 0x02          ; 000011F0  call 0x1425
  db 0xC3                      ; 000011F3  ret
  db 0x26, 0x8A, 0x45, 0x05    ; 000011F4  mov al,[es:di+0x5]
  db 0xE8, 0xD8, 0x44          ; 000011F8  call 0x56d3
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
  db 0xE8, 0x12, 0x40          ; 0000121D  call 0x5232
  db 0x56                      ; 00001220  push si
  db 0x2E, 0x8E, 0x06, 0x2F, 0x56 ; 00001221  mov es,[cs:0x562f]
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
  db 0xE8, 0x04, 0x45          ; 00001242  call 0x5749
  db 0xEB, 0x0A                ; 00001245  jmp short 0x1251
  db 0xE8, 0x0C, 0x00          ; 00001247  call 0x1256
  db 0xE8, 0xE5, 0x3F          ; 0000124A  call 0x5232
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
  db 0xE8, 0x4C, 0x44          ; 00001284  call 0x56d3
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
  db 0xE8, 0xE7, 0x44          ; 000012B9  call 0x57a3
  db 0x56                      ; 000012BC  push si
  db 0x8B, 0x34                ; 000012BD  mov si,[si]
  db 0xE8, 0x22, 0x02          ; 000012BF  call 0x14e4
  db 0x5E                      ; 000012C2  pop si
  db 0xEB, 0x09                ; 000012C3  jmp short 0x12ce
  db 0x5B                      ; 000012C5  pop bx
  db 0x53                      ; 000012C6  push bx
  db 0xE8, 0xD9, 0x44          ; 000012C7  call 0x57a3
  db 0x5B                      ; 000012CA  pop bx
  db 0xE8, 0x57, 0x01          ; 000012CB  call 0x1425
  db 0xC3                      ; 000012CE  ret
  db 0x26, 0x8A, 0x45, 0x05    ; 000012CF  mov al,[es:di+0x5]
  db 0xE8, 0xFD, 0x43          ; 000012D3  call 0x56d3
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
  db 0xE8, 0x2D, 0x3F          ; 00001302  call 0x5232
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
  db 0x2E, 0x3A, 0x26, 0x91, 0x32 ; 00001337  cmp ah,[cs:0x3291]
  db 0x74, 0x0D                ; 0000133C  jz 0x134b
  db 0x2E, 0x3A, 0x26, 0xF9, 0x32 ; 0000133E  cmp ah,[cs:0x32f9]
  db 0x74, 0x06                ; 00001343  jz 0x134b
  db 0xE8, 0xDD, 0x00          ; 00001345  call 0x1425
  db 0xE9, 0x8A, 0x00          ; 00001348  jmp 0x13d5
  db 0x80, 0xCC, 0x01          ; 0000134B  or ah,0x1
  db 0x26, 0x8A, 0x45, 0x01    ; 0000134E  mov al,[es:di+0x1]
  db 0x26, 0x88, 0x05          ; 00001352  mov [es:di],al
  db 0x26, 0x88, 0x65, 0x01    ; 00001355  mov [es:di+0x1],ah
  db 0x06                      ; 00001359  push es
  db 0x57                      ; 0000135A  push di
  db 0x2E, 0x8E, 0x06, 0x2F, 0x56 ; 0000135B  mov es,[cs:0x562f]
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
  db 0xE8, 0xFF, 0x42          ; 000013B7  call 0x56b9
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
  db 0x2E, 0x3A, 0x06, 0x91, 0x32 ; 000013E5  cmp al,[cs:0x3291]
  db 0x74, 0x09                ; 000013EA  jz 0x13f5
  db 0x2E, 0x3A, 0x06, 0xF9, 0x32 ; 000013EC  cmp al,[cs:0x32f9]
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
  db 0x2E, 0x8E, 0x06, 0x2F, 0x56 ; 0000142F  mov es,[cs:0x562f]
  db 0x56                      ; 00001434  push si
  db 0x8B, 0xFB                ; 00001435  mov di,bx
  db 0x83, 0xC7, 0x0E          ; 00001437  add di,byte +0xe
  db 0xBE, 0x45, 0x15          ; 0000143A  mov si,0x1545
  db 0xB9, 0x64, 0x00          ; 0000143D  mov cx,0x64
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
  db 0xB9, 0x64, 0x00          ; 0000149C  mov cx,0x64
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
  db 0xD0                      ; 00001536  db 0xd0
  db 0x37                      ; 00001537  aaa
  db 0x3E, 0x38, 0x06, 0x54, 0x38 ; 00001538  cmp [ds:0x3854],al
  db 0x86, 0x38                ; 0000153D  xchg bh,[bx+si]
  db 0x00, 0x00                ; 0000153F  add [bx+si],al
  db 0x00, 0x00                ; 00001541  add [bx+si],al
  db 0x00, 0x00                ; 00001543  add [bx+si],al
  db 0x00, 0x00                ; 00001545  add [bx+si],al
  db 0x00, 0x00                ; 00001547  add [bx+si],al
  db 0x00, 0x00                ; 00001549  add [bx+si],al
  db 0x00, 0x00                ; 0000154B  add [bx+si],al
  db 0x00, 0x00                ; 0000154D  add [bx+si],al
  db 0x00, 0x00                ; 0000154F  add [bx+si],al
  db 0x00, 0x00                ; 00001551  add [bx+si],al
  db 0x00, 0x00                ; 00001553  add [bx+si],al
  db 0x00, 0x00                ; 00001555  add [bx+si],al
  db 0x00, 0x00                ; 00001557  add [bx+si],al
  db 0x00, 0x00                ; 00001559  add [bx+si],al
  db 0x00, 0x00                ; 0000155B  add [bx+si],al
  db 0x00, 0x00                ; 0000155D  add [bx+si],al
  db 0x00, 0x00                ; 0000155F  add [bx+si],al
  db 0x00, 0x00                ; 00001561  add [bx+si],al
  db 0x00, 0x00                ; 00001563  add [bx+si],al
  db 0x00, 0x00                ; 00001565  add [bx+si],al
  db 0x00, 0x00                ; 00001567  add [bx+si],al
  db 0x00, 0x00                ; 00001569  add [bx+si],al
  db 0x00, 0x00                ; 0000156B  add [bx+si],al
  db 0x00, 0x00                ; 0000156D  add [bx+si],al
  db 0x00, 0x00                ; 0000156F  add [bx+si],al
  db 0x00, 0x00                ; 00001571  add [bx+si],al
  db 0x00, 0x00                ; 00001573  add [bx+si],al
  db 0x00, 0x00                ; 00001575  add [bx+si],al
  db 0x00, 0x00                ; 00001577  add [bx+si],al
  db 0x00, 0x00                ; 00001579  add [bx+si],al
  db 0x00, 0x00                ; 0000157B  add [bx+si],al
  db 0x00, 0x00                ; 0000157D  add [bx+si],al
  db 0x00, 0x00                ; 0000157F  add [bx+si],al
  db 0x00, 0x00                ; 00001581  add [bx+si],al
  db 0x00, 0x00                ; 00001583  add [bx+si],al
  db 0x00, 0x00                ; 00001585  add [bx+si],al
  db 0x00, 0x00                ; 00001587  add [bx+si],al
  db 0x00, 0x00                ; 00001589  add [bx+si],al
  db 0x00, 0x00                ; 0000158B  add [bx+si],al
  db 0x00, 0x00                ; 0000158D  add [bx+si],al
  db 0x00, 0x00                ; 0000158F  add [bx+si],al
  db 0x00, 0x00                ; 00001591  add [bx+si],al
  db 0x00, 0x00                ; 00001593  add [bx+si],al
  db 0x00, 0x00                ; 00001595  add [bx+si],al
  db 0x00, 0x00                ; 00001597  add [bx+si],al
  db 0x00, 0x00                ; 00001599  add [bx+si],al
  db 0x00, 0x00                ; 0000159B  add [bx+si],al
  db 0x00, 0x00                ; 0000159D  add [bx+si],al
  db 0x00, 0x00                ; 0000159F  add [bx+si],al
  db 0x00, 0x00                ; 000015A1  add [bx+si],al
  db 0x00, 0x00                ; 000015A3  add [bx+si],al
  db 0x00, 0x00                ; 000015A5  add [bx+si],al
  db 0x00, 0x00                ; 000015A7  add [bx+si],al
  db 0x00, 0x00                ; 000015A9  add [bx+si],al
  db 0x00, 0x00                ; 000015AB  add [bx+si],al
  db 0x00, 0x00                ; 000015AD  add [bx+si],al
  db 0x00, 0x00                ; 000015AF  add [bx+si],al
  db 0x00, 0x00                ; 000015B1  add [bx+si],al
  db 0x00, 0x00                ; 000015B3  add [bx+si],al
  db 0x00, 0x00                ; 000015B5  add [bx+si],al
  db 0x00, 0x00                ; 000015B7  add [bx+si],al
  db 0x00, 0x00                ; 000015B9  add [bx+si],al
  db 0x00, 0x00                ; 000015BB  add [bx+si],al
  db 0x00, 0x00                ; 000015BD  add [bx+si],al
  db 0x00, 0x00                ; 000015BF  add [bx+si],al
  db 0x00, 0x00                ; 000015C1  add [bx+si],al
  db 0x00, 0x00                ; 000015C3  add [bx+si],al
  db 0x00, 0x00                ; 000015C5  add [bx+si],al
  db 0x00, 0x00                ; 000015C7  add [bx+si],al
  db 0x00, 0x00                ; 000015C9  add [bx+si],al
  db 0x00, 0x00                ; 000015CB  add [bx+si],al
  db 0x00, 0x00                ; 000015CD  add [bx+si],al
  db 0x00, 0x00                ; 000015CF  add [bx+si],al
  db 0x00, 0x00                ; 000015D1  add [bx+si],al
  db 0x00, 0x00                ; 000015D3  add [bx+si],al
  db 0x00, 0x00                ; 000015D5  add [bx+si],al
  db 0x00, 0x00                ; 000015D7  add [bx+si],al
  db 0x00, 0x00                ; 000015D9  add [bx+si],al
  db 0x00, 0x00                ; 000015DB  add [bx+si],al
  db 0x00, 0x00                ; 000015DD  add [bx+si],al
  db 0x00, 0x00                ; 000015DF  add [bx+si],al
  db 0x00, 0x00                ; 000015E1  add [bx+si],al
  db 0x00, 0x00                ; 000015E3  add [bx+si],al
  db 0x00, 0x00                ; 000015E5  add [bx+si],al
  db 0x00, 0x00                ; 000015E7  add [bx+si],al
  db 0x00, 0x00                ; 000015E9  add [bx+si],al
  db 0x00, 0x00                ; 000015EB  add [bx+si],al
  db 0x00, 0x00                ; 000015ED  add [bx+si],al
  db 0x00, 0x00                ; 000015EF  add [bx+si],al
  db 0x00, 0x00                ; 000015F1  add [bx+si],al
  db 0x00, 0x00                ; 000015F3  add [bx+si],al
  db 0x00, 0x00                ; 000015F5  add [bx+si],al
  db 0x00, 0x00                ; 000015F7  add [bx+si],al
  db 0x00, 0x00                ; 000015F9  add [bx+si],al
  db 0x00, 0x00                ; 000015FB  add [bx+si],al
  db 0x00, 0x00                ; 000015FD  add [bx+si],al
  db 0x00, 0x00                ; 000015FF  add [bx+si],al
  db 0x00, 0x00                ; 00001601  add [bx+si],al
  db 0x00, 0x00                ; 00001603  add [bx+si],al
  db 0x00, 0x00                ; 00001605  add [bx+si],al
  db 0x00, 0x00                ; 00001607  add [bx+si],al
  db 0x00, 0x00                ; 00001609  add [bx+si],al
  db 0x00, 0x00                ; 0000160B  add [bx+si],al
  db 0x00, 0x00                ; 0000160D  add [bx+si],al
  db 0x00, 0x00                ; 0000160F  add [bx+si],al
  db 0x00, 0x00                ; 00001611  add [bx+si],al
  db 0x00, 0x00                ; 00001613  add [bx+si],al
  db 0x00, 0x00                ; 00001615  add [bx+si],al
  db 0x00, 0x00                ; 00001617  add [bx+si],al
  db 0x00, 0x00                ; 00001619  add [bx+si],al
  db 0x00, 0x00                ; 0000161B  add [bx+si],al
  db 0x00, 0x00                ; 0000161D  add [bx+si],al
  db 0x00, 0x00                ; 0000161F  add [bx+si],al
  db 0x00, 0x00                ; 00001621  add [bx+si],al
  db 0x00, 0x00                ; 00001623  add [bx+si],al
  db 0x00, 0x00                ; 00001625  add [bx+si],al
  db 0x00, 0x00                ; 00001627  add [bx+si],al
  db 0x00, 0x00                ; 00001629  add [bx+si],al
  db 0x00, 0x00                ; 0000162B  add [bx+si],al
  db 0x00, 0x00                ; 0000162D  add [bx+si],al
  db 0x00, 0x00                ; 0000162F  add [bx+si],al
  db 0x00, 0x00                ; 00001631  add [bx+si],al
  db 0x00, 0x00                ; 00001633  add [bx+si],al
  db 0x00, 0x00                ; 00001635  add [bx+si],al
  db 0x00, 0x00                ; 00001637  add [bx+si],al
  db 0x00, 0x00                ; 00001639  add [bx+si],al
  db 0x00, 0x00                ; 0000163B  add [bx+si],al
  db 0x00, 0x00                ; 0000163D  add [bx+si],al
  db 0x00, 0x00                ; 0000163F  add [bx+si],al
  db 0x00, 0x00                ; 00001641  add [bx+si],al
  db 0x00, 0x00                ; 00001643  add [bx+si],al
  db 0x00, 0x00                ; 00001645  add [bx+si],al
  db 0x00, 0x00                ; 00001647  add [bx+si],al
  db 0x00, 0x00                ; 00001649  add [bx+si],al
  db 0x00, 0x00                ; 0000164B  add [bx+si],al
  db 0x00, 0x00                ; 0000164D  add [bx+si],al
  db 0x00, 0x00                ; 0000164F  add [bx+si],al
  db 0x00, 0x00                ; 00001651  add [bx+si],al
  db 0x00, 0x00                ; 00001653  add [bx+si],al
  db 0x00, 0x00                ; 00001655  add [bx+si],al
  db 0x00, 0x00                ; 00001657  add [bx+si],al
  db 0x00, 0x00                ; 00001659  add [bx+si],al
  db 0x00, 0x00                ; 0000165B  add [bx+si],al
  db 0x00, 0x00                ; 0000165D  add [bx+si],al
  db 0x00, 0x00                ; 0000165F  add [bx+si],al
  db 0x00, 0x00                ; 00001661  add [bx+si],al
  db 0x00, 0x00                ; 00001663  add [bx+si],al
  db 0x00, 0x00                ; 00001665  add [bx+si],al
  db 0x00, 0x00                ; 00001667  add [bx+si],al
  db 0x00, 0x00                ; 00001669  add [bx+si],al
  db 0x00, 0x00                ; 0000166B  add [bx+si],al
  db 0x00, 0x00                ; 0000166D  add [bx+si],al
  db 0x00, 0x00                ; 0000166F  add [bx+si],al
  db 0x00, 0x00                ; 00001671  add [bx+si],al
  db 0x00, 0x00                ; 00001673  add [bx+si],al
  db 0x00, 0x00                ; 00001675  add [bx+si],al
  db 0x00, 0x00                ; 00001677  add [bx+si],al
  db 0x00, 0x00                ; 00001679  add [bx+si],al
  db 0x00, 0x00                ; 0000167B  add [bx+si],al
  db 0x00, 0x00                ; 0000167D  add [bx+si],al
  db 0x00, 0x00                ; 0000167F  add [bx+si],al
  db 0x00, 0x00                ; 00001681  add [bx+si],al
  db 0x00, 0x00                ; 00001683  add [bx+si],al
  db 0x00, 0x00                ; 00001685  add [bx+si],al
  db 0x00, 0x00                ; 00001687  add [bx+si],al
  db 0x00, 0x00                ; 00001689  add [bx+si],al
  db 0x00, 0x00                ; 0000168B  add [bx+si],al
  db 0x00, 0x00                ; 0000168D  add [bx+si],al
  db 0x00, 0x00                ; 0000168F  add [bx+si],al
  db 0x00, 0x00                ; 00001691  add [bx+si],al
  db 0x00, 0x00                ; 00001693  add [bx+si],al
  db 0x00, 0x00                ; 00001695  add [bx+si],al
  db 0x00, 0x00                ; 00001697  add [bx+si],al
  db 0x00, 0x00                ; 00001699  add [bx+si],al
  db 0x00, 0x00                ; 0000169B  add [bx+si],al
  db 0x00, 0x00                ; 0000169D  add [bx+si],al
  db 0x00, 0x00                ; 0000169F  add [bx+si],al
  db 0x00, 0x00                ; 000016A1  add [bx+si],al
  db 0x00, 0x00                ; 000016A3  add [bx+si],al
  db 0x00, 0x00                ; 000016A5  add [bx+si],al
  db 0x00, 0x00                ; 000016A7  add [bx+si],al
  db 0x00, 0x00                ; 000016A9  add [bx+si],al
  db 0x00, 0x00                ; 000016AB  add [bx+si],al
  db 0x00, 0x00                ; 000016AD  add [bx+si],al
  db 0x00, 0x00                ; 000016AF  add [bx+si],al
  db 0x00, 0x00                ; 000016B1  add [bx+si],al
  db 0x00, 0x00                ; 000016B3  add [bx+si],al
  db 0x00, 0x00                ; 000016B5  add [bx+si],al
  db 0x00, 0x00                ; 000016B7  add [bx+si],al
  db 0x00, 0x00                ; 000016B9  add [bx+si],al
  db 0x00, 0x00                ; 000016BB  add [bx+si],al
  db 0x00, 0x00                ; 000016BD  add [bx+si],al
  db 0x00, 0x00                ; 000016BF  add [bx+si],al
  db 0x00, 0x00                ; 000016C1  add [bx+si],al
  db 0x00, 0x00                ; 000016C3  add [bx+si],al
  db 0x00, 0x00                ; 000016C5  add [bx+si],al
  db 0x00, 0x00                ; 000016C7  add [bx+si],al
  db 0x00, 0x00                ; 000016C9  add [bx+si],al
  db 0x00, 0x00                ; 000016CB  add [bx+si],al
  db 0x00, 0x00                ; 000016CD  add [bx+si],al
  db 0x00, 0x00                ; 000016CF  add [bx+si],al
  db 0x00, 0x00                ; 000016D1  add [bx+si],al
  db 0x00, 0x00                ; 000016D3  add [bx+si],al
  db 0x00, 0x00                ; 000016D5  add [bx+si],al
  db 0x00, 0x00                ; 000016D7  add [bx+si],al
  db 0x00, 0x00                ; 000016D9  add [bx+si],al
  db 0x00, 0x00                ; 000016DB  add [bx+si],al
  db 0x00, 0x00                ; 000016DD  add [bx+si],al
  db 0x00, 0x00                ; 000016DF  add [bx+si],al
  db 0x00, 0x00                ; 000016E1  add [bx+si],al
  db 0x00, 0x00                ; 000016E3  add [bx+si],al
  db 0x00, 0x00                ; 000016E5  add [bx+si],al
  db 0x00, 0x00                ; 000016E7  add [bx+si],al
  db 0x00, 0x00                ; 000016E9  add [bx+si],al
  db 0x00, 0x00                ; 000016EB  add [bx+si],al
  db 0x00, 0x00                ; 000016ED  add [bx+si],al
  db 0x00, 0x00                ; 000016EF  add [bx+si],al
  db 0x00, 0x00                ; 000016F1  add [bx+si],al
  db 0x00, 0x00                ; 000016F3  add [bx+si],al
  db 0x00, 0x00                ; 000016F5  add [bx+si],al
  db 0x00, 0x00                ; 000016F7  add [bx+si],al
  db 0x00, 0x00                ; 000016F9  add [bx+si],al
  db 0x00, 0x00                ; 000016FB  add [bx+si],al
  db 0x00, 0x00                ; 000016FD  add [bx+si],al
  db 0x00, 0x00                ; 000016FF  add [bx+si],al
  db 0x00, 0x00                ; 00001701  add [bx+si],al
  db 0x00, 0x00                ; 00001703  add [bx+si],al
  db 0x00, 0x00                ; 00001705  add [bx+si],al
  db 0x00, 0x00                ; 00001707  add [bx+si],al
  db 0x00, 0x00                ; 00001709  add [bx+si],al
  db 0x00, 0x00                ; 0000170B  add [bx+si],al
  db 0x00, 0x00                ; 0000170D  add [bx+si],al
  db 0x00, 0x00                ; 0000170F  add [bx+si],al
  db 0x00, 0x00                ; 00001711  add [bx+si],al
  db 0x00, 0x00                ; 00001713  add [bx+si],al
  db 0x00, 0x00                ; 00001715  add [bx+si],al
  db 0x00, 0x00                ; 00001717  add [bx+si],al
  db 0x00, 0x00                ; 00001719  add [bx+si],al
  db 0x00, 0x00                ; 0000171B  add [bx+si],al
  db 0x00, 0x00                ; 0000171D  add [bx+si],al
  db 0x00, 0x00                ; 0000171F  add [bx+si],al
  db 0x00, 0x00                ; 00001721  add [bx+si],al
  db 0x00, 0x00                ; 00001723  add [bx+si],al
  db 0x00, 0x00                ; 00001725  add [bx+si],al
  db 0x00, 0x00                ; 00001727  add [bx+si],al
  db 0x00, 0x00                ; 00001729  add [bx+si],al
  db 0x00, 0x00                ; 0000172B  add [bx+si],al
  db 0x00, 0x00                ; 0000172D  add [bx+si],al
  db 0x00, 0x00                ; 0000172F  add [bx+si],al
  db 0x00, 0x00                ; 00001731  add [bx+si],al
  db 0x00, 0x00                ; 00001733  add [bx+si],al
  db 0x00, 0x00                ; 00001735  add [bx+si],al
  db 0x00, 0x00                ; 00001737  add [bx+si],al
  db 0x00, 0x00                ; 00001739  add [bx+si],al
  db 0x00, 0x00                ; 0000173B  add [bx+si],al
  db 0x00, 0x00                ; 0000173D  add [bx+si],al
  db 0x00, 0x00                ; 0000173F  add [bx+si],al
  db 0x00, 0x00                ; 00001741  add [bx+si],al
  db 0x00, 0x00                ; 00001743  add [bx+si],al
  db 0x00, 0x00                ; 00001745  add [bx+si],al
  db 0x00, 0x00                ; 00001747  add [bx+si],al
  db 0x00, 0x00                ; 00001749  add [bx+si],al
  db 0x00, 0x00                ; 0000174B  add [bx+si],al
  db 0x00, 0x00                ; 0000174D  add [bx+si],al
  db 0x00, 0x00                ; 0000174F  add [bx+si],al
  db 0x00, 0x00                ; 00001751  add [bx+si],al
  db 0x00, 0x00                ; 00001753  add [bx+si],al
  db 0x00, 0x00                ; 00001755  add [bx+si],al
  db 0x00, 0x00                ; 00001757  add [bx+si],al
  db 0x00, 0x00                ; 00001759  add [bx+si],al
  db 0x00, 0x00                ; 0000175B  add [bx+si],al
  db 0x00, 0x00                ; 0000175D  add [bx+si],al
  db 0x00, 0x00                ; 0000175F  add [bx+si],al
  db 0x00, 0x00                ; 00001761  add [bx+si],al
  db 0x00, 0x00                ; 00001763  add [bx+si],al
  db 0x00, 0x00                ; 00001765  add [bx+si],al
  db 0x00, 0x00                ; 00001767  add [bx+si],al
  db 0x00, 0x00                ; 00001769  add [bx+si],al
  db 0x00, 0x00                ; 0000176B  add [bx+si],al
  db 0x00, 0x00                ; 0000176D  add [bx+si],al
  db 0x00, 0x00                ; 0000176F  add [bx+si],al
  db 0x00, 0x00                ; 00001771  add [bx+si],al
  db 0x00, 0x00                ; 00001773  add [bx+si],al
  db 0x00, 0x00                ; 00001775  add [bx+si],al
  db 0x00, 0x00                ; 00001777  add [bx+si],al
  db 0x00, 0x00                ; 00001779  add [bx+si],al
  db 0x00, 0x00                ; 0000177B  add [bx+si],al
  db 0x00, 0x00                ; 0000177D  add [bx+si],al
  db 0x00, 0x00                ; 0000177F  add [bx+si],al
  db 0x00, 0x00                ; 00001781  add [bx+si],al
  db 0x00, 0x00                ; 00001783  add [bx+si],al
  db 0x00, 0x00                ; 00001785  add [bx+si],al
  db 0x00, 0x00                ; 00001787  add [bx+si],al
  db 0x00, 0x00                ; 00001789  add [bx+si],al
  db 0x00, 0x00                ; 0000178B  add [bx+si],al
  db 0x00, 0x00                ; 0000178D  add [bx+si],al
  db 0x00, 0x00                ; 0000178F  add [bx+si],al
  db 0x00, 0x00                ; 00001791  add [bx+si],al
  db 0x00, 0x00                ; 00001793  add [bx+si],al
  db 0x00, 0x00                ; 00001795  add [bx+si],al
  db 0x00, 0x00                ; 00001797  add [bx+si],al
  db 0x00, 0x00                ; 00001799  add [bx+si],al
  db 0x00, 0x00                ; 0000179B  add [bx+si],al
  db 0x00, 0x00                ; 0000179D  add [bx+si],al
  db 0x00, 0x00                ; 0000179F  add [bx+si],al
  db 0x00, 0x00                ; 000017A1  add [bx+si],al
  db 0x00, 0x00                ; 000017A3  add [bx+si],al
  db 0x00, 0x00                ; 000017A5  add [bx+si],al
  db 0x00, 0x00                ; 000017A7  add [bx+si],al
  db 0x00, 0x00                ; 000017A9  add [bx+si],al
  db 0x00, 0x00                ; 000017AB  add [bx+si],al
  db 0x00, 0x00                ; 000017AD  add [bx+si],al
  db 0x00, 0x00                ; 000017AF  add [bx+si],al
  db 0x00, 0x00                ; 000017B1  add [bx+si],al
  db 0x00, 0x00                ; 000017B3  add [bx+si],al
  db 0x00, 0x00                ; 000017B5  add [bx+si],al
  db 0x00, 0x00                ; 000017B7  add [bx+si],al
  db 0x00, 0x00                ; 000017B9  add [bx+si],al
  db 0x00, 0x00                ; 000017BB  add [bx+si],al
  db 0x00, 0x00                ; 000017BD  add [bx+si],al
  db 0x00, 0x00                ; 000017BF  add [bx+si],al
  db 0x00, 0x00                ; 000017C1  add [bx+si],al
  db 0x00, 0x00                ; 000017C3  add [bx+si],al
  db 0x00, 0x00                ; 000017C5  add [bx+si],al
  db 0x00, 0x00                ; 000017C7  add [bx+si],al
  db 0x00, 0x00                ; 000017C9  add [bx+si],al
  db 0x00, 0x00                ; 000017CB  add [bx+si],al
  db 0x00, 0x00                ; 000017CD  add [bx+si],al
  db 0x00, 0x00                ; 000017CF  add [bx+si],al
  db 0x00, 0x00                ; 000017D1  add [bx+si],al
  db 0x00, 0x00                ; 000017D3  add [bx+si],al
  db 0x00, 0x00                ; 000017D5  add [bx+si],al
  db 0x00, 0x00                ; 000017D7  add [bx+si],al
  db 0x00, 0x00                ; 000017D9  add [bx+si],al
  db 0x00, 0x00                ; 000017DB  add [bx+si],al
  db 0x00, 0x00                ; 000017DD  add [bx+si],al
  db 0x00, 0x00                ; 000017DF  add [bx+si],al
  db 0x00, 0x00                ; 000017E1  add [bx+si],al
  db 0x00, 0x00                ; 000017E3  add [bx+si],al
  db 0x00, 0x00                ; 000017E5  add [bx+si],al
  db 0x00, 0x00                ; 000017E7  add [bx+si],al
  db 0x00, 0x00                ; 000017E9  add [bx+si],al
  db 0x00, 0x00                ; 000017EB  add [bx+si],al
  db 0x00, 0x00                ; 000017ED  add [bx+si],al
  db 0x00, 0x00                ; 000017EF  add [bx+si],al
  db 0x00, 0x00                ; 000017F1  add [bx+si],al
  db 0x00, 0x00                ; 000017F3  add [bx+si],al
  db 0x00, 0x00                ; 000017F5  add [bx+si],al
  db 0x00, 0x00                ; 000017F7  add [bx+si],al
  db 0x00, 0x00                ; 000017F9  add [bx+si],al
  db 0x00, 0x00                ; 000017FB  add [bx+si],al
  db 0x00, 0x00                ; 000017FD  add [bx+si],al
  db 0x00, 0x00                ; 000017FF  add [bx+si],al
  db 0x00, 0x00                ; 00001801  add [bx+si],al
  db 0x00, 0x00                ; 00001803  add [bx+si],al
  db 0x00, 0x00                ; 00001805  add [bx+si],al
  db 0x00, 0x00                ; 00001807  add [bx+si],al
  db 0x00, 0x00                ; 00001809  add [bx+si],al
  db 0x00, 0x00                ; 0000180B  add [bx+si],al
  db 0x00, 0x00                ; 0000180D  add [bx+si],al
  db 0x00, 0x00                ; 0000180F  add [bx+si],al
  db 0x00, 0x00                ; 00001811  add [bx+si],al
  db 0x00, 0x00                ; 00001813  add [bx+si],al
  db 0x00, 0x00                ; 00001815  add [bx+si],al
  db 0x00, 0x00                ; 00001817  add [bx+si],al
  db 0x00, 0x00                ; 00001819  add [bx+si],al
  db 0x00, 0x00                ; 0000181B  add [bx+si],al
  db 0x00, 0x00                ; 0000181D  add [bx+si],al
  db 0x00, 0x00                ; 0000181F  add [bx+si],al
  db 0x00, 0x00                ; 00001821  add [bx+si],al
  db 0x00, 0x00                ; 00001823  add [bx+si],al
  db 0x00, 0x00                ; 00001825  add [bx+si],al
  db 0x00, 0x00                ; 00001827  add [bx+si],al
  db 0x00, 0x00                ; 00001829  add [bx+si],al
  db 0x00, 0x00                ; 0000182B  add [bx+si],al
  db 0x00, 0x00                ; 0000182D  add [bx+si],al
  db 0x00, 0x00                ; 0000182F  add [bx+si],al
  db 0x00, 0x00                ; 00001831  add [bx+si],al
  db 0x00, 0x00                ; 00001833  add [bx+si],al
  db 0x00, 0x00                ; 00001835  add [bx+si],al
  db 0x00, 0x00                ; 00001837  add [bx+si],al
  db 0x00, 0x00                ; 00001839  add [bx+si],al
  db 0x00, 0x00                ; 0000183B  add [bx+si],al
  db 0x00, 0x00                ; 0000183D  add [bx+si],al
  db 0x00, 0x00                ; 0000183F  add [bx+si],al
  db 0x00, 0x00                ; 00001841  add [bx+si],al
  db 0x00, 0x00                ; 00001843  add [bx+si],al
  db 0x00, 0x00                ; 00001845  add [bx+si],al
  db 0x00, 0x00                ; 00001847  add [bx+si],al
  db 0x00, 0x00                ; 00001849  add [bx+si],al
  db 0x00, 0x00                ; 0000184B  add [bx+si],al
  db 0x00, 0x00                ; 0000184D  add [bx+si],al
  db 0x00, 0x00                ; 0000184F  add [bx+si],al
  db 0x00, 0x00                ; 00001851  add [bx+si],al
  db 0x00, 0x00                ; 00001853  add [bx+si],al
  db 0x00, 0x00                ; 00001855  add [bx+si],al
  db 0x00, 0x00                ; 00001857  add [bx+si],al
  db 0x00, 0x00                ; 00001859  add [bx+si],al
  db 0x00, 0x00                ; 0000185B  add [bx+si],al
  db 0x00, 0x00                ; 0000185D  add [bx+si],al
  db 0x00, 0x00                ; 0000185F  add [bx+si],al
  db 0x00, 0x00                ; 00001861  add [bx+si],al
  db 0x00, 0x00                ; 00001863  add [bx+si],al
  db 0x00, 0x00                ; 00001865  add [bx+si],al
  db 0x00, 0x00                ; 00001867  add [bx+si],al
  db 0x00, 0x00                ; 00001869  add [bx+si],al
  db 0x00, 0x00                ; 0000186B  add [bx+si],al
  db 0x00, 0x00                ; 0000186D  add [bx+si],al
  db 0x00, 0x00                ; 0000186F  add [bx+si],al
  db 0x00, 0x00                ; 00001871  add [bx+si],al
  db 0x00, 0x00                ; 00001873  add [bx+si],al
  db 0x00, 0x00                ; 00001875  add [bx+si],al
  db 0x00, 0x00                ; 00001877  add [bx+si],al
  db 0x00, 0x00                ; 00001879  add [bx+si],al
  db 0x00, 0x00                ; 0000187B  add [bx+si],al
  db 0x00, 0x00                ; 0000187D  add [bx+si],al
  db 0x00, 0x00                ; 0000187F  add [bx+si],al
  db 0x00, 0x00                ; 00001881  add [bx+si],al
  db 0x00, 0x00                ; 00001883  add [bx+si],al
  db 0x00, 0x00                ; 00001885  add [bx+si],al
  db 0x00, 0x00                ; 00001887  add [bx+si],al
  db 0x00, 0x00                ; 00001889  add [bx+si],al
  db 0x00, 0x00                ; 0000188B  add [bx+si],al
  db 0x00, 0x00                ; 0000188D  add [bx+si],al
  db 0x00, 0x00                ; 0000188F  add [bx+si],al
  db 0x00, 0x00                ; 00001891  add [bx+si],al
  db 0x00, 0x00                ; 00001893  add [bx+si],al
  db 0x00, 0x00                ; 00001895  add [bx+si],al
  db 0x00, 0x00                ; 00001897  add [bx+si],al
  db 0x00, 0x00                ; 00001899  add [bx+si],al
  db 0x00, 0x00                ; 0000189B  add [bx+si],al
  db 0x00, 0x00                ; 0000189D  add [bx+si],al
  db 0x00, 0x00                ; 0000189F  add [bx+si],al
  db 0x00, 0x00                ; 000018A1  add [bx+si],al
  db 0x00, 0x00                ; 000018A3  add [bx+si],al
  db 0x00, 0x00                ; 000018A5  add [bx+si],al
  db 0x00, 0x00                ; 000018A7  add [bx+si],al
  db 0x00, 0x00                ; 000018A9  add [bx+si],al
  db 0x00, 0x00                ; 000018AB  add [bx+si],al
  db 0x00, 0x00                ; 000018AD  add [bx+si],al
  db 0x00, 0x00                ; 000018AF  add [bx+si],al
  db 0x00, 0x00                ; 000018B1  add [bx+si],al
  db 0x00, 0x00                ; 000018B3  add [bx+si],al
  db 0x00, 0x00                ; 000018B5  add [bx+si],al
  db 0x00, 0x00                ; 000018B7  add [bx+si],al
  db 0x00, 0x00                ; 000018B9  add [bx+si],al
  db 0x00, 0x00                ; 000018BB  add [bx+si],al
  db 0x00, 0x00                ; 000018BD  add [bx+si],al
  db 0x00, 0x00                ; 000018BF  add [bx+si],al
  db 0x00, 0x00                ; 000018C1  add [bx+si],al
  db 0x00, 0x00                ; 000018C3  add [bx+si],al
  db 0x00, 0x00                ; 000018C5  add [bx+si],al
  db 0x00, 0x00                ; 000018C7  add [bx+si],al
  db 0x00, 0x00                ; 000018C9  add [bx+si],al
  db 0x00, 0x00                ; 000018CB  add [bx+si],al
  db 0x00, 0x00                ; 000018CD  add [bx+si],al
  db 0x00, 0x00                ; 000018CF  add [bx+si],al
  db 0x00, 0x00                ; 000018D1  add [bx+si],al
  db 0x00, 0x00                ; 000018D3  add [bx+si],al
  db 0x00, 0x00                ; 000018D5  add [bx+si],al
  db 0x00, 0x00                ; 000018D7  add [bx+si],al
  db 0x00, 0x00                ; 000018D9  add [bx+si],al
  db 0x00, 0x00                ; 000018DB  add [bx+si],al
  db 0x00, 0x00                ; 000018DD  add [bx+si],al
  db 0x00, 0x00                ; 000018DF  add [bx+si],al
  db 0x00, 0x00                ; 000018E1  add [bx+si],al
  db 0x00, 0x00                ; 000018E3  add [bx+si],al
  db 0x00, 0x00                ; 000018E5  add [bx+si],al
  db 0x00, 0x00                ; 000018E7  add [bx+si],al
  db 0x00, 0x00                ; 000018E9  add [bx+si],al
  db 0x00, 0x00                ; 000018EB  add [bx+si],al
  db 0x00, 0x00                ; 000018ED  add [bx+si],al
  db 0x00, 0x00                ; 000018EF  add [bx+si],al
  db 0x00, 0x00                ; 000018F1  add [bx+si],al
  db 0x00, 0x00                ; 000018F3  add [bx+si],al
  db 0x00, 0x00                ; 000018F5  add [bx+si],al
  db 0x00, 0x00                ; 000018F7  add [bx+si],al
  db 0x00, 0x00                ; 000018F9  add [bx+si],al
  db 0x00, 0x00                ; 000018FB  add [bx+si],al
  db 0x00, 0x00                ; 000018FD  add [bx+si],al
  db 0x00, 0x00                ; 000018FF  add [bx+si],al
  db 0x00, 0x00                ; 00001901  add [bx+si],al
  db 0x00, 0x00                ; 00001903  add [bx+si],al
  db 0x00, 0x00                ; 00001905  add [bx+si],al
  db 0x00, 0x00                ; 00001907  add [bx+si],al
  db 0x00, 0x00                ; 00001909  add [bx+si],al
  db 0x00, 0x00                ; 0000190B  add [bx+si],al
  db 0x00, 0x00                ; 0000190D  add [bx+si],al
  db 0x00, 0x00                ; 0000190F  add [bx+si],al
  db 0x00, 0x00                ; 00001911  add [bx+si],al
  db 0x00, 0x00                ; 00001913  add [bx+si],al
  db 0x00, 0x00                ; 00001915  add [bx+si],al
  db 0x00, 0x00                ; 00001917  add [bx+si],al
  db 0x00, 0x00                ; 00001919  add [bx+si],al
  db 0x00, 0x00                ; 0000191B  add [bx+si],al
  db 0x00, 0x00                ; 0000191D  add [bx+si],al
  db 0x00, 0x00                ; 0000191F  add [bx+si],al
  db 0x00, 0x00                ; 00001921  add [bx+si],al
  db 0x00, 0x00                ; 00001923  add [bx+si],al
  db 0x00, 0x00                ; 00001925  add [bx+si],al
  db 0x00, 0x00                ; 00001927  add [bx+si],al
  db 0x00, 0x00                ; 00001929  add [bx+si],al
  db 0x00, 0x00                ; 0000192B  add [bx+si],al
  db 0x00, 0x00                ; 0000192D  add [bx+si],al
  db 0x00, 0x00                ; 0000192F  add [bx+si],al
  db 0x00, 0x00                ; 00001931  add [bx+si],al
  db 0x00, 0x00                ; 00001933  add [bx+si],al
  db 0x00, 0x00                ; 00001935  add [bx+si],al
  db 0x00, 0x00                ; 00001937  add [bx+si],al
  db 0x00, 0x00                ; 00001939  add [bx+si],al
  db 0x00, 0x00                ; 0000193B  add [bx+si],al
  db 0x00, 0x00                ; 0000193D  add [bx+si],al
  db 0x00, 0x00                ; 0000193F  add [bx+si],al
  db 0x00, 0x00                ; 00001941  add [bx+si],al
  db 0x00, 0x00                ; 00001943  add [bx+si],al
  db 0x00, 0x00                ; 00001945  add [bx+si],al
  db 0x00, 0x00                ; 00001947  add [bx+si],al
  db 0x00, 0x00                ; 00001949  add [bx+si],al
  db 0x00, 0x00                ; 0000194B  add [bx+si],al
  db 0x00, 0x00                ; 0000194D  add [bx+si],al
  db 0x00, 0x00                ; 0000194F  add [bx+si],al
  db 0x00, 0x00                ; 00001951  add [bx+si],al
  db 0x00, 0x00                ; 00001953  add [bx+si],al
  db 0x00, 0x00                ; 00001955  add [bx+si],al
  db 0x00, 0x00                ; 00001957  add [bx+si],al
  db 0x00, 0x00                ; 00001959  add [bx+si],al
  db 0x00, 0x00                ; 0000195B  add [bx+si],al
  db 0x00, 0x00                ; 0000195D  add [bx+si],al
  db 0x00, 0x00                ; 0000195F  add [bx+si],al
  db 0x00, 0x00                ; 00001961  add [bx+si],al
  db 0x00, 0x00                ; 00001963  add [bx+si],al
  db 0x00, 0x00                ; 00001965  add [bx+si],al
  db 0x00, 0x00                ; 00001967  add [bx+si],al
  db 0x00, 0x00                ; 00001969  add [bx+si],al
  db 0x00, 0x00                ; 0000196B  add [bx+si],al
  db 0x00, 0x00                ; 0000196D  add [bx+si],al
  db 0x00, 0x00                ; 0000196F  add [bx+si],al
  db 0x00, 0x00                ; 00001971  add [bx+si],al
  db 0x00, 0x00                ; 00001973  add [bx+si],al
  db 0x00, 0x00                ; 00001975  add [bx+si],al
  db 0x00, 0x00                ; 00001977  add [bx+si],al
  db 0x00, 0x00                ; 00001979  add [bx+si],al
  db 0x00, 0x00                ; 0000197B  add [bx+si],al
  db 0x00, 0x00                ; 0000197D  add [bx+si],al
  db 0x00, 0x00                ; 0000197F  add [bx+si],al
  db 0x00, 0x00                ; 00001981  add [bx+si],al
  db 0x00, 0x00                ; 00001983  add [bx+si],al
  db 0x00, 0x00                ; 00001985  add [bx+si],al
  db 0x00, 0x00                ; 00001987  add [bx+si],al
  db 0x00, 0x00                ; 00001989  add [bx+si],al
  db 0x00, 0x00                ; 0000198B  add [bx+si],al
  db 0x00, 0x00                ; 0000198D  add [bx+si],al
  db 0x00, 0x00                ; 0000198F  add [bx+si],al
  db 0x00, 0x00                ; 00001991  add [bx+si],al
  db 0x00, 0x00                ; 00001993  add [bx+si],al
  db 0x00, 0x00                ; 00001995  add [bx+si],al
  db 0x00, 0x00                ; 00001997  add [bx+si],al
  db 0x00, 0x00                ; 00001999  add [bx+si],al
  db 0x00, 0x00                ; 0000199B  add [bx+si],al
  db 0x00, 0x00                ; 0000199D  add [bx+si],al
  db 0x00, 0x00                ; 0000199F  add [bx+si],al
  db 0x00, 0x00                ; 000019A1  add [bx+si],al
  db 0x00, 0x00                ; 000019A3  add [bx+si],al
  db 0x00, 0x00                ; 000019A5  add [bx+si],al
  db 0x00, 0x00                ; 000019A7  add [bx+si],al
  db 0x00, 0x00                ; 000019A9  add [bx+si],al
  db 0x00, 0x00                ; 000019AB  add [bx+si],al
  db 0x00, 0x00                ; 000019AD  add [bx+si],al
  db 0x00, 0x00                ; 000019AF  add [bx+si],al
  db 0x00, 0x00                ; 000019B1  add [bx+si],al
  db 0x00, 0x00                ; 000019B3  add [bx+si],al
  db 0x00, 0x00                ; 000019B5  add [bx+si],al
  db 0x00, 0x00                ; 000019B7  add [bx+si],al
  db 0x00, 0x00                ; 000019B9  add [bx+si],al
  db 0x00, 0x00                ; 000019BB  add [bx+si],al
  db 0x00, 0x00                ; 000019BD  add [bx+si],al
  db 0x00, 0x00                ; 000019BF  add [bx+si],al
  db 0x00, 0x00                ; 000019C1  add [bx+si],al
  db 0x00, 0x00                ; 000019C3  add [bx+si],al
  db 0x00, 0x00                ; 000019C5  add [bx+si],al
  db 0x00, 0x00                ; 000019C7  add [bx+si],al
  db 0x00, 0x00                ; 000019C9  add [bx+si],al
  db 0x00, 0x00                ; 000019CB  add [bx+si],al
  db 0x00, 0x00                ; 000019CD  add [bx+si],al
  db 0x00, 0x00                ; 000019CF  add [bx+si],al
  db 0x00, 0x00                ; 000019D1  add [bx+si],al
  db 0x00, 0x00                ; 000019D3  add [bx+si],al
  db 0x00, 0x00                ; 000019D5  add [bx+si],al
  db 0x00, 0x00                ; 000019D7  add [bx+si],al
  db 0x00, 0x00                ; 000019D9  add [bx+si],al
  db 0x00, 0x00                ; 000019DB  add [bx+si],al
  db 0x00, 0x00                ; 000019DD  add [bx+si],al
  db 0x00, 0x00                ; 000019DF  add [bx+si],al
  db 0x00, 0x00                ; 000019E1  add [bx+si],al
  db 0x00, 0x00                ; 000019E3  add [bx+si],al
  db 0x00, 0x00                ; 000019E5  add [bx+si],al
  db 0x00, 0x00                ; 000019E7  add [bx+si],al
  db 0x00, 0x00                ; 000019E9  add [bx+si],al
  db 0x00, 0x00                ; 000019EB  add [bx+si],al
  db 0x00, 0x00                ; 000019ED  add [bx+si],al
  db 0x00, 0x00                ; 000019EF  add [bx+si],al
  db 0x00, 0x00                ; 000019F1  add [bx+si],al
  db 0x00, 0x00                ; 000019F3  add [bx+si],al
  db 0x00, 0x00                ; 000019F5  add [bx+si],al
  db 0x00, 0x00                ; 000019F7  add [bx+si],al
  db 0x00, 0x00                ; 000019F9  add [bx+si],al
  db 0x00, 0x00                ; 000019FB  add [bx+si],al
  db 0x00, 0x00                ; 000019FD  add [bx+si],al
  db 0x00, 0x00                ; 000019FF  add [bx+si],al
  db 0x00, 0x00                ; 00001A01  add [bx+si],al
  db 0x00, 0x00                ; 00001A03  add [bx+si],al
  db 0x00, 0x00                ; 00001A05  add [bx+si],al
  db 0x00, 0x00                ; 00001A07  add [bx+si],al
  db 0x00, 0x00                ; 00001A09  add [bx+si],al
  db 0x00, 0x00                ; 00001A0B  add [bx+si],al
  db 0x00, 0x00                ; 00001A0D  add [bx+si],al
  db 0x00, 0x00                ; 00001A0F  add [bx+si],al
  db 0x00, 0x00                ; 00001A11  add [bx+si],al
  db 0x00, 0x00                ; 00001A13  add [bx+si],al
  db 0x00, 0x00                ; 00001A15  add [bx+si],al
  db 0x00, 0x00                ; 00001A17  add [bx+si],al
  db 0x00, 0x00                ; 00001A19  add [bx+si],al
  db 0x00, 0x00                ; 00001A1B  add [bx+si],al
  db 0x00, 0x00                ; 00001A1D  add [bx+si],al
  db 0x00, 0x00                ; 00001A1F  add [bx+si],al
  db 0x00, 0x00                ; 00001A21  add [bx+si],al
  db 0x00, 0x00                ; 00001A23  add [bx+si],al
  db 0x00, 0x00                ; 00001A25  add [bx+si],al
  db 0x00, 0x00                ; 00001A27  add [bx+si],al
  db 0x00, 0x00                ; 00001A29  add [bx+si],al
  db 0x00, 0x00                ; 00001A2B  add [bx+si],al
  db 0x00, 0x00                ; 00001A2D  add [bx+si],al
  db 0x00, 0x00                ; 00001A2F  add [bx+si],al
  db 0x00, 0x00                ; 00001A31  add [bx+si],al
  db 0x00, 0x00                ; 00001A33  add [bx+si],al
  db 0x00, 0x00                ; 00001A35  add [bx+si],al
  db 0x00, 0x00                ; 00001A37  add [bx+si],al
  db 0x00, 0x00                ; 00001A39  add [bx+si],al
  db 0x00, 0x00                ; 00001A3B  add [bx+si],al
  db 0x00, 0x00                ; 00001A3D  add [bx+si],al
  db 0x00, 0x00                ; 00001A3F  add [bx+si],al
  db 0x00, 0x00                ; 00001A41  add [bx+si],al
  db 0x00, 0x00                ; 00001A43  add [bx+si],al
  db 0x00, 0x00                ; 00001A45  add [bx+si],al
  db 0x00, 0x00                ; 00001A47  add [bx+si],al
  db 0x00, 0x00                ; 00001A49  add [bx+si],al
  db 0x00, 0x00                ; 00001A4B  add [bx+si],al
  db 0x00, 0x00                ; 00001A4D  add [bx+si],al
  db 0x00, 0x00                ; 00001A4F  add [bx+si],al
  db 0x00, 0x00                ; 00001A51  add [bx+si],al
  db 0x00, 0x00                ; 00001A53  add [bx+si],al
  db 0x00, 0x00                ; 00001A55  add [bx+si],al
  db 0x00, 0x00                ; 00001A57  add [bx+si],al
  db 0x00, 0x00                ; 00001A59  add [bx+si],al
  db 0x00, 0x00                ; 00001A5B  add [bx+si],al
  db 0x00, 0x00                ; 00001A5D  add [bx+si],al
  db 0x00, 0x00                ; 00001A5F  add [bx+si],al
  db 0x00, 0x00                ; 00001A61  add [bx+si],al
  db 0x00, 0x00                ; 00001A63  add [bx+si],al
  db 0x00, 0x00                ; 00001A65  add [bx+si],al
  db 0x00, 0x00                ; 00001A67  add [bx+si],al
  db 0x00, 0x00                ; 00001A69  add [bx+si],al
  db 0x00, 0x00                ; 00001A6B  add [bx+si],al
  db 0x00, 0x00                ; 00001A6D  add [bx+si],al
  db 0x00, 0x00                ; 00001A6F  add [bx+si],al
  db 0x00, 0x00                ; 00001A71  add [bx+si],al
  db 0x00, 0x00                ; 00001A73  add [bx+si],al
  db 0x00, 0x00                ; 00001A75  add [bx+si],al
  db 0x00, 0x00                ; 00001A77  add [bx+si],al
  db 0x00, 0x00                ; 00001A79  add [bx+si],al
  db 0x00, 0x00                ; 00001A7B  add [bx+si],al
  db 0x00, 0x00                ; 00001A7D  add [bx+si],al
  db 0x00, 0x00                ; 00001A7F  add [bx+si],al
  db 0x00, 0x00                ; 00001A81  add [bx+si],al
  db 0x00, 0x00                ; 00001A83  add [bx+si],al
  db 0x00, 0x00                ; 00001A85  add [bx+si],al
  db 0x00, 0x00                ; 00001A87  add [bx+si],al
  db 0x00, 0x00                ; 00001A89  add [bx+si],al
  db 0x00, 0x00                ; 00001A8B  add [bx+si],al
  db 0x00, 0x00                ; 00001A8D  add [bx+si],al
  db 0x00, 0x00                ; 00001A8F  add [bx+si],al
  db 0x00, 0x00                ; 00001A91  add [bx+si],al
  db 0x00, 0x00                ; 00001A93  add [bx+si],al
  db 0x00, 0x00                ; 00001A95  add [bx+si],al
  db 0x00, 0x00                ; 00001A97  add [bx+si],al
  db 0x00, 0x00                ; 00001A99  add [bx+si],al
  db 0x00, 0x00                ; 00001A9B  add [bx+si],al
  db 0x00, 0x00                ; 00001A9D  add [bx+si],al
  db 0x00, 0x00                ; 00001A9F  add [bx+si],al
  db 0x00, 0x00                ; 00001AA1  add [bx+si],al
  db 0x00, 0x00                ; 00001AA3  add [bx+si],al
  db 0x00, 0x00                ; 00001AA5  add [bx+si],al
  db 0x00, 0x00                ; 00001AA7  add [bx+si],al
  db 0x00, 0x00                ; 00001AA9  add [bx+si],al
  db 0x00, 0x00                ; 00001AAB  add [bx+si],al
  db 0x00, 0x00                ; 00001AAD  add [bx+si],al
  db 0x00, 0x00                ; 00001AAF  add [bx+si],al
  db 0x00, 0x00                ; 00001AB1  add [bx+si],al
  db 0x00, 0x00                ; 00001AB3  add [bx+si],al
  db 0x00, 0x00                ; 00001AB5  add [bx+si],al
  db 0x00, 0x00                ; 00001AB7  add [bx+si],al
  db 0x00, 0x00                ; 00001AB9  add [bx+si],al
  db 0x00, 0x00                ; 00001ABB  add [bx+si],al
  db 0x00, 0x00                ; 00001ABD  add [bx+si],al
  db 0x00, 0x00                ; 00001ABF  add [bx+si],al
  db 0x00, 0x00                ; 00001AC1  add [bx+si],al
  db 0x00, 0x00                ; 00001AC3  add [bx+si],al
  db 0x00, 0x00                ; 00001AC5  add [bx+si],al
  db 0x00, 0x00                ; 00001AC7  add [bx+si],al
  db 0x00, 0x00                ; 00001AC9  add [bx+si],al
  db 0x00, 0x00                ; 00001ACB  add [bx+si],al
  db 0x00, 0x00                ; 00001ACD  add [bx+si],al
  db 0x00, 0x00                ; 00001ACF  add [bx+si],al
  db 0x00, 0x00                ; 00001AD1  add [bx+si],al
  db 0x00, 0x00                ; 00001AD3  add [bx+si],al
  db 0x00, 0x00                ; 00001AD5  add [bx+si],al
  db 0x00, 0x00                ; 00001AD7  add [bx+si],al
  db 0x00, 0x00                ; 00001AD9  add [bx+si],al
  db 0x00, 0x00                ; 00001ADB  add [bx+si],al
  db 0x00, 0x00                ; 00001ADD  add [bx+si],al
  db 0x00, 0x00                ; 00001ADF  add [bx+si],al
  db 0x00, 0x00                ; 00001AE1  add [bx+si],al
  db 0x00, 0x00                ; 00001AE3  add [bx+si],al
  db 0x00, 0x00                ; 00001AE5  add [bx+si],al
  db 0x00, 0x00                ; 00001AE7  add [bx+si],al
  db 0x00, 0x00                ; 00001AE9  add [bx+si],al
  db 0x00, 0x00                ; 00001AEB  add [bx+si],al
  db 0x00, 0x00                ; 00001AED  add [bx+si],al
  db 0x00, 0x00                ; 00001AEF  add [bx+si],al
  db 0x00, 0x00                ; 00001AF1  add [bx+si],al
  db 0x00, 0x00                ; 00001AF3  add [bx+si],al
  db 0x00, 0x00                ; 00001AF5  add [bx+si],al
  db 0x00, 0x00                ; 00001AF7  add [bx+si],al
  db 0x00, 0x00                ; 00001AF9  add [bx+si],al
  db 0x00, 0x00                ; 00001AFB  add [bx+si],al
  db 0x00, 0x00                ; 00001AFD  add [bx+si],al
  db 0x00, 0x00                ; 00001AFF  add [bx+si],al
  db 0x00, 0x00                ; 00001B01  add [bx+si],al
  db 0x00, 0x00                ; 00001B03  add [bx+si],al
  db 0x00, 0x00                ; 00001B05  add [bx+si],al
  db 0x00, 0x00                ; 00001B07  add [bx+si],al
  db 0x00, 0x00                ; 00001B09  add [bx+si],al
  db 0x00, 0x00                ; 00001B0B  add [bx+si],al
  db 0x00, 0x00                ; 00001B0D  add [bx+si],al
  db 0x00, 0x00                ; 00001B0F  add [bx+si],al
  db 0x00, 0x00                ; 00001B11  add [bx+si],al
  db 0x00, 0x00                ; 00001B13  add [bx+si],al
  db 0x00, 0x00                ; 00001B15  add [bx+si],al
  db 0x00, 0x00                ; 00001B17  add [bx+si],al
  db 0x00, 0x00                ; 00001B19  add [bx+si],al
  db 0x00, 0x00                ; 00001B1B  add [bx+si],al
  db 0x00, 0x00                ; 00001B1D  add [bx+si],al
  db 0x00, 0x00                ; 00001B1F  add [bx+si],al
  db 0x00, 0x00                ; 00001B21  add [bx+si],al
  db 0x00, 0x00                ; 00001B23  add [bx+si],al
  db 0x00, 0x00                ; 00001B25  add [bx+si],al
  db 0x00, 0x00                ; 00001B27  add [bx+si],al
  db 0x00, 0x00                ; 00001B29  add [bx+si],al
  db 0x00, 0x00                ; 00001B2B  add [bx+si],al
  db 0x00, 0x00                ; 00001B2D  add [bx+si],al
  db 0x00, 0x00                ; 00001B2F  add [bx+si],al
  db 0x00, 0x00                ; 00001B31  add [bx+si],al
  db 0x00, 0x00                ; 00001B33  add [bx+si],al
  db 0x00, 0x00                ; 00001B35  add [bx+si],al
  db 0x00, 0x00                ; 00001B37  add [bx+si],al
  db 0x00, 0x00                ; 00001B39  add [bx+si],al
  db 0x00, 0x00                ; 00001B3B  add [bx+si],al
  db 0x00, 0x00                ; 00001B3D  add [bx+si],al
  db 0x00, 0x00                ; 00001B3F  add [bx+si],al
  db 0x00, 0x00                ; 00001B41  add [bx+si],al
  db 0x00, 0x00                ; 00001B43  add [bx+si],al
  db 0x00, 0x00                ; 00001B45  add [bx+si],al
  db 0x00, 0x00                ; 00001B47  add [bx+si],al
  db 0x00, 0x00                ; 00001B49  add [bx+si],al
  db 0x00, 0x00                ; 00001B4B  add [bx+si],al
  db 0x00, 0x00                ; 00001B4D  add [bx+si],al
  db 0x00, 0x00                ; 00001B4F  add [bx+si],al
  db 0x00, 0x00                ; 00001B51  add [bx+si],al
  db 0x00, 0x00                ; 00001B53  add [bx+si],al
  db 0x00, 0x00                ; 00001B55  add [bx+si],al
  db 0x00, 0x00                ; 00001B57  add [bx+si],al
  db 0x00, 0x00                ; 00001B59  add [bx+si],al
  db 0x00, 0x00                ; 00001B5B  add [bx+si],al
  db 0x00, 0x00                ; 00001B5D  add [bx+si],al
  db 0x00, 0x00                ; 00001B5F  add [bx+si],al
  db 0x00, 0x00                ; 00001B61  add [bx+si],al
  db 0x00, 0x00                ; 00001B63  add [bx+si],al
  db 0x00, 0x00                ; 00001B65  add [bx+si],al
  db 0x00, 0x00                ; 00001B67  add [bx+si],al
  db 0x00, 0x00                ; 00001B69  add [bx+si],al
  db 0x00, 0x00                ; 00001B6B  add [bx+si],al
  db 0x00, 0x00                ; 00001B6D  add [bx+si],al
  db 0x00, 0x00                ; 00001B6F  add [bx+si],al
  db 0x00, 0x00                ; 00001B71  add [bx+si],al
  db 0x00, 0x00                ; 00001B73  add [bx+si],al
  db 0x00, 0x00                ; 00001B75  add [bx+si],al
  db 0x00, 0x00                ; 00001B77  add [bx+si],al
  db 0x00, 0x00                ; 00001B79  add [bx+si],al
  db 0x00, 0x00                ; 00001B7B  add [bx+si],al
  db 0x00, 0x00                ; 00001B7D  add [bx+si],al
  db 0x00, 0x00                ; 00001B7F  add [bx+si],al
  db 0x00, 0x00                ; 00001B81  add [bx+si],al
  db 0x00, 0x00                ; 00001B83  add [bx+si],al
  db 0x00, 0x00                ; 00001B85  add [bx+si],al
  db 0x00, 0x00                ; 00001B87  add [bx+si],al
  db 0x00, 0x00                ; 00001B89  add [bx+si],al
  db 0x00, 0x00                ; 00001B8B  add [bx+si],al
  db 0x00, 0x00                ; 00001B8D  add [bx+si],al
  db 0x00, 0x00                ; 00001B8F  add [bx+si],al
  db 0x00, 0x00                ; 00001B91  add [bx+si],al
  db 0x00, 0x00                ; 00001B93  add [bx+si],al
  db 0x00, 0x00                ; 00001B95  add [bx+si],al
  db 0x00, 0x00                ; 00001B97  add [bx+si],al
  db 0x00, 0x00                ; 00001B99  add [bx+si],al
  db 0x00, 0x00                ; 00001B9B  add [bx+si],al
  db 0x00, 0x00                ; 00001B9D  add [bx+si],al
  db 0x00, 0x00                ; 00001B9F  add [bx+si],al
  db 0x00, 0x00                ; 00001BA1  add [bx+si],al
  db 0x00, 0x00                ; 00001BA3  add [bx+si],al
  db 0x00, 0x00                ; 00001BA5  add [bx+si],al
  db 0x00, 0x00                ; 00001BA7  add [bx+si],al
  db 0x00, 0x00                ; 00001BA9  add [bx+si],al
  db 0x00, 0x00                ; 00001BAB  add [bx+si],al
  db 0x00, 0x00                ; 00001BAD  add [bx+si],al
  db 0x00, 0x00                ; 00001BAF  add [bx+si],al
  db 0x00, 0x00                ; 00001BB1  add [bx+si],al
  db 0x00, 0x00                ; 00001BB3  add [bx+si],al
  db 0x00, 0x00                ; 00001BB5  add [bx+si],al
  db 0x00, 0x00                ; 00001BB7  add [bx+si],al
  db 0x00, 0x00                ; 00001BB9  add [bx+si],al
  db 0x00, 0x00                ; 00001BBB  add [bx+si],al
  db 0x00, 0x00                ; 00001BBD  add [bx+si],al
  db 0x00, 0x00                ; 00001BBF  add [bx+si],al
  db 0x00, 0x00                ; 00001BC1  add [bx+si],al
  db 0x00, 0x00                ; 00001BC3  add [bx+si],al
  db 0x00, 0x00                ; 00001BC5  add [bx+si],al
  db 0x00, 0x00                ; 00001BC7  add [bx+si],al
  db 0x00, 0x00                ; 00001BC9  add [bx+si],al
  db 0x00, 0x00                ; 00001BCB  add [bx+si],al
  db 0x00, 0x00                ; 00001BCD  add [bx+si],al
  db 0x00, 0x00                ; 00001BCF  add [bx+si],al
  db 0x00, 0x00                ; 00001BD1  add [bx+si],al
  db 0x00, 0x00                ; 00001BD3  add [bx+si],al
  db 0x00, 0x00                ; 00001BD5  add [bx+si],al
  db 0x00, 0x00                ; 00001BD7  add [bx+si],al
  db 0x00, 0x00                ; 00001BD9  add [bx+si],al
  db 0x00, 0x00                ; 00001BDB  add [bx+si],al
  db 0x00, 0x00                ; 00001BDD  add [bx+si],al
  db 0x00, 0x00                ; 00001BDF  add [bx+si],al
  db 0x00, 0x00                ; 00001BE1  add [bx+si],al
  db 0x00, 0x00                ; 00001BE3  add [bx+si],al
  db 0x00, 0x00                ; 00001BE5  add [bx+si],al
  db 0x00, 0x00                ; 00001BE7  add [bx+si],al
  db 0x00, 0x00                ; 00001BE9  add [bx+si],al
  db 0x00, 0x00                ; 00001BEB  add [bx+si],al
  db 0x00, 0x00                ; 00001BED  add [bx+si],al
  db 0x00, 0x00                ; 00001BEF  add [bx+si],al
  db 0x00, 0x00                ; 00001BF1  add [bx+si],al
  db 0x00, 0x00                ; 00001BF3  add [bx+si],al
  db 0x00, 0x00                ; 00001BF5  add [bx+si],al
  db 0x00, 0x00                ; 00001BF7  add [bx+si],al
  db 0x00, 0x00                ; 00001BF9  add [bx+si],al
  db 0x00, 0x00                ; 00001BFB  add [bx+si],al
  db 0x00, 0x00                ; 00001BFD  add [bx+si],al
  db 0x00, 0x00                ; 00001BFF  add [bx+si],al
  db 0x00, 0x00                ; 00001C01  add [bx+si],al
  db 0x00, 0x00                ; 00001C03  add [bx+si],al
  db 0x00, 0x00                ; 00001C05  add [bx+si],al
  db 0x00, 0x00                ; 00001C07  add [bx+si],al
  db 0x00, 0x00                ; 00001C09  add [bx+si],al
  db 0x00, 0x00                ; 00001C0B  add [bx+si],al
  db 0x00, 0x00                ; 00001C0D  add [bx+si],al
  db 0x00, 0x00                ; 00001C0F  add [bx+si],al
  db 0x00, 0x00                ; 00001C11  add [bx+si],al
  db 0x00, 0x00                ; 00001C13  add [bx+si],al
  db 0x00, 0x00                ; 00001C15  add [bx+si],al
  db 0x00, 0x00                ; 00001C17  add [bx+si],al
  db 0x00, 0x00                ; 00001C19  add [bx+si],al
  db 0x00, 0x00                ; 00001C1B  add [bx+si],al
  db 0x00, 0x00                ; 00001C1D  add [bx+si],al
  db 0x00, 0x00                ; 00001C1F  add [bx+si],al
  db 0x00, 0x00                ; 00001C21  add [bx+si],al
  db 0x00, 0x00                ; 00001C23  add [bx+si],al
  db 0x00, 0x00                ; 00001C25  add [bx+si],al
  db 0x00, 0x00                ; 00001C27  add [bx+si],al
  db 0x00, 0x00                ; 00001C29  add [bx+si],al
  db 0x00, 0x00                ; 00001C2B  add [bx+si],al
  db 0x00, 0x00                ; 00001C2D  add [bx+si],al
  db 0x00, 0x00                ; 00001C2F  add [bx+si],al
  db 0x00, 0x00                ; 00001C31  add [bx+si],al
  db 0x00, 0x00                ; 00001C33  add [bx+si],al
  db 0x00, 0x00                ; 00001C35  add [bx+si],al
  db 0x00, 0x00                ; 00001C37  add [bx+si],al
  db 0x00, 0x00                ; 00001C39  add [bx+si],al
  db 0x00, 0x00                ; 00001C3B  add [bx+si],al
  db 0x00, 0x00                ; 00001C3D  add [bx+si],al
  db 0x00, 0x00                ; 00001C3F  add [bx+si],al
  db 0x00, 0x00                ; 00001C41  add [bx+si],al
  db 0x00, 0x00                ; 00001C43  add [bx+si],al
  db 0x00, 0x00                ; 00001C45  add [bx+si],al
  db 0x00, 0x00                ; 00001C47  add [bx+si],al
  db 0x00, 0x00                ; 00001C49  add [bx+si],al
  db 0x00, 0x00                ; 00001C4B  add [bx+si],al
  db 0x00, 0x00                ; 00001C4D  add [bx+si],al
  db 0x00, 0x00                ; 00001C4F  add [bx+si],al
  db 0x00, 0x00                ; 00001C51  add [bx+si],al
  db 0x00, 0x00                ; 00001C53  add [bx+si],al
  db 0x00, 0x00                ; 00001C55  add [bx+si],al
  db 0x00, 0x00                ; 00001C57  add [bx+si],al
  db 0x00, 0x00                ; 00001C59  add [bx+si],al
  db 0x00, 0x00                ; 00001C5B  add [bx+si],al
  db 0x00, 0x00                ; 00001C5D  add [bx+si],al
  db 0x00, 0x00                ; 00001C5F  add [bx+si],al
  db 0x00, 0x00                ; 00001C61  add [bx+si],al
  db 0x00, 0x00                ; 00001C63  add [bx+si],al
  db 0x00, 0x00                ; 00001C65  add [bx+si],al
  db 0x00, 0x00                ; 00001C67  add [bx+si],al
  db 0x00, 0x00                ; 00001C69  add [bx+si],al
  db 0x00, 0x00                ; 00001C6B  add [bx+si],al
  db 0x00, 0x00                ; 00001C6D  add [bx+si],al
  db 0x00, 0x00                ; 00001C6F  add [bx+si],al
  db 0x00, 0x00                ; 00001C71  add [bx+si],al
  db 0x00, 0x00                ; 00001C73  add [bx+si],al
  db 0x00, 0x00                ; 00001C75  add [bx+si],al
  db 0x00, 0x00                ; 00001C77  add [bx+si],al
  db 0x00, 0x00                ; 00001C79  add [bx+si],al
  db 0x00, 0x00                ; 00001C7B  add [bx+si],al
  db 0x00, 0x00                ; 00001C7D  add [bx+si],al
  db 0x00, 0x00                ; 00001C7F  add [bx+si],al
  db 0x00, 0x00                ; 00001C81  add [bx+si],al
  db 0x00, 0x00                ; 00001C83  add [bx+si],al
  db 0x00, 0x00                ; 00001C85  add [bx+si],al
  db 0x00, 0x00                ; 00001C87  add [bx+si],al
  db 0x00, 0x00                ; 00001C89  add [bx+si],al
  db 0x00, 0x00                ; 00001C8B  add [bx+si],al
  db 0x00, 0x00                ; 00001C8D  add [bx+si],al
  db 0x00, 0x00                ; 00001C8F  add [bx+si],al
  db 0x00, 0x00                ; 00001C91  add [bx+si],al
  db 0x00, 0x00                ; 00001C93  add [bx+si],al
  db 0x00, 0x00                ; 00001C95  add [bx+si],al
  db 0x00, 0x00                ; 00001C97  add [bx+si],al
  db 0x00, 0x00                ; 00001C99  add [bx+si],al
  db 0x00, 0x00                ; 00001C9B  add [bx+si],al
  db 0x00, 0x00                ; 00001C9D  add [bx+si],al
  db 0x00, 0x00                ; 00001C9F  add [bx+si],al
  db 0x00, 0x00                ; 00001CA1  add [bx+si],al
  db 0x00, 0x00                ; 00001CA3  add [bx+si],al
  db 0x00, 0x00                ; 00001CA5  add [bx+si],al
  db 0x00, 0x00                ; 00001CA7  add [bx+si],al
  db 0x00, 0x00                ; 00001CA9  add [bx+si],al
  db 0x00, 0x00                ; 00001CAB  add [bx+si],al
  db 0x00, 0x00                ; 00001CAD  add [bx+si],al
  db 0x00, 0x00                ; 00001CAF  add [bx+si],al
  db 0x00, 0x00                ; 00001CB1  add [bx+si],al
  db 0x00, 0x00                ; 00001CB3  add [bx+si],al
  db 0x00, 0x00                ; 00001CB5  add [bx+si],al
  db 0x00, 0x00                ; 00001CB7  add [bx+si],al
  db 0x00, 0x00                ; 00001CB9  add [bx+si],al
  db 0x00, 0x00                ; 00001CBB  add [bx+si],al
  db 0x00, 0x00                ; 00001CBD  add [bx+si],al
  db 0x00, 0x00                ; 00001CBF  add [bx+si],al
  db 0x00, 0x00                ; 00001CC1  add [bx+si],al
  db 0x00, 0x00                ; 00001CC3  add [bx+si],al
  db 0x00, 0x00                ; 00001CC5  add [bx+si],al
  db 0x00, 0x00                ; 00001CC7  add [bx+si],al
  db 0x00, 0x00                ; 00001CC9  add [bx+si],al
  db 0x00, 0x00                ; 00001CCB  add [bx+si],al
  db 0x00, 0x00                ; 00001CCD  add [bx+si],al
  db 0x00, 0x00                ; 00001CCF  add [bx+si],al
  db 0x00, 0x00                ; 00001CD1  add [bx+si],al
  db 0x00, 0x00                ; 00001CD3  add [bx+si],al
  db 0x00, 0x00                ; 00001CD5  add [bx+si],al
  db 0x00, 0x00                ; 00001CD7  add [bx+si],al
  db 0x00, 0x00                ; 00001CD9  add [bx+si],al
  db 0x00, 0x00                ; 00001CDB  add [bx+si],al
  db 0x00, 0x00                ; 00001CDD  add [bx+si],al
  db 0x00, 0x00                ; 00001CDF  add [bx+si],al
  db 0x00, 0x00                ; 00001CE1  add [bx+si],al
  db 0x00, 0x00                ; 00001CE3  add [bx+si],al
  db 0x00, 0x00                ; 00001CE5  add [bx+si],al
  db 0x00, 0x00                ; 00001CE7  add [bx+si],al
  db 0x00, 0x00                ; 00001CE9  add [bx+si],al
  db 0x00, 0x00                ; 00001CEB  add [bx+si],al
  db 0x00, 0x00                ; 00001CED  add [bx+si],al
  db 0x00, 0x00                ; 00001CEF  add [bx+si],al
  db 0x00, 0x00                ; 00001CF1  add [bx+si],al
  db 0x00, 0x00                ; 00001CF3  add [bx+si],al
  db 0x00, 0x00                ; 00001CF5  add [bx+si],al
  db 0x00, 0x00                ; 00001CF7  add [bx+si],al
  db 0x00, 0x00                ; 00001CF9  add [bx+si],al
  db 0x00, 0x00                ; 00001CFB  add [bx+si],al
  db 0x00, 0x00                ; 00001CFD  add [bx+si],al
  db 0x00, 0x00                ; 00001CFF  add [bx+si],al
  db 0x00, 0x00                ; 00001D01  add [bx+si],al
  db 0x00, 0x00                ; 00001D03  add [bx+si],al
  db 0x00, 0x00                ; 00001D05  add [bx+si],al
  db 0x00, 0x00                ; 00001D07  add [bx+si],al
  db 0x00, 0x00                ; 00001D09  add [bx+si],al
  db 0x00, 0x00                ; 00001D0B  add [bx+si],al
  db 0x00, 0x00                ; 00001D0D  add [bx+si],al
  db 0x00, 0x00                ; 00001D0F  add [bx+si],al
  db 0x00, 0x00                ; 00001D11  add [bx+si],al
  db 0x00, 0x00                ; 00001D13  add [bx+si],al
  db 0x00, 0x00                ; 00001D15  add [bx+si],al
  db 0x00, 0x00                ; 00001D17  add [bx+si],al
  db 0x00, 0x00                ; 00001D19  add [bx+si],al
  db 0x00, 0x00                ; 00001D1B  add [bx+si],al
  db 0x00, 0x00                ; 00001D1D  add [bx+si],al
  db 0x00, 0x00                ; 00001D1F  add [bx+si],al
  db 0x00, 0x00                ; 00001D21  add [bx+si],al
  db 0x00, 0x00                ; 00001D23  add [bx+si],al
  db 0x00, 0x00                ; 00001D25  add [bx+si],al
  db 0x00, 0x00                ; 00001D27  add [bx+si],al
  db 0x00, 0x00                ; 00001D29  add [bx+si],al
  db 0x00, 0x00                ; 00001D2B  add [bx+si],al
  db 0x00, 0x00                ; 00001D2D  add [bx+si],al
  db 0x00, 0x00                ; 00001D2F  add [bx+si],al
  db 0x00, 0x00                ; 00001D31  add [bx+si],al
  db 0x00, 0x00                ; 00001D33  add [bx+si],al
  db 0x00, 0x00                ; 00001D35  add [bx+si],al
  db 0x00, 0x00                ; 00001D37  add [bx+si],al
  db 0x00, 0x00                ; 00001D39  add [bx+si],al
  db 0x00, 0x00                ; 00001D3B  add [bx+si],al
  db 0x00, 0x00                ; 00001D3D  add [bx+si],al
  db 0x00, 0x00                ; 00001D3F  add [bx+si],al
  db 0x00, 0x00                ; 00001D41  add [bx+si],al
  db 0x00, 0x00                ; 00001D43  add [bx+si],al
  db 0x00, 0x00                ; 00001D45  add [bx+si],al
  db 0x00, 0x00                ; 00001D47  add [bx+si],al
  db 0x00, 0x00                ; 00001D49  add [bx+si],al
  db 0x00, 0x00                ; 00001D4B  add [bx+si],al
  db 0x00, 0x00                ; 00001D4D  add [bx+si],al
  db 0x00, 0x00                ; 00001D4F  add [bx+si],al
  db 0x00, 0x00                ; 00001D51  add [bx+si],al
  db 0x00, 0x00                ; 00001D53  add [bx+si],al
  db 0x00, 0x00                ; 00001D55  add [bx+si],al
  db 0x00, 0x00                ; 00001D57  add [bx+si],al
  db 0x00, 0x00                ; 00001D59  add [bx+si],al
  db 0x00, 0x00                ; 00001D5B  add [bx+si],al
  db 0x00, 0x00                ; 00001D5D  add [bx+si],al
  db 0x00, 0x00                ; 00001D5F  add [bx+si],al
  db 0x00, 0x00                ; 00001D61  add [bx+si],al
  db 0x00, 0x00                ; 00001D63  add [bx+si],al
  db 0x00, 0x00                ; 00001D65  add [bx+si],al
  db 0x00, 0x00                ; 00001D67  add [bx+si],al
  db 0x00, 0x00                ; 00001D69  add [bx+si],al
  db 0x00, 0x00                ; 00001D6B  add [bx+si],al
  db 0x00, 0x00                ; 00001D6D  add [bx+si],al
  db 0x00, 0x00                ; 00001D6F  add [bx+si],al
  db 0x00, 0x00                ; 00001D71  add [bx+si],al
  db 0x00, 0x00                ; 00001D73  add [bx+si],al
  db 0x00, 0x00                ; 00001D75  add [bx+si],al
  db 0x00, 0x00                ; 00001D77  add [bx+si],al
  db 0x00, 0x00                ; 00001D79  add [bx+si],al
  db 0x00, 0x00                ; 00001D7B  add [bx+si],al
  db 0x00, 0x00                ; 00001D7D  add [bx+si],al
  db 0x00, 0x00                ; 00001D7F  add [bx+si],al
  db 0x00, 0x00                ; 00001D81  add [bx+si],al
  db 0x00, 0x00                ; 00001D83  add [bx+si],al
  db 0x00, 0x00                ; 00001D85  add [bx+si],al
  db 0x00, 0x00                ; 00001D87  add [bx+si],al
  db 0x00, 0x00                ; 00001D89  add [bx+si],al
  db 0x00, 0x00                ; 00001D8B  add [bx+si],al
  db 0x00, 0x00                ; 00001D8D  add [bx+si],al
  db 0x00, 0x00                ; 00001D8F  add [bx+si],al
  db 0x00, 0x00                ; 00001D91  add [bx+si],al
  db 0x00, 0x00                ; 00001D93  add [bx+si],al
  db 0x00, 0x00                ; 00001D95  add [bx+si],al
  db 0x00, 0x00                ; 00001D97  add [bx+si],al
  db 0x00, 0x00                ; 00001D99  add [bx+si],al
  db 0x00, 0x00                ; 00001D9B  add [bx+si],al
  db 0x00, 0x00                ; 00001D9D  add [bx+si],al
  db 0x00, 0x00                ; 00001D9F  add [bx+si],al
  db 0x00, 0x00                ; 00001DA1  add [bx+si],al
  db 0x00, 0x00                ; 00001DA3  add [bx+si],al
  db 0x00, 0x00                ; 00001DA5  add [bx+si],al
  db 0x00, 0x00                ; 00001DA7  add [bx+si],al
  db 0x00, 0x00                ; 00001DA9  add [bx+si],al
  db 0x00, 0x00                ; 00001DAB  add [bx+si],al
  db 0x00, 0x00                ; 00001DAD  add [bx+si],al
  db 0x00, 0x00                ; 00001DAF  add [bx+si],al
  db 0x00, 0x00                ; 00001DB1  add [bx+si],al
  db 0x00, 0x00                ; 00001DB3  add [bx+si],al
  db 0x00, 0x00                ; 00001DB5  add [bx+si],al
  db 0x00, 0x00                ; 00001DB7  add [bx+si],al
  db 0x00, 0x00                ; 00001DB9  add [bx+si],al
  db 0x00, 0x00                ; 00001DBB  add [bx+si],al
  db 0x00, 0x00                ; 00001DBD  add [bx+si],al
  db 0x00, 0x00                ; 00001DBF  add [bx+si],al
  db 0x00, 0x00                ; 00001DC1  add [bx+si],al
  db 0x00, 0x00                ; 00001DC3  add [bx+si],al
  db 0x00, 0x00                ; 00001DC5  add [bx+si],al
  db 0x00, 0x00                ; 00001DC7  add [bx+si],al
  db 0x00, 0x00                ; 00001DC9  add [bx+si],al
  db 0x00, 0x00                ; 00001DCB  add [bx+si],al
  db 0x00, 0x00                ; 00001DCD  add [bx+si],al
  db 0x00, 0x00                ; 00001DCF  add [bx+si],al
  db 0x00, 0x00                ; 00001DD1  add [bx+si],al
  db 0x00, 0x00                ; 00001DD3  add [bx+si],al
  db 0x00, 0x00                ; 00001DD5  add [bx+si],al
  db 0x00, 0x00                ; 00001DD7  add [bx+si],al
  db 0x00, 0x00                ; 00001DD9  add [bx+si],al
  db 0x00, 0x00                ; 00001DDB  add [bx+si],al
  db 0x00, 0x00                ; 00001DDD  add [bx+si],al
  db 0x00, 0x00                ; 00001DDF  add [bx+si],al
  db 0x00, 0x00                ; 00001DE1  add [bx+si],al
  db 0x00, 0x00                ; 00001DE3  add [bx+si],al
  db 0x00, 0x00                ; 00001DE5  add [bx+si],al
  db 0x00, 0x00                ; 00001DE7  add [bx+si],al
  db 0x00, 0x00                ; 00001DE9  add [bx+si],al
  db 0x00, 0x00                ; 00001DEB  add [bx+si],al
  db 0x00, 0x00                ; 00001DED  add [bx+si],al
  db 0x00, 0x00                ; 00001DEF  add [bx+si],al
  db 0x00, 0x00                ; 00001DF1  add [bx+si],al
  db 0x00, 0x00                ; 00001DF3  add [bx+si],al
  db 0x00, 0x00                ; 00001DF5  add [bx+si],al
  db 0x00, 0x00                ; 00001DF7  add [bx+si],al
  db 0x00, 0x00                ; 00001DF9  add [bx+si],al
  db 0x00, 0x00                ; 00001DFB  add [bx+si],al
  db 0x00, 0x00                ; 00001DFD  add [bx+si],al
  db 0x00, 0x00                ; 00001DFF  add [bx+si],al
  db 0x00, 0x00                ; 00001E01  add [bx+si],al
  db 0x00, 0x00                ; 00001E03  add [bx+si],al
  db 0x00, 0x00                ; 00001E05  add [bx+si],al
  db 0x00, 0x00                ; 00001E07  add [bx+si],al
  db 0x00, 0x00                ; 00001E09  add [bx+si],al
  db 0x00, 0x00                ; 00001E0B  add [bx+si],al
  db 0x00, 0x00                ; 00001E0D  add [bx+si],al
  db 0x00, 0x00                ; 00001E0F  add [bx+si],al
  db 0x00, 0x00                ; 00001E11  add [bx+si],al
  db 0x00, 0x00                ; 00001E13  add [bx+si],al
  db 0x00, 0x00                ; 00001E15  add [bx+si],al
  db 0x00, 0x00                ; 00001E17  add [bx+si],al
  db 0x00, 0x00                ; 00001E19  add [bx+si],al
  db 0x00, 0x00                ; 00001E1B  add [bx+si],al
  db 0x00, 0x00                ; 00001E1D  add [bx+si],al
  db 0x00, 0x00                ; 00001E1F  add [bx+si],al
  db 0x00, 0x00                ; 00001E21  add [bx+si],al
  db 0x00, 0x00                ; 00001E23  add [bx+si],al
  db 0x00, 0x00                ; 00001E25  add [bx+si],al
  db 0x00, 0x00                ; 00001E27  add [bx+si],al
  db 0x00, 0x00                ; 00001E29  add [bx+si],al
  db 0x00, 0x00                ; 00001E2B  add [bx+si],al
  db 0x00, 0x00                ; 00001E2D  add [bx+si],al
  db 0x00, 0x00                ; 00001E2F  add [bx+si],al
  db 0x00, 0x00                ; 00001E31  add [bx+si],al
  db 0x00, 0x00                ; 00001E33  add [bx+si],al
  db 0x00, 0x00                ; 00001E35  add [bx+si],al
  db 0x00, 0x00                ; 00001E37  add [bx+si],al
  db 0x00, 0x00                ; 00001E39  add [bx+si],al
  db 0x00, 0x00                ; 00001E3B  add [bx+si],al
  db 0x00, 0x00                ; 00001E3D  add [bx+si],al
  db 0x00, 0x00                ; 00001E3F  add [bx+si],al
  db 0x00, 0x00                ; 00001E41  add [bx+si],al
  db 0x00, 0x00                ; 00001E43  add [bx+si],al
  db 0x00, 0x00                ; 00001E45  add [bx+si],al
  db 0x00, 0x00                ; 00001E47  add [bx+si],al
  db 0x00, 0x00                ; 00001E49  add [bx+si],al
  db 0x00, 0x00                ; 00001E4B  add [bx+si],al
  db 0x00, 0x00                ; 00001E4D  add [bx+si],al
  db 0x00, 0x00                ; 00001E4F  add [bx+si],al
  db 0x00, 0x00                ; 00001E51  add [bx+si],al
  db 0x00, 0x00                ; 00001E53  add [bx+si],al
  db 0x00, 0x00                ; 00001E55  add [bx+si],al
  db 0x00, 0x00                ; 00001E57  add [bx+si],al
  db 0x00, 0x00                ; 00001E59  add [bx+si],al
  db 0x00, 0x00                ; 00001E5B  add [bx+si],al
  db 0x00, 0x00                ; 00001E5D  add [bx+si],al
  db 0x00, 0x00                ; 00001E5F  add [bx+si],al
  db 0x00, 0x00                ; 00001E61  add [bx+si],al
  db 0x00, 0x00                ; 00001E63  add [bx+si],al
  db 0x00, 0x00                ; 00001E65  add [bx+si],al
  db 0x00, 0x00                ; 00001E67  add [bx+si],al
  db 0x00, 0x00                ; 00001E69  add [bx+si],al
  db 0x00, 0x00                ; 00001E6B  add [bx+si],al
  db 0x00, 0x00                ; 00001E6D  add [bx+si],al
  db 0x00, 0x00                ; 00001E6F  add [bx+si],al
  db 0x00, 0x00                ; 00001E71  add [bx+si],al
  db 0x00, 0x00                ; 00001E73  add [bx+si],al
  db 0x00, 0x00                ; 00001E75  add [bx+si],al
  db 0x00, 0x00                ; 00001E77  add [bx+si],al
  db 0x00, 0x00                ; 00001E79  add [bx+si],al
  db 0x00, 0x00                ; 00001E7B  add [bx+si],al
  db 0x00, 0x00                ; 00001E7D  add [bx+si],al
  db 0x00, 0x00                ; 00001E7F  add [bx+si],al
  db 0x00, 0x00                ; 00001E81  add [bx+si],al
  db 0x00, 0x00                ; 00001E83  add [bx+si],al
  db 0x00, 0x00                ; 00001E85  add [bx+si],al
  db 0x00, 0x00                ; 00001E87  add [bx+si],al
  db 0x00, 0x00                ; 00001E89  add [bx+si],al
  db 0x00, 0x00                ; 00001E8B  add [bx+si],al
  db 0x00, 0x00                ; 00001E8D  add [bx+si],al
  db 0x00, 0x00                ; 00001E8F  add [bx+si],al
  db 0x00, 0x00                ; 00001E91  add [bx+si],al
  db 0x00, 0x00                ; 00001E93  add [bx+si],al
  db 0x00, 0x00                ; 00001E95  add [bx+si],al
  db 0x00, 0x00                ; 00001E97  add [bx+si],al
  db 0x00, 0x00                ; 00001E99  add [bx+si],al
  db 0x00, 0x00                ; 00001E9B  add [bx+si],al
  db 0x00, 0x00                ; 00001E9D  add [bx+si],al
  db 0x00, 0x00                ; 00001E9F  add [bx+si],al
  db 0x00, 0x00                ; 00001EA1  add [bx+si],al
  db 0x00, 0x00                ; 00001EA3  add [bx+si],al
  db 0x00, 0x00                ; 00001EA5  add [bx+si],al
  db 0x00, 0x00                ; 00001EA7  add [bx+si],al
  db 0x00, 0x00                ; 00001EA9  add [bx+si],al
  db 0x00, 0x00                ; 00001EAB  add [bx+si],al
  db 0x00, 0x00                ; 00001EAD  add [bx+si],al
  db 0x00, 0x00                ; 00001EAF  add [bx+si],al
  db 0x00, 0x00                ; 00001EB1  add [bx+si],al
  db 0x00, 0x00                ; 00001EB3  add [bx+si],al
  db 0x00, 0x00                ; 00001EB5  add [bx+si],al
  db 0x00, 0x00                ; 00001EB7  add [bx+si],al
  db 0x00, 0x00                ; 00001EB9  add [bx+si],al
  db 0x00, 0x00                ; 00001EBB  add [bx+si],al
  db 0x00, 0x00                ; 00001EBD  add [bx+si],al
  db 0x00, 0x00                ; 00001EBF  add [bx+si],al
  db 0x00, 0x00                ; 00001EC1  add [bx+si],al
  db 0x00, 0x00                ; 00001EC3  add [bx+si],al
  db 0x00, 0x00                ; 00001EC5  add [bx+si],al
  db 0x00, 0x00                ; 00001EC7  add [bx+si],al
  db 0x00, 0x00                ; 00001EC9  add [bx+si],al
  db 0x00, 0x00                ; 00001ECB  add [bx+si],al
  db 0x00, 0x00                ; 00001ECD  add [bx+si],al
  db 0x00, 0x00                ; 00001ECF  add [bx+si],al
  db 0x00, 0x00                ; 00001ED1  add [bx+si],al
  db 0x00, 0x00                ; 00001ED3  add [bx+si],al
  db 0x00, 0x00                ; 00001ED5  add [bx+si],al
  db 0x00, 0x00                ; 00001ED7  add [bx+si],al
  db 0x00, 0x00                ; 00001ED9  add [bx+si],al
  db 0x00, 0x00                ; 00001EDB  add [bx+si],al
  db 0x00, 0x00                ; 00001EDD  add [bx+si],al
  db 0x00, 0x00                ; 00001EDF  add [bx+si],al
  db 0x00, 0x00                ; 00001EE1  add [bx+si],al
  db 0x00, 0x00                ; 00001EE3  add [bx+si],al
  db 0x00, 0x00                ; 00001EE5  add [bx+si],al
  db 0x00, 0x00                ; 00001EE7  add [bx+si],al
  db 0x00, 0x00                ; 00001EE9  add [bx+si],al
  db 0x00, 0x00                ; 00001EEB  add [bx+si],al
  db 0x00, 0x00                ; 00001EED  add [bx+si],al
  db 0x00, 0x00                ; 00001EEF  add [bx+si],al
  db 0x00, 0x00                ; 00001EF1  add [bx+si],al
  db 0x00, 0x00                ; 00001EF3  add [bx+si],al
  db 0x00, 0x00                ; 00001EF5  add [bx+si],al
  db 0x00, 0x00                ; 00001EF7  add [bx+si],al
  db 0x00, 0x00                ; 00001EF9  add [bx+si],al
  db 0x00, 0x00                ; 00001EFB  add [bx+si],al
  db 0x00, 0x00                ; 00001EFD  add [bx+si],al
  db 0x00, 0x00                ; 00001EFF  add [bx+si],al
  db 0x00, 0x00                ; 00001F01  add [bx+si],al
  db 0x00, 0x00                ; 00001F03  add [bx+si],al
  db 0x00, 0x00                ; 00001F05  add [bx+si],al
  db 0x00, 0x00                ; 00001F07  add [bx+si],al
  db 0x00, 0x00                ; 00001F09  add [bx+si],al
  db 0x00, 0x00                ; 00001F0B  add [bx+si],al
  db 0x00, 0x00                ; 00001F0D  add [bx+si],al
  db 0x00, 0x00                ; 00001F0F  add [bx+si],al
  db 0x00, 0x00                ; 00001F11  add [bx+si],al
  db 0x00, 0x00                ; 00001F13  add [bx+si],al
  db 0x00, 0x00                ; 00001F15  add [bx+si],al
  db 0x00, 0x00                ; 00001F17  add [bx+si],al
  db 0x00, 0x00                ; 00001F19  add [bx+si],al
  db 0x00, 0x00                ; 00001F1B  add [bx+si],al
  db 0x00, 0x00                ; 00001F1D  add [bx+si],al
  db 0x00, 0x00                ; 00001F1F  add [bx+si],al
  db 0x00, 0x00                ; 00001F21  add [bx+si],al
  db 0x00, 0x00                ; 00001F23  add [bx+si],al
  db 0x00, 0x00                ; 00001F25  add [bx+si],al
  db 0x00, 0x00                ; 00001F27  add [bx+si],al
  db 0x00, 0x00                ; 00001F29  add [bx+si],al
  db 0x00, 0x00                ; 00001F2B  add [bx+si],al
  db 0x00, 0x00                ; 00001F2D  add [bx+si],al
  db 0x00, 0x00                ; 00001F2F  add [bx+si],al
  db 0x00, 0x00                ; 00001F31  add [bx+si],al
  db 0x00, 0x00                ; 00001F33  add [bx+si],al
  db 0x00, 0x00                ; 00001F35  add [bx+si],al
  db 0x00, 0x00                ; 00001F37  add [bx+si],al
  db 0x00, 0x00                ; 00001F39  add [bx+si],al
  db 0x00, 0x00                ; 00001F3B  add [bx+si],al
  db 0x00, 0x00                ; 00001F3D  add [bx+si],al
  db 0x00, 0x00                ; 00001F3F  add [bx+si],al
  db 0x00, 0x00                ; 00001F41  add [bx+si],al
  db 0x00, 0x00                ; 00001F43  add [bx+si],al
  db 0x00, 0x00                ; 00001F45  add [bx+si],al
  db 0x00, 0x00                ; 00001F47  add [bx+si],al
  db 0x00, 0x00                ; 00001F49  add [bx+si],al
  db 0x00, 0x00                ; 00001F4B  add [bx+si],al
  db 0x00, 0x00                ; 00001F4D  add [bx+si],al
  db 0x00, 0x00                ; 00001F4F  add [bx+si],al
  db 0x00, 0x00                ; 00001F51  add [bx+si],al
  db 0x00, 0x00                ; 00001F53  add [bx+si],al
  db 0x00, 0x00                ; 00001F55  add [bx+si],al
  db 0x00, 0x00                ; 00001F57  add [bx+si],al
  db 0x00, 0x00                ; 00001F59  add [bx+si],al
  db 0x00, 0x00                ; 00001F5B  add [bx+si],al
  db 0x00, 0x00                ; 00001F5D  add [bx+si],al
  db 0x00, 0x00                ; 00001F5F  add [bx+si],al
  db 0x00, 0x00                ; 00001F61  add [bx+si],al
  db 0x00, 0x00                ; 00001F63  add [bx+si],al
  db 0x00, 0x00                ; 00001F65  add [bx+si],al
  db 0x00, 0x00                ; 00001F67  add [bx+si],al
  db 0x00, 0x00                ; 00001F69  add [bx+si],al
  db 0x00, 0x00                ; 00001F6B  add [bx+si],al
  db 0x00, 0x00                ; 00001F6D  add [bx+si],al
  db 0x00, 0x00                ; 00001F6F  add [bx+si],al
  db 0x00, 0x00                ; 00001F71  add [bx+si],al
  db 0x00, 0x00                ; 00001F73  add [bx+si],al
  db 0x00, 0x00                ; 00001F75  add [bx+si],al
  db 0x00, 0x00                ; 00001F77  add [bx+si],al
  db 0x00, 0x00                ; 00001F79  add [bx+si],al
  db 0x00, 0x00                ; 00001F7B  add [bx+si],al
  db 0x00, 0x00                ; 00001F7D  add [bx+si],al
  db 0x00, 0x00                ; 00001F7F  add [bx+si],al
  db 0x00, 0x00                ; 00001F81  add [bx+si],al
  db 0x00, 0x00                ; 00001F83  add [bx+si],al
  db 0x00, 0x00                ; 00001F85  add [bx+si],al
  db 0x00, 0x00                ; 00001F87  add [bx+si],al
  db 0x00, 0x00                ; 00001F89  add [bx+si],al
  db 0x00, 0x00                ; 00001F8B  add [bx+si],al
  db 0x00, 0x00                ; 00001F8D  add [bx+si],al
  db 0x00, 0x00                ; 00001F8F  add [bx+si],al
  db 0x00, 0x00                ; 00001F91  add [bx+si],al
  db 0x00, 0x00                ; 00001F93  add [bx+si],al
  db 0x00, 0x00                ; 00001F95  add [bx+si],al
  db 0x00, 0x00                ; 00001F97  add [bx+si],al
  db 0x00, 0x00                ; 00001F99  add [bx+si],al
  db 0x00, 0x00                ; 00001F9B  add [bx+si],al
  db 0x00, 0x00                ; 00001F9D  add [bx+si],al
  db 0x00, 0x00                ; 00001F9F  add [bx+si],al
  db 0x00, 0x00                ; 00001FA1  add [bx+si],al
  db 0x00, 0x00                ; 00001FA3  add [bx+si],al
  db 0x00, 0x00                ; 00001FA5  add [bx+si],al
  db 0x00, 0x00                ; 00001FA7  add [bx+si],al
  db 0x00, 0x00                ; 00001FA9  add [bx+si],al
  db 0x00, 0x00                ; 00001FAB  add [bx+si],al
  db 0x00, 0x00                ; 00001FAD  add [bx+si],al
  db 0x00, 0x00                ; 00001FAF  add [bx+si],al
  db 0x00, 0x00                ; 00001FB1  add [bx+si],al
  db 0x00, 0x00                ; 00001FB3  add [bx+si],al
  db 0x00, 0x00                ; 00001FB5  add [bx+si],al
  db 0x00, 0x00                ; 00001FB7  add [bx+si],al
  db 0x00, 0x00                ; 00001FB9  add [bx+si],al
  db 0x00, 0x00                ; 00001FBB  add [bx+si],al
  db 0x00, 0x00                ; 00001FBD  add [bx+si],al
  db 0x00, 0x00                ; 00001FBF  add [bx+si],al
  db 0x00, 0x00                ; 00001FC1  add [bx+si],al
  db 0x00, 0x00                ; 00001FC3  add [bx+si],al
  db 0x00, 0x00                ; 00001FC5  add [bx+si],al
  db 0x00, 0x00                ; 00001FC7  add [bx+si],al
  db 0x00, 0x00                ; 00001FC9  add [bx+si],al
  db 0x00, 0x00                ; 00001FCB  add [bx+si],al
  db 0x00, 0x00                ; 00001FCD  add [bx+si],al
  db 0x00, 0x00                ; 00001FCF  add [bx+si],al
  db 0x00, 0x00                ; 00001FD1  add [bx+si],al
  db 0x00, 0x00                ; 00001FD3  add [bx+si],al
  db 0x00, 0x00                ; 00001FD5  add [bx+si],al
  db 0x00, 0x00                ; 00001FD7  add [bx+si],al
  db 0x00, 0x00                ; 00001FD9  add [bx+si],al
  db 0x00, 0x00                ; 00001FDB  add [bx+si],al
  db 0x00, 0x00                ; 00001FDD  add [bx+si],al
  db 0x00, 0x00                ; 00001FDF  add [bx+si],al
  db 0x00, 0x00                ; 00001FE1  add [bx+si],al
  db 0x00, 0x00                ; 00001FE3  add [bx+si],al
  db 0x00, 0x00                ; 00001FE5  add [bx+si],al
  db 0x00, 0x00                ; 00001FE7  add [bx+si],al
  db 0x00, 0x00                ; 00001FE9  add [bx+si],al
  db 0x00, 0x00                ; 00001FEB  add [bx+si],al
  db 0x00, 0x00                ; 00001FED  add [bx+si],al
  db 0x00, 0x00                ; 00001FEF  add [bx+si],al
  db 0x00, 0x00                ; 00001FF1  add [bx+si],al
  db 0x00, 0x00                ; 00001FF3  add [bx+si],al
  db 0x00, 0x00                ; 00001FF5  add [bx+si],al
  db 0x00, 0x00                ; 00001FF7  add [bx+si],al
  db 0x00, 0x00                ; 00001FF9  add [bx+si],al
  db 0x00, 0x00                ; 00001FFB  add [bx+si],al
  db 0x00, 0x00                ; 00001FFD  add [bx+si],al
  db 0x00, 0x00                ; 00001FFF  add [bx+si],al
  db 0x00, 0x00                ; 00002001  add [bx+si],al
  db 0x00, 0x00                ; 00002003  add [bx+si],al
  db 0x00, 0x00                ; 00002005  add [bx+si],al
  db 0x00, 0x00                ; 00002007  add [bx+si],al
  db 0x00, 0x00                ; 00002009  add [bx+si],al
  db 0x00, 0x00                ; 0000200B  add [bx+si],al
  db 0x00, 0x00                ; 0000200D  add [bx+si],al
  db 0x00, 0x00                ; 0000200F  add [bx+si],al
  db 0x00, 0x00                ; 00002011  add [bx+si],al
  db 0x00, 0x00                ; 00002013  add [bx+si],al
  db 0x00, 0x00                ; 00002015  add [bx+si],al
  db 0x00, 0x00                ; 00002017  add [bx+si],al
  db 0x00, 0x00                ; 00002019  add [bx+si],al
  db 0x00, 0x00                ; 0000201B  add [bx+si],al
  db 0x00, 0x00                ; 0000201D  add [bx+si],al
  db 0x00, 0x00                ; 0000201F  add [bx+si],al
  db 0x00, 0x00                ; 00002021  add [bx+si],al
  db 0x00, 0x00                ; 00002023  add [bx+si],al
  db 0x00, 0x00                ; 00002025  add [bx+si],al
  db 0x00, 0x00                ; 00002027  add [bx+si],al
  db 0x00, 0x00                ; 00002029  add [bx+si],al
  db 0x00, 0x00                ; 0000202B  add [bx+si],al
  db 0x00, 0x00                ; 0000202D  add [bx+si],al
  db 0x00, 0x00                ; 0000202F  add [bx+si],al
  db 0x00, 0x00                ; 00002031  add [bx+si],al
  db 0x00, 0x00                ; 00002033  add [bx+si],al
  db 0x00, 0x00                ; 00002035  add [bx+si],al
  db 0x00, 0x00                ; 00002037  add [bx+si],al
  db 0x00, 0x00                ; 00002039  add [bx+si],al
  db 0x00, 0x00                ; 0000203B  add [bx+si],al
  db 0x00, 0x00                ; 0000203D  add [bx+si],al
  db 0x00, 0x00                ; 0000203F  add [bx+si],al
  db 0x00, 0x00                ; 00002041  add [bx+si],al
  db 0x00, 0x00                ; 00002043  add [bx+si],al
  db 0x00, 0x00                ; 00002045  add [bx+si],al
  db 0x00, 0x00                ; 00002047  add [bx+si],al
  db 0x00, 0x00                ; 00002049  add [bx+si],al
  db 0x00, 0x00                ; 0000204B  add [bx+si],al
  db 0x00, 0x00                ; 0000204D  add [bx+si],al
  db 0x00, 0x00                ; 0000204F  add [bx+si],al
  db 0x00, 0x00                ; 00002051  add [bx+si],al
  db 0x00, 0x00                ; 00002053  add [bx+si],al
  db 0x00, 0x00                ; 00002055  add [bx+si],al
  db 0x00, 0x00                ; 00002057  add [bx+si],al
  db 0x00, 0x00                ; 00002059  add [bx+si],al
  db 0x00, 0x00                ; 0000205B  add [bx+si],al
  db 0x00, 0x00                ; 0000205D  add [bx+si],al
  db 0x00, 0x00                ; 0000205F  add [bx+si],al
  db 0x00, 0x00                ; 00002061  add [bx+si],al
  db 0x00, 0x00                ; 00002063  add [bx+si],al
  db 0x00, 0x00                ; 00002065  add [bx+si],al
  db 0x00, 0x00                ; 00002067  add [bx+si],al
  db 0x00, 0x00                ; 00002069  add [bx+si],al
  db 0x00, 0x00                ; 0000206B  add [bx+si],al
  db 0x00, 0x00                ; 0000206D  add [bx+si],al
  db 0x00, 0x00                ; 0000206F  add [bx+si],al
  db 0x00, 0x00                ; 00002071  add [bx+si],al
  db 0x00, 0x00                ; 00002073  add [bx+si],al
  db 0x00, 0x00                ; 00002075  add [bx+si],al
  db 0x00, 0x00                ; 00002077  add [bx+si],al
  db 0x00, 0x00                ; 00002079  add [bx+si],al
  db 0x00, 0x00                ; 0000207B  add [bx+si],al
  db 0x00, 0x00                ; 0000207D  add [bx+si],al
  db 0x00, 0x00                ; 0000207F  add [bx+si],al
  db 0x00, 0x00                ; 00002081  add [bx+si],al
  db 0x00, 0x00                ; 00002083  add [bx+si],al
  db 0x00, 0x00                ; 00002085  add [bx+si],al
  db 0x00, 0x00                ; 00002087  add [bx+si],al
  db 0x00, 0x00                ; 00002089  add [bx+si],al
  db 0x00, 0x00                ; 0000208B  add [bx+si],al
  db 0x00, 0x00                ; 0000208D  add [bx+si],al
  db 0x00, 0x00                ; 0000208F  add [bx+si],al
  db 0x00, 0x00                ; 00002091  add [bx+si],al
  db 0x00, 0x00                ; 00002093  add [bx+si],al
  db 0x00, 0x00                ; 00002095  add [bx+si],al
  db 0x00, 0x00                ; 00002097  add [bx+si],al
  db 0x00, 0x00                ; 00002099  add [bx+si],al
  db 0x00, 0x00                ; 0000209B  add [bx+si],al
  db 0x00, 0x00                ; 0000209D  add [bx+si],al
  db 0x00, 0x00                ; 0000209F  add [bx+si],al
  db 0x00, 0x00                ; 000020A1  add [bx+si],al
  db 0x00, 0x00                ; 000020A3  add [bx+si],al
  db 0x00, 0x00                ; 000020A5  add [bx+si],al
  db 0x00, 0x00                ; 000020A7  add [bx+si],al
  db 0x00, 0x00                ; 000020A9  add [bx+si],al
  db 0x00, 0x00                ; 000020AB  add [bx+si],al
  db 0x00, 0x00                ; 000020AD  add [bx+si],al
  db 0x00, 0x00                ; 000020AF  add [bx+si],al
  db 0x00, 0x00                ; 000020B1  add [bx+si],al
  db 0x00, 0x00                ; 000020B3  add [bx+si],al
  db 0x00, 0x00                ; 000020B5  add [bx+si],al
  db 0x00, 0x00                ; 000020B7  add [bx+si],al
  db 0x00, 0x00                ; 000020B9  add [bx+si],al
  db 0x00, 0x00                ; 000020BB  add [bx+si],al
  db 0x00, 0x00                ; 000020BD  add [bx+si],al
  db 0x00, 0x00                ; 000020BF  add [bx+si],al
  db 0x00, 0x00                ; 000020C1  add [bx+si],al
  db 0x00, 0x00                ; 000020C3  add [bx+si],al
  db 0x00, 0x00                ; 000020C5  add [bx+si],al
  db 0x00, 0x00                ; 000020C7  add [bx+si],al
  db 0x00, 0x00                ; 000020C9  add [bx+si],al
  db 0x00, 0x00                ; 000020CB  add [bx+si],al
  db 0x00, 0x00                ; 000020CD  add [bx+si],al
  db 0x00, 0x00                ; 000020CF  add [bx+si],al
  db 0x00, 0x00                ; 000020D1  add [bx+si],al
  db 0x00, 0x00                ; 000020D3  add [bx+si],al
  db 0x00, 0x00                ; 000020D5  add [bx+si],al
  db 0x00, 0x00                ; 000020D7  add [bx+si],al
  db 0x00, 0x00                ; 000020D9  add [bx+si],al
  db 0x00, 0x00                ; 000020DB  add [bx+si],al
  db 0x00, 0x00                ; 000020DD  add [bx+si],al
  db 0x00, 0x00                ; 000020DF  add [bx+si],al
  db 0x00, 0x00                ; 000020E1  add [bx+si],al
  db 0x00, 0x00                ; 000020E3  add [bx+si],al
  db 0x00, 0x00                ; 000020E5  add [bx+si],al
  db 0x00, 0x00                ; 000020E7  add [bx+si],al
  db 0x00, 0x00                ; 000020E9  add [bx+si],al
  db 0x00, 0x00                ; 000020EB  add [bx+si],al
  db 0x00, 0x00                ; 000020ED  add [bx+si],al
  db 0x00, 0x00                ; 000020EF  add [bx+si],al
  db 0x00, 0x00                ; 000020F1  add [bx+si],al
  db 0x00, 0x00                ; 000020F3  add [bx+si],al
  db 0x00, 0x00                ; 000020F5  add [bx+si],al
  db 0x00, 0x00                ; 000020F7  add [bx+si],al
  db 0x00, 0x00                ; 000020F9  add [bx+si],al
  db 0x00, 0x00                ; 000020FB  add [bx+si],al
  db 0x00, 0x00                ; 000020FD  add [bx+si],al
  db 0x00, 0x00                ; 000020FF  add [bx+si],al
  db 0x00, 0x00                ; 00002101  add [bx+si],al
  db 0x00, 0x00                ; 00002103  add [bx+si],al
  db 0x00, 0x00                ; 00002105  add [bx+si],al
  db 0x00, 0x00                ; 00002107  add [bx+si],al
  db 0x00, 0x00                ; 00002109  add [bx+si],al
  db 0x00, 0x00                ; 0000210B  add [bx+si],al
  db 0x00, 0x00                ; 0000210D  add [bx+si],al
  db 0x00, 0x00                ; 0000210F  add [bx+si],al
  db 0x00, 0x00                ; 00002111  add [bx+si],al
  db 0x00, 0x00                ; 00002113  add [bx+si],al
  db 0x00, 0x00                ; 00002115  add [bx+si],al
  db 0x00, 0x00                ; 00002117  add [bx+si],al
  db 0x00, 0x00                ; 00002119  add [bx+si],al
  db 0x00, 0x00                ; 0000211B  add [bx+si],al
  db 0x00, 0x00                ; 0000211D  add [bx+si],al
  db 0x00, 0x00                ; 0000211F  add [bx+si],al
  db 0x00, 0x00                ; 00002121  add [bx+si],al
  db 0x00, 0x00                ; 00002123  add [bx+si],al
  db 0x00, 0x00                ; 00002125  add [bx+si],al
  db 0x00, 0x00                ; 00002127  add [bx+si],al
  db 0x00, 0x00                ; 00002129  add [bx+si],al
  db 0x00, 0x00                ; 0000212B  add [bx+si],al
  db 0x00, 0x00                ; 0000212D  add [bx+si],al
  db 0x00, 0x00                ; 0000212F  add [bx+si],al
  db 0x00, 0x00                ; 00002131  add [bx+si],al
  db 0x00, 0x00                ; 00002133  add [bx+si],al
  db 0x00, 0x00                ; 00002135  add [bx+si],al
  db 0x00, 0x00                ; 00002137  add [bx+si],al
  db 0x00, 0x00                ; 00002139  add [bx+si],al
  db 0x00, 0x00                ; 0000213B  add [bx+si],al
  db 0x00, 0x00                ; 0000213D  add [bx+si],al
  db 0x00, 0x00                ; 0000213F  add [bx+si],al
  db 0x00, 0x00                ; 00002141  add [bx+si],al
  db 0x00, 0x00                ; 00002143  add [bx+si],al
  db 0x00, 0x00                ; 00002145  add [bx+si],al
  db 0x00, 0x00                ; 00002147  add [bx+si],al
  db 0x00, 0x00                ; 00002149  add [bx+si],al
  db 0x00, 0x00                ; 0000214B  add [bx+si],al
  db 0x00, 0x00                ; 0000214D  add [bx+si],al
  db 0x00, 0x00                ; 0000214F  add [bx+si],al
  db 0x00, 0x00                ; 00002151  add [bx+si],al
  db 0x00, 0x00                ; 00002153  add [bx+si],al
  db 0x00, 0x00                ; 00002155  add [bx+si],al
  db 0x00, 0x00                ; 00002157  add [bx+si],al
  db 0x00, 0x00                ; 00002159  add [bx+si],al
  db 0x00, 0x00                ; 0000215B  add [bx+si],al
  db 0x00, 0x00                ; 0000215D  add [bx+si],al
  db 0x00, 0x00                ; 0000215F  add [bx+si],al
  db 0x00, 0x00                ; 00002161  add [bx+si],al
  db 0x00, 0x00                ; 00002163  add [bx+si],al
  db 0x00, 0x00                ; 00002165  add [bx+si],al
  db 0x00, 0x00                ; 00002167  add [bx+si],al
  db 0x00, 0x00                ; 00002169  add [bx+si],al
  db 0x00, 0x00                ; 0000216B  add [bx+si],al
  db 0x00, 0x00                ; 0000216D  add [bx+si],al
  db 0x00, 0x00                ; 0000216F  add [bx+si],al
  db 0x00, 0x00                ; 00002171  add [bx+si],al
  db 0x00, 0x00                ; 00002173  add [bx+si],al
  db 0x00, 0x00                ; 00002175  add [bx+si],al
  db 0x00, 0x00                ; 00002177  add [bx+si],al
  db 0x00, 0x00                ; 00002179  add [bx+si],al
  db 0x00, 0x00                ; 0000217B  add [bx+si],al
  db 0x00, 0x00                ; 0000217D  add [bx+si],al
  db 0x00, 0x00                ; 0000217F  add [bx+si],al
  db 0x00, 0x00                ; 00002181  add [bx+si],al
  db 0x00, 0x00                ; 00002183  add [bx+si],al
  db 0x00, 0x00                ; 00002185  add [bx+si],al
  db 0x00, 0x00                ; 00002187  add [bx+si],al
  db 0x00, 0x00                ; 00002189  add [bx+si],al
  db 0x00, 0x00                ; 0000218B  add [bx+si],al
  db 0x00, 0x00                ; 0000218D  add [bx+si],al
  db 0x00, 0x00                ; 0000218F  add [bx+si],al
  db 0x00, 0x00                ; 00002191  add [bx+si],al
  db 0x00, 0x00                ; 00002193  add [bx+si],al
  db 0x00, 0x00                ; 00002195  add [bx+si],al
  db 0x00, 0x00                ; 00002197  add [bx+si],al
  db 0x00, 0x00                ; 00002199  add [bx+si],al
  db 0x00, 0x00                ; 0000219B  add [bx+si],al
  db 0x00, 0x00                ; 0000219D  add [bx+si],al
  db 0x00, 0x00                ; 0000219F  add [bx+si],al
  db 0x00, 0x00                ; 000021A1  add [bx+si],al
  db 0x00, 0x00                ; 000021A3  add [bx+si],al
  db 0x00, 0x00                ; 000021A5  add [bx+si],al
  db 0x00, 0x00                ; 000021A7  add [bx+si],al
  db 0x00, 0x00                ; 000021A9  add [bx+si],al
  db 0x00, 0x00                ; 000021AB  add [bx+si],al
  db 0x00, 0x00                ; 000021AD  add [bx+si],al
  db 0x00, 0x00                ; 000021AF  add [bx+si],al
  db 0x00, 0x00                ; 000021B1  add [bx+si],al
  db 0x00, 0x00                ; 000021B3  add [bx+si],al
  db 0x00, 0x00                ; 000021B5  add [bx+si],al
  db 0x00, 0x00                ; 000021B7  add [bx+si],al
  db 0x00, 0x00                ; 000021B9  add [bx+si],al
  db 0x00, 0x00                ; 000021BB  add [bx+si],al
  db 0x00, 0x00                ; 000021BD  add [bx+si],al
  db 0x00, 0x00                ; 000021BF  add [bx+si],al
  db 0x00, 0x00                ; 000021C1  add [bx+si],al
  db 0x00, 0x00                ; 000021C3  add [bx+si],al
  db 0x00, 0x00                ; 000021C5  add [bx+si],al
  db 0x00, 0x00                ; 000021C7  add [bx+si],al
  db 0x00, 0x00                ; 000021C9  add [bx+si],al
  db 0x00, 0x00                ; 000021CB  add [bx+si],al
  db 0x00, 0x00                ; 000021CD  add [bx+si],al
  db 0x00, 0x00                ; 000021CF  add [bx+si],al
  db 0x00, 0x00                ; 000021D1  add [bx+si],al
  db 0x00, 0x00                ; 000021D3  add [bx+si],al
  db 0x00, 0x00                ; 000021D5  add [bx+si],al
  db 0x00, 0x00                ; 000021D7  add [bx+si],al
  db 0x00, 0x00                ; 000021D9  add [bx+si],al
  db 0x00, 0x00                ; 000021DB  add [bx+si],al
  db 0x00, 0x00                ; 000021DD  add [bx+si],al
  db 0x00, 0x00                ; 000021DF  add [bx+si],al
  db 0x00, 0x00                ; 000021E1  add [bx+si],al
  db 0x00, 0x00                ; 000021E3  add [bx+si],al
  db 0x00, 0x00                ; 000021E5  add [bx+si],al
  db 0x00, 0x00                ; 000021E7  add [bx+si],al
  db 0x00, 0x00                ; 000021E9  add [bx+si],al
  db 0x00, 0x00                ; 000021EB  add [bx+si],al
  db 0x00, 0x00                ; 000021ED  add [bx+si],al
  db 0x00, 0x00                ; 000021EF  add [bx+si],al
  db 0x00, 0x00                ; 000021F1  add [bx+si],al
  db 0x00, 0x00                ; 000021F3  add [bx+si],al
  db 0x00, 0x00                ; 000021F5  add [bx+si],al
  db 0x00, 0x00                ; 000021F7  add [bx+si],al
  db 0x00, 0x00                ; 000021F9  add [bx+si],al
  db 0x00, 0x00                ; 000021FB  add [bx+si],al
  db 0x00, 0x00                ; 000021FD  add [bx+si],al
  db 0x00, 0x00                ; 000021FF  add [bx+si],al
  db 0x00, 0x00                ; 00002201  add [bx+si],al
  db 0x00, 0x00                ; 00002203  add [bx+si],al
  db 0x00, 0x00                ; 00002205  add [bx+si],al
  db 0x00, 0x00                ; 00002207  add [bx+si],al
  db 0x00, 0x00                ; 00002209  add [bx+si],al
  db 0x00, 0x00                ; 0000220B  add [bx+si],al
  db 0x00, 0x00                ; 0000220D  add [bx+si],al
  db 0x00, 0x00                ; 0000220F  add [bx+si],al
  db 0x00, 0x00                ; 00002211  add [bx+si],al
  db 0x00, 0x00                ; 00002213  add [bx+si],al
  db 0x00, 0x00                ; 00002215  add [bx+si],al
  db 0x00, 0x00                ; 00002217  add [bx+si],al
  db 0x00, 0x00                ; 00002219  add [bx+si],al
  db 0x00, 0x00                ; 0000221B  add [bx+si],al
  db 0x00, 0x00                ; 0000221D  add [bx+si],al
  db 0x00, 0x00                ; 0000221F  add [bx+si],al
  db 0x00, 0x00                ; 00002221  add [bx+si],al
  db 0x00, 0x00                ; 00002223  add [bx+si],al
  db 0x00, 0x00                ; 00002225  add [bx+si],al
  db 0x00, 0x00                ; 00002227  add [bx+si],al
  db 0x00, 0x00                ; 00002229  add [bx+si],al
  db 0x00, 0x00                ; 0000222B  add [bx+si],al
  db 0x00, 0x00                ; 0000222D  add [bx+si],al
  db 0x00, 0x00                ; 0000222F  add [bx+si],al
  db 0x00, 0x00                ; 00002231  add [bx+si],al
  db 0x00, 0x00                ; 00002233  add [bx+si],al
  db 0x00, 0x00                ; 00002235  add [bx+si],al
  db 0x00, 0x00                ; 00002237  add [bx+si],al
  db 0x00, 0x00                ; 00002239  add [bx+si],al
  db 0x00, 0x00                ; 0000223B  add [bx+si],al
  db 0x00, 0x00                ; 0000223D  add [bx+si],al
  db 0x00, 0x00                ; 0000223F  add [bx+si],al
  db 0x00, 0x00                ; 00002241  add [bx+si],al
  db 0x00, 0x00                ; 00002243  add [bx+si],al
  db 0x00, 0x00                ; 00002245  add [bx+si],al
  db 0x00, 0x00                ; 00002247  add [bx+si],al
  db 0x00, 0x00                ; 00002249  add [bx+si],al
  db 0x00, 0x00                ; 0000224B  add [bx+si],al
  db 0x00, 0x00                ; 0000224D  add [bx+si],al
  db 0x00, 0x00                ; 0000224F  add [bx+si],al
  db 0x00, 0x00                ; 00002251  add [bx+si],al
  db 0x00, 0x00                ; 00002253  add [bx+si],al
  db 0x00, 0x00                ; 00002255  add [bx+si],al
  db 0x00, 0x00                ; 00002257  add [bx+si],al
  db 0x00, 0x00                ; 00002259  add [bx+si],al
  db 0x00, 0x00                ; 0000225B  add [bx+si],al
  db 0x00, 0x00                ; 0000225D  add [bx+si],al
  db 0x00, 0x00                ; 0000225F  add [bx+si],al
  db 0x00, 0x00                ; 00002261  add [bx+si],al
  db 0x00, 0x00                ; 00002263  add [bx+si],al
  db 0x00, 0x00                ; 00002265  add [bx+si],al
  db 0x00, 0x00                ; 00002267  add [bx+si],al
  db 0x00, 0x00                ; 00002269  add [bx+si],al
  db 0x00, 0x00                ; 0000226B  add [bx+si],al
  db 0x00, 0x00                ; 0000226D  add [bx+si],al
  db 0x00, 0x00                ; 0000226F  add [bx+si],al
  db 0x00, 0x00                ; 00002271  add [bx+si],al
  db 0x00, 0x00                ; 00002273  add [bx+si],al
  db 0x00, 0x00                ; 00002275  add [bx+si],al
  db 0x00, 0x00                ; 00002277  add [bx+si],al
  db 0x00, 0x00                ; 00002279  add [bx+si],al
  db 0x00, 0x00                ; 0000227B  add [bx+si],al
  db 0x00, 0x00                ; 0000227D  add [bx+si],al
  db 0x00, 0x00                ; 0000227F  add [bx+si],al
  db 0x00, 0x00                ; 00002281  add [bx+si],al
  db 0x00, 0x00                ; 00002283  add [bx+si],al
  db 0x00, 0x00                ; 00002285  add [bx+si],al
  db 0x00, 0x00                ; 00002287  add [bx+si],al
  db 0x00, 0x00                ; 00002289  add [bx+si],al
  db 0x00, 0x00                ; 0000228B  add [bx+si],al
  db 0x00, 0x00                ; 0000228D  add [bx+si],al
  db 0x00, 0x00                ; 0000228F  add [bx+si],al
  db 0x00, 0x00                ; 00002291  add [bx+si],al
  db 0x00, 0x00                ; 00002293  add [bx+si],al
  db 0x00, 0x00                ; 00002295  add [bx+si],al
  db 0x00, 0x00                ; 00002297  add [bx+si],al
  db 0x00, 0x00                ; 00002299  add [bx+si],al
  db 0x00, 0x00                ; 0000229B  add [bx+si],al
  db 0x00, 0x00                ; 0000229D  add [bx+si],al
  db 0x00, 0x00                ; 0000229F  add [bx+si],al
  db 0x00, 0x00                ; 000022A1  add [bx+si],al
  db 0x00, 0x00                ; 000022A3  add [bx+si],al
  db 0x00, 0x00                ; 000022A5  add [bx+si],al
  db 0x00, 0x00                ; 000022A7  add [bx+si],al
  db 0x00, 0x00                ; 000022A9  add [bx+si],al
  db 0x00, 0x00                ; 000022AB  add [bx+si],al
  db 0x00, 0x00                ; 000022AD  add [bx+si],al
  db 0x00, 0x00                ; 000022AF  add [bx+si],al
  db 0x00, 0x00                ; 000022B1  add [bx+si],al
  db 0x00, 0x00                ; 000022B3  add [bx+si],al
  db 0x00, 0x00                ; 000022B5  add [bx+si],al
  db 0x00, 0x00                ; 000022B7  add [bx+si],al
  db 0x00, 0x00                ; 000022B9  add [bx+si],al
  db 0x00, 0x00                ; 000022BB  add [bx+si],al
  db 0x00, 0x00                ; 000022BD  add [bx+si],al
  db 0x00, 0x00                ; 000022BF  add [bx+si],al
  db 0x00, 0x00                ; 000022C1  add [bx+si],al
  db 0x00, 0x00                ; 000022C3  add [bx+si],al
  db 0x00, 0x00                ; 000022C5  add [bx+si],al
  db 0x00, 0x00                ; 000022C7  add [bx+si],al
  db 0x00, 0x00                ; 000022C9  add [bx+si],al
  db 0x00, 0x00                ; 000022CB  add [bx+si],al
  db 0x00, 0x00                ; 000022CD  add [bx+si],al
  db 0x00, 0x00                ; 000022CF  add [bx+si],al
  db 0x00, 0x00                ; 000022D1  add [bx+si],al
  db 0x00, 0x00                ; 000022D3  add [bx+si],al
  db 0x00, 0x00                ; 000022D5  add [bx+si],al
  db 0x00, 0x00                ; 000022D7  add [bx+si],al
  db 0x00, 0x00                ; 000022D9  add [bx+si],al
  db 0x00, 0x00                ; 000022DB  add [bx+si],al
  db 0x00, 0x00                ; 000022DD  add [bx+si],al
  db 0x00, 0x00                ; 000022DF  add [bx+si],al
  db 0x00, 0x00                ; 000022E1  add [bx+si],al
  db 0x00, 0x00                ; 000022E3  add [bx+si],al
  db 0x00, 0x00                ; 000022E5  add [bx+si],al
  db 0x00, 0x00                ; 000022E7  add [bx+si],al
  db 0x00, 0x00                ; 000022E9  add [bx+si],al
  db 0x00, 0x00                ; 000022EB  add [bx+si],al
  db 0x00, 0x00                ; 000022ED  add [bx+si],al
  db 0x00, 0x00                ; 000022EF  add [bx+si],al
  db 0x00, 0x00                ; 000022F1  add [bx+si],al
  db 0x00, 0x00                ; 000022F3  add [bx+si],al
  db 0x00, 0x00                ; 000022F5  add [bx+si],al
  db 0x00, 0x00                ; 000022F7  add [bx+si],al
  db 0x00, 0x00                ; 000022F9  add [bx+si],al
  db 0x00, 0x00                ; 000022FB  add [bx+si],al
  db 0x00, 0x00                ; 000022FD  add [bx+si],al
  db 0x00, 0x00                ; 000022FF  add [bx+si],al
  db 0x00, 0x00                ; 00002301  add [bx+si],al
  db 0x00, 0x00                ; 00002303  add [bx+si],al
  db 0x00, 0x00                ; 00002305  add [bx+si],al
  db 0x00, 0x00                ; 00002307  add [bx+si],al
  db 0x00, 0x00                ; 00002309  add [bx+si],al
  db 0x00, 0x00                ; 0000230B  add [bx+si],al
  db 0x00, 0x00                ; 0000230D  add [bx+si],al
  db 0x00, 0x00                ; 0000230F  add [bx+si],al
  db 0x00, 0x00                ; 00002311  add [bx+si],al
  db 0x00, 0x00                ; 00002313  add [bx+si],al
  db 0x00, 0x00                ; 00002315  add [bx+si],al
  db 0x00, 0x00                ; 00002317  add [bx+si],al
  db 0x00, 0x00                ; 00002319  add [bx+si],al
  db 0x00, 0x00                ; 0000231B  add [bx+si],al
  db 0x00, 0x00                ; 0000231D  add [bx+si],al
  db 0x00, 0x00                ; 0000231F  add [bx+si],al
  db 0x00, 0x00                ; 00002321  add [bx+si],al
  db 0x00, 0x00                ; 00002323  add [bx+si],al
  db 0x00, 0x00                ; 00002325  add [bx+si],al
  db 0x00, 0x00                ; 00002327  add [bx+si],al
  db 0x00, 0x00                ; 00002329  add [bx+si],al
  db 0x00, 0x00                ; 0000232B  add [bx+si],al
  db 0x00, 0x00                ; 0000232D  add [bx+si],al
  db 0x00, 0x00                ; 0000232F  add [bx+si],al
  db 0x00, 0x00                ; 00002331  add [bx+si],al
  db 0x00, 0x00                ; 00002333  add [bx+si],al
  db 0x00, 0x00                ; 00002335  add [bx+si],al
  db 0x00, 0x00                ; 00002337  add [bx+si],al
  db 0x00, 0x00                ; 00002339  add [bx+si],al
  db 0x00, 0x00                ; 0000233B  add [bx+si],al
  db 0x00, 0x00                ; 0000233D  add [bx+si],al
  db 0x00, 0x00                ; 0000233F  add [bx+si],al
  db 0x00, 0x00                ; 00002341  add [bx+si],al
  db 0x00, 0x00                ; 00002343  add [bx+si],al
  db 0x00, 0x00                ; 00002345  add [bx+si],al
  db 0x00, 0x00                ; 00002347  add [bx+si],al
  db 0x00, 0x00                ; 00002349  add [bx+si],al
  db 0x00, 0x00                ; 0000234B  add [bx+si],al
  db 0x00, 0x00                ; 0000234D  add [bx+si],al
  db 0x00, 0x00                ; 0000234F  add [bx+si],al
  db 0x00, 0x00                ; 00002351  add [bx+si],al
  db 0x00, 0x00                ; 00002353  add [bx+si],al
  db 0x00, 0x00                ; 00002355  add [bx+si],al
  db 0x00, 0x00                ; 00002357  add [bx+si],al
  db 0x00, 0x00                ; 00002359  add [bx+si],al
  db 0x00, 0x00                ; 0000235B  add [bx+si],al
  db 0x00, 0x00                ; 0000235D  add [bx+si],al
  db 0x00, 0x00                ; 0000235F  add [bx+si],al
  db 0x00, 0x00                ; 00002361  add [bx+si],al
  db 0x00, 0x00                ; 00002363  add [bx+si],al
  db 0x00, 0x00                ; 00002365  add [bx+si],al
  db 0x00, 0x00                ; 00002367  add [bx+si],al
  db 0x00, 0x00                ; 00002369  add [bx+si],al
  db 0x00, 0x00                ; 0000236B  add [bx+si],al
  db 0x00, 0x00                ; 0000236D  add [bx+si],al
  db 0x00, 0x00                ; 0000236F  add [bx+si],al
  db 0x00, 0x00                ; 00002371  add [bx+si],al
  db 0x00, 0x00                ; 00002373  add [bx+si],al
  db 0x00, 0x00                ; 00002375  add [bx+si],al
  db 0x00, 0x00                ; 00002377  add [bx+si],al
  db 0x00, 0x00                ; 00002379  add [bx+si],al
  db 0x00, 0x00                ; 0000237B  add [bx+si],al
  db 0x00, 0x00                ; 0000237D  add [bx+si],al
  db 0x00, 0x00                ; 0000237F  add [bx+si],al
  db 0x00, 0x00                ; 00002381  add [bx+si],al
  db 0x00, 0x00                ; 00002383  add [bx+si],al
  db 0x00, 0x00                ; 00002385  add [bx+si],al
  db 0x00, 0x00                ; 00002387  add [bx+si],al
  db 0x00, 0x00                ; 00002389  add [bx+si],al
  db 0x00, 0x00                ; 0000238B  add [bx+si],al
  db 0x00, 0x00                ; 0000238D  add [bx+si],al
  db 0x00, 0x00                ; 0000238F  add [bx+si],al
  db 0x00, 0x00                ; 00002391  add [bx+si],al
  db 0x00, 0x00                ; 00002393  add [bx+si],al
  db 0x00, 0x00                ; 00002395  add [bx+si],al
  db 0x00, 0x00                ; 00002397  add [bx+si],al
  db 0x00, 0x00                ; 00002399  add [bx+si],al
  db 0x00, 0x00                ; 0000239B  add [bx+si],al
  db 0x00, 0x00                ; 0000239D  add [bx+si],al
  db 0x00, 0x00                ; 0000239F  add [bx+si],al
  db 0x00, 0x00                ; 000023A1  add [bx+si],al
  db 0x00, 0x00                ; 000023A3  add [bx+si],al
  db 0x00, 0x00                ; 000023A5  add [bx+si],al
  db 0x00, 0x00                ; 000023A7  add [bx+si],al
  db 0x00, 0x00                ; 000023A9  add [bx+si],al
  db 0x00, 0x00                ; 000023AB  add [bx+si],al
  db 0x00, 0x00                ; 000023AD  add [bx+si],al
  db 0x00, 0x00                ; 000023AF  add [bx+si],al
  db 0x00, 0x00                ; 000023B1  add [bx+si],al
  db 0x00, 0x00                ; 000023B3  add [bx+si],al
  db 0x00, 0x00                ; 000023B5  add [bx+si],al
  db 0x00, 0x00                ; 000023B7  add [bx+si],al
  db 0x00, 0x00                ; 000023B9  add [bx+si],al
  db 0x00, 0x00                ; 000023BB  add [bx+si],al
  db 0x00, 0x00                ; 000023BD  add [bx+si],al
  db 0x00, 0x00                ; 000023BF  add [bx+si],al
  db 0x00, 0x00                ; 000023C1  add [bx+si],al
  db 0x00, 0x00                ; 000023C3  add [bx+si],al
  db 0x00, 0x00                ; 000023C5  add [bx+si],al
  db 0x00, 0x00                ; 000023C7  add [bx+si],al
  db 0x00, 0x00                ; 000023C9  add [bx+si],al
  db 0x00, 0x00                ; 000023CB  add [bx+si],al
  db 0x00, 0x00                ; 000023CD  add [bx+si],al
  db 0x00, 0x00                ; 000023CF  add [bx+si],al
  db 0x00, 0x00                ; 000023D1  add [bx+si],al
  db 0x00, 0x00                ; 000023D3  add [bx+si],al
  db 0x00, 0x00                ; 000023D5  add [bx+si],al
  db 0x00, 0x00                ; 000023D7  add [bx+si],al
  db 0x00, 0x00                ; 000023D9  add [bx+si],al
  db 0x00, 0x00                ; 000023DB  add [bx+si],al
  db 0x00, 0x00                ; 000023DD  add [bx+si],al
  db 0x00, 0x00                ; 000023DF  add [bx+si],al
  db 0x00, 0x00                ; 000023E1  add [bx+si],al
  db 0x00, 0x00                ; 000023E3  add [bx+si],al
  db 0x00, 0x00                ; 000023E5  add [bx+si],al
  db 0x00, 0x00                ; 000023E7  add [bx+si],al
  db 0x00, 0x00                ; 000023E9  add [bx+si],al
  db 0x00, 0x00                ; 000023EB  add [bx+si],al
  db 0x00, 0x00                ; 000023ED  add [bx+si],al
  db 0x00, 0x00                ; 000023EF  add [bx+si],al
  db 0x00, 0x00                ; 000023F1  add [bx+si],al
  db 0x00, 0x00                ; 000023F3  add [bx+si],al
  db 0x00, 0x00                ; 000023F5  add [bx+si],al
  db 0x00, 0x00                ; 000023F7  add [bx+si],al
  db 0x00, 0x00                ; 000023F9  add [bx+si],al
  db 0x00, 0x00                ; 000023FB  add [bx+si],al
  db 0x00, 0x00                ; 000023FD  add [bx+si],al
  db 0x00, 0x00                ; 000023FF  add [bx+si],al
  db 0x00, 0x00                ; 00002401  add [bx+si],al
  db 0x00, 0x00                ; 00002403  add [bx+si],al
  db 0x00, 0x00                ; 00002405  add [bx+si],al
  db 0x00, 0x00                ; 00002407  add [bx+si],al
  db 0x00, 0x00                ; 00002409  add [bx+si],al
  db 0x00, 0x00                ; 0000240B  add [bx+si],al
  db 0x00, 0x00                ; 0000240D  add [bx+si],al
  db 0x00, 0x00                ; 0000240F  add [bx+si],al
  db 0x00, 0x00                ; 00002411  add [bx+si],al
  db 0x00, 0x00                ; 00002413  add [bx+si],al
  db 0x00, 0x00                ; 00002415  add [bx+si],al
  db 0x00, 0x00                ; 00002417  add [bx+si],al
  db 0x00, 0x00                ; 00002419  add [bx+si],al
  db 0x00, 0x00                ; 0000241B  add [bx+si],al
  db 0x00, 0x00                ; 0000241D  add [bx+si],al
  db 0x00, 0x00                ; 0000241F  add [bx+si],al
  db 0x00, 0x00                ; 00002421  add [bx+si],al
  db 0x00, 0x00                ; 00002423  add [bx+si],al
  db 0x00, 0x00                ; 00002425  add [bx+si],al
  db 0x00, 0x00                ; 00002427  add [bx+si],al
  db 0x00, 0x00                ; 00002429  add [bx+si],al
  db 0x00, 0x00                ; 0000242B  add [bx+si],al
  db 0x00, 0x00                ; 0000242D  add [bx+si],al
  db 0x00, 0x00                ; 0000242F  add [bx+si],al
  db 0x00, 0x00                ; 00002431  add [bx+si],al
  db 0x00, 0x00                ; 00002433  add [bx+si],al
  db 0x00, 0x00                ; 00002435  add [bx+si],al
  db 0x00, 0x00                ; 00002437  add [bx+si],al
  db 0x00, 0x00                ; 00002439  add [bx+si],al
  db 0x00, 0x00                ; 0000243B  add [bx+si],al
  db 0x00, 0x00                ; 0000243D  add [bx+si],al
  db 0x00, 0x00                ; 0000243F  add [bx+si],al
  db 0x00, 0x00                ; 00002441  add [bx+si],al
  db 0x00, 0x00                ; 00002443  add [bx+si],al
  db 0x00, 0x00                ; 00002445  add [bx+si],al
  db 0x00, 0x00                ; 00002447  add [bx+si],al
  db 0x00, 0x00                ; 00002449  add [bx+si],al
  db 0x00, 0x00                ; 0000244B  add [bx+si],al
  db 0x00, 0x00                ; 0000244D  add [bx+si],al
  db 0x00, 0x00                ; 0000244F  add [bx+si],al
  db 0x00, 0x00                ; 00002451  add [bx+si],al
  db 0x00, 0x00                ; 00002453  add [bx+si],al
  db 0x00, 0x00                ; 00002455  add [bx+si],al
  db 0x00, 0x00                ; 00002457  add [bx+si],al
  db 0x00, 0x00                ; 00002459  add [bx+si],al
  db 0x00, 0x00                ; 0000245B  add [bx+si],al
  db 0x00, 0x00                ; 0000245D  add [bx+si],al
  db 0x00, 0x00                ; 0000245F  add [bx+si],al
  db 0x00, 0x00                ; 00002461  add [bx+si],al
  db 0x00, 0x00                ; 00002463  add [bx+si],al
  db 0x00, 0x00                ; 00002465  add [bx+si],al
  db 0x00, 0x00                ; 00002467  add [bx+si],al
  db 0x00, 0x00                ; 00002469  add [bx+si],al
  db 0x00, 0x00                ; 0000246B  add [bx+si],al
  db 0x00, 0x00                ; 0000246D  add [bx+si],al
  db 0x00, 0x00                ; 0000246F  add [bx+si],al
  db 0x00, 0x00                ; 00002471  add [bx+si],al
  db 0x00, 0x00                ; 00002473  add [bx+si],al
  db 0x00, 0x00                ; 00002475  add [bx+si],al
  db 0x00, 0x00                ; 00002477  add [bx+si],al
  db 0x00, 0x00                ; 00002479  add [bx+si],al
  db 0x00, 0x00                ; 0000247B  add [bx+si],al
  db 0x00, 0x00                ; 0000247D  add [bx+si],al
  db 0x00, 0x00                ; 0000247F  add [bx+si],al
  db 0x00, 0x00                ; 00002481  add [bx+si],al
  db 0x00, 0x00                ; 00002483  add [bx+si],al
  db 0x00, 0x00                ; 00002485  add [bx+si],al
  db 0x00, 0x00                ; 00002487  add [bx+si],al
  db 0x00, 0x00                ; 00002489  add [bx+si],al
  db 0x00, 0x00                ; 0000248B  add [bx+si],al
  db 0x00, 0x00                ; 0000248D  add [bx+si],al
  db 0x00, 0x00                ; 0000248F  add [bx+si],al
  db 0x00, 0x00                ; 00002491  add [bx+si],al
  db 0x00, 0x00                ; 00002493  add [bx+si],al
  db 0x00, 0x00                ; 00002495  add [bx+si],al
  db 0x00, 0x00                ; 00002497  add [bx+si],al
  db 0x00, 0x00                ; 00002499  add [bx+si],al
  db 0x00, 0x00                ; 0000249B  add [bx+si],al
  db 0x00, 0x00                ; 0000249D  add [bx+si],al
  db 0x00, 0x00                ; 0000249F  add [bx+si],al
  db 0x00, 0x00                ; 000024A1  add [bx+si],al
  db 0x00, 0x00                ; 000024A3  add [bx+si],al
  db 0x00, 0x00                ; 000024A5  add [bx+si],al
  db 0x00, 0x00                ; 000024A7  add [bx+si],al
  db 0x00, 0x00                ; 000024A9  add [bx+si],al
  db 0x00, 0x00                ; 000024AB  add [bx+si],al
  db 0x00, 0x00                ; 000024AD  add [bx+si],al
  db 0x00, 0x00                ; 000024AF  add [bx+si],al
  db 0x00, 0x00                ; 000024B1  add [bx+si],al
  db 0x00, 0x00                ; 000024B3  add [bx+si],al
  db 0x00, 0x00                ; 000024B5  add [bx+si],al
  db 0x00, 0x00                ; 000024B7  add [bx+si],al
  db 0x00, 0x00                ; 000024B9  add [bx+si],al
  db 0x00, 0x00                ; 000024BB  add [bx+si],al
  db 0x00, 0x00                ; 000024BD  add [bx+si],al
  db 0x00, 0x00                ; 000024BF  add [bx+si],al
  db 0x00, 0x00                ; 000024C1  add [bx+si],al
  db 0x00, 0x00                ; 000024C3  add [bx+si],al
  db 0x00, 0x00                ; 000024C5  add [bx+si],al
  db 0x00, 0x00                ; 000024C7  add [bx+si],al
  db 0x00, 0x00                ; 000024C9  add [bx+si],al
  db 0x00, 0x00                ; 000024CB  add [bx+si],al
  db 0x00, 0x00                ; 000024CD  add [bx+si],al
  db 0x00, 0x00                ; 000024CF  add [bx+si],al
  db 0x00, 0x00                ; 000024D1  add [bx+si],al
  db 0x00, 0x00                ; 000024D3  add [bx+si],al
  db 0x00, 0x00                ; 000024D5  add [bx+si],al
  db 0x00, 0x00                ; 000024D7  add [bx+si],al
  db 0x00, 0x00                ; 000024D9  add [bx+si],al
  db 0x00, 0x00                ; 000024DB  add [bx+si],al
  db 0x00, 0x00                ; 000024DD  add [bx+si],al
  db 0x00, 0x00                ; 000024DF  add [bx+si],al
  db 0x00, 0x00                ; 000024E1  add [bx+si],al
  db 0x00, 0x00                ; 000024E3  add [bx+si],al
  db 0x00, 0x00                ; 000024E5  add [bx+si],al
  db 0x00, 0x00                ; 000024E7  add [bx+si],al
  db 0x00, 0x00                ; 000024E9  add [bx+si],al
  db 0x00, 0x00                ; 000024EB  add [bx+si],al
  db 0x00, 0x00                ; 000024ED  add [bx+si],al
  db 0x00, 0x00                ; 000024EF  add [bx+si],al
  db 0x00, 0x00                ; 000024F1  add [bx+si],al
  db 0x00, 0x00                ; 000024F3  add [bx+si],al
  db 0x00, 0x00                ; 000024F5  add [bx+si],al
  db 0x00, 0x00                ; 000024F7  add [bx+si],al
  db 0x00, 0x00                ; 000024F9  add [bx+si],al
  db 0x00, 0x00                ; 000024FB  add [bx+si],al
  db 0x00, 0x00                ; 000024FD  add [bx+si],al
  db 0x00, 0x00                ; 000024FF  add [bx+si],al
  db 0x00, 0x00                ; 00002501  add [bx+si],al
  db 0x00, 0x00                ; 00002503  add [bx+si],al
  db 0x00, 0x00                ; 00002505  add [bx+si],al
  db 0x00, 0x00                ; 00002507  add [bx+si],al
  db 0x00, 0x00                ; 00002509  add [bx+si],al
  db 0x00, 0x00                ; 0000250B  add [bx+si],al
  db 0x00, 0x00                ; 0000250D  add [bx+si],al
  db 0x00, 0x00                ; 0000250F  add [bx+si],al
  db 0x00, 0x00                ; 00002511  add [bx+si],al
  db 0x00, 0x00                ; 00002513  add [bx+si],al
  db 0x00, 0x00                ; 00002515  add [bx+si],al
  db 0x00, 0x00                ; 00002517  add [bx+si],al
  db 0x00, 0x00                ; 00002519  add [bx+si],al
  db 0x00, 0x00                ; 0000251B  add [bx+si],al
  db 0x00, 0x00                ; 0000251D  add [bx+si],al
  db 0x00, 0x00                ; 0000251F  add [bx+si],al
  db 0x00, 0x00                ; 00002521  add [bx+si],al
  db 0x00, 0x00                ; 00002523  add [bx+si],al
  db 0x00, 0x00                ; 00002525  add [bx+si],al
  db 0x00, 0x00                ; 00002527  add [bx+si],al
  db 0x00, 0x00                ; 00002529  add [bx+si],al
  db 0x00, 0x00                ; 0000252B  add [bx+si],al
  db 0x00, 0x00                ; 0000252D  add [bx+si],al
  db 0x00, 0x00                ; 0000252F  add [bx+si],al
  db 0x00, 0x00                ; 00002531  add [bx+si],al
  db 0x00, 0x00                ; 00002533  add [bx+si],al
  db 0x00, 0x00                ; 00002535  add [bx+si],al
  db 0x00, 0x00                ; 00002537  add [bx+si],al
  db 0x00, 0x00                ; 00002539  add [bx+si],al
  db 0x00, 0x00                ; 0000253B  add [bx+si],al
  db 0x00, 0x00                ; 0000253D  add [bx+si],al
  db 0x00, 0x00                ; 0000253F  add [bx+si],al
  db 0x00, 0x00                ; 00002541  add [bx+si],al
  db 0x00, 0x00                ; 00002543  add [bx+si],al
  db 0x00, 0x00                ; 00002545  add [bx+si],al
  db 0x00, 0x00                ; 00002547  add [bx+si],al
  db 0x00, 0x00                ; 00002549  add [bx+si],al
  db 0x00, 0x00                ; 0000254B  add [bx+si],al
  db 0x00, 0x00                ; 0000254D  add [bx+si],al
  db 0x00, 0x00                ; 0000254F  add [bx+si],al
  db 0x00, 0x00                ; 00002551  add [bx+si],al
  db 0x00, 0x00                ; 00002553  add [bx+si],al
  db 0x00, 0x00                ; 00002555  add [bx+si],al
  db 0x00, 0x00                ; 00002557  add [bx+si],al
  db 0x00, 0x00                ; 00002559  add [bx+si],al
  db 0x00, 0x00                ; 0000255B  add [bx+si],al
  db 0x00, 0x00                ; 0000255D  add [bx+si],al
  db 0x00, 0x00                ; 0000255F  add [bx+si],al
  db 0x00, 0x00                ; 00002561  add [bx+si],al
  db 0x00, 0x00                ; 00002563  add [bx+si],al
  db 0x00, 0x00                ; 00002565  add [bx+si],al
  db 0x00, 0x00                ; 00002567  add [bx+si],al
  db 0x00, 0x00                ; 00002569  add [bx+si],al
  db 0x00, 0x00                ; 0000256B  add [bx+si],al
  db 0x00, 0x00                ; 0000256D  add [bx+si],al
  db 0x00, 0x00                ; 0000256F  add [bx+si],al
  db 0x00, 0x00                ; 00002571  add [bx+si],al
  db 0x00, 0x00                ; 00002573  add [bx+si],al
  db 0x00, 0x00                ; 00002575  add [bx+si],al
  db 0x00, 0x00                ; 00002577  add [bx+si],al
  db 0x00, 0x00                ; 00002579  add [bx+si],al
  db 0x00, 0x00                ; 0000257B  add [bx+si],al
  db 0x00, 0x00                ; 0000257D  add [bx+si],al
  db 0x00, 0x00                ; 0000257F  add [bx+si],al
  db 0x00, 0x00                ; 00002581  add [bx+si],al
  db 0x00, 0x00                ; 00002583  add [bx+si],al
  db 0x00, 0x00                ; 00002585  add [bx+si],al
  db 0x00, 0x00                ; 00002587  add [bx+si],al
  db 0x00, 0x00                ; 00002589  add [bx+si],al
  db 0x00, 0x00                ; 0000258B  add [bx+si],al
  db 0x00, 0x00                ; 0000258D  add [bx+si],al
  db 0x00, 0x00                ; 0000258F  add [bx+si],al
  db 0x00, 0x00                ; 00002591  add [bx+si],al
  db 0x00, 0x00                ; 00002593  add [bx+si],al
  db 0x00, 0x00                ; 00002595  add [bx+si],al
  db 0x00, 0x00                ; 00002597  add [bx+si],al
  db 0x00, 0x00                ; 00002599  add [bx+si],al
  db 0x00, 0x00                ; 0000259B  add [bx+si],al
  db 0x00, 0x00                ; 0000259D  add [bx+si],al
  db 0x00, 0x00                ; 0000259F  add [bx+si],al
  db 0x00, 0x00                ; 000025A1  add [bx+si],al
  db 0x00, 0x00                ; 000025A3  add [bx+si],al
  db 0x00, 0x00                ; 000025A5  add [bx+si],al
  db 0x00, 0x00                ; 000025A7  add [bx+si],al
  db 0x00, 0x00                ; 000025A9  add [bx+si],al
  db 0x00, 0x00                ; 000025AB  add [bx+si],al
  db 0x00, 0x00                ; 000025AD  add [bx+si],al
  db 0x00, 0x00                ; 000025AF  add [bx+si],al
  db 0x00, 0x00                ; 000025B1  add [bx+si],al
  db 0x00, 0x00                ; 000025B3  add [bx+si],al
  db 0x00, 0x00                ; 000025B5  add [bx+si],al
  db 0x00, 0x00                ; 000025B7  add [bx+si],al
  db 0x00, 0x00                ; 000025B9  add [bx+si],al
  db 0x00, 0x00                ; 000025BB  add [bx+si],al
  db 0x00, 0x00                ; 000025BD  add [bx+si],al
  db 0x00, 0x00                ; 000025BF  add [bx+si],al
  db 0x00, 0x00                ; 000025C1  add [bx+si],al
  db 0x00, 0x00                ; 000025C3  add [bx+si],al
  db 0x00, 0x00                ; 000025C5  add [bx+si],al
  db 0x00, 0x00                ; 000025C7  add [bx+si],al
  db 0x00, 0x00                ; 000025C9  add [bx+si],al
  db 0x00, 0x00                ; 000025CB  add [bx+si],al
  db 0x00, 0x00                ; 000025CD  add [bx+si],al
  db 0x00, 0x00                ; 000025CF  add [bx+si],al
  db 0x00, 0x00                ; 000025D1  add [bx+si],al
  db 0x00, 0x00                ; 000025D3  add [bx+si],al
  db 0x00, 0x00                ; 000025D5  add [bx+si],al
  db 0x00, 0x00                ; 000025D7  add [bx+si],al
  db 0x00, 0x00                ; 000025D9  add [bx+si],al
  db 0x00, 0x00                ; 000025DB  add [bx+si],al
  db 0x00, 0x00                ; 000025DD  add [bx+si],al
  db 0x00, 0x00                ; 000025DF  add [bx+si],al
  db 0x00, 0x00                ; 000025E1  add [bx+si],al
  db 0x00, 0x00                ; 000025E3  add [bx+si],al
  db 0x00, 0x00                ; 000025E5  add [bx+si],al
  db 0x00, 0x00                ; 000025E7  add [bx+si],al
  db 0x00, 0x00                ; 000025E9  add [bx+si],al
  db 0x00, 0x00                ; 000025EB  add [bx+si],al
  db 0x00, 0x00                ; 000025ED  add [bx+si],al
  db 0x00, 0x00                ; 000025EF  add [bx+si],al
  db 0x00, 0x00                ; 000025F1  add [bx+si],al
  db 0x00, 0x00                ; 000025F3  add [bx+si],al
  db 0x00, 0x00                ; 000025F5  add [bx+si],al
  db 0x00, 0x00                ; 000025F7  add [bx+si],al
  db 0x00, 0x00                ; 000025F9  add [bx+si],al
  db 0x00, 0x00                ; 000025FB  add [bx+si],al
  db 0x00, 0x00                ; 000025FD  add [bx+si],al
  db 0x00, 0x00                ; 000025FF  add [bx+si],al
  db 0x00, 0x00                ; 00002601  add [bx+si],al
  db 0x00, 0x00                ; 00002603  add [bx+si],al
  db 0x00, 0x00                ; 00002605  add [bx+si],al
  db 0x00, 0x00                ; 00002607  add [bx+si],al
  db 0x00, 0x00                ; 00002609  add [bx+si],al
  db 0x00, 0x00                ; 0000260B  add [bx+si],al
  db 0x00, 0x00                ; 0000260D  add [bx+si],al
  db 0x00, 0x00                ; 0000260F  add [bx+si],al
  db 0x00, 0x00                ; 00002611  add [bx+si],al
  db 0x00, 0x00                ; 00002613  add [bx+si],al
  db 0x00, 0x00                ; 00002615  add [bx+si],al
  db 0x00, 0x00                ; 00002617  add [bx+si],al
  db 0x00, 0x00                ; 00002619  add [bx+si],al
  db 0x00, 0x00                ; 0000261B  add [bx+si],al
  db 0x00, 0x00                ; 0000261D  add [bx+si],al
  db 0x00, 0x00                ; 0000261F  add [bx+si],al
  db 0x00, 0x00                ; 00002621  add [bx+si],al
  db 0x00, 0x00                ; 00002623  add [bx+si],al
  db 0x00, 0x00                ; 00002625  add [bx+si],al
  db 0x00, 0x00                ; 00002627  add [bx+si],al
  db 0x00, 0x00                ; 00002629  add [bx+si],al
  db 0x00, 0x00                ; 0000262B  add [bx+si],al
  db 0x00, 0x00                ; 0000262D  add [bx+si],al
  db 0x00, 0x00                ; 0000262F  add [bx+si],al
  db 0x00, 0x00                ; 00002631  add [bx+si],al
  db 0x00, 0x00                ; 00002633  add [bx+si],al
  db 0x00, 0x00                ; 00002635  add [bx+si],al
  db 0x00, 0x00                ; 00002637  add [bx+si],al
  db 0x00, 0x00                ; 00002639  add [bx+si],al
  db 0x00, 0x00                ; 0000263B  add [bx+si],al
  db 0x00, 0x00                ; 0000263D  add [bx+si],al
  db 0x00, 0x00                ; 0000263F  add [bx+si],al
  db 0x00, 0x00                ; 00002641  add [bx+si],al
  db 0x00, 0x00                ; 00002643  add [bx+si],al
  db 0x00, 0x00                ; 00002645  add [bx+si],al
  db 0x00, 0x00                ; 00002647  add [bx+si],al
  db 0x00, 0x00                ; 00002649  add [bx+si],al
  db 0x00, 0x00                ; 0000264B  add [bx+si],al
  db 0x00, 0x00                ; 0000264D  add [bx+si],al
  db 0x00, 0x00                ; 0000264F  add [bx+si],al
  db 0x00, 0x00                ; 00002651  add [bx+si],al
  db 0x00, 0x00                ; 00002653  add [bx+si],al
  db 0x00, 0x00                ; 00002655  add [bx+si],al
  db 0x00, 0x00                ; 00002657  add [bx+si],al
  db 0x00, 0x00                ; 00002659  add [bx+si],al
  db 0x00, 0x00                ; 0000265B  add [bx+si],al
  db 0x00, 0x00                ; 0000265D  add [bx+si],al
  db 0x00, 0x00                ; 0000265F  add [bx+si],al
  db 0x00, 0x00                ; 00002661  add [bx+si],al
  db 0x00, 0x00                ; 00002663  add [bx+si],al
  db 0x00, 0x00                ; 00002665  add [bx+si],al
  db 0x00, 0x00                ; 00002667  add [bx+si],al
  db 0x00, 0x00                ; 00002669  add [bx+si],al
  db 0x00, 0x00                ; 0000266B  add [bx+si],al
  db 0x00, 0x00                ; 0000266D  add [bx+si],al
  db 0x00, 0x00                ; 0000266F  add [bx+si],al
  db 0x00, 0x00                ; 00002671  add [bx+si],al
  db 0x00, 0x00                ; 00002673  add [bx+si],al
  db 0x00, 0x00                ; 00002675  add [bx+si],al
  db 0x00, 0x00                ; 00002677  add [bx+si],al
  db 0x00, 0x00                ; 00002679  add [bx+si],al
  db 0x00, 0x00                ; 0000267B  add [bx+si],al
  db 0x00, 0x00                ; 0000267D  add [bx+si],al
  db 0x00, 0x00                ; 0000267F  add [bx+si],al
  db 0x00, 0x00                ; 00002681  add [bx+si],al
  db 0x00, 0x00                ; 00002683  add [bx+si],al
  db 0x00, 0x00                ; 00002685  add [bx+si],al
  db 0x00, 0x00                ; 00002687  add [bx+si],al
  db 0x00, 0x00                ; 00002689  add [bx+si],al
  db 0x00, 0x00                ; 0000268B  add [bx+si],al
  db 0x00, 0x00                ; 0000268D  add [bx+si],al
  db 0x00, 0x00                ; 0000268F  add [bx+si],al
  db 0x00, 0x00                ; 00002691  add [bx+si],al
  db 0x00, 0x00                ; 00002693  add [bx+si],al
  db 0x00, 0x00                ; 00002695  add [bx+si],al
  db 0x00, 0x00                ; 00002697  add [bx+si],al
  db 0x00, 0x00                ; 00002699  add [bx+si],al
  db 0x00, 0x00                ; 0000269B  add [bx+si],al
  db 0x00, 0x00                ; 0000269D  add [bx+si],al
  db 0x00, 0x00                ; 0000269F  add [bx+si],al
  db 0x00, 0x00                ; 000026A1  add [bx+si],al
  db 0x00, 0x00                ; 000026A3  add [bx+si],al
  db 0x00, 0x00                ; 000026A5  add [bx+si],al
  db 0x00, 0x00                ; 000026A7  add [bx+si],al
  db 0x00, 0x00                ; 000026A9  add [bx+si],al
  db 0x00, 0x00                ; 000026AB  add [bx+si],al
  db 0x00, 0x00                ; 000026AD  add [bx+si],al
  db 0x00, 0x00                ; 000026AF  add [bx+si],al
  db 0x00, 0x00                ; 000026B1  add [bx+si],al
  db 0x00, 0x00                ; 000026B3  add [bx+si],al
  db 0x00, 0x00                ; 000026B5  add [bx+si],al
  db 0x00, 0x00                ; 000026B7  add [bx+si],al
  db 0x00, 0x00                ; 000026B9  add [bx+si],al
  db 0x00, 0x00                ; 000026BB  add [bx+si],al
  db 0x00, 0x00                ; 000026BD  add [bx+si],al
  db 0x00, 0x00                ; 000026BF  add [bx+si],al
  db 0x00, 0x00                ; 000026C1  add [bx+si],al
  db 0x00, 0x00                ; 000026C3  add [bx+si],al
  db 0x00, 0x00                ; 000026C5  add [bx+si],al
  db 0x00, 0x00                ; 000026C7  add [bx+si],al
  db 0x00, 0x00                ; 000026C9  add [bx+si],al
  db 0x00, 0x00                ; 000026CB  add [bx+si],al
  db 0x00, 0x00                ; 000026CD  add [bx+si],al
  db 0x00, 0x00                ; 000026CF  add [bx+si],al
  db 0x00, 0x00                ; 000026D1  add [bx+si],al
  db 0x00, 0x00                ; 000026D3  add [bx+si],al
  db 0x00, 0x00                ; 000026D5  add [bx+si],al
  db 0x00, 0x00                ; 000026D7  add [bx+si],al
  db 0x00, 0x00                ; 000026D9  add [bx+si],al
  db 0x00, 0x00                ; 000026DB  add [bx+si],al
  db 0x00, 0x00                ; 000026DD  add [bx+si],al
  db 0x00, 0x00                ; 000026DF  add [bx+si],al
  db 0x00, 0x00                ; 000026E1  add [bx+si],al
  db 0x00, 0x00                ; 000026E3  add [bx+si],al
  db 0x00, 0x00                ; 000026E5  add [bx+si],al
  db 0x00, 0x00                ; 000026E7  add [bx+si],al
  db 0x00, 0x00                ; 000026E9  add [bx+si],al
  db 0x00, 0x00                ; 000026EB  add [bx+si],al
  db 0x00, 0x00                ; 000026ED  add [bx+si],al
  db 0x00, 0x00                ; 000026EF  add [bx+si],al
  db 0x00, 0x00                ; 000026F1  add [bx+si],al
  db 0x00, 0x00                ; 000026F3  add [bx+si],al
  db 0x00, 0x00                ; 000026F5  add [bx+si],al
  db 0x00, 0x00                ; 000026F7  add [bx+si],al
  db 0x00, 0x00                ; 000026F9  add [bx+si],al
  db 0x00, 0x00                ; 000026FB  add [bx+si],al
  db 0x00, 0x00                ; 000026FD  add [bx+si],al
  db 0x00, 0x00                ; 000026FF  add [bx+si],al
  db 0x00, 0x00                ; 00002701  add [bx+si],al
  db 0x00, 0x00                ; 00002703  add [bx+si],al
  db 0x00, 0x00                ; 00002705  add [bx+si],al
  db 0x00, 0x00                ; 00002707  add [bx+si],al
  db 0x00, 0x00                ; 00002709  add [bx+si],al
  db 0x00, 0x00                ; 0000270B  add [bx+si],al
  db 0x00, 0x00                ; 0000270D  add [bx+si],al
  db 0x00, 0x00                ; 0000270F  add [bx+si],al
  db 0x00, 0x00                ; 00002711  add [bx+si],al
  db 0x00, 0x00                ; 00002713  add [bx+si],al
  db 0x00, 0x00                ; 00002715  add [bx+si],al
  db 0x00, 0x00                ; 00002717  add [bx+si],al
  db 0x00, 0x00                ; 00002719  add [bx+si],al
  db 0x00, 0x00                ; 0000271B  add [bx+si],al
  db 0x00, 0x00                ; 0000271D  add [bx+si],al
  db 0x00, 0x00                ; 0000271F  add [bx+si],al
  db 0x00, 0x00                ; 00002721  add [bx+si],al
  db 0x00, 0x00                ; 00002723  add [bx+si],al
  db 0x00, 0x00                ; 00002725  add [bx+si],al
  db 0x00, 0x00                ; 00002727  add [bx+si],al
  db 0x00, 0x00                ; 00002729  add [bx+si],al
  db 0x00, 0x00                ; 0000272B  add [bx+si],al
  db 0x00, 0x00                ; 0000272D  add [bx+si],al
  db 0x00, 0x00                ; 0000272F  add [bx+si],al
  db 0x00, 0x00                ; 00002731  add [bx+si],al
  db 0x00, 0x00                ; 00002733  add [bx+si],al
  db 0x00, 0x00                ; 00002735  add [bx+si],al
  db 0x00, 0x00                ; 00002737  add [bx+si],al
  db 0x00, 0x00                ; 00002739  add [bx+si],al
  db 0x00, 0x00                ; 0000273B  add [bx+si],al
  db 0x00, 0x00                ; 0000273D  add [bx+si],al
  db 0x00, 0x00                ; 0000273F  add [bx+si],al
  db 0x00, 0x00                ; 00002741  add [bx+si],al
  db 0x00, 0x00                ; 00002743  add [bx+si],al
  db 0x00, 0x00                ; 00002745  add [bx+si],al
  db 0x00, 0x00                ; 00002747  add [bx+si],al
  db 0x00, 0x00                ; 00002749  add [bx+si],al
  db 0x00, 0x00                ; 0000274B  add [bx+si],al
  db 0x00, 0x00                ; 0000274D  add [bx+si],al
  db 0x00, 0x00                ; 0000274F  add [bx+si],al
  db 0x00, 0x00                ; 00002751  add [bx+si],al
  db 0x00, 0x00                ; 00002753  add [bx+si],al
  db 0x00, 0x00                ; 00002755  add [bx+si],al
  db 0x00, 0x00                ; 00002757  add [bx+si],al
  db 0x00, 0x00                ; 00002759  add [bx+si],al
  db 0x00, 0x00                ; 0000275B  add [bx+si],al
  db 0x00, 0x00                ; 0000275D  add [bx+si],al
  db 0x00, 0x00                ; 0000275F  add [bx+si],al
  db 0x00, 0x00                ; 00002761  add [bx+si],al
  db 0x00, 0x00                ; 00002763  add [bx+si],al
  db 0x00, 0x00                ; 00002765  add [bx+si],al
  db 0x00, 0x00                ; 00002767  add [bx+si],al
  db 0x00, 0x00                ; 00002769  add [bx+si],al
  db 0x00, 0x00                ; 0000276B  add [bx+si],al
  db 0x00, 0x00                ; 0000276D  add [bx+si],al
  db 0x00, 0x00                ; 0000276F  add [bx+si],al
  db 0x00, 0x00                ; 00002771  add [bx+si],al
  db 0x00, 0x00                ; 00002773  add [bx+si],al
  db 0x00, 0x00                ; 00002775  add [bx+si],al
  db 0x00, 0x00                ; 00002777  add [bx+si],al
  db 0x00, 0x00                ; 00002779  add [bx+si],al
  db 0x00, 0x00                ; 0000277B  add [bx+si],al
  db 0x00, 0x00                ; 0000277D  add [bx+si],al
  db 0x00, 0x00                ; 0000277F  add [bx+si],al
  db 0x00, 0x00                ; 00002781  add [bx+si],al
  db 0x00, 0x00                ; 00002783  add [bx+si],al
  db 0x00, 0x00                ; 00002785  add [bx+si],al
  db 0x00, 0x00                ; 00002787  add [bx+si],al
  db 0x00, 0x00                ; 00002789  add [bx+si],al
  db 0x00, 0x00                ; 0000278B  add [bx+si],al
  db 0x00, 0x00                ; 0000278D  add [bx+si],al
  db 0x00, 0x00                ; 0000278F  add [bx+si],al
  db 0x00, 0x00                ; 00002791  add [bx+si],al
  db 0x00, 0x00                ; 00002793  add [bx+si],al
  db 0x00, 0x00                ; 00002795  add [bx+si],al
  db 0x00, 0x00                ; 00002797  add [bx+si],al
  db 0x00, 0x00                ; 00002799  add [bx+si],al
  db 0x00, 0x00                ; 0000279B  add [bx+si],al
  db 0x00, 0x00                ; 0000279D  add [bx+si],al
  db 0x00, 0x00                ; 0000279F  add [bx+si],al
  db 0x00, 0x00                ; 000027A1  add [bx+si],al
  db 0x00, 0x00                ; 000027A3  add [bx+si],al
  db 0x00, 0x00                ; 000027A5  add [bx+si],al
  db 0x00, 0x00                ; 000027A7  add [bx+si],al
  db 0x00, 0x00                ; 000027A9  add [bx+si],al
  db 0x00, 0x00                ; 000027AB  add [bx+si],al
  db 0x00, 0x00                ; 000027AD  add [bx+si],al
  db 0x00, 0x00                ; 000027AF  add [bx+si],al
  db 0x00, 0x00                ; 000027B1  add [bx+si],al
  db 0x00, 0x00                ; 000027B3  add [bx+si],al
  db 0x00, 0x00                ; 000027B5  add [bx+si],al
  db 0x00, 0x00                ; 000027B7  add [bx+si],al
  db 0x00, 0x00                ; 000027B9  add [bx+si],al
  db 0x00, 0x00                ; 000027BB  add [bx+si],al
  db 0x00, 0x00                ; 000027BD  add [bx+si],al
  db 0x00, 0x00                ; 000027BF  add [bx+si],al
  db 0x00, 0x00                ; 000027C1  add [bx+si],al
  db 0x00, 0x00                ; 000027C3  add [bx+si],al
  db 0x00, 0x00                ; 000027C5  add [bx+si],al
  db 0x00, 0x00                ; 000027C7  add [bx+si],al
  db 0x00, 0x00                ; 000027C9  add [bx+si],al
  db 0x00, 0x00                ; 000027CB  add [bx+si],al
  db 0x00, 0x00                ; 000027CD  add [bx+si],al
  db 0x00, 0x00                ; 000027CF  add [bx+si],al
  db 0x00, 0x00                ; 000027D1  add [bx+si],al
  db 0x00, 0x00                ; 000027D3  add [bx+si],al
  db 0x00, 0x00                ; 000027D5  add [bx+si],al
  db 0x00, 0x00                ; 000027D7  add [bx+si],al
  db 0x00, 0x00                ; 000027D9  add [bx+si],al
  db 0x00, 0x00                ; 000027DB  add [bx+si],al
  db 0x00, 0x00                ; 000027DD  add [bx+si],al
  db 0x00, 0x00                ; 000027DF  add [bx+si],al
  db 0x00, 0x00                ; 000027E1  add [bx+si],al
  db 0x00, 0x00                ; 000027E3  add [bx+si],al
  db 0x00, 0x00                ; 000027E5  add [bx+si],al
  db 0x00, 0x00                ; 000027E7  add [bx+si],al
  db 0x00, 0x00                ; 000027E9  add [bx+si],al
  db 0x00, 0x00                ; 000027EB  add [bx+si],al
  db 0x00, 0x00                ; 000027ED  add [bx+si],al
  db 0x00, 0x00                ; 000027EF  add [bx+si],al
  db 0x00, 0x00                ; 000027F1  add [bx+si],al
  db 0x00, 0x00                ; 000027F3  add [bx+si],al
  db 0x00, 0x00                ; 000027F5  add [bx+si],al
  db 0x00, 0x00                ; 000027F7  add [bx+si],al
  db 0x00, 0x00                ; 000027F9  add [bx+si],al
  db 0x00, 0x00                ; 000027FB  add [bx+si],al
  db 0x00, 0x00                ; 000027FD  add [bx+si],al
  db 0x00, 0x00                ; 000027FF  add [bx+si],al
  db 0x00, 0x00                ; 00002801  add [bx+si],al
  db 0x00, 0x00                ; 00002803  add [bx+si],al
  db 0x00, 0x00                ; 00002805  add [bx+si],al
  db 0x00, 0x00                ; 00002807  add [bx+si],al
  db 0x00, 0x00                ; 00002809  add [bx+si],al
  db 0x00, 0x00                ; 0000280B  add [bx+si],al
  db 0x00, 0x00                ; 0000280D  add [bx+si],al
  db 0x00, 0x00                ; 0000280F  add [bx+si],al
  db 0x00, 0x00                ; 00002811  add [bx+si],al
  db 0x00, 0x00                ; 00002813  add [bx+si],al
  db 0x00, 0x00                ; 00002815  add [bx+si],al
  db 0x00, 0x00                ; 00002817  add [bx+si],al
  db 0x00, 0x00                ; 00002819  add [bx+si],al
  db 0x00, 0x00                ; 0000281B  add [bx+si],al
  db 0x00, 0x00                ; 0000281D  add [bx+si],al
  db 0x00, 0x00                ; 0000281F  add [bx+si],al
  db 0x00, 0x00                ; 00002821  add [bx+si],al
  db 0x00, 0x00                ; 00002823  add [bx+si],al
  db 0x00, 0x00                ; 00002825  add [bx+si],al
  db 0x00, 0x00                ; 00002827  add [bx+si],al
  db 0x00, 0x00                ; 00002829  add [bx+si],al
  db 0x00, 0x00                ; 0000282B  add [bx+si],al
  db 0x00, 0x00                ; 0000282D  add [bx+si],al
  db 0x00, 0x00                ; 0000282F  add [bx+si],al
  db 0x00, 0x00                ; 00002831  add [bx+si],al
  db 0x00, 0x00                ; 00002833  add [bx+si],al
  db 0x00, 0x00                ; 00002835  add [bx+si],al
  db 0x00, 0x00                ; 00002837  add [bx+si],al
  db 0x00, 0x00                ; 00002839  add [bx+si],al
  db 0x00, 0x00                ; 0000283B  add [bx+si],al
  db 0x00, 0x00                ; 0000283D  add [bx+si],al
  db 0x00, 0x00                ; 0000283F  add [bx+si],al
  db 0x00, 0x00                ; 00002841  add [bx+si],al
  db 0x00, 0x00                ; 00002843  add [bx+si],al
  db 0x00, 0x00                ; 00002845  add [bx+si],al
  db 0x00, 0x00                ; 00002847  add [bx+si],al
  db 0x00, 0x00                ; 00002849  add [bx+si],al
  db 0x00, 0x00                ; 0000284B  add [bx+si],al
  db 0x00, 0x00                ; 0000284D  add [bx+si],al
  db 0x00, 0x00                ; 0000284F  add [bx+si],al
  db 0x00, 0x00                ; 00002851  add [bx+si],al
  db 0x00, 0x00                ; 00002853  add [bx+si],al
  db 0x00, 0x00                ; 00002855  add [bx+si],al
  db 0x00, 0x00                ; 00002857  add [bx+si],al
  db 0x00, 0x00                ; 00002859  add [bx+si],al
  db 0x00, 0x00                ; 0000285B  add [bx+si],al
  db 0x00, 0x00                ; 0000285D  add [bx+si],al
  db 0x00, 0x00                ; 0000285F  add [bx+si],al
  db 0x00, 0x00                ; 00002861  add [bx+si],al
  db 0x00, 0x00                ; 00002863  add [bx+si],al
  db 0x00, 0x00                ; 00002865  add [bx+si],al
  db 0x00, 0x00                ; 00002867  add [bx+si],al
  db 0x00, 0x00                ; 00002869  add [bx+si],al
  db 0x00, 0x00                ; 0000286B  add [bx+si],al
  db 0x00, 0x00                ; 0000286D  add [bx+si],al
  db 0x00, 0x00                ; 0000286F  add [bx+si],al
  db 0x00, 0x00                ; 00002871  add [bx+si],al
  db 0x00, 0x00                ; 00002873  add [bx+si],al
  db 0x00, 0x00                ; 00002875  add [bx+si],al
  db 0x00, 0x00                ; 00002877  add [bx+si],al
  db 0x00, 0x00                ; 00002879  add [bx+si],al
  db 0x00, 0x00                ; 0000287B  add [bx+si],al
  db 0x00, 0x00                ; 0000287D  add [bx+si],al
  db 0x00, 0x00                ; 0000287F  add [bx+si],al
  db 0x00, 0x00                ; 00002881  add [bx+si],al
  db 0x00, 0x00                ; 00002883  add [bx+si],al
  db 0x00, 0x00                ; 00002885  add [bx+si],al
  db 0x00, 0x00                ; 00002887  add [bx+si],al
  db 0x00, 0x00                ; 00002889  add [bx+si],al
  db 0x00, 0x00                ; 0000288B  add [bx+si],al
  db 0x00, 0x00                ; 0000288D  add [bx+si],al
  db 0x00, 0x00                ; 0000288F  add [bx+si],al
  db 0x00, 0x00                ; 00002891  add [bx+si],al
  db 0x00, 0x00                ; 00002893  add [bx+si],al
  db 0x00, 0x00                ; 00002895  add [bx+si],al
  db 0x00, 0x00                ; 00002897  add [bx+si],al
  db 0x00, 0x00                ; 00002899  add [bx+si],al
  db 0x00, 0x00                ; 0000289B  add [bx+si],al
  db 0x00, 0x00                ; 0000289D  add [bx+si],al
  db 0x00, 0x00                ; 0000289F  add [bx+si],al
  db 0x00, 0x00                ; 000028A1  add [bx+si],al
  db 0x00, 0x00                ; 000028A3  add [bx+si],al
  db 0x00, 0x00                ; 000028A5  add [bx+si],al
  db 0x00, 0x00                ; 000028A7  add [bx+si],al
  db 0x00, 0x00                ; 000028A9  add [bx+si],al
  db 0x00, 0x00                ; 000028AB  add [bx+si],al
  db 0x00, 0x00                ; 000028AD  add [bx+si],al
  db 0x00, 0x00                ; 000028AF  add [bx+si],al
  db 0x00, 0x00                ; 000028B1  add [bx+si],al
  db 0x00, 0x00                ; 000028B3  add [bx+si],al
  db 0x00, 0x00                ; 000028B5  add [bx+si],al
  db 0x00, 0x00                ; 000028B7  add [bx+si],al
  db 0x00, 0x00                ; 000028B9  add [bx+si],al
  db 0x00, 0x00                ; 000028BB  add [bx+si],al
  db 0x00, 0x00                ; 000028BD  add [bx+si],al
  db 0x00, 0x00                ; 000028BF  add [bx+si],al
  db 0x00, 0x00                ; 000028C1  add [bx+si],al
  db 0x00, 0x00                ; 000028C3  add [bx+si],al
  db 0x00, 0x00                ; 000028C5  add [bx+si],al
  db 0x00, 0x00                ; 000028C7  add [bx+si],al
  db 0x00, 0x00                ; 000028C9  add [bx+si],al
  db 0x00, 0x00                ; 000028CB  add [bx+si],al
  db 0x00, 0x00                ; 000028CD  add [bx+si],al
  db 0x00, 0x00                ; 000028CF  add [bx+si],al
  db 0x00, 0x00                ; 000028D1  add [bx+si],al
  db 0x00, 0x00                ; 000028D3  add [bx+si],al
  db 0x00, 0x00                ; 000028D5  add [bx+si],al
  db 0x00, 0x00                ; 000028D7  add [bx+si],al
  db 0x00, 0x00                ; 000028D9  add [bx+si],al
  db 0x00, 0x00                ; 000028DB  add [bx+si],al
  db 0x00, 0x00                ; 000028DD  add [bx+si],al
  db 0x00, 0x00                ; 000028DF  add [bx+si],al
  db 0x00, 0x00                ; 000028E1  add [bx+si],al
  db 0x00, 0x00                ; 000028E3  add [bx+si],al
  db 0x00, 0x00                ; 000028E5  add [bx+si],al
  db 0x00, 0x00                ; 000028E7  add [bx+si],al
  db 0x00, 0x00                ; 000028E9  add [bx+si],al
  db 0x00, 0x00                ; 000028EB  add [bx+si],al
  db 0x00, 0x00                ; 000028ED  add [bx+si],al
  db 0x00, 0x00                ; 000028EF  add [bx+si],al
  db 0x00, 0x00                ; 000028F1  add [bx+si],al
  db 0x00, 0x00                ; 000028F3  add [bx+si],al
  db 0x00, 0x00                ; 000028F5  add [bx+si],al
  db 0x00, 0x00                ; 000028F7  add [bx+si],al
  db 0x00, 0x00                ; 000028F9  add [bx+si],al
  db 0x00, 0x00                ; 000028FB  add [bx+si],al
  db 0x00, 0x00                ; 000028FD  add [bx+si],al
  db 0x00, 0x00                ; 000028FF  add [bx+si],al
  db 0x00, 0x00                ; 00002901  add [bx+si],al
  db 0x00, 0x00                ; 00002903  add [bx+si],al
  db 0x00, 0x00                ; 00002905  add [bx+si],al
  db 0x00, 0x00                ; 00002907  add [bx+si],al
  db 0x00, 0x00                ; 00002909  add [bx+si],al
  db 0x00, 0x00                ; 0000290B  add [bx+si],al
  db 0x00, 0x00                ; 0000290D  add [bx+si],al
  db 0x00, 0x00                ; 0000290F  add [bx+si],al
  db 0x00, 0x00                ; 00002911  add [bx+si],al
  db 0x00, 0x00                ; 00002913  add [bx+si],al
  db 0x00, 0x00                ; 00002915  add [bx+si],al
  db 0x00, 0x00                ; 00002917  add [bx+si],al
  db 0x00, 0x00                ; 00002919  add [bx+si],al
  db 0x00, 0x00                ; 0000291B  add [bx+si],al
  db 0x00, 0x00                ; 0000291D  add [bx+si],al
  db 0x00, 0x00                ; 0000291F  add [bx+si],al
  db 0x00, 0x00                ; 00002921  add [bx+si],al
  db 0x00, 0x00                ; 00002923  add [bx+si],al
  db 0x00, 0x00                ; 00002925  add [bx+si],al
  db 0x00, 0x00                ; 00002927  add [bx+si],al
  db 0x00, 0x00                ; 00002929  add [bx+si],al
  db 0x00, 0x00                ; 0000292B  add [bx+si],al
  db 0x00, 0x00                ; 0000292D  add [bx+si],al
  db 0x00, 0x00                ; 0000292F  add [bx+si],al
  db 0x00, 0x00                ; 00002931  add [bx+si],al
  db 0x00, 0x00                ; 00002933  add [bx+si],al
  db 0x00, 0x00                ; 00002935  add [bx+si],al
  db 0x00, 0x00                ; 00002937  add [bx+si],al
  db 0x00, 0x00                ; 00002939  add [bx+si],al
  db 0x00, 0x00                ; 0000293B  add [bx+si],al
  db 0x00, 0x00                ; 0000293D  add [bx+si],al
  db 0x00, 0x00                ; 0000293F  add [bx+si],al
  db 0x00, 0x00                ; 00002941  add [bx+si],al
  db 0x00, 0x00                ; 00002943  add [bx+si],al
  db 0x00, 0x00                ; 00002945  add [bx+si],al
  db 0x00, 0x00                ; 00002947  add [bx+si],al
  db 0x00, 0x00                ; 00002949  add [bx+si],al
  db 0x00, 0x00                ; 0000294B  add [bx+si],al
  db 0x00, 0x00                ; 0000294D  add [bx+si],al
  db 0x00, 0x00                ; 0000294F  add [bx+si],al
  db 0x00, 0x00                ; 00002951  add [bx+si],al
  db 0x00, 0x00                ; 00002953  add [bx+si],al
  db 0x00, 0x00                ; 00002955  add [bx+si],al
  db 0x00, 0x00                ; 00002957  add [bx+si],al
  db 0x00, 0x00                ; 00002959  add [bx+si],al
  db 0x00, 0x00                ; 0000295B  add [bx+si],al
  db 0x00, 0x00                ; 0000295D  add [bx+si],al
  db 0x00, 0x00                ; 0000295F  add [bx+si],al
  db 0x00, 0x00                ; 00002961  add [bx+si],al
  db 0x00, 0x00                ; 00002963  add [bx+si],al
  db 0x00, 0x00                ; 00002965  add [bx+si],al
  db 0x00, 0x00                ; 00002967  add [bx+si],al
  db 0x00, 0x00                ; 00002969  add [bx+si],al
  db 0x00, 0x00                ; 0000296B  add [bx+si],al
  db 0x00, 0x00                ; 0000296D  add [bx+si],al
  db 0x00, 0x00                ; 0000296F  add [bx+si],al
  db 0x00, 0x00                ; 00002971  add [bx+si],al
  db 0x00, 0x00                ; 00002973  add [bx+si],al
  db 0x00, 0x00                ; 00002975  add [bx+si],al
  db 0x00, 0x00                ; 00002977  add [bx+si],al
  db 0x00, 0x00                ; 00002979  add [bx+si],al
  db 0x00, 0x00                ; 0000297B  add [bx+si],al
  db 0x00, 0x00                ; 0000297D  add [bx+si],al
  db 0x00, 0x00                ; 0000297F  add [bx+si],al
  db 0x00, 0x00                ; 00002981  add [bx+si],al
  db 0x00, 0x00                ; 00002983  add [bx+si],al
  db 0x00, 0x00                ; 00002985  add [bx+si],al
  db 0x00, 0x00                ; 00002987  add [bx+si],al
  db 0x00, 0x00                ; 00002989  add [bx+si],al
  db 0x00, 0x00                ; 0000298B  add [bx+si],al
  db 0x00, 0x00                ; 0000298D  add [bx+si],al
  db 0x00, 0x00                ; 0000298F  add [bx+si],al
  db 0x00, 0x00                ; 00002991  add [bx+si],al
  db 0x00, 0x00                ; 00002993  add [bx+si],al
  db 0x00, 0x00                ; 00002995  add [bx+si],al
  db 0x00, 0x00                ; 00002997  add [bx+si],al
  db 0x00, 0x00                ; 00002999  add [bx+si],al
  db 0x00, 0x00                ; 0000299B  add [bx+si],al
  db 0x00, 0x00                ; 0000299D  add [bx+si],al
  db 0x00, 0x00                ; 0000299F  add [bx+si],al
  db 0x00, 0x00                ; 000029A1  add [bx+si],al
  db 0x00, 0x00                ; 000029A3  add [bx+si],al
  db 0x00, 0x00                ; 000029A5  add [bx+si],al
  db 0x00, 0x00                ; 000029A7  add [bx+si],al
  db 0x00, 0x00                ; 000029A9  add [bx+si],al
  db 0x00, 0x00                ; 000029AB  add [bx+si],al
  db 0x00, 0x00                ; 000029AD  add [bx+si],al
  db 0x00, 0x00                ; 000029AF  add [bx+si],al
  db 0x00, 0x00                ; 000029B1  add [bx+si],al
  db 0x00, 0x00                ; 000029B3  add [bx+si],al
  db 0x00, 0x00                ; 000029B5  add [bx+si],al
  db 0x00, 0x00                ; 000029B7  add [bx+si],al
  db 0x00, 0x00                ; 000029B9  add [bx+si],al
  db 0x00, 0x00                ; 000029BB  add [bx+si],al
  db 0x00, 0x00                ; 000029BD  add [bx+si],al
  db 0x00, 0x00                ; 000029BF  add [bx+si],al
  db 0x00, 0x00                ; 000029C1  add [bx+si],al
  db 0x00, 0x00                ; 000029C3  add [bx+si],al
  db 0x00, 0x00                ; 000029C5  add [bx+si],al
  db 0x00, 0x00                ; 000029C7  add [bx+si],al
  db 0x00, 0x00                ; 000029C9  add [bx+si],al
  db 0x00, 0x00                ; 000029CB  add [bx+si],al
  db 0x00, 0x00                ; 000029CD  add [bx+si],al
  db 0x00, 0x00                ; 000029CF  add [bx+si],al
  db 0x00, 0x00                ; 000029D1  add [bx+si],al
  db 0x00, 0x00                ; 000029D3  add [bx+si],al
  db 0x00, 0x00                ; 000029D5  add [bx+si],al
  db 0x00, 0x00                ; 000029D7  add [bx+si],al
  db 0x00, 0x00                ; 000029D9  add [bx+si],al
  db 0x00, 0x00                ; 000029DB  add [bx+si],al
  db 0x00, 0x00                ; 000029DD  add [bx+si],al
  db 0x00, 0x00                ; 000029DF  add [bx+si],al
  db 0x00, 0x00                ; 000029E1  add [bx+si],al
  db 0x00, 0x00                ; 000029E3  add [bx+si],al
  db 0x00, 0x00                ; 000029E5  add [bx+si],al
  db 0x00, 0x00                ; 000029E7  add [bx+si],al
  db 0x00, 0x00                ; 000029E9  add [bx+si],al
  db 0x00, 0x00                ; 000029EB  add [bx+si],al
  db 0x00, 0x00                ; 000029ED  add [bx+si],al
  db 0x00, 0x00                ; 000029EF  add [bx+si],al
  db 0x00, 0x00                ; 000029F1  add [bx+si],al
  db 0x00, 0x00                ; 000029F3  add [bx+si],al
  db 0x00, 0x00                ; 000029F5  add [bx+si],al
  db 0x00, 0x00                ; 000029F7  add [bx+si],al
  db 0x00, 0x00                ; 000029F9  add [bx+si],al
  db 0x00, 0x00                ; 000029FB  add [bx+si],al
  db 0x00, 0x00                ; 000029FD  add [bx+si],al
  db 0x00, 0x00                ; 000029FF  add [bx+si],al
  db 0x00, 0x00                ; 00002A01  add [bx+si],al
  db 0x00, 0x00                ; 00002A03  add [bx+si],al
  db 0x00, 0x00                ; 00002A05  add [bx+si],al
  db 0x00, 0x00                ; 00002A07  add [bx+si],al
  db 0x00, 0x00                ; 00002A09  add [bx+si],al
  db 0x00, 0x00                ; 00002A0B  add [bx+si],al
  db 0x00, 0x00                ; 00002A0D  add [bx+si],al
  db 0x00, 0x00                ; 00002A0F  add [bx+si],al
  db 0x00, 0x00                ; 00002A11  add [bx+si],al
  db 0x00, 0x00                ; 00002A13  add [bx+si],al
  db 0x00, 0x00                ; 00002A15  add [bx+si],al
  db 0x00, 0x00                ; 00002A17  add [bx+si],al
  db 0x00, 0x00                ; 00002A19  add [bx+si],al
  db 0x00, 0x00                ; 00002A1B  add [bx+si],al
  db 0x00, 0x00                ; 00002A1D  add [bx+si],al
  db 0x00, 0x00                ; 00002A1F  add [bx+si],al
  db 0x00, 0x00                ; 00002A21  add [bx+si],al
  db 0x00, 0x00                ; 00002A23  add [bx+si],al
  db 0x00, 0x00                ; 00002A25  add [bx+si],al
  db 0x00, 0x00                ; 00002A27  add [bx+si],al
  db 0x00, 0x00                ; 00002A29  add [bx+si],al
  db 0x00, 0x00                ; 00002A2B  add [bx+si],al
  db 0x00, 0x00                ; 00002A2D  add [bx+si],al
  db 0x00, 0x00                ; 00002A2F  add [bx+si],al
  db 0x00, 0x00                ; 00002A31  add [bx+si],al
  db 0x00, 0x00                ; 00002A33  add [bx+si],al
  db 0x00, 0x00                ; 00002A35  add [bx+si],al
  db 0x00, 0x00                ; 00002A37  add [bx+si],al
  db 0x00, 0x00                ; 00002A39  add [bx+si],al
  db 0x00, 0x00                ; 00002A3B  add [bx+si],al
  db 0x00, 0x00                ; 00002A3D  add [bx+si],al
  db 0x00, 0x00                ; 00002A3F  add [bx+si],al
  db 0x00, 0x00                ; 00002A41  add [bx+si],al
  db 0x00, 0x00                ; 00002A43  add [bx+si],al
  db 0x00, 0x00                ; 00002A45  add [bx+si],al
  db 0x00, 0x00                ; 00002A47  add [bx+si],al
  db 0x00, 0x00                ; 00002A49  add [bx+si],al
  db 0x00, 0x00                ; 00002A4B  add [bx+si],al
  db 0x00, 0x00                ; 00002A4D  add [bx+si],al
  db 0x00, 0x00                ; 00002A4F  add [bx+si],al
  db 0x00, 0x00                ; 00002A51  add [bx+si],al
  db 0x00, 0x00                ; 00002A53  add [bx+si],al
  db 0x00, 0x00                ; 00002A55  add [bx+si],al
  db 0x00, 0x00                ; 00002A57  add [bx+si],al
  db 0x00, 0x00                ; 00002A59  add [bx+si],al
  db 0x00, 0x00                ; 00002A5B  add [bx+si],al
  db 0x00, 0x00                ; 00002A5D  add [bx+si],al
  db 0x00, 0x00                ; 00002A5F  add [bx+si],al
  db 0x00, 0x00                ; 00002A61  add [bx+si],al
  db 0x00, 0x00                ; 00002A63  add [bx+si],al
  db 0x00, 0x00                ; 00002A65  add [bx+si],al
  db 0x00, 0x00                ; 00002A67  add [bx+si],al
  db 0x00, 0x00                ; 00002A69  add [bx+si],al
  db 0x00, 0x00                ; 00002A6B  add [bx+si],al
  db 0x00, 0x00                ; 00002A6D  add [bx+si],al
  db 0x00, 0x00                ; 00002A6F  add [bx+si],al
  db 0x00, 0x00                ; 00002A71  add [bx+si],al
  db 0x00, 0x00                ; 00002A73  add [bx+si],al
  db 0x00, 0x00                ; 00002A75  add [bx+si],al
  db 0x00, 0x00                ; 00002A77  add [bx+si],al
  db 0x00, 0x00                ; 00002A79  add [bx+si],al
  db 0x00, 0x00                ; 00002A7B  add [bx+si],al
  db 0x00, 0x00                ; 00002A7D  add [bx+si],al
  db 0x00, 0x00                ; 00002A7F  add [bx+si],al
  db 0x00, 0x00                ; 00002A81  add [bx+si],al
  db 0x00, 0x00                ; 00002A83  add [bx+si],al
  db 0x00, 0x00                ; 00002A85  add [bx+si],al
  db 0x00, 0x00                ; 00002A87  add [bx+si],al
  db 0x00, 0x00                ; 00002A89  add [bx+si],al
  db 0x00, 0x00                ; 00002A8B  add [bx+si],al
  db 0x00, 0x00                ; 00002A8D  add [bx+si],al
  db 0x00, 0x00                ; 00002A8F  add [bx+si],al
  db 0x00, 0x00                ; 00002A91  add [bx+si],al
  db 0x00, 0x00                ; 00002A93  add [bx+si],al
  db 0x00, 0x00                ; 00002A95  add [bx+si],al
  db 0x00, 0x00                ; 00002A97  add [bx+si],al
  db 0x00, 0x00                ; 00002A99  add [bx+si],al
  db 0x00, 0x00                ; 00002A9B  add [bx+si],al
  db 0x00, 0x00                ; 00002A9D  add [bx+si],al
  db 0x00, 0x00                ; 00002A9F  add [bx+si],al
  db 0x00, 0x00                ; 00002AA1  add [bx+si],al
  db 0x00, 0x00                ; 00002AA3  add [bx+si],al
  db 0x00, 0x00                ; 00002AA5  add [bx+si],al
  db 0x00, 0x00                ; 00002AA7  add [bx+si],al
  db 0x00, 0x00                ; 00002AA9  add [bx+si],al
  db 0x00, 0x00                ; 00002AAB  add [bx+si],al
  db 0x00, 0x00                ; 00002AAD  add [bx+si],al
  db 0x00, 0x00                ; 00002AAF  add [bx+si],al
  db 0x00, 0x00                ; 00002AB1  add [bx+si],al
  db 0x00, 0x00                ; 00002AB3  add [bx+si],al
  db 0x00, 0x00                ; 00002AB5  add [bx+si],al
  db 0x00, 0x00                ; 00002AB7  add [bx+si],al
  db 0x00, 0x00                ; 00002AB9  add [bx+si],al
  db 0x00, 0x00                ; 00002ABB  add [bx+si],al
  db 0x00, 0x00                ; 00002ABD  add [bx+si],al
  db 0x00, 0x00                ; 00002ABF  add [bx+si],al
  db 0x00, 0x00                ; 00002AC1  add [bx+si],al
  db 0x00, 0x00                ; 00002AC3  add [bx+si],al
  db 0x00, 0x00                ; 00002AC5  add [bx+si],al
  db 0x00, 0x00                ; 00002AC7  add [bx+si],al
  db 0x00, 0x00                ; 00002AC9  add [bx+si],al
  db 0x00, 0x00                ; 00002ACB  add [bx+si],al
  db 0x00, 0x00                ; 00002ACD  add [bx+si],al
  db 0x00, 0x00                ; 00002ACF  add [bx+si],al
  db 0x00, 0x00                ; 00002AD1  add [bx+si],al
  db 0x00, 0x00                ; 00002AD3  add [bx+si],al
  db 0x00, 0x00                ; 00002AD5  add [bx+si],al
  db 0x00, 0x00                ; 00002AD7  add [bx+si],al
  db 0x00, 0x00                ; 00002AD9  add [bx+si],al
  db 0x00, 0x00                ; 00002ADB  add [bx+si],al
  db 0x00, 0x00                ; 00002ADD  add [bx+si],al
  db 0x00, 0x00                ; 00002ADF  add [bx+si],al
  db 0x00, 0x00                ; 00002AE1  add [bx+si],al
  db 0x00, 0x00                ; 00002AE3  add [bx+si],al
  db 0x00, 0x00                ; 00002AE5  add [bx+si],al
  db 0x00, 0x00                ; 00002AE7  add [bx+si],al
  db 0x00, 0x00                ; 00002AE9  add [bx+si],al
  db 0x00, 0x00                ; 00002AEB  add [bx+si],al
  db 0x00, 0x00                ; 00002AED  add [bx+si],al
  db 0x00, 0x00                ; 00002AEF  add [bx+si],al
  db 0x00, 0x00                ; 00002AF1  add [bx+si],al
  db 0x00, 0x00                ; 00002AF3  add [bx+si],al
  db 0x00, 0x00                ; 00002AF5  add [bx+si],al
  db 0x00, 0x00                ; 00002AF7  add [bx+si],al
  db 0x00, 0x00                ; 00002AF9  add [bx+si],al
  db 0x00, 0x00                ; 00002AFB  add [bx+si],al
  db 0x00, 0x00                ; 00002AFD  add [bx+si],al
  db 0x00, 0x00                ; 00002AFF  add [bx+si],al
  db 0x00, 0x00                ; 00002B01  add [bx+si],al
  db 0x00, 0x00                ; 00002B03  add [bx+si],al
  db 0x00, 0x00                ; 00002B05  add [bx+si],al
  db 0x00, 0x00                ; 00002B07  add [bx+si],al
  db 0x00, 0x00                ; 00002B09  add [bx+si],al
  db 0x00, 0x00                ; 00002B0B  add [bx+si],al
  db 0x00, 0x00                ; 00002B0D  add [bx+si],al
  db 0x00, 0x00                ; 00002B0F  add [bx+si],al
  db 0x00, 0x00                ; 00002B11  add [bx+si],al
  db 0x00, 0x00                ; 00002B13  add [bx+si],al
  db 0x00, 0x00                ; 00002B15  add [bx+si],al
  db 0x00, 0x00                ; 00002B17  add [bx+si],al
  db 0x00, 0x00                ; 00002B19  add [bx+si],al
  db 0x00, 0x00                ; 00002B1B  add [bx+si],al
  db 0x00, 0x00                ; 00002B1D  add [bx+si],al
  db 0x00, 0x00                ; 00002B1F  add [bx+si],al
  db 0x00, 0x00                ; 00002B21  add [bx+si],al
  db 0x00, 0x00                ; 00002B23  add [bx+si],al
  db 0x00, 0x00                ; 00002B25  add [bx+si],al
  db 0x00, 0x00                ; 00002B27  add [bx+si],al
  db 0x00, 0x00                ; 00002B29  add [bx+si],al
  db 0x00, 0x00                ; 00002B2B  add [bx+si],al
  db 0x00, 0x00                ; 00002B2D  add [bx+si],al
  db 0x00, 0x00                ; 00002B2F  add [bx+si],al
  db 0x00, 0x00                ; 00002B31  add [bx+si],al
  db 0x00, 0x00                ; 00002B33  add [bx+si],al
  db 0x00, 0x00                ; 00002B35  add [bx+si],al
  db 0x00, 0x00                ; 00002B37  add [bx+si],al
  db 0x00, 0x00                ; 00002B39  add [bx+si],al
  db 0x00, 0x00                ; 00002B3B  add [bx+si],al
  db 0x00, 0x00                ; 00002B3D  add [bx+si],al
  db 0x00, 0x00                ; 00002B3F  add [bx+si],al
  db 0x00, 0x00                ; 00002B41  add [bx+si],al
  db 0x00, 0x00                ; 00002B43  add [bx+si],al
  db 0x00, 0x00                ; 00002B45  add [bx+si],al
  db 0x00, 0x00                ; 00002B47  add [bx+si],al
  db 0x00, 0x00                ; 00002B49  add [bx+si],al
  db 0x00, 0x00                ; 00002B4B  add [bx+si],al
  db 0x00, 0x00                ; 00002B4D  add [bx+si],al
  db 0x00, 0x00                ; 00002B4F  add [bx+si],al
  db 0x00, 0x00                ; 00002B51  add [bx+si],al
  db 0x00, 0x00                ; 00002B53  add [bx+si],al
  db 0x00, 0x00                ; 00002B55  add [bx+si],al
  db 0x00, 0x00                ; 00002B57  add [bx+si],al
  db 0x00, 0x00                ; 00002B59  add [bx+si],al
  db 0x00, 0x00                ; 00002B5B  add [bx+si],al
  db 0x00, 0x00                ; 00002B5D  add [bx+si],al
  db 0x00, 0x00                ; 00002B5F  add [bx+si],al
  db 0x00, 0x00                ; 00002B61  add [bx+si],al
  db 0x00, 0x00                ; 00002B63  add [bx+si],al
  db 0x00, 0x00                ; 00002B65  add [bx+si],al
  db 0x00, 0x00                ; 00002B67  add [bx+si],al
  db 0x00, 0x00                ; 00002B69  add [bx+si],al
  db 0x00, 0x00                ; 00002B6B  add [bx+si],al
  db 0x00, 0x00                ; 00002B6D  add [bx+si],al
  db 0x00, 0x00                ; 00002B6F  add [bx+si],al
  db 0x00, 0x00                ; 00002B71  add [bx+si],al
  db 0x00, 0x00                ; 00002B73  add [bx+si],al
  db 0x00, 0x00                ; 00002B75  add [bx+si],al
  db 0x00, 0x00                ; 00002B77  add [bx+si],al
  db 0x00, 0x00                ; 00002B79  add [bx+si],al
  db 0x00, 0x00                ; 00002B7B  add [bx+si],al
  db 0x00, 0x00                ; 00002B7D  add [bx+si],al
  db 0x00, 0x00                ; 00002B7F  add [bx+si],al
  db 0x00, 0x00                ; 00002B81  add [bx+si],al
  db 0x00, 0x00                ; 00002B83  add [bx+si],al
  db 0x00, 0x00                ; 00002B85  add [bx+si],al
  db 0x00, 0x00                ; 00002B87  add [bx+si],al
  db 0x00, 0x00                ; 00002B89  add [bx+si],al
  db 0x00, 0x00                ; 00002B8B  add [bx+si],al
  db 0x00, 0x00                ; 00002B8D  add [bx+si],al
  db 0x00, 0x00                ; 00002B8F  add [bx+si],al
  db 0x00, 0x00                ; 00002B91  add [bx+si],al
  db 0x00, 0x00                ; 00002B93  add [bx+si],al
  db 0x00, 0x00                ; 00002B95  add [bx+si],al
  db 0x00, 0x00                ; 00002B97  add [bx+si],al
  db 0x00, 0x00                ; 00002B99  add [bx+si],al
  db 0x00, 0x00                ; 00002B9B  add [bx+si],al
  db 0x00, 0x00                ; 00002B9D  add [bx+si],al
  db 0x00, 0x00                ; 00002B9F  add [bx+si],al
  db 0x00, 0x00                ; 00002BA1  add [bx+si],al
  db 0x00, 0x00                ; 00002BA3  add [bx+si],al
  db 0x00, 0x00                ; 00002BA5  add [bx+si],al
  db 0x00, 0x00                ; 00002BA7  add [bx+si],al
  db 0x00, 0x00                ; 00002BA9  add [bx+si],al
  db 0x00, 0x00                ; 00002BAB  add [bx+si],al
  db 0x00, 0x00                ; 00002BAD  add [bx+si],al
  db 0x00, 0x00                ; 00002BAF  add [bx+si],al
  db 0x00, 0x00                ; 00002BB1  add [bx+si],al
  db 0x00, 0x00                ; 00002BB3  add [bx+si],al
  db 0x00, 0x00                ; 00002BB5  add [bx+si],al
  db 0x00, 0x00                ; 00002BB7  add [bx+si],al
  db 0x00, 0x00                ; 00002BB9  add [bx+si],al
  db 0x00, 0x00                ; 00002BBB  add [bx+si],al
  db 0x00, 0x00                ; 00002BBD  add [bx+si],al
  db 0x00, 0x00                ; 00002BBF  add [bx+si],al
  db 0x00, 0x00                ; 00002BC1  add [bx+si],al
  db 0x00, 0x00                ; 00002BC3  add [bx+si],al
  db 0x00, 0x00                ; 00002BC5  add [bx+si],al
  db 0x00, 0x00                ; 00002BC7  add [bx+si],al
  db 0x00, 0x00                ; 00002BC9  add [bx+si],al
  db 0x00, 0x00                ; 00002BCB  add [bx+si],al
  db 0x00, 0x00                ; 00002BCD  add [bx+si],al
  db 0x00, 0x00                ; 00002BCF  add [bx+si],al
  db 0x00, 0x00                ; 00002BD1  add [bx+si],al
  db 0x00, 0x00                ; 00002BD3  add [bx+si],al
  db 0x00, 0x00                ; 00002BD5  add [bx+si],al
  db 0x00, 0x00                ; 00002BD7  add [bx+si],al
  db 0x00, 0x00                ; 00002BD9  add [bx+si],al
  db 0x00, 0x00                ; 00002BDB  add [bx+si],al
  db 0x00, 0x00                ; 00002BDD  add [bx+si],al
  db 0x00, 0x00                ; 00002BDF  add [bx+si],al
  db 0x00, 0x00                ; 00002BE1  add [bx+si],al
  db 0x00, 0x00                ; 00002BE3  add [bx+si],al
  db 0x00, 0x00                ; 00002BE5  add [bx+si],al
  db 0x00, 0x00                ; 00002BE7  add [bx+si],al
  db 0x00, 0x00                ; 00002BE9  add [bx+si],al
  db 0x00, 0x00                ; 00002BEB  add [bx+si],al
  db 0x00, 0x00                ; 00002BED  add [bx+si],al
  db 0x00, 0x00                ; 00002BEF  add [bx+si],al
  db 0x00, 0x00                ; 00002BF1  add [bx+si],al
  db 0x00, 0x00                ; 00002BF3  add [bx+si],al
  db 0x00, 0x00                ; 00002BF5  add [bx+si],al
  db 0x00, 0x00                ; 00002BF7  add [bx+si],al
  db 0x00, 0x00                ; 00002BF9  add [bx+si],al
  db 0x00, 0x00                ; 00002BFB  add [bx+si],al
  db 0x00, 0x00                ; 00002BFD  add [bx+si],al
  db 0x00, 0x00                ; 00002BFF  add [bx+si],al
  db 0x00, 0x00                ; 00002C01  add [bx+si],al
  db 0x00, 0x00                ; 00002C03  add [bx+si],al
  db 0x00, 0x00                ; 00002C05  add [bx+si],al
  db 0x00, 0x00                ; 00002C07  add [bx+si],al
  db 0x00, 0x00                ; 00002C09  add [bx+si],al
  db 0x00, 0x00                ; 00002C0B  add [bx+si],al
  db 0x00, 0x00                ; 00002C0D  add [bx+si],al
  db 0x00, 0x00                ; 00002C0F  add [bx+si],al
  db 0x00, 0x00                ; 00002C11  add [bx+si],al
  db 0x00, 0x00                ; 00002C13  add [bx+si],al
  db 0x00, 0x00                ; 00002C15  add [bx+si],al
  db 0x00, 0x00                ; 00002C17  add [bx+si],al
  db 0x00, 0x00                ; 00002C19  add [bx+si],al
  db 0x00, 0x00                ; 00002C1B  add [bx+si],al
  db 0x00, 0x00                ; 00002C1D  add [bx+si],al
  db 0x00, 0x00                ; 00002C1F  add [bx+si],al
  db 0x00, 0x00                ; 00002C21  add [bx+si],al
  db 0x00, 0x00                ; 00002C23  add [bx+si],al
  db 0x00, 0x00                ; 00002C25  add [bx+si],al
  db 0x00, 0x00                ; 00002C27  add [bx+si],al
  db 0x00, 0x00                ; 00002C29  add [bx+si],al
  db 0x00, 0x00                ; 00002C2B  add [bx+si],al
  db 0x00, 0x00                ; 00002C2D  add [bx+si],al
  db 0x00, 0x00                ; 00002C2F  add [bx+si],al
  db 0x00, 0x00                ; 00002C31  add [bx+si],al
  db 0x00, 0x00                ; 00002C33  add [bx+si],al
  db 0x00, 0x00                ; 00002C35  add [bx+si],al
  db 0x00, 0x00                ; 00002C37  add [bx+si],al
  db 0x00, 0x00                ; 00002C39  add [bx+si],al
  db 0x00, 0x00                ; 00002C3B  add [bx+si],al
  db 0x00, 0x00                ; 00002C3D  add [bx+si],al
  db 0x00, 0x00                ; 00002C3F  add [bx+si],al
  db 0x00, 0x00                ; 00002C41  add [bx+si],al
  db 0x00, 0x00                ; 00002C43  add [bx+si],al
  db 0x00, 0x00                ; 00002C45  add [bx+si],al
  db 0x00, 0x00                ; 00002C47  add [bx+si],al
  db 0x00, 0x00                ; 00002C49  add [bx+si],al
  db 0x00, 0x00                ; 00002C4B  add [bx+si],al
  db 0x00, 0x00                ; 00002C4D  add [bx+si],al
  db 0x00, 0x00                ; 00002C4F  add [bx+si],al
  db 0x00, 0x00                ; 00002C51  add [bx+si],al
  db 0x00, 0x00                ; 00002C53  add [bx+si],al
  db 0x00, 0x00                ; 00002C55  add [bx+si],al
  db 0x00, 0x00                ; 00002C57  add [bx+si],al
  db 0x00, 0x00                ; 00002C59  add [bx+si],al
  db 0x00, 0x00                ; 00002C5B  add [bx+si],al
  db 0x00, 0x00                ; 00002C5D  add [bx+si],al
  db 0x00, 0x00                ; 00002C5F  add [bx+si],al
  db 0x00, 0x00                ; 00002C61  add [bx+si],al
  db 0x00, 0x00                ; 00002C63  add [bx+si],al
  db 0x00, 0x00                ; 00002C65  add [bx+si],al
  db 0x00, 0x00                ; 00002C67  add [bx+si],al
  db 0x00, 0x00                ; 00002C69  add [bx+si],al
  db 0x00, 0x00                ; 00002C6B  add [bx+si],al
  db 0x00, 0x00                ; 00002C6D  add [bx+si],al
  db 0x00, 0x00                ; 00002C6F  add [bx+si],al
  db 0x00, 0x00                ; 00002C71  add [bx+si],al
  db 0x00, 0x00                ; 00002C73  add [bx+si],al
  db 0x00, 0x00                ; 00002C75  add [bx+si],al
  db 0x00, 0x00                ; 00002C77  add [bx+si],al
  db 0x00, 0x00                ; 00002C79  add [bx+si],al
  db 0x00, 0x00                ; 00002C7B  add [bx+si],al
  db 0x00, 0x00                ; 00002C7D  add [bx+si],al
  db 0x00, 0x00                ; 00002C7F  add [bx+si],al
  db 0x00, 0x00                ; 00002C81  add [bx+si],al
  db 0x00, 0x00                ; 00002C83  add [bx+si],al
  db 0x00, 0x00                ; 00002C85  add [bx+si],al
  db 0x00, 0x00                ; 00002C87  add [bx+si],al
  db 0x00, 0x00                ; 00002C89  add [bx+si],al
  db 0x00, 0x00                ; 00002C8B  add [bx+si],al
  db 0x00, 0x00                ; 00002C8D  add [bx+si],al
  db 0x00, 0x00                ; 00002C8F  add [bx+si],al
  db 0x00, 0x00                ; 00002C91  add [bx+si],al
  db 0x00, 0x00                ; 00002C93  add [bx+si],al
  db 0x00, 0x00                ; 00002C95  add [bx+si],al
  db 0x00, 0x00                ; 00002C97  add [bx+si],al
  db 0x00, 0x00                ; 00002C99  add [bx+si],al
  db 0x00, 0x00                ; 00002C9B  add [bx+si],al
  db 0x00, 0x00                ; 00002C9D  add [bx+si],al
  db 0x00, 0x00                ; 00002C9F  add [bx+si],al
  db 0x00, 0x00                ; 00002CA1  add [bx+si],al
  db 0x00, 0x00                ; 00002CA3  add [bx+si],al
  db 0x00, 0x00                ; 00002CA5  add [bx+si],al
  db 0x00, 0x00                ; 00002CA7  add [bx+si],al
  db 0x00, 0x00                ; 00002CA9  add [bx+si],al
  db 0x00, 0x00                ; 00002CAB  add [bx+si],al
  db 0x00, 0x00                ; 00002CAD  add [bx+si],al
  db 0x00, 0x00                ; 00002CAF  add [bx+si],al
  db 0x00, 0x00                ; 00002CB1  add [bx+si],al
  db 0x00, 0x00                ; 00002CB3  add [bx+si],al
  db 0x00, 0x00                ; 00002CB5  add [bx+si],al
  db 0x00, 0x00                ; 00002CB7  add [bx+si],al
  db 0x00, 0x00                ; 00002CB9  add [bx+si],al
  db 0x00, 0x00                ; 00002CBB  add [bx+si],al
  db 0x00, 0x00                ; 00002CBD  add [bx+si],al
  db 0x00, 0x00                ; 00002CBF  add [bx+si],al
  db 0x00, 0x00                ; 00002CC1  add [bx+si],al
  db 0x00, 0x00                ; 00002CC3  add [bx+si],al
  db 0x00, 0x00                ; 00002CC5  add [bx+si],al
  db 0x00, 0x00                ; 00002CC7  add [bx+si],al
  db 0x00, 0x00                ; 00002CC9  add [bx+si],al
  db 0x00, 0x00                ; 00002CCB  add [bx+si],al
  db 0x00, 0x00                ; 00002CCD  add [bx+si],al
  db 0x00, 0x00                ; 00002CCF  add [bx+si],al
  db 0x00, 0x00                ; 00002CD1  add [bx+si],al
  db 0x00, 0x00                ; 00002CD3  add [bx+si],al
  db 0x00, 0x00                ; 00002CD5  add [bx+si],al
  db 0x00, 0x00                ; 00002CD7  add [bx+si],al
  db 0x00, 0x00                ; 00002CD9  add [bx+si],al
  db 0x00, 0x00                ; 00002CDB  add [bx+si],al
  db 0x00, 0x00                ; 00002CDD  add [bx+si],al
  db 0x00, 0x00                ; 00002CDF  add [bx+si],al
  db 0x00, 0x00                ; 00002CE1  add [bx+si],al
  db 0x00, 0x00                ; 00002CE3  add [bx+si],al
  db 0x00, 0x00                ; 00002CE5  add [bx+si],al
  db 0x00, 0x00                ; 00002CE7  add [bx+si],al
  db 0x00, 0x00                ; 00002CE9  add [bx+si],al
  db 0x00, 0x00                ; 00002CEB  add [bx+si],al
  db 0x00, 0x00                ; 00002CED  add [bx+si],al
  db 0x00, 0x00                ; 00002CEF  add [bx+si],al
  db 0x00, 0x00                ; 00002CF1  add [bx+si],al
  db 0x00, 0x00                ; 00002CF3  add [bx+si],al
  db 0x00, 0x00                ; 00002CF5  add [bx+si],al
  db 0x00, 0x00                ; 00002CF7  add [bx+si],al
  db 0x00, 0x00                ; 00002CF9  add [bx+si],al
  db 0x00, 0x00                ; 00002CFB  add [bx+si],al
  db 0x00, 0x00                ; 00002CFD  add [bx+si],al
  db 0x00, 0x00                ; 00002CFF  add [bx+si],al
  db 0x00, 0x00                ; 00002D01  add [bx+si],al
  db 0x00, 0x00                ; 00002D03  add [bx+si],al
  db 0x00, 0x00                ; 00002D05  add [bx+si],al
  db 0x00, 0x00                ; 00002D07  add [bx+si],al
  db 0x00, 0x00                ; 00002D09  add [bx+si],al
  db 0x00, 0x00                ; 00002D0B  add [bx+si],al
  db 0x00, 0x00                ; 00002D0D  add [bx+si],al
  db 0x00, 0x00                ; 00002D0F  add [bx+si],al
  db 0x00, 0x00                ; 00002D11  add [bx+si],al
  db 0x00, 0x00                ; 00002D13  add [bx+si],al
  db 0x00, 0x00                ; 00002D15  add [bx+si],al
  db 0x00, 0x00                ; 00002D17  add [bx+si],al
  db 0x00, 0x00                ; 00002D19  add [bx+si],al
  db 0x00, 0x00                ; 00002D1B  add [bx+si],al
  db 0x00, 0x00                ; 00002D1D  add [bx+si],al
  db 0x00, 0x00                ; 00002D1F  add [bx+si],al
  db 0x00, 0x00                ; 00002D21  add [bx+si],al
  db 0x00, 0x00                ; 00002D23  add [bx+si],al
  db 0x00, 0x00                ; 00002D25  add [bx+si],al
  db 0x00, 0x00                ; 00002D27  add [bx+si],al
  db 0x00, 0x00                ; 00002D29  add [bx+si],al
  db 0x00, 0x00                ; 00002D2B  add [bx+si],al
  db 0x00, 0x00                ; 00002D2D  add [bx+si],al
  db 0x00, 0x00                ; 00002D2F  add [bx+si],al
  db 0x00, 0x00                ; 00002D31  add [bx+si],al
  db 0x00, 0x00                ; 00002D33  add [bx+si],al
  db 0x00, 0x00                ; 00002D35  add [bx+si],al
  db 0x00, 0x00                ; 00002D37  add [bx+si],al
  db 0x00, 0x00                ; 00002D39  add [bx+si],al
  db 0x00, 0x00                ; 00002D3B  add [bx+si],al
  db 0x00, 0x00                ; 00002D3D  add [bx+si],al
  db 0x00, 0x00                ; 00002D3F  add [bx+si],al
  db 0x00, 0x00                ; 00002D41  add [bx+si],al
  db 0x00, 0x00                ; 00002D43  add [bx+si],al
  db 0x00, 0x00                ; 00002D45  add [bx+si],al
  db 0x00, 0x00                ; 00002D47  add [bx+si],al
  db 0x00, 0x00                ; 00002D49  add [bx+si],al
  db 0x00, 0x00                ; 00002D4B  add [bx+si],al
  db 0x00, 0x00                ; 00002D4D  add [bx+si],al
  db 0x00, 0x00                ; 00002D4F  add [bx+si],al
  db 0x00, 0x00                ; 00002D51  add [bx+si],al
  db 0x00, 0x00                ; 00002D53  add [bx+si],al
  db 0x00, 0x00                ; 00002D55  add [bx+si],al
  db 0x00, 0x00                ; 00002D57  add [bx+si],al
  db 0x00, 0x00                ; 00002D59  add [bx+si],al
  db 0x00, 0x00                ; 00002D5B  add [bx+si],al
  db 0x00, 0x00                ; 00002D5D  add [bx+si],al
  db 0x00, 0x00                ; 00002D5F  add [bx+si],al
  db 0x00, 0x00                ; 00002D61  add [bx+si],al
  db 0x00, 0x00                ; 00002D63  add [bx+si],al
  db 0x00, 0x00                ; 00002D65  add [bx+si],al
  db 0x00, 0x00                ; 00002D67  add [bx+si],al
  db 0x00, 0x00                ; 00002D69  add [bx+si],al
  db 0x00, 0x00                ; 00002D6B  add [bx+si],al
  db 0x00, 0x00                ; 00002D6D  add [bx+si],al
  db 0x00, 0x00                ; 00002D6F  add [bx+si],al
  db 0x00, 0x00                ; 00002D71  add [bx+si],al
  db 0x00, 0x00                ; 00002D73  add [bx+si],al
  db 0x00, 0x00                ; 00002D75  add [bx+si],al
  db 0x00, 0x00                ; 00002D77  add [bx+si],al
  db 0x00, 0x00                ; 00002D79  add [bx+si],al
  db 0x00, 0x00                ; 00002D7B  add [bx+si],al
  db 0x00, 0x00                ; 00002D7D  add [bx+si],al
  db 0x00, 0x00                ; 00002D7F  add [bx+si],al
  db 0x00, 0x00                ; 00002D81  add [bx+si],al
  db 0x00, 0x00                ; 00002D83  add [bx+si],al
  db 0x00, 0x00                ; 00002D85  add [bx+si],al
  db 0x00, 0x00                ; 00002D87  add [bx+si],al
  db 0x00, 0x00                ; 00002D89  add [bx+si],al
  db 0x00, 0x00                ; 00002D8B  add [bx+si],al
  db 0x00, 0x00                ; 00002D8D  add [bx+si],al
  db 0x00, 0x00                ; 00002D8F  add [bx+si],al
  db 0x00, 0x00                ; 00002D91  add [bx+si],al
  db 0x00, 0x00                ; 00002D93  add [bx+si],al
  db 0x00, 0x00                ; 00002D95  add [bx+si],al
  db 0x00, 0x00                ; 00002D97  add [bx+si],al
  db 0x00, 0x00                ; 00002D99  add [bx+si],al
  db 0x00, 0x00                ; 00002D9B  add [bx+si],al
  db 0x00, 0x00                ; 00002D9D  add [bx+si],al
  db 0x00, 0x00                ; 00002D9F  add [bx+si],al
  db 0x00, 0x00                ; 00002DA1  add [bx+si],al
  db 0x00, 0x00                ; 00002DA3  add [bx+si],al
  db 0x00, 0x00                ; 00002DA5  add [bx+si],al
  db 0x00, 0x00                ; 00002DA7  add [bx+si],al
  db 0x00, 0x00                ; 00002DA9  add [bx+si],al
  db 0x00, 0x00                ; 00002DAB  add [bx+si],al
  db 0x00, 0x00                ; 00002DAD  add [bx+si],al
  db 0x00, 0x00                ; 00002DAF  add [bx+si],al
  db 0x00, 0x00                ; 00002DB1  add [bx+si],al
  db 0x00, 0x00                ; 00002DB3  add [bx+si],al
  db 0x00, 0x00                ; 00002DB5  add [bx+si],al
  db 0x00, 0x00                ; 00002DB7  add [bx+si],al
  db 0x00, 0x00                ; 00002DB9  add [bx+si],al
  db 0x00, 0x00                ; 00002DBB  add [bx+si],al
  db 0x00, 0x00                ; 00002DBD  add [bx+si],al
  db 0x00, 0x00                ; 00002DBF  add [bx+si],al
  db 0x00, 0x00                ; 00002DC1  add [bx+si],al
  db 0x00, 0x00                ; 00002DC3  add [bx+si],al
  db 0x00, 0x00                ; 00002DC5  add [bx+si],al
  db 0x00, 0x00                ; 00002DC7  add [bx+si],al
  db 0x00, 0x00                ; 00002DC9  add [bx+si],al
  db 0x00, 0x00                ; 00002DCB  add [bx+si],al
  db 0x00, 0x00                ; 00002DCD  add [bx+si],al
  db 0x00, 0x00                ; 00002DCF  add [bx+si],al
  db 0x00, 0x00                ; 00002DD1  add [bx+si],al
  db 0x00, 0x00                ; 00002DD3  add [bx+si],al
  db 0x00, 0x00                ; 00002DD5  add [bx+si],al
  db 0x00, 0x00                ; 00002DD7  add [bx+si],al
  db 0x00, 0x00                ; 00002DD9  add [bx+si],al
  db 0x00, 0x00                ; 00002DDB  add [bx+si],al
  db 0x00, 0x00                ; 00002DDD  add [bx+si],al
  db 0x00, 0x00                ; 00002DDF  add [bx+si],al
  db 0x00, 0x00                ; 00002DE1  add [bx+si],al
  db 0x00, 0x00                ; 00002DE3  add [bx+si],al
  db 0x00, 0x00                ; 00002DE5  add [bx+si],al
  db 0x00, 0x00                ; 00002DE7  add [bx+si],al
  db 0x00, 0x00                ; 00002DE9  add [bx+si],al
  db 0x00, 0x00                ; 00002DEB  add [bx+si],al
  db 0x00, 0x00                ; 00002DED  add [bx+si],al
  db 0x00, 0x00                ; 00002DEF  add [bx+si],al
  db 0x00, 0x00                ; 00002DF1  add [bx+si],al
  db 0x00, 0x00                ; 00002DF3  add [bx+si],al
  db 0x00, 0x00                ; 00002DF5  add [bx+si],al
  db 0x00, 0x00                ; 00002DF7  add [bx+si],al
  db 0x00, 0x00                ; 00002DF9  add [bx+si],al
  db 0x00, 0x00                ; 00002DFB  add [bx+si],al
  db 0x00, 0x00                ; 00002DFD  add [bx+si],al
  db 0x00, 0x00                ; 00002DFF  add [bx+si],al
  db 0x00, 0x00                ; 00002E01  add [bx+si],al
  db 0x00, 0x00                ; 00002E03  add [bx+si],al
  db 0x00, 0x00                ; 00002E05  add [bx+si],al
  db 0x00, 0x00                ; 00002E07  add [bx+si],al
  db 0x00, 0x00                ; 00002E09  add [bx+si],al
  db 0x00, 0x00                ; 00002E0B  add [bx+si],al
  db 0x00, 0x00                ; 00002E0D  add [bx+si],al
  db 0x00, 0x00                ; 00002E0F  add [bx+si],al
  db 0x00, 0x00                ; 00002E11  add [bx+si],al
  db 0x00, 0x00                ; 00002E13  add [bx+si],al
  db 0x00, 0x00                ; 00002E15  add [bx+si],al
  db 0x00, 0x00                ; 00002E17  add [bx+si],al
  db 0x00, 0x00                ; 00002E19  add [bx+si],al
  db 0x00, 0x00                ; 00002E1B  add [bx+si],al
  db 0x00, 0x00                ; 00002E1D  add [bx+si],al
  db 0x00, 0x00                ; 00002E1F  add [bx+si],al
  db 0x00, 0x00                ; 00002E21  add [bx+si],al
  db 0x00, 0x00                ; 00002E23  add [bx+si],al
  db 0x00, 0x00                ; 00002E25  add [bx+si],al
  db 0x00, 0x00                ; 00002E27  add [bx+si],al
  db 0x00, 0x00                ; 00002E29  add [bx+si],al
  db 0x00, 0x00                ; 00002E2B  add [bx+si],al
  db 0x00, 0x00                ; 00002E2D  add [bx+si],al
  db 0x00, 0x00                ; 00002E2F  add [bx+si],al
  db 0x00, 0x00                ; 00002E31  add [bx+si],al
  db 0x00, 0x00                ; 00002E33  add [bx+si],al
  db 0x00, 0x00                ; 00002E35  add [bx+si],al
  db 0x00, 0x00                ; 00002E37  add [bx+si],al
  db 0x00, 0x00                ; 00002E39  add [bx+si],al
  db 0x00, 0x00                ; 00002E3B  add [bx+si],al
  db 0x00, 0x00                ; 00002E3D  add [bx+si],al
  db 0x00, 0x00                ; 00002E3F  add [bx+si],al
  db 0x00, 0x00                ; 00002E41  add [bx+si],al
  db 0x00, 0x00                ; 00002E43  add [bx+si],al
  db 0x00, 0x00                ; 00002E45  add [bx+si],al
  db 0x00, 0x00                ; 00002E47  add [bx+si],al
  db 0x00, 0x00                ; 00002E49  add [bx+si],al
  db 0x00, 0x00                ; 00002E4B  add [bx+si],al
  db 0x00, 0x00                ; 00002E4D  add [bx+si],al
  db 0x00, 0x00                ; 00002E4F  add [bx+si],al
  db 0x00, 0x00                ; 00002E51  add [bx+si],al
  db 0x00, 0x00                ; 00002E53  add [bx+si],al
  db 0x00, 0x00                ; 00002E55  add [bx+si],al
  db 0x00, 0x00                ; 00002E57  add [bx+si],al
  db 0x00, 0x00                ; 00002E59  add [bx+si],al
  db 0x00, 0x00                ; 00002E5B  add [bx+si],al
  db 0x00, 0x00                ; 00002E5D  add [bx+si],al
  db 0x00, 0x00                ; 00002E5F  add [bx+si],al
  db 0x00, 0x00                ; 00002E61  add [bx+si],al
  db 0x00, 0x00                ; 00002E63  add [bx+si],al
  db 0x00, 0x00                ; 00002E65  add [bx+si],al
  db 0x00, 0x00                ; 00002E67  add [bx+si],al
  db 0x00, 0x00                ; 00002E69  add [bx+si],al
  db 0x00, 0x00                ; 00002E6B  add [bx+si],al
  db 0x00, 0x00                ; 00002E6D  add [bx+si],al
  db 0x00, 0x00                ; 00002E6F  add [bx+si],al
  db 0x00, 0x00                ; 00002E71  add [bx+si],al
  db 0x00, 0x00                ; 00002E73  add [bx+si],al
  db 0x00, 0x00                ; 00002E75  add [bx+si],al
  db 0x00, 0x00                ; 00002E77  add [bx+si],al
  db 0x00, 0x00                ; 00002E79  add [bx+si],al
  db 0x00, 0x00                ; 00002E7B  add [bx+si],al
  db 0x00, 0x00                ; 00002E7D  add [bx+si],al
  db 0x00, 0x00                ; 00002E7F  add [bx+si],al
  db 0x00, 0x00                ; 00002E81  add [bx+si],al
  db 0x00, 0x00                ; 00002E83  add [bx+si],al
  db 0x00, 0x00                ; 00002E85  add [bx+si],al
  db 0x00, 0x00                ; 00002E87  add [bx+si],al
  db 0x00, 0x00                ; 00002E89  add [bx+si],al
  db 0x00, 0x00                ; 00002E8B  add [bx+si],al
  db 0x00, 0x00                ; 00002E8D  add [bx+si],al
  db 0x00, 0x00                ; 00002E8F  add [bx+si],al
  db 0x00, 0x00                ; 00002E91  add [bx+si],al
  db 0x00, 0x00                ; 00002E93  add [bx+si],al
  db 0x00, 0x00                ; 00002E95  add [bx+si],al
  db 0x00, 0x00                ; 00002E97  add [bx+si],al
  db 0x00, 0x00                ; 00002E99  add [bx+si],al
  db 0x00, 0x00                ; 00002E9B  add [bx+si],al
  db 0x00, 0x00                ; 00002E9D  add [bx+si],al
  db 0x00, 0x00                ; 00002E9F  add [bx+si],al
  db 0x00, 0x00                ; 00002EA1  add [bx+si],al
  db 0x00, 0x00                ; 00002EA3  add [bx+si],al
  db 0x00, 0x00                ; 00002EA5  add [bx+si],al
  db 0x00, 0x00                ; 00002EA7  add [bx+si],al
  db 0x00, 0x00                ; 00002EA9  add [bx+si],al
  db 0x00, 0x00                ; 00002EAB  add [bx+si],al
  db 0x00, 0x00                ; 00002EAD  add [bx+si],al
  db 0x00, 0x00                ; 00002EAF  add [bx+si],al
  db 0x00, 0x00                ; 00002EB1  add [bx+si],al
  db 0x00, 0x00                ; 00002EB3  add [bx+si],al
  db 0x00, 0x00                ; 00002EB5  add [bx+si],al
  db 0x00, 0x00                ; 00002EB7  add [bx+si],al
  db 0x00, 0x00                ; 00002EB9  add [bx+si],al
  db 0x00, 0x00                ; 00002EBB  add [bx+si],al
  db 0x00, 0x00                ; 00002EBD  add [bx+si],al
  db 0x00, 0x00                ; 00002EBF  add [bx+si],al
  db 0x00, 0x00                ; 00002EC1  add [bx+si],al
  db 0x00, 0x00                ; 00002EC3  add [bx+si],al
  db 0x00, 0x00                ; 00002EC5  add [bx+si],al
  db 0x00, 0x00                ; 00002EC7  add [bx+si],al
  db 0x00, 0x00                ; 00002EC9  add [bx+si],al
  db 0x00, 0x00                ; 00002ECB  add [bx+si],al
  db 0x00, 0x00                ; 00002ECD  add [bx+si],al
  db 0x00, 0x00                ; 00002ECF  add [bx+si],al
  db 0x00, 0x00                ; 00002ED1  add [bx+si],al
  db 0x00, 0x00                ; 00002ED3  add [bx+si],al
  db 0x00, 0x00                ; 00002ED5  add [bx+si],al
  db 0x00, 0x00                ; 00002ED7  add [bx+si],al
  db 0x00, 0x00                ; 00002ED9  add [bx+si],al
  db 0x00, 0x00                ; 00002EDB  add [bx+si],al
  db 0x00, 0x00                ; 00002EDD  add [bx+si],al
  db 0x00, 0x00                ; 00002EDF  add [bx+si],al
  db 0x00, 0x00                ; 00002EE1  add [bx+si],al
  db 0x00, 0x00                ; 00002EE3  add [bx+si],al
  db 0x00, 0x00                ; 00002EE5  add [bx+si],al
  db 0x00, 0x00                ; 00002EE7  add [bx+si],al
  db 0x00, 0x00                ; 00002EE9  add [bx+si],al
  db 0x00, 0x00                ; 00002EEB  add [bx+si],al
  db 0x00, 0x00                ; 00002EED  add [bx+si],al
  db 0x00, 0x00                ; 00002EEF  add [bx+si],al
  db 0x00, 0x00                ; 00002EF1  add [bx+si],al
  db 0x00, 0x00                ; 00002EF3  add [bx+si],al
  db 0x00, 0x00                ; 00002EF5  add [bx+si],al
  db 0x00, 0x00                ; 00002EF7  add [bx+si],al
  db 0x00, 0x00                ; 00002EF9  add [bx+si],al
  db 0x00, 0x00                ; 00002EFB  add [bx+si],al
  db 0x00, 0x00                ; 00002EFD  add [bx+si],al
  db 0x00, 0x00                ; 00002EFF  add [bx+si],al
  db 0x00, 0x00                ; 00002F01  add [bx+si],al
  db 0x00, 0x00                ; 00002F03  add [bx+si],al
  db 0x00, 0x00                ; 00002F05  add [bx+si],al
  db 0x00, 0x00                ; 00002F07  add [bx+si],al
  db 0x00, 0x00                ; 00002F09  add [bx+si],al
  db 0x00, 0x00                ; 00002F0B  add [bx+si],al
  db 0x00, 0x00                ; 00002F0D  add [bx+si],al
  db 0x00, 0x00                ; 00002F0F  add [bx+si],al
  db 0x00, 0x00                ; 00002F11  add [bx+si],al
  db 0x00, 0x00                ; 00002F13  add [bx+si],al
  db 0x00, 0x00                ; 00002F15  add [bx+si],al
  db 0x00, 0x00                ; 00002F17  add [bx+si],al
  db 0x00, 0x00                ; 00002F19  add [bx+si],al
  db 0x00, 0x00                ; 00002F1B  add [bx+si],al
  db 0x00, 0x00                ; 00002F1D  add [bx+si],al
  db 0x00, 0x00                ; 00002F1F  add [bx+si],al
  db 0x00, 0x00                ; 00002F21  add [bx+si],al
  db 0x00, 0x00                ; 00002F23  add [bx+si],al
  db 0x00, 0x00                ; 00002F25  add [bx+si],al
  db 0x00, 0x00                ; 00002F27  add [bx+si],al
  db 0x00, 0x00                ; 00002F29  add [bx+si],al
  db 0x00, 0x00                ; 00002F2B  add [bx+si],al
  db 0x00, 0x00                ; 00002F2D  add [bx+si],al
  db 0x00, 0x00                ; 00002F2F  add [bx+si],al
  db 0x00, 0x00                ; 00002F31  add [bx+si],al
  db 0x00, 0x00                ; 00002F33  add [bx+si],al
  db 0x00, 0x00                ; 00002F35  add [bx+si],al
  db 0x00, 0x00                ; 00002F37  add [bx+si],al
  db 0x00, 0x00                ; 00002F39  add [bx+si],al
  db 0x00, 0x00                ; 00002F3B  add [bx+si],al
  db 0x00, 0x00                ; 00002F3D  add [bx+si],al
  db 0x00, 0x00                ; 00002F3F  add [bx+si],al
  db 0x00, 0x00                ; 00002F41  add [bx+si],al
  db 0x00, 0x00                ; 00002F43  add [bx+si],al
  db 0x00, 0x00                ; 00002F45  add [bx+si],al
  db 0x00, 0x00                ; 00002F47  add [bx+si],al
  db 0x00, 0x00                ; 00002F49  add [bx+si],al
  db 0x00, 0x00                ; 00002F4B  add [bx+si],al
  db 0x00, 0x00                ; 00002F4D  add [bx+si],al
  db 0x00, 0x00                ; 00002F4F  add [bx+si],al
  db 0x00, 0x00                ; 00002F51  add [bx+si],al
  db 0x00, 0x00                ; 00002F53  add [bx+si],al
  db 0x00, 0x00                ; 00002F55  add [bx+si],al
  db 0x00, 0x00                ; 00002F57  add [bx+si],al
  db 0x00, 0x00                ; 00002F59  add [bx+si],al
  db 0x00, 0x00                ; 00002F5B  add [bx+si],al
  db 0x00, 0x00                ; 00002F5D  add [bx+si],al
  db 0x00, 0x00                ; 00002F5F  add [bx+si],al
  db 0x00, 0x00                ; 00002F61  add [bx+si],al
  db 0x00, 0x00                ; 00002F63  add [bx+si],al
  db 0x00, 0x00                ; 00002F65  add [bx+si],al
  db 0x00, 0x00                ; 00002F67  add [bx+si],al
  db 0x00, 0x00                ; 00002F69  add [bx+si],al
  db 0x00, 0x00                ; 00002F6B  add [bx+si],al
  db 0x00, 0x00                ; 00002F6D  add [bx+si],al
  db 0x00, 0x00                ; 00002F6F  add [bx+si],al
  db 0x00, 0x00                ; 00002F71  add [bx+si],al
  db 0x00, 0x00                ; 00002F73  add [bx+si],al
  db 0x00, 0x00                ; 00002F75  add [bx+si],al
  db 0x00, 0x00                ; 00002F77  add [bx+si],al
  db 0x00, 0x00                ; 00002F79  add [bx+si],al
  db 0x00, 0x00                ; 00002F7B  add [bx+si],al
  db 0x00, 0x00                ; 00002F7D  add [bx+si],al
  db 0x00, 0x00                ; 00002F7F  add [bx+si],al
  db 0x00, 0x00                ; 00002F81  add [bx+si],al
  db 0x00, 0x00                ; 00002F83  add [bx+si],al
  db 0x00, 0x00                ; 00002F85  add [bx+si],al
  db 0x00, 0x00                ; 00002F87  add [bx+si],al
  db 0x00, 0x00                ; 00002F89  add [bx+si],al
  db 0x00, 0x00                ; 00002F8B  add [bx+si],al
  db 0x00, 0x00                ; 00002F8D  add [bx+si],al
  db 0x00, 0x00                ; 00002F8F  add [bx+si],al
  db 0x00, 0x00                ; 00002F91  add [bx+si],al
  db 0x00, 0x00                ; 00002F93  add [bx+si],al
  db 0x00, 0x00                ; 00002F95  add [bx+si],al
  db 0x00, 0x00                ; 00002F97  add [bx+si],al
  db 0x00, 0x00                ; 00002F99  add [bx+si],al
  db 0x00, 0x00                ; 00002F9B  add [bx+si],al
  db 0x00, 0x00                ; 00002F9D  add [bx+si],al
  db 0x00, 0x00                ; 00002F9F  add [bx+si],al
  db 0x00, 0x00                ; 00002FA1  add [bx+si],al
  db 0x00, 0x00                ; 00002FA3  add [bx+si],al
  db 0x00, 0x00                ; 00002FA5  add [bx+si],al
  db 0x00, 0x00                ; 00002FA7  add [bx+si],al
  db 0x00, 0x00                ; 00002FA9  add [bx+si],al
  db 0x00, 0x00                ; 00002FAB  add [bx+si],al
  db 0x00, 0x00                ; 00002FAD  add [bx+si],al
  db 0x00, 0x00                ; 00002FAF  add [bx+si],al
  db 0x00, 0x00                ; 00002FB1  add [bx+si],al
  db 0x00, 0x00                ; 00002FB3  add [bx+si],al
  db 0x00, 0x00                ; 00002FB5  add [bx+si],al
  db 0x00, 0x00                ; 00002FB7  add [bx+si],al
  db 0x00, 0x00                ; 00002FB9  add [bx+si],al
  db 0x00, 0x00                ; 00002FBB  add [bx+si],al
  db 0x00, 0x00                ; 00002FBD  add [bx+si],al
  db 0x00, 0x00                ; 00002FBF  add [bx+si],al
  db 0x00, 0x00                ; 00002FC1  add [bx+si],al
  db 0x00, 0x00                ; 00002FC3  add [bx+si],al
  db 0x00, 0x00                ; 00002FC5  add [bx+si],al
  db 0x00, 0x00                ; 00002FC7  add [bx+si],al
  db 0x00, 0x00                ; 00002FC9  add [bx+si],al
  db 0x00, 0x00                ; 00002FCB  add [bx+si],al
  db 0x00, 0x00                ; 00002FCD  add [bx+si],al
  db 0x00, 0x00                ; 00002FCF  add [bx+si],al
  db 0x00, 0x00                ; 00002FD1  add [bx+si],al
  db 0x00, 0x00                ; 00002FD3  add [bx+si],al
  db 0x00, 0x00                ; 00002FD5  add [bx+si],al
  db 0x00, 0x00                ; 00002FD7  add [bx+si],al
  db 0x00, 0x00                ; 00002FD9  add [bx+si],al
  db 0x00, 0x00                ; 00002FDB  add [bx+si],al
  db 0x00, 0x00                ; 00002FDD  add [bx+si],al
  db 0x00, 0x00                ; 00002FDF  add [bx+si],al
  db 0x00, 0x00                ; 00002FE1  add [bx+si],al
  db 0x00, 0x00                ; 00002FE3  add [bx+si],al
  db 0x00, 0x00                ; 00002FE5  add [bx+si],al
  db 0x00, 0x00                ; 00002FE7  add [bx+si],al
  db 0x00, 0x00                ; 00002FE9  add [bx+si],al
  db 0x00, 0x00                ; 00002FEB  add [bx+si],al
  db 0x00, 0x00                ; 00002FED  add [bx+si],al
  db 0x00, 0x00                ; 00002FEF  add [bx+si],al
  db 0x00, 0x00                ; 00002FF1  add [bx+si],al
  db 0x00, 0x00                ; 00002FF3  add [bx+si],al
  db 0x00, 0x00                ; 00002FF5  add [bx+si],al
  db 0x00, 0x00                ; 00002FF7  add [bx+si],al
  db 0x00, 0x00                ; 00002FF9  add [bx+si],al
  db 0x00, 0x00                ; 00002FFB  add [bx+si],al
  db 0x00, 0x00                ; 00002FFD  add [bx+si],al
  db 0x00, 0x00                ; 00002FFF  add [bx+si],al
  db 0x00, 0x00                ; 00003001  add [bx+si],al
  db 0x00, 0x00                ; 00003003  add [bx+si],al
  db 0x00, 0x00                ; 00003005  add [bx+si],al
  db 0x00, 0x00                ; 00003007  add [bx+si],al
  db 0x00, 0x00                ; 00003009  add [bx+si],al
  db 0x00, 0x00                ; 0000300B  add [bx+si],al
  db 0x00, 0x00                ; 0000300D  add [bx+si],al
  db 0x00, 0x00                ; 0000300F  add [bx+si],al
  db 0x00, 0x00                ; 00003011  add [bx+si],al
  db 0x00, 0x00                ; 00003013  add [bx+si],al
  db 0x00, 0x00                ; 00003015  add [bx+si],al
  db 0x00, 0x00                ; 00003017  add [bx+si],al
  db 0x00, 0x00                ; 00003019  add [bx+si],al
  db 0x00, 0x00                ; 0000301B  add [bx+si],al
  db 0x00, 0x00                ; 0000301D  add [bx+si],al
  db 0x00, 0x00                ; 0000301F  add [bx+si],al
  db 0x00, 0x00                ; 00003021  add [bx+si],al
  db 0x00, 0x00                ; 00003023  add [bx+si],al
  db 0x00, 0x00                ; 00003025  add [bx+si],al
  db 0x00, 0x00                ; 00003027  add [bx+si],al
  db 0x00, 0x00                ; 00003029  add [bx+si],al
  db 0x00, 0x00                ; 0000302B  add [bx+si],al
  db 0x00, 0x00                ; 0000302D  add [bx+si],al
  db 0x00, 0x00                ; 0000302F  add [bx+si],al
  db 0x00, 0x00                ; 00003031  add [bx+si],al
  db 0x00, 0x00                ; 00003033  add [bx+si],al
  db 0x00, 0x00                ; 00003035  add [bx+si],al
  db 0x00, 0x00                ; 00003037  add [bx+si],al
  db 0x00, 0x00                ; 00003039  add [bx+si],al
  db 0x00, 0x00                ; 0000303B  add [bx+si],al
  db 0x00, 0x00                ; 0000303D  add [bx+si],al
  db 0x00, 0x00                ; 0000303F  add [bx+si],al
  db 0x00, 0x00                ; 00003041  add [bx+si],al
  db 0x00, 0x00                ; 00003043  add [bx+si],al
  db 0x00, 0x00                ; 00003045  add [bx+si],al
  db 0x00, 0x00                ; 00003047  add [bx+si],al
  db 0x00, 0x00                ; 00003049  add [bx+si],al
  db 0x00, 0x00                ; 0000304B  add [bx+si],al
  db 0x00, 0x00                ; 0000304D  add [bx+si],al
  db 0x00, 0x00                ; 0000304F  add [bx+si],al
  db 0x00, 0x00                ; 00003051  add [bx+si],al
  db 0x00, 0x00                ; 00003053  add [bx+si],al
  db 0x00, 0x00                ; 00003055  add [bx+si],al
  db 0x00, 0x00                ; 00003057  add [bx+si],al
  db 0x00, 0x00                ; 00003059  add [bx+si],al
  db 0x00, 0x00                ; 0000305B  add [bx+si],al
  db 0x00, 0x00                ; 0000305D  add [bx+si],al
  db 0x00, 0x00                ; 0000305F  add [bx+si],al
  db 0x00, 0x00                ; 00003061  add [bx+si],al
  db 0x00, 0x00                ; 00003063  add [bx+si],al
  db 0x00, 0x00                ; 00003065  add [bx+si],al
  db 0x00, 0x00                ; 00003067  add [bx+si],al
  db 0x00, 0x00                ; 00003069  add [bx+si],al
  db 0x00, 0x00                ; 0000306B  add [bx+si],al
  db 0x00, 0x00                ; 0000306D  add [bx+si],al
  db 0x00, 0x00                ; 0000306F  add [bx+si],al
  db 0x00, 0x00                ; 00003071  add [bx+si],al
  db 0x00, 0x00                ; 00003073  add [bx+si],al
  db 0x00, 0x00                ; 00003075  add [bx+si],al
  db 0x00, 0x00                ; 00003077  add [bx+si],al
  db 0x00, 0x00                ; 00003079  add [bx+si],al
  db 0x00, 0x00                ; 0000307B  add [bx+si],al
  db 0x00, 0x00                ; 0000307D  add [bx+si],al
  db 0x00, 0x00                ; 0000307F  add [bx+si],al
  db 0x00, 0x00                ; 00003081  add [bx+si],al
  db 0x00, 0x00                ; 00003083  add [bx+si],al
  db 0x00, 0x00                ; 00003085  add [bx+si],al
  db 0x00, 0x00                ; 00003087  add [bx+si],al
  db 0x00, 0x00                ; 00003089  add [bx+si],al
  db 0x00, 0x00                ; 0000308B  add [bx+si],al
  db 0x00, 0x00                ; 0000308D  add [bx+si],al
  db 0x00, 0x00                ; 0000308F  add [bx+si],al
  db 0x00, 0x00                ; 00003091  add [bx+si],al
  db 0x00, 0x00                ; 00003093  add [bx+si],al
  db 0x00, 0x00                ; 00003095  add [bx+si],al
  db 0x00, 0x00                ; 00003097  add [bx+si],al
  db 0x00, 0x00                ; 00003099  add [bx+si],al
  db 0x00, 0x00                ; 0000309B  add [bx+si],al
  db 0x00, 0x00                ; 0000309D  add [bx+si],al
  db 0x00, 0x00                ; 0000309F  add [bx+si],al
  db 0x00, 0x00                ; 000030A1  add [bx+si],al
  db 0x00, 0x00                ; 000030A3  add [bx+si],al
  db 0x00, 0x00                ; 000030A5  add [bx+si],al
  db 0x00, 0x00                ; 000030A7  add [bx+si],al
  db 0x00, 0x00                ; 000030A9  add [bx+si],al
  db 0x00, 0x00                ; 000030AB  add [bx+si],al
  db 0x00, 0x00                ; 000030AD  add [bx+si],al
  db 0x00, 0x00                ; 000030AF  add [bx+si],al
  db 0x00, 0x00                ; 000030B1  add [bx+si],al
  db 0x00, 0x00                ; 000030B3  add [bx+si],al
  db 0x00, 0x00                ; 000030B5  add [bx+si],al
  db 0x00, 0x00                ; 000030B7  add [bx+si],al
  db 0x00, 0x00                ; 000030B9  add [bx+si],al
  db 0x00, 0x00                ; 000030BB  add [bx+si],al
  db 0x00, 0x00                ; 000030BD  add [bx+si],al
  db 0x00, 0x00                ; 000030BF  add [bx+si],al
  db 0x00, 0x00                ; 000030C1  add [bx+si],al
  db 0x00, 0x00                ; 000030C3  add [bx+si],al
  db 0x00, 0x00                ; 000030C5  add [bx+si],al
  db 0x00, 0x00                ; 000030C7  add [bx+si],al
  db 0x00, 0x00                ; 000030C9  add [bx+si],al
  db 0x00, 0x00                ; 000030CB  add [bx+si],al
  db 0x00, 0x00                ; 000030CD  add [bx+si],al
  db 0x00, 0x00                ; 000030CF  add [bx+si],al
  db 0x00, 0x00                ; 000030D1  add [bx+si],al
  db 0x00, 0x00                ; 000030D3  add [bx+si],al
  db 0x00, 0x00                ; 000030D5  add [bx+si],al
  db 0x00, 0x00                ; 000030D7  add [bx+si],al
  db 0x00, 0x00                ; 000030D9  add [bx+si],al
  db 0x00, 0x00                ; 000030DB  add [bx+si],al
  db 0x00, 0x00                ; 000030DD  add [bx+si],al
  db 0x00, 0x00                ; 000030DF  add [bx+si],al
  db 0x00, 0x00                ; 000030E1  add [bx+si],al
  db 0x00, 0x00                ; 000030E3  add [bx+si],al
  db 0x00, 0x00                ; 000030E5  add [bx+si],al
  db 0x00, 0x00                ; 000030E7  add [bx+si],al
  db 0x00, 0x00                ; 000030E9  add [bx+si],al
  db 0x00, 0x00                ; 000030EB  add [bx+si],al
  db 0x00, 0x00                ; 000030ED  add [bx+si],al
  db 0x00, 0x00                ; 000030EF  add [bx+si],al
  db 0x00, 0x00                ; 000030F1  add [bx+si],al
  db 0x00, 0x00                ; 000030F3  add [bx+si],al
  db 0x00, 0x00                ; 000030F5  add [bx+si],al
  db 0x00, 0x00                ; 000030F7  add [bx+si],al
  db 0x00, 0x00                ; 000030F9  add [bx+si],al
  db 0x00, 0x00                ; 000030FB  add [bx+si],al
  db 0x00, 0x00                ; 000030FD  add [bx+si],al
  db 0x00, 0x00                ; 000030FF  add [bx+si],al
  db 0x00, 0x00                ; 00003101  add [bx+si],al
  db 0x00, 0x00                ; 00003103  add [bx+si],al
  db 0x00, 0x00                ; 00003105  add [bx+si],al
  db 0x00, 0x00                ; 00003107  add [bx+si],al
  db 0x00, 0x00                ; 00003109  add [bx+si],al
  db 0x00, 0x00                ; 0000310B  add [bx+si],al
  db 0x00, 0x00                ; 0000310D  add [bx+si],al
  db 0x00, 0x00                ; 0000310F  add [bx+si],al
  db 0x00, 0x00                ; 00003111  add [bx+si],al
  db 0x00, 0x00                ; 00003113  add [bx+si],al
  db 0x00, 0x00                ; 00003115  add [bx+si],al
  db 0x00, 0x00                ; 00003117  add [bx+si],al
  db 0x00, 0x00                ; 00003119  add [bx+si],al
  db 0x00, 0x00                ; 0000311B  add [bx+si],al
  db 0x00, 0x00                ; 0000311D  add [bx+si],al
  db 0x00, 0x00                ; 0000311F  add [bx+si],al
  db 0x00, 0x00                ; 00003121  add [bx+si],al
  db 0x00, 0x00                ; 00003123  add [bx+si],al
  db 0x00, 0x00                ; 00003125  add [bx+si],al
  db 0x00, 0x00                ; 00003127  add [bx+si],al
  db 0x00, 0x00                ; 00003129  add [bx+si],al
  db 0x00, 0x00                ; 0000312B  add [bx+si],al
  db 0x00, 0x00                ; 0000312D  add [bx+si],al
  db 0x00, 0x00                ; 0000312F  add [bx+si],al
  db 0x00, 0x00                ; 00003131  add [bx+si],al
  db 0x00, 0x00                ; 00003133  add [bx+si],al
  db 0x00, 0x00                ; 00003135  add [bx+si],al
  db 0x00, 0x00                ; 00003137  add [bx+si],al
  db 0x00, 0x00                ; 00003139  add [bx+si],al
  db 0x00, 0x00                ; 0000313B  add [bx+si],al
  db 0x00, 0x00                ; 0000313D  add [bx+si],al
  db 0x00, 0x00                ; 0000313F  add [bx+si],al
  db 0x00, 0x00                ; 00003141  add [bx+si],al
  db 0x00, 0x00                ; 00003143  add [bx+si],al
  db 0x00, 0x00                ; 00003145  add [bx+si],al
  db 0x00, 0x00                ; 00003147  add [bx+si],al
  db 0x00, 0x00                ; 00003149  add [bx+si],al
  db 0x00, 0x00                ; 0000314B  add [bx+si],al
  db 0x00, 0x00                ; 0000314D  add [bx+si],al
  db 0x00, 0x00                ; 0000314F  add [bx+si],al
  db 0x00, 0x00                ; 00003151  add [bx+si],al
  db 0x00, 0x00                ; 00003153  add [bx+si],al
  db 0x00, 0x00                ; 00003155  add [bx+si],al
  db 0x00, 0x00                ; 00003157  add [bx+si],al
  db 0x00, 0x00                ; 00003159  add [bx+si],al
  db 0x00, 0x00                ; 0000315B  add [bx+si],al
  db 0x00, 0x00                ; 0000315D  add [bx+si],al
  db 0x00, 0x00                ; 0000315F  add [bx+si],al
  db 0x00, 0x00                ; 00003161  add [bx+si],al
  db 0x00, 0x00                ; 00003163  add [bx+si],al
  db 0x00, 0x00                ; 00003165  add [bx+si],al
  db 0x00, 0x00                ; 00003167  add [bx+si],al
  db 0x00, 0x00                ; 00003169  add [bx+si],al
  db 0x00, 0x00                ; 0000316B  add [bx+si],al
  db 0x00, 0x00                ; 0000316D  add [bx+si],al
  db 0x00, 0x00                ; 0000316F  add [bx+si],al
  db 0x00, 0x00                ; 00003171  add [bx+si],al
  db 0x00, 0x00                ; 00003173  add [bx+si],al
  db 0x00, 0x00                ; 00003175  add [bx+si],al
  db 0x00, 0x00                ; 00003177  add [bx+si],al
  db 0x00, 0x00                ; 00003179  add [bx+si],al
  db 0x00, 0x00                ; 0000317B  add [bx+si],al
  db 0x00, 0x00                ; 0000317D  add [bx+si],al
  db 0x00, 0x00                ; 0000317F  add [bx+si],al
  db 0x00, 0x00                ; 00003181  add [bx+si],al
  db 0x00, 0x00                ; 00003183  add [bx+si],al
  db 0x00, 0x00                ; 00003185  add [bx+si],al
  db 0x00, 0x00                ; 00003187  add [bx+si],al
  db 0x00, 0x00                ; 00003189  add [bx+si],al
  db 0x00, 0x00                ; 0000318B  add [bx+si],al
  db 0x00, 0x00                ; 0000318D  add [bx+si],al
  db 0x00, 0x00                ; 0000318F  add [bx+si],al
  db 0x00, 0x00                ; 00003191  add [bx+si],al
  db 0x00, 0x00                ; 00003193  add [bx+si],al
  db 0x00, 0x00                ; 00003195  add [bx+si],al
  db 0x00, 0x00                ; 00003197  add [bx+si],al
  db 0x00, 0x00                ; 00003199  add [bx+si],al
  db 0x00, 0x00                ; 0000319B  add [bx+si],al
  db 0x00, 0x00                ; 0000319D  add [bx+si],al
  db 0x00, 0x00                ; 0000319F  add [bx+si],al
  db 0x00, 0x00                ; 000031A1  add [bx+si],al
  db 0x00, 0x00                ; 000031A3  add [bx+si],al
  db 0x00, 0x00                ; 000031A5  add [bx+si],al
  db 0x00, 0x00                ; 000031A7  add [bx+si],al
  db 0x00, 0x00                ; 000031A9  add [bx+si],al
  db 0x00, 0x00                ; 000031AB  add [bx+si],al
  db 0x00, 0x00                ; 000031AD  add [bx+si],al
  db 0x00, 0x00                ; 000031AF  add [bx+si],al
  db 0x00, 0x00                ; 000031B1  add [bx+si],al
  db 0x00, 0x00                ; 000031B3  add [bx+si],al
  db 0x00, 0x00                ; 000031B5  add [bx+si],al
  db 0x00, 0x00                ; 000031B7  add [bx+si],al
  db 0x00, 0x00                ; 000031B9  add [bx+si],al
  db 0x00, 0x00                ; 000031BB  add [bx+si],al
  db 0x00, 0x00                ; 000031BD  add [bx+si],al
  db 0x00, 0x00                ; 000031BF  add [bx+si],al
  db 0x00, 0x00                ; 000031C1  add [bx+si],al
  db 0x00, 0x00                ; 000031C3  add [bx+si],al
  db 0x00, 0x00                ; 000031C5  add [bx+si],al
  db 0x00, 0x00                ; 000031C7  add [bx+si],al
  db 0x00, 0x00                ; 000031C9  add [bx+si],al
  db 0x00, 0x00                ; 000031CB  add [bx+si],al
  db 0x00, 0x00                ; 000031CD  add [bx+si],al
  db 0x00, 0x00                ; 000031CF  add [bx+si],al
  db 0x00, 0x00                ; 000031D1  add [bx+si],al
  db 0x00, 0x00                ; 000031D3  add [bx+si],al
  db 0x00, 0x00                ; 000031D5  add [bx+si],al
  db 0x00, 0x00                ; 000031D7  add [bx+si],al
  db 0x00, 0x00                ; 000031D9  add [bx+si],al
  db 0x00, 0x00                ; 000031DB  add [bx+si],al
  db 0x00, 0x00                ; 000031DD  add [bx+si],al
  db 0x00, 0x00                ; 000031DF  add [bx+si],al
  db 0x00, 0x00                ; 000031E1  add [bx+si],al
  db 0x00, 0x00                ; 000031E3  add [bx+si],al
  db 0x00, 0x00                ; 000031E5  add [bx+si],al
  db 0x00, 0x00                ; 000031E7  add [bx+si],al
  db 0x00, 0x00                ; 000031E9  add [bx+si],al
  db 0x00, 0x00                ; 000031EB  add [bx+si],al
  db 0x00, 0x00                ; 000031ED  add [bx+si],al
  db 0x00, 0x00                ; 000031EF  add [bx+si],al
  db 0x00, 0x00                ; 000031F1  add [bx+si],al
  db 0x00, 0x00                ; 000031F3  add [bx+si],al
  db 0x00, 0x00                ; 000031F5  add [bx+si],al
  db 0x00, 0x00                ; 000031F7  add [bx+si],al
  db 0x00, 0x00                ; 000031F9  add [bx+si],al
  db 0x00, 0x00                ; 000031FB  add [bx+si],al
  db 0x00, 0x00                ; 000031FD  add [bx+si],al
  db 0x00, 0x00                ; 000031FF  add [bx+si],al
  db 0x00, 0x00                ; 00003201  add [bx+si],al
  db 0x00, 0x00                ; 00003203  add [bx+si],al
  db 0x00, 0x00                ; 00003205  add [bx+si],al
  db 0x00, 0x00                ; 00003207  add [bx+si],al
  db 0x00, 0x00                ; 00003209  add [bx+si],al
  db 0x00, 0x00                ; 0000320B  add [bx+si],al
  db 0x00, 0x00                ; 0000320D  add [bx+si],al
  db 0x00, 0x00                ; 0000320F  add [bx+si],al
  db 0x00, 0x00                ; 00003211  add [bx+si],al
  db 0x00, 0x00                ; 00003213  add [bx+si],al
  db 0x00, 0x00                ; 00003215  add [bx+si],al
  db 0x00, 0x00                ; 00003217  add [bx+si],al
  db 0x00, 0x00                ; 00003219  add [bx+si],al
  db 0x00, 0x00                ; 0000321B  add [bx+si],al
  db 0x00, 0x00                ; 0000321D  add [bx+si],al
  db 0x00, 0x00                ; 0000321F  add [bx+si],al
  db 0x00, 0x00                ; 00003221  add [bx+si],al
  db 0x00, 0x00                ; 00003223  add [bx+si],al
  db 0x00, 0x00                ; 00003225  add [bx+si],al
  db 0x00, 0x00                ; 00003227  add [bx+si],al
  db 0x00, 0x00                ; 00003229  add [bx+si],al
  db 0x00, 0x00                ; 0000322B  add [bx+si],al
  db 0x00, 0x00                ; 0000322D  add [bx+si],al
  db 0x00, 0x00                ; 0000322F  add [bx+si],al
  db 0x00, 0x00                ; 00003231  add [bx+si],al
  db 0x00, 0x00                ; 00003233  add [bx+si],al
  db 0x00, 0x00                ; 00003235  add [bx+si],al
  db 0x00, 0x00                ; 00003237  add [bx+si],al
  db 0x00, 0x00                ; 00003239  add [bx+si],al
  db 0x00, 0x00                ; 0000323B  add [bx+si],al
  db 0x00, 0x00                ; 0000323D  add [bx+si],al
  db 0x00, 0x00                ; 0000323F  add [bx+si],al
  db 0x00, 0x00                ; 00003241  add [bx+si],al
  db 0x00, 0x00                ; 00003243  add [bx+si],al
  db 0x00, 0x00                ; 00003245  add [bx+si],al
  db 0x00, 0x00                ; 00003247  add [bx+si],al
  db 0x00, 0x00                ; 00003249  add [bx+si],al
  db 0x00, 0x00                ; 0000324B  add [bx+si],al
  db 0x00, 0x00                ; 0000324D  add [bx+si],al
  db 0x00, 0x00                ; 0000324F  add [bx+si],al
  db 0x00, 0x00                ; 00003251  add [bx+si],al
  db 0x00, 0x00                ; 00003253  add [bx+si],al
  db 0x00, 0x00                ; 00003255  add [bx+si],al
  db 0x00, 0x00                ; 00003257  add [bx+si],al
  db 0x00, 0x00                ; 00003259  add [bx+si],al
  db 0x00, 0x00                ; 0000325B  add [bx+si],al
  db 0x00, 0x00                ; 0000325D  add [bx+si],al
  db 0x00, 0x00                ; 0000325F  add [bx+si],al
  db 0x00, 0x00                ; 00003261  add [bx+si],al
  db 0x00, 0x00                ; 00003263  add [bx+si],al
  db 0x00, 0x00                ; 00003265  add [bx+si],al
  db 0x00, 0x00                ; 00003267  add [bx+si],al
  db 0x00, 0x00                ; 00003269  add [bx+si],al
  db 0x00, 0x00                ; 0000326B  add [bx+si],al
  db 0x00, 0x00                ; 0000326D  add [bx+si],al
  db 0x00, 0x00                ; 0000326F  add [bx+si],al
  db 0x00, 0x00                ; 00003271  add [bx+si],al
  db 0x00, 0x00                ; 00003273  add [bx+si],al
  db 0x00, 0x00                ; 00003275  add [bx+si],al
  db 0x00, 0x00                ; 00003277  add [bx+si],al
  db 0x00, 0x00                ; 00003279  add [bx+si],al
  db 0x00, 0x00                ; 0000327B  add [bx+si],al
  db 0x00, 0x00                ; 0000327D  add [bx+si],al
  db 0x00, 0x00                ; 0000327F  add [bx+si],al
  db 0x00, 0x00                ; 00003281  add [bx+si],al
  db 0x00, 0x00                ; 00003283  add [bx+si],al
  db 0x00, 0x00                ; 00003285  add [bx+si],al
  db 0x00, 0x00                ; 00003287  add [bx+si],al
  db 0x00, 0x00                ; 00003289  add [bx+si],al
  db 0x00, 0x00                ; 0000328B  add [bx+si],al
  db 0x00, 0x00                ; 0000328D  add [bx+si],al
  db 0x00, 0x00                ; 0000328F  add [bx+si],al
  db 0x00, 0x00                ; 00003291  add [bx+si],al
  db 0x00, 0x00                ; 00003293  add [bx+si],al
  db 0x00, 0x00                ; 00003295  add [bx+si],al
  db 0x00, 0x00                ; 00003297  add [bx+si],al
  db 0x00, 0x00                ; 00003299  add [bx+si],al
  db 0x00, 0x00                ; 0000329B  add [bx+si],al
  db 0x00, 0x00                ; 0000329D  add [bx+si],al
  db 0x00, 0x00                ; 0000329F  add [bx+si],al
  db 0x00, 0x00                ; 000032A1  add [bx+si],al
  db 0x00, 0x00                ; 000032A3  add [bx+si],al
  db 0x00, 0x00                ; 000032A5  add [bx+si],al
  db 0x00, 0x00                ; 000032A7  add [bx+si],al
  db 0x00, 0x00                ; 000032A9  add [bx+si],al
  db 0x00, 0x00                ; 000032AB  add [bx+si],al
  db 0x00, 0x00                ; 000032AD  add [bx+si],al
  db 0x00, 0x00                ; 000032AF  add [bx+si],al
  db 0x00, 0x00                ; 000032B1  add [bx+si],al
  db 0x00, 0x00                ; 000032B3  add [bx+si],al
  db 0x00, 0x00                ; 000032B5  add [bx+si],al
  db 0x00, 0x00                ; 000032B7  add [bx+si],al
  db 0x00, 0x00                ; 000032B9  add [bx+si],al
  db 0x00, 0x00                ; 000032BB  add [bx+si],al
  db 0x00, 0x00                ; 000032BD  add [bx+si],al
  db 0x00, 0x00                ; 000032BF  add [bx+si],al
  db 0x00, 0x00                ; 000032C1  add [bx+si],al
  db 0x00, 0x00                ; 000032C3  add [bx+si],al
  db 0x00, 0x00                ; 000032C5  add [bx+si],al
  db 0x00, 0x00                ; 000032C7  add [bx+si],al
  db 0x00, 0x00                ; 000032C9  add [bx+si],al
  db 0x00, 0x00                ; 000032CB  add [bx+si],al
  db 0x00, 0x00                ; 000032CD  add [bx+si],al
  db 0x00, 0x00                ; 000032CF  add [bx+si],al
  db 0x00, 0x00                ; 000032D1  add [bx+si],al
  db 0x00, 0x00                ; 000032D3  add [bx+si],al
  db 0x00, 0x00                ; 000032D5  add [bx+si],al
  db 0x00, 0x00                ; 000032D7  add [bx+si],al
  db 0x00, 0x00                ; 000032D9  add [bx+si],al
  db 0x00, 0x00                ; 000032DB  add [bx+si],al
  db 0x00, 0x00                ; 000032DD  add [bx+si],al
  db 0x00, 0x00                ; 000032DF  add [bx+si],al
  db 0x00, 0x00                ; 000032E1  add [bx+si],al
  db 0x00, 0x00                ; 000032E3  add [bx+si],al
  db 0x00, 0x00                ; 000032E5  add [bx+si],al
  db 0x00, 0x00                ; 000032E7  add [bx+si],al
  db 0x00, 0x00                ; 000032E9  add [bx+si],al
  db 0x00, 0x00                ; 000032EB  add [bx+si],al
  db 0x00, 0x00                ; 000032ED  add [bx+si],al
  db 0x00, 0x00                ; 000032EF  add [bx+si],al
  db 0x00, 0x00                ; 000032F1  add [bx+si],al
  db 0x00, 0x00                ; 000032F3  add [bx+si],al
  db 0x00, 0x00                ; 000032F5  add [bx+si],al
  db 0x00, 0x00                ; 000032F7  add [bx+si],al
  db 0x00, 0x00                ; 000032F9  add [bx+si],al
  db 0x00, 0x00                ; 000032FB  add [bx+si],al
  db 0x00, 0x00                ; 000032FD  add [bx+si],al
  db 0x00, 0x00                ; 000032FF  add [bx+si],al
  db 0x00, 0x00                ; 00003301  add [bx+si],al
  db 0x00, 0x00                ; 00003303  add [bx+si],al
  db 0x00, 0x00                ; 00003305  add [bx+si],al
  db 0x00, 0x00                ; 00003307  add [bx+si],al
  db 0x00, 0x00                ; 00003309  add [bx+si],al
  db 0x00, 0x00                ; 0000330B  add [bx+si],al
  db 0x00, 0x00                ; 0000330D  add [bx+si],al
  db 0x00, 0x00                ; 0000330F  add [bx+si],al
  db 0x00, 0x00                ; 00003311  add [bx+si],al
  db 0x00, 0x00                ; 00003313  add [bx+si],al
  db 0x00, 0x00                ; 00003315  add [bx+si],al
  db 0x00, 0x00                ; 00003317  add [bx+si],al
  db 0x00, 0x00                ; 00003319  add [bx+si],al
  db 0x00, 0x00                ; 0000331B  add [bx+si],al
  db 0x00, 0x00                ; 0000331D  add [bx+si],al
  db 0x00, 0x00                ; 0000331F  add [bx+si],al
  db 0x00, 0x00                ; 00003321  add [bx+si],al
  db 0x00, 0x00                ; 00003323  add [bx+si],al
  db 0x00, 0x00                ; 00003325  add [bx+si],al
  db 0x00, 0x00                ; 00003327  add [bx+si],al
  db 0x00, 0x00                ; 00003329  add [bx+si],al
  db 0x00, 0x00                ; 0000332B  add [bx+si],al
  db 0x00, 0x00                ; 0000332D  add [bx+si],al
  db 0x00, 0x00                ; 0000332F  add [bx+si],al
  db 0x00, 0x00                ; 00003331  add [bx+si],al
  db 0x00, 0x00                ; 00003333  add [bx+si],al
  db 0x00, 0x00                ; 00003335  add [bx+si],al
  db 0x00, 0x00                ; 00003337  add [bx+si],al
  db 0x00, 0x00                ; 00003339  add [bx+si],al
  db 0x00, 0x00                ; 0000333B  add [bx+si],al
  db 0x00, 0x00                ; 0000333D  add [bx+si],al
  db 0x00, 0x00                ; 0000333F  add [bx+si],al
  db 0x00, 0x00                ; 00003341  add [bx+si],al
  db 0x00, 0x00                ; 00003343  add [bx+si],al
  db 0x00, 0x00                ; 00003345  add [bx+si],al
  db 0x00, 0x00                ; 00003347  add [bx+si],al
  db 0x00, 0x00                ; 00003349  add [bx+si],al
  db 0x00, 0x00                ; 0000334B  add [bx+si],al
  db 0x00, 0x00                ; 0000334D  add [bx+si],al
  db 0x00, 0x00                ; 0000334F  add [bx+si],al
  db 0x00, 0x00                ; 00003351  add [bx+si],al
  db 0x00, 0x00                ; 00003353  add [bx+si],al
  db 0x00, 0x00                ; 00003355  add [bx+si],al
  db 0x00, 0x00                ; 00003357  add [bx+si],al
  db 0x00, 0x00                ; 00003359  add [bx+si],al
  db 0x00, 0x00                ; 0000335B  add [bx+si],al
  db 0x00, 0x00                ; 0000335D  add [bx+si],al
  db 0x00, 0x00                ; 0000335F  add [bx+si],al
  db 0x03, 0x00                ; 00003361  add ax,[bx+si]
  db 0x00, 0x00                ; 00003363  add [bx+si],al
  db 0x00, 0x00                ; 00003365  add [bx+si],al
  db 0x01, 0x00                ; 00003367  add [bx+si],ax
  db 0x00, 0x00                ; 00003369  add [bx+si],al
  db 0x00, 0x00                ; 0000336B  add [bx+si],al
  db 0xFF                      ; 0000336D  db 0xff
  db 0xFF                      ; 0000336E  db 0xff
  db 0xFF                      ; 0000336F  db 0xff
  db 0xFF                      ; 00003370  db 0xff
  db 0xFF                      ; 00003371  db 0xff
  db 0xFF, 0x00                ; 00003372  inc word [bx+si]
  db 0x00, 0x00                ; 00003374  add [bx+si],al
  db 0x00, 0x00                ; 00003376  add [bx+si],al
  db 0x7A, 0x3B                ; 00003378  jpe 0x33b5
  db 0xD0                      ; 0000337A  db 0xd0
  db 0x37                      ; 0000337B  aaa
  db 0x00, 0x00                ; 0000337C  add [bx+si],al
  db 0x00, 0x00                ; 0000337E  add [bx+si],al
  db 0x00, 0x00                ; 00003380  add [bx+si],al
  db 0x00, 0x00                ; 00003382  add [bx+si],al
  db 0x00, 0x00                ; 00003384  add [bx+si],al
  db 0x00, 0x00                ; 00003386  add [bx+si],al
  db 0x00, 0x00                ; 00003388  add [bx+si],al
  db 0x94                      ; 0000338A  xchg ax,sp
  db 0x33, 0x00                ; 0000338B  xor ax,[bx+si]
  db 0x00, 0x00                ; 0000338D  add [bx+si],al
  db 0x00, 0x00                ; 0000338F  add [bx+si],al
  db 0x00, 0x00                ; 00003391  add [bx+si],al
  db 0x00, 0x00                ; 00003393  add [bx+si],al
  db 0x80, 0x00, 0x00          ; 00003395  add byte [bx+si],0x0
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
  db 0xE6, 0x37                ; 000037D4  out 0x37,al
  db 0xFF                      ; 000037D6  db 0xff
  db 0xFF, 0x00                ; 000037D7  inc word [bx+si]
  db 0x00, 0x00                ; 000037D9  add [bx+si],al
  db 0x00, 0x00                ; 000037DB  add [bx+si],al
  db 0x00, 0x00                ; 000037DD  add [bx+si],al
  db 0x00, 0x00                ; 000037DF  add [bx+si],al
  db 0x00, 0x00                ; 000037E1  add [bx+si],al
  db 0x00, 0x00                ; 000037E3  add [bx+si],al
  db 0x00, 0x00                ; 000037E5  add [bx+si],al
  db 0x00, 0x00                ; 000037E7  add [bx+si],al
  db 0x00, 0xFC                ; 000037E9  add ah,bh
  db 0x37                      ; 000037EB  aaa
  db 0xFF                      ; 000037EC  db 0xff
  db 0xFF, 0x00                ; 000037ED  inc word [bx+si]
  db 0x00, 0x00                ; 000037EF  add [bx+si],al
  db 0x00, 0x00                ; 000037F1  add [bx+si],al
  db 0x00, 0x00                ; 000037F3  add [bx+si],al
  db 0x00, 0x00                ; 000037F5  add [bx+si],al
  db 0x00, 0x00                ; 000037F7  add [bx+si],al
  db 0x00, 0x00                ; 000037F9  add [bx+si],al
  db 0x00, 0x00                ; 000037FB  add [bx+si],al
  db 0x00, 0x00                ; 000037FD  add [bx+si],al
  db 0x00, 0x12                ; 000037FF  add [bp+si],dl
  db 0x38, 0xFF                ; 00003801  cmp bh,bh
  db 0xFF, 0x00                ; 00003803  inc word [bx+si]
  db 0x00, 0x00                ; 00003805  add [bx+si],al
  db 0x00, 0x00                ; 00003807  add [bx+si],al
  db 0x00, 0x00                ; 00003809  add [bx+si],al
  db 0x00, 0x00                ; 0000380B  add [bx+si],al
  db 0x00, 0x00                ; 0000380D  add [bx+si],al
  db 0x00, 0x00                ; 0000380F  add [bx+si],al
  db 0x00, 0x00                ; 00003811  add [bx+si],al
  db 0x00, 0x00                ; 00003813  add [bx+si],al
  db 0x00, 0x28                ; 00003815  add [bx+si],ch
  db 0x38, 0xFF                ; 00003817  cmp bh,bh
  db 0xFF, 0x00                ; 00003819  inc word [bx+si]
  db 0x00, 0x00                ; 0000381B  add [bx+si],al
  db 0x00, 0x00                ; 0000381D  add [bx+si],al
  db 0x00, 0x00                ; 0000381F  add [bx+si],al
  db 0x00, 0x00                ; 00003821  add [bx+si],al
  db 0x00, 0x00                ; 00003823  add [bx+si],al
  db 0x00, 0x00                ; 00003825  add [bx+si],al
  db 0x00, 0x00                ; 00003827  add [bx+si],al
  db 0x00, 0x00                ; 00003829  add [bx+si],al
  db 0x00, 0x3E, 0x38, 0xFF    ; 0000382B  add [0xff38],bh
  db 0xFF, 0x00                ; 0000382F  inc word [bx+si]
  db 0x00, 0x00                ; 00003831  add [bx+si],al
  db 0x00, 0x00                ; 00003833  add [bx+si],al
  db 0x00, 0x00                ; 00003835  add [bx+si],al
  db 0x00, 0x00                ; 00003837  add [bx+si],al
  db 0x00, 0x00                ; 00003839  add [bx+si],al
  db 0x00, 0x00                ; 0000383B  add [bx+si],al
  db 0x00, 0x00                ; 0000383D  add [bx+si],al
  db 0x00, 0x00                ; 0000383F  add [bx+si],al
  db 0x80, 0x00, 0x00          ; 00003841  add byte [bx+si],0x0
  db 0xFF                      ; 00003844  db 0xff
  db 0xFF, 0x00                ; 00003845  inc word [bx+si]
  db 0x00, 0x00                ; 00003847  add [bx+si],al
  db 0x00, 0x00                ; 00003849  add [bx+si],al
  db 0x00, 0x00                ; 0000384B  add [bx+si],al
  db 0x00, 0x00                ; 0000384D  add [bx+si],al
  db 0x00, 0x00                ; 0000384F  add [bx+si],al
  db 0x00, 0x00                ; 00003851  add [bx+si],al
  db 0x00, 0x00                ; 00003853  add [bx+si],al
  db 0x00, 0x5E, 0x38          ; 00003855  add [bp+0x38],bl
  db 0x00, 0x00                ; 00003858  add [bx+si],al
  db 0x00, 0x00                ; 0000385A  add [bx+si],al
  db 0x38, 0x04                ; 0000385C  cmp [si],al
  db 0x00, 0x00                ; 0000385E  add [bx+si],al
  db 0x68, 0x38, 0x00          ; 00003860  push word 0x38
  db 0x00, 0x00                ; 00003863  add [bx+si],al
  db 0x00, 0x38                ; 00003865  add [bx+si],bh
  db 0x04, 0x00                ; 00003867  add al,0x0
  db 0x00, 0x72, 0x38          ; 00003869  add [bp+si+0x38],dh
  db 0x00, 0x00                ; 0000386C  add [bx+si],al
  db 0x00, 0x00                ; 0000386E  add [bx+si],al
  db 0x38, 0x04                ; 00003870  cmp [si],al
  db 0x00, 0x00                ; 00003872  add [bx+si],al
  db 0x7C, 0x38                ; 00003874  jl 0x38ae
  db 0x00, 0x00                ; 00003876  add [bx+si],al
  db 0x00, 0x00                ; 00003878  add [bx+si],al
  db 0x38, 0x04                ; 0000387A  cmp [si],al
  db 0x00, 0x00                ; 0000387C  add [bx+si],al
  db 0x86, 0x38                ; 0000387E  xchg bh,[bx+si]
  db 0x00, 0x00                ; 00003880  add [bx+si],al
  db 0x00, 0x00                ; 00003882  add [bx+si],al
  db 0x38, 0x04                ; 00003884  cmp [si],al
  db 0x00, 0x00                ; 00003886  add [bx+si],al
  db 0x00, 0x00                ; 00003888  add [bx+si],al
  db 0x00, 0x00                ; 0000388A  add [bx+si],al
  db 0x00, 0x00                ; 0000388C  add [bx+si],al
  db 0x38, 0x84, 0xB8, 0x04    ; 0000388E  cmp [si+0x4b8],al
  db 0x00, 0xCD                ; 00003892  add ch,cl
  db 0x28, 0x26, 0x80, 0x7C    ; 00003894  sub [0x7c80],ah
  db 0x0D, 0xFF, 0x74          ; 00003898  or ax,0x74ff
  db 0x03, 0xE9                ; 0000389B  add bp,cx
  db 0x06                      ; 0000389D  push es
  db 0x02, 0xB1, 0x9A, 0xCD    ; 0000389E  add dh,[bx+di-0x3266]
  db 0xE0, 0x2E                ; 000038A2  loopne 0x38d2
  db 0x8C, 0x06, 0x25, 0x56    ; 000038A4  mov [0x5625],es
  db 0x26, 0x8B, 0x47, 0x38    ; 000038A8  mov ax,[es:bx+0x38]
  db 0x2E, 0xA3, 0x2B, 0x56    ; 000038AC  mov [cs:0x562b],ax
  db 0x26, 0x8B, 0x47, 0x3A    ; 000038B0  mov ax,[es:bx+0x3a]
  db 0x2E, 0xA3, 0x2D, 0x56    ; 000038B4  mov [cs:0x562d],ax
  db 0x26, 0x8B, 0x07          ; 000038B8  mov ax,[es:bx]
  db 0x2E, 0xA3, 0x27, 0x56    ; 000038BB  mov [cs:0x5627],ax
  db 0x26, 0x8B, 0x47, 0x02    ; 000038BF  mov ax,[es:bx+0x2]
  db 0x2E, 0xA3, 0x29, 0x56    ; 000038C3  mov [cs:0x5629],ax
  db 0x2E, 0x8E, 0x06, 0x2F, 0x56 ; 000038C7  mov es,[cs:0x562f]
  db 0x8C, 0xD8                ; 000038CC  mov ax,ds
  db 0x8E, 0xC0                ; 000038CE  mov es,ax
  db 0xBF, 0x45, 0x15          ; 000038D0  mov di,0x1545
  db 0xB9, 0x4C, 0x1D          ; 000038D3  mov cx,0x1d4c
  db 0x32, 0xC0                ; 000038D6  xor al,al
  db 0xF3, 0xAA                ; 000038D8  rep stosb
  db 0xBB, 0x9C, 0x33          ; 000038DA  mov bx,0x339c
  db 0xBF, 0x94, 0x33          ; 000038DD  mov di,0x3394
  db 0xE8, 0xEC, 0x01          ; 000038E0  call 0x3acf
  db 0xBB, 0x90, 0x38          ; 000038E3  mov bx,0x3890
  db 0xB9, 0x06, 0x00          ; 000038E6  mov cx,0x6
  db 0xBF, 0x54, 0x38          ; 000038E9  mov di,0x3854
  db 0x51                      ; 000038EC  push cx
  db 0xE8, 0xDF, 0x01          ; 000038ED  call 0x3acf
  db 0x59                      ; 000038F0  pop cx
  db 0x83, 0xC7, 0x0A          ; 000038F1  add di,byte +0xa
  db 0x81, 0xC3, 0x38, 0x04    ; 000038F4  add bx,0x438
  db 0xE2, 0xF2                ; 000038F8  loop 0x38ec
  db 0xB8, 0x00, 0x30          ; 000038FA  mov ax,0x3000
  db 0x8E, 0xC0                ; 000038FD  mov es,ax
  db 0xBF, 0xF6, 0xFF          ; 000038FF  mov di,0xfff6
  db 0x26, 0xC7, 0x05, 0x00, 0x00 ; 00003902  mov word [es:di],0x0
  db 0xB8, 0x00, 0x30          ; 00003907  mov ax,0x3000
  db 0xBB, 0xE0, 0xFF          ; 0000390A  mov bx,0xffe0
  db 0xB1, 0x04                ; 0000390D  mov cl,0x4
  db 0xD3, 0xC0                ; 0000390F  rol ax,cl
  db 0x8A, 0xE8                ; 00003911  mov ch,al
  db 0x24, 0xF0                ; 00003913  and al,0xf0
  db 0x03, 0xC3                ; 00003915  add ax,bx
  db 0x80, 0xD5, 0x00          ; 00003917  adc ch,0x0
  db 0x80, 0xE5, 0x0F          ; 0000391A  and ch,0xf
  db 0x86, 0xE9                ; 0000391D  xchg ch,cl
  db 0x32, 0xED                ; 0000391F  xor ch,ch
  db 0x26, 0x89, 0x45, 0x06    ; 00003921  mov [es:di+0x6],ax
  db 0x26, 0x89, 0x4D, 0x08    ; 00003925  mov [es:di+0x8],cx
  db 0x1E                      ; 00003929  push ds
  db 0xB8, 0x00, 0xF0          ; 0000392A  mov ax,0xf000
  db 0x8E, 0xD8                ; 0000392D  mov ds,ax
  db 0x2E, 0x8E, 0x06, 0x2F, 0x56 ; 0000392F  mov es,[cs:0x562f]
  db 0xBF, 0xAE, 0x3B          ; 00003934  mov di,0x3bae
  db 0xBE, 0x00, 0x60          ; 00003937  mov si,0x6000
  db 0xB9, 0x04, 0x00          ; 0000393A  mov cx,0x4
  db 0xF3, 0xA5                ; 0000393D  rep movsw
  db 0x8C, 0xD8                ; 0000393F  mov ax,ds
  db 0x1F                      ; 00003941  pop ds
  db 0x8E, 0xC0                ; 00003942  mov es,ax
  db 0xBF, 0x00, 0x60          ; 00003944  mov di,0x6000
  db 0x26, 0xC7, 0x05, 0x01, 0x00 ; 00003947  mov word [es:di],0x1
  db 0x26, 0xC7, 0x45, 0x02, 0x74, 0x33 ; 0000394C  mov word [es:di+0x2],0x3374
  db 0x8C, 0xD8                ; 00003952  mov ax,ds
  db 0xB1, 0x04                ; 00003954  mov cl,0x4
  db 0xD3, 0xE0                ; 00003956  shl ax,cl
  db 0x26, 0x89, 0x45, 0x04    ; 00003958  mov [es:di+0x4],ax
  db 0x8C, 0xD8                ; 0000395C  mov ax,ds
  db 0xB1, 0x0C                ; 0000395E  mov cl,0xc
  db 0xD3, 0xE8                ; 00003960  shr ax,cl
  db 0x26, 0x89, 0x45, 0x06    ; 00003962  mov [es:di+0x6],ax
  db 0xB8, 0x00, 0x30          ; 00003966  mov ax,0x3000
  db 0x8E, 0xC0                ; 00003969  mov es,ax
  db 0xBF, 0xE0, 0xFF          ; 0000396B  mov di,0xffe0
  db 0x26, 0xC7, 0x05, 0x01, 0x00 ; 0000396E  mov word [es:di],0x1
  db 0x26, 0xC7, 0x45, 0x02, 0x74, 0x33 ; 00003973  mov word [es:di+0x2],0x3374
  db 0x8C, 0xD8                ; 00003979  mov ax,ds
  db 0xB1, 0x04                ; 0000397B  mov cl,0x4
  db 0xD3, 0xE0                ; 0000397D  shl ax,cl
  db 0x26, 0x89, 0x45, 0x04    ; 0000397F  mov [es:di+0x4],ax
  db 0x8C, 0xD8                ; 00003983  mov ax,ds
  db 0xB1, 0x0C                ; 00003985  mov cl,0xc
  db 0xD3, 0xE8                ; 00003987  shr ax,cl
  db 0x26, 0x89, 0x45, 0x06    ; 00003989  mov [es:di+0x6],ax
  db 0xFA                      ; 0000398D  cli
  db 0x33, 0xC0                ; 0000398E  xor ax,ax
  db 0x8E, 0xC0                ; 00003990  mov es,ax
  db 0xB8, 0x24, 0x3B          ; 00003992  mov ax,0x3b24
  db 0xBF, 0x94, 0x00          ; 00003995  mov di,0x94
  db 0xAB                      ; 00003998  stosw
  db 0x8C, 0xC8                ; 00003999  mov ax,cs
  db 0xAB                      ; 0000399B  stosw
  db 0xB8, 0x87, 0x55          ; 0000399C  mov ax,0x5587
  db 0xBF, 0xA4, 0x00          ; 0000399F  mov di,0xa4
  db 0xAB                      ; 000039A2  stosw
  db 0x8C, 0xC8                ; 000039A3  mov ax,cs
  db 0xAB                      ; 000039A5  stosw
  db 0xBA, 0x02, 0x00          ; 000039A6  mov dx,0x2
  db 0xB0, 0x80                ; 000039A9  mov al,0x80
  db 0xEE                      ; 000039AB  out dx,al
  db 0xFB                      ; 000039AC  sti
  db 0x8C, 0xD8                ; 000039AD  mov ax,ds
  db 0x8E, 0xC0                ; 000039AF  mov es,ax
  db 0xBA, 0x00, 0x01          ; 000039B1  mov dx,0x100
  db 0xEC                      ; 000039B4  in al,dx
  db 0x8C, 0xD8                ; 000039B5  mov ax,ds
  db 0x05, 0x04, 0x00          ; 000039B7  add ax,0x4
  db 0x8E, 0xC0                ; 000039BA  mov es,ax
  db 0xBA, 0x16, 0x00          ; 000039BC  mov dx,0x16
  db 0xE8, 0x68, 0x1E          ; 000039BF  call 0x582a
  db 0xBF, 0x00, 0x60          ; 000039C2  mov di,0x6000
  db 0xBE, 0xAE, 0x3B          ; 000039C5  mov si,0x3bae
  db 0xB9, 0x04, 0x00          ; 000039C8  mov cx,0x4
  db 0xB8, 0x00, 0xF0          ; 000039CB  mov ax,0xf000
  db 0x8E, 0xC0                ; 000039CE  mov es,ax
  db 0xF3, 0xA5                ; 000039D0  rep movsw
  db 0x8C, 0xD8                ; 000039D2  mov ax,ds
  db 0x8E, 0xC0                ; 000039D4  mov es,ax
  db 0xBF, 0x8A, 0x3B          ; 000039D6  mov di,0x3b8a
  db 0xE8, 0x10, 0x01          ; 000039D9  call 0x3aec
  db 0xB8, 0x00, 0x01          ; 000039DC  mov ax,0x100
  db 0xE8, 0x26, 0x1E          ; 000039DF  call 0x5808
  db 0x8C, 0xD8                ; 000039E2  mov ax,ds
  db 0x05, 0x04, 0x00          ; 000039E4  add ax,0x4
  db 0x8E, 0xC0                ; 000039E7  mov es,ax
  db 0xBA, 0x16, 0x00          ; 000039E9  mov dx,0x16
  db 0xE8, 0x3B, 0x1E          ; 000039EC  call 0x582a
  db 0xBE, 0x84, 0x3B          ; 000039EF  mov si,0x3b84
  db 0x81, 0x3C, 0x00, 0xA0    ; 000039F2  cmp word [si],0xa000
  db 0x74, 0x03                ; 000039F6  jz 0x39fb
  db 0xE9, 0xAA, 0x00          ; 000039F8  jmp 0x3aa5
  db 0xBE, 0x90, 0x3B          ; 000039FB  mov si,0x3b90
  db 0x81, 0x3C, 0x00, 0xA0    ; 000039FE  cmp word [si],0xa000
  db 0x74, 0x03                ; 00003A02  jz 0x3a07
  db 0xE9, 0x9E, 0x00          ; 00003A04  jmp 0x3aa5
  db 0xFA                      ; 00003A07  cli
  db 0x33, 0xC0                ; 00003A08  xor ax,ax
  db 0x8E, 0xC0                ; 00003A0A  mov es,ax
  db 0xB8, 0x26, 0x54          ; 00003A0C  mov ax,0x5426
  db 0xBF, 0x94, 0x00          ; 00003A0F  mov di,0x94
  db 0xAB                      ; 00003A12  stosw
  db 0x8C, 0xC8                ; 00003A13  mov ax,cs
  db 0xAB                      ; 00003A15  stosw
  db 0xFB                      ; 00003A16  sti
  db 0xB8, 0x20, 0x00          ; 00003A17  mov ax,0x20
  db 0xBA, 0xA5, 0x53          ; 00003A1A  mov dx,0x53a5
  db 0x8C, 0xC9                ; 00003A1D  mov cx,cs
  db 0xCD, 0x28                ; 00003A1F  int 0x28
  db 0xB8, 0x22, 0x00          ; 00003A21  mov ax,0x22
  db 0xBA, 0xF9, 0x57          ; 00003A24  mov dx,0x57f9
  db 0x8C, 0xC9                ; 00003A27  mov cx,cs
  db 0xCD, 0x28                ; 00003A29  int 0x28
  db 0x8C, 0xD8                ; 00003A2B  mov ax,ds
  db 0x8E, 0xC0                ; 00003A2D  mov es,ax
  db 0x2E, 0xC7, 0x06, 0x78, 0x33, 0x84, 0x33 ; 00003A2F  mov word [cs:0x3378],0x3384
  db 0xBE, 0x00, 0x05          ; 00003A36  mov si,0x500
  db 0x8C, 0x4C, 0x50          ; 00003A39  mov [si+0x50],cs
  db 0x8C, 0x5C, 0x52          ; 00003A3C  mov [si+0x52],ds
  db 0x8C, 0x44, 0x54          ; 00003A3F  mov [si+0x54],es
  db 0x8C, 0x54, 0x56          ; 00003A42  mov [si+0x56],ss
  db 0xBE, 0xA0, 0x02          ; 00003A45  mov si,0x2a0
  db 0x8C, 0x4C, 0x50          ; 00003A48  mov [si+0x50],cs
  db 0x8C, 0x5C, 0x52          ; 00003A4B  mov [si+0x52],ds
  db 0x8C, 0x44, 0x54          ; 00003A4E  mov [si+0x54],es
  db 0x8C, 0x54, 0x56          ; 00003A51  mov [si+0x56],ss
  db 0xBA, 0x70, 0x02          ; 00003A54  mov dx,0x270
  db 0xB1, 0x90                ; 00003A57  mov cl,0x90
  db 0xCD, 0xE0                ; 00003A59  int 0xe0
  db 0x9C                      ; 00003A5B  pushf
  db 0xFA                      ; 00003A5C  cli
  db 0x2E, 0x8B, 0x36, 0x36, 0x15 ; 00003A5D  mov si,[cs:0x1536]
  db 0x2E, 0x8B, 0x3E, 0x3B, 0x15 ; 00003A62  mov di,[cs:0x153b]
  db 0x89, 0x7C, 0x06          ; 00003A67  mov [si+0x6],di
  db 0x2E, 0x89, 0x36, 0x7A, 0x33 ; 00003A6A  mov [cs:0x337a],si
  db 0x2E, 0xC6, 0x06, 0x35, 0x15, 0x00 ; 00003A6F  mov byte [cs:0x1535],0x0
  db 0x2E, 0xC7, 0x06, 0x36, 0x15, 0x00, 0x00 ; 00003A75  mov word [cs:0x1536],0x0
  db 0x2E, 0xC7, 0x06, 0x38, 0x15, 0x00, 0x00 ; 00003A7C  mov word [cs:0x1538],0x0
  db 0x2E, 0xC6, 0x06, 0x3A, 0x15, 0x00 ; 00003A83  mov byte [cs:0x153a],0x0
  db 0x2E, 0xC7, 0x06, 0x3B, 0x15, 0x00, 0x00 ; 00003A89  mov word [cs:0x153b],0x0
  db 0x2E, 0xC7, 0x06, 0x3D, 0x15, 0x00, 0x00 ; 00003A90  mov word [cs:0x153d],0x0
  db 0x2E, 0xC6, 0x06, 0x34, 0x15, 0x00 ; 00003A97  mov byte [cs:0x1534],0x0
  db 0x9D                      ; 00003A9D  popf
  db 0xB8, 0x10, 0x00          ; 00003A9E  mov ax,0x10
  db 0xE8, 0x64, 0x1D          ; 00003AA1  call 0x5808
  db 0xC3                      ; 00003AA4  ret
  db 0xBA, 0xAE, 0x0B          ; 00003AA5  mov dx,0xbae
  db 0xB1, 0x87                ; 00003AA8  mov cl,0x87
  db 0xCD, 0xE0                ; 00003AAA  int 0xe0
  db 0x0B, 0xC0                ; 00003AAC  or ax,ax
  db 0x75, 0x07                ; 00003AAE  jnz 0x3ab7
  db 0xBA, 0xAE, 0x0B          ; 00003AB0  mov dx,0xbae
  db 0xB1, 0x88                ; 00003AB3  mov cl,0x88
  db 0xCD, 0xE0                ; 00003AB5  int 0xe0
  db 0xBA, 0xBE, 0x0B          ; 00003AB7  mov dx,0xbbe
  db 0xB1, 0x87                ; 00003ABA  mov cl,0x87
  db 0xCD, 0xE0                ; 00003ABC  int 0xe0
  db 0x0B, 0xC0                ; 00003ABE  or ax,ax
  db 0x75, 0x07                ; 00003AC0  jnz 0x3ac9
  db 0xBA, 0xBE, 0x0B          ; 00003AC2  mov dx,0xbbe
  db 0xB1, 0x88                ; 00003AC5  mov cl,0x88
  db 0xCD, 0xE0                ; 00003AC7  int 0xe0
  db 0xB1, 0x8F                ; 00003AC9  mov cl,0x8f
  db 0xB2, 0xFF                ; 00003ACB  mov dl,0xff
  db 0xCD, 0xE0                ; 00003ACD  int 0xe0
  db 0x8C, 0xD8                ; 00003ACF  mov ax,ds
  db 0xB1, 0x04                ; 00003AD1  mov cl,0x4
  db 0xD3, 0xC0                ; 00003AD3  rol ax,cl
  db 0x8A, 0xE8                ; 00003AD5  mov ch,al
  db 0x24, 0xF0                ; 00003AD7  and al,0xf0
  db 0x03, 0xC3                ; 00003AD9  add ax,bx
  db 0x80, 0xD5, 0x00          ; 00003ADB  adc ch,0x0
  db 0x80, 0xE5, 0x0F          ; 00003ADE  and ch,0xf
  db 0x86, 0xE9                ; 00003AE1  xchg ch,cl
  db 0x32, 0xED                ; 00003AE3  xor ch,ch
  db 0x89, 0x45, 0x04          ; 00003AE5  mov [di+0x4],ax
  db 0x89, 0x4D, 0x06          ; 00003AE8  mov [di+0x6],cx
  db 0xC3                      ; 00003AEB  ret
  db 0x57                      ; 00003AEC  push di
  db 0xB8, 0x03, 0x00          ; 00003AED  mov ax,0x3
  db 0xCD, 0x28                ; 00003AF0  int 0x28
  db 0x5F                      ; 00003AF2  pop di
  db 0x26, 0x8B, 0x44, 0x05    ; 00003AF3  mov ax,[es:si+0x5]
  db 0x26, 0x8B, 0x54, 0x01    ; 00003AF7  mov dx,[es:si+0x1]
  db 0xD1, 0xE2                ; 00003AFB  shl dx,1
  db 0xF8                      ; 00003AFD  clc
  db 0xD1, 0xD0                ; 00003AFE  rcl ax,1
  db 0x73, 0x01                ; 00003B00  jnc 0x3b03
  db 0x42                      ; 00003B02  inc dx
  db 0xBE, 0x1E, 0x3B          ; 00003B03  mov si,0x3b1e
  db 0x03, 0x04                ; 00003B06  add ax,[si]
  db 0x89, 0x05                ; 00003B08  mov [di],ax
  db 0x13, 0x54, 0x02          ; 00003B0A  adc dx,[si+0x2]
  db 0x89, 0x55, 0x02          ; 00003B0D  mov [di+0x2],dx
  db 0xB8, 0x00, 0x00          ; 00003B10  mov ax,0x0
  db 0x13, 0x44, 0x04          ; 00003B13  adc ax,[si+0x4]
  db 0x89, 0x45, 0x04          ; 00003B16  mov [di+0x4],ax
  db 0x8C, 0xD8                ; 00003B19  mov ax,ds
  db 0x8E, 0xC0                ; 00003B1B  mov es,ax
  db 0xC3                      ; 00003B1D  ret
  db 0x00, 0x00                ; 00003B1E  add [bx+si],al
  db 0x00, 0x00                ; 00003B20  add [bx+si],al
  db 0x00, 0x00                ; 00003B22  add [bx+si],al
  db 0x50                      ; 00003B24  push ax
  db 0x2E, 0x8C, 0x16, 0x31, 0x56 ; 00003B25  mov [cs:0x5631],ss
  db 0x2E, 0x89, 0x26, 0x33, 0x56 ; 00003B2A  mov [cs:0x5633],sp
  db 0xBC, 0xB5, 0x56          ; 00003B2F  mov sp,0x56b5
  db 0x8C, 0xC8                ; 00003B32  mov ax,cs
  db 0x8E, 0xD0                ; 00003B34  mov ss,ax
  db 0x60                      ; 00003B36  pusha
  db 0x1E                      ; 00003B37  push ds
  db 0x8E, 0xD8                ; 00003B38  mov ds,ax
  db 0x2E, 0xA1, 0x74, 0x33    ; 00003B3A  mov ax,[cs:0x3374]
  db 0x25, 0x00, 0xF0          ; 00003B3E  and ax,0xf000
  db 0x2E, 0xA3, 0x76, 0x33    ; 00003B41  mov [cs:0x3376],ax
  db 0xBA, 0x16, 0x00          ; 00003B45  mov dx,0x16
  db 0xE8, 0xF3, 0x1C          ; 00003B48  call 0x583e
  db 0x2E, 0xC6, 0x06, 0xF8, 0x57, 0xFF ; 00003B4B  mov byte [cs:0x57f8],0xff
  db 0x2E, 0x81, 0x0E, 0x76, 0x33, 0x00, 0x00 ; 00003B51  or word [cs:0x3376],0x0
  db 0xBA, 0x00, 0x01          ; 00003B58  mov dx,0x100
  db 0xEC                      ; 00003B5B  in al,dx
  db 0xB0, 0x20                ; 00003B5C  mov al,0x20
  db 0xE6, 0x00                ; 00003B5E  out 0x0,al
  db 0xBA, 0x22, 0xFF          ; 00003B60  mov dx,0xff22
  db 0xB8, 0x00, 0x80          ; 00003B63  mov ax,0x8000
  db 0xEF                      ; 00003B66  out dx,ax
  db 0x1F                      ; 00003B67  pop ds
  db 0x61                      ; 00003B68  popa
  db 0x2E, 0x8B, 0x26, 0x33, 0x56 ; 00003B69  mov sp,[cs:0x5633]
  db 0x2E, 0x8E, 0x16, 0x31, 0x56 ; 00003B6E  mov ss,[cs:0x5631]
  db 0x58                      ; 00003B73  pop ax
  db 0x2E, 0xFF, 0x2E, 0x2B, 0x56 ; 00003B74  jmp far [cs:0x562b]
  db 0x00, 0x00                ; 00003B79  add [bx+si],al
  db 0x00, 0x02                ; 00003B7B  add [bp+si],al
  db 0x00, 0x84, 0x3B, 0x04    ; 00003B7D  add [si+0x43b],al
  db 0x08, 0x00                ; 00003B81  or [bx+si],al
  db 0x66, 0x00, 0x00          ; 00003B83  o32 add [bx+si],al
  db 0x01, 0x00                ; 00003B86  add [bx+si],ax
  db 0x90                      ; 00003B88  nop
  db 0x3B, 0x00                ; 00003B89  cmp ax,[bx+si]
  db 0x00, 0x00                ; 00003B8B  add [bx+si],al
  db 0x00, 0x00                ; 00003B8D  add [bx+si],al
  db 0x00, 0x00                ; 00003B8F  add [bx+si],al
  db 0x00, 0x03                ; 00003B91  add [bp+di],al
  db 0x00, 0xA4, 0x3B, 0x0C    ; 00003B93  add [si+0xc3b],ah
  db 0x00, 0x03                ; 00003B97  add [bp+di],al
  db 0x00, 0x00                ; 00003B99  add [bx+si],al
  db 0x00, 0x00                ; 00003B9B  add [bx+si],al
  db 0x00, 0x01                ; 00003B9D  add [bx+di],al
  db 0x00, 0x00                ; 00003B9F  add [bx+si],al
  db 0x00, 0x00                ; 00003BA1  add [bx+si],al
  db 0x00, 0x00                ; 00003BA3  add [bx+si],al
  db 0x00, 0x02                ; 00003BA5  add [bp+si],al
  db 0x80, 0x84, 0x3B, 0x04, 0x08 ; 00003BA7  add byte [si+0x43b],0x8
  db 0x00, 0x26, 0x00, 0x00    ; 00003BAC  add [0x0],ah
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
  db 0x00, 0x00                ; 00003DF6  add [bx+si],al
  db 0x00, 0x00                ; 00003DF8  add [bx+si],al
  db 0x00, 0x00                ; 00003DFA  add [bx+si],al
  db 0x00, 0x00                ; 00003DFC  add [bx+si],al
  db 0x00, 0x00                ; 00003DFE  add [bx+si],al
  db 0x00, 0x00                ; 00003E00  add [bx+si],al
  db 0x00, 0x00                ; 00003E02  add [bx+si],al
  db 0x00, 0x00                ; 00003E04  add [bx+si],al
  db 0x00, 0x00                ; 00003E06  add [bx+si],al
  db 0x00, 0x00                ; 00003E08  add [bx+si],al
  db 0x00, 0x00                ; 00003E0A  add [bx+si],al
  db 0x00, 0x00                ; 00003E0C  add [bx+si],al
  db 0x00, 0x00                ; 00003E0E  add [bx+si],al
  db 0x00, 0x00                ; 00003E10  add [bx+si],al
  db 0x00, 0x00                ; 00003E12  add [bx+si],al
  db 0x00, 0x00                ; 00003E14  add [bx+si],al
  db 0x00, 0x00                ; 00003E16  add [bx+si],al
  db 0x00, 0x00                ; 00003E18  add [bx+si],al
  db 0x00, 0x00                ; 00003E1A  add [bx+si],al
  db 0x00, 0x00                ; 00003E1C  add [bx+si],al
  db 0x00, 0x00                ; 00003E1E  add [bx+si],al
  db 0x00, 0x00                ; 00003E20  add [bx+si],al
  db 0x00, 0x00                ; 00003E22  add [bx+si],al
  db 0x00, 0x00                ; 00003E24  add [bx+si],al
  db 0x00, 0x00                ; 00003E26  add [bx+si],al
  db 0x00, 0x00                ; 00003E28  add [bx+si],al
  db 0x00, 0x00                ; 00003E2A  add [bx+si],al
  db 0x00, 0x00                ; 00003E2C  add [bx+si],al
  db 0x00, 0x00                ; 00003E2E  add [bx+si],al
  db 0x00, 0x00                ; 00003E30  add [bx+si],al
  db 0x00, 0x00                ; 00003E32  add [bx+si],al
  db 0x00, 0x00                ; 00003E34  add [bx+si],al
  db 0x00, 0x00                ; 00003E36  add [bx+si],al
  db 0x00, 0x00                ; 00003E38  add [bx+si],al
  db 0x00, 0x00                ; 00003E3A  add [bx+si],al
  db 0x00, 0x00                ; 00003E3C  add [bx+si],al
  db 0x00, 0x00                ; 00003E3E  add [bx+si],al
  db 0x00, 0x00                ; 00003E40  add [bx+si],al
  db 0x00, 0x00                ; 00003E42  add [bx+si],al
  db 0x00, 0x00                ; 00003E44  add [bx+si],al
  db 0x00, 0x00                ; 00003E46  add [bx+si],al
  db 0x00, 0x00                ; 00003E48  add [bx+si],al
  db 0x00, 0x00                ; 00003E4A  add [bx+si],al
  db 0x00, 0x00                ; 00003E4C  add [bx+si],al
  db 0x00, 0x00                ; 00003E4E  add [bx+si],al
  db 0x00, 0x00                ; 00003E50  add [bx+si],al
  db 0x00, 0x00                ; 00003E52  add [bx+si],al
  db 0x00, 0x00                ; 00003E54  add [bx+si],al
  db 0x00, 0x00                ; 00003E56  add [bx+si],al
  db 0x00, 0x00                ; 00003E58  add [bx+si],al
  db 0x00, 0x00                ; 00003E5A  add [bx+si],al
  db 0x00, 0x00                ; 00003E5C  add [bx+si],al
  db 0x00, 0x00                ; 00003E5E  add [bx+si],al
  db 0x00, 0x00                ; 00003E60  add [bx+si],al
  db 0x00, 0x00                ; 00003E62  add [bx+si],al
  db 0x00, 0x00                ; 00003E64  add [bx+si],al
  db 0x00, 0x00                ; 00003E66  add [bx+si],al
  db 0x00, 0x00                ; 00003E68  add [bx+si],al
  db 0x00, 0x00                ; 00003E6A  add [bx+si],al
  db 0x00, 0x00                ; 00003E6C  add [bx+si],al
  db 0x00, 0x00                ; 00003E6E  add [bx+si],al
  db 0x00, 0x00                ; 00003E70  add [bx+si],al
  db 0x00, 0x00                ; 00003E72  add [bx+si],al
  db 0x00, 0x00                ; 00003E74  add [bx+si],al
  db 0x00, 0x00                ; 00003E76  add [bx+si],al
  db 0x00, 0x00                ; 00003E78  add [bx+si],al
  db 0x00, 0x00                ; 00003E7A  add [bx+si],al
  db 0x00, 0x00                ; 00003E7C  add [bx+si],al
  db 0x00, 0x00                ; 00003E7E  add [bx+si],al
  db 0x00, 0x00                ; 00003E80  add [bx+si],al
  db 0x00, 0x00                ; 00003E82  add [bx+si],al
  db 0x00, 0x00                ; 00003E84  add [bx+si],al
  db 0x00, 0x00                ; 00003E86  add [bx+si],al
  db 0x00, 0x00                ; 00003E88  add [bx+si],al
  db 0x00, 0x00                ; 00003E8A  add [bx+si],al
  db 0x00, 0x00                ; 00003E8C  add [bx+si],al
  db 0x00, 0x00                ; 00003E8E  add [bx+si],al
  db 0x00, 0x00                ; 00003E90  add [bx+si],al
  db 0x00, 0x00                ; 00003E92  add [bx+si],al
  db 0x00, 0x00                ; 00003E94  add [bx+si],al
  db 0x00, 0x00                ; 00003E96  add [bx+si],al
  db 0x00, 0x00                ; 00003E98  add [bx+si],al
  db 0x00, 0x00                ; 00003E9A  add [bx+si],al
  db 0x00, 0x00                ; 00003E9C  add [bx+si],al
  db 0x00, 0x00                ; 00003E9E  add [bx+si],al
  db 0x00, 0x00                ; 00003EA0  add [bx+si],al
  db 0x00, 0x00                ; 00003EA2  add [bx+si],al
  db 0x00, 0x00                ; 00003EA4  add [bx+si],al
  db 0x00, 0x00                ; 00003EA6  add [bx+si],al
  db 0x00, 0x00                ; 00003EA8  add [bx+si],al
  db 0x00, 0x00                ; 00003EAA  add [bx+si],al
  db 0x00, 0x00                ; 00003EAC  add [bx+si],al
  db 0x00, 0x00                ; 00003EAE  add [bx+si],al
  db 0x00, 0x00                ; 00003EB0  add [bx+si],al
  db 0x00, 0x00                ; 00003EB2  add [bx+si],al
  db 0x00, 0x00                ; 00003EB4  add [bx+si],al
  db 0x00, 0x00                ; 00003EB6  add [bx+si],al
  db 0x00, 0x00                ; 00003EB8  add [bx+si],al
  db 0x00, 0x00                ; 00003EBA  add [bx+si],al
  db 0x00, 0x00                ; 00003EBC  add [bx+si],al
  db 0x00, 0x00                ; 00003EBE  add [bx+si],al
  db 0x00, 0x00                ; 00003EC0  add [bx+si],al
  db 0x00, 0x00                ; 00003EC2  add [bx+si],al
  db 0x00, 0x00                ; 00003EC4  add [bx+si],al
  db 0x00, 0x00                ; 00003EC6  add [bx+si],al
  db 0x00, 0x00                ; 00003EC8  add [bx+si],al
  db 0x00, 0x00                ; 00003ECA  add [bx+si],al
  db 0x00, 0x00                ; 00003ECC  add [bx+si],al
  db 0x00, 0x00                ; 00003ECE  add [bx+si],al
  db 0x00, 0x00                ; 00003ED0  add [bx+si],al
  db 0x00, 0x00                ; 00003ED2  add [bx+si],al
  db 0x00, 0x00                ; 00003ED4  add [bx+si],al
  db 0x00, 0x00                ; 00003ED6  add [bx+si],al
  db 0x00, 0x00                ; 00003ED8  add [bx+si],al
  db 0x00, 0x00                ; 00003EDA  add [bx+si],al
  db 0x00, 0x00                ; 00003EDC  add [bx+si],al
  db 0x00, 0x00                ; 00003EDE  add [bx+si],al
  db 0x00, 0x00                ; 00003EE0  add [bx+si],al
  db 0x00, 0x00                ; 00003EE2  add [bx+si],al
  db 0x00, 0x00                ; 00003EE4  add [bx+si],al
  db 0x00, 0x00                ; 00003EE6  add [bx+si],al
  db 0x00, 0x00                ; 00003EE8  add [bx+si],al
  db 0x00, 0x00                ; 00003EEA  add [bx+si],al
  db 0x00, 0x00                ; 00003EEC  add [bx+si],al
  db 0x00, 0x00                ; 00003EEE  add [bx+si],al
  db 0x00, 0x00                ; 00003EF0  add [bx+si],al
  db 0x00, 0x00                ; 00003EF2  add [bx+si],al
  db 0x00, 0x00                ; 00003EF4  add [bx+si],al
  db 0x00, 0x00                ; 00003EF6  add [bx+si],al
  db 0x00, 0x00                ; 00003EF8  add [bx+si],al
  db 0x00, 0x00                ; 00003EFA  add [bx+si],al
  db 0x00, 0x00                ; 00003EFC  add [bx+si],al
  db 0x00, 0x00                ; 00003EFE  add [bx+si],al
  db 0x00, 0x00                ; 00003F00  add [bx+si],al
  db 0x00, 0x00                ; 00003F02  add [bx+si],al
  db 0x00, 0x00                ; 00003F04  add [bx+si],al
  db 0x00, 0x00                ; 00003F06  add [bx+si],al
  db 0x00, 0x00                ; 00003F08  add [bx+si],al
  db 0x00, 0x00                ; 00003F0A  add [bx+si],al
  db 0x00, 0x00                ; 00003F0C  add [bx+si],al
  db 0x00, 0x00                ; 00003F0E  add [bx+si],al
  db 0x00, 0x00                ; 00003F10  add [bx+si],al
  db 0x00, 0x00                ; 00003F12  add [bx+si],al
  db 0x00, 0x00                ; 00003F14  add [bx+si],al
  db 0x00, 0x00                ; 00003F16  add [bx+si],al
  db 0x00, 0x00                ; 00003F18  add [bx+si],al
  db 0x00, 0x00                ; 00003F1A  add [bx+si],al
  db 0x00, 0x00                ; 00003F1C  add [bx+si],al
  db 0x00, 0x00                ; 00003F1E  add [bx+si],al
  db 0x00, 0x00                ; 00003F20  add [bx+si],al
  db 0x00, 0x00                ; 00003F22  add [bx+si],al
  db 0x00, 0x00                ; 00003F24  add [bx+si],al
  db 0x00, 0x00                ; 00003F26  add [bx+si],al
  db 0x00, 0x00                ; 00003F28  add [bx+si],al
  db 0x00, 0x00                ; 00003F2A  add [bx+si],al
  db 0x00, 0x00                ; 00003F2C  add [bx+si],al
  db 0x00, 0x00                ; 00003F2E  add [bx+si],al
  db 0x00, 0x00                ; 00003F30  add [bx+si],al
  db 0x00, 0x00                ; 00003F32  add [bx+si],al
  db 0x00, 0x00                ; 00003F34  add [bx+si],al
  db 0x00, 0x00                ; 00003F36  add [bx+si],al
  db 0x00, 0x00                ; 00003F38  add [bx+si],al
  db 0x00, 0x00                ; 00003F3A  add [bx+si],al
  db 0x00, 0x00                ; 00003F3C  add [bx+si],al
  db 0x00, 0x00                ; 00003F3E  add [bx+si],al
  db 0x00, 0x00                ; 00003F40  add [bx+si],al
  db 0x00, 0x00                ; 00003F42  add [bx+si],al
  db 0x00, 0x00                ; 00003F44  add [bx+si],al
  db 0x00, 0x00                ; 00003F46  add [bx+si],al
  db 0x00, 0x00                ; 00003F48  add [bx+si],al
  db 0x00, 0x00                ; 00003F4A  add [bx+si],al
  db 0x00, 0x00                ; 00003F4C  add [bx+si],al
  db 0x00, 0x00                ; 00003F4E  add [bx+si],al
  db 0x00, 0x00                ; 00003F50  add [bx+si],al
  db 0x00, 0x00                ; 00003F52  add [bx+si],al
  db 0x00, 0x00                ; 00003F54  add [bx+si],al
  db 0x00, 0x00                ; 00003F56  add [bx+si],al
  db 0x00, 0x00                ; 00003F58  add [bx+si],al
  db 0x00, 0x00                ; 00003F5A  add [bx+si],al
  db 0x00, 0x00                ; 00003F5C  add [bx+si],al
  db 0x00, 0x00                ; 00003F5E  add [bx+si],al
  db 0x00, 0x00                ; 00003F60  add [bx+si],al
  db 0x00, 0x00                ; 00003F62  add [bx+si],al
  db 0x00, 0x00                ; 00003F64  add [bx+si],al
  db 0x00, 0x00                ; 00003F66  add [bx+si],al
  db 0x00, 0x00                ; 00003F68  add [bx+si],al
  db 0x00, 0x00                ; 00003F6A  add [bx+si],al
  db 0x00, 0x00                ; 00003F6C  add [bx+si],al
  db 0x00, 0x00                ; 00003F6E  add [bx+si],al
  db 0x00, 0x00                ; 00003F70  add [bx+si],al
  db 0x00, 0x00                ; 00003F72  add [bx+si],al
  db 0x00, 0x00                ; 00003F74  add [bx+si],al
  db 0x00, 0x00                ; 00003F76  add [bx+si],al
  db 0x00, 0x00                ; 00003F78  add [bx+si],al
  db 0x00, 0x00                ; 00003F7A  add [bx+si],al
  db 0x00, 0x00                ; 00003F7C  add [bx+si],al
  db 0x00, 0x00                ; 00003F7E  add [bx+si],al
  db 0x00, 0x00                ; 00003F80  add [bx+si],al
  db 0x00, 0x00                ; 00003F82  add [bx+si],al
  db 0x00, 0x00                ; 00003F84  add [bx+si],al
  db 0x00, 0x00                ; 00003F86  add [bx+si],al
  db 0x00, 0x00                ; 00003F88  add [bx+si],al
  db 0x00, 0x00                ; 00003F8A  add [bx+si],al
  db 0x00, 0x00                ; 00003F8C  add [bx+si],al
  db 0x00, 0x00                ; 00003F8E  add [bx+si],al
  db 0x00, 0x00                ; 00003F90  add [bx+si],al
  db 0x00, 0x00                ; 00003F92  add [bx+si],al
  db 0x00, 0x00                ; 00003F94  add [bx+si],al
  db 0x00, 0x00                ; 00003F96  add [bx+si],al
  db 0x00, 0x00                ; 00003F98  add [bx+si],al
  db 0x00, 0x00                ; 00003F9A  add [bx+si],al
  db 0x00, 0x00                ; 00003F9C  add [bx+si],al
  db 0x00, 0x00                ; 00003F9E  add [bx+si],al
  db 0x00, 0x00                ; 00003FA0  add [bx+si],al
  db 0x00, 0x00                ; 00003FA2  add [bx+si],al
  db 0x00, 0x00                ; 00003FA4  add [bx+si],al
  db 0x00, 0x00                ; 00003FA6  add [bx+si],al
  db 0x00, 0x00                ; 00003FA8  add [bx+si],al
  db 0x00, 0x00                ; 00003FAA  add [bx+si],al
  db 0x00, 0x00                ; 00003FAC  add [bx+si],al
  db 0x00, 0x00                ; 00003FAE  add [bx+si],al
  db 0x00, 0x00                ; 00003FB0  add [bx+si],al
  db 0x00, 0x00                ; 00003FB2  add [bx+si],al
  db 0x00, 0x00                ; 00003FB4  add [bx+si],al
  db 0x00, 0x00                ; 00003FB6  add [bx+si],al
  db 0x00, 0x00                ; 00003FB8  add [bx+si],al
  db 0x00, 0x00                ; 00003FBA  add [bx+si],al
  db 0x00, 0x00                ; 00003FBC  add [bx+si],al
  db 0x00, 0x00                ; 00003FBE  add [bx+si],al
  db 0x00, 0x00                ; 00003FC0  add [bx+si],al
  db 0x00, 0x00                ; 00003FC2  add [bx+si],al
  db 0x00, 0x00                ; 00003FC4  add [bx+si],al
  db 0x00, 0x00                ; 00003FC6  add [bx+si],al
  db 0x00, 0x00                ; 00003FC8  add [bx+si],al
  db 0x00, 0x00                ; 00003FCA  add [bx+si],al
  db 0x00, 0x00                ; 00003FCC  add [bx+si],al
  db 0x00, 0x00                ; 00003FCE  add [bx+si],al
  db 0x00, 0x00                ; 00003FD0  add [bx+si],al
  db 0x00, 0x00                ; 00003FD2  add [bx+si],al
  db 0x00, 0x00                ; 00003FD4  add [bx+si],al
  db 0x00, 0x00                ; 00003FD6  add [bx+si],al
  db 0x00, 0x00                ; 00003FD8  add [bx+si],al
  db 0x00, 0x00                ; 00003FDA  add [bx+si],al
  db 0x00, 0x00                ; 00003FDC  add [bx+si],al
  db 0x00, 0x00                ; 00003FDE  add [bx+si],al
  db 0x00, 0x00                ; 00003FE0  add [bx+si],al
  db 0x00, 0x00                ; 00003FE2  add [bx+si],al
  db 0x00, 0x00                ; 00003FE4  add [bx+si],al
  db 0x00, 0x00                ; 00003FE6  add [bx+si],al
  db 0x00, 0x00                ; 00003FE8  add [bx+si],al
  db 0x00, 0x00                ; 00003FEA  add [bx+si],al
  db 0x00, 0x00                ; 00003FEC  add [bx+si],al
  db 0x00, 0x00                ; 00003FEE  add [bx+si],al
  db 0x00, 0x00                ; 00003FF0  add [bx+si],al
  db 0x00, 0x00                ; 00003FF2  add [bx+si],al
  db 0x00, 0x00                ; 00003FF4  add [bx+si],al
  db 0x00, 0x00                ; 00003FF6  add [bx+si],al
  db 0x00, 0x00                ; 00003FF8  add [bx+si],al
  db 0x00, 0x00                ; 00003FFA  add [bx+si],al
  db 0x00, 0x00                ; 00003FFC  add [bx+si],al
  db 0x00, 0x00                ; 00003FFE  add [bx+si],al
  db 0x00, 0x00                ; 00004000  add [bx+si],al
  db 0x00, 0x00                ; 00004002  add [bx+si],al
  db 0x00, 0x00                ; 00004004  add [bx+si],al
  db 0x00, 0x00                ; 00004006  add [bx+si],al
  db 0x00, 0x00                ; 00004008  add [bx+si],al
  db 0x00, 0x00                ; 0000400A  add [bx+si],al
  db 0x00, 0x00                ; 0000400C  add [bx+si],al
  db 0x00, 0x00                ; 0000400E  add [bx+si],al
  db 0x00, 0x00                ; 00004010  add [bx+si],al
  db 0x00, 0x00                ; 00004012  add [bx+si],al
  db 0x00, 0x00                ; 00004014  add [bx+si],al
  db 0x00, 0x00                ; 00004016  add [bx+si],al
  db 0x00, 0x00                ; 00004018  add [bx+si],al
  db 0x00, 0x00                ; 0000401A  add [bx+si],al
  db 0x00, 0x00                ; 0000401C  add [bx+si],al
  db 0x00, 0x00                ; 0000401E  add [bx+si],al
  db 0x00, 0x00                ; 00004020  add [bx+si],al
  db 0x00, 0x00                ; 00004022  add [bx+si],al
  db 0x00, 0x00                ; 00004024  add [bx+si],al
  db 0x00, 0x00                ; 00004026  add [bx+si],al
  db 0x00, 0x00                ; 00004028  add [bx+si],al
  db 0x00, 0x00                ; 0000402A  add [bx+si],al
  db 0x00, 0x00                ; 0000402C  add [bx+si],al
  db 0x00, 0x00                ; 0000402E  add [bx+si],al
  db 0x00, 0x00                ; 00004030  add [bx+si],al
  db 0x00, 0x00                ; 00004032  add [bx+si],al
  db 0x00, 0x00                ; 00004034  add [bx+si],al
  db 0x00, 0x00                ; 00004036  add [bx+si],al
  db 0x00, 0x00                ; 00004038  add [bx+si],al
  db 0x00, 0x00                ; 0000403A  add [bx+si],al
  db 0x00, 0x00                ; 0000403C  add [bx+si],al
  db 0x00, 0x00                ; 0000403E  add [bx+si],al
  db 0x00, 0x00                ; 00004040  add [bx+si],al
  db 0x00, 0x00                ; 00004042  add [bx+si],al
  db 0x00, 0x00                ; 00004044  add [bx+si],al
  db 0x00, 0x00                ; 00004046  add [bx+si],al
  db 0x00, 0x00                ; 00004048  add [bx+si],al
  db 0x00, 0x00                ; 0000404A  add [bx+si],al
  db 0x00, 0x00                ; 0000404C  add [bx+si],al
  db 0x00, 0x00                ; 0000404E  add [bx+si],al
  db 0x00, 0x00                ; 00004050  add [bx+si],al
  db 0x00, 0x00                ; 00004052  add [bx+si],al
  db 0x00, 0x00                ; 00004054  add [bx+si],al
  db 0x00, 0x00                ; 00004056  add [bx+si],al
  db 0x00, 0x00                ; 00004058  add [bx+si],al
  db 0x00, 0x00                ; 0000405A  add [bx+si],al
  db 0x00, 0x00                ; 0000405C  add [bx+si],al
  db 0x00, 0x00                ; 0000405E  add [bx+si],al
  db 0x00, 0x00                ; 00004060  add [bx+si],al
  db 0x00, 0x00                ; 00004062  add [bx+si],al
  db 0x00, 0x00                ; 00004064  add [bx+si],al
  db 0x00, 0x00                ; 00004066  add [bx+si],al
  db 0x00, 0x00                ; 00004068  add [bx+si],al
  db 0x00, 0x00                ; 0000406A  add [bx+si],al
  db 0x00, 0x00                ; 0000406C  add [bx+si],al
  db 0x00, 0x00                ; 0000406E  add [bx+si],al
  db 0x00, 0x00                ; 00004070  add [bx+si],al
  db 0x00, 0x00                ; 00004072  add [bx+si],al
  db 0x00, 0x00                ; 00004074  add [bx+si],al
  db 0x00, 0x00                ; 00004076  add [bx+si],al
  db 0x00, 0x00                ; 00004078  add [bx+si],al
  db 0x00, 0x00                ; 0000407A  add [bx+si],al
  db 0x00, 0x00                ; 0000407C  add [bx+si],al
  db 0x00, 0x00                ; 0000407E  add [bx+si],al
  db 0x00, 0x00                ; 00004080  add [bx+si],al
  db 0x00, 0x00                ; 00004082  add [bx+si],al
  db 0x00, 0x00                ; 00004084  add [bx+si],al
  db 0x00, 0x00                ; 00004086  add [bx+si],al
  db 0x00, 0x00                ; 00004088  add [bx+si],al
  db 0x00, 0x00                ; 0000408A  add [bx+si],al
  db 0x00, 0x00                ; 0000408C  add [bx+si],al
  db 0x00, 0x00                ; 0000408E  add [bx+si],al
  db 0x00, 0x00                ; 00004090  add [bx+si],al
  db 0x00, 0x00                ; 00004092  add [bx+si],al
  db 0x00, 0x00                ; 00004094  add [bx+si],al
  db 0x00, 0x00                ; 00004096  add [bx+si],al
  db 0x00, 0x00                ; 00004098  add [bx+si],al
  db 0x00, 0x00                ; 0000409A  add [bx+si],al
  db 0x00, 0x00                ; 0000409C  add [bx+si],al
  db 0x00, 0x00                ; 0000409E  add [bx+si],al
  db 0x00, 0x00                ; 000040A0  add [bx+si],al
  db 0x00, 0x00                ; 000040A2  add [bx+si],al
  db 0x00, 0x00                ; 000040A4  add [bx+si],al
  db 0x00, 0x00                ; 000040A6  add [bx+si],al
  db 0x00, 0x00                ; 000040A8  add [bx+si],al
  db 0x00, 0x00                ; 000040AA  add [bx+si],al
  db 0x00, 0x00                ; 000040AC  add [bx+si],al
  db 0x00, 0x00                ; 000040AE  add [bx+si],al
  db 0x00, 0x00                ; 000040B0  add [bx+si],al
  db 0x00, 0x00                ; 000040B2  add [bx+si],al
  db 0x00, 0x00                ; 000040B4  add [bx+si],al
  db 0x00, 0x00                ; 000040B6  add [bx+si],al
  db 0x00, 0x00                ; 000040B8  add [bx+si],al
  db 0x00, 0x00                ; 000040BA  add [bx+si],al
  db 0x00, 0x00                ; 000040BC  add [bx+si],al
  db 0x00, 0x00                ; 000040BE  add [bx+si],al
  db 0x00, 0x00                ; 000040C0  add [bx+si],al
  db 0x00, 0x00                ; 000040C2  add [bx+si],al
  db 0x00, 0x00                ; 000040C4  add [bx+si],al
  db 0x00, 0x00                ; 000040C6  add [bx+si],al
  db 0x00, 0x00                ; 000040C8  add [bx+si],al
  db 0x00, 0x00                ; 000040CA  add [bx+si],al
  db 0x00, 0x00                ; 000040CC  add [bx+si],al
  db 0x00, 0x00                ; 000040CE  add [bx+si],al
  db 0x00, 0x00                ; 000040D0  add [bx+si],al
  db 0x00, 0x00                ; 000040D2  add [bx+si],al
  db 0x00, 0x00                ; 000040D4  add [bx+si],al
  db 0x00, 0x00                ; 000040D6  add [bx+si],al
  db 0x00, 0x00                ; 000040D8  add [bx+si],al
  db 0x00, 0x00                ; 000040DA  add [bx+si],al
  db 0x00, 0x00                ; 000040DC  add [bx+si],al
  db 0x00, 0x00                ; 000040DE  add [bx+si],al
  db 0x00, 0x00                ; 000040E0  add [bx+si],al
  db 0x00, 0x00                ; 000040E2  add [bx+si],al
  db 0x00, 0x00                ; 000040E4  add [bx+si],al
  db 0x00, 0x00                ; 000040E6  add [bx+si],al
  db 0x00, 0x00                ; 000040E8  add [bx+si],al
  db 0x00, 0x00                ; 000040EA  add [bx+si],al
  db 0x00, 0x00                ; 000040EC  add [bx+si],al
  db 0x00, 0x00                ; 000040EE  add [bx+si],al
  db 0x00, 0x00                ; 000040F0  add [bx+si],al
  db 0x00, 0x00                ; 000040F2  add [bx+si],al
  db 0x00, 0x00                ; 000040F4  add [bx+si],al
  db 0x00, 0x00                ; 000040F6  add [bx+si],al
  db 0x00, 0x00                ; 000040F8  add [bx+si],al
  db 0x00, 0x00                ; 000040FA  add [bx+si],al
  db 0x00, 0x00                ; 000040FC  add [bx+si],al
  db 0x00, 0x00                ; 000040FE  add [bx+si],al
  db 0x00, 0x00                ; 00004100  add [bx+si],al
  db 0x00, 0x00                ; 00004102  add [bx+si],al
  db 0x00, 0x00                ; 00004104  add [bx+si],al
  db 0x00, 0x00                ; 00004106  add [bx+si],al
  db 0x00, 0x00                ; 00004108  add [bx+si],al
  db 0x00, 0x00                ; 0000410A  add [bx+si],al
  db 0x00, 0x00                ; 0000410C  add [bx+si],al
  db 0x00, 0x00                ; 0000410E  add [bx+si],al
  db 0x00, 0x00                ; 00004110  add [bx+si],al
  db 0x00, 0x00                ; 00004112  add [bx+si],al
  db 0x00, 0x00                ; 00004114  add [bx+si],al
  db 0x00, 0x00                ; 00004116  add [bx+si],al
  db 0x00, 0x00                ; 00004118  add [bx+si],al
  db 0x00, 0x00                ; 0000411A  add [bx+si],al
  db 0x00, 0x00                ; 0000411C  add [bx+si],al
  db 0x00, 0x00                ; 0000411E  add [bx+si],al
  db 0x00, 0x00                ; 00004120  add [bx+si],al
  db 0x00, 0x00                ; 00004122  add [bx+si],al
  db 0x00, 0x00                ; 00004124  add [bx+si],al
  db 0x00, 0x00                ; 00004126  add [bx+si],al
  db 0x00, 0x00                ; 00004128  add [bx+si],al
  db 0x00, 0x00                ; 0000412A  add [bx+si],al
  db 0x00, 0x00                ; 0000412C  add [bx+si],al
  db 0x00, 0x00                ; 0000412E  add [bx+si],al
  db 0x00, 0x00                ; 00004130  add [bx+si],al
  db 0x00, 0x00                ; 00004132  add [bx+si],al
  db 0x00, 0x00                ; 00004134  add [bx+si],al
  db 0x00, 0x00                ; 00004136  add [bx+si],al
  db 0x00, 0x00                ; 00004138  add [bx+si],al
  db 0x00, 0x00                ; 0000413A  add [bx+si],al
  db 0x00, 0x00                ; 0000413C  add [bx+si],al
  db 0x00, 0x00                ; 0000413E  add [bx+si],al
  db 0x00, 0x00                ; 00004140  add [bx+si],al
  db 0x00, 0x00                ; 00004142  add [bx+si],al
  db 0x00, 0x00                ; 00004144  add [bx+si],al
  db 0x00, 0x00                ; 00004146  add [bx+si],al
  db 0x00, 0x00                ; 00004148  add [bx+si],al
  db 0x00, 0x00                ; 0000414A  add [bx+si],al
  db 0x00, 0x00                ; 0000414C  add [bx+si],al
  db 0x00, 0x00                ; 0000414E  add [bx+si],al
  db 0x00, 0x00                ; 00004150  add [bx+si],al
  db 0x00, 0x00                ; 00004152  add [bx+si],al
  db 0x00, 0x00                ; 00004154  add [bx+si],al
  db 0x00, 0x00                ; 00004156  add [bx+si],al
  db 0x00, 0x00                ; 00004158  add [bx+si],al
  db 0x00, 0x00                ; 0000415A  add [bx+si],al
  db 0x00, 0x00                ; 0000415C  add [bx+si],al
  db 0x00, 0x00                ; 0000415E  add [bx+si],al
  db 0x00, 0x00                ; 00004160  add [bx+si],al
  db 0x00, 0x00                ; 00004162  add [bx+si],al
  db 0x00, 0x00                ; 00004164  add [bx+si],al
  db 0x00, 0x00                ; 00004166  add [bx+si],al
  db 0x00, 0x00                ; 00004168  add [bx+si],al
  db 0x00, 0x00                ; 0000416A  add [bx+si],al
  db 0x00, 0x00                ; 0000416C  add [bx+si],al
  db 0x00, 0x00                ; 0000416E  add [bx+si],al
  db 0x00, 0x00                ; 00004170  add [bx+si],al
  db 0x00, 0x00                ; 00004172  add [bx+si],al
  db 0x00, 0x00                ; 00004174  add [bx+si],al
  db 0x00, 0x00                ; 00004176  add [bx+si],al
  db 0x00, 0x00                ; 00004178  add [bx+si],al
  db 0x00, 0x00                ; 0000417A  add [bx+si],al
  db 0x00, 0x00                ; 0000417C  add [bx+si],al
  db 0x00, 0x00                ; 0000417E  add [bx+si],al
  db 0x00, 0x00                ; 00004180  add [bx+si],al
  db 0x00, 0x00                ; 00004182  add [bx+si],al
  db 0x00, 0x00                ; 00004184  add [bx+si],al
  db 0x00, 0x00                ; 00004186  add [bx+si],al
  db 0x00, 0x00                ; 00004188  add [bx+si],al
  db 0x00, 0x00                ; 0000418A  add [bx+si],al
  db 0x00, 0x00                ; 0000418C  add [bx+si],al
  db 0x00, 0x00                ; 0000418E  add [bx+si],al
  db 0x00, 0x00                ; 00004190  add [bx+si],al
  db 0x00, 0x00                ; 00004192  add [bx+si],al
  db 0x00, 0x00                ; 00004194  add [bx+si],al
  db 0x00, 0x00                ; 00004196  add [bx+si],al
  db 0x00, 0x00                ; 00004198  add [bx+si],al
  db 0x00, 0x00                ; 0000419A  add [bx+si],al
  db 0x00, 0x00                ; 0000419C  add [bx+si],al
  db 0x00, 0x00                ; 0000419E  add [bx+si],al
  db 0x00, 0x00                ; 000041A0  add [bx+si],al
  db 0x00, 0x00                ; 000041A2  add [bx+si],al
  db 0x00, 0x00                ; 000041A4  add [bx+si],al
  db 0x00, 0x00                ; 000041A6  add [bx+si],al
  db 0x00, 0x00                ; 000041A8  add [bx+si],al
  db 0x00, 0x00                ; 000041AA  add [bx+si],al
  db 0x00, 0x00                ; 000041AC  add [bx+si],al
  db 0x00, 0x00                ; 000041AE  add [bx+si],al
  db 0x00, 0x00                ; 000041B0  add [bx+si],al
  db 0x00, 0x00                ; 000041B2  add [bx+si],al
  db 0x00, 0x00                ; 000041B4  add [bx+si],al
  db 0x00, 0x00                ; 000041B6  add [bx+si],al
  db 0x00, 0x00                ; 000041B8  add [bx+si],al
  db 0x00, 0x00                ; 000041BA  add [bx+si],al
  db 0x00, 0x00                ; 000041BC  add [bx+si],al
  db 0x00, 0x00                ; 000041BE  add [bx+si],al
  db 0x00, 0x00                ; 000041C0  add [bx+si],al
  db 0x00, 0x00                ; 000041C2  add [bx+si],al
  db 0x00, 0x00                ; 000041C4  add [bx+si],al
  db 0x00, 0x00                ; 000041C6  add [bx+si],al
  db 0x00, 0x00                ; 000041C8  add [bx+si],al
  db 0x00, 0x00                ; 000041CA  add [bx+si],al
  db 0x00, 0x00                ; 000041CC  add [bx+si],al
  db 0x00, 0x00                ; 000041CE  add [bx+si],al
  db 0x00, 0x00                ; 000041D0  add [bx+si],al
  db 0x00, 0x00                ; 000041D2  add [bx+si],al
  db 0x00, 0x00                ; 000041D4  add [bx+si],al
  db 0x00, 0x00                ; 000041D6  add [bx+si],al
  db 0x00, 0x00                ; 000041D8  add [bx+si],al
  db 0x00, 0x00                ; 000041DA  add [bx+si],al
  db 0x00, 0x00                ; 000041DC  add [bx+si],al
  db 0x00, 0x00                ; 000041DE  add [bx+si],al
  db 0x00, 0x00                ; 000041E0  add [bx+si],al
  db 0x00, 0x00                ; 000041E2  add [bx+si],al
  db 0x00, 0x00                ; 000041E4  add [bx+si],al
  db 0x00, 0x00                ; 000041E6  add [bx+si],al
  db 0x00, 0x00                ; 000041E8  add [bx+si],al
  db 0x00, 0x00                ; 000041EA  add [bx+si],al
  db 0x00, 0x00                ; 000041EC  add [bx+si],al
  db 0x00, 0x00                ; 000041EE  add [bx+si],al
  db 0x00, 0x00                ; 000041F0  add [bx+si],al
  db 0x00, 0x00                ; 000041F2  add [bx+si],al
  db 0x00, 0x00                ; 000041F4  add [bx+si],al
  db 0x00, 0x00                ; 000041F6  add [bx+si],al
  db 0x00, 0x00                ; 000041F8  add [bx+si],al
  db 0x00, 0x00                ; 000041FA  add [bx+si],al
  db 0x00, 0x00                ; 000041FC  add [bx+si],al
  db 0x00, 0x00                ; 000041FE  add [bx+si],al
  db 0x00, 0x00                ; 00004200  add [bx+si],al
  db 0x00, 0x00                ; 00004202  add [bx+si],al
  db 0x00, 0x00                ; 00004204  add [bx+si],al
  db 0x00, 0x00                ; 00004206  add [bx+si],al
  db 0x00, 0x00                ; 00004208  add [bx+si],al
  db 0x00, 0x00                ; 0000420A  add [bx+si],al
  db 0x00, 0x00                ; 0000420C  add [bx+si],al
  db 0x00, 0x00                ; 0000420E  add [bx+si],al
  db 0x00, 0x00                ; 00004210  add [bx+si],al
  db 0x00, 0x00                ; 00004212  add [bx+si],al
  db 0x00, 0x00                ; 00004214  add [bx+si],al
  db 0x00, 0x00                ; 00004216  add [bx+si],al
  db 0x00, 0x00                ; 00004218  add [bx+si],al
  db 0x00, 0x00                ; 0000421A  add [bx+si],al
  db 0x00, 0x00                ; 0000421C  add [bx+si],al
  db 0x00, 0x00                ; 0000421E  add [bx+si],al
  db 0x00, 0x00                ; 00004220  add [bx+si],al
  db 0x00, 0x00                ; 00004222  add [bx+si],al
  db 0x00, 0x00                ; 00004224  add [bx+si],al
  db 0x00, 0x00                ; 00004226  add [bx+si],al
  db 0x00, 0x00                ; 00004228  add [bx+si],al
  db 0x00, 0x00                ; 0000422A  add [bx+si],al
  db 0x00, 0x00                ; 0000422C  add [bx+si],al
  db 0x00, 0x00                ; 0000422E  add [bx+si],al
  db 0x00, 0x00                ; 00004230  add [bx+si],al
  db 0x00, 0x00                ; 00004232  add [bx+si],al
  db 0x00, 0x00                ; 00004234  add [bx+si],al
  db 0x00, 0x00                ; 00004236  add [bx+si],al
  db 0x00, 0x00                ; 00004238  add [bx+si],al
  db 0x00, 0x00                ; 0000423A  add [bx+si],al
  db 0x00, 0x00                ; 0000423C  add [bx+si],al
  db 0x00, 0x00                ; 0000423E  add [bx+si],al
  db 0x00, 0x00                ; 00004240  add [bx+si],al
  db 0x00, 0x00                ; 00004242  add [bx+si],al
  db 0x00, 0x00                ; 00004244  add [bx+si],al
  db 0x00, 0x00                ; 00004246  add [bx+si],al
  db 0x00, 0x00                ; 00004248  add [bx+si],al
  db 0x00, 0x00                ; 0000424A  add [bx+si],al
  db 0x00, 0x00                ; 0000424C  add [bx+si],al
  db 0x00, 0x00                ; 0000424E  add [bx+si],al
  db 0x00, 0x00                ; 00004250  add [bx+si],al
  db 0x00, 0x00                ; 00004252  add [bx+si],al
  db 0x00, 0x00                ; 00004254  add [bx+si],al
  db 0x00, 0x00                ; 00004256  add [bx+si],al
  db 0x00, 0x00                ; 00004258  add [bx+si],al
  db 0x00, 0x00                ; 0000425A  add [bx+si],al
  db 0x00, 0x00                ; 0000425C  add [bx+si],al
  db 0x00, 0x00                ; 0000425E  add [bx+si],al
  db 0x00, 0x00                ; 00004260  add [bx+si],al
  db 0x00, 0x00                ; 00004262  add [bx+si],al
  db 0x00, 0x00                ; 00004264  add [bx+si],al
  db 0x00, 0x00                ; 00004266  add [bx+si],al
  db 0x00, 0x00                ; 00004268  add [bx+si],al
  db 0x00, 0x00                ; 0000426A  add [bx+si],al
  db 0x00, 0x00                ; 0000426C  add [bx+si],al
  db 0x00, 0x00                ; 0000426E  add [bx+si],al
  db 0x00, 0x00                ; 00004270  add [bx+si],al
  db 0x00, 0x00                ; 00004272  add [bx+si],al
  db 0x00, 0x00                ; 00004274  add [bx+si],al
  db 0x00, 0x00                ; 00004276  add [bx+si],al
  db 0x00, 0x00                ; 00004278  add [bx+si],al
  db 0x00, 0x00                ; 0000427A  add [bx+si],al
  db 0x00, 0x00                ; 0000427C  add [bx+si],al
  db 0x00, 0x00                ; 0000427E  add [bx+si],al
  db 0x00, 0x00                ; 00004280  add [bx+si],al
  db 0x00, 0x00                ; 00004282  add [bx+si],al
  db 0x00, 0x00                ; 00004284  add [bx+si],al
  db 0x00, 0x00                ; 00004286  add [bx+si],al
  db 0x00, 0x00                ; 00004288  add [bx+si],al
  db 0x00, 0x00                ; 0000428A  add [bx+si],al
  db 0x00, 0x00                ; 0000428C  add [bx+si],al
  db 0x00, 0x00                ; 0000428E  add [bx+si],al
  db 0x00, 0x00                ; 00004290  add [bx+si],al
  db 0x00, 0x00                ; 00004292  add [bx+si],al
  db 0x00, 0x00                ; 00004294  add [bx+si],al
  db 0x00, 0x00                ; 00004296  add [bx+si],al
  db 0x00, 0x00                ; 00004298  add [bx+si],al
  db 0x00, 0x00                ; 0000429A  add [bx+si],al
  db 0x00, 0x00                ; 0000429C  add [bx+si],al
  db 0x00, 0x00                ; 0000429E  add [bx+si],al
  db 0x00, 0x00                ; 000042A0  add [bx+si],al
  db 0x00, 0x00                ; 000042A2  add [bx+si],al
  db 0x00, 0x00                ; 000042A4  add [bx+si],al
  db 0x00, 0x00                ; 000042A6  add [bx+si],al
  db 0x00, 0x00                ; 000042A8  add [bx+si],al
  db 0x00, 0x00                ; 000042AA  add [bx+si],al
  db 0x00, 0x00                ; 000042AC  add [bx+si],al
  db 0x00, 0x00                ; 000042AE  add [bx+si],al
  db 0x00, 0x00                ; 000042B0  add [bx+si],al
  db 0x00, 0x00                ; 000042B2  add [bx+si],al
  db 0x00, 0x00                ; 000042B4  add [bx+si],al
  db 0x00, 0x00                ; 000042B6  add [bx+si],al
  db 0x00, 0x00                ; 000042B8  add [bx+si],al
  db 0x00, 0x00                ; 000042BA  add [bx+si],al
  db 0x00, 0x00                ; 000042BC  add [bx+si],al
  db 0x00, 0x00                ; 000042BE  add [bx+si],al
  db 0x00, 0x00                ; 000042C0  add [bx+si],al
  db 0x00, 0x00                ; 000042C2  add [bx+si],al
  db 0x00, 0x00                ; 000042C4  add [bx+si],al
  db 0x00, 0x00                ; 000042C6  add [bx+si],al
  db 0x00, 0x00                ; 000042C8  add [bx+si],al
  db 0x00, 0x00                ; 000042CA  add [bx+si],al
  db 0x00, 0x00                ; 000042CC  add [bx+si],al
  db 0x00, 0x00                ; 000042CE  add [bx+si],al
  db 0x00, 0x00                ; 000042D0  add [bx+si],al
  db 0x00, 0x00                ; 000042D2  add [bx+si],al
  db 0x00, 0x00                ; 000042D4  add [bx+si],al
  db 0x00, 0x00                ; 000042D6  add [bx+si],al
  db 0x00, 0x00                ; 000042D8  add [bx+si],al
  db 0x00, 0x00                ; 000042DA  add [bx+si],al
  db 0x00, 0x00                ; 000042DC  add [bx+si],al
  db 0x00, 0x00                ; 000042DE  add [bx+si],al
  db 0x00, 0x00                ; 000042E0  add [bx+si],al
  db 0x00, 0x00                ; 000042E2  add [bx+si],al
  db 0x00, 0x00                ; 000042E4  add [bx+si],al
  db 0x00, 0x00                ; 000042E6  add [bx+si],al
  db 0x00, 0x00                ; 000042E8  add [bx+si],al
  db 0x00, 0x00                ; 000042EA  add [bx+si],al
  db 0x00, 0x00                ; 000042EC  add [bx+si],al
  db 0x00, 0x00                ; 000042EE  add [bx+si],al
  db 0x00, 0x00                ; 000042F0  add [bx+si],al
  db 0x00, 0x00                ; 000042F2  add [bx+si],al
  db 0x00, 0x00                ; 000042F4  add [bx+si],al
  db 0x00, 0x00                ; 000042F6  add [bx+si],al
  db 0x00, 0x00                ; 000042F8  add [bx+si],al
  db 0x00, 0x00                ; 000042FA  add [bx+si],al
  db 0x00, 0x00                ; 000042FC  add [bx+si],al
  db 0x00, 0x00                ; 000042FE  add [bx+si],al
  db 0x00, 0x00                ; 00004300  add [bx+si],al
  db 0x00, 0x00                ; 00004302  add [bx+si],al
  db 0x00, 0x00                ; 00004304  add [bx+si],al
  db 0x00, 0x00                ; 00004306  add [bx+si],al
  db 0x00, 0x00                ; 00004308  add [bx+si],al
  db 0x00, 0x00                ; 0000430A  add [bx+si],al
  db 0x00, 0x00                ; 0000430C  add [bx+si],al
  db 0x00, 0x00                ; 0000430E  add [bx+si],al
  db 0x00, 0x00                ; 00004310  add [bx+si],al
  db 0x00, 0x00                ; 00004312  add [bx+si],al
  db 0x00, 0x00                ; 00004314  add [bx+si],al
  db 0x00, 0x00                ; 00004316  add [bx+si],al
  db 0x00, 0x00                ; 00004318  add [bx+si],al
  db 0x00, 0x00                ; 0000431A  add [bx+si],al
  db 0x00, 0x00                ; 0000431C  add [bx+si],al
  db 0x00, 0x00                ; 0000431E  add [bx+si],al
  db 0x00, 0x00                ; 00004320  add [bx+si],al
  db 0x00, 0x00                ; 00004322  add [bx+si],al
  db 0x00, 0x00                ; 00004324  add [bx+si],al
  db 0x00, 0x00                ; 00004326  add [bx+si],al
  db 0x00, 0x00                ; 00004328  add [bx+si],al
  db 0x00, 0x00                ; 0000432A  add [bx+si],al
  db 0x00, 0x00                ; 0000432C  add [bx+si],al
  db 0x00, 0x00                ; 0000432E  add [bx+si],al
  db 0x00, 0x00                ; 00004330  add [bx+si],al
  db 0x00, 0x00                ; 00004332  add [bx+si],al
  db 0x00, 0x00                ; 00004334  add [bx+si],al
  db 0x00, 0x00                ; 00004336  add [bx+si],al
  db 0x00, 0x00                ; 00004338  add [bx+si],al
  db 0x00, 0x00                ; 0000433A  add [bx+si],al
  db 0x00, 0x00                ; 0000433C  add [bx+si],al
  db 0x00, 0x00                ; 0000433E  add [bx+si],al
  db 0x00, 0x00                ; 00004340  add [bx+si],al
  db 0x00, 0x00                ; 00004342  add [bx+si],al
  db 0x00, 0x00                ; 00004344  add [bx+si],al
  db 0x00, 0x00                ; 00004346  add [bx+si],al
  db 0x00, 0x00                ; 00004348  add [bx+si],al
  db 0x00, 0x00                ; 0000434A  add [bx+si],al
  db 0x00, 0x00                ; 0000434C  add [bx+si],al
  db 0x00, 0x00                ; 0000434E  add [bx+si],al
  db 0x00, 0x00                ; 00004350  add [bx+si],al
  db 0x00, 0x00                ; 00004352  add [bx+si],al
  db 0x00, 0x00                ; 00004354  add [bx+si],al
  db 0x00, 0x00                ; 00004356  add [bx+si],al
  db 0x00, 0x00                ; 00004358  add [bx+si],al
  db 0x00, 0x00                ; 0000435A  add [bx+si],al
  db 0x00, 0x00                ; 0000435C  add [bx+si],al
  db 0x00, 0x00                ; 0000435E  add [bx+si],al
  db 0x00, 0x00                ; 00004360  add [bx+si],al
  db 0x00, 0x00                ; 00004362  add [bx+si],al
  db 0x00, 0x00                ; 00004364  add [bx+si],al
  db 0x00, 0x00                ; 00004366  add [bx+si],al
  db 0x00, 0x00                ; 00004368  add [bx+si],al
  db 0x00, 0x00                ; 0000436A  add [bx+si],al
  db 0x00, 0x00                ; 0000436C  add [bx+si],al
  db 0x00, 0x00                ; 0000436E  add [bx+si],al
  db 0x00, 0x00                ; 00004370  add [bx+si],al
  db 0x00, 0x00                ; 00004372  add [bx+si],al
  db 0x00, 0x00                ; 00004374  add [bx+si],al
  db 0x00, 0x00                ; 00004376  add [bx+si],al
  db 0x00, 0x00                ; 00004378  add [bx+si],al
  db 0x00, 0x00                ; 0000437A  add [bx+si],al
  db 0x00, 0x00                ; 0000437C  add [bx+si],al
  db 0x00, 0x00                ; 0000437E  add [bx+si],al
  db 0x00, 0x00                ; 00004380  add [bx+si],al
  db 0x00, 0x00                ; 00004382  add [bx+si],al
  db 0x00, 0x00                ; 00004384  add [bx+si],al
  db 0x00, 0x00                ; 00004386  add [bx+si],al
  db 0x00, 0x00                ; 00004388  add [bx+si],al
  db 0x00, 0x00                ; 0000438A  add [bx+si],al
  db 0x00, 0x00                ; 0000438C  add [bx+si],al
  db 0x00, 0x00                ; 0000438E  add [bx+si],al
  db 0x00, 0x00                ; 00004390  add [bx+si],al
  db 0x00, 0x00                ; 00004392  add [bx+si],al
  db 0x00, 0x00                ; 00004394  add [bx+si],al
  db 0x00, 0x00                ; 00004396  add [bx+si],al
  db 0x00, 0x00                ; 00004398  add [bx+si],al
  db 0x00, 0x00                ; 0000439A  add [bx+si],al
  db 0x00, 0x00                ; 0000439C  add [bx+si],al
  db 0x00, 0x00                ; 0000439E  add [bx+si],al
  db 0x00, 0x00                ; 000043A0  add [bx+si],al
  db 0x00, 0x00                ; 000043A2  add [bx+si],al
  db 0x00, 0x00                ; 000043A4  add [bx+si],al
  db 0x00, 0x00                ; 000043A6  add [bx+si],al
  db 0x00, 0x00                ; 000043A8  add [bx+si],al
  db 0x00, 0x00                ; 000043AA  add [bx+si],al
  db 0x00, 0x00                ; 000043AC  add [bx+si],al
  db 0x00, 0x00                ; 000043AE  add [bx+si],al
  db 0x00, 0x00                ; 000043B0  add [bx+si],al
  db 0x00, 0x00                ; 000043B2  add [bx+si],al
  db 0x00, 0x00                ; 000043B4  add [bx+si],al
  db 0x00, 0x00                ; 000043B6  add [bx+si],al
  db 0x00, 0x00                ; 000043B8  add [bx+si],al
  db 0x00, 0x00                ; 000043BA  add [bx+si],al
  db 0x00, 0x00                ; 000043BC  add [bx+si],al
  db 0x00, 0x00                ; 000043BE  add [bx+si],al
  db 0x00, 0x00                ; 000043C0  add [bx+si],al
  db 0x00, 0x00                ; 000043C2  add [bx+si],al
  db 0x00, 0x00                ; 000043C4  add [bx+si],al
  db 0x00, 0x00                ; 000043C6  add [bx+si],al
  db 0x00, 0x00                ; 000043C8  add [bx+si],al
  db 0x00, 0x00                ; 000043CA  add [bx+si],al
  db 0x00, 0x00                ; 000043CC  add [bx+si],al
  db 0x00, 0x00                ; 000043CE  add [bx+si],al
  db 0x00, 0x00                ; 000043D0  add [bx+si],al
  db 0x00, 0x00                ; 000043D2  add [bx+si],al
  db 0x00, 0x00                ; 000043D4  add [bx+si],al
  db 0x00, 0x00                ; 000043D6  add [bx+si],al
  db 0x00, 0x00                ; 000043D8  add [bx+si],al
  db 0x00, 0x00                ; 000043DA  add [bx+si],al
  db 0x00, 0x00                ; 000043DC  add [bx+si],al
  db 0x00, 0x00                ; 000043DE  add [bx+si],al
  db 0x00, 0x00                ; 000043E0  add [bx+si],al
  db 0x00, 0x00                ; 000043E2  add [bx+si],al
  db 0x00, 0x00                ; 000043E4  add [bx+si],al
  db 0x00, 0x00                ; 000043E6  add [bx+si],al
  db 0x00, 0x00                ; 000043E8  add [bx+si],al
  db 0x00, 0x00                ; 000043EA  add [bx+si],al
  db 0x00, 0x00                ; 000043EC  add [bx+si],al
  db 0x00, 0x00                ; 000043EE  add [bx+si],al
  db 0x00, 0x00                ; 000043F0  add [bx+si],al
  db 0x00, 0x00                ; 000043F2  add [bx+si],al
  db 0x00, 0x00                ; 000043F4  add [bx+si],al
  db 0x00, 0x00                ; 000043F6  add [bx+si],al
  db 0x00, 0x00                ; 000043F8  add [bx+si],al
  db 0x00, 0x00                ; 000043FA  add [bx+si],al
  db 0x00, 0x00                ; 000043FC  add [bx+si],al
  db 0x00, 0x00                ; 000043FE  add [bx+si],al
  db 0x00, 0x00                ; 00004400  add [bx+si],al
  db 0x00, 0x00                ; 00004402  add [bx+si],al
  db 0x00, 0x00                ; 00004404  add [bx+si],al
  db 0x00, 0x00                ; 00004406  add [bx+si],al
  db 0x00, 0x00                ; 00004408  add [bx+si],al
  db 0x00, 0x00                ; 0000440A  add [bx+si],al
  db 0x00, 0x00                ; 0000440C  add [bx+si],al
  db 0x00, 0x00                ; 0000440E  add [bx+si],al
  db 0x00, 0x00                ; 00004410  add [bx+si],al
  db 0x00, 0x00                ; 00004412  add [bx+si],al
  db 0x00, 0x00                ; 00004414  add [bx+si],al
  db 0x00, 0x00                ; 00004416  add [bx+si],al
  db 0x00, 0x00                ; 00004418  add [bx+si],al
  db 0x00, 0x00                ; 0000441A  add [bx+si],al
  db 0x00, 0x00                ; 0000441C  add [bx+si],al
  db 0x00, 0x00                ; 0000441E  add [bx+si],al
  db 0x00, 0x00                ; 00004420  add [bx+si],al
  db 0x00, 0x00                ; 00004422  add [bx+si],al
  db 0x00, 0x00                ; 00004424  add [bx+si],al
  db 0x00, 0x00                ; 00004426  add [bx+si],al
  db 0x00, 0x00                ; 00004428  add [bx+si],al
  db 0x00, 0x00                ; 0000442A  add [bx+si],al
  db 0x00, 0x00                ; 0000442C  add [bx+si],al
  db 0x00, 0x00                ; 0000442E  add [bx+si],al
  db 0x00, 0x00                ; 00004430  add [bx+si],al
  db 0x00, 0x00                ; 00004432  add [bx+si],al
  db 0x00, 0x00                ; 00004434  add [bx+si],al
  db 0x00, 0x00                ; 00004436  add [bx+si],al
  db 0x00, 0x00                ; 00004438  add [bx+si],al
  db 0x00, 0x00                ; 0000443A  add [bx+si],al
  db 0x00, 0x00                ; 0000443C  add [bx+si],al
  db 0x00, 0x00                ; 0000443E  add [bx+si],al
  db 0x00, 0x00                ; 00004440  add [bx+si],al
  db 0x00, 0x00                ; 00004442  add [bx+si],al
  db 0x00, 0x00                ; 00004444  add [bx+si],al
  db 0x00, 0x00                ; 00004446  add [bx+si],al
  db 0x00, 0x00                ; 00004448  add [bx+si],al
  db 0x00, 0x00                ; 0000444A  add [bx+si],al
  db 0x00, 0x00                ; 0000444C  add [bx+si],al
  db 0x00, 0x00                ; 0000444E  add [bx+si],al
  db 0x00, 0x00                ; 00004450  add [bx+si],al
  db 0x00, 0x00                ; 00004452  add [bx+si],al
  db 0x00, 0x00                ; 00004454  add [bx+si],al
  db 0x00, 0x00                ; 00004456  add [bx+si],al
  db 0x00, 0x00                ; 00004458  add [bx+si],al
  db 0x00, 0x00                ; 0000445A  add [bx+si],al
  db 0x00, 0x00                ; 0000445C  add [bx+si],al
  db 0x00, 0x00                ; 0000445E  add [bx+si],al
  db 0x00, 0x00                ; 00004460  add [bx+si],al
  db 0x00, 0x00                ; 00004462  add [bx+si],al
  db 0x00, 0x00                ; 00004464  add [bx+si],al
  db 0x00, 0x00                ; 00004466  add [bx+si],al
  db 0x00, 0x00                ; 00004468  add [bx+si],al
  db 0x00, 0x00                ; 0000446A  add [bx+si],al
  db 0x00, 0x00                ; 0000446C  add [bx+si],al
  db 0x00, 0x00                ; 0000446E  add [bx+si],al
  db 0x00, 0x00                ; 00004470  add [bx+si],al
  db 0x00, 0x00                ; 00004472  add [bx+si],al
  db 0x00, 0x00                ; 00004474  add [bx+si],al
  db 0x00, 0x00                ; 00004476  add [bx+si],al
  db 0x00, 0x00                ; 00004478  add [bx+si],al
  db 0x00, 0x00                ; 0000447A  add [bx+si],al
  db 0x00, 0x00                ; 0000447C  add [bx+si],al
  db 0x00, 0x00                ; 0000447E  add [bx+si],al
  db 0x00, 0x00                ; 00004480  add [bx+si],al
  db 0x00, 0x00                ; 00004482  add [bx+si],al
  db 0x00, 0x00                ; 00004484  add [bx+si],al
  db 0x00, 0x00                ; 00004486  add [bx+si],al
  db 0x00, 0x00                ; 00004488  add [bx+si],al
  db 0x00, 0x00                ; 0000448A  add [bx+si],al
  db 0x00, 0x00                ; 0000448C  add [bx+si],al
  db 0x00, 0x00                ; 0000448E  add [bx+si],al
  db 0x00, 0x00                ; 00004490  add [bx+si],al
  db 0x00, 0x00                ; 00004492  add [bx+si],al
  db 0x00, 0x00                ; 00004494  add [bx+si],al
  db 0x00, 0x00                ; 00004496  add [bx+si],al
  db 0x00, 0x00                ; 00004498  add [bx+si],al
  db 0x00, 0x00                ; 0000449A  add [bx+si],al
  db 0x00, 0x00                ; 0000449C  add [bx+si],al
  db 0x00, 0x00                ; 0000449E  add [bx+si],al
  db 0x00, 0x00                ; 000044A0  add [bx+si],al
  db 0x00, 0x00                ; 000044A2  add [bx+si],al
  db 0x00, 0x00                ; 000044A4  add [bx+si],al
  db 0x00, 0x00                ; 000044A6  add [bx+si],al
  db 0x00, 0x00                ; 000044A8  add [bx+si],al
  db 0x00, 0x00                ; 000044AA  add [bx+si],al
  db 0x00, 0x00                ; 000044AC  add [bx+si],al
  db 0x00, 0x00                ; 000044AE  add [bx+si],al
  db 0x00, 0x00                ; 000044B0  add [bx+si],al
  db 0x00, 0x00                ; 000044B2  add [bx+si],al
  db 0x00, 0x00                ; 000044B4  add [bx+si],al
  db 0x00, 0x00                ; 000044B6  add [bx+si],al
  db 0x00, 0x00                ; 000044B8  add [bx+si],al
  db 0x00, 0x00                ; 000044BA  add [bx+si],al
  db 0x00, 0x00                ; 000044BC  add [bx+si],al
  db 0x00, 0x00                ; 000044BE  add [bx+si],al
  db 0x00, 0x00                ; 000044C0  add [bx+si],al
  db 0x00, 0x00                ; 000044C2  add [bx+si],al
  db 0x00, 0x00                ; 000044C4  add [bx+si],al
  db 0x00, 0x00                ; 000044C6  add [bx+si],al
  db 0x00, 0x00                ; 000044C8  add [bx+si],al
  db 0x00, 0x00                ; 000044CA  add [bx+si],al
  db 0x00, 0x00                ; 000044CC  add [bx+si],al
  db 0x00, 0x00                ; 000044CE  add [bx+si],al
  db 0x00, 0x00                ; 000044D0  add [bx+si],al
  db 0x00, 0x00                ; 000044D2  add [bx+si],al
  db 0x00, 0x00                ; 000044D4  add [bx+si],al
  db 0x00, 0x00                ; 000044D6  add [bx+si],al
  db 0x00, 0x00                ; 000044D8  add [bx+si],al
  db 0x00, 0x00                ; 000044DA  add [bx+si],al
  db 0x00, 0x00                ; 000044DC  add [bx+si],al
  db 0x00, 0x00                ; 000044DE  add [bx+si],al
  db 0x00, 0x00                ; 000044E0  add [bx+si],al
  db 0x00, 0x00                ; 000044E2  add [bx+si],al
  db 0x00, 0x00                ; 000044E4  add [bx+si],al
  db 0x00, 0x00                ; 000044E6  add [bx+si],al
  db 0x00, 0x00                ; 000044E8  add [bx+si],al
  db 0x00, 0x00                ; 000044EA  add [bx+si],al
  db 0x00, 0x00                ; 000044EC  add [bx+si],al
  db 0x00, 0x00                ; 000044EE  add [bx+si],al
  db 0x00, 0x00                ; 000044F0  add [bx+si],al
  db 0x00, 0x00                ; 000044F2  add [bx+si],al
  db 0x00, 0x00                ; 000044F4  add [bx+si],al
  db 0x00, 0x00                ; 000044F6  add [bx+si],al
  db 0x00, 0x00                ; 000044F8  add [bx+si],al
  db 0x00, 0x00                ; 000044FA  add [bx+si],al
  db 0x00, 0x00                ; 000044FC  add [bx+si],al
  db 0x00, 0x00                ; 000044FE  add [bx+si],al
  db 0x00, 0x00                ; 00004500  add [bx+si],al
  db 0x00, 0x00                ; 00004502  add [bx+si],al
  db 0x00, 0x00                ; 00004504  add [bx+si],al
  db 0x00, 0x00                ; 00004506  add [bx+si],al
  db 0x00, 0x00                ; 00004508  add [bx+si],al
  db 0x00, 0x00                ; 0000450A  add [bx+si],al
  db 0x00, 0x00                ; 0000450C  add [bx+si],al
  db 0x00, 0x00                ; 0000450E  add [bx+si],al
  db 0x00, 0x00                ; 00004510  add [bx+si],al
  db 0x00, 0x00                ; 00004512  add [bx+si],al
  db 0x00, 0x00                ; 00004514  add [bx+si],al
  db 0x00, 0x00                ; 00004516  add [bx+si],al
  db 0x00, 0x00                ; 00004518  add [bx+si],al
  db 0x00, 0x00                ; 0000451A  add [bx+si],al
  db 0x00, 0x00                ; 0000451C  add [bx+si],al
  db 0x00, 0x00                ; 0000451E  add [bx+si],al
  db 0x00, 0x00                ; 00004520  add [bx+si],al
  db 0x00, 0x00                ; 00004522  add [bx+si],al
  db 0x00, 0x00                ; 00004524  add [bx+si],al
  db 0x00, 0x00                ; 00004526  add [bx+si],al
  db 0x00, 0x00                ; 00004528  add [bx+si],al
  db 0x00, 0x00                ; 0000452A  add [bx+si],al
  db 0x00, 0x00                ; 0000452C  add [bx+si],al
  db 0x00, 0x00                ; 0000452E  add [bx+si],al
  db 0x00, 0x00                ; 00004530  add [bx+si],al
  db 0x00, 0x00                ; 00004532  add [bx+si],al
  db 0x00, 0x00                ; 00004534  add [bx+si],al
  db 0x00, 0x00                ; 00004536  add [bx+si],al
  db 0x00, 0x00                ; 00004538  add [bx+si],al
  db 0x00, 0x00                ; 0000453A  add [bx+si],al
  db 0x00, 0x00                ; 0000453C  add [bx+si],al
  db 0x00, 0x00                ; 0000453E  add [bx+si],al
  db 0x00, 0x00                ; 00004540  add [bx+si],al
  db 0x00, 0x00                ; 00004542  add [bx+si],al
  db 0x00, 0x00                ; 00004544  add [bx+si],al
  db 0x00, 0x00                ; 00004546  add [bx+si],al
  db 0x00, 0x00                ; 00004548  add [bx+si],al
  db 0x00, 0x00                ; 0000454A  add [bx+si],al
  db 0x00, 0x00                ; 0000454C  add [bx+si],al
  db 0x00, 0x00                ; 0000454E  add [bx+si],al
  db 0x00, 0x00                ; 00004550  add [bx+si],al
  db 0x00, 0x00                ; 00004552  add [bx+si],al
  db 0x00, 0x00                ; 00004554  add [bx+si],al
  db 0x00, 0x00                ; 00004556  add [bx+si],al
  db 0x00, 0x00                ; 00004558  add [bx+si],al
  db 0x00, 0x00                ; 0000455A  add [bx+si],al
  db 0x00, 0x00                ; 0000455C  add [bx+si],al
  db 0x00, 0x00                ; 0000455E  add [bx+si],al
  db 0x00, 0x00                ; 00004560  add [bx+si],al
  db 0x00, 0x00                ; 00004562  add [bx+si],al
  db 0x00, 0x00                ; 00004564  add [bx+si],al
  db 0x00, 0x00                ; 00004566  add [bx+si],al
  db 0x00, 0x00                ; 00004568  add [bx+si],al
  db 0x00, 0x00                ; 0000456A  add [bx+si],al
  db 0x00, 0x00                ; 0000456C  add [bx+si],al
  db 0x00, 0x00                ; 0000456E  add [bx+si],al
  db 0x00, 0x00                ; 00004570  add [bx+si],al
  db 0x00, 0x00                ; 00004572  add [bx+si],al
  db 0x00, 0x00                ; 00004574  add [bx+si],al
  db 0x00, 0x00                ; 00004576  add [bx+si],al
  db 0x00, 0x00                ; 00004578  add [bx+si],al
  db 0x00, 0x00                ; 0000457A  add [bx+si],al
  db 0x00, 0x00                ; 0000457C  add [bx+si],al
  db 0x00, 0x00                ; 0000457E  add [bx+si],al
  db 0x00, 0x00                ; 00004580  add [bx+si],al
  db 0x00, 0x00                ; 00004582  add [bx+si],al
  db 0x00, 0x00                ; 00004584  add [bx+si],al
  db 0x00, 0x00                ; 00004586  add [bx+si],al
  db 0x00, 0x00                ; 00004588  add [bx+si],al
  db 0x00, 0x00                ; 0000458A  add [bx+si],al
  db 0x00, 0x00                ; 0000458C  add [bx+si],al
  db 0x00, 0x00                ; 0000458E  add [bx+si],al
  db 0x00, 0x00                ; 00004590  add [bx+si],al
  db 0x00, 0x00                ; 00004592  add [bx+si],al
  db 0x00, 0x00                ; 00004594  add [bx+si],al
  db 0x00, 0x00                ; 00004596  add [bx+si],al
  db 0x00, 0x00                ; 00004598  add [bx+si],al
  db 0x00, 0x00                ; 0000459A  add [bx+si],al
  db 0x00, 0x00                ; 0000459C  add [bx+si],al
  db 0x00, 0x00                ; 0000459E  add [bx+si],al
  db 0x00, 0x00                ; 000045A0  add [bx+si],al
  db 0x00, 0x00                ; 000045A2  add [bx+si],al
  db 0x00, 0x00                ; 000045A4  add [bx+si],al
  db 0x00, 0x00                ; 000045A6  add [bx+si],al
  db 0x00, 0x00                ; 000045A8  add [bx+si],al
  db 0x00, 0x00                ; 000045AA  add [bx+si],al
  db 0x00, 0x00                ; 000045AC  add [bx+si],al
  db 0x00, 0x00                ; 000045AE  add [bx+si],al
  db 0x00, 0x00                ; 000045B0  add [bx+si],al
  db 0x00, 0x00                ; 000045B2  add [bx+si],al
  db 0x00, 0x00                ; 000045B4  add [bx+si],al
  db 0x00, 0x00                ; 000045B6  add [bx+si],al
  db 0x00, 0x00                ; 000045B8  add [bx+si],al
  db 0x00, 0x00                ; 000045BA  add [bx+si],al
  db 0x00, 0x00                ; 000045BC  add [bx+si],al
  db 0x00, 0x00                ; 000045BE  add [bx+si],al
  db 0x00, 0x00                ; 000045C0  add [bx+si],al
  db 0x00, 0x00                ; 000045C2  add [bx+si],al
  db 0x00, 0x00                ; 000045C4  add [bx+si],al
  db 0x00, 0x00                ; 000045C6  add [bx+si],al
  db 0x00, 0x00                ; 000045C8  add [bx+si],al
  db 0x00, 0x00                ; 000045CA  add [bx+si],al
  db 0x00, 0x00                ; 000045CC  add [bx+si],al
  db 0x00, 0x00                ; 000045CE  add [bx+si],al
  db 0x00, 0x00                ; 000045D0  add [bx+si],al
  db 0x00, 0x00                ; 000045D2  add [bx+si],al
  db 0x00, 0x00                ; 000045D4  add [bx+si],al
  db 0x00, 0x00                ; 000045D6  add [bx+si],al
  db 0x00, 0x00                ; 000045D8  add [bx+si],al
  db 0x00, 0x00                ; 000045DA  add [bx+si],al
  db 0x00, 0x00                ; 000045DC  add [bx+si],al
  db 0x00, 0x00                ; 000045DE  add [bx+si],al
  db 0x00, 0x00                ; 000045E0  add [bx+si],al
  db 0x00, 0x00                ; 000045E2  add [bx+si],al
  db 0x00, 0x00                ; 000045E4  add [bx+si],al
  db 0x00, 0x00                ; 000045E6  add [bx+si],al
  db 0x00, 0x00                ; 000045E8  add [bx+si],al
  db 0x00, 0x00                ; 000045EA  add [bx+si],al
  db 0x00, 0x00                ; 000045EC  add [bx+si],al
  db 0x00, 0x00                ; 000045EE  add [bx+si],al
  db 0x00, 0x00                ; 000045F0  add [bx+si],al
  db 0x00, 0x00                ; 000045F2  add [bx+si],al
  db 0x00, 0x00                ; 000045F4  add [bx+si],al
  db 0x00, 0x00                ; 000045F6  add [bx+si],al
  db 0x00, 0x00                ; 000045F8  add [bx+si],al
  db 0x00, 0x00                ; 000045FA  add [bx+si],al
  db 0x00, 0x00                ; 000045FC  add [bx+si],al
  db 0x00, 0x00                ; 000045FE  add [bx+si],al
  db 0x00, 0x00                ; 00004600  add [bx+si],al
  db 0x00, 0x00                ; 00004602  add [bx+si],al
  db 0x00, 0x00                ; 00004604  add [bx+si],al
  db 0x00, 0x00                ; 00004606  add [bx+si],al
  db 0x00, 0x00                ; 00004608  add [bx+si],al
  db 0x00, 0x00                ; 0000460A  add [bx+si],al
  db 0x00, 0x00                ; 0000460C  add [bx+si],al
  db 0x00, 0x00                ; 0000460E  add [bx+si],al
  db 0x00, 0x00                ; 00004610  add [bx+si],al
  db 0x00, 0x00                ; 00004612  add [bx+si],al
  db 0x00, 0x00                ; 00004614  add [bx+si],al
  db 0x00, 0x00                ; 00004616  add [bx+si],al
  db 0x00, 0x00                ; 00004618  add [bx+si],al
  db 0x00, 0x00                ; 0000461A  add [bx+si],al
  db 0x00, 0x00                ; 0000461C  add [bx+si],al
  db 0x00, 0x00                ; 0000461E  add [bx+si],al
  db 0x00, 0x00                ; 00004620  add [bx+si],al
  db 0x00, 0x00                ; 00004622  add [bx+si],al
  db 0x00, 0x00                ; 00004624  add [bx+si],al
  db 0x00, 0x00                ; 00004626  add [bx+si],al
  db 0x00, 0x00                ; 00004628  add [bx+si],al
  db 0x00, 0x00                ; 0000462A  add [bx+si],al
  db 0x00, 0x00                ; 0000462C  add [bx+si],al
  db 0x00, 0x00                ; 0000462E  add [bx+si],al
  db 0x00, 0x00                ; 00004630  add [bx+si],al
  db 0x00, 0x00                ; 00004632  add [bx+si],al
  db 0x00, 0x00                ; 00004634  add [bx+si],al
  db 0x00, 0x00                ; 00004636  add [bx+si],al
  db 0x00, 0x00                ; 00004638  add [bx+si],al
  db 0x00, 0x00                ; 0000463A  add [bx+si],al
  db 0x00, 0x00                ; 0000463C  add [bx+si],al
  db 0x00, 0x00                ; 0000463E  add [bx+si],al
  db 0x00, 0x00                ; 00004640  add [bx+si],al
  db 0x00, 0x00                ; 00004642  add [bx+si],al
  db 0x00, 0x00                ; 00004644  add [bx+si],al
  db 0x00, 0x00                ; 00004646  add [bx+si],al
  db 0x00, 0x00                ; 00004648  add [bx+si],al
  db 0x00, 0x00                ; 0000464A  add [bx+si],al
  db 0x00, 0x00                ; 0000464C  add [bx+si],al
  db 0x00, 0x00                ; 0000464E  add [bx+si],al
  db 0x00, 0x00                ; 00004650  add [bx+si],al
  db 0x00, 0x00                ; 00004652  add [bx+si],al
  db 0x00, 0x00                ; 00004654  add [bx+si],al
  db 0x00, 0x00                ; 00004656  add [bx+si],al
  db 0x00, 0x00                ; 00004658  add [bx+si],al
  db 0x00, 0x00                ; 0000465A  add [bx+si],al
  db 0x00, 0x00                ; 0000465C  add [bx+si],al
  db 0x00, 0x00                ; 0000465E  add [bx+si],al
  db 0x00, 0x00                ; 00004660  add [bx+si],al
  db 0x00, 0x00                ; 00004662  add [bx+si],al
  db 0x00, 0x00                ; 00004664  add [bx+si],al
  db 0x00, 0x00                ; 00004666  add [bx+si],al
  db 0x00, 0x00                ; 00004668  add [bx+si],al
  db 0x00, 0x00                ; 0000466A  add [bx+si],al
  db 0x00, 0x00                ; 0000466C  add [bx+si],al
  db 0x00, 0x00                ; 0000466E  add [bx+si],al
  db 0x00, 0x00                ; 00004670  add [bx+si],al
  db 0x00, 0x00                ; 00004672  add [bx+si],al
  db 0x00, 0x00                ; 00004674  add [bx+si],al
  db 0x00, 0x00                ; 00004676  add [bx+si],al
  db 0x00, 0x00                ; 00004678  add [bx+si],al
  db 0x00, 0x00                ; 0000467A  add [bx+si],al
  db 0x00, 0x00                ; 0000467C  add [bx+si],al
  db 0x00, 0x00                ; 0000467E  add [bx+si],al
  db 0x00, 0x00                ; 00004680  add [bx+si],al
  db 0x00, 0x00                ; 00004682  add [bx+si],al
  db 0x00, 0x00                ; 00004684  add [bx+si],al
  db 0x00, 0x00                ; 00004686  add [bx+si],al
  db 0x00, 0x00                ; 00004688  add [bx+si],al
  db 0x00, 0x00                ; 0000468A  add [bx+si],al
  db 0x00, 0x00                ; 0000468C  add [bx+si],al
  db 0x00, 0x00                ; 0000468E  add [bx+si],al
  db 0x00, 0x00                ; 00004690  add [bx+si],al
  db 0x00, 0x00                ; 00004692  add [bx+si],al
  db 0x00, 0x00                ; 00004694  add [bx+si],al
  db 0x00, 0x00                ; 00004696  add [bx+si],al
  db 0x00, 0x00                ; 00004698  add [bx+si],al
  db 0x00, 0x00                ; 0000469A  add [bx+si],al
  db 0x00, 0x00                ; 0000469C  add [bx+si],al
  db 0x00, 0x00                ; 0000469E  add [bx+si],al
  db 0x00, 0x00                ; 000046A0  add [bx+si],al
  db 0x00, 0x00                ; 000046A2  add [bx+si],al
  db 0x00, 0x00                ; 000046A4  add [bx+si],al
  db 0x00, 0x00                ; 000046A6  add [bx+si],al
  db 0x00, 0x00                ; 000046A8  add [bx+si],al
  db 0x00, 0x00                ; 000046AA  add [bx+si],al
  db 0x00, 0x00                ; 000046AC  add [bx+si],al
  db 0x00, 0x00                ; 000046AE  add [bx+si],al
  db 0x00, 0x00                ; 000046B0  add [bx+si],al
  db 0x00, 0x00                ; 000046B2  add [bx+si],al
  db 0x00, 0x00                ; 000046B4  add [bx+si],al
  db 0x00, 0x00                ; 000046B6  add [bx+si],al
  db 0x00, 0x00                ; 000046B8  add [bx+si],al
  db 0x00, 0x00                ; 000046BA  add [bx+si],al
  db 0x00, 0x00                ; 000046BC  add [bx+si],al
  db 0x00, 0x00                ; 000046BE  add [bx+si],al
  db 0x00, 0x00                ; 000046C0  add [bx+si],al
  db 0x00, 0x00                ; 000046C2  add [bx+si],al
  db 0x00, 0x00                ; 000046C4  add [bx+si],al
  db 0x00, 0x00                ; 000046C6  add [bx+si],al
  db 0x00, 0x00                ; 000046C8  add [bx+si],al
  db 0x00, 0x00                ; 000046CA  add [bx+si],al
  db 0x00, 0x00                ; 000046CC  add [bx+si],al
  db 0x00, 0x00                ; 000046CE  add [bx+si],al
  db 0x00, 0x00                ; 000046D0  add [bx+si],al
  db 0x00, 0x00                ; 000046D2  add [bx+si],al
  db 0x00, 0x00                ; 000046D4  add [bx+si],al
  db 0x00, 0x00                ; 000046D6  add [bx+si],al
  db 0x00, 0x00                ; 000046D8  add [bx+si],al
  db 0x00, 0x00                ; 000046DA  add [bx+si],al
  db 0x00, 0x00                ; 000046DC  add [bx+si],al
  db 0x00, 0x00                ; 000046DE  add [bx+si],al
  db 0x00, 0x00                ; 000046E0  add [bx+si],al
  db 0x00, 0x00                ; 000046E2  add [bx+si],al
  db 0x00, 0x00                ; 000046E4  add [bx+si],al
  db 0x00, 0x00                ; 000046E6  add [bx+si],al
  db 0x00, 0x00                ; 000046E8  add [bx+si],al
  db 0x00, 0x00                ; 000046EA  add [bx+si],al
  db 0x00, 0x00                ; 000046EC  add [bx+si],al
  db 0x00, 0x00                ; 000046EE  add [bx+si],al
  db 0x00, 0x00                ; 000046F0  add [bx+si],al
  db 0x00, 0x00                ; 000046F2  add [bx+si],al
  db 0x00, 0x00                ; 000046F4  add [bx+si],al
  db 0x00, 0x00                ; 000046F6  add [bx+si],al
  db 0x00, 0x00                ; 000046F8  add [bx+si],al
  db 0x00, 0x00                ; 000046FA  add [bx+si],al
  db 0x00, 0x00                ; 000046FC  add [bx+si],al
  db 0x00, 0x00                ; 000046FE  add [bx+si],al
  db 0x00, 0x00                ; 00004700  add [bx+si],al
  db 0x00, 0x00                ; 00004702  add [bx+si],al
  db 0x00, 0x00                ; 00004704  add [bx+si],al
  db 0x00, 0x00                ; 00004706  add [bx+si],al
  db 0x00, 0x00                ; 00004708  add [bx+si],al
  db 0x00, 0x00                ; 0000470A  add [bx+si],al
  db 0x00, 0x00                ; 0000470C  add [bx+si],al
  db 0x00, 0x00                ; 0000470E  add [bx+si],al
  db 0x00, 0x00                ; 00004710  add [bx+si],al
  db 0x00, 0x00                ; 00004712  add [bx+si],al
  db 0x00, 0x00                ; 00004714  add [bx+si],al
  db 0x00, 0x00                ; 00004716  add [bx+si],al
  db 0x00, 0x00                ; 00004718  add [bx+si],al
  db 0x00, 0x00                ; 0000471A  add [bx+si],al
  db 0x00, 0x00                ; 0000471C  add [bx+si],al
  db 0x00, 0x00                ; 0000471E  add [bx+si],al
  db 0x00, 0x00                ; 00004720  add [bx+si],al
  db 0x00, 0x00                ; 00004722  add [bx+si],al
  db 0x00, 0x00                ; 00004724  add [bx+si],al
  db 0x00, 0x00                ; 00004726  add [bx+si],al
  db 0x00, 0x00                ; 00004728  add [bx+si],al
  db 0x00, 0x00                ; 0000472A  add [bx+si],al
  db 0x00, 0x00                ; 0000472C  add [bx+si],al
  db 0x00, 0x00                ; 0000472E  add [bx+si],al
  db 0x00, 0x00                ; 00004730  add [bx+si],al
  db 0x00, 0x00                ; 00004732  add [bx+si],al
  db 0x00, 0x00                ; 00004734  add [bx+si],al
  db 0x00, 0x00                ; 00004736  add [bx+si],al
  db 0x00, 0x00                ; 00004738  add [bx+si],al
  db 0x00, 0x00                ; 0000473A  add [bx+si],al
  db 0x00, 0x00                ; 0000473C  add [bx+si],al
  db 0x00, 0x00                ; 0000473E  add [bx+si],al
  db 0x00, 0x00                ; 00004740  add [bx+si],al
  db 0x00, 0x00                ; 00004742  add [bx+si],al
  db 0x00, 0x00                ; 00004744  add [bx+si],al
  db 0x00, 0x00                ; 00004746  add [bx+si],al
  db 0x00, 0x00                ; 00004748  add [bx+si],al
  db 0x00, 0x00                ; 0000474A  add [bx+si],al
  db 0x00, 0x00                ; 0000474C  add [bx+si],al
  db 0x00, 0x00                ; 0000474E  add [bx+si],al
  db 0x00, 0x00                ; 00004750  add [bx+si],al
  db 0x00, 0x00                ; 00004752  add [bx+si],al
  db 0x00, 0x00                ; 00004754  add [bx+si],al
  db 0x00, 0x00                ; 00004756  add [bx+si],al
  db 0x00, 0x00                ; 00004758  add [bx+si],al
  db 0x00, 0x00                ; 0000475A  add [bx+si],al
  db 0x00, 0x00                ; 0000475C  add [bx+si],al
  db 0x00, 0x00                ; 0000475E  add [bx+si],al
  db 0x00, 0x00                ; 00004760  add [bx+si],al
  db 0x00, 0x00                ; 00004762  add [bx+si],al
  db 0x00, 0x00                ; 00004764  add [bx+si],al
  db 0x00, 0x00                ; 00004766  add [bx+si],al
  db 0x00, 0x00                ; 00004768  add [bx+si],al
  db 0x00, 0x00                ; 0000476A  add [bx+si],al
  db 0x00, 0x00                ; 0000476C  add [bx+si],al
  db 0x00, 0x00                ; 0000476E  add [bx+si],al
  db 0x00, 0x00                ; 00004770  add [bx+si],al
  db 0x00, 0x00                ; 00004772  add [bx+si],al
  db 0x00, 0x00                ; 00004774  add [bx+si],al
  db 0x00, 0x00                ; 00004776  add [bx+si],al
  db 0x00, 0x00                ; 00004778  add [bx+si],al
  db 0x00, 0x00                ; 0000477A  add [bx+si],al
  db 0x00, 0x00                ; 0000477C  add [bx+si],al
  db 0x00, 0x00                ; 0000477E  add [bx+si],al
  db 0x00, 0x00                ; 00004780  add [bx+si],al
  db 0x00, 0x00                ; 00004782  add [bx+si],al
  db 0x00, 0x00                ; 00004784  add [bx+si],al
  db 0x00, 0x00                ; 00004786  add [bx+si],al
  db 0x00, 0x00                ; 00004788  add [bx+si],al
  db 0x00, 0x00                ; 0000478A  add [bx+si],al
  db 0x00, 0x00                ; 0000478C  add [bx+si],al
  db 0x00, 0x00                ; 0000478E  add [bx+si],al
  db 0x00, 0x00                ; 00004790  add [bx+si],al
  db 0x00, 0x00                ; 00004792  add [bx+si],al
  db 0x00, 0x00                ; 00004794  add [bx+si],al
  db 0x00, 0x00                ; 00004796  add [bx+si],al
  db 0x00, 0x00                ; 00004798  add [bx+si],al
  db 0x00, 0x00                ; 0000479A  add [bx+si],al
  db 0x00, 0x00                ; 0000479C  add [bx+si],al
  db 0x00, 0x00                ; 0000479E  add [bx+si],al
  db 0x00, 0x00                ; 000047A0  add [bx+si],al
  db 0x00, 0x00                ; 000047A2  add [bx+si],al
  db 0x00, 0x00                ; 000047A4  add [bx+si],al
  db 0x00, 0x00                ; 000047A6  add [bx+si],al
  db 0x00, 0x00                ; 000047A8  add [bx+si],al
  db 0x00, 0x00                ; 000047AA  add [bx+si],al
  db 0x00, 0x00                ; 000047AC  add [bx+si],al
  db 0x00, 0x00                ; 000047AE  add [bx+si],al
  db 0x00, 0x00                ; 000047B0  add [bx+si],al
  db 0x00, 0x00                ; 000047B2  add [bx+si],al
  db 0x00, 0x00                ; 000047B4  add [bx+si],al
  db 0x00, 0x00                ; 000047B6  add [bx+si],al
  db 0x00, 0x00                ; 000047B8  add [bx+si],al
  db 0x00, 0x00                ; 000047BA  add [bx+si],al
  db 0x00, 0x00                ; 000047BC  add [bx+si],al
  db 0x00, 0x00                ; 000047BE  add [bx+si],al
  db 0x00, 0x00                ; 000047C0  add [bx+si],al
  db 0x00, 0x00                ; 000047C2  add [bx+si],al
  db 0x00, 0x00                ; 000047C4  add [bx+si],al
  db 0x00, 0x00                ; 000047C6  add [bx+si],al
  db 0x00, 0x00                ; 000047C8  add [bx+si],al
  db 0x00, 0x00                ; 000047CA  add [bx+si],al
  db 0x00, 0x00                ; 000047CC  add [bx+si],al
  db 0x00, 0x00                ; 000047CE  add [bx+si],al
  db 0x00, 0x00                ; 000047D0  add [bx+si],al
  db 0x00, 0x00                ; 000047D2  add [bx+si],al
  db 0x00, 0x00                ; 000047D4  add [bx+si],al
  db 0x00, 0x00                ; 000047D6  add [bx+si],al
  db 0x00, 0x00                ; 000047D8  add [bx+si],al
  db 0x00, 0x00                ; 000047DA  add [bx+si],al
  db 0x00, 0x00                ; 000047DC  add [bx+si],al
  db 0x00, 0x00                ; 000047DE  add [bx+si],al
  db 0x00, 0x00                ; 000047E0  add [bx+si],al
  db 0x00, 0x00                ; 000047E2  add [bx+si],al
  db 0x00, 0x00                ; 000047E4  add [bx+si],al
  db 0x00, 0x00                ; 000047E6  add [bx+si],al
  db 0x00, 0x00                ; 000047E8  add [bx+si],al
  db 0x00, 0x00                ; 000047EA  add [bx+si],al
  db 0x00, 0x00                ; 000047EC  add [bx+si],al
  db 0x00, 0x00                ; 000047EE  add [bx+si],al
  db 0x00, 0x00                ; 000047F0  add [bx+si],al
  db 0x00, 0x00                ; 000047F2  add [bx+si],al
  db 0x00, 0x00                ; 000047F4  add [bx+si],al
  db 0x00, 0x00                ; 000047F6  add [bx+si],al
  db 0x00, 0x00                ; 000047F8  add [bx+si],al
  db 0x00, 0x00                ; 000047FA  add [bx+si],al
  db 0x00, 0x00                ; 000047FC  add [bx+si],al
  db 0x00, 0x00                ; 000047FE  add [bx+si],al
  db 0x00, 0x00                ; 00004800  add [bx+si],al
  db 0x00, 0x00                ; 00004802  add [bx+si],al
  db 0x00, 0x00                ; 00004804  add [bx+si],al
  db 0x00, 0x00                ; 00004806  add [bx+si],al
  db 0x00, 0x00                ; 00004808  add [bx+si],al
  db 0x00, 0x00                ; 0000480A  add [bx+si],al
  db 0x00, 0x00                ; 0000480C  add [bx+si],al
  db 0x00, 0x00                ; 0000480E  add [bx+si],al
  db 0x00, 0x00                ; 00004810  add [bx+si],al
  db 0x00, 0x00                ; 00004812  add [bx+si],al
  db 0x00, 0x00                ; 00004814  add [bx+si],al
  db 0x00, 0x00                ; 00004816  add [bx+si],al
  db 0x00, 0x00                ; 00004818  add [bx+si],al
  db 0x00, 0x00                ; 0000481A  add [bx+si],al
  db 0x00, 0x00                ; 0000481C  add [bx+si],al
  db 0x00, 0x00                ; 0000481E  add [bx+si],al
  db 0x00, 0x00                ; 00004820  add [bx+si],al
  db 0x00, 0x00                ; 00004822  add [bx+si],al
  db 0x00, 0x00                ; 00004824  add [bx+si],al
  db 0x00, 0x00                ; 00004826  add [bx+si],al
  db 0x00, 0x00                ; 00004828  add [bx+si],al
  db 0x00, 0x00                ; 0000482A  add [bx+si],al
  db 0x00, 0x00                ; 0000482C  add [bx+si],al
  db 0x00, 0x00                ; 0000482E  add [bx+si],al
  db 0x00, 0x00                ; 00004830  add [bx+si],al
  db 0x00, 0x00                ; 00004832  add [bx+si],al
  db 0x00, 0x00                ; 00004834  add [bx+si],al
  db 0x00, 0x00                ; 00004836  add [bx+si],al
  db 0x00, 0x00                ; 00004838  add [bx+si],al
  db 0x00, 0x00                ; 0000483A  add [bx+si],al
  db 0x00, 0x00                ; 0000483C  add [bx+si],al
  db 0x00, 0x00                ; 0000483E  add [bx+si],al
  db 0x00, 0x00                ; 00004840  add [bx+si],al
  db 0x00, 0x00                ; 00004842  add [bx+si],al
  db 0x00, 0x00                ; 00004844  add [bx+si],al
  db 0x00, 0x00                ; 00004846  add [bx+si],al
  db 0x00, 0x00                ; 00004848  add [bx+si],al
  db 0x00, 0x00                ; 0000484A  add [bx+si],al
  db 0x00, 0x00                ; 0000484C  add [bx+si],al
  db 0x00, 0x00                ; 0000484E  add [bx+si],al
  db 0x00, 0x00                ; 00004850  add [bx+si],al
  db 0x00, 0x00                ; 00004852  add [bx+si],al
  db 0x00, 0x00                ; 00004854  add [bx+si],al
  db 0x00, 0x00                ; 00004856  add [bx+si],al
  db 0x00, 0x00                ; 00004858  add [bx+si],al
  db 0x00, 0x00                ; 0000485A  add [bx+si],al
  db 0x00, 0x00                ; 0000485C  add [bx+si],al
  db 0x00, 0x00                ; 0000485E  add [bx+si],al
  db 0x00, 0x00                ; 00004860  add [bx+si],al
  db 0x00, 0x00                ; 00004862  add [bx+si],al
  db 0x00, 0x00                ; 00004864  add [bx+si],al
  db 0x00, 0x00                ; 00004866  add [bx+si],al
  db 0x00, 0x00                ; 00004868  add [bx+si],al
  db 0x00, 0x00                ; 0000486A  add [bx+si],al
  db 0x00, 0x00                ; 0000486C  add [bx+si],al
  db 0x00, 0x00                ; 0000486E  add [bx+si],al
  db 0x00, 0x00                ; 00004870  add [bx+si],al
  db 0x00, 0x00                ; 00004872  add [bx+si],al
  db 0x00, 0x00                ; 00004874  add [bx+si],al
  db 0x00, 0x00                ; 00004876  add [bx+si],al
  db 0x00, 0x00                ; 00004878  add [bx+si],al
  db 0x00, 0x00                ; 0000487A  add [bx+si],al
  db 0x00, 0x00                ; 0000487C  add [bx+si],al
  db 0x00, 0x00                ; 0000487E  add [bx+si],al
  db 0x00, 0x00                ; 00004880  add [bx+si],al
  db 0x00, 0x00                ; 00004882  add [bx+si],al
  db 0x00, 0x00                ; 00004884  add [bx+si],al
  db 0x00, 0x00                ; 00004886  add [bx+si],al
  db 0x00, 0x00                ; 00004888  add [bx+si],al
  db 0x00, 0x00                ; 0000488A  add [bx+si],al
  db 0x00, 0x00                ; 0000488C  add [bx+si],al
  db 0x00, 0x00                ; 0000488E  add [bx+si],al
  db 0x00, 0x00                ; 00004890  add [bx+si],al
  db 0x00, 0x00                ; 00004892  add [bx+si],al
  db 0x00, 0x00                ; 00004894  add [bx+si],al
  db 0x00, 0x00                ; 00004896  add [bx+si],al
  db 0x00, 0x00                ; 00004898  add [bx+si],al
  db 0x00, 0x00                ; 0000489A  add [bx+si],al
  db 0x00, 0x00                ; 0000489C  add [bx+si],al
  db 0x00, 0x00                ; 0000489E  add [bx+si],al
  db 0x00, 0x00                ; 000048A0  add [bx+si],al
  db 0x00, 0x00                ; 000048A2  add [bx+si],al
  db 0x00, 0x00                ; 000048A4  add [bx+si],al
  db 0x00, 0x00                ; 000048A6  add [bx+si],al
  db 0x00, 0x00                ; 000048A8  add [bx+si],al
  db 0x00, 0x00                ; 000048AA  add [bx+si],al
  db 0x00, 0x00                ; 000048AC  add [bx+si],al
  db 0x00, 0x00                ; 000048AE  add [bx+si],al
  db 0x00, 0x00                ; 000048B0  add [bx+si],al
  db 0x00, 0x00                ; 000048B2  add [bx+si],al
  db 0x00, 0x00                ; 000048B4  add [bx+si],al
  db 0x00, 0x00                ; 000048B6  add [bx+si],al
  db 0x00, 0x00                ; 000048B8  add [bx+si],al
  db 0x00, 0x00                ; 000048BA  add [bx+si],al
  db 0x00, 0x00                ; 000048BC  add [bx+si],al
  db 0x00, 0x00                ; 000048BE  add [bx+si],al
  db 0x00, 0x00                ; 000048C0  add [bx+si],al
  db 0x00, 0x00                ; 000048C2  add [bx+si],al
  db 0x00, 0x00                ; 000048C4  add [bx+si],al
  db 0x00, 0x00                ; 000048C6  add [bx+si],al
  db 0x00, 0x00                ; 000048C8  add [bx+si],al
  db 0x00, 0x00                ; 000048CA  add [bx+si],al
  db 0x00, 0x00                ; 000048CC  add [bx+si],al
  db 0x00, 0x00                ; 000048CE  add [bx+si],al
  db 0x00, 0x00                ; 000048D0  add [bx+si],al
  db 0x00, 0x00                ; 000048D2  add [bx+si],al
  db 0x00, 0x00                ; 000048D4  add [bx+si],al
  db 0x00, 0x00                ; 000048D6  add [bx+si],al
  db 0x00, 0x00                ; 000048D8  add [bx+si],al
  db 0x00, 0x00                ; 000048DA  add [bx+si],al
  db 0x00, 0x00                ; 000048DC  add [bx+si],al
  db 0x00, 0x00                ; 000048DE  add [bx+si],al
  db 0x00, 0x00                ; 000048E0  add [bx+si],al
  db 0x00, 0x00                ; 000048E2  add [bx+si],al
  db 0x00, 0x00                ; 000048E4  add [bx+si],al
  db 0x00, 0x00                ; 000048E6  add [bx+si],al
  db 0x00, 0x00                ; 000048E8  add [bx+si],al
  db 0x00, 0x00                ; 000048EA  add [bx+si],al
  db 0x00, 0x00                ; 000048EC  add [bx+si],al
  db 0x00, 0x00                ; 000048EE  add [bx+si],al
  db 0x00, 0x00                ; 000048F0  add [bx+si],al
  db 0x00, 0x00                ; 000048F2  add [bx+si],al
  db 0x00, 0x00                ; 000048F4  add [bx+si],al
  db 0x00, 0x00                ; 000048F6  add [bx+si],al
  db 0x00, 0x00                ; 000048F8  add [bx+si],al
  db 0x00, 0x00                ; 000048FA  add [bx+si],al
  db 0x00, 0x00                ; 000048FC  add [bx+si],al
  db 0x00, 0x00                ; 000048FE  add [bx+si],al
  db 0x00, 0x00                ; 00004900  add [bx+si],al
  db 0x00, 0x00                ; 00004902  add [bx+si],al
  db 0x00, 0x00                ; 00004904  add [bx+si],al
  db 0x00, 0x00                ; 00004906  add [bx+si],al
  db 0x00, 0x00                ; 00004908  add [bx+si],al
  db 0x00, 0x00                ; 0000490A  add [bx+si],al
  db 0x00, 0x00                ; 0000490C  add [bx+si],al
  db 0x00, 0x00                ; 0000490E  add [bx+si],al
  db 0x00, 0x00                ; 00004910  add [bx+si],al
  db 0x00, 0x00                ; 00004912  add [bx+si],al
  db 0x00, 0x00                ; 00004914  add [bx+si],al
  db 0x00, 0x00                ; 00004916  add [bx+si],al
  db 0x00, 0x00                ; 00004918  add [bx+si],al
  db 0x00, 0x00                ; 0000491A  add [bx+si],al
  db 0x00, 0x00                ; 0000491C  add [bx+si],al
  db 0x00, 0x00                ; 0000491E  add [bx+si],al
  db 0x00, 0x00                ; 00004920  add [bx+si],al
  db 0x00, 0x00                ; 00004922  add [bx+si],al
  db 0x00, 0x00                ; 00004924  add [bx+si],al
  db 0x00, 0x00                ; 00004926  add [bx+si],al
  db 0x00, 0x00                ; 00004928  add [bx+si],al
  db 0x00, 0x00                ; 0000492A  add [bx+si],al
  db 0x00, 0x00                ; 0000492C  add [bx+si],al
  db 0x00, 0x00                ; 0000492E  add [bx+si],al
  db 0x00, 0x00                ; 00004930  add [bx+si],al
  db 0x00, 0x00                ; 00004932  add [bx+si],al
  db 0x00, 0x00                ; 00004934  add [bx+si],al
  db 0x00, 0x00                ; 00004936  add [bx+si],al
  db 0x00, 0x00                ; 00004938  add [bx+si],al
  db 0x00, 0x00                ; 0000493A  add [bx+si],al
  db 0x00, 0x00                ; 0000493C  add [bx+si],al
  db 0x00, 0x00                ; 0000493E  add [bx+si],al
  db 0x00, 0x00                ; 00004940  add [bx+si],al
  db 0x00, 0x00                ; 00004942  add [bx+si],al
  db 0x00, 0x00                ; 00004944  add [bx+si],al
  db 0x00, 0x00                ; 00004946  add [bx+si],al
  db 0x00, 0x00                ; 00004948  add [bx+si],al
  db 0x00, 0x00                ; 0000494A  add [bx+si],al
  db 0x00, 0x00                ; 0000494C  add [bx+si],al
  db 0x00, 0x00                ; 0000494E  add [bx+si],al
  db 0x00, 0x00                ; 00004950  add [bx+si],al
  db 0x00, 0x00                ; 00004952  add [bx+si],al
  db 0x00, 0x00                ; 00004954  add [bx+si],al
  db 0x00, 0x00                ; 00004956  add [bx+si],al
  db 0x00, 0x00                ; 00004958  add [bx+si],al
  db 0x00, 0x00                ; 0000495A  add [bx+si],al
  db 0x00, 0x00                ; 0000495C  add [bx+si],al
  db 0x00, 0x00                ; 0000495E  add [bx+si],al
  db 0x00, 0x00                ; 00004960  add [bx+si],al
  db 0x00, 0x00                ; 00004962  add [bx+si],al
  db 0x00, 0x00                ; 00004964  add [bx+si],al
  db 0x00, 0x00                ; 00004966  add [bx+si],al
  db 0x00, 0x00                ; 00004968  add [bx+si],al
  db 0x00, 0x00                ; 0000496A  add [bx+si],al
  db 0x00, 0x00                ; 0000496C  add [bx+si],al
  db 0x00, 0x00                ; 0000496E  add [bx+si],al
  db 0x00, 0x00                ; 00004970  add [bx+si],al
  db 0x00, 0x00                ; 00004972  add [bx+si],al
  db 0x00, 0x00                ; 00004974  add [bx+si],al
  db 0x00, 0x00                ; 00004976  add [bx+si],al
  db 0x00, 0x00                ; 00004978  add [bx+si],al
  db 0x00, 0x00                ; 0000497A  add [bx+si],al
  db 0x00, 0x00                ; 0000497C  add [bx+si],al
  db 0x00, 0x00                ; 0000497E  add [bx+si],al
  db 0x00, 0x00                ; 00004980  add [bx+si],al
  db 0x00, 0x00                ; 00004982  add [bx+si],al
  db 0x00, 0x00                ; 00004984  add [bx+si],al
  db 0x00, 0x00                ; 00004986  add [bx+si],al
  db 0x00, 0x00                ; 00004988  add [bx+si],al
  db 0x00, 0x00                ; 0000498A  add [bx+si],al
  db 0x00, 0x00                ; 0000498C  add [bx+si],al
  db 0x00, 0x00                ; 0000498E  add [bx+si],al
  db 0x00, 0x00                ; 00004990  add [bx+si],al
  db 0x00, 0x00                ; 00004992  add [bx+si],al
  db 0x00, 0x00                ; 00004994  add [bx+si],al
  db 0x00, 0x00                ; 00004996  add [bx+si],al
  db 0x00, 0x00                ; 00004998  add [bx+si],al
  db 0x00, 0x00                ; 0000499A  add [bx+si],al
  db 0x00, 0x00                ; 0000499C  add [bx+si],al
  db 0x00, 0x00                ; 0000499E  add [bx+si],al
  db 0x00, 0x00                ; 000049A0  add [bx+si],al
  db 0x00, 0x00                ; 000049A2  add [bx+si],al
  db 0x00, 0x00                ; 000049A4  add [bx+si],al
  db 0x00, 0x00                ; 000049A6  add [bx+si],al
  db 0x00, 0x00                ; 000049A8  add [bx+si],al
  db 0x00, 0x00                ; 000049AA  add [bx+si],al
  db 0x00, 0x00                ; 000049AC  add [bx+si],al
  db 0x00, 0x00                ; 000049AE  add [bx+si],al
  db 0x00, 0x00                ; 000049B0  add [bx+si],al
  db 0x00, 0x00                ; 000049B2  add [bx+si],al
  db 0x00, 0x00                ; 000049B4  add [bx+si],al
  db 0x00, 0x00                ; 000049B6  add [bx+si],al
  db 0x00, 0x00                ; 000049B8  add [bx+si],al
  db 0x00, 0x00                ; 000049BA  add [bx+si],al
  db 0x00, 0x00                ; 000049BC  add [bx+si],al
  db 0x00, 0x00                ; 000049BE  add [bx+si],al
  db 0x00, 0x00                ; 000049C0  add [bx+si],al
  db 0x00, 0x00                ; 000049C2  add [bx+si],al
  db 0x00, 0x00                ; 000049C4  add [bx+si],al
  db 0x00, 0x00                ; 000049C6  add [bx+si],al
  db 0x00, 0x00                ; 000049C8  add [bx+si],al
  db 0x00, 0x00                ; 000049CA  add [bx+si],al
  db 0x00, 0x00                ; 000049CC  add [bx+si],al
  db 0x00, 0x00                ; 000049CE  add [bx+si],al
  db 0x00, 0x00                ; 000049D0  add [bx+si],al
  db 0x00, 0x00                ; 000049D2  add [bx+si],al
  db 0x00, 0x00                ; 000049D4  add [bx+si],al
  db 0x00, 0x00                ; 000049D6  add [bx+si],al
  db 0x00, 0x00                ; 000049D8  add [bx+si],al
  db 0x00, 0x00                ; 000049DA  add [bx+si],al
  db 0x00, 0x00                ; 000049DC  add [bx+si],al
  db 0x00, 0x00                ; 000049DE  add [bx+si],al
  db 0x00, 0x00                ; 000049E0  add [bx+si],al
  db 0x00, 0x00                ; 000049E2  add [bx+si],al
  db 0x00, 0x00                ; 000049E4  add [bx+si],al
  db 0x00, 0x00                ; 000049E6  add [bx+si],al
  db 0x00, 0x00                ; 000049E8  add [bx+si],al
  db 0x00, 0x00                ; 000049EA  add [bx+si],al
  db 0x00, 0x00                ; 000049EC  add [bx+si],al
  db 0x00, 0x00                ; 000049EE  add [bx+si],al
  db 0x00, 0x00                ; 000049F0  add [bx+si],al
  db 0x00, 0x00                ; 000049F2  add [bx+si],al
  db 0x00, 0x00                ; 000049F4  add [bx+si],al
  db 0x00, 0x00                ; 000049F6  add [bx+si],al
  db 0x00, 0x00                ; 000049F8  add [bx+si],al
  db 0x00, 0x00                ; 000049FA  add [bx+si],al
  db 0x00, 0x00                ; 000049FC  add [bx+si],al
  db 0x00, 0x00                ; 000049FE  add [bx+si],al
  db 0x00, 0x00                ; 00004A00  add [bx+si],al
  db 0x00, 0x00                ; 00004A02  add [bx+si],al
  db 0x00, 0x00                ; 00004A04  add [bx+si],al
  db 0x00, 0x00                ; 00004A06  add [bx+si],al
  db 0x00, 0x00                ; 00004A08  add [bx+si],al
  db 0x00, 0x00                ; 00004A0A  add [bx+si],al
  db 0x00, 0x00                ; 00004A0C  add [bx+si],al
  db 0x00, 0x00                ; 00004A0E  add [bx+si],al
  db 0x00, 0x00                ; 00004A10  add [bx+si],al
  db 0x00, 0x00                ; 00004A12  add [bx+si],al
  db 0x00, 0x00                ; 00004A14  add [bx+si],al
  db 0x00, 0x00                ; 00004A16  add [bx+si],al
  db 0x00, 0x00                ; 00004A18  add [bx+si],al
  db 0x00, 0x00                ; 00004A1A  add [bx+si],al
  db 0x00, 0x00                ; 00004A1C  add [bx+si],al
  db 0x00, 0x00                ; 00004A1E  add [bx+si],al
  db 0x00, 0x00                ; 00004A20  add [bx+si],al
  db 0x00, 0x00                ; 00004A22  add [bx+si],al
  db 0x00, 0x00                ; 00004A24  add [bx+si],al
  db 0x00, 0x00                ; 00004A26  add [bx+si],al
  db 0x00, 0x00                ; 00004A28  add [bx+si],al
  db 0x00, 0x00                ; 00004A2A  add [bx+si],al
  db 0x00, 0x00                ; 00004A2C  add [bx+si],al
  db 0x00, 0x00                ; 00004A2E  add [bx+si],al
  db 0x00, 0x00                ; 00004A30  add [bx+si],al
  db 0x00, 0x00                ; 00004A32  add [bx+si],al
  db 0x00, 0x00                ; 00004A34  add [bx+si],al
  db 0x00, 0x00                ; 00004A36  add [bx+si],al
  db 0x00, 0x00                ; 00004A38  add [bx+si],al
  db 0x00, 0x00                ; 00004A3A  add [bx+si],al
  db 0x00, 0x00                ; 00004A3C  add [bx+si],al
  db 0x00, 0x00                ; 00004A3E  add [bx+si],al
  db 0x00, 0x00                ; 00004A40  add [bx+si],al
  db 0x00, 0x00                ; 00004A42  add [bx+si],al
  db 0x00, 0x00                ; 00004A44  add [bx+si],al
  db 0x00, 0x00                ; 00004A46  add [bx+si],al
  db 0x00, 0x00                ; 00004A48  add [bx+si],al
  db 0x00, 0x00                ; 00004A4A  add [bx+si],al
  db 0x00, 0x00                ; 00004A4C  add [bx+si],al
  db 0x00, 0x00                ; 00004A4E  add [bx+si],al
  db 0x00, 0x00                ; 00004A50  add [bx+si],al
  db 0x00, 0x00                ; 00004A52  add [bx+si],al
  db 0x00, 0x00                ; 00004A54  add [bx+si],al
  db 0x00, 0x00                ; 00004A56  add [bx+si],al
  db 0x00, 0x00                ; 00004A58  add [bx+si],al
  db 0x00, 0x00                ; 00004A5A  add [bx+si],al
  db 0x00, 0x00                ; 00004A5C  add [bx+si],al
  db 0x00, 0x00                ; 00004A5E  add [bx+si],al
  db 0x00, 0x00                ; 00004A60  add [bx+si],al
  db 0x00, 0x00                ; 00004A62  add [bx+si],al
  db 0x00, 0x00                ; 00004A64  add [bx+si],al
  db 0x00, 0x00                ; 00004A66  add [bx+si],al
  db 0x00, 0x00                ; 00004A68  add [bx+si],al
  db 0x00, 0x00                ; 00004A6A  add [bx+si],al
  db 0x00, 0x00                ; 00004A6C  add [bx+si],al
  db 0x00, 0x00                ; 00004A6E  add [bx+si],al
  db 0x00, 0x00                ; 00004A70  add [bx+si],al
  db 0x00, 0x00                ; 00004A72  add [bx+si],al
  db 0x00, 0x00                ; 00004A74  add [bx+si],al
  db 0x00, 0x00                ; 00004A76  add [bx+si],al
  db 0x00, 0x00                ; 00004A78  add [bx+si],al
  db 0x00, 0x00                ; 00004A7A  add [bx+si],al
  db 0x00, 0x00                ; 00004A7C  add [bx+si],al
  db 0x00, 0x00                ; 00004A7E  add [bx+si],al
  db 0x00, 0x00                ; 00004A80  add [bx+si],al
  db 0x00, 0x00                ; 00004A82  add [bx+si],al
  db 0x00, 0x00                ; 00004A84  add [bx+si],al
  db 0x00, 0x00                ; 00004A86  add [bx+si],al
  db 0x00, 0x00                ; 00004A88  add [bx+si],al
  db 0x00, 0x00                ; 00004A8A  add [bx+si],al
  db 0x00, 0x00                ; 00004A8C  add [bx+si],al
  db 0x00, 0x00                ; 00004A8E  add [bx+si],al
  db 0x00, 0x00                ; 00004A90  add [bx+si],al
  db 0x00, 0x00                ; 00004A92  add [bx+si],al
  db 0x00, 0x00                ; 00004A94  add [bx+si],al
  db 0x00, 0x00                ; 00004A96  add [bx+si],al
  db 0x00, 0x00                ; 00004A98  add [bx+si],al
  db 0x00, 0x00                ; 00004A9A  add [bx+si],al
  db 0x00, 0x00                ; 00004A9C  add [bx+si],al
  db 0x00, 0x00                ; 00004A9E  add [bx+si],al
  db 0x00, 0x00                ; 00004AA0  add [bx+si],al
  db 0x00, 0x00                ; 00004AA2  add [bx+si],al
  db 0x00, 0x00                ; 00004AA4  add [bx+si],al
  db 0x00, 0x00                ; 00004AA6  add [bx+si],al
  db 0x00, 0x00                ; 00004AA8  add [bx+si],al
  db 0x00, 0x00                ; 00004AAA  add [bx+si],al
  db 0x00, 0x00                ; 00004AAC  add [bx+si],al
  db 0x00, 0x00                ; 00004AAE  add [bx+si],al
  db 0x00, 0x00                ; 00004AB0  add [bx+si],al
  db 0x00, 0x00                ; 00004AB2  add [bx+si],al
  db 0x00, 0x00                ; 00004AB4  add [bx+si],al
  db 0x00, 0x00                ; 00004AB6  add [bx+si],al
  db 0x00, 0x00                ; 00004AB8  add [bx+si],al
  db 0x00, 0x00                ; 00004ABA  add [bx+si],al
  db 0x00, 0x00                ; 00004ABC  add [bx+si],al
  db 0x00, 0x00                ; 00004ABE  add [bx+si],al
  db 0x00, 0x00                ; 00004AC0  add [bx+si],al
  db 0x00, 0x00                ; 00004AC2  add [bx+si],al
  db 0x00, 0x00                ; 00004AC4  add [bx+si],al
  db 0x00, 0x00                ; 00004AC6  add [bx+si],al
  db 0x00, 0x00                ; 00004AC8  add [bx+si],al
  db 0x00, 0x00                ; 00004ACA  add [bx+si],al
  db 0x00, 0x00                ; 00004ACC  add [bx+si],al
  db 0x00, 0x00                ; 00004ACE  add [bx+si],al
  db 0x00, 0x00                ; 00004AD0  add [bx+si],al
  db 0x00, 0x00                ; 00004AD2  add [bx+si],al
  db 0x00, 0x00                ; 00004AD4  add [bx+si],al
  db 0x00, 0x00                ; 00004AD6  add [bx+si],al
  db 0x00, 0x00                ; 00004AD8  add [bx+si],al
  db 0x00, 0x00                ; 00004ADA  add [bx+si],al
  db 0x00, 0x00                ; 00004ADC  add [bx+si],al
  db 0x00, 0x00                ; 00004ADE  add [bx+si],al
  db 0x00, 0x00                ; 00004AE0  add [bx+si],al
  db 0x00, 0x00                ; 00004AE2  add [bx+si],al
  db 0x00, 0x00                ; 00004AE4  add [bx+si],al
  db 0x00, 0x00                ; 00004AE6  add [bx+si],al
  db 0x00, 0x00                ; 00004AE8  add [bx+si],al
  db 0x00, 0x00                ; 00004AEA  add [bx+si],al
  db 0x00, 0x00                ; 00004AEC  add [bx+si],al
  db 0x00, 0x00                ; 00004AEE  add [bx+si],al
  db 0x00, 0x00                ; 00004AF0  add [bx+si],al
  db 0x00, 0x00                ; 00004AF2  add [bx+si],al
  db 0x00, 0x00                ; 00004AF4  add [bx+si],al
  db 0x00, 0x00                ; 00004AF6  add [bx+si],al
  db 0x00, 0x00                ; 00004AF8  add [bx+si],al
  db 0x00, 0x00                ; 00004AFA  add [bx+si],al
  db 0x00, 0x00                ; 00004AFC  add [bx+si],al
  db 0x00, 0x00                ; 00004AFE  add [bx+si],al
  db 0x00, 0x00                ; 00004B00  add [bx+si],al
  db 0x00, 0x00                ; 00004B02  add [bx+si],al
  db 0x00, 0x00                ; 00004B04  add [bx+si],al
  db 0x00, 0x00                ; 00004B06  add [bx+si],al
  db 0x00, 0x00                ; 00004B08  add [bx+si],al
  db 0x00, 0x00                ; 00004B0A  add [bx+si],al
  db 0x00, 0x00                ; 00004B0C  add [bx+si],al
  db 0x00, 0x00                ; 00004B0E  add [bx+si],al
  db 0x00, 0x00                ; 00004B10  add [bx+si],al
  db 0x00, 0x00                ; 00004B12  add [bx+si],al
  db 0x00, 0x00                ; 00004B14  add [bx+si],al
  db 0x00, 0x00                ; 00004B16  add [bx+si],al
  db 0x00, 0x00                ; 00004B18  add [bx+si],al
  db 0x00, 0x00                ; 00004B1A  add [bx+si],al
  db 0x00, 0x00                ; 00004B1C  add [bx+si],al
  db 0x00, 0x00                ; 00004B1E  add [bx+si],al
  db 0x00, 0x00                ; 00004B20  add [bx+si],al
  db 0x00, 0x00                ; 00004B22  add [bx+si],al
  db 0x00, 0x00                ; 00004B24  add [bx+si],al
  db 0x00, 0x00                ; 00004B26  add [bx+si],al
  db 0x00, 0x00                ; 00004B28  add [bx+si],al
  db 0x00, 0x00                ; 00004B2A  add [bx+si],al
  db 0x00, 0x00                ; 00004B2C  add [bx+si],al
  db 0x00, 0x00                ; 00004B2E  add [bx+si],al
  db 0x00, 0x00                ; 00004B30  add [bx+si],al
  db 0x00, 0x00                ; 00004B32  add [bx+si],al
  db 0x00, 0x00                ; 00004B34  add [bx+si],al
  db 0x00, 0x00                ; 00004B36  add [bx+si],al
  db 0x00, 0x00                ; 00004B38  add [bx+si],al
  db 0x00, 0x00                ; 00004B3A  add [bx+si],al
  db 0x00, 0x00                ; 00004B3C  add [bx+si],al
  db 0x00, 0x00                ; 00004B3E  add [bx+si],al
  db 0x00, 0x00                ; 00004B40  add [bx+si],al
  db 0x00, 0x00                ; 00004B42  add [bx+si],al
  db 0x00, 0x00                ; 00004B44  add [bx+si],al
  db 0x00, 0x00                ; 00004B46  add [bx+si],al
  db 0x00, 0x00                ; 00004B48  add [bx+si],al
  db 0x00, 0x00                ; 00004B4A  add [bx+si],al
  db 0x00, 0x00                ; 00004B4C  add [bx+si],al
  db 0x00, 0x00                ; 00004B4E  add [bx+si],al
  db 0x00, 0x00                ; 00004B50  add [bx+si],al
  db 0x00, 0x00                ; 00004B52  add [bx+si],al
  db 0x00, 0x00                ; 00004B54  add [bx+si],al
  db 0x00, 0x00                ; 00004B56  add [bx+si],al
  db 0x00, 0x00                ; 00004B58  add [bx+si],al
  db 0x00, 0x00                ; 00004B5A  add [bx+si],al
  db 0x00, 0x00                ; 00004B5C  add [bx+si],al
  db 0x00, 0x00                ; 00004B5E  add [bx+si],al
  db 0x00, 0x00                ; 00004B60  add [bx+si],al
  db 0x00, 0x00                ; 00004B62  add [bx+si],al
  db 0x00, 0x00                ; 00004B64  add [bx+si],al
  db 0x00, 0x00                ; 00004B66  add [bx+si],al
  db 0x00, 0x00                ; 00004B68  add [bx+si],al
  db 0x00, 0x00                ; 00004B6A  add [bx+si],al
  db 0x00, 0x00                ; 00004B6C  add [bx+si],al
  db 0x00, 0x00                ; 00004B6E  add [bx+si],al
  db 0x00, 0x00                ; 00004B70  add [bx+si],al
  db 0x00, 0x00                ; 00004B72  add [bx+si],al
  db 0x00, 0x00                ; 00004B74  add [bx+si],al
  db 0x00, 0x00                ; 00004B76  add [bx+si],al
  db 0x00, 0x00                ; 00004B78  add [bx+si],al
  db 0x00, 0x00                ; 00004B7A  add [bx+si],al
  db 0x00, 0x00                ; 00004B7C  add [bx+si],al
  db 0x00, 0x00                ; 00004B7E  add [bx+si],al
  db 0x00, 0x00                ; 00004B80  add [bx+si],al
  db 0x00, 0x00                ; 00004B82  add [bx+si],al
  db 0x00, 0x00                ; 00004B84  add [bx+si],al
  db 0x00, 0x00                ; 00004B86  add [bx+si],al
  db 0x00, 0x00                ; 00004B88  add [bx+si],al
  db 0x00, 0x00                ; 00004B8A  add [bx+si],al
  db 0x00, 0x00                ; 00004B8C  add [bx+si],al
  db 0x00, 0x00                ; 00004B8E  add [bx+si],al
  db 0x00, 0x00                ; 00004B90  add [bx+si],al
  db 0x00, 0x00                ; 00004B92  add [bx+si],al
  db 0x00, 0x00                ; 00004B94  add [bx+si],al
  db 0x00, 0x00                ; 00004B96  add [bx+si],al
  db 0x00, 0x00                ; 00004B98  add [bx+si],al
  db 0x00, 0x00                ; 00004B9A  add [bx+si],al
  db 0x00, 0x00                ; 00004B9C  add [bx+si],al
  db 0x00, 0x00                ; 00004B9E  add [bx+si],al
  db 0x00, 0x00                ; 00004BA0  add [bx+si],al
  db 0x00, 0x00                ; 00004BA2  add [bx+si],al
  db 0x00, 0x00                ; 00004BA4  add [bx+si],al
  db 0x00, 0x00                ; 00004BA6  add [bx+si],al
  db 0x00, 0x00                ; 00004BA8  add [bx+si],al
  db 0x00, 0x00                ; 00004BAA  add [bx+si],al
  db 0x00, 0x00                ; 00004BAC  add [bx+si],al
  db 0x00, 0x00                ; 00004BAE  add [bx+si],al
  db 0x00, 0x00                ; 00004BB0  add [bx+si],al
  db 0x00, 0x00                ; 00004BB2  add [bx+si],al
  db 0x00, 0x00                ; 00004BB4  add [bx+si],al
  db 0x00, 0x00                ; 00004BB6  add [bx+si],al
  db 0x00, 0x00                ; 00004BB8  add [bx+si],al
  db 0x00, 0x00                ; 00004BBA  add [bx+si],al
  db 0x00, 0x00                ; 00004BBC  add [bx+si],al
  db 0x00, 0x00                ; 00004BBE  add [bx+si],al
  db 0x00, 0x00                ; 00004BC0  add [bx+si],al
  db 0x00, 0x00                ; 00004BC2  add [bx+si],al
  db 0x00, 0x00                ; 00004BC4  add [bx+si],al
  db 0x00, 0x00                ; 00004BC6  add [bx+si],al
  db 0x00, 0x00                ; 00004BC8  add [bx+si],al
  db 0x00, 0x00                ; 00004BCA  add [bx+si],al
  db 0x00, 0x00                ; 00004BCC  add [bx+si],al
  db 0x00, 0x00                ; 00004BCE  add [bx+si],al
  db 0x00, 0x00                ; 00004BD0  add [bx+si],al
  db 0x00, 0x00                ; 00004BD2  add [bx+si],al
  db 0x00, 0x00                ; 00004BD4  add [bx+si],al
  db 0x00, 0x00                ; 00004BD6  add [bx+si],al
  db 0x00, 0x00                ; 00004BD8  add [bx+si],al
  db 0x00, 0x00                ; 00004BDA  add [bx+si],al
  db 0x00, 0x00                ; 00004BDC  add [bx+si],al
  db 0x00, 0x00                ; 00004BDE  add [bx+si],al
  db 0x00, 0x00                ; 00004BE0  add [bx+si],al
  db 0x00, 0x00                ; 00004BE2  add [bx+si],al
  db 0x00, 0x00                ; 00004BE4  add [bx+si],al
  db 0x00, 0x00                ; 00004BE6  add [bx+si],al
  db 0x00, 0x00                ; 00004BE8  add [bx+si],al
  db 0x00, 0x00                ; 00004BEA  add [bx+si],al
  db 0x00, 0x00                ; 00004BEC  add [bx+si],al
  db 0x00, 0x00                ; 00004BEE  add [bx+si],al
  db 0x00, 0x00                ; 00004BF0  add [bx+si],al
  db 0x00, 0x00                ; 00004BF2  add [bx+si],al
  db 0x00, 0x00                ; 00004BF4  add [bx+si],al
  db 0x00, 0x00                ; 00004BF6  add [bx+si],al
  db 0x00, 0x00                ; 00004BF8  add [bx+si],al
  db 0x00, 0x00                ; 00004BFA  add [bx+si],al
  db 0x00, 0x00                ; 00004BFC  add [bx+si],al
  db 0x00, 0x00                ; 00004BFE  add [bx+si],al
  db 0x00, 0x00                ; 00004C00  add [bx+si],al
  db 0x00, 0x00                ; 00004C02  add [bx+si],al
  db 0x00, 0x00                ; 00004C04  add [bx+si],al
  db 0x00, 0x00                ; 00004C06  add [bx+si],al
  db 0x00, 0x00                ; 00004C08  add [bx+si],al
  db 0x00, 0x00                ; 00004C0A  add [bx+si],al
  db 0x00, 0x00                ; 00004C0C  add [bx+si],al
  db 0x00, 0x00                ; 00004C0E  add [bx+si],al
  db 0x00, 0x00                ; 00004C10  add [bx+si],al
  db 0x00, 0x00                ; 00004C12  add [bx+si],al
  db 0x00, 0x00                ; 00004C14  add [bx+si],al
  db 0x00, 0x00                ; 00004C16  add [bx+si],al
  db 0x00, 0x00                ; 00004C18  add [bx+si],al
  db 0x00, 0x00                ; 00004C1A  add [bx+si],al
  db 0x00, 0x00                ; 00004C1C  add [bx+si],al
  db 0x00, 0x00                ; 00004C1E  add [bx+si],al
  db 0x00, 0x00                ; 00004C20  add [bx+si],al
  db 0x00, 0x00                ; 00004C22  add [bx+si],al
  db 0x00, 0x00                ; 00004C24  add [bx+si],al
  db 0x00, 0x00                ; 00004C26  add [bx+si],al
  db 0x00, 0x00                ; 00004C28  add [bx+si],al
  db 0x00, 0x00                ; 00004C2A  add [bx+si],al
  db 0x00, 0x00                ; 00004C2C  add [bx+si],al
  db 0x00, 0x00                ; 00004C2E  add [bx+si],al
  db 0x00, 0x00                ; 00004C30  add [bx+si],al
  db 0x00, 0x00                ; 00004C32  add [bx+si],al
  db 0x00, 0x00                ; 00004C34  add [bx+si],al
  db 0x00, 0x00                ; 00004C36  add [bx+si],al
  db 0x00, 0x00                ; 00004C38  add [bx+si],al
  db 0x00, 0x00                ; 00004C3A  add [bx+si],al
  db 0x00, 0x00                ; 00004C3C  add [bx+si],al
  db 0x00, 0x00                ; 00004C3E  add [bx+si],al
  db 0x00, 0x00                ; 00004C40  add [bx+si],al
  db 0x00, 0x00                ; 00004C42  add [bx+si],al
  db 0x00, 0x00                ; 00004C44  add [bx+si],al
  db 0x00, 0x00                ; 00004C46  add [bx+si],al
  db 0x00, 0x00                ; 00004C48  add [bx+si],al
  db 0x00, 0x00                ; 00004C4A  add [bx+si],al
  db 0x00, 0x00                ; 00004C4C  add [bx+si],al
  db 0x00, 0x00                ; 00004C4E  add [bx+si],al
  db 0x00, 0x00                ; 00004C50  add [bx+si],al
  db 0x00, 0x00                ; 00004C52  add [bx+si],al
  db 0x00, 0x00                ; 00004C54  add [bx+si],al
  db 0x00, 0x00                ; 00004C56  add [bx+si],al
  db 0x00, 0x00                ; 00004C58  add [bx+si],al
  db 0x00, 0x00                ; 00004C5A  add [bx+si],al
  db 0x00, 0x00                ; 00004C5C  add [bx+si],al
  db 0x00, 0x00                ; 00004C5E  add [bx+si],al
  db 0x00, 0x00                ; 00004C60  add [bx+si],al
  db 0x00, 0x00                ; 00004C62  add [bx+si],al
  db 0x00, 0x00                ; 00004C64  add [bx+si],al
  db 0x00, 0x00                ; 00004C66  add [bx+si],al
  db 0x00, 0x00                ; 00004C68  add [bx+si],al
  db 0x00, 0x00                ; 00004C6A  add [bx+si],al
  db 0x00, 0x00                ; 00004C6C  add [bx+si],al
  db 0x00, 0x00                ; 00004C6E  add [bx+si],al
  db 0x00, 0x00                ; 00004C70  add [bx+si],al
  db 0x00, 0x00                ; 00004C72  add [bx+si],al
  db 0x00, 0x00                ; 00004C74  add [bx+si],al
  db 0x00, 0x00                ; 00004C76  add [bx+si],al
  db 0x00, 0x00                ; 00004C78  add [bx+si],al
  db 0x00, 0x00                ; 00004C7A  add [bx+si],al
  db 0x00, 0x00                ; 00004C7C  add [bx+si],al
  db 0x00, 0x00                ; 00004C7E  add [bx+si],al
  db 0x00, 0x00                ; 00004C80  add [bx+si],al
  db 0x00, 0x00                ; 00004C82  add [bx+si],al
  db 0x00, 0x00                ; 00004C84  add [bx+si],al
  db 0x00, 0x00                ; 00004C86  add [bx+si],al
  db 0x00, 0x00                ; 00004C88  add [bx+si],al
  db 0x00, 0x00                ; 00004C8A  add [bx+si],al
  db 0x00, 0x00                ; 00004C8C  add [bx+si],al
  db 0x00, 0x00                ; 00004C8E  add [bx+si],al
  db 0x00, 0x00                ; 00004C90  add [bx+si],al
  db 0x00, 0x00                ; 00004C92  add [bx+si],al
  db 0x00, 0x00                ; 00004C94  add [bx+si],al
  db 0x00, 0x00                ; 00004C96  add [bx+si],al
  db 0x00, 0x00                ; 00004C98  add [bx+si],al
  db 0x00, 0x00                ; 00004C9A  add [bx+si],al
  db 0x00, 0x00                ; 00004C9C  add [bx+si],al
  db 0x00, 0x00                ; 00004C9E  add [bx+si],al
  db 0x00, 0x00                ; 00004CA0  add [bx+si],al
  db 0x00, 0x00                ; 00004CA2  add [bx+si],al
  db 0x00, 0x00                ; 00004CA4  add [bx+si],al
  db 0x00, 0x00                ; 00004CA6  add [bx+si],al
  db 0x00, 0x00                ; 00004CA8  add [bx+si],al
  db 0x00, 0x00                ; 00004CAA  add [bx+si],al
  db 0x00, 0x00                ; 00004CAC  add [bx+si],al
  db 0x00, 0x00                ; 00004CAE  add [bx+si],al
  db 0x00, 0x00                ; 00004CB0  add [bx+si],al
  db 0x00, 0x00                ; 00004CB2  add [bx+si],al
  db 0x00, 0x00                ; 00004CB4  add [bx+si],al
  db 0x00, 0x00                ; 00004CB6  add [bx+si],al
  db 0x00, 0x00                ; 00004CB8  add [bx+si],al
  db 0x00, 0x00                ; 00004CBA  add [bx+si],al
  db 0x00, 0x00                ; 00004CBC  add [bx+si],al
  db 0x00, 0x00                ; 00004CBE  add [bx+si],al
  db 0x00, 0x00                ; 00004CC0  add [bx+si],al
  db 0x00, 0x00                ; 00004CC2  add [bx+si],al
  db 0x00, 0x00                ; 00004CC4  add [bx+si],al
  db 0x00, 0x00                ; 00004CC6  add [bx+si],al
  db 0x00, 0x00                ; 00004CC8  add [bx+si],al
  db 0x00, 0x00                ; 00004CCA  add [bx+si],al
  db 0x00, 0x00                ; 00004CCC  add [bx+si],al
  db 0x00, 0x00                ; 00004CCE  add [bx+si],al
  db 0x00, 0x00                ; 00004CD0  add [bx+si],al
  db 0x00, 0x00                ; 00004CD2  add [bx+si],al
  db 0x00, 0x00                ; 00004CD4  add [bx+si],al
  db 0x00, 0x00                ; 00004CD6  add [bx+si],al
  db 0x00, 0x00                ; 00004CD8  add [bx+si],al
  db 0x00, 0x00                ; 00004CDA  add [bx+si],al
  db 0x00, 0x00                ; 00004CDC  add [bx+si],al
  db 0x00, 0x00                ; 00004CDE  add [bx+si],al
  db 0x00, 0x00                ; 00004CE0  add [bx+si],al
  db 0x00, 0x00                ; 00004CE2  add [bx+si],al
  db 0x00, 0x00                ; 00004CE4  add [bx+si],al
  db 0x00, 0x00                ; 00004CE6  add [bx+si],al
  db 0x00, 0x00                ; 00004CE8  add [bx+si],al
  db 0x00, 0x00                ; 00004CEA  add [bx+si],al
  db 0x00, 0x00                ; 00004CEC  add [bx+si],al
  db 0x00, 0x00                ; 00004CEE  add [bx+si],al
  db 0x00, 0x00                ; 00004CF0  add [bx+si],al
  db 0x00, 0x00                ; 00004CF2  add [bx+si],al
  db 0x00, 0x00                ; 00004CF4  add [bx+si],al
  db 0x00, 0x00                ; 00004CF6  add [bx+si],al
  db 0x00, 0x00                ; 00004CF8  add [bx+si],al
  db 0x00, 0x00                ; 00004CFA  add [bx+si],al
  db 0x00, 0x00                ; 00004CFC  add [bx+si],al
  db 0x00, 0x00                ; 00004CFE  add [bx+si],al
  db 0x00, 0x00                ; 00004D00  add [bx+si],al
  db 0x00, 0x00                ; 00004D02  add [bx+si],al
  db 0x00, 0x00                ; 00004D04  add [bx+si],al
  db 0x00, 0x00                ; 00004D06  add [bx+si],al
  db 0x00, 0x00                ; 00004D08  add [bx+si],al
  db 0x00, 0x00                ; 00004D0A  add [bx+si],al
  db 0x00, 0x00                ; 00004D0C  add [bx+si],al
  db 0x00, 0x00                ; 00004D0E  add [bx+si],al
  db 0x00, 0x00                ; 00004D10  add [bx+si],al
  db 0x00, 0x00                ; 00004D12  add [bx+si],al
  db 0x00, 0x00                ; 00004D14  add [bx+si],al
  db 0x00, 0x00                ; 00004D16  add [bx+si],al
  db 0x00, 0x00                ; 00004D18  add [bx+si],al
  db 0x00, 0x00                ; 00004D1A  add [bx+si],al
  db 0x00, 0x00                ; 00004D1C  add [bx+si],al
  db 0x00, 0x00                ; 00004D1E  add [bx+si],al
  db 0x00, 0x00                ; 00004D20  add [bx+si],al
  db 0x00, 0x00                ; 00004D22  add [bx+si],al
  db 0x00, 0x00                ; 00004D24  add [bx+si],al
  db 0x00, 0x00                ; 00004D26  add [bx+si],al
  db 0x00, 0x00                ; 00004D28  add [bx+si],al
  db 0x00, 0x00                ; 00004D2A  add [bx+si],al
  db 0x00, 0x00                ; 00004D2C  add [bx+si],al
  db 0x00, 0x00                ; 00004D2E  add [bx+si],al
  db 0x00, 0x00                ; 00004D30  add [bx+si],al
  db 0x00, 0x00                ; 00004D32  add [bx+si],al
  db 0x00, 0x00                ; 00004D34  add [bx+si],al
  db 0x00, 0x00                ; 00004D36  add [bx+si],al
  db 0x00, 0x00                ; 00004D38  add [bx+si],al
  db 0x00, 0x00                ; 00004D3A  add [bx+si],al
  db 0x00, 0x00                ; 00004D3C  add [bx+si],al
  db 0x00, 0x00                ; 00004D3E  add [bx+si],al
  db 0x00, 0x00                ; 00004D40  add [bx+si],al
  db 0x00, 0x00                ; 00004D42  add [bx+si],al
  db 0x00, 0x00                ; 00004D44  add [bx+si],al
  db 0x00, 0x00                ; 00004D46  add [bx+si],al
  db 0x00, 0x00                ; 00004D48  add [bx+si],al
  db 0x00, 0x00                ; 00004D4A  add [bx+si],al
  db 0x00, 0x00                ; 00004D4C  add [bx+si],al
  db 0x00, 0x00                ; 00004D4E  add [bx+si],al
  db 0x00, 0x00                ; 00004D50  add [bx+si],al
  db 0x00, 0x00                ; 00004D52  add [bx+si],al
  db 0x00, 0x00                ; 00004D54  add [bx+si],al
  db 0x00, 0x00                ; 00004D56  add [bx+si],al
  db 0x00, 0x00                ; 00004D58  add [bx+si],al
  db 0x00, 0x00                ; 00004D5A  add [bx+si],al
  db 0x00, 0x00                ; 00004D5C  add [bx+si],al
  db 0x00, 0x00                ; 00004D5E  add [bx+si],al
  db 0x00, 0x00                ; 00004D60  add [bx+si],al
  db 0x00, 0x00                ; 00004D62  add [bx+si],al
  db 0x00, 0x00                ; 00004D64  add [bx+si],al
  db 0x00, 0x00                ; 00004D66  add [bx+si],al
  db 0x00, 0x00                ; 00004D68  add [bx+si],al
  db 0x00, 0x00                ; 00004D6A  add [bx+si],al
  db 0x00, 0x00                ; 00004D6C  add [bx+si],al
  db 0x00, 0x00                ; 00004D6E  add [bx+si],al
  db 0x00, 0x00                ; 00004D70  add [bx+si],al
  db 0x00, 0x00                ; 00004D72  add [bx+si],al
  db 0x00, 0x00                ; 00004D74  add [bx+si],al
  db 0x00, 0x00                ; 00004D76  add [bx+si],al
  db 0x00, 0x00                ; 00004D78  add [bx+si],al
  db 0x00, 0x00                ; 00004D7A  add [bx+si],al
  db 0x00, 0x00                ; 00004D7C  add [bx+si],al
  db 0x00, 0x00                ; 00004D7E  add [bx+si],al
  db 0x00, 0x00                ; 00004D80  add [bx+si],al
  db 0x00, 0x00                ; 00004D82  add [bx+si],al
  db 0x00, 0x00                ; 00004D84  add [bx+si],al
  db 0x00, 0x00                ; 00004D86  add [bx+si],al
  db 0x00, 0x00                ; 00004D88  add [bx+si],al
  db 0x00, 0x00                ; 00004D8A  add [bx+si],al
  db 0x00, 0x00                ; 00004D8C  add [bx+si],al
  db 0x00, 0x00                ; 00004D8E  add [bx+si],al
  db 0x00, 0x00                ; 00004D90  add [bx+si],al
  db 0x00, 0x00                ; 00004D92  add [bx+si],al
  db 0x00, 0x00                ; 00004D94  add [bx+si],al
  db 0x00, 0x00                ; 00004D96  add [bx+si],al
  db 0x00, 0x00                ; 00004D98  add [bx+si],al
  db 0x00, 0x00                ; 00004D9A  add [bx+si],al
  db 0x00, 0x00                ; 00004D9C  add [bx+si],al
  db 0x00, 0x00                ; 00004D9E  add [bx+si],al
  db 0x00, 0x00                ; 00004DA0  add [bx+si],al
  db 0x00, 0x00                ; 00004DA2  add [bx+si],al
  db 0x00, 0x00                ; 00004DA4  add [bx+si],al
  db 0x00, 0x00                ; 00004DA6  add [bx+si],al
  db 0x00, 0x00                ; 00004DA8  add [bx+si],al
  db 0x00, 0x00                ; 00004DAA  add [bx+si],al
  db 0x00, 0x00                ; 00004DAC  add [bx+si],al
  db 0x00, 0x00                ; 00004DAE  add [bx+si],al
  db 0x00, 0x00                ; 00004DB0  add [bx+si],al
  db 0x00, 0x00                ; 00004DB2  add [bx+si],al
  db 0x00, 0x00                ; 00004DB4  add [bx+si],al
  db 0x00, 0x00                ; 00004DB6  add [bx+si],al
  db 0x00, 0x00                ; 00004DB8  add [bx+si],al
  db 0x00, 0x00                ; 00004DBA  add [bx+si],al
  db 0x00, 0x00                ; 00004DBC  add [bx+si],al
  db 0x00, 0x00                ; 00004DBE  add [bx+si],al
  db 0x00, 0x00                ; 00004DC0  add [bx+si],al
  db 0x00, 0x00                ; 00004DC2  add [bx+si],al
  db 0x00, 0x00                ; 00004DC4  add [bx+si],al
  db 0x00, 0x00                ; 00004DC6  add [bx+si],al
  db 0x00, 0x00                ; 00004DC8  add [bx+si],al
  db 0x00, 0x00                ; 00004DCA  add [bx+si],al
  db 0x00, 0x00                ; 00004DCC  add [bx+si],al
  db 0x00, 0x00                ; 00004DCE  add [bx+si],al
  db 0x00, 0x00                ; 00004DD0  add [bx+si],al
  db 0x00, 0x00                ; 00004DD2  add [bx+si],al
  db 0x00, 0x00                ; 00004DD4  add [bx+si],al
  db 0x00, 0x00                ; 00004DD6  add [bx+si],al
  db 0x00, 0x00                ; 00004DD8  add [bx+si],al
  db 0x00, 0x00                ; 00004DDA  add [bx+si],al
  db 0x00, 0x00                ; 00004DDC  add [bx+si],al
  db 0x00, 0x00                ; 00004DDE  add [bx+si],al
  db 0x00, 0x00                ; 00004DE0  add [bx+si],al
  db 0x00, 0x00                ; 00004DE2  add [bx+si],al
  db 0x00, 0x00                ; 00004DE4  add [bx+si],al
  db 0x00, 0x00                ; 00004DE6  add [bx+si],al
  db 0x00, 0x00                ; 00004DE8  add [bx+si],al
  db 0x00, 0x00                ; 00004DEA  add [bx+si],al
  db 0x00, 0x00                ; 00004DEC  add [bx+si],al
  db 0x00, 0x00                ; 00004DEE  add [bx+si],al
  db 0x00, 0x00                ; 00004DF0  add [bx+si],al
  db 0x00, 0x00                ; 00004DF2  add [bx+si],al
  db 0x00, 0x00                ; 00004DF4  add [bx+si],al
  db 0x00, 0x00                ; 00004DF6  add [bx+si],al
  db 0x00, 0x00                ; 00004DF8  add [bx+si],al
  db 0x00, 0x00                ; 00004DFA  add [bx+si],al
  db 0x00, 0x00                ; 00004DFC  add [bx+si],al
  db 0x00, 0x00                ; 00004DFE  add [bx+si],al
  db 0x00, 0x00                ; 00004E00  add [bx+si],al
  db 0x00, 0x00                ; 00004E02  add [bx+si],al
  db 0x00, 0x00                ; 00004E04  add [bx+si],al
  db 0x00, 0x00                ; 00004E06  add [bx+si],al
  db 0x00, 0x00                ; 00004E08  add [bx+si],al
  db 0x00, 0x00                ; 00004E0A  add [bx+si],al
  db 0x00, 0x00                ; 00004E0C  add [bx+si],al
  db 0x00, 0x00                ; 00004E0E  add [bx+si],al
  db 0x00, 0x00                ; 00004E10  add [bx+si],al
  db 0x00, 0x00                ; 00004E12  add [bx+si],al
  db 0x00, 0x00                ; 00004E14  add [bx+si],al
  db 0x00, 0x00                ; 00004E16  add [bx+si],al
  db 0x00, 0x00                ; 00004E18  add [bx+si],al
  db 0x00, 0x00                ; 00004E1A  add [bx+si],al
  db 0x00, 0x00                ; 00004E1C  add [bx+si],al
  db 0x00, 0x00                ; 00004E1E  add [bx+si],al
  db 0x00, 0x00                ; 00004E20  add [bx+si],al
  db 0x00, 0x00                ; 00004E22  add [bx+si],al
  db 0x00, 0x00                ; 00004E24  add [bx+si],al
  db 0x00, 0x00                ; 00004E26  add [bx+si],al
  db 0x00, 0x00                ; 00004E28  add [bx+si],al
  db 0x00, 0x00                ; 00004E2A  add [bx+si],al
  db 0x00, 0x00                ; 00004E2C  add [bx+si],al
  db 0x00, 0x00                ; 00004E2E  add [bx+si],al
  db 0x00, 0x00                ; 00004E30  add [bx+si],al
  db 0x00, 0x00                ; 00004E32  add [bx+si],al
  db 0x00, 0x00                ; 00004E34  add [bx+si],al
  db 0x00, 0x00                ; 00004E36  add [bx+si],al
  db 0x00, 0x00                ; 00004E38  add [bx+si],al
  db 0x00, 0x00                ; 00004E3A  add [bx+si],al
  db 0x00, 0x00                ; 00004E3C  add [bx+si],al
  db 0x00, 0x00                ; 00004E3E  add [bx+si],al
  db 0x00, 0x00                ; 00004E40  add [bx+si],al
  db 0x00, 0x00                ; 00004E42  add [bx+si],al
  db 0x00, 0x00                ; 00004E44  add [bx+si],al
  db 0x00, 0x00                ; 00004E46  add [bx+si],al
  db 0x00, 0x00                ; 00004E48  add [bx+si],al
  db 0x00, 0x00                ; 00004E4A  add [bx+si],al
  db 0x00, 0x00                ; 00004E4C  add [bx+si],al
  db 0x00, 0x00                ; 00004E4E  add [bx+si],al
  db 0x00, 0x00                ; 00004E50  add [bx+si],al
  db 0x00, 0x00                ; 00004E52  add [bx+si],al
  db 0x00, 0x00                ; 00004E54  add [bx+si],al
  db 0x00, 0x00                ; 00004E56  add [bx+si],al
  db 0x00, 0x00                ; 00004E58  add [bx+si],al
  db 0x00, 0x00                ; 00004E5A  add [bx+si],al
  db 0x00, 0x00                ; 00004E5C  add [bx+si],al
  db 0x00, 0x00                ; 00004E5E  add [bx+si],al
  db 0x00, 0x00                ; 00004E60  add [bx+si],al
  db 0x00, 0x00                ; 00004E62  add [bx+si],al
  db 0x00, 0x00                ; 00004E64  add [bx+si],al
  db 0x00, 0x00                ; 00004E66  add [bx+si],al
  db 0x00, 0x00                ; 00004E68  add [bx+si],al
  db 0x00, 0x00                ; 00004E6A  add [bx+si],al
  db 0x00, 0x00                ; 00004E6C  add [bx+si],al
  db 0x00, 0x00                ; 00004E6E  add [bx+si],al
  db 0x00, 0x00                ; 00004E70  add [bx+si],al
  db 0x00, 0x00                ; 00004E72  add [bx+si],al
  db 0x00, 0x00                ; 00004E74  add [bx+si],al
  db 0x00, 0x00                ; 00004E76  add [bx+si],al
  db 0x00, 0x00                ; 00004E78  add [bx+si],al
  db 0x00, 0x00                ; 00004E7A  add [bx+si],al
  db 0x00, 0x00                ; 00004E7C  add [bx+si],al
  db 0x00, 0x00                ; 00004E7E  add [bx+si],al
  db 0x00, 0x00                ; 00004E80  add [bx+si],al
  db 0x00, 0x00                ; 00004E82  add [bx+si],al
  db 0x00, 0x00                ; 00004E84  add [bx+si],al
  db 0x00, 0x00                ; 00004E86  add [bx+si],al
  db 0x00, 0x00                ; 00004E88  add [bx+si],al
  db 0x00, 0x00                ; 00004E8A  add [bx+si],al
  db 0x00, 0x00                ; 00004E8C  add [bx+si],al
  db 0x00, 0x00                ; 00004E8E  add [bx+si],al
  db 0x00, 0x00                ; 00004E90  add [bx+si],al
  db 0x00, 0x00                ; 00004E92  add [bx+si],al
  db 0x00, 0x00                ; 00004E94  add [bx+si],al
  db 0x00, 0x00                ; 00004E96  add [bx+si],al
  db 0x00, 0x00                ; 00004E98  add [bx+si],al
  db 0x00, 0x00                ; 00004E9A  add [bx+si],al
  db 0x00, 0x00                ; 00004E9C  add [bx+si],al
  db 0x00, 0x00                ; 00004E9E  add [bx+si],al
  db 0x00, 0x00                ; 00004EA0  add [bx+si],al
  db 0x00, 0x00                ; 00004EA2  add [bx+si],al
  db 0x00, 0x00                ; 00004EA4  add [bx+si],al
  db 0x00, 0x00                ; 00004EA6  add [bx+si],al
  db 0x00, 0x00                ; 00004EA8  add [bx+si],al
  db 0x00, 0x00                ; 00004EAA  add [bx+si],al
  db 0x00, 0x00                ; 00004EAC  add [bx+si],al
  db 0x00, 0x00                ; 00004EAE  add [bx+si],al
  db 0x00, 0x00                ; 00004EB0  add [bx+si],al
  db 0x00, 0x00                ; 00004EB2  add [bx+si],al
  db 0x00, 0x00                ; 00004EB4  add [bx+si],al
  db 0x00, 0x00                ; 00004EB6  add [bx+si],al
  db 0x00, 0x00                ; 00004EB8  add [bx+si],al
  db 0x00, 0x00                ; 00004EBA  add [bx+si],al
  db 0x00, 0x00                ; 00004EBC  add [bx+si],al
  db 0x00, 0x00                ; 00004EBE  add [bx+si],al
  db 0x00, 0x00                ; 00004EC0  add [bx+si],al
  db 0x00, 0x00                ; 00004EC2  add [bx+si],al
  db 0x00, 0x00                ; 00004EC4  add [bx+si],al
  db 0x00, 0x00                ; 00004EC6  add [bx+si],al
  db 0x00, 0x00                ; 00004EC8  add [bx+si],al
  db 0x00, 0x00                ; 00004ECA  add [bx+si],al
  db 0x00, 0x00                ; 00004ECC  add [bx+si],al
  db 0x00, 0x00                ; 00004ECE  add [bx+si],al
  db 0x00, 0x00                ; 00004ED0  add [bx+si],al
  db 0x00, 0x00                ; 00004ED2  add [bx+si],al
  db 0x00, 0x00                ; 00004ED4  add [bx+si],al
  db 0x00, 0x00                ; 00004ED6  add [bx+si],al
  db 0x00, 0x00                ; 00004ED8  add [bx+si],al
  db 0x00, 0x00                ; 00004EDA  add [bx+si],al
  db 0x00, 0x00                ; 00004EDC  add [bx+si],al
  db 0x00, 0x00                ; 00004EDE  add [bx+si],al
  db 0x00, 0x00                ; 00004EE0  add [bx+si],al
  db 0x00, 0x00                ; 00004EE2  add [bx+si],al
  db 0x00, 0x00                ; 00004EE4  add [bx+si],al
  db 0x00, 0x00                ; 00004EE6  add [bx+si],al
  db 0x00, 0x00                ; 00004EE8  add [bx+si],al
  db 0x00, 0x00                ; 00004EEA  add [bx+si],al
  db 0x00, 0x00                ; 00004EEC  add [bx+si],al
  db 0x00, 0x00                ; 00004EEE  add [bx+si],al
  db 0x00, 0x00                ; 00004EF0  add [bx+si],al
  db 0x00, 0x00                ; 00004EF2  add [bx+si],al
  db 0x00, 0x00                ; 00004EF4  add [bx+si],al
  db 0x00, 0x00                ; 00004EF6  add [bx+si],al
  db 0x00, 0x00                ; 00004EF8  add [bx+si],al
  db 0x00, 0x00                ; 00004EFA  add [bx+si],al
  db 0x00, 0x00                ; 00004EFC  add [bx+si],al
  db 0x00, 0x00                ; 00004EFE  add [bx+si],al
  db 0x00, 0x00                ; 00004F00  add [bx+si],al
  db 0x00, 0x00                ; 00004F02  add [bx+si],al
  db 0x00, 0x00                ; 00004F04  add [bx+si],al
  db 0x00, 0x00                ; 00004F06  add [bx+si],al
  db 0x00, 0x00                ; 00004F08  add [bx+si],al
  db 0x00, 0x00                ; 00004F0A  add [bx+si],al
  db 0x00, 0x00                ; 00004F0C  add [bx+si],al
  db 0x00, 0x00                ; 00004F0E  add [bx+si],al
  db 0x00, 0x00                ; 00004F10  add [bx+si],al
  db 0x00, 0x00                ; 00004F12  add [bx+si],al
  db 0x00, 0x00                ; 00004F14  add [bx+si],al
  db 0x00, 0x00                ; 00004F16  add [bx+si],al
  db 0x00, 0x00                ; 00004F18  add [bx+si],al
  db 0x00, 0x00                ; 00004F1A  add [bx+si],al
  db 0x00, 0x00                ; 00004F1C  add [bx+si],al
  db 0x00, 0x00                ; 00004F1E  add [bx+si],al
  db 0x00, 0x00                ; 00004F20  add [bx+si],al
  db 0x00, 0x00                ; 00004F22  add [bx+si],al
  db 0x00, 0x00                ; 00004F24  add [bx+si],al
  db 0x00, 0x00                ; 00004F26  add [bx+si],al
  db 0x00, 0x00                ; 00004F28  add [bx+si],al
  db 0x00, 0x00                ; 00004F2A  add [bx+si],al
  db 0x00, 0x00                ; 00004F2C  add [bx+si],al
  db 0x00, 0x00                ; 00004F2E  add [bx+si],al
  db 0x00, 0x00                ; 00004F30  add [bx+si],al
  db 0x00, 0x00                ; 00004F32  add [bx+si],al
  db 0x00, 0x00                ; 00004F34  add [bx+si],al
  db 0x00, 0x00                ; 00004F36  add [bx+si],al
  db 0x00, 0x00                ; 00004F38  add [bx+si],al
  db 0x00, 0x00                ; 00004F3A  add [bx+si],al
  db 0x00, 0x00                ; 00004F3C  add [bx+si],al
  db 0x00, 0x00                ; 00004F3E  add [bx+si],al
  db 0x00, 0x00                ; 00004F40  add [bx+si],al
  db 0x00, 0x00                ; 00004F42  add [bx+si],al
  db 0x00, 0x00                ; 00004F44  add [bx+si],al
  db 0x00, 0x00                ; 00004F46  add [bx+si],al
  db 0x00, 0x00                ; 00004F48  add [bx+si],al
  db 0x00, 0x00                ; 00004F4A  add [bx+si],al
  db 0x00, 0x00                ; 00004F4C  add [bx+si],al
  db 0x00, 0x00                ; 00004F4E  add [bx+si],al
  db 0x00, 0x00                ; 00004F50  add [bx+si],al
  db 0x00, 0x00                ; 00004F52  add [bx+si],al
  db 0x00, 0x00                ; 00004F54  add [bx+si],al
  db 0x00, 0x00                ; 00004F56  add [bx+si],al
  db 0x00, 0x00                ; 00004F58  add [bx+si],al
  db 0x00, 0x00                ; 00004F5A  add [bx+si],al
  db 0x00, 0x00                ; 00004F5C  add [bx+si],al
  db 0x00, 0x00                ; 00004F5E  add [bx+si],al
  db 0x00, 0x00                ; 00004F60  add [bx+si],al
  db 0x00, 0x00                ; 00004F62  add [bx+si],al
  db 0x00, 0x00                ; 00004F64  add [bx+si],al
  db 0x00, 0x00                ; 00004F66  add [bx+si],al
  db 0x00, 0x00                ; 00004F68  add [bx+si],al
  db 0x00, 0x00                ; 00004F6A  add [bx+si],al
  db 0x00, 0x00                ; 00004F6C  add [bx+si],al
  db 0x00, 0x00                ; 00004F6E  add [bx+si],al
  db 0x00, 0x00                ; 00004F70  add [bx+si],al
  db 0x00, 0x00                ; 00004F72  add [bx+si],al
  db 0x00, 0x00                ; 00004F74  add [bx+si],al
  db 0x00, 0x00                ; 00004F76  add [bx+si],al
  db 0x00, 0x00                ; 00004F78  add [bx+si],al
  db 0x00, 0x00                ; 00004F7A  add [bx+si],al
  db 0x00, 0x00                ; 00004F7C  add [bx+si],al
  db 0x00, 0x00                ; 00004F7E  add [bx+si],al
  db 0x00, 0x00                ; 00004F80  add [bx+si],al
  db 0x00, 0x00                ; 00004F82  add [bx+si],al
  db 0x00, 0x00                ; 00004F84  add [bx+si],al
  db 0x00, 0x00                ; 00004F86  add [bx+si],al
  db 0x00, 0x00                ; 00004F88  add [bx+si],al
  db 0x00, 0x00                ; 00004F8A  add [bx+si],al
  db 0x00, 0x00                ; 00004F8C  add [bx+si],al
  db 0x00, 0x00                ; 00004F8E  add [bx+si],al
  db 0x00, 0x00                ; 00004F90  add [bx+si],al
  db 0x00, 0x00                ; 00004F92  add [bx+si],al
  db 0x00, 0x00                ; 00004F94  add [bx+si],al
  db 0x00, 0x00                ; 00004F96  add [bx+si],al
  db 0x00, 0x00                ; 00004F98  add [bx+si],al
  db 0x00, 0x00                ; 00004F9A  add [bx+si],al
  db 0x00, 0x00                ; 00004F9C  add [bx+si],al
  db 0x00, 0x00                ; 00004F9E  add [bx+si],al
  db 0x00, 0x00                ; 00004FA0  add [bx+si],al
  db 0x00, 0x00                ; 00004FA2  add [bx+si],al
  db 0x00, 0x00                ; 00004FA4  add [bx+si],al
  db 0x00, 0x00                ; 00004FA6  add [bx+si],al
  db 0x00, 0x00                ; 00004FA8  add [bx+si],al
  db 0x00, 0x00                ; 00004FAA  add [bx+si],al
  db 0x00, 0x00                ; 00004FAC  add [bx+si],al
  db 0x00, 0x00                ; 00004FAE  add [bx+si],al
  db 0x00, 0x00                ; 00004FB0  add [bx+si],al
  db 0x00, 0x00                ; 00004FB2  add [bx+si],al
  db 0x00, 0x00                ; 00004FB4  add [bx+si],al
  db 0x00, 0x00                ; 00004FB6  add [bx+si],al
  db 0x00, 0x00                ; 00004FB8  add [bx+si],al
  db 0x00, 0x00                ; 00004FBA  add [bx+si],al
  db 0x00, 0x00                ; 00004FBC  add [bx+si],al
  db 0x00, 0x00                ; 00004FBE  add [bx+si],al
  db 0x00, 0x00                ; 00004FC0  add [bx+si],al
  db 0x00, 0x00                ; 00004FC2  add [bx+si],al
  db 0x00, 0x00                ; 00004FC4  add [bx+si],al
  db 0x00, 0x00                ; 00004FC6  add [bx+si],al
  db 0x00, 0x00                ; 00004FC8  add [bx+si],al
  db 0x00, 0x00                ; 00004FCA  add [bx+si],al
  db 0x00, 0x00                ; 00004FCC  add [bx+si],al
  db 0x00, 0x00                ; 00004FCE  add [bx+si],al
  db 0x00, 0x00                ; 00004FD0  add [bx+si],al
  db 0x00, 0x00                ; 00004FD2  add [bx+si],al
  db 0x00, 0x00                ; 00004FD4  add [bx+si],al
  db 0x00, 0x00                ; 00004FD6  add [bx+si],al
  db 0x00, 0x00                ; 00004FD8  add [bx+si],al
  db 0x00, 0x00                ; 00004FDA  add [bx+si],al
  db 0x00, 0x00                ; 00004FDC  add [bx+si],al
  db 0x00, 0x00                ; 00004FDE  add [bx+si],al
  db 0x00, 0x00                ; 00004FE0  add [bx+si],al
  db 0x00, 0x00                ; 00004FE2  add [bx+si],al
  db 0x00, 0x00                ; 00004FE4  add [bx+si],al
  db 0x00, 0x00                ; 00004FE6  add [bx+si],al
  db 0x00, 0x00                ; 00004FE8  add [bx+si],al
  db 0x00, 0x00                ; 00004FEA  add [bx+si],al
  db 0x00, 0x00                ; 00004FEC  add [bx+si],al
  db 0x00, 0x00                ; 00004FEE  add [bx+si],al
  db 0x00, 0x00                ; 00004FF0  add [bx+si],al
  db 0x00, 0x00                ; 00004FF2  add [bx+si],al
  db 0x00, 0x00                ; 00004FF4  add [bx+si],al
  db 0x00, 0x00                ; 00004FF6  add [bx+si],al
  db 0x00, 0x00                ; 00004FF8  add [bx+si],al
  db 0x00, 0x00                ; 00004FFA  add [bx+si],al
  db 0x00, 0x00                ; 00004FFC  add [bx+si],al
  db 0x00, 0x00                ; 00004FFE  add [bx+si],al
  db 0x00, 0x00                ; 00005000  add [bx+si],al
  db 0x00, 0x00                ; 00005002  add [bx+si],al
  db 0x00, 0x00                ; 00005004  add [bx+si],al
  db 0x00, 0x00                ; 00005006  add [bx+si],al
  db 0x00, 0x00                ; 00005008  add [bx+si],al
  db 0x00, 0x00                ; 0000500A  add [bx+si],al
  db 0x00, 0x00                ; 0000500C  add [bx+si],al
  db 0x00, 0x00                ; 0000500E  add [bx+si],al
  db 0x00, 0x00                ; 00005010  add [bx+si],al
  db 0x00, 0x00                ; 00005012  add [bx+si],al
  db 0x00, 0x00                ; 00005014  add [bx+si],al
  db 0x00, 0x00                ; 00005016  add [bx+si],al
  db 0x00, 0x00                ; 00005018  add [bx+si],al
  db 0x00, 0x00                ; 0000501A  add [bx+si],al
  db 0x00, 0x00                ; 0000501C  add [bx+si],al
  db 0x00, 0x00                ; 0000501E  add [bx+si],al
  db 0x00, 0x00                ; 00005020  add [bx+si],al
  db 0x00, 0x00                ; 00005022  add [bx+si],al
  db 0x00, 0x00                ; 00005024  add [bx+si],al
  db 0x00, 0x00                ; 00005026  add [bx+si],al
  db 0x00, 0x00                ; 00005028  add [bx+si],al
  db 0x00, 0x00                ; 0000502A  add [bx+si],al
  db 0x00, 0x00                ; 0000502C  add [bx+si],al
  db 0x00, 0x00                ; 0000502E  add [bx+si],al
  db 0x00, 0x00                ; 00005030  add [bx+si],al
  db 0x00, 0x00                ; 00005032  add [bx+si],al
  db 0x00, 0x00                ; 00005034  add [bx+si],al
  db 0x00, 0x00                ; 00005036  add [bx+si],al
  db 0x00, 0x00                ; 00005038  add [bx+si],al
  db 0x00, 0x00                ; 0000503A  add [bx+si],al
  db 0x00, 0x00                ; 0000503C  add [bx+si],al
  db 0x00, 0x00                ; 0000503E  add [bx+si],al
  db 0x00, 0x00                ; 00005040  add [bx+si],al
  db 0x00, 0x00                ; 00005042  add [bx+si],al
  db 0x00, 0x00                ; 00005044  add [bx+si],al
  db 0x00, 0x00                ; 00005046  add [bx+si],al
  db 0x00, 0x00                ; 00005048  add [bx+si],al
  db 0x00, 0x00                ; 0000504A  add [bx+si],al
  db 0x00, 0x00                ; 0000504C  add [bx+si],al
  db 0x00, 0x00                ; 0000504E  add [bx+si],al
  db 0x00, 0x00                ; 00005050  add [bx+si],al
  db 0x00, 0x00                ; 00005052  add [bx+si],al
  db 0x00, 0x00                ; 00005054  add [bx+si],al
  db 0x00, 0x00                ; 00005056  add [bx+si],al
  db 0x00, 0x00                ; 00005058  add [bx+si],al
  db 0x00, 0x00                ; 0000505A  add [bx+si],al
  db 0x00, 0x00                ; 0000505C  add [bx+si],al
  db 0x00, 0x00                ; 0000505E  add [bx+si],al
  db 0x00, 0x00                ; 00005060  add [bx+si],al
  db 0x00, 0x00                ; 00005062  add [bx+si],al
  db 0x00, 0x00                ; 00005064  add [bx+si],al
  db 0x00, 0x00                ; 00005066  add [bx+si],al
  db 0x00, 0x00                ; 00005068  add [bx+si],al
  db 0x00, 0x00                ; 0000506A  add [bx+si],al
  db 0x00, 0x00                ; 0000506C  add [bx+si],al
  db 0x00, 0x00                ; 0000506E  add [bx+si],al
  db 0x00, 0x00                ; 00005070  add [bx+si],al
  db 0x00, 0x00                ; 00005072  add [bx+si],al
  db 0x00, 0x00                ; 00005074  add [bx+si],al
  db 0x00, 0x00                ; 00005076  add [bx+si],al
  db 0x00, 0x00                ; 00005078  add [bx+si],al
  db 0x00, 0x00                ; 0000507A  add [bx+si],al
  db 0x00, 0x00                ; 0000507C  add [bx+si],al
  db 0x00, 0x00                ; 0000507E  add [bx+si],al
  db 0x00, 0x00                ; 00005080  add [bx+si],al
  db 0x00, 0x00                ; 00005082  add [bx+si],al
  db 0x00, 0x00                ; 00005084  add [bx+si],al
  db 0x00, 0x00                ; 00005086  add [bx+si],al
  db 0x00, 0x00                ; 00005088  add [bx+si],al
  db 0x00, 0x00                ; 0000508A  add [bx+si],al
  db 0x00, 0x00                ; 0000508C  add [bx+si],al
  db 0x00, 0x00                ; 0000508E  add [bx+si],al
  db 0x00, 0x00                ; 00005090  add [bx+si],al
  db 0x00, 0x00                ; 00005092  add [bx+si],al
  db 0x00, 0x00                ; 00005094  add [bx+si],al
  db 0x00, 0x00                ; 00005096  add [bx+si],al
  db 0x00, 0x00                ; 00005098  add [bx+si],al
  db 0x00, 0x00                ; 0000509A  add [bx+si],al
  db 0x00, 0x00                ; 0000509C  add [bx+si],al
  db 0x00, 0x00                ; 0000509E  add [bx+si],al
  db 0x00, 0x00                ; 000050A0  add [bx+si],al
  db 0x00, 0x00                ; 000050A2  add [bx+si],al
  db 0x00, 0x00                ; 000050A4  add [bx+si],al
  db 0x00, 0x00                ; 000050A6  add [bx+si],al
  db 0x00, 0x00                ; 000050A8  add [bx+si],al
  db 0x00, 0x00                ; 000050AA  add [bx+si],al
  db 0x00, 0x00                ; 000050AC  add [bx+si],al
  db 0x00, 0x00                ; 000050AE  add [bx+si],al
  db 0x00, 0x00                ; 000050B0  add [bx+si],al
  db 0x00, 0x00                ; 000050B2  add [bx+si],al
  db 0x00, 0x00                ; 000050B4  add [bx+si],al
  db 0x00, 0x00                ; 000050B6  add [bx+si],al
  db 0x00, 0x00                ; 000050B8  add [bx+si],al
  db 0x00, 0x00                ; 000050BA  add [bx+si],al
  db 0x00, 0x00                ; 000050BC  add [bx+si],al
  db 0x00, 0x00                ; 000050BE  add [bx+si],al
  db 0x00, 0x00                ; 000050C0  add [bx+si],al
  db 0x00, 0x00                ; 000050C2  add [bx+si],al
  db 0x00, 0x00                ; 000050C4  add [bx+si],al
  db 0x00, 0x00                ; 000050C6  add [bx+si],al
  db 0x00, 0x00                ; 000050C8  add [bx+si],al
  db 0x00, 0x00                ; 000050CA  add [bx+si],al
  db 0x00, 0x00                ; 000050CC  add [bx+si],al
  db 0x00, 0x00                ; 000050CE  add [bx+si],al
  db 0x00, 0x00                ; 000050D0  add [bx+si],al
  db 0x00, 0x00                ; 000050D2  add [bx+si],al
  db 0x00, 0x00                ; 000050D4  add [bx+si],al
  db 0x00, 0x00                ; 000050D6  add [bx+si],al
  db 0x00, 0x00                ; 000050D8  add [bx+si],al
  db 0x00, 0x00                ; 000050DA  add [bx+si],al
  db 0x00, 0x00                ; 000050DC  add [bx+si],al
  db 0x00, 0x00                ; 000050DE  add [bx+si],al
  db 0x00, 0x00                ; 000050E0  add [bx+si],al
  db 0x00, 0x00                ; 000050E2  add [bx+si],al
  db 0x00, 0x00                ; 000050E4  add [bx+si],al
  db 0x00, 0x00                ; 000050E6  add [bx+si],al
  db 0x00, 0x00                ; 000050E8  add [bx+si],al
  db 0x00, 0x00                ; 000050EA  add [bx+si],al
  db 0x00, 0x00                ; 000050EC  add [bx+si],al
  db 0x00, 0x00                ; 000050EE  add [bx+si],al
  db 0x00, 0x00                ; 000050F0  add [bx+si],al
  db 0x00, 0x00                ; 000050F2  add [bx+si],al
  db 0x00, 0x00                ; 000050F4  add [bx+si],al
  db 0x00, 0x00                ; 000050F6  add [bx+si],al
  db 0x00, 0x00                ; 000050F8  add [bx+si],al
  db 0x00, 0x00                ; 000050FA  add [bx+si],al
  db 0x00, 0x00                ; 000050FC  add [bx+si],al
  db 0x00, 0x00                ; 000050FE  add [bx+si],al
  db 0x00, 0x00                ; 00005100  add [bx+si],al
  db 0x00, 0x00                ; 00005102  add [bx+si],al
  db 0x00, 0x00                ; 00005104  add [bx+si],al
  db 0x00, 0x00                ; 00005106  add [bx+si],al
  db 0x00, 0x00                ; 00005108  add [bx+si],al
  db 0x00, 0x00                ; 0000510A  add [bx+si],al
  db 0x00, 0x00                ; 0000510C  add [bx+si],al
  db 0x00, 0x00                ; 0000510E  add [bx+si],al
  db 0x00, 0x00                ; 00005110  add [bx+si],al
  db 0x00, 0x00                ; 00005112  add [bx+si],al
  db 0x00, 0x00                ; 00005114  add [bx+si],al
  db 0x00, 0x00                ; 00005116  add [bx+si],al
  db 0x00, 0x00                ; 00005118  add [bx+si],al
  db 0x00, 0x00                ; 0000511A  add [bx+si],al
  db 0x00, 0x00                ; 0000511C  add [bx+si],al
  db 0x00, 0x00                ; 0000511E  add [bx+si],al
  db 0x00, 0x00                ; 00005120  add [bx+si],al
  db 0x00, 0x00                ; 00005122  add [bx+si],al
  db 0x00, 0x00                ; 00005124  add [bx+si],al
  db 0x00, 0x00                ; 00005126  add [bx+si],al
  db 0x00, 0x00                ; 00005128  add [bx+si],al
  db 0x00, 0x00                ; 0000512A  add [bx+si],al
  db 0x00, 0x00                ; 0000512C  add [bx+si],al
  db 0x00, 0x00                ; 0000512E  add [bx+si],al
  db 0x00, 0x00                ; 00005130  add [bx+si],al
  db 0x00, 0x00                ; 00005132  add [bx+si],al
  db 0x00, 0x00                ; 00005134  add [bx+si],al
  db 0x00, 0x00                ; 00005136  add [bx+si],al
  db 0x00, 0x00                ; 00005138  add [bx+si],al
  db 0x00, 0x00                ; 0000513A  add [bx+si],al
  db 0x00, 0x00                ; 0000513C  add [bx+si],al
  db 0x00, 0x00                ; 0000513E  add [bx+si],al
  db 0x00, 0x00                ; 00005140  add [bx+si],al
  db 0x00, 0x00                ; 00005142  add [bx+si],al
  db 0x00, 0x00                ; 00005144  add [bx+si],al
  db 0x00, 0x00                ; 00005146  add [bx+si],al
  db 0x00, 0x00                ; 00005148  add [bx+si],al
  db 0x00, 0x00                ; 0000514A  add [bx+si],al
  db 0x00, 0x00                ; 0000514C  add [bx+si],al
  db 0x00, 0x00                ; 0000514E  add [bx+si],al
  db 0x00, 0x00                ; 00005150  add [bx+si],al
  db 0x00, 0x00                ; 00005152  add [bx+si],al
  db 0x00, 0x00                ; 00005154  add [bx+si],al
  db 0x00, 0x00                ; 00005156  add [bx+si],al
  db 0x00, 0x00                ; 00005158  add [bx+si],al
  db 0x00, 0x00                ; 0000515A  add [bx+si],al
  db 0x00, 0x00                ; 0000515C  add [bx+si],al
  db 0x00, 0x00                ; 0000515E  add [bx+si],al
  db 0x00, 0x00                ; 00005160  add [bx+si],al
  db 0x00, 0x00                ; 00005162  add [bx+si],al
  db 0x00, 0x00                ; 00005164  add [bx+si],al
  db 0x00, 0x00                ; 00005166  add [bx+si],al
  db 0x00, 0x00                ; 00005168  add [bx+si],al
  db 0x00, 0x00                ; 0000516A  add [bx+si],al
  db 0x00, 0x00                ; 0000516C  add [bx+si],al
  db 0x00, 0x00                ; 0000516E  add [bx+si],al
  db 0x00, 0x00                ; 00005170  add [bx+si],al
  db 0x00, 0x00                ; 00005172  add [bx+si],al
  db 0x00, 0x00                ; 00005174  add [bx+si],al
  db 0x00, 0x00                ; 00005176  add [bx+si],al
  db 0x00, 0x00                ; 00005178  add [bx+si],al
  db 0x00, 0x00                ; 0000517A  add [bx+si],al
  db 0x00, 0x00                ; 0000517C  add [bx+si],al
  db 0x00, 0x00                ; 0000517E  add [bx+si],al
  db 0x00, 0x00                ; 00005180  add [bx+si],al
  db 0x00, 0x00                ; 00005182  add [bx+si],al
  db 0x00, 0x00                ; 00005184  add [bx+si],al
  db 0x00, 0x00                ; 00005186  add [bx+si],al
  db 0x00, 0x00                ; 00005188  add [bx+si],al
  db 0x00, 0x00                ; 0000518A  add [bx+si],al
  db 0x00, 0x00                ; 0000518C  add [bx+si],al
  db 0x00, 0x00                ; 0000518E  add [bx+si],al
  db 0x00, 0x00                ; 00005190  add [bx+si],al
  db 0x00, 0x00                ; 00005192  add [bx+si],al
  db 0x00, 0x00                ; 00005194  add [bx+si],al
  db 0x00, 0x00                ; 00005196  add [bx+si],al
  db 0x00, 0x00                ; 00005198  add [bx+si],al
  db 0x00, 0x00                ; 0000519A  add [bx+si],al
  db 0x00, 0x00                ; 0000519C  add [bx+si],al
  db 0x00, 0x00                ; 0000519E  add [bx+si],al
  db 0x00, 0x00                ; 000051A0  add [bx+si],al
  db 0x00, 0x00                ; 000051A2  add [bx+si],al
  db 0x00, 0x00                ; 000051A4  add [bx+si],al
  db 0x00, 0x00                ; 000051A6  add [bx+si],al
  db 0x00, 0x00                ; 000051A8  add [bx+si],al
  db 0x00, 0x00                ; 000051AA  add [bx+si],al
  db 0x00, 0x00                ; 000051AC  add [bx+si],al
  db 0x00, 0x00                ; 000051AE  add [bx+si],al
  db 0x00, 0x00                ; 000051B0  add [bx+si],al
  db 0x00, 0x00                ; 000051B2  add [bx+si],al
  db 0x00, 0x00                ; 000051B4  add [bx+si],al
  db 0x00, 0x00                ; 000051B6  add [bx+si],al
  db 0x00, 0x00                ; 000051B8  add [bx+si],al
  db 0x00, 0x00                ; 000051BA  add [bx+si],al
  db 0x00, 0x00                ; 000051BC  add [bx+si],al
  db 0x00, 0x00                ; 000051BE  add [bx+si],al
  db 0x00, 0x00                ; 000051C0  add [bx+si],al
  db 0x00, 0x00                ; 000051C2  add [bx+si],al
  db 0x00, 0x00                ; 000051C4  add [bx+si],al
  db 0x00, 0x00                ; 000051C6  add [bx+si],al
  db 0x00, 0x00                ; 000051C8  add [bx+si],al
  db 0x00, 0x00                ; 000051CA  add [bx+si],al
  db 0x00, 0x00                ; 000051CC  add [bx+si],al
  db 0x00, 0x00                ; 000051CE  add [bx+si],al
  db 0x00, 0x00                ; 000051D0  add [bx+si],al
  db 0x00, 0x00                ; 000051D2  add [bx+si],al
  db 0x00, 0x00                ; 000051D4  add [bx+si],al
  db 0x00, 0x00                ; 000051D6  add [bx+si],al
  db 0x00, 0x00                ; 000051D8  add [bx+si],al
  db 0x00, 0x00                ; 000051DA  add [bx+si],al
  db 0x00, 0x00                ; 000051DC  add [bx+si],al
  db 0x00, 0x00                ; 000051DE  add [bx+si],al
  db 0x00, 0x00                ; 000051E0  add [bx+si],al
  db 0x00, 0x9C, 0xFA, 0x2E    ; 000051E2  add [si+0x2efa],bl
  db 0xFE, 0x06, 0xE0, 0x51    ; 000051E6  inc byte [0x51e0]
  db 0x2E, 0x80, 0x3E, 0xE0, 0x51, 0x01 ; 000051EA  cmp byte [cs:0x51e0],0x1
  db 0x75, 0x15                ; 000051F0  jnz 0x5207
  db 0x2E, 0x89, 0x36, 0xE1, 0x51 ; 000051F2  mov [cs:0x51e1],si
  db 0xC6, 0x44, 0x0B, 0x3F    ; 000051F7  mov byte [si+0xb],0x3f
  db 0xC7, 0x44, 0x0E, 0x00, 0x00 ; 000051FB  mov word [si+0xe],0x0
  db 0xC7, 0x44, 0x0C, 0x00, 0x00 ; 00005200  mov word [si+0xc],0x0
  db 0xEB, 0x29                ; 00005205  jmp short 0x5230
  db 0x57                      ; 00005207  push di
  db 0x32, 0xC0                ; 00005208  xor al,al
  db 0x2E, 0x8B, 0x3E, 0xE1, 0x51 ; 0000520A  mov di,[cs:0x51e1]
  db 0x02, 0x45, 0x0B          ; 0000520F  add al,[di+0xb]
  db 0x83, 0x7D, 0x0C, 0x00    ; 00005212  cmp word [di+0xc],byte +0x0
  db 0x74, 0x05                ; 00005216  jz 0x521d
  db 0x8B, 0x7D, 0x0C          ; 00005218  mov di,[di+0xc]
  db 0xEB, 0xF2                ; 0000521B  jmp short 0x520f
  db 0xB4, 0x3F                ; 0000521D  mov ah,0x3f
  db 0x2A, 0xE0                ; 0000521F  sub ah,al
  db 0x88, 0x64, 0x0B          ; 00005221  mov [si+0xb],ah
  db 0x89, 0x7C, 0x0E          ; 00005224  mov [si+0xe],di
  db 0xC7, 0x44, 0x0C, 0x00, 0x00 ; 00005227  mov word [si+0xc],0x0
  db 0x89, 0x75, 0x0C          ; 0000522C  mov [di+0xc],si
  db 0x5F                      ; 0000522F  pop di
  db 0x9D                      ; 00005230  popf
  db 0xC3                      ; 00005231  ret
  db 0x9C                      ; 00005232  pushf
  db 0xFA                      ; 00005233  cli
  db 0x57                      ; 00005234  push di
  db 0x53                      ; 00005235  push bx
  db 0x2E, 0x80, 0x3E, 0xE0, 0x51, 0x00 ; 00005236  cmp byte [cs:0x51e0],0x0
  db 0x74, 0x44                ; 0000523C  jz 0x5282
  db 0x2E, 0xFE, 0x0E, 0xE0, 0x51 ; 0000523E  dec byte [cs:0x51e0]
  db 0x74, 0x3D                ; 00005243  jz 0x5282
  db 0x83, 0x7C, 0x0C, 0x00    ; 00005245  cmp word [si+0xc],byte +0x0
  db 0x75, 0x0A                ; 00005249  jnz 0x5255
  db 0x8B, 0x7C, 0x0E          ; 0000524B  mov di,[si+0xe]
  db 0xC7, 0x45, 0x0C, 0x00, 0x00 ; 0000524E  mov word [di+0xc],0x0
  db 0xEB, 0x2D                ; 00005253  jmp short 0x5282
  db 0x83, 0x7C, 0x0E, 0x00    ; 00005255  cmp word [si+0xe],byte +0x0
  db 0x74, 0x14                ; 00005259  jz 0x526f
  db 0x8A, 0x44, 0x0B          ; 0000525B  mov al,[si+0xb]
  db 0x8B, 0x7C, 0x0C          ; 0000525E  mov di,[si+0xc]
  db 0x00, 0x45, 0x0B          ; 00005261  add [di+0xb],al
  db 0x8B, 0x5C, 0x0E          ; 00005264  mov bx,[si+0xe]
  db 0x89, 0x5D, 0x0E          ; 00005267  mov [di+0xe],bx
  db 0x89, 0x7F, 0x0C          ; 0000526A  mov [bx+0xc],di
  db 0xEB, 0x13                ; 0000526D  jmp short 0x5282
  db 0x8B, 0x7C, 0x0C          ; 0000526F  mov di,[si+0xc]
  db 0x2E, 0x89, 0x3E, 0xE1, 0x51 ; 00005272  mov [cs:0x51e1],di
  db 0x8A, 0x44, 0x0B          ; 00005277  mov al,[si+0xb]
  db 0x00, 0x45, 0x0B          ; 0000527A  add [di+0xb],al
  db 0xC7, 0x45, 0x0E, 0x00, 0x00 ; 0000527D  mov word [di+0xe],0x0
  db 0x5B                      ; 00005282  pop bx
  db 0x5F                      ; 00005283  pop di
  db 0xC7, 0x44, 0x0C, 0x00, 0x00 ; 00005284  mov word [si+0xc],0x0
  db 0xC7, 0x44, 0x0E, 0x00, 0x00 ; 00005289  mov word [si+0xe],0x0
  db 0x9D                      ; 0000528E  popf
  db 0xC3                      ; 0000528F  ret
  db 0x9C                      ; 00005290  pushf
  db 0xFA                      ; 00005291  cli
  db 0x33, 0xC9                ; 00005292  xor cx,cx
  db 0x2E, 0x80, 0x3E, 0xE0, 0x51, 0x00 ; 00005294  cmp byte [cs:0x51e0],0x0
  db 0x74, 0x24                ; 0000529A  jz 0x52c0
  db 0x2E, 0x8B, 0x36, 0xE1, 0x51 ; 0000529C  mov si,[cs:0x51e1]
  db 0x56                      ; 000052A1  push si
  db 0x80, 0x7C, 0x0B, 0x00    ; 000052A2  cmp byte [si+0xb],0x0
  db 0x75, 0x0D                ; 000052A6  jnz 0x52b5
  db 0x41                      ; 000052A8  inc cx
  db 0x2E, 0xFE, 0x0E, 0xE0, 0x51 ; 000052A9  dec byte [cs:0x51e0]
  db 0x74, 0x05                ; 000052AE  jz 0x52b5
  db 0x8B, 0x74, 0x0C          ; 000052B0  mov si,[si+0xc]
  db 0xEB, 0xED                ; 000052B3  jmp short 0x52a2
  db 0x2E, 0x89, 0x36, 0xE1, 0x51 ; 000052B5  mov [cs:0x51e1],si
  db 0xC7, 0x44, 0x0E, 0x00, 0x00 ; 000052BA  mov word [si+0xe],0x0
  db 0x5E                      ; 000052BF  pop si
  db 0x9D                      ; 000052C0  popf
  db 0xC3                      ; 000052C1  ret
  db 0x00, 0x00                ; 000052C2  add [bx+si],al
  db 0x00, 0x9C, 0xFA, 0x2E    ; 000052C4  add [si+0x2efa],bl
  db 0xFE, 0x06, 0xC2, 0x52    ; 000052C8  inc byte [0x52c2]
  db 0x2E, 0x80, 0x3E, 0xC2, 0x52, 0x01 ; 000052CC  cmp byte [cs:0x52c2],0x1
  db 0x75, 0x16                ; 000052D2  jnz 0x52ea
  db 0x2E, 0x89, 0x36, 0xC3, 0x52 ; 000052D4  mov [cs:0x52c3],si
  db 0xC7, 0x44, 0x05, 0x68, 0x10 ; 000052D9  mov word [si+0x5],0x1068
  db 0xC7, 0x44, 0x09, 0x00, 0x00 ; 000052DE  mov word [si+0x9],0x0
  db 0xC7, 0x44, 0x07, 0x00, 0x00 ; 000052E3  mov word [si+0x7],0x0
  db 0xEB, 0x2A                ; 000052E8  jmp short 0x5314
  db 0x57                      ; 000052EA  push di
  db 0x33, 0xC0                ; 000052EB  xor ax,ax
  db 0x2E, 0x8B, 0x3E, 0xC3, 0x52 ; 000052ED  mov di,[cs:0x52c3]
  db 0x03, 0x45, 0x05          ; 000052F2  add ax,[di+0x5]
  db 0x83, 0x7D, 0x07, 0x00    ; 000052F5  cmp word [di+0x7],byte +0x0
  db 0x74, 0x05                ; 000052F9  jz 0x5300
  db 0x8B, 0x7D, 0x07          ; 000052FB  mov di,[di+0x7]
  db 0xEB, 0xF2                ; 000052FE  jmp short 0x52f2
  db 0xBA, 0x68, 0x10          ; 00005300  mov dx,0x1068
  db 0x2B, 0xD0                ; 00005303  sub dx,ax
  db 0x89, 0x54, 0x05          ; 00005305  mov [si+0x5],dx
  db 0x89, 0x7C, 0x09          ; 00005308  mov [si+0x9],di
  db 0xC7, 0x44, 0x07, 0x00, 0x00 ; 0000530B  mov word [si+0x7],0x0
  db 0x89, 0x75, 0x07          ; 00005310  mov [di+0x7],si
  db 0x5F                      ; 00005313  pop di
  db 0x9D                      ; 00005314  popf
  db 0xC3                      ; 00005315  ret
  db 0x9C                      ; 00005316  pushf
  db 0xFA                      ; 00005317  cli
  db 0x57                      ; 00005318  push di
  db 0x2E, 0x80, 0x3E, 0xC2, 0x52, 0x00 ; 00005319  cmp byte [cs:0x52c2],0x0
  db 0x74, 0x44                ; 0000531F  jz 0x5365
  db 0x2E, 0xFE, 0x0E, 0xC2, 0x52 ; 00005321  dec byte [cs:0x52c2]
  db 0x74, 0x3D                ; 00005326  jz 0x5365
  db 0x83, 0x7C, 0x07, 0x00    ; 00005328  cmp word [si+0x7],byte +0x0
  db 0x75, 0x0A                ; 0000532C  jnz 0x5338
  db 0x8B, 0x7C, 0x09          ; 0000532E  mov di,[si+0x9]
  db 0xC7, 0x45, 0x07, 0x00, 0x00 ; 00005331  mov word [di+0x7],0x0
  db 0xEB, 0x2D                ; 00005336  jmp short 0x5365
  db 0x83, 0x7C, 0x09, 0x00    ; 00005338  cmp word [si+0x9],byte +0x0
  db 0x74, 0x14                ; 0000533C  jz 0x5352
  db 0x8B, 0x44, 0x05          ; 0000533E  mov ax,[si+0x5]
  db 0x8B, 0x7C, 0x07          ; 00005341  mov di,[si+0x7]
  db 0x01, 0x45, 0x05          ; 00005344  add [di+0x5],ax
  db 0x8B, 0x5C, 0x09          ; 00005347  mov bx,[si+0x9]
  db 0x89, 0x5D, 0x09          ; 0000534A  mov [di+0x9],bx
  db 0x89, 0x7F, 0x07          ; 0000534D  mov [bx+0x7],di
  db 0xEB, 0x13                ; 00005350  jmp short 0x5365
  db 0x8B, 0x7C, 0x07          ; 00005352  mov di,[si+0x7]
  db 0x2E, 0x89, 0x3E, 0xC3, 0x52 ; 00005355  mov [cs:0x52c3],di
  db 0x8B, 0x44, 0x05          ; 0000535A  mov ax,[si+0x5]
  db 0x01, 0x45, 0x05          ; 0000535D  add [di+0x5],ax
  db 0xC7, 0x45, 0x09, 0x00, 0x00 ; 00005360  mov word [di+0x9],0x0
  db 0x5F                      ; 00005365  pop di
  db 0xC7, 0x44, 0x07, 0x00, 0x00 ; 00005366  mov word [si+0x7],0x0
  db 0xC7, 0x44, 0x09, 0x00, 0x00 ; 0000536B  mov word [si+0x9],0x0
  db 0x9D                      ; 00005370  popf
  db 0xC3                      ; 00005371  ret
  db 0x9C                      ; 00005372  pushf
  db 0xFA                      ; 00005373  cli
  db 0x33, 0xC9                ; 00005374  xor cx,cx
  db 0x2E, 0x80, 0x3E, 0xC2, 0x52, 0x00 ; 00005376  cmp byte [cs:0x52c2],0x0
  db 0x74, 0x24                ; 0000537C  jz 0x53a2
  db 0x2E, 0x8B, 0x36, 0xC3, 0x52 ; 0000537E  mov si,[cs:0x52c3]
  db 0x56                      ; 00005383  push si
  db 0x83, 0x7C, 0x05, 0x00    ; 00005384  cmp word [si+0x5],byte +0x0
  db 0x75, 0x0D                ; 00005388  jnz 0x5397
  db 0x41                      ; 0000538A  inc cx
  db 0x2E, 0xFE, 0x0E, 0xC2, 0x52 ; 0000538B  dec byte [cs:0x52c2]
  db 0x74, 0x05                ; 00005390  jz 0x5397
  db 0x8B, 0x74, 0x07          ; 00005392  mov si,[si+0x7]
  db 0xEB, 0xED                ; 00005395  jmp short 0x5384
  db 0x2E, 0x89, 0x36, 0xC3, 0x52 ; 00005397  mov [cs:0x52c3],si
  db 0xC7, 0x44, 0x09, 0x00, 0x00 ; 0000539C  mov word [si+0x9],0x0
  db 0x5E                      ; 000053A1  pop si
  db 0x9D                      ; 000053A2  popf
  db 0xC3                      ; 000053A3  ret
  db 0xFF, 0x8C, 0xC8, 0x8E    ; 000053A4  dec word [si-0x7138]
  db 0xD8, 0x2E, 0x80, 0x3E    ; 000053A8  fsubr dword [0x3e80]
  db 0xE0, 0x51                ; 000053AC  loopne 0x53ff
  db 0x00, 0x74, 0x16          ; 000053AE  add [si+0x16],dh
  db 0x2E, 0x8B, 0x1E, 0xE1, 0x51 ; 000053B1  mov bx,[cs:0x51e1]
  db 0x80, 0x7F, 0x0B, 0x00    ; 000053B6  cmp byte [bx+0xb],0x0
  db 0x74, 0x0B                ; 000053BA  jz 0x53c7
  db 0xFE, 0x4F, 0x0B          ; 000053BC  dec byte [bx+0xb]
  db 0x75, 0x06                ; 000053BF  jnz 0x53c7
  db 0x2E, 0x80, 0x0E, 0xB7, 0x56, 0x01 ; 000053C1  or byte [cs:0x56b7],0x1
  db 0x2E, 0x80, 0x3E, 0xC2, 0x52, 0x00 ; 000053C7  cmp byte [cs:0x52c2],0x0
  db 0x74, 0x16                ; 000053CD  jz 0x53e5
  db 0x2E, 0x8B, 0x1E, 0xC3, 0x52 ; 000053CF  mov bx,[cs:0x52c3]
  db 0x83, 0x7F, 0x05, 0x00    ; 000053D4  cmp word [bx+0x5],byte +0x0
  db 0x74, 0x0B                ; 000053D8  jz 0x53e5
  db 0xFF, 0x4F, 0x05          ; 000053DA  dec word [bx+0x5]
  db 0x75, 0x06                ; 000053DD  jnz 0x53e5
  db 0x2E, 0x80, 0x0E, 0xB7, 0x56, 0x02 ; 000053DF  or byte [cs:0x56b7],0x2
  db 0x2E, 0x83, 0x3E, 0x98, 0x32, 0x00 ; 000053E5  cmp word [cs:0x3298],byte +0x0
  db 0x74, 0x0D                ; 000053EB  jz 0x53fa
  db 0x2E, 0xFF, 0x0E, 0x98, 0x32 ; 000053ED  dec word [cs:0x3298]
  db 0x75, 0x06                ; 000053F2  jnz 0x53fa
  db 0x2E, 0x80, 0x0E, 0xB7, 0x56, 0x04 ; 000053F4  or byte [cs:0x56b7],0x4
  db 0x2E, 0x83, 0x3E, 0x00, 0x33, 0x00 ; 000053FA  cmp word [cs:0x3300],byte +0x0
  db 0x74, 0x0D                ; 00005400  jz 0x540f
  db 0x2E, 0xFF, 0x0E, 0x00, 0x33 ; 00005402  dec word [cs:0x3300]
  db 0x75, 0x06                ; 00005407  jnz 0x540f
  db 0x2E, 0x80, 0x0E, 0xB7, 0x56, 0x08 ; 00005409  or byte [cs:0x56b7],0x8
  db 0x2E, 0x80, 0x3E, 0xA4, 0x53, 0x00 ; 0000540F  cmp byte [cs:0x53a4],0x0
  db 0x74, 0x0E                ; 00005415  jz 0x5425
  db 0x2E, 0x80, 0x3E, 0xB7, 0x56, 0x00 ; 00005417  cmp byte [cs:0x56b7],0x0
  db 0x74, 0x06                ; 0000541D  jz 0x5425
  db 0xBA, 0x17, 0x00          ; 0000541F  mov dx,0x17
  db 0xE8, 0x19, 0x04          ; 00005422  call 0x583e
  db 0xCB                      ; 00005425  retf
  db 0x50                      ; 00005426  push ax
  db 0x2E, 0x8C, 0x16, 0x31, 0x56 ; 00005427  mov [cs:0x5631],ss
  db 0x2E, 0x89, 0x26, 0x33, 0x56 ; 0000542C  mov [cs:0x5633],sp
  db 0xBC, 0xB5, 0x56          ; 00005431  mov sp,0x56b5
  db 0x8C, 0xC8                ; 00005434  mov ax,cs
  db 0x8E, 0xD0                ; 00005436  mov ss,ax
  db 0x60                      ; 00005438  pusha
  db 0x1E                      ; 00005439  push ds
  db 0x8E, 0xD8                ; 0000543A  mov ds,ax
  db 0x2E, 0x83, 0x3E, 0x76, 0x33, 0x00 ; 0000543C  cmp word [cs:0x3376],byte +0x0
  db 0x75, 0xF8                ; 00005442  jnz 0x543c
  db 0x2E, 0xA1, 0x74, 0x33    ; 00005444  mov ax,[cs:0x3374]
  db 0x25, 0x00, 0xF0          ; 00005448  and ax,0xf000
  db 0x2E, 0xA3, 0x76, 0x33    ; 0000544B  mov [cs:0x3376],ax
  db 0x2E, 0xF7, 0x06, 0x76, 0x33, 0x00, 0xA0 ; 0000544F  test word [cs:0x3376],0xa000
  db 0x74, 0x06                ; 00005456  jz 0x545e
  db 0xBA, 0x16, 0x00          ; 00005458  mov dx,0x16
  db 0xE8, 0xE0, 0x03          ; 0000545B  call 0x583e
  db 0x2E, 0xF7, 0x06, 0x76, 0x33, 0x00, 0x50 ; 0000545E  test word [cs:0x3376],0x5000
  db 0x75, 0x0A                ; 00005465  jnz 0x5471
  db 0x2E, 0x81, 0x0E, 0x76, 0x33, 0x00, 0x00 ; 00005467  or word [cs:0x3376],0x0
  db 0xE9, 0xF5, 0x00          ; 0000546E  jmp 0x5566
  db 0x2E, 0x8B, 0x1E, 0x7A, 0x33 ; 00005471  mov bx,[cs:0x337a]
  db 0x83, 0xFB, 0x00          ; 00005476  cmp bx,byte +0x0
  db 0x74, 0x78                ; 00005479  jz 0x54f3
  db 0xF7, 0x07, 0x00, 0x40    ; 0000547B  test word [bx],0x4000
  db 0x75, 0x61                ; 0000547F  jnz 0x54e2
  db 0x81, 0x3F, 0x00, 0xA0    ; 00005481  cmp word [bx],0xa000
  db 0x75, 0x37                ; 00005485  jnz 0x54be
  db 0x2E, 0xFF, 0x06, 0x2E, 0x15 ; 00005487  inc word [cs:0x152e]
  db 0x2E, 0x83, 0x3E, 0x30, 0x15, 0x00 ; 0000548C  cmp word [cs:0x1530],byte +0x0
  db 0x75, 0x0C                ; 00005492  jnz 0x54a0
  db 0x2E, 0x89, 0x1E, 0x30, 0x15 ; 00005494  mov [cs:0x1530],bx
  db 0x2E, 0x89, 0x1E, 0x32, 0x15 ; 00005499  mov [cs:0x1532],bx
  db 0xEB, 0x0D                ; 0000549E  jmp short 0x54ad
  db 0x2E, 0x8B, 0x36, 0x32, 0x15 ; 000054A0  mov si,[cs:0x1532]
  db 0x89, 0x5C, 0x04          ; 000054A5  mov [si+0x4],bx
  db 0x2E, 0x89, 0x1E, 0x32, 0x15 ; 000054A8  mov [cs:0x1532],bx
  db 0xF7, 0x47, 0x02, 0x00, 0x80 ; 000054AD  test word [bx+0x2],0x8000
  db 0x74, 0x05                ; 000054B2  jz 0x54b9
  db 0xBB, 0x00, 0x00          ; 000054B4  mov bx,0x0
  db 0xEB, 0x29                ; 000054B7  jmp short 0x54e2
  db 0x8B, 0x5F, 0x04          ; 000054B9  mov bx,[bx+0x4]
  db 0xEB, 0xBD                ; 000054BC  jmp short 0x547b
  db 0x2E, 0xFF, 0x06, 0x3F, 0x15 ; 000054BE  inc word [cs:0x153f]
  db 0x8B, 0x77, 0x04          ; 000054C3  mov si,[bx+0x4]
  db 0x8B, 0x47, 0x02          ; 000054C6  mov ax,[bx+0x2]
  db 0x1E                      ; 000054C9  push ds
  db 0x53                      ; 000054CA  push bx
  db 0xC7, 0x07, 0xFF, 0x00    ; 000054CB  mov word [bx],0xff
  db 0xCD, 0x29                ; 000054CF  int 0x29
  db 0x83, 0xC4, 0x04          ; 000054D1  add sp,byte +0x4
  db 0xA9, 0x00, 0x80          ; 000054D4  test ax,0x8000
  db 0x74, 0x05                ; 000054D7  jz 0x54de
  db 0xBB, 0x00, 0x00          ; 000054D9  mov bx,0x0
  db 0xEB, 0x04                ; 000054DC  jmp short 0x54e2
  db 0x8B, 0xDE                ; 000054DE  mov bx,si
  db 0xEB, 0x99                ; 000054E0  jmp short 0x547b
  db 0x2E, 0x89, 0x1E, 0x7A, 0x33 ; 000054E2  mov [cs:0x337a],bx
  db 0xBA, 0x17, 0x00          ; 000054E7  mov dx,0x17
  db 0xE8, 0x51, 0x03          ; 000054EA  call 0x583e
  db 0x2E, 0xC6, 0x06, 0xB8, 0x56, 0xFF ; 000054ED  mov byte [cs:0x56b8],0xff
  db 0x2E, 0xF7, 0x06, 0x76, 0x33, 0x00, 0x10 ; 000054F3  test word [cs:0x3376],0x1000
  db 0x75, 0x0A                ; 000054FA  jnz 0x5506
  db 0x2E, 0x81, 0x0E, 0x76, 0x33, 0x00, 0x00 ; 000054FC  or word [cs:0x3376],0x0
  db 0xE9, 0x60, 0x00          ; 00005503  jmp 0x5566
  db 0x2E, 0x80, 0x3E, 0x35, 0x15, 0x00 ; 00005506  cmp byte [cs:0x1535],0x0
  db 0x74, 0x4B                ; 0000550C  jz 0x5559
  db 0x2E, 0x80, 0x3E, 0x3A, 0x15, 0x00 ; 0000550E  cmp byte [cs:0x153a],0x0
  db 0x74, 0x43                ; 00005514  jz 0x5559
  db 0x2E, 0x81, 0x0E, 0x76, 0x33, 0x10, 0x00 ; 00005516  or word [cs:0x3376],0x10
  db 0x2E, 0x8B, 0x36, 0x36, 0x15 ; 0000551D  mov si,[cs:0x1536]
  db 0x2E, 0x8B, 0x3E, 0x3B, 0x15 ; 00005522  mov di,[cs:0x153b]
  db 0x89, 0x7C, 0x06          ; 00005527  mov [si+0x6],di
  db 0x2E, 0x89, 0x36, 0x7A, 0x33 ; 0000552A  mov [cs:0x337a],si
  db 0x2E, 0xC6, 0x06, 0x35, 0x15, 0x00 ; 0000552F  mov byte [cs:0x1535],0x0
  db 0x2E, 0xC7, 0x06, 0x36, 0x15, 0x00, 0x00 ; 00005535  mov word [cs:0x1536],0x0
  db 0x2E, 0xC7, 0x06, 0x38, 0x15, 0x00, 0x00 ; 0000553C  mov word [cs:0x1538],0x0
  db 0x2E, 0xC6, 0x06, 0x3A, 0x15, 0x00 ; 00005543  mov byte [cs:0x153a],0x0
  db 0x2E, 0xC7, 0x06, 0x3B, 0x15, 0x00, 0x00 ; 00005549  mov word [cs:0x153b],0x0
  db 0x2E, 0xC7, 0x06, 0x3D, 0x15, 0x00, 0x00 ; 00005550  mov word [cs:0x153d],0x0
  db 0xEB, 0x0D                ; 00005557  jmp short 0x5566
  db 0x2E, 0x81, 0x0E, 0x76, 0x33, 0x00, 0x00 ; 00005559  or word [cs:0x3376],0x0
  db 0x2E, 0xC6, 0x06, 0x34, 0x15, 0xFF ; 00005560  mov byte [cs:0x1534],0xff
  db 0xBA, 0x00, 0x01          ; 00005566  mov dx,0x100
  db 0xEC                      ; 00005569  in al,dx
  db 0xB0, 0x20                ; 0000556A  mov al,0x20
  db 0xE6, 0x00                ; 0000556C  out 0x0,al
  db 0xBA, 0x22, 0xFF          ; 0000556E  mov dx,0xff22
  db 0xB8, 0x00, 0x80          ; 00005571  mov ax,0x8000
  db 0xEF                      ; 00005574  out dx,ax
  db 0x1F                      ; 00005575  pop ds
  db 0x61                      ; 00005576  popa
  db 0x2E, 0x8B, 0x26, 0x33, 0x56 ; 00005577  mov sp,[cs:0x5633]
  db 0x2E, 0x8E, 0x16, 0x31, 0x56 ; 0000557C  mov ss,[cs:0x5631]
  db 0x58                      ; 00005581  pop ax
  db 0x2E, 0xFF, 0x2E, 0x2B, 0x56 ; 00005582  jmp far [cs:0x562b]
  db 0xFA                      ; 00005587  cli
  db 0x60                      ; 00005588  pusha
  db 0x8B, 0xEC                ; 00005589  mov bp,sp
  db 0x1E                      ; 0000558B  push ds
  db 0xC5, 0x5E, 0x16          ; 0000558C  lds bx,[bp+0x16]
  db 0x80, 0x3F, 0x00          ; 0000558F  cmp byte [bx],0x0
  db 0x75, 0x03                ; 00005592  jnz 0x5597
  db 0xE9, 0x8B, 0x00          ; 00005594  jmp 0x5622
  db 0x8B, 0x7F, 0x06          ; 00005597  mov di,[bx+0x6]
  db 0x83, 0xFF, 0xFF          ; 0000559A  cmp di,byte -0x1
  db 0x74, 0x4A                ; 0000559D  jz 0x55e9
  db 0x2E, 0x80, 0x3E, 0x3A, 0x15, 0x00 ; 0000559F  cmp byte [cs:0x153a],0x0
  db 0x75, 0x07                ; 000055A5  jnz 0x55ae
  db 0x2E, 0x89, 0x3E, 0x3B, 0x15 ; 000055A7  mov [cs:0x153b],di
  db 0xEB, 0x0D                ; 000055AC  jmp short 0x55bb
  db 0x2E, 0x8B, 0x36, 0x3D, 0x15 ; 000055AE  mov si,[cs:0x153d]
  db 0x81, 0x64, 0x08, 0xFF, 0x7F ; 000055B3  and word [si+0x8],0x7fff
  db 0x89, 0x7C, 0x02          ; 000055B8  mov [si+0x2],di
  db 0x2E, 0xFE, 0x06, 0x3A, 0x15 ; 000055BB  inc byte [cs:0x153a]
  db 0xF7, 0x45, 0x08, 0x00, 0x80 ; 000055C0  test word [di+0x8],0x8000
  db 0x75, 0x14                ; 000055C5  jnz 0x55db
  db 0xF7, 0x05, 0x00, 0x80    ; 000055C7  test word [di],0x8000
  db 0x75, 0x0E                ; 000055CB  jnz 0x55db
  db 0x2E, 0xFE, 0x06, 0x3A, 0x15 ; 000055CD  inc byte [cs:0x153a]
  db 0xC7, 0x05, 0x00, 0x00    ; 000055D2  mov word [di],0x0
  db 0x8B, 0x7D, 0x02          ; 000055D6  mov di,[di+0x2]
  db 0xEB, 0xE5                ; 000055D9  jmp short 0x55c0
  db 0xC7, 0x05, 0x00, 0x00    ; 000055DB  mov word [di],0x0
  db 0x81, 0x4D, 0x08, 0x00, 0x80 ; 000055DF  or word [di+0x8],0x8000
  db 0x2E, 0x89, 0x3E, 0x3D, 0x15 ; 000055E4  mov [cs:0x153d],di
  db 0x2E, 0xFE, 0x06, 0x35, 0x15 ; 000055E9  inc byte [cs:0x1535]
  db 0xC7, 0x07, 0x00, 0x00    ; 000055EE  mov word [bx],0x0
  db 0xC7, 0x47, 0x02, 0x00, 0x80 ; 000055F2  mov word [bx+0x2],0x8000
  db 0xC7, 0x47, 0x06, 0xFF, 0xFF ; 000055F7  mov word [bx+0x6],0xffff
  db 0x2E, 0x80, 0x3E, 0x35, 0x15, 0x01 ; 000055FC  cmp byte [cs:0x1535],0x1
  db 0x75, 0x0C                ; 00005602  jnz 0x5610
  db 0x2E, 0x89, 0x1E, 0x36, 0x15 ; 00005604  mov [cs:0x1536],bx
  db 0x2E, 0x89, 0x1E, 0x38, 0x15 ; 00005609  mov [cs:0x1538],bx
  db 0xEB, 0x12                ; 0000560E  jmp short 0x5622
  db 0x2E, 0x8B, 0x36, 0x38, 0x15 ; 00005610  mov si,[cs:0x1538]
  db 0xC7, 0x44, 0x02, 0x00, 0x00 ; 00005615  mov word [si+0x2],0x0
  db 0x89, 0x5C, 0x04          ; 0000561A  mov [si+0x4],bx
  db 0x2E, 0x89, 0x1E, 0x38, 0x15 ; 0000561D  mov [cs:0x1538],bx
  db 0x1F                      ; 00005622  pop ds
  db 0x61                      ; 00005623  popa
  db 0xCF                      ; 00005624  iret
  db 0x00, 0x00                ; 00005625  add [bx+si],al
  db 0x00, 0x00                ; 00005627  add [bx+si],al
  db 0x00, 0x00                ; 00005629  add [bx+si],al
  db 0x00, 0x00                ; 0000562B  add [bx+si],al
  db 0x00, 0x00                ; 0000562D  add [bx+si],al
  db 0x00, 0x00                ; 0000562F  add [bx+si],al
  db 0x00, 0x00                ; 00005631  add [bx+si],al
  db 0x00, 0x00                ; 00005633  add [bx+si],al
  db 0xCC                      ; 00005635  int3
  db 0xCC                      ; 00005636  int3
  db 0xCC                      ; 00005637  int3
  db 0xCC                      ; 00005638  int3
  db 0xCC                      ; 00005639  int3
  db 0xCC                      ; 0000563A  int3
  db 0xCC                      ; 0000563B  int3
  db 0xCC                      ; 0000563C  int3
  db 0xCC                      ; 0000563D  int3
  db 0xCC                      ; 0000563E  int3
  db 0xCC                      ; 0000563F  int3
  db 0xCC                      ; 00005640  int3
  db 0xCC                      ; 00005641  int3
  db 0xCC                      ; 00005642  int3
  db 0xCC                      ; 00005643  int3
  db 0xCC                      ; 00005644  int3
  db 0xCC                      ; 00005645  int3
  db 0xCC                      ; 00005646  int3
  db 0xCC                      ; 00005647  int3
  db 0xCC                      ; 00005648  int3
  db 0xCC                      ; 00005649  int3
  db 0xCC                      ; 0000564A  int3
  db 0xCC                      ; 0000564B  int3
  db 0xCC                      ; 0000564C  int3
  db 0xCC                      ; 0000564D  int3
  db 0xCC                      ; 0000564E  int3
  db 0xCC                      ; 0000564F  int3
  db 0xCC                      ; 00005650  int3
  db 0xCC                      ; 00005651  int3
  db 0xCC                      ; 00005652  int3
  db 0xCC                      ; 00005653  int3
  db 0xCC                      ; 00005654  int3
  db 0xCC                      ; 00005655  int3
  db 0xCC                      ; 00005656  int3
  db 0xCC                      ; 00005657  int3
  db 0xCC                      ; 00005658  int3
  db 0xCC                      ; 00005659  int3
  db 0xCC                      ; 0000565A  int3
  db 0xCC                      ; 0000565B  int3
  db 0xCC                      ; 0000565C  int3
  db 0xCC                      ; 0000565D  int3
  db 0xCC                      ; 0000565E  int3
  db 0xCC                      ; 0000565F  int3
  db 0xCC                      ; 00005660  int3
  db 0xCC                      ; 00005661  int3
  db 0xCC                      ; 00005662  int3
  db 0xCC                      ; 00005663  int3
  db 0xCC                      ; 00005664  int3
  db 0xCC                      ; 00005665  int3
  db 0xCC                      ; 00005666  int3
  db 0xCC                      ; 00005667  int3
  db 0xCC                      ; 00005668  int3
  db 0xCC                      ; 00005669  int3
  db 0xCC                      ; 0000566A  int3
  db 0xCC                      ; 0000566B  int3
  db 0xCC                      ; 0000566C  int3
  db 0xCC                      ; 0000566D  int3
  db 0xCC                      ; 0000566E  int3
  db 0xCC                      ; 0000566F  int3
  db 0xCC                      ; 00005670  int3
  db 0xCC                      ; 00005671  int3
  db 0xCC                      ; 00005672  int3
  db 0xCC                      ; 00005673  int3
  db 0xCC                      ; 00005674  int3
  db 0xCC                      ; 00005675  int3
  db 0xCC                      ; 00005676  int3
  db 0xCC                      ; 00005677  int3
  db 0xCC                      ; 00005678  int3
  db 0xCC                      ; 00005679  int3
  db 0xCC                      ; 0000567A  int3
  db 0xCC                      ; 0000567B  int3
  db 0xCC                      ; 0000567C  int3
  db 0xCC                      ; 0000567D  int3
  db 0xCC                      ; 0000567E  int3
  db 0xCC                      ; 0000567F  int3
  db 0xCC                      ; 00005680  int3
  db 0xCC                      ; 00005681  int3
  db 0xCC                      ; 00005682  int3
  db 0xCC                      ; 00005683  int3
  db 0xCC                      ; 00005684  int3
  db 0xCC                      ; 00005685  int3
  db 0xCC                      ; 00005686  int3
  db 0xCC                      ; 00005687  int3
  db 0xCC                      ; 00005688  int3
  db 0xCC                      ; 00005689  int3
  db 0xCC                      ; 0000568A  int3
  db 0xCC                      ; 0000568B  int3
  db 0xCC                      ; 0000568C  int3
  db 0xCC                      ; 0000568D  int3
  db 0xCC                      ; 0000568E  int3
  db 0xCC                      ; 0000568F  int3
  db 0xCC                      ; 00005690  int3
  db 0xCC                      ; 00005691  int3
  db 0xCC                      ; 00005692  int3
  db 0xCC                      ; 00005693  int3
  db 0xCC                      ; 00005694  int3
  db 0xCC                      ; 00005695  int3
  db 0xCC                      ; 00005696  int3
  db 0xCC                      ; 00005697  int3
  db 0xCC                      ; 00005698  int3
  db 0xCC                      ; 00005699  int3
  db 0xCC                      ; 0000569A  int3
  db 0xCC                      ; 0000569B  int3
  db 0xCC                      ; 0000569C  int3
  db 0xCC                      ; 0000569D  int3
  db 0xCC                      ; 0000569E  int3
  db 0xCC                      ; 0000569F  int3
  db 0xCC                      ; 000056A0  int3
  db 0xCC                      ; 000056A1  int3
  db 0xCC                      ; 000056A2  int3
  db 0xCC                      ; 000056A3  int3
  db 0xCC                      ; 000056A4  int3
  db 0xCC                      ; 000056A5  int3
  db 0xCC                      ; 000056A6  int3
  db 0xCC                      ; 000056A7  int3
  db 0xCC                      ; 000056A8  int3
  db 0xCC                      ; 000056A9  int3
  db 0xCC                      ; 000056AA  int3
  db 0xCC                      ; 000056AB  int3
  db 0xCC                      ; 000056AC  int3
  db 0xCC                      ; 000056AD  int3
  db 0xCC                      ; 000056AE  int3
  db 0xCC                      ; 000056AF  int3
  db 0xCC                      ; 000056B0  int3
  db 0xCC                      ; 000056B1  int3
  db 0xCC                      ; 000056B2  int3
  db 0xCC                      ; 000056B3  int3
  db 0xCC                      ; 000056B4  int3
  db 0xCC                      ; 000056B5  int3
  db 0xCC                      ; 000056B6  int3
  db 0x00, 0x00                ; 000056B7  add [bx+si],al
  db 0x2E, 0x3A, 0x06, 0x91, 0x32 ; 000056B9  cmp al,[cs:0x3291]
  db 0x75, 0x05                ; 000056BE  jnz 0x56c5
  db 0xBE, 0x91, 0x32          ; 000056C0  mov si,0x3291
  db 0xF8                      ; 000056C3  clc
  db 0xC3                      ; 000056C4  ret
  db 0x2E, 0x3A, 0x06, 0xF9, 0x32 ; 000056C5  cmp al,[cs:0x32f9]
  db 0x75, 0x05                ; 000056CA  jnz 0x56d1
  db 0xBE, 0xF9, 0x32          ; 000056CC  mov si,0x32f9
  db 0xF8                      ; 000056CF  clc
  db 0xC3                      ; 000056D0  ret
  db 0xF9                      ; 000056D1  stc
  db 0xC3                      ; 000056D2  ret
  db 0x57                      ; 000056D3  push di
  db 0xBF, 0x45, 0x15          ; 000056D4  mov di,0x1545
  db 0x32, 0xE4                ; 000056D7  xor ah,ah
  db 0xB9, 0x4B, 0x00          ; 000056D9  mov cx,0x4b
  db 0xF7, 0xE1                ; 000056DC  mul cx
  db 0x03, 0xF8                ; 000056DE  add di,ax
  db 0x39, 0x75, 0x07          ; 000056E0  cmp [di+0x7],si
  db 0x75, 0x08                ; 000056E3  jnz 0x56ed
  db 0x8B, 0xF7                ; 000056E5  mov si,di
  db 0x83, 0xC6, 0x07          ; 000056E7  add si,byte +0x7
  db 0xF8                      ; 000056EA  clc
  db 0xEB, 0x0E                ; 000056EB  jmp short 0x56fb
  db 0x39, 0x75, 0x29          ; 000056ED  cmp [di+0x29],si
  db 0x75, 0x08                ; 000056F0  jnz 0x56fa
  db 0x8B, 0xF7                ; 000056F2  mov si,di
  db 0x83, 0xC6, 0x29          ; 000056F4  add si,byte +0x29
  db 0xF8                      ; 000056F7  clc
  db 0xEB, 0x01                ; 000056F8  jmp short 0x56fb
  db 0xF9                      ; 000056FA  stc
  db 0x5F                      ; 000056FB  pop di
  db 0xC3                      ; 000056FC  ret
  db 0x8A, 0x44, 0x06          ; 000056FD  mov al,[si+0x6]
  db 0x3C, 0xFE                ; 00005700  cmp al,0xfe
  db 0x74, 0x03                ; 00005702  jz 0x5707
  db 0xFE, 0x44, 0x06          ; 00005704  inc byte [si+0x6]
  db 0x88, 0x44, 0x10          ; 00005707  mov [si+0x10],al
  db 0x2E, 0x8E, 0x06, 0x2F, 0x56 ; 0000570A  mov es,[cs:0x562f]
  db 0xB0, 0x05                ; 0000570F  mov al,0x5
  db 0xAA                      ; 00005711  stosb
  db 0x8A, 0x04                ; 00005712  mov al,[si]
  db 0x56                      ; 00005714  push si
  db 0xBE, 0x61, 0x33          ; 00005715  mov si,0x3361
  db 0x3C, 0x08                ; 00005718  cmp al,0x8
  db 0x74, 0x0C                ; 0000571A  jz 0x5728
  db 0x3C, 0x04                ; 0000571C  cmp al,0x4
  db 0x75, 0x05                ; 0000571E  jnz 0x5725
  db 0xBE, 0x67, 0x33          ; 00005720  mov si,0x3367
  db 0xEB, 0x03                ; 00005723  jmp short 0x5728
  db 0xBE, 0x6D, 0x33          ; 00005725  mov si,0x336d
  db 0xB9, 0x03, 0x00          ; 00005728  mov cx,0x3
  db 0xF3, 0xA5                ; 0000572B  rep movsw
  db 0x5E                      ; 0000572D  pop si
  db 0x8B, 0x44, 0x09          ; 0000572E  mov ax,[si+0x9]
  db 0xAB                      ; 00005731  stosw
  db 0x8B, 0xC6                ; 00005732  mov ax,si
  db 0x05, 0x0B, 0x00          ; 00005734  add ax,0xb
  db 0xAB                      ; 00005737  stosw
  db 0x8C, 0xD8                ; 00005738  mov ax,ds
  db 0xAB                      ; 0000573A  stosw
  db 0x56                      ; 0000573B  push si
  db 0x53                      ; 0000573C  push bx
  db 0xB1, 0x8B                ; 0000573D  mov cl,0x8b
  db 0xCD, 0xE0                ; 0000573F  int 0xe0
  db 0x5B                      ; 00005741  pop bx
  db 0x5E                      ; 00005742  pop si
  db 0xC7, 0x44, 0x07, 0xE8, 0x03 ; 00005743  mov word [si+0x7],0x3e8
  db 0xC3                      ; 00005748  ret
  db 0x2E, 0x8E, 0x06, 0x2F, 0x56 ; 00005749  mov es,[cs:0x562f]
  db 0xB0, 0x00                ; 0000574E  mov al,0x0
  db 0xAA                      ; 00005750  stosb
  db 0x8B, 0xC6                ; 00005751  mov ax,si
  db 0xAB                      ; 00005753  stosw
  db 0x8A, 0x44, 0x11          ; 00005754  mov al,[si+0x11]
  db 0xAA                      ; 00005757  stosb
  db 0xC6, 0x44, 0x21, 0x01    ; 00005758  mov byte [si+0x21],0x1
  db 0x56                      ; 0000575C  push si
  db 0xB1, 0x8B                ; 0000575D  mov cl,0x8b
  db 0xCD, 0xE0                ; 0000575F  int 0xe0
  db 0x5E                      ; 00005761  pop si
  db 0xC3                      ; 00005762  ret
  db 0xC4, 0x7C, 0x15          ; 00005763  les di,[si+0x15]
  db 0x8B, 0x1C                ; 00005766  mov bx,[si]
  db 0x8A, 0x47, 0x06          ; 00005768  mov al,[bx+0x6]
  db 0x26, 0x88, 0x45, 0x05    ; 0000576B  mov [es:di+0x5],al
  db 0xBF, 0x1F, 0x15          ; 0000576F  mov di,0x151f
  db 0x2E, 0x8E, 0x06, 0x2F, 0x56 ; 00005772  mov es,[cs:0x562f]
  db 0xB0, 0x04                ; 00005777  mov al,0x4
  db 0xAA                      ; 00005779  stosb
  db 0x8B, 0xC6                ; 0000577A  mov ax,si
  db 0xAB                      ; 0000577C  stosw
  db 0xE8, 0x9C, 0x00          ; 0000577D  call 0x581c
  db 0xAA                      ; 00005780  stosb
  db 0xC6, 0x44, 0x21, 0x01    ; 00005781  mov byte [si+0x21],0x1
  db 0x56                      ; 00005785  push si
  db 0xBA, 0x03, 0x15          ; 00005786  mov dx,0x1503
  db 0xB1, 0x8B                ; 00005789  mov cl,0x8b
  db 0xCD, 0xE0                ; 0000578B  int 0xe0
  db 0x5E                      ; 0000578D  pop si
  db 0xC3                      ; 0000578E  ret
  db 0xE8, 0x32, 0x00          ; 0000578F  call 0x57c4
  db 0x53                      ; 00005792  push bx
  db 0xBB, 0x1F, 0x15          ; 00005793  mov bx,0x151f
  db 0xC6, 0x47, 0x0A, 0x02    ; 00005796  mov byte [bx+0xa],0x2
  db 0x88, 0x47, 0x0B          ; 0000579A  mov [bx+0xb],al
  db 0x88, 0x67, 0x0C          ; 0000579D  mov [bx+0xc],ah
  db 0xE9, 0x14, 0x00          ; 000057A0  jmp 0x57b7
  db 0xE8, 0x1E, 0x00          ; 000057A3  call 0x57c4
  db 0x53                      ; 000057A6  push bx
  db 0xBB, 0x1F, 0x15          ; 000057A7  mov bx,0x151f
  db 0xC6, 0x47, 0x0A, 0x04    ; 000057AA  mov byte [bx+0xa],0x4
  db 0x88, 0x67, 0x0B          ; 000057AE  mov [bx+0xb],ah
  db 0x8A, 0x44, 0x04          ; 000057B1  mov al,[si+0x4]
  db 0x88, 0x47, 0x0C          ; 000057B4  mov [bx+0xc],al
  db 0x56                      ; 000057B7  push si
  db 0x57                      ; 000057B8  push di
  db 0xB1, 0x8B                ; 000057B9  mov cl,0x8b
  db 0xBA, 0x03, 0x15          ; 000057BB  mov dx,0x1503
  db 0xCD, 0xE0                ; 000057BE  int 0xe0
  db 0x5F                      ; 000057C0  pop di
  db 0x5E                      ; 000057C1  pop si
  db 0x5B                      ; 000057C2  pop bx
  db 0xC3                      ; 000057C3  ret
  db 0x50                      ; 000057C4  push ax
  db 0x53                      ; 000057C5  push bx
  db 0x56                      ; 000057C6  push si
  db 0x06                      ; 000057C7  push es
  db 0x57                      ; 000057C8  push di
  db 0xBF, 0x1F, 0x15          ; 000057C9  mov di,0x151f
  db 0x2E, 0x8E, 0x06, 0x2F, 0x56 ; 000057CC  mov es,[cs:0x562f]
  db 0xB0, 0x02                ; 000057D1  mov al,0x2
  db 0xAA                      ; 000057D3  stosb
  db 0x8B, 0xF3                ; 000057D4  mov si,bx
  db 0x83, 0xC6, 0x0E          ; 000057D6  add si,byte +0xe
  db 0xB9, 0x03, 0x00          ; 000057D9  mov cx,0x3
  db 0xF3, 0xA5                ; 000057DC  rep movsw
  db 0x5F                      ; 000057DE  pop di
  db 0x07                      ; 000057DF  pop es
  db 0x5E                      ; 000057E0  pop si
  db 0x26, 0x8A, 0x45, 0x01    ; 000057E1  mov al,[es:di+0x1]
  db 0xBB, 0x1F, 0x15          ; 000057E5  mov bx,0x151f
  db 0x88, 0x47, 0x07          ; 000057E8  mov [bx+0x7],al
  db 0x26, 0x8A, 0x05          ; 000057EB  mov al,[es:di]
  db 0x88, 0x47, 0x08          ; 000057EE  mov [bx+0x8],al
  db 0xC6, 0x47, 0x09, 0x03    ; 000057F1  mov byte [bx+0x9],0x3
  db 0x5B                      ; 000057F5  pop bx
  db 0x58                      ; 000057F6  pop ax
  db 0xC3                      ; 000057F7  ret
  db 0x00, 0x2E, 0x80, 0x3E    ; 000057F8  add [0x3e80],ch
  db 0xF8                      ; 000057FC  clc
  db 0x57                      ; 000057FD  push di
  db 0xFF, 0x75, 0x06          ; 000057FE  push word [di+0x6]
  db 0xB8, 0x80, 0x00          ; 00005801  mov ax,0x80
  db 0xE8, 0x01, 0x00          ; 00005804  call 0x5808
  db 0xCB                      ; 00005807  retf
  db 0x9C                      ; 00005808  pushf
  db 0xFA                      ; 00005809  cli
  db 0x2E, 0x83, 0x3E, 0x76, 0x33, 0x00 ; 0000580A  cmp word [cs:0x3376],byte +0x0
  db 0x75, 0xF8                ; 00005810  jnz 0x580a
  db 0x2E, 0xA3, 0x76, 0x33    ; 00005812  mov [cs:0x3376],ax
  db 0xBA, 0x00, 0x01          ; 00005816  mov dx,0x100
  db 0xEC                      ; 00005819  in al,dx
  db 0x9D                      ; 0000581A  popf
  db 0xC3                      ; 0000581B  ret
  db 0x8B, 0x44, 0x19          ; 0000581C  mov ax,[si+0x19]
  db 0x2D, 0x45, 0x15          ; 0000581F  sub ax,0x1545
  db 0x33, 0xD2                ; 00005822  xor dx,dx
  db 0xB9, 0x4B, 0x00          ; 00005824  mov cx,0x4b
  db 0xF7, 0xF1                ; 00005827  div cx
  db 0xC3                      ; 00005829  ret
  db 0x1E                      ; 0000582A  push ds
  db 0x2E, 0x8E, 0x1E, 0x25, 0x56 ; 0000582B  mov ds,[cs:0x5625]
  db 0xB9, 0x84, 0x00          ; 00005830  mov cx,0x84
  db 0x2E, 0xFF, 0x1E, 0x27, 0x56 ; 00005833  call far [cs:0x5627]
  db 0x59                      ; 00005838  pop cx
  db 0x8E, 0xD9                ; 00005839  mov ds,cx
  db 0x8E, 0xC1                ; 0000583B  mov es,cx
  db 0xC3                      ; 0000583D  ret
  db 0x1E                      ; 0000583E  push ds
  db 0x2E, 0x8E, 0x1E, 0x25, 0x56 ; 0000583F  mov ds,[cs:0x5625]
  db 0xB9, 0x85, 0x00          ; 00005844  mov cx,0x85
  db 0x2E, 0xFF, 0x1E, 0x27, 0x56 ; 00005847  call far [cs:0x5627]
  db 0x1F                      ; 0000584C  pop ds
  db 0xC3                      ; 0000584D  ret
  db 0x00, 0x00                ; 0000584E  add [bx+si],al

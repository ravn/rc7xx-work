; ===========================================================================
; Regnecentralen RC759 Piccoline — XIOS4.CON Code Segment
; Extended I/O System for CCP/M-86 Release 3.1 (4 virtuelle konsoller)
; Forfatter: Flemming Kraglund, Regnecentralen
; ===========================================================================

  db 0xE9, 0x04, 0x54          ; 00000000  jmp 0x5407
  db 0xE9, 0x34, 0x00          ; 00000003  jmp 0x3a
  db 0x00, 0x00                ; 00000006  add [bx+si],al
  db 0x00, 0x00                ; 00000008  add [bx+si],al
  db 0x00, 0x00                ; 0000000A  add [bx+si],al
  db 0x00, 0x3C                ; 0000000C  add [si],bh
  db 0x00, 0x00                ; 0000000E  add [bx+si],al
  db 0x01, 0x04                ; 00000010  add [si],ax
  db 0x09, 0x03                ; 00000012  or [bp+di],ax
  db 0x49                      ; 00000014  dec cx
  db 0x0D, 0xD5, 0x0E          ; 00000015  or ax,0xed5
  db 0xCF                      ; 00000018  iret
  db 0x3C, 0xE3                ; 00000019  cmp al,0xe3
  db 0x3C, 0x00                ; 0000001B  cmp al,0x0
  db 0x00, 0x00                ; 0000001D  add [bx+si],al
  db 0x00, 0x00                ; 0000001F  add [bx+si],al
  db 0x00, 0x00                ; 00000021  add [bx+si],al
  db 0x00, 0x00                ; 00000023  add [bx+si],al
  db 0x00, 0x00                ; 00000025  add [bx+si],al
  db 0x00, 0x00                ; 00000027  add [bx+si],al
  db 0x00, 0x00                ; 00000029  add [bx+si],al
  db 0x00, 0x00                ; 0000002B  add [bx+si],al
  db 0x00, 0x00                ; 0000002D  add [bx+si],al
  db 0x00, 0xBF, 0x3D, 0x00    ; 0000002F  add [bx+0x3d],bh
  db 0x00, 0x00                ; 00000033  add [bx+si],al
  db 0x00, 0x00                ; 00000035  add [bx+si],al
  db 0x00, 0x00                ; 00000037  add [bx+si],al
  db 0x05, 0xFC, 0x98          ; 00000039  add ax,0x98fc
  db 0xD0, 0xE0                ; 0000003C  shl al,1
  db 0x93                      ; 0000003E  xchg ax,bx
  db 0x2E, 0xFF, 0x97, 0x47, 0x0C ; 0000003F  call [cs:bx+0xc47]
  db 0x8B, 0xD8                ; 00000044  mov bx,ax
  db 0xCB                      ; 00000046  retf
; =============================================================================
; Digital Research CCP/M-86 XIOS Function Dispatch Table (CS:0C47h, 37 entries)
; Reference: Digital Research CCP/M-86 XIOS-86 (xios.a86)
; Indgang: AL = funktionsnummer (0..13 standard + udvidede funktioner)
; =============================================================================
xios_function_table:
  dw 0x1116                                    ; Func  0: io_const (Console input status)
  dw 0x1119                                    ; Func  1: io_conin (Console input character)
  dw 0x1473                                    ; Func  2: io_conout (Console output character)
  dw 0x451D                                    ; Func  3: io_listst (List/printer status)
  dw 0x444C                                    ; Func  4: io_list (List/printer output)
  dw 0x3FDA                                    ; Func  5: io_auxin (AUX/serial input)
  dw 0x3FDD                                    ; Func  6: io_auxout (AUX/serial output)
  dw 0x2032                                    ; Func  7: io_switch (Switch virtual console)
  dw 0x210B                                    ; Func  8: io_statline (Update console status line)
  dw 0x3108                                    ; Func  9: io_seldsk (Select disk drive)
  dw 0x3166                                    ; Func 10: io_read (Read logical disk sector)
  dw 0x3226                                    ; Func 11: io_write (Write logical disk sector)
  dw 0x32E8                                    ; Func 12: io_flushbuf (Flush disk buffers)
  dw 0x440E                                    ; Func 13: io_poll (Poll hardware device)
  dw 0x0D18                                    ; Func 14: Reserveret stub
  dw 0x0D18                                    ; Func 15: Reserveret stub
  dw 0x2630                                    ; Func 16: Udvidet funktion (virtual console)
  dw 0x1451                                    ; Func 17: Udvidet funktion
  dw 0x2279                                    ; Func 18: Udvidet funktion
  dw 0x2645                                    ; Func 19: io_auxist (AUX input status)
  dw 0x2676                                    ; Func 20: Udvidet funktion
  dw 0x26A6                                    ; Func 21: Udvidet funktion
  dw 0x26C0                                    ; Func 22: Udvidet funktion
  dw 0x26C7                                    ; Func 23: Udvidet funktion
  dw 0x26E9                                    ; Func 24: Udvidet funktion
  times 5 dw 0x0D18                            ; Func 25..29: Reserveret stubs
  dw 0x26EA                                    ; Func 30: io_setblank (Screen blanking)
  times 6 dw 0x0D18                            ; Func 31..36: Reserveret stubs
  db 0x1E                      ; 00000091  push ds
  db 0x2E, 0x8E, 0x1E, 0x06, 0x0C ; 00000092  mov ds,[cs:0xc06]
  db 0x2E, 0x8B, 0x1E, 0x68, 0x00 ; 00000097  mov bx,[cs:0x68]
  db 0x8E, 0x47, 0x10          ; 0000009C  mov es,[bx+0x10]
  db 0x33, 0xDB                ; 0000009F  xor bx,bx
  db 0x8A, 0xD8                ; 000000A1  mov bl,al
  db 0xD1, 0xE3                ; 000000A3  shl bx,1
  db 0x2E, 0xFF, 0x97, 0xAC, 0x0C ; 000000A5  call [cs:bx+0xcac]
  db 0x1F                      ; 000000AA  pop ds
  db 0xCF                      ; 000000AB  iret
  db 0xFF, 0x22                ; 000000AC  jmp [bp+si]
  db 0x11, 0x24                ; 000000AE  adc [si],sp
  db 0xBA, 0x1D, 0x63          ; 000000B0  mov dx,0x631d
  db 0x46                      ; 000000B3  inc si
  db 0x6C                      ; 000000B4  insb
  db 0x46                      ; 000000B5  inc si
  db 0xE6, 0x37                ; 000000B6  out 0x37,al
  db 0x02, 0x38                ; 000000B8  add bh,[bx+si]
  db 0x03, 0x38                ; 000000BA  add di,[bx+si]
  db 0x04, 0x38                ; 000000BC  add al,0x38
  db 0x20, 0x38                ; 000000BE  and [bx+si],bh
  db 0x21, 0x38                ; 000000C0  and [bx+si],di
  db 0xAC                      ; 000000C2  lodsb
  db 0x38, 0xEB                ; 000000C3  cmp bl,ch
  db 0x47                      ; 000000C5  inc di
  db 0x3A, 0x39                ; 000000C6  cmp bh,[bx+di]
  db 0x43                      ; 000000C8  inc bx
  db 0x39, 0x0D                ; 000000C9  cmp [di],cx
  db 0x11, 0x18                ; 000000CB  adc [bx+si],bx
  db 0x0D, 0x18, 0x0D          ; 000000CD  or ax,0xd18
  db 0xB1, 0x43                ; 000000D0  mov cl,0x43
  db 0x0C, 0x48                ; 000000D2  or al,0x48
  db 0x6C                      ; 000000D4  insb
  db 0x25, 0xCB, 0x25          ; 000000D5  and ax,0x25cb
  db 0xD4, 0x25                ; 000000D8  aam 0x25
  db 0x1F                      ; 000000DA  pop ds
  db 0x48                      ; 000000DB  dec ax
  db 0x10, 0x49, 0xEB          ; 000000DC  adc [bx+di-0x15],cl
  db 0x41                      ; 000000DF  inc cx
  db 0x6B, 0x69, 0x8A, 0x69    ; 000000E0  imul bp,[bx+di-0x76],byte +0x69
  db 0xA7                      ; 000000E4  cmpsw
  db 0x69, 0xC4, 0x69, 0xC3    ; 000000E5  imul ax,sp,word 0xc369
  db 0x2A, 0xFC                ; 000000E9  sub bh,ah
  db 0x25, 0x75, 0x46          ; 000000EB  and ax,0x4675
  db 0x83, 0x46, 0x93, 0x46    ; 000000EE  add word [bp-0x6d],byte +0x46
  db 0x20, 0x25                ; 000000F2  and [di],ah
  db 0xE0, 0x25                ; 000000F4  loopne 0x11b
  db 0xEE                      ; 000000F6  out dx,al
  db 0x25, 0xF5, 0x25          ; 000000F7  and ax,0x25f5
  db 0x66, 0x25, 0xDF, 0x69, 0xB8, 0x6C ; 000000FA  and eax,0x6cb869df
  db 0x6A, 0x6D                ; 00000100  push byte +0x6d
  db 0x18, 0x0D                ; 00000102  sbb [di],cl
  db 0x18, 0x0D                ; 00000104  sbb [di],cl
  db 0x18, 0x0D                ; 00000106  sbb [di],cl
  db 0x18, 0x0D                ; 00000108  sbb [di],cl
  db 0x18, 0x0D                ; 0000010A  sbb [di],cl
  db 0x18, 0x0D                ; 0000010C  sbb [di],cl
  db 0x18, 0x0D                ; 0000010E  sbb [di],cl
  db 0x4B                      ; 00000110  dec bx
  db 0x48                      ; 00000111  dec ax
  db 0x94                      ; 00000112  xchg ax,sp
  db 0x25, 0x7D, 0x25          ; 00000113  and ax,0x257d
  db 0x19, 0x0D                ; 00000116  sbb [di],cx
  db 0xC3                      ; 00000118  ret
  db 0xB8, 0x23, 0x85          ; 00000119  mov ax,0x8523
  db 0xBB, 0x06, 0x02          ; 0000011C  mov bx,0x206
  db 0xC3                      ; 0000011F  ret
  db 0x52                      ; 00000120  push dx
  db 0xB1, 0x85                ; 00000121  mov cl,0x85
  db 0xE8, 0x16, 0x00          ; 00000123  call 0x13c
  db 0x5A                      ; 00000126  pop dx
  db 0x85, 0xC0                ; 00000127  test ax,ax
  db 0x74, 0x05                ; 00000129  jz 0x130
  db 0x80, 0xF9, 0x2A          ; 0000012B  cmp cl,0x2a
  db 0x74, 0xF0                ; 0000012E  jz 0x120
  db 0xC3                      ; 00000130  ret
  db 0xB1, 0x84                ; 00000131  mov cl,0x84
  db 0x2E, 0x8B, 0x1E, 0x68, 0x00 ; 00000133  mov bx,[cs:0x68]
  db 0x2E, 0x8E, 0x47, 0x10    ; 00000138  mov es,[cs:bx+0x10]
  db 0x32, 0xED                ; 0000013C  xor ch,ch
  db 0x2E, 0x8E, 0x1E, 0x06, 0x0C ; 0000013E  mov ds,[cs:0xc06]
  db 0x2E, 0xFF, 0x1E, 0x08, 0x0C ; 00000143  call far [cs:0xc08]
  db 0xC3                      ; 00000148  ret
  db 0x00, 0x00                ; 00000149  add [bx+si],al
  db 0x00, 0x00                ; 0000014B  add [bx+si],al
  db 0x00, 0x00                ; 0000014D  add [bx+si],al
  db 0x00, 0x00                ; 0000014F  add [bx+si],al
  db 0xFF                      ; 00000151  db 0xff
  db 0xFF, 0x00                ; 00000152  inc word [bx+si]
  db 0x00, 0x00                ; 00000154  add [bx+si],al
  db 0x00, 0x00                ; 00000156  add [bx+si],al
  db 0x00, 0x10                ; 00000158  add [bx+si],dl
  db 0x00, 0x00                ; 0000015A  add [bx+si],al
  db 0x00, 0x00                ; 0000015C  add [bx+si],al
  db 0x00, 0x00                ; 0000015E  add [bx+si],al
  db 0x00, 0x00                ; 00000160  add [bx+si],al
  db 0x00, 0x00                ; 00000162  add [bx+si],al
  db 0x00, 0x00                ; 00000164  add [bx+si],al
  db 0x00, 0x00                ; 00000166  add [bx+si],al
  db 0x00, 0x00                ; 00000168  add [bx+si],al
  db 0x00, 0x00                ; 0000016A  add [bx+si],al
  db 0x00, 0x00                ; 0000016C  add [bx+si],al
  db 0x00, 0x00                ; 0000016E  add [bx+si],al
  db 0x00, 0x75, 0x0D          ; 00000170  add [di+0xd],dh
  db 0x00, 0x00                ; 00000173  add [bx+si],al
  db 0x00, 0x00                ; 00000175  add [bx+si],al
  db 0x00, 0x00                ; 00000177  add [bx+si],al
  db 0x00, 0x00                ; 00000179  add [bx+si],al
  db 0x00, 0x00                ; 0000017B  add [bx+si],al
  db 0xFF                      ; 0000017D  db 0xff
  db 0xFF, 0x00                ; 0000017E  inc word [bx+si]
  db 0x01, 0x00                ; 00000180  add [bx+si],ax
  db 0x00, 0x02                ; 00000182  add [bp+si],al
  db 0x00, 0x10                ; 00000184  add [bx+si],dl
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
  db 0x00, 0xA1, 0x0D, 0x00    ; 0000019C  add [bx+di+0xd],ah
  db 0x00, 0x00                ; 000001A0  add [bx+si],al
  db 0x00, 0x00                ; 000001A2  add [bx+si],al
  db 0x00, 0x00                ; 000001A4  add [bx+si],al
  db 0x00, 0x00                ; 000001A6  add [bx+si],al
  db 0x00, 0xFF                ; 000001A8  add bh,bh
  db 0xFF, 0x00                ; 000001AA  inc word [bx+si]
  db 0x02, 0x00                ; 000001AC  add al,[bx+si]
  db 0x00, 0x02                ; 000001AE  add [bp+si],al
  db 0x00, 0x10                ; 000001B0  add [bx+si],dl
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
  db 0x00, 0xCD                ; 000001C8  add ch,cl
  db 0x0D, 0x00, 0x00          ; 000001CA  or ax,0x0
  db 0x00, 0x00                ; 000001CD  add [bx+si],al
  db 0x00, 0x00                ; 000001CF  add [bx+si],al
  db 0x00, 0x00                ; 000001D1  add [bx+si],al
  db 0x00, 0x00                ; 000001D3  add [bx+si],al
  db 0xFF                      ; 000001D5  db 0xff
  db 0xFF, 0x00                ; 000001D6  inc word [bx+si]
  db 0x03, 0x00                ; 000001D8  add ax,[bx+si]
  db 0x00, 0x02                ; 000001DA  add [bp+si],al
  db 0x00, 0x10                ; 000001DC  add [bx+si],dl
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
  db 0x00, 0xF9                ; 000001F4  add cl,bh
  db 0x0D, 0x00, 0x00          ; 000001F6  or ax,0x0
  db 0x00, 0x00                ; 000001F9  add [bx+si],al
  db 0x00, 0x00                ; 000001FB  add [bx+si],al
  db 0x00, 0x00                ; 000001FD  add [bx+si],al
  db 0x00, 0x00                ; 000001FF  add [bx+si],al
  db 0x00, 0x00                ; 00000201  add [bx+si],al
  db 0x00, 0x00                ; 00000203  add [bx+si],al
  db 0x00, 0x00                ; 00000205  add [bx+si],al
  db 0x00, 0x00                ; 00000207  add [bx+si],al
  db 0x00, 0x00                ; 00000209  add [bx+si],al
  db 0x00, 0x00                ; 0000020B  add [bx+si],al
  db 0x00, 0x00                ; 0000020D  add [bx+si],al
  db 0x00, 0x00                ; 0000020F  add [bx+si],al
  db 0x00, 0x00                ; 00000211  add [bx+si],al
  db 0x00, 0x00                ; 00000213  add [bx+si],al
  db 0x00, 0x00                ; 00000215  add [bx+si],al
  db 0x00, 0x00                ; 00000217  add [bx+si],al
  db 0x00, 0x00                ; 00000219  add [bx+si],al
  db 0x00, 0x00                ; 0000021B  add [bx+si],al
  db 0x00, 0x00                ; 0000021D  add [bx+si],al
  db 0x00, 0x00                ; 0000021F  add [bx+si],al
  db 0x25, 0x0E, 0x00          ; 00000221  and ax,0xe
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
  db 0x00, 0x51, 0x0E          ; 0000024C  add [bx+di+0xe],dl
  db 0x00, 0x00                ; 0000024F  add [bx+si],al
  db 0x00, 0x00                ; 00000251  add [bx+si],al
  db 0x00, 0x00                ; 00000253  add [bx+si],al
  db 0x00, 0x00                ; 00000255  add [bx+si],al
  db 0x00, 0x00                ; 00000257  add [bx+si],al
  db 0x00, 0x00                ; 00000259  add [bx+si],al
  db 0x00, 0x00                ; 0000025B  add [bx+si],al
  db 0x00, 0x00                ; 0000025D  add [bx+si],al
  db 0x00, 0x00                ; 0000025F  add [bx+si],al
  db 0x00, 0x00                ; 00000261  add [bx+si],al
  db 0x00, 0x00                ; 00000263  add [bx+si],al
  db 0x00, 0x00                ; 00000265  add [bx+si],al
  db 0x00, 0x00                ; 00000267  add [bx+si],al
  db 0x00, 0x00                ; 00000269  add [bx+si],al
  db 0x00, 0x00                ; 0000026B  add [bx+si],al
  db 0x00, 0x00                ; 0000026D  add [bx+si],al
  db 0x00, 0x00                ; 0000026F  add [bx+si],al
  db 0x00, 0x00                ; 00000271  add [bx+si],al
  db 0x00, 0x00                ; 00000273  add [bx+si],al
  db 0x00, 0x00                ; 00000275  add [bx+si],al
  db 0x00, 0x00                ; 00000277  add [bx+si],al
  db 0x7D, 0x0E                ; 00000279  jnl 0x289
  db 0x00, 0x00                ; 0000027B  add [bx+si],al
  db 0x00, 0x00                ; 0000027D  add [bx+si],al
  db 0x00, 0x00                ; 0000027F  add [bx+si],al
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
  db 0xA9, 0x0E, 0x00          ; 000002A5  test ax,0xe
  db 0x00, 0x00                ; 000002A8  add [bx+si],al
  db 0x00, 0x00                ; 000002AA  add [bx+si],al
  db 0x00, 0x00                ; 000002AC  add [bx+si],al
  db 0x00, 0x00                ; 000002AE  add [bx+si],al
  db 0x00, 0x00                ; 000002B0  add [bx+si],al
  db 0x00, 0x00                ; 000002B2  add [bx+si],al
  db 0x00, 0x00                ; 000002B4  add [bx+si],al
  db 0x00, 0x00                ; 000002B6  add [bx+si],al
  db 0x00, 0x00                ; 000002B8  add [bx+si],al
  db 0x00, 0x00                ; 000002BA  add [bx+si],al
  db 0x00, 0x00                ; 000002BC  add [bx+si],al
  db 0x00, 0x00                ; 000002BE  add [bx+si],al
  db 0x00, 0x00                ; 000002C0  add [bx+si],al
  db 0x00, 0x00                ; 000002C2  add [bx+si],al
  db 0x00, 0x00                ; 000002C4  add [bx+si],al
  db 0x00, 0x00                ; 000002C6  add [bx+si],al
  db 0x00, 0x00                ; 000002C8  add [bx+si],al
  db 0x00, 0x00                ; 000002CA  add [bx+si],al
  db 0x00, 0x00                ; 000002CC  add [bx+si],al
  db 0x00, 0x00                ; 000002CE  add [bx+si],al
  db 0x00, 0x00                ; 000002D0  add [bx+si],al
  db 0x00, 0x00                ; 000002D2  add [bx+si],al
  db 0x00, 0x00                ; 000002D4  add [bx+si],al
  db 0x00, 0x00                ; 000002D6  add [bx+si],al
  db 0x00, 0x00                ; 000002D8  add [bx+si],al
  db 0x00, 0x00                ; 000002DA  add [bx+si],al
  db 0x00, 0xFF                ; 000002DC  add bh,bh
  db 0xFF, 0x00                ; 000002DE  inc word [bx+si]
  db 0x00, 0x00                ; 000002E0  add [bx+si],al
  db 0x00, 0x00                ; 000002E2  add [bx+si],al
  db 0x00, 0x00                ; 000002E4  add [bx+si],al
  db 0x00, 0xFF                ; 000002E6  add bh,bh
  db 0xFF, 0x00                ; 000002E8  inc word [bx+si]
  db 0x00, 0x00                ; 000002EA  add [bx+si],al
  db 0x00, 0x00                ; 000002EC  add [bx+si],al
  db 0x00, 0x00                ; 000002EE  add [bx+si],al
  db 0x00, 0xFF                ; 000002F0  add bh,bh
  db 0xFF                      ; 000002F2  db 0xff
  db 0xE8, 0x14, 0x38          ; 000002F3  call 0x3b0a
  db 0x2E, 0x80, 0x3E, 0x23, 0x2C, 0xFF ; 000002F6  cmp byte [cs:0x2c23],0xff
  db 0x75, 0x03                ; 000002FC  jnz 0x301
  db 0xE8, 0xED, 0x1C          ; 000002FE  call 0x1fee
  db 0x1E                      ; 00000301  push ds
  db 0x07                      ; 00000302  pop es
  db 0xE8, 0xF8, 0x37          ; 00000303  call 0x3afe
  db 0xE4, 0x20                ; 00000306  in al,0x20
  db 0x2E, 0xA2, 0x44, 0x10    ; 00000308  mov [cs:0x1044],al
  db 0x2E, 0x80, 0x3E, 0x47, 0x10, 0xFF ; 0000030C  cmp byte [cs:0x1047],0xff
  db 0x75, 0x1B                ; 00000312  jnz 0x32f
  db 0xA8, 0x80                ; 00000314  test al,0x80
  db 0x75, 0x56                ; 00000316  jnz 0x36e
  db 0x2E, 0xC6, 0x06, 0x47, 0x10, 0x00 ; 00000318  mov byte [cs:0x1047],0x0
  db 0xBB, 0xDF, 0x2F          ; 0000031E  mov bx,0x2fdf
  db 0xD7                      ; 00000321  xlatb
  db 0x2E, 0xA2, 0x40, 0x10    ; 00000322  mov [cs:0x1040],al
  db 0xBA, 0x13, 0x00          ; 00000326  mov dx,0x13
  db 0xE8, 0xF4, 0xFD          ; 00000329  call 0x120
  db 0xE9, 0xD6, 0x00          ; 0000032C  jmp 0x405
  db 0x2E, 0x80, 0x3E, 0x48, 0x10, 0xFF ; 0000032F  cmp byte [cs:0x1048],0xff
  db 0x75, 0x0C                ; 00000335  jnz 0x343
  db 0x2E, 0xC6, 0x06, 0x48, 0x10, 0x00 ; 00000337  mov byte [cs:0x1048],0x0
  db 0xE8, 0xCE, 0x1B          ; 0000033D  call 0x1f0e
  db 0xE9, 0xC2, 0x00          ; 00000340  jmp 0x405
  db 0x3C, 0xE3                ; 00000343  cmp al,0xe3
  db 0x75, 0x09                ; 00000345  jnz 0x350
  db 0x2E, 0xC6, 0x06, 0x48, 0x10, 0xFF ; 00000347  mov byte [cs:0x1048],0xff
  db 0xE9, 0xB5, 0x00          ; 0000034D  jmp 0x405
  db 0x3C, 0x0E                ; 00000350  cmp al,0xe
  db 0x75, 0x1A                ; 00000352  jnz 0x36e
  db 0x2E, 0xF6, 0x06, 0x45, 0x10, 0x02 ; 00000354  test byte [cs:0x1045],0x2
  db 0x74, 0x12                ; 0000035A  jz 0x36e
  db 0x2E, 0xF6, 0x06, 0x45, 0x10, 0x10 ; 0000035C  test byte [cs:0x1045],0x10
  db 0x74, 0x0A                ; 00000362  jz 0x36e
  db 0xBB, 0xF8, 0x6D          ; 00000364  mov bx,0x6df8
  db 0xE9, 0xD2, 0x3A          ; 00000367  jmp 0x3e3c
  db 0xCC                      ; 0000036A  int3
  db 0xE9, 0x97, 0x00          ; 0000036B  jmp 0x405
  db 0x24, 0x7F                ; 0000036E  and al,0x7f
  db 0x3C, 0x62                ; 00000370  cmp al,0x62
  db 0x7E, 0x03                ; 00000372  jng 0x377
  db 0xE9, 0x8E, 0x00          ; 00000374  jmp 0x405
  db 0xB9, 0x05, 0x00          ; 00000377  mov cx,0x5
  db 0xB4, 0x02                ; 0000037A  mov ah,0x2
  db 0xBB, 0x49, 0x10          ; 0000037C  mov bx,0x1049
  db 0x3A, 0x07                ; 0000037F  cmp al,[bx]
  db 0x75, 0x03                ; 00000381  jnz 0x386
  db 0xE9, 0x82, 0x00          ; 00000383  jmp 0x408
  db 0xD0, 0xE4                ; 00000386  shl ah,1
  db 0x43                      ; 00000388  inc bx
  db 0xE2, 0xF4                ; 00000389  loop 0x37f
  db 0x2E, 0xA0, 0x44, 0x10    ; 0000038B  mov al,[cs:0x1044]
  db 0x0A, 0xC0                ; 0000038F  or al,al
  db 0x79, 0x03                ; 00000391  jns 0x396
  db 0xE9, 0x6F, 0x00          ; 00000393  jmp 0x405
  db 0xBB, 0xA5, 0x30          ; 00000396  mov bx,0x30a5
  db 0x2E, 0xF6, 0x06, 0x45, 0x10, 0x02 ; 00000399  test byte [cs:0x1045],0x2
  db 0x75, 0x0E                ; 0000039F  jnz 0x3af
  db 0xBB, 0x42, 0x30          ; 000003A1  mov bx,0x3042
  db 0x2E, 0xF6, 0x06, 0x45, 0x10, 0x0C ; 000003A4  test byte [cs:0x1045],0xc
  db 0x75, 0x03                ; 000003AA  jnz 0x3af
  db 0xBB, 0xDF, 0x2F          ; 000003AC  mov bx,0x2fdf
  db 0xD7                      ; 000003AF  xlatb
  db 0x3C, 0xFF                ; 000003B0  cmp al,0xff
  db 0x74, 0x51                ; 000003B2  jz 0x405
  db 0x98                      ; 000003B4  cbw
  db 0x2E, 0x88, 0x26, 0x3F, 0x10 ; 000003B5  mov [cs:0x103f],ah
  db 0x2E, 0xF6, 0x06, 0x46, 0x10, 0x20 ; 000003BA  test byte [cs:0x1046],0x20
  db 0x74, 0x12                ; 000003C0  jz 0x3d4
  db 0x3C, 0x7E                ; 000003C2  cmp al,0x7e
  db 0x77, 0x0E                ; 000003C4  ja 0x3d4
  db 0x3C, 0x61                ; 000003C6  cmp al,0x61
  db 0x73, 0x08                ; 000003C8  jnc 0x3d2
  db 0x3C, 0x5E                ; 000003CA  cmp al,0x5e
  db 0x77, 0x06                ; 000003CC  ja 0x3d4
  db 0x3C, 0x41                ; 000003CE  cmp al,0x41
  db 0x72, 0x02                ; 000003D0  jc 0x3d4
  db 0x34, 0x20                ; 000003D2  xor al,0x20
  db 0x24, 0x7F                ; 000003D4  and al,0x7f
  db 0x2E, 0xF6, 0x06, 0x45, 0x10, 0x10 ; 000003D6  test byte [cs:0x1045],0x10
  db 0x74, 0x10                ; 000003DC  jz 0x3ee
  db 0x84, 0xE4                ; 000003DE  test ah,ah
  db 0x79, 0x0A                ; 000003E0  jns 0x3ec
  db 0x3C, 0x0B                ; 000003E2  cmp al,0xb
  db 0x77, 0x08                ; 000003E4  ja 0x3ee
  db 0xBB, 0x4E, 0x10          ; 000003E6  mov bx,0x104e
  db 0xD7                      ; 000003E9  xlatb
  db 0xEB, 0x02                ; 000003EA  jmp short 0x3ee
  db 0x0C, 0x80                ; 000003EC  or al,0x80
  db 0x2E, 0xA2, 0x3E, 0x10    ; 000003EE  mov [cs:0x103e],al
  db 0x2E, 0x8B, 0x16, 0x41, 0x10 ; 000003F2  mov dx,[cs:0x1041]
  db 0x83, 0xFA, 0x18          ; 000003F7  cmp dx,byte +0x18
  db 0x75, 0x06                ; 000003FA  jnz 0x402
  db 0x2E, 0xC6, 0x06, 0x43, 0x10, 0xFF ; 000003FC  mov byte [cs:0x1043],0xff
  db 0xE8, 0x1B, 0xFD          ; 00000402  call 0x120
  db 0xE9, 0x23, 0x37          ; 00000405  jmp 0x3b2b
  db 0x3C, 0x28                ; 00000408  cmp al,0x28
  db 0x74, 0x18                ; 0000040A  jz 0x424
  db 0x2E, 0xF6, 0x06, 0x44, 0x10, 0x80 ; 0000040C  test byte [cs:0x1044],0x80
  db 0x74, 0x09                ; 00000412  jz 0x41d
  db 0xF6, 0xD4                ; 00000414  not ah
  db 0x2E, 0x20, 0x26, 0x45, 0x10 ; 00000416  and [cs:0x1045],ah
  db 0xEB, 0x1F                ; 0000041B  jmp short 0x43c
  db 0x2E, 0x08, 0x26, 0x45, 0x10 ; 0000041D  or [cs:0x1045],ah
  db 0xEB, 0x18                ; 00000422  jmp short 0x43c
  db 0x2E, 0xF6, 0x06, 0x44, 0x10, 0x80 ; 00000424  test byte [cs:0x1044],0x80
  db 0x75, 0x10                ; 0000042A  jnz 0x43c
  db 0x2E, 0x30, 0x26, 0x46, 0x10 ; 0000042C  xor [cs:0x1046],ah
  db 0x2E, 0x80, 0x3E, 0x98, 0x22, 0xFF ; 00000431  cmp byte [cs:0x2298],0xff
  db 0x74, 0x03                ; 00000437  jz 0x43c
  db 0xE8, 0xCD, 0x10          ; 00000439  call 0x1509
  db 0xEB, 0xC7                ; 0000043C  jmp short 0x405
  db 0x00, 0x00                ; 0000043E  add [bx+si],al
  db 0x00, 0x05                ; 00000440  add [di],al
  db 0x00, 0x00                ; 00000442  add [bx+si],al
  db 0x00, 0x00                ; 00000444  add [bx+si],al
  db 0x00, 0x00                ; 00000446  add [bx+si],al
  db 0x00, 0x1D                ; 00000448  add [di],bl
  db 0x36, 0x2A, 0x37          ; 0000044A  sub dh,[ss:bx]
  db 0x28, 0x23                ; 0000044D  sub [bp+di],ah
  db 0x24, 0x25                ; 0000044F  and al,0x25
  db 0x26, 0x27                ; 00000451  es daa
  db 0x28, 0x29                ; 00000453  sub [bx+di],ch
  db 0x2A, 0x2B                ; 00000455  sub ch,[bp+di]
  db 0x2C, 0x1D                ; 00000457  sub al,0x1d
  db 0x1E                      ; 00000459  push ds
  db 0xE8, 0xAD, 0x36          ; 0000045A  call 0x3b0a
  db 0xFC                      ; 0000045D  cld
  db 0xBA, 0x30, 0x02          ; 0000045E  mov dx,0x230
  db 0xEF                      ; 00000461  out dx,ax
  db 0xBA, 0x40, 0x02          ; 00000462  mov dx,0x240
  db 0xEF                      ; 00000465  out dx,ax
  db 0x2E, 0xFE, 0x06, 0xB3, 0x10 ; 00000466  inc byte [cs:0x10b3]
  db 0x2E, 0x80, 0x3E, 0xB1, 0x10, 0x00 ; 0000046B  cmp byte [cs:0x10b1],0x0
  db 0x74, 0x25                ; 00000471  jz 0x498
  db 0xBA, 0x5E, 0xFF          ; 00000473  mov dx,0xff5e
  db 0x2E, 0x80, 0x3E, 0xB2, 0x10, 0x00 ; 00000476  cmp byte [cs:0x10b2],0x0
  db 0x75, 0x0A                ; 0000047C  jnz 0x488
  db 0x2E, 0xC6, 0x06, 0xB2, 0x10, 0x08 ; 0000047E  mov byte [cs:0x10b2],0x8
  db 0xB8, 0x03, 0xC0          ; 00000484  mov ax,0xc003
  db 0xEF                      ; 00000487  out dx,ax
  db 0x2E, 0xFE, 0x0E, 0xB2, 0x10 ; 00000488  dec byte [cs:0x10b2]
  db 0x75, 0x09                ; 0000048D  jnz 0x498
  db 0xB8, 0x02, 0xC0          ; 0000048F  mov ax,0xc002
  db 0xEF                      ; 00000492  out dx,ax
  db 0x2E, 0xFE, 0x0E, 0xB1, 0x10 ; 00000493  dec byte [cs:0x10b1]
  db 0x2E, 0x80, 0x3E, 0x0C, 0x0C, 0x00 ; 00000498  cmp byte [cs:0xc0c],0x0
  db 0x74, 0x06                ; 0000049E  jz 0x4a6
  db 0xBA, 0x01, 0x00          ; 000004A0  mov dx,0x1
  db 0xE8, 0x7A, 0xFC          ; 000004A3  call 0x120
  db 0x2E, 0xFF, 0x1E, 0xB2, 0x46 ; 000004A6  call far [cs:0x46b2]
  db 0xE8, 0x50, 0x36          ; 000004AB  call 0x3afe
  db 0xE9, 0x7A, 0x36          ; 000004AE  jmp 0x3b2b
  db 0x00, 0x00                ; 000004B1  add [bx+si],al
  db 0x00, 0x00                ; 000004B3  add [bx+si],al
  db 0x3B, 0x3C                ; 000004B5  cmp di,[si]
  db 0x3D, 0x3E, 0x3F          ; 000004B7  cmp ax,0x3f3e
  db 0x40                      ; 000004BA  inc ax
  db 0x41                      ; 000004BB  inc cx
  db 0x42                      ; 000004BC  inc dx
  db 0x43                      ; 000004BD  inc bx
  db 0x44                      ; 000004BE  inc sp
  db 0x45                      ; 000004BF  inc bp
  db 0x46                      ; 000004C0  inc si
  db 0x47                      ; 000004C1  inc di
  db 0x48                      ; 000004C2  dec ax
  db 0x49                      ; 000004C3  dec cx
  db 0x4A                      ; 000004C4  dec dx
  db 0x4B                      ; 000004C5  dec bx
  db 0x4C                      ; 000004C6  dec sp
  db 0x4D                      ; 000004C7  dec bp
  db 0x4E                      ; 000004C8  dec si
  db 0x4F                      ; 000004C9  dec di
  db 0x50                      ; 000004CA  push ax
  db 0x51                      ; 000004CB  push cx
  db 0x52                      ; 000004CC  push dx
  db 0x53                      ; 000004CD  push bx
  db 0x55                      ; 000004CE  push bp
  db 0x56                      ; 000004CF  push si
  db 0x57                      ; 000004D0  push di
  db 0x58                      ; 000004D1  pop ax
  db 0x59                      ; 000004D2  pop cx
  db 0x5A                      ; 000004D3  pop dx
  db 0x5B                      ; 000004D4  pop bx
  db 0x5C                      ; 000004D5  pop sp
  db 0x5D                      ; 000004D6  pop bp
  db 0x5E                      ; 000004D7  pop si
  db 0x61                      ; 000004D8  popa
  db 0x62, 0x63, 0x64          ; 000004D9  bound sp,[bp+di+0x64]
  db 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C ; 000004DC  gs push dword 0x6c6b6a69
  db 0x6D                      ; 000004E4  insw
  db 0x6E                      ; 000004E5  outsb
  db 0x6F                      ; 000004E6  outsw
  db 0x70, 0x71                ; 000004E7  jo 0x55a
  db 0x72, 0x73                ; 000004E9  jc 0x55e
  db 0x74, 0x75                ; 000004EB  jz 0x562
  db 0x76, 0x77                ; 000004ED  jna 0x566
  db 0x78, 0x79                ; 000004EF  js 0x56a
  db 0x7A, 0x7B                ; 000004F1  jpe 0x56e
  db 0x7C, 0x7D                ; 000004F3  jl 0x572
  db 0x7E, 0x54                ; 000004F5  jng 0x54b
  db 0x8B, 0x77, 0x76          ; 000004F7  mov si,[bx+0x76]
  db 0xB1, 0x14                ; 000004FA  mov cl,0x14
  db 0x3C, 0x0C                ; 000004FC  cmp al,0xc
  db 0x72, 0x08                ; 000004FE  jc 0x508
  db 0x2C, 0x0C                ; 00000500  sub al,0xc
  db 0x81, 0xC6, 0xF0, 0x00    ; 00000502  add si,0xf0
  db 0xB1, 0x04                ; 00000506  mov cl,0x4
  db 0xF6, 0xE1                ; 00000508  mul cl
  db 0x03, 0xF0                ; 0000050A  add si,ax
  db 0xC3                      ; 0000050C  ret
  db 0xE8, 0x73, 0x13          ; 0000050D  call 0x1883
  db 0x8B, 0x5F, 0x76          ; 00000510  mov bx,[bx+0x76]
  db 0x1E                      ; 00000513  push ds
  db 0x07                      ; 00000514  pop es
  db 0xC3                      ; 00000515  ret
  db 0xE9, 0x7D, 0x2F          ; 00000516  jmp 0x3496
  db 0x80, 0xFA, 0x04          ; 00000519  cmp dl,0x4
  db 0x72, 0x03                ; 0000051C  jc 0x521
  db 0xE9, 0xBD, 0x2E          ; 0000051E  jmp 0x33de
  db 0x2E, 0x8B, 0x1E, 0x1B, 0x2D ; 00000521  mov bx,[cs:0x2d1b]
  db 0x80, 0x7F, 0x7A, 0x00    ; 00000526  cmp byte [bx+0x7a],0x0
  db 0x75, 0x4C                ; 0000052A  jnz 0x578
  db 0x53                      ; 0000052C  push bx
  db 0xBA, 0x05, 0x00          ; 0000052D  mov dx,0x5
  db 0xE8, 0xFE, 0xFB          ; 00000530  call 0x131
  db 0x5B                      ; 00000533  pop bx
  db 0x2E, 0xA1, 0x1F, 0x2C    ; 00000534  mov ax,[cs:0x2c1f]
  db 0x2E, 0xA3, 0x21, 0x2C    ; 00000538  mov [cs:0x2c21],ax
  db 0x2E, 0xA1, 0x3E, 0x10    ; 0000053C  mov ax,[cs:0x103e]
  db 0x84, 0xE4                ; 00000540  test ah,ah
  db 0x74, 0x19                ; 00000542  jz 0x55d
  db 0x3C, 0x7A                ; 00000544  cmp al,0x7a
  db 0x74, 0x45                ; 00000546  jz 0x58d
  db 0x3C, 0x7B                ; 00000548  cmp al,0x7b
  db 0x74, 0x4B                ; 0000054A  jz 0x597
  db 0x3C, 0x7D                ; 0000054C  cmp al,0x7d
  db 0x74, 0x77                ; 0000054E  jz 0x5c7
  db 0x3C, 0x7E                ; 00000550  cmp al,0x7e
  db 0x75, 0x03                ; 00000552  jnz 0x557
  db 0xE9, 0x3C, 0x02          ; 00000554  jmp 0x793
  db 0x3C, 0x70                ; 00000557  cmp al,0x70
  db 0x72, 0x03                ; 00000559  jc 0x55e
  db 0x24, 0x03                ; 0000055B  and al,0x3
  db 0xC3                      ; 0000055D  ret
  db 0xF7, 0x47, 0x6B, 0x00, 0x08 ; 0000055E  test word [bx+0x6b],0x800
  db 0x74, 0x0A                ; 00000563  jz 0x56f
  db 0xBB, 0xB5, 0x10          ; 00000565  mov bx,0x10b5
  db 0xD7                      ; 00000568  xlatb
  db 0x32, 0xE4                ; 00000569  xor ah,ah
  db 0x0C, 0x80                ; 0000056B  or al,0x80
  db 0xEB, 0xEE                ; 0000056D  jmp short 0x55d
  db 0xE8, 0x85, 0xFF          ; 0000056F  call 0x4f7
  db 0x89, 0x77, 0x78          ; 00000572  mov [bx+0x78],si
  db 0x88, 0x4F, 0x7A          ; 00000575  mov [bx+0x7a],cl
  db 0x8B, 0x77, 0x78          ; 00000578  mov si,[bx+0x78]
  db 0xAC                      ; 0000057B  lodsb
  db 0x89, 0x77, 0x78          ; 0000057C  mov [bx+0x78],si
  db 0xFE, 0x4F, 0x7A          ; 0000057F  dec byte [bx+0x7a]
  db 0x32, 0xE4                ; 00000582  xor ah,ah
  db 0x0A, 0xC0                ; 00000584  or al,al
  db 0x75, 0xD5                ; 00000586  jnz 0x55d
  db 0x88, 0x47, 0x7A          ; 00000588  mov [bx+0x7a],al
  db 0xEB, 0x9F                ; 0000058B  jmp short 0x52c
  db 0x2E, 0x8A, 0x16, 0x19, 0x2D ; 0000058D  mov dl,[cs:0x2d19]
  db 0xE8, 0x32, 0x15          ; 00000592  call 0x1ac7
  db 0xEB, 0x95                ; 00000595  jmp short 0x52c
  db 0x2E, 0x80, 0x3E, 0x14, 0x2D, 0x01 ; 00000597  cmp byte [cs:0x2d14],0x1
  db 0x72, 0x22                ; 0000059D  jc 0x5c1
  db 0xE8, 0x5E, 0x0F          ; 0000059F  call 0x1500
  db 0x75, 0x1D                ; 000005A2  jnz 0x5c1
  db 0x2E, 0xC6, 0x06, 0x14, 0x2D, 0x02 ; 000005A4  mov byte [cs:0x2d14],0x2
  db 0xBA, 0x18, 0x00          ; 000005AA  mov dx,0x18
  db 0x2E, 0x89, 0x16, 0x41, 0x10 ; 000005AD  mov [cs:0x1041],dx
  db 0x2E, 0xC6, 0x06, 0x43, 0x10, 0xFF ; 000005B2  mov byte [cs:0x1043],0xff
  db 0xE8, 0x65, 0xFB          ; 000005B8  call 0x120
  db 0x9C                      ; 000005BB  pushf
  db 0x2E, 0xFF, 0x1E, 0x38, 0x00 ; 000005BC  call far [cs:0x38]
  db 0xE9, 0x68, 0xFF          ; 000005C1  jmp 0x52c
  db 0xE8, 0xA1, 0x16          ; 000005C4  call 0x1c68
  db 0xB0, 0xFF                ; 000005C7  mov al,0xff
  db 0x2E, 0x86, 0x06, 0x98, 0x22 ; 000005C9  xchg al,[cs:0x2298]
  db 0x3C, 0xFF                ; 000005CE  cmp al,0xff
  db 0x74, 0xF2                ; 000005D0  jz 0x5c4
  db 0x2E, 0x89, 0x1E, 0x99, 0x22 ; 000005D2  mov [cs:0x2299],bx
  db 0x2E, 0xA2, 0x98, 0x22    ; 000005D7  mov [cs:0x2298],al
  db 0x8C, 0xC5                ; 000005DB  mov bp,es
  db 0x51                      ; 000005DD  push cx
  db 0x1E                      ; 000005DE  push ds
  db 0x07                      ; 000005DF  pop es
  db 0xBF, 0x9E, 0x6F          ; 000005E0  mov di,0x6f9e
  db 0x57                      ; 000005E3  push di
  db 0xB8, 0x20, 0x08          ; 000005E4  mov ax,0x820
  db 0xB9, 0x50, 0x00          ; 000005E7  mov cx,0x50
  db 0xF3, 0xAB                ; 000005EA  rep stosw
  db 0x5F                      ; 000005EC  pop di
  db 0xBE, 0x38, 0x4B          ; 000005ED  mov si,0x4b38
  db 0xAC                      ; 000005F0  lodsb
  db 0xE8, 0x9C, 0x00          ; 000005F1  call 0x690
  db 0xBE, 0xEE, 0x12          ; 000005F4  mov si,0x12ee
  db 0xAD                      ; 000005F7  lodsw
  db 0x0B, 0xC0                ; 000005F8  or ax,ax
  db 0x74, 0xF8                ; 000005FA  jz 0x5f4
  db 0x97                      ; 000005FC  xchg ax,di
  db 0x56                      ; 000005FD  push si
  db 0x57                      ; 000005FE  push di
  db 0x8B, 0x75, 0xFC          ; 000005FF  mov si,[di-0x4]
  db 0xAC                      ; 00000602  lodsb
  db 0xBF, 0xDA, 0x6F          ; 00000603  mov di,0x6fda
  db 0xE8, 0x87, 0x00          ; 00000606  call 0x690
  db 0xB9, 0x14, 0x00          ; 00000609  mov cx,0x14
  db 0xB0, 0x20                ; 0000060C  mov al,0x20
  db 0xF3, 0xAB                ; 0000060E  rep stosw
  db 0x5F                      ; 00000610  pop di
  db 0x2E, 0x8B, 0x1E, 0x1B, 0x2D ; 00000611  mov bx,[cs:0x2d1b]
  db 0x8B, 0x75, 0xFA          ; 00000616  mov si,[di-0x6]
  db 0x8A, 0x18                ; 00000619  mov bl,[bx+si]
  db 0x32, 0xFF                ; 0000061B  xor bh,bh
  db 0xD1, 0xE3                ; 0000061D  shl bx,1
  db 0x5E                      ; 0000061F  pop si
  db 0xEB, 0x02                ; 00000620  jmp short 0x624
  db 0x33, 0xDB                ; 00000622  xor bx,bx
  db 0x8B, 0x01                ; 00000624  mov ax,[bx+di]
  db 0x0B, 0xC0                ; 00000626  or ax,ax
  db 0x74, 0xF8                ; 00000628  jz 0x622
  db 0x56                      ; 0000062A  push si
  db 0x57                      ; 0000062B  push di
  db 0x8B, 0xF0                ; 0000062C  mov si,ax
  db 0x8A, 0x45, 0xF9          ; 0000062E  mov al,[di-0x7]
  db 0xBF, 0x0C, 0x70          ; 00000631  mov di,0x700c
  db 0xE8, 0x59, 0x00          ; 00000634  call 0x690
  db 0xB9, 0x08, 0x00          ; 00000637  mov cx,0x8
  db 0xB0, 0x20                ; 0000063A  mov al,0x20
  db 0xF3, 0xAB                ; 0000063C  rep stosw
  db 0x2E, 0x8B, 0x16, 0x41, 0x10 ; 0000063E  mov dx,[cs:0x1041]
  db 0x53                      ; 00000643  push bx
  db 0x8E, 0xC5                ; 00000644  mov es,bp
  db 0xE8, 0xE8, 0xFA          ; 00000646  call 0x131
  db 0x8C, 0xC5                ; 00000649  mov bp,es
  db 0x1E                      ; 0000064B  push ds
  db 0x07                      ; 0000064C  pop es
  db 0x5B                      ; 0000064D  pop bx
  db 0x5F                      ; 0000064E  pop di
  db 0x5E                      ; 0000064F  pop si
  db 0x2E, 0xA1, 0x3E, 0x10    ; 00000650  mov ax,[cs:0x103e]
  db 0x3D, 0x7D, 0xFF          ; 00000654  cmp ax,0xff7d
  db 0x74, 0x1A                ; 00000657  jz 0x673
  db 0x3D, 0x1B, 0x00          ; 00000659  cmp ax,0x1b
  db 0x74, 0x99                ; 0000065C  jz 0x5f7
  db 0x3D, 0x0D, 0x00          ; 0000065E  cmp ax,0xd
  db 0x74, 0x0A                ; 00000661  jz 0x66d
  db 0x3D, 0x20, 0x00          ; 00000663  cmp ax,0x20
  db 0x75, 0xBC                ; 00000666  jnz 0x624
  db 0x43                      ; 00000668  inc bx
  db 0x43                      ; 00000669  inc bx
  db 0xE9, 0xB7, 0xFF          ; 0000066A  jmp 0x624
  db 0xE8, 0x12, 0x00          ; 0000066D  call 0x682
  db 0xE9, 0x84, 0xFF          ; 00000670  jmp 0x5f7
  db 0xE8, 0x0C, 0x00          ; 00000673  call 0x682
  db 0x8E, 0xC5                ; 00000676  mov es,bp
  db 0xB9, 0xFF, 0xFF          ; 00000678  mov cx,0xffff
  db 0xE8, 0x8D, 0x0E          ; 0000067B  call 0x150b
  db 0x59                      ; 0000067E  pop cx
  db 0xE9, 0x97, 0xFE          ; 0000067F  jmp 0x519
  db 0xD1, 0xEB                ; 00000682  shr bx,1
  db 0x93                      ; 00000684  xchg ax,bx
  db 0x56                      ; 00000685  push si
  db 0x2E, 0x8B, 0x1E, 0x1B, 0x2D ; 00000686  mov bx,[cs:0x2d1b]
  db 0xFF, 0x55, 0xFE          ; 0000068B  call [di-0x2]
  db 0x5E                      ; 0000068E  pop si
  db 0xC3                      ; 0000068F  ret
  db 0x98                      ; 00000690  cbw
  db 0x91                      ; 00000691  xchg ax,cx
  db 0xB4, 0x08                ; 00000692  mov ah,0x8
  db 0xAC                      ; 00000694  lodsb
  db 0xAB                      ; 00000695  stosw
  db 0xE2, 0xFC                ; 00000696  loop 0x694
  db 0xC3                      ; 00000698  ret
  db 0x88, 0x47, 0x74          ; 00000699  mov [bx+0x74],al
  db 0xE9, 0x53, 0x1A          ; 0000069C  jmp 0x20f2
  db 0x8A, 0xE8                ; 0000069F  mov ch,al
  db 0xB1, 0x0A                ; 000006A1  mov cl,0xa
  db 0x89, 0x4F, 0x72          ; 000006A3  mov [bx+0x72],cx
  db 0xE9, 0x49, 0x1A          ; 000006A6  jmp 0x20f2
  db 0x88, 0x47, 0x71          ; 000006A9  mov [bx+0x71],al
  db 0x2E, 0xA2, 0x95, 0x2F    ; 000006AC  mov [cs:0x2f95],al
  db 0xC3                      ; 000006B0  ret
  db 0x88, 0x47, 0x7F          ; 000006B1  mov [bx+0x7f],al
  db 0xC3                      ; 000006B4  ret
  db 0x53                      ; 000006B5  push bx
  db 0x51                      ; 000006B6  push cx
  db 0x32, 0xE4                ; 000006B7  xor ah,ah
  db 0xBB, 0x2E, 0x2D          ; 000006B9  mov bx,0x2d2e
  db 0x88, 0x87, 0x83, 0x00    ; 000006BC  mov [bx+0x83],al
  db 0xBB, 0xC2, 0x2D          ; 000006C0  mov bx,0x2dc2
  db 0x88, 0x87, 0x83, 0x00    ; 000006C3  mov [bx+0x83],al
  db 0xBB, 0x56, 0x2E          ; 000006C7  mov bx,0x2e56
  db 0x88, 0x87, 0x83, 0x00    ; 000006CA  mov [bx+0x83],al
  db 0xBB, 0xEA, 0x2E          ; 000006CE  mov bx,0x2eea
  db 0x88, 0x87, 0x83, 0x00    ; 000006D1  mov [bx+0x83],al
  db 0x8B, 0xD8                ; 000006D5  mov bx,ax
  db 0xB1, 0x04                ; 000006D7  mov cl,0x4
  db 0xD3, 0xE3                ; 000006D9  shl bx,cl
  db 0x2B, 0xD8                ; 000006DB  sub bx,ax
  db 0xB1, 0x02                ; 000006DD  mov cl,0x2
  db 0xD3, 0xE3                ; 000006DF  shl bx,cl
  db 0x2E, 0x89, 0x1E, 0x1F, 0x2C ; 000006E1  mov [cs:0x2c1f],bx
  db 0x2E, 0x89, 0x1E, 0x21, 0x2C ; 000006E6  mov [cs:0x2c21],bx
  db 0x59                      ; 000006EB  pop cx
  db 0x5B                      ; 000006EC  pop bx
  db 0xC3                      ; 000006ED  ret
  db 0x0E                      ; 000006EE  push cs
  db 0x13, 0x01                ; 000006EF  adc ax,[bx+di]
  db 0x13, 0x2B                ; 000006F1  adc bp,[bp+di]
  db 0x13, 0x51, 0x13          ; 000006F3  adc dx,[bx+di+0x13]
  db 0x38, 0x13                ; 000006F6  cmp [bp+di],dl
  db 0x00, 0x00                ; 000006F8  add [bx+si],al
  db 0x04, 0x74                ; 000006FA  add al,0x74
  db 0x00, 0x4D, 0x4B          ; 000006FC  add [di+0x4b],cl
  db 0x99                      ; 000006FF  cwd
  db 0x12, 0xCA                ; 00000700  adc cl,dl
  db 0x4B                      ; 00000702  dec bx
  db 0xCE                      ; 00000703  into
  db 0x4B                      ; 00000704  dec bx
  db 0x00, 0x00                ; 00000705  add [bx+si],al
  db 0x02, 0x73, 0x00          ; 00000707  add dh,[bp+di+0x0]
  db 0x5A                      ; 0000070A  pop dx
  db 0x4B                      ; 0000070B  dec bx
  db 0x9F                      ; 0000070C  lahf
  db 0x12, 0x85, 0x13, 0x83    ; 0000070D  adc al,[di-0x7ced]
  db 0x13, 0x81, 0x13, 0x7F    ; 00000711  adc ax,[bx+di+0x7f13]
  db 0x13, 0x7D, 0x13          ; 00000715  adc di,[di+0x13]
  db 0x7B, 0x13                ; 00000718  jpo 0x72d
  db 0x79, 0x13                ; 0000071A  jns 0x72f
  db 0x77, 0x13                ; 0000071C  ja 0x731
  db 0x75, 0x13                ; 0000071E  jnz 0x733
  db 0x73, 0x13                ; 00000720  jnc 0x735
  db 0x00, 0x00                ; 00000722  add [bx+si],al
  db 0x04, 0x71                ; 00000724  add al,0x71
  db 0x00, 0x67, 0x4B          ; 00000726  add [bx+0x4b],ah
  db 0xA9, 0x12, 0xCA          ; 00000729  test ax,0xca12
  db 0x4B                      ; 0000072C  dec bx
  db 0xCE                      ; 0000072D  into
  db 0x4B                      ; 0000072E  dec bx
  db 0x00, 0x00                ; 0000072F  add [bx+si],al
  db 0x07                      ; 00000731  pop es
  db 0x7F, 0x00                ; 00000732  jg 0x734
  db 0x74, 0x4B                ; 00000734  jz 0x781
  db 0xB1, 0x12                ; 00000736  mov cl,0x12
  db 0x92                      ; 00000738  xchg ax,dx
  db 0x4B                      ; 00000739  dec bx
  db 0x99                      ; 0000073A  cwd
  db 0x4B                      ; 0000073B  dec bx
  db 0xA0, 0x4B, 0xA7          ; 0000073C  mov al,[0xa74b]
  db 0x4B                      ; 0000073F  dec bx
  db 0xAE                      ; 00000740  scasb
  db 0x4B                      ; 00000741  dec bx
  db 0xB5, 0x4B                ; 00000742  mov ch,0x4b
  db 0xBC, 0x4B, 0xC3          ; 00000744  mov sp,0xc34b
  db 0x4B                      ; 00000747  dec bx
  db 0x00, 0x00                ; 00000748  add [bx+si],al
  db 0x02, 0x83, 0x00, 0x83    ; 0000074A  add al,[bp+di-0x7d00]
  db 0x4B                      ; 0000074E  dec bx
  db 0xB5, 0x12                ; 0000074F  mov ch,0x12
  db 0x91                      ; 00000751  xchg ax,cx
  db 0x13, 0x73, 0x13          ; 00000752  adc si,[bp+di+0x13]
  db 0x75, 0x13                ; 00000755  jnz 0x76a
  db 0x77, 0x13                ; 00000757  ja 0x76c
  db 0x79, 0x13                ; 00000759  jns 0x76e
  db 0x7B, 0x13                ; 0000075B  jpo 0x770
  db 0x7D, 0x13                ; 0000075D  jnl 0x772
  db 0x7F, 0x13                ; 0000075F  jg 0x774
  db 0x81, 0x13, 0x83, 0x13    ; 00000761  adc word [bp+di],0x1383
  db 0x85, 0x13                ; 00000765  test [bp+di],dx
  db 0x87, 0x13                ; 00000767  xchg dx,[bp+di]
  db 0x89, 0x13                ; 00000769  mov [bp+di],dx
  db 0x8B, 0x13                ; 0000076B  mov dx,[bp+di]
  db 0x8D, 0x13                ; 0000076D  lea dx,[bp+di]
  db 0x8F                      ; 0000076F  db 0x8f
  db 0x13, 0x00                ; 00000770  adc ax,[bx+si]
  db 0x00, 0x31                ; 00000772  add [bx+di],dh
  db 0x20, 0x32                ; 00000774  and [bp+si],dh
  db 0x20, 0x33                ; 00000776  and [bp+di],dh
  db 0x20, 0x34                ; 00000778  and [si],dh
  db 0x20, 0x35                ; 0000077A  and [di],dh
  db 0x20, 0x36, 0x20, 0x37    ; 0000077C  and [0x3720],dh
  db 0x20, 0x38                ; 00000780  and [bx+si],bh
  db 0x20, 0x39                ; 00000782  and [bx+di],bh
  db 0x20, 0x31                ; 00000784  and [bx+di],dh
  db 0x30, 0x31                ; 00000786  xor [bx+di],dh
  db 0x31, 0x31                ; 00000788  xor [bx+di],si
  db 0x32, 0x31                ; 0000078A  xor dh,[bx+di]
  db 0x33, 0x31                ; 0000078C  xor si,[bx+di]
  db 0x34, 0x31                ; 0000078E  xor al,0x31
  db 0x35, 0x9B, 0x20          ; 00000790  xor ax,0x209b
  db 0xF6, 0x47, 0x6B, 0x04    ; 00000793  test byte [bx+0x6b],0x4
  db 0x74, 0x03                ; 00000797  jz 0x79c
  db 0xE9, 0x85, 0xFD          ; 00000799  jmp 0x521
  db 0x8B, 0x5F, 0x5C          ; 0000079C  mov bx,[bx+0x5c]
  db 0x8B, 0x37                ; 0000079F  mov si,[bx]
  db 0x8A, 0x54, 0x24          ; 000007A1  mov dl,[si+0x24]
  db 0x52                      ; 000007A4  push dx
  db 0xB1, 0xA0                ; 000007A5  mov cl,0xa0
  db 0xE8, 0x89, 0xF9          ; 000007A7  call 0x133
  db 0xB1, 0xA1                ; 000007AA  mov cl,0xa1
  db 0xE8, 0x84, 0xF9          ; 000007AC  call 0x133
  db 0x5A                      ; 000007AF  pop dx
  db 0xBE, 0x3E, 0x4D          ; 000007B0  mov si,0x4d3e
  db 0x0B, 0xC0                ; 000007B3  or ax,ax
  db 0x75, 0x49                ; 000007B5  jnz 0x800
  db 0x52                      ; 000007B7  push dx
  db 0xE8, 0x62, 0x31          ; 000007B8  call 0x391d
  db 0x5A                      ; 000007BB  pop dx
  db 0xBE, 0x28, 0x4D          ; 000007BC  mov si,0x4d28
  db 0x0A, 0xC0                ; 000007BF  or al,al
  db 0x74, 0x3D                ; 000007C1  jz 0x800
  db 0xB1, 0x0C                ; 000007C3  mov cl,0xc
  db 0xE8, 0x67, 0x00          ; 000007C5  call 0x82f
  db 0x2E, 0x8B, 0x1E, 0x1B, 0x2D ; 000007C8  mov bx,[cs:0x2d1b]
  db 0x8B, 0x4F, 0x48          ; 000007CD  mov cx,[bx+0x48]
  db 0x2E, 0xF6, 0x06, 0x1D, 0x2D, 0xFF ; 000007D0  test byte [cs:0x2d1d],0xff
  db 0x75, 0x06                ; 000007D6  jnz 0x7de
  db 0xBB, 0x4A, 0x70          ; 000007D8  mov bx,0x704a
  db 0xB9, 0x18, 0x00          ; 000007DB  mov cx,0x18
  db 0x8B, 0x37                ; 000007DE  mov si,[bx]
  db 0x53                      ; 000007E0  push bx
  db 0x51                      ; 000007E1  push cx
  db 0x1E                      ; 000007E2  push ds
  db 0x2E, 0x8E, 0x1E, 0x7E, 0x2F ; 000007E3  mov ds,[cs:0x2f7e]
  db 0xE8, 0x1A, 0x00          ; 000007E8  call 0x805
  db 0x1F                      ; 000007EB  pop ds
  db 0x59                      ; 000007EC  pop cx
  db 0x5B                      ; 000007ED  pop bx
  db 0x43                      ; 000007EE  inc bx
  db 0x43                      ; 000007EF  inc bx
  db 0xE2, 0xEC                ; 000007F0  loop 0x7de
  db 0xBE, 0x9E, 0x6F          ; 000007F2  mov si,0x6f9e
  db 0xE8, 0x0D, 0x00          ; 000007F5  call 0x805
  db 0xB1, 0x9F                ; 000007F8  mov cl,0x9f
  db 0xE8, 0x36, 0xF9          ; 000007FA  call 0x133
  db 0xE9, 0x21, 0xFD          ; 000007FD  jmp 0x521
  db 0xE8, 0x98, 0x0E          ; 00000800  call 0x169b
  db 0xEB, 0xF3                ; 00000803  jmp short 0x7f8
  db 0xB9, 0x51, 0x00          ; 00000805  mov cx,0x51
  db 0x8B, 0xDE                ; 00000808  mov bx,si
  db 0x81, 0xC3, 0xA0, 0x00    ; 0000080A  add bx,0xa0
  db 0x49                      ; 0000080E  dec cx
  db 0x74, 0x13                ; 0000080F  jz 0x824
  db 0x4B                      ; 00000811  dec bx
  db 0x4B                      ; 00000812  dec bx
  db 0x80, 0x3F, 0x20          ; 00000813  cmp byte [bx],0x20
  db 0x74, 0xF6                ; 00000816  jz 0x80e
  db 0xAD                      ; 00000818  lodsw
  db 0x51                      ; 00000819  push cx
  db 0x56                      ; 0000081A  push si
  db 0x8A, 0xC8                ; 0000081B  mov cl,al
  db 0xE8, 0x0F, 0x00          ; 0000081D  call 0x82f
  db 0x5E                      ; 00000820  pop si
  db 0x59                      ; 00000821  pop cx
  db 0xE2, 0xF4                ; 00000822  loop 0x818
  db 0xB1, 0x0D                ; 00000824  mov cl,0xd
  db 0xE8, 0x06, 0x00          ; 00000826  call 0x82f
  db 0xB1, 0x0A                ; 00000829  mov cl,0xa
  db 0xE8, 0x01, 0x00          ; 0000082B  call 0x82f
  db 0xC3                      ; 0000082E  ret
  db 0xF6, 0xC1, 0x80          ; 0000082F  test cl,0x80
  db 0x74, 0x10                ; 00000832  jz 0x844
  db 0x80, 0xFA, 0x01          ; 00000834  cmp dl,0x1
  db 0x74, 0x09                ; 00000837  jz 0x842
  db 0xBB, 0xE3, 0x45          ; 00000839  mov bx,0x45e3
  db 0x2E, 0x84, 0x4F, 0x1C    ; 0000083C  test [cs:bx+0x1c],cl
  db 0x74, 0x02                ; 00000840  jz 0x844
  db 0xB1, 0x20                ; 00000842  mov cl,0x20
  db 0x52                      ; 00000844  push dx
  db 0x1E                      ; 00000845  push ds
  db 0x2E, 0x8E, 0x1E, 0x06, 0x0C ; 00000846  mov ds,[cs:0xc06]
  db 0xE8, 0xFE, 0x2F          ; 0000084B  call 0x384c
  db 0x1F                      ; 0000084E  pop ds
  db 0x5A                      ; 0000084F  pop dx
  db 0xC3                      ; 00000850  ret
  db 0x32, 0xE4                ; 00000851  xor ah,ah
  db 0x2E, 0xA0, 0x43, 0x10    ; 00000853  mov al,[cs:0x1043]
  db 0x80, 0xF9, 0xFE          ; 00000857  cmp cl,0xfe
  db 0x74, 0x16                ; 0000085A  jz 0x872
  db 0x72, 0x04                ; 0000085C  jc 0x862
  db 0x84, 0xC0                ; 0000085E  test al,al
  db 0x74, 0x10                ; 00000860  jz 0x872
  db 0xBA, 0x18, 0x00          ; 00000862  mov dx,0x18
  db 0xE8, 0xC9, 0xF8          ; 00000865  call 0x131
  db 0x2E, 0xC6, 0x06, 0x43, 0x10, 0x00 ; 00000868  mov byte [cs:0x1043],0x0
  db 0x2E, 0xA1, 0x3E, 0x10    ; 0000086E  mov ax,[cs:0x103e]
  db 0xC3                      ; 00000872  ret
  db 0x80, 0xFA, 0x04          ; 00000873  cmp dl,0x4
  db 0x72, 0x03                ; 00000876  jc 0x87b
  db 0xE9, 0x37, 0x2C          ; 00000878  jmp 0x34b2
  db 0x06                      ; 0000087B  push es
  db 0x1E                      ; 0000087C  push ds
  db 0x07                      ; 0000087D  pop es
  db 0x32, 0xF6                ; 0000087E  xor dh,dh
  db 0x8B, 0xDA                ; 00000880  mov bx,dx
  db 0xD1, 0xE3                ; 00000882  shl bx,1
  db 0x2E, 0x8B, 0x9F, 0x80, 0x2F ; 00000884  mov bx,[cs:bx+0x2f80]
  db 0xFF, 0x57, 0x5E          ; 00000889  call [bx+0x5e]
  db 0x2E, 0xA1, 0x1F, 0x2C    ; 0000088C  mov ax,[cs:0x2c1f]
  db 0x2E, 0xA3, 0x21, 0x2C    ; 00000890  mov [cs:0x2c21],ax
  db 0x07                      ; 00000894  pop es
  db 0xC3                      ; 00000895  ret
  db 0x80, 0xF9, 0x20          ; 00000896  cmp cl,0x20
  db 0x73, 0x5F                ; 00000899  jnc 0x8fa
  db 0x80, 0xF9, 0x00          ; 0000089B  cmp cl,0x0
  db 0x75, 0x01                ; 0000089E  jnz 0x8a1
  db 0xC3                      ; 000008A0  ret
  db 0x80, 0xF9, 0x0D          ; 000008A1  cmp cl,0xd
  db 0x75, 0x03                ; 000008A4  jnz 0x8a9
  db 0xE9, 0xCF, 0x05          ; 000008A6  jmp 0xe78
  db 0x80, 0xF9, 0x0A          ; 000008A9  cmp cl,0xa
  db 0x75, 0x15                ; 000008AC  jnz 0x8c3
  db 0xF6, 0x47, 0x6B, 0x04    ; 000008AE  test byte [bx+0x6b],0x4
  db 0x75, 0x06                ; 000008B2  jnz 0x8ba
  db 0xE8, 0x90, 0x05          ; 000008B4  call 0xe47
  db 0xE9, 0xC3, 0x05          ; 000008B7  jmp 0xe7d
  db 0xE8, 0x41, 0x0A          ; 000008BA  call 0x12fe
  db 0xE8, 0x87, 0x05          ; 000008BD  call 0xe47
  db 0xE9, 0x7C, 0x0A          ; 000008C0  jmp 0x133f
  db 0x80, 0xF9, 0x08          ; 000008C3  cmp cl,0x8
  db 0x75, 0x16                ; 000008C6  jnz 0x8de
  db 0xFF, 0x4F, 0x66          ; 000008C8  dec word [bx+0x66]
  db 0x79, 0x0E                ; 000008CB  jns 0x8db
  db 0x8B, 0x47, 0x60          ; 000008CD  mov ax,[bx+0x60]
  db 0x89, 0x47, 0x66          ; 000008D0  mov [bx+0x66],ax
  db 0xFF, 0x4F, 0x64          ; 000008D3  dec word [bx+0x64]
  db 0x79, 0x03                ; 000008D6  jns 0x8db
  db 0xE9, 0x98, 0x05          ; 000008D8  jmp 0xe73
  db 0xE9, 0x9F, 0x05          ; 000008DB  jmp 0xe7d
  db 0x80, 0xF9, 0x1B          ; 000008DE  cmp cl,0x1b
  db 0x75, 0x06                ; 000008E1  jnz 0x8e9
  db 0xC7, 0x47, 0x5E, 0xB5, 0x15 ; 000008E3  mov word [bx+0x5e],0x15b5
  db 0xC3                      ; 000008E8  ret
  db 0x80, 0xF9, 0x07          ; 000008E9  cmp cl,0x7
  db 0x75, 0x0C                ; 000008EC  jnz 0x8fa
  db 0xF6, 0x47, 0x6B, 0x02    ; 000008EE  test byte [bx+0x6b],0x2
  db 0x75, 0x05                ; 000008F2  jnz 0x8f9
  db 0x2E, 0xFE, 0x06, 0xB1, 0x10 ; 000008F4  inc byte [cs:0x10b1]
  db 0xC3                      ; 000008F9  ret
  db 0xF6, 0x47, 0x6B, 0x04    ; 000008FA  test byte [bx+0x6b],0x4
  db 0x75, 0x6F                ; 000008FE  jnz 0x96f
  db 0xF6, 0x47, 0x6B, 0x08    ; 00000900  test byte [bx+0x6b],0x8
  db 0x74, 0x03                ; 00000904  jz 0x909
  db 0xE8, 0x1B, 0x03          ; 00000906  call 0xc24
  db 0xF7, 0x47, 0x6B, 0x00, 0x10 ; 00000909  test word [bx+0x6b],0x1000
  db 0x74, 0x02                ; 0000090E  jz 0x912
  db 0xB1, 0x20                ; 00000910  mov cl,0x20
  db 0x8B, 0x7F, 0x62          ; 00000912  mov di,[bx+0x62]
  db 0x8A, 0x6F, 0x6A          ; 00000915  mov ch,[bx+0x6a]
  db 0x06                      ; 00000918  push es
  db 0x2E, 0x8E, 0x06, 0x7E, 0x2F ; 00000919  mov es,[cs:0x2f7e]
  db 0x26, 0x89, 0x0D          ; 0000091E  mov [es:di],cx
  db 0x2E, 0xF6, 0x06, 0x1D, 0x2D, 0xFF ; 00000921  test byte [cs:0x2d1d],0xff
  db 0x75, 0x3F                ; 00000927  jnz 0x968
  db 0xE8, 0xF0, 0x11          ; 00000929  call 0x1b1c
  db 0x8A, 0x77, 0x64          ; 0000092C  mov dh,[bx+0x64]
  db 0x8A, 0x57, 0x66          ; 0000092F  mov dl,[bx+0x66]
  db 0xE8, 0x1F, 0x13          ; 00000932  call 0x1c54
  db 0x03, 0x47, 0x46          ; 00000935  add ax,[bx+0x46]
  db 0x96                      ; 00000938  xchg ax,si
  db 0xE8, 0xB2, 0x11          ; 00000939  call 0x1aee
  db 0x72, 0x26                ; 0000093C  jc 0x964
  db 0x2E, 0x8A, 0x84, 0x9F, 0x4F ; 0000093E  mov al,[cs:si+0x4f9f]
  db 0xE8, 0x1B, 0x13          ; 00000943  call 0x1c61
  db 0x3A, 0x47, 0x34          ; 00000946  cmp al,[bx+0x34]
  db 0x75, 0x19                ; 00000949  jnz 0x964
  db 0xD1, 0xE6                ; 0000094B  shl si,1
  db 0xF6, 0x47, 0x6B, 0x02    ; 0000094D  test byte [bx+0x6b],0x2
  db 0x74, 0x0E                ; 00000951  jz 0x961
  db 0x2E, 0x80, 0x3E, 0x88, 0x2F, 0xFF ; 00000953  cmp byte [cs:0x2f88],0xff
  db 0x75, 0x06                ; 00000959  jnz 0x961
  db 0x80, 0xE5, 0x87          ; 0000095B  and ch,0x87
  db 0x80, 0xCD, 0x08          ; 0000095E  or ch,0x8
  db 0x26, 0x89, 0x0C          ; 00000961  mov [es:si],cx
  db 0xC6, 0x47, 0x35, 0x00    ; 00000964  mov byte [bx+0x35],0x0
  db 0x07                      ; 00000968  pop es
  db 0xE8, 0x12, 0x00          ; 00000969  call 0x97e
  db 0xE9, 0x28, 0x05          ; 0000096C  jmp 0xe97
  db 0x8B, 0x47, 0x64          ; 0000096F  mov ax,[bx+0x64]
  db 0x8B, 0x57, 0x66          ; 00000972  mov dx,[bx+0x66]
  db 0xE8, 0xB7, 0x08          ; 00000975  call 0x122f
  db 0xE8, 0x03, 0x00          ; 00000978  call 0x97e
  db 0xE9, 0xC1, 0x09          ; 0000097B  jmp 0x133f
  db 0x83, 0x47, 0x62, 0x02    ; 0000097E  add word [bx+0x62],byte +0x2
  db 0x8B, 0x47, 0x66          ; 00000982  mov ax,[bx+0x66]
  db 0x40                      ; 00000985  inc ax
  db 0x3A, 0x47, 0x4D          ; 00000986  cmp al,[bx+0x4d]
  db 0x72, 0x1B                ; 00000989  jc 0x9a6
  db 0x83, 0x6F, 0x62, 0x02    ; 0000098B  sub word [bx+0x62],byte +0x2
  db 0x48                      ; 0000098F  dec ax
  db 0xF7, 0x47, 0x6B, 0x00, 0x01 ; 00000990  test word [bx+0x6b],0x100
  db 0x75, 0x0F                ; 00000995  jnz 0x9a6
  db 0xE8, 0xAD, 0x04          ; 00000997  call 0xe47
  db 0x8B, 0x77, 0x64          ; 0000099A  mov si,[bx+0x64]
  db 0xD1, 0xE6                ; 0000099D  shl si,1
  db 0x8B, 0x30                ; 0000099F  mov si,[bx+si]
  db 0x89, 0x77, 0x62          ; 000009A1  mov [bx+0x62],si
  db 0x33, 0xC0                ; 000009A4  xor ax,ax
  db 0x89, 0x47, 0x66          ; 000009A6  mov [bx+0x66],ax
  db 0xC3                      ; 000009A9  ret
  db 0xE8, 0x41, 0x16          ; 000009AA  call 0x1fee
  db 0xC7, 0x47, 0x5E, 0x96, 0x14 ; 000009AD  mov word [bx+0x5e],0x1496
  db 0xE9, 0xE1, 0xFE          ; 000009B2  jmp 0x896
  db 0xC7, 0x47, 0x5E, 0x96, 0x14 ; 000009B5  mov word [bx+0x5e],0x1496
  db 0xBF, 0x3E, 0x16          ; 000009BA  mov di,0x163e
  db 0x8A, 0xC1                ; 000009BD  mov al,cl
  db 0xE8, 0x61, 0x0A          ; 000009BF  call 0x1423
  db 0x8C, 0x19                ; 000009C2  mov [bx+di],ds
  db 0x74, 0x19                ; 000009C4  jz 0x9df
  db 0x6C                      ; 000009C6  insb
  db 0x19, 0x66, 0x19          ; 000009C7  sbb [bp+0x19],sp
  db 0x60                      ; 000009CA  pusha
  db 0x19, 0x59, 0x19          ; 000009CB  sbb [bx+di+0x19],bx
  db 0x52                      ; 000009CE  push dx
  db 0x19, 0x4D, 0x19          ; 000009CF  sbb [di+0x19],cx
  db 0x48                      ; 000009D2  dec ax
  db 0x19, 0x42, 0x19          ; 000009D3  sbb [bp+si+0x19],ax
  db 0x3D, 0x19, 0x38          ; 000009D6  cmp ax,0x3819
  db 0x19, 0x66, 0x19          ; 000009D9  sbb [bp+0x19],sp
  db 0x60                      ; 000009DC  pusha
  db 0x19, 0x15                ; 000009DD  sbb [di],dx
  db 0x19, 0x04                ; 000009DF  sbb [si],ax
  db 0x19, 0xCD                ; 000009E1  sbb bp,cx
  db 0x18, 0xB6, 0x18, 0xAB    ; 000009E3  sbb [bp-0x54e8],dh
  db 0x18, 0xA4, 0x18, 0x86    ; 000009E7  sbb [si-0x79e8],ah
  db 0x19, 0xEA                ; 000009EB  sbb dx,bp
  db 0x17                      ; 000009ED  pop ss
  db 0xE4, 0x17                ; 000009EE  in al,0x17
  db 0x9E                      ; 000009F0  sahf
  db 0x18, 0x98, 0x18, 0x0B    ; 000009F1  sbb [bx+si+0xb18],bl
  db 0x18, 0x03                ; 000009F5  sbb [bp+di],al
  db 0x18, 0xD9                ; 000009F7  sbb cl,bl
  db 0x17                      ; 000009F9  pop ss
  db 0xD4, 0x17                ; 000009FA  aam 0x17
  db 0xC8, 0x17, 0xC1, 0x17    ; 000009FC  enter 0xc117,0x17
  db 0x65, 0x17                ; 00000A00  gs pop ss
  db 0x7C, 0x17                ; 00000A02  jl 0xa1b
  db 0x6D                      ; 00000A04  insw
  db 0x17                      ; 00000A05  pop ss
  db 0xB1, 0x17                ; 00000A06  mov cl,0x17
  db 0xA3, 0x17, 0x99          ; 00000A08  mov [0x9917],ax
  db 0x17                      ; 00000A0B  pop ss
  db 0xDE, 0x17                ; 00000A0C  ficom word [bx]
  db 0xBC, 0x17, 0xB7          ; 00000A0E  mov sp,0xb717
  db 0x17                      ; 00000A11  pop ss
  db 0x7C, 0x17                ; 00000A12  jl 0xa2b
  db 0x6D                      ; 00000A14  insw
  db 0x17                      ; 00000A15  pop ss
  db 0x59                      ; 00000A16  pop cx
  db 0x17                      ; 00000A17  pop ss
  db 0x53                      ; 00000A18  push bx
  db 0x17                      ; 00000A19  pop ss
  db 0x4D                      ; 00000A1A  dec bp
  db 0x17                      ; 00000A1B  pop ss
  db 0x47                      ; 00000A1C  inc di
  db 0x17                      ; 00000A1D  pop ss
  db 0x80, 0x19, 0x42          ; 00000A1E  sbb byte [bx+di],0x42
  db 0x17                      ; 00000A21  pop ss
  db 0x3D, 0x17, 0xF9          ; 00000A22  cmp ax,0xf917
  db 0x16                      ; 00000A25  push ss
  db 0x14, 0x17                ; 00000A26  adc al,0x17
  db 0xEA, 0x16, 0xDB, 0x16, 0xD2 ; 00000A28  jmp 0xd216:0xdb16
  db 0x16                      ; 00000A2D  push ss
  db 0xC3                      ; 00000A2E  ret
  db 0x16                      ; 00000A2F  push ss
  db 0xA3, 0x16, 0xB0          ; 00000A30  mov [0xb016],ax
  db 0x16                      ; 00000A33  push ss
  db 0x9A, 0x16, 0x97, 0x16, 0x8E ; 00000A34  call 0x8e16:0x9716
  db 0x16                      ; 00000A39  push ss
  db 0x7F, 0x16                ; 00000A3A  jg 0xa52
  db 0x7C, 0x16                ; 00000A3C  jl 0xa54
  db 0x3D, 0x48, 0x43          ; 00000A3E  cmp ax,0x4348
  db 0x44                      ; 00000A41  inc sp
  db 0x42                      ; 00000A42  inc dx
  db 0x41                      ; 00000A43  inc cx
  db 0x45                      ; 00000A44  inc bp
  db 0x49                      ; 00000A45  dec cx
  db 0x4A                      ; 00000A46  dec dx
  db 0x4B                      ; 00000A47  dec bx
  db 0x4C                      ; 00000A48  dec sp
  db 0x4D                      ; 00000A49  dec bp
  db 0x4E                      ; 00000A4A  dec si
  db 0x4F                      ; 00000A4B  dec di
  db 0x50                      ; 00000A4C  push ax
  db 0x51                      ; 00000A4D  push cx
  db 0x59                      ; 00000A4E  pop cx
  db 0x61                      ; 00000A4F  popa
  db 0x62, 0x63, 0x64          ; 00000A50  bound sp,[bp+di+0x64]
  db 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C ; 00000A53  gs push dword 0x6c6b6a69
  db 0x6D                      ; 00000A5B  insw
  db 0x6E                      ; 00000A5C  outsb
  db 0x6F                      ; 00000A5D  outsw
  db 0x70, 0x71                ; 00000A5E  jo 0xad1
  db 0x73, 0x74                ; 00000A60  jnc 0xad6
  db 0x72, 0x75                ; 00000A62  jc 0xad9
  db 0x76, 0x77                ; 00000A64  jna 0xadd
  db 0x78, 0x7A                ; 00000A66  js 0xae2
  db 0x3A, 0x3C                ; 00000A68  cmp bh,[si]
  db 0x3E, 0x30, 0x31          ; 00000A6A  xor [ds:bx+di],dh
  db 0x32, 0x33                ; 00000A6D  xor dh,[bp+di]
  db 0x36, 0x37                ; 00000A6F  ss aaa
  db 0xF1                      ; 00000A71  int1
  db 0xF2, 0xF3, 0xF4          ; 00000A72  rep hlt
  db 0xF5                      ; 00000A75  cmc
  db 0xF6, 0xF7                ; 00000A76  div bh
  db 0xFB                      ; 00000A78  sti
  db 0xFC                      ; 00000A79  cld
  db 0xFD                      ; 00000A7A  std
  db 0xFE                      ; 00000A7B  db 0xfe
  db 0xE9, 0xF4, 0x03          ; 00000A7C  jmp 0xe73
  db 0x8B, 0x57, 0x66          ; 00000A7F  mov dx,[bx+0x66]
  db 0x3B, 0x57, 0x60          ; 00000A82  cmp dx,[bx+0x60]
  db 0x74, 0x26                ; 00000A85  jz 0xaad
  db 0x42                      ; 00000A87  inc dx
  db 0x89, 0x57, 0x66          ; 00000A88  mov [bx+0x66],dx
  db 0xE9, 0xEF, 0x03          ; 00000A8B  jmp 0xe7d
  db 0xFF, 0x4F, 0x66          ; 00000A8E  dec word [bx+0x66]
  db 0x79, 0x1A                ; 00000A91  jns 0xaad
  db 0xFF, 0x47, 0x66          ; 00000A93  inc word [bx+0x66]
  db 0xC3                      ; 00000A96  ret
  db 0xE9, 0xCA, 0x03          ; 00000A97  jmp 0xe64
  db 0xFF, 0x4F, 0x64          ; 00000A9A  dec word [bx+0x64]
  db 0x79, 0x0E                ; 00000A9D  jns 0xaad
  db 0xFF, 0x47, 0x64          ; 00000A9F  inc word [bx+0x64]
  db 0xC3                      ; 00000AA2  ret
  db 0x8B, 0x77, 0x64          ; 00000AA3  mov si,[bx+0x64]
  db 0x85, 0xF6                ; 00000AA6  test si,si
  db 0x75, 0xF0                ; 00000AA8  jnz 0xa9a
  db 0xE8, 0xEC, 0x04          ; 00000AAA  call 0xf99
  db 0xE9, 0xCD, 0x03          ; 00000AAD  jmp 0xe7d
  db 0xF6, 0x47, 0x6B, 0x04    ; 00000AB0  test byte [bx+0x6b],0x4
  db 0x75, 0x0A                ; 00000AB4  jnz 0xac0
  db 0xE8, 0xAD, 0x15          ; 00000AB6  call 0x2066
  db 0x8A, 0x87, 0x80, 0x00    ; 00000AB9  mov al,[bx+0x80]
  db 0xE8, 0x5B, 0x01          ; 00000ABD  call 0xc1b
  db 0xE8, 0xB0, 0x03          ; 00000AC0  call 0xe73
  db 0x8B, 0x77, 0x64          ; 00000AC3  mov si,[bx+0x64]
  db 0x46                      ; 00000AC6  inc si
  db 0x3B, 0x77, 0x48          ; 00000AC7  cmp si,[bx+0x48]
  db 0x74, 0x06                ; 00000ACA  jz 0xad2
  db 0x8B, 0x57, 0x48          ; 00000ACC  mov dx,[bx+0x48]
  db 0xE8, 0x37, 0x04          ; 00000ACF  call 0xf09
  db 0x8B, 0x4F, 0x60          ; 00000AD2  mov cx,[bx+0x60]
  db 0x8B, 0x57, 0x66          ; 00000AD5  mov dx,[bx+0x66]
  db 0xE9, 0xFD, 0x03          ; 00000AD8  jmp 0xed8
  db 0xE8, 0x20, 0x08          ; 00000ADB  call 0x12fe
  db 0x8B, 0x77, 0x64          ; 00000ADE  mov si,[bx+0x64]
  db 0xE8, 0xB5, 0x04          ; 00000AE1  call 0xf99
  db 0xE8, 0xB3, 0xFE          ; 00000AE4  call 0x99a
  db 0xE9, 0xE5, 0x03          ; 00000AE7  jmp 0xecf
  db 0xE8, 0x11, 0x08          ; 00000AEA  call 0x12fe
  db 0x8B, 0x77, 0x64          ; 00000AED  mov si,[bx+0x64]
  db 0xE8, 0x7D, 0x04          ; 00000AF0  call 0xf70
  db 0xE8, 0xA4, 0xFE          ; 00000AF3  call 0x99a
  db 0xE9, 0xD6, 0x03          ; 00000AF6  jmp 0xecf
  db 0xF6, 0x47, 0x6B, 0x04    ; 00000AF9  test byte [bx+0x6b],0x4
  db 0x75, 0x42                ; 00000AFD  jnz 0xb41
  db 0x8B, 0x77, 0x64          ; 00000AFF  mov si,[bx+0x64]
  db 0xD1, 0xE6                ; 00000B02  shl si,1
  db 0x8B, 0x30                ; 00000B04  mov si,[bx+si]
  db 0x8B, 0x47, 0x60          ; 00000B06  mov ax,[bx+0x60]
  db 0xD1, 0xE0                ; 00000B09  shl ax,1
  db 0x03, 0xF0                ; 00000B0B  add si,ax
  db 0x8B, 0xFE                ; 00000B0D  mov di,si
  db 0x4E                      ; 00000B0F  dec si
  db 0x4E                      ; 00000B10  dec si
  db 0xFD                      ; 00000B11  std
  db 0xEB, 0x0D                ; 00000B12  jmp short 0xb21
  db 0xF6, 0x47, 0x6B, 0x04    ; 00000B14  test byte [bx+0x6b],0x4
  db 0x75, 0x27                ; 00000B18  jnz 0xb41
  db 0x8B, 0x77, 0x62          ; 00000B1A  mov si,[bx+0x62]
  db 0x8B, 0xFE                ; 00000B1D  mov di,si
  db 0x46                      ; 00000B1F  inc si
  db 0x46                      ; 00000B20  inc si
  db 0x8B, 0x4F, 0x60          ; 00000B21  mov cx,[bx+0x60]
  db 0x8B, 0x57, 0x66          ; 00000B24  mov dx,[bx+0x66]
  db 0x2B, 0xCA                ; 00000B27  sub cx,dx
  db 0x06                      ; 00000B29  push es
  db 0x2E, 0x8E, 0x06, 0x7E, 0x2F ; 00000B2A  mov es,[cs:0x2f7e]
  db 0xF3, 0x26, 0xA5          ; 00000B2F  es rep movsw
  db 0xB0, 0x20                ; 00000B32  mov al,0x20
  db 0x8A, 0x67, 0x6A          ; 00000B34  mov ah,[bx+0x6a]
  db 0xAB                      ; 00000B37  stosw
  db 0x07                      ; 00000B38  pop es
  db 0xFC                      ; 00000B39  cld
  db 0xE9, 0x09, 0x12          ; 00000B3A  jmp 0x1d46
  db 0x80, 0x4F, 0x6A, 0x02    ; 00000B3D  or byte [bx+0x6a],0x2
  db 0xC3                      ; 00000B41  ret
  db 0x80, 0x67, 0x6A, 0xFD    ; 00000B42  and byte [bx+0x6a],0xfd
  db 0xC3                      ; 00000B46  ret
  db 0xC7, 0x47, 0x5E, 0x41, 0x1A ; 00000B47  mov word [bx+0x5e],0x1a41
  db 0xC3                      ; 00000B4C  ret
  db 0xC7, 0x47, 0x5E, 0x8D, 0x19 ; 00000B4D  mov word [bx+0x5e],0x198d
  db 0xC3                      ; 00000B52  ret
  db 0xC7, 0x47, 0x5E, 0x96, 0x19 ; 00000B53  mov word [bx+0x5e],0x1996
  db 0xC3                      ; 00000B58  ret
  db 0x33, 0xF6                ; 00000B59  xor si,si
  db 0x8B, 0x57, 0x64          ; 00000B5B  mov dx,[bx+0x64]
  db 0x0B, 0xD2                ; 00000B5E  or dx,dx
  db 0x74, 0x03                ; 00000B60  jz 0xb65
  db 0xE8, 0xA4, 0x03          ; 00000B62  call 0xf09
  db 0x33, 0xD2                ; 00000B65  xor dx,dx
  db 0x8B, 0x4F, 0x66          ; 00000B67  mov cx,[bx+0x66]
  db 0xE9, 0x6B, 0x03          ; 00000B6A  jmp 0xed8
  db 0xF7, 0x47, 0x6B, 0x00, 0x02 ; 00000B6D  test word [bx+0x6b],0x200
  db 0x74, 0x24                ; 00000B72  jz 0xb98
  db 0x81, 0x67, 0x6B, 0xFF, 0xFD ; 00000B74  and word [bx+0x6b],0xfdff
  db 0xE9, 0x53, 0x03          ; 00000B79  jmp 0xecf
  db 0xF7, 0x47, 0x6B, 0x00, 0x02 ; 00000B7C  test word [bx+0x6b],0x200
  db 0x75, 0x15                ; 00000B81  jnz 0xb98
  db 0xE8, 0x78, 0x07          ; 00000B83  call 0x12fe
  db 0x81, 0x4F, 0x6B, 0x00, 0x02 ; 00000B86  or word [bx+0x6b],0x200
  db 0xF6, 0x47, 0x6B, 0x02    ; 00000B8B  test byte [bx+0x6b],0x2
  db 0x75, 0x07                ; 00000B8F  jnz 0xb98
  db 0x2E, 0xC7, 0x06, 0x12, 0x6E, 0xFF, 0xFF ; 00000B91  mov word [cs:0x6e12],0xffff
  db 0xC3                      ; 00000B98  ret
  db 0x8A, 0x47, 0x66          ; 00000B99  mov al,[bx+0x66]
  db 0x8A, 0x67, 0x64          ; 00000B9C  mov ah,[bx+0x64]
  db 0x89, 0x47, 0x68          ; 00000B9F  mov [bx+0x68],ax
  db 0xC3                      ; 00000BA2  ret
  db 0x33, 0xC0                ; 00000BA3  xor ax,ax
  db 0x87, 0x47, 0x68          ; 00000BA5  xchg ax,[bx+0x68]
  db 0x88, 0x47, 0x66          ; 00000BA8  mov [bx+0x66],al
  db 0x88, 0x67, 0x64          ; 00000BAB  mov [bx+0x64],ah
  db 0xE9, 0xCC, 0x02          ; 00000BAE  jmp 0xe7d
  db 0x8B, 0x77, 0x64          ; 00000BB1  mov si,[bx+0x64]
  db 0xE9, 0x4F, 0x03          ; 00000BB4  jmp 0xf06
  db 0x80, 0x4F, 0x6A, 0x01    ; 00000BB7  or byte [bx+0x6a],0x1
  db 0xC3                      ; 00000BBB  ret
  db 0x80, 0x67, 0x6A, 0xFE    ; 00000BBC  and byte [bx+0x6a],0xfe
  db 0xC3                      ; 00000BC0  ret
  db 0x81, 0x4F, 0x6B, 0x00, 0x04 ; 00000BC1  or word [bx+0x6b],0x400
  db 0xEB, 0x05                ; 00000BC6  jmp short 0xbcd
  db 0x81, 0x67, 0x6B, 0xFF, 0xFB ; 00000BC8  and word [bx+0x6b],0xfbff
  db 0x8A, 0x87, 0x80, 0x00    ; 00000BCD  mov al,[bx+0x80]
  db 0xE9, 0x47, 0x00          ; 00000BD1  jmp 0xc1b
  db 0x80, 0x4F, 0x6A, 0x04    ; 00000BD4  or byte [bx+0x6a],0x4
  db 0xC3                      ; 00000BD8  ret
  db 0x80, 0x67, 0x6A, 0xFB    ; 00000BD9  and byte [bx+0x6a],0xfb
  db 0xC3                      ; 00000BDD  ret
  db 0x81, 0x4F, 0x6B, 0x00, 0x10 ; 00000BDE  or word [bx+0x6b],0x1000
  db 0xC3                      ; 00000BE3  ret
  db 0x81, 0x67, 0x6B, 0xFF, 0xEF ; 00000BE4  and word [bx+0x6b],0xefff
  db 0xC3                      ; 00000BE9  ret
  db 0x81, 0x67, 0x6B, 0xFF, 0xE0 ; 00000BEA  and word [bx+0x6b],0xe0ff
  db 0x80, 0x67, 0x6A, 0xF8    ; 00000BEF  and byte [bx+0x6a],0xf8
  db 0xC6, 0x47, 0x75, 0xF8    ; 00000BF3  mov byte [bx+0x75],0xf8
  db 0x8A, 0x47, 0x7F          ; 00000BF7  mov al,[bx+0x7f]
  db 0xC0, 0xC8, 0x04          ; 00000BFA  ror al,byte 0x4
  db 0xE8, 0x1B, 0x00          ; 00000BFD  call 0xc1b
  db 0xE9, 0xCC, 0x02          ; 00000C00  jmp 0xecf
  db 0x8A, 0x87, 0x80, 0x00    ; 00000C03  mov al,[bx+0x80]
  db 0x0C, 0x80                ; 00000C07  or al,0x80
  db 0xEB, 0x10                ; 00000C09  jmp short 0xc1b
  db 0x8A, 0x87, 0x80, 0x00    ; 00000C0B  mov al,[bx+0x80]
  db 0x24, 0x7F                ; 00000C0F  and al,0x7f
  db 0xEB, 0x08                ; 00000C11  jmp short 0xc1b
  db 0x8A, 0x87, 0x80, 0x00    ; 00000C13  mov al,[bx+0x80]
  db 0x24, 0x0F                ; 00000C17  and al,0xf
  db 0x0A, 0xC1                ; 00000C19  or al,cl
  db 0x88, 0x87, 0x80, 0x00    ; 00000C1B  mov [bx+0x80],al
  db 0x80, 0x4F, 0x6B, 0x08    ; 00000C1F  or byte [bx+0x6b],0x8
  db 0xC3                      ; 00000C23  ret
  db 0x80, 0x67, 0x6B, 0xF7    ; 00000C24  and byte [bx+0x6b],0xf7
  db 0x8A, 0x87, 0x80, 0x00    ; 00000C28  mov al,[bx+0x80]
  db 0xF7, 0x47, 0x6B, 0x00, 0x04 ; 00000C2C  test word [bx+0x6b],0x400
  db 0x74, 0x03                ; 00000C31  jz 0xc36
  db 0xC0, 0xC8, 0x04          ; 00000C33  ror al,byte 0x4
  db 0x51                      ; 00000C36  push cx
  db 0x57                      ; 00000C37  push di
  db 0x8D, 0xBF, 0x84, 0x00    ; 00000C38  lea di,[bx+0x84]
  db 0x8B, 0x8F, 0x81, 0x00    ; 00000C3C  mov cx,[bx+0x81]
  db 0x8B, 0xD1                ; 00000C40  mov dx,cx
  db 0xF2, 0xAE                ; 00000C42  repne scasb
  db 0x9C                      ; 00000C44  pushf
  db 0x41                      ; 00000C45  inc cx
  db 0x2B, 0xD1                ; 00000C46  sub dx,cx
  db 0x9D                      ; 00000C48  popf
  db 0x74, 0x3D                ; 00000C49  jz 0xc88
  db 0x83, 0xBF, 0x81, 0x00, 0x10 ; 00000C4B  cmp word [bx+0x81],byte +0x10
  db 0x75, 0x17                ; 00000C50  jnz 0xc69
  db 0x8A, 0x47, 0x6A          ; 00000C52  mov al,[bx+0x6a]
  db 0x98                      ; 00000C55  cbw
  db 0xC1, 0xE8, 0x03          ; 00000C56  shr ax,byte 0x3
  db 0x96                      ; 00000C59  xchg ax,si
  db 0x8A, 0x80, 0x84, 0x00    ; 00000C5A  mov al,[bx+si+0x84]
  db 0x88, 0x87, 0x80, 0x00    ; 00000C5E  mov [bx+0x80],al
  db 0x81, 0x67, 0x6B, 0xFF, 0xFB ; 00000C62  and word [bx+0x6b],0xfbff
  db 0xEB, 0x2C                ; 00000C67  jmp short 0xc95
  db 0x42                      ; 00000C69  inc dx
  db 0x88, 0x05                ; 00000C6A  mov [di],al
  db 0xFF, 0x87, 0x81, 0x00    ; 00000C6C  inc word [bx+0x81]
  db 0xF6, 0x47, 0x6B, 0x02    ; 00000C70  test byte [bx+0x6b],0x2
  db 0x75, 0x12                ; 00000C74  jnz 0xc88
  db 0xE8, 0x3E, 0x14          ; 00000C76  call 0x20b7
  db 0x8B, 0xCA                ; 00000C79  mov cx,dx
  db 0xC1, 0xE2, 0x02          ; 00000C7B  shl dx,byte 0x2
  db 0x81, 0xC2, 0x80, 0x01    ; 00000C7E  add dx,0x180
  db 0xEE                      ; 00000C82  out dx,al
  db 0x42                      ; 00000C83  inc dx
  db 0x42                      ; 00000C84  inc dx
  db 0xEE                      ; 00000C85  out dx,al
  db 0x8B, 0xD1                ; 00000C86  mov dx,cx
  db 0xC0, 0xE2, 0x03          ; 00000C88  shl dl,byte 0x3
  db 0x8A, 0x47, 0x6A          ; 00000C8B  mov al,[bx+0x6a]
  db 0x24, 0x07                ; 00000C8E  and al,0x7
  db 0x0A, 0xC2                ; 00000C90  or al,dl
  db 0x88, 0x47, 0x6A          ; 00000C92  mov [bx+0x6a],al
  db 0x5F                      ; 00000C95  pop di
  db 0x59                      ; 00000C96  pop cx
  db 0xC3                      ; 00000C97  ret
  db 0x81, 0x67, 0x6B, 0xFF, 0xFE ; 00000C98  and word [bx+0x6b],0xfeff
  db 0xC3                      ; 00000C9D  ret
  db 0x81, 0x4F, 0x6B, 0x00, 0x01 ; 00000C9E  or word [bx+0x6b],0x100
  db 0xC3                      ; 00000CA3  ret
  db 0xC7, 0x47, 0x7B, 0x74, 0x1B ; 00000CA4  mov word [bx+0x7b],0x1b74
  db 0xEB, 0x05                ; 00000CA9  jmp short 0xcb0
  db 0xC7, 0x47, 0x7B, 0x9D, 0x1B ; 00000CAB  mov word [bx+0x7b],0x1b9d
  db 0xC7, 0x47, 0x5E, 0xA7, 0x19 ; 00000CB0  mov word [bx+0x5e],0x19a7
  db 0xC3                      ; 00000CB5  ret
  db 0xBE, 0x18, 0x00          ; 00000CB6  mov si,0x18
  db 0xE8, 0x4A, 0x02          ; 00000CB9  call 0xf06
  db 0xE8, 0x5D, 0x0E          ; 00000CBC  call 0x1b1c
  db 0xE8, 0xA6, 0x0F          ; 00000CBF  call 0x1c68
  db 0xB8, 0x19, 0x00          ; 00000CC2  mov ax,0x19
  db 0xE8, 0x26, 0x00          ; 00000CC5  call 0xcee
  db 0xC6, 0x47, 0x35, 0x00    ; 00000CC8  mov byte [bx+0x35],0x0
  db 0xC3                      ; 00000CCC  ret
  db 0xE8, 0x4C, 0x0E          ; 00000CCD  call 0x1b1c
  db 0xE8, 0x95, 0x0F          ; 00000CD0  call 0x1c68
  db 0x83, 0x7F, 0x64, 0x18    ; 00000CD3  cmp word [bx+0x64],byte +0x18
  db 0x75, 0x0A                ; 00000CD7  jnz 0xce3
  db 0xFF, 0x4F, 0x64          ; 00000CD9  dec word [bx+0x64]
  db 0xC6, 0x47, 0x35, 0x00    ; 00000CDC  mov byte [bx+0x35],0x0
  db 0xE8, 0x9A, 0x01          ; 00000CE0  call 0xe7d
  db 0xB8, 0x18, 0x00          ; 00000CE3  mov ax,0x18
  db 0xE8, 0x05, 0x00          ; 00000CE6  call 0xcee
  db 0xC6, 0x47, 0x35, 0x00    ; 00000CE9  mov byte [bx+0x35],0x0
  db 0xC3                      ; 00000CED  ret
  db 0x89, 0x47, 0x48          ; 00000CEE  mov [bx+0x48],ax
  db 0xF6, 0x47, 0x6B, 0x16    ; 00000CF1  test byte [bx+0x6b],0x16
  db 0x75, 0x0C                ; 00000CF5  jnz 0xd03
  db 0xE8, 0xEE, 0x04          ; 00000CF7  call 0x11e8
  db 0x2E, 0x80, 0x36, 0xFA, 0x6D, 0x80 ; 00000CFA  xor byte [cs:0x6dfa],0x80
  db 0xE8, 0x65, 0x0F          ; 00000D00  call 0x1c68
  db 0xC3                      ; 00000D03  ret
  db 0x8B, 0x47, 0x6B          ; 00000D04  mov ax,[bx+0x6b]
  db 0x8A, 0x47, 0x6A          ; 00000D07  mov al,[bx+0x6a]
  db 0x89, 0x47, 0x6D          ; 00000D0A  mov [bx+0x6d],ax
  db 0x8A, 0x87, 0x80, 0x00    ; 00000D0D  mov al,[bx+0x80]
  db 0x88, 0x47, 0x6F          ; 00000D11  mov [bx+0x6f],al
  db 0xC3                      ; 00000D14  ret
  db 0x8B, 0x47, 0x6D          ; 00000D15  mov ax,[bx+0x6d]
  db 0x88, 0x47, 0x6A          ; 00000D18  mov [bx+0x6a],al
  db 0x8A, 0x47, 0x6B          ; 00000D1B  mov al,[bx+0x6b]
  db 0x89, 0x47, 0x6B          ; 00000D1E  mov [bx+0x6b],ax
  db 0x8A, 0x47, 0x6F          ; 00000D21  mov al,[bx+0x6f]
  db 0xE8, 0xF4, 0xFE          ; 00000D24  call 0xc1b
  db 0xF6, 0x47, 0x6B, 0x02    ; 00000D27  test byte [bx+0x6b],0x2
  db 0x74, 0x01                ; 00000D2B  jz 0xd2e
  db 0xC3                      ; 00000D2D  ret
  db 0x2E, 0xC7, 0x06, 0x12, 0x6E, 0xFF, 0xFF ; 00000D2E  mov word [cs:0x6e12],0xffff
  db 0xE9, 0x97, 0x01          ; 00000D35  jmp 0xecf
  db 0xB0, 0x01                ; 00000D38  mov al,0x1
  db 0xE9, 0x5C, 0xF9          ; 00000D3A  jmp 0x699
  db 0x32, 0xC0                ; 00000D3D  xor al,al
  db 0xE9, 0x57, 0xF9          ; 00000D3F  jmp 0x699
  db 0xC7, 0x47, 0x5E, 0xDB, 0x19 ; 00000D42  mov word [bx+0x5e],0x19db
  db 0xC3                      ; 00000D47  ret
  db 0xC6, 0x47, 0x71, 0x01    ; 00000D48  mov byte [bx+0x71],0x1
  db 0xC3                      ; 00000D4C  ret
  db 0xC6, 0x47, 0x71, 0x00    ; 00000D4D  mov byte [bx+0x71],0x0
  db 0xC3                      ; 00000D51  ret
  db 0xC6, 0x47, 0x75, 0xFF    ; 00000D52  mov byte [bx+0x75],0xff
  db 0xE9, 0x99, 0x13          ; 00000D56  jmp 0x20f2
  db 0xC6, 0x47, 0x75, 0xF8    ; 00000D59  mov byte [bx+0x75],0xf8
  db 0xE9, 0x92, 0x13          ; 00000D5D  jmp 0x20f2
  db 0x81, 0x4F, 0x6B, 0x00, 0x08 ; 00000D60  or word [bx+0x6b],0x800
  db 0xC3                      ; 00000D65  ret
  db 0x81, 0x67, 0x6B, 0xFF, 0xF7 ; 00000D66  and word [bx+0x6b],0xf7ff
  db 0xC3                      ; 00000D6B  ret
  db 0x8B, 0x77, 0x76          ; 00000D6C  mov si,[bx+0x76]
  db 0xBF, 0x1F, 0x57          ; 00000D6F  mov di,0x571f
  db 0xEB, 0x06                ; 00000D72  jmp short 0xd7a
  db 0x8B, 0x7F, 0x76          ; 00000D74  mov di,[bx+0x76]
  db 0xBE, 0x1F, 0x57          ; 00000D77  mov si,0x571f
  db 0xB9, 0xC8, 0x01          ; 00000D7A  mov cx,0x1c8
  db 0xF3, 0xA4                ; 00000D7D  rep movsb
  db 0xC3                      ; 00000D7F  ret
  db 0xC7, 0x47, 0x5E, 0xE7, 0x19 ; 00000D80  mov word [bx+0x5e],0x19e7
  db 0xC3                      ; 00000D85  ret
  db 0xC7, 0x47, 0x5E, 0x0D, 0x1A ; 00000D86  mov word [bx+0x5e],0x1a0d
  db 0xC3                      ; 00000D8B  ret
  db 0xC3                      ; 00000D8C  ret
  db 0xC0, 0xE1, 0x04          ; 00000D8D  shl cl,byte 0x4
  db 0xE8, 0x80, 0xFE          ; 00000D90  call 0xc13
  db 0xE9, 0xAB, 0x00          ; 00000D93  jmp 0xe41
  db 0x80, 0xE1, 0x0F          ; 00000D96  and cl,0xf
  db 0x8A, 0x87, 0x80, 0x00    ; 00000D99  mov al,[bx+0x80]
  db 0x24, 0xF0                ; 00000D9D  and al,0xf0
  db 0x0A, 0xC1                ; 00000D9F  or al,cl
  db 0xE8, 0x77, 0xFE          ; 00000DA1  call 0xc1b
  db 0xE9, 0x9A, 0x00          ; 00000DA4  jmp 0xe41
  db 0xC7, 0x47, 0x5E, 0xB5, 0x19 ; 00000DA7  mov word [bx+0x5e],0x19b5
  db 0x80, 0xE9, 0x20          ; 00000DAC  sub cl,0x20
  db 0x32, 0xED                ; 00000DAF  xor ch,ch
  db 0x89, 0x4F, 0x7D          ; 00000DB1  mov [bx+0x7d],cx
  db 0xC3                      ; 00000DB4  ret
  db 0x80, 0xE9, 0x20          ; 00000DB5  sub cl,0x20
  db 0x3A, 0x4F, 0x48          ; 00000DB8  cmp cl,[bx+0x48]
  db 0x73, 0x3A                ; 00000DBB  jnc 0xdf7
  db 0x32, 0xED                ; 00000DBD  xor ch,ch
  db 0x8B, 0xF9                ; 00000DBF  mov di,cx
  db 0x8B, 0x77, 0x7D          ; 00000DC1  mov si,[bx+0x7d]
  db 0x3B, 0xFE                ; 00000DC4  cmp di,si
  db 0x72, 0x2F                ; 00000DC6  jc 0xdf7
  db 0x56                      ; 00000DC8  push si
  db 0x57                      ; 00000DC9  push di
  db 0xE8, 0x31, 0x05          ; 00000DCA  call 0x12fe
  db 0x5F                      ; 00000DCD  pop di
  db 0x5E                      ; 00000DCE  pop si
  db 0xFF, 0x57, 0x7B          ; 00000DCF  call [bx+0x7b]
  db 0xE8, 0x6A, 0x05          ; 00000DD2  call 0x133f
  db 0xE8, 0xA5, 0x00          ; 00000DD5  call 0xe7d
  db 0xE9, 0x66, 0x00          ; 00000DD8  jmp 0xe41
  db 0xC1, 0xC9, 0x04          ; 00000DDB  ror cx,byte 0x4
  db 0xC0, 0xCD, 0x04          ; 00000DDE  ror ch,byte 0x4
  db 0xE8, 0xBF, 0xF8          ; 00000DE1  call 0x6a3
  db 0xE9, 0x5A, 0x00          ; 00000DE4  jmp 0xe41
  db 0xC7, 0x47, 0x5E, 0xF8, 0x19 ; 00000DE7  mov word [bx+0x5e],0x19f8
  db 0x80, 0xE9, 0x20          ; 00000DEC  sub cl,0x20
  db 0x3A, 0x4F, 0x48          ; 00000DEF  cmp cl,[bx+0x48]
  db 0x73, 0x03                ; 00000DF2  jnc 0xdf7
  db 0x88, 0x4F, 0x64          ; 00000DF4  mov [bx+0x64],cl
  db 0xC3                      ; 00000DF7  ret
  db 0xC7, 0x47, 0x5E, 0x96, 0x14 ; 00000DF8  mov word [bx+0x5e],0x1496
  db 0x80, 0xE9, 0x20          ; 00000DFD  sub cl,0x20
  db 0x3A, 0x4F, 0x60          ; 00000E00  cmp cl,[bx+0x60]
  db 0x77, 0x3C                ; 00000E03  ja 0xe41
  db 0x88, 0x4F, 0x66          ; 00000E05  mov [bx+0x66],cl
  db 0xE8, 0x72, 0x00          ; 00000E08  call 0xe7d
  db 0xEB, 0x34                ; 00000E0B  jmp short 0xe41
  db 0x86, 0xC1                ; 00000E0D  xchg al,cl
  db 0xBF, 0xB5, 0x10          ; 00000E0F  mov di,0x10b5
  db 0x8B, 0xD7                ; 00000E12  mov dx,di
  db 0xB9, 0x42, 0x00          ; 00000E14  mov cx,0x42
  db 0xF2, 0xAE                ; 00000E17  repne scasb
  db 0x75, 0x26                ; 00000E19  jnz 0xe41
  db 0x4F                      ; 00000E1B  dec di
  db 0x2B, 0xFA                ; 00000E1C  sub di,dx
  db 0x97                      ; 00000E1E  xchg ax,di
  db 0xE8, 0xD5, 0xF6          ; 00000E1F  call 0x4f7
  db 0x89, 0x77, 0x7B          ; 00000E22  mov [bx+0x7b],si
  db 0x88, 0x4F, 0x7D          ; 00000E25  mov [bx+0x7d],cl
  db 0xC7, 0x47, 0x5E, 0x2E, 0x1A ; 00000E28  mov word [bx+0x5e],0x1a2e
  db 0xC3                      ; 00000E2D  ret
  db 0x8B, 0x77, 0x7B          ; 00000E2E  mov si,[bx+0x7b]
  db 0x88, 0x0C                ; 00000E31  mov [si],cl
  db 0x46                      ; 00000E33  inc si
  db 0x89, 0x77, 0x7B          ; 00000E34  mov [bx+0x7b],si
  db 0x0A, 0xC9                ; 00000E37  or cl,cl
  db 0x74, 0x06                ; 00000E39  jz 0xe41
  db 0xFE, 0x4F, 0x7D          ; 00000E3B  dec byte [bx+0x7d]
  db 0x74, 0x01                ; 00000E3E  jz 0xe41
  db 0xC3                      ; 00000E40  ret
  db 0xC7, 0x47, 0x5E, 0x96, 0x14 ; 00000E41  mov word [bx+0x5e],0x1496
  db 0xC3                      ; 00000E46  ret
  db 0x8B, 0x77, 0x64          ; 00000E47  mov si,[bx+0x64]
  db 0x46                      ; 00000E4A  inc si
  db 0x3B, 0x77, 0x48          ; 00000E4B  cmp si,[bx+0x48]
  db 0x75, 0x07                ; 00000E4E  jnz 0xe57
  db 0xBE, 0x00, 0x00          ; 00000E50  mov si,0x0
  db 0xE8, 0x1A, 0x01          ; 00000E53  call 0xf70
  db 0xC3                      ; 00000E56  ret
  db 0x89, 0x77, 0x64          ; 00000E57  mov [bx+0x64],si
  db 0x80, 0x7F, 0x4C, 0x00    ; 00000E5A  cmp byte [bx+0x4c],0x0
  db 0x74, 0x03                ; 00000E5E  jz 0xe63
  db 0xE8, 0xE3, 0x0E          ; 00000E60  call 0x1d46
  db 0xC3                      ; 00000E63  ret
  db 0x8B, 0x57, 0x64          ; 00000E64  mov dx,[bx+0x64]
  db 0x42                      ; 00000E67  inc dx
  db 0x3B, 0x57, 0x48          ; 00000E68  cmp dx,[bx+0x48]
  db 0x74, 0x05                ; 00000E6B  jz 0xe72
  db 0x89, 0x57, 0x64          ; 00000E6D  mov [bx+0x64],dx
  db 0xEB, 0x0B                ; 00000E70  jmp short 0xe7d
  db 0xC3                      ; 00000E72  ret
  db 0xC7, 0x47, 0x64, 0x00, 0x00 ; 00000E73  mov word [bx+0x64],0x0
  db 0xC7, 0x47, 0x66, 0x00, 0x00 ; 00000E78  mov word [bx+0x66],0x0
  db 0x8B, 0x7F, 0x66          ; 00000E7D  mov di,[bx+0x66]
  db 0x8B, 0x77, 0x64          ; 00000E80  mov si,[bx+0x64]
  db 0xD1, 0xE6                ; 00000E83  shl si,1
  db 0x8B, 0x10                ; 00000E85  mov dx,[bx+si]
  db 0xD1, 0xE7                ; 00000E87  shl di,1
  db 0x03, 0xD7                ; 00000E89  add dx,di
  db 0x89, 0x57, 0x62          ; 00000E8B  mov [bx+0x62],dx
  db 0xF6, 0x47, 0x6B, 0x04    ; 00000E8E  test byte [bx+0x6b],0x4
  db 0x74, 0x03                ; 00000E92  jz 0xe97
  db 0xE9, 0xA5, 0x04          ; 00000E94  jmp 0x133c
  db 0xF7, 0x47, 0x6B, 0x03, 0x02 ; 00000E97  test word [bx+0x6b],0x203
  db 0x75, 0x28                ; 00000E9C  jnz 0xec6
  db 0x8A, 0x77, 0x64          ; 00000E9E  mov dh,[bx+0x64]
  db 0x8A, 0x57, 0x66          ; 00000EA1  mov dl,[bx+0x66]
  db 0xF6, 0x47, 0x6B, 0x10    ; 00000EA4  test byte [bx+0x6b],0x10
  db 0x74, 0x17                ; 00000EA8  jz 0xec1
  db 0x2A, 0x77, 0x4B          ; 00000EAA  sub dh,[bx+0x4b]
  db 0x72, 0x18                ; 00000EAD  jc 0xec7
  db 0x2A, 0x57, 0x4A          ; 00000EAF  sub dl,[bx+0x4a]
  db 0x72, 0x13                ; 00000EB2  jc 0xec7
  db 0x3A, 0x77, 0x42          ; 00000EB4  cmp dh,[bx+0x42]
  db 0x73, 0x0E                ; 00000EB7  jnc 0xec7
  db 0x3A, 0x57, 0x44          ; 00000EB9  cmp dl,[bx+0x44]
  db 0x73, 0x09                ; 00000EBC  jnc 0xec7
  db 0x03, 0x57, 0x36          ; 00000EBE  add dx,[bx+0x36]
  db 0x2E, 0x89, 0x16, 0x12, 0x6E ; 00000EC1  mov [cs:0x6e12],dx
  db 0xC3                      ; 00000EC6  ret
  db 0x2E, 0xC7, 0x06, 0x12, 0x6E, 0xFF, 0xFF ; 00000EC7  mov word [cs:0x6e12],0xffff
  db 0xC3                      ; 00000ECE  ret
  db 0xF6, 0x47, 0x6B, 0x04    ; 00000ECF  test byte [bx+0x6b],0x4
  db 0x74, 0xC2                ; 00000ED3  jz 0xe97
  db 0xE9, 0x67, 0x04          ; 00000ED5  jmp 0x133f
  db 0x8B, 0x77, 0x64          ; 00000ED8  mov si,[bx+0x64]
  db 0xD1, 0xE6                ; 00000EDB  shl si,1
  db 0x8B, 0x38                ; 00000EDD  mov di,[bx+si]
  db 0xD1, 0xEE                ; 00000EDF  shr si,1
  db 0x03, 0xFA                ; 00000EE1  add di,dx
  db 0x03, 0xFA                ; 00000EE3  add di,dx
  db 0x2B, 0xCA                ; 00000EE5  sub cx,dx
  db 0x41                      ; 00000EE7  inc cx
  db 0xF6, 0x47, 0x6B, 0x04    ; 00000EE8  test byte [bx+0x6b],0x4
  db 0x75, 0x05                ; 00000EEC  jnz 0xef3
  db 0xE8, 0x3F, 0x00          ; 00000EEE  call 0xf30
  db 0xEB, 0x22                ; 00000EF1  jmp short 0xf15
  db 0x8B, 0xC6                ; 00000EF3  mov ax,si
  db 0x50                      ; 00000EF5  push ax
  db 0x52                      ; 00000EF6  push dx
  db 0x51                      ; 00000EF7  push cx
  db 0xB1, 0x20                ; 00000EF8  mov cl,0x20
  db 0xE8, 0x32, 0x03          ; 00000EFA  call 0x122f
  db 0x59                      ; 00000EFD  pop cx
  db 0x5A                      ; 00000EFE  pop dx
  db 0x58                      ; 00000EFF  pop ax
  db 0x42                      ; 00000F00  inc dx
  db 0xE2, 0xF2                ; 00000F01  loop 0xef5
  db 0xE9, 0x39, 0x04          ; 00000F03  jmp 0x133f
  db 0x8B, 0xD6                ; 00000F06  mov dx,si
  db 0x42                      ; 00000F08  inc dx
  db 0x56                      ; 00000F09  push si
  db 0x52                      ; 00000F0A  push dx
  db 0xE8, 0x13, 0x00          ; 00000F0B  call 0xf21
  db 0x5A                      ; 00000F0E  pop dx
  db 0x5E                      ; 00000F0F  pop si
  db 0x46                      ; 00000F10  inc si
  db 0x3B, 0xD6                ; 00000F11  cmp dx,si
  db 0x75, 0xF4                ; 00000F13  jnz 0xf09
  db 0x2E, 0xF6, 0x06, 0x1D, 0x2D, 0xFF ; 00000F15  test byte [cs:0x2d1d],0xff
  db 0x75, 0x03                ; 00000F1B  jnz 0xf20
  db 0xE8, 0x26, 0x0E          ; 00000F1D  call 0x1d46
  db 0xC3                      ; 00000F20  ret
  db 0xF6, 0x47, 0x6B, 0x04    ; 00000F21  test byte [bx+0x6b],0x4
  db 0x75, 0x21                ; 00000F25  jnz 0xf48
  db 0xD1, 0xE6                ; 00000F27  shl si,1
  db 0x8B, 0x38                ; 00000F29  mov di,[bx+si]
  db 0xD1, 0xEE                ; 00000F2B  shr si,1
  db 0xB9, 0x50, 0x00          ; 00000F2D  mov cx,0x50
  db 0xF6, 0x47, 0x6B, 0x08    ; 00000F30  test byte [bx+0x6b],0x8
  db 0x74, 0x03                ; 00000F34  jz 0xf39
  db 0xE8, 0xEB, 0xFC          ; 00000F36  call 0xc24
  db 0x06                      ; 00000F39  push es
  db 0x8A, 0x67, 0x6A          ; 00000F3A  mov ah,[bx+0x6a]
  db 0xB0, 0x20                ; 00000F3D  mov al,0x20
  db 0x2E, 0x8E, 0x06, 0x7E, 0x2F ; 00000F3F  mov es,[cs:0x2f7e]
  db 0xF3, 0xAB                ; 00000F44  rep stosw
  db 0x07                      ; 00000F46  pop es
  db 0xC3                      ; 00000F47  ret
  db 0x1E                      ; 00000F48  push ds
  db 0x8B, 0xC6                ; 00000F49  mov ax,si
  db 0xB4, 0x0A                ; 00000F4B  mov ah,0xa
  db 0xF6, 0xE4                ; 00000F4D  mul ah
  db 0x8B, 0xF8                ; 00000F4F  mov di,ax
  db 0xD1, 0xE7                ; 00000F51  shl di,1
  db 0xE8, 0xB2, 0x04          ; 00000F53  call 0x1408
  db 0x1E                      ; 00000F56  push ds
  db 0x07                      ; 00000F57  pop es
  db 0x33, 0xC0                ; 00000F58  xor ax,ax
  db 0xB9, 0x23, 0x00          ; 00000F5A  mov cx,0x23
  db 0x51                      ; 00000F5D  push cx
  db 0xB9, 0x0A, 0x00          ; 00000F5E  mov cx,0xa
  db 0xF3, 0xAB                ; 00000F61  rep stosw
  db 0x81, 0xC7, 0xEC, 0x01    ; 00000F63  add di,0x1ec
  db 0x59                      ; 00000F67  pop cx
  db 0xE2, 0xF3                ; 00000F68  loop 0xf5d
  db 0x1F                      ; 00000F6A  pop ds
  db 0xC6, 0x47, 0x35, 0x00    ; 00000F6B  mov byte [bx+0x35],0x0
  db 0xC3                      ; 00000F6F  ret
  db 0x8B, 0x7F, 0x48          ; 00000F70  mov di,[bx+0x48]
  db 0x4F                      ; 00000F73  dec di
  db 0xF6, 0x47, 0x6B, 0x04    ; 00000F74  test byte [bx+0x6b],0x4
  db 0x74, 0x03                ; 00000F78  jz 0xf7d
  db 0xE9, 0x1B, 0x04          ; 00000F7A  jmp 0x1398
  db 0x56                      ; 00000F7D  push si
  db 0x57                      ; 00000F7E  push di
  db 0x8B, 0xCF                ; 00000F7F  mov cx,di
  db 0x2B, 0xCE                ; 00000F81  sub cx,si
  db 0xD1, 0xE6                ; 00000F83  shl si,1
  db 0x03, 0xF3                ; 00000F85  add si,bx
  db 0x8B, 0xFE                ; 00000F87  mov di,si
  db 0xAD                      ; 00000F89  lodsw
  db 0xF3, 0xA5                ; 00000F8A  rep movsw
  db 0x87, 0x47, 0x32          ; 00000F8C  xchg ax,[bx+0x32]
  db 0xAB                      ; 00000F8F  stosw
  db 0x5A                      ; 00000F90  pop dx
  db 0x59                      ; 00000F91  pop cx
  db 0x8B, 0xF2                ; 00000F92  mov si,dx
  db 0xBF, 0x00, 0x00          ; 00000F94  mov di,0x0
  db 0xEB, 0x27                ; 00000F97  jmp short 0xfc0
  db 0x8B, 0x7F, 0x48          ; 00000F99  mov di,[bx+0x48]
  db 0x4F                      ; 00000F9C  dec di
  db 0xF6, 0x47, 0x6B, 0x04    ; 00000F9D  test byte [bx+0x6b],0x4
  db 0x74, 0x01                ; 00000FA1  jz 0xfa4
  db 0xC3                      ; 00000FA3  ret
  db 0x56                      ; 00000FA4  push si
  db 0x57                      ; 00000FA5  push di
  db 0x8B, 0xCF                ; 00000FA6  mov cx,di
  db 0x2B, 0xCE                ; 00000FA8  sub cx,si
  db 0xD1, 0xE7                ; 00000FAA  shl di,1
  db 0x03, 0xFB                ; 00000FAC  add di,bx
  db 0x8B, 0xF7                ; 00000FAE  mov si,di
  db 0xFD                      ; 00000FB0  std
  db 0xAD                      ; 00000FB1  lodsw
  db 0xF3, 0xA5                ; 00000FB2  rep movsw
  db 0x87, 0x47, 0x32          ; 00000FB4  xchg ax,[bx+0x32]
  db 0xAB                      ; 00000FB7  stosw
  db 0xFC                      ; 00000FB8  cld
  db 0x5A                      ; 00000FB9  pop dx
  db 0x59                      ; 00000FBA  pop cx
  db 0x8B, 0xF1                ; 00000FBB  mov si,cx
  db 0xBF, 0x06, 0x00          ; 00000FBD  mov di,0x6
  db 0x50                      ; 00000FC0  push ax
  db 0xE8, 0x58, 0x0B          ; 00000FC1  call 0x1b1c
  db 0x58                      ; 00000FC4  pop ax
  db 0xF6, 0x47, 0x6B, 0x12    ; 00000FC5  test byte [bx+0x6b],0x12
  db 0x75, 0x1D                ; 00000FC9  jnz 0xfe8
  db 0x80, 0x7F, 0x71, 0x00    ; 00000FCB  cmp byte [bx+0x71],0x0
  db 0x74, 0x1C                ; 00000FCF  jz 0xfed
  db 0x3B, 0xCA                ; 00000FD1  cmp cx,dx
  db 0x75, 0x29                ; 00000FD3  jnz 0xffe
  db 0xE8, 0x2E, 0xFF          ; 00000FD5  call 0xf06
  db 0xE8, 0x0D, 0x02          ; 00000FD8  call 0x11e8
  db 0x2E, 0x80, 0x36, 0xFA, 0x6D, 0x80 ; 00000FDB  xor byte [cs:0x6dfa],0x80
  db 0xB4, 0x00                ; 00000FE1  mov ah,0x0
  db 0xE8, 0x3E, 0x10          ; 00000FE3  call 0x2024
  db 0xEB, 0x11                ; 00000FE6  jmp short 0xff9
  db 0xE8, 0x1B, 0xFF          ; 00000FE8  call 0xf06
  db 0xEB, 0x0C                ; 00000FEB  jmp short 0xff9
  db 0xE8, 0x16, 0xFF          ; 00000FED  call 0xf06
  db 0xE8, 0xF5, 0x01          ; 00000FF0  call 0x11e8
  db 0x2E, 0x80, 0x36, 0xFA, 0x6D, 0x80 ; 00000FF3  xor byte [cs:0x6dfa],0x80
  db 0xC6, 0x47, 0x35, 0x00    ; 00000FF9  mov byte [bx+0x35],0x0
  db 0xC3                      ; 00000FFD  ret
  db 0x57                      ; 00000FFE  push di
  db 0x80, 0x4F, 0x6B, 0x01    ; 00000FFF  or byte [bx+0x6b],0x1
  db 0xE8, 0xA1, 0x00          ; 00001003  call 0x10a7
  db 0x2E, 0xC6, 0x06, 0x93, 0x2F, 0xFF ; 00001006  mov byte [cs:0x2f93],0xff
  db 0xE8, 0x8F, 0x00          ; 0000100C  call 0x109e
  db 0x2E, 0xC6, 0x06, 0x93, 0x2F, 0x00 ; 0000100F  mov byte [cs:0x2f93],0x0
  db 0x58                      ; 00001015  pop ax
  db 0x2E, 0xA2, 0x94, 0x2F    ; 00001016  mov [cs:0x2f94],al
  db 0x2E, 0x89, 0x1E, 0x8D, 0x2F ; 0000101A  mov [cs:0x2f8d],bx
  db 0x53                      ; 0000101F  push bx
  db 0xBA, 0x04, 0x00          ; 00001020  mov dx,0x4
  db 0xE8, 0xFA, 0xF0          ; 00001023  call 0x120
  db 0xB1, 0x8E                ; 00001026  mov cl,0x8e
  db 0xE8, 0x08, 0xF1          ; 00001028  call 0x133
  db 0xBA, 0x09, 0x00          ; 0000102B  mov dx,0x9
  db 0xE8, 0x00, 0xF1          ; 0000102E  call 0x131
  db 0x5B                      ; 00001031  pop bx
  db 0xC3                      ; 00001032  ret
  db 0xE8, 0x82, 0x00          ; 00001033  call 0x10b8
  db 0x2E, 0xFF, 0x06, 0x91, 0x2F ; 00001036  inc word [cs:0x2f91]
  db 0x50                      ; 0000103B  push ax
  db 0xE8, 0xC7, 0xFE          ; 0000103C  call 0xf06
  db 0x8B, 0xF3                ; 0000103F  mov si,bx
  db 0xBF, 0xA0, 0x2F          ; 00001041  mov di,0x2fa0
  db 0x8B, 0x4F, 0x48          ; 00001044  mov cx,[bx+0x48]
  db 0xF3, 0xA5                ; 00001047  rep movsw
  db 0xE8, 0x83, 0x00          ; 00001049  call 0x10cf
  db 0x58                      ; 0000104C  pop ax
  db 0x2E, 0x8B, 0x3E, 0x91, 0x2F ; 0000104D  mov di,[cs:0x2f91]
  db 0x83, 0xC7, 0x03          ; 00001052  add di,byte +0x3
  db 0xB1, 0x01                ; 00001055  mov cl,0x1
  db 0xE9, 0x1D, 0x00          ; 00001057  jmp 0x1077
  db 0xE8, 0x5B, 0x00          ; 0000105A  call 0x10b8
  db 0x50                      ; 0000105D  push ax
  db 0xE8, 0xA5, 0xFE          ; 0000105E  call 0xf06
  db 0x8B, 0xF3                ; 00001061  mov si,bx
  db 0xBF, 0xA0, 0x2F          ; 00001063  mov di,0x2fa0
  db 0x8B, 0x4F, 0x48          ; 00001066  mov cx,[bx+0x48]
  db 0xF3, 0xA5                ; 00001069  rep movsw
  db 0xE8, 0x61, 0x00          ; 0000106B  call 0x10cf
  db 0x58                      ; 0000106E  pop ax
  db 0x2E, 0x8B, 0x3E, 0x8F, 0x2F ; 0000106F  mov di,[cs:0x2f8f]
  db 0x47                      ; 00001074  inc di
  db 0xB1, 0x07                ; 00001075  mov cl,0x7
  db 0x2E, 0x88, 0x8F, 0x80, 0x00 ; 00001077  mov [cs:bx+0x80],cl
  db 0xFE, 0xC1                ; 0000107C  inc cl
  db 0x2E, 0x88, 0x4F, 0x7C    ; 0000107E  mov [cs:bx+0x7c],cl
  db 0xD1, 0xE7                ; 00001082  shl di,1
  db 0xD1, 0xE7                ; 00001084  shl di,1
  db 0x03, 0xFB                ; 00001086  add di,bx
  db 0x2E, 0x8B, 0x16, 0x7E, 0x2F ; 00001088  mov dx,[cs:0x2f7e]
  db 0xE8, 0xB6, 0x0F          ; 0000108D  call 0x2046
  db 0x2E, 0xC7, 0x06, 0x12, 0x6E, 0xFF, 0xFF ; 00001090  mov word [cs:0x6e12],0xffff
  db 0x2E, 0x80, 0x36, 0xFA, 0x6D, 0x80 ; 00001097  xor byte [cs:0x6dfa],0x80
  db 0xC3                      ; 0000109D  ret
  db 0x53                      ; 0000109E  push bx
  db 0xBA, 0x0A, 0x00          ; 0000109F  mov dx,0xa
  db 0xE8, 0x8C, 0xF0          ; 000010A2  call 0x131
  db 0x5B                      ; 000010A5  pop bx
  db 0xC3                      ; 000010A6  ret
  db 0xBF, 0x96, 0x2F          ; 000010A7  mov di,0x2f96
  db 0xAB                      ; 000010AA  stosw
  db 0x8B, 0xC3                ; 000010AB  mov ax,bx
  db 0xAB                      ; 000010AD  stosw
  db 0x8B, 0xC1                ; 000010AE  mov ax,cx
  db 0xAB                      ; 000010B0  stosw
  db 0x8B, 0xC2                ; 000010B1  mov ax,dx
  db 0xAB                      ; 000010B3  stosw
  db 0x8B, 0xC6                ; 000010B4  mov ax,si
  db 0xAB                      ; 000010B6  stosw
  db 0xC3                      ; 000010B7  ret
  db 0xBE, 0x98, 0x2F          ; 000010B8  mov si,0x2f98
  db 0xAD                      ; 000010BB  lodsw
  db 0x8B, 0xD8                ; 000010BC  mov bx,ax
  db 0xAD                      ; 000010BE  lodsw
  db 0x2E, 0xA3, 0x8F, 0x2F    ; 000010BF  mov [cs:0x2f8f],ax
  db 0xAD                      ; 000010C3  lodsw
  db 0x2E, 0xA3, 0x91, 0x2F    ; 000010C4  mov [cs:0x2f91],ax
  db 0x8B, 0x34                ; 000010C8  mov si,[si]
  db 0x2E, 0xA1, 0x96, 0x2F    ; 000010CA  mov ax,[cs:0x2f96]
  db 0xC3                      ; 000010CE  ret
  db 0x8B, 0x4F, 0x48          ; 000010CF  mov cx,[bx+0x48]
  db 0x2E, 0x8B, 0x16, 0x91, 0x2F ; 000010D2  mov dx,[cs:0x2f91]
  db 0x2B, 0xCA                ; 000010D7  sub cx,dx
  db 0xD1, 0xE1                ; 000010D9  shl cx,1
  db 0x51                      ; 000010DB  push cx
  db 0x2E, 0x8B, 0x0E, 0x8F, 0x2F ; 000010DC  mov cx,[cs:0x2f8f]
  db 0x2B, 0xD1                ; 000010E1  sub dx,cx
  db 0xD1, 0xE2                ; 000010E3  shl dx,1
  db 0x52                      ; 000010E5  push dx
  db 0xD1, 0xE1                ; 000010E6  shl cx,1
  db 0xE8, 0x31, 0x01          ; 000010E8  call 0x121c
  db 0xF3, 0xA5                ; 000010EB  rep movsw
  db 0x8D, 0x47, 0x7C          ; 000010ED  lea ax,[bx+0x7c]
  db 0xE8, 0x51, 0x0F          ; 000010F0  call 0x2044
  db 0xB8, 0x94, 0x6F          ; 000010F3  mov ax,0x6f94
  db 0xE8, 0x4B, 0x0F          ; 000010F6  call 0x2044
  db 0x59                      ; 000010F9  pop cx
  db 0xF3, 0xA5                ; 000010FA  rep movsw
  db 0x8D, 0x87, 0x80, 0x00    ; 000010FC  lea ax,[bx+0x80]
  db 0xE8, 0x41, 0x0F          ; 00001100  call 0x2044
  db 0xB8, 0x94, 0x6F          ; 00001103  mov ax,0x6f94
  db 0xE8, 0x3B, 0x0F          ; 00001106  call 0x2044
  db 0x59                      ; 00001109  pop cx
  db 0xF3, 0xA5                ; 0000110A  rep movsw
  db 0x53                      ; 0000110C  push bx
  db 0x2E, 0x8B, 0x1E, 0x8D, 0x2F ; 0000110D  mov bx,[cs:0x2f8d]
  db 0x8B, 0x4F, 0x48          ; 00001112  mov cx,[bx+0x48]
  db 0x5B                      ; 00001115  pop bx
  db 0xE9, 0xF1, 0x00          ; 00001116  jmp 0x120a
  db 0xB0, 0x05                ; 00001119  mov al,0x5
  db 0xEB, 0x02                ; 0000111B  jmp short 0x111f
  db 0xB0, 0x03                ; 0000111D  mov al,0x3
  db 0xE8, 0xFA, 0x00          ; 0000111F  call 0x121c
  db 0xB9, 0x3E, 0x00          ; 00001122  mov cx,0x3e
  db 0xF3, 0xA5                ; 00001125  rep movsw
  db 0x2E, 0x88, 0x87, 0x80, 0x00 ; 00001127  mov [cs:bx+0x80],al
  db 0xFE, 0xC0                ; 0000112C  inc al
  db 0x2E, 0x88, 0x47, 0x7C    ; 0000112E  mov [cs:bx+0x7c],al
  db 0x2E, 0x8B, 0x3E, 0x8F, 0x2F ; 00001132  mov di,[cs:0x2f8f]
  db 0xD1, 0xE7                ; 00001137  shl di,1
  db 0xD1, 0xE7                ; 00001139  shl di,1
  db 0x03, 0xFB                ; 0000113B  add di,bx
  db 0x8D, 0x47, 0x7C          ; 0000113D  lea ax,[bx+0x7c]
  db 0xE8, 0x01, 0x0F          ; 00001140  call 0x2044
  db 0x2E, 0x8B, 0x3E, 0x91, 0x2F ; 00001143  mov di,[cs:0x2f91]
  db 0x47                      ; 00001148  inc di
  db 0x47                      ; 00001149  inc di
  db 0xD1, 0xE7                ; 0000114A  shl di,1
  db 0xD1, 0xE7                ; 0000114C  shl di,1
  db 0x03, 0xFB                ; 0000114E  add di,bx
  db 0x8D, 0x87, 0x80, 0x00    ; 00001150  lea ax,[bx+0x80]
  db 0xE8, 0xED, 0x0E          ; 00001154  call 0x2044
  db 0x2E, 0x80, 0x36, 0xFA, 0x6D, 0x80 ; 00001157  xor byte [cs:0x6dfa],0x80
  db 0xC3                      ; 0000115D  ret
  db 0xE8, 0xBB, 0x00          ; 0000115E  call 0x121c
  db 0x2E, 0x80, 0x47, 0x7C, 0x04 ; 00001161  add byte [cs:bx+0x7c],0x4
  db 0x2E, 0x80, 0x87, 0x80, 0x00, 0x04 ; 00001166  add byte [cs:bx+0x80],0x4
  db 0x2E, 0x80, 0x36, 0xFA, 0x6D, 0x80 ; 0000116C  xor byte [cs:0x6dfa],0x80
  db 0xC3                      ; 00001172  ret
  db 0xE8, 0xA6, 0x00          ; 00001173  call 0x121c
  db 0x2E, 0x80, 0x6F, 0x7C, 0x04 ; 00001176  sub byte [cs:bx+0x7c],0x4
  db 0x2E, 0x80, 0xAF, 0x80, 0x00, 0x04 ; 0000117B  sub byte [cs:bx+0x80],0x4
  db 0x2E, 0x80, 0x36, 0xFA, 0x6D, 0x80 ; 00001181  xor byte [cs:0x6dfa],0x80
  db 0xC3                      ; 00001187  ret
  db 0x2E, 0x8B, 0x1E, 0x8D, 0x2F ; 00001188  mov bx,[cs:0x2f8d]
  db 0x8B, 0x4F, 0x48          ; 0000118D  mov cx,[bx+0x48]
  db 0x53                      ; 00001190  push bx
  db 0xBB, 0xA0, 0x2F          ; 00001191  mov bx,0x2fa0
  db 0xE8, 0x54, 0x00          ; 00001194  call 0x11eb
  db 0x2E, 0x80, 0x36, 0xFA, 0x6D, 0x80 ; 00001197  xor byte [cs:0x6dfa],0x80
  db 0x5B                      ; 0000119D  pop bx
  db 0xC6, 0x47, 0x35, 0x00    ; 0000119E  mov byte [bx+0x35],0x0
  db 0xC3                      ; 000011A2  ret
  db 0x2E, 0x8B, 0x1E, 0x8D, 0x2F ; 000011A3  mov bx,[cs:0x2f8d]
  db 0x2E, 0xA0, 0x93, 0x2F    ; 000011A8  mov al,[cs:0x2f93]
  db 0x0A, 0xC0                ; 000011AC  or al,al
  db 0x75, 0x09                ; 000011AE  jnz 0x11b9
  db 0x80, 0x67, 0x6B, 0xFE    ; 000011B0  and byte [bx+0x6b],0xfe
  db 0xE8, 0xE0, 0xFC          ; 000011B4  call 0xe97
  db 0x32, 0xC0                ; 000011B7  xor al,al
  db 0xC3                      ; 000011B9  ret
  db 0x1E                      ; 000011BA  push ds
  db 0x07                      ; 000011BB  pop es
  db 0x2E, 0x8A, 0x1E, 0x94, 0x2F ; 000011BC  mov bl,[cs:0x2f94]
  db 0x32, 0xFF                ; 000011C1  xor bh,bh
  db 0xD1, 0xE3                ; 000011C3  shl bx,1
  db 0x2E, 0xFF, 0x97, 0xD0, 0x1D ; 000011C5  call [cs:bx+0x1dd0]
  db 0x2E, 0xFE, 0x06, 0x94, 0x2F ; 000011CA  inc byte [cs:0x2f94]
  db 0xC3                      ; 000011CF  ret
  db 0x33, 0x1C                ; 000011D0  xor bx,[si]
  db 0x1D, 0x1D, 0x5E          ; 000011D2  sbb ax,0x5e1d
  db 0x1D, 0x5E, 0x1D          ; 000011D5  sbb ax,0x1d5e
  db 0x88, 0x1D                ; 000011D8  mov [di],bl
  db 0xA3, 0x1D, 0x5A          ; 000011DA  mov [0x5a1d],ax
  db 0x1C, 0x19                ; 000011DD  sbb al,0x19
  db 0x1D, 0x73, 0x1D          ; 000011DF  sbb ax,0x1d73
  db 0x73, 0x1D                ; 000011E2  jnc 0x1201
  db 0x88, 0x1D                ; 000011E4  mov [di],bl
  db 0xA3, 0x1D, 0x8B          ; 000011E6  mov [0x8b1d],ax
  db 0x4F                      ; 000011E9  dec di
  db 0x48                      ; 000011EA  dec ax
  db 0x51                      ; 000011EB  push cx
  db 0x8B, 0xF3                ; 000011EC  mov si,bx
  db 0xBF, 0x7E, 0x6E          ; 000011EE  mov di,0x6e7e
  db 0x2E, 0xF6, 0x06, 0xFA, 0x6D, 0x80 ; 000011F1  test byte [cs:0x6dfa],0x80
  db 0x75, 0x03                ; 000011F7  jnz 0x11fc
  db 0xBF, 0x06, 0x6F          ; 000011F9  mov di,0x6f06
  db 0x51                      ; 000011FC  push cx
  db 0xAD                      ; 000011FD  lodsw
  db 0x2E, 0x8B, 0x16, 0x7E, 0x2F ; 000011FE  mov dx,[cs:0x2f7e]
  db 0xE8, 0x40, 0x0E          ; 00001203  call 0x2046
  db 0x59                      ; 00001206  pop cx
  db 0xE2, 0xF3                ; 00001207  loop 0x11fc
  db 0x59                      ; 00001209  pop cx
  db 0x83, 0xF9, 0x18          ; 0000120A  cmp cx,byte +0x18
  db 0x77, 0x06                ; 0000120D  ja 0x1215
  db 0xB8, 0x9E, 0x6F          ; 0000120F  mov ax,0x6f9e
  db 0xE8, 0x2F, 0x0E          ; 00001212  call 0x2044
  db 0xB8, 0x3E, 0x70          ; 00001215  mov ax,0x703e
  db 0xE8, 0x29, 0x0E          ; 00001218  call 0x2044
  db 0xC3                      ; 0000121B  ret
  db 0xBE, 0x7E, 0x6E          ; 0000121C  mov si,0x6e7e
  db 0xBF, 0x06, 0x6F          ; 0000121F  mov di,0x6f06
  db 0x2E, 0xF6, 0x06, 0xFA, 0x6D, 0x80 ; 00001222  test byte [cs:0x6dfa],0x80
  db 0x74, 0x02                ; 00001228  jz 0x122c
  db 0x87, 0xF7                ; 0000122A  xchg si,di
  db 0x8B, 0xDF                ; 0000122C  mov bx,di
  db 0xC3                      ; 0000122E  ret
  db 0x8B, 0x6F, 0x6B          ; 0000122F  mov bp,[bx+0x6b]
  db 0x2E, 0x89, 0x2E, 0x18, 0x20 ; 00001232  mov [cs:0x2018],bp
  db 0x53                      ; 00001237  push bx
  db 0x1E                      ; 00001238  push ds
  db 0xE8, 0xCC, 0x01          ; 00001239  call 0x1408
  db 0x32, 0xED                ; 0000123C  xor ch,ch
  db 0x8B, 0xD9                ; 0000123E  mov bx,cx
  db 0xB1, 0x05                ; 00001240  mov cl,0x5
  db 0xD3, 0xE3                ; 00001242  shl bx,cl
  db 0xE8, 0x8A, 0x01          ; 00001244  call 0x13d1
  db 0x2E, 0x80, 0x3E, 0x21, 0x20, 0x02 ; 00001247  cmp byte [cs:0x2021],0x2
  db 0x74, 0x07                ; 0000124D  jz 0x1256
  db 0xBD, 0xFF, 0x01          ; 0000124F  mov bp,0x1ff
  db 0xD3, 0xCD                ; 00001252  ror bp,cl
  db 0xEB, 0x1F                ; 00001254  jmp short 0x1275
  db 0x80, 0xF9, 0x03          ; 00001256  cmp cl,0x3
  db 0x7D, 0x0D                ; 00001259  jnl 0x1268
  db 0xBD, 0x03, 0x00          ; 0000125B  mov bp,0x3
  db 0xD3, 0xCD                ; 0000125E  ror bp,cl
  db 0x2E, 0xC6, 0x06, 0x22, 0x20, 0xFF ; 00001260  mov byte [cs:0x2022],0xff
  db 0xEB, 0x0D                ; 00001266  jmp short 0x1275
  db 0xBD, 0xFF, 0x03          ; 00001268  mov bp,0x3ff
  db 0x2E, 0xC6, 0x06, 0x22, 0x20, 0x00 ; 0000126B  mov byte [cs:0x2022],0x0
  db 0xD3, 0xCD                ; 00001271  ror bp,cl
  db 0xD0, 0xE9                ; 00001273  shr cl,1
  db 0xB5, 0x0A                ; 00001275  mov ch,0xa
  db 0x26, 0x8B, 0x07          ; 00001277  mov ax,[es:bx]
  db 0x2E, 0xF7, 0x06, 0x18, 0x20, 0x00, 0x04 ; 0000127A  test word [cs:0x2018],0x400
  db 0x74, 0x02                ; 00001281  jz 0x1285
  db 0xF7, 0xD0                ; 00001283  not ax
  db 0x25, 0x00, 0xFE          ; 00001285  and ax,0xfe00
  db 0x2E, 0x80, 0x3E, 0x21, 0x20, 0x02 ; 00001288  cmp byte [cs:0x2021],0x2
  db 0x75, 0x12                ; 0000128E  jnz 0x12a2
  db 0x2E, 0x80, 0x3E, 0x22, 0x20, 0x00 ; 00001290  cmp byte [cs:0x2022],0x0
  db 0x74, 0x0A                ; 00001296  jz 0x12a2
  db 0x51                      ; 00001298  push cx
  db 0xB9, 0x08, 0x00          ; 00001299  mov cx,0x8
  db 0xE8, 0x54, 0x00          ; 0000129C  call 0x12f3
  db 0x8B, 0xC2                ; 0000129F  mov ax,dx
  db 0x59                      ; 000012A1  pop cx
  db 0xD3, 0xC8                ; 000012A2  ror ax,cl
  db 0x2E, 0x80, 0x3E, 0x21, 0x20, 0x02 ; 000012A4  cmp byte [cs:0x2021],0x2
  db 0x75, 0x08                ; 000012AA  jnz 0x12b4
  db 0x2E, 0x80, 0x3E, 0x22, 0x20, 0x00 ; 000012AC  cmp byte [cs:0x2022],0x0
  db 0x74, 0x0E                ; 000012B2  jz 0x12c2
  db 0x8A, 0x34                ; 000012B4  mov dh,[si]
  db 0x8A, 0x15                ; 000012B6  mov dl,[di]
  db 0x23, 0xD5                ; 000012B8  and dx,bp
  db 0x0B, 0xD0                ; 000012BA  or dx,ax
  db 0x88, 0x34                ; 000012BC  mov [si],dh
  db 0x88, 0x15                ; 000012BE  mov [di],dl
  db 0xEB, 0x20                ; 000012C0  jmp short 0x12e2
  db 0x8B, 0xD5                ; 000012C2  mov dx,bp
  db 0x20, 0x34                ; 000012C4  and [si],dh
  db 0x20, 0x94, 0x00, 0x02    ; 000012C6  and [si+0x200],dl
  db 0x51                      ; 000012CA  push cx
  db 0xB9, 0x04, 0x00          ; 000012CB  mov cx,0x4
  db 0xE8, 0x22, 0x00          ; 000012CE  call 0x12f3
  db 0x52                      ; 000012D1  push dx
  db 0xB9, 0x08, 0x00          ; 000012D2  mov cx,0x8
  db 0xE8, 0x1B, 0x00          ; 000012D5  call 0x12f3
  db 0x58                      ; 000012D8  pop ax
  db 0x59                      ; 000012D9  pop cx
  db 0x08, 0x04                ; 000012DA  or [si],al
  db 0x88, 0x35                ; 000012DC  mov [di],dh
  db 0x08, 0x94, 0x00, 0x02    ; 000012DE  or [si+0x200],dl
  db 0x43                      ; 000012E2  inc bx
  db 0x43                      ; 000012E3  inc bx
  db 0x46                      ; 000012E4  inc si
  db 0x46                      ; 000012E5  inc si
  db 0x47                      ; 000012E6  inc di
  db 0x47                      ; 000012E7  inc di
  db 0xFE, 0xCD                ; 000012E8  dec ch
  db 0x75, 0x8B                ; 000012EA  jnz 0x1277
  db 0x1F                      ; 000012EC  pop ds
  db 0x5B                      ; 000012ED  pop bx
  db 0xC6, 0x47, 0x35, 0x00    ; 000012EE  mov byte [bx+0x35],0x0
  db 0xC3                      ; 000012F2  ret
  db 0x33, 0xD2                ; 000012F3  xor dx,dx
  db 0xD1, 0xE0                ; 000012F5  shl ax,1
  db 0xD1, 0xD2                ; 000012F7  rcl dx,1
  db 0xD1, 0xC2                ; 000012F9  rol dx,1
  db 0xE2, 0xF8                ; 000012FB  loop 0x12f5
  db 0xC3                      ; 000012FD  ret
  db 0xF6, 0x47, 0x6B, 0x04    ; 000012FE  test byte [bx+0x6b],0x4
  db 0x74, 0x37                ; 00001302  jz 0x133b
  db 0xF7, 0x47, 0x6B, 0x00, 0x02 ; 00001304  test word [bx+0x6b],0x200
  db 0x75, 0x30                ; 00001309  jnz 0x133b
  db 0x1E                      ; 0000130B  push ds
  db 0xE8, 0xF9, 0x00          ; 0000130C  call 0x1408
  db 0x2E, 0x8B, 0x16, 0x1A, 0x20 ; 0000130F  mov dx,[cs:0x201a]
  db 0x2E, 0x8B, 0x36, 0x1D, 0x20 ; 00001314  mov si,[cs:0x201d]
  db 0x2E, 0x8B, 0x3E, 0x1F, 0x20 ; 00001319  mov di,[cs:0x201f]
  db 0x30, 0x34                ; 0000131E  xor [si],dh
  db 0x2E, 0x80, 0x3E, 0x21, 0x20, 0x02 ; 00001320  cmp byte [cs:0x2021],0x2
  db 0x74, 0x04                ; 00001326  jz 0x132c
  db 0x30, 0x15                ; 00001328  xor [di],dl
  db 0xEB, 0x0A                ; 0000132A  jmp short 0x1336
  db 0x30, 0x15                ; 0000132C  xor [di],dl
  db 0x2E, 0xA0, 0x1C, 0x20    ; 0000132E  mov al,[cs:0x201c]
  db 0x30, 0x84, 0x00, 0x02    ; 00001332  xor [si+0x200],al
  db 0x1F                      ; 00001336  pop ds
  db 0xC6, 0x47, 0x35, 0x00    ; 00001337  mov byte [bx+0x35],0x0
  db 0xC3                      ; 0000133B  ret
  db 0xE8, 0xBF, 0xFF          ; 0000133C  call 0x12fe
  db 0xF7, 0x47, 0x6B, 0x00, 0x02 ; 0000133F  test word [bx+0x6b],0x200
  db 0x75, 0xF5                ; 00001344  jnz 0x133b
  db 0x8B, 0x47, 0x64          ; 00001346  mov ax,[bx+0x64]
  db 0x8B, 0x57, 0x66          ; 00001349  mov dx,[bx+0x66]
  db 0x1E                      ; 0000134C  push ds
  db 0xE8, 0xB8, 0x00          ; 0000134D  call 0x1408
  db 0xE8, 0x7E, 0x00          ; 00001350  call 0x13d1
  db 0x83, 0xC6, 0x12          ; 00001353  add si,byte +0x12
  db 0x83, 0xC7, 0x12          ; 00001356  add di,byte +0x12
  db 0x2E, 0x80, 0x3E, 0x21, 0x20, 0x02 ; 00001359  cmp byte [cs:0x2021],0x2
  db 0x74, 0x0B                ; 0000135F  jz 0x136c
  db 0xBA, 0x00, 0xFE          ; 00001361  mov dx,0xfe00
  db 0xD3, 0xCA                ; 00001364  ror dx,cl
  db 0x30, 0x34                ; 00001366  xor [si],dh
  db 0x30, 0x15                ; 00001368  xor [di],dl
  db 0xEB, 0x17                ; 0000136A  jmp short 0x1383
  db 0xBA, 0xFC, 0xFF          ; 0000136C  mov dx,0xfffc
  db 0x8A, 0xE2                ; 0000136F  mov ah,dl
  db 0x32, 0xC0                ; 00001371  xor al,al
  db 0xD3, 0xEA                ; 00001373  shr dx,cl
  db 0xD3, 0xE8                ; 00001375  shr ax,cl
  db 0x30, 0x34                ; 00001377  xor [si],dh
  db 0x30, 0x15                ; 00001379  xor [di],dl
  db 0x30, 0x84, 0x00, 0x02    ; 0000137B  xor [si+0x200],al
  db 0x2E, 0xA2, 0x1C, 0x20    ; 0000137F  mov [cs:0x201c],al
  db 0x2E, 0x89, 0x16, 0x1A, 0x20 ; 00001383  mov [cs:0x201a],dx
  db 0x2E, 0x89, 0x36, 0x1D, 0x20 ; 00001388  mov [cs:0x201d],si
  db 0x2E, 0x89, 0x3E, 0x1F, 0x20 ; 0000138D  mov [cs:0x201f],di
  db 0x1F                      ; 00001392  pop ds
  db 0xC6, 0x47, 0x35, 0x00    ; 00001393  mov byte [bx+0x35],0x0
  db 0xC3                      ; 00001397  ret
  db 0x57                      ; 00001398  push di
  db 0x1E                      ; 00001399  push ds
  db 0x8B, 0xC7                ; 0000139A  mov ax,di
  db 0x2B, 0xC6                ; 0000139C  sub ax,si
  db 0xB4, 0x0A                ; 0000139E  mov ah,0xa
  db 0xF6, 0xE4                ; 000013A0  mul ah
  db 0x8B, 0xC8                ; 000013A2  mov cx,ax
  db 0x8B, 0xC6                ; 000013A4  mov ax,si
  db 0xB4, 0x0A                ; 000013A6  mov ah,0xa
  db 0xF6, 0xE4                ; 000013A8  mul ah
  db 0xD1, 0xE0                ; 000013AA  shl ax,1
  db 0x8B, 0xF8                ; 000013AC  mov di,ax
  db 0xBA, 0x23, 0x00          ; 000013AE  mov dx,0x23
  db 0xE8, 0x54, 0x00          ; 000013B1  call 0x1408
  db 0x1E                      ; 000013B4  push ds
  db 0x07                      ; 000013B5  pop es
  db 0x8B, 0xF7                ; 000013B6  mov si,di
  db 0x83, 0xC6, 0x14          ; 000013B8  add si,byte +0x14
  db 0x57                      ; 000013BB  push di
  db 0x51                      ; 000013BC  push cx
  db 0xF3, 0xA5                ; 000013BD  rep movsw
  db 0x59                      ; 000013BF  pop cx
  db 0x5F                      ; 000013C0  pop di
  db 0x81, 0xC7, 0x00, 0x02    ; 000013C1  add di,0x200
  db 0x4A                      ; 000013C5  dec dx
  db 0x75, 0xEE                ; 000013C6  jnz 0x13b6
  db 0x1F                      ; 000013C8  pop ds
  db 0x5E                      ; 000013C9  pop si
  db 0xC6, 0x47, 0x35, 0x00    ; 000013CA  mov byte [bx+0x35],0x0
  db 0xE9, 0x35, 0xFB          ; 000013CE  jmp 0xf06
  db 0xB4, 0x0A                ; 000013D1  mov ah,0xa
  db 0xF6, 0xE4                ; 000013D3  mul ah
  db 0x8B, 0xF0                ; 000013D5  mov si,ax
  db 0xB8, 0x07, 0x00          ; 000013D7  mov ax,0x7
  db 0xF7, 0xE2                ; 000013DA  mul dx
  db 0x2E, 0x80, 0x3E, 0x21, 0x20, 0x02 ; 000013DC  cmp byte [cs:0x2021],0x2
  db 0x75, 0x02                ; 000013E2  jnz 0x13e6
  db 0xD1, 0xE0                ; 000013E4  shl ax,1
  db 0x8B, 0xC8                ; 000013E6  mov cx,ax
  db 0x25, 0xF0, 0xFF          ; 000013E8  and ax,0xfff0
  db 0xBA, 0x10, 0x00          ; 000013EB  mov dx,0x10
  db 0xF7, 0xE2                ; 000013EE  mul dx
  db 0x03, 0xF0                ; 000013F0  add si,ax
  db 0xD1, 0xE6                ; 000013F2  shl si,1
  db 0x8B, 0xFE                ; 000013F4  mov di,si
  db 0xF7, 0xC1, 0x08, 0x00    ; 000013F6  test cx,0x8
  db 0x75, 0x03                ; 000013FA  jnz 0x13ff
  db 0x46                      ; 000013FC  inc si
  db 0xEB, 0x04                ; 000013FD  jmp short 0x1403
  db 0x81, 0xC7, 0x01, 0x02    ; 000013FF  add di,0x201
  db 0x81, 0xE1, 0x07, 0x00    ; 00001403  and cx,0x7
  db 0xC3                      ; 00001407  ret
  db 0x50                      ; 00001408  push ax
  db 0xE8, 0x10, 0x07          ; 00001409  call 0x1b1c
  db 0x58                      ; 0000140C  pop ax
  db 0x2E, 0x8E, 0x06, 0xDB, 0x2F ; 0000140D  mov es,[cs:0x2fdb]
  db 0x2E, 0x8E, 0x1E, 0xDD, 0x2F ; 00001412  mov ds,[cs:0x2fdd]
  db 0xC3                      ; 00001417  ret
  db 0x00, 0x00                ; 00001418  add [bx+si],al
  db 0x00, 0x00                ; 0000141A  add [bx+si],al
  db 0x00, 0x00                ; 0000141C  add [bx+si],al
  db 0x00, 0x00                ; 0000141E  add [bx+si],al
  db 0x00, 0x00                ; 00001420  add [bx+si],al
  db 0x00, 0x33                ; 00001422  add [bp+di],dh
  db 0xC9                      ; 00001424  leave
  db 0x8A, 0x0D                ; 00001425  mov cl,[di]
  db 0x47                      ; 00001427  inc di
  db 0x41                      ; 00001428  inc cx
  db 0xF2, 0xAE                ; 00001429  repne scasb
  db 0x5E                      ; 0000142B  pop si
  db 0xD1, 0xE1                ; 0000142C  shl cx,1
  db 0x03, 0xF1                ; 0000142E  add si,cx
  db 0xFF, 0x24                ; 00001430  jmp [si]
  db 0x2E, 0x3A, 0x16, 0x19, 0x2D ; 00001432  cmp dl,[cs:0x2d19]
  db 0x75, 0x01                ; 00001437  jnz 0x143a
  db 0xC3                      ; 00001439  ret
  db 0x2E, 0x8B, 0x1E, 0x1B, 0x2D ; 0000143A  mov bx,[cs:0x2d1b]
  db 0xE8, 0xBE, 0x00          ; 0000143F  call 0x1500
  db 0x74, 0x01                ; 00001442  jz 0x1445
  db 0xC3                      ; 00001444  ret
  db 0x2E, 0x80, 0x3E, 0xB1, 0x10, 0x00 ; 00001445  cmp byte [cs:0x10b1],0x0
  db 0x74, 0x06                ; 0000144B  jz 0x1453
  db 0x2E, 0xC6, 0x06, 0xB1, 0x10, 0x01 ; 0000144D  mov byte [cs:0x10b1],0x1
  db 0xE8, 0xD5, 0x06          ; 00001453  call 0x1b2b
  db 0xF6, 0x47, 0x6B, 0x01    ; 00001456  test byte [bx+0x6b],0x1
  db 0x74, 0x03                ; 0000145A  jz 0x145f
  db 0xE8, 0x09, 0x08          ; 0000145C  call 0x1c68
  db 0x80, 0x4F, 0x6B, 0x02    ; 0000145F  or byte [bx+0x6b],0x2
  db 0x8A, 0x4F, 0x70          ; 00001463  mov cl,[bx+0x70]
  db 0xE8, 0xDF, 0x07          ; 00001466  call 0x1c48
  db 0x2E, 0x89, 0x1E, 0x1B, 0x2D ; 00001469  mov [cs:0x2d1b],bx
  db 0x80, 0x67, 0x6B, 0xFD    ; 0000146E  and byte [bx+0x6b],0xfd
  db 0x3A, 0x4F, 0x70          ; 00001472  cmp cl,[bx+0x70]
  db 0x74, 0x2E                ; 00001475  jz 0x14a5
  db 0x06                      ; 00001477  push es
  db 0x2E, 0xC4, 0x36, 0xD6, 0x2F ; 00001478  les si,[cs:0x2fd6]
  db 0xB0, 0xFF                ; 0000147D  mov al,0xff
  db 0x26, 0x86, 0x04          ; 0000147F  xchg al,[es:si]
  db 0x0A, 0xC0                ; 00001482  or al,al
  db 0x74, 0x05                ; 00001484  jz 0x148b
  db 0xE8, 0xDF, 0x07          ; 00001486  call 0x1c68
  db 0xEB, 0xF2                ; 00001489  jmp short 0x147d
  db 0x56                      ; 0000148B  push si
  db 0x06                      ; 0000148C  push es
  db 0xB4, 0x03                ; 0000148D  mov ah,0x3
  db 0xE8, 0x92, 0x0B          ; 0000148F  call 0x2024
  db 0xE8, 0xF9, 0x03          ; 00001492  call 0x188e
  db 0x07                      ; 00001495  pop es
  db 0x5E                      ; 00001496  pop si
  db 0x2E, 0x8B, 0x16, 0xDD, 0x2F ; 00001497  mov dx,[cs:0x2fdd]
  db 0x26, 0x89, 0x54, 0x01    ; 0000149C  mov [es:si+0x1],dx
  db 0x26, 0xC6, 0x04, 0x00    ; 000014A0  mov byte [es:si],0x0
  db 0x07                      ; 000014A4  pop es
  db 0x06                      ; 000014A5  push es
  db 0x1E                      ; 000014A6  push ds
  db 0x07                      ; 000014A7  pop es
  db 0x8A, 0x57, 0x34          ; 000014A8  mov dl,[bx+0x34]
  db 0xE8, 0xDC, 0x06          ; 000014AB  call 0x1b8a
  db 0x2E, 0xC7, 0x06, 0x12, 0x6E, 0xFF, 0xFF ; 000014AE  mov word [cs:0x6e12],0xffff
  db 0xE8, 0x23, 0x0C          ; 000014B5  call 0x20db
  db 0xE8, 0x4C, 0x06          ; 000014B8  call 0x1b07
  db 0x8B, 0x4F, 0x48          ; 000014BB  mov cx,[bx+0x48]
  db 0x53                      ; 000014BE  push bx
  db 0x2E, 0xC6, 0x06, 0x1D, 0x2D, 0xFF ; 000014BF  mov byte [cs:0x2d1d],0xff
  db 0xF6, 0x47, 0x6B, 0x04    ; 000014C5  test byte [bx+0x6b],0x4
  db 0x75, 0x15                ; 000014C9  jnz 0x14e0
  db 0xF6, 0x47, 0x6B, 0x10    ; 000014CB  test byte [bx+0x6b],0x10
  db 0x74, 0x0F                ; 000014CF  jz 0x14e0
  db 0x2E, 0xC6, 0x06, 0x1D, 0x2D, 0x00 ; 000014D1  mov byte [cs:0x2d1d],0x0
  db 0xE8, 0x30, 0x08          ; 000014D7  call 0x1d0a
  db 0xBB, 0x4A, 0x70          ; 000014DA  mov bx,0x704a
  db 0xB9, 0x18, 0x00          ; 000014DD  mov cx,0x18
  db 0xE8, 0x08, 0xFD          ; 000014E0  call 0x11eb
  db 0x5B                      ; 000014E3  pop bx
  db 0x2E, 0x80, 0x36, 0xFA, 0x6D, 0x80 ; 000014E4  xor byte [cs:0x6dfa],0x80
  db 0xE8, 0x05, 0x0C          ; 000014EA  call 0x20f2
  db 0xB4, 0x01                ; 000014ED  mov ah,0x1
  db 0xE8, 0x32, 0x0B          ; 000014EF  call 0x2024
  db 0xF6, 0x47, 0x6B, 0x04    ; 000014F2  test byte [bx+0x6b],0x4
  db 0x75, 0x03                ; 000014F6  jnz 0x14fb
  db 0xE8, 0x9C, 0xF9          ; 000014F8  call 0xe97
  db 0xE8, 0x41, 0x06          ; 000014FB  call 0x1b3f
  db 0x07                      ; 000014FE  pop es
  db 0xC3                      ; 000014FF  ret
  db 0x8B, 0x77, 0x5C          ; 00001500  mov si,[bx+0x5c]
  db 0xF7, 0x44, 0x0E, 0x08, 0x00 ; 00001503  test word [si+0xe],0x8
  db 0xC3                      ; 00001508  ret
  db 0x33, 0xC9                ; 00001509  xor cx,cx
  db 0xBB, 0x75, 0x22          ; 0000150B  mov bx,0x2275
  db 0xB0, 0xFF                ; 0000150E  mov al,0xff
  db 0x2E, 0x86, 0x06, 0x98, 0x22 ; 00001510  xchg al,[cs:0x2298]
  db 0x3C, 0xFF                ; 00001515  cmp al,0xff
  db 0x75, 0x05                ; 00001517  jnz 0x151e
  db 0xE8, 0x4C, 0x07          ; 00001519  call 0x1c68
  db 0xEB, 0xF0                ; 0000151C  jmp short 0x150e
  db 0xFC                      ; 0000151E  cld
  db 0x06                      ; 0000151F  push es
  db 0x1E                      ; 00001520  push ds
  db 0x53                      ; 00001521  push bx
  db 0x8C, 0xC8                ; 00001522  mov ax,cs
  db 0x8E, 0xC0                ; 00001524  mov es,ax
  db 0xB0, 0xFF                ; 00001526  mov al,0xff
  db 0xE3, 0x05                ; 00001528  jcxz 0x152f
  db 0x2E, 0x89, 0x0E, 0x99, 0x22 ; 0000152A  mov [cs:0x2299],cx
  db 0x2E, 0x83, 0x3E, 0x99, 0x22, 0xFF ; 0000152F  cmp word [cs:0x2299],byte -0x1
  db 0x74, 0x0D                ; 00001535  jz 0x1544
  db 0xE3, 0x07                ; 00001537  jcxz 0x1540
  db 0x8E, 0xDA                ; 00001539  mov ds,dx
  db 0x8B, 0xF1                ; 0000153B  mov si,cx
  db 0xE9, 0x1C, 0x01          ; 0000153D  jmp 0x165c
  db 0x5B                      ; 00001540  pop bx
  db 0xE9, 0x28, 0x01          ; 00001541  jmp 0x166c
  db 0xBF, 0xDA, 0x4B          ; 00001544  mov di,0x4bda
  db 0xB0, 0x20                ; 00001547  mov al,0x20
  db 0xB9, 0x09, 0x4C          ; 00001549  mov cx,0x4c09
  db 0x2B, 0xCF                ; 0000154C  sub cx,di
  db 0xF3, 0xAA                ; 0000154E  rep stosb
  db 0xBF, 0x11, 0x4C          ; 00001550  mov di,0x4c11
  db 0xB9, 0x19, 0x4C          ; 00001553  mov cx,0x4c19
  db 0x2B, 0xCF                ; 00001556  sub cx,di
  db 0xF3, 0xAA                ; 00001558  rep stosb
  db 0x2E, 0xA0, 0x19, 0x2D    ; 0000155A  mov al,[cs:0x2d19]
  db 0x04, 0x30                ; 0000155E  add al,0x30
  db 0x2E, 0xA2, 0xDA, 0x4B    ; 00001560  mov [cs:0x4bda],al
  db 0x2E, 0xC7, 0x06, 0x11, 0x4C, 0x30, 0x20 ; 00001564  mov word [cs:0x4c11],0x2030
  db 0x2E, 0x8B, 0x1E, 0x1B, 0x2D ; 0000156B  mov bx,[cs:0x2d1b]
  db 0x8B, 0x5F, 0x5C          ; 00001570  mov bx,[bx+0x5c]
  db 0x8B, 0x37                ; 00001573  mov si,[bx]
  db 0x85, 0xF6                ; 00001575  test si,si
  db 0x74, 0x15                ; 00001577  jz 0x158e
  db 0x8A, 0x44, 0x24          ; 00001579  mov al,[si+0x24]
  db 0xE8, 0x09, 0x01          ; 0000157C  call 0x1688
  db 0x2E, 0xA3, 0x11, 0x4C    ; 0000157F  mov [cs:0x4c11],ax
  db 0x8D, 0x74, 0x08          ; 00001583  lea si,[si+0x8]
  db 0xBF, 0xE5, 0x4B          ; 00001586  mov di,0x4be5
  db 0xB9, 0x04, 0x00          ; 00001589  mov cx,0x4
  db 0xF3, 0xA5                ; 0000158C  rep movsw
  db 0x8B, 0x4F, 0x0E          ; 0000158E  mov cx,[bx+0xe]
  db 0xF7, 0xC1, 0x80, 0x00    ; 00001591  test cx,0x80
  db 0x74, 0x09                ; 00001595  jz 0x15a0
  db 0x2E, 0xC7, 0x06, 0x00, 0x4C, 0x92, 0x53 ; 00001597  mov word [cs:0x4c00],0x5392
  db 0xEB, 0x0D                ; 0000159E  jmp short 0x15ad
  db 0xF7, 0xC1, 0x00, 0x01    ; 000015A0  test cx,0x100
  db 0x74, 0x07                ; 000015A4  jz 0x15ad
  db 0x2E, 0xC7, 0x06, 0x00, 0x4C, 0x92, 0x4F ; 000015A6  mov word [cs:0x4c00],0x4f92
  db 0xF7, 0xC1, 0x00, 0x02    ; 000015AD  test cx,0x200
  db 0x74, 0x14                ; 000015B1  jz 0x15c7
  db 0xBF, 0x03, 0x4C          ; 000015B3  mov di,0x4c03
  db 0xC7, 0x05, 0x92, 0x50    ; 000015B6  mov word [di],0x5092
  db 0xC6, 0x45, 0x02, 0x3D    ; 000015BA  mov byte [di+0x2],0x3d
  db 0x8A, 0x47, 0x08          ; 000015BE  mov al,[bx+0x8]
  db 0xE8, 0xC4, 0x00          ; 000015C1  call 0x1688
  db 0x89, 0x45, 0x03          ; 000015C4  mov [di+0x3],ax
  db 0xBE, 0x3A, 0x4C          ; 000015C7  mov si,0x4c3a
  db 0xF7, 0xC1, 0x08, 0x00    ; 000015CA  test cx,0x8
  db 0x75, 0x15                ; 000015CE  jnz 0x15e5
  db 0xBE, 0x22, 0x4C          ; 000015D0  mov si,0x4c22
  db 0xF7, 0xC1, 0x01, 0x00    ; 000015D3  test cx,0x1
  db 0x74, 0x0C                ; 000015D7  jz 0x15e5
  db 0xBE, 0x2A, 0x4C          ; 000015D9  mov si,0x4c2a
  db 0xF7, 0xC1, 0x04, 0x00    ; 000015DC  test cx,0x4
  db 0x74, 0x03                ; 000015E0  jz 0x15e5
  db 0xBE, 0x32, 0x4C          ; 000015E2  mov si,0x4c32
  db 0xBF, 0xDC, 0x4B          ; 000015E5  mov di,0x4bdc
  db 0xB9, 0x08, 0x00          ; 000015E8  mov cx,0x8
  db 0xF3, 0xA4                ; 000015EB  rep movsb
  db 0xB9, 0x10, 0x00          ; 000015ED  mov cx,0x10
  db 0xB4, 0x41                ; 000015F0  mov ah,0x41
  db 0xB0, 0x20                ; 000015F2  mov al,0x20
  db 0x2E, 0x8B, 0x16, 0x88, 0x00 ; 000015F4  mov dx,[cs:0x88]
  db 0xBF, 0xEF, 0x4B          ; 000015F9  mov di,0x4bef
  db 0xD1, 0xEA                ; 000015FC  shr dx,1
  db 0x73, 0x07                ; 000015FE  jnc 0x1607
  db 0x86, 0xE0                ; 00001600  xchg ah,al
  db 0xAA                      ; 00001602  stosb
  db 0x86, 0xE0                ; 00001603  xchg ah,al
  db 0xEB, 0x01                ; 00001605  jmp short 0x1608
  db 0xAA                      ; 00001607  stosb
  db 0xFE, 0xC4                ; 00001608  inc ah
  db 0xE2, 0xF0                ; 0000160A  loop 0x15fc
  db 0xBE, 0x80, 0x00          ; 0000160C  mov si,0x80
  db 0xBF, 0x19, 0x4C          ; 0000160F  mov di,0x4c19
  db 0xB9, 0x03, 0x00          ; 00001612  mov cx,0x3
  db 0xAC                      ; 00001615  lodsb
  db 0xE8, 0x66, 0x00          ; 00001616  call 0x167f
  db 0xAB                      ; 00001619  stosw
  db 0x47                      ; 0000161A  inc di
  db 0xE2, 0xF8                ; 0000161B  loop 0x1615
  db 0x2E, 0xA0, 0x46, 0x10    ; 0000161D  mov al,[cs:0x1046]
  db 0xA8, 0x20                ; 00001621  test al,0x20
  db 0x74, 0x0B                ; 00001623  jz 0x1630
  db 0xBE, 0x42, 0x4C          ; 00001625  mov si,0x4c42
  db 0xBF, 0x14, 0x4C          ; 00001628  mov di,0x4c14
  db 0xB9, 0x04, 0x00          ; 0000162B  mov cx,0x4
  db 0xF3, 0xA4                ; 0000162E  rep movsb
  db 0x2E, 0x80, 0x3E, 0x14, 0x2D, 0x00 ; 00001630  cmp byte [cs:0x2d14],0x0
  db 0x74, 0x06                ; 00001636  jz 0x163e
  db 0x2E, 0xC6, 0x06, 0xEE, 0x4B, 0x07 ; 00001638  mov byte [cs:0x4bee],0x7
  db 0x2E, 0xF6, 0x06, 0x1D, 0x2D, 0xFF ; 0000163E  test byte [cs:0x2d1d],0xff
  db 0x75, 0x13                ; 00001644  jnz 0x1659
  db 0xB9, 0x04, 0x00          ; 00001646  mov cx,0x4
  db 0xBE, 0x80, 0x2F          ; 00001649  mov si,0x2f80
  db 0xAD                      ; 0000164C  lodsw
  db 0x93                      ; 0000164D  xchg ax,bx
  db 0x51                      ; 0000164E  push cx
  db 0x56                      ; 0000164F  push si
  db 0x06                      ; 00001650  push es
  db 0xE8, 0x42, 0x08          ; 00001651  call 0x1e96
  db 0x07                      ; 00001654  pop es
  db 0x5E                      ; 00001655  pop si
  db 0x59                      ; 00001656  pop cx
  db 0xE2, 0xF3                ; 00001657  loop 0x164c
  db 0xBE, 0xD2, 0x4B          ; 00001659  mov si,0x4bd2
  db 0xBF, 0x9E, 0x6F          ; 0000165C  mov di,0x6f9e
  db 0xB4, 0x08                ; 0000165F  mov ah,0x8
  db 0xB9, 0x50, 0x00          ; 00001661  mov cx,0x50
  db 0x5B                      ; 00001664  pop bx
  db 0xFF, 0xD3                ; 00001665  call bx
  db 0xAB                      ; 00001667  stosw
  db 0xE2, 0xFB                ; 00001668  loop 0x1665
  db 0x32, 0xC0                ; 0000166A  xor al,al
  db 0x2E, 0xC6, 0x06, 0x98, 0x22, 0x00 ; 0000166C  mov byte [cs:0x2298],0x0
  db 0x1F                      ; 00001672  pop ds
  db 0x07                      ; 00001673  pop es
  db 0xC3                      ; 00001674  ret
  db 0xAC                      ; 00001675  lodsb
  db 0xC3                      ; 00001676  ret
  db 0xAD                      ; 00001677  lodsw
  db 0xC3                      ; 00001678  ret
  db 0xBB, 0x77, 0x22          ; 00001679  mov bx,0x2277
  db 0xE9, 0x8F, 0xFE          ; 0000167C  jmp 0x150e
  db 0xB4, 0x33                ; 0000167F  mov ah,0x33
  db 0xC1, 0xC8, 0x04          ; 00001681  ror ax,byte 0x4
  db 0xC0, 0xCC, 0x04          ; 00001684  ror ah,byte 0x4
  db 0xC3                      ; 00001687  ret
  db 0xD4, 0x0A                ; 00001688  aam
  db 0x05, 0x30, 0x30          ; 0000168A  add ax,0x3030
  db 0x86, 0xC4                ; 0000168D  xchg al,ah
  db 0x3C, 0x30                ; 0000168F  cmp al,0x30
  db 0x75, 0x04                ; 00001691  jnz 0x1697
  db 0xB0, 0x20                ; 00001693  mov al,0x20
  db 0x86, 0xC4                ; 00001695  xchg al,ah
  db 0xC3                      ; 00001697  ret
  db 0x00, 0xFF                ; 00001698  add bh,bh
  db 0xFF, 0x06, 0xBF, 0x46    ; 0000169A  inc word [0x46bf]
  db 0x4C                      ; 0000169E  dec sp
  db 0x57                      ; 0000169F  push di
  db 0x57                      ; 000016A0  push di
  db 0x1E                      ; 000016A1  push ds
  db 0x07                      ; 000016A2  pop es
  db 0xB9, 0x32, 0x00          ; 000016A3  mov cx,0x32
  db 0xB0, 0x20                ; 000016A6  mov al,0x20
  db 0xF3, 0xAA                ; 000016A8  rep stosb
  db 0xAC                      ; 000016AA  lodsb
  db 0x8A, 0xC8                ; 000016AB  mov cl,al
  db 0x5F                      ; 000016AD  pop di
  db 0xF3, 0xA4                ; 000016AE  rep movsb
  db 0x2E, 0x8B, 0x1E, 0x1B, 0x2D ; 000016B0  mov bx,[cs:0x2d1b]
  db 0xE8, 0x64, 0x04          ; 000016B5  call 0x1b1c
  db 0xE8, 0xAD, 0x05          ; 000016B8  call 0x1c68
  db 0x2E, 0xC7, 0x06, 0x12, 0x6E, 0xFF, 0xFF ; 000016BB  mov word [cs:0x6e12],0xffff
  db 0xFF, 0x77, 0x48          ; 000016C2  push word [bx+0x48]
  db 0xB8, 0x18, 0x00          ; 000016C5  mov ax,0x18
  db 0xE8, 0x23, 0xF6          ; 000016C8  call 0xcee
  db 0x58                      ; 000016CB  pop ax
  db 0x59                      ; 000016CC  pop cx
  db 0x8C, 0xCA                ; 000016CD  mov dx,cs
  db 0x07                      ; 000016CF  pop es
  db 0x50                      ; 000016D0  push ax
  db 0x53                      ; 000016D1  push bx
  db 0xE8, 0x36, 0xFE          ; 000016D2  call 0x150b
  db 0x2E, 0xFE, 0x06, 0xB1, 0x10 ; 000016D5  inc byte [cs:0x10b1]
  db 0x2E, 0xC6, 0x06, 0x47, 0x10, 0xFF ; 000016DA  mov byte [cs:0x1047],0xff
  db 0xBA, 0x13, 0x00          ; 000016E0  mov dx,0x13
  db 0xE8, 0x4B, 0xEA          ; 000016E3  call 0x131
  db 0xB9, 0xFF, 0xFF          ; 000016E6  mov cx,0xffff
  db 0xE8, 0x1F, 0xFE          ; 000016E9  call 0x150b
  db 0x5B                      ; 000016EC  pop bx
  db 0x58                      ; 000016ED  pop ax
  db 0x06                      ; 000016EE  push es
  db 0xE8, 0xFC, 0xF5          ; 000016EF  call 0xcee
  db 0xC6, 0x47, 0x35, 0x00    ; 000016F2  mov byte [bx+0x35],0x0
  db 0xE8, 0xD6, 0xF7          ; 000016F6  call 0xecf
  db 0x07                      ; 000016F9  pop es
  db 0x2E, 0xA0, 0x40, 0x10    ; 000016FA  mov al,[cs:0x1040]
  db 0xC3                      ; 000016FE  ret
  db 0x8E, 0xC2                ; 000016FF  mov es,dx
  db 0x87, 0xF1                ; 00001701  xchg si,cx
  db 0xE8, 0x7D, 0x01          ; 00001703  call 0x1883
  db 0x2E, 0x83, 0x3E, 0xD8, 0x2F, 0x00 ; 00001706  cmp word [cs:0x2fd8],byte +0x0
  db 0x74, 0x15                ; 0000170C  jz 0x1723
  db 0x2E, 0x3A, 0x16, 0xDA, 0x2F ; 0000170E  cmp dl,[cs:0x2fda]
  db 0x74, 0x0E                ; 00001713  jz 0x1723
  db 0xBE, 0x55, 0x4D          ; 00001715  mov si,0x4d55
  db 0xE8, 0x80, 0xFF          ; 00001718  call 0x169b
  db 0xB1, 0x00                ; 0000171B  mov cl,0x0
  db 0xE8, 0x13, 0xEA          ; 0000171D  call 0x133
  db 0xB0, 0xFF                ; 00001720  mov al,0xff
  db 0xC3                      ; 00001722  ret
  db 0xF6, 0x47, 0x6B, 0x04    ; 00001723  test byte [bx+0x6b],0x4
  db 0x74, 0x0C                ; 00001727  jz 0x1735
  db 0x2E, 0x8B, 0x16, 0xDD, 0x2F ; 00001729  mov dx,[cs:0x2fdd]
  db 0x26, 0x89, 0x54, 0x01    ; 0000172E  mov [es:si+0x1],dx
  db 0xE9, 0xD3, 0x00          ; 00001732  jmp 0x1808
  db 0x2E, 0x88, 0x16, 0xDA, 0x2F ; 00001735  mov [cs:0x2fda],dl
  db 0x2E, 0x89, 0x36, 0xD6, 0x2F ; 0000173A  mov [cs:0x2fd6],si
  db 0x2E, 0x8C, 0x06, 0xD8, 0x2F ; 0000173F  mov [cs:0x2fd8],es
  db 0x26, 0x8B, 0x54, 0x01    ; 00001744  mov dx,[es:si+0x1]
  db 0x2E, 0x89, 0x16, 0xD4, 0x2F ; 00001748  mov [cs:0x2fd4],dx
  db 0x2E, 0x88, 0x26, 0x21, 0x20 ; 0000174D  mov [cs:0x2021],ah
  db 0xBA, 0x4F, 0x00          ; 00001752  mov dx,0x4f
  db 0x80, 0xFC, 0x02          ; 00001755  cmp ah,0x2
  db 0x75, 0x03                ; 00001758  jnz 0x175d
  db 0xBA, 0x27, 0x00          ; 0000175A  mov dx,0x27
  db 0x89, 0x57, 0x60          ; 0000175D  mov [bx+0x60],dx
  db 0x42                      ; 00001760  inc dx
  db 0x88, 0x57, 0x4D          ; 00001761  mov [bx+0x4d],dl
  db 0xE8, 0xC4, 0x03          ; 00001764  call 0x1b2b
  db 0xE8, 0xFE, 0x04          ; 00001767  call 0x1c68
  db 0x80, 0x4F, 0x6B, 0x04    ; 0000176A  or byte [bx+0x6b],0x4
  db 0xC6, 0x47, 0x70, 0x0C    ; 0000176E  mov byte [bx+0x70],0xc
  db 0x2E, 0x8B, 0x16, 0xD4, 0x2F ; 00001772  mov dx,[cs:0x2fd4]
  db 0x2E, 0x89, 0x16, 0xDD, 0x2F ; 00001777  mov [cs:0x2fdd],dx
  db 0xF6, 0x47, 0x6B, 0x02    ; 0000177C  test byte [bx+0x6b],0x2
  db 0x75, 0x08                ; 00001780  jnz 0x178a
  db 0xB4, 0x03                ; 00001782  mov ah,0x3
  db 0xE8, 0x9D, 0x08          ; 00001784  call 0x2024
  db 0xE8, 0x0B, 0x01          ; 00001787  call 0x1895
  db 0x2E, 0x8E, 0x06, 0x7E, 0x2F ; 0000178A  mov es,[cs:0x2f7e]
  db 0x33, 0xF6                ; 0000178F  xor si,si
  db 0xBA, 0x00, 0x00          ; 00001791  mov dx,0x0
  db 0x2E, 0x80, 0x3E, 0x21, 0x20, 0x01 ; 00001794  cmp byte [cs:0x2021],0x1
  db 0x74, 0x03                ; 0000179A  jz 0x179f
  db 0xBA, 0x00, 0x40          ; 0000179C  mov dx,0x4000
  db 0x8B, 0x38                ; 0000179F  mov di,[bx+si]
  db 0x8B, 0xC2                ; 000017A1  mov ax,dx
  db 0xB9, 0x23, 0x00          ; 000017A3  mov cx,0x23
  db 0xAB                      ; 000017A6  stosw
  db 0x05, 0x10, 0x00          ; 000017A7  add ax,0x10
  db 0xE2, 0xFA                ; 000017AA  loop 0x17a6
  db 0x26, 0xC7, 0x05, 0x00, 0x82 ; 000017AC  mov word [es:di],0x8200
  db 0x46                      ; 000017B1  inc si
  db 0x46                      ; 000017B2  inc si
  db 0x42                      ; 000017B3  inc dx
  db 0x80, 0xFA, 0x10          ; 000017B4  cmp dl,0x10
  db 0x72, 0xE6                ; 000017B7  jc 0x179f
  db 0x26, 0xC7, 0x05, 0x00, 0x81 ; 000017B9  mov word [es:di],0x8100
  db 0xB8, 0xC0, 0xCC          ; 000017BE  mov ax,0xccc0
  db 0x2E, 0x80, 0x3E, 0x88, 0x2F, 0xFF ; 000017C1  cmp byte [cs:0x2f88],0xff
  db 0x75, 0x03                ; 000017C7  jnz 0x17cc
  db 0xB8, 0x40, 0x12          ; 000017C9  mov ax,0x1240
  db 0x2E, 0x80, 0x3E, 0x21, 0x20, 0x02 ; 000017CC  cmp byte [cs:0x2021],0x2
  db 0x74, 0x06                ; 000017D2  jz 0x17da
  db 0x8A, 0x47, 0x7F          ; 000017D4  mov al,[bx+0x7f]
  db 0xC0, 0xC8, 0x04          ; 000017D7  ror al,byte 0x4
  db 0x8D, 0xB7, 0x84, 0x00    ; 000017DA  lea si,[bx+0x84]
  db 0x88, 0x04                ; 000017DE  mov [si],al
  db 0x88, 0x64, 0x08          ; 000017E0  mov [si+0x8],ah
  db 0x2E, 0xA1, 0xDD, 0x2F    ; 000017E3  mov ax,[cs:0x2fdd]
  db 0x2E, 0xC4, 0x36, 0xD6, 0x2F ; 000017E7  les si,[cs:0x2fd6]
  db 0x26, 0x89, 0x44, 0x01    ; 000017EC  mov [es:si+0x1],ax
  db 0x8E, 0xC0                ; 000017F0  mov es,ax
  db 0xB9, 0x00, 0x40          ; 000017F2  mov cx,0x4000
  db 0x33, 0xC0                ; 000017F5  xor ax,ax
  db 0x33, 0xFF                ; 000017F7  xor di,di
  db 0xF3, 0xAB                ; 000017F9  rep stosw
  db 0x81, 0x4F, 0x6B, 0x00, 0x02 ; 000017FB  or word [bx+0x6b],0x200
  db 0x2E, 0x8B, 0x1E, 0x1B, 0x2D ; 00001800  mov bx,[cs:0x2d1b]
  db 0xE8, 0x9D, 0xFC          ; 00001805  call 0x14a5
  db 0x8D, 0x5F, 0x35          ; 00001808  lea bx,[bx+0x35]
  db 0x2E, 0x8B, 0x16, 0x06, 0x0C ; 0000180B  mov dx,[cs:0xc06]
  db 0xC3                      ; 00001810  ret
  db 0x2E, 0x83, 0x3E, 0xD8, 0x2F, 0x00 ; 00001811  cmp word [cs:0x2fd8],byte +0x0
  db 0x74, 0x69                ; 00001817  jz 0x1882
  db 0xE8, 0x67, 0x00          ; 00001819  call 0x1883
  db 0x2E, 0x3A, 0x16, 0xDA, 0x2F ; 0000181C  cmp dl,[cs:0x2fda]
  db 0x75, 0x5F                ; 00001821  jnz 0x1882
  db 0x2E, 0xC4, 0x36, 0xD6, 0x2F ; 00001823  les si,[cs:0x2fd6]
  db 0x2E, 0xC7, 0x06, 0xD8, 0x2F, 0x00, 0x00 ; 00001828  mov word [cs:0x2fd8],0x0
  db 0x2E, 0xA1, 0xD4, 0x2F    ; 0000182F  mov ax,[cs:0x2fd4]
  db 0x26, 0x89, 0x44, 0x01    ; 00001833  mov [es:si+0x1],ax
  db 0x26, 0xC6, 0x04, 0x00    ; 00001837  mov byte [es:si],0x0
  db 0xF6, 0x47, 0x6B, 0x04    ; 0000183B  test byte [bx+0x6b],0x4
  db 0x74, 0x41                ; 0000183F  jz 0x1882
  db 0x80, 0x67, 0x6B, 0xFB    ; 00001841  and byte [bx+0x6b],0xfb
  db 0xC6, 0x47, 0x70, 0x0D    ; 00001845  mov byte [bx+0x70],0xd
  db 0xE8, 0x1A, 0x08          ; 00001849  call 0x2066
  db 0x8B, 0x87, 0x84, 0x00    ; 0000184C  mov ax,[bx+0x84]
  db 0x88, 0xA7, 0x80, 0x00    ; 00001850  mov [bx+0x80],ah
  db 0xC6, 0x47, 0x6A, 0x08    ; 00001854  mov byte [bx+0x6a],0x8
  db 0xF6, 0x47, 0x6B, 0x02    ; 00001858  test byte [bx+0x6b],0x2
  db 0x75, 0x08                ; 0000185C  jnz 0x1866
  db 0xB4, 0x03                ; 0000185E  mov ah,0x3
  db 0xE8, 0xC1, 0x07          ; 00001860  call 0x2024
  db 0xE8, 0x42, 0x00          ; 00001863  call 0x18a8
  db 0xC6, 0x47, 0x4D, 0x50    ; 00001866  mov byte [bx+0x4d],0x50
  db 0xC7, 0x47, 0x60, 0x4F, 0x00 ; 0000186A  mov word [bx+0x60],0x4f
  db 0xE8, 0x3E, 0xF2          ; 0000186F  call 0xab0
  db 0x81, 0x67, 0x6B, 0xFF, 0xFD ; 00001872  and word [bx+0x6b],0xfdff
  db 0xE8, 0xB1, 0x02          ; 00001877  call 0x1b2b
  db 0x2E, 0x8B, 0x1E, 0x1B, 0x2D ; 0000187A  mov bx,[cs:0x2d1b]
  db 0xE8, 0x23, 0xFC          ; 0000187F  call 0x14a5
  db 0xC3                      ; 00001882  ret
  db 0x2E, 0x8B, 0x1E, 0x68, 0x00 ; 00001883  mov bx,[cs:0x68]
  db 0x8A, 0x57, 0x20          ; 00001888  mov dl,[bx+0x20]
  db 0xE9, 0xBA, 0x03          ; 0000188B  jmp 0x1c48
  db 0x2E, 0x80, 0x7F, 0x70, 0x0D ; 0000188E  cmp byte [cs:bx+0x70],0xd
  db 0x74, 0x13                ; 00001893  jz 0x18a8
  db 0x2E, 0xC7, 0x06, 0x90, 0x6F, 0x0F, 0x00 ; 00001895  mov word [cs:0x6f90],0xf
  db 0x2E, 0xC7, 0x06, 0x92, 0x6F, 0x23, 0x87 ; 0000189C  mov word [cs:0x6f92],0x8723
  db 0xBE, 0x4C, 0x6E          ; 000018A3  mov si,0x6e4c
  db 0xEB, 0x11                ; 000018A6  jmp short 0x18b9
  db 0x2E, 0xC7, 0x06, 0x90, 0x6F, 0x09, 0x00 ; 000018A8  mov word [cs:0x6f90],0x9
  db 0x2E, 0xC7, 0x06, 0x92, 0x6F, 0x50, 0x87 ; 000018AF  mov word [cs:0x6f92],0x8750
  db 0xBE, 0x1E, 0x6E          ; 000018B6  mov si,0x6e1e
  db 0x2E, 0xA1, 0xDD, 0x2F    ; 000018B9  mov ax,[cs:0x2fdd]
  db 0x2E, 0x8B, 0x16, 0xDB, 0x2F ; 000018BD  mov dx,[cs:0x2fdb]
  db 0x2E, 0xA3, 0xDB, 0x2F    ; 000018C2  mov [cs:0x2fdb],ax
  db 0x2E, 0x89, 0x16, 0xDD, 0x2F ; 000018C6  mov [cs:0x2fdd],dx
  db 0x1E                      ; 000018CB  push ds
  db 0x56                      ; 000018CC  push si
  db 0x33, 0xED                ; 000018CD  xor bp,bp
  db 0xB9, 0x10, 0x00          ; 000018CF  mov cx,0x10
  db 0x51                      ; 000018D2  push cx
  db 0x8B, 0xF5                ; 000018D3  mov si,bp
  db 0x33, 0xFF                ; 000018D5  xor di,di
  db 0x8E, 0xD8                ; 000018D7  mov ds,ax
  db 0x2E, 0x8E, 0x06, 0x7E, 0x2F ; 000018D9  mov es,[cs:0x2f7e]
  db 0xE8, 0x39, 0x00          ; 000018DE  call 0x191a
  db 0x8B, 0xF5                ; 000018E1  mov si,bp
  db 0x8B, 0xFE                ; 000018E3  mov di,si
  db 0x8E, 0xDA                ; 000018E5  mov ds,dx
  db 0x8E, 0xC0                ; 000018E7  mov es,ax
  db 0xE8, 0x2E, 0x00          ; 000018E9  call 0x191a
  db 0x8B, 0xFD                ; 000018EC  mov di,bp
  db 0x33, 0xF6                ; 000018EE  xor si,si
  db 0x2E, 0x8E, 0x1E, 0x7E, 0x2F ; 000018F0  mov ds,[cs:0x2f7e]
  db 0x8E, 0xC2                ; 000018F5  mov es,dx
  db 0xE8, 0x20, 0x00          ; 000018F7  call 0x191a
  db 0x81, 0xC5, 0x00, 0x08    ; 000018FA  add bp,0x800
  db 0x59                      ; 000018FE  pop cx
  db 0xE2, 0xD1                ; 000018FF  loop 0x18d2
  db 0x5E                      ; 00001901  pop si
  db 0x1F                      ; 00001902  pop ds
  db 0x53                      ; 00001903  push bx
  db 0x8A, 0x47, 0x70          ; 00001904  mov al,[bx+0x70]
  db 0xBA, 0x76, 0x00          ; 00001907  mov dx,0x76
  db 0xEE                      ; 0000190A  out dx,al
  db 0xBF, 0x16, 0x6E          ; 0000190B  mov di,0x6e16
  db 0x8B, 0xC6                ; 0000190E  mov ax,si
  db 0xE8, 0x31, 0x07          ; 00001910  call 0x2044
  db 0xB4, 0x04                ; 00001913  mov ah,0x4
  db 0xE8, 0x0C, 0x07          ; 00001915  call 0x2024
  db 0x5B                      ; 00001918  pop bx
  db 0xC3                      ; 00001919  ret
  db 0xB9, 0x00, 0x04          ; 0000191A  mov cx,0x400
  db 0xF3, 0xA5                ; 0000191D  rep movsw
  db 0xC3                      ; 0000191F  ret
  db 0x8B, 0xEC                ; 00001920  mov bp,sp
  db 0x1E                      ; 00001922  push ds
  db 0x52                      ; 00001923  push dx
  db 0x51                      ; 00001924  push cx
  db 0x56                      ; 00001925  push si
  db 0xE8, 0x5A, 0xFF          ; 00001926  call 0x1883
  db 0xF6, 0x47, 0x6B, 0x08    ; 00001929  test byte [bx+0x6b],0x8
  db 0x74, 0x05                ; 0000192D  jz 0x1934
  db 0x1E                      ; 0000192F  push ds
  db 0x07                      ; 00001930  pop es
  db 0xE8, 0xF0, 0xF2          ; 00001931  call 0xc24
  db 0x5E                      ; 00001934  pop si
  db 0x59                      ; 00001935  pop cx
  db 0x5A                      ; 00001936  pop dx
  db 0x2E, 0x8E, 0x06, 0x7E, 0x2F ; 00001937  mov es,[cs:0x2f7e]
  db 0x8E, 0x5E, 0x02          ; 0000193C  mov ds,[bp+0x2]
  db 0x33, 0xC0                ; 0000193F  xor ax,ax
  db 0x86, 0xC6                ; 00001941  xchg al,dh
  db 0x95                      ; 00001943  xchg ax,bp
  db 0x2E, 0x8A, 0x67, 0x6A    ; 00001944  mov ah,[cs:bx+0x6a]
  db 0xEB, 0x03                ; 00001948  jmp short 0x194d
  db 0x45                      ; 0000194A  inc bp
  db 0x33, 0xD2                ; 0000194B  xor dx,dx
  db 0x8B, 0xFD                ; 0000194D  mov di,bp
  db 0xD1, 0xE7                ; 0000194F  shl di,1
  db 0x2E, 0x8B, 0x39          ; 00001951  mov di,[cs:bx+di]
  db 0x03, 0xFA                ; 00001954  add di,dx
  db 0x03, 0xFA                ; 00001956  add di,dx
  db 0x83, 0xFA, 0x50          ; 00001958  cmp dx,byte +0x50
  db 0x74, 0xED                ; 0000195B  jz 0x194a
  db 0xAC                      ; 0000195D  lodsb
  db 0xAB                      ; 0000195E  stosw
  db 0x42                      ; 0000195F  inc dx
  db 0xE2, 0xF6                ; 00001960  loop 0x1958
  db 0x1F                      ; 00001962  pop ds
  db 0xE9, 0xE0, 0x03          ; 00001963  jmp 0x1d46
  db 0xE8, 0x1A, 0xFF          ; 00001966  call 0x1883
  db 0xE9, 0xDA, 0x03          ; 00001969  jmp 0x1d46
  db 0x8B, 0xEC                ; 0000196C  mov bp,sp
  db 0x8B, 0x6E, 0x02          ; 0000196E  mov bp,[bp+0x2]
  db 0xB5, 0x02                ; 00001971  mov ch,0x2
  db 0x51                      ; 00001973  push cx
  db 0x52                      ; 00001974  push dx
  db 0xE8, 0x0A, 0x00          ; 00001975  call 0x1982
  db 0x59                      ; 00001978  pop cx
  db 0x5A                      ; 00001979  pop dx
  db 0x80, 0xCD, 0x01          ; 0000197A  or ch,0x1
  db 0x8B, 0xEC                ; 0000197D  mov bp,sp
  db 0x8B, 0x6E, 0x02          ; 0000197F  mov bp,[bp+0x2]
  db 0x87, 0xF2                ; 00001982  xchg si,dx
  db 0x87, 0xF9                ; 00001984  xchg di,cx
  db 0xE8, 0x24, 0x00          ; 00001986  call 0x19ad
  db 0xC1, 0xE7, 0x05          ; 00001989  shl di,byte 0x5
  db 0xE8, 0x2C, 0x00          ; 0000198C  call 0x19bb
  db 0xC6, 0x47, 0x35, 0x00    ; 0000198F  mov byte [bx+0x35],0x0
  db 0xC3                      ; 00001993  ret
  db 0x8B, 0xEC                ; 00001994  mov bp,sp
  db 0x8B, 0x6E, 0x02          ; 00001996  mov bp,[bp+0x2]
  db 0xC1, 0xE1, 0x05          ; 00001999  shl cx,byte 0x5
  db 0x87, 0xF1                ; 0000199C  xchg si,cx
  db 0x87, 0xFA                ; 0000199E  xchg di,dx
  db 0xE8, 0x0A, 0x00          ; 000019A0  call 0x19ad
  db 0x87, 0xD5                ; 000019A3  xchg dx,bp
  db 0xE8, 0x13, 0x00          ; 000019A5  call 0x19bb
  db 0xC6, 0x47, 0x35, 0x00    ; 000019A8  mov byte [bx+0x35],0x0
  db 0xC3                      ; 000019AC  ret
  db 0xE8, 0xD3, 0xFE          ; 000019AD  call 0x1883
  db 0xE8, 0x69, 0x01          ; 000019B0  call 0x1b1c
  db 0x53                      ; 000019B3  push bx
  db 0x2E, 0x8B, 0x16, 0xDB, 0x2F ; 000019B4  mov dx,[cs:0x2fdb]
  db 0x5B                      ; 000019B9  pop bx
  db 0xC3                      ; 000019BA  ret
  db 0xB9, 0x10, 0x00          ; 000019BB  mov cx,0x10
  db 0x1E                      ; 000019BE  push ds
  db 0x8E, 0xDD                ; 000019BF  mov ds,bp
  db 0x8E, 0xC2                ; 000019C1  mov es,dx
  db 0x56                      ; 000019C3  push si
  db 0x57                      ; 000019C4  push di
  db 0xF3, 0xA5                ; 000019C5  rep movsw
  db 0x5E                      ; 000019C7  pop si
  db 0x5F                      ; 000019C8  pop di
  db 0x1F                      ; 000019C9  pop ds
  db 0xC3                      ; 000019CA  ret
  db 0xE8, 0xB5, 0xFE          ; 000019CB  call 0x1883
  db 0xBE, 0xF8, 0x6D          ; 000019CE  mov si,0x6df8
  db 0xE9, 0x67, 0x00          ; 000019D1  jmp 0x1a3b
  db 0xE8, 0xAC, 0xFE          ; 000019D4  call 0x1883
  db 0x8A, 0x77, 0x64          ; 000019D7  mov dh,[bx+0x64]
  db 0x8A, 0x57, 0x66          ; 000019DA  mov dl,[bx+0x66]
  db 0x87, 0xDA                ; 000019DD  xchg bx,dx
  db 0xC3                      ; 000019DF  ret
  db 0x53                      ; 000019E0  push bx
  db 0xE8, 0x9F, 0xFE          ; 000019E1  call 0x1883
  db 0x5A                      ; 000019E4  pop dx
  db 0x88, 0x77, 0x64          ; 000019E5  mov [bx+0x64],dh
  db 0x88, 0x57, 0x66          ; 000019E8  mov [bx+0x66],dl
  db 0xE9, 0x8F, 0xF4          ; 000019EB  jmp 0xe7d
  db 0xE8, 0x92, 0xFE          ; 000019EE  call 0x1883
  db 0x8A, 0x67, 0x6A          ; 000019F1  mov ah,[bx+0x6a]
  db 0xC3                      ; 000019F4  ret
  db 0xE8, 0x8B, 0xFE          ; 000019F5  call 0x1883
  db 0x88, 0x67, 0x6A          ; 000019F8  mov [bx+0x6a],ah
  db 0xC3                      ; 000019FB  ret
  db 0x87, 0xF2                ; 000019FC  xchg si,dx
  db 0xE8, 0x82, 0xFE          ; 000019FE  call 0x1883
  db 0x8D, 0xBF, 0x84, 0x00    ; 00001A01  lea di,[bx+0x84]
  db 0x8B, 0xEC                ; 00001A05  mov bp,sp
  db 0xB9, 0x08, 0x00          ; 00001A07  mov cx,0x8
  db 0x1E                      ; 00001A0A  push ds
  db 0x07                      ; 00001A0B  pop es
  db 0x8E, 0x5E, 0x02          ; 00001A0C  mov ds,[bp+0x2]
  db 0xFC                      ; 00001A0F  cld
  db 0xF3, 0xA5                ; 00001A10  rep movsw
  db 0x0E                      ; 00001A12  push cs
  db 0x1F                      ; 00001A13  pop ds
  db 0xF6, 0x47, 0x6B, 0x02    ; 00001A14  test byte [bx+0x6b],0x2
  db 0x75, 0x15                ; 00001A18  jnz 0x1a2f
  db 0x2E, 0x80, 0x3E, 0x21, 0x20, 0x02 ; 00001A1A  cmp byte [cs:0x2021],0x2
  db 0x75, 0x05                ; 00001A20  jnz 0x1a27
  db 0xB4, 0x03                ; 00001A22  mov ah,0x3
  db 0xE8, 0xFD, 0x05          ; 00001A24  call 0x2024
  db 0xE8, 0xB1, 0x06          ; 00001A27  call 0x20db
  db 0xB4, 0x01                ; 00001A2A  mov ah,0x1
  db 0xE8, 0xF5, 0x05          ; 00001A2C  call 0x2024
  db 0xC3                      ; 00001A2F  ret
  db 0xB8, 0x14, 0x2D          ; 00001A30  mov ax,0x2d14
  db 0x80, 0xFA, 0x04          ; 00001A33  cmp dl,0x4
  db 0x73, 0x0C                ; 00001A36  jnc 0x1a44
  db 0xE8, 0x0D, 0x02          ; 00001A38  call 0x1c48
  db 0x8B, 0xC3                ; 00001A3B  mov ax,bx
  db 0x0E                      ; 00001A3D  push cs
  db 0x07                      ; 00001A3E  pop es
  db 0x2E, 0x8B, 0x16, 0x7E, 0x2F ; 00001A3F  mov dx,[cs:0x2f7e]
  db 0xC3                      ; 00001A44  ret
  db 0x80, 0xF9, 0x03          ; 00001A45  cmp cl,0x3
  db 0x73, 0x11                ; 00001A48  jnc 0x1a5b
  db 0x2E, 0x88, 0x0E, 0x14, 0x2D ; 00001A4A  mov [cs:0x2d14],cl
  db 0x80, 0xF9, 0x02          ; 00001A4F  cmp cl,0x2
  db 0x74, 0x21                ; 00001A52  jz 0x1a75
  db 0x2E, 0xC7, 0x06, 0x41, 0x10, 0x05, 0x00 ; 00001A54  mov word [cs:0x1041],0x5
  db 0x8A, 0xC2                ; 00001A5B  mov al,dl
  db 0x3C, 0x04                ; 00001A5D  cmp al,0x4
  db 0x73, 0x14                ; 00001A5F  jnc 0x1a75
  db 0x04, 0x70                ; 00001A61  add al,0x70
  db 0xB4, 0xFF                ; 00001A63  mov ah,0xff
  db 0x2E, 0xA3, 0x3E, 0x10    ; 00001A65  mov [cs:0x103e],ax
  db 0xBA, 0x05, 0x00          ; 00001A69  mov dx,0x5
  db 0xE8, 0xB1, 0xE6          ; 00001A6C  call 0x120
  db 0x9C                      ; 00001A6F  pushf
  db 0x2E, 0xFF, 0x1E, 0x38, 0x00 ; 00001A70  call far [cs:0x38]
  db 0xC3                      ; 00001A75  ret
  db 0x50                      ; 00001A76  push ax
  db 0xE8, 0xCE, 0x01          ; 00001A77  call 0x1c48
  db 0xE8, 0xAE, 0x00          ; 00001A7A  call 0x1b2b
  db 0x8B, 0x47, 0x36          ; 00001A7D  mov ax,[bx+0x36]
  db 0x89, 0x47, 0x3A          ; 00001A80  mov [bx+0x3a],ax
  db 0x8B, 0x47, 0x38          ; 00001A83  mov ax,[bx+0x38]
  db 0x89, 0x47, 0x3C          ; 00001A86  mov [bx+0x3c],ax
  db 0x89, 0x4F, 0x36          ; 00001A89  mov [bx+0x36],cx
  db 0x59                      ; 00001A8C  pop cx
  db 0x89, 0x4F, 0x38          ; 00001A8D  mov [bx+0x38],cx
  db 0x06                      ; 00001A90  push es
  db 0x1E                      ; 00001A91  push ds
  db 0x07                      ; 00001A92  pop es
  db 0xE8, 0x22, 0x01          ; 00001A93  call 0x1bb8
  db 0xE8, 0x36, 0x01          ; 00001A96  call 0x1bcf
  db 0xE8, 0x51, 0x01          ; 00001A99  call 0x1bed
  db 0x07                      ; 00001A9C  pop es
  db 0x2E, 0x8B, 0x1E, 0x1B, 0x2D ; 00001A9D  mov bx,[cs:0x2d1b]
  db 0xE8, 0x00, 0xFA          ; 00001AA2  call 0x14a5
  db 0xC3                      ; 00001AA5  ret
  db 0xE8, 0x9F, 0x01          ; 00001AA6  call 0x1c48
  db 0xE8, 0x70, 0x00          ; 00001AA9  call 0x1b1c
  db 0x88, 0x77, 0x4C          ; 00001AAC  mov [bx+0x4c],dh
  db 0x89, 0x4F, 0x40          ; 00001AAF  mov [bx+0x40],cx
  db 0xE8, 0x1A, 0x01          ; 00001AB2  call 0x1bcf
  db 0xE8, 0x8E, 0x02          ; 00001AB5  call 0x1d46
  db 0xE8, 0x14, 0xF4          ; 00001AB8  call 0xecf
  db 0xC6, 0x47, 0x35, 0x00    ; 00001ABB  mov byte [bx+0x35],0x0
  db 0xC3                      ; 00001ABF  ret
  db 0xE8, 0x85, 0x01          ; 00001AC0  call 0x1c48
  db 0x88, 0x4F, 0x4D          ; 00001AC3  mov [bx+0x4d],cl
  db 0xC3                      ; 00001AC6  ret
  db 0x52                      ; 00001AC7  push dx
  db 0xE8, 0x7D, 0x01          ; 00001AC8  call 0x1c48
  db 0xB9, 0x00, 0x00          ; 00001ACB  mov cx,0x0
  db 0x8A, 0x67, 0x48          ; 00001ACE  mov ah,[bx+0x48]
  db 0xFE, 0xCC                ; 00001AD1  dec ah
  db 0xB0, 0x4F                ; 00001AD3  mov al,0x4f
  db 0x39, 0x4F, 0x36          ; 00001AD5  cmp [bx+0x36],cx
  db 0x75, 0x0B                ; 00001AD8  jnz 0x1ae5
  db 0x39, 0x47, 0x38          ; 00001ADA  cmp [bx+0x38],ax
  db 0x75, 0x06                ; 00001ADD  jnz 0x1ae5
  db 0x8B, 0x4F, 0x3A          ; 00001ADF  mov cx,[bx+0x3a]
  db 0x8B, 0x47, 0x3C          ; 00001AE2  mov ax,[bx+0x3c]
  db 0x5A                      ; 00001AE5  pop dx
  db 0xE9, 0x8D, 0xFF          ; 00001AE6  jmp 0x1a76
  db 0xC3                      ; 00001AE9  ret
  db 0xB8, 0x01, 0x50          ; 00001AEA  mov ax,0x5001
  db 0xC3                      ; 00001AED  ret
  db 0x8B, 0x47, 0x4A          ; 00001AEE  mov ax,[bx+0x4a]
  db 0x3A, 0xD0                ; 00001AF1  cmp dl,al
  db 0x72, 0x11                ; 00001AF3  jc 0x1b06
  db 0x3A, 0xF4                ; 00001AF5  cmp dh,ah
  db 0x72, 0x0D                ; 00001AF7  jc 0x1b06
  db 0x02, 0x47, 0x44          ; 00001AF9  add al,[bx+0x44]
  db 0x02, 0x67, 0x42          ; 00001AFC  add ah,[bx+0x42]
  db 0x3A, 0xD0                ; 00001AFF  cmp dl,al
  db 0x73, 0x02                ; 00001B01  jnc 0x1b05
  db 0x3A, 0xF4                ; 00001B03  cmp dh,ah
  db 0xF5                      ; 00001B05  cmc
  db 0xC3                      ; 00001B06  ret
  db 0x80, 0x4F, 0x6B, 0x10    ; 00001B07  or byte [bx+0x6b],0x10
  db 0x80, 0x7F, 0x42, 0x18    ; 00001B0B  cmp byte [bx+0x42],0x18
  db 0x72, 0x0A                ; 00001B0F  jc 0x1b1b
  db 0x80, 0x7F, 0x44, 0x50    ; 00001B11  cmp byte [bx+0x44],0x50
  db 0x75, 0x04                ; 00001B15  jnz 0x1b1b
  db 0x80, 0x77, 0x6B, 0x10    ; 00001B17  xor byte [bx+0x6b],0x10
  db 0xC3                      ; 00001B1B  ret
  db 0xB0, 0xFF                ; 00001B1C  mov al,0xff
  db 0x86, 0x47, 0x35          ; 00001B1E  xchg al,[bx+0x35]
  db 0x84, 0xC0                ; 00001B21  test al,al
  db 0x74, 0x05                ; 00001B23  jz 0x1b2a
  db 0xE8, 0x40, 0x01          ; 00001B25  call 0x1c68
  db 0xEB, 0xF2                ; 00001B28  jmp short 0x1b1c
  db 0xC3                      ; 00001B2A  ret
  db 0x53                      ; 00001B2B  push bx
  db 0x51                      ; 00001B2C  push cx
  db 0xBB, 0x2E, 0x2D          ; 00001B2D  mov bx,0x2d2e
  db 0xB9, 0x04, 0x00          ; 00001B30  mov cx,0x4
  db 0xE8, 0xE6, 0xFF          ; 00001B33  call 0x1b1c
  db 0x81, 0xC3, 0x94, 0x00    ; 00001B36  add bx,0x94
  db 0xE2, 0xF7                ; 00001B3A  loop 0x1b33
  db 0x59                      ; 00001B3C  pop cx
  db 0x5B                      ; 00001B3D  pop bx
  db 0xC3                      ; 00001B3E  ret
  db 0x53                      ; 00001B3F  push bx
  db 0x51                      ; 00001B40  push cx
  db 0xBB, 0x2E, 0x2D          ; 00001B41  mov bx,0x2d2e
  db 0xB9, 0x04, 0x00          ; 00001B44  mov cx,0x4
  db 0xC6, 0x47, 0x35, 0x00    ; 00001B47  mov byte [bx+0x35],0x0
  db 0x81, 0xC3, 0x94, 0x00    ; 00001B4B  add bx,0x94
  db 0xE2, 0xF6                ; 00001B4F  loop 0x1b47
  db 0x59                      ; 00001B51  pop cx
  db 0x5B                      ; 00001B52  pop bx
  db 0xC3                      ; 00001B53  ret
  db 0x80, 0x7F, 0x4C, 0x00    ; 00001B54  cmp byte [bx+0x4c],0x0
  db 0x74, 0x18                ; 00001B58  jz 0x1b72
  db 0x8A, 0x67, 0x64          ; 00001B5A  mov ah,[bx+0x64]
  db 0x8A, 0x47, 0x4B          ; 00001B5D  mov al,[bx+0x4b]
  db 0x3A, 0xC4                ; 00001B60  cmp al,ah
  db 0x77, 0x0B                ; 00001B62  ja 0x1b6f
  db 0x2A, 0x67, 0x42          ; 00001B64  sub ah,[bx+0x42]
  db 0x78, 0x09                ; 00001B67  js 0x1b72
  db 0x3A, 0xC4                ; 00001B69  cmp al,ah
  db 0x77, 0x05                ; 00001B6B  ja 0x1b72
  db 0xFE, 0xC4                ; 00001B6D  inc ah
  db 0x88, 0x67, 0x4B          ; 00001B6F  mov [bx+0x4b],ah
  db 0x8B, 0x57, 0x36          ; 00001B72  mov dx,[bx+0x36]
  db 0xE8, 0xDC, 0x00          ; 00001B75  call 0x1c54
  db 0x92                      ; 00001B78  xchg ax,dx
  db 0xB0, 0x50                ; 00001B79  mov al,0x50
  db 0xF6, 0x67, 0x4B          ; 00001B7B  mul byte [bx+0x4b]
  db 0x2B, 0xD0                ; 00001B7E  sub dx,ax
  db 0x8A, 0x47, 0x4A          ; 00001B80  mov al,[bx+0x4a]
  db 0x98                      ; 00001B83  cbw
  db 0x2B, 0xD0                ; 00001B84  sub dx,ax
  db 0x89, 0x57, 0x46          ; 00001B86  mov [bx+0x46],dx
  db 0xC3                      ; 00001B89  ret
  db 0xBF, 0x16, 0x2D          ; 00001B8A  mov di,0x2d16
  db 0xB9, 0x04, 0x00          ; 00001B8D  mov cx,0x4
  db 0x8A, 0xC2                ; 00001B90  mov al,dl
  db 0xF2, 0xAE                ; 00001B92  repne scasb
  db 0xE3, 0x0B                ; 00001B94  jcxz 0x1ba1
  db 0x4F                      ; 00001B96  dec di
  db 0x8A, 0x45, 0x01          ; 00001B97  mov al,[di+0x1]
  db 0x88, 0x05                ; 00001B9A  mov [di],al
  db 0x47                      ; 00001B9C  inc di
  db 0xE2, 0xF8                ; 00001B9D  loop 0x1b97
  db 0x88, 0x15                ; 00001B9F  mov [di],dl
  db 0xBF, 0x1E, 0x2D          ; 00001BA1  mov di,0x2d1e
  db 0x8A, 0x47, 0x4E          ; 00001BA4  mov al,[bx+0x4e]
  db 0xB4, 0x00                ; 00001BA7  mov ah,0x0
  db 0xB9, 0x10, 0x00          ; 00001BA9  mov cx,0x10
  db 0x84, 0xE0                ; 00001BAC  test al,ah
  db 0x74, 0x02                ; 00001BAE  jz 0x1bb2
  db 0x88, 0x15                ; 00001BB0  mov [di],dl
  db 0xFE, 0xC4                ; 00001BB2  inc ah
  db 0x47                      ; 00001BB4  inc di
  db 0xE2, 0xF5                ; 00001BB5  loop 0x1bac
  db 0xC3                      ; 00001BB7  ret
  db 0x8A, 0x47, 0x39          ; 00001BB8  mov al,[bx+0x39]
  db 0x2A, 0x47, 0x37          ; 00001BBB  sub al,[bx+0x37]
  db 0x98                      ; 00001BBE  cbw
  db 0x40                      ; 00001BBF  inc ax
  db 0x89, 0x47, 0x42          ; 00001BC0  mov [bx+0x42],ax
  db 0x8A, 0x47, 0x38          ; 00001BC3  mov al,[bx+0x38]
  db 0x2A, 0x47, 0x36          ; 00001BC6  sub al,[bx+0x36]
  db 0x98                      ; 00001BC9  cbw
  db 0x40                      ; 00001BCA  inc ax
  db 0x89, 0x47, 0x44          ; 00001BCB  mov [bx+0x44],ax
  db 0xC3                      ; 00001BCE  ret
  db 0x8B, 0x57, 0x40          ; 00001BCF  mov dx,[bx+0x40]
  db 0x8A, 0x47, 0x48          ; 00001BD2  mov al,[bx+0x48]
  db 0x2A, 0x47, 0x42          ; 00001BD5  sub al,[bx+0x42]
  db 0x3A, 0xC6                ; 00001BD8  cmp al,dh
  db 0x73, 0x02                ; 00001BDA  jnc 0x1bde
  db 0x8A, 0xF0                ; 00001BDC  mov dh,al
  db 0xB0, 0x50                ; 00001BDE  mov al,0x50
  db 0x2A, 0x47, 0x44          ; 00001BE0  sub al,[bx+0x44]
  db 0x3A, 0xC2                ; 00001BE3  cmp al,dl
  db 0x73, 0x02                ; 00001BE5  jnc 0x1be9
  db 0x8A, 0xD0                ; 00001BE7  mov dl,al
  db 0x89, 0x57, 0x4A          ; 00001BE9  mov [bx+0x4a],dx
  db 0xC3                      ; 00001BEC  ret
  db 0xBF, 0x9F, 0x4F          ; 00001BED  mov di,0x4f9f
  db 0xB9, 0x80, 0x07          ; 00001BF0  mov cx,0x780
  db 0x8A, 0x47, 0x4E          ; 00001BF3  mov al,[bx+0x4e]
  db 0xF6, 0xD0                ; 00001BF6  not al
  db 0x26, 0x20, 0x05          ; 00001BF8  and [es:di],al
  db 0x47                      ; 00001BFB  inc di
  db 0xE2, 0xFA                ; 00001BFC  loop 0x1bf8
  db 0x8B, 0x57, 0x36          ; 00001BFE  mov dx,[bx+0x36]
  db 0x80, 0xFE, 0x00          ; 00001C01  cmp dh,0x0
  db 0x74, 0x02                ; 00001C04  jz 0x1c08
  db 0xFE, 0xCE                ; 00001C06  dec dh
  db 0x80, 0xFA, 0x00          ; 00001C08  cmp dl,0x0
  db 0x74, 0x02                ; 00001C0B  jz 0x1c0f
  db 0xFE, 0xCA                ; 00001C0D  dec dl
  db 0x8B, 0x4F, 0x38          ; 00001C0F  mov cx,[bx+0x38]
  db 0x8A, 0x47, 0x48          ; 00001C12  mov al,[bx+0x48]
  db 0xFE, 0xC8                ; 00001C15  dec al
  db 0x3A, 0xE8                ; 00001C17  cmp ch,al
  db 0x74, 0x02                ; 00001C19  jz 0x1c1d
  db 0xFE, 0xC5                ; 00001C1B  inc ch
  db 0x80, 0xF9, 0x4F          ; 00001C1D  cmp cl,0x4f
  db 0x74, 0x02                ; 00001C20  jz 0x1c24
  db 0xFE, 0xC1                ; 00001C22  inc cl
  db 0xE8, 0x2D, 0x00          ; 00001C24  call 0x1c54
  db 0x97                      ; 00001C27  xchg ax,di
  db 0x81, 0xC7, 0x9F, 0x4F    ; 00001C28  add di,0x4f9f
  db 0x2B, 0xCA                ; 00001C2C  sub cx,dx
  db 0x81, 0xC1, 0x01, 0x01    ; 00001C2E  add cx,0x101
  db 0x8A, 0x47, 0x4E          ; 00001C32  mov al,[bx+0x4e]
  db 0x57                      ; 00001C35  push di
  db 0x51                      ; 00001C36  push cx
  db 0x08, 0x05                ; 00001C37  or [di],al
  db 0x47                      ; 00001C39  inc di
  db 0xFE, 0xC9                ; 00001C3A  dec cl
  db 0x75, 0xF9                ; 00001C3C  jnz 0x1c37
  db 0x59                      ; 00001C3E  pop cx
  db 0x5F                      ; 00001C3F  pop di
  db 0x83, 0xC7, 0x50          ; 00001C40  add di,byte +0x50
  db 0xFE, 0xCD                ; 00001C43  dec ch
  db 0x75, 0xEE                ; 00001C45  jnz 0x1c35
  db 0xC3                      ; 00001C47  ret
  db 0x8A, 0xDA                ; 00001C48  mov bl,dl
  db 0x32, 0xFF                ; 00001C4A  xor bh,bh
  db 0xD1, 0xE3                ; 00001C4C  shl bx,1
  db 0x2E, 0x8B, 0x9F, 0x80, 0x2F ; 00001C4E  mov bx,[cs:bx+0x2f80]
  db 0xC3                      ; 00001C53  ret
  db 0xB0, 0xB0                ; 00001C54  mov al,0xb0
  db 0xF6, 0xE6                ; 00001C56  mul dh
  db 0xF7, 0xD8                ; 00001C58  neg ax
  db 0x03, 0xC2                ; 00001C5A  add ax,dx
  db 0x8B, 0xF8                ; 00001C5C  mov di,ax
  db 0x03, 0xFF                ; 00001C5E  add di,di
  db 0xC3                      ; 00001C60  ret
  db 0x53                      ; 00001C61  push bx
  db 0xBB, 0x1E, 0x2D          ; 00001C62  mov bx,0x2d1e
  db 0xD7                      ; 00001C65  xlatb
  db 0x5B                      ; 00001C66  pop bx
  db 0xC3                      ; 00001C67  ret
  db 0x53                      ; 00001C68  push bx
  db 0x51                      ; 00001C69  push cx
  db 0x52                      ; 00001C6A  push dx
  db 0x56                      ; 00001C6B  push si
  db 0x57                      ; 00001C6C  push di
  db 0x06                      ; 00001C6D  push es
  db 0xB1, 0x8D                ; 00001C6E  mov cl,0x8d
  db 0xBA, 0x01, 0x00          ; 00001C70  mov dx,0x1
  db 0x2E, 0x8B, 0x1E, 0x68, 0x00 ; 00001C73  mov bx,[cs:0x68]
  db 0x8E, 0x47, 0x10          ; 00001C78  mov es,[bx+0x10]
  db 0xE8, 0xB5, 0xE4          ; 00001C7B  call 0x133
  db 0x07                      ; 00001C7E  pop es
  db 0x5F                      ; 00001C7F  pop di
  db 0x5E                      ; 00001C80  pop si
  db 0x5A                      ; 00001C81  pop dx
  db 0x59                      ; 00001C82  pop cx
  db 0x5B                      ; 00001C83  pop bx
  db 0xC3                      ; 00001C84  ret
  db 0x53                      ; 00001C85  push bx
  db 0xBE, 0xA3, 0x4D          ; 00001C86  mov si,0x4da3
  db 0x2E, 0xC6, 0x06, 0x09, 0x29, 0x03 ; 00001C89  mov byte [cs:0x2909],0x3
  db 0x2E, 0x8A, 0x16, 0x09, 0x29 ; 00001C8F  mov dl,[cs:0x2909]
  db 0xE8, 0xB1, 0xFF          ; 00001C94  call 0x1c48
  db 0x89, 0x77, 0x58          ; 00001C97  mov [bx+0x58],si
  db 0x8B, 0x57, 0x36          ; 00001C9A  mov dx,[bx+0x36]
  db 0x8B, 0x4F, 0x42          ; 00001C9D  mov cx,[bx+0x42]
  db 0x2E, 0xC7, 0x06, 0x07, 0x29, 0xFF, 0xFF ; 00001CA0  mov word [cs:0x2907],0xffff
  db 0x53                      ; 00001CA7  push bx
  db 0x51                      ; 00001CA8  push cx
  db 0x52                      ; 00001CA9  push dx
  db 0x8B, 0xEA                ; 00001CAA  mov bp,dx
  db 0xE8, 0xA5, 0xFF          ; 00001CAC  call 0x1c54
  db 0x97                      ; 00001CAF  xchg ax,di
  db 0x81, 0xC7, 0x9F, 0x4F    ; 00001CB0  add di,0x4f9f
  db 0x8B, 0x4F, 0x44          ; 00001CB4  mov cx,[bx+0x44]
  db 0x26, 0x8A, 0x05          ; 00001CB7  mov al,[es:di]
  db 0x8B, 0xD7                ; 00001CBA  mov dx,di
  db 0xF3, 0xAE                ; 00001CBC  repe scasb
  db 0x74, 0x02                ; 00001CBE  jz 0x1cc2
  db 0x4F                      ; 00001CC0  dec di
  db 0x41                      ; 00001CC1  inc cx
  db 0x8B, 0xDF                ; 00001CC2  mov bx,di
  db 0x2B, 0xDA                ; 00001CC4  sub bx,dx
  db 0xE8, 0x98, 0xFF          ; 00001CC6  call 0x1c61
  db 0x2E, 0x3A, 0x06, 0x09, 0x29 ; 00001CC9  cmp al,[cs:0x2909]
  db 0x75, 0x1A                ; 00001CCE  jnz 0x1cea
  db 0x2E, 0x3B, 0x16, 0x07, 0x29 ; 00001CD0  cmp dx,[cs:0x2907]
  db 0x74, 0x09                ; 00001CD5  jz 0x1ce0
  db 0x88, 0x1C                ; 00001CD7  mov [si],bl
  db 0x46                      ; 00001CD9  inc si
  db 0x89, 0x2C                ; 00001CDA  mov [si],bp
  db 0x46                      ; 00001CDC  inc si
  db 0x46                      ; 00001CDD  inc si
  db 0xEB, 0x03                ; 00001CDE  jmp short 0x1ce3
  db 0x00, 0x5C, 0xFD          ; 00001CE0  add [si-0x3],bl
  db 0x03, 0xD3                ; 00001CE3  add dx,bx
  db 0x2E, 0x89, 0x16, 0x07, 0x29 ; 00001CE5  mov [cs:0x2907],dx
  db 0x03, 0xEB                ; 00001CEA  add bp,bx
  db 0x85, 0xC9                ; 00001CEC  test cx,cx
  db 0x75, 0xC7                ; 00001CEE  jnz 0x1cb7
  db 0x5A                      ; 00001CF0  pop dx
  db 0x59                      ; 00001CF1  pop cx
  db 0x5B                      ; 00001CF2  pop bx
  db 0xFE, 0xC6                ; 00001CF3  inc dh
  db 0x3A, 0x77, 0x39          ; 00001CF5  cmp dh,[bx+0x39]
  db 0x76, 0xA6                ; 00001CF8  jna 0x1ca0
  db 0xC6, 0x04, 0x00          ; 00001CFA  mov byte [si],0x0
  db 0x46                      ; 00001CFD  inc si
  db 0x2E, 0xFE, 0x0E, 0x09, 0x29 ; 00001CFE  dec byte [cs:0x2909]
  db 0x79, 0x8A                ; 00001D03  jns 0x1c8f
  db 0x5B                      ; 00001D05  pop bx
  db 0xC3                      ; 00001D06  ret
  db 0x00, 0x00                ; 00001D07  add [bx+si],al
  db 0x00, 0xE8                ; 00001D09  add al,ch
  db 0x78, 0xFF                ; 00001D0B  js 0x1d0c
  db 0x06                      ; 00001D0D  push es
  db 0xBE, 0x9F, 0x4F          ; 00001D0E  mov si,0x4f9f
  db 0x2E, 0x8E, 0x06, 0x7E, 0x2F ; 00001D11  mov es,[cs:0x2f7e]
  db 0x33, 0xFF                ; 00001D16  xor di,di
  db 0xB9, 0x80, 0x07          ; 00001D18  mov cx,0x780
  db 0xB8, 0x20, 0x08          ; 00001D1B  mov ax,0x820
  db 0xB2, 0x0F                ; 00001D1E  mov dl,0xf
  db 0x84, 0x14                ; 00001D20  test [si],dl
  db 0x75, 0x03                ; 00001D22  jnz 0x1d27
  db 0x26, 0x89, 0x05          ; 00001D24  mov [es:di],ax
  db 0x47                      ; 00001D27  inc di
  db 0x47                      ; 00001D28  inc di
  db 0x46                      ; 00001D29  inc si
  db 0xE2, 0xF4                ; 00001D2A  loop 0x1d20
  db 0xBE, 0x16, 0x2D          ; 00001D2C  mov si,0x2d16
  db 0xB9, 0x04, 0x00          ; 00001D2F  mov cx,0x4
  db 0x56                      ; 00001D32  push si
  db 0x51                      ; 00001D33  push cx
  db 0x8A, 0x14                ; 00001D34  mov dl,[si]
  db 0xE8, 0x0F, 0xFF          ; 00001D36  call 0x1c48
  db 0xE8, 0x79, 0x00          ; 00001D39  call 0x1db5
  db 0xE8, 0x07, 0x00          ; 00001D3C  call 0x1d46
  db 0x59                      ; 00001D3F  pop cx
  db 0x5E                      ; 00001D40  pop si
  db 0x46                      ; 00001D41  inc si
  db 0xE2, 0xEE                ; 00001D42  loop 0x1d32
  db 0x07                      ; 00001D44  pop es
  db 0xC3                      ; 00001D45  ret
  db 0x2E, 0xF6, 0x06, 0x1D, 0x2D, 0xFF ; 00001D46  test byte [cs:0x2d1d],0xff
  db 0x75, 0x66                ; 00001D4C  jnz 0x1db4
  db 0xE8, 0x03, 0xFE          ; 00001D4E  call 0x1b54
  db 0xD1, 0xE2                ; 00001D51  shl dx,1
  db 0x8B, 0x77, 0x58          ; 00001D53  mov si,[bx+0x58]
  db 0x1E                      ; 00001D56  push ds
  db 0x06                      ; 00001D57  push es
  db 0x2E, 0xA1, 0x7E, 0x2F    ; 00001D58  mov ax,[cs:0x2f7e]
  db 0x8E, 0xD8                ; 00001D5C  mov ds,ax
  db 0x8E, 0xC0                ; 00001D5E  mov es,ax
  db 0x2E, 0xAC                ; 00001D60  cs lodsb
  db 0x98                      ; 00001D62  cbw
  db 0x91                      ; 00001D63  xchg ax,cx
  db 0xE3, 0x4C                ; 00001D64  jcxz 0x1db2
  db 0x2E, 0xAD                ; 00001D66  cs lodsw
  db 0x92                      ; 00001D68  xchg ax,dx
  db 0xE8, 0xE8, 0xFE          ; 00001D69  call 0x1c54
  db 0x2E, 0x2B, 0x57, 0x36    ; 00001D6C  sub dx,[cs:bx+0x36]
  db 0x2E, 0x03, 0x57, 0x4A    ; 00001D70  add dx,[cs:bx+0x4a]
  db 0x8A, 0xC6                ; 00001D74  mov al,dh
  db 0x98                      ; 00001D76  cbw
  db 0xD1, 0xE0                ; 00001D77  shl ax,1
  db 0x56                      ; 00001D79  push si
  db 0x96                      ; 00001D7A  xchg ax,si
  db 0x2E, 0x8B, 0x30          ; 00001D7B  mov si,[cs:bx+si]
  db 0x32, 0xF6                ; 00001D7E  xor dh,dh
  db 0xD1, 0xE2                ; 00001D80  shl dx,1
  db 0x03, 0xF2                ; 00001D82  add si,dx
  db 0x2E, 0xF6, 0x47, 0x6B, 0x04 ; 00001D84  test byte [cs:bx+0x6b],0x4
  db 0x74, 0x07                ; 00001D89  jz 0x1d92
  db 0xB8, 0x20, 0x08          ; 00001D8B  mov ax,0x820
  db 0xF3, 0xAB                ; 00001D8E  rep stosw
  db 0xEB, 0x1D                ; 00001D90  jmp short 0x1daf
  db 0x2E, 0xF6, 0x47, 0x6B, 0x02 ; 00001D92  test byte [cs:bx+0x6b],0x2
  db 0x74, 0x14                ; 00001D97  jz 0x1dad
  db 0x2E, 0x80, 0x3E, 0x88, 0x2F, 0xFF ; 00001D99  cmp byte [cs:0x2f88],0xff
  db 0x75, 0x0C                ; 00001D9F  jnz 0x1dad
  db 0xAD                      ; 00001DA1  lodsw
  db 0x80, 0xE4, 0x87          ; 00001DA2  and ah,0x87
  db 0x80, 0xCC, 0x08          ; 00001DA5  or ah,0x8
  db 0xAB                      ; 00001DA8  stosw
  db 0xE2, 0xF6                ; 00001DA9  loop 0x1da1
  db 0xEB, 0x02                ; 00001DAB  jmp short 0x1daf
  db 0xF3, 0xA5                ; 00001DAD  rep movsw
  db 0x5E                      ; 00001DAF  pop si
  db 0xEB, 0xAE                ; 00001DB0  jmp short 0x1d60
  db 0x07                      ; 00001DB2  pop es
  db 0x1F                      ; 00001DB3  pop ds
  db 0xC3                      ; 00001DB4  ret
  db 0xC7, 0x47, 0x5A, 0xFF, 0xFF ; 00001DB5  mov word [bx+0x5a],0xffff
  db 0x8B, 0x57, 0x36          ; 00001DBA  mov dx,[bx+0x36]
  db 0x8B, 0x4F, 0x44          ; 00001DBD  mov cx,[bx+0x44]
  db 0xFE, 0xCE                ; 00001DC0  dec dh
  db 0x78, 0x0C                ; 00001DC2  js 0x1dd0
  db 0x2E, 0xC6, 0x06, 0x80, 0x2A, 0xAC ; 00001DC4  mov byte [cs:0x2a80],0xac
  db 0xB8, 0xBC, 0xCC          ; 00001DCA  mov ax,0xccbc
  db 0xE8, 0x38, 0x00          ; 00001DCD  call 0x1e08
  db 0x8A, 0x77, 0x39          ; 00001DD0  mov dh,[bx+0x39]
  db 0xFE, 0xC6                ; 00001DD3  inc dh
  db 0x3A, 0x77, 0x48          ; 00001DD5  cmp dh,[bx+0x48]
  db 0x74, 0x0C                ; 00001DD8  jz 0x1de6
  db 0x2E, 0xC6, 0x06, 0x80, 0x2A, 0xD0 ; 00001DDA  mov byte [cs:0x2a80],0xd0
  db 0xB8, 0xD5, 0xDA          ; 00001DE0  mov ax,0xdad5
  db 0xE8, 0x22, 0x00          ; 00001DE3  call 0x1e08
  db 0x8B, 0x57, 0x36          ; 00001DE6  mov dx,[bx+0x36]
  db 0x8B, 0x4F, 0x42          ; 00001DE9  mov cx,[bx+0x42]
  db 0xFE, 0xCA                ; 00001DEC  dec dl
  db 0x78, 0x05                ; 00001DEE  js 0x1df5
  db 0xB0, 0xB5                ; 00001DF0  mov al,0xb5
  db 0xE8, 0x74, 0x00          ; 00001DF2  call 0x1e69
  db 0x8A, 0x57, 0x38          ; 00001DF5  mov dl,[bx+0x38]
  db 0xFE, 0xC2                ; 00001DF8  inc dl
  db 0x80, 0xFA, 0x50          ; 00001DFA  cmp dl,0x50
  db 0x74, 0x05                ; 00001DFD  jz 0x1e04
  db 0xB0, 0xCA                ; 00001DFF  mov al,0xca
  db 0xE8, 0x65, 0x00          ; 00001E01  call 0x1e69
  db 0xE8, 0x8F, 0x00          ; 00001E04  call 0x1e96
  db 0xC3                      ; 00001E07  ret
  db 0x52                      ; 00001E08  push dx
  db 0x51                      ; 00001E09  push cx
  db 0x50                      ; 00001E0A  push ax
  db 0xE8, 0x46, 0xFE          ; 00001E0B  call 0x1c54
  db 0x96                      ; 00001E0E  xchg ax,si
  db 0x58                      ; 00001E0F  pop ax
  db 0x50                      ; 00001E10  push ax
  db 0xB4, 0x08                ; 00001E11  mov ah,0x8
  db 0x80, 0xFA, 0x00          ; 00001E13  cmp dl,0x0
  db 0x74, 0x06                ; 00001E16  jz 0x1e1e
  db 0x4F                      ; 00001E18  dec di
  db 0x4F                      ; 00001E19  dec di
  db 0x4E                      ; 00001E1A  dec si
  db 0xE8, 0x63, 0x00          ; 00001E1B  call 0x1e81
  db 0x02, 0xD1                ; 00001E1E  add dl,cl
  db 0xFE, 0xCA                ; 00001E20  dec dl
  db 0x2E, 0x80, 0x3E, 0x80, 0x2A, 0xAC ; 00001E22  cmp byte [cs:0x2a80],0xac
  db 0x75, 0x28                ; 00001E28  jnz 0x1e52
  db 0x50                      ; 00001E2A  push ax
  db 0x51                      ; 00001E2B  push cx
  db 0xB4, 0x08                ; 00001E2C  mov ah,0x8
  db 0xB0, 0x20                ; 00001E2E  mov al,0x20
  db 0xE8, 0x4E, 0x00          ; 00001E30  call 0x1e81
  db 0x8A, 0x47, 0x34          ; 00001E33  mov al,[bx+0x34]
  db 0x04, 0x30                ; 00001E36  add al,0x30
  db 0xE8, 0x46, 0x00          ; 00001E38  call 0x1e81
  db 0xB0, 0x3A                ; 00001E3B  mov al,0x3a
  db 0xE8, 0x41, 0x00          ; 00001E3D  call 0x1e81
  db 0x89, 0x77, 0x5A          ; 00001E40  mov [bx+0x5a],si
  db 0xE8, 0x50, 0x00          ; 00001E43  call 0x1e96
  db 0xB0, 0x20                ; 00001E46  mov al,0x20
  db 0xE8, 0x36, 0x00          ; 00001E48  call 0x1e81
  db 0x59                      ; 00001E4B  pop cx
  db 0x58                      ; 00001E4C  pop ax
  db 0x83, 0xE9, 0x0C          ; 00001E4D  sub cx,byte +0xc
  db 0x76, 0x09                ; 00001E50  jna 0x1e5b
  db 0x2E, 0xA0, 0x80, 0x2A    ; 00001E52  mov al,[cs:0x2a80]
  db 0xE8, 0x28, 0x00          ; 00001E56  call 0x1e81
  db 0xE2, 0xFB                ; 00001E59  loop 0x1e56
  db 0x59                      ; 00001E5B  pop cx
  db 0x86, 0xC5                ; 00001E5C  xchg al,ch
  db 0x80, 0xFA, 0x4F          ; 00001E5E  cmp dl,0x4f
  db 0x74, 0x03                ; 00001E61  jz 0x1e66
  db 0xE8, 0x1B, 0x00          ; 00001E63  call 0x1e81
  db 0x59                      ; 00001E66  pop cx
  db 0x5A                      ; 00001E67  pop dx
  db 0xC3                      ; 00001E68  ret
  db 0x51                      ; 00001E69  push cx
  db 0x50                      ; 00001E6A  push ax
  db 0xE8, 0xE6, 0xFD          ; 00001E6B  call 0x1c54
  db 0x96                      ; 00001E6E  xchg ax,si
  db 0x58                      ; 00001E6F  pop ax
  db 0xB4, 0x08                ; 00001E70  mov ah,0x8
  db 0xE8, 0x0C, 0x00          ; 00001E72  call 0x1e81
  db 0x81, 0xC7, 0x9E, 0x00    ; 00001E75  add di,0x9e
  db 0x83, 0xC6, 0x4F          ; 00001E79  add si,byte +0x4f
  db 0xE2, 0xF4                ; 00001E7C  loop 0x1e72
  db 0x59                      ; 00001E7E  pop cx
  db 0xC3                      ; 00001E7F  ret
  db 0x00, 0x50, 0x2E          ; 00001E80  add [bx+si+0x2e],dl
  db 0x8A, 0x84, 0x9F, 0x4F    ; 00001E83  mov al,[si+0x4f9f]
  db 0x46                      ; 00001E87  inc si
  db 0xE8, 0xD6, 0xFD          ; 00001E88  call 0x1c61
  db 0x3A, 0x47, 0x34          ; 00001E8B  cmp al,[bx+0x34]
  db 0x58                      ; 00001E8E  pop ax
  db 0x75, 0x02                ; 00001E8F  jnz 0x1e93
  db 0xAB                      ; 00001E91  stosw
  db 0xC3                      ; 00001E92  ret
  db 0x47                      ; 00001E93  inc di
  db 0x47                      ; 00001E94  inc di
  db 0xC3                      ; 00001E95  ret
  db 0x2E, 0x8E, 0x06, 0x7E, 0x2F ; 00001E96  mov es,[cs:0x2f7e]
  db 0x8B, 0x77, 0x5C          ; 00001E9B  mov si,[bx+0x5c]
  db 0x8B, 0x34                ; 00001E9E  mov si,[si]
  db 0x85, 0xF6                ; 00001EA0  test si,si
  db 0x74, 0x1E                ; 00001EA2  jz 0x1ec2
  db 0x8D, 0x6C, 0x08          ; 00001EA4  lea bp,[si+0x8]
  db 0x8B, 0x77, 0x5A          ; 00001EA7  mov si,[bx+0x5a]
  db 0x83, 0xFE, 0xFF          ; 00001EAA  cmp si,byte -0x1
  db 0x74, 0x13                ; 00001EAD  jz 0x1ec2
  db 0x8B, 0xFE                ; 00001EAF  mov di,si
  db 0x03, 0xFF                ; 00001EB1  add di,di
  db 0xB9, 0x08, 0x00          ; 00001EB3  mov cx,0x8
  db 0xB4, 0x08                ; 00001EB6  mov ah,0x8
  db 0x87, 0xF5                ; 00001EB8  xchg si,bp
  db 0xAC                      ; 00001EBA  lodsb
  db 0x87, 0xF5                ; 00001EBB  xchg si,bp
  db 0xE8, 0xC1, 0xFF          ; 00001EBD  call 0x1e81
  db 0xE2, 0xF6                ; 00001EC0  loop 0x1eb8
  db 0xC3                      ; 00001EC2  ret
  db 0x80, 0xF9, 0x04          ; 00001EC3  cmp cl,0x4
  db 0x72, 0x03                ; 00001EC6  jc 0x1ecb
  db 0x32, 0xC0                ; 00001EC8  xor al,al
  db 0xC3                      ; 00001ECA  ret
  db 0x8A, 0xD9                ; 00001ECB  mov bl,cl
  db 0x32, 0xFF                ; 00001ECD  xor bh,bh
  db 0xD1, 0xE3                ; 00001ECF  shl bx,1
  db 0x2E, 0xFF, 0xA7, 0xD6, 0x2A ; 00001ED1  jmp [cs:bx+0x2ad6]
  db 0xEB, 0x2A                ; 00001ED6  jmp short 0x1f02
  db 0xEF                      ; 00001ED8  out dx,ax
  db 0x2A, 0xEE                ; 00001ED9  sub ch,dh
  db 0x2A, 0xF5                ; 00001EDB  sub dh,ch
  db 0x2A, 0x05                ; 00001EDD  sub al,[di]
  db 0x00, 0x00                ; 00001EDF  add [bx+si],al
  db 0x00, 0x00                ; 00001EE1  add [bx+si],al
  db 0x00, 0x00                ; 00001EE3  add [bx+si],al
  db 0x00, 0x00                ; 00001EE5  add [bx+si],al
  db 0x00, 0x00                ; 00001EE7  add [bx+si],al
  db 0x00, 0x00                ; 00001EE9  add [bx+si],al
  db 0xB0, 0xFF                ; 00001EEB  mov al,0xff
  db 0xC3                      ; 00001EED  ret
  db 0xC3                      ; 00001EEE  ret
  db 0x2E, 0xC6, 0x06, 0xDE, 0x2A, 0x05 ; 00001EEF  mov byte [cs:0x2ade],0x5
  db 0x9C                      ; 00001EF5  pushf
  db 0xFA                      ; 00001EF6  cli
  db 0x33, 0xC0                ; 00001EF7  xor ax,ax
  db 0x33, 0xDB                ; 00001EF9  xor bx,bx
  db 0x33, 0xC9                ; 00001EFB  xor cx,cx
  db 0x2E, 0x87, 0x06, 0xDF, 0x2A ; 00001EFD  xchg ax,[cs:0x2adf]
  db 0x2E, 0x87, 0x1E, 0xE1, 0x2A ; 00001F02  xchg bx,[cs:0x2ae1]
  db 0x2E, 0x87, 0x0E, 0xE3, 0x2A ; 00001F07  xchg cx,[cs:0x2ae3]
  db 0x9D                      ; 00001F0C  popf
  db 0xC3                      ; 00001F0D  ret
  db 0x8A, 0xE0                ; 00001F0E  mov ah,al
  db 0x2E, 0x80, 0x3E, 0xDE, 0x2A, 0x05 ; 00001F10  cmp byte [cs:0x2ade],0x5
  db 0x75, 0x39                ; 00001F16  jnz 0x1f51
  db 0x80, 0xE4, 0xF8          ; 00001F18  and ah,0xf8
  db 0x80, 0xFC, 0x80          ; 00001F1B  cmp ah,0x80
  db 0x75, 0x30                ; 00001F1E  jnz 0x1f50
  db 0xF6, 0xD0                ; 00001F20  not al
  db 0x24, 0x07                ; 00001F22  and al,0x7
  db 0x75, 0x09                ; 00001F24  jnz 0x1f2f
  db 0x2E, 0xC7, 0x06, 0xE5, 0x2A, 0x02, 0x00 ; 00001F26  mov word [cs:0x2ae5],0x2
  db 0xEB, 0x1C                ; 00001F2D  jmp short 0x1f4b
  db 0x2E, 0x83, 0x3E, 0xE5, 0x2A, 0x01 ; 00001F2F  cmp word [cs:0x2ae5],byte +0x1
  db 0x74, 0x19                ; 00001F35  jz 0x1f50
  db 0xB4, 0x20                ; 00001F37  mov ah,0x20
  db 0xA8, 0x04                ; 00001F39  test al,0x4
  db 0x75, 0x08                ; 00001F3B  jnz 0x1f45
  db 0xFE, 0xC4                ; 00001F3D  inc ah
  db 0xA8, 0x02                ; 00001F3F  test al,0x2
  db 0x75, 0x02                ; 00001F41  jnz 0x1f45
  db 0xFE, 0xC4                ; 00001F43  inc ah
  db 0xB0, 0x01                ; 00001F45  mov al,0x1
  db 0x2E, 0xA3, 0xE5, 0x2A    ; 00001F47  mov [cs:0x2ae5],ax
  db 0x2E, 0xFE, 0x0E, 0xDE, 0x2A ; 00001F4B  dec byte [cs:0x2ade]
  db 0xC3                      ; 00001F50  ret
  db 0x8A, 0xE0                ; 00001F51  mov ah,al
  db 0x80, 0xE4, 0xF8          ; 00001F53  and ah,0xf8
  db 0x80, 0xFC, 0x80          ; 00001F56  cmp ah,0x80
  db 0x74, 0x47                ; 00001F59  jz 0x1fa2
  db 0x98                      ; 00001F5B  cbw
  db 0x2E, 0x8A, 0x1E, 0xDE, 0x2A ; 00001F5C  mov bl,[cs:0x2ade]
  db 0xFE, 0xCB                ; 00001F61  dec bl
  db 0x74, 0x1B                ; 00001F63  jz 0x1f80
  db 0xFE, 0xCB                ; 00001F65  dec bl
  db 0x74, 0x10                ; 00001F67  jz 0x1f79
  db 0xFE, 0xCB                ; 00001F69  dec bl
  db 0x74, 0x06                ; 00001F6B  jz 0x1f73
  db 0x2E, 0xA3, 0xE7, 0x2A    ; 00001F6D  mov [cs:0x2ae7],ax
  db 0xEB, 0xD8                ; 00001F71  jmp short 0x1f4b
  db 0x2E, 0xA3, 0xE9, 0x2A    ; 00001F73  mov [cs:0x2ae9],ax
  db 0xEB, 0xD2                ; 00001F77  jmp short 0x1f4b
  db 0x2E, 0x01, 0x06, 0xE7, 0x2A ; 00001F79  add [cs:0x2ae7],ax
  db 0xEB, 0xCB                ; 00001F7E  jmp short 0x1f4b
  db 0x2E, 0x03, 0x06, 0xE9, 0x2A ; 00001F80  add ax,[cs:0x2ae9]
  db 0x2E, 0x01, 0x06, 0xE3, 0x2A ; 00001F85  add [cs:0x2ae3],ax
  db 0x2E, 0xA1, 0xE7, 0x2A    ; 00001F8A  mov ax,[cs:0x2ae7]
  db 0x2E, 0x01, 0x06, 0xE1, 0x2A ; 00001F8E  add [cs:0x2ae1],ax
  db 0x2E, 0xA1, 0xE5, 0x2A    ; 00001F93  mov ax,[cs:0x2ae5]
  db 0x2E, 0xA3, 0xDF, 0x2A    ; 00001F97  mov [cs:0x2adf],ax
  db 0x2E, 0xC6, 0x06, 0xDE, 0x2A, 0x05 ; 00001F9B  mov byte [cs:0x2ade],0x5
  db 0xC3                      ; 00001FA1  ret
  db 0x2E, 0xC6, 0x06, 0xDE, 0x2A, 0x05 ; 00001FA2  mov byte [cs:0x2ade],0x5
  db 0xE9, 0x63, 0xFF          ; 00001FA8  jmp 0x1f0e
  db 0x2E, 0x8B, 0x1E, 0x1B, 0x2D ; 00001FAB  mov bx,[cs:0x2d1b]
  db 0x80, 0xBF, 0x83, 0x00, 0x00 ; 00001FB0  cmp byte [bx+0x83],0x0
  db 0x74, 0x36                ; 00001FB5  jz 0x1fed
  db 0xF6, 0x47, 0x6B, 0x04    ; 00001FB7  test byte [bx+0x6b],0x4
  db 0x75, 0x30                ; 00001FBB  jnz 0x1fed
  db 0x2E, 0x80, 0x3E, 0x23, 0x2C, 0xFF ; 00001FBD  cmp byte [cs:0x2c23],0xff
  db 0x74, 0x28                ; 00001FC3  jz 0x1fed
  db 0x2E, 0xFF, 0x0E, 0x21, 0x2C ; 00001FC5  dec word [cs:0x2c21]
  db 0x75, 0x21                ; 00001FCA  jnz 0x1fed
  db 0x2E, 0xC6, 0x06, 0x23, 0x2C, 0xFF ; 00001FCC  mov byte [cs:0x2c23],0xff
  db 0xE8, 0x47, 0xF2          ; 00001FD2  call 0x121c
  db 0xB8, 0x40, 0x70          ; 00001FD5  mov ax,0x7040
  db 0xE8, 0x69, 0x00          ; 00001FD8  call 0x2044
  db 0x2E, 0x80, 0x36, 0xFA, 0x6D, 0x80 ; 00001FDB  xor byte [cs:0x6dfa],0x80
  db 0x2E, 0xC7, 0x06, 0x12, 0x6E, 0xFF, 0xFF ; 00001FE1  mov word [cs:0x6e12],0xffff
  db 0xC7, 0x47, 0x5E, 0xAA, 0x15 ; 00001FE8  mov word [bx+0x5e],0x15aa
  db 0xC3                      ; 00001FED  ret
  db 0x53                      ; 00001FEE  push bx
  db 0x2E, 0x8B, 0x1E, 0x1B, 0x2D ; 00001FEF  mov bx,[cs:0x2d1b]
  db 0x80, 0xBF, 0x83, 0x00, 0x00 ; 00001FF4  cmp byte [bx+0x83],0x0
  db 0x75, 0x02                ; 00001FF9  jnz 0x1ffd
  db 0x5B                      ; 00001FFB  pop bx
  db 0xC3                      ; 00001FFC  ret
  db 0x2E, 0x8B, 0x1E, 0x1F, 0x2C ; 00001FFD  mov bx,[cs:0x2c1f]
  db 0x2E, 0x89, 0x1E, 0x21, 0x2C ; 00002002  mov [cs:0x2c21],bx
  db 0x52                      ; 00002007  push dx
  db 0x2E, 0x80, 0x36, 0xFA, 0x6D, 0x80 ; 00002008  xor byte [cs:0x6dfa],0x80
  db 0x2E, 0x8B, 0x1E, 0x1B, 0x2D ; 0000200E  mov bx,[cs:0x2d1b]
  db 0xE8, 0xB9, 0xEE          ; 00002013  call 0xecf
  db 0x5A                      ; 00002016  pop dx
  db 0x5B                      ; 00002017  pop bx
  db 0x2E, 0xC6, 0x06, 0x23, 0x2C, 0x00 ; 00002018  mov byte [cs:0x2c23],0x0
  db 0xC3                      ; 0000201E  ret
  db 0x84, 0x03                ; 0000201F  test [bp+di],al
  db 0x84, 0x03                ; 00002021  test [bp+di],al
  db 0x00, 0xB0, 0x01, 0x2E    ; 00002023  add [bx+si+0x2e01],dh
  db 0xA3, 0xF8, 0x6D          ; 00002027  mov [0x6df8],ax
  db 0xBA, 0x40, 0x02          ; 0000202A  mov dx,0x240
  db 0xEE                      ; 0000202D  out dx,al
  db 0x2E, 0x38, 0x06, 0xF8, 0x6D ; 0000202E  cmp [cs:0x6df8],al
  db 0x74, 0xF9                ; 00002033  jz 0x202e
  db 0x2E, 0xC7, 0x06, 0xF8, 0x6D, 0x00, 0x09 ; 00002035  mov word [cs:0x6df8],0x900
  db 0xC3                      ; 0000203C  ret
  db 0x2E, 0x8B, 0x16, 0x7E, 0x2F ; 0000203D  mov dx,[cs:0x2f7e]
  db 0xEB, 0x02                ; 00002042  jmp short 0x2046
  db 0x8C, 0xCA                ; 00002044  mov dx,cs
  db 0xFC                      ; 00002046  cld
  db 0xE8, 0x09, 0x00          ; 00002047  call 0x2053
  db 0x8C, 0xCA                ; 0000204A  mov dx,cs
  db 0x8E, 0xC2                ; 0000204C  mov es,dx
  db 0xAB                      ; 0000204E  stosw
  db 0x8B, 0xC1                ; 0000204F  mov ax,cx
  db 0xAB                      ; 00002051  stosw
  db 0xC3                      ; 00002052  ret
  db 0xB1, 0x04                ; 00002053  mov cl,0x4
  db 0xD3, 0xC2                ; 00002055  rol dx,cl
  db 0x8B, 0xCA                ; 00002057  mov cx,dx
  db 0x81, 0xE1, 0x0F, 0x00    ; 00002059  and cx,0xf
  db 0x80, 0xE2, 0xF0          ; 0000205D  and dl,0xf0
  db 0x03, 0xC2                ; 00002060  add ax,dx
  db 0x83, 0xD1, 0x00          ; 00002062  adc cx,byte +0x0
  db 0xC3                      ; 00002065  ret
  db 0x2E, 0x80, 0x3E, 0x88, 0x2F, 0xFF ; 00002066  cmp byte [cs:0x2f88],0xff
  db 0x74, 0x15                ; 0000206C  jz 0x2083
  db 0x06                      ; 0000206E  push es
  db 0x1E                      ; 0000206F  push ds
  db 0x07                      ; 00002070  pop es
  db 0x8D, 0xBF, 0x84, 0x00    ; 00002071  lea di,[bx+0x84]
  db 0xBE, 0x97, 0x2C          ; 00002075  mov si,0x2c97
  db 0xB9, 0x10, 0x00          ; 00002078  mov cx,0x10
  db 0x89, 0x8F, 0x81, 0x00    ; 0000207B  mov [bx+0x81],cx
  db 0xF3, 0xA4                ; 0000207F  rep movsb
  db 0x07                      ; 00002081  pop es
  db 0xC3                      ; 00002082  ret
  db 0x2E, 0xA0, 0x8B, 0x2F    ; 00002083  mov al,[cs:0x2f8b]
  db 0x2E, 0x8A, 0x26, 0x8C, 0x2F ; 00002087  mov ah,[cs:0x2f8c]
  db 0x89, 0x87, 0x84, 0x00    ; 0000208C  mov [bx+0x84],ax
  db 0xC7, 0x87, 0x81, 0x00, 0x02, 0x00 ; 00002090  mov word [bx+0x81],0x2
  db 0xC3                      ; 00002096  ret
  db 0x48                      ; 00002097  dec ax
  db 0x40                      ; 00002098  inc ax
  db 0x00, 0x04                ; 00002099  add [si],al
  db 0x08, 0x0C                ; 0000209B  or [si],cl
  db 0x44                      ; 0000209D  inc sp
  db 0x4C                      ; 0000209E  dec sp
  db 0x80, 0x84, 0x88, 0x8C, 0xC0 ; 0000209F  add byte [si-0x7378],0xc0
  db 0xC4                      ; 000020A4  db 0xc4
  db 0xC8, 0xCC, 0x0C, 0xC0    ; 000020A5  enter 0xccc,0xc0
  db 0x00, 0x0C                ; 000020A9  add [si],cl
  db 0x0C, 0x0C                ; 000020AB  or al,0xc
  db 0xCC                      ; 000020AD  int3
  db 0x0C, 0xC0                ; 000020AE  or al,0xc0
  db 0xC0, 0xCC, 0x0C          ; 000020B0  ror ah,byte 0xc
  db 0xC0, 0xC0, 0xC0          ; 000020B3  rol al,byte 0xc0
  db 0xCC                      ; 000020B6  int3
  db 0x2E, 0x80, 0x3E, 0x88, 0x2F, 0xFF ; 000020B7  cmp byte [cs:0x2f88],0xff
  db 0x74, 0x1B                ; 000020BD  jz 0x20da
  db 0xF6, 0x47, 0x6B, 0x04    ; 000020BF  test byte [bx+0x6b],0x4
  db 0x75, 0x15                ; 000020C3  jnz 0x20da
  db 0x06                      ; 000020C5  push es
  db 0x57                      ; 000020C6  push di
  db 0x51                      ; 000020C7  push cx
  db 0xBF, 0x97, 0x2C          ; 000020C8  mov di,0x2c97
  db 0x0E                      ; 000020CB  push cs
  db 0x07                      ; 000020CC  pop es
  db 0xB9, 0x10, 0x00          ; 000020CD  mov cx,0x10
  db 0xF2, 0xAE                ; 000020D0  repne scasb
  db 0x83, 0xC7, 0x0F          ; 000020D2  add di,byte +0xf
  db 0x8A, 0x05                ; 000020D5  mov al,[di]
  db 0x59                      ; 000020D7  pop cx
  db 0x5F                      ; 000020D8  pop di
  db 0x07                      ; 000020D9  pop es
  db 0xC3                      ; 000020DA  ret
  db 0x8D, 0xB7, 0x84, 0x00    ; 000020DB  lea si,[bx+0x84]
  db 0xBA, 0x80, 0x01          ; 000020DF  mov dx,0x180
  db 0xB9, 0x10, 0x00          ; 000020E2  mov cx,0x10
  db 0xAC                      ; 000020E5  lodsb
  db 0xE8, 0xCE, 0xFF          ; 000020E6  call 0x20b7
  db 0xEE                      ; 000020E9  out dx,al
  db 0x42                      ; 000020EA  inc dx
  db 0x42                      ; 000020EB  inc dx
  db 0xEE                      ; 000020EC  out dx,al
  db 0x42                      ; 000020ED  inc dx
  db 0x42                      ; 000020EE  inc dx
  db 0xE2, 0xF4                ; 000020EF  loop 0x20e5
  db 0xC3                      ; 000020F1  ret
  db 0xF6, 0x47, 0x6B, 0x02    ; 000020F2  test byte [bx+0x6b],0x2
  db 0x75, 0x1B                ; 000020F6  jnz 0x2113
  db 0x8A, 0x47, 0x75          ; 000020F8  mov al,[bx+0x75]
  db 0x2E, 0xA2, 0x4A, 0x6E    ; 000020FB  mov [cs:0x6e4a],al
  db 0x8A, 0x47, 0x74          ; 000020FF  mov al,[bx+0x74]
  db 0x2E, 0xA2, 0x46, 0x6E    ; 00002102  mov [cs:0x6e46],al
  db 0x8B, 0x4F, 0x72          ; 00002106  mov cx,[bx+0x72]
  db 0x2E, 0x89, 0x0E, 0x30, 0x6E ; 00002109  mov [cs:0x6e30],cx
  db 0xB4, 0x04                ; 0000210E  mov ah,0x4
  db 0xE8, 0x11, 0xFF          ; 00002110  call 0x2024
  db 0xC3                      ; 00002113  ret
  db 0x00, 0x04                ; 00002114  add [si],al
  db 0x03, 0x02                ; 00002116  add ax,[bp+si]
  db 0x01, 0x00                ; 00002118  add [bx+si],ax
  db 0x00, 0x2E, 0x2D, 0xFF    ; 0000211A  add [0xff2d],ch
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
  db 0x4F                      ; 00002166  dec di
  db 0x17                      ; 00002167  pop ss
  db 0x00, 0x00                ; 00002168  add [bx+si],al
  db 0x4F                      ; 0000216A  dec di
  db 0x17                      ; 0000216B  pop ss
  db 0x50                      ; 0000216C  push ax
  db 0x18, 0x00                ; 0000216D  sbb [bx+si],al
  db 0x00, 0x18                ; 0000216F  add [bx+si],bl
  db 0x00, 0x50, 0x00          ; 00002171  add [bx+si+0x0],dl
  db 0x00, 0x00                ; 00002174  add [bx+si],al
  db 0x18, 0x00                ; 00002176  sbb [bx+si],al
  db 0x00, 0x00                ; 00002178  add [bx+si],al
  db 0x00, 0x50, 0x01          ; 0000217A  add [bx+si+0x1],dl
  db 0x00, 0x00                ; 0000217D  add [bx+si],al
  db 0x00, 0x00                ; 0000217F  add [bx+si],al
  db 0x00, 0x00                ; 00002181  add [bx+si],al
  db 0x00, 0x00                ; 00002183  add [bx+si],al
  db 0x00, 0x00                ; 00002185  add [bx+si],al
  db 0x00, 0xFF                ; 00002187  add bh,bh
  db 0xFF, 0x49, 0x0D          ; 00002189  dec word [bx+di+0xd]
  db 0x96                      ; 0000218C  xchg ax,si
  db 0x14, 0x4F                ; 0000218D  adc al,0x4f
  db 0x00, 0x00                ; 0000218F  add [bx+si],al
  db 0x00, 0x00                ; 00002191  add [bx+si],al
  db 0x00, 0x00                ; 00002193  add [bx+si],al
  db 0x00, 0x00                ; 00002195  add [bx+si],al
  db 0x00, 0x08                ; 00002197  add [bx+si],cl
  db 0x00, 0x00                ; 00002199  add [bx+si],al
  db 0x00, 0x00                ; 0000219B  add [bx+si],al
  db 0x00, 0x0D                ; 0000219D  add [di],cl
  db 0x01, 0x0A                ; 0000219F  add [bp+si],cx
  db 0x00, 0x01                ; 000021A1  add [bx+di],al
  db 0xF8                      ; 000021A3  clc
  db 0xE7, 0x58                ; 000021A4  out 0x58,ax
  db 0x00, 0x00                ; 000021A6  add [bx+si],al
  db 0x00, 0x00                ; 000021A8  add [bx+si],al
  db 0x00, 0x00                ; 000021AA  add [bx+si],al
  db 0x00, 0x00                ; 000021AC  add [bx+si],al
  db 0x00, 0x02                ; 000021AE  add [bp+si],al
  db 0x00, 0x0F                ; 000021B0  add [bx],cl
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
  db 0x01, 0x00                ; 000021F6  add [bx+si],ax
  db 0x00, 0x00                ; 000021F8  add [bx+si],al
  db 0x4F                      ; 000021FA  dec di
  db 0x17                      ; 000021FB  pop ss
  db 0x00, 0x00                ; 000021FC  add [bx+si],al
  db 0x4F                      ; 000021FE  dec di
  db 0x17                      ; 000021FF  pop ss
  db 0x50                      ; 00002200  push ax
  db 0x18, 0x00                ; 00002201  sbb [bx+si],al
  db 0x00, 0x18                ; 00002203  add [bx+si],bl
  db 0x00, 0x50, 0x00          ; 00002205  add [bx+si+0x0],dl
  db 0x00, 0x00                ; 00002208  add [bx+si],al
  db 0x18, 0x00                ; 0000220A  sbb [bx+si],al
  db 0x00, 0x00                ; 0000220C  add [bx+si],al
  db 0x00, 0x50, 0x02          ; 0000220E  add [bx+si+0x2],dl
  db 0x00, 0x00                ; 00002211  add [bx+si],al
  db 0x00, 0x00                ; 00002213  add [bx+si],al
  db 0x00, 0x00                ; 00002215  add [bx+si],al
  db 0x00, 0x00                ; 00002217  add [bx+si],al
  db 0x00, 0x00                ; 00002219  add [bx+si],al
  db 0x00, 0xFF                ; 0000221B  add bh,bh
  db 0xFF, 0x75, 0x0D          ; 0000221D  push word [di+0xd]
  db 0x96                      ; 00002220  xchg ax,si
  db 0x14, 0x4F                ; 00002221  adc al,0x4f
  db 0x00, 0x00                ; 00002223  add [bx+si],al
  db 0x00, 0x00                ; 00002225  add [bx+si],al
  db 0x00, 0x00                ; 00002227  add [bx+si],al
  db 0x00, 0x00                ; 00002229  add [bx+si],al
  db 0x00, 0x08                ; 0000222B  add [bx+si],cl
  db 0x12, 0x00                ; 0000222D  adc al,[bx+si]
  db 0x00, 0x00                ; 0000222F  add [bx+si],al
  db 0x00, 0x0D                ; 00002231  add [di],cl
  db 0x01, 0x0A                ; 00002233  add [bp+si],cx
  db 0x00, 0x01                ; 00002235  add [bx+di],al
  db 0xF8                      ; 00002237  clc
  db 0xAF                      ; 00002238  scasw
  db 0x5A                      ; 00002239  pop dx
  db 0x00, 0x00                ; 0000223A  add [bx+si],al
  db 0x00, 0x00                ; 0000223C  add [bx+si],al
  db 0x00, 0x00                ; 0000223E  add [bx+si],al
  db 0x00, 0x00                ; 00002240  add [bx+si],al
  db 0x00, 0x02                ; 00002242  add [bp+si],al
  db 0x00, 0x0F                ; 00002244  add [bx],cl
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
  db 0x02, 0x00                ; 0000228A  add al,[bx+si]
  db 0x00, 0x00                ; 0000228C  add [bx+si],al
  db 0x4F                      ; 0000228E  dec di
  db 0x17                      ; 0000228F  pop ss
  db 0x00, 0x00                ; 00002290  add [bx+si],al
  db 0x4F                      ; 00002292  dec di
  db 0x17                      ; 00002293  pop ss
  db 0x50                      ; 00002294  push ax
  db 0x18, 0x00                ; 00002295  sbb [bx+si],al
  db 0x00, 0x18                ; 00002297  add [bx+si],bl
  db 0x00, 0x50, 0x00          ; 00002299  add [bx+si+0x0],dl
  db 0x00, 0x00                ; 0000229C  add [bx+si],al
  db 0x18, 0x00                ; 0000229E  sbb [bx+si],al
  db 0x00, 0x00                ; 000022A0  add [bx+si],al
  db 0x00, 0x50, 0x04          ; 000022A2  add [bx+si+0x4],dl
  db 0x00, 0x00                ; 000022A5  add [bx+si],al
  db 0x00, 0x00                ; 000022A7  add [bx+si],al
  db 0x00, 0x00                ; 000022A9  add [bx+si],al
  db 0x00, 0x00                ; 000022AB  add [bx+si],al
  db 0x00, 0x00                ; 000022AD  add [bx+si],al
  db 0x00, 0xFF                ; 000022AF  add bh,bh
  db 0xFF, 0xA1, 0x0D, 0x96    ; 000022B1  jmp [bx+di-0x69f3]
  db 0x14, 0x4F                ; 000022B5  adc al,0x4f
  db 0x00, 0x00                ; 000022B7  add [bx+si],al
  db 0x00, 0x00                ; 000022B9  add [bx+si],al
  db 0x00, 0x00                ; 000022BB  add [bx+si],al
  db 0x00, 0x00                ; 000022BD  add [bx+si],al
  db 0x00, 0x08                ; 000022BF  add [bx+si],cl
  db 0x12, 0x00                ; 000022C1  adc al,[bx+si]
  db 0x00, 0x00                ; 000022C3  add [bx+si],al
  db 0x00, 0x0D                ; 000022C5  add [di],cl
  db 0x01, 0x0A                ; 000022C7  add [bp+si],cx
  db 0x00, 0x01                ; 000022C9  add [bx+di],al
  db 0xF8                      ; 000022CB  clc
  db 0x77, 0x5C                ; 000022CC  ja 0x232a
  db 0x00, 0x00                ; 000022CE  add [bx+si],al
  db 0x00, 0x00                ; 000022D0  add [bx+si],al
  db 0x00, 0x00                ; 000022D2  add [bx+si],al
  db 0x00, 0x00                ; 000022D4  add [bx+si],al
  db 0x00, 0x02                ; 000022D6  add [bp+si],al
  db 0x00, 0x0F                ; 000022D8  add [bx],cl
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
  db 0x03, 0x00                ; 0000231E  add ax,[bx+si]
  db 0x00, 0x00                ; 00002320  add [bx+si],al
  db 0x4F                      ; 00002322  dec di
  db 0x17                      ; 00002323  pop ss
  db 0x00, 0x00                ; 00002324  add [bx+si],al
  db 0x4F                      ; 00002326  dec di
  db 0x17                      ; 00002327  pop ss
  db 0x50                      ; 00002328  push ax
  db 0x18, 0x00                ; 00002329  sbb [bx+si],al
  db 0x00, 0x18                ; 0000232B  add [bx+si],bl
  db 0x00, 0x50, 0x00          ; 0000232D  add [bx+si+0x0],dl
  db 0x00, 0x00                ; 00002330  add [bx+si],al
  db 0x18, 0x00                ; 00002332  sbb [bx+si],al
  db 0x00, 0x00                ; 00002334  add [bx+si],al
  db 0x00, 0x50, 0x08          ; 00002336  add [bx+si+0x8],dl
  db 0x00, 0x00                ; 00002339  add [bx+si],al
  db 0x00, 0x00                ; 0000233B  add [bx+si],al
  db 0x00, 0x00                ; 0000233D  add [bx+si],al
  db 0x00, 0x00                ; 0000233F  add [bx+si],al
  db 0x00, 0x00                ; 00002341  add [bx+si],al
  db 0x00, 0xFF                ; 00002343  add bh,bh
  db 0xFF, 0xCD                ; 00002345  dec bp
  db 0x0D, 0x96, 0x14          ; 00002347  or ax,0x1496
  db 0x4F                      ; 0000234A  dec di
  db 0x00, 0x00                ; 0000234B  add [bx+si],al
  db 0x00, 0x00                ; 0000234D  add [bx+si],al
  db 0x00, 0x00                ; 0000234F  add [bx+si],al
  db 0x00, 0x00                ; 00002351  add [bx+si],al
  db 0x00, 0x08                ; 00002353  add [bx+si],cl
  db 0x12, 0x00                ; 00002355  adc al,[bx+si]
  db 0x00, 0x00                ; 00002357  add [bx+si],al
  db 0x00, 0x0D                ; 00002359  add [di],cl
  db 0x01, 0x0A                ; 0000235B  add [bp+si],cx
  db 0x00, 0x01                ; 0000235D  add [bx+di],al
  db 0xF8                      ; 0000235F  clc
  db 0x3F                      ; 00002360  aas
  db 0x5E                      ; 00002361  pop si
  db 0x00, 0x00                ; 00002362  add [bx+si],al
  db 0x00, 0x00                ; 00002364  add [bx+si],al
  db 0x00, 0x00                ; 00002366  add [bx+si],al
  db 0x00, 0x00                ; 00002368  add [bx+si],al
  db 0x00, 0x02                ; 0000236A  add [bp+si],al
  db 0x00, 0x0F                ; 0000236C  add [bx],cl
  db 0x00, 0x00                ; 0000236E  add [bx+si],al
  db 0x00, 0x00                ; 00002370  add [bx+si],al
  db 0x00, 0x00                ; 00002372  add [bx+si],al
  db 0x00, 0x00                ; 00002374  add [bx+si],al
  db 0x00, 0x00                ; 00002376  add [bx+si],al
  db 0x00, 0x00                ; 00002378  add [bx+si],al
  db 0x00, 0x00                ; 0000237A  add [bx+si],al
  db 0x00, 0x00                ; 0000237C  add [bx+si],al
  db 0x00, 0x00                ; 0000237E  add [bx+si],al
  db 0x2E, 0x2D, 0xC2, 0x2D    ; 00002380  cs sub ax,0x2dc2
  db 0x56                      ; 00002384  push si
  db 0x2E, 0xEA, 0x2E, 0x00, 0x09, 0x01 ; 00002385  cs jmp 0x109:0x2e
  db 0xC0, 0xC0, 0x00          ; 0000238B  rol al,byte 0x0
  db 0x00, 0x00                ; 0000238E  add [bx+si],al
  db 0x00, 0x00                ; 00002390  add [bx+si],al
  db 0x00, 0x00                ; 00002392  add [bx+si],al
  db 0xFF, 0x01                ; 00002394  inc word [bx+di]
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
  db 0x00, 0xD0                ; 000023D2  add al,dl
  db 0x00, 0x00                ; 000023D4  add [bx+si],al
  db 0x00, 0x00                ; 000023D6  add [bx+si],al
  db 0x00, 0x00                ; 000023D8  add [bx+si],al
  db 0x00, 0x00                ; 000023DA  add [bx+si],al
  db 0xD0, 0x00                ; 000023DC  rol byte [bx+si],1
  db 0x00, 0xFF                ; 000023DE  add bh,bh
  db 0x09, 0x31                ; 000023E0  or [bx+di],si
  db 0x32, 0x33                ; 000023E2  xor dh,[bp+di]
  db 0x34, 0x35                ; 000023E4  xor al,0x35
  db 0x36, 0x37                ; 000023E6  ss aaa
  db 0x38, 0x39                ; 000023E8  cmp [bx+di],bh
  db 0x30, 0x2D                ; 000023EA  xor [di],ch
  db 0x60                      ; 000023EC  pusha
  db 0x08, 0x1B                ; 000023ED  or [bp+di],bl
  db 0x71, 0x77                ; 000023EF  jno 0x2468
  db 0x65, 0x72, 0x74          ; 000023F1  gs jc 0x2468
  db 0x79, 0x75                ; 000023F4  jns 0x246b
  db 0x69, 0x6F, 0x70, 0x7B, 0x7D ; 000023F6  imul bp,[bx+0x70],word 0x7d7b
  db 0x0D, 0xFF, 0x61          ; 000023FB  or ax,0x61ff
  db 0x73, 0x64                ; 000023FE  jnc 0x2464
  db 0x66, 0x67, 0x68, 0x6A, 0x6B, 0x6C, 0x3B ; 00002400  push dword 0x3b6c6b6a
  db 0xFF                      ; 00002407  db 0xff
  db 0x3A, 0xFF                ; 00002408  cmp bh,bh
  db 0x7C, 0x7A                ; 0000240A  jl 0x2486
  db 0x78, 0x63                ; 0000240C  js 0x2471
  db 0x76, 0x62                ; 0000240E  jna 0x2472
  db 0x6E                      ; 00002410  outsb
  db 0x6D                      ; 00002411  insw
  db 0x2C, 0x2E                ; 00002412  sub al,0x2e
  db 0x2F                      ; 00002414  das
  db 0xFF                      ; 00002415  db 0xff
  db 0xFF                      ; 00002416  db 0xff
  db 0x7E, 0x20                ; 00002417  jng 0x2439
  db 0xC1, 0x80, 0x81, 0x82, 0x83 ; 00002419  rol word [bx+si-0x7d7f],byte 0x83
  db 0x84, 0x85, 0x86, 0x87    ; 0000241E  test [di-0x787a],al
  db 0x88, 0x89, 0x8A, 0x8B    ; 00002422  mov [bx+di-0x7476],cl
  db 0x97                      ; 00002426  xchg ax,di
  db 0x8E, 0x8F, 0x93, 0x94    ; 00002427  mov cs,[bx-0x6b6d]
  db 0xFF, 0x90, 0x92, 0x8D    ; 0000242B  call [bx+si-0x726e]
  db 0x95                      ; 0000242F  xchg ax,bp
  db 0x8C, 0x98, 0x37, 0x38    ; 00002430  mov [bx+si+0x3837],ds
  db 0x39, 0x2D                ; 00002434  cmp [di],bp
  db 0x2B, 0x34                ; 00002436  sub si,[si]
  db 0x35, 0x36, 0x2C          ; 00002438  xor ax,0x2c36
  db 0x96                      ; 0000243B  xchg ax,si
  db 0x31, 0x32                ; 0000243C  xor [bp+si],si
  db 0x33, 0x91, 0x30, 0x2E    ; 0000243E  xor dx,[bx+di+0x2e30]
  db 0xFF, 0x0C                ; 00002442  dec word [si]
  db 0x21, 0x22                ; 00002444  and [bp+si],sp
  db 0x23, 0x24                ; 00002446  and sp,[si]
  db 0x25, 0x26, 0x27          ; 00002448  and ax,0x2726
  db 0x28, 0x29                ; 0000244B  sub [bx+di],ch
  db 0x5F                      ; 0000244D  pop di
  db 0x3D, 0x40, 0x08          ; 0000244E  cmp ax,0x840
  db 0x1B, 0x51, 0x57          ; 00002451  sbb dx,[bx+di+0x57]
  db 0x45                      ; 00002454  inc bp
  db 0x52                      ; 00002455  push dx
  db 0x54                      ; 00002456  push sp
  db 0x59                      ; 00002457  pop cx
  db 0x55                      ; 00002458  push bp
  db 0x49                      ; 00002459  dec cx
  db 0x4F                      ; 0000245A  dec di
  db 0x50                      ; 0000245B  push ax
  db 0x5B                      ; 0000245C  pop bx
  db 0x5D                      ; 0000245D  pop bp
  db 0x0D, 0xFF, 0x41          ; 0000245E  or ax,0x41ff
  db 0x53                      ; 00002461  push bx
  db 0x44                      ; 00002462  inc sp
  db 0x46                      ; 00002463  inc si
  db 0x47                      ; 00002464  inc di
  db 0x48                      ; 00002465  dec ax
  db 0x4A                      ; 00002466  dec dx
  db 0x4B                      ; 00002467  dec bx
  db 0x4C                      ; 00002468  dec sp
  db 0x2B, 0xFF                ; 00002469  sub di,di
  db 0x2A, 0xFF                ; 0000246B  sub bh,bh
  db 0x5C                      ; 0000246D  pop sp
  db 0x5A                      ; 0000246E  pop dx
  db 0x58                      ; 0000246F  pop ax
  db 0x43                      ; 00002470  inc bx
  db 0x56                      ; 00002471  push si
  db 0x42                      ; 00002472  inc dx
  db 0x4E                      ; 00002473  dec si
  db 0x4D                      ; 00002474  dec bp
  db 0x3C, 0x3E                ; 00002475  cmp al,0x3e
  db 0x3F                      ; 00002477  aas
  db 0xFF                      ; 00002478  db 0xff
  db 0xFF, 0x5E, 0x20          ; 00002479  call far [bp+0x20]
  db 0xC1, 0xAD, 0xAE, 0xAF, 0xB0 ; 0000247C  shr word [di-0x5052],byte 0xb0
  db 0xB1, 0xB2                ; 00002481  mov cl,0xb2
  db 0xB3, 0xB4                ; 00002483  mov bl,0xb4
  db 0xB5, 0xB6                ; 00002485  mov ch,0xb6
  db 0x9F                      ; 00002487  lahf
  db 0xA0, 0x97, 0x99          ; 00002488  mov al,[0x9997]
  db 0x9A, 0x9B, 0x9C, 0xFF, 0x90 ; 0000248B  call 0x90ff:0x9c9b
  db 0x92                      ; 00002490  xchg ax,dx
  db 0x8D, 0x95, 0x8C, 0x98    ; 00002491  lea dx,[di-0x6774]
  db 0x37                      ; 00002495  aaa
  db 0x38, 0x39                ; 00002496  cmp [bx+di],bh
  db 0x2D, 0x2B, 0x34          ; 00002498  sub ax,0x342b
  db 0x35, 0x36, 0x2C          ; 0000249B  xor ax,0x2c36
  db 0x96                      ; 0000249E  xchg ax,si
  db 0x31, 0x32                ; 0000249F  xor [bp+si],si
  db 0x33, 0x91, 0x30, 0x2E    ; 000024A1  xor dx,[bx+di+0x2e30]
  db 0xFF, 0x09                ; 000024A5  dec word [bx+di]
  db 0xFF                      ; 000024A7  db 0xff
  db 0xFF                      ; 000024A8  db 0xff
  db 0xFF                      ; 000024A9  db 0xff
  db 0xFF                      ; 000024AA  db 0xff
  db 0xFF                      ; 000024AB  db 0xff
  db 0xFF                      ; 000024AC  db 0xff
  db 0xFF                      ; 000024AD  db 0xff
  db 0xFF                      ; 000024AE  db 0xff
  db 0xFF, 0x1F                ; 000024AF  call far [bx]
  db 0xFF, 0x00                ; 000024B1  inc word [bx+si]
  db 0x7F, 0x1B                ; 000024B3  jg 0x24d0
  db 0x11, 0x17                ; 000024B5  adc [bx],dx
  db 0x05, 0x12, 0x14          ; 000024B7  add ax,0x1412
  db 0x19, 0x15                ; 000024BA  sbb [di],dx
  db 0x09, 0x0F                ; 000024BC  or [bx],cx
  db 0x10, 0x1B                ; 000024BE  adc [bp+di],bl
  db 0x1D, 0x0D, 0xFF          ; 000024C0  sbb ax,0xff0d
  db 0x01, 0x13                ; 000024C3  add [bp+di],dx
  db 0x04, 0x06                ; 000024C5  add al,0x6
  db 0x07                      ; 000024C7  pop es
  db 0x08, 0x0A                ; 000024C8  or [bp+si],cl
  db 0x0B, 0x0C                ; 000024CA  or cx,[si]
  db 0xFF                      ; 000024CC  db 0xff
  db 0xFF                      ; 000024CD  db 0xff
  db 0xFF                      ; 000024CE  db 0xff
  db 0xFF, 0x1C                ; 000024CF  call far [si]
  db 0x1A, 0x18                ; 000024D1  sbb bl,[bx+si]
  db 0x03, 0x16, 0x02, 0x0E    ; 000024D3  add dx,[0xe02]
  db 0x0D, 0xFF, 0xFF          ; 000024D7  or ax,0xffff
  db 0xFF                      ; 000024DA  db 0xff
  db 0xFF                      ; 000024DB  db 0xff
  db 0xFF, 0x1E, 0x20, 0xFE    ; 000024DC  call far [0xfe20]
  db 0xB7, 0xB8                ; 000024E0  mov bh,0xb8
  db 0xB9, 0xBA, 0xBB          ; 000024E2  mov cx,0xbbba
  db 0xBC, 0xBD, 0xBE          ; 000024E5  mov sp,0xbebd
  db 0xBF, 0xC0, 0xA1          ; 000024E8  mov di,0xa1c0
  db 0xA2, 0x97, 0xFD          ; 000024EB  mov [0xfd97],al
  db 0xFF                      ; 000024EE  db 0xff
  db 0xFB                      ; 000024EF  sti
  db 0xFA                      ; 000024F0  cli
  db 0xFF, 0x90, 0x92, 0x8D    ; 000024F1  call [bx+si-0x726e]
  db 0x95                      ; 000024F5  xchg ax,bp
  db 0x8C, 0x98, 0xFF, 0xFF    ; 000024F6  mov [bx+si-0x1],ds
  db 0xFF                      ; 000024FA  db 0xff
  db 0xFF                      ; 000024FB  db 0xff
  db 0xFF                      ; 000024FC  db 0xff
  db 0xFF                      ; 000024FD  db 0xff
  db 0xFF                      ; 000024FE  db 0xff
  db 0xFF                      ; 000024FF  db 0xff
  db 0xFF, 0x96, 0xF1, 0xF2    ; 00002500  call [bp-0xd0f]
  db 0xF3, 0x91                ; 00002504  rep xchg ax,cx
  db 0xF0                      ; 00002506  lock
  db 0xFF                      ; 00002507  db 0xff
  db 0xB8, 0x00, 0x00          ; 00002508  mov ax,0x0
  db 0x8A, 0xC1                ; 0000250B  mov al,cl
  db 0xBB, 0xBF, 0x3C          ; 0000250D  mov bx,0x3cbf
  db 0xD7                      ; 00002510  xlatb
  db 0x3C, 0x00                ; 00002511  cmp al,0x0
  db 0x74, 0x4E                ; 00002513  jz 0x2563
  db 0xF6, 0xC2, 0x01          ; 00002515  test dl,0x1
  db 0x74, 0x0E                ; 00002518  jz 0x2528
  db 0xBA, 0xFE, 0xFF          ; 0000251A  mov dx,0xfffe
  db 0xF9                      ; 0000251D  stc
  db 0xD3, 0xD2                ; 0000251E  rcl dx,cl
  db 0x2E, 0x21, 0x16, 0x09, 0x3B ; 00002520  and [cs:0x3b09],dx
  db 0xE9, 0x0A, 0x00          ; 00002525  jmp 0x2532
  db 0xBA, 0x01, 0x00          ; 00002528  mov dx,0x1
  db 0xD3, 0xE2                ; 0000252B  shl dx,cl
  db 0x2E, 0x09, 0x16, 0x09, 0x3B ; 0000252D  or [cs:0x3b09],dx
  db 0x24, 0xF7                ; 00002532  and al,0xf7
  db 0x8A, 0xE0                ; 00002534  mov ah,al
  db 0x24, 0xF0                ; 00002536  and al,0xf0
  db 0x8A, 0xC4                ; 00002538  mov al,ah
  db 0xBB, 0x0F, 0x3E          ; 0000253A  mov bx,0x3e0f
  db 0x8A, 0xE9                ; 0000253D  mov ch,cl
  db 0x74, 0x07                ; 0000253F  jz 0x2548
  db 0xB1, 0x04                ; 00002541  mov cl,0x4
  db 0xD2, 0xE8                ; 00002543  shr al,cl
  db 0xBB, 0x31, 0x3E          ; 00002545  mov bx,0x3e31
  db 0xFE, 0xC8                ; 00002548  dec al
  db 0xB1, 0x11                ; 0000254A  mov cl,0x11
  db 0xF6, 0xE1                ; 0000254C  mul cl
  db 0x03, 0xC3                ; 0000254E  add ax,bx
  db 0x50                      ; 00002550  push ax
  db 0x8A, 0xCD                ; 00002551  mov cl,ch
  db 0xBB, 0xCF, 0x3C          ; 00002553  mov bx,0x3ccf
  db 0xB0, 0x14                ; 00002556  mov al,0x14
  db 0xF6, 0xE1                ; 00002558  mul cl
  db 0x03, 0xD8                ; 0000255A  add bx,ax
  db 0x58                      ; 0000255C  pop ax
  db 0x89, 0x47, 0x08          ; 0000255D  mov [bx+0x8],ax
  db 0x8B, 0xC3                ; 00002560  mov ax,bx
  db 0xC3                      ; 00002562  ret
  db 0x8B, 0xD8                ; 00002563  mov bx,ax
  db 0xC3                      ; 00002565  ret
  db 0x8B, 0xEC                ; 00002566  mov bp,sp
  db 0xB0, 0x01                ; 00002568  mov al,0x1
  db 0x80, 0x7E, 0x0F, 0x00    ; 0000256A  cmp byte [bp+0xf],0x0
  db 0x75, 0x01                ; 0000256E  jnz 0x2571
  db 0xC3                      ; 00002570  ret
  db 0x8A, 0x46, 0x0E          ; 00002571  mov al,[bp+0xe]
  db 0xBB, 0x12, 0x3B          ; 00002574  mov bx,0x3b12
  db 0xE8, 0x4A, 0x03          ; 00002577  call 0x28c4
  db 0x8A, 0x46, 0x0E          ; 0000257A  mov al,[bp+0xe]
  db 0x8A, 0xC8                ; 0000257D  mov cl,al
  db 0xBB, 0xBF, 0x3C          ; 0000257F  mov bx,0x3cbf
  db 0xD7                      ; 00002582  xlatb
  db 0x3C, 0x00                ; 00002583  cmp al,0x0
  db 0x75, 0x05                ; 00002585  jnz 0x258c
  db 0xB0, 0x01                ; 00002587  mov al,0x1
  db 0x8A, 0xD8                ; 00002589  mov bl,al
  db 0xC3                      ; 0000258B  ret
  db 0x3C, 0xC0                ; 0000258C  cmp al,0xc0
  db 0x74, 0x07                ; 0000258E  jz 0x2597
  db 0x3C, 0xD0                ; 00002590  cmp al,0xd0
  db 0x74, 0x06                ; 00002592  jz 0x259a
  db 0xE9, 0x06, 0x00          ; 00002594  jmp 0x259d
  db 0xE9, 0xAC, 0x07          ; 00002597  jmp 0x2d46
  db 0xE9, 0xF4, 0x07          ; 0000259A  jmp 0x2d91
  db 0x2E, 0xC6, 0x06, 0xF5, 0x3A, 0x08 ; 0000259D  mov byte [cs:0x3af5],0x8
  db 0x2E, 0x20, 0x06, 0xF5, 0x3A ; 000025A3  and [cs:0x3af5],al
  db 0x24, 0xF7                ; 000025A8  and al,0xf7
  db 0x50                      ; 000025AA  push ax
  db 0xBB, 0xCF, 0x3C          ; 000025AB  mov bx,0x3ccf
  db 0xB0, 0x14                ; 000025AE  mov al,0x14
  db 0xF6, 0xE1                ; 000025B0  mul cl
  db 0x03, 0xC3                ; 000025B2  add ax,bx
  db 0x2E, 0xA3, 0x00, 0x3B    ; 000025B4  mov [cs:0x3b00],ax
  db 0x8B, 0xF0                ; 000025B8  mov si,ax
  db 0x8B, 0x5C, 0x08          ; 000025BA  mov bx,[si+0x8]
  db 0x8B, 0x07                ; 000025BD  mov ax,[bx]
  db 0x2E, 0xA3, 0x02, 0x3B    ; 000025BF  mov [cs:0x3b02],ax
  db 0x8A, 0x47, 0x0F          ; 000025C3  mov al,[bx+0xf]
  db 0x2E, 0xA2, 0x04, 0x3B    ; 000025C6  mov [cs:0x3b04],al
  db 0x8B, 0x46, 0x08          ; 000025CA  mov ax,[bp+0x8]
  db 0x8B, 0x5E, 0x06          ; 000025CD  mov bx,[bp+0x6]
  db 0xE8, 0x3C, 0x08          ; 000025D0  call 0x2e0f
  db 0x2E, 0xC7, 0x06, 0xC8, 0x3A, 0x66, 0xAE ; 000025D3  mov word [cs:0x3ac8],0xae66
  db 0x58                      ; 000025DA  pop ax
  db 0x24, 0xF0                ; 000025DB  and al,0xf0
  db 0xBB, 0x00, 0x00          ; 000025DD  mov bx,0x0
  db 0x2E, 0xC6, 0x06, 0x0B, 0x3B, 0x00 ; 000025E0  mov byte [cs:0x3b0b],0x0
  db 0x74, 0x09                ; 000025E6  jz 0x25f1
  db 0xBB, 0x02, 0x00          ; 000025E8  mov bx,0x2
  db 0x2E, 0xC6, 0x06, 0x0B, 0x3B, 0x0A ; 000025EB  mov byte [cs:0x3b0b],0xa
  db 0x2E, 0xFF, 0x97, 0xE6, 0x32 ; 000025F1  call [cs:bx+0x32e6]
  db 0x2E, 0x80, 0x3E, 0xE3, 0x3A, 0x00 ; 000025F6  cmp byte [cs:0x3ae3],0x0
  db 0x74, 0x21                ; 000025FC  jz 0x261f
  db 0x2E, 0x80, 0x3E, 0x0B, 0x3B, 0x0A ; 000025FE  cmp byte [cs:0x3b0b],0xa
  db 0x73, 0x10                ; 00002604  jnc 0x2616
  db 0x8A, 0x46, 0x0E          ; 00002606  mov al,[bp+0xe]
  db 0xBB, 0x92, 0x3B          ; 00002609  mov bx,0x3b92
  db 0xE8, 0xB5, 0x02          ; 0000260C  call 0x28c4
  db 0x2E, 0xFE, 0x06, 0x0B, 0x3B ; 0000260F  inc byte [cs:0x3b0b]
  db 0xEB, 0xE8                ; 00002614  jmp short 0x25fe
  db 0x8A, 0x46, 0x0E          ; 00002616  mov al,[bp+0xe]
  db 0xBB, 0x52, 0x3B          ; 00002619  mov bx,0x3b52
  db 0xE8, 0xA5, 0x02          ; 0000261C  call 0x28c4
  db 0x2E, 0xA0, 0xE3, 0x3A    ; 0000261F  mov al,[cs:0x3ae3]
  db 0x8A, 0xD8                ; 00002623  mov bl,al
  db 0xC3                      ; 00002625  ret
  db 0x8B, 0xEC                ; 00002626  mov bp,sp
  db 0xB0, 0x01                ; 00002628  mov al,0x1
  db 0x80, 0x7E, 0x0F, 0x00    ; 0000262A  cmp byte [bp+0xf],0x0
  db 0x75, 0x01                ; 0000262E  jnz 0x2631
  db 0xC3                      ; 00002630  ret
  db 0x8A, 0x46, 0x0E          ; 00002631  mov al,[bp+0xe]
  db 0xBB, 0x32, 0x3B          ; 00002634  mov bx,0x3b32
  db 0xE8, 0x8A, 0x02          ; 00002637  call 0x28c4
  db 0x8A, 0x46, 0x0E          ; 0000263A  mov al,[bp+0xe]
  db 0x8A, 0xC8                ; 0000263D  mov cl,al
  db 0xBB, 0xBF, 0x3C          ; 0000263F  mov bx,0x3cbf
  db 0xD7                      ; 00002642  xlatb
  db 0x3C, 0x00                ; 00002643  cmp al,0x0
  db 0x75, 0x05                ; 00002645  jnz 0x264c
  db 0xB0, 0x01                ; 00002647  mov al,0x1
  db 0x8A, 0xD8                ; 00002649  mov bl,al
  db 0xC3                      ; 0000264B  ret
  db 0x3C, 0xC0                ; 0000264C  cmp al,0xc0
  db 0x74, 0x07                ; 0000264E  jz 0x2657
  db 0x3C, 0xD0                ; 00002650  cmp al,0xd0
  db 0x74, 0x06                ; 00002652  jz 0x265a
  db 0xE9, 0x06, 0x00          ; 00002654  jmp 0x265d
  db 0xE9, 0xFF, 0x06          ; 00002657  jmp 0x2d59
  db 0xE9, 0x4B, 0x07          ; 0000265A  jmp 0x2da8
  db 0x2E, 0xC6, 0x06, 0xF5, 0x3A, 0x08 ; 0000265D  mov byte [cs:0x3af5],0x8
  db 0x2E, 0x20, 0x06, 0xF5, 0x3A ; 00002663  and [cs:0x3af5],al
  db 0x24, 0xF7                ; 00002668  and al,0xf7
  db 0x50                      ; 0000266A  push ax
  db 0xBB, 0xCF, 0x3C          ; 0000266B  mov bx,0x3ccf
  db 0xB0, 0x14                ; 0000266E  mov al,0x14
  db 0xF6, 0xE1                ; 00002670  mul cl
  db 0x03, 0xC3                ; 00002672  add ax,bx
  db 0x2E, 0xA3, 0x00, 0x3B    ; 00002674  mov [cs:0x3b00],ax
  db 0x8B, 0xF0                ; 00002678  mov si,ax
  db 0x8B, 0x5C, 0x08          ; 0000267A  mov bx,[si+0x8]
  db 0x8B, 0x07                ; 0000267D  mov ax,[bx]
  db 0x2E, 0xA3, 0x02, 0x3B    ; 0000267F  mov [cs:0x3b02],ax
  db 0x8A, 0x47, 0x0F          ; 00002683  mov al,[bx+0xf]
  db 0x2E, 0xA2, 0x04, 0x3B    ; 00002686  mov [cs:0x3b04],al
  db 0x8B, 0x46, 0x08          ; 0000268A  mov ax,[bp+0x8]
  db 0x8B, 0x5E, 0x06          ; 0000268D  mov bx,[bp+0x6]
  db 0xE8, 0x7C, 0x07          ; 00002690  call 0x2e0f
  db 0x2E, 0xC7, 0x06, 0xC8, 0x3A, 0xA6, 0x76 ; 00002693  mov word [cs:0x3ac8],0x76a6
  db 0x58                      ; 0000269A  pop ax
  db 0x24, 0xF0                ; 0000269B  and al,0xf0
  db 0xBB, 0x00, 0x00          ; 0000269D  mov bx,0x0
  db 0x2E, 0xC6, 0x06, 0x0B, 0x3B, 0x00 ; 000026A0  mov byte [cs:0x3b0b],0x0
  db 0x74, 0x09                ; 000026A6  jz 0x26b1
  db 0xBB, 0x02, 0x00          ; 000026A8  mov bx,0x2
  db 0x2E, 0xC6, 0x06, 0x0B, 0x3B, 0x0A ; 000026AB  mov byte [cs:0x3b0b],0xa
  db 0x2E, 0xFF, 0x97, 0xE6, 0x32 ; 000026B1  call [cs:bx+0x32e6]
  db 0x2E, 0x80, 0x3E, 0xE4, 0x3A, 0x00 ; 000026B6  cmp byte [cs:0x3ae4],0x0
  db 0x74, 0x21                ; 000026BC  jz 0x26df
  db 0x2E, 0x80, 0x3E, 0x0B, 0x3B, 0x0A ; 000026BE  cmp byte [cs:0x3b0b],0xa
  db 0x73, 0x10                ; 000026C4  jnc 0x26d6
  db 0x8A, 0x46, 0x0E          ; 000026C6  mov al,[bp+0xe]
  db 0xBB, 0xB2, 0x3B          ; 000026C9  mov bx,0x3bb2
  db 0xE8, 0xF5, 0x01          ; 000026CC  call 0x28c4
  db 0x2E, 0xFE, 0x06, 0x0B, 0x3B ; 000026CF  inc byte [cs:0x3b0b]
  db 0xEB, 0xE8                ; 000026D4  jmp short 0x26be
  db 0x8A, 0x46, 0x0E          ; 000026D6  mov al,[bp+0xe]
  db 0xBB, 0x72, 0x3B          ; 000026D9  mov bx,0x3b72
  db 0xE8, 0xE5, 0x01          ; 000026DC  call 0x28c4
  db 0x2E, 0xA0, 0xE4, 0x3A    ; 000026DF  mov al,[cs:0x3ae4]
  db 0x8A, 0xD8                ; 000026E3  mov bl,al
  db 0xC3                      ; 000026E5  ret
  db 0xEB, 0x32                ; 000026E6  jmp short 0x271a
  db 0x32, 0xC0                ; 000026E8  xor al,al
  db 0xC3                      ; 000026EA  ret
  db 0xFF, 0x46, 0x0A          ; 000026EB  inc word [bp+0xa]
  db 0x2E, 0xC6, 0x06, 0x0E, 0x3B, 0x01 ; 000026EE  mov byte [cs:0x3b0e],0x1
  db 0x8A, 0x66, 0x0E          ; 000026F4  mov ah,[bp+0xe]
  db 0xE8, 0x0E, 0x02          ; 000026F7  call 0x2908
  db 0x2E, 0xC6, 0x06, 0xF4, 0x3A, 0x00 ; 000026FA  mov byte [cs:0x3af4],0x0
  db 0x2E, 0xA1, 0x02, 0x3B    ; 00002700  mov ax,[cs:0x3b02]
  db 0x2B, 0x46, 0x0A          ; 00002704  sub ax,[bp+0xa]
  db 0x40                      ; 00002707  inc ax
  db 0x8A, 0x56, 0x0F          ; 00002708  mov dl,[bp+0xf]
  db 0x32, 0xF6                ; 0000270B  xor dh,dh
  db 0x3B, 0xC2                ; 0000270D  cmp ax,dx
  db 0x73, 0x20                ; 0000270F  jnc 0x2731
  db 0x2E, 0xA3, 0x05, 0x3B    ; 00002711  mov [cs:0x3b05],ax
  db 0x2B, 0xD0                ; 00002715  sub dx,ax
  db 0x52                      ; 00002717  push dx
  db 0xE8, 0x2B, 0x00          ; 00002718  call 0x2746
  db 0x5A                      ; 0000271B  pop dx
  db 0x72, 0x1B                ; 0000271C  jc 0x2739
  db 0x88, 0x56, 0x0F          ; 0000271E  mov [bp+0xf],dl
  db 0xC7, 0x46, 0x0A, 0x01, 0x00 ; 00002721  mov word [bp+0xa],0x1
  db 0xFF, 0x46, 0x0C          ; 00002726  inc word [bp+0xc]
  db 0x2E, 0xFE, 0x06, 0xF4, 0x3A ; 00002729  inc byte [cs:0x3af4]
  db 0xE9, 0xCF, 0xFF          ; 0000272E  jmp 0x2700
  db 0x2E, 0x89, 0x16, 0x05, 0x3B ; 00002731  mov [cs:0x3b05],dx
  db 0xE8, 0x0D, 0x00          ; 00002736  call 0x2746
  db 0x8A, 0x66, 0x0E          ; 00002739  mov ah,[bp+0xe]
  db 0xE8, 0x69, 0x02          ; 0000273C  call 0x29a8
  db 0x2E, 0xC6, 0x06, 0x0E, 0x3B, 0x00 ; 0000273F  mov byte [cs:0x3b0e],0x0
  db 0xC3                      ; 00002745  ret
  db 0xE8, 0x39, 0x04          ; 00002746  call 0x2b82
  db 0x73, 0x04                ; 00002749  jnc 0x274f
  db 0xE8, 0x68, 0x01          ; 0000274B  call 0x28b6
  db 0xC3                      ; 0000274E  ret
  db 0xB8, 0x01, 0x00          ; 0000274F  mov ax,0x1
  db 0x8A, 0x4E, 0x0E          ; 00002752  mov cl,[bp+0xe]
  db 0xD3, 0xE0                ; 00002755  shl ax,cl
  db 0x2E, 0x23, 0x06, 0x09, 0x3B ; 00002757  and ax,[cs:0x3b09]
  db 0x75, 0x0D                ; 0000275C  jnz 0x276b
  db 0x8A, 0x5E, 0x0E          ; 0000275E  mov bl,[bp+0xe]
  db 0x32, 0xFF                ; 00002761  xor bh,bh
  db 0x2E, 0x80, 0xBF, 0xFE, 0x3A, 0xFF ; 00002763  cmp byte [cs:bx+0x3afe],0xff
  db 0x75, 0x10                ; 00002769  jnz 0x277b
  db 0xF7, 0xD0                ; 0000276B  not ax
  db 0x2E, 0x21, 0x06, 0x09, 0x3B ; 0000276D  and [cs:0x3b09],ax
  db 0xE8, 0xC0, 0x02          ; 00002772  call 0x2a35
  db 0x73, 0x04                ; 00002775  jnc 0x277b
  db 0xE8, 0x3C, 0x01          ; 00002777  call 0x28b6
  db 0xC3                      ; 0000277A  ret
  db 0x2E, 0x80, 0x3E, 0xF4, 0x3A, 0x00 ; 0000277B  cmp byte [cs:0x3af4],0x0
  db 0x75, 0x1A                ; 00002781  jnz 0x279d
  db 0x2E, 0xA1, 0x05, 0x3B    ; 00002783  mov ax,[cs:0x3b05]
  db 0x2E, 0xA3, 0x07, 0x3B    ; 00002787  mov [cs:0x3b07],ax
  db 0xBA, 0x86, 0x02          ; 0000278B  mov dx,0x286
  db 0xBE, 0xE8, 0x3A          ; 0000278E  mov si,0x3ae8
  db 0xE8, 0x3B, 0x06          ; 00002791  call 0x2dcf
  db 0xE8, 0xCB, 0x02          ; 00002794  call 0x2a62
  db 0x73, 0x46                ; 00002797  jnc 0x27df
  db 0xE8, 0x1A, 0x01          ; 00002799  call 0x28b6
  db 0xC3                      ; 0000279C  ret
  db 0x2E, 0xA1, 0x07, 0x3B    ; 0000279D  mov ax,[cs:0x3b07]
  db 0x2E, 0x8A, 0x0E, 0x04, 0x3B ; 000027A1  mov cl,[cs:0x3b04]
  db 0x80, 0xC1, 0x07          ; 000027A6  add cl,0x7
  db 0xD3, 0xE0                ; 000027A9  shl ax,cl
  db 0x2E, 0x01, 0x06, 0xE5, 0x3A ; 000027AB  add [cs:0x3ae5],ax
  db 0x2E, 0x80, 0x16, 0xE7, 0x3A, 0x00 ; 000027B0  adc byte [cs:0x3ae7],0x0
  db 0x2E, 0xA1, 0x05, 0x3B    ; 000027B6  mov ax,[cs:0x3b05]
  db 0x2E, 0xA3, 0x07, 0x3B    ; 000027BA  mov [cs:0x3b07],ax
  db 0xBA, 0x86, 0x02          ; 000027BE  mov dx,0x286
  db 0xBE, 0xE8, 0x3A          ; 000027C1  mov si,0x3ae8
  db 0xE8, 0x08, 0x06          ; 000027C4  call 0x2dcf
  db 0x2E, 0x80, 0x26, 0xF5, 0x3A, 0x08 ; 000027C7  and byte [cs:0x3af5],0x8
  db 0x75, 0x07                ; 000027CD  jnz 0x27d6
  db 0xF7, 0x46, 0x0C, 0x01, 0x00 ; 000027CF  test word [bp+0xc],0x1
  db 0x75, 0x09                ; 000027D4  jnz 0x27df
  db 0xE8, 0xDE, 0x02          ; 000027D6  call 0x2ab7
  db 0x73, 0x04                ; 000027D9  jnc 0x27df
  db 0xE8, 0xD8, 0x00          ; 000027DB  call 0x28b6
  db 0xC3                      ; 000027DE  ret
  db 0x2E, 0xC6, 0x06, 0xF6, 0x3A, 0x01 ; 000027DF  mov byte [cs:0x3af6],0x1
  db 0x2E, 0xC6, 0x06, 0xF8, 0x3A, 0x00 ; 000027E5  mov byte [cs:0x3af8],0x0
  db 0xBB, 0xFF, 0xFE          ; 000027EB  mov bx,0xfeff
  db 0xBE, 0xE8, 0x3A          ; 000027EE  mov si,0x3ae8
  db 0x21, 0x5C, 0x0A          ; 000027F1  and [si+0xa],bx
  db 0x80, 0x7E, 0x0F, 0x01    ; 000027F4  cmp byte [bp+0xf],0x1
  db 0x74, 0x27                ; 000027F8  jz 0x2821
  db 0x2E, 0xC6, 0x06, 0xF8, 0x3A, 0x10 ; 000027FA  mov byte [cs:0x3af8],0x10
  db 0x2E, 0xFE, 0x06, 0xF6, 0x3A ; 00002800  inc byte [cs:0x3af6]
  db 0xF7, 0xD3                ; 00002805  not bx
  db 0xBE, 0xE8, 0x3A          ; 00002807  mov si,0x3ae8
  db 0x09, 0x5C, 0x0A          ; 0000280A  or [si+0xa],bx
  db 0x2E, 0xA1, 0x02, 0x3B    ; 0000280D  mov ax,[cs:0x3b02]
  db 0x2B, 0x46, 0x0A          ; 00002811  sub ax,[bp+0xa]
  db 0x40                      ; 00002814  inc ax
  db 0x2E, 0x3B, 0x06, 0x05, 0x3B ; 00002815  cmp ax,[cs:0x3b05]
  db 0x74, 0x05                ; 0000281A  jz 0x2821
  db 0x2E, 0xFE, 0x06, 0xF6, 0x3A ; 0000281C  inc byte [cs:0x3af6]
  db 0x2E, 0xC6, 0x06, 0xF7, 0x3A, 0x00 ; 00002821  mov byte [cs:0x3af7],0x0
  db 0xF7, 0x46, 0x0C, 0x01, 0x00 ; 00002827  test word [bp+0xc],0x1
  db 0x74, 0x0E                ; 0000282C  jz 0x283c
  db 0x2E, 0x80, 0x26, 0xF5, 0x3A, 0x08 ; 0000282E  and byte [cs:0x3af5],0x8
  db 0x75, 0x06                ; 00002834  jnz 0x283c
  db 0x2E, 0xC6, 0x06, 0xF7, 0x3A, 0x02 ; 00002836  mov byte [cs:0x3af7],0x2
  db 0xB9, 0x0A, 0x00          ; 0000283C  mov cx,0xa
  db 0x51                      ; 0000283F  push cx
  db 0x83, 0xF9, 0x05          ; 00002840  cmp cx,byte +0x5
  db 0x75, 0x0D                ; 00002843  jnz 0x2852
  db 0xE8, 0xCA, 0x01          ; 00002845  call 0x2a12
  db 0xE8, 0x17, 0x02          ; 00002848  call 0x2a62
  db 0x73, 0x05                ; 0000284B  jnc 0x2852
  db 0x59                      ; 0000284D  pop cx
  db 0xE8, 0x65, 0x00          ; 0000284E  call 0x28b6
  db 0xC3                      ; 00002851  ret
  db 0xFA                      ; 00002852  cli
  db 0xE8, 0x67, 0x01          ; 00002853  call 0x29bd
  db 0xFB                      ; 00002856  sti
  db 0x32, 0xC0                ; 00002857  xor al,al
  db 0xE8, 0xE8, 0x05          ; 00002859  call 0x2e44
  db 0x32, 0xC0                ; 0000285C  xor al,al
  db 0xE8, 0x21, 0x06          ; 0000285E  call 0x2e82
  db 0xB4, 0x04                ; 00002861  mov ah,0x4
  db 0x32, 0xC0                ; 00002863  xor al,al
  db 0xE8, 0x1F, 0x06          ; 00002865  call 0x2e87
  db 0xBE, 0xE8, 0x3A          ; 00002868  mov si,0x3ae8
  db 0x32, 0xC0                ; 0000286B  xor al,al
  db 0xE8, 0xB9, 0x05          ; 0000286D  call 0x2e29
  db 0x2E, 0x81, 0x3E, 0xC8, 0x3A, 0x66, 0xAE ; 00002870  cmp word [cs:0x3ac8],0xae66
  db 0x75, 0x13                ; 00002877  jnz 0x288c
  db 0xE8, 0x64, 0x02          ; 00002879  call 0x2ae0
  db 0xB0, 0x00                ; 0000287C  mov al,0x0
  db 0xE8, 0xE2, 0x05          ; 0000287E  call 0x2e63
  db 0xE8, 0x09, 0x03          ; 00002881  call 0x2b8d
  db 0xBB, 0x92, 0x3B          ; 00002884  mov bx,0x3b92
  db 0x72, 0x16                ; 00002887  jc 0x289f
  db 0xE9, 0x25, 0x00          ; 00002889  jmp 0x28b1
  db 0xE8, 0x6C, 0x02          ; 0000288C  call 0x2afb
  db 0xB0, 0x00                ; 0000288F  mov al,0x0
  db 0xE8, 0xCF, 0x05          ; 00002891  call 0x2e63
  db 0xE8, 0x1B, 0x03          ; 00002894  call 0x2bb2
  db 0xBB, 0xB2, 0x3B          ; 00002897  mov bx,0x3bb2
  db 0x72, 0x03                ; 0000289A  jc 0x289f
  db 0xE9, 0x12, 0x00          ; 0000289C  jmp 0x28b1
  db 0x8A, 0x46, 0x0E          ; 0000289F  mov al,[bp+0xe]
  db 0xE8, 0x1F, 0x00          ; 000028A2  call 0x28c4
  db 0x2E, 0xFE, 0x06, 0x0B, 0x3B ; 000028A5  inc byte [cs:0x3b0b]
  db 0x59                      ; 000028AA  pop cx
  db 0x49                      ; 000028AB  dec cx
  db 0x74, 0x06                ; 000028AC  jz 0x28b4
  db 0xE9, 0x8E, 0xFF          ; 000028AE  jmp 0x283f
  db 0x59                      ; 000028B1  pop cx
  db 0xF8                      ; 000028B2  clc
  db 0xC3                      ; 000028B3  ret
  db 0xF9                      ; 000028B4  stc
  db 0xC3                      ; 000028B5  ret
  db 0x2E, 0xC6, 0x06, 0xE3, 0x3A, 0x01 ; 000028B6  mov byte [cs:0x3ae3],0x1
  db 0x2E, 0xC6, 0x06, 0xE4, 0x3A, 0x01 ; 000028BC  mov byte [cs:0x3ae4],0x1
  db 0xF9                      ; 000028C2  stc
  db 0xC3                      ; 000028C3  ret
  db 0x8A, 0xC8                ; 000028C4  mov cl,al
  db 0xB8, 0x01, 0x00          ; 000028C6  mov ax,0x1
  db 0xD3, 0xE0                ; 000028C9  shl ax,cl
  db 0x2E, 0x85, 0x06, 0x0C, 0x3B ; 000028CB  test [cs:0x3b0c],ax
  db 0x74, 0x08                ; 000028D0  jz 0x28da
  db 0xD0, 0xE1                ; 000028D2  shl cl,1
  db 0x32, 0xED                ; 000028D4  xor ch,ch
  db 0x8B, 0xF1                ; 000028D6  mov si,cx
  db 0xFF, 0x00                ; 000028D8  inc word [bx+si]
  db 0xC3                      ; 000028DA  ret
  db 0x8A, 0x4E, 0x0E          ; 000028DB  mov cl,[bp+0xe]
  db 0x8A, 0xC1                ; 000028DE  mov al,cl
  db 0xB8, 0x01, 0x00          ; 000028E0  mov ax,0x1
  db 0xD3, 0xE0                ; 000028E3  shl ax,cl
  db 0x2E, 0x85, 0x06, 0x0C, 0x3B ; 000028E5  test [cs:0x3b0c],ax
  db 0x74, 0x1B                ; 000028EA  jz 0x2907
  db 0xD0, 0xE1                ; 000028EC  shl cl,1
  db 0x32, 0xED                ; 000028EE  xor ch,ch
  db 0x8B, 0xF1                ; 000028F0  mov si,cx
  db 0xB9, 0x08, 0x00          ; 000028F2  mov cx,0x8
  db 0xB0, 0x01                ; 000028F5  mov al,0x1
  db 0x2E, 0x84, 0x06, 0x0F, 0x3B ; 000028F7  test [cs:0x3b0f],al
  db 0x74, 0x02                ; 000028FC  jz 0x2900
  db 0xFF, 0x00                ; 000028FE  inc word [bx+si]
  db 0x83, 0xC6, 0x04          ; 00002900  add si,byte +0x4
  db 0xD0, 0xE0                ; 00002903  shl al,1
  db 0xE2, 0xF0                ; 00002905  loop 0x28f7
  db 0xC3                      ; 00002907  ret
  db 0xFA                      ; 00002908  cli
  db 0x50                      ; 00002909  push ax
  db 0xE8, 0x79, 0x38          ; 0000290A  call 0x6186
  db 0x58                      ; 0000290D  pop ax
  db 0xFB                      ; 0000290E  sti
  db 0x8A, 0xCC                ; 0000290F  mov cl,ah
  db 0xB5, 0x02                ; 00002911  mov ch,0x2
  db 0xD2, 0xE5                ; 00002913  shl ch,cl
  db 0x2E, 0x22, 0x2E, 0xF9, 0x3A ; 00002915  and ch,[cs:0x3af9]
  db 0xB0, 0x02                ; 0000291A  mov al,0x2
  db 0x80, 0xE4, 0x01          ; 0000291C  and ah,0x1
  db 0x74, 0x02                ; 0000291F  jz 0x2923
  db 0xD0, 0xE0                ; 00002921  shl al,1
  db 0xFA                      ; 00002923  cli
  db 0x2E, 0xC6, 0x06, 0xFA, 0x3A, 0x00 ; 00002924  mov byte [cs:0x3afa],0x0
  db 0xFB                      ; 0000292A  sti
  db 0x0A, 0xC4                ; 0000292B  or al,ah
  db 0x2E, 0x8A, 0x26, 0xF9, 0x3A ; 0000292D  mov ah,[cs:0x3af9]
  db 0x80, 0xE4, 0xFE          ; 00002932  and ah,0xfe
  db 0x0A, 0xC4                ; 00002935  or al,ah
  db 0x2E, 0xA2, 0xF9, 0x3A    ; 00002937  mov [cs:0x3af9],al
  db 0xBA, 0x88, 0x02          ; 0000293B  mov dx,0x288
  db 0xEE                      ; 0000293E  out dx,al
  db 0x80, 0xFD, 0x00          ; 0000293F  cmp ch,0x0
  db 0x75, 0x0A                ; 00002942  jnz 0x294e
  db 0xBA, 0x3C, 0x00          ; 00002944  mov dx,0x3c
  db 0xB1, 0x8D                ; 00002947  mov cl,0x8d
  db 0x60                      ; 00002949  pusha
  db 0xE8, 0xE6, 0xD7          ; 0000294A  call 0x133
  db 0x61                      ; 0000294D  popa
  db 0xC3                      ; 0000294E  ret
  db 0x2E, 0x80, 0x3E, 0xFA, 0x3A, 0x00 ; 0000294F  cmp byte [cs:0x3afa],0x0
  db 0x74, 0x39                ; 00002955  jz 0x2990
  db 0x2E, 0xFE, 0x0E, 0xFA, 0x3A ; 00002957  dec byte [cs:0x3afa]
  db 0x75, 0x32                ; 0000295C  jnz 0x2990
  db 0x53                      ; 0000295E  push bx
  db 0x50                      ; 0000295F  push ax
  db 0xBB, 0xE3, 0x45          ; 00002960  mov bx,0x45e3
  db 0x8A, 0x47, 0x14          ; 00002963  mov al,[bx+0x14]
  db 0x3C, 0x05                ; 00002966  cmp al,0x5
  db 0x58                      ; 00002968  pop ax
  db 0x5B                      ; 00002969  pop bx
  db 0x72, 0x0A                ; 0000296A  jc 0x2976
  db 0xB4, 0x00                ; 0000296C  mov ah,0x0
  db 0xE8, 0x20, 0x00          ; 0000296E  call 0x2991
  db 0xB4, 0x01                ; 00002971  mov ah,0x1
  db 0xE8, 0x1B, 0x00          ; 00002973  call 0x2991
  db 0x2E, 0xC6, 0x06, 0x0E, 0x0C, 0xFF ; 00002976  mov byte [cs:0xc0e],0xff
  db 0xBF, 0xCF, 0x3C          ; 0000297C  mov di,0x3ccf
  db 0xC6, 0x45, 0x05, 0xFF    ; 0000297F  mov byte [di+0x5],0xff
  db 0xBF, 0xE3, 0x3C          ; 00002983  mov di,0x3ce3
  db 0xC6, 0x45, 0x05, 0xFF    ; 00002986  mov byte [di+0x5],0xff
  db 0x2E, 0xC6, 0x06, 0x97, 0x6C, 0xFF ; 0000298A  mov byte [cs:0x6c97],0xff
  db 0xC3                      ; 00002990  ret
  db 0xB0, 0xFD                ; 00002991  mov al,0xfd
  db 0x80, 0xE4, 0x01          ; 00002993  and ah,0x1
  db 0x74, 0x02                ; 00002996  jz 0x299a
  db 0xB0, 0xFB                ; 00002998  mov al,0xfb
  db 0x2E, 0x22, 0x06, 0xF9, 0x3A ; 0000299A  and al,[cs:0x3af9]
  db 0x2E, 0xA2, 0xF9, 0x3A    ; 0000299F  mov [cs:0x3af9],al
  db 0xBA, 0x88, 0x02          ; 000029A3  mov dx,0x288
  db 0xEE                      ; 000029A6  out dx,al
  db 0xC3                      ; 000029A7  ret
  db 0xFA                      ; 000029A8  cli
  db 0xBB, 0xE3, 0x45          ; 000029A9  mov bx,0x45e3
  db 0x8A, 0x47, 0x14          ; 000029AC  mov al,[bx+0x14]
  db 0x2E, 0xA2, 0xFA, 0x3A    ; 000029AF  mov [cs:0x3afa],al
  db 0xFB                      ; 000029B3  sti
  db 0xC3                      ; 000029B4  ret
  db 0x2E, 0x80, 0x3E, 0x0E, 0x3B, 0x01 ; 000029B5  cmp byte [cs:0x3b0e],0x1
  db 0x74, 0x34                ; 000029BB  jz 0x29f1
  db 0x2E, 0xF6, 0x06, 0xBF, 0x3C, 0x0F ; 000029BD  test byte [cs:0x3cbf],0xf
  db 0x74, 0x0E                ; 000029C3  jz 0x29d3
  db 0xBF, 0xCF, 0x3C          ; 000029C5  mov di,0x3ccf
  db 0x2E, 0xA0, 0xF9, 0x3A    ; 000029C8  mov al,[cs:0x3af9]
  db 0x24, 0xFE                ; 000029CC  and al,0xfe
  db 0xB4, 0x02                ; 000029CE  mov ah,0x2
  db 0xE8, 0x1F, 0x00          ; 000029D0  call 0x29f2
  db 0x2E, 0xF6, 0x06, 0xC0, 0x3C, 0x0F ; 000029D3  test byte [cs:0x3cc0],0xf
  db 0x74, 0x0E                ; 000029D9  jz 0x29e9
  db 0xBF, 0xE3, 0x3C          ; 000029DB  mov di,0x3ce3
  db 0x2E, 0xA0, 0xF9, 0x3A    ; 000029DE  mov al,[cs:0x3af9]
  db 0x0C, 0x01                ; 000029E2  or al,0x1
  db 0xB4, 0x04                ; 000029E4  mov ah,0x4
  db 0xE8, 0x09, 0x00          ; 000029E6  call 0x29f2
  db 0x2E, 0xA0, 0xF9, 0x3A    ; 000029E9  mov al,[cs:0x3af9]
  db 0xBA, 0x88, 0x02          ; 000029ED  mov dx,0x288
  db 0xEE                      ; 000029F0  out dx,al
  db 0xC3                      ; 000029F1  ret
  db 0x84, 0xC4                ; 000029F2  test ah,al
  db 0x74, 0x1B                ; 000029F4  jz 0x2a11
  db 0xBA, 0x88, 0x02          ; 000029F6  mov dx,0x288
  db 0xEE                      ; 000029F9  out dx,al
  db 0xBA, 0x80, 0x02          ; 000029FA  mov dx,0x280
  db 0xEC                      ; 000029FD  in al,dx
  db 0xA8, 0x80                ; 000029FE  test al,0x80
  db 0x74, 0x0F                ; 00002A00  jz 0x2a11
  db 0x2E, 0xC6, 0x06, 0x0E, 0x0C, 0xFF ; 00002A02  mov byte [cs:0xc0e],0xff
  db 0xC6, 0x45, 0x05, 0xFF    ; 00002A08  mov byte [di+0x5],0xff
  db 0x2E, 0x30, 0x26, 0xF9, 0x3A ; 00002A0C  xor [cs:0x3af9],ah
  db 0xC3                      ; 00002A11  ret
  db 0xB4, 0xFD                ; 00002A12  mov ah,0xfd
  db 0x80, 0x7E, 0x0E, 0x00    ; 00002A14  cmp byte [bp+0xe],0x0
  db 0x74, 0x02                ; 00002A18  jz 0x2a1c
  db 0xB4, 0xFB                ; 00002A1A  mov ah,0xfb
  db 0x2E, 0xA0, 0xF9, 0x3A    ; 00002A1C  mov al,[cs:0x3af9]
  db 0xBA, 0x88, 0x02          ; 00002A20  mov dx,0x288
  db 0x22, 0xC4                ; 00002A23  and al,ah
  db 0xEE                      ; 00002A25  out dx,al
  db 0xF6, 0xD4                ; 00002A26  not ah
  db 0x0A, 0xC4                ; 00002A28  or al,ah
  db 0xEE                      ; 00002A2A  out dx,al
  db 0xBA, 0x3C, 0x00          ; 00002A2B  mov dx,0x3c
  db 0xB1, 0x8D                ; 00002A2E  mov cl,0x8d
  db 0x60                      ; 00002A30  pusha
  db 0xE8, 0xFF, 0xD6          ; 00002A31  call 0x133
  db 0x61                      ; 00002A34  popa
  db 0xBA, 0x80, 0x02          ; 00002A35  mov dx,0x280
  db 0xB0, 0x0C                ; 00002A38  mov al,0xc
  db 0xEE                      ; 00002A3A  out dx,al
  db 0xE8, 0xFC, 0x00          ; 00002A3B  call 0x2b3a
  db 0x32, 0xFF                ; 00002A3E  xor bh,bh
  db 0x2E, 0xF6, 0x06, 0x0F, 0x3B, 0x04 ; 00002A40  test byte [cs:0x3b0f],0x4
  db 0x8A, 0x5E, 0x0E          ; 00002A46  mov bl,[bp+0xe]
  db 0x2E, 0xC6, 0x87, 0xFE, 0x3A, 0x00 ; 00002A49  mov byte [cs:bx+0x3afe],0x0
  db 0x75, 0x06                ; 00002A4F  jnz 0x2a57
  db 0x2E, 0xC6, 0x87, 0xFE, 0x3A, 0xFF ; 00002A51  mov byte [cs:bx+0x3afe],0xff
  db 0xF8                      ; 00002A57  clc
  db 0x2E, 0xF6, 0x06, 0x0F, 0x3B, 0x10 ; 00002A58  test byte [cs:0x3b0f],0x10
  db 0x74, 0x01                ; 00002A5E  jz 0x2a61
  db 0xF9                      ; 00002A60  stc
  db 0xC3                      ; 00002A61  ret
  db 0xB9, 0x03, 0x00          ; 00002A62  mov cx,0x3
  db 0x51                      ; 00002A65  push cx
  db 0x8A, 0x5E, 0x0E          ; 00002A66  mov bl,[bp+0xe]
  db 0x32, 0xFF                ; 00002A69  xor bh,bh
  db 0x2E, 0x8A, 0x87, 0xFE, 0x3A ; 00002A6B  mov al,[cs:bx+0x3afe]
  db 0x3C, 0xFF                ; 00002A70  cmp al,0xff
  db 0x74, 0x04                ; 00002A72  jz 0x2a78
  db 0xBA, 0x82, 0x02          ; 00002A74  mov dx,0x282
  db 0xEE                      ; 00002A77  out dx,al
  db 0x8B, 0x46, 0x0C          ; 00002A78  mov ax,[bp+0xc]
  db 0x2E, 0x80, 0x26, 0xF5, 0x3A, 0x08 ; 00002A7B  and byte [cs:0x3af5],0x8
  db 0x75, 0x02                ; 00002A81  jnz 0x2a85
  db 0xD1, 0xE8                ; 00002A83  shr ax,1
  db 0xBA, 0x86, 0x02          ; 00002A85  mov dx,0x286
  db 0xEE                      ; 00002A88  out dx,al
  db 0x50                      ; 00002A89  push ax
  db 0xB0, 0x1C                ; 00002A8A  mov al,0x1c
  db 0xBA, 0x80, 0x02          ; 00002A8C  mov dx,0x280
  db 0xEE                      ; 00002A8F  out dx,al
  db 0xE8, 0xA7, 0x00          ; 00002A90  call 0x2b3a
  db 0x32, 0xFF                ; 00002A93  xor bh,bh
  db 0x58                      ; 00002A95  pop ax
  db 0x8A, 0x5E, 0x0E          ; 00002A96  mov bl,[bp+0xe]
  db 0x2E, 0x88, 0x87, 0xFE, 0x3A ; 00002A99  mov [cs:bx+0x3afe],al
  db 0x2E, 0xF6, 0x06, 0x0F, 0x3B, 0x99 ; 00002A9E  test byte [cs:0x3b0f],0x99
  db 0xF8                      ; 00002AA4  clc
  db 0x59                      ; 00002AA5  pop cx
  db 0x74, 0x0E                ; 00002AA6  jz 0x2ab6
  db 0x2E, 0xC6, 0x87, 0xFE, 0x3A, 0xFF ; 00002AA8  mov byte [cs:bx+0x3afe],0xff
  db 0x51                      ; 00002AAE  push cx
  db 0xE8, 0x60, 0xFF          ; 00002AAF  call 0x2a12
  db 0x59                      ; 00002AB2  pop cx
  db 0xE2, 0xB0                ; 00002AB3  loop 0x2a65
  db 0xF9                      ; 00002AB5  stc
  db 0xC3                      ; 00002AB6  ret
  db 0xB0, 0x5C                ; 00002AB7  mov al,0x5c
  db 0xBA, 0x80, 0x02          ; 00002AB9  mov dx,0x280
  db 0xEE                      ; 00002ABC  out dx,al
  db 0xE8, 0x7A, 0x00          ; 00002ABD  call 0x2b3a
  db 0x32, 0xFF                ; 00002AC0  xor bh,bh
  db 0x8A, 0x5E, 0x0E          ; 00002AC2  mov bl,[bp+0xe]
  db 0x2E, 0xFE, 0x87, 0xFE, 0x3A ; 00002AC5  inc byte [cs:bx+0x3afe]
  db 0x2E, 0xF6, 0x06, 0x0F, 0x3B, 0x99 ; 00002ACA  test byte [cs:0x3b0f],0x99
  db 0xF8                      ; 00002AD0  clc
  db 0x74, 0x0C                ; 00002AD1  jz 0x2adf
  db 0x2E, 0xC6, 0x87, 0xFE, 0x3A, 0xFF ; 00002AD3  mov byte [cs:bx+0x3afe],0xff
  db 0xE8, 0x59, 0xFF          ; 00002AD9  call 0x2a35
  db 0xE8, 0x83, 0xFF          ; 00002ADC  call 0x2a62
  db 0xC3                      ; 00002ADF  ret
  db 0x8B, 0x46, 0x0A          ; 00002AE0  mov ax,[bp+0xa]
  db 0xBA, 0x84, 0x02          ; 00002AE3  mov dx,0x284
  db 0xEE                      ; 00002AE6  out dx,al
  db 0xB0, 0x88                ; 00002AE7  mov al,0x88
  db 0x2E, 0x0A, 0x06, 0xF7, 0x3A ; 00002AE9  or al,[cs:0x3af7]
  db 0x2E, 0x0A, 0x06, 0xF8, 0x3A ; 00002AEE  or al,[cs:0x3af8]
  db 0xBA, 0x80, 0x02          ; 00002AF3  mov dx,0x280
  db 0xEE                      ; 00002AF6  out dx,al
  db 0xE8, 0x40, 0x00          ; 00002AF7  call 0x2b3a
  db 0xC3                      ; 00002AFA  ret
  db 0x2E, 0x8A, 0x26, 0xF9, 0x3A ; 00002AFB  mov ah,[cs:0x3af9]
  db 0x80, 0xE4, 0xEF          ; 00002B00  and ah,0xef
  db 0xBA, 0x82, 0x02          ; 00002B03  mov dx,0x282
  db 0xEC                      ; 00002B06  in al,dx
  db 0x3C, 0x2A                ; 00002B07  cmp al,0x2a
  db 0x72, 0x03                ; 00002B09  jc 0x2b0e
  db 0x80, 0xCC, 0x10          ; 00002B0B  or ah,0x10
  db 0x8A, 0xC4                ; 00002B0E  mov al,ah
  db 0x2E, 0xA2, 0xF9, 0x3A    ; 00002B10  mov [cs:0x3af9],al
  db 0xBA, 0x88, 0x02          ; 00002B14  mov dx,0x288
  db 0xEE                      ; 00002B17  out dx,al
  db 0x8B, 0x46, 0x0A          ; 00002B18  mov ax,[bp+0xa]
  db 0xBA, 0x84, 0x02          ; 00002B1B  mov dx,0x284
  db 0xEE                      ; 00002B1E  out dx,al
  db 0xB0, 0xA8                ; 00002B1F  mov al,0xa8
  db 0x2E, 0x0A, 0x06, 0xF7, 0x3A ; 00002B21  or al,[cs:0x3af7]
  db 0x2E, 0x0A, 0x06, 0xF8, 0x3A ; 00002B26  or al,[cs:0x3af8]
  db 0xBA, 0x80, 0x02          ; 00002B2B  mov dx,0x280
  db 0xEE                      ; 00002B2E  out dx,al
  db 0xE8, 0x08, 0x00          ; 00002B2F  call 0x2b3a
  db 0xC3                      ; 00002B32  ret
  db 0xB0, 0xD8                ; 00002B33  mov al,0xd8
  db 0xBA, 0x80, 0x02          ; 00002B35  mov dx,0x280
  db 0xEE                      ; 00002B38  out dx,al
  db 0xC3                      ; 00002B39  ret
  db 0x2E, 0xC6, 0x06, 0xFB, 0x3A, 0x01 ; 00002B3A  mov byte [cs:0x3afb],0x1
  db 0xBA, 0x08, 0x00          ; 00002B40  mov dx,0x8
  db 0xE8, 0xEB, 0xD5          ; 00002B43  call 0x131
  db 0xC3                      ; 00002B46  ret
  db 0xE8, 0xC0, 0x0F          ; 00002B47  call 0x3b0a
  db 0x2E, 0x8E, 0x1E, 0x06, 0x0C ; 00002B4A  mov ds,[cs:0xc06]
  db 0xBA, 0x80, 0x02          ; 00002B4F  mov dx,0x280
  db 0xEC                      ; 00002B52  in al,dx
  db 0x2E, 0xA2, 0x0F, 0x3B    ; 00002B53  mov [cs:0x3b0f],al
  db 0xB0, 0xD0                ; 00002B57  mov al,0xd0
  db 0xEE                      ; 00002B59  out dx,al
  db 0xB9, 0x09, 0x00          ; 00002B5A  mov cx,0x9
  db 0xE2, 0xFE                ; 00002B5D  loop 0x2b5d
  db 0xEC                      ; 00002B5F  in al,dx
  db 0xBA, 0xC8, 0xFF          ; 00002B60  mov dx,0xffc8
  db 0xED                      ; 00002B63  in ax,dx
  db 0x2E, 0xA3, 0x10, 0x3B    ; 00002B64  mov [cs:0x3b10],ax
  db 0xE8, 0x93, 0x0F          ; 00002B68  call 0x3afe
  db 0x2E, 0x80, 0x3E, 0xFB, 0x3A, 0x01 ; 00002B6B  cmp byte [cs:0x3afb],0x1
  db 0x75, 0x0C                ; 00002B71  jnz 0x2b7f
  db 0x2E, 0xC6, 0x06, 0xFB, 0x3A, 0x00 ; 00002B73  mov byte [cs:0x3afb],0x0
  db 0xBA, 0x08, 0x00          ; 00002B79  mov dx,0x8
  db 0xE8, 0xA1, 0xD5          ; 00002B7C  call 0x120
  db 0xE9, 0xA9, 0x0F          ; 00002B7F  jmp 0x3b2b
  db 0xBA, 0x80, 0x02          ; 00002B82  mov dx,0x280
  db 0xEC                      ; 00002B85  in al,dx
  db 0x24, 0x81                ; 00002B86  and al,0x81
  db 0xF8                      ; 00002B88  clc
  db 0x74, 0x01                ; 00002B89  jz 0x2b8c
  db 0xF9                      ; 00002B8B  stc
  db 0xC3                      ; 00002B8C  ret
  db 0x2E, 0xC6, 0x06, 0xE3, 0x3A, 0x00 ; 00002B8D  mov byte [cs:0x3ae3],0x0
  db 0x2E, 0xA0, 0x0F, 0x3B    ; 00002B93  mov al,[cs:0x3b0f]
  db 0xA8, 0xBF                ; 00002B97  test al,0xbf
  db 0x75, 0x0A                ; 00002B99  jnz 0x2ba5
  db 0x2E, 0x83, 0x3E, 0x10, 0x3B, 0x00 ; 00002B9B  cmp word [cs:0x3b10],byte +0x0
  db 0x75, 0x02                ; 00002BA1  jnz 0x2ba5
  db 0xF8                      ; 00002BA3  clc
  db 0xC3                      ; 00002BA4  ret
  db 0xBB, 0xD2, 0x3B          ; 00002BA5  mov bx,0x3bd2
  db 0xE8, 0x30, 0xFD          ; 00002BA8  call 0x28db
  db 0x2E, 0xFE, 0x06, 0xE3, 0x3A ; 00002BAB  inc byte [cs:0x3ae3]
  db 0xF9                      ; 00002BB0  stc
  db 0xC3                      ; 00002BB1  ret
  db 0x2E, 0xC6, 0x06, 0xE4, 0x3A, 0x00 ; 00002BB2  mov byte [cs:0x3ae4],0x0
  db 0x2E, 0xA0, 0x0F, 0x3B    ; 00002BB8  mov al,[cs:0x3b0f]
  db 0xA8, 0xFF                ; 00002BBC  test al,0xff
  db 0x75, 0x0A                ; 00002BBE  jnz 0x2bca
  db 0x2E, 0x83, 0x3E, 0x10, 0x3B, 0x00 ; 00002BC0  cmp word [cs:0x3b10],byte +0x0
  db 0x75, 0x02                ; 00002BC6  jnz 0x2bca
  db 0xF8                      ; 00002BC8  clc
  db 0xC3                      ; 00002BC9  ret
  db 0xBB, 0xF2, 0x3B          ; 00002BCA  mov bx,0x3bf2
  db 0xE8, 0x0B, 0xFD          ; 00002BCD  call 0x28db
  db 0x2E, 0xC6, 0x06, 0xE4, 0x3A, 0x01 ; 00002BD0  mov byte [cs:0x3ae4],0x1
  db 0x2E, 0xA0, 0x0F, 0x3B    ; 00002BD6  mov al,[cs:0x3b0f]
  db 0xA8, 0x40                ; 00002BDA  test al,0x40
  db 0x74, 0x06                ; 00002BDC  jz 0x2be4
  db 0x2E, 0xC6, 0x06, 0xE4, 0x3A, 0x02 ; 00002BDE  mov byte [cs:0x3ae4],0x2
  db 0xF9                      ; 00002BE4  stc
  db 0xC3                      ; 00002BE5  ret
  db 0x2E, 0xC6, 0x06, 0x0E, 0x3B, 0x01 ; 00002BE6  mov byte [cs:0x3b0e],0x1
  db 0x8B, 0xEC                ; 00002BEC  mov bp,sp
  db 0x8A, 0x66, 0x14          ; 00002BEE  mov ah,[bp+0x14]
  db 0xE8, 0x14, 0xFD          ; 00002BF1  call 0x2908
  db 0xB0, 0x0C                ; 00002BF4  mov al,0xc
  db 0x24, 0xFB                ; 00002BF6  and al,0xfb
  db 0xBA, 0x80, 0x02          ; 00002BF8  mov dx,0x280
  db 0xEE                      ; 00002BFB  out dx,al
  db 0xE8, 0x3B, 0xFF          ; 00002BFC  call 0x2b3a
  db 0xE9, 0x27, 0x01          ; 00002BFF  jmp 0x2d29
  db 0xC3                      ; 00002C02  ret
  db 0xC3                      ; 00002C03  ret
  db 0x2E, 0xC6, 0x06, 0x0E, 0x3B, 0x01 ; 00002C04  mov byte [cs:0x3b0e],0x1
  db 0x8B, 0xEC                ; 00002C0A  mov bp,sp
  db 0x8A, 0x66, 0x14          ; 00002C0C  mov ah,[bp+0x14]
  db 0xE8, 0xF6, 0xFC          ; 00002C0F  call 0x2908
  db 0xB0, 0x5C                ; 00002C12  mov al,0x5c
  db 0x24, 0xFB                ; 00002C14  and al,0xfb
  db 0xBA, 0x80, 0x02          ; 00002C16  mov dx,0x280
  db 0xEE                      ; 00002C19  out dx,al
  db 0xE8, 0x1D, 0xFF          ; 00002C1A  call 0x2b3a
  db 0xE9, 0x09, 0x01          ; 00002C1D  jmp 0x2d29
  db 0xC3                      ; 00002C20  ret
  db 0x2E, 0xC6, 0x06, 0x0E, 0x3B, 0x01 ; 00002C21  mov byte [cs:0x3b0e],0x1
  db 0x8B, 0xEC                ; 00002C27  mov bp,sp
  db 0x8B, 0x46, 0x0C          ; 00002C29  mov ax,[bp+0xc]
  db 0x8B, 0x5E, 0x0A          ; 00002C2C  mov bx,[bp+0xa]
  db 0xE8, 0xDD, 0x01          ; 00002C2F  call 0x2e0f
  db 0x2E, 0xC7, 0x06, 0xC8, 0x3A, 0xA6, 0x76 ; 00002C32  mov word [cs:0x3ac8],0x76a6
  db 0x32, 0xC0                ; 00002C39  xor al,al
  db 0xE8, 0x06, 0x02          ; 00002C3B  call 0x2e44
  db 0x32, 0xC0                ; 00002C3E  xor al,al
  db 0xE8, 0x3F, 0x02          ; 00002C40  call 0x2e82
  db 0xB4, 0x04                ; 00002C43  mov ah,0x4
  db 0x32, 0xC0                ; 00002C45  xor al,al
  db 0xE8, 0x3D, 0x02          ; 00002C47  call 0x2e87
  db 0x8A, 0x66, 0x14          ; 00002C4A  mov ah,[bp+0x14]
  db 0xE8, 0xB8, 0xFC          ; 00002C4D  call 0x2908
  db 0x2E, 0xC6, 0x06, 0xE4, 0x3A, 0x01 ; 00002C50  mov byte [cs:0x3ae4],0x1
  db 0xE8, 0x29, 0xFF          ; 00002C56  call 0x2b82
  db 0x73, 0x03                ; 00002C59  jnc 0x2c5e
  db 0xE9, 0x37, 0x00          ; 00002C5B  jmp 0x2c95
  db 0x8B, 0x46, 0x0E          ; 00002C5E  mov ax,[bp+0xe]
  db 0xBA, 0x86, 0x02          ; 00002C61  mov dx,0x286
  db 0xBE, 0xE8, 0x3A          ; 00002C64  mov si,0x3ae8
  db 0xE8, 0x6F, 0x01          ; 00002C67  call 0x2dd9
  db 0x2E, 0xC6, 0x06, 0xF8, 0x3A, 0x00 ; 00002C6A  mov byte [cs:0x3af8],0x0
  db 0x2E, 0xC6, 0x06, 0xF6, 0x3A, 0x00 ; 00002C70  mov byte [cs:0x3af6],0x0
  db 0x2E, 0xC6, 0x06, 0xF7, 0x3A, 0x00 ; 00002C76  mov byte [cs:0x3af7],0x0
  db 0x80, 0x7E, 0x12, 0x00    ; 00002C7C  cmp byte [bp+0x12],0x0
  db 0x74, 0x06                ; 00002C80  jz 0x2c88
  db 0x2E, 0xC6, 0x06, 0xF7, 0x3A, 0x02 ; 00002C82  mov byte [cs:0x3af7],0x2
  db 0xBE, 0xE8, 0x3A          ; 00002C88  mov si,0x3ae8
  db 0x32, 0xC0                ; 00002C8B  xor al,al
  db 0xE8, 0x99, 0x01          ; 00002C8D  call 0x2e29
  db 0xB0, 0xF4                ; 00002C90  mov al,0xf4
  db 0xE8, 0x08, 0x00          ; 00002C92  call 0x2c9d
  db 0x32, 0xC0                ; 00002C95  xor al,al
  db 0xE8, 0xC9, 0x01          ; 00002C97  call 0x2e63
  db 0xE9, 0x8C, 0x00          ; 00002C9A  jmp 0x2d29
  db 0x8A, 0x56, 0x12          ; 00002C9D  mov dl,[bp+0x12]
  db 0xD0, 0xE2                ; 00002CA0  shl dl,1
  db 0x0A, 0xC2                ; 00002CA2  or al,dl
  db 0xBA, 0x80, 0x02          ; 00002CA4  mov dx,0x280
  db 0xEE                      ; 00002CA7  out dx,al
  db 0xE8, 0x8F, 0xFE          ; 00002CA8  call 0x2b3a
  db 0xC3                      ; 00002CAB  ret
  db 0x2E, 0xC6, 0x06, 0x0E, 0x3B, 0x01 ; 00002CAC  mov byte [cs:0x3b0e],0x1
  db 0x8B, 0xEC                ; 00002CB2  mov bp,sp
  db 0x8B, 0x46, 0x0C          ; 00002CB4  mov ax,[bp+0xc]
  db 0x8B, 0x5E, 0x0A          ; 00002CB7  mov bx,[bp+0xa]
  db 0xE8, 0x52, 0x01          ; 00002CBA  call 0x2e0f
  db 0x2E, 0xC7, 0x06, 0xC8, 0x3A, 0x66, 0xAE ; 00002CBD  mov word [cs:0x3ac8],0xae66
  db 0x32, 0xC0                ; 00002CC4  xor al,al
  db 0xE8, 0x7B, 0x01          ; 00002CC6  call 0x2e44
  db 0x32, 0xC0                ; 00002CC9  xor al,al
  db 0xE8, 0xB4, 0x01          ; 00002CCB  call 0x2e82
  db 0xB4, 0x04                ; 00002CCE  mov ah,0x4
  db 0x32, 0xC0                ; 00002CD0  xor al,al
  db 0xE8, 0xB2, 0x01          ; 00002CD2  call 0x2e87
  db 0x8A, 0x66, 0x14          ; 00002CD5  mov ah,[bp+0x14]
  db 0xE8, 0x2D, 0xFC          ; 00002CD8  call 0x2908
  db 0x2E, 0xC6, 0x06, 0xE4, 0x3A, 0x01 ; 00002CDB  mov byte [cs:0x3ae4],0x1
  db 0xE8, 0x9E, 0xFE          ; 00002CE1  call 0x2b82
  db 0x73, 0x03                ; 00002CE4  jnc 0x2ce9
  db 0xE9, 0x37, 0x00          ; 00002CE6  jmp 0x2d20
  db 0x8B, 0x46, 0x0E          ; 00002CE9  mov ax,[bp+0xe]
  db 0xBA, 0x86, 0x02          ; 00002CEC  mov dx,0x286
  db 0xBE, 0xE8, 0x3A          ; 00002CEF  mov si,0x3ae8
  db 0xE8, 0xE4, 0x00          ; 00002CF2  call 0x2dd9
  db 0x2E, 0xC6, 0x06, 0xF8, 0x3A, 0x00 ; 00002CF5  mov byte [cs:0x3af8],0x0
  db 0x2E, 0xC6, 0x06, 0xF6, 0x3A, 0x00 ; 00002CFB  mov byte [cs:0x3af6],0x0
  db 0x2E, 0xC6, 0x06, 0xF7, 0x3A, 0x00 ; 00002D01  mov byte [cs:0x3af7],0x0
  db 0x80, 0x7E, 0x12, 0x00    ; 00002D07  cmp byte [bp+0x12],0x0
  db 0x74, 0x06                ; 00002D0B  jz 0x2d13
  db 0x2E, 0xC6, 0x06, 0xF7, 0x3A, 0x02 ; 00002D0D  mov byte [cs:0x3af7],0x2
  db 0xBE, 0xE8, 0x3A          ; 00002D13  mov si,0x3ae8
  db 0x32, 0xC0                ; 00002D16  xor al,al
  db 0xE8, 0x0E, 0x01          ; 00002D18  call 0x2e29
  db 0xB0, 0xE4                ; 00002D1B  mov al,0xe4
  db 0xE8, 0x7D, 0xFF          ; 00002D1D  call 0x2c9d
  db 0x32, 0xC0                ; 00002D20  xor al,al
  db 0xE8, 0x3E, 0x01          ; 00002D22  call 0x2e63
  db 0xE9, 0x01, 0x00          ; 00002D25  jmp 0x2d29
  db 0xC3                      ; 00002D28  ret
  db 0x8A, 0x66, 0x14          ; 00002D29  mov ah,[bp+0x14]
  db 0xE8, 0x79, 0xFC          ; 00002D2C  call 0x29a8
  db 0x2E, 0xA0, 0x0F, 0x3B    ; 00002D2F  mov al,[cs:0x3b0f]
  db 0x2E, 0xC6, 0x06, 0x0E, 0x3B, 0x00 ; 00002D33  mov byte [cs:0x3b0e],0x0
  db 0xC3                      ; 00002D39  ret
  db 0x2E, 0x8E, 0x06, 0x06, 0x0C ; 00002D3A  mov es,[cs:0xc06]
  db 0xB8, 0x12, 0x3B          ; 00002D3F  mov ax,0x3b12
  db 0xC3                      ; 00002D42  ret
  db 0xC3                      ; 00002D43  ret
  db 0x00, 0x00                ; 00002D44  add [bx+si],al
  db 0xE8, 0x23, 0x00          ; 00002D46  call 0x2d6c
  db 0x06                      ; 00002D49  push es
  db 0xC4, 0x7E, 0x06          ; 00002D4A  les di,[bp+0x6]
  db 0x33, 0xF6                ; 00002D4D  xor si,si
  db 0x1E                      ; 00002D4F  push ds
  db 0x8E, 0xDB                ; 00002D50  mov ds,bx
  db 0xF3, 0xA5                ; 00002D52  rep movsw
  db 0x1F                      ; 00002D54  pop ds
  db 0x07                      ; 00002D55  pop es
  db 0x33, 0xC0                ; 00002D56  xor ax,ax
  db 0xC3                      ; 00002D58  ret
  db 0xE8, 0x10, 0x00          ; 00002D59  call 0x2d6c
  db 0x06                      ; 00002D5C  push es
  db 0x8E, 0xC3                ; 00002D5D  mov es,bx
  db 0x33, 0xFF                ; 00002D5F  xor di,di
  db 0x1E                      ; 00002D61  push ds
  db 0xC5, 0x76, 0x06          ; 00002D62  lds si,[bp+0x6]
  db 0xF3, 0xA5                ; 00002D65  rep movsw
  db 0x1F                      ; 00002D67  pop ds
  db 0x07                      ; 00002D68  pop es
  db 0x33, 0xC0                ; 00002D69  xor ax,ax
  db 0xC3                      ; 00002D6B  ret
  db 0x8B, 0x5E, 0x0C          ; 00002D6C  mov bx,[bp+0xc]
  db 0xB1, 0x03                ; 00002D6F  mov cl,0x3
  db 0xD3, 0xE3                ; 00002D71  shl bx,cl
  db 0x8B, 0x4E, 0x0A          ; 00002D73  mov cx,[bp+0xa]
  db 0x03, 0xD9                ; 00002D76  add bx,cx
  db 0xB1, 0x03                ; 00002D78  mov cl,0x3
  db 0xD3, 0xE3                ; 00002D7A  shl bx,cl
  db 0x2E, 0x03, 0x1E, 0x44, 0x39 ; 00002D7C  add bx,[cs:0x3944]
  db 0xB9, 0x40, 0x00          ; 00002D81  mov cx,0x40
  db 0x8A, 0x46, 0x0F          ; 00002D84  mov al,[bp+0xf]
  db 0x32, 0xE4                ; 00002D87  xor ah,ah
  db 0xF7, 0xE1                ; 00002D89  mul cx
  db 0x8B, 0xC8                ; 00002D8B  mov cx,ax
  db 0xFC                      ; 00002D8D  cld
  db 0xC3                      ; 00002D8E  ret
  db 0x00, 0x40, 0xE8          ; 00002D8F  add [bx+si-0x18],al
  db 0x18, 0x00                ; 00002D92  sbb [bx+si],al
  db 0x06                      ; 00002D94  push es
  db 0xC4, 0x7E, 0x06          ; 00002D95  les di,[bp+0x6]
  db 0x33, 0xF6                ; 00002D98  xor si,si
  db 0x1E                      ; 00002D9A  push ds
  db 0x8E, 0xDB                ; 00002D9B  mov ds,bx
  db 0x8B, 0x04                ; 00002D9D  mov ax,[si]
  db 0xAD                      ; 00002D9F  lodsw
  db 0xAB                      ; 00002DA0  stosw
  db 0xE2, 0xFA                ; 00002DA1  loop 0x2d9d
  db 0x1F                      ; 00002DA3  pop ds
  db 0x07                      ; 00002DA4  pop es
  db 0x33, 0xC0                ; 00002DA5  xor ax,ax
  db 0xC3                      ; 00002DA7  ret
  db 0xB8, 0x01, 0x00          ; 00002DA8  mov ax,0x1
  db 0xC3                      ; 00002DAB  ret
  db 0x8B, 0x5E, 0x0C          ; 00002DAC  mov bx,[bp+0xc]
  db 0xB1, 0x03                ; 00002DAF  mov cl,0x3
  db 0xD3, 0xE3                ; 00002DB1  shl bx,cl
  db 0x8B, 0x4E, 0x0A          ; 00002DB3  mov cx,[bp+0xa]
  db 0x03, 0xD9                ; 00002DB6  add bx,cx
  db 0xB1, 0x03                ; 00002DB8  mov cl,0x3
  db 0xD3, 0xE3                ; 00002DBA  shl bx,cl
  db 0x2E, 0x03, 0x1E, 0x8F, 0x39 ; 00002DBC  add bx,[cs:0x398f]
  db 0xB9, 0x40, 0x00          ; 00002DC1  mov cx,0x40
  db 0x8A, 0x46, 0x0F          ; 00002DC4  mov al,[bp+0xf]
  db 0x32, 0xE4                ; 00002DC7  xor ah,ah
  db 0xF7, 0xE1                ; 00002DC9  mul cx
  db 0x8B, 0xC8                ; 00002DCB  mov cx,ax
  db 0xFC                      ; 00002DCD  cld
  db 0xC3                      ; 00002DCE  ret
  db 0x2E, 0x8A, 0x0E, 0x04, 0x3B ; 00002DCF  mov cl,[cs:0x3b04]
  db 0x80, 0xC1, 0x07          ; 00002DD4  add cl,0x7
  db 0xD3, 0xE0                ; 00002DD7  shl ax,cl
  db 0x89, 0x44, 0x08          ; 00002DD9  mov [si+0x8],ax
  db 0x2E, 0xA1, 0xC8, 0x3A    ; 00002DDC  mov ax,[cs:0x3ac8]
  db 0x89, 0x44, 0x0A          ; 00002DE0  mov [si+0xa],ax
  db 0x2E, 0x8A, 0x1E, 0xE7, 0x3A ; 00002DE3  mov bl,[cs:0x3ae7]
  db 0x32, 0xFF                ; 00002DE8  xor bh,bh
  db 0x3D, 0x66, 0xAE          ; 00002DEA  cmp ax,0xae66
  db 0x2E, 0xA1, 0xE5, 0x3A    ; 00002DED  mov ax,[cs:0x3ae5]
  db 0x74, 0x0E                ; 00002DF1  jz 0x2e01
  db 0xC7, 0x04, 0x00, 0x00    ; 00002DF3  mov word [si],0x0
  db 0x89, 0x54, 0x02          ; 00002DF7  mov [si+0x2],dx
  db 0x89, 0x5C, 0x04          ; 00002DFA  mov [si+0x4],bx
  db 0x89, 0x44, 0x06          ; 00002DFD  mov [si+0x6],ax
  db 0xC3                      ; 00002E00  ret
  db 0x89, 0x1C                ; 00002E01  mov [si],bx
  db 0x89, 0x44, 0x02          ; 00002E03  mov [si+0x2],ax
  db 0xC7, 0x44, 0x04, 0x00, 0x00 ; 00002E06  mov word [si+0x4],0x0
  db 0x89, 0x54, 0x06          ; 00002E0B  mov [si+0x6],dx
  db 0xC3                      ; 00002E0E  ret
  db 0xB1, 0x04                ; 00002E0F  mov cl,0x4
  db 0xD3, 0xC0                ; 00002E11  rol ax,cl
  db 0x8A, 0xE8                ; 00002E13  mov ch,al
  db 0x24, 0xF0                ; 00002E15  and al,0xf0
  db 0x03, 0xC3                ; 00002E17  add ax,bx
  db 0x80, 0xD5, 0x00          ; 00002E19  adc ch,0x0
  db 0x80, 0xE5, 0x0F          ; 00002E1C  and ch,0xf
  db 0x2E, 0xA3, 0xE5, 0x3A    ; 00002E1F  mov [cs:0x3ae5],ax
  db 0x2E, 0x88, 0x2E, 0xE7, 0x3A ; 00002E23  mov [cs:0x3ae7],ch
  db 0xC3                      ; 00002E28  ret
  db 0xFA                      ; 00002E29  cli
  db 0xBF, 0xCA, 0x3A          ; 00002E2A  mov di,0x3aca
  db 0xA8, 0x01                ; 00002E2D  test al,0x1
  db 0x74, 0x03                ; 00002E2F  jz 0x2e34
  db 0xBF, 0xD6, 0x3A          ; 00002E31  mov di,0x3ad6
  db 0xB9, 0x06, 0x00          ; 00002E34  mov cx,0x6
  db 0x8B, 0x15                ; 00002E37  mov dx,[di]
  db 0x8B, 0x04                ; 00002E39  mov ax,[si]
  db 0xEF                      ; 00002E3B  out dx,ax
  db 0x47                      ; 00002E3C  inc di
  db 0x47                      ; 00002E3D  inc di
  db 0x46                      ; 00002E3E  inc si
  db 0x46                      ; 00002E3F  inc si
  db 0xE2, 0xF5                ; 00002E40  loop 0x2e37
  db 0xFB                      ; 00002E42  sti
  db 0xC3                      ; 00002E43  ret
  db 0xBA, 0xEE, 0x67          ; 00002E44  mov dx,0x67ee
  db 0x0A, 0xC0                ; 00002E47  or al,al
  db 0x74, 0x03                ; 00002E49  jz 0x2e4e
  db 0xBA, 0x1A, 0x68          ; 00002E4B  mov dx,0x681a
  db 0x60                      ; 00002E4E  pusha
  db 0xB1, 0x89                ; 00002E4F  mov cl,0x89
  db 0xE8, 0xDF, 0xD2          ; 00002E51  call 0x133
  db 0x61                      ; 00002E54  popa
  db 0xFA                      ; 00002E55  cli
  db 0xB4, 0x01                ; 00002E56  mov ah,0x1
  db 0x8A, 0xC8                ; 00002E58  mov cl,al
  db 0xD2, 0xE4                ; 00002E5A  shl ah,cl
  db 0x2E, 0x30, 0x26, 0xE2, 0x3A ; 00002E5C  xor [cs:0x3ae2],ah
  db 0xFB                      ; 00002E61  sti
  db 0xC3                      ; 00002E62  ret
  db 0xFA                      ; 00002E63  cli
  db 0xB4, 0x01                ; 00002E64  mov ah,0x1
  db 0x8A, 0xC8                ; 00002E66  mov cl,al
  db 0xD2, 0xE4                ; 00002E68  shl ah,cl
  db 0x2E, 0x08, 0x26, 0xE2, 0x3A ; 00002E6A  or [cs:0x3ae2],ah
  db 0xBA, 0xEE, 0x67          ; 00002E6F  mov dx,0x67ee
  db 0x0A, 0xC0                ; 00002E72  or al,al
  db 0x74, 0x03                ; 00002E74  jz 0x2e79
  db 0xBA, 0x1A, 0x68          ; 00002E76  mov dx,0x681a
  db 0x60                      ; 00002E79  pusha
  db 0xB1, 0x8B                ; 00002E7A  mov cl,0x8b
  db 0xE8, 0xB4, 0xD2          ; 00002E7C  call 0x133
  db 0x61                      ; 00002E7F  popa
  db 0xFB                      ; 00002E80  sti
  db 0xC3                      ; 00002E81  ret
  db 0x0C, 0x0A                ; 00002E82  or al,0xa
  db 0xE6, 0x76                ; 00002E84  out 0x76,al
  db 0xC3                      ; 00002E86  ret
  db 0xFA                      ; 00002E87  cli
  db 0xB5, 0xF3                ; 00002E88  mov ch,0xf3
  db 0x3C, 0x00                ; 00002E8A  cmp al,0x0
  db 0x74, 0x06                ; 00002E8C  jz 0x2e94
  db 0xB5, 0xC7                ; 00002E8E  mov ch,0xc7
  db 0xB1, 0x03                ; 00002E90  mov cl,0x3
  db 0xD2, 0xE4                ; 00002E92  shl ah,cl
  db 0xE4, 0x74                ; 00002E94  in al,0x74
  db 0x22, 0xC5                ; 00002E96  and al,ch
  db 0x0A, 0xC4                ; 00002E98  or al,ah
  db 0xE6, 0x74                ; 00002E9A  out 0x74,al
  db 0xFB                      ; 00002E9C  sti
  db 0xC3                      ; 00002E9D  ret
  db 0x52                      ; 00002E9E  push dx
  db 0x2E, 0xA3, 0xBC, 0x3C    ; 00002E9F  mov [cs:0x3cbc],ax
  db 0x2E, 0x80, 0x3E, 0x0E, 0x3B, 0x01 ; 00002EA3  cmp byte [cs:0x3b0e],0x1
  db 0x75, 0x06                ; 00002EA9  jnz 0x2eb1
  db 0xBA, 0x80, 0x02          ; 00002EAB  mov dx,0x280
  db 0xB0, 0xD8                ; 00002EAE  mov al,0xd8
  db 0xEE                      ; 00002EB0  out dx,al
  db 0x5A                      ; 00002EB1  pop dx
  db 0x2E, 0xA1, 0xBC, 0x3C    ; 00002EB2  mov ax,[cs:0x3cbc]
  db 0x52                      ; 00002EB6  push dx
  db 0x2E, 0xA3, 0xBC, 0x3C    ; 00002EB7  mov [cs:0x3cbc],ax
  db 0xBA, 0x22, 0xFF          ; 00002EBB  mov dx,0xff22
  db 0xB8, 0x00, 0x80          ; 00002EBE  mov ax,0x8000
  db 0xEF                      ; 00002EC1  out dx,ax
  db 0x2E, 0xA1, 0xBC, 0x3C    ; 00002EC2  mov ax,[cs:0x3cbc]
  db 0x5A                      ; 00002EC6  pop dx
  db 0xCF                      ; 00002EC7  iret
  db 0x00, 0x00                ; 00002EC8  add [bx+si],al
  db 0xC6                      ; 00002ECA  db 0xc6
  db 0xFF, 0xC4                ; 00002ECB  inc sp
  db 0xFF, 0xC2                ; 00002ECD  inc dx
  db 0xFF, 0xC0                ; 00002ECF  inc ax
  db 0xFF, 0xC8                ; 00002ED1  dec ax
  db 0xFF, 0xCA                ; 00002ED3  dec dx
  db 0xFF, 0xD6                ; 00002ED5  call si
  db 0xFF, 0xD4                ; 00002ED7  call sp
  db 0xFF, 0xD2                ; 00002ED9  call dx
  db 0xFF, 0xD0                ; 00002EDB  call ax
  db 0xFF                      ; 00002EDD  db 0xff
  db 0xD8, 0xFF                ; 00002EDE  fdivr st7
  db 0xDA                      ; 00002EE0  db 0xda
  db 0xFF, 0x03                ; 00002EE1  inc word [bp+di]
  db 0x00, 0x00                ; 00002EE3  add [bx+si],al
  db 0x00, 0x00                ; 00002EE5  add [bx+si],al
  db 0x00, 0x00                ; 00002EE7  add [bx+si],al
  db 0x00, 0x00                ; 00002EE9  add [bx+si],al
  db 0x00, 0x00                ; 00002EEB  add [bx+si],al
  db 0x00, 0x00                ; 00002EED  add [bx+si],al
  db 0x00, 0x00                ; 00002EEF  add [bx+si],al
  db 0x00, 0x00                ; 00002EF1  add [bx+si],al
  db 0x00, 0x00                ; 00002EF3  add [bx+si],al
  db 0x08, 0x00                ; 00002EF5  or [bx+si],al
  db 0x00, 0x00                ; 00002EF7  add [bx+si],al
  db 0x48                      ; 00002EF9  dec ax
  db 0x00, 0x00                ; 00002EFA  add [bx+si],al
  db 0x00, 0x00                ; 00002EFC  add [bx+si],al
  db 0x00, 0x00                ; 00002EFE  add [bx+si],al
  db 0x00, 0x00                ; 00002F00  add [bx+si],al
  db 0x00, 0x00                ; 00002F02  add [bx+si],al
  db 0x00, 0x00                ; 00002F04  add [bx+si],al
  db 0x00, 0x00                ; 00002F06  add [bx+si],al
  db 0x00, 0x00                ; 00002F08  add [bx+si],al
  db 0x00, 0x00                ; 00002F0A  add [bx+si],al
  db 0xFF, 0x00                ; 00002F0C  inc word [bx+si]
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
  db 0xCC                      ; 00003012  int3
  db 0xCC                      ; 00003013  int3
  db 0xCC                      ; 00003014  int3
  db 0xCC                      ; 00003015  int3
  db 0xCC                      ; 00003016  int3
  db 0xCC                      ; 00003017  int3
  db 0xCC                      ; 00003018  int3
  db 0xCC                      ; 00003019  int3
  db 0xCC                      ; 0000301A  int3
  db 0xCC                      ; 0000301B  int3
  db 0xCC                      ; 0000301C  int3
  db 0xCC                      ; 0000301D  int3
  db 0xCC                      ; 0000301E  int3
  db 0xCC                      ; 0000301F  int3
  db 0xCC                      ; 00003020  int3
  db 0xCC                      ; 00003021  int3
  db 0xCC                      ; 00003022  int3
  db 0xCC                      ; 00003023  int3
  db 0xCC                      ; 00003024  int3
  db 0xCC                      ; 00003025  int3
  db 0xCC                      ; 00003026  int3
  db 0xCC                      ; 00003027  int3
  db 0xCC                      ; 00003028  int3
  db 0xCC                      ; 00003029  int3
  db 0xCC                      ; 0000302A  int3
  db 0xCC                      ; 0000302B  int3
  db 0xCC                      ; 0000302C  int3
  db 0xCC                      ; 0000302D  int3
  db 0xCC                      ; 0000302E  int3
  db 0xCC                      ; 0000302F  int3
  db 0xCC                      ; 00003030  int3
  db 0xCC                      ; 00003031  int3
  db 0xCC                      ; 00003032  int3
  db 0xCC                      ; 00003033  int3
  db 0xCC                      ; 00003034  int3
  db 0xCC                      ; 00003035  int3
  db 0xCC                      ; 00003036  int3
  db 0xCC                      ; 00003037  int3
  db 0xCC                      ; 00003038  int3
  db 0xCC                      ; 00003039  int3
  db 0xCC                      ; 0000303A  int3
  db 0xCC                      ; 0000303B  int3
  db 0xCC                      ; 0000303C  int3
  db 0xCC                      ; 0000303D  int3
  db 0xCC                      ; 0000303E  int3
  db 0xCC                      ; 0000303F  int3
  db 0xCC                      ; 00003040  int3
  db 0xCC                      ; 00003041  int3
  db 0xCC                      ; 00003042  int3
  db 0xCC                      ; 00003043  int3
  db 0xCC                      ; 00003044  int3
  db 0xCC                      ; 00003045  int3
  db 0xCC                      ; 00003046  int3
  db 0xCC                      ; 00003047  int3
  db 0xCC                      ; 00003048  int3
  db 0xCC                      ; 00003049  int3
  db 0xCC                      ; 0000304A  int3
  db 0xCC                      ; 0000304B  int3
  db 0xCC                      ; 0000304C  int3
  db 0xCC                      ; 0000304D  int3
  db 0xCC                      ; 0000304E  int3
  db 0xCC                      ; 0000304F  int3
  db 0xCC                      ; 00003050  int3
  db 0xCC                      ; 00003051  int3
  db 0xCC                      ; 00003052  int3
  db 0xCC                      ; 00003053  int3
  db 0xCC                      ; 00003054  int3
  db 0xCC                      ; 00003055  int3
  db 0xCC                      ; 00003056  int3
  db 0xCC                      ; 00003057  int3
  db 0xCC                      ; 00003058  int3
  db 0xCC                      ; 00003059  int3
  db 0xCC                      ; 0000305A  int3
  db 0xCC                      ; 0000305B  int3
  db 0xCC                      ; 0000305C  int3
  db 0xCC                      ; 0000305D  int3
  db 0xCC                      ; 0000305E  int3
  db 0xCC                      ; 0000305F  int3
  db 0xCC                      ; 00003060  int3
  db 0xCC                      ; 00003061  int3
  db 0x00, 0x00                ; 00003062  add [bx+si],al
  db 0x00, 0x00                ; 00003064  add [bx+si],al
  db 0x00, 0x00                ; 00003066  add [bx+si],al
  db 0xCC                      ; 00003068  int3
  db 0xCC                      ; 00003069  int3
  db 0xCC                      ; 0000306A  int3
  db 0xCC                      ; 0000306B  int3
  db 0xCC                      ; 0000306C  int3
  db 0xCC                      ; 0000306D  int3
  db 0xCC                      ; 0000306E  int3
  db 0xCC                      ; 0000306F  int3
  db 0xCC                      ; 00003070  int3
  db 0xCC                      ; 00003071  int3
  db 0xCC                      ; 00003072  int3
  db 0xCC                      ; 00003073  int3
  db 0xCC                      ; 00003074  int3
  db 0xCC                      ; 00003075  int3
  db 0xCC                      ; 00003076  int3
  db 0xCC                      ; 00003077  int3
  db 0xCC                      ; 00003078  int3
  db 0xCC                      ; 00003079  int3
  db 0xCC                      ; 0000307A  int3
  db 0xCC                      ; 0000307B  int3
  db 0xCC                      ; 0000307C  int3
  db 0xCC                      ; 0000307D  int3
  db 0xCC                      ; 0000307E  int3
  db 0xCC                      ; 0000307F  int3
  db 0xCC                      ; 00003080  int3
  db 0xCC                      ; 00003081  int3
  db 0xCC                      ; 00003082  int3
  db 0xCC                      ; 00003083  int3
  db 0xCC                      ; 00003084  int3
  db 0xCC                      ; 00003085  int3
  db 0xCC                      ; 00003086  int3
  db 0xCC                      ; 00003087  int3
  db 0xCC                      ; 00003088  int3
  db 0xCC                      ; 00003089  int3
  db 0xCC                      ; 0000308A  int3
  db 0xCC                      ; 0000308B  int3
  db 0xCC                      ; 0000308C  int3
  db 0xCC                      ; 0000308D  int3
  db 0xCC                      ; 0000308E  int3
  db 0xCC                      ; 0000308F  int3
  db 0xCC                      ; 00003090  int3
  db 0xCC                      ; 00003091  int3
  db 0xCC                      ; 00003092  int3
  db 0xCC                      ; 00003093  int3
  db 0xCC                      ; 00003094  int3
  db 0xCC                      ; 00003095  int3
  db 0xCC                      ; 00003096  int3
  db 0xCC                      ; 00003097  int3
  db 0xCC                      ; 00003098  int3
  db 0xCC                      ; 00003099  int3
  db 0xCC                      ; 0000309A  int3
  db 0xCC                      ; 0000309B  int3
  db 0xCC                      ; 0000309C  int3
  db 0xCC                      ; 0000309D  int3
  db 0xCC                      ; 0000309E  int3
  db 0xCC                      ; 0000309F  int3
  db 0xCC                      ; 000030A0  int3
  db 0xCC                      ; 000030A1  int3
  db 0xCC                      ; 000030A2  int3
  db 0xCC                      ; 000030A3  int3
  db 0xCC                      ; 000030A4  int3
  db 0xCC                      ; 000030A5  int3
  db 0xCC                      ; 000030A6  int3
  db 0xCC                      ; 000030A7  int3
  db 0xCC                      ; 000030A8  int3
  db 0xCC                      ; 000030A9  int3
  db 0xCC                      ; 000030AA  int3
  db 0xCC                      ; 000030AB  int3
  db 0xCC                      ; 000030AC  int3
  db 0xCC                      ; 000030AD  int3
  db 0xCC                      ; 000030AE  int3
  db 0xCC                      ; 000030AF  int3
  db 0xCC                      ; 000030B0  int3
  db 0xCC                      ; 000030B1  int3
  db 0xCC                      ; 000030B2  int3
  db 0xCC                      ; 000030B3  int3
  db 0xCC                      ; 000030B4  int3
  db 0xCC                      ; 000030B5  int3
  db 0xCC                      ; 000030B6  int3
  db 0xCC                      ; 000030B7  int3
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
  db 0x00, 0x0F                ; 000030D6  add [bx],cl
  db 0x3E, 0x00, 0x00          ; 000030D8  add [ds:bx+si],al
  db 0x00, 0x00                ; 000030DB  add [bx+si],al
  db 0x40                      ; 000030DD  inc ax
  db 0x3F                      ; 000030DE  aas
  db 0x4F                      ; 000030DF  dec di
  db 0x3F                      ; 000030E0  aas
  db 0x00, 0x00                ; 000030E1  add [bx+si],al
  db 0x00, 0x00                ; 000030E3  add [bx+si],al
  db 0x00, 0x00                ; 000030E5  add [bx+si],al
  db 0x00, 0x00                ; 000030E7  add [bx+si],al
  db 0x00, 0x00                ; 000030E9  add [bx+si],al
  db 0x0F                      ; 000030EB  db 0x0f
  db 0x3E, 0x00, 0x00          ; 000030EC  add [ds:bx+si],al
  db 0x00, 0x00                ; 000030EF  add [bx+si],al
  db 0x40                      ; 000030F1  inc ax
  db 0x3F                      ; 000030F2  aas
  db 0x4F                      ; 000030F3  dec di
  db 0x3F                      ; 000030F4  aas
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
  db 0xEC                      ; 000031C7  in al,dx
  db 0x3E, 0x00, 0x00          ; 000031C8  add [ds:bx+si],al
  db 0x00, 0x00                ; 000031CB  add [bx+si],al
  db 0x40                      ; 000031CD  inc ax
  db 0x3F                      ; 000031CE  aas
  db 0x4F                      ; 000031CF  dec di
  db 0x3F                      ; 000031D0  aas
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
  db 0x08, 0x00                ; 0000320F  or [bx+si],al
  db 0x04, 0x0F                ; 00003211  add al,0xf
  db 0x00, 0x57, 0x02          ; 00003213  add [bx+0x2],dl
  db 0xFF, 0x01                ; 00003216  inc word [bx+di]
  db 0xFF, 0x00                ; 00003218  inc word [bx+si]
  db 0x80, 0x80, 0x04, 0x00, 0x03 ; 0000321A  add byte [bx+si+0x4],0x3
  db 0x07                      ; 0000321F  pop es
  db 0x08, 0x00                ; 00003220  or [bx+si],al
  db 0x04, 0x0F                ; 00003222  add al,0xf
  db 0x00, 0x57, 0x02          ; 00003224  add [bx+0x2],dl
  db 0xFF, 0x01                ; 00003227  inc word [bx+di]
  db 0xFF, 0x00                ; 00003229  inc word [bx+si]
  db 0x80, 0x80, 0x04, 0x00, 0x03 ; 0000322B  add byte [bx+si+0x4],0x3
  db 0x07                      ; 00003230  pop es
  db 0x12, 0x00                ; 00003231  adc al,[bx+si]
  db 0x05, 0x1F, 0x01          ; 00003233  add ax,0x11f
  db 0xB0, 0x0A                ; 00003236  mov al,0xa
  db 0xFF, 0x04                ; 00003238  inc word [si]
  db 0xFF, 0xC0                ; 0000323A  inc ax
  db 0x00, 0x80, 0x04, 0x00    ; 0000323C  add [bx+si+0x4],al
  db 0x02, 0x03                ; 00003240  add al,[bp+di]
  db 0x12, 0x00                ; 00003242  adc al,[bx+si]
  db 0x05, 0x1F, 0x00          ; 00003244  add ax,0x1f
  db 0xB0, 0x0A                ; 00003247  mov al,0xa
  db 0xFF, 0x04                ; 00003249  inc word [si]
  db 0xFF, 0xC0                ; 0000324B  inc ax
  db 0x00, 0x80, 0x04, 0x00    ; 0000324D  add [bx+si+0x4],al
  db 0x02, 0x03                ; 00003251  add al,[bp+di]
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
  db 0x00, 0x08                ; 000032EB  add [bx+si],cl
  db 0x00, 0x03                ; 000032ED  add [bp+di],al
  db 0x07                      ; 000032EF  pop es
  db 0x00, 0x00                ; 000032F0  add [bx+si],al
  db 0x00, 0x3F                ; 000032F2  add [bx],bh
  db 0x00, 0xC0                ; 000032F4  add al,al
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
  db 0x2E, 0x8E, 0x06, 0xD7, 0x3F ; 0000335E  mov es,[cs:0x3fd7]
  db 0x26, 0xC7, 0x06, 0x08, 0x00, 0xD9, 0x3F ; 00003363  mov word [es:0x8],0x3fd9
  db 0x2E, 0x8C, 0x1E, 0xD3, 0x3F ; 0000336A  mov [cs:0x3fd3],ds
  db 0x2E, 0x89, 0x1E, 0xD5, 0x3F ; 0000336F  mov [cs:0x3fd5],bx
  db 0x33, 0xDB                ; 00003374  xor bx,bx
  db 0x8E, 0xDB                ; 00003376  mov ds,bx
  db 0xBB, 0x00, 0x02          ; 00003378  mov bx,0x200
  db 0x89, 0x07                ; 0000337B  mov [bx],ax
  db 0x89, 0x57, 0x02          ; 0000337D  mov [bx+0x2],dx
  db 0x89, 0x4F, 0x04          ; 00003380  mov [bx+0x4],cx
  db 0xB9, 0x0A, 0x00          ; 00003383  mov cx,0xa
  db 0x51                      ; 00003386  push cx
  db 0xB9, 0xFF, 0xFF          ; 00003387  mov cx,0xffff
  db 0xE2, 0xFE                ; 0000338A  loop 0x338a
  db 0x59                      ; 0000338C  pop cx
  db 0xE2, 0xF7                ; 0000338D  loop 0x3386
  db 0x2E, 0xA1, 0xD5, 0x3F    ; 0000338F  mov ax,[cs:0x3fd5]
  db 0x89, 0x47, 0x06          ; 00003393  mov [bx+0x6],ax
  db 0x89, 0x6F, 0x08          ; 00003396  mov [bx+0x8],bp
  db 0x89, 0x77, 0x0A          ; 00003399  mov [bx+0xa],si
  db 0x89, 0x7F, 0x0C          ; 0000339C  mov [bx+0xc],di
  db 0x89, 0x67, 0x0E          ; 0000339F  mov [bx+0xe],sp
  db 0x8C, 0x4F, 0x10          ; 000033A2  mov [bx+0x10],cs
  db 0x2E, 0xA1, 0xD3, 0x3F    ; 000033A5  mov ax,[cs:0x3fd3]
  db 0x89, 0x47, 0x12          ; 000033A9  mov [bx+0x12],ax
  db 0x8C, 0x57, 0x14          ; 000033AC  mov [bx+0x14],ss
  db 0x8C, 0x47, 0x16          ; 000033AF  mov [bx+0x16],es
  db 0x58                      ; 000033B2  pop ax
  db 0x89, 0x47, 0x18          ; 000033B3  mov [bx+0x18],ax
  db 0x58                      ; 000033B6  pop ax
  db 0x89, 0x47, 0x1A          ; 000033B7  mov [bx+0x1a],ax
  db 0x58                      ; 000033BA  pop ax
  db 0x89, 0x47, 0x1C          ; 000033BB  mov [bx+0x1c],ax
  db 0xC6, 0x06, 0x67, 0x00, 0x50 ; 000033BE  mov byte [0x67],0x50
  db 0x2E, 0x8E, 0x1E, 0x06, 0x0C ; 000033C3  mov ds,[cs:0xc06]
  db 0x2E, 0x8E, 0x06, 0x06, 0x0C ; 000033C8  mov es,[cs:0xc06]
  db 0xBB, 0xF8, 0x6D          ; 000033CD  mov bx,0x6df8
  db 0xE9, 0x69, 0x0A          ; 000033D0  jmp 0x3e3c
  db 0x00, 0x00                ; 000033D3  add [bx+si],al
  db 0x00, 0x00                ; 000033D5  add [bx+si],al
  db 0x00, 0x00                ; 000033D7  add [bx+si],al
  db 0xCF                      ; 000033D9  iret
  db 0xB0, 0x1A                ; 000033DA  mov al,0x1a
  db 0xC3                      ; 000033DC  ret
  db 0xC3                      ; 000033DD  ret
  db 0x2E, 0x3A, 0x16, 0x12, 0x0C ; 000033DE  cmp dl,[cs:0xc12]
  db 0x72, 0x03                ; 000033E3  jc 0x33e8
  db 0xB0, 0x1A                ; 000033E5  mov al,0x1a
  db 0xC3                      ; 000033E7  ret
  db 0x8A, 0xDA                ; 000033E8  mov bl,dl
  db 0x80, 0xEB, 0x04          ; 000033EA  sub bl,0x4
  db 0x32, 0xFF                ; 000033ED  xor bh,bh
  db 0xD1, 0xE3                ; 000033EF  shl bx,1
  db 0x2E, 0xFF, 0x97, 0xF7, 0x3F ; 000033F1  call [cs:bx+0x3ff7]
  db 0xC3                      ; 000033F6  ret
  db 0x4B                      ; 000033F7  dec bx
  db 0x40                      ; 000033F8  inc ax
  db 0x4B                      ; 000033F9  dec bx
  db 0x40                      ; 000033FA  inc ax
  db 0x4A                      ; 000033FB  dec dx
  db 0x40                      ; 000033FC  inc ax
  db 0x4A                      ; 000033FD  dec dx
  db 0x40                      ; 000033FE  inc ax
  db 0x01, 0x40, 0x53          ; 000033FF  add [bx+si+0x53],ax
  db 0x51                      ; 00003402  push cx
  db 0xBA, 0x3A, 0x40          ; 00003403  mov dx,0x403a
  db 0xB1, 0x87                ; 00003406  mov cl,0x87
  db 0xE8, 0x28, 0xCD          ; 00003408  call 0x133
  db 0x59                      ; 0000340B  pop cx
  db 0x5B                      ; 0000340C  pop bx
  db 0x85, 0xC0                ; 0000340D  test ax,ax
  db 0x74, 0x08                ; 0000340F  jz 0x3419
  db 0x2E, 0xC7, 0x06, 0xFF, 0x3F, 0x4A, 0x40 ; 00003411  mov word [cs:0x3fff],0x404a
  db 0xC3                      ; 00003418  ret
  db 0x2E, 0xC7, 0x06, 0xFF, 0x3F, 0x20, 0x40 ; 00003419  mov word [cs:0x3fff],0x4020
  db 0x2E, 0x80, 0x3E, 0x1F, 0x41, 0x00 ; 00003420  cmp byte [cs:0x411f],0x0
  db 0x74, 0x03                ; 00003426  jz 0x342b
  db 0xE8, 0xE5, 0x00          ; 00003428  call 0x3510
  db 0xB1, 0x89                ; 0000342B  mov cl,0x89
  db 0xBA, 0x3A, 0x40          ; 0000342D  mov dx,0x403a
  db 0xE8, 0x00, 0xCD          ; 00003430  call 0x133
  db 0x2E, 0xA0, 0x38, 0x40    ; 00003433  mov al,[cs:0x4038]
  db 0xC3                      ; 00003437  ret
  db 0x00, 0x00                ; 00003438  add [bx+si],al
  db 0x00, 0x00                ; 0000343A  add [bx+si],al
  db 0x00, 0x00                ; 0000343C  add [bx+si],al
  db 0x00, 0x00                ; 0000343E  add [bx+si],al
  db 0x38, 0x40, 0x4E          ; 00003440  cmp [bx+si+0x4e],al
  db 0x65, 0x74, 0x43          ; 00003443  gs jz 0x3489
  db 0x6F                      ; 00003446  outsw
  db 0x6E                      ; 00003447  outsb
  db 0x49                      ; 00003448  dec cx
  db 0x20, 0xC3                ; 00003449  and bl,al
  db 0xFA                      ; 0000344B  cli
  db 0xE8, 0x47, 0x00          ; 0000344C  call 0x3496
  db 0x75, 0x0C                ; 0000344F  jnz 0x345d
  db 0x53                      ; 00003451  push bx
  db 0x80, 0x4F, 0x1A, 0x04    ; 00003452  or byte [bx+0x1a],0x4
  db 0x8B, 0x57, 0x14          ; 00003456  mov dx,[bx+0x14]
  db 0xE8, 0xD5, 0xCC          ; 00003459  call 0x131
  db 0x5B                      ; 0000345C  pop bx
  db 0x8B, 0x47, 0x02          ; 0000345D  mov ax,[bx+0x2]
  db 0x2D, 0x0A, 0x00          ; 00003460  sub ax,0xa
  db 0x39, 0x47, 0x08          ; 00003463  cmp [bx+0x8],ax
  db 0x75, 0x13                ; 00003466  jnz 0x347b
  db 0x80, 0x7F, 0x1D, 0x01    ; 00003468  cmp byte [bx+0x1d],0x1
  db 0x75, 0x0D                ; 0000346C  jnz 0x347b
  db 0x80, 0x4F, 0x1B, 0x20    ; 0000346E  or byte [bx+0x1b],0x20
  db 0xF6, 0x47, 0x1B, 0x01    ; 00003472  test byte [bx+0x1b],0x1
  db 0x74, 0x03                ; 00003476  jz 0x347b
  db 0xE8, 0xD4, 0x01          ; 00003478  call 0x364f
  db 0x8B, 0x77, 0x04          ; 0000347B  mov si,[bx+0x4]
  db 0x06                      ; 0000347E  push es
  db 0x8E, 0x07                ; 0000347F  mov es,[bx]
  db 0x26, 0x8A, 0x04          ; 00003481  mov al,[es:si]
  db 0x07                      ; 00003484  pop es
  db 0xB4, 0x00                ; 00003485  mov ah,0x0
  db 0xFF, 0x47, 0x04          ; 00003487  inc word [bx+0x4]
  db 0x8B, 0x57, 0x02          ; 0000348A  mov dx,[bx+0x2]
  db 0x4A                      ; 0000348D  dec dx
  db 0x21, 0x57, 0x04          ; 0000348E  and [bx+0x4],dx
  db 0xFF, 0x47, 0x08          ; 00003491  inc word [bx+0x8]
  db 0xFB                      ; 00003494  sti
  db 0xC3                      ; 00003495  ret
  db 0x80, 0xFA, 0x08          ; 00003496  cmp dl,0x8
  db 0x74, 0x14                ; 00003499  jz 0x34af
  db 0xE8, 0x0C, 0x03          ; 0000349B  call 0x37aa
  db 0x8B, 0x47, 0x02          ; 0000349E  mov ax,[bx+0x2]
  db 0x39, 0x47, 0x08          ; 000034A1  cmp [bx+0x8],ax
  db 0xB8, 0x00, 0x00          ; 000034A4  mov ax,0x0
  db 0x74, 0x03                ; 000034A7  jz 0x34ac
  db 0xB8, 0xFF, 0x00          ; 000034A9  mov ax,0xff
  db 0x0B, 0xC0                ; 000034AC  or ax,ax
  db 0xC3                      ; 000034AE  ret
  db 0xC3                      ; 000034AF  ret
  db 0x48                      ; 000034B0  dec ax
  db 0xC3                      ; 000034B1  ret
  db 0x2E, 0x3A, 0x16, 0x12, 0x0C ; 000034B2  cmp dl,[cs:0xc12]
  db 0x72, 0x01                ; 000034B7  jc 0x34ba
  db 0xC3                      ; 000034B9  ret
  db 0x8A, 0xDA                ; 000034BA  mov bl,dl
  db 0x80, 0xEB, 0x04          ; 000034BC  sub bl,0x4
  db 0x32, 0xFF                ; 000034BF  xor bh,bh
  db 0xD1, 0xE3                ; 000034C1  shl bx,1
  db 0x2E, 0xFF, 0x97, 0xC9, 0x40 ; 000034C3  call [cs:bx+0x40c9]
  db 0xC3                      ; 000034C8  ret
  db 0xAF                      ; 000034C9  scasw
  db 0x41                      ; 000034CA  inc cx
  db 0xAF                      ; 000034CB  scasw
  db 0x41                      ; 000034CC  inc cx
  db 0xD3, 0x40, 0xD3          ; 000034CD  rol word [bx+si-0x2d],cl
  db 0x40                      ; 000034D0  inc ax
  db 0xD4, 0x40                ; 000034D1  aam 0x40
  db 0xC3                      ; 000034D3  ret
  db 0x53                      ; 000034D4  push bx
  db 0x51                      ; 000034D5  push cx
  db 0xBA, 0x9F, 0x41          ; 000034D6  mov dx,0x419f
  db 0xB1, 0x87                ; 000034D9  mov cl,0x87
  db 0xE8, 0x55, 0xCC          ; 000034DB  call 0x133
  db 0x59                      ; 000034DE  pop cx
  db 0x5B                      ; 000034DF  pop bx
  db 0x85, 0xC0                ; 000034E0  test ax,ax
  db 0x74, 0x08                ; 000034E2  jz 0x34ec
  db 0x2E, 0xC7, 0x06, 0xD1, 0x40, 0xD3, 0x40 ; 000034E4  mov word [cs:0x40d1],0x40d3
  db 0xC3                      ; 000034EB  ret
  db 0x2E, 0xC7, 0x06, 0xD1, 0x40, 0xF3, 0x40 ; 000034EC  mov word [cs:0x40d1],0x40f3
  db 0x2E, 0x8A, 0x1E, 0x1F, 0x41 ; 000034F3  mov bl,[cs:0x411f]
  db 0x32, 0xFF                ; 000034F8  xor bh,bh
  db 0x2E, 0x88, 0x8F, 0x20, 0x41 ; 000034FA  mov [cs:bx+0x4120],cl
  db 0x43                      ; 000034FF  inc bx
  db 0x2E, 0x88, 0x1E, 0x1F, 0x41 ; 00003500  mov [cs:0x411f],bl
  db 0x80, 0xF9, 0x0D          ; 00003505  cmp cl,0xd
  db 0x74, 0x06                ; 00003508  jz 0x3510
  db 0x83, 0xFB, 0x7F          ; 0000350A  cmp bx,byte +0x7f
  db 0x74, 0x01                ; 0000350D  jz 0x3510
  db 0xC3                      ; 0000350F  ret
  db 0xBA, 0x9F, 0x41          ; 00003510  mov dx,0x419f
  db 0xB1, 0x8B                ; 00003513  mov cl,0x8b
  db 0xE8, 0x1B, 0xCC          ; 00003515  call 0x133
  db 0x2E, 0xC6, 0x06, 0x1F, 0x41, 0x00 ; 00003518  mov byte [cs:0x411f],0x0
  db 0xC3                      ; 0000351E  ret
  db 0x00, 0x00                ; 0000351F  add [bx+si],al
  db 0x00, 0x00                ; 00003521  add [bx+si],al
  db 0x00, 0x00                ; 00003523  add [bx+si],al
  db 0x00, 0x00                ; 00003525  add [bx+si],al
  db 0x00, 0x00                ; 00003527  add [bx+si],al
  db 0x00, 0x00                ; 00003529  add [bx+si],al
  db 0x00, 0x00                ; 0000352B  add [bx+si],al
  db 0x00, 0x00                ; 0000352D  add [bx+si],al
  db 0x00, 0x00                ; 0000352F  add [bx+si],al
  db 0x00, 0x00                ; 00003531  add [bx+si],al
  db 0x00, 0x00                ; 00003533  add [bx+si],al
  db 0x00, 0x00                ; 00003535  add [bx+si],al
  db 0x00, 0x00                ; 00003537  add [bx+si],al
  db 0x00, 0x00                ; 00003539  add [bx+si],al
  db 0x00, 0x00                ; 0000353B  add [bx+si],al
  db 0x00, 0x00                ; 0000353D  add [bx+si],al
  db 0x00, 0x00                ; 0000353F  add [bx+si],al
  db 0x00, 0x00                ; 00003541  add [bx+si],al
  db 0x00, 0x00                ; 00003543  add [bx+si],al
  db 0x00, 0x00                ; 00003545  add [bx+si],al
  db 0x00, 0x00                ; 00003547  add [bx+si],al
  db 0x00, 0x00                ; 00003549  add [bx+si],al
  db 0x00, 0x00                ; 0000354B  add [bx+si],al
  db 0x00, 0x00                ; 0000354D  add [bx+si],al
  db 0x00, 0x00                ; 0000354F  add [bx+si],al
  db 0x00, 0x00                ; 00003551  add [bx+si],al
  db 0x00, 0x00                ; 00003553  add [bx+si],al
  db 0x00, 0x00                ; 00003555  add [bx+si],al
  db 0x00, 0x00                ; 00003557  add [bx+si],al
  db 0x00, 0x00                ; 00003559  add [bx+si],al
  db 0x00, 0x00                ; 0000355B  add [bx+si],al
  db 0x00, 0x00                ; 0000355D  add [bx+si],al
  db 0x00, 0x00                ; 0000355F  add [bx+si],al
  db 0x00, 0x00                ; 00003561  add [bx+si],al
  db 0x00, 0x00                ; 00003563  add [bx+si],al
  db 0x00, 0x00                ; 00003565  add [bx+si],al
  db 0x00, 0x00                ; 00003567  add [bx+si],al
  db 0x00, 0x00                ; 00003569  add [bx+si],al
  db 0x00, 0x00                ; 0000356B  add [bx+si],al
  db 0x00, 0x00                ; 0000356D  add [bx+si],al
  db 0x00, 0x00                ; 0000356F  add [bx+si],al
  db 0x00, 0x00                ; 00003571  add [bx+si],al
  db 0x00, 0x00                ; 00003573  add [bx+si],al
  db 0x00, 0x00                ; 00003575  add [bx+si],al
  db 0x00, 0x00                ; 00003577  add [bx+si],al
  db 0x00, 0x00                ; 00003579  add [bx+si],al
  db 0x00, 0x00                ; 0000357B  add [bx+si],al
  db 0x00, 0x00                ; 0000357D  add [bx+si],al
  db 0x00, 0x00                ; 0000357F  add [bx+si],al
  db 0x00, 0x00                ; 00003581  add [bx+si],al
  db 0x00, 0x00                ; 00003583  add [bx+si],al
  db 0x00, 0x00                ; 00003585  add [bx+si],al
  db 0x00, 0x00                ; 00003587  add [bx+si],al
  db 0x00, 0x00                ; 00003589  add [bx+si],al
  db 0x00, 0x00                ; 0000358B  add [bx+si],al
  db 0x00, 0x00                ; 0000358D  add [bx+si],al
  db 0x00, 0x00                ; 0000358F  add [bx+si],al
  db 0x00, 0x00                ; 00003591  add [bx+si],al
  db 0x00, 0x00                ; 00003593  add [bx+si],al
  db 0x00, 0x00                ; 00003595  add [bx+si],al
  db 0x00, 0x00                ; 00003597  add [bx+si],al
  db 0x00, 0x00                ; 00003599  add [bx+si],al
  db 0x00, 0x00                ; 0000359B  add [bx+si],al
  db 0x00, 0x00                ; 0000359D  add [bx+si],al
  db 0x00, 0x00                ; 0000359F  add [bx+si],al
  db 0x00, 0x00                ; 000035A1  add [bx+si],al
  db 0x00, 0x00                ; 000035A3  add [bx+si],al
  db 0x1F                      ; 000035A5  pop ds
  db 0x41                      ; 000035A6  inc cx
  db 0x4E                      ; 000035A7  dec si
  db 0x65, 0x74, 0x43          ; 000035A8  gs jz 0x35ee
  db 0x6F                      ; 000035AB  outsw
  db 0x6E                      ; 000035AC  outsb
  db 0x4F                      ; 000035AD  dec di
  db 0x20, 0xE8                ; 000035AE  and al,ch
  db 0xF8                      ; 000035B0  clc
  db 0x01, 0x9C, 0xFA, 0x83    ; 000035B1  add [si-0x7c06],bx
  db 0x7F, 0x12                ; 000035B5  jg 0x35c9
  db 0x00, 0x75, 0x0E          ; 000035B7  add [di+0xe],dh
  db 0x53                      ; 000035BA  push bx
  db 0x51                      ; 000035BB  push cx
  db 0x80, 0x4F, 0x1B, 0x04    ; 000035BC  or byte [bx+0x1b],0x4
  db 0x8B, 0x57, 0x16          ; 000035C0  mov dx,[bx+0x16]
  db 0xE8, 0x6B, 0xCB          ; 000035C3  call 0x131
  db 0x59                      ; 000035C6  pop cx
  db 0x5B                      ; 000035C7  pop bx
  db 0x8B, 0x77, 0x10          ; 000035C8  mov si,[bx+0x10]
  db 0x06                      ; 000035CB  push es
  db 0x8E, 0x47, 0x0A          ; 000035CC  mov es,[bx+0xa]
  db 0x26, 0x88, 0x0C          ; 000035CF  mov [es:si],cl
  db 0x07                      ; 000035D2  pop es
  db 0xFF, 0x47, 0x10          ; 000035D3  inc word [bx+0x10]
  db 0x8B, 0x47, 0x0C          ; 000035D6  mov ax,[bx+0xc]
  db 0x48                      ; 000035D9  dec ax
  db 0x21, 0x47, 0x10          ; 000035DA  and [bx+0x10],ax
  db 0xFF, 0x4F, 0x12          ; 000035DD  dec word [bx+0x12]
  db 0xF6, 0x47, 0x1B, 0x01    ; 000035E0  test byte [bx+0x1b],0x1
  db 0x74, 0x03                ; 000035E4  jz 0x35e9
  db 0xE8, 0x66, 0x00          ; 000035E6  call 0x364f
  db 0x9D                      ; 000035E9  popf
  db 0xC3                      ; 000035EA  ret
  db 0x2E, 0x3A, 0x16, 0x12, 0x0C ; 000035EB  cmp dl,[cs:0xc12]
  db 0x73, 0x0C                ; 000035F0  jnc 0x35fe
  db 0x8A, 0xDA                ; 000035F2  mov bl,dl
  db 0x80, 0xEB, 0x04          ; 000035F4  sub bl,0x4
  db 0x32, 0xFF                ; 000035F7  xor bh,bh
  db 0x83, 0xFB, 0x02          ; 000035F9  cmp bx,byte +0x2
  db 0x72, 0x01                ; 000035FC  jc 0x35ff
  db 0xC3                      ; 000035FE  ret
  db 0xE8, 0xA8, 0x01          ; 000035FF  call 0x37aa
  db 0x9C                      ; 00003602  pushf
  db 0xFA                      ; 00003603  cli
  db 0x88, 0x4F, 0x1C          ; 00003604  mov [bx+0x1c],cl
  db 0x80, 0x4F, 0x1B, 0x08    ; 00003607  or byte [bx+0x1b],0x8
  db 0xF6, 0x47, 0x1B, 0x01    ; 0000360B  test byte [bx+0x1b],0x1
  db 0x74, 0x03                ; 0000360F  jz 0x3614
  db 0xE8, 0x3B, 0x00          ; 00003611  call 0x364f
  db 0x8B, 0x57, 0x18          ; 00003614  mov dx,[bx+0x18]
  db 0xE8, 0x17, 0xCB          ; 00003617  call 0x131
  db 0x9D                      ; 0000361A  popf
  db 0xC3                      ; 0000361B  ret
  db 0xE8, 0xEB, 0x04          ; 0000361C  call 0x3b0a
  db 0xBB, 0xBC, 0x43          ; 0000361F  mov bx,0x43bc
  db 0xEB, 0x06                ; 00003622  jmp short 0x362a
  db 0xE8, 0xE3, 0x04          ; 00003624  call 0x3b0a
  db 0xBB, 0xE5, 0x43          ; 00003627  mov bx,0x43e5
  db 0x8B, 0x57, 0x25          ; 0000362A  mov dx,[bx+0x25]
  db 0xE8, 0x72, 0x01          ; 0000362D  call 0x37a2
  db 0xE8, 0x1C, 0x00          ; 00003630  call 0x364f
  db 0x83, 0x7F, 0x12, 0x00    ; 00003633  cmp word [bx+0x12],byte +0x0
  db 0x74, 0x13                ; 00003637  jz 0x364c
  db 0xF6, 0x47, 0x1B, 0x04    ; 00003639  test byte [bx+0x1b],0x4
  db 0x74, 0x0D                ; 0000363D  jz 0x364c
  db 0x80, 0x67, 0x1B, 0xFB    ; 0000363F  and byte [bx+0x1b],0xfb
  db 0x8B, 0x57, 0x16          ; 00003643  mov dx,[bx+0x16]
  db 0xE8, 0xD7, 0xCA          ; 00003646  call 0x120
  db 0xE9, 0xDF, 0x04          ; 00003649  jmp 0x3b2b
  db 0xE9, 0xEE, 0x04          ; 0000364C  jmp 0x3b3d
  db 0xF6, 0x47, 0x1B, 0x08    ; 0000364F  test byte [bx+0x1b],0x8
  db 0x74, 0x13                ; 00003653  jz 0x3668
  db 0x8A, 0x47, 0x1C          ; 00003655  mov al,[bx+0x1c]
  db 0xE8, 0x61, 0x00          ; 00003658  call 0x36bc
  db 0x80, 0x67, 0x1B, 0xF7    ; 0000365B  and byte [bx+0x1b],0xf7
  db 0x53                      ; 0000365F  push bx
  db 0x8B, 0x57, 0x18          ; 00003660  mov dx,[bx+0x18]
  db 0xE8, 0xBA, 0xCA          ; 00003663  call 0x120
  db 0x5B                      ; 00003666  pop bx
  db 0xC3                      ; 00003667  ret
  db 0xF6, 0x47, 0x1B, 0x10    ; 00003668  test byte [bx+0x1b],0x10
  db 0x74, 0x0A                ; 0000366C  jz 0x3678
  db 0xB0, 0x13                ; 0000366E  mov al,0x13
  db 0xE8, 0x49, 0x00          ; 00003670  call 0x36bc
  db 0x80, 0x67, 0x1B, 0xEF    ; 00003673  and byte [bx+0x1b],0xef
  db 0xC3                      ; 00003677  ret
  db 0xF6, 0x47, 0x1B, 0x20    ; 00003678  test byte [bx+0x1b],0x20
  db 0x74, 0x0A                ; 0000367C  jz 0x3688
  db 0xB0, 0x11                ; 0000367E  mov al,0x11
  db 0xE8, 0x39, 0x00          ; 00003680  call 0x36bc
  db 0x80, 0x67, 0x1B, 0xDF    ; 00003683  and byte [bx+0x1b],0xdf
  db 0xC3                      ; 00003687  ret
  db 0xF6, 0x47, 0x1B, 0x02    ; 00003688  test byte [bx+0x1b],0x2
  db 0x74, 0x05                ; 0000368C  jz 0x3693
  db 0x80, 0x4F, 0x1B, 0x01    ; 0000368E  or byte [bx+0x1b],0x1
  db 0xC3                      ; 00003692  ret
  db 0x8B, 0x47, 0x12          ; 00003693  mov ax,[bx+0x12]
  db 0x3B, 0x47, 0x0C          ; 00003696  cmp ax,[bx+0xc]
  db 0x75, 0x05                ; 00003699  jnz 0x36a0
  db 0x80, 0x4F, 0x1B, 0x01    ; 0000369B  or byte [bx+0x1b],0x1
  db 0xC3                      ; 0000369F  ret
  db 0x8B, 0x77, 0x0E          ; 000036A0  mov si,[bx+0xe]
  db 0x06                      ; 000036A3  push es
  db 0x8E, 0x47, 0x0A          ; 000036A4  mov es,[bx+0xa]
  db 0x26, 0x8A, 0x04          ; 000036A7  mov al,[es:si]
  db 0x07                      ; 000036AA  pop es
  db 0xFF, 0x47, 0x0E          ; 000036AB  inc word [bx+0xe]
  db 0x8B, 0x57, 0x0C          ; 000036AE  mov dx,[bx+0xc]
  db 0x4A                      ; 000036B1  dec dx
  db 0x21, 0x57, 0x0E          ; 000036B2  and [bx+0xe],dx
  db 0xFF, 0x47, 0x12          ; 000036B5  inc word [bx+0x12]
  db 0xE8, 0x01, 0x00          ; 000036B8  call 0x36bc
  db 0xC3                      ; 000036BB  ret
  db 0x8B, 0x57, 0x23          ; 000036BC  mov dx,[bx+0x23]
  db 0xEE                      ; 000036BF  out dx,al
  db 0x80, 0x67, 0x1B, 0xFE    ; 000036C0  and byte [bx+0x1b],0xfe
  db 0xC3                      ; 000036C4  ret
  db 0xE8, 0x42, 0x04          ; 000036C5  call 0x3b0a
  db 0xBB, 0xBC, 0x43          ; 000036C8  mov bx,0x43bc
  db 0xE9, 0x06, 0x00          ; 000036CB  jmp 0x36d4
  db 0xE8, 0x39, 0x04          ; 000036CE  call 0x3b0a
  db 0xBB, 0xE5, 0x43          ; 000036D1  mov bx,0x43e5
  db 0x8B, 0x57, 0x27          ; 000036D4  mov dx,[bx+0x27]
  db 0xEC                      ; 000036D7  in al,dx
  db 0x88, 0x47, 0x1E          ; 000036D8  mov [bx+0x1e],al
  db 0xB0, 0x10                ; 000036DB  mov al,0x10
  db 0xEE                      ; 000036DD  out dx,al
  db 0xE8, 0xC1, 0x00          ; 000036DE  call 0x37a2
  db 0xE9, 0x59, 0x04          ; 000036E1  jmp 0x3b3d
  db 0xE8, 0x23, 0x04          ; 000036E4  call 0x3b0a
  db 0xBB, 0xBC, 0x43          ; 000036E7  mov bx,0x43bc
  db 0xE9, 0x06, 0x00          ; 000036EA  jmp 0x36f3
  db 0xE8, 0x1A, 0x04          ; 000036ED  call 0x3b0a
  db 0xBB, 0xE5, 0x43          ; 000036F0  mov bx,0x43e5
  db 0x8B, 0x57, 0x23          ; 000036F3  mov dx,[bx+0x23]
  db 0xEC                      ; 000036F6  in al,dx
  db 0x50                      ; 000036F7  push ax
  db 0xE8, 0xA7, 0x00          ; 000036F8  call 0x37a2
  db 0x58                      ; 000036FB  pop ax
  db 0x80, 0x7F, 0x1D, 0x01    ; 000036FC  cmp byte [bx+0x1d],0x1
  db 0x75, 0x48                ; 00003700  jnz 0x374a
  db 0x50                      ; 00003702  push ax
  db 0x25, 0x7F, 0x00          ; 00003703  and ax,0x7f
  db 0x3C, 0x13                ; 00003706  cmp al,0x13
  db 0x58                      ; 00003708  pop ax
  db 0x75, 0x07                ; 00003709  jnz 0x3712
  db 0x80, 0x4F, 0x1B, 0x02    ; 0000370B  or byte [bx+0x1b],0x2
  db 0xE9, 0x2B, 0x04          ; 0000370F  jmp 0x3b3d
  db 0x3C, 0x11                ; 00003712  cmp al,0x11
  db 0x75, 0x15                ; 00003714  jnz 0x372b
  db 0xF6, 0x47, 0x1B, 0x02    ; 00003716  test byte [bx+0x1b],0x2
  db 0x74, 0xF3                ; 0000371A  jz 0x370f
  db 0x80, 0x67, 0x1B, 0xFD    ; 0000371C  and byte [bx+0x1b],0xfd
  db 0xF6, 0x47, 0x1B, 0x01    ; 00003720  test byte [bx+0x1b],0x1
  db 0x74, 0xE9                ; 00003724  jz 0x370f
  db 0xE8, 0x26, 0xFF          ; 00003726  call 0x364f
  db 0xEB, 0xE4                ; 00003729  jmp short 0x370f
  db 0x83, 0x7F, 0x08, 0x21    ; 0000372B  cmp word [bx+0x8],byte +0x21
  db 0x75, 0x19                ; 0000372F  jnz 0x374a
  db 0x80, 0x4F, 0x1B, 0x10    ; 00003731  or byte [bx+0x1b],0x10
  db 0xF6, 0x47, 0x1B, 0x01    ; 00003735  test byte [bx+0x1b],0x1
  db 0x74, 0x0F                ; 00003739  jz 0x374a
  db 0x50                      ; 0000373B  push ax
  db 0x52                      ; 0000373C  push dx
  db 0xBA, 0x02, 0x03          ; 0000373D  mov dx,0x302
  db 0xEC                      ; 00003740  in al,dx
  db 0x24, 0x01                ; 00003741  and al,0x1
  db 0x74, 0xFB                ; 00003743  jz 0x3740
  db 0x5A                      ; 00003745  pop dx
  db 0xE8, 0x06, 0xFF          ; 00003746  call 0x364f
  db 0x58                      ; 00003749  pop ax
  db 0x83, 0x7F, 0x08, 0x00    ; 0000374A  cmp word [bx+0x8],byte +0x0
  db 0x77, 0x07                ; 0000374E  ja 0x3757
  db 0x2E, 0xFE, 0x06, 0xB1, 0x10 ; 00003750  inc byte [cs:0x10b1]
  db 0xEB, 0xB8                ; 00003755  jmp short 0x370f
  db 0x8B, 0x77, 0x06          ; 00003757  mov si,[bx+0x6]
  db 0x06                      ; 0000375A  push es
  db 0x8E, 0x07                ; 0000375B  mov es,[bx]
  db 0x26, 0x88, 0x04          ; 0000375D  mov [es:si],al
  db 0x07                      ; 00003760  pop es
  db 0xFF, 0x47, 0x06          ; 00003761  inc word [bx+0x6]
  db 0x8B, 0x47, 0x02          ; 00003764  mov ax,[bx+0x2]
  db 0x48                      ; 00003767  dec ax
  db 0x21, 0x47, 0x06          ; 00003768  and [bx+0x6],ax
  db 0xFF, 0x4F, 0x08          ; 0000376B  dec word [bx+0x8]
  db 0xF6, 0x47, 0x1A, 0x04    ; 0000376E  test byte [bx+0x1a],0x4
  db 0x74, 0x9B                ; 00003772  jz 0x370f
  db 0x8B, 0x57, 0x14          ; 00003774  mov dx,[bx+0x14]
  db 0x53                      ; 00003777  push bx
  db 0xE8, 0xA5, 0xC9          ; 00003778  call 0x120
  db 0x5B                      ; 0000377B  pop bx
  db 0x80, 0x67, 0x1A, 0xFB    ; 0000377C  and byte [bx+0x1a],0xfb
  db 0xE9, 0xA8, 0x03          ; 00003780  jmp 0x3b2b
  db 0xE8, 0x84, 0x03          ; 00003783  call 0x3b0a
  db 0xBB, 0xBC, 0x43          ; 00003786  mov bx,0x43bc
  db 0xE9, 0x06, 0x00          ; 00003789  jmp 0x3792
  db 0xE8, 0x7B, 0x03          ; 0000378C  call 0x3b0a
  db 0xBB, 0xE5, 0x43          ; 0000378F  mov bx,0x43e5
  db 0x8B, 0x57, 0x25          ; 00003792  mov dx,[bx+0x25]
  db 0xB0, 0x01                ; 00003795  mov al,0x1
  db 0xEE                      ; 00003797  out dx,al
  db 0xEC                      ; 00003798  in al,dx
  db 0x88, 0x47, 0x1F          ; 00003799  mov [bx+0x1f],al
  db 0xB0, 0x30                ; 0000379C  mov al,0x30
  db 0xEE                      ; 0000379E  out dx,al
  db 0xE9, 0x3C, 0xFF          ; 0000379F  jmp 0x36de
  db 0xBA, 0x22, 0xFF          ; 000037A2  mov dx,0xff22
  db 0xB8, 0x00, 0x80          ; 000037A5  mov ax,0x8000
  db 0xEF                      ; 000037A8  out dx,ax
  db 0xC3                      ; 000037A9  ret
  db 0xBA, 0x02, 0x00          ; 000037AA  mov dx,0x2
  db 0xBB, 0xE5, 0x43          ; 000037AD  mov bx,0x43e5
  db 0xC3                      ; 000037B0  ret
  db 0xBB, 0xE5, 0x43          ; 000037B1  mov bx,0x43e5
  db 0x88, 0x57, 0x1D          ; 000037B4  mov [bx+0x1d],dl
  db 0xC3                      ; 000037B7  ret
  db 0xBC, 0x43, 0xE5          ; 000037B8  mov sp,0xe543
  db 0x43                      ; 000037BB  inc bx
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
  db 0x0D, 0x00, 0x0E          ; 000037D0  or ax,0xe00
  db 0x00, 0x11                ; 000037D3  add [bx+di],dl
  db 0x00, 0x01                ; 000037D5  add [bx+di],al
  db 0x01, 0x00                ; 000037D7  add [bx+si],ax
  db 0x00, 0x00                ; 000037D9  add [bx+si],al
  db 0x00, 0x7F, 0x14          ; 000037DB  add [bx+0x14],bh
  db 0x00, 0xFE                ; 000037DE  add dh,bh
  db 0x02, 0x00                ; 000037E0  add al,[bx+si]
  db 0x03, 0x00                ; 000037E2  add ax,[bx+si]
  db 0x03, 0x00                ; 000037E4  add ax,[bx+si]
  db 0x00, 0x00                ; 000037E6  add [bx+si],al
  db 0x00, 0x00                ; 000037E8  add [bx+si],al
  db 0x00, 0x00                ; 000037EA  add [bx+si],al
  db 0x00, 0x00                ; 000037EC  add [bx+si],al
  db 0x00, 0x00                ; 000037EE  add [bx+si],al
  db 0x00, 0x00                ; 000037F0  add [bx+si],al
  db 0x00, 0x00                ; 000037F2  add [bx+si],al
  db 0x00, 0x00                ; 000037F4  add [bx+si],al
  db 0x00, 0x00                ; 000037F6  add [bx+si],al
  db 0x00, 0x0D                ; 000037F8  add [di],cl
  db 0x00, 0x0E, 0x00, 0x11    ; 000037FA  add [0x1100],cl
  db 0x00, 0x01                ; 000037FE  add [bx+di],al
  db 0x01, 0x00                ; 00003800  add [bx+si],ax
  db 0x00, 0x00                ; 00003802  add [bx+si],al
  db 0x00, 0x7F, 0x14          ; 00003804  add [bx+0x14],bh
  db 0x00, 0x00                ; 00003807  add [bx+si],al
  db 0x03, 0x02                ; 00003809  add ax,[bp+si]
  db 0x03, 0x02                ; 0000380B  add ax,[bp+si]
  db 0x03, 0x80, 0xFA, 0x02    ; 0000380D  add ax,[bx+si+0x2fa]
  db 0x75, 0x1B                ; 00003811  jnz 0x382e
  db 0x52                      ; 00003813  push dx
  db 0xBA, 0x92, 0x02          ; 00003814  mov dx,0x292
  db 0xB0, 0xFF                ; 00003817  mov al,0xff
  db 0xEE                      ; 00003819  out dx,al
  db 0xEC                      ; 0000381A  in al,dx
  db 0x24, 0x80                ; 0000381B  and al,0x80
  db 0x5A                      ; 0000381D  pop dx
  db 0x75, 0x07                ; 0000381E  jnz 0x3827
  db 0xB0, 0xFF                ; 00003820  mov al,0xff
  db 0x8A, 0xD8                ; 00003822  mov bl,al
  db 0xE9, 0x24, 0x00          ; 00003824  jmp 0x384b
  db 0xB0, 0x00                ; 00003827  mov al,0x0
  db 0x8A, 0xD8                ; 00003829  mov bl,al
  db 0xE9, 0x1D, 0x00          ; 0000382B  jmp 0x384b
  db 0x80, 0xFA, 0x01          ; 0000382E  cmp dl,0x1
  db 0x75, 0x18                ; 00003831  jnz 0x384b
  db 0x52                      ; 00003833  push dx
  db 0xBA, 0x8E, 0x02          ; 00003834  mov dx,0x28e
  db 0xB0, 0xFF                ; 00003837  mov al,0xff
  db 0xEE                      ; 00003839  out dx,al
  db 0xEC                      ; 0000383A  in al,dx
  db 0x24, 0x80                ; 0000383B  and al,0x80
  db 0x5A                      ; 0000383D  pop dx
  db 0x75, 0x07                ; 0000383E  jnz 0x3847
  db 0xB0, 0xFF                ; 00003840  mov al,0xff
  db 0x8A, 0xD8                ; 00003842  mov bl,al
  db 0xE9, 0x04, 0x00          ; 00003844  jmp 0x384b
  db 0xB0, 0x00                ; 00003847  mov al,0x0
  db 0x8A, 0xD8                ; 00003849  mov bl,al
  db 0xC3                      ; 0000384B  ret
  db 0x51                      ; 0000384C  push cx
  db 0x52                      ; 0000384D  push dx
  db 0xE8, 0xCC, 0x00          ; 0000384E  call 0x391d
  db 0x5A                      ; 00003851  pop dx
  db 0x59                      ; 00003852  pop cx
  db 0x0B, 0xC0                ; 00003853  or ax,ax
  db 0x75, 0x3A                ; 00003855  jnz 0x3891
  db 0x1E                      ; 00003857  push ds
  db 0x06                      ; 00003858  push es
  db 0x51                      ; 00003859  push cx
  db 0x52                      ; 0000385A  push dx
  db 0x0E                      ; 0000385B  push cs
  db 0x1F                      ; 0000385C  pop ds
  db 0x2E, 0x8B, 0x36, 0x68, 0x00 ; 0000385D  mov si,[cs:0x68]
  db 0x8E, 0x44, 0x10          ; 00003862  mov es,[si+0x10]
  db 0xBE, 0x70, 0x4D          ; 00003865  mov si,0x4d70
  db 0xE8, 0x30, 0xDE          ; 00003868  call 0x169b
  db 0x5A                      ; 0000386B  pop dx
  db 0x59                      ; 0000386C  pop cx
  db 0x07                      ; 0000386D  pop es
  db 0x1F                      ; 0000386E  pop ds
  db 0x3C, 0x31                ; 0000386F  cmp al,0x31
  db 0x74, 0xD9                ; 00003871  jz 0x384c
  db 0x3C, 0x32                ; 00003873  cmp al,0x32
  db 0x75, 0x15                ; 00003875  jnz 0x388c
  db 0x1E                      ; 00003877  push ds
  db 0x06                      ; 00003878  push es
  db 0x0E                      ; 00003879  push cs
  db 0x1F                      ; 0000387A  pop ds
  db 0x2E, 0x8B, 0x1E, 0x68, 0x00 ; 0000387B  mov bx,[cs:0x68]
  db 0x8E, 0x47, 0x10          ; 00003880  mov es,[bx+0x10]
  db 0xB9, 0x8F, 0x00          ; 00003883  mov cx,0x8f
  db 0xE8, 0xAA, 0xC8          ; 00003886  call 0x133
  db 0x07                      ; 00003889  pop es
  db 0x1F                      ; 0000388A  pop ds
  db 0xC3                      ; 0000388B  ret
  db 0x3C, 0x33                ; 0000388C  cmp al,0x33
  db 0x75, 0xBC                ; 0000388E  jnz 0x384c
  db 0xC3                      ; 00003890  ret
  db 0x80, 0xFA, 0x00          ; 00003891  cmp dl,0x0
  db 0x74, 0x69                ; 00003894  jz 0x38ff
  db 0x80, 0xFA, 0x02          ; 00003896  cmp dl,0x2
  db 0x75, 0x4E                ; 00003899  jnz 0x38e9
  db 0xFA                      ; 0000389B  cli
  db 0x2E, 0x80, 0x3E, 0x95, 0x6C, 0xFF ; 0000389C  cmp byte [cs:0x6c95],0xff
  db 0x2E, 0xC6, 0x06, 0x96, 0x6C, 0x0A ; 000038A2  mov byte [cs:0x6c96],0xa
  db 0xFB                      ; 000038A8  sti
  db 0x74, 0x05                ; 000038A9  jz 0x38b0
  db 0x51                      ; 000038AB  push cx
  db 0xE8, 0x24, 0x28          ; 000038AC  call 0x60d3
  db 0x59                      ; 000038AF  pop cx
  db 0xBA, 0x8C, 0x02          ; 000038B0  mov dx,0x28c
  db 0xB0, 0x08                ; 000038B3  mov al,0x8
  db 0xEE                      ; 000038B5  out dx,al
  db 0xBA, 0x19, 0x00          ; 000038B6  mov dx,0x19
  db 0x51                      ; 000038B9  push cx
  db 0xE8, 0x74, 0xC8          ; 000038BA  call 0x131
  db 0x59                      ; 000038BD  pop cx
  db 0x8A, 0xC1                ; 000038BE  mov al,cl
  db 0xBA, 0x8A, 0x02          ; 000038C0  mov dx,0x28a
  db 0xEE                      ; 000038C3  out dx,al
  db 0xB0, 0x89                ; 000038C4  mov al,0x89
  db 0xBA, 0x8C, 0x02          ; 000038C6  mov dx,0x28c
  db 0xEE                      ; 000038C9  out dx,al
  db 0xB0, 0x88                ; 000038CA  mov al,0x88
  db 0xEE                      ; 000038CC  out dx,al
  db 0xFA                      ; 000038CD  cli
  db 0x1E                      ; 000038CE  push ds
  db 0x2E, 0x8E, 0x1E, 0x06, 0x0C ; 000038CF  mov ds,[cs:0xc06]
  db 0xBB, 0xE3, 0x45          ; 000038D4  mov bx,0x45e3
  db 0x8A, 0x47, 0x14          ; 000038D7  mov al,[bx+0x14]
  db 0x3C, 0x05                ; 000038DA  cmp al,0x5
  db 0x73, 0x02                ; 000038DC  jnc 0x38e0
  db 0xB0, 0x05                ; 000038DE  mov al,0x5
  db 0x2E, 0xA2, 0x96, 0x6C    ; 000038E0  mov [cs:0x6c96],al
  db 0x1F                      ; 000038E4  pop ds
  db 0xFB                      ; 000038E5  sti
  db 0xE9, 0x33, 0x00          ; 000038E6  jmp 0x391c
  db 0x80, 0xFA, 0x01          ; 000038E9  cmp dl,0x1
  db 0x75, 0x2E                ; 000038EC  jnz 0x391c
  db 0xBB, 0xE3, 0x45          ; 000038EE  mov bx,0x45e3
  db 0x8A, 0x47, 0x0D          ; 000038F1  mov al,[bx+0xd]
  db 0x24, 0x0F                ; 000038F4  and al,0xf
  db 0x3C, 0x01                ; 000038F6  cmp al,0x1
  db 0x75, 0x22                ; 000038F8  jnz 0x391c
  db 0xB2, 0x05                ; 000038FA  mov dl,0x5
  db 0xE9, 0xB0, 0xFC          ; 000038FC  jmp 0x35af
  db 0xBA, 0x60, 0x02          ; 000038FF  mov dx,0x260
  db 0xB0, 0x08                ; 00003902  mov al,0x8
  db 0xEE                      ; 00003904  out dx,al
  db 0xBA, 0x0C, 0x00          ; 00003905  mov dx,0xc
  db 0x51                      ; 00003908  push cx
  db 0xE8, 0x25, 0xC8          ; 00003909  call 0x131
  db 0x59                      ; 0000390C  pop cx
  db 0x8A, 0xC1                ; 0000390D  mov al,cl
  db 0xBA, 0x50, 0x02          ; 0000390F  mov dx,0x250
  db 0xEE                      ; 00003912  out dx,al
  db 0xB0, 0x89                ; 00003913  mov al,0x89
  db 0xBA, 0x60, 0x02          ; 00003915  mov dx,0x260
  db 0xEE                      ; 00003918  out dx,al
  db 0xB0, 0x88                ; 00003919  mov al,0x88
  db 0xEE                      ; 0000391B  out dx,al
  db 0xC3                      ; 0000391C  ret
  db 0x80, 0xFA, 0x00          ; 0000391D  cmp dl,0x0
  db 0x74, 0x46                ; 00003920  jz 0x3968
  db 0x80, 0xFA, 0x02          ; 00003922  cmp dl,0x2
  db 0x75, 0x39                ; 00003925  jnz 0x3960
  db 0x2E, 0x80, 0x3E, 0x95, 0x6C, 0xFF ; 00003927  cmp byte [cs:0x6c95],0xff
  db 0x74, 0x22                ; 0000392D  jz 0x3951
  db 0x2E, 0xC6, 0x06, 0x9A, 0x6C, 0xFF ; 0000392F  mov byte [cs:0x6c9a],0xff
  db 0xE8, 0x9B, 0x27          ; 00003935  call 0x60d3
  db 0xFA                      ; 00003938  cli
  db 0x1E                      ; 00003939  push ds
  db 0x2E, 0x8E, 0x1E, 0x06, 0x0C ; 0000393A  mov ds,[cs:0xc06]
  db 0xBB, 0xE3, 0x45          ; 0000393F  mov bx,0x45e3
  db 0x8A, 0x47, 0x14          ; 00003942  mov al,[bx+0x14]
  db 0x3C, 0x05                ; 00003945  cmp al,0x5
  db 0x73, 0x02                ; 00003947  jnc 0x394b
  db 0xB0, 0x05                ; 00003949  mov al,0x5
  db 0x2E, 0xA2, 0x96, 0x6C    ; 0000394B  mov [cs:0x6c96],al
  db 0x1F                      ; 0000394F  pop ds
  db 0xFB                      ; 00003950  sti
  db 0xBA, 0x8C, 0x02          ; 00003951  mov dx,0x28c
  db 0xEC                      ; 00003954  in al,dx
  db 0xA8, 0x10                ; 00003955  test al,0x10
  db 0x75, 0x1F                ; 00003957  jnz 0x3978
  db 0xA8, 0x08                ; 00003959  test al,0x8
  db 0x74, 0x1B                ; 0000395B  jz 0x3978
  db 0xE9, 0x14, 0x00          ; 0000395D  jmp 0x3974
  db 0x80, 0xFA, 0x01          ; 00003960  cmp dl,0x1
  db 0x75, 0x13                ; 00003963  jnz 0x3978
  db 0xE9, 0x13, 0x00          ; 00003965  jmp 0x397b
  db 0xBA, 0x60, 0x02          ; 00003968  mov dx,0x260
  db 0xEC                      ; 0000396B  in al,dx
  db 0xA8, 0x10                ; 0000396C  test al,0x10
  db 0x75, 0x08                ; 0000396E  jnz 0x3978
  db 0xA8, 0x08                ; 00003970  test al,0x8
  db 0x74, 0x04                ; 00003972  jz 0x3978
  db 0xB8, 0xFF, 0xFF          ; 00003974  mov ax,0xffff
  db 0xC3                      ; 00003977  ret
  db 0x33, 0xC0                ; 00003978  xor ax,ax
  db 0xC3                      ; 0000397A  ret
  db 0xBA, 0x02, 0x03          ; 0000397B  mov dx,0x302
  db 0xEC                      ; 0000397E  in al,dx
  db 0xA8, 0x80                ; 0000397F  test al,0x80
  db 0xB8, 0xFF, 0xFF          ; 00003981  mov ax,0xffff
  db 0x75, 0x01                ; 00003984  jnz 0x3987
  db 0x40                      ; 00003986  inc ax
  db 0xC3                      ; 00003987  ret
  db 0xE8, 0x7F, 0x01          ; 00003988  call 0x3b0a
  db 0xB0, 0x80                ; 0000398B  mov al,0x80
  db 0xBA, 0x60, 0x02          ; 0000398D  mov dx,0x260
  db 0xEE                      ; 00003990  out dx,al
  db 0xE8, 0x6A, 0x01          ; 00003991  call 0x3afe
  db 0xBA, 0x0C, 0x00          ; 00003994  mov dx,0xc
  db 0xE8, 0x86, 0xC7          ; 00003997  call 0x120
  db 0xE9, 0x8E, 0x01          ; 0000399A  jmp 0x3b2b
  db 0xE8, 0x6A, 0x01          ; 0000399D  call 0x3b0a
  db 0xB0, 0x80                ; 000039A0  mov al,0x80
  db 0xBA, 0x8C, 0x02          ; 000039A2  mov dx,0x28c
  db 0xEE                      ; 000039A5  out dx,al
  db 0xE8, 0x55, 0x01          ; 000039A6  call 0x3afe
  db 0xBA, 0x19, 0x00          ; 000039A9  mov dx,0x19
  db 0xE8, 0x71, 0xC7          ; 000039AC  call 0x120
  db 0xE9, 0x79, 0x01          ; 000039AF  jmp 0x3b2b
  db 0x00, 0x00                ; 000039B2  add [bx+si],al
  db 0x04, 0x00                ; 000039B4  add al,0x0
  db 0x00, 0x80, 0x04, 0x00    ; 000039B6  add [bx+si+0x4],al
  db 0x00, 0x00                ; 000039BA  add [bx+si],al
  db 0x00, 0x00                ; 000039BC  add [bx+si],al
  db 0x00, 0x00                ; 000039BE  add [bx+si],al
  db 0x00, 0x00                ; 000039C0  add [bx+si],al
  db 0x00, 0x00                ; 000039C2  add [bx+si],al
  db 0x00, 0x01                ; 000039C4  add [bx+di],al
  db 0x01, 0x00                ; 000039C6  add [bx+si],ax
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
  db 0x66, 0x00, 0x47, 0xAA    ; 000039EA  o32 add [bx-0x56],al
  db 0x17                      ; 000039EE  pop ss
  db 0x61                      ; 000039EF  popa
  db 0x60                      ; 000039F0  pusha
  db 0x47                      ; 000039F1  inc di
  db 0xAA                      ; 000039F2  stosb
  db 0x17                      ; 000039F3  pop ss
  db 0x61                      ; 000039F4  popa
  db 0x10, 0xA1, 0x3C, 0x00    ; 000039F5  adc [bx+di+0x3c],ah
  db 0x00, 0x00                ; 000039F9  add [bx+si],al
  db 0x00, 0x00                ; 000039FB  add [bx+si],al
  db 0x02, 0x00                ; 000039FD  add al,[bx+si]
  db 0xFF, 0x00                ; 000039FF  inc word [bx+si]
  db 0x00, 0x00                ; 00003A01  add [bx+si],al
  db 0x00, 0x00                ; 00003A03  add [bx+si],al
  db 0x00, 0x00                ; 00003A05  add [bx+si],al
  db 0x00, 0x00                ; 00003A07  add [bx+si],al
  db 0x00, 0x00                ; 00003A09  add [bx+si],al
  db 0x00, 0x00                ; 00003A0B  add [bx+si],al
  db 0x00, 0x00                ; 00003A0D  add [bx+si],al
  db 0x00, 0x00                ; 00003A0F  add [bx+si],al
  db 0x00, 0x00                ; 00003A11  add [bx+si],al
  db 0x00, 0x00                ; 00003A13  add [bx+si],al
  db 0x00, 0x00                ; 00003A15  add [bx+si],al
  db 0x00, 0x00                ; 00003A17  add [bx+si],al
  db 0x00, 0x00                ; 00003A19  add [bx+si],al
  db 0x00, 0x00                ; 00003A1B  add [bx+si],al
  db 0x00, 0x00                ; 00003A1D  add [bx+si],al
  db 0x00, 0x00                ; 00003A1F  add [bx+si],al
  db 0x00, 0x00                ; 00003A21  add [bx+si],al
  db 0x00, 0x00                ; 00003A23  add [bx+si],al
  db 0x00, 0x00                ; 00003A25  add [bx+si],al
  db 0x00, 0x00                ; 00003A27  add [bx+si],al
  db 0x00, 0x00                ; 00003A29  add [bx+si],al
  db 0x00, 0x00                ; 00003A2B  add [bx+si],al
  db 0x00, 0x00                ; 00003A2D  add [bx+si],al
  db 0x00, 0x00                ; 00003A2F  add [bx+si],al
  db 0x00, 0x00                ; 00003A31  add [bx+si],al
  db 0x00, 0x00                ; 00003A33  add [bx+si],al
  db 0x00, 0x00                ; 00003A35  add [bx+si],al
  db 0x00, 0x00                ; 00003A37  add [bx+si],al
  db 0x00, 0x00                ; 00003A39  add [bx+si],al
  db 0x00, 0x00                ; 00003A3B  add [bx+si],al
  db 0x00, 0x00                ; 00003A3D  add [bx+si],al
  db 0x00, 0x00                ; 00003A3F  add [bx+si],al
  db 0x00, 0x00                ; 00003A41  add [bx+si],al
  db 0x00, 0x00                ; 00003A43  add [bx+si],al
  db 0x00, 0x00                ; 00003A45  add [bx+si],al
  db 0x00, 0x00                ; 00003A47  add [bx+si],al
  db 0x00, 0x00                ; 00003A49  add [bx+si],al
  db 0x00, 0x00                ; 00003A4B  add [bx+si],al
  db 0x00, 0x00                ; 00003A4D  add [bx+si],al
  db 0x00, 0x00                ; 00003A4F  add [bx+si],al
  db 0x00, 0x00                ; 00003A51  add [bx+si],al
  db 0x00, 0x00                ; 00003A53  add [bx+si],al
  db 0x00, 0x00                ; 00003A55  add [bx+si],al
  db 0x00, 0x00                ; 00003A57  add [bx+si],al
  db 0x00, 0x00                ; 00003A59  add [bx+si],al
  db 0x00, 0x00                ; 00003A5B  add [bx+si],al
  db 0x00, 0x00                ; 00003A5D  add [bx+si],al
  db 0x00, 0x00                ; 00003A5F  add [bx+si],al
  db 0x00, 0x00                ; 00003A61  add [bx+si],al
  db 0x2E, 0x8E, 0x06, 0x06, 0x0C ; 00003A63  mov es,[cs:0xc06]
  db 0xBE, 0xE3, 0x45          ; 00003A68  mov si,0x45e3
  db 0xC3                      ; 00003A6B  ret
  db 0x2E, 0x8E, 0x06, 0x06, 0x0C ; 00003A6C  mov es,[cs:0xc06]
  db 0xBE, 0xB2, 0x45          ; 00003A71  mov si,0x45b2
  db 0xC3                      ; 00003A74  ret
  db 0x9C                      ; 00003A75  pushf
  db 0xFA                      ; 00003A76  cli
  db 0x2E, 0x89, 0x16, 0xB2, 0x46 ; 00003A77  mov [cs:0x46b2],dx
  db 0x2E, 0x89, 0x0E, 0xB4, 0x46 ; 00003A7C  mov [cs:0x46b4],cx
  db 0x9D                      ; 00003A81  popf
  db 0xC3                      ; 00003A82  ret
  db 0x9C                      ; 00003A83  pushf
  db 0xFA                      ; 00003A84  cli
  db 0xB8, 0xB1, 0x46          ; 00003A85  mov ax,0x46b1
  db 0x2E, 0xA3, 0xB2, 0x46    ; 00003A88  mov [cs:0x46b2],ax
  db 0x2E, 0x8C, 0x0E, 0xB4, 0x46 ; 00003A8C  mov [cs:0x46b4],cs
  db 0x9D                      ; 00003A91  popf
  db 0xC3                      ; 00003A92  ret
  db 0x9C                      ; 00003A93  pushf
  db 0xFA                      ; 00003A94  cli
  db 0x2E, 0x89, 0x16, 0xB6, 0x46 ; 00003A95  mov [cs:0x46b6],dx
  db 0x2E, 0x89, 0x0E, 0xB8, 0x46 ; 00003A9A  mov [cs:0x46b8],cx
  db 0x9D                      ; 00003A9F  popf
  db 0xC3                      ; 00003AA0  ret
  db 0x9C                      ; 00003AA1  pushf
  db 0xFA                      ; 00003AA2  cli
  db 0xB8, 0xB1, 0x46          ; 00003AA3  mov ax,0x46b1
  db 0x2E, 0xA3, 0xB6, 0x46    ; 00003AA6  mov [cs:0x46b6],ax
  db 0x2E, 0x8C, 0x0E, 0xB8, 0x46 ; 00003AAA  mov [cs:0x46b8],cs
  db 0x9D                      ; 00003AAF  popf
  db 0xC3                      ; 00003AB0  ret
  db 0xCB                      ; 00003AB1  retf
  db 0xB1, 0x46                ; 00003AB2  mov cl,0x46
  db 0x00, 0x00                ; 00003AB4  add [bx+si],al
  db 0xB1, 0x46                ; 00003AB6  mov cl,0x46
  db 0x00, 0x00                ; 00003AB8  add [bx+si],al
  db 0xE8, 0x4D, 0x00          ; 00003ABA  call 0x3b0a
  db 0x2E, 0xFF, 0x06, 0xB3, 0x47 ; 00003ABD  inc word [cs:0x47b3]
  db 0x75, 0x05                ; 00003AC2  jnz 0x3ac9
  db 0x2E, 0xFF, 0x06, 0xB5, 0x47 ; 00003AC4  inc word [cs:0x47b5]
  db 0x2E, 0xC6, 0x06, 0xB3, 0x10, 0x00 ; 00003AC9  mov byte [cs:0x10b3],0x0
  db 0xE8, 0xD9, 0xE4          ; 00003ACF  call 0x1fab
  db 0xE8, 0x7A, 0xEE          ; 00003AD2  call 0x294f
  db 0xE8, 0xDD, 0xEE          ; 00003AD5  call 0x29b5
  db 0xE8, 0x16, 0x27          ; 00003AD8  call 0x61f1
  db 0xBB, 0xB2, 0x45          ; 00003ADB  mov bx,0x45b2
  db 0x80, 0x7F, 0x0C, 0xFF    ; 00003ADE  cmp byte [bx+0xc],0xff
  db 0x74, 0x07                ; 00003AE2  jz 0x3aeb
  db 0xB0, 0x10                ; 00003AE4  mov al,0x10
  db 0xE8, 0xEA, 0x00          ; 00003AE6  call 0x3bd3
  db 0xEB, 0x07                ; 00003AE9  jmp short 0x3af2
  db 0xB0, 0x07                ; 00003AEB  mov al,0x7
  db 0xB4, 0xC4                ; 00003AED  mov ah,0xc4
  db 0xE8, 0xC5, 0x00          ; 00003AEF  call 0x3bb7
  db 0xE8, 0x09, 0x00          ; 00003AF2  call 0x3afe
  db 0xBA, 0x02, 0x00          ; 00003AF5  mov dx,0x2
  db 0xE8, 0x25, 0xC6          ; 00003AF8  call 0x120
  db 0xE9, 0x3F, 0x00          ; 00003AFB  jmp 0x3b3d
  db 0xB0, 0x20                ; 00003AFE  mov al,0x20
  db 0xE6, 0x00                ; 00003B00  out 0x0,al
  db 0xBA, 0x22, 0xFF          ; 00003B02  mov dx,0xff22
  db 0xB8, 0x00, 0x80          ; 00003B05  mov ax,0x8000
  db 0xEF                      ; 00003B08  out dx,ax
  db 0xC3                      ; 00003B09  ret
  db 0x2E, 0x8F, 0x06, 0xB1, 0x47 ; 00003B0A  pop word [cs:0x47b1]
  db 0x2E, 0x8C, 0x16, 0xAD, 0x47 ; 00003B0F  mov [cs:0x47ad],ss
  db 0x2E, 0x89, 0x26, 0xAF, 0x47 ; 00003B14  mov [cs:0x47af],sp
  db 0x0E                      ; 00003B19  push cs
  db 0x17                      ; 00003B1A  pop ss
  db 0xBC, 0xAB, 0x47          ; 00003B1B  mov sp,0x47ab
  db 0x1E                      ; 00003B1E  push ds
  db 0x06                      ; 00003B1F  push es
  db 0x60                      ; 00003B20  pusha
  db 0x2E, 0x8E, 0x1E, 0x06, 0x0C ; 00003B21  mov ds,[cs:0xc06]
  db 0x2E, 0xFF, 0x26, 0xB1, 0x47 ; 00003B26  jmp [cs:0x47b1]
  db 0x61                      ; 00003B2B  popa
  db 0x07                      ; 00003B2C  pop es
  db 0x1F                      ; 00003B2D  pop ds
  db 0x2E, 0x8E, 0x16, 0xAD, 0x47 ; 00003B2E  mov ss,[cs:0x47ad]
  db 0x2E, 0x8B, 0x26, 0xAF, 0x47 ; 00003B33  mov sp,[cs:0x47af]
  db 0x2E, 0xFF, 0x2E, 0x38, 0x00 ; 00003B38  jmp far [cs:0x38]
  db 0x61                      ; 00003B3D  popa
  db 0x07                      ; 00003B3E  pop es
  db 0x1F                      ; 00003B3F  pop ds
  db 0x2E, 0x8E, 0x16, 0xAD, 0x47 ; 00003B40  mov ss,[cs:0x47ad]
  db 0x2E, 0x8B, 0x26, 0xAF, 0x47 ; 00003B45  mov sp,[cs:0x47af]
  db 0xCF                      ; 00003B4A  iret
  db 0x00, 0x00                ; 00003B4B  add [bx+si],al
  db 0x00, 0x00                ; 00003B4D  add [bx+si],al
  db 0x00, 0x00                ; 00003B4F  add [bx+si],al
  db 0x00, 0x00                ; 00003B51  add [bx+si],al
  db 0x00, 0x00                ; 00003B53  add [bx+si],al
  db 0x00, 0x00                ; 00003B55  add [bx+si],al
  db 0x00, 0x00                ; 00003B57  add [bx+si],al
  db 0x00, 0x00                ; 00003B59  add [bx+si],al
  db 0x00, 0x00                ; 00003B5B  add [bx+si],al
  db 0x00, 0x00                ; 00003B5D  add [bx+si],al
  db 0x00, 0x00                ; 00003B5F  add [bx+si],al
  db 0x00, 0x00                ; 00003B61  add [bx+si],al
  db 0x00, 0x00                ; 00003B63  add [bx+si],al
  db 0x00, 0x00                ; 00003B65  add [bx+si],al
  db 0x00, 0x00                ; 00003B67  add [bx+si],al
  db 0x00, 0x00                ; 00003B69  add [bx+si],al
  db 0x00, 0x00                ; 00003B6B  add [bx+si],al
  db 0x00, 0x00                ; 00003B6D  add [bx+si],al
  db 0x00, 0x00                ; 00003B6F  add [bx+si],al
  db 0x00, 0x00                ; 00003B71  add [bx+si],al
  db 0x00, 0x00                ; 00003B73  add [bx+si],al
  db 0x00, 0x00                ; 00003B75  add [bx+si],al
  db 0x00, 0x00                ; 00003B77  add [bx+si],al
  db 0x00, 0x00                ; 00003B79  add [bx+si],al
  db 0x00, 0x00                ; 00003B7B  add [bx+si],al
  db 0x00, 0x00                ; 00003B7D  add [bx+si],al
  db 0x00, 0x00                ; 00003B7F  add [bx+si],al
  db 0x00, 0x00                ; 00003B81  add [bx+si],al
  db 0x00, 0x00                ; 00003B83  add [bx+si],al
  db 0x00, 0x00                ; 00003B85  add [bx+si],al
  db 0x00, 0x00                ; 00003B87  add [bx+si],al
  db 0x00, 0x00                ; 00003B89  add [bx+si],al
  db 0x00, 0x00                ; 00003B8B  add [bx+si],al
  db 0x00, 0x00                ; 00003B8D  add [bx+si],al
  db 0x00, 0x00                ; 00003B8F  add [bx+si],al
  db 0x00, 0x00                ; 00003B91  add [bx+si],al
  db 0x00, 0x00                ; 00003B93  add [bx+si],al
  db 0x00, 0x00                ; 00003B95  add [bx+si],al
  db 0x00, 0x00                ; 00003B97  add [bx+si],al
  db 0x00, 0x00                ; 00003B99  add [bx+si],al
  db 0x00, 0x00                ; 00003B9B  add [bx+si],al
  db 0x00, 0x00                ; 00003B9D  add [bx+si],al
  db 0x00, 0x00                ; 00003B9F  add [bx+si],al
  db 0x00, 0x00                ; 00003BA1  add [bx+si],al
  db 0x00, 0x00                ; 00003BA3  add [bx+si],al
  db 0x00, 0x00                ; 00003BA5  add [bx+si],al
  db 0x00, 0x00                ; 00003BA7  add [bx+si],al
  db 0x00, 0x00                ; 00003BA9  add [bx+si],al
  db 0x00, 0x00                ; 00003BAB  add [bx+si],al
  db 0x00, 0x00                ; 00003BAD  add [bx+si],al
  db 0x00, 0x00                ; 00003BAF  add [bx+si],al
  db 0x00, 0x00                ; 00003BB1  add [bx+si],al
  db 0x00, 0x00                ; 00003BB3  add [bx+si],al
  db 0x00, 0x00                ; 00003BB5  add [bx+si],al
  db 0xBA, 0x5C, 0x00          ; 00003BB7  mov dx,0x5c
  db 0x24, 0x1F                ; 00003BBA  and al,0x1f
  db 0xEE                      ; 00003BBC  out dx,al
  db 0x83, 0xEA, 0x02          ; 00003BBD  sub dx,byte +0x2
  db 0x86, 0xE0                ; 00003BC0  xchg ah,al
  db 0xEE                      ; 00003BC2  out dx,al
  db 0x86, 0xE0                ; 00003BC3  xchg ah,al
  db 0x83, 0xC2, 0x02          ; 00003BC5  add dx,byte +0x2
  db 0x0C, 0x40                ; 00003BC8  or al,0x40
  db 0xEE                      ; 00003BCA  out dx,al
  db 0x90                      ; 00003BCB  nop
  db 0x90                      ; 00003BCC  nop
  db 0x90                      ; 00003BCD  nop
  db 0x90                      ; 00003BCE  nop
  db 0x24, 0x1F                ; 00003BCF  and al,0x1f
  db 0xEE                      ; 00003BD1  out dx,al
  db 0xC3                      ; 00003BD2  ret
  db 0xBA, 0x5C, 0x00          ; 00003BD3  mov dx,0x5c
  db 0x0C, 0x80                ; 00003BD6  or al,0x80
  db 0xEE                      ; 00003BD8  out dx,al
  db 0x0C, 0xA0                ; 00003BD9  or al,0xa0
  db 0xEE                      ; 00003BDB  out dx,al
  db 0x90                      ; 00003BDC  nop
  db 0x90                      ; 00003BDD  nop
  db 0x90                      ; 00003BDE  nop
  db 0x90                      ; 00003BDF  nop
  db 0x86, 0xE0                ; 00003BE0  xchg ah,al
  db 0xEC                      ; 00003BE2  in al,dx
  db 0x86, 0xE0                ; 00003BE3  xchg ah,al
  db 0x24, 0x9F                ; 00003BE5  and al,0x9f
  db 0xEE                      ; 00003BE7  out dx,al
  db 0x86, 0xE0                ; 00003BE8  xchg ah,al
  db 0xC3                      ; 00003BEA  ret
  db 0x8A, 0xE2                ; 00003BEB  mov ah,dl
  db 0xE4, 0x56                ; 00003BED  in al,0x56
  db 0xE8, 0x14, 0x00          ; 00003BEF  call 0x3c06
  db 0x32, 0xC0                ; 00003BF2  xor al,al
  db 0xE6, 0x5C                ; 00003BF4  out 0x5c,al
  db 0xE8, 0x0D, 0x00          ; 00003BF6  call 0x3c06
  db 0x86, 0xE0                ; 00003BF9  xchg ah,al
  db 0xE6, 0x5A                ; 00003BFB  out 0x5a,al
  db 0xE8, 0x06, 0x00          ; 00003BFD  call 0x3c06
  db 0xE6, 0x56                ; 00003C00  out 0x56,al
  db 0xE8, 0x01, 0x00          ; 00003C02  call 0x3c06
  db 0xC3                      ; 00003C05  ret
  db 0xB9, 0x1E, 0x00          ; 00003C06  mov cx,0x1e
  db 0xE2, 0xFE                ; 00003C09  loop 0x3c09
  db 0xC3                      ; 00003C0B  ret
  db 0x2E, 0x8B, 0x16, 0xB5, 0x47 ; 00003C0C  mov dx,[cs:0x47b5]
  db 0x2E, 0xA1, 0xB3, 0x47    ; 00003C11  mov ax,[cs:0x47b3]
  db 0x2E, 0x8A, 0x0E, 0xB3, 0x10 ; 00003C15  mov cl,[cs:0x10b3]
  db 0x32, 0xED                ; 00003C1A  xor ch,ch
  db 0x8B, 0xD8                ; 00003C1C  mov bx,ax
  db 0xC3                      ; 00003C1E  ret
  db 0xBA, 0x02, 0x03          ; 00003C1F  mov dx,0x302
  db 0xEC                      ; 00003C22  in al,dx
  db 0x8A, 0xD8                ; 00003C23  mov bl,al
  db 0x86, 0xC4                ; 00003C25  xchg al,ah
  db 0x32, 0xC0                ; 00003C27  xor al,al
  db 0xD0, 0xE4                ; 00003C29  shl ah,1
  db 0x80, 0xE4, 0x70          ; 00003C2B  and ah,0x70
  db 0xF6, 0xC3, 0x01          ; 00003C2E  test bl,0x1
  db 0x74, 0x02                ; 00003C31  jz 0x3c35
  db 0x0C, 0x20                ; 00003C33  or al,0x20
  db 0xF6, 0xC3, 0x02          ; 00003C35  test bl,0x2
  db 0x74, 0x02                ; 00003C38  jz 0x3c3c
  db 0x0C, 0x01                ; 00003C3A  or al,0x1
  db 0xF6, 0xC3, 0x04          ; 00003C3C  test bl,0x4
  db 0x74, 0x02                ; 00003C3F  jz 0x3c43
  db 0x0C, 0x04                ; 00003C41  or al,0x4
  db 0xF6, 0xC3, 0x80          ; 00003C43  test bl,0x80
  db 0x74, 0x02                ; 00003C46  jz 0x3c4a
  db 0x0C, 0x08                ; 00003C48  or al,0x8
  db 0xC3                      ; 00003C4A  ret
  db 0xB0, 0x01                ; 00003C4B  mov al,0x1
  db 0xE8, 0x0B, 0x00          ; 00003C4D  call 0x3c5b
  db 0x0E                      ; 00003C50  push cs
  db 0x57                      ; 00003C51  push di
  db 0xB8, 0x18, 0x00          ; 00003C52  mov ax,0x18
  db 0xCD, 0x28                ; 00003C55  int 0x28
  db 0x83, 0xC4, 0x04          ; 00003C57  add sp,byte +0x4
  db 0xC3                      ; 00003C5A  ret
  db 0xBF, 0x00, 0x49          ; 00003C5B  mov di,0x4900
  db 0x88, 0x05                ; 00003C5E  mov [di],al
  db 0xBB, 0xE3, 0x45          ; 00003C60  mov bx,0x45e3
  db 0x0A, 0xC0                ; 00003C63  or al,al
  db 0x75, 0x49                ; 00003C65  jnz 0x3cb0
  db 0xC6, 0x45, 0x01, 0x00    ; 00003C67  mov byte [di+0x1],0x0
  db 0xC6, 0x45, 0x02, 0x00    ; 00003C6B  mov byte [di+0x2],0x0
  db 0x8A, 0x47, 0x07          ; 00003C6F  mov al,[bx+0x7]
  db 0x8A, 0xE0                ; 00003C72  mov ah,al
  db 0x24, 0xF0                ; 00003C74  and al,0xf0
  db 0xB1, 0x04                ; 00003C76  mov cl,0x4
  db 0xD2, 0xE8                ; 00003C78  shr al,cl
  db 0x88, 0x45, 0x03          ; 00003C7A  mov [di+0x3],al
  db 0x80, 0xE4, 0x0F          ; 00003C7D  and ah,0xf
  db 0x88, 0x65, 0x04          ; 00003C80  mov [di+0x4],ah
  db 0xC6, 0x45, 0x05, 0x04    ; 00003C83  mov byte [di+0x5],0x4
  db 0xC6, 0x45, 0x06, 0x04    ; 00003C87  mov byte [di+0x6],0x4
  db 0x8A, 0x47, 0x09          ; 00003C8B  mov al,[bx+0x9]
  db 0x88, 0x45, 0x07          ; 00003C8E  mov [di+0x7],al
  db 0xC6, 0x45, 0x08, 0x05    ; 00003C91  mov byte [di+0x8],0x5
  db 0x8A, 0x47, 0x0A          ; 00003C95  mov al,[bx+0xa]
  db 0x88, 0x45, 0x09          ; 00003C98  mov [di+0x9],al
  db 0xC6, 0x45, 0x0A, 0x01    ; 00003C9B  mov byte [di+0xa],0x1
  db 0x8A, 0x47, 0x0B          ; 00003C9F  mov al,[bx+0xb]
  db 0x88, 0x45, 0x0B          ; 00003CA2  mov [di+0xb],al
  db 0xC6, 0x45, 0x0C, 0x03    ; 00003CA5  mov byte [di+0xc],0x3
  db 0x8A, 0x47, 0x0C          ; 00003CA9  mov al,[bx+0xc]
  db 0x88, 0x45, 0x0D          ; 00003CAC  mov [di+0xd],al
  db 0xC3                      ; 00003CAF  ret
  db 0x8A, 0x47, 0x0D          ; 00003CB0  mov al,[bx+0xd]
  db 0x8A, 0xE0                ; 00003CB3  mov ah,al
  db 0x24, 0x0F                ; 00003CB5  and al,0xf
  db 0x88, 0x45, 0x01          ; 00003CB7  mov [di+0x1],al
  db 0xC6, 0x45, 0x02, 0x00    ; 00003CBA  mov byte [di+0x2],0x0
  db 0x80, 0xE4, 0xF0          ; 00003CBE  and ah,0xf0
  db 0xB1, 0x04                ; 00003CC1  mov cl,0x4
  db 0xD2, 0xEC                ; 00003CC3  shr ah,cl
  db 0x88, 0x65, 0x03          ; 00003CC5  mov [di+0x3],ah
  db 0x88, 0x65, 0x04          ; 00003CC8  mov [di+0x4],ah
  db 0xC6, 0x45, 0x05, 0x05    ; 00003CCB  mov byte [di+0x5],0x5
  db 0xC6, 0x45, 0x06, 0x04    ; 00003CCF  mov byte [di+0x6],0x4
  db 0x8A, 0x47, 0x0E          ; 00003CD3  mov al,[bx+0xe]
  db 0x88, 0x45, 0x07          ; 00003CD6  mov [di+0x7],al
  db 0xC6, 0x45, 0x08, 0x05    ; 00003CD9  mov byte [di+0x8],0x5
  db 0x8A, 0x47, 0x0F          ; 00003CDD  mov al,[bx+0xf]
  db 0x88, 0x45, 0x09          ; 00003CE0  mov [di+0x9],al
  db 0xC6, 0x45, 0x0A, 0x02    ; 00003CE3  mov byte [di+0xa],0x2
  db 0xC6, 0x45, 0x0B, 0x40    ; 00003CE7  mov byte [di+0xb],0x40
  db 0xC6, 0x45, 0x0C, 0x01    ; 00003CEB  mov byte [di+0xc],0x1
  db 0x8A, 0x47, 0x10          ; 00003CEF  mov al,[bx+0x10]
  db 0x88, 0x45, 0x0D          ; 00003CF2  mov [di+0xd],al
  db 0xC6, 0x45, 0x0E, 0x03    ; 00003CF5  mov byte [di+0xe],0x3
  db 0x8A, 0x47, 0x11          ; 00003CF9  mov al,[bx+0x11]
  db 0x88, 0x45, 0x0F          ; 00003CFC  mov [di+0xf],al
  db 0xC3                      ; 00003CFF  ret
  db 0x00, 0x00                ; 00003D00  add [bx+si],al
  db 0x00, 0x00                ; 00003D02  add [bx+si],al
  db 0x00, 0x00                ; 00003D04  add [bx+si],al
  db 0x00, 0x00                ; 00003D06  add [bx+si],al
  db 0x00, 0x00                ; 00003D08  add [bx+si],al
  db 0x00, 0x00                ; 00003D0A  add [bx+si],al
  db 0x00, 0x00                ; 00003D0C  add [bx+si],al
  db 0x00, 0x00                ; 00003D0E  add [bx+si],al
  db 0x55                      ; 00003D10  push bp
  db 0x8B, 0xEC                ; 00003D11  mov bp,sp
  db 0x83, 0xC5, 0x02          ; 00003D13  add bp,byte +0x2
  db 0xC4, 0x7E, 0x0A          ; 00003D16  les di,[bp+0xa]
  db 0x26, 0x8A, 0x0D          ; 00003D19  mov cl,[es:di]
  db 0x26, 0x8A, 0x55, 0x02    ; 00003D1C  mov dl,[es:di+0x2]
  db 0xE8, 0x8E, 0xFA          ; 00003D20  call 0x37b1
  db 0x26, 0x8A, 0x5D, 0x03    ; 00003D23  mov bl,[es:di+0x3]
  db 0x32, 0xFF                ; 00003D27  xor bh,bh
  db 0xD1, 0xE3                ; 00003D29  shl bx,1
  db 0x2E, 0x8B, 0x87, 0x22, 0x4A ; 00003D2B  mov ax,[cs:bx+0x4a22]
  db 0x50                      ; 00003D30  push ax
  db 0xBA, 0x16, 0x03          ; 00003D31  mov dx,0x316
  db 0xB0, 0xB6                ; 00003D34  mov al,0xb6
  db 0xEE                      ; 00003D36  out dx,al
  db 0x58                      ; 00003D37  pop ax
  db 0xBA, 0x14, 0x03          ; 00003D38  mov dx,0x314
  db 0xEE                      ; 00003D3B  out dx,al
  db 0x86, 0xE0                ; 00003D3C  xchg ah,al
  db 0xEE                      ; 00003D3E  out dx,al
  db 0x26, 0x8A, 0x4D, 0x05    ; 00003D3F  mov cl,[es:di+0x5]
  db 0x32, 0xED                ; 00003D43  xor ch,ch
  db 0x83, 0xC7, 0x06          ; 00003D45  add di,byte +0x6
  db 0x83, 0xF9, 0x00          ; 00003D48  cmp cx,byte +0x0
  db 0x74, 0x06                ; 00003D4B  jz 0x3d53
  db 0xBB, 0xE3, 0x45          ; 00003D4D  mov bx,0x45e3
  db 0xE9, 0x03, 0x00          ; 00003D50  jmp 0x3d56
  db 0xE9, 0x86, 0x00          ; 00003D53  jmp 0x3ddc
  db 0x26, 0x8A, 0x05          ; 00003D56  mov al,[es:di]
  db 0x47                      ; 00003D59  inc di
  db 0x26, 0x8A, 0x25          ; 00003D5A  mov ah,[es:di]
  db 0x47                      ; 00003D5D  inc di
  db 0x3C, 0x03                ; 00003D5E  cmp al,0x3
  db 0x75, 0x05                ; 00003D60  jnz 0x3d67
  db 0x88, 0x67, 0x11          ; 00003D62  mov [bx+0x11],ah
  db 0xEB, 0x10                ; 00003D65  jmp short 0x3d77
  db 0x3C, 0x04                ; 00003D67  cmp al,0x4
  db 0x75, 0x05                ; 00003D69  jnz 0x3d70
  db 0x88, 0x67, 0x0E          ; 00003D6B  mov [bx+0xe],ah
  db 0xEB, 0x07                ; 00003D6E  jmp short 0x3d77
  db 0x3C, 0x05                ; 00003D70  cmp al,0x5
  db 0x75, 0x03                ; 00003D72  jnz 0x3d77
  db 0x88, 0x67, 0x0F          ; 00003D74  mov [bx+0xf],ah
  db 0xE2, 0xDD                ; 00003D77  loop 0x3d56
  db 0xBA, 0x02, 0x03          ; 00003D79  mov dx,0x302
  db 0xB0, 0x02                ; 00003D7C  mov al,0x2
  db 0xEE                      ; 00003D7E  out dx,al
  db 0x90                      ; 00003D7F  nop
  db 0x90                      ; 00003D80  nop
  db 0x90                      ; 00003D81  nop
  db 0xEE                      ; 00003D82  out dx,al
  db 0x90                      ; 00003D83  nop
  db 0x90                      ; 00003D84  nop
  db 0x90                      ; 00003D85  nop
  db 0x04, 0x40                ; 00003D86  add al,0x40
  db 0xEE                      ; 00003D88  out dx,al
  db 0x53                      ; 00003D89  push bx
  db 0x8A, 0x47, 0x0E          ; 00003D8A  mov al,[bx+0xe]
  db 0x8A, 0x5F, 0x11          ; 00003D8D  mov bl,[bx+0x11]
  db 0xB1, 0x06                ; 00003D90  mov cl,0x6
  db 0xD2, 0xEB                ; 00003D92  shr bl,cl
  db 0x80, 0xFB, 0x01          ; 00003D94  cmp bl,0x1
  db 0x74, 0x09                ; 00003D97  jz 0x3da2
  db 0x80, 0xFB, 0x02          ; 00003D99  cmp bl,0x2
  db 0x75, 0x06                ; 00003D9C  jnz 0x3da4
  db 0xB3, 0x01                ; 00003D9E  mov bl,0x1
  db 0xEB, 0x02                ; 00003DA0  jmp short 0x3da4
  db 0xB3, 0x02                ; 00003DA2  mov bl,0x2
  db 0xB1, 0x02                ; 00003DA4  mov cl,0x2
  db 0xD2, 0xE3                ; 00003DA6  shl bl,cl
  db 0x80, 0xCB, 0x02          ; 00003DA8  or bl,0x2
  db 0xB1, 0x04                ; 00003DAB  mov cl,0x4
  db 0xD2, 0xE0                ; 00003DAD  shl al,cl
  db 0x0A, 0xC3                ; 00003DAF  or al,bl
  db 0xEE                      ; 00003DB1  out dx,al
  db 0x5B                      ; 00003DB2  pop bx
  db 0x8A, 0x47, 0x11          ; 00003DB3  mov al,[bx+0x11]
  db 0xB1, 0x02                ; 00003DB6  mov cl,0x2
  db 0xD2, 0xE0                ; 00003DB8  shl al,cl
  db 0x8A, 0x5F, 0x0F          ; 00003DBA  mov bl,[bx+0xf]
  db 0xF6, 0xC3, 0x80          ; 00003DBD  test bl,0x80
  db 0x74, 0x02                ; 00003DC0  jz 0x3dc4
  db 0x0C, 0x02                ; 00003DC2  or al,0x2
  db 0xF6, 0xC3, 0x10          ; 00003DC4  test bl,0x10
  db 0x74, 0x02                ; 00003DC7  jz 0x3dcb
  db 0x0C, 0x08                ; 00003DC9  or al,0x8
  db 0xF6, 0xC3, 0x08          ; 00003DCB  test bl,0x8
  db 0x74, 0x02                ; 00003DCE  jz 0x3dd2
  db 0x0C, 0x01                ; 00003DD0  or al,0x1
  db 0xF6, 0xC3, 0x02          ; 00003DD2  test bl,0x2
  db 0x74, 0x02                ; 00003DD5  jz 0x3dd9
  db 0x0C, 0x20                ; 00003DD7  or al,0x20
  db 0x0C, 0x10                ; 00003DD9  or al,0x10
  db 0xEE                      ; 00003DDB  out dx,al
  db 0x5D                      ; 00003DDC  pop bp
  db 0xC3                      ; 00003DDD  ret
  db 0xA8, 0x03                ; 00003DDE  test al,0x3
  db 0x70, 0x02                ; 00003DE0  jo 0x3de4
  db 0xAA                      ; 00003DE2  stosb
  db 0x01, 0x38                ; 00003DE3  add [bx+si],di
  db 0x01, 0x9C, 0x00, 0x4E    ; 00003DE5  add [si+0x4e00],bx
  db 0x00, 0x27                ; 00003DE9  add [bx],ah
  db 0x00, 0x13                ; 00003DEB  add [bp+di],dl
  db 0x00, 0x0A                ; 00003DED  add [bp+si],cl
  db 0x00, 0x05                ; 00003DEF  add [di],al
  db 0x00, 0x05                ; 00003DF1  add [di],al
  db 0x00, 0xE0                ; 00003DF3  add al,ah
  db 0x04, 0x40                ; 00003DF5  add al,0x40
  db 0x03, 0x38                ; 00003DF7  add di,[bx+si]
  db 0x02, 0xA0, 0x01, 0xD0    ; 00003DF9  add ah,[bx+si-0x2fff]
  db 0x00, 0x68, 0x00          ; 00003DFD  add [bx+si+0x0],ch
  db 0x34, 0x00                ; 00003E00  xor al,0x0
  db 0x1A, 0x00                ; 00003E02  sbb al,[bx+si]
  db 0x0D, 0x00, 0x06          ; 00003E04  or ax,0x600
  db 0x00, 0x03                ; 00003E07  add [bp+di],al
  db 0x00, 0xDE                ; 00003E09  add dh,bl
  db 0x49                      ; 00003E0B  dec cx
  db 0x88, 0x13                ; 00003E0C  mov [bp+di],dl
  db 0x05, 0x0D, 0xE1          ; 00003E0E  add ax,0xe10d
  db 0x08, 0x83, 0x06, 0x41    ; 00003E11  or [bp+di+0x4106],al
  db 0x03, 0xA0, 0x01, 0xD0    ; 00003E15  add sp,[bx+si-0x2fff]
  db 0x00, 0x68, 0x00          ; 00003E19  add [bx+si+0x0],ch
  db 0x34, 0x00                ; 00003E1C  xor al,0x0
  db 0x1A, 0x00                ; 00003E1E  sbb al,[bx+si]
  db 0x0D, 0x00, 0x00          ; 00003E20  or ax,0x0
  db 0x04, 0x00                ; 00003E23  add al,0x0
  db 0x04, 0xBA                ; 00003E25  add al,0xba
  db 0x02, 0x00                ; 00003E27  add al,[bx+si]
  db 0x02, 0x00                ; 00003E29  add al,[bx+si]
  db 0x01, 0x80, 0x00, 0x40    ; 00003E2B  add [bx+si+0x4000],ax
  db 0x00, 0x20                ; 00003E2F  add [bx+si],ah
  db 0x00, 0x10                ; 00003E31  add [bx+si],dl
  db 0x00, 0x08                ; 00003E33  add [bx+si],cl
  db 0x00, 0xF3                ; 00003E35  add bl,dh
  db 0xA4                      ; 00003E37  movsb
  db 0xCF                      ; 00003E38  iret
  db 0xF3, 0xA5                ; 00003E39  rep movsw
  db 0xCF                      ; 00003E3B  iret
  db 0x53                      ; 00003E3C  push bx
  db 0x2E, 0xFF, 0x1E, 0xB6, 0x46 ; 00003E3D  call far [cs:0x46b6]
  db 0x5B                      ; 00003E42  pop bx
  db 0xF9                      ; 00003E43  stc
  db 0x2E, 0xFF, 0x2E, 0x49, 0x4A ; 00003E44  jmp far [cs:0x4a49]
  db 0x00, 0x00                ; 00003E49  add [bx+si],al
  db 0xFF                      ; 00003E4B  db 0xff
  db 0xFF, 0x1E, 0x2E, 0x8E    ; 00003E4C  call far [0x8e2e]
  db 0x1E                      ; 00003E50  push ds
  db 0x06                      ; 00003E51  push es
  db 0x0C, 0x2E                ; 00003E52  or al,0x2e
  db 0x8C, 0x16, 0xAD, 0x47    ; 00003E54  mov [0x47ad],ss
  db 0x2E, 0x89, 0x26, 0xAF, 0x47 ; 00003E58  mov [cs:0x47af],sp
  db 0x2E, 0x8E, 0x16, 0x06, 0x0C ; 00003E5D  mov ss,[cs:0xc06]
  db 0xBC, 0xAB, 0x47          ; 00003E62  mov sp,0x47ab
  db 0x50                      ; 00003E65  push ax
  db 0x53                      ; 00003E66  push bx
  db 0x56                      ; 00003E67  push si
  db 0x33, 0xC0                ; 00003E68  xor ax,ax
  db 0xE8, 0x91, 0xFC          ; 00003E6A  call 0x3afe
  db 0x2E, 0x8B, 0x1E, 0x8C, 0x00 ; 00003E6D  mov bx,[cs:0x8c]
  db 0x85, 0xDB                ; 00003E72  test bx,bx
  db 0x74, 0x14                ; 00003E74  jz 0x3e8a
  db 0xBE, 0x9D, 0x4A          ; 00003E76  mov si,0x4a9d
  db 0x8A, 0x44, 0x02          ; 00003E79  mov al,[si+0x2]
  db 0xA8, 0x3A                ; 00003E7C  test al,0x3a
  db 0x75, 0x0A                ; 00003E7E  jnz 0x3e8a
  db 0x81, 0x67, 0x06, 0xFD, 0xFF ; 00003E80  and word [bx+0x6],0xfffd
  db 0x81, 0x4F, 0x06, 0x80, 0x00 ; 00003E85  or word [bx+0x6],0x80
  db 0xC6, 0x44, 0x02, 0x00    ; 00003E8A  mov byte [si+0x2],0x0
  db 0x5E                      ; 00003E8E  pop si
  db 0x5B                      ; 00003E8F  pop bx
  db 0x58                      ; 00003E90  pop ax
  db 0x2E, 0x8E, 0x16, 0xAD, 0x47 ; 00003E91  mov ss,[cs:0x47ad]
  db 0x2E, 0x8B, 0x26, 0xAF, 0x47 ; 00003E96  mov sp,[cs:0x47af]
  db 0x1F                      ; 00003E9B  pop ds
  db 0xCF                      ; 00003E9C  iret
  db 0x00, 0x00                ; 00003E9D  add [bx+si],al
  db 0x00, 0x00                ; 00003E9F  add [bx+si],al
  db 0x00, 0x00                ; 00003EA1  add [bx+si],al
  db 0x00, 0x00                ; 00003EA3  add [bx+si],al
  db 0x00, 0x00                ; 00003EA5  add [bx+si],al
  db 0x00, 0x00                ; 00003EA7  add [bx+si],al
  db 0x00, 0x00                ; 00003EA9  add [bx+si],al
  db 0xFA                      ; 00003EAB  cli
  db 0x8C, 0xC8                ; 00003EAC  mov ax,cs
  db 0x8E, 0xC0                ; 00003EAE  mov es,ax
  db 0x8E, 0xD8                ; 00003EB0  mov ds,ax
  db 0x2E, 0x8B, 0x36, 0x68, 0x00 ; 00003EB2  mov si,[cs:0x68]
  db 0x8B, 0x6C, 0x10          ; 00003EB7  mov bp,[si+0x10]
  db 0x8D, 0x74, 0x08          ; 00003EBA  lea si,[si+0x8]
  db 0xBF, 0x0B, 0x4B          ; 00003EBD  mov di,0x4b0b
  db 0xB9, 0x04, 0x00          ; 00003EC0  mov cx,0x4
  db 0xF3, 0xA5                ; 00003EC3  rep movsw
  db 0x58                      ; 00003EC5  pop ax
  db 0x2D, 0x01, 0x00          ; 00003EC6  sub ax,0x1
  db 0xBF, 0x05, 0x4B          ; 00003EC9  mov di,0x4b05
  db 0xE8, 0x4E, 0x00          ; 00003ECC  call 0x3f1d
  db 0x58                      ; 00003ECF  pop ax
  db 0x58                      ; 00003ED0  pop ax
  db 0x58                      ; 00003ED1  pop ax
  db 0xBF, 0x19, 0x4B          ; 00003ED2  mov di,0x4b19
  db 0xE8, 0x45, 0x00          ; 00003ED5  call 0x3f1d
  db 0x58                      ; 00003ED8  pop ax
  db 0xBF, 0x14, 0x4B          ; 00003ED9  mov di,0x4b14
  db 0xE8, 0x3E, 0x00          ; 00003EDC  call 0x3f1d
  db 0xBE, 0xFA, 0x4A          ; 00003EDF  mov si,0x4afa
  db 0x8E, 0xC5                ; 00003EE2  mov es,bp
  db 0xE8, 0xB4, 0xD7          ; 00003EE4  call 0x169b
  db 0x2E, 0x8B, 0x1E, 0x68, 0x00 ; 00003EE7  mov bx,[cs:0x68]
  db 0x81, 0x67, 0x06, 0xFD, 0xFD ; 00003EEC  and word [bx+0x6],0xfdfd
  db 0xB9, 0x8F, 0x00          ; 00003EF1  mov cx,0x8f
  db 0xBA, 0xFF, 0xFF          ; 00003EF4  mov dx,0xffff
  db 0xE9, 0x39, 0xC2          ; 00003EF7  jmp 0x133
  db 0x22, 0x49, 0x6E          ; 00003EFA  and cl,[bx+di+0x6e]
  db 0x74, 0x65                ; 00003EFD  jz 0x3f64
  db 0x72, 0x72                ; 00003EFF  jc 0x3f73
  db 0x75, 0x70                ; 00003F01  jnz 0x3f73
  db 0x74, 0x3D                ; 00003F03  jz 0x3f42
  db 0x20, 0x20                ; 00003F05  and [bx+si],ah
  db 0x20, 0x20                ; 00003F07  and [bx+si],ah
  db 0x20, 0x20                ; 00003F09  and [bx+si],ah
  db 0x20, 0x20                ; 00003F0B  and [bx+si],ah
  db 0x20, 0x20                ; 00003F0D  and [bx+si],ah
  db 0x20, 0x20                ; 00003F0F  and [bx+si],ah
  db 0x20, 0x20                ; 00003F11  and [bx+si],ah
  db 0x20, 0x20                ; 00003F13  and [bx+si],ah
  db 0x20, 0x20                ; 00003F15  and [bx+si],ah
  db 0x20, 0x3A                ; 00003F17  and [bp+si],bh
  db 0x20, 0x20                ; 00003F19  and [bx+si],ah
  db 0x20, 0x20                ; 00003F1B  and [bx+si],ah
  db 0xFC                      ; 00003F1D  cld
  db 0x50                      ; 00003F1E  push ax
  db 0x8A, 0xC4                ; 00003F1F  mov al,ah
  db 0xE8, 0x01, 0x00          ; 00003F21  call 0x3f25
  db 0x58                      ; 00003F24  pop ax
  db 0x50                      ; 00003F25  push ax
  db 0xB1, 0x04                ; 00003F26  mov cl,0x4
  db 0xD2, 0xE8                ; 00003F28  shr al,cl
  db 0xE8, 0x01, 0x00          ; 00003F2A  call 0x3f2e
  db 0x58                      ; 00003F2D  pop ax
  db 0x24, 0x0F                ; 00003F2E  and al,0xf
  db 0x04, 0x90                ; 00003F30  add al,0x90
  db 0x27                      ; 00003F32  daa
  db 0x14, 0x40                ; 00003F33  adc al,0x40
  db 0x27                      ; 00003F35  daa
  db 0xAA                      ; 00003F36  stosb
  db 0xC3                      ; 00003F37  ret
  db 0x14, 0x20                ; 00003F38  adc al,0x20
  db 0xFF, 0x37                ; 00003F3A  push word [bx]
  db 0x35, 0x39, 0x20          ; 00003F3C  xor ax,0x2039
  db 0x53                      ; 00003F3F  push bx
  db 0x4B                      ; 00003F40  dec bx
  db 0x5B                      ; 00003F41  pop bx
  db 0x52                      ; 00003F42  push dx
  db 0x4D                      ; 00003F43  dec bp
  db 0x54                      ; 00003F44  push sp
  db 0x52                      ; 00003F45  push dx
  db 0x49                      ; 00003F46  dec cx
  db 0x4D                      ; 00003F47  dec bp
  db 0x4E                      ; 00003F48  dec si
  db 0x49                      ; 00003F49  dec cx
  db 0x4E                      ; 00003F4A  dec si
  db 0x47                      ; 00003F4B  inc di
  db 0x20, 0x0C                ; 00003F4C  and [si],cl
  db 0x4D                      ; 00003F4E  dec bp
  db 0x61                      ; 00003F4F  popa
  db 0x72, 0x6B                ; 00003F50  jc 0x3fbd
  db 0x7C, 0x72                ; 00003F52  jl 0x3fc6
  db 0x20, 0x42, 0x6C          ; 00003F54  and [bp+si+0x6c],al
  db 0x69, 0x6E, 0x6B, 0x0C, 0x4D ; 00003F57  imul bp,[bp+0x6b],word 0x4d0c
  db 0x61                      ; 00003F5C  popa
  db 0x72, 0x6B                ; 00003F5D  jc 0x3fca
  db 0x7C, 0x72                ; 00003F5F  jl 0x3fd3
  db 0x20, 0x48, 0x7C          ; 00003F61  and [bx+si+0x7c],cl
  db 0x6A, 0x64                ; 00003F64  push byte +0x64
  db 0x65, 0x0C, 0x42          ; 00003F66  gs or al,0x42
  db 0x6C                      ; 00003F69  insb
  db 0x7C, 0x64                ; 00003F6A  jl 0x3fd0
  db 0x20, 0x52, 0x75          ; 00003F6C  and [bp+si+0x75],dl
  db 0x6C                      ; 00003F6F  insb
  db 0x6E                      ; 00003F70  outsb
  db 0x69, 0x6E, 0x67, 0x0E, 0x53 ; 00003F71  imul bp,[bp+0x67],word 0x530e
  db 0x74, 0x61                ; 00003F76  jz 0x3fd9
  db 0x6E                      ; 00003F78  outsb
  db 0x64, 0x61                ; 00003F79  fs popa
  db 0x72, 0x64                ; 00003F7B  jc 0x3fe1
  db 0x20, 0x46, 0x61          ; 00003F7D  and [bp+0x61],al
  db 0x72, 0x76                ; 00003F80  jc 0x3ff8
  db 0x65, 0x0E                ; 00003F82  gs push cs
  db 0x53                      ; 00003F84  push bx
  db 0x6C                      ; 00003F85  insb
  db 0x75, 0x6B                ; 00003F86  jnz 0x3ff3
  db 0x20, 0x53, 0x6B          ; 00003F88  and [bp+di+0x6b],dl
  db 0x7B, 0x72                ; 00003F8B  jpo 0x3fff
  db 0x6D                      ; 00003F8D  insw
  db 0x20, 0x20                ; 00003F8E  and [bx+si],ah
  db 0x20, 0x20                ; 00003F90  and [bx+si],ah
  db 0x73, 0x6F                ; 00003F92  jnc 0x4003
  db 0x72, 0x74                ; 00003F94  jc 0x400a
  db 0x20, 0x20                ; 00003F96  and [bx+si],ah
  db 0x20, 0x62, 0x6C          ; 00003F98  and [bp+si+0x6c],ah
  db 0x7D, 0x20                ; 00003F9B  jnl 0x3fbd
  db 0x20, 0x20                ; 00003F9D  and [bx+si],ah
  db 0x20, 0x67, 0x72          ; 00003F9F  and [bx+0x72],ah
  db 0x7C, 0x6E                ; 00003FA2  jl 0x4012
  db 0x20, 0x20                ; 00003FA4  and [bx+si],ah
  db 0x20, 0x63, 0x79          ; 00003FA6  and [bp+di+0x79],ah
  db 0x61                      ; 00003FA9  popa
  db 0x6E                      ; 00003FAA  outsb
  db 0x20, 0x20                ; 00003FAB  and [bx+si],ah
  db 0x20, 0x72, 0x7C          ; 00003FAD  and [bp+si+0x7c],dh
  db 0x64, 0x20, 0x20          ; 00003FB0  and [fs:bx+si],ah
  db 0x20, 0x20                ; 00003FB3  and [bx+si],ah
  db 0x6D                      ; 00003FB5  insw
  db 0x61                      ; 00003FB6  popa
  db 0x67, 0x65, 0x6E          ; 00003FB7  gs a32 outsb
  db 0x74, 0x61                ; 00003FBA  jz 0x401d
  db 0x67, 0x75, 0x6C          ; 00003FBC  jnz 0x402b
  db 0x20, 0x20                ; 00003FBF  and [bx+si],ah
  db 0x20, 0x20                ; 00003FC1  and [bx+si],ah
  db 0x68, 0x76, 0x69          ; 00003FC3  push word 0x6976
  db 0x64, 0x20, 0x20          ; 00003FC6  and [fs:bx+si],ah
  db 0x20, 0x4E, 0x45          ; 00003FC9  and [bp+0x45],cl
  db 0x4A                      ; 00003FCC  dec dx
  db 0x20, 0x4A, 0x41          ; 00003FCD  and [bp+si+0x41],cl
  db 0x20, 0x20                ; 00003FD0  and [bx+si],ah
  db 0x20, 0x4B, 0x6F          ; 00003FD2  and [bp+di+0x6f],cl
  db 0x6E                      ; 00003FD5  outsb
  db 0x73, 0x6F                ; 00003FD6  jnc 0x4047
  db 0x6C                      ; 00003FD8  insb
  db 0x3D, 0x00, 0x20          ; 00003FD9  cmp ax,0x2000
  db 0x00, 0x00                ; 00003FDC  add [bx+si],al
  db 0x00, 0x00                ; 00003FDE  add [bx+si],al
  db 0x00, 0x00                ; 00003FE0  add [bx+si],al
  db 0x00, 0x00                ; 00003FE2  add [bx+si],al
  db 0x20, 0x00                ; 00003FE4  and [bx+si],al
  db 0x00, 0x00                ; 00003FE6  add [bx+si],al
  db 0x00, 0x00                ; 00003FE8  add [bx+si],al
  db 0x00, 0x00                ; 00003FEA  add [bx+si],al
  db 0x00, 0x20                ; 00003FEC  add [bx+si],ah
  db 0x00, 0x00                ; 00003FEE  add [bx+si],al
  db 0x00, 0x00                ; 00003FF0  add [bx+si],al
  db 0x00, 0x00                ; 00003FF2  add [bx+si],al
  db 0x00, 0x00                ; 00003FF4  add [bx+si],al
  db 0x00, 0x00                ; 00003FF6  add [bx+si],al
  db 0x00, 0x00                ; 00003FF8  add [bx+si],al
  db 0x00, 0x00                ; 00003FFA  add [bx+si],al
  db 0x00, 0x00                ; 00003FFC  add [bx+si],al
  db 0x00, 0x20                ; 00003FFE  add [bx+si],ah
  db 0x00, 0x00                ; 00004000  add [bx+si],al
  db 0x00, 0x00                ; 00004002  add [bx+si],al
  db 0x00, 0x00                ; 00004004  add [bx+si],al
  db 0x00, 0x00                ; 00004006  add [bx+si],al
  db 0x20, 0x53, 0x6B          ; 00004008  and [bp+di+0x6b],dl
  db 0x72, 0x69                ; 0000400B  jc 0x4076
  db 0x76, 0x65                ; 0000400D  jna 0x4074
  db 0x72, 0x3D                ; 0000400F  jc 0x404e
  db 0x00, 0x00                ; 00004011  add [bx+si],al
  db 0x20, 0x00                ; 00004013  and [bx+si],al
  db 0x00, 0x00                ; 00004015  add [bx+si],al
  db 0x00, 0x20                ; 00004017  add [bx+si],ah
  db 0x30, 0x30                ; 00004019  xor [bx+si],dh
  db 0x3A, 0x30                ; 0000401B  cmp dh,[bx+si]
  db 0x30, 0x3A                ; 0000401D  xor [bp+si],bh
  db 0x30, 0x30                ; 0000401F  xor [bx+si],dh
  db 0x20, 0x44, 0x79          ; 00004021  and [si+0x79],al
  db 0x6E                      ; 00004024  outsb
  db 0x61                      ; 00004025  popa
  db 0x6D                      ; 00004026  insw
  db 0x69, 0x73, 0x6B, 0x42, 0x75 ; 00004027  imul si,[bp+di+0x6b],word 0x7542
  db 0x66, 0x66, 0x65, 0x72, 0x65 ; 0000402C  gs o32 jc 0x4096
  db 0x74, 0x42                ; 00004031  jz 0x4075
  db 0x75, 0x66                ; 00004033  jnz 0x409b
  db 0x66, 0x65, 0x72, 0x20    ; 00004035  gs o32 jc 0x4059
  db 0x20, 0x4C, 0x7D          ; 00004039  and [si+0x7d],cl
  db 0x73, 0x74                ; 0000403C  jnc 0x40b2
  db 0x20, 0x20                ; 0000403E  and [bx+si],ah
  db 0x20, 0x20                ; 00004040  and [bx+si],ah
  db 0x4C                      ; 00004042  dec sp
  db 0x5D                      ; 00004043  pop bp
  db 0x53                      ; 00004044  push bx
  db 0x20, 0x20                ; 00004045  and [bx+si],ah
  db 0x20, 0x20                ; 00004047  and [bx+si],ah
  db 0x20, 0x20                ; 00004049  and [bx+si],ah
  db 0x20, 0x20                ; 0000404B  and [bx+si],ah
  db 0x20, 0x20                ; 0000404D  and [bx+si],ah
  db 0x20, 0x20                ; 0000404F  and [bx+si],ah
  db 0x20, 0x20                ; 00004051  and [bx+si],ah
  db 0x20, 0x20                ; 00004053  and [bx+si],ah
  db 0x20, 0x20                ; 00004055  and [bx+si],ah
  db 0x20, 0x20                ; 00004057  and [bx+si],ah
  db 0x20, 0x20                ; 00004059  and [bx+si],ah
  db 0x20, 0x20                ; 0000405B  and [bx+si],ah
  db 0x20, 0x20                ; 0000405D  and [bx+si],ah
  db 0x20, 0x20                ; 0000405F  and [bx+si],ah
  db 0x20, 0x20                ; 00004061  and [bx+si],ah
  db 0x20, 0x20                ; 00004063  and [bx+si],ah
  db 0x20, 0x20                ; 00004065  and [bx+si],ah
  db 0x20, 0x20                ; 00004067  and [bx+si],ah
  db 0x20, 0x20                ; 00004069  and [bx+si],ah
  db 0x20, 0x20                ; 0000406B  and [bx+si],ah
  db 0x20, 0x20                ; 0000406D  and [bx+si],ah
  db 0x20, 0x20                ; 0000406F  and [bx+si],ah
  db 0x20, 0x20                ; 00004071  and [bx+si],ah
  db 0x20, 0x20                ; 00004073  and [bx+si],ah
  db 0x20, 0x20                ; 00004075  and [bx+si],ah
  db 0x20, 0x20                ; 00004077  and [bx+si],ah
  db 0x2D, 0x20, 0x54          ; 00004079  sub ax,0x5420
  db 0x72, 0x79                ; 0000407C  jc 0x40f7
  db 0x6B, 0x20, 0x70          ; 0000407E  imul sp,[bx+si],byte +0x70
  db 0x7D, 0x20                ; 00004081  jnl 0x40a3
  db 0x65, 0x6E                ; 00004083  gs outsb
  db 0x20, 0x74, 0x61          ; 00004085  and [si+0x61],dh
  db 0x73, 0x74                ; 00004088  jnc 0x40fe
  db 0x20, 0x20                ; 0000408A  and [bx+si],ah
  db 0x20, 0x20                ; 0000408C  and [bx+si],ah
  db 0x20, 0x20                ; 0000408E  and [bx+si],ah
  db 0x20, 0x20                ; 00004090  and [bx+si],ah
  db 0x20, 0x20                ; 00004092  and [bx+si],ah
  db 0x20, 0x20                ; 00004094  and [bx+si],ah
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
  db 0x24, 0x20                ; 000040E6  and al,0x20
  db 0x2A, 0x2A                ; 000040E8  sub ch,[bp+si]
  db 0x20, 0x56, 0x65          ; 000040EA  and [bp+0x65],dl
  db 0x6E                      ; 000040ED  outsb
  db 0x74, 0x65                ; 000040EE  jz 0x4155
  db 0x72, 0x20                ; 000040F0  jc 0x4112
  db 0x70, 0x7D                ; 000040F2  jo 0x4171
  db 0x20, 0x66, 0x7B          ; 000040F4  and [bp+0x7b],ah
  db 0x6C                      ; 000040F7  insb
  db 0x6C                      ; 000040F8  insb
  db 0x65, 0x73, 0x20          ; 000040F9  gs jnc 0x411c
  db 0x64, 0x69, 0x73, 0x6B, 0x65, 0x74 ; 000040FC  imul si,[fs:bp+di+0x6b],word 0x7465
  db 0x74, 0x65                ; 00004102  jz 0x4169
  db 0x73, 0x74                ; 00004104  jnc 0x417a
  db 0x61                      ; 00004106  popa
  db 0x74, 0x69                ; 00004107  jz 0x4172
  db 0x6F                      ; 00004109  outsw
  db 0x6E                      ; 0000410A  outsb
  db 0x1C, 0x20                ; 0000410B  sbb al,0x20
  db 0x2A, 0x2A                ; 0000410D  sub ch,[bp+si]
  db 0x20, 0x56, 0x65          ; 0000410F  and [bp+0x65],dl
  db 0x6E                      ; 00004112  outsb
  db 0x74, 0x65                ; 00004113  jz 0x417a
  db 0x72, 0x20                ; 00004115  jc 0x4137
  db 0x70, 0x7D                ; 00004117  jo 0x4196
  db 0x20, 0x66, 0x7B          ; 00004119  and [bp+0x7b],ah
  db 0x6C                      ; 0000411C  insb
  db 0x6C                      ; 0000411D  insb
  db 0x65, 0x73, 0x20          ; 0000411E  gs jnc 0x4141
  db 0x73, 0x6B                ; 00004121  jnc 0x418e
  db 0x72, 0x69                ; 00004123  jc 0x418e
  db 0x76, 0x65                ; 00004125  jna 0x418c
  db 0x72, 0x15                ; 00004127  jc 0x413e
  db 0x20, 0x2A                ; 00004129  and [bp+si],ch
  db 0x2A, 0x20                ; 0000412B  sub ah,[bx+si]
  db 0x53                      ; 0000412D  push bx
  db 0x6B, 0x72, 0x69, 0x76    ; 0000412E  imul si,[bp+si+0x69],byte +0x76
  db 0x65, 0x72, 0x20          ; 00004132  gs jc 0x4155
  db 0x69, 0x6B, 0x6B, 0x65, 0x20 ; 00004135  imul bp,[bp+di+0x6b],word 0x2065
  db 0x6B, 0x6C, 0x61, 0x72    ; 0000413A  imul bp,[si+0x61],byte +0x72
  db 0x16                      ; 0000413E  push ss
  db 0x20, 0x2A                ; 0000413F  and [bp+si],ch
  db 0x2A, 0x20                ; 00004141  sub ah,[bx+si]
  db 0x53                      ; 00004143  push bx
  db 0x6B, 0x72, 0x69, 0x76    ; 00004144  imul si,[bp+si+0x69],byte +0x76
  db 0x65, 0x72, 0x20          ; 00004148  gs jc 0x416b
  db 0x52                      ; 0000414B  push dx
  db 0x65, 0x73, 0x65          ; 0000414C  gs jnc 0x41b4
  db 0x72, 0x76                ; 0000414F  jc 0x41c7
  db 0x65, 0x72, 0x65          ; 00004151  gs jc 0x41b9
  db 0x74, 0x1A                ; 00004154  jz 0x4170
  db 0x20, 0x2A                ; 00004156  and [bp+si],ch
  db 0x2A, 0x20                ; 00004158  sub ah,[bx+si]
  db 0x47                      ; 0000415A  inc di
  db 0x72, 0x61                ; 0000415B  jc 0x41be
  db 0x66, 0x69, 0x6B, 0x73, 0x6B, 0x7B, 0x72, 0x6D ; 0000415D  imul ebp,[bp+di+0x73],dword 0x6d727b6b
  db 0x20, 0x72, 0x65          ; 00004165  and [bp+si+0x65],dh
  db 0x73, 0x65                ; 00004168  jnc 0x41cf
  db 0x72, 0x76                ; 0000416A  jc 0x41e2
  db 0x65, 0x72, 0x65          ; 0000416C  gs jc 0x41d4
  db 0x74, 0x32                ; 0000416F  jz 0x41a3
  db 0x20, 0x2A                ; 00004171  and [bp+si],ch
  db 0x2A, 0x20                ; 00004173  sub ah,[bx+si]
  db 0x53                      ; 00004175  push bx
  db 0x6B, 0x72, 0x69, 0x76    ; 00004176  imul si,[bp+si+0x69],byte +0x76
  db 0x65, 0x72, 0x20          ; 0000417A  gs jc 0x419d
  db 0x69, 0x6B, 0x6B, 0x65, 0x20 ; 0000417D  imul bp,[bp+di+0x6b],word 0x2065
  db 0x6B, 0x6C, 0x61, 0x72    ; 00004182  imul bp,[si+0x61],byte +0x72
  db 0x2E, 0x20, 0x31          ; 00004186  and [cs:bx+di],dh
  db 0x3D, 0x67, 0x65          ; 00004189  cmp ax,0x6567
  db 0x6E                      ; 0000418C  outsb
  db 0x74, 0x61                ; 0000418D  jz 0x41f0
  db 0x67, 0x2C, 0x32          ; 0000418F  sub al,0x32
  db 0x3D, 0x61, 0x66          ; 00004192  cmp ax,0x6661
  db 0x62, 0x72, 0x79          ; 00004195  bound si,[bp+si+0x79]
  db 0x64, 0x2C, 0x33          ; 00004198  fs sub al,0x33
  db 0x3D, 0x69, 0x67          ; 0000419B  cmp ax,0x6769
  db 0x6E                      ; 0000419E  outsb
  db 0x6F                      ; 0000419F  outsw
  db 0x72, 0x65                ; 000041A0  jc 0x4207
  db 0x72, 0x50                ; 000041A2  jc 0x41f4
  db 0x49                      ; 000041A4  dec cx
  db 0x43                      ; 000041A5  inc bx
  db 0x43                      ; 000041A6  inc bx
  db 0x4F                      ; 000041A7  dec di
  db 0x4C                      ; 000041A8  dec sp
  db 0x49                      ; 000041A9  dec cx
  db 0x4E                      ; 000041AA  dec si
  db 0x45                      ; 000041AB  inc bp
  db 0x20, 0x58, 0x49          ; 000041AC  and [bx+si+0x49],bl
  db 0x4F                      ; 000041AF  dec di
  db 0x53                      ; 000041B0  push bx
  db 0x20, 0x76, 0x65          ; 000041B1  and [bp+0x65],dh
  db 0x72, 0x73                ; 000041B4  jc 0x4229
  db 0x69, 0x6F, 0x6E, 0x20, 0x32 ; 000041B6  imul bp,[bx+0x6e],word 0x3220
  db 0x2E, 0x33, 0x20          ; 000041BB  xor sp,[cs:bx+si]
  db 0x2D, 0x20, 0x4D          ; 000041BE  sub ax,0x4d20
  db 0x61                      ; 000041C1  popa
  db 0x72, 0x74                ; 000041C2  jc 0x4238
  db 0x73, 0x20                ; 000041C4  jnc 0x41e6
  db 0x31, 0x39                ; 000041C6  xor [bx+di],di
  db 0x38, 0x35                ; 000041C8  cmp [di],dh
  db 0x20, 0x0D                ; 000041CA  and [di],cl
  db 0x0A, 0x0A                ; 000041CC  or cl,[bp+si]
  db 0x20, 0x20                ; 000041CE  and [bx+si],ah
  db 0x20, 0x20                ; 000041D0  and [bx+si],ah
  db 0x20, 0x20                ; 000041D2  and [bx+si],ah
  db 0x4B                      ; 000041D4  dec bx
  db 0x20, 0x62, 0x79          ; 000041D5  and [bp+si+0x79],ah
  db 0x74, 0x65                ; 000041D8  jz 0x423f
  db 0x73, 0x20                ; 000041DA  jnc 0x41fc
  db 0x68, 0x6F, 0x76          ; 000041DC  push word 0x766f
  db 0x65, 0x64, 0x20, 0x6C, 0x61 ; 000041DF  and [fs:si+0x61],ch
  db 0x67, 0x65, 0x72, 0x0D    ; 000041E4  gs jc 0x41f5
  db 0x0A, 0x00                ; 000041E8  or al,[bx+si]
  db 0x20, 0x20                ; 000041EA  and [bx+si],ah
  db 0x20, 0x20                ; 000041EC  and [bx+si],ah
  db 0x20, 0x20                ; 000041EE  and [bx+si],ah
  db 0x4B                      ; 000041F0  dec bx
  db 0x20, 0x62, 0x79          ; 000041F1  and [bp+si+0x79],ah
  db 0x74, 0x65                ; 000041F4  jz 0x425b
  db 0x73, 0x20                ; 000041F6  jnc 0x4218
  db 0x62, 0x72, 0x75          ; 000041F8  bound si,[bp+si+0x75]
  db 0x67, 0x65, 0x72, 0x20    ; 000041FB  gs jc 0x421f
  db 0x6C                      ; 000041FF  insb
  db 0x61                      ; 00004200  popa
  db 0x67, 0x65, 0x72, 0x0D    ; 00004201  gs jc 0x4212
  db 0x0A, 0x00                ; 00004205  or al,[bx+si]
  db 0x20, 0x20                ; 00004207  and [bx+si],ah
  db 0x20, 0x20                ; 00004209  and [bx+si],ah
  db 0x20, 0x20                ; 0000420B  and [bx+si],ah
  db 0x44                      ; 0000420D  inc sp
  db 0x69, 0x73, 0x6B, 0x65, 0x74 ; 0000420E  imul si,[bp+di+0x6b],word 0x7465
  db 0x74, 0x65                ; 00004213  jz 0x427a
  db 0x20, 0x73, 0x74          ; 00004215  and [bp+di+0x74],dh
  db 0x61                      ; 00004218  popa
  db 0x74, 0x69                ; 00004219  jz 0x4284
  db 0x6F                      ; 0000421B  outsw
  db 0x6E                      ; 0000421C  outsb
  db 0x28, 0x65, 0x72          ; 0000421D  sub [di+0x72],ah
  db 0x29, 0x0D                ; 00004220  sub [di],cx
  db 0x0A, 0x00                ; 00004222  or al,[bx+si]
  db 0x20, 0x20                ; 00004224  and [bx+si],ah
  db 0x20, 0x20                ; 00004226  and [bx+si],ah
  db 0x20, 0x20                ; 00004228  and [bx+si],ah
  db 0x57                      ; 0000422A  push di
  db 0x69, 0x6E, 0x63, 0x68, 0x65 ; 0000422B  imul bp,[bp+0x63],word 0x6568
  db 0x73, 0x74                ; 00004230  jnc 0x42a6
  db 0x65, 0x72, 0x20          ; 00004232  gs jc 0x4255
  db 0x64, 0x69, 0x73, 0x6B, 0x20, 0x73 ; 00004235  imul si,[fs:bp+di+0x6b],word 0x7320
  db 0x74, 0x61                ; 0000423B  jz 0x429e
  db 0x74, 0x69                ; 0000423D  jz 0x42a8
  db 0x6F                      ; 0000423F  outsw
  db 0x6E                      ; 00004240  outsb
  db 0x28, 0x65, 0x72          ; 00004241  sub [di+0x72],ah
  db 0x29, 0x0D                ; 00004244  sub [di],cx
  db 0x0A, 0x00                ; 00004246  or al,[bx+si]
  db 0x20, 0x20                ; 00004248  and [bx+si],ah
  db 0x20, 0x20                ; 0000424A  and [bx+si],ah
  db 0x20, 0x20                ; 0000424C  and [bx+si],ah
  db 0x44                      ; 0000424E  inc sp
  db 0x61                      ; 0000424F  popa
  db 0x74, 0x61                ; 00004250  jz 0x42b3
  db 0x20, 0x62, 0x75          ; 00004252  and [bp+si+0x75],ah
  db 0x66, 0x66, 0x65, 0x72, 0x28 ; 00004255  gs o32 jc 0x4282
  db 0x65, 0x29, 0x0D          ; 0000425A  sub [gs:di],cx
  db 0x0A, 0x00                ; 0000425D  or al,[bx+si]
  db 0x20, 0x20                ; 0000425F  and [bx+si],ah
  db 0x20, 0x20                ; 00004261  and [bx+si],ah
  db 0x20, 0x20                ; 00004263  and [bx+si],ah
  db 0x4B                      ; 00004265  dec bx
  db 0x61                      ; 00004266  popa
  db 0x74, 0x61                ; 00004267  jz 0x42ca
  db 0x6C                      ; 00004269  insb
  db 0x6F                      ; 0000426A  outsw
  db 0x67, 0x20, 0x62, 0x75    ; 0000426B  and [edx+0x75],ah
  db 0x66, 0x66, 0x65, 0x72, 0x28 ; 0000426F  gs o32 jc 0x429c
  db 0x65, 0x29, 0x0D          ; 00004274  sub [gs:di],cx
  db 0x0A, 0x00                ; 00004277  or al,[bx+si]
  db 0x20, 0x20                ; 00004279  and [bx+si],ah
  db 0x20, 0x20                ; 0000427B  and [bx+si],ah
  db 0x20, 0x20                ; 0000427D  and [bx+si],ah
  db 0x4B                      ; 0000427F  dec bx
  db 0x20, 0x62, 0x79          ; 00004280  and [bp+si+0x79],ah
  db 0x74, 0x65                ; 00004283  jz 0x42ea
  db 0x73, 0x20                ; 00004285  jnc 0x42a7
  db 0x4D                      ; 00004287  dec bp
  db 0x2D, 0x64, 0x69          ; 00004288  sub ax,0x6964
  db 0x73, 0x6B                ; 0000428B  jnc 0x42f8
  db 0x0D, 0x0A, 0x00          ; 0000428D  or ax,0xa
  db 0x20, 0x20                ; 00004290  and [bx+si],ah
  db 0x2A, 0x2A                ; 00004292  sub ch,[bp+si]
  db 0x2A, 0x20                ; 00004294  sub ah,[bx+si]
  db 0x46                      ; 00004296  inc si
  db 0x6F                      ; 00004297  outsw
  db 0x72, 0x20                ; 00004298  jc 0x42ba
  db 0x6C                      ; 0000429A  insb
  db 0x69, 0x64, 0x74, 0x20, 0x6C ; 0000429B  imul sp,[si+0x74],word 0x6c20
  db 0x61                      ; 000042A0  popa
  db 0x67, 0x65, 0x72, 0x20    ; 000042A1  gs jc 0x42c5
  db 0x74, 0x69                ; 000042A5  jz 0x4310
  db 0x6C                      ; 000042A7  insb
  db 0x20, 0x4D, 0x2D          ; 000042A8  and [di+0x2d],cl
  db 0x64, 0x69, 0x73, 0x6B, 0x0D, 0x0A ; 000042AB  imul si,[fs:bp+di+0x6b],word 0xa0d
  db 0x00, 0x0D                ; 000042B1  add [di],cl
  db 0x0A, 0x4C, 0x6F          ; 000042B3  or cl,[si+0x6f]
  db 0x6B, 0x61, 0x6C, 0x6E    ; 000042B6  imul sp,[bx+di+0x6c],byte +0x6e
  db 0x65, 0x74, 0x20          ; 000042BA  gs jz 0x42dd
  db 0x61                      ; 000042BD  popa
  db 0x64, 0x61                ; 000042BE  fs popa
  db 0x70, 0x74                ; 000042C0  jo 0x4336
  db 0x6F                      ; 000042C2  outsw
  db 0x72, 0x20                ; 000042C3  jc 0x42e5
  db 0x69, 0x6E, 0x73, 0x74, 0x61 ; 000042C5  imul bp,[bp+0x73],word 0x6174
  db 0x6C                      ; 000042CA  insb
  db 0x6C                      ; 000042CB  insb
  db 0x65, 0x72, 0x65          ; 000042CC  gs jc 0x4334
  db 0x74, 0x0D                ; 000042CF  jz 0x42de
  db 0x0A, 0x00                ; 000042D1  or al,[bx+si]
  db 0x0D, 0x0A, 0x4E          ; 000042D3  or ax,0x4e0a
  db 0x75, 0x6D                ; 000042D6  jnz 0x4345
  db 0x65, 0x72, 0x69          ; 000042D8  gs jc 0x4344
  db 0x73, 0x6B                ; 000042DB  jnc 0x4348
  db 0x20, 0x52, 0x65          ; 000042DD  and [bp+si+0x65],dl
  db 0x67, 0x6E                ; 000042E0  a32 outsb
  db 0x65, 0x65, 0x6E          ; 000042E2  gs outsb
  db 0x68, 0x65, 0x64          ; 000042E5  push word 0x6465
  db 0x20, 0x69, 0x6E          ; 000042E8  and [bx+di+0x6e],ch
  db 0x73, 0x74                ; 000042EB  jnc 0x4361
  db 0x61                      ; 000042ED  popa
  db 0x6C                      ; 000042EE  insb
  db 0x6C                      ; 000042EF  insb
  db 0x65, 0x72, 0x65          ; 000042F0  gs jc 0x4358
  db 0x74, 0x0D                ; 000042F3  jz 0x4302
  db 0x0A, 0x00                ; 000042F5  or al,[bx+si]
  db 0x57                      ; 000042F7  push di
  db 0x69, 0x6E, 0x63, 0x68, 0x65 ; 000042F8  imul bp,[bp+0x63],word 0x6568
  db 0x73, 0x74                ; 000042FD  jnc 0x4373
  db 0x65, 0x72, 0x20          ; 000042FF  gs jc 0x4322
  db 0x64, 0x69, 0x73, 0x6B, 0x20, 0x20 ; 00004302  imul si,[fs:bp+di+0x6b],word 0x2020
  db 0x58                      ; 00004308  pop ax
  db 0x20, 0x65, 0x72          ; 00004309  and [di+0x72],ah
  db 0x20, 0x69, 0x6B          ; 0000430C  and [bx+di+0x6b],ch
  db 0x6B, 0x65, 0x20, 0x69    ; 0000430F  imul sp,[di+0x20],byte +0x69
  db 0x6E                      ; 00004313  outsb
  db 0x69, 0x74, 0x69, 0x61, 0x6C ; 00004314  imul si,[si+0x69],word 0x6c61
  db 0x69, 0x73, 0x65, 0x72, 0x65 ; 00004319  imul si,[bp+di+0x65],word 0x6572
  db 0x74, 0x0D                ; 0000431E  jz 0x432d
  db 0x0A, 0x00                ; 00004320  or al,[bx+si]
  db 0x57                      ; 00004322  push di
  db 0x69, 0x6E, 0x63, 0x68, 0x65 ; 00004323  imul bp,[bp+0x63],word 0x6568
  db 0x73, 0x74                ; 00004328  jnc 0x439e
  db 0x65, 0x72, 0x20          ; 0000432A  gs jc 0x434d
  db 0x64, 0x69, 0x73, 0x6B, 0x20, 0x20 ; 0000432D  imul si,[fs:bp+di+0x6b],word 0x2020
  db 0x78, 0x20                ; 00004333  js 0x4355
  db 0x68, 0x61, 0x72          ; 00004335  push word 0x7261
  db 0x20, 0x64, 0x7D          ; 00004338  and [si+0x7d],ah
  db 0x72, 0x6C                ; 0000433B  jc 0x43a9
  db 0x69, 0x67, 0x20, 0x6B, 0x6F ; 0000433D  imul sp,[bx+0x20],word 0x6f6b
  db 0x6E                      ; 00004342  outsb
  db 0x66, 0x69, 0x67, 0x75, 0x72, 0x61, 0x74, 0x69 ; 00004343  imul esp,[bx+0x75],dword 0x69746172
  db 0x6F                      ; 0000434B  outsw
  db 0x6E                      ; 0000434C  outsb
  db 0x73, 0x20                ; 0000434D  jnc 0x436f
  db 0x73, 0x65                ; 0000434F  jnc 0x43b6
  db 0x6B, 0x74, 0x6F, 0x72    ; 00004351  imul si,[si+0x6f],byte +0x72
  db 0x0D, 0x0A, 0x00          ; 00004355  or ax,0xa
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
  db 0x0E                      ; 0000503C  push cs
  db 0x1F                      ; 0000503D  pop ds
  db 0xFC                      ; 0000503E  cld
  db 0xBB, 0xB2, 0x45          ; 0000503F  mov bx,0x45b2
  db 0x8B, 0x57, 0x0A          ; 00005042  mov dx,[bx+0xa]
  db 0xB1, 0x0C                ; 00005045  mov cl,0xc
  db 0xD3, 0xE2                ; 00005047  shl dx,cl
  db 0x8E, 0xC2                ; 00005049  mov es,dx
  db 0x8B, 0x7F, 0x08          ; 0000504B  mov di,[bx+0x8]
  db 0x26, 0xC6, 0x45, 0x01, 0x05 ; 0000504E  mov byte [es:di+0x1],0x5
  db 0x8C, 0xCA                ; 00005053  mov dx,cs
  db 0xB8, 0xF8, 0x6D          ; 00005055  mov ax,0x6df8
  db 0xE8, 0xF8, 0xCF          ; 00005058  call 0x2053
  db 0x83, 0xC7, 0x0E          ; 0000505B  add di,byte +0xe
  db 0xAB                      ; 0000505E  stosw
  db 0x8B, 0xC1                ; 0000505F  mov ax,cx
  db 0xAB                      ; 00005061  stosw
  db 0xBA, 0x40, 0x02          ; 00005062  mov dx,0x240
  db 0xEE                      ; 00005065  out dx,al
  db 0x0E                      ; 00005066  push cs
  db 0x07                      ; 00005067  pop es
  db 0xBF, 0xFE, 0x6D          ; 00005068  mov di,0x6dfe
  db 0xB8, 0x7A, 0x6E          ; 0000506B  mov ax,0x6e7a
  db 0xE8, 0xD3, 0xCF          ; 0000506E  call 0x2044
  db 0xB8, 0x02, 0x6F          ; 00005071  mov ax,0x6f02
  db 0xE8, 0xCD, 0xCF          ; 00005074  call 0x2044
  db 0xBF, 0x16, 0x6E          ; 00005077  mov di,0x6e16
  db 0xB8, 0x1E, 0x6E          ; 0000507A  mov ax,0x6e1e
  db 0xE8, 0xC4, 0xCF          ; 0000507D  call 0x2044
  db 0xB8, 0x96, 0x6F          ; 00005080  mov ax,0x6f96
  db 0xE8, 0xBE, 0xCF          ; 00005083  call 0x2044
  db 0xB8, 0x8A, 0x6F          ; 00005086  mov ax,0x6f8a
  db 0x50                      ; 00005089  push ax
  db 0xBF, 0x7A, 0x6E          ; 0000508A  mov di,0x6e7a
  db 0xE8, 0xB4, 0xCF          ; 0000508D  call 0x2044
  db 0x58                      ; 00005090  pop ax
  db 0xBF, 0x02, 0x6F          ; 00005091  mov di,0x6f02
  db 0xE8, 0xAD, 0xCF          ; 00005094  call 0x2044
  db 0x2E, 0xA1, 0xD2, 0x2F    ; 00005097  mov ax,[cs:0x2fd2]
  db 0x8E, 0xC0                ; 0000509B  mov es,ax
  db 0x33, 0xFF                ; 0000509D  xor di,di
  db 0xB9, 0x00, 0x40          ; 0000509F  mov cx,0x4000
  db 0xB8, 0xFF, 0x00          ; 000050A2  mov ax,0xff
  db 0xF3, 0xAB                ; 000050A5  rep stosw
  db 0x1E                      ; 000050A7  push ds
  db 0x2E, 0xA1, 0xD2, 0x2F    ; 000050A8  mov ax,[cs:0x2fd2]
  db 0x8E, 0xC0                ; 000050AC  mov es,ax
  db 0x2E, 0xC5, 0x1E, 0x7C, 0x70 ; 000050AE  lds bx,[cs:0x707c]
  db 0xC5, 0x37                ; 000050B3  lds si,[bx]
  db 0xAC                      ; 000050B5  lodsb
  db 0xB1, 0x05                ; 000050B6  mov cl,0x5
  db 0x32, 0xE4                ; 000050B8  xor ah,ah
  db 0xD3, 0xE0                ; 000050BA  shl ax,cl
  db 0x8B, 0xF8                ; 000050BC  mov di,ax
  db 0xB9, 0x0A, 0x00          ; 000050BE  mov cx,0xa
  db 0xB0, 0xFF                ; 000050C1  mov al,0xff
  db 0x8A, 0x24                ; 000050C3  mov ah,[si]
  db 0xAB                      ; 000050C5  stosw
  db 0x46                      ; 000050C6  inc si
  db 0xE2, 0xFA                ; 000050C7  loop 0x50c3
  db 0xAC                      ; 000050C9  lodsb
  db 0x0A, 0xC0                ; 000050CA  or al,al
  db 0x75, 0xE8                ; 000050CC  jnz 0x50b6
  db 0x06                      ; 000050CE  push es
  db 0x1E                      ; 000050CF  push ds
  db 0x0E                      ; 000050D0  push cs
  db 0x1F                      ; 000050D1  pop ds
  db 0xB0, 0x33                ; 000050D2  mov al,0x33
  db 0xB9, 0x97, 0x00          ; 000050D4  mov cx,0x97
  db 0xBA, 0x79, 0x5E          ; 000050D7  mov dx,0x5e79
  db 0xCD, 0x28                ; 000050DA  int 0x28
  db 0xB9, 0x98, 0x00          ; 000050DC  mov cx,0x98
  db 0xB0, 0x33                ; 000050DF  mov al,0x33
  db 0xBA, 0x99, 0x5E          ; 000050E1  mov dx,0x5e99
  db 0xCD, 0x28                ; 000050E4  int 0x28
  db 0xB0, 0x34                ; 000050E6  mov al,0x34
  db 0xB9, 0x97, 0x00          ; 000050E8  mov cx,0x97
  db 0xBA, 0x99, 0x5E          ; 000050EB  mov dx,0x5e99
  db 0xCD, 0x28                ; 000050EE  int 0x28
  db 0xB0, 0x34                ; 000050F0  mov al,0x34
  db 0xB9, 0x98, 0x00          ; 000050F2  mov cx,0x98
  db 0xBA, 0x79, 0x5E          ; 000050F5  mov dx,0x5e79
  db 0xCD, 0x28                ; 000050F8  int 0x28
  db 0x1F                      ; 000050FA  pop ds
  db 0x07                      ; 000050FB  pop es
  db 0x8C, 0xC0                ; 000050FC  mov ax,es
  db 0x8E, 0xD8                ; 000050FE  mov ds,ax
  db 0x33, 0xF6                ; 00005100  xor si,si
  db 0xBF, 0x00, 0x20          ; 00005102  mov di,0x2000
  db 0xB9, 0x00, 0x30          ; 00005105  mov cx,0x3000
  db 0xF3, 0xA5                ; 00005108  rep movsw
  db 0x1F                      ; 0000510A  pop ds
  db 0xBB, 0xB2, 0x45          ; 0000510B  mov bx,0x45b2
  db 0xF6, 0x47, 0x12, 0x01    ; 0000510E  test byte [bx+0x12],0x1
  db 0x75, 0x22                ; 00005112  jnz 0x5136
  db 0x2E, 0xC6, 0x06, 0x88, 0x2F, 0xFF ; 00005114  mov byte [cs:0x2f88],0xff
  db 0x2E, 0xC6, 0x06, 0x8B, 0x2F, 0x38 ; 0000511A  mov byte [cs:0x2f8b],0x38
  db 0xBB, 0xE3, 0x45          ; 00005120  mov bx,0x45e3
  db 0x8A, 0x47, 0x16          ; 00005123  mov al,[bx+0x16]
  db 0xB1, 0x04                ; 00005126  mov cl,0x4
  db 0xD2, 0xC0                ; 00005128  rol al,cl
  db 0x24, 0xF0                ; 0000512A  and al,0xf0
  db 0x75, 0x02                ; 0000512C  jnz 0x5130
  db 0xB0, 0x60                ; 0000512E  mov al,0x60
  db 0x2E, 0xA2, 0x8C, 0x2F    ; 00005130  mov [cs:0x2f8c],al
  db 0xEB, 0x07                ; 00005134  jmp short 0x513d
  db 0x2E, 0xC7, 0x06, 0xF6, 0x12, 0x00, 0x00 ; 00005136  mov word [cs:0x12f6],0x0
  db 0xBB, 0xE3, 0x45          ; 0000513D  mov bx,0x45e3
  db 0x8A, 0x47, 0x13          ; 00005140  mov al,[bx+0x13]
  db 0x8A, 0xD0                ; 00005143  mov dl,al
  db 0x24, 0x01                ; 00005145  and al,0x1
  db 0x2E, 0xA2, 0x8A, 0x2F    ; 00005147  mov [cs:0x2f8a],al
  db 0xB1, 0x04                ; 0000514B  mov cl,0x4
  db 0xD2, 0xEA                ; 0000514D  shr dl,cl
  db 0xFE, 0xCA                ; 0000514F  dec dl
  db 0x80, 0xFA, 0x09          ; 00005151  cmp dl,0x9
  db 0x76, 0x02                ; 00005154  jna 0x5158
  db 0xB2, 0x09                ; 00005156  mov dl,0x9
  db 0x2E, 0x88, 0x16, 0x89, 0x2F ; 00005158  mov [cs:0x2f89],dl
  db 0xB0, 0x0A                ; 0000515D  mov al,0xa
  db 0xB4, 0x09                ; 0000515F  mov ah,0x9
  db 0x2A, 0xE2                ; 00005161  sub ah,dl
  db 0x2E, 0xA3, 0x30, 0x6E    ; 00005163  mov [cs:0x6e30],ax
  db 0xB0, 0x00                ; 00005167  mov al,0x0
  db 0xF6, 0x47, 0x12, 0xF0    ; 00005169  test byte [bx+0x12],0xf0
  db 0x74, 0x02                ; 0000516D  jz 0x5171
  db 0xB0, 0x01                ; 0000516F  mov al,0x1
  db 0x2E, 0xA2, 0x95, 0x2F    ; 00005171  mov [cs:0x2f95],al
  db 0x2E, 0x8B, 0x16, 0x38, 0x0C ; 00005175  mov dx,[cs:0xc38]
  db 0x2E, 0x89, 0x16, 0x7E, 0x2F ; 0000517A  mov [cs:0x2f7e],dx
  db 0x8E, 0xC2                ; 0000517F  mov es,dx
  db 0xB9, 0x04, 0x00          ; 00005181  mov cx,0x4
  db 0xBB, 0x2E, 0x2D          ; 00005184  mov bx,0x2d2e
  db 0xBF, 0x00, 0x0F          ; 00005187  mov di,0xf00
  db 0x33, 0xF6                ; 0000518A  xor si,si
  db 0x51                      ; 0000518C  push cx
  db 0xB9, 0x1A, 0x00          ; 0000518D  mov cx,0x1a
  db 0x89, 0x7F, 0x62          ; 00005190  mov [bx+0x62],di
  db 0x89, 0x38                ; 00005193  mov [bx+si],di
  db 0x51                      ; 00005195  push cx
  db 0xB9, 0x50, 0x00          ; 00005196  mov cx,0x50
  db 0xB8, 0x20, 0x08          ; 00005199  mov ax,0x820
  db 0xFC                      ; 0000519C  cld
  db 0xF3, 0xAB                ; 0000519D  rep stosw
  db 0x46                      ; 0000519F  inc si
  db 0x46                      ; 000051A0  inc si
  db 0x59                      ; 000051A1  pop cx
  db 0xE2, 0xEF                ; 000051A2  loop 0x5193
  db 0x57                      ; 000051A4  push di
  db 0xE8, 0xBE, 0xCE          ; 000051A5  call 0x2066
  db 0x2E, 0xA0, 0x8C, 0x2F    ; 000051A8  mov al,[cs:0x2f8c]
  db 0x88, 0x87, 0x80, 0x00    ; 000051AC  mov [bx+0x80],al
  db 0x80, 0x4F, 0x6B, 0x08    ; 000051B0  or byte [bx+0x6b],0x8
  db 0xC0, 0xE8, 0x04          ; 000051B4  shr al,byte 0x4
  db 0x88, 0x47, 0x7F          ; 000051B7  mov [bx+0x7f],al
  db 0x2E, 0xA0, 0x95, 0x2F    ; 000051BA  mov al,[cs:0x2f95]
  db 0x88, 0x47, 0x71          ; 000051BE  mov [bx+0x71],al
  db 0x2E, 0xA0, 0x8A, 0x2F    ; 000051C1  mov al,[cs:0x2f8a]
  db 0x88, 0x47, 0x74          ; 000051C5  mov [bx+0x74],al
  db 0x2E, 0xA1, 0x30, 0x6E    ; 000051C8  mov ax,[cs:0x6e30]
  db 0x89, 0x47, 0x72          ; 000051CC  mov [bx+0x72],ax
  db 0x5F                      ; 000051CF  pop di
  db 0x81, 0xC3, 0x94, 0x00    ; 000051D0  add bx,0x94
  db 0x59                      ; 000051D4  pop cx
  db 0xE2, 0xB3                ; 000051D5  loop 0x518a
  db 0x1E                      ; 000051D7  push ds
  db 0x07                      ; 000051D8  pop es
  db 0xBF, 0x9F, 0x4F          ; 000051D9  mov di,0x4f9f
  db 0xB9, 0x80, 0x07          ; 000051DC  mov cx,0x780
  db 0xB0, 0x0F                ; 000051DF  mov al,0xf
  db 0xF3, 0xAA                ; 000051E1  rep stosb
  db 0xBF, 0x1E, 0x2D          ; 000051E3  mov di,0x2d1e
  db 0xB9, 0x10, 0x00          ; 000051E6  mov cx,0x10
  db 0x32, 0xC0                ; 000051E9  xor al,al
  db 0xF3, 0xAA                ; 000051EB  rep stosb
  db 0xBF, 0x1E, 0x2D          ; 000051ED  mov di,0x2d1e
  db 0xBA, 0x03, 0x00          ; 000051F0  mov dx,0x3
  db 0x8B, 0xDA                ; 000051F3  mov bx,dx
  db 0xD1, 0xE3                ; 000051F5  shl bx,1
  db 0x2E, 0x8B, 0x9F, 0x80, 0x2F ; 000051F7  mov bx,[cs:bx+0x2f80]
  db 0xE8, 0xA2, 0xC9          ; 000051FC  call 0x1ba1
  db 0xFE, 0xCA                ; 000051FF  dec dl
  db 0x79, 0xF0                ; 00005201  jns 0x51f3
  db 0xBF, 0x1F, 0x57          ; 00005203  mov di,0x571f
  db 0x57                      ; 00005206  push di
  db 0x33, 0xC0                ; 00005207  xor ax,ax
  db 0xB9, 0xC8, 0x01          ; 00005209  mov cx,0x1c8
  db 0xF3, 0xAB                ; 0000520C  rep stosw
  db 0x5F                      ; 0000520E  pop di
  db 0x81, 0xC7, 0xF0, 0x00    ; 0000520F  add di,0xf0
  db 0xBE, 0x45, 0x5E          ; 00005213  mov si,0x5e45
  db 0xB9, 0x34, 0x00          ; 00005216  mov cx,0x34
  db 0xF3, 0xA4                ; 00005219  rep movsb
  db 0x2E, 0x80, 0x3E, 0xF8, 0x6D, 0x01 ; 0000521B  cmp byte [cs:0x6df8],0x1
  db 0x74, 0xF8                ; 00005221  jz 0x521b
  db 0xB4, 0x04                ; 00005223  mov ah,0x4
  db 0xE8, 0xFC, 0xCD          ; 00005225  call 0x2024
  db 0xB4, 0x06                ; 00005228  mov ah,0x6
  db 0xE8, 0xF7, 0xCD          ; 0000522A  call 0x2024
  db 0xBB, 0x2E, 0x2D          ; 0000522D  mov bx,0x2d2e
  db 0xE8, 0x72, 0xC2          ; 00005230  call 0x14a5
  db 0xE8, 0xD3, 0xC2          ; 00005233  call 0x1509
  db 0xBA, 0x5E, 0xFF          ; 00005236  mov dx,0xff5e
  db 0xB8, 0x00, 0x02          ; 00005239  mov ax,0x200
  db 0x83, 0xEA, 0x02          ; 0000523C  sub dx,byte +0x2
  db 0xEF                      ; 0000523F  out dx,ax
  db 0x83, 0xEA, 0x02          ; 00005240  sub dx,byte +0x2
  db 0xEF                      ; 00005243  out dx,ax
  db 0xC3                      ; 00005244  ret
  db 0x1B, 0x48, 0x00          ; 00005245  sbb cx,[bx+si+0x0]
  db 0x00, 0x1B                ; 00005248  add [bp+di],bl
  db 0x41                      ; 0000524A  inc cx
  db 0x00, 0x00                ; 0000524B  add [bx+si],al
  db 0x00, 0x00                ; 0000524D  add [bx+si],al
  db 0x00, 0x00                ; 0000524F  add [bx+si],al
  db 0x00, 0x00                ; 00005251  add [bx+si],al
  db 0x00, 0x00                ; 00005253  add [bx+si],al
  db 0x1B, 0x44, 0x00          ; 00005255  sbb ax,[si+0x0]
  db 0x00, 0x0D                ; 00005258  add [di],cl
  db 0x00, 0x00                ; 0000525A  add [bx+si],al
  db 0x00, 0x1B                ; 0000525C  add [bp+di],bl
  db 0x43                      ; 0000525E  inc bx
  db 0x00, 0x00                ; 0000525F  add [bx+si],al
  db 0x00, 0x00                ; 00005261  add [bx+si],al
  db 0x00, 0x00                ; 00005263  add [bx+si],al
  db 0x00, 0x00                ; 00005265  add [bx+si],al
  db 0x00, 0x00                ; 00005267  add [bx+si],al
  db 0x1B, 0x42, 0x00          ; 00005269  sbb ax,[bp+si+0x0]
  db 0x00, 0x09                ; 0000526C  add [bx+di],cl
  db 0x00, 0x00                ; 0000526E  add [bx+si],al
  db 0x00, 0x7F, 0x4C          ; 00005270  add [bx+0x4c],bh
  db 0x00, 0x00                ; 00005273  add [bx+si],al
  db 0x7F, 0x00                ; 00005275  jg 0x5277
  db 0x00, 0x00                ; 00005277  add [bx+si],al
  db 0x00, 0x00                ; 00005279  add [bx+si],al
  db 0x00, 0x00                ; 0000527B  add [bx+si],al
  db 0x00, 0x00                ; 0000527D  add [bx+si],al
  db 0x00, 0x00                ; 0000527F  add [bx+si],al
  db 0x00, 0x00                ; 00005281  add [bx+si],al
  db 0x00, 0x00                ; 00005283  add [bx+si],al
  db 0x00, 0x00                ; 00005285  add [bx+si],al
  db 0x00, 0x00                ; 00005287  add [bx+si],al
  db 0x00, 0x00                ; 00005289  add [bx+si],al
  db 0x00, 0x00                ; 0000528B  add [bx+si],al
  db 0x00, 0x00                ; 0000528D  add [bx+si],al
  db 0x00, 0x00                ; 0000528F  add [bx+si],al
  db 0x00, 0x00                ; 00005291  add [bx+si],al
  db 0x00, 0x00                ; 00005293  add [bx+si],al
  db 0x00, 0x00                ; 00005295  add [bx+si],al
  db 0x00, 0x00                ; 00005297  add [bx+si],al
  db 0x00, 0x00                ; 00005299  add [bx+si],al
  db 0x00, 0x00                ; 0000529B  add [bx+si],al
  db 0x00, 0x00                ; 0000529D  add [bx+si],al
  db 0x00, 0x00                ; 0000529F  add [bx+si],al
  db 0x00, 0x00                ; 000052A1  add [bx+si],al
  db 0x00, 0x00                ; 000052A3  add [bx+si],al
  db 0x00, 0x00                ; 000052A5  add [bx+si],al
  db 0x00, 0x00                ; 000052A7  add [bx+si],al
  db 0x00, 0x00                ; 000052A9  add [bx+si],al
  db 0x00, 0x00                ; 000052AB  add [bx+si],al
  db 0x00, 0x00                ; 000052AD  add [bx+si],al
  db 0x00, 0x00                ; 000052AF  add [bx+si],al
  db 0x00, 0x00                ; 000052B1  add [bx+si],al
  db 0x00, 0x00                ; 000052B3  add [bx+si],al
  db 0x00, 0x00                ; 000052B5  add [bx+si],al
  db 0x00, 0x00                ; 000052B7  add [bx+si],al
  db 0x00, 0x00                ; 000052B9  add [bx+si],al
  db 0x00, 0x00                ; 000052BB  add [bx+si],al
  db 0x00, 0x00                ; 000052BD  add [bx+si],al
  db 0x01, 0x01                ; 000052BF  add [bx+di],ax
  db 0x00, 0x00                ; 000052C1  add [bx+si],al
  db 0x1F                      ; 000052C3  pop ds
  db 0x1C, 0x1F                ; 000052C4  sbb al,0x1f
  db 0x1E                      ; 000052C6  push ds
  db 0x1F                      ; 000052C7  pop ds
  db 0x1E                      ; 000052C8  push ds
  db 0x1F                      ; 000052C9  pop ds
  db 0x1F                      ; 000052CA  pop ds
  db 0x1E                      ; 000052CB  push ds
  db 0x1F                      ; 000052CC  pop ds
  db 0x1E                      ; 000052CD  push ds
  db 0x1F                      ; 000052CE  pop ds
  db 0x00, 0x1F                ; 000052CF  add [bx],bl
  db 0x1D, 0x1F, 0x1E          ; 000052D1  sbb ax,0x1e1f
  db 0x1F                      ; 000052D4  pop ds
  db 0x1E                      ; 000052D5  push ds
  db 0x1F                      ; 000052D6  pop ds
  db 0x1F                      ; 000052D7  pop ds
  db 0x1E                      ; 000052D8  push ds
  db 0x1F                      ; 000052D9  pop ds
  db 0x1E                      ; 000052DA  push ds
  db 0x1F                      ; 000052DB  pop ds
  db 0x00, 0x00                ; 000052DC  add [bx+si],al
  db 0x00, 0x00                ; 000052DE  add [bx+si],al
  db 0x00, 0x00                ; 000052E0  add [bx+si],al
  db 0x00, 0x00                ; 000052E2  add [bx+si],al
  db 0x00, 0x00                ; 000052E4  add [bx+si],al
  db 0x00, 0x00                ; 000052E6  add [bx+si],al
  db 0x04, 0x00                ; 000052E8  add al,0x0
  db 0x0C, 0x00                ; 000052EA  or al,0x0
  db 0x84, 0x03                ; 000052EC  test [bp+di],al
  db 0x06                      ; 000052EE  push es
  db 0x2E, 0xA1, 0x06, 0x0C    ; 000052EF  mov ax,[cs:0xc06]
  db 0x8E, 0xC0                ; 000052F3  mov es,ax
  db 0xBB, 0x00, 0x00          ; 000052F5  mov bx,0x0
  db 0xB0, 0x02                ; 000052F8  mov al,0x2
  db 0xE8, 0xD6, 0xE8          ; 000052FA  call 0x3bd3
  db 0x26, 0x88, 0x87, 0x82, 0x00 ; 000052FD  mov [es:bx+0x82],al
  db 0xB0, 0x03                ; 00005302  mov al,0x3
  db 0xE8, 0xCC, 0xE8          ; 00005304  call 0x3bd3
  db 0x26, 0x88, 0x87, 0x81, 0x00 ; 00005307  mov [es:bx+0x81],al
  db 0xB0, 0x04                ; 0000530C  mov al,0x4
  db 0xE8, 0xC2, 0xE8          ; 0000530E  call 0x3bd3
  db 0x26, 0x88, 0x87, 0x80, 0x00 ; 00005311  mov [es:bx+0x80],al
  db 0xB0, 0x07                ; 00005316  mov al,0x7
  db 0xE8, 0xB8, 0xE8          ; 00005318  call 0x3bd3
  db 0xE8, 0x12, 0x00          ; 0000531B  call 0x5330
  db 0x2E, 0xA2, 0xC0, 0x5E    ; 0000531E  mov [cs:0x5ec0],al
  db 0xB0, 0x06                ; 00005322  mov al,0x6
  db 0xE8, 0xAC, 0xE8          ; 00005324  call 0x3bd3
  db 0xE8, 0x06, 0x00          ; 00005327  call 0x5330
  db 0x2E, 0xA2, 0xBF, 0x5E    ; 0000532A  mov [cs:0x5ebf],al
  db 0x07                      ; 0000532E  pop es
  db 0xC3                      ; 0000532F  ret
  db 0x8A, 0xE0                ; 00005330  mov ah,al
  db 0x80, 0xE4, 0xF0          ; 00005332  and ah,0xf0
  db 0xB1, 0x04                ; 00005335  mov cl,0x4
  db 0xD2, 0xEC                ; 00005337  shr ah,cl
  db 0x24, 0x0F                ; 00005339  and al,0xf
  db 0xD5, 0x0A                ; 0000533B  aad
  db 0xC3                      ; 0000533D  ret
  db 0x06                      ; 0000533E  push es
  db 0x2E, 0xA1, 0x06, 0x0C    ; 0000533F  mov ax,[cs:0xc06]
  db 0x8E, 0xC0                ; 00005343  mov es,ax
  db 0xBB, 0x00, 0x00          ; 00005345  mov bx,0x0
  db 0xB0, 0x02                ; 00005348  mov al,0x2
  db 0xE8, 0x86, 0xE8          ; 0000534A  call 0x3bd3
  db 0x26, 0x88, 0x87, 0x82, 0x00 ; 0000534D  mov [es:bx+0x82],al
  db 0xB0, 0x03                ; 00005352  mov al,0x3
  db 0xE8, 0x7C, 0xE8          ; 00005354  call 0x3bd3
  db 0x26, 0x88, 0x87, 0x81, 0x00 ; 00005357  mov [es:bx+0x81],al
  db 0xB0, 0x04                ; 0000535C  mov al,0x4
  db 0xE8, 0x72, 0xE8          ; 0000535E  call 0x3bd3
  db 0x24, 0x7F                ; 00005361  and al,0x7f
  db 0x26, 0x88, 0x87, 0x80, 0x00 ; 00005363  mov [es:bx+0x80],al
  db 0xB0, 0x06                ; 00005368  mov al,0x6
  db 0xE8, 0x66, 0xE8          ; 0000536A  call 0x3bd3
  db 0xE8, 0xC0, 0xFF          ; 0000536D  call 0x5330
  db 0x2E, 0xA2, 0xC0, 0x5E    ; 00005370  mov [cs:0x5ec0],al
  db 0xB0, 0x05                ; 00005374  mov al,0x5
  db 0xE8, 0x5A, 0xE8          ; 00005376  call 0x3bd3
  db 0xE8, 0xB4, 0xFF          ; 00005379  call 0x5330
  db 0x2E, 0xA2, 0xBF, 0x5E    ; 0000537C  mov [cs:0x5ebf],al
  db 0x07                      ; 00005380  pop es
  db 0xC3                      ; 00005381  ret
  db 0x52                      ; 00005382  push dx
  db 0x53                      ; 00005383  push bx
  db 0x51                      ; 00005384  push cx
  db 0x50                      ; 00005385  push ax
  db 0xE8, 0x4C, 0x00          ; 00005386  call 0x53d5
  db 0x8A, 0xD8                ; 00005389  mov bl,al
  db 0xB4, 0x00                ; 0000538B  mov ah,0x0
  db 0xB0, 0x00                ; 0000538D  mov al,0x0
  db 0xE8, 0x43, 0x00          ; 0000538F  call 0x53d5
  db 0x8A, 0xF8                ; 00005392  mov bh,al
  db 0x58                      ; 00005394  pop ax
  db 0x50                      ; 00005395  push ax
  db 0xE8, 0x60, 0x00          ; 00005396  call 0x53f9
  db 0x58                      ; 00005399  pop ax
  db 0xBA, 0x80, 0x00          ; 0000539A  mov dx,0x80
  db 0xD0, 0xE0                ; 0000539D  shl al,1
  db 0xD0, 0xE0                ; 0000539F  shl al,1
  db 0x32, 0xE4                ; 000053A1  xor ah,ah
  db 0x03, 0xD0                ; 000053A3  add dx,ax
  db 0x59                      ; 000053A5  pop cx
  db 0x51                      ; 000053A6  push cx
  db 0x8A, 0xC1                ; 000053A7  mov al,cl
  db 0xB1, 0x04                ; 000053A9  mov cl,0x4
  db 0xD2, 0xE8                ; 000053AB  shr al,cl
  db 0xEE                      ; 000053AD  out dx,al
  db 0x59                      ; 000053AE  pop cx
  db 0x8A, 0xC1                ; 000053AF  mov al,cl
  db 0x24, 0x0F                ; 000053B1  and al,0xf
  db 0x83, 0xC2, 0x02          ; 000053B3  add dx,byte +0x2
  db 0xEE                      ; 000053B6  out dx,al
  db 0x2A, 0xD9                ; 000053B7  sub bl,cl
  db 0x02, 0xFB                ; 000053B9  add bh,bl
  db 0xB4, 0x00                ; 000053BB  mov ah,0x0
  db 0xE8, 0x39, 0x00          ; 000053BD  call 0x53f9
  db 0xBA, 0x80, 0x00          ; 000053C0  mov dx,0x80
  db 0x8A, 0xC7                ; 000053C3  mov al,bh
  db 0xB1, 0x04                ; 000053C5  mov cl,0x4
  db 0xD2, 0xE8                ; 000053C7  shr al,cl
  db 0xEE                      ; 000053C9  out dx,al
  db 0x8A, 0xC7                ; 000053CA  mov al,bh
  db 0x24, 0x0F                ; 000053CC  and al,0xf
  db 0x83, 0xC2, 0x02          ; 000053CE  add dx,byte +0x2
  db 0xEE                      ; 000053D1  out dx,al
  db 0x5B                      ; 000053D2  pop bx
  db 0x5A                      ; 000053D3  pop dx
  db 0xC3                      ; 000053D4  ret
  db 0x52                      ; 000053D5  push dx
  db 0x51                      ; 000053D6  push cx
  db 0x50                      ; 000053D7  push ax
  db 0xE8, 0x1E, 0x00          ; 000053D8  call 0x53f9
  db 0xBA, 0x80, 0x00          ; 000053DB  mov dx,0x80
  db 0x58                      ; 000053DE  pop ax
  db 0xD0, 0xE0                ; 000053DF  shl al,1
  db 0xD0, 0xE0                ; 000053E1  shl al,1
  db 0x32, 0xE4                ; 000053E3  xor ah,ah
  db 0x03, 0xD0                ; 000053E5  add dx,ax
  db 0xEC                      ; 000053E7  in al,dx
  db 0x83, 0xC2, 0x02          ; 000053E8  add dx,byte +0x2
  db 0x86, 0xE0                ; 000053EB  xchg ah,al
  db 0xEC                      ; 000053ED  in al,dx
  db 0xB1, 0x04                ; 000053EE  mov cl,0x4
  db 0xD2, 0xE4                ; 000053F0  shl ah,cl
  db 0x24, 0x0F                ; 000053F2  and al,0xf
  db 0x0A, 0xC4                ; 000053F4  or al,ah
  db 0x59                      ; 000053F6  pop cx
  db 0x5A                      ; 000053F7  pop dx
  db 0xC3                      ; 000053F8  ret
  db 0xBA, 0x74, 0x00          ; 000053F9  mov dx,0x74
  db 0xEC                      ; 000053FC  in al,dx
  db 0x24, 0xCF                ; 000053FD  and al,0xcf
  db 0xB1, 0x04                ; 000053FF  mov cl,0x4
  db 0xD2, 0xE4                ; 00005401  shl ah,cl
  db 0x0A, 0xC4                ; 00005403  or al,ah
  db 0xEE                      ; 00005405  out dx,al
  db 0xC3                      ; 00005406  ret
  db 0xFA                      ; 00005407  cli
  db 0xFC                      ; 00005408  cld
  db 0x2E, 0x8C, 0x06, 0xB9, 0x5E ; 00005409  mov [cs:0x5eb9],es
  db 0xBE, 0x50, 0x00          ; 0000540E  mov si,0x50
  db 0xBF, 0xB2, 0x45          ; 00005411  mov di,0x45b2
  db 0x1E                      ; 00005414  push ds
  db 0x07                      ; 00005415  pop es
  db 0x1E                      ; 00005416  push ds
  db 0x33, 0xC0                ; 00005417  xor ax,ax
  db 0x8E, 0xD8                ; 00005419  mov ds,ax
  db 0xB9, 0x30, 0x00          ; 0000541B  mov cx,0x30
  db 0xFC                      ; 0000541E  cld
  db 0xF3, 0xA4                ; 0000541F  rep movsb
  db 0x1F                      ; 00005421  pop ds
  db 0xB8, 0x00, 0x00          ; 00005422  mov ax,0x0
  db 0xB3, 0x00                ; 00005425  mov bl,0x0
  db 0xB7, 0x03                ; 00005427  mov bh,0x3
  db 0xB9, 0x20, 0x00          ; 00005429  mov cx,0x20
  db 0x50                      ; 0000542C  push ax
  db 0xE8, 0xA5, 0xFF          ; 0000542D  call 0x53d5
  db 0x02, 0xD8                ; 00005430  add bl,al
  db 0x58                      ; 00005432  pop ax
  db 0xFE, 0xC0                ; 00005433  inc al
  db 0xE2, 0xF5                ; 00005435  loop 0x542c
  db 0xFE, 0xC4                ; 00005437  inc ah
  db 0xB0, 0x00                ; 00005439  mov al,0x0
  db 0xB9, 0x20, 0x00          ; 0000543B  mov cx,0x20
  db 0xFE, 0xCF                ; 0000543E  dec bh
  db 0x75, 0xEA                ; 00005440  jnz 0x542c
  db 0x80, 0xFB, 0xAA          ; 00005442  cmp bl,0xaa
  db 0x75, 0x1D                ; 00005445  jnz 0x5464
  db 0xBB, 0xE3, 0x45          ; 00005447  mov bx,0x45e3
  db 0xB8, 0x00, 0x00          ; 0000544A  mov ax,0x0
  db 0x50                      ; 0000544D  push ax
  db 0xE8, 0x84, 0xFF          ; 0000544E  call 0x53d5
  db 0x88, 0x07                ; 00005451  mov [bx],al
  db 0x43                      ; 00005453  inc bx
  db 0x58                      ; 00005454  pop ax
  db 0xFE, 0xC0                ; 00005455  inc al
  db 0x3C, 0x20                ; 00005457  cmp al,0x20
  db 0x75, 0xF2                ; 00005459  jnz 0x544d
  db 0xB0, 0x00                ; 0000545B  mov al,0x0
  db 0xFE, 0xC4                ; 0000545D  inc ah
  db 0x80, 0xFC, 0x04          ; 0000545F  cmp ah,0x4
  db 0x75, 0xE9                ; 00005462  jnz 0x544d
  db 0xB4, 0x03                ; 00005464  mov ah,0x3
  db 0xE8, 0x90, 0xFF          ; 00005466  call 0x53f9
  db 0xBB, 0xB2, 0x45          ; 00005469  mov bx,0x45b2
  db 0x80, 0x67, 0x17, 0xDF    ; 0000546C  and byte [bx+0x17],0xdf
  db 0x80, 0x7F, 0x17, 0x50    ; 00005470  cmp byte [bx+0x17],0x50
  db 0x75, 0x19                ; 00005474  jnz 0x548f
  db 0x33, 0xC0                ; 00005476  xor ax,ax
  db 0x1E                      ; 00005478  push ds
  db 0x07                      ; 00005479  pop es
  db 0xBF, 0xDC, 0x5E          ; 0000547A  mov di,0x5edc
  db 0xB9, 0x03, 0x00          ; 0000547D  mov cx,0x3
  db 0xBB, 0xE8, 0x5E          ; 00005480  mov bx,0x5ee8
  db 0x8B, 0x37                ; 00005483  mov si,[bx]
  db 0x1E                      ; 00005485  push ds
  db 0x8E, 0xD8                ; 00005486  mov ds,ax
  db 0xA5                      ; 00005488  movsw
  db 0xA5                      ; 00005489  movsw
  db 0x1F                      ; 0000548A  pop ds
  db 0x43                      ; 0000548B  inc bx
  db 0x43                      ; 0000548C  inc bx
  db 0xE2, 0xF4                ; 0000548D  loop 0x5483
  db 0x33, 0xC0                ; 0000548F  xor ax,ax
  db 0x8B, 0xF8                ; 00005491  mov di,ax
  db 0x8E, 0xC0                ; 00005493  mov es,ax
  db 0x8C, 0xCB                ; 00005495  mov bx,cs
  db 0xB8, 0x90, 0x70          ; 00005497  mov ax,0x7090
  db 0xB1, 0x04                ; 0000549A  mov cl,0x4
  db 0xD3, 0xE8                ; 0000549C  shr ax,cl
  db 0x03, 0xD8                ; 0000549E  add bx,ax
  db 0x33, 0xC0                ; 000054A0  xor ax,ax
  db 0xB9, 0x00, 0x01          ; 000054A2  mov cx,0x100
  db 0xAB                      ; 000054A5  stosw
  db 0x40                      ; 000054A6  inc ax
  db 0x93                      ; 000054A7  xchg ax,bx
  db 0xAB                      ; 000054A8  stosw
  db 0x93                      ; 000054A9  xchg ax,bx
  db 0xE2, 0xF9                ; 000054AA  loop 0x54a5
  db 0xBB, 0xB2, 0x45          ; 000054AC  mov bx,0x45b2
  db 0x80, 0x67, 0x17, 0xDF    ; 000054AF  and byte [bx+0x17],0xdf
  db 0x80, 0x7F, 0x17, 0x50    ; 000054B3  cmp byte [bx+0x17],0x50
  db 0x75, 0x12                ; 000054B7  jnz 0x54cb
  db 0x33, 0xC0                ; 000054B9  xor ax,ax
  db 0x8E, 0xC0                ; 000054BB  mov es,ax
  db 0xB9, 0x03, 0x00          ; 000054BD  mov cx,0x3
  db 0xBB, 0xE8, 0x5E          ; 000054C0  mov bx,0x5ee8
  db 0x8B, 0x3F                ; 000054C3  mov di,[bx]
  db 0xA5                      ; 000054C5  movsw
  db 0xA5                      ; 000054C6  movsw
  db 0x43                      ; 000054C7  inc bx
  db 0x43                      ; 000054C8  inc bx
  db 0xE2, 0xF8                ; 000054C9  loop 0x54c3
  db 0xBB, 0xB2, 0x45          ; 000054CB  mov bx,0x45b2
  db 0x80, 0x67, 0x17, 0xDF    ; 000054CE  and byte [bx+0x17],0xdf
  db 0x80, 0x7F, 0x17, 0x50    ; 000054D2  cmp byte [bx+0x17],0x50
  db 0x74, 0x0C                ; 000054D6  jz 0x54e4
  db 0x8C, 0xCB                ; 000054D8  mov bx,cs
  db 0xBF, 0x0C, 0x00          ; 000054DA  mov di,0xc
  db 0xB8, 0xAB, 0x4A          ; 000054DD  mov ax,0x4aab
  db 0xAB                      ; 000054E0  stosw
  db 0x8B, 0xC3                ; 000054E1  mov ax,bx
  db 0xAB                      ; 000054E3  stosw
  db 0x8C, 0xCB                ; 000054E4  mov bx,cs
  db 0xBF, 0x08, 0x00          ; 000054E6  mov di,0x8
  db 0xB8, 0x5E, 0x3F          ; 000054E9  mov ax,0x3f5e
  db 0xAB                      ; 000054EC  stosw
  db 0x8B, 0xC3                ; 000054ED  mov ax,bx
  db 0xAB                      ; 000054EF  stosw
  db 0xBF, 0x28, 0x00          ; 000054F0  mov di,0x28
  db 0xB8, 0x9E, 0x3A          ; 000054F3  mov ax,0x3a9e
  db 0xAB                      ; 000054F6  stosw
  db 0x8B, 0xC3                ; 000054F7  mov ax,bx
  db 0xAB                      ; 000054F9  stosw
  db 0xBF, 0x2C, 0x00          ; 000054FA  mov di,0x2c
  db 0xB8, 0xB6, 0x3A          ; 000054FD  mov ax,0x3ab6
  db 0xAB                      ; 00005500  stosw
  db 0x8B, 0xC3                ; 00005501  mov ax,bx
  db 0xAB                      ; 00005503  stosw
  db 0xBF, 0x34, 0x00          ; 00005504  mov di,0x34
  db 0xB8, 0xED, 0x42          ; 00005507  mov ax,0x42ed
  db 0xAB                      ; 0000550A  stosw
  db 0x8B, 0xC3                ; 0000550B  mov ax,bx
  db 0xAB                      ; 0000550D  stosw
  db 0xBF, 0x3C, 0x00          ; 0000550E  mov di,0x3c
  db 0xB8, 0x24, 0x42          ; 00005511  mov ax,0x4224
  db 0xAB                      ; 00005514  stosw
  db 0x8B, 0xC3                ; 00005515  mov ax,bx
  db 0xAB                      ; 00005517  stosw
  db 0xBF, 0x80, 0x00          ; 00005518  mov di,0x80
  db 0xB8, 0x47, 0x37          ; 0000551B  mov ax,0x3747
  db 0xAB                      ; 0000551E  stosw
  db 0x8B, 0xC3                ; 0000551F  mov ax,bx
  db 0xAB                      ; 00005521  stosw
  db 0xBF, 0x84, 0x00          ; 00005522  mov di,0x84
  db 0xB8, 0xF3, 0x0E          ; 00005525  mov ax,0xef3
  db 0xAB                      ; 00005528  stosw
  db 0x8B, 0xC3                ; 00005529  mov ax,bx
  db 0xAB                      ; 0000552B  stosw
  db 0xBF, 0x8C, 0x00          ; 0000552C  mov di,0x8c
  db 0xB8, 0xBA, 0x46          ; 0000552F  mov ax,0x46ba
  db 0xAB                      ; 00005532  stosw
  db 0x8B, 0xC3                ; 00005533  mov ax,bx
  db 0xAB                      ; 00005535  stosw
  db 0xBF, 0x88, 0x00          ; 00005536  mov di,0x88
  db 0xB8, 0x9D, 0x45          ; 00005539  mov ax,0x459d
  db 0xAB                      ; 0000553C  stosw
  db 0x8B, 0xC3                ; 0000553D  mov ax,bx
  db 0xAB                      ; 0000553F  stosw
  db 0xBF, 0x90, 0x00          ; 00005540  mov di,0x90
  db 0xB8, 0x5A, 0x10          ; 00005543  mov ax,0x105a
  db 0xAB                      ; 00005546  stosw
  db 0x8B, 0xC3                ; 00005547  mov ax,bx
  db 0xAB                      ; 00005549  stosw
  db 0xBF, 0x98, 0x00          ; 0000554A  mov di,0x98
  db 0xB8, 0x88, 0x45          ; 0000554D  mov ax,0x4588
  db 0xAB                      ; 00005550  stosw
  db 0x8B, 0xC3                ; 00005551  mov ax,bx
  db 0xAB                      ; 00005553  stosw
  db 0xBF, 0x9C, 0x00          ; 00005554  mov di,0x9c
  db 0xB8, 0x88, 0x45          ; 00005557  mov ax,0x4588
  db 0xAB                      ; 0000555A  stosw
  db 0x8B, 0xC3                ; 0000555B  mov ax,bx
  db 0xAB                      ; 0000555D  stosw
  db 0xBF, 0x88, 0x03          ; 0000555E  mov di,0x388
  db 0xB8, 0x36, 0x4A          ; 00005561  mov ax,0x4a36
  db 0xAB                      ; 00005564  stosw
  db 0x8B, 0xC3                ; 00005565  mov ax,bx
  db 0xAB                      ; 00005567  stosw
  db 0xBF, 0x8C, 0x03          ; 00005568  mov di,0x38c
  db 0xB8, 0x39, 0x4A          ; 0000556B  mov ax,0x4a39
  db 0xAB                      ; 0000556E  stosw
  db 0x8B, 0xC3                ; 0000556F  mov ax,bx
  db 0xAB                      ; 00005571  stosw
  db 0xBF, 0xA0, 0x00          ; 00005572  mov di,0xa0
  db 0xB8, 0x91, 0x0C          ; 00005575  mov ax,0xc91
  db 0xAB                      ; 00005578  stosw
  db 0x8B, 0xC3                ; 00005579  mov ax,bx
  db 0xAB                      ; 0000557B  stosw
  db 0x2E, 0x8C, 0x0E, 0xB8, 0x46 ; 0000557C  mov [cs:0x46b8],cs
  db 0x2E, 0x8C, 0x0E, 0xB4, 0x46 ; 00005581  mov [cs:0x46b4],cs
  db 0xBB, 0xB2, 0x45          ; 00005586  mov bx,0x45b2
  db 0x80, 0x7F, 0x0C, 0xFF    ; 00005589  cmp byte [bx+0xc],0xff
  db 0x74, 0x0C                ; 0000558D  jz 0x559b
  db 0xB4, 0x04                ; 0000558F  mov ah,0x4
  db 0xB0, 0x11                ; 00005591  mov al,0x11
  db 0xE8, 0x21, 0xE6          ; 00005593  call 0x3bb7
  db 0xE8, 0x55, 0xFD          ; 00005596  call 0x52ee
  db 0xEB, 0x0D                ; 00005599  jmp short 0x55a8
  db 0xBA, 0x5C, 0x00          ; 0000559B  mov dx,0x5c
  db 0xB0, 0x07                ; 0000559E  mov al,0x7
  db 0xB4, 0xC4                ; 000055A0  mov ah,0xc4
  db 0xE8, 0x12, 0xE6          ; 000055A2  call 0x3bb7
  db 0xE8, 0x96, 0xFD          ; 000055A5  call 0x533e
  db 0x2E, 0xC7, 0x06, 0xBC, 0x5E, 0x00, 0x00 ; 000055A8  mov word [cs:0x5ebc],0x0
  db 0xBB, 0xE3, 0x45          ; 000055AF  mov bx,0x45e3
  db 0x8A, 0x47, 0x18          ; 000055B2  mov al,[bx+0x18]
  db 0xE8, 0x78, 0xFD          ; 000055B5  call 0x5330
  db 0x2E, 0xA2, 0xC1, 0x5E    ; 000055B8  mov [cs:0x5ec1],al
  db 0x8A, 0x47, 0x17          ; 000055BC  mov al,[bx+0x17]
  db 0xE8, 0x6E, 0xFD          ; 000055BF  call 0x5330
  db 0x2E, 0x3A, 0x06, 0xC0, 0x5E ; 000055C2  cmp al,[cs:0x5ec0]
  db 0x72, 0x1A                ; 000055C7  jc 0x55e3
  db 0x74, 0x28                ; 000055C9  jz 0x55f3
  db 0x2E, 0xFE, 0x06, 0xC1, 0x5E ; 000055CB  inc byte [cs:0x5ec1]
  db 0x2E, 0xA0, 0xC1, 0x5E    ; 000055D0  mov al,[cs:0x5ec1]
  db 0xE8, 0x30, 0x05          ; 000055D4  call 0x5b07
  db 0x88, 0x47, 0x18          ; 000055D7  mov [bx+0x18],al
  db 0x8A, 0xC8                ; 000055DA  mov cl,al
  db 0xB4, 0x00                ; 000055DC  mov ah,0x0
  db 0xB0, 0x18                ; 000055DE  mov al,0x18
  db 0xE8, 0x9F, 0xFD          ; 000055E0  call 0x5382
  db 0x2E, 0xA0, 0xC0, 0x5E    ; 000055E3  mov al,[cs:0x5ec0]
  db 0xE8, 0x1D, 0x05          ; 000055E7  call 0x5b07
  db 0x8A, 0xC8                ; 000055EA  mov cl,al
  db 0xB4, 0x00                ; 000055EC  mov ah,0x0
  db 0xB0, 0x17                ; 000055EE  mov al,0x17
  db 0xE8, 0x8F, 0xFD          ; 000055F0  call 0x5382
  db 0xB8, 0x4E, 0x00          ; 000055F3  mov ax,0x4e
  db 0x2E, 0x3A, 0x06, 0xC1, 0x5E ; 000055F6  cmp al,[cs:0x5ec1]
  db 0x74, 0x18                ; 000055FB  jz 0x5615
  db 0xA8, 0x03                ; 000055FD  test al,0x3
  db 0x74, 0x0A                ; 000055FF  jz 0x560b
  db 0x2E, 0x81, 0x06, 0xBC, 0x5E, 0x6D, 0x01 ; 00005601  add word [cs:0x5ebc],0x16d
  db 0x40                      ; 00005608  inc ax
  db 0xEB, 0xEB                ; 00005609  jmp short 0x55f6
  db 0x2E, 0x81, 0x06, 0xBC, 0x5E, 0x6E, 0x01 ; 0000560B  add word [cs:0x5ebc],0x16e
  db 0x40                      ; 00005612  inc ax
  db 0xEB, 0xE1                ; 00005613  jmp short 0x55f6
  db 0x2E, 0xF6, 0x06, 0xC1, 0x5E, 0x03 ; 00005615  test byte [cs:0x5ec1],0x3
  db 0x74, 0x08                ; 0000561B  jz 0x5625
  db 0x2E, 0xC6, 0x06, 0xBE, 0x5E, 0x00 ; 0000561D  mov byte [cs:0x5ebe],0x0
  db 0xEB, 0x06                ; 00005623  jmp short 0x562b
  db 0x2E, 0xC6, 0x06, 0xBE, 0x5E, 0xFF ; 00005625  mov byte [cs:0x5ebe],0xff
  db 0xBB, 0x01, 0x00          ; 0000562B  mov bx,0x1
  db 0x2E, 0x3A, 0x1E, 0xC0, 0x5E ; 0000562E  cmp bl,[cs:0x5ec0]
  db 0x74, 0x1E                ; 00005633  jz 0x5653
  db 0x2E, 0x80, 0x3E, 0xBE, 0x5E, 0xFF ; 00005635  cmp byte [cs:0x5ebe],0xff
  db 0x74, 0x07                ; 0000563B  jz 0x5644
  db 0x2E, 0x8A, 0x87, 0xC2, 0x5E ; 0000563D  mov al,[cs:bx+0x5ec2]
  db 0xEB, 0x05                ; 00005642  jmp short 0x5649
  db 0x2E, 0x8A, 0x87, 0xCF, 0x5E ; 00005644  mov al,[cs:bx+0x5ecf]
  db 0x32, 0xE4                ; 00005649  xor ah,ah
  db 0x2E, 0x01, 0x06, 0xBC, 0x5E ; 0000564B  add [cs:0x5ebc],ax
  db 0x43                      ; 00005650  inc bx
  db 0xEB, 0xDB                ; 00005651  jmp short 0x562e
  db 0x2E, 0xA0, 0xBF, 0x5E    ; 00005653  mov al,[cs:0x5ebf]
  db 0x32, 0xE4                ; 00005657  xor ah,ah
  db 0x2E, 0x03, 0x06, 0xBC, 0x5E ; 00005659  add ax,[cs:0x5ebc]
  db 0x06                      ; 0000565E  push es
  db 0x2E, 0x8E, 0x06, 0x06, 0x0C ; 0000565F  mov es,[cs:0xc06]
  db 0x26, 0xA3, 0x7E, 0x00    ; 00005664  mov [es:0x7e],ax
  db 0x07                      ; 00005668  pop es
  db 0xBA, 0x52, 0xFF          ; 00005669  mov dx,0xff52
  db 0xED                      ; 0000566C  in ax,dx
  db 0xBE, 0xF4, 0x49          ; 0000566D  mov si,0x49f4
  db 0x3D, 0x1A, 0x00          ; 00005670  cmp ax,0x1a
  db 0x74, 0x03                ; 00005673  jz 0x5678
  db 0xBE, 0xDE, 0x49          ; 00005675  mov si,0x49de
  db 0x2E, 0x89, 0x36, 0x0A, 0x4A ; 00005678  mov [cs:0x4a0a],si
  db 0xE8, 0xBC, 0xF9          ; 0000567D  call 0x503c
  db 0xBB, 0xB2, 0x45          ; 00005680  mov bx,0x45b2
  db 0x80, 0x67, 0x17, 0xDF    ; 00005683  and byte [bx+0x17],0xdf
  db 0x80, 0x7F, 0x17, 0x50    ; 00005687  cmp byte [bx+0x17],0x50
  db 0x75, 0x09                ; 0000568B  jnz 0x5696
  db 0x2E, 0xC7, 0x06, 0x92, 0x67, 0x18, 0x00 ; 0000568D  mov word [cs:0x6792],0x18
  db 0xEB, 0x00                ; 00005694  jmp short 0x5696
  db 0xBB, 0xE3, 0x45          ; 00005696  mov bx,0x45e3
  db 0x80, 0x7F, 0x33, 0x01    ; 00005699  cmp byte [bx+0x33],0x1
  db 0x75, 0x0F                ; 0000569D  jnz 0x56ae
  db 0xB2, 0x05                ; 0000569F  mov dl,0x5
  db 0xE8, 0xA7, 0xE5          ; 000056A1  call 0x3c4b
  db 0xBB, 0xE5, 0x43          ; 000056A4  mov bx,0x43e5
  db 0xBA, 0x02, 0x03          ; 000056A7  mov dx,0x302
  db 0xEC                      ; 000056AA  in al,dx
  db 0x88, 0x47, 0x1E          ; 000056AB  mov [bx+0x1e],al
  db 0x2E, 0x8E, 0x06, 0xB9, 0x5E ; 000056AE  mov es,[cs:0x5eb9]
  db 0xB1, 0x86                ; 000056B3  mov cl,0x86
  db 0xBA, 0xA6, 0x67          ; 000056B5  mov dx,0x67a6
  db 0xE8, 0x78, 0xAA          ; 000056B8  call 0x133
  db 0xB1, 0x87                ; 000056BB  mov cl,0x87
  db 0xBA, 0xC2, 0x67          ; 000056BD  mov dx,0x67c2
  db 0xE8, 0x70, 0xAA          ; 000056C0  call 0x133
  db 0xB1, 0x8B                ; 000056C3  mov cl,0x8b
  db 0xBA, 0xC2, 0x67          ; 000056C5  mov dx,0x67c2
  db 0xE8, 0x68, 0xAA          ; 000056C8  call 0x133
  db 0xB1, 0x86                ; 000056CB  mov cl,0x86
  db 0xBA, 0xD2, 0x67          ; 000056CD  mov dx,0x67d2
  db 0xE8, 0x60, 0xAA          ; 000056D0  call 0x133
  db 0xB1, 0x87                ; 000056D3  mov cl,0x87
  db 0xBA, 0xEE, 0x67          ; 000056D5  mov dx,0x67ee
  db 0xE8, 0x58, 0xAA          ; 000056D8  call 0x133
  db 0xB1, 0x8B                ; 000056DB  mov cl,0x8b
  db 0xBA, 0xEE, 0x67          ; 000056DD  mov dx,0x67ee
  db 0xE8, 0x50, 0xAA          ; 000056E0  call 0x133
  db 0xB1, 0x86                ; 000056E3  mov cl,0x86
  db 0xBA, 0xFE, 0x67          ; 000056E5  mov dx,0x67fe
  db 0xE8, 0x48, 0xAA          ; 000056E8  call 0x133
  db 0xB1, 0x87                ; 000056EB  mov cl,0x87
  db 0xBA, 0x1A, 0x68          ; 000056ED  mov dx,0x681a
  db 0xE8, 0x40, 0xAA          ; 000056F0  call 0x133
  db 0xB1, 0x8B                ; 000056F3  mov cl,0x8b
  db 0xBA, 0x1A, 0x68          ; 000056F5  mov dx,0x681a
  db 0xE8, 0x38, 0xAA          ; 000056F8  call 0x133
  db 0xB1, 0x86                ; 000056FB  mov cl,0x86
  db 0xBA, 0x33, 0x69          ; 000056FD  mov dx,0x6933
  db 0xE8, 0x30, 0xAA          ; 00005700  call 0x133
  db 0xB1, 0x87                ; 00005703  mov cl,0x87
  db 0xBA, 0x4F, 0x69          ; 00005705  mov dx,0x694f
  db 0xE8, 0x28, 0xAA          ; 00005708  call 0x133
  db 0xB1, 0x8B                ; 0000570B  mov cl,0x8b
  db 0xBA, 0x4F, 0x69          ; 0000570D  mov dx,0x694f
  db 0xE8, 0x20, 0xAA          ; 00005710  call 0x133
  db 0xB1, 0x86                ; 00005713  mov cl,0x86
  db 0xBA, 0x2A, 0x68          ; 00005715  mov dx,0x682a
  db 0xE8, 0x18, 0xAA          ; 00005718  call 0x133
  db 0xB1, 0x86                ; 0000571B  mov cl,0x86
  db 0xBA, 0x46, 0x68          ; 0000571D  mov dx,0x6846
  db 0xE8, 0x10, 0xAA          ; 00005720  call 0x133
  db 0xB1, 0x86                ; 00005723  mov cl,0x86
  db 0xBA, 0x07, 0x69          ; 00005725  mov dx,0x6907
  db 0xE8, 0x08, 0xAA          ; 00005728  call 0x133
  db 0xB1, 0x87                ; 0000572B  mov cl,0x87
  db 0xBA, 0x23, 0x69          ; 0000572D  mov dx,0x6923
  db 0xE8, 0x00, 0xAA          ; 00005730  call 0x133
  db 0xB1, 0x8B                ; 00005733  mov cl,0x8b
  db 0xBA, 0x23, 0x69          ; 00005735  mov dx,0x6923
  db 0xE8, 0xF8, 0xA9          ; 00005738  call 0x133
  db 0x2E, 0xA0, 0xF9, 0x3A    ; 0000573B  mov al,[cs:0x3af9]
  db 0xBA, 0x88, 0x02          ; 0000573F  mov dx,0x288
  db 0xEE                      ; 00005742  out dx,al
  db 0xBA, 0x80, 0x02          ; 00005743  mov dx,0x280
  db 0xEC                      ; 00005746  in al,dx
  db 0xBA, 0x94, 0x02          ; 00005747  mov dx,0x294
  db 0xEE                      ; 0000574A  out dx,al
  db 0xBB, 0xB2, 0x45          ; 0000574B  mov bx,0x45b2
  db 0x8A, 0x4F, 0x13          ; 0000574E  mov cl,[bx+0x13]
  db 0xBB, 0x00, 0x00          ; 00005751  mov bx,0x0
  db 0x80, 0xF9, 0x00          ; 00005754  cmp cl,0x0
  db 0x74, 0x0B                ; 00005757  jz 0x5764
  db 0x2E, 0xC6, 0x87, 0xBF, 0x3C, 0x01 ; 00005759  mov byte [cs:bx+0x3cbf],0x1
  db 0x43                      ; 0000575F  inc bx
  db 0xFE, 0xC9                ; 00005760  dec cl
  db 0xEB, 0xF0                ; 00005762  jmp short 0x5754
  db 0xBB, 0xB2, 0x45          ; 00005764  mov bx,0x45b2
  db 0xC4, 0x3F                ; 00005767  les di,[bx]
  db 0x8C, 0xC0                ; 00005769  mov ax,es
  db 0xB1, 0x06                ; 0000576B  mov cl,0x6
  db 0xD3, 0xE0                ; 0000576D  shl ax,cl
  db 0xB1, 0x0A                ; 0000576F  mov cl,0xa
  db 0xD3, 0xEF                ; 00005771  shr di,cl
  db 0x03, 0xC7                ; 00005773  add ax,di
  db 0x2E, 0xA3, 0x94, 0x67    ; 00005775  mov [cs:0x6794],ax
  db 0x2E, 0x8B, 0x1E, 0x92, 0x67 ; 00005779  mov bx,[cs:0x6792]
  db 0x2E, 0x29, 0x1E, 0x94, 0x67 ; 0000577E  sub [cs:0x6794],bx
  db 0xBF, 0xCE, 0x4D          ; 00005783  mov di,0x4dce
  db 0xE8, 0x94, 0x03          ; 00005786  call 0x5b1d
  db 0xBE, 0xA3, 0x4D          ; 00005789  mov si,0x4da3
  db 0xE8, 0x65, 0x03          ; 0000578C  call 0x5af4
  db 0xBB, 0xB2, 0x45          ; 0000578F  mov bx,0x45b2
  db 0x8A, 0x47, 0x13          ; 00005792  mov al,[bx+0x13]
  db 0x32, 0xE4                ; 00005795  xor ah,ah
  db 0x0A, 0xC0                ; 00005797  or al,al
  db 0x74, 0x17                ; 00005799  jz 0x57b2
  db 0x3C, 0x01                ; 0000579B  cmp al,0x1
  db 0x75, 0x07                ; 0000579D  jnz 0x57a6
  db 0xBB, 0xBF, 0x3C          ; 0000579F  mov bx,0x3cbf
  db 0xC6, 0x47, 0x01, 0x00    ; 000057A2  mov byte [bx+0x1],0x0
  db 0xBF, 0x07, 0x4E          ; 000057A6  mov di,0x4e07
  db 0xE8, 0x71, 0x03          ; 000057A9  call 0x5b1d
  db 0xBE, 0x07, 0x4E          ; 000057AC  mov si,0x4e07
  db 0xE8, 0x42, 0x03          ; 000057AF  call 0x5af4
  db 0xE9, 0x1A, 0x00          ; 000057B2  jmp 0x57cf
  db 0xBB, 0xB2, 0x45          ; 000057B5  mov bx,0x45b2
  db 0x2E, 0xA0, 0xBB, 0x5E    ; 000057B8  mov al,[cs:0x5ebb]
  db 0x2A, 0x47, 0x13          ; 000057BC  sub al,[bx+0x13]
  db 0x74, 0x0E                ; 000057BF  jz 0x57cf
  db 0x32, 0xE4                ; 000057C1  xor ah,ah
  db 0xBF, 0x24, 0x4E          ; 000057C3  mov di,0x4e24
  db 0xE8, 0x54, 0x03          ; 000057C6  call 0x5b1d
  db 0xBE, 0x24, 0x4E          ; 000057C9  mov si,0x4e24
  db 0xE8, 0x25, 0x03          ; 000057CC  call 0x5af4
  db 0xBB, 0xE3, 0x45          ; 000057CF  mov bx,0x45e3
  db 0x8A, 0x47, 0x34          ; 000057D2  mov al,[bx+0x34]
  db 0x2E, 0xA2, 0x4B, 0x00    ; 000057D5  mov [cs:0x4b],al
  db 0x2E, 0xA2, 0x50, 0x00    ; 000057D9  mov [cs:0x50],al
  db 0xBB, 0xE3, 0x45          ; 000057DD  mov bx,0x45e3
  db 0x2E, 0xA1, 0x94, 0x67    ; 000057E0  mov ax,[cs:0x6794]
  db 0x8A, 0x5F, 0x1B          ; 000057E4  mov bl,[bx+0x1b]
  db 0xB7, 0x00                ; 000057E7  mov bh,0x0
  db 0xB1, 0x06                ; 000057E9  mov cl,0x6
  db 0xD3, 0xE3                ; 000057EB  shl bx,cl
  db 0x2B, 0xC3                ; 000057ED  sub ax,bx
  db 0x2E, 0x8B, 0x1E, 0x44, 0x00 ; 000057EF  mov bx,[cs:0x44]
  db 0xB1, 0x06                ; 000057F4  mov cl,0x6
  db 0xD3, 0xEB                ; 000057F6  shr bx,cl
  db 0x83, 0xC3, 0x40          ; 000057F8  add bx,byte +0x40
  db 0x3B, 0xC3                ; 000057FB  cmp ax,bx
  db 0x77, 0x09                ; 000057FD  ja 0x5808
  db 0xBE, 0x90, 0x4E          ; 000057FF  mov si,0x4e90
  db 0xE8, 0xEF, 0x02          ; 00005802  call 0x5af4
  db 0xE9, 0x52, 0x00          ; 00005805  jmp 0x585a
  db 0x2E, 0xA3, 0x94, 0x67    ; 00005808  mov [cs:0x6794],ax
  db 0x06                      ; 0000580C  push es
  db 0xB1, 0x06                ; 0000580D  mov cl,0x6
  db 0xD3, 0xE0                ; 0000580F  shl ax,cl
  db 0x2E, 0xA3, 0x44, 0x39    ; 00005811  mov [cs:0x3944],ax
  db 0xBB, 0xE3, 0x45          ; 00005815  mov bx,0x45e3
  db 0x8A, 0x47, 0x1B          ; 00005818  mov al,[bx+0x1b]
  db 0x0A, 0xC0                ; 0000581B  or al,al
  db 0x74, 0x3A                ; 0000581D  jz 0x5859
  db 0x32, 0xE4                ; 0000581F  xor ah,ah
  db 0xB1, 0x06                ; 00005821  mov cl,0x6
  db 0xD3, 0xE0                ; 00005823  shl ax,cl
  db 0x48                      ; 00005825  dec ax
  db 0x2E, 0xA3, 0xF1, 0x3E    ; 00005826  mov [cs:0x3ef1],ax
  db 0x40                      ; 0000582A  inc ax
  db 0xBF, 0x79, 0x4E          ; 0000582B  mov di,0x4e79
  db 0xE8, 0xEC, 0x02          ; 0000582E  call 0x5b1d
  db 0xBE, 0x79, 0x4E          ; 00005831  mov si,0x4e79
  db 0xE8, 0xBD, 0x02          ; 00005834  call 0x5af4
  db 0x2E, 0xC6, 0x06, 0x50, 0x00, 0x0C ; 00005837  mov byte [cs:0x50],0xc
  db 0xBB, 0xBF, 0x3C          ; 0000583D  mov bx,0x3cbf
  db 0xC6, 0x47, 0x0C, 0xC0    ; 00005840  mov byte [bx+0xc],0xc0
  db 0x2E, 0xA1, 0x44, 0x39    ; 00005844  mov ax,[cs:0x3944]
  db 0x8E, 0xC0                ; 00005848  mov es,ax
  db 0x33, 0xFF                ; 0000584A  xor di,di
  db 0xB8, 0xE5, 0xE5          ; 0000584C  mov ax,0xe5e5
  db 0x26, 0x39, 0x05          ; 0000584F  cmp [es:di],ax
  db 0x74, 0x05                ; 00005852  jz 0x5859
  db 0xB9, 0x00, 0x20          ; 00005854  mov cx,0x2000
  db 0xF3, 0xAB                ; 00005857  rep stosw
  db 0x07                      ; 00005859  pop es
  db 0xB9, 0x10, 0x00          ; 0000585A  mov cx,0x10
  db 0x51                      ; 0000585D  push cx
  db 0xFE, 0xC9                ; 0000585E  dec cl
  db 0xB2, 0x00                ; 00005860  mov dl,0x0
  db 0xE8, 0xA3, 0xCC          ; 00005862  call 0x2508
  db 0x0B, 0xDB                ; 00005865  or bx,bx
  db 0x74, 0x6C                ; 00005867  jz 0x58d5
  db 0x2E, 0xA1, 0x96, 0x67    ; 00005869  mov ax,[cs:0x6796]
  db 0x89, 0x47, 0x0A          ; 0000586D  mov [bx+0xa],ax
  db 0x53                      ; 00005870  push bx
  db 0x8B, 0x5F, 0x08          ; 00005871  mov bx,[bx+0x8]
  db 0x8B, 0x47, 0x0B          ; 00005874  mov ax,[bx+0xb]
  db 0x25, 0xFF, 0x7F          ; 00005877  and ax,0x7fff
  db 0x5B                      ; 0000587A  pop bx
  db 0x75, 0x07                ; 0000587B  jnz 0x5884
  db 0xC7, 0x47, 0x0A, 0x00, 0x00 ; 0000587D  mov word [bx+0xa],0x0
  db 0xEB, 0x12                ; 00005882  jmp short 0x5896
  db 0x53                      ; 00005884  push bx
  db 0x8B, 0x5F, 0x08          ; 00005885  mov bx,[bx+0x8]
  db 0x8B, 0x47, 0x07          ; 00005888  mov ax,[bx+0x7]
  db 0xB1, 0x02                ; 0000588B  mov cl,0x2
  db 0xD3, 0xE8                ; 0000588D  shr ax,cl
  db 0x40                      ; 0000588F  inc ax
  db 0x2E, 0x01, 0x06, 0x96, 0x67 ; 00005890  add [cs:0x6796],ax
  db 0x5B                      ; 00005895  pop bx
  db 0x53                      ; 00005896  push bx
  db 0x8B, 0x5F, 0x08          ; 00005897  mov bx,[bx+0x8]
  db 0x8B, 0x47, 0x07          ; 0000589A  mov ax,[bx+0x7]
  db 0x40                      ; 0000589D  inc ax
  db 0xB1, 0x02                ; 0000589E  mov cl,0x2
  db 0xD3, 0xE0                ; 000058A0  shl ax,cl
  db 0x05, 0xFF, 0x03          ; 000058A2  add ax,0x3ff
  db 0xB1, 0x0A                ; 000058A5  mov cl,0xa
  db 0xD3, 0xE8                ; 000058A7  shr ax,cl
  db 0x2E, 0x29, 0x06, 0x94, 0x67 ; 000058A9  sub [cs:0x6794],ax
  db 0x5B                      ; 000058AE  pop bx
  db 0x2E, 0xA1, 0x94, 0x67    ; 000058AF  mov ax,[cs:0x6794]
  db 0xB1, 0x06                ; 000058B3  mov cl,0x6
  db 0xD3, 0xE0                ; 000058B5  shl ax,cl
  db 0x89, 0x47, 0x12          ; 000058B7  mov [bx+0x12],ax
  db 0x2E, 0xA1, 0x96, 0x67    ; 000058BA  mov ax,[cs:0x6796]
  db 0x89, 0x47, 0x0C          ; 000058BE  mov [bx+0xc],ax
  db 0x53                      ; 000058C1  push bx
  db 0x8B, 0x5F, 0x08          ; 000058C2  mov bx,[bx+0x8]
  db 0x8B, 0x47, 0x05          ; 000058C5  mov ax,[bx+0x5]
  db 0x5B                      ; 000058C8  pop bx
  db 0xB1, 0x03                ; 000058C9  mov cl,0x3
  db 0xD3, 0xE8                ; 000058CB  shr ax,cl
  db 0x40                      ; 000058CD  inc ax
  db 0xD1, 0xE0                ; 000058CE  shl ax,1
  db 0x2E, 0x01, 0x06, 0x96, 0x67 ; 000058D0  add [cs:0x6796],ax
  db 0x59                      ; 000058D5  pop cx
  db 0x49                      ; 000058D6  dec cx
  db 0x74, 0x03                ; 000058D7  jz 0x58dc
  db 0xE9, 0x81, 0xFF          ; 000058D9  jmp 0x585d
  db 0xBB, 0xB2, 0x45          ; 000058DC  mov bx,0x45b2
  db 0x2E, 0x8A, 0x16, 0xBB, 0x5E ; 000058DF  mov dl,[cs:0x5ebb]
  db 0x2E, 0xC7, 0x06, 0xA4, 0x67, 0x20, 0x04 ; 000058E4  mov word [cs:0x67a4],0x420
  db 0xBB, 0xE3, 0x45          ; 000058EB  mov bx,0x45e3
  db 0x8A, 0x4F, 0x1A          ; 000058EE  mov cl,[bx+0x1a]
  db 0xB5, 0x00                ; 000058F1  mov ch,0x0
  db 0x51                      ; 000058F3  push cx
  db 0x2E, 0x8B, 0x1E, 0x44, 0x00 ; 000058F4  mov bx,[cs:0x44]
  db 0xB1, 0x06                ; 000058F9  mov cl,0x6
  db 0xD3, 0xEB                ; 000058FB  shr bx,cl
  db 0x59                      ; 000058FD  pop cx
  db 0x2E, 0xA1, 0x94, 0x67    ; 000058FE  mov ax,[cs:0x6794]
  db 0x2B, 0xC3                ; 00005902  sub ax,bx
  db 0x2D, 0x40, 0x00          ; 00005904  sub ax,0x40
  db 0x3B, 0xC8                ; 00005907  cmp cx,ax
  db 0x72, 0x03                ; 00005909  jc 0x590e
  db 0x49                      ; 0000590B  dec cx
  db 0xEB, 0xF9                ; 0000590C  jmp short 0x5907
  db 0x3A, 0xCA                ; 0000590E  cmp cl,dl
  db 0x72, 0x02                ; 00005910  jc 0x5914
  db 0xEB, 0x02                ; 00005912  jmp short 0x5916
  db 0x8A, 0xCA                ; 00005914  mov cl,dl
  db 0x2E, 0x29, 0x0E, 0x94, 0x67 ; 00005916  sub [cs:0x6794],cx
  db 0x2E, 0xA1, 0x94, 0x67    ; 0000591B  mov ax,[cs:0x6794]
  db 0x51                      ; 0000591F  push cx
  db 0xB1, 0x06                ; 00005920  mov cl,0x6
  db 0xD3, 0xE0                ; 00005922  shl ax,cl
  db 0x2E, 0xA3, 0x90, 0x67    ; 00005924  mov [cs:0x6790],ax
  db 0x59                      ; 00005928  pop cx
  db 0xBB, 0x4F, 0x3F          ; 00005929  mov bx,0x3f4f
  db 0x2E, 0xA1, 0x96, 0x67    ; 0000592C  mov ax,[cs:0x6796]
  db 0x89, 0x07                ; 00005930  mov [bx],ax
  db 0x88, 0x4F, 0x02          ; 00005932  mov [bx+0x2],cl
  db 0x0A, 0xC9                ; 00005935  or cl,cl
  db 0x74, 0x45                ; 00005937  jz 0x597e
  db 0x50                      ; 00005939  push ax
  db 0x2E, 0xA1, 0x98, 0x67    ; 0000593A  mov ax,[cs:0x6798]
  db 0x2E, 0x2B, 0x06, 0x96, 0x67 ; 0000593E  sub ax,[cs:0x6796]
  db 0x2E, 0x3B, 0x06, 0xA4, 0x67 ; 00005943  cmp ax,[cs:0x67a4]
  db 0x58                      ; 00005948  pop ax
  db 0x72, 0x2E                ; 00005949  jc 0x5979
  db 0x2E, 0x83, 0x06, 0x96, 0x67, 0x10 ; 0000594B  add word [cs:0x6796],byte +0x10
  db 0x8B, 0xD8                ; 00005951  mov bx,ax
  db 0x8B, 0xFB                ; 00005953  mov di,bx
  db 0x51                      ; 00005955  push cx
  db 0xB9, 0x08, 0x00          ; 00005956  mov cx,0x8
  db 0x33, 0xC0                ; 00005959  xor ax,ax
  db 0x1E                      ; 0000595B  push ds
  db 0x07                      ; 0000595C  pop es
  db 0xF3, 0xAB                ; 0000595D  rep stosw
  db 0x59                      ; 0000595F  pop cx
  db 0xC6, 0x07, 0xFF          ; 00005960  mov byte [bx],0xff
  db 0x2E, 0xA1, 0x90, 0x67    ; 00005963  mov ax,[cs:0x6790]
  db 0x89, 0x47, 0x0A          ; 00005967  mov [bx+0xa],ax
  db 0x2E, 0x83, 0x06, 0x90, 0x67, 0x40 ; 0000596A  add word [cs:0x6790],byte +0x40
  db 0x2E, 0xA1, 0x96, 0x67    ; 00005970  mov ax,[cs:0x6796]
  db 0x89, 0x47, 0x0C          ; 00005974  mov [bx+0xc],ax
  db 0xE2, 0xC0                ; 00005977  loop 0x5939
  db 0xC7, 0x47, 0x0C, 0x00, 0x00 ; 00005979  mov word [bx+0xc],0x0
  db 0xBB, 0x4F, 0x3F          ; 0000597E  mov bx,0x3f4f
  db 0x28, 0x4F, 0x02          ; 00005981  sub [bx+0x2],cl
  db 0x8A, 0x47, 0x02          ; 00005984  mov al,[bx+0x2]
  db 0x32, 0xE4                ; 00005987  xor ah,ah
  db 0x0B, 0xC0                ; 00005989  or ax,ax
  db 0x74, 0x67                ; 0000598B  jz 0x59f4
  db 0xBF, 0x48, 0x4E          ; 0000598D  mov di,0x4e48
  db 0xE8, 0x8A, 0x01          ; 00005990  call 0x5b1d
  db 0xBE, 0x48, 0x4E          ; 00005993  mov si,0x4e48
  db 0xE8, 0x5B, 0x01          ; 00005996  call 0x5af4
  db 0xBB, 0x40, 0x3F          ; 00005999  mov bx,0x3f40
  db 0x2E, 0xA1, 0x96, 0x67    ; 0000599C  mov ax,[cs:0x6796]
  db 0x89, 0x07                ; 000059A0  mov [bx],ax
  db 0xB1, 0x00                ; 000059A2  mov cl,0x0
  db 0x2E, 0xA1, 0x96, 0x67    ; 000059A4  mov ax,[cs:0x6796]
  db 0x05, 0x10, 0x04          ; 000059A8  add ax,0x410
  db 0x2E, 0x3B, 0x06, 0x98, 0x67 ; 000059AB  cmp ax,[cs:0x6798]
  db 0x77, 0x27                ; 000059B0  ja 0x59d9
  db 0x2E, 0x8B, 0x1E, 0x96, 0x67 ; 000059B2  mov bx,[cs:0x6796]
  db 0x2E, 0x83, 0x06, 0x96, 0x67, 0x10 ; 000059B7  add word [cs:0x6796],byte +0x10
  db 0xC6, 0x07, 0xFF          ; 000059BD  mov byte [bx],0xff
  db 0x2E, 0xA1, 0x96, 0x67    ; 000059C0  mov ax,[cs:0x6796]
  db 0x89, 0x47, 0x0A          ; 000059C4  mov [bx+0xa],ax
  db 0x2E, 0x81, 0x06, 0x96, 0x67, 0x00, 0x04 ; 000059C7  add word [cs:0x6796],0x400
  db 0x2E, 0xA1, 0x96, 0x67    ; 000059CE  mov ax,[cs:0x6796]
  db 0x89, 0x47, 0x0C          ; 000059D2  mov [bx+0xc],ax
  db 0xFE, 0xC1                ; 000059D5  inc cl
  db 0xEB, 0xCB                ; 000059D7  jmp short 0x59a4
  db 0xC7, 0x47, 0x0C, 0x00, 0x00 ; 000059D9  mov word [bx+0xc],0x0
  db 0xBB, 0x40, 0x3F          ; 000059DE  mov bx,0x3f40
  db 0x88, 0x4F, 0x02          ; 000059E1  mov [bx+0x2],cl
  db 0x8A, 0xC1                ; 000059E4  mov al,cl
  db 0x32, 0xE4                ; 000059E6  xor ah,ah
  db 0xBF, 0x5F, 0x4E          ; 000059E8  mov di,0x4e5f
  db 0xE8, 0x2F, 0x01          ; 000059EB  call 0x5b1d
  db 0xBE, 0x5F, 0x4E          ; 000059EE  mov si,0x4e5f
  db 0xE8, 0x00, 0x01          ; 000059F1  call 0x5af4
  db 0x2E, 0xA1, 0x94, 0x67    ; 000059F4  mov ax,[cs:0x6794]
  db 0xB1, 0x06                ; 000059F8  mov cl,0x6
  db 0xD3, 0xE0                ; 000059FA  shl ax,cl
  db 0x2D, 0x10, 0x00          ; 000059FC  sub ax,0x10
  db 0x2E, 0xA3, 0xE5, 0x43    ; 000059FF  mov [cs:0x43e5],ax
  db 0x2E, 0xC7, 0x06, 0xE7, 0x43, 0x00, 0x01 ; 00005A03  mov word [cs:0x43e7],0x100
  db 0x2E, 0xC7, 0x06, 0xED, 0x43, 0x00, 0x01 ; 00005A0A  mov word [cs:0x43ed],0x100
  db 0x2D, 0x01, 0x00          ; 00005A11  sub ax,0x1
  db 0x2E, 0xA3, 0xEF, 0x43    ; 00005A14  mov [cs:0x43ef],ax
  db 0x2E, 0xC7, 0x06, 0xF1, 0x43, 0x10, 0x00 ; 00005A18  mov word [cs:0x43f1],0x10
  db 0x2E, 0xC7, 0x06, 0xF7, 0x43, 0x10, 0x00 ; 00005A1F  mov word [cs:0x43f7],0x10
  db 0x50                      ; 00005A26  push ax
  db 0xB1, 0x06                ; 00005A27  mov cl,0x6
  db 0xD3, 0xE8                ; 00005A29  shr ax,cl
  db 0x2E, 0xA3, 0x94, 0x67    ; 00005A2B  mov [cs:0x6794],ax
  db 0x59                      ; 00005A2F  pop cx
  db 0xBB, 0x5A, 0x00          ; 00005A30  mov bx,0x5a
  db 0x8B, 0xF3                ; 00005A33  mov si,bx
  db 0x8B, 0x1F                ; 00005A35  mov bx,[bx]
  db 0x85, 0xDB                ; 00005A37  test bx,bx
  db 0x74, 0x3B                ; 00005A39  jz 0x5a76
  db 0x8B, 0x47, 0x02          ; 00005A3B  mov ax,[bx+0x2]
  db 0x03, 0x47, 0x04          ; 00005A3E  add ax,[bx+0x4]
  db 0x3B, 0xC1                ; 00005A41  cmp ax,cx
  db 0x76, 0xEE                ; 00005A43  jna 0x5a33
  db 0x8B, 0x47, 0x02          ; 00005A45  mov ax,[bx+0x2]
  db 0x2B, 0xC8                ; 00005A48  sub cx,ax
  db 0x76, 0x11                ; 00005A4A  jna 0x5a5d
  db 0x89, 0x4F, 0x04          ; 00005A4C  mov [bx+0x4],cx
  db 0x8B, 0x37                ; 00005A4F  mov si,[bx]
  db 0x85, 0xF6                ; 00005A51  test si,si
  db 0x74, 0x21                ; 00005A53  jz 0x5a76
  db 0xC7, 0x07, 0x00, 0x00    ; 00005A55  mov word [bx],0x0
  db 0x8B, 0xDE                ; 00005A59  mov bx,si
  db 0xEB, 0x06                ; 00005A5B  jmp short 0x5a63
  db 0xC7, 0x04, 0x00, 0x00    ; 00005A5D  mov word [si],0x0
  db 0x8B, 0xF3                ; 00005A61  mov si,bx
  db 0x8B, 0xFB                ; 00005A63  mov di,bx
  db 0x8B, 0x1F                ; 00005A65  mov bx,[bx]
  db 0x85, 0xDB                ; 00005A67  test bx,bx
  db 0x75, 0xF8                ; 00005A69  jnz 0x5a63
  db 0x2E, 0xA1, 0x58, 0x00    ; 00005A6B  mov ax,[cs:0x58]
  db 0x2E, 0x89, 0x36, 0x58, 0x00 ; 00005A6F  mov [cs:0x58],si
  db 0x89, 0x05                ; 00005A74  mov [di],ax
  db 0x2E, 0xA1, 0x94, 0x67    ; 00005A76  mov ax,[cs:0x6794]
  db 0x2E, 0x8B, 0x1E, 0x44, 0x00 ; 00005A7A  mov bx,[cs:0x44]
  db 0xB1, 0x06                ; 00005A7F  mov cl,0x6
  db 0xD3, 0xEB                ; 00005A81  shr bx,cl
  db 0x2B, 0xC3                ; 00005A83  sub ax,bx
  db 0xBF, 0xEA, 0x4D          ; 00005A85  mov di,0x4dea
  db 0xE8, 0x92, 0x00          ; 00005A88  call 0x5b1d
  db 0xBE, 0xEA, 0x4D          ; 00005A8B  mov si,0x4dea
  db 0xE8, 0x63, 0x00          ; 00005A8E  call 0x5af4
  db 0x33, 0xC0                ; 00005A91  xor ax,ax
  db 0x2E, 0x0B, 0x06, 0xF2, 0x66 ; 00005A93  or ax,[cs:0x66f2]
  db 0xB8, 0xA0, 0x00          ; 00005A98  mov ax,0xa0
  db 0x74, 0x38                ; 00005A9B  jz 0x5ad5
  db 0x33, 0xC0                ; 00005A9D  xor ax,ax
  db 0x8E, 0xC0                ; 00005A9F  mov es,ax
  db 0xBF, 0x94, 0x00          ; 00005AA1  mov di,0x94
  db 0xB8, 0x4D, 0x4A          ; 00005AA4  mov ax,0x4a4d
  db 0xAB                      ; 00005AA7  stosw
  db 0x8C, 0xC8                ; 00005AA8  mov ax,cs
  db 0xAB                      ; 00005AAA  stosw
  db 0x2E, 0xC7, 0x06, 0x8C, 0x00, 0x00, 0x00 ; 00005AAB  mov word [cs:0x8c],0x0
  db 0x2E, 0xC7, 0x06, 0xA2, 0x00, 0x00, 0x00 ; 00005AB2  mov word [cs:0xa2],0x0
  db 0x2E, 0xC7, 0x06, 0xA0, 0x00, 0x94, 0x00 ; 00005AB9  mov word [cs:0xa0],0x94
  db 0x2E, 0x8C, 0x0E, 0xA6, 0x00 ; 00005AC0  mov [cs:0xa6],cs
  db 0x2E, 0xC7, 0x06, 0xA4, 0x00, 0x4D, 0x4A ; 00005AC5  mov word [cs:0xa4],0x4a4d
  db 0xBE, 0xD3, 0x4E          ; 00005ACC  mov si,0x4ed3
  db 0xE8, 0x22, 0x00          ; 00005ACF  call 0x5af4
  db 0xB8, 0x80, 0x00          ; 00005AD2  mov ax,0x80
  db 0x50                      ; 00005AD5  push ax
  db 0xBB, 0xB2, 0x45          ; 00005AD6  mov bx,0x45b2
  db 0x80, 0x7F, 0x0D, 0xFF    ; 00005AD9  cmp byte [bx+0xd],0xff
  db 0x75, 0x06                ; 00005ADD  jnz 0x5ae5
  db 0xBE, 0xB2, 0x4E          ; 00005ADF  mov si,0x4eb2
  db 0xE8, 0x0F, 0x00          ; 00005AE2  call 0x5af4
  db 0xBA, 0x28, 0xFF          ; 00005AE5  mov dx,0xff28
  db 0xB8, 0x41, 0x00          ; 00005AE8  mov ax,0x41
  db 0xEF                      ; 00005AEB  out dx,ax
  db 0x58                      ; 00005AEC  pop ax
  db 0xBA, 0x02, 0x00          ; 00005AED  mov dx,0x2
  db 0xEF                      ; 00005AF0  out dx,ax
  db 0xCB                      ; 00005AF1  retf
  db 0x00, 0x00                ; 00005AF2  add [bx+si],al
  db 0x32, 0xD2                ; 00005AF4  xor dl,dl
  db 0x8A, 0x0C                ; 00005AF6  mov cl,[si]
  db 0x84, 0xC9                ; 00005AF8  test cl,cl
  db 0x74, 0x0A                ; 00005AFA  jz 0x5b06
  db 0x52                      ; 00005AFC  push dx
  db 0x56                      ; 00005AFD  push si
  db 0xE8, 0x72, 0xAD          ; 00005AFE  call 0x873
  db 0x5E                      ; 00005B01  pop si
  db 0x5A                      ; 00005B02  pop dx
  db 0x46                      ; 00005B03  inc si
  db 0xEB, 0xF0                ; 00005B04  jmp short 0x5af6
  db 0xC3                      ; 00005B06  ret
  db 0x52                      ; 00005B07  push dx
  db 0x53                      ; 00005B08  push bx
  db 0x51                      ; 00005B09  push cx
  db 0x33, 0xD2                ; 00005B0A  xor dx,dx
  db 0x32, 0xE4                ; 00005B0C  xor ah,ah
  db 0xBB, 0x0A, 0x00          ; 00005B0E  mov bx,0xa
  db 0xF7, 0xFB                ; 00005B11  idiv bx
  db 0xB1, 0x04                ; 00005B13  mov cl,0x4
  db 0xD2, 0xE0                ; 00005B15  shl al,cl
  db 0x0A, 0xC2                ; 00005B17  or al,dl
  db 0x59                      ; 00005B19  pop cx
  db 0x5B                      ; 00005B1A  pop bx
  db 0x5A                      ; 00005B1B  pop dx
  db 0xC3                      ; 00005B1C  ret
  db 0x51                      ; 00005B1D  push cx
  db 0x53                      ; 00005B1E  push bx
  db 0x52                      ; 00005B1F  push dx
  db 0x56                      ; 00005B20  push si
  db 0x57                      ; 00005B21  push di
  db 0xBE, 0x00, 0x00          ; 00005B22  mov si,0x0
  db 0x2B, 0xD2                ; 00005B25  sub dx,dx
  db 0x2E, 0xF7, 0xBC, 0x9A, 0x67 ; 00005B27  idiv word [cs:si+0x679a]
  db 0xB3, 0x30                ; 00005B2C  mov bl,0x30
  db 0x02, 0xC3                ; 00005B2E  add al,bl
  db 0x88, 0x05                ; 00005B30  mov [di],al
  db 0x46                      ; 00005B32  inc si
  db 0x46                      ; 00005B33  inc si
  db 0x47                      ; 00005B34  inc di
  db 0x8B, 0xC2                ; 00005B35  mov ax,dx
  db 0x83, 0xFE, 0x0A          ; 00005B37  cmp si,byte +0xa
  db 0x75, 0xE9                ; 00005B3A  jnz 0x5b25
  db 0xB9, 0x05, 0x00          ; 00005B3C  mov cx,0x5
  db 0x5F                      ; 00005B3F  pop di
  db 0x80, 0x3D, 0x30          ; 00005B40  cmp byte [di],0x30
  db 0x75, 0x06                ; 00005B43  jnz 0x5b4b
  db 0xC6, 0x05, 0x20          ; 00005B45  mov byte [di],0x20
  db 0x47                      ; 00005B48  inc di
  db 0xE2, 0xF5                ; 00005B49  loop 0x5b40
  db 0x5E                      ; 00005B4B  pop si
  db 0x5A                      ; 00005B4C  pop dx
  db 0x5B                      ; 00005B4D  pop bx
  db 0x59                      ; 00005B4E  pop cx
  db 0xC3                      ; 00005B4F  ret
  db 0x00, 0x00                ; 00005B50  add [bx+si],al
  db 0x00, 0x00                ; 00005B52  add [bx+si],al
  db 0x00, 0x00                ; 00005B54  add [bx+si],al
  db 0x00, 0x00                ; 00005B56  add [bx+si],al
  db 0x00, 0x00                ; 00005B58  add [bx+si],al
  db 0x00, 0x00                ; 00005B5A  add [bx+si],al
  db 0x00, 0x00                ; 00005B5C  add [bx+si],al
  db 0x00, 0x00                ; 00005B5E  add [bx+si],al
  db 0x00, 0x00                ; 00005B60  add [bx+si],al
  db 0x00, 0x00                ; 00005B62  add [bx+si],al
  db 0x00, 0x00                ; 00005B64  add [bx+si],al
  db 0x00, 0x00                ; 00005B66  add [bx+si],al
  db 0x00, 0x00                ; 00005B68  add [bx+si],al
  db 0x00, 0x00                ; 00005B6A  add [bx+si],al
  db 0x00, 0x00                ; 00005B6C  add [bx+si],al
  db 0x00, 0x00                ; 00005B6E  add [bx+si],al
  db 0x00, 0x00                ; 00005B70  add [bx+si],al
  db 0x00, 0x00                ; 00005B72  add [bx+si],al
  db 0x00, 0x00                ; 00005B74  add [bx+si],al
  db 0x00, 0x00                ; 00005B76  add [bx+si],al
  db 0x00, 0x00                ; 00005B78  add [bx+si],al
  db 0x00, 0x00                ; 00005B7A  add [bx+si],al
  db 0x00, 0x00                ; 00005B7C  add [bx+si],al
  db 0x00, 0x00                ; 00005B7E  add [bx+si],al
  db 0x00, 0x00                ; 00005B80  add [bx+si],al
  db 0x00, 0x00                ; 00005B82  add [bx+si],al
  db 0x00, 0x00                ; 00005B84  add [bx+si],al
  db 0x00, 0x00                ; 00005B86  add [bx+si],al
  db 0x00, 0x00                ; 00005B88  add [bx+si],al
  db 0x00, 0x00                ; 00005B8A  add [bx+si],al
  db 0x00, 0x00                ; 00005B8C  add [bx+si],al
  db 0x00, 0x00                ; 00005B8E  add [bx+si],al
  db 0x00, 0x00                ; 00005B90  add [bx+si],al
  db 0x00, 0x00                ; 00005B92  add [bx+si],al
  db 0x00, 0x00                ; 00005B94  add [bx+si],al
  db 0x07                      ; 00005B96  pop es
  db 0x60                      ; 00005B97  pusha
  db 0x90                      ; 00005B98  nop
  db 0x67, 0x10, 0x27          ; 00005B99  adc [edi],ah
  db 0xE8, 0x03, 0x64          ; 00005B9C  call 0xbfa2
  db 0x00, 0x0A                ; 00005B9F  add [bp+si],cl
  db 0x00, 0x01                ; 00005BA1  add [bx+di],al
  db 0x00, 0x00                ; 00005BA3  add [bx+si],al
  db 0x00, 0x00                ; 00005BA5  add [bx+si],al
  db 0x00, 0x00                ; 00005BA7  add [bx+si],al
  db 0x00, 0x03                ; 00005BA9  add [bp+di],al
  db 0x00, 0x4D, 0x58          ; 00005BAB  add [di+0x58],cl
  db 0x73, 0x6F                ; 00005BAE  jnc 0x5c1f
  db 0x75, 0x6E                ; 00005BB0  jnz 0x5c20
  db 0x64, 0x20, 0x00          ; 00005BB2  and [fs:bx+si],al
  db 0x00, 0x01                ; 00005BB5  add [bx+di],al
  db 0x00, 0x00                ; 00005BB7  add [bx+si],al
  db 0x00, 0x00                ; 00005BB9  add [bx+si],al
  db 0x00, 0x00                ; 00005BBB  add [bx+si],al
  db 0x00, 0x00                ; 00005BBD  add [bx+si],al
  db 0x00, 0x00                ; 00005BBF  add [bx+si],al
  db 0x00, 0x00                ; 00005BC1  add [bx+si],al
  db 0x00, 0x00                ; 00005BC3  add [bx+si],al
  db 0x00, 0x00                ; 00005BC5  add [bx+si],al
  db 0x00, 0x00                ; 00005BC7  add [bx+si],al
  db 0x00, 0x4D, 0x58          ; 00005BC9  add [di+0x58],cl
  db 0x73, 0x6F                ; 00005BCC  jnc 0x5c3d
  db 0x75, 0x6E                ; 00005BCE  jnz 0x5c3e
  db 0x64, 0x20, 0x00          ; 00005BD0  and [fs:bx+si],al
  db 0x00, 0x00                ; 00005BD3  add [bx+si],al
  db 0x00, 0x03                ; 00005BD5  add [bp+di],al
  db 0x00, 0x4D, 0x58          ; 00005BD7  add [di+0x58],cl
  db 0x64, 0x6D                ; 00005BDA  fs insw
  db 0x61                      ; 00005BDC  popa
  db 0x30, 0x20                ; 00005BDD  xor [bx+si],ah
  db 0x20, 0x00                ; 00005BDF  and [bx+si],al
  db 0x00, 0x01                ; 00005BE1  add [bx+di],al
  db 0x00, 0x00                ; 00005BE3  add [bx+si],al
  db 0x00, 0x00                ; 00005BE5  add [bx+si],al
  db 0x00, 0x00                ; 00005BE7  add [bx+si],al
  db 0x00, 0x00                ; 00005BE9  add [bx+si],al
  db 0x00, 0x00                ; 00005BEB  add [bx+si],al
  db 0x00, 0x00                ; 00005BED  add [bx+si],al
  db 0x00, 0x00                ; 00005BEF  add [bx+si],al
  db 0x00, 0x00                ; 00005BF1  add [bx+si],al
  db 0x00, 0x00                ; 00005BF3  add [bx+si],al
  db 0x00, 0x4D, 0x58          ; 00005BF5  add [di+0x58],cl
  db 0x64, 0x6D                ; 00005BF8  fs insw
  db 0x61                      ; 00005BFA  popa
  db 0x30, 0x20                ; 00005BFB  xor [bx+si],ah
  db 0x20, 0x00                ; 00005BFD  and [bx+si],al
  db 0x00, 0x00                ; 00005BFF  add [bx+si],al
  db 0x00, 0x03                ; 00005C01  add [bp+di],al
  db 0x00, 0x4D, 0x58          ; 00005C03  add [di+0x58],cl
  db 0x64, 0x6D                ; 00005C06  fs insw
  db 0x61                      ; 00005C08  popa
  db 0x31, 0x20                ; 00005C09  xor [bx+si],sp
  db 0x20, 0x00                ; 00005C0B  and [bx+si],al
  db 0x00, 0x01                ; 00005C0D  add [bx+di],al
  db 0x00, 0x00                ; 00005C0F  add [bx+si],al
  db 0x00, 0x00                ; 00005C11  add [bx+si],al
  db 0x00, 0x00                ; 00005C13  add [bx+si],al
  db 0x00, 0x00                ; 00005C15  add [bx+si],al
  db 0x00, 0x00                ; 00005C17  add [bx+si],al
  db 0x00, 0x00                ; 00005C19  add [bx+si],al
  db 0x00, 0x00                ; 00005C1B  add [bx+si],al
  db 0x00, 0x00                ; 00005C1D  add [bx+si],al
  db 0x00, 0x00                ; 00005C1F  add [bx+si],al
  db 0x00, 0x4D, 0x58          ; 00005C21  add [di+0x58],cl
  db 0x64, 0x6D                ; 00005C24  fs insw
  db 0x61                      ; 00005C26  popa
  db 0x31, 0x20                ; 00005C27  xor [bx+si],sp
  db 0x20, 0x00                ; 00005C29  and [bx+si],al
  db 0x00, 0x00                ; 00005C2B  add [bx+si],al
  db 0x00, 0x02                ; 00005C2D  add [bp+si],al
  db 0x00, 0x6C, 0x69          ; 00005C2F  add [si+0x69],ch
  db 0x6E                      ; 00005C32  outsb
  db 0x6B, 0x5F, 0x72, 0x65    ; 00005C33  imul bx,[bx+0x72],byte +0x65
  db 0x71, 0x0F                ; 00005C37  jno 0x5c48
  db 0x00, 0x01                ; 00005C39  add [bx+di],al
  db 0x00, 0x00                ; 00005C3B  add [bx+si],al
  db 0x00, 0x00                ; 00005C3D  add [bx+si],al
  db 0x00, 0x00                ; 00005C3F  add [bx+si],al
  db 0x00, 0x00                ; 00005C41  add [bx+si],al
  db 0x00, 0x62, 0x68          ; 00005C43  add [bp+si+0x68],ah
  db 0x00, 0x00                ; 00005C46  add [bx+si],al
  db 0x00, 0x00                ; 00005C48  add [bx+si],al
  db 0x02, 0x00                ; 00005C4A  add al,[bx+si]
  db 0x58                      ; 00005C4C  pop ax
  db 0x4D                      ; 00005C4D  dec bp
  db 0x49                      ; 00005C4E  dec cx
  db 0x54                      ; 00005C4F  push sp
  db 0x5F                      ; 00005C50  pop di
  db 0x52                      ; 00005C51  push dx
  db 0x45                      ; 00005C52  inc bp
  db 0x51                      ; 00005C53  push cx
  db 0x0F, 0x00, 0x0A          ; 00005C54  str [bp+si]
  db 0x00, 0x00                ; 00005C57  add [bx+si],al
  db 0x00, 0x00                ; 00005C59  add [bx+si],al
  db 0x00, 0x00                ; 00005C5B  add [bx+si],al
  db 0x00, 0x00                ; 00005C5D  add [bx+si],al
  db 0x00, 0x71, 0x68          ; 00005C5F  add [bx+di+0x68],dh
  db 0x00, 0x00                ; 00005C62  add [bx+si],al
  db 0x00, 0x00                ; 00005C64  add [bx+si],al
  db 0x00, 0x00                ; 00005C66  add [bx+si],al
  db 0x00, 0x00                ; 00005C68  add [bx+si],al
  db 0x00, 0x00                ; 00005C6A  add [bx+si],al
  db 0x00, 0x00                ; 00005C6C  add [bx+si],al
  db 0x00, 0x00                ; 00005C6E  add [bx+si],al
  db 0x00, 0x00                ; 00005C70  add [bx+si],al
  db 0x00, 0x00                ; 00005C72  add [bx+si],al
  db 0x00, 0x00                ; 00005C74  add [bx+si],al
  db 0x00, 0x00                ; 00005C76  add [bx+si],al
  db 0x00, 0x00                ; 00005C78  add [bx+si],al
  db 0x00, 0x00                ; 00005C7A  add [bx+si],al
  db 0x00, 0x00                ; 00005C7C  add [bx+si],al
  db 0x00, 0x00                ; 00005C7E  add [bx+si],al
  db 0x00, 0x00                ; 00005C80  add [bx+si],al
  db 0x00, 0x00                ; 00005C82  add [bx+si],al
  db 0x00, 0x00                ; 00005C84  add [bx+si],al
  db 0x00, 0x00                ; 00005C86  add [bx+si],al
  db 0x00, 0x00                ; 00005C88  add [bx+si],al
  db 0x00, 0x00                ; 00005C8A  add [bx+si],al
  db 0x00, 0x00                ; 00005C8C  add [bx+si],al
  db 0x00, 0x00                ; 00005C8E  add [bx+si],al
  db 0x00, 0x00                ; 00005C90  add [bx+si],al
  db 0x00, 0x00                ; 00005C92  add [bx+si],al
  db 0x00, 0x00                ; 00005C94  add [bx+si],al
  db 0x00, 0x00                ; 00005C96  add [bx+si],al
  db 0x00, 0x00                ; 00005C98  add [bx+si],al
  db 0x00, 0x00                ; 00005C9A  add [bx+si],al
  db 0x00, 0x00                ; 00005C9C  add [bx+si],al
  db 0x00, 0x00                ; 00005C9E  add [bx+si],al
  db 0x00, 0x00                ; 00005CA0  add [bx+si],al
  db 0x00, 0x00                ; 00005CA2  add [bx+si],al
  db 0x00, 0x00                ; 00005CA4  add [bx+si],al
  db 0x00, 0x00                ; 00005CA6  add [bx+si],al
  db 0x00, 0x00                ; 00005CA8  add [bx+si],al
  db 0x00, 0x00                ; 00005CAA  add [bx+si],al
  db 0x00, 0x00                ; 00005CAC  add [bx+si],al
  db 0x00, 0x00                ; 00005CAE  add [bx+si],al
  db 0x00, 0x00                ; 00005CB0  add [bx+si],al
  db 0x00, 0x00                ; 00005CB2  add [bx+si],al
  db 0x00, 0x00                ; 00005CB4  add [bx+si],al
  db 0x00, 0x00                ; 00005CB6  add [bx+si],al
  db 0x00, 0x00                ; 00005CB8  add [bx+si],al
  db 0x00, 0x00                ; 00005CBA  add [bx+si],al
  db 0x00, 0x00                ; 00005CBC  add [bx+si],al
  db 0x00, 0x00                ; 00005CBE  add [bx+si],al
  db 0x00, 0x00                ; 00005CC0  add [bx+si],al
  db 0x00, 0x00                ; 00005CC2  add [bx+si],al
  db 0x00, 0x00                ; 00005CC4  add [bx+si],al
  db 0x00, 0x00                ; 00005CC6  add [bx+si],al
  db 0x00, 0x00                ; 00005CC8  add [bx+si],al
  db 0x00, 0x00                ; 00005CCA  add [bx+si],al
  db 0x00, 0x00                ; 00005CCC  add [bx+si],al
  db 0x00, 0x00                ; 00005CCE  add [bx+si],al
  db 0x00, 0x00                ; 00005CD0  add [bx+si],al
  db 0x00, 0x00                ; 00005CD2  add [bx+si],al
  db 0x00, 0x00                ; 00005CD4  add [bx+si],al
  db 0x00, 0x00                ; 00005CD6  add [bx+si],al
  db 0x00, 0x00                ; 00005CD8  add [bx+si],al
  db 0x00, 0x00                ; 00005CDA  add [bx+si],al
  db 0x00, 0x00                ; 00005CDC  add [bx+si],al
  db 0x00, 0x00                ; 00005CDE  add [bx+si],al
  db 0x00, 0x00                ; 00005CE0  add [bx+si],al
  db 0x00, 0x00                ; 00005CE2  add [bx+si],al
  db 0x00, 0x00                ; 00005CE4  add [bx+si],al
  db 0x00, 0x00                ; 00005CE6  add [bx+si],al
  db 0x00, 0x00                ; 00005CE8  add [bx+si],al
  db 0x00, 0x00                ; 00005CEA  add [bx+si],al
  db 0x00, 0x00                ; 00005CEC  add [bx+si],al
  db 0x00, 0x00                ; 00005CEE  add [bx+si],al
  db 0x00, 0x00                ; 00005CF0  add [bx+si],al
  db 0x00, 0x00                ; 00005CF2  add [bx+si],al
  db 0x00, 0x00                ; 00005CF4  add [bx+si],al
  db 0x00, 0x00                ; 00005CF6  add [bx+si],al
  db 0x00, 0x00                ; 00005CF8  add [bx+si],al
  db 0x00, 0x00                ; 00005CFA  add [bx+si],al
  db 0x00, 0x00                ; 00005CFC  add [bx+si],al
  db 0x00, 0x00                ; 00005CFE  add [bx+si],al
  db 0x00, 0x00                ; 00005D00  add [bx+si],al
  db 0x00, 0x00                ; 00005D02  add [bx+si],al
  db 0x00, 0x00                ; 00005D04  add [bx+si],al
  db 0x00, 0x00                ; 00005D06  add [bx+si],al
  db 0x00, 0x00                ; 00005D08  add [bx+si],al
  db 0x00, 0x03                ; 00005D0A  add [bp+di],al
  db 0x00, 0x4D, 0x58          ; 00005D0C  add [di+0x58],cl
  db 0x61                      ; 00005D0F  popa
  db 0x6C                      ; 00005D10  insb
  db 0x74, 0x20                ; 00005D11  jz 0x5d33
  db 0x20, 0x20                ; 00005D13  and [bx+si],ah
  db 0x00, 0x00                ; 00005D15  add [bx+si],al
  db 0x01, 0x00                ; 00005D17  add [bx+si],ax
  db 0x00, 0x00                ; 00005D19  add [bx+si],al
  db 0x00, 0x00                ; 00005D1B  add [bx+si],al
  db 0x00, 0x00                ; 00005D1D  add [bx+si],al
  db 0x00, 0x00                ; 00005D1F  add [bx+si],al
  db 0x00, 0x00                ; 00005D21  add [bx+si],al
  db 0x00, 0x00                ; 00005D23  add [bx+si],al
  db 0x00, 0x00                ; 00005D25  add [bx+si],al
  db 0x00, 0x00                ; 00005D27  add [bx+si],al
  db 0x00, 0x00                ; 00005D29  add [bx+si],al
  db 0x4D                      ; 00005D2B  dec bp
  db 0x58                      ; 00005D2C  pop ax
  db 0x61                      ; 00005D2D  popa
  db 0x6C                      ; 00005D2E  insb
  db 0x74, 0x20                ; 00005D2F  jz 0x5d51
  db 0x20, 0x20                ; 00005D31  and [bx+si],ah
  db 0x00, 0x00                ; 00005D33  add [bx+si],al
  db 0x00, 0x00                ; 00005D35  add [bx+si],al
  db 0x03, 0x00                ; 00005D37  add ax,[bx+si]
  db 0x4D                      ; 00005D39  dec bp
  db 0x58                      ; 00005D3A  pop ax
  db 0x63, 0x61, 0x73          ; 00005D3B  arpl [bx+di+0x73],sp
  db 0x73, 0x20                ; 00005D3E  jnc 0x5d60
  db 0x20, 0x00                ; 00005D40  and [bx+si],al
  db 0x00, 0x01                ; 00005D42  add [bx+di],al
  db 0x00, 0x00                ; 00005D44  add [bx+si],al
  db 0x00, 0x00                ; 00005D46  add [bx+si],al
  db 0x00, 0x00                ; 00005D48  add [bx+si],al
  db 0x00, 0x00                ; 00005D4A  add [bx+si],al
  db 0x00, 0x00                ; 00005D4C  add [bx+si],al
  db 0x00, 0x00                ; 00005D4E  add [bx+si],al
  db 0x00, 0x00                ; 00005D50  add [bx+si],al
  db 0x00, 0x00                ; 00005D52  add [bx+si],al
  db 0x00, 0x00                ; 00005D54  add [bx+si],al
  db 0x00, 0x4D, 0x58          ; 00005D56  add [di+0x58],cl
  db 0x63, 0x61, 0x73          ; 00005D59  arpl [bx+di+0x73],sp
  db 0x73, 0x20                ; 00005D5C  jnc 0x5d7e
  db 0x20, 0xFF                ; 00005D5E  and bh,bh
  db 0xFF, 0x00                ; 00005D60  inc word [bx+si]
  db 0x00, 0x00                ; 00005D62  add [bx+si],al
  db 0x00, 0x00                ; 00005D64  add [bx+si],al
  db 0x00, 0x00                ; 00005D66  add [bx+si],al
  db 0x00, 0x00                ; 00005D68  add [bx+si],al
  db 0x01, 0xE8                ; 00005D6A  add ax,bp
  db 0x20, 0x03                ; 00005D6C  and [bp+di],al
  db 0x8B, 0xDA                ; 00005D6E  mov bx,dx
  db 0x2E, 0xC7, 0x06, 0x68, 0x69, 0x00, 0x00 ; 00005D70  mov word [cs:0x6968],0x0
  db 0x2E, 0xC6, 0x06, 0x6A, 0x69, 0x01 ; 00005D77  mov byte [cs:0x696a],0x1
  db 0x2E, 0x89, 0x0E, 0x66, 0x69 ; 00005D7D  mov [cs:0x6966],cx
  db 0xE8, 0x77, 0x00          ; 00005D82  call 0x5dfc
  db 0x87, 0xDA                ; 00005D85  xchg bx,dx
  db 0x87, 0xD9                ; 00005D87  xchg bx,cx
  db 0xC3                      ; 00005D89  ret
  db 0xE8, 0x01, 0x03          ; 00005D8A  call 0x608e
  db 0x8B, 0xDA                ; 00005D8D  mov bx,dx
  db 0x2E, 0xC7, 0x06, 0x68, 0x69, 0x00, 0x00 ; 00005D8F  mov word [cs:0x6968],0x0
  db 0x2E, 0x89, 0x0E, 0x66, 0x69 ; 00005D96  mov [cs:0x6966],cx
  db 0x2E, 0xC6, 0x06, 0x6A, 0x69, 0x01 ; 00005D9B  mov byte [cs:0x696a],0x1
  db 0xE8, 0xA9, 0x01          ; 00005DA1  call 0x5f4d
  db 0x8B, 0xD3                ; 00005DA4  mov dx,bx
  db 0xC3                      ; 00005DA6  ret
  db 0xE8, 0xE4, 0x02          ; 00005DA7  call 0x608e
  db 0x8B, 0xDA                ; 00005DAA  mov bx,dx
  db 0x2E, 0xC6, 0x06, 0x6A, 0x69, 0x02 ; 00005DAC  mov byte [cs:0x696a],0x2
  db 0x2E, 0xFF, 0x06, 0x68, 0x69 ; 00005DB2  inc word [cs:0x6968]
  db 0x2E, 0x89, 0x0E, 0x66, 0x69 ; 00005DB7  mov [cs:0x6966],cx
  db 0xE8, 0x3D, 0x00          ; 00005DBC  call 0x5dfc
  db 0x87, 0xDA                ; 00005DBF  xchg bx,dx
  db 0x87, 0xD9                ; 00005DC1  xchg bx,cx
  db 0xC3                      ; 00005DC3  ret
  db 0xE8, 0xC7, 0x02          ; 00005DC4  call 0x608e
  db 0x8B, 0xDA                ; 00005DC7  mov bx,dx
  db 0x2E, 0xC6, 0x06, 0x6A, 0x69, 0x02 ; 00005DC9  mov byte [cs:0x696a],0x2
  db 0x2E, 0x89, 0x0E, 0x66, 0x69 ; 00005DCF  mov [cs:0x6966],cx
  db 0x2E, 0xFF, 0x06, 0x68, 0x69 ; 00005DD4  inc word [cs:0x6968]
  db 0xE8, 0x71, 0x01          ; 00005DD9  call 0x5f4d
  db 0x8B, 0xD3                ; 00005DDC  mov dx,bx
  db 0xC3                      ; 00005DDE  ret
  db 0xE8, 0xAC, 0x02          ; 00005DDF  call 0x608e
  db 0x8B, 0xDA                ; 00005DE2  mov bx,dx
  db 0x2E, 0xC6, 0x06, 0x6A, 0x69, 0x03 ; 00005DE4  mov byte [cs:0x696a],0x3
  db 0x2E, 0xC7, 0x06, 0x66, 0x69, 0x00, 0x00 ; 00005DEA  mov word [cs:0x6966],0x0
  db 0x2E, 0xFF, 0x06, 0x68, 0x69 ; 00005DF1  inc word [cs:0x6968]
  db 0xE8, 0x54, 0x01          ; 00005DF6  call 0x5f4d
  db 0x8B, 0xD3                ; 00005DF9  mov dx,bx
  db 0xC3                      ; 00005DFB  ret
  db 0xFA                      ; 00005DFC  cli
  db 0x53                      ; 00005DFD  push bx
  db 0x51                      ; 00005DFE  push cx
  db 0x56                      ; 00005DFF  push si
  db 0xBE, 0x0A, 0x00          ; 00005E00  mov si,0xa
  db 0xE8, 0x47, 0x02          ; 00005E03  call 0x604d
  db 0xB8, 0xFF, 0xFF          ; 00005E06  mov ax,0xffff
  db 0xBA, 0x52, 0xFF          ; 00005E09  mov dx,0xff52
  db 0xEF                      ; 00005E0C  out dx,ax
  db 0xBA, 0x54, 0xFF          ; 00005E0D  mov dx,0xff54
  db 0xEF                      ; 00005E10  out dx,ax
  db 0xB8, 0x13, 0xC0          ; 00005E11  mov ax,0xc013
  db 0xBA, 0x56, 0xFF          ; 00005E14  mov dx,0xff56
  db 0xEF                      ; 00005E17  out dx,ax
  db 0xB8, 0x01, 0x00          ; 00005E18  mov ax,0x1
  db 0xE7, 0x76                ; 00005E1B  out 0x76,ax
  db 0xE4, 0x70                ; 00005E1D  in al,0x70
  db 0x24, 0x01                ; 00005E1F  and al,0x1
  db 0x2E, 0xA2, 0x63, 0x69    ; 00005E21  mov [cs:0x6963],al
  db 0xBA, 0x7A, 0x3F          ; 00005E25  mov dx,0x3f7a
  db 0x4A                      ; 00005E28  dec dx
  db 0x75, 0x03                ; 00005E29  jnz 0x5e2e
  db 0xE9, 0xA1, 0x00          ; 00005E2B  jmp 0x5ecf
  db 0xE8, 0xF4, 0x00          ; 00005E2E  call 0x5f25
  db 0xE3, 0xF5                ; 00005E31  jcxz 0x5e28
  db 0xB9, 0x12, 0x05          ; 00005E33  mov cx,0x512
  db 0xBA, 0x65, 0x04          ; 00005E36  mov dx,0x465
  db 0x51                      ; 00005E39  push cx
  db 0xE8, 0xE8, 0x00          ; 00005E3A  call 0x5f25
  db 0x0B, 0xC9                ; 00005E3D  or cx,cx
  db 0x59                      ; 00005E3F  pop cx
  db 0x74, 0xDB                ; 00005E40  jz 0x5e1d
  db 0x3B, 0xD3                ; 00005E42  cmp dx,bx
  db 0xE3, 0x04                ; 00005E44  jcxz 0x5e4a
  db 0x73, 0xD5                ; 00005E46  jnc 0x5e1d
  db 0xE2, 0xEF                ; 00005E48  loop 0x5e39
  db 0x72, 0xED                ; 00005E4A  jc 0x5e39
  db 0xE8, 0xD6, 0x00          ; 00005E4C  call 0x5f25
  db 0xE8, 0xA1, 0x00          ; 00005E4F  call 0x5ef3
  db 0x3C, 0x03                ; 00005E52  cmp al,0x3
  db 0x74, 0x7E                ; 00005E54  jz 0x5ed4
  db 0x2E, 0x3A, 0x06, 0x6A, 0x69 ; 00005E56  cmp al,[cs:0x696a]
  db 0x75, 0x6C                ; 00005E5B  jnz 0x5ec9
  db 0x5E                      ; 00005E5D  pop si
  db 0x59                      ; 00005E5E  pop cx
  db 0x5B                      ; 00005E5F  pop bx
  db 0xE8, 0x90, 0x00          ; 00005E60  call 0x5ef3
  db 0x8A, 0xE0                ; 00005E63  mov ah,al
  db 0xE8, 0x8B, 0x00          ; 00005E65  call 0x5ef3
  db 0x2E, 0x3B, 0x06, 0x68, 0x69 ; 00005E68  cmp ax,[cs:0x6968]
  db 0xB0, 0x04                ; 00005E6D  mov al,0x4
  db 0x50                      ; 00005E6F  push ax
  db 0x75, 0x72                ; 00005E70  jnz 0x5ee4
  db 0x58                      ; 00005E72  pop ax
  db 0xE8, 0x7D, 0x00          ; 00005E73  call 0x5ef3
  db 0x8A, 0xE0                ; 00005E76  mov ah,al
  db 0xE8, 0x78, 0x00          ; 00005E78  call 0x5ef3
  db 0x3B, 0xC1                ; 00005E7B  cmp ax,cx
  db 0x73, 0x02                ; 00005E7D  jnc 0x5e81
  db 0x8B, 0xC8                ; 00005E7F  mov cx,ax
  db 0x51                      ; 00005E81  push cx
  db 0xB8, 0x00, 0x00          ; 00005E82  mov ax,0x0
  db 0x2E, 0xC7, 0x06, 0x5F, 0x69, 0xFF, 0xFF ; 00005E85  mov word [cs:0x695f],0xffff
  db 0xBA, 0x80, 0x00          ; 00005E8C  mov dx,0x80
  db 0xE8, 0x61, 0x00          ; 00005E8F  call 0x5ef3
  db 0x72, 0x23                ; 00005E92  jc 0x5eb7
  db 0xE3, 0x04                ; 00005E94  jcxz 0x5e9a
  db 0x88, 0x07                ; 00005E96  mov [bx],al
  db 0x43                      ; 00005E98  inc bx
  db 0x49                      ; 00005E99  dec cx
  db 0x4A                      ; 00005E9A  dec dx
  db 0x7F, 0xF2                ; 00005E9B  jg 0x5e8f
  db 0xE8, 0x53, 0x00          ; 00005E9D  call 0x5ef3
  db 0x8A, 0xE0                ; 00005EA0  mov ah,al
  db 0xE8, 0x4E, 0x00          ; 00005EA2  call 0x5ef3
  db 0xF7, 0xD0                ; 00005EA5  not ax
  db 0x2E, 0x81, 0x3E, 0x5F, 0x69, 0x0F, 0x1D ; 00005EA7  cmp word [cs:0x695f],0x1d0f
  db 0xB0, 0x00                ; 00005EAE  mov al,0x0
  db 0x75, 0x07                ; 00005EB0  jnz 0x5eb9
  db 0xE3, 0x07                ; 00005EB2  jcxz 0x5ebb
  db 0xE9, 0xCB, 0xFF          ; 00005EB4  jmp 0x5e82
  db 0xB0, 0x01                ; 00005EB7  mov al,0x1
  db 0xFE, 0xC0                ; 00005EB9  inc al
  db 0x5A                      ; 00005EBB  pop dx
  db 0x2B, 0xD1                ; 00005EBC  sub dx,cx
  db 0x50                      ; 00005EBE  push ax
  db 0xA8, 0x03                ; 00005EBF  test al,0x3
  db 0x75, 0x21                ; 00005EC1  jnz 0x5ee4
  db 0xE8, 0x2D, 0x00          ; 00005EC3  call 0x5ef3
  db 0xE9, 0x1B, 0x00          ; 00005EC6  jmp 0x5ee4
  db 0x4E                      ; 00005EC9  dec si
  db 0x74, 0x03                ; 00005ECA  jz 0x5ecf
  db 0xE9, 0x4E, 0xFF          ; 00005ECC  jmp 0x5e1d
  db 0xB0, 0x03                ; 00005ECF  mov al,0x3
  db 0xE9, 0x0A, 0x00          ; 00005ED1  jmp 0x5ede
  db 0x2E, 0x80, 0x3E, 0x6A, 0x69, 0x01 ; 00005ED4  cmp byte [cs:0x696a],0x1
  db 0x74, 0xED                ; 00005EDA  jz 0x5ec9
  db 0xB0, 0x05                ; 00005EDC  mov al,0x5
  db 0x5E                      ; 00005EDE  pop si
  db 0x59                      ; 00005EDF  pop cx
  db 0x5B                      ; 00005EE0  pop bx
  db 0x2B, 0xD2                ; 00005EE1  sub dx,dx
  db 0x50                      ; 00005EE3  push ax
  db 0xB8, 0x03, 0x00          ; 00005EE4  mov ax,0x3
  db 0xE7, 0x76                ; 00005EE7  out 0x76,ax
  db 0x58                      ; 00005EE9  pop ax
  db 0x80, 0xFC, 0x01          ; 00005EEA  cmp ah,0x1
  db 0xF5                      ; 00005EED  cmc
  db 0xE8, 0x6D, 0x01          ; 00005EEE  call 0x605e
  db 0xFB                      ; 00005EF1  sti
  db 0xC3                      ; 00005EF2  ret
  db 0x53                      ; 00005EF3  push bx
  db 0x51                      ; 00005EF4  push cx
  db 0x50                      ; 00005EF5  push ax
  db 0xB1, 0x08                ; 00005EF6  mov cl,0x8
  db 0x51                      ; 00005EF8  push cx
  db 0xE8, 0x29, 0x00          ; 00005EF9  call 0x5f25
  db 0xE3, 0x21                ; 00005EFC  jcxz 0x5f1f
  db 0x53                      ; 00005EFE  push bx
  db 0xE8, 0x23, 0x00          ; 00005EFF  call 0x5f25
  db 0x58                      ; 00005F02  pop ax
  db 0xE3, 0x1A                ; 00005F03  jcxz 0x5f1f
  db 0x03, 0xD8                ; 00005F05  add bx,ax
  db 0x81, 0xFB, 0xCA, 0x08    ; 00005F07  cmp bx,0x8ca
  db 0xF5                      ; 00005F0B  cmc
  db 0x9F                      ; 00005F0C  lahf
  db 0x59                      ; 00005F0D  pop cx
  db 0xD0, 0xD5                ; 00005F0E  rcl ch,1
  db 0x9E                      ; 00005F10  sahf
  db 0xE8, 0x23, 0x01          ; 00005F11  call 0x6037
  db 0xFE, 0xC9                ; 00005F14  dec cl
  db 0x75, 0xE0                ; 00005F16  jnz 0x5ef8
  db 0x58                      ; 00005F18  pop ax
  db 0x8A, 0xC5                ; 00005F19  mov al,ch
  db 0xF8                      ; 00005F1B  clc
  db 0x59                      ; 00005F1C  pop cx
  db 0x5B                      ; 00005F1D  pop bx
  db 0xC3                      ; 00005F1E  ret
  db 0x59                      ; 00005F1F  pop cx
  db 0x58                      ; 00005F20  pop ax
  db 0xF9                      ; 00005F21  stc
  db 0xE9, 0xF7, 0xFF          ; 00005F22  jmp 0x5f1c
  db 0xB9, 0x90, 0x01          ; 00005F25  mov cx,0x190
  db 0x2E, 0x8A, 0x26, 0x63, 0x69 ; 00005F28  mov ah,[cs:0x6963]
  db 0xE4, 0x70                ; 00005F2D  in al,0x70
  db 0x24, 0x01                ; 00005F2F  and al,0x1
  db 0x3A, 0xC4                ; 00005F31  cmp al,ah
  db 0xE1, 0xF8                ; 00005F33  loope 0x5f2d
  db 0x2E, 0xA2, 0x63, 0x69    ; 00005F35  mov [cs:0x6963],al
  db 0x52                      ; 00005F39  push dx
  db 0xBA, 0x50, 0xFF          ; 00005F3A  mov dx,0xff50
  db 0xED                      ; 00005F3D  in ax,dx
  db 0x5A                      ; 00005F3E  pop dx
  db 0x8B, 0xD8                ; 00005F3F  mov bx,ax
  db 0x2E, 0xA1, 0x61, 0x69    ; 00005F41  mov ax,[cs:0x6961]
  db 0x2E, 0x89, 0x1E, 0x61, 0x69 ; 00005F45  mov [cs:0x6961],bx
  db 0x2B, 0xD8                ; 00005F4A  sub bx,ax
  db 0xC3                      ; 00005F4C  ret
  db 0xFA                      ; 00005F4D  cli
  db 0x53                      ; 00005F4E  push bx
  db 0x51                      ; 00005F4F  push cx
  db 0xB8, 0x13, 0xC0          ; 00005F50  mov ax,0xc013
  db 0xBA, 0x56, 0xFF          ; 00005F53  mov dx,0xff56
  db 0xEF                      ; 00005F56  out dx,ax
  db 0xB8, 0xDC, 0x05          ; 00005F57  mov ax,0x5dc
  db 0xBA, 0x52, 0xFF          ; 00005F5A  mov dx,0xff52
  db 0xEF                      ; 00005F5D  out dx,ax
  db 0xBA, 0x54, 0xFF          ; 00005F5E  mov dx,0xff54
  db 0xEF                      ; 00005F61  out dx,ax
  db 0xE8, 0xE8, 0x00          ; 00005F62  call 0x604d
  db 0xB8, 0x01, 0x00          ; 00005F65  mov ax,0x1
  db 0xE7, 0x76                ; 00005F68  out 0x76,ax
  db 0xB9, 0xE8, 0x07          ; 00005F6A  mov cx,0x7e8
  db 0xF9                      ; 00005F6D  stc
  db 0xE8, 0x93, 0x00          ; 00005F6E  call 0x6004
  db 0xE2, 0xFA                ; 00005F71  loop 0x5f6d
  db 0xF8                      ; 00005F73  clc
  db 0xE8, 0x8D, 0x00          ; 00005F74  call 0x6004
  db 0x2E, 0xA0, 0x6A, 0x69    ; 00005F77  mov al,[cs:0x696a]
  db 0x50                      ; 00005F7B  push ax
  db 0xE8, 0x6E, 0x00          ; 00005F7C  call 0x5fed
  db 0x58                      ; 00005F7F  pop ax
  db 0x3C, 0x03                ; 00005F80  cmp al,0x3
  db 0x74, 0x56                ; 00005F82  jz 0x5fda
  db 0x2E, 0xA1, 0x68, 0x69    ; 00005F84  mov ax,[cs:0x6968]
  db 0x50                      ; 00005F88  push ax
  db 0x86, 0xE0                ; 00005F89  xchg ah,al
  db 0xE8, 0x5F, 0x00          ; 00005F8B  call 0x5fed
  db 0x58                      ; 00005F8E  pop ax
  db 0xE8, 0x5B, 0x00          ; 00005F8F  call 0x5fed
  db 0x2E, 0xA1, 0x66, 0x69    ; 00005F92  mov ax,[cs:0x6966]
  db 0x50                      ; 00005F96  push ax
  db 0x86, 0xE0                ; 00005F97  xchg ah,al
  db 0xE8, 0x51, 0x00          ; 00005F99  call 0x5fed
  db 0x58                      ; 00005F9C  pop ax
  db 0xE8, 0x4D, 0x00          ; 00005F9D  call 0x5fed
  db 0x59                      ; 00005FA0  pop cx
  db 0x5B                      ; 00005FA1  pop bx
  db 0x2E, 0xC7, 0x06, 0x5F, 0x69, 0xFF, 0xFF ; 00005FA2  mov word [cs:0x695f],0xffff
  db 0xBA, 0x80, 0x00          ; 00005FA9  mov dx,0x80
  db 0x8A, 0x07                ; 00005FAC  mov al,[bx]
  db 0xE8, 0x3C, 0x00          ; 00005FAE  call 0x5fed
  db 0xE3, 0x02                ; 00005FB1  jcxz 0x5fb5
  db 0x43                      ; 00005FB3  inc bx
  db 0x49                      ; 00005FB4  dec cx
  db 0x4A                      ; 00005FB5  dec dx
  db 0x7F, 0xF4                ; 00005FB6  jg 0x5fac
  db 0x2E, 0xA1, 0x5F, 0x69    ; 00005FB8  mov ax,[cs:0x695f]
  db 0xF7, 0xD0                ; 00005FBC  not ax
  db 0x50                      ; 00005FBE  push ax
  db 0x86, 0xE0                ; 00005FBF  xchg ah,al
  db 0xE8, 0x29, 0x00          ; 00005FC1  call 0x5fed
  db 0x58                      ; 00005FC4  pop ax
  db 0xE8, 0x25, 0x00          ; 00005FC5  call 0x5fed
  db 0x0B, 0xC9                ; 00005FC8  or cx,cx
  db 0x75, 0xD6                ; 00005FCA  jnz 0x5fa2
  db 0x51                      ; 00005FCC  push cx
  db 0xB9, 0x20, 0x00          ; 00005FCD  mov cx,0x20
  db 0xF9                      ; 00005FD0  stc
  db 0xE8, 0x30, 0x00          ; 00005FD1  call 0x6004
  db 0xE2, 0xFA                ; 00005FD4  loop 0x5fd0
  db 0x59                      ; 00005FD6  pop cx
  db 0xE9, 0x02, 0x00          ; 00005FD7  jmp 0x5fdc
  db 0x59                      ; 00005FDA  pop cx
  db 0x5B                      ; 00005FDB  pop bx
  db 0xB8, 0x00, 0x00          ; 00005FDC  mov ax,0x0
  db 0xE7, 0x76                ; 00005FDF  out 0x76,ax
  db 0xB8, 0x03, 0x00          ; 00005FE1  mov ax,0x3
  db 0xE7, 0x76                ; 00005FE4  out 0x76,ax
  db 0x2B, 0xC0                ; 00005FE6  sub ax,ax
  db 0xE8, 0x73, 0x00          ; 00005FE8  call 0x605e
  db 0xFB                      ; 00005FEB  sti
  db 0xC3                      ; 00005FEC  ret
  db 0x51                      ; 00005FED  push cx
  db 0x50                      ; 00005FEE  push ax
  db 0x8A, 0xE8                ; 00005FEF  mov ch,al
  db 0xB1, 0x08                ; 00005FF1  mov cl,0x8
  db 0xD0, 0xD5                ; 00005FF3  rcl ch,1
  db 0x9C                      ; 00005FF5  pushf
  db 0xE8, 0x0B, 0x00          ; 00005FF6  call 0x6004
  db 0x9D                      ; 00005FF9  popf
  db 0xE8, 0x3A, 0x00          ; 00005FFA  call 0x6037
  db 0xFE, 0xC9                ; 00005FFD  dec cl
  db 0x75, 0xF2                ; 00005FFF  jnz 0x5ff3
  db 0x58                      ; 00006001  pop ax
  db 0x59                      ; 00006002  pop cx
  db 0xC3                      ; 00006003  ret
  db 0xB8, 0xDC, 0x05          ; 00006004  mov ax,0x5dc
  db 0x72, 0x03                ; 00006007  jc 0x600c
  db 0xB8, 0xEE, 0x02          ; 00006009  mov ax,0x2ee
  db 0x52                      ; 0000600C  push dx
  db 0x50                      ; 0000600D  push ax
  db 0xBA, 0x56, 0xFF          ; 0000600E  mov dx,0xff56
  db 0xED                      ; 00006011  in ax,dx
  db 0x25, 0x20, 0x00          ; 00006012  and ax,0x20
  db 0x74, 0xF7                ; 00006015  jz 0x600e
  db 0xED                      ; 00006017  in ax,dx
  db 0x25, 0xDF, 0xFF          ; 00006018  and ax,0xffdf
  db 0xEF                      ; 0000601B  out dx,ax
  db 0x58                      ; 0000601C  pop ax
  db 0x50                      ; 0000601D  push ax
  db 0xBA, 0x52, 0xFF          ; 0000601E  mov dx,0xff52
  db 0xEF                      ; 00006021  out dx,ax
  db 0xBA, 0x56, 0xFF          ; 00006022  mov dx,0xff56
  db 0xED                      ; 00006025  in ax,dx
  db 0x25, 0x20, 0x00          ; 00006026  and ax,0x20
  db 0x74, 0xF7                ; 00006029  jz 0x6022
  db 0xED                      ; 0000602B  in ax,dx
  db 0x25, 0xDF, 0xFF          ; 0000602C  and ax,0xffdf
  db 0xEF                      ; 0000602F  out dx,ax
  db 0x58                      ; 00006030  pop ax
  db 0xBA, 0x54, 0xFF          ; 00006031  mov dx,0xff54
  db 0xEF                      ; 00006034  out dx,ax
  db 0x5A                      ; 00006035  pop dx
  db 0xC3                      ; 00006036  ret
  db 0x2E, 0xA1, 0x5F, 0x69    ; 00006037  mov ax,[cs:0x695f]
  db 0xD1, 0xD8                ; 0000603B  rcr ax,1
  db 0xD1, 0xD0                ; 0000603D  rcl ax,1
  db 0xF8                      ; 0000603F  clc
  db 0x71, 0x04                ; 00006040  jno 0x6046
  db 0x35, 0x10, 0x08          ; 00006042  xor ax,0x810
  db 0xF9                      ; 00006045  stc
  db 0xD1, 0xD0                ; 00006046  rcl ax,1
  db 0x2E, 0xA3, 0x5F, 0x69    ; 00006048  mov [cs:0x695f],ax
  db 0xC3                      ; 0000604C  ret
  db 0xB8, 0x02, 0x00          ; 0000604D  mov ax,0x2
  db 0xE7, 0x76                ; 00006050  out 0x76,ax
  db 0xB3, 0x96                ; 00006052  mov bl,0x96
  db 0xB9, 0xA0, 0x0F          ; 00006054  mov cx,0xfa0
  db 0xE2, 0xFE                ; 00006057  loop 0x6057
  db 0xFE, 0xCB                ; 00006059  dec bl
  db 0x75, 0xF7                ; 0000605B  jnz 0x6054
  db 0xC3                      ; 0000605D  ret
  db 0x52                      ; 0000605E  push dx
  db 0x50                      ; 0000605F  push ax
  db 0x06                      ; 00006060  push es
  db 0x53                      ; 00006061  push bx
  db 0x2E, 0xA1, 0x06, 0x0C    ; 00006062  mov ax,[cs:0xc06]
  db 0x8E, 0xC0                ; 00006066  mov es,ax
  db 0xBB, 0x00, 0x00          ; 00006068  mov bx,0x0
  db 0xB0, 0x02                ; 0000606B  mov al,0x2
  db 0xE8, 0x63, 0xDB          ; 0000606D  call 0x3bd3
  db 0x26, 0x88, 0x87, 0x82, 0x00 ; 00006070  mov [es:bx+0x82],al
  db 0xB0, 0x03                ; 00006075  mov al,0x3
  db 0xE8, 0x59, 0xDB          ; 00006077  call 0x3bd3
  db 0x26, 0x88, 0x87, 0x81, 0x00 ; 0000607A  mov [es:bx+0x81],al
  db 0xB0, 0x04                ; 0000607F  mov al,0x4
  db 0xE8, 0x4F, 0xDB          ; 00006081  call 0x3bd3
  db 0x26, 0x88, 0x87, 0x80, 0x00 ; 00006084  mov [es:bx+0x80],al
  db 0x5B                      ; 00006089  pop bx
  db 0x07                      ; 0000608A  pop es
  db 0x58                      ; 0000608B  pop ax
  db 0x5A                      ; 0000608C  pop dx
  db 0xC3                      ; 0000608D  ret
  db 0x58                      ; 0000608E  pop ax
  db 0x5B                      ; 0000608F  pop bx
  db 0x1F                      ; 00006090  pop ds
  db 0x1E                      ; 00006091  push ds
  db 0x53                      ; 00006092  push bx
  db 0x50                      ; 00006093  push ax
  db 0xC3                      ; 00006094  ret
  db 0x00, 0x00                ; 00006095  add [bx+si],al
  db 0x00, 0x00                ; 00006097  add [bx+si],al
  db 0x00, 0x00                ; 00006099  add [bx+si],al
  db 0x06                      ; 0000609B  push es
  db 0xBF, 0x96, 0x4C          ; 0000609C  mov di,0x4c96
  db 0x57                      ; 0000609F  push di
  db 0x57                      ; 000060A0  push di
  db 0x1E                      ; 000060A1  push ds
  db 0x07                      ; 000060A2  pop es
  db 0xB9, 0x50, 0x00          ; 000060A3  mov cx,0x50
  db 0xB0, 0x20                ; 000060A6  mov al,0x20
  db 0xF3, 0xAA                ; 000060A8  rep stosb
  db 0xAC                      ; 000060AA  lodsb
  db 0x8A, 0xC8                ; 000060AB  mov cl,al
  db 0x5F                      ; 000060AD  pop di
  db 0xF3, 0xA4                ; 000060AE  rep movsb
  db 0x59                      ; 000060B0  pop cx
  db 0x8C, 0xCA                ; 000060B1  mov dx,cs
  db 0x07                      ; 000060B3  pop es
  db 0xE8, 0x54, 0xB4          ; 000060B4  call 0x150b
  db 0xC3                      ; 000060B7  ret
  db 0x50                      ; 000060B8  push ax
  db 0x06                      ; 000060B9  push es
  db 0xE8, 0xAF, 0xD9          ; 000060BA  call 0x3a6c
  db 0x83, 0xC6, 0x13          ; 000060BD  add si,byte +0x13
  db 0x8A, 0x04                ; 000060C0  mov al,[si]
  db 0x3C, 0x00                ; 000060C2  cmp al,0x0
  db 0x07                      ; 000060C4  pop es
  db 0x58                      ; 000060C5  pop ax
  db 0x74, 0x6B                ; 000060C6  jz 0x6133
  db 0x80, 0xFC, 0x01          ; 000060C8  cmp ah,0x1
  db 0x75, 0x5A                ; 000060CB  jnz 0x6127
  db 0x2E, 0xC6, 0x06, 0x98, 0x6C, 0xFF ; 000060CD  mov byte [cs:0x6c98],0xff
  db 0xBA, 0x92, 0x02          ; 000060D3  mov dx,0x292
  db 0xB0, 0xFF                ; 000060D6  mov al,0xff
  db 0xEE                      ; 000060D8  out dx,al
  db 0xEC                      ; 000060D9  in al,dx
  db 0x24, 0x80                ; 000060DA  and al,0x80
  db 0x74, 0x2B                ; 000060DC  jz 0x6109
  db 0x1E                      ; 000060DE  push ds
  db 0x06                      ; 000060DF  push es
  db 0x51                      ; 000060E0  push cx
  db 0x52                      ; 000060E1  push dx
  db 0x0E                      ; 000060E2  push cs
  db 0x1F                      ; 000060E3  pop ds
  db 0x2E, 0x8B, 0x36, 0x68, 0x00 ; 000060E4  mov si,[cs:0x68]
  db 0x8E, 0x44, 0x10          ; 000060E9  mov es,[si+0x10]
  db 0xBE, 0x0B, 0x4D          ; 000060EC  mov si,0x4d0b
  db 0xE8, 0xA9, 0xFF          ; 000060EF  call 0x609b
  db 0x5A                      ; 000060F2  pop dx
  db 0x59                      ; 000060F3  pop cx
  db 0x07                      ; 000060F4  pop es
  db 0x1F                      ; 000060F5  pop ds
  db 0xB1, 0x83                ; 000060F6  mov cl,0x83
  db 0xB2, 0x02                ; 000060F8  mov dl,0x2
  db 0xE8, 0x36, 0xA0          ; 000060FA  call 0x133
  db 0x2E, 0xC6, 0x06, 0x95, 0x6C, 0xFF ; 000060FD  mov byte [cs:0x6c95],0xff
  db 0xB9, 0xFF, 0xFF          ; 00006103  mov cx,0xffff
  db 0xE8, 0x02, 0xB4          ; 00006106  call 0x150b
  db 0x2E, 0x80, 0x3E, 0x9A, 0x6C, 0xFF ; 00006109  cmp byte [cs:0x6c9a],0xff
  db 0x2E, 0xC6, 0x06, 0x9A, 0x6C, 0x00 ; 0000610F  mov byte [cs:0x6c9a],0x0
  db 0x2E, 0xC6, 0x06, 0x95, 0x6C, 0xFF ; 00006115  mov byte [cs:0x6c95],0xff
  db 0x2E, 0xC6, 0x06, 0x96, 0x6C, 0x0A ; 0000611B  mov byte [cs:0x6c96],0xa
  db 0x75, 0x01                ; 00006121  jnz 0x6124
  db 0xC3                      ; 00006123  ret
  db 0x33, 0xC0                ; 00006124  xor ax,ax
  db 0xC3                      ; 00006126  ret
  db 0x80, 0xFC, 0x02          ; 00006127  cmp ah,0x2
  db 0x75, 0x07                ; 0000612A  jnz 0x6133
  db 0x2E, 0xC6, 0x06, 0x98, 0x6C, 0x00 ; 0000612C  mov byte [cs:0x6c98],0x0
  db 0xC3                      ; 00006132  ret
  db 0xB8, 0xFF, 0xFF          ; 00006133  mov ax,0xffff
  db 0xC3                      ; 00006136  ret
  db 0x2E, 0x80, 0x3E, 0x95, 0x6C, 0xFF ; 00006137  cmp byte [cs:0x6c95],0xff
  db 0x75, 0x2A                ; 0000613D  jnz 0x6169
  db 0x2E, 0x80, 0x3E, 0x96, 0x6C, 0x00 ; 0000613F  cmp byte [cs:0x6c96],0x0
  db 0x74, 0x08                ; 00006145  jz 0x614f
  db 0x2E, 0xFE, 0x0E, 0x96, 0x6C ; 00006147  dec byte [cs:0x6c96]
  db 0xE9, 0x1A, 0x00          ; 0000614C  jmp 0x6169
  db 0x2E, 0x80, 0x3E, 0x98, 0x6C, 0xFF ; 0000614F  cmp byte [cs:0x6c98],0xff
  db 0x74, 0x12                ; 00006155  jz 0x6169
  db 0xBA, 0x94, 0x02          ; 00006157  mov dx,0x294
  db 0xEE                      ; 0000615A  out dx,al
  db 0x33, 0xC0                ; 0000615B  xor ax,ax
  db 0x2E, 0xC6, 0x06, 0x95, 0x6C, 0x00 ; 0000615D  mov byte [cs:0x6c95],0x0
  db 0x2E, 0xC6, 0x06, 0x96, 0x6C, 0x00 ; 00006163  mov byte [cs:0x6c96],0x0
  db 0xC3                      ; 00006169  ret
  db 0x50                      ; 0000616A  push ax
  db 0x06                      ; 0000616B  push es
  db 0xE8, 0xFD, 0xD8          ; 0000616C  call 0x3a6c
  db 0x83, 0xC6, 0x13          ; 0000616F  add si,byte +0x13
  db 0x26, 0x8A, 0x04          ; 00006172  mov al,[es:si]
  db 0x3C, 0x00                ; 00006175  cmp al,0x0
  db 0x07                      ; 00006177  pop es
  db 0x58                      ; 00006178  pop ax
  db 0x74, 0x4E                ; 00006179  jz 0x61c9
  db 0x80, 0xFC, 0x01          ; 0000617B  cmp ah,0x1
  db 0x75, 0x3D                ; 0000617E  jnz 0x61bd
  db 0x2E, 0xC6, 0x06, 0x99, 0x6C, 0xFF ; 00006180  mov byte [cs:0x6c99],0xff
  db 0x2E, 0xC6, 0x06, 0x97, 0x6C, 0x00 ; 00006186  mov byte [cs:0x6c97],0x0
  db 0xBA, 0x8E, 0x02          ; 0000618C  mov dx,0x28e
  db 0xB0, 0xFF                ; 0000618F  mov al,0xff
  db 0xEE                      ; 00006191  out dx,al
  db 0xEC                      ; 00006192  in al,dx
  db 0x24, 0x80                ; 00006193  and al,0x80
  db 0x74, 0x25                ; 00006195  jz 0x61bc
  db 0x1E                      ; 00006197  push ds
  db 0x06                      ; 00006198  push es
  db 0x51                      ; 00006199  push cx
  db 0x52                      ; 0000619A  push dx
  db 0x0E                      ; 0000619B  push cs
  db 0x1F                      ; 0000619C  pop ds
  db 0x2E, 0x8B, 0x36, 0x68, 0x00 ; 0000619D  mov si,[cs:0x68]
  db 0x8E, 0x44, 0x10          ; 000061A2  mov es,[si+0x10]
  db 0xBE, 0xE6, 0x4C          ; 000061A5  mov si,0x4ce6
  db 0xE8, 0xF0, 0xFE          ; 000061A8  call 0x609b
  db 0x5A                      ; 000061AB  pop dx
  db 0x59                      ; 000061AC  pop cx
  db 0x07                      ; 000061AD  pop es
  db 0x1F                      ; 000061AE  pop ds
  db 0xB2, 0x01                ; 000061AF  mov dl,0x1
  db 0xB1, 0x83                ; 000061B1  mov cl,0x83
  db 0xE8, 0x7D, 0x9F          ; 000061B3  call 0x133
  db 0xB9, 0xFF, 0xFF          ; 000061B6  mov cx,0xffff
  db 0xE8, 0x4F, 0xB3          ; 000061B9  call 0x150b
  db 0xC3                      ; 000061BC  ret
  db 0x80, 0xFC, 0x02          ; 000061BD  cmp ah,0x2
  db 0x75, 0x07                ; 000061C0  jnz 0x61c9
  db 0x2E, 0xC6, 0x06, 0x99, 0x6C, 0x00 ; 000061C2  mov byte [cs:0x6c99],0x0
  db 0xC3                      ; 000061C8  ret
  db 0xB8, 0xFF, 0xFF          ; 000061C9  mov ax,0xffff
  db 0xC3                      ; 000061CC  ret
  db 0x2E, 0x80, 0x3E, 0x97, 0x6C, 0xFF ; 000061CD  cmp byte [cs:0x6c97],0xff
  db 0x75, 0x1B                ; 000061D3  jnz 0x61f0
  db 0x2E, 0x80, 0x3E, 0x99, 0x6C, 0xFF ; 000061D5  cmp byte [cs:0x6c99],0xff
  db 0x74, 0x13                ; 000061DB  jz 0x61f0
  db 0x2E, 0xA1, 0x88, 0x00    ; 000061DD  mov ax,[cs:0x88]
  db 0x25, 0xFF, 0xEF          ; 000061E1  and ax,0xefff
  db 0x75, 0x0A                ; 000061E4  jnz 0x61f0
  db 0xBA, 0x90, 0x02          ; 000061E6  mov dx,0x290
  db 0xEE                      ; 000061E9  out dx,al
  db 0x2E, 0xC6, 0x06, 0x97, 0x6C, 0x00 ; 000061EA  mov byte [cs:0x6c97],0x0
  db 0xC3                      ; 000061F0  ret
  db 0xE8, 0xD9, 0xFF          ; 000061F1  call 0x61cd
  db 0xE8, 0x40, 0xFF          ; 000061F4  call 0x6137
  db 0xC3                      ; 000061F7  ret
  db 0x01, 0x03                ; 000061F8  add [bp+di],ax
  db 0x00, 0x00                ; 000061FA  add [bx+si],al
  db 0x50                      ; 000061FC  push ax
  db 0x00, 0x00                ; 000061FD  add [bx+si],al
  db 0x00, 0x00                ; 000061FF  add [bx+si],al
  db 0x00, 0x00                ; 00006201  add [bx+si],al
  db 0x00, 0x00                ; 00006203  add [bx+si],al
  db 0x00, 0x00                ; 00006205  add [bx+si],al
  db 0x00, 0x00                ; 00006207  add [bx+si],al
  db 0x00, 0x00                ; 00006209  add [bx+si],al
  db 0x00, 0x00                ; 0000620B  add [bx+si],al
  db 0x00, 0xF7                ; 0000620D  add bh,dh
  db 0xFF, 0x00                ; 0000620F  inc word [bx+si]
  db 0x00, 0xFF                ; 00006211  add bh,bh
  db 0xFF                      ; 00006213  db 0xff
  db 0xFF                      ; 00006214  db 0xff
  db 0xFF, 0x00                ; 00006215  inc word [bx+si]
  db 0x00, 0x00                ; 00006217  add [bx+si],al
  db 0x00, 0x00                ; 00006219  add [bx+si],al
  db 0x00, 0x00                ; 0000621B  add [bx+si],al
  db 0x00, 0x00                ; 0000621D  add [bx+si],al
  db 0x10, 0x03                ; 0000621F  adc [bp+di],al
  db 0x2F                      ; 00006221  das
  db 0x29, 0x06, 0x29, 0x06    ; 00006222  sub [0x629],ax
  db 0x00, 0x00                ; 00006226  add [bx+si],al
  db 0x09, 0x00                ; 00006228  or [bx+si],ax
  db 0x0A, 0x00                ; 0000622A  or al,[bx+si]
  db 0x05, 0x00, 0x09          ; 0000622C  add ax,0x900
  db 0x06                      ; 0000622F  push es
  db 0x09, 0x00                ; 00006230  or [bx+si],ax
  db 0x09, 0x00                ; 00006232  or [bx+si],ax
  db 0x09, 0x09                ; 00006234  or [bx+di],cx
  db 0x00, 0x00                ; 00006236  add [bx+si],al
  db 0x38, 0x01                ; 00006238  cmp [bx+di],al
  db 0x05, 0x00, 0x24          ; 0000623A  add ax,0x2400
  db 0x00, 0x1E, 0x01, 0x00    ; 0000623D  add [0x1],bl
  db 0x00, 0x00                ; 00006241  add [bx+si],al
  db 0x00, 0x01                ; 00006243  add [bx+di],al
  db 0x47                      ; 00006245  inc di
  db 0x03, 0x47, 0x04          ; 00006246  add ax,[bx+0x4]
  db 0xFA                      ; 00006249  cli
  db 0xF9                      ; 0000624A  stc
  db 0xFF, 0x00                ; 0000624B  inc word [bx+si]
  db 0x10, 0x03                ; 0000624D  adc [bp+di],al
  db 0x2F                      ; 0000624F  das
  db 0x29, 0x06, 0x29, 0x06    ; 00006250  sub [0x629],ax
  db 0x00, 0x00                ; 00006254  add [bx+si],al
  db 0x0F, 0x00, 0x10          ; 00006256  lldt [bx+si]
  db 0x00, 0x05                ; 00006259  add [di],al
  db 0x00, 0x09                ; 0000625B  add [bx+di],cl
  db 0x06                      ; 0000625D  push es
  db 0x09, 0x08                ; 0000625E  or [bx+si],cx
  db 0x09, 0x00                ; 00006260  or [bx+si],ax
  db 0x09, 0x09                ; 00006262  or [bx+di],cx
  db 0x00, 0x00                ; 00006264  add [bx+si],al
  db 0x38, 0x01                ; 00006266  cmp [bx+di],al
  db 0x05, 0x00, 0x20          ; 00006268  add ax,0x2000
  db 0x00, 0x20                ; 0000626B  add [bx+si],ah
  db 0x01, 0x00                ; 0000626D  add [bx+si],ax
  db 0x00, 0x00                ; 0000626F  add [bx+si],al
  db 0x00, 0x01                ; 00006271  add [bx+di],al
  db 0x47                      ; 00006273  inc di
  db 0x03, 0x47, 0x00          ; 00006274  add ax,[bx+0x0]
  db 0xFF                      ; 00006277  db 0xff
  db 0xFF                      ; 00006278  db 0xff
  db 0xFF, 0x00                ; 00006279  inc word [bx+si]
  db 0x00, 0x00                ; 0000627B  add [bx+si],al
  db 0x00, 0x00                ; 0000627D  add [bx+si],al
  db 0x00, 0x00                ; 0000627F  add [bx+si],al
  db 0x00, 0x00                ; 00006281  add [bx+si],al
  db 0x00, 0x00                ; 00006283  add [bx+si],al
  db 0x00, 0x00                ; 00006285  add [bx+si],al
  db 0x00, 0x00                ; 00006287  add [bx+si],al
  db 0x00, 0x00                ; 00006289  add [bx+si],al
  db 0x00, 0x00                ; 0000628B  add [bx+si],al
  db 0x00, 0x00                ; 0000628D  add [bx+si],al
  db 0x00, 0x00                ; 0000628F  add [bx+si],al
  db 0x00, 0x00                ; 00006291  add [bx+si],al
  db 0x00, 0x00                ; 00006293  add [bx+si],al
  db 0x00, 0x00                ; 00006295  add [bx+si],al
  db 0x00, 0x00                ; 00006297  add [bx+si],al
  db 0x00, 0x00                ; 00006299  add [bx+si],al
  db 0x00, 0x00                ; 0000629B  add [bx+si],al
  db 0x00, 0x00                ; 0000629D  add [bx+si],al
  db 0x00, 0x00                ; 0000629F  add [bx+si],al
  db 0x00, 0x00                ; 000062A1  add [bx+si],al
  db 0x00, 0x00                ; 000062A3  add [bx+si],al
  db 0x00, 0x00                ; 000062A5  add [bx+si],al
  db 0x00, 0x00                ; 000062A7  add [bx+si],al
  db 0x00, 0x00                ; 000062A9  add [bx+si],al
  db 0x00, 0x00                ; 000062AB  add [bx+si],al
  db 0x00, 0x00                ; 000062AD  add [bx+si],al
  db 0x00, 0x00                ; 000062AF  add [bx+si],al
  db 0x00, 0x00                ; 000062B1  add [bx+si],al
  db 0x00, 0x00                ; 000062B3  add [bx+si],al
  db 0x00, 0x00                ; 000062B5  add [bx+si],al
  db 0x00, 0x00                ; 000062B7  add [bx+si],al
  db 0x00, 0x00                ; 000062B9  add [bx+si],al
  db 0x00, 0x00                ; 000062BB  add [bx+si],al
  db 0x00, 0x00                ; 000062BD  add [bx+si],al
  db 0x00, 0x00                ; 000062BF  add [bx+si],al
  db 0x00, 0x00                ; 000062C1  add [bx+si],al
  db 0x00, 0x00                ; 000062C3  add [bx+si],al
  db 0x00, 0x00                ; 000062C5  add [bx+si],al
  db 0x00, 0x00                ; 000062C7  add [bx+si],al
  db 0x00, 0x00                ; 000062C9  add [bx+si],al
  db 0x00, 0x00                ; 000062CB  add [bx+si],al
  db 0x00, 0x00                ; 000062CD  add [bx+si],al
  db 0x00, 0x00                ; 000062CF  add [bx+si],al
  db 0x00, 0x00                ; 000062D1  add [bx+si],al
  db 0x00, 0x00                ; 000062D3  add [bx+si],al
  db 0x00, 0x00                ; 000062D5  add [bx+si],al
  db 0x00, 0x00                ; 000062D7  add [bx+si],al
  db 0x00, 0x00                ; 000062D9  add [bx+si],al
  db 0x00, 0x00                ; 000062DB  add [bx+si],al
  db 0x00, 0x00                ; 000062DD  add [bx+si],al
  db 0x00, 0x00                ; 000062DF  add [bx+si],al
  db 0x00, 0x00                ; 000062E1  add [bx+si],al
  db 0x00, 0x00                ; 000062E3  add [bx+si],al
  db 0x00, 0x00                ; 000062E5  add [bx+si],al
  db 0x00, 0x00                ; 000062E7  add [bx+si],al
  db 0x00, 0x00                ; 000062E9  add [bx+si],al
  db 0x00, 0x00                ; 000062EB  add [bx+si],al
  db 0x00, 0x00                ; 000062ED  add [bx+si],al
  db 0x00, 0x00                ; 000062EF  add [bx+si],al
  db 0x00, 0x00                ; 000062F1  add [bx+si],al
  db 0x00, 0x00                ; 000062F3  add [bx+si],al
  db 0x00, 0x00                ; 000062F5  add [bx+si],al
  db 0x00, 0x00                ; 000062F7  add [bx+si],al
  db 0x00, 0x00                ; 000062F9  add [bx+si],al
  db 0x84, 0x00                ; 000062FB  test [bx+si],al
  db 0x88, 0x00                ; 000062FD  mov [bx+si],al
  db 0x85, 0x00                ; 000062FF  test [bx+si],ax
  db 0x88, 0x00                ; 00006301  mov [bx+si],al
  db 0x00, 0x00                ; 00006303  add [bx+si],al
  db 0x00, 0x00                ; 00006305  add [bx+si],al
  db 0x00, 0x00                ; 00006307  add [bx+si],al
  db 0x00, 0x00                ; 00006309  add [bx+si],al
  db 0x00, 0x00                ; 0000630B  add [bx+si],al
  db 0x00, 0x00                ; 0000630D  add [bx+si],al
  db 0x00, 0x00                ; 0000630F  add [bx+si],al
  db 0x00, 0x00                ; 00006311  add [bx+si],al
  db 0x00, 0x00                ; 00006313  add [bx+si],al
  db 0x00, 0x00                ; 00006315  add [bx+si],al
  db 0x00, 0x00                ; 00006317  add [bx+si],al
  db 0x00, 0x00                ; 00006319  add [bx+si],al
  db 0x00, 0x00                ; 0000631B  add [bx+si],al
  db 0x00, 0x00                ; 0000631D  add [bx+si],al
  db 0x00, 0x00                ; 0000631F  add [bx+si],al
  db 0x00, 0x00                ; 00006321  add [bx+si],al
  db 0x00, 0x00                ; 00006323  add [bx+si],al
  db 0x00, 0x00                ; 00006325  add [bx+si],al
  db 0x00, 0x00                ; 00006327  add [bx+si],al
  db 0x00, 0x00                ; 00006329  add [bx+si],al
  db 0x00, 0x00                ; 0000632B  add [bx+si],al
  db 0x00, 0x00                ; 0000632D  add [bx+si],al
  db 0x00, 0x00                ; 0000632F  add [bx+si],al
  db 0x00, 0x00                ; 00006331  add [bx+si],al
  db 0x00, 0x00                ; 00006333  add [bx+si],al
  db 0x00, 0x00                ; 00006335  add [bx+si],al
  db 0x00, 0x00                ; 00006337  add [bx+si],al
  db 0x00, 0x00                ; 00006339  add [bx+si],al
  db 0x00, 0x00                ; 0000633B  add [bx+si],al
  db 0x00, 0x00                ; 0000633D  add [bx+si],al
  db 0x00, 0x00                ; 0000633F  add [bx+si],al
  db 0x00, 0x00                ; 00006341  add [bx+si],al
  db 0x00, 0x00                ; 00006343  add [bx+si],al
  db 0x00, 0x00                ; 00006345  add [bx+si],al
  db 0x00, 0x00                ; 00006347  add [bx+si],al
  db 0x00, 0x00                ; 00006349  add [bx+si],al
  db 0x00, 0x00                ; 0000634B  add [bx+si],al
  db 0x00, 0x00                ; 0000634D  add [bx+si],al
  db 0x00, 0x00                ; 0000634F  add [bx+si],al
  db 0x00, 0x00                ; 00006351  add [bx+si],al
  db 0x00, 0x00                ; 00006353  add [bx+si],al
  db 0x00, 0x00                ; 00006355  add [bx+si],al
  db 0x00, 0x00                ; 00006357  add [bx+si],al
  db 0x00, 0x00                ; 00006359  add [bx+si],al
  db 0x00, 0x00                ; 0000635B  add [bx+si],al
  db 0x00, 0x00                ; 0000635D  add [bx+si],al
  db 0x00, 0x00                ; 0000635F  add [bx+si],al
  db 0x00, 0x00                ; 00006361  add [bx+si],al
  db 0x00, 0x00                ; 00006363  add [bx+si],al
  db 0x00, 0x00                ; 00006365  add [bx+si],al
  db 0x00, 0x00                ; 00006367  add [bx+si],al
  db 0x00, 0x00                ; 00006369  add [bx+si],al
  db 0x00, 0x00                ; 0000636B  add [bx+si],al
  db 0x00, 0x00                ; 0000636D  add [bx+si],al
  db 0x00, 0x00                ; 0000636F  add [bx+si],al
  db 0x00, 0x00                ; 00006371  add [bx+si],al
  db 0x00, 0x00                ; 00006373  add [bx+si],al
  db 0x00, 0x00                ; 00006375  add [bx+si],al
  db 0x00, 0x00                ; 00006377  add [bx+si],al
  db 0x00, 0x00                ; 00006379  add [bx+si],al
  db 0x00, 0x00                ; 0000637B  add [bx+si],al
  db 0x00, 0x00                ; 0000637D  add [bx+si],al
  db 0x00, 0x00                ; 0000637F  add [bx+si],al
  db 0x00, 0x00                ; 00006381  add [bx+si],al
  db 0x84, 0x00                ; 00006383  test [bx+si],al
  db 0x88, 0x00                ; 00006385  mov [bx+si],al
  db 0x85, 0x00                ; 00006387  test [bx+si],ax
  db 0x88, 0x00                ; 00006389  mov [bx+si],al
  db 0x8E, 0x00                ; 0000638B  mov es,[bx+si]
  db 0x00, 0x01                ; 0000638D  add [bx+di],al
  db 0x83, 0x09, 0x00          ; 0000638F  or word [bx+di],byte +0x0
  db 0x50                      ; 00006392  push ax
  db 0x87, 0x00                ; 00006393  xchg ax,[bx+si]
  db 0x88, 0x01                ; 00006395  mov [bx+di],al
  db 0x83, 0x00, 0x04          ; 00006397  add word [bx+si],byte +0x4
  db 0x50                      ; 0000639A  push ax
  db 0x8A, 0x00                ; 0000639B  mov al,[bx+si]
  db 0x00, 0x00                ; 0000639D  add [bx+si],al
  db 0x00, 0x00                ; 0000639F  add [bx+si],al
  db 0x00, 0x00                ; 000063A1  add [bx+si],al
  db 0x00, 0x00                ; 000063A3  add [bx+si],al
  db 0x00, 0x00                ; 000063A5  add [bx+si],al
  db 0x00, 0x00                ; 000063A7  add [bx+si],al
  db 0x00, 0x00                ; 000063A9  add [bx+si],al
  db 0x00, 0x00                ; 000063AB  add [bx+si],al
  db 0x00, 0x00                ; 000063AD  add [bx+si],al
  db 0x00, 0x00                ; 000063AF  add [bx+si],al
  db 0x00, 0x00                ; 000063B1  add [bx+si],al
  db 0x00, 0x00                ; 000063B3  add [bx+si],al
  db 0x00, 0x00                ; 000063B5  add [bx+si],al
  db 0x00, 0x00                ; 000063B7  add [bx+si],al
  db 0x00, 0x00                ; 000063B9  add [bx+si],al
  db 0x00, 0x00                ; 000063BB  add [bx+si],al
  db 0x00, 0x00                ; 000063BD  add [bx+si],al
  db 0x00, 0x00                ; 000063BF  add [bx+si],al
  db 0x00, 0x00                ; 000063C1  add [bx+si],al
  db 0x00, 0x00                ; 000063C3  add [bx+si],al
  db 0x00, 0x00                ; 000063C5  add [bx+si],al
  db 0x00, 0x00                ; 000063C7  add [bx+si],al
  db 0x00, 0x00                ; 000063C9  add [bx+si],al
  db 0x00, 0x00                ; 000063CB  add [bx+si],al
  db 0x00, 0x00                ; 000063CD  add [bx+si],al
  db 0x00, 0x00                ; 000063CF  add [bx+si],al
  db 0x00, 0x00                ; 000063D1  add [bx+si],al
  db 0x00, 0x00                ; 000063D3  add [bx+si],al
  db 0x00, 0x00                ; 000063D5  add [bx+si],al
  db 0x00, 0x00                ; 000063D7  add [bx+si],al
  db 0x00, 0x00                ; 000063D9  add [bx+si],al
  db 0x00, 0x00                ; 000063DB  add [bx+si],al
  db 0x00, 0x00                ; 000063DD  add [bx+si],al
  db 0x00, 0x00                ; 000063DF  add [bx+si],al
  db 0x00, 0x00                ; 000063E1  add [bx+si],al
  db 0x00, 0x00                ; 000063E3  add [bx+si],al
  db 0x00, 0x00                ; 000063E5  add [bx+si],al
  db 0x00, 0x00                ; 000063E7  add [bx+si],al
  db 0x00, 0x00                ; 000063E9  add [bx+si],al
  db 0x00, 0x00                ; 000063EB  add [bx+si],al
  db 0x00, 0x00                ; 000063ED  add [bx+si],al
  db 0x00, 0x00                ; 000063EF  add [bx+si],al
  db 0x00, 0x00                ; 000063F1  add [bx+si],al
  db 0x00, 0x00                ; 000063F3  add [bx+si],al
  db 0x00, 0x00                ; 000063F5  add [bx+si],al
  db 0x00, 0x00                ; 000063F7  add [bx+si],al
  db 0x00, 0x00                ; 000063F9  add [bx+si],al
  db 0x00, 0x00                ; 000063FB  add [bx+si],al
  db 0x00, 0x00                ; 000063FD  add [bx+si],al
  db 0x00, 0x00                ; 000063FF  add [bx+si],al
  db 0x00, 0x00                ; 00006401  add [bx+si],al
  db 0x00, 0x00                ; 00006403  add [bx+si],al
  db 0x00, 0x00                ; 00006405  add [bx+si],al
  db 0x00, 0x00                ; 00006407  add [bx+si],al
  db 0x00, 0x00                ; 00006409  add [bx+si],al
  db 0x00, 0x00                ; 0000640B  add [bx+si],al
  db 0x00, 0x00                ; 0000640D  add [bx+si],al
  db 0x00, 0x00                ; 0000640F  add [bx+si],al
  db 0x00, 0x00                ; 00006411  add [bx+si],al
  db 0x00, 0x00                ; 00006413  add [bx+si],al
  db 0x00, 0x00                ; 00006415  add [bx+si],al
  db 0x00, 0x00                ; 00006417  add [bx+si],al
  db 0x00, 0x00                ; 00006419  add [bx+si],al
  db 0x00, 0x00                ; 0000641B  add [bx+si],al
  db 0x00, 0x00                ; 0000641D  add [bx+si],al
  db 0x00, 0x00                ; 0000641F  add [bx+si],al
  db 0x00, 0x00                ; 00006421  add [bx+si],al
  db 0x00, 0x00                ; 00006423  add [bx+si],al
  db 0x00, 0x00                ; 00006425  add [bx+si],al
  db 0x00, 0x00                ; 00006427  add [bx+si],al
  db 0x00, 0x00                ; 00006429  add [bx+si],al
  db 0x00, 0x00                ; 0000642B  add [bx+si],al
  db 0x00, 0x00                ; 0000642D  add [bx+si],al
  db 0x00, 0x00                ; 0000642F  add [bx+si],al
  db 0x00, 0x00                ; 00006431  add [bx+si],al
  db 0x00, 0x00                ; 00006433  add [bx+si],al
  db 0x00, 0x00                ; 00006435  add [bx+si],al
  db 0x00, 0x00                ; 00006437  add [bx+si],al
  db 0x00, 0x00                ; 00006439  add [bx+si],al
  db 0x00, 0x00                ; 0000643B  add [bx+si],al
  db 0x00, 0x00                ; 0000643D  add [bx+si],al
  db 0x81, 0x52, 0x87, 0xFF, 0x0C ; 0000643F  adc word [bp+si-0x79],0xcff
  db 0x50                      ; 00006444  push ax
  db 0x8A, 0x20                ; 00006445  mov ah,[bx+si]
  db 0x08, 0x00                ; 00006447  or [bx+si],al
  db 0x81, 0x00, 0x00, 0xA0    ; 00006449  add word [bx+si],0xa000
  db 0x00, 0x40, 0x01          ; 0000644D  add [bx+si+0x1],al
  db 0xE0, 0x01                ; 00006450  loopne 0x6453
  db 0x80, 0x02, 0x20          ; 00006452  add byte [bp+si],0x20
  db 0x03, 0xC0                ; 00006455  add ax,ax
  db 0x03, 0x60, 0x04          ; 00006457  add sp,[bx+si+0x4]
  db 0x00, 0x05                ; 0000645A  add [di],al
  db 0xA0, 0x05, 0x40          ; 0000645C  mov al,[0x4005]
  db 0x06                      ; 0000645F  push es
  db 0xE0, 0x06                ; 00006460  loopne 0x6468
  db 0x80, 0x07, 0x20          ; 00006462  add byte [bx],0x20
  db 0x08, 0xC0                ; 00006465  or al,al
  db 0x08, 0x60, 0x09          ; 00006467  or [bx+si+0x9],ah
  db 0x00, 0x0A                ; 0000646A  add [bp+si],cl
  db 0xA0, 0x0A, 0x40          ; 0000646C  mov al,[0x400a]
  db 0x0B, 0xE0                ; 0000646F  or sp,ax
  db 0x0B, 0x80, 0x0C, 0x20    ; 00006471  or ax,[bx+si+0x200c]
  db 0x0D, 0xC0, 0x0D          ; 00006475  or ax,0xdc0
  db 0x60                      ; 00006478  pusha
  db 0x0E                      ; 00006479  push cs
  db 0x9E                      ; 0000647A  sahf
  db 0x6F                      ; 0000647B  outsw
  db 0x00, 0x00                ; 0000647C  add [bx+si],al
  db 0xF8                      ; 0000647E  clc
  db 0xFF, 0x00                ; 0000647F  inc word [bx+si]
  db 0x00, 0x00                ; 00006481  add [bx+si],al
  db 0x00, 0x00                ; 00006483  add [bx+si],al
  db 0x00, 0x00                ; 00006485  add [bx+si],al
  db 0x00, 0x00                ; 00006487  add [bx+si],al
  db 0x00, 0x00                ; 00006489  add [bx+si],al
  db 0x00, 0x00                ; 0000648B  add [bx+si],al
  db 0x00, 0x00                ; 0000648D  add [bx+si],al
  db 0x00, 0xCC                ; 0000648F  add ah,cl
  db 0xCC                      ; 00006491  int3
  db 0xCC                      ; 00006492  int3
  db 0xCC                      ; 00006493  int3
  db 0xCC                      ; 00006494  int3
  db 0xCC                      ; 00006495  int3
  db 0xCC                      ; 00006496  int3
  db 0xCC                      ; 00006497  int3
  db 0xCC                      ; 00006498  int3
  db 0xCC                      ; 00006499  int3
  db 0xCC                      ; 0000649A  int3
  db 0xCC                      ; 0000649B  int3
  db 0xCC                      ; 0000649C  int3
  db 0xCC                      ; 0000649D  int3
  db 0xCC                      ; 0000649E  int3
  db 0xCC                      ; 0000649F  int3
  db 0xCC                      ; 000064A0  int3
  db 0xCC                      ; 000064A1  int3
  db 0xCC                      ; 000064A2  int3
  db 0xCC                      ; 000064A3  int3
  db 0xCC                      ; 000064A4  int3
  db 0xCC                      ; 000064A5  int3
  db 0xCC                      ; 000064A6  int3
  db 0xCC                      ; 000064A7  int3
  db 0xCC                      ; 000064A8  int3
  db 0xCC                      ; 000064A9  int3
  db 0xCC                      ; 000064AA  int3
  db 0xCC                      ; 000064AB  int3
  db 0xCC                      ; 000064AC  int3
  db 0xCC                      ; 000064AD  int3
  db 0xCC                      ; 000064AE  int3
  db 0xCC                      ; 000064AF  int3
  db 0xCC                      ; 000064B0  int3
  db 0xCC                      ; 000064B1  int3
  db 0xCC                      ; 000064B2  int3
  db 0xCC                      ; 000064B3  int3
  db 0xCC                      ; 000064B4  int3
  db 0xCC                      ; 000064B5  int3
  db 0xCC                      ; 000064B6  int3
  db 0xCC                      ; 000064B7  int3
  db 0xCC                      ; 000064B8  int3
  db 0xCC                      ; 000064B9  int3
  db 0xCC                      ; 000064BA  int3
  db 0xCC                      ; 000064BB  int3
  db 0xCC                      ; 000064BC  int3
  db 0xCC                      ; 000064BD  int3
  db 0xCC                      ; 000064BE  int3
  db 0xCC                      ; 000064BF  int3
  db 0xCC                      ; 000064C0  int3
  db 0xCC                      ; 000064C1  int3
  db 0xCC                      ; 000064C2  int3
  db 0xCC                      ; 000064C3  int3
  db 0xCC                      ; 000064C4  int3
  db 0xCC                      ; 000064C5  int3
  db 0xCC                      ; 000064C6  int3
  db 0xCC                      ; 000064C7  int3
  db 0xCC                      ; 000064C8  int3
  db 0xCC                      ; 000064C9  int3
  db 0xCC                      ; 000064CA  int3
  db 0xCC                      ; 000064CB  int3
  db 0xCC                      ; 000064CC  int3
  db 0xCC                      ; 000064CD  int3
  db 0xCC                      ; 000064CE  int3
  db 0xCC                      ; 000064CF  int3
  db 0xCC                      ; 000064D0  int3
  db 0xCC                      ; 000064D1  int3
  db 0xCC                      ; 000064D2  int3
  db 0xCC                      ; 000064D3  int3
  db 0xCC                      ; 000064D4  int3
  db 0xCC                      ; 000064D5  int3
  db 0xCC                      ; 000064D6  int3
  db 0xCC                      ; 000064D7  int3
  db 0xCC                      ; 000064D8  int3
  db 0xCC                      ; 000064D9  int3
  db 0xCC                      ; 000064DA  int3
  db 0xCC                      ; 000064DB  int3
  db 0xCC                      ; 000064DC  int3
  db 0xCC                      ; 000064DD  int3
  db 0xCC                      ; 000064DE  int3
  db 0xCC                      ; 000064DF  int3
  db 0xCC                      ; 000064E0  int3
  db 0xCC                      ; 000064E1  int3
  db 0xCC                      ; 000064E2  int3
  db 0xCC                      ; 000064E3  int3
  db 0xCC                      ; 000064E4  int3
  db 0xCC                      ; 000064E5  int3
  db 0xCC                      ; 000064E6  int3
  db 0xCC                      ; 000064E7  int3
  db 0xCC                      ; 000064E8  int3
  db 0xCC                      ; 000064E9  int3
  db 0xCC                      ; 000064EA  int3
  db 0xCC                      ; 000064EB  int3
  db 0xCC                      ; 000064EC  int3
  db 0xCC                      ; 000064ED  int3
  db 0xCC                      ; 000064EE  int3
  db 0xCC                      ; 000064EF  int3
  db 0xCC                      ; 000064F0  int3
  db 0xCC                      ; 000064F1  int3
  db 0xCC                      ; 000064F2  int3
  db 0xCC                      ; 000064F3  int3
  db 0xCC                      ; 000064F4  int3
  db 0xCC                      ; 000064F5  int3
  db 0xCC                      ; 000064F6  int3
  db 0xCC                      ; 000064F7  int3
  db 0xCC                      ; 000064F8  int3
  db 0xCC                      ; 000064F9  int3
  db 0xCC                      ; 000064FA  int3
  db 0xCC                      ; 000064FB  int3
  db 0xCC                      ; 000064FC  int3
  db 0xCC                      ; 000064FD  int3
  db 0xCC                      ; 000064FE  int3
  db 0xCC                      ; 000064FF  int3
  db 0xCC                      ; 00006500  int3
  db 0xCC                      ; 00006501  int3
  db 0xCC                      ; 00006502  int3
  db 0xCC                      ; 00006503  int3
  db 0xCC                      ; 00006504  int3
  db 0xCC                      ; 00006505  int3
  db 0xCC                      ; 00006506  int3
  db 0xCC                      ; 00006507  int3
  db 0xCC                      ; 00006508  int3
  db 0xCC                      ; 00006509  int3
  db 0xCC                      ; 0000650A  int3
  db 0xCC                      ; 0000650B  int3
  db 0xCC                      ; 0000650C  int3
  db 0xCC                      ; 0000650D  int3
  db 0xCC                      ; 0000650E  int3
  db 0xCC                      ; 0000650F  int3
  db 0xCC                      ; 00006510  int3
  db 0xCC                      ; 00006511  int3
  db 0xCC                      ; 00006512  int3
  db 0xCC                      ; 00006513  int3
  db 0xCC                      ; 00006514  int3
  db 0xCC                      ; 00006515  int3
  db 0xCC                      ; 00006516  int3
  db 0xCC                      ; 00006517  int3
  db 0xCC                      ; 00006518  int3
  db 0xCC                      ; 00006519  int3
  db 0xCC                      ; 0000651A  int3
  db 0xCC                      ; 0000651B  int3
  db 0xCC                      ; 0000651C  int3
  db 0xCC                      ; 0000651D  int3
  db 0xCC                      ; 0000651E  int3
  db 0xCC                      ; 0000651F  int3
  db 0xCC                      ; 00006520  int3
  db 0xCC                      ; 00006521  int3
  db 0xCC                      ; 00006522  int3
  db 0xCC                      ; 00006523  int3
  db 0xCC                      ; 00006524  int3
  db 0xCC                      ; 00006525  int3
  db 0xCC                      ; 00006526  int3
  db 0xCC                      ; 00006527  int3
  db 0xCC                      ; 00006528  int3
  db 0xCC                      ; 00006529  int3
  db 0xCC                      ; 0000652A  int3
  db 0xCC                      ; 0000652B  int3
  db 0xCC                      ; 0000652C  int3
  db 0xCC                      ; 0000652D  int3
  db 0xCC                      ; 0000652E  int3
  db 0xCC                      ; 0000652F  int3
  db 0xCC                      ; 00006530  int3
  db 0xCC                      ; 00006531  int3
  db 0xCC                      ; 00006532  int3
  db 0xCC                      ; 00006533  int3
  db 0xCC                      ; 00006534  int3
  db 0xCC                      ; 00006535  int3
  db 0xCC                      ; 00006536  int3
  db 0xCC                      ; 00006537  int3
  db 0xCC                      ; 00006538  int3
  db 0xCC                      ; 00006539  int3
  db 0xCC                      ; 0000653A  int3
  db 0xCC                      ; 0000653B  int3
  db 0xCC                      ; 0000653C  int3
  db 0xCC                      ; 0000653D  int3
  db 0xCC                      ; 0000653E  int3
  db 0xCC                      ; 0000653F  int3
  db 0xCC                      ; 00006540  int3
  db 0xCC                      ; 00006541  int3
  db 0xCC                      ; 00006542  int3
  db 0xCC                      ; 00006543  int3
  db 0xCC                      ; 00006544  int3
  db 0xCC                      ; 00006545  int3
  db 0xCC                      ; 00006546  int3
  db 0xCC                      ; 00006547  int3
  db 0xCC                      ; 00006548  int3
  db 0xCC                      ; 00006549  int3
  db 0xCC                      ; 0000654A  int3
  db 0xCC                      ; 0000654B  int3
  db 0xCC                      ; 0000654C  int3
  db 0xCC                      ; 0000654D  int3
  db 0xCC                      ; 0000654E  int3
  db 0xCC                      ; 0000654F  int3
  db 0xCC                      ; 00006550  int3
  db 0xCC                      ; 00006551  int3
  db 0xCC                      ; 00006552  int3
  db 0xCC                      ; 00006553  int3
  db 0xCC                      ; 00006554  int3
  db 0xCC                      ; 00006555  int3
  db 0xCC                      ; 00006556  int3
  db 0xCC                      ; 00006557  int3
  db 0xCC                      ; 00006558  int3
  db 0xCC                      ; 00006559  int3
  db 0xCC                      ; 0000655A  int3
  db 0xCC                      ; 0000655B  int3
  db 0xCC                      ; 0000655C  int3
  db 0xCC                      ; 0000655D  int3
  db 0xCC                      ; 0000655E  int3
  db 0xCC                      ; 0000655F  int3
  db 0xCC                      ; 00006560  int3
  db 0xCC                      ; 00006561  int3
  db 0xCC                      ; 00006562  int3
  db 0xCC                      ; 00006563  int3
  db 0xCC                      ; 00006564  int3
  db 0xCC                      ; 00006565  int3
  db 0xCC                      ; 00006566  int3
  db 0xCC                      ; 00006567  int3
  db 0xCC                      ; 00006568  int3
  db 0xCC                      ; 00006569  int3
  db 0xCC                      ; 0000656A  int3
  db 0xCC                      ; 0000656B  int3
  db 0xCC                      ; 0000656C  int3
  db 0xCC                      ; 0000656D  int3
  db 0xCC                      ; 0000656E  int3
  db 0xCC                      ; 0000656F  int3
  db 0xCC                      ; 00006570  int3
  db 0xCC                      ; 00006571  int3
  db 0xCC                      ; 00006572  int3
  db 0xCC                      ; 00006573  int3
  db 0xCC                      ; 00006574  int3
  db 0xCC                      ; 00006575  int3
  db 0xCC                      ; 00006576  int3
  db 0xCC                      ; 00006577  int3
  db 0xCC                      ; 00006578  int3
  db 0xCC                      ; 00006579  int3
  db 0xCC                      ; 0000657A  int3
  db 0xCC                      ; 0000657B  int3
  db 0xCC                      ; 0000657C  int3
  db 0xCC                      ; 0000657D  int3
  db 0xCC                      ; 0000657E  int3
  db 0xCC                      ; 0000657F  int3
  db 0xCC                      ; 00006580  int3
  db 0xCC                      ; 00006581  int3
  db 0xCC                      ; 00006582  int3
  db 0xCC                      ; 00006583  int3
  db 0xCC                      ; 00006584  int3
  db 0xCC                      ; 00006585  int3
  db 0xCC                      ; 00006586  int3
  db 0xCC                      ; 00006587  int3
  db 0xCC                      ; 00006588  int3
  db 0xCC                      ; 00006589  int3
  db 0xCC                      ; 0000658A  int3
  db 0xCC                      ; 0000658B  int3
  db 0xCC                      ; 0000658C  int3
  db 0xCC                      ; 0000658D  int3
  db 0xCC                      ; 0000658E  int3
  db 0xCC                      ; 0000658F  int3
  db 0x00, 0x00                ; 00006590  add [bx+si],al
  db 0x00, 0x00                ; 00006592  add [bx+si],al
  db 0x00, 0x00                ; 00006594  add [bx+si],al
  db 0x00, 0x00                ; 00006596  add [bx+si],al
  db 0x00, 0x00                ; 00006598  add [bx+si],al
  db 0x00, 0x00                ; 0000659A  add [bx+si],al
  db 0x00, 0x00                ; 0000659C  add [bx+si],al
  db 0x00, 0x00                ; 0000659E  add [bx+si],al
  db 0x00, 0x00                ; 000065A0  add [bx+si],al
  db 0x00, 0x00                ; 000065A2  add [bx+si],al
  db 0x00, 0x00                ; 000065A4  add [bx+si],al
  db 0x00, 0x00                ; 000065A6  add [bx+si],al
  db 0x00, 0x00                ; 000065A8  add [bx+si],al
  db 0x00, 0x00                ; 000065AA  add [bx+si],al
  db 0x00, 0x00                ; 000065AC  add [bx+si],al
  db 0x00, 0x00                ; 000065AE  add [bx+si],al
  db 0x00, 0x00                ; 000065B0  add [bx+si],al
  db 0x00, 0x00                ; 000065B2  add [bx+si],al
  db 0x00, 0x00                ; 000065B4  add [bx+si],al
  db 0x00, 0x00                ; 000065B6  add [bx+si],al
  db 0x00, 0x00                ; 000065B8  add [bx+si],al
  db 0x00, 0x00                ; 000065BA  add [bx+si],al
  db 0x00, 0x00                ; 000065BC  add [bx+si],al
  db 0x00, 0x00                ; 000065BE  add [bx+si],al
  db 0x00, 0x00                ; 000065C0  add [bx+si],al
  db 0x00, 0x00                ; 000065C2  add [bx+si],al
  db 0x00, 0x00                ; 000065C4  add [bx+si],al
  db 0x00, 0x00                ; 000065C6  add [bx+si],al
  db 0x00, 0x00                ; 000065C8  add [bx+si],al
  db 0x00, 0x00                ; 000065CA  add [bx+si],al
  db 0x00, 0x00                ; 000065CC  add [bx+si],al
  db 0x00, 0x00                ; 000065CE  add [bx+si],al
  db 0x00, 0x00                ; 000065D0  add [bx+si],al
  db 0x00, 0x00                ; 000065D2  add [bx+si],al
  db 0x00, 0x00                ; 000065D4  add [bx+si],al
  db 0x00, 0x00                ; 000065D6  add [bx+si],al
  db 0x00, 0x00                ; 000065D8  add [bx+si],al
  db 0x00, 0x00                ; 000065DA  add [bx+si],al
  db 0x00, 0x00                ; 000065DC  add [bx+si],al
  db 0x00, 0x00                ; 000065DE  add [bx+si],al
  db 0x00, 0x00                ; 000065E0  add [bx+si],al
  db 0x00, 0x00                ; 000065E2  add [bx+si],al
  db 0x00, 0x00                ; 000065E4  add [bx+si],al
  db 0x00, 0x00                ; 000065E6  add [bx+si],al
  db 0x00, 0x00                ; 000065E8  add [bx+si],al
  db 0x00, 0x00                ; 000065EA  add [bx+si],al
  db 0x00, 0x00                ; 000065EC  add [bx+si],al
  db 0x00, 0x00                ; 000065EE  add [bx+si],al
  db 0x00, 0x00                ; 000065F0  add [bx+si],al
  db 0x00, 0x00                ; 000065F2  add [bx+si],al
  db 0x00, 0x00                ; 000065F4  add [bx+si],al
  db 0x00, 0x00                ; 000065F6  add [bx+si],al
  db 0x00, 0x00                ; 000065F8  add [bx+si],al
  db 0x00, 0x00                ; 000065FA  add [bx+si],al
  db 0x00, 0x00                ; 000065FC  add [bx+si],al
  db 0x00, 0x00                ; 000065FE  add [bx+si],al
  db 0x11, 0x6B, 0x04          ; 00006600  adc [bp+di+0x4],bp
  db 0x04, 0x11                ; 00006603  add al,0x11
  db 0x6B, 0x04, 0x08          ; 00006605  imul ax,[si],byte +0x8
  db 0x00, 0x00                ; 00006608  add [bx+si],al
  db 0x00, 0x00                ; 0000660A  add [bx+si],al
  db 0x00, 0x00                ; 0000660C  add [bx+si],al
  db 0x00, 0x00                ; 0000660E  add [bx+si],al
  db 0x00, 0x00                ; 00006610  add [bx+si],al
  db 0x00, 0x00                ; 00006612  add [bx+si],al
  db 0x00, 0x00                ; 00006614  add [bx+si],al
  db 0x00, 0x00                ; 00006616  add [bx+si],al
  db 0x00, 0x00                ; 00006618  add [bx+si],al
  db 0x00, 0x00                ; 0000661A  add [bx+si],al
  db 0x00, 0x00                ; 0000661C  add [bx+si],al
  db 0x00, 0x00                ; 0000661E  add [bx+si],al
  db 0x00, 0x00                ; 00006620  add [bx+si],al
  db 0x00, 0x00                ; 00006622  add [bx+si],al
  db 0x00, 0x00                ; 00006624  add [bx+si],al
  db 0x00, 0x00                ; 00006626  add [bx+si],al
  db 0x00, 0x00                ; 00006628  add [bx+si],al
  db 0x00, 0x00                ; 0000662A  add [bx+si],al
  db 0x00, 0x00                ; 0000662C  add [bx+si],al
  db 0x00, 0x00                ; 0000662E  add [bx+si],al
  db 0x00, 0x00                ; 00006630  add [bx+si],al
  db 0x00, 0x00                ; 00006632  add [bx+si],al
  db 0x00, 0x00                ; 00006634  add [bx+si],al
  db 0x00, 0x00                ; 00006636  add [bx+si],al
  db 0x00, 0x00                ; 00006638  add [bx+si],al
  db 0x00, 0x00                ; 0000663A  add [bx+si],al
  db 0x00, 0x00                ; 0000663C  add [bx+si],al
  db 0x00, 0x00                ; 0000663E  add [bx+si],al
  db 0x00, 0x00                ; 00006640  add [bx+si],al
  db 0x00, 0x00                ; 00006642  add [bx+si],al
  db 0x00, 0x00                ; 00006644  add [bx+si],al
  db 0x00, 0x00                ; 00006646  add [bx+si],al
  db 0x00, 0x00                ; 00006648  add [bx+si],al
  db 0x00, 0x00                ; 0000664A  add [bx+si],al
  db 0x00, 0x00                ; 0000664C  add [bx+si],al
  db 0x00, 0x00                ; 0000664E  add [bx+si],al
  db 0x00, 0x00                ; 00006650  add [bx+si],al
  db 0x00, 0x00                ; 00006652  add [bx+si],al
  db 0x00, 0x00                ; 00006654  add [bx+si],al
  db 0x00, 0x00                ; 00006656  add [bx+si],al
  db 0x00, 0x00                ; 00006658  add [bx+si],al
  db 0x00, 0x00                ; 0000665A  add [bx+si],al
  db 0x00, 0x00                ; 0000665C  add [bx+si],al
  db 0x00, 0x00                ; 0000665E  add [bx+si],al
  db 0x00, 0x00                ; 00006660  add [bx+si],al
  db 0x00, 0x00                ; 00006662  add [bx+si],al
  db 0x00, 0x00                ; 00006664  add [bx+si],al
  db 0x00, 0x00                ; 00006666  add [bx+si],al
  db 0x00, 0x00                ; 00006668  add [bx+si],al
  db 0x00, 0x00                ; 0000666A  add [bx+si],al
  db 0x00, 0x00                ; 0000666C  add [bx+si],al
  db 0x00, 0x00                ; 0000666E  add [bx+si],al
  db 0x00, 0x00                ; 00006670  add [bx+si],al
  db 0x00, 0x00                ; 00006672  add [bx+si],al
  db 0x00, 0x00                ; 00006674  add [bx+si],al
  db 0x00, 0x00                ; 00006676  add [bx+si],al
  db 0x00, 0x00                ; 00006678  add [bx+si],al
  db 0x00, 0x00                ; 0000667A  add [bx+si],al
  db 0x00, 0x00                ; 0000667C  add [bx+si],al
  db 0x00, 0x00                ; 0000667E  add [bx+si],al

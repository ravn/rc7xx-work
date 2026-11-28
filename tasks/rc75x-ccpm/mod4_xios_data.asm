  cmp ah, [bp + di + 0x22]                     ; 0CED0  0x3A, 0x63, 0x22
  adc ax, 0x1fe                                ; 0CED3  0x15, 0xFE, 0x01
  db 0x00, 0x00                                ; 0CED6
  db 0x00, 0x00                                ; 0CED8
  inc sp                                       ; 0CEDA  0x44
  db 0x63, 0x20                                ; 0CEDB  arpl word [bx + si], sp
  pop ss                                       ; 0CEDD  0x17
  adc [si], al                                 ; 0CEDE  0x10, 0x04
  db 0x00, 0x00                                ; 0CEE0
  db 0x00, 0x00                                ; 0CEE2
  dec si                                       ; 0CEE4  0x4E
  db 0x63, 0x30                                ; 0CEE5  arpl word [bx + si], si
  sbb ax, [bx + si]                            ; 0CEE7  0x1B, 0x00
  db 0x02, 0x00                                ; 0CEE9  add al, byte [bx + si]
  db 0x00, 0x00                                ; 0CEEB
  add [bx + si + 0x63], bl                     ; 0CEED  0x00, 0x58, 0x63
  xor [di], bl                                 ; 0CEF0  0x30, 0x1D
  add [bp + si], al                            ; 0CEF2  0x00, 0x02
  db 0x00, 0x00                                ; 0CEF4
  db 0x00, 0x00                                ; 0CEF6
  db 0x62, 0x63, 0x30                          ; 0CEF8  bound sp, dword [bp + di + 0x30]
  pop ds                                       ; 0CEFB  0x1F
  add [bp + si], al                            ; 0CEFC  0x00, 0x02
  db 0x00, 0x00                                ; 0CEFE
  db 0x00, 0x00                                ; 0CF00
  db 0x6C                                      ; 0CF02  insb
  db 0x63, 0x30                                ; 0CF03  arpl word [bx + si], si
  and [bx + si], ax                            ; 0CF05  0x21, 0x00
  add [bx + si], ax                            ; 0CF07  0x01, 0x00
  db 0x00, 0x00                                ; 0CF09
  add [bp + 0x63], dh                          ; 0CF0B  0x00, 0x76, 0x63
  xor [bp + si], ah                            ; 0CF0E  0x30, 0x22
  add [bp + si], al                            ; 0CF10  0x00, 0x02
  db 0x00, 0x00                                ; 0CF12
  db 0x00, 0x00                                ; 0CF14
  and byte [bp + di + 0x30], 0x24              ; 0CF16  0x80, 0x63, 0x30, 0x24
  add [bp + si], al                            ; 0CF1A  0x00, 0x02
  db 0x00, 0x00                                ; 0CF1C
  db 0x00, 0x00                                ; 0CF1E
  mov ah, [bp + di + 0x30]                     ; 0CF20  0x8A, 0x63, 0x30
  add [es:bp + si], al                         ; 0CF23  0x26, 0x00, 0x02
  db 0x00, 0x00                                ; 0CF26
  db 0x00, 0x00                                ; 0CF28
  xchg sp, ax                                  ; 0CF2A  0x94
  db 0x63, 0x30                                ; 0CF2B  arpl word [bx + si], si
  sub [bx + si], al                            ; 0CF2D  0x28, 0x00
  add [bx + si], ax                            ; 0CF2F  0x01, 0x00
  db 0x00, 0x00                                ; 0CF31
  add [bp + 0x3063], bl                        ; 0CF33  0x00, 0x9E, 0x63, 0x30
  sub [bx + si], ax                            ; 0CF37  0x29, 0x00
  db 0x02, 0x00                                ; 0CF39  add al, byte [bx + si]
  db 0x00, 0x00                                ; 0CF3B
  add [bx + si + 0x3063], ch                   ; 0CF3D  0x00, 0xA8, 0x63, 0x30
  sub ax, [bx + si]                            ; 0CF41  0x2B, 0x00
  db 0x02, 0x00                                ; 0CF43  add al, byte [bx + si]
  db 0x00, 0x00                                ; 0CF45
  add [bp + si + 0x3063], dh                   ; 0CF47  0x00, 0xB2, 0x63, 0x30
  sub ax, 0x200                                ; 0CF4B  0x2D, 0x00, 0x02
  db 0x00, 0x00                                ; 0CF4E
  db 0x00, 0x00                                ; 0CF50
  mov sp, 0x3063                               ; 0CF52  0xBC, 0x63, 0x30
  db 0x2F                                      ; 0CF55  das
  add [bp + si], al                            ; 0CF56  0x00, 0x02
  db 0x00, 0x00                                ; 0CF58
  db 0x00, 0x00                                ; 0CF5A
  db 0xC6                                      ; 0CF5C  .
  db 0x63, 0x30                                ; 0CF5D  arpl word [bx + si], si
  xor [bx + si], ax                            ; 0CF5F  0x31, 0x00
  db 0x02, 0x00                                ; 0CF61  add al, byte [bx + si]
  db 0x00, 0x00                                ; 0CF63
  add al, dl                                   ; 0CF65  0x00, 0xD0
  db 0x63, 0x30                                ; 0CF67  arpl word [bx + si], si
  xor ax, [bx + si]                            ; 0CF69  0x33, 0x00
  db 0x02, 0x00                                ; 0CF6B  add al, byte [bx + si]
  db 0x00, 0x00                                ; 0CF6D
  add dl, bl                                   ; 0CF6F  0x00, 0xDA
  db 0x63, 0x30                                ; 0CF71  arpl word [bx + si], si
  xor ax, 0x200                                ; 0CF73  0x35, 0x00, 0x02
  db 0x00, 0x00                                ; 0CF76
  db 0x00, 0x00                                ; 0CF78
  in al, 0x63                                  ; 0CF7A  0xE4, 0x63
  xor [bx], dh                                 ; 0CF7C  0x30, 0x37
  add [bp + si], al                            ; 0CF7E  0x00, 0x02
  db 0x00, 0x00                                ; 0CF80
  db 0x00, 0x00                                ; 0CF82
  out dx, al                                   ; 0CF84  0xEE
  db 0x63, 0x30                                ; 0CF85  arpl word [bx + si], si
  cmp [bx + si], ax                            ; 0CF87  0x39, 0x00
  db 0x02, 0x00                                ; 0CF89  add al, byte [bx + si]
  db 0x00, 0x00                                ; 0CF8B
  add al, bh                                   ; 0CF8D  0x00, 0xF8
  db 0x63, 0x30                                ; 0CF8F  arpl word [bx + si], si
  cmp ax, [bx + si]                            ; 0CF91  0x3B, 0x00
  db 0x02, 0x00                                ; 0CF93  add al, byte [bx + si]
  db 0x00, 0x00                                ; 0CF95
  add [bp + si], al                            ; 0CF97  0x00, 0x02
  xor [fs:di], bh                              ; 0CF99  0x64, 0x30, 0x3D
  add [bp + si], al                            ; 0CF9C  0x00, 0x02
  db 0x00, 0x00                                ; 0CF9E
  db 0x00, 0x00                                ; 0CFA0
  or al, 0x64                                  ; 0CFA2  0x0C, 0x64
  xor [bx], bh                                 ; 0CFA4  0x30, 0x3F
  add [si], al                                 ; 0CFA6  0x00, 0x04
  db 0x00, 0x00                                ; 0CFA8
  db 0x00, 0x00                                ; 0CFAA
  push ss                                      ; 0CFAC  0x16
  db 0x64, 0x30, 0x43, 0x00                    ; 0CFAD  xor byte [fs:bp + di], al
  add al, 0                                    ; 0CFB1  0x04, 0x00
  db 0x00, 0x00                                ; 0CFB3
  add [bx + si], ah                            ; 0CFB5  0x00, 0x20
  db 0x64, 0x30, 0x47, 0x00                    ; 0CFB7  xor byte [fs:bx], al
  add al, 0                                    ; 0CFBB  0x04, 0x00
  db 0x00, 0x00                                ; 0CFBD
  add [bp + si], ch                            ; 0CFBF  0x00, 0x2A
  db 0x64, 0x30, 0x4B, 0x00                    ; 0CFC1  xor byte [fs:bp + di], cl
  add al, 0                                    ; 0CFC5  0x04, 0x00
  db 0x00, 0x00                                ; 0CFC7
  add [si], dh                                 ; 0CFC9  0x00, 0x34
  db 0x64, 0x30, 0x4F, 0x00                    ; 0CFCB  xor byte [fs:bx], cl
  add al, 0                                    ; 0CFCF  0x04, 0x00
  db 0x00, 0x00                                ; 0CFD1
  add [0x3064], bh                             ; 0CFD3  0x00, 0x3E, 0x64, 0x30
  push bx                                      ; 0CFD7  0x53
  add [si], al                                 ; 0CFD8  0x00, 0x04
  db 0x00, 0x00                                ; 0CFDA
  db 0x00, 0x00                                ; 0CFDC
  dec ax                                       ; 0CFDE  0x48
  db 0x64, 0x30, 0x57, 0x00                    ; 0CFDF  xor byte [fs:bx], dl
  add al, 0                                    ; 0CFE3  0x04, 0x00
  db 0x00, 0x00                                ; 0CFE5
  add [bp + si + 0x64], dl                     ; 0CFE7  0x00, 0x52, 0x64
  db 0x30, 0x5B, 0x00                          ; 0CFEA  xor byte [bp + di], bl
  add al, 0                                    ; 0CFED  0x04, 0x00
  db 0x00, 0x00                                ; 0CFEF
  add [si + 0x64], bl                          ; 0CFF1  0x00, 0x5C, 0x64
  db 0x30, 0x5F, 0x00                          ; 0CFF4  xor byte [bx], bl
  add al, 0                                    ; 0CFF7  0x04, 0x00
  db 0x00, 0x00                                ; 0CFF9
  add [bp + 0x64], ah                          ; 0CFFB  0x00, 0x66, 0x64
  db 0x30, 0x63, 0x00                          ; 0CFFE  xor byte [bp + di], ah
  add al, 0                                    ; 0D001  0x04, 0x00
  db 0x00, 0x00                                ; 0D003
  add [bx + si + 0x64], dh                     ; 0D005  0x00, 0x70, 0x64
  db 0x30, 0x67, 0x00                          ; 0D008  xor byte [bx], ah
  add al, 0                                    ; 0D00B  0x04, 0x00
  db 0x00, 0x00                                ; 0D00D
  add [bp + si + 0x64], bh                     ; 0D00F  0x00, 0x7A, 0x64
  db 0x30, 0x6B, 0x00                          ; 0D012  xor byte [bp + di], ch
  add al, 0                                    ; 0D015  0x04, 0x00
  db 0x00, 0x00                                ; 0D017
  add [si + 0x3064], al                        ; 0D019  0x00, 0x84, 0x64, 0x30
  db 0x6F                                      ; 0D01D  outsw
  add [si], al                                 ; 0D01E  0x00, 0x04
  db 0x00, 0x00                                ; 0D020
  db 0x00, 0x00                                ; 0D022
  mov fs, word [si + 0x30]                     ; 0D024  0x8E, 0x64, 0x30
  jae loc_0D029                                ; 0D027  0x73, 0x00

loc_0D029:                                     ; 0D029
  add al, 0                                    ; 0D029  0x04, 0x00
  db 0x00, 0x00                                ; 0D02B
  add [bx + si + 0x3064], bl                   ; 0D02D  0x00, 0x98, 0x64, 0x30
  ja loc_0D033                                 ; 0D031  0x77, 0x00

loc_0D033:                                     ; 0D033
  add al, 0                                    ; 0D033  0x04, 0x00
  db 0x00, 0x00                                ; 0D035
  add [bp + si + 0x3064], ah                   ; 0D037  0x00, 0xA2, 0x64, 0x30
  jnp loc_0D03D                                ; 0D03B  0x7B, 0x00

loc_0D03D:                                     ; 0D03D
  add al, 0                                    ; 0D03D  0x04, 0x00
  db 0x00, 0x00                                ; 0D03F
  add [si + 0x3064], ch                        ; 0D041  0x00, 0xAC, 0x64, 0x30
  jg loc_0D047                                 ; 0D045  0x7F, 0x00

loc_0D047:                                     ; 0D047
  adc [bx + si], al                            ; 0D047  0x10, 0x00
  db 0x00, 0x00                                ; 0D049
  add [bp + 0x3064], dh                        ; 0D04B  0x00, 0xB6, 0x64, 0x30
  pop word [bx + si]                           ; 0D04F  0x8F, 0x00
  adc [bx + si], al                            ; 0D051  0x10, 0x00
  db 0x00, 0x00                                ; 0D053
  add al, al                                   ; 0D055  0x00, 0xC0
  xor [fs:bx + 0x1000], bl                     ; 0D057  0x64, 0x30, 0x9F, 0x00, 0x10
  db 0x00, 0x00                                ; 0D05C
  db 0x00, 0x00                                ; 0D05E
  retf 0x3064                                  ; 0D060  0xCA, 0x64, 0x30
  scasw                                        ; 0D063  0xAF
  add [bx + si], dl                            ; 0D064  0x00, 0x10
  db 0x00, 0x00                                ; 0D066
  db 0x00, 0x00                                ; 0D068
  db 0x00, 0x00                                ; 0D06A
  xor [bx + 0x1000], bh                        ; 0D06C  0x30, 0xBF, 0x00, 0x10
  db 0x00, 0x00                                ; 0D070
  db 0x00, 0x00                                ; 0D072
  db 0x00, 0x00                                ; 0D074
  db 0x00, 0x00                                ; 0D076
  db 0x00, 0x00                                ; 0D078
  db 0x00, 0x00                                ; 0D07A
  db 0x00, 0x00                                ; 0D07C
  db 0xD4, 0x64                                ; 0D07E  aam 0x64
  db 0x00, 0x00                                ; 0D080
  db 0x00, 0x00                                ; 0D082
  db 0x00, 0x00                                ; 0D084
  db 0x00, 0x00                                ; 0D086
  db 0xDE, 0x64, 0x00                          ; 0D088  fisub word [si]
  db 0x00, 0x00                                ; 0D08B
  db 0x00, 0x00                                ; 0D08D
  db 0x00, 0x00                                ; 0D08F
  add al, ch                                   ; 0D091  0x00, 0xE8
  add [fs:bx + si], al                         ; 0D093  0x64, 0x00, 0x00
  db 0x00, 0x00                                ; 0D096
  db 0x00, 0x00                                ; 0D098
  db 0x00, 0x00                                ; 0D09A
  db 0xF2, 0x64, 0x00, 0x00                    ; 0D09C  add byte [fs:bx + si], al
  db 0x00, 0x00                                ; 0D0A0
  db 0x00, 0x00                                ; 0D0A2
  db 0x00, 0x00                                ; 0D0A4
  cld                                          ; 0D0A6  0xFC
  add [fs:bx + si], al                         ; 0D0A7  0x64, 0x00, 0x00
  db 0x00, 0x00                                ; 0D0AA
  db 0x00, 0x00                                ; 0D0AC
  db 0x00, 0x00                                ; 0D0AE
  push es                                      ; 0D0B0  0x06
  add [gs:bx + si], al                         ; 0D0B1  0x65, 0x00, 0x00
  db 0x00, 0x00                                ; 0D0B4
  db 0x00, 0x00                                ; 0D0B6
  db 0x00, 0x00                                ; 0D0B8
  db 0x10, 0x65, 0x00                          ; 0D0BA  adc byte [di], ah
  db 0x00, 0x00                                ; 0D0BD
  db 0x00, 0x00                                ; 0D0BF
  db 0x00, 0x00                                ; 0D0C1
  add [bp + si], bl                            ; 0D0C3  0x00, 0x1A
  add [gs:bx + si], al                         ; 0D0C5  0x65, 0x00, 0x00
  db 0x00, 0x00                                ; 0D0C8
  db 0x00, 0x00                                ; 0D0CA
  db 0x00, 0x00                                ; 0D0CC
  and al, 0x65                                 ; 0D0CE  0x24, 0x65
  db 0x00, 0x00                                ; 0D0D0
  db 0x00, 0x00                                ; 0D0D2
  db 0x00, 0x00                                ; 0D0D4
  db 0x00, 0x00                                ; 0D0D6
  db 0x2E, 0x65, 0x00, 0x00                    ; 0D0D8  add byte [gs:bx + si], al
  db 0x00, 0x00                                ; 0D0DC
  db 0x00, 0x00                                ; 0D0DE
  db 0x00, 0x00                                ; 0D0E0
  db 0x38, 0x65, 0x00                          ; 0D0E2  cmp byte [di], ah
  db 0x00, 0x00                                ; 0D0E5
  db 0x00, 0x00                                ; 0D0E7
  db 0x00, 0x00                                ; 0D0E9
  add [bp + si + 0x65], al                     ; 0D0EB  0x00, 0x42, 0x65
  db 0x00, 0x00                                ; 0D0EE
  db 0x00, 0x00                                ; 0D0F0
  db 0x00, 0x00                                ; 0D0F2
  db 0x00, 0x00                                ; 0D0F4
  dec sp                                       ; 0D0F6  0x4C
  add [gs:bx + si], al                         ; 0D0F7  0x65, 0x00, 0x00
  db 0x00, 0x00                                ; 0D0FA
  db 0x00, 0x00                                ; 0D0FC
  db 0x00, 0x00                                ; 0D0FE
  push si                                      ; 0D100  0x56
  add [gs:bx + si], al                         ; 0D101  0x65, 0x00, 0x00
  db 0x00, 0x00                                ; 0D104
  db 0x00, 0x00                                ; 0D106
  db 0x00, 0x00                                ; 0D108
  db 0x60                                      ; 0D10A  pusha
  add [gs:bx + si], al                         ; 0D10B  0x65, 0x00, 0x00
  db 0x00, 0x00                                ; 0D10E
  db 0x00, 0x00                                ; 0D110
  db 0x00, 0x00                                ; 0D112
  push 0x65                                    ; 0D114  0x6A, 0x65
  db 0x00, 0x00                                ; 0D116
  db 0x00, 0x00                                ; 0D118
  db 0x00, 0x00                                ; 0D11A
  db 0x00, 0x00                                ; 0D11C
  je loc_0D185                                 ; 0D11E  0x74, 0x65
  db 0x00, 0x00                                ; 0D120
  db 0x00, 0x00                                ; 0D122
  db 0x00, 0x00                                ; 0D124
  db 0x00, 0x00                                ; 0D126
  db 0x7E, 0x65                                ; 0D128  jle 0xd18f
  db 0x00, 0x00                                ; 0D12A
  db 0x00, 0x00                                ; 0D12C
  db 0x00, 0x00                                ; 0D12E
  db 0x00, 0x00                                ; 0D130
  db 0x88, 0x65, 0x00                          ; 0D132  mov byte [di], ah
  db 0x00, 0x00                                ; 0D135
  db 0x00, 0x00                                ; 0D137
  db 0x00, 0x00                                ; 0D139
  db 0x00, 0x92, 0x65, 0x00                    ; 0D13B  add byte [bp + si + 0x65], dl
  db 0x00, 0x00                                ; 0D13F
  db 0x00, 0x00                                ; 0D141
  db 0x00, 0x00                                ; 0D143
  db 0x00, 0x9C, 0x65, 0x00                    ; 0D145  add byte [si + 0x65], bl
  db 0x00, 0x00                                ; 0D149
  db 0x00, 0x00                                ; 0D14B
  db 0x00, 0x00                                ; 0D14D
  db 0x00, 0xA6, 0x65, 0x00                    ; 0D14F  add byte [bp + 0x65], ah
  db 0x00, 0x00                                ; 0D153
  db 0x00, 0x00                                ; 0D155
  db 0x00, 0x00                                ; 0D157
  db 0x00, 0xB0, 0x65, 0x00                    ; 0D159  add byte [bx + si + 0x65], dh
  db 0x00, 0x00                                ; 0D15D
  db 0x00, 0x00                                ; 0D15F
  db 0x00, 0x00                                ; 0D161
  db 0x00, 0xBA, 0x65, 0x00                    ; 0D163  add byte [bp + si + 0x65], bh
  db 0x00, 0x00                                ; 0D167
  db 0x00, 0x00                                ; 0D169
  db 0x00, 0x00                                ; 0D16B
  add ah, al                                   ; 0D16D  0x00, 0xC4
  add [gs:bx + si], al                         ; 0D16F  0x65, 0x00, 0x00
  db 0x00, 0x00                                ; 0D172
  db 0x00, 0x00                                ; 0D174
  db 0x00, 0x00                                ; 0D176
  into                                         ; 0D178  0xCE
  add [gs:bx + si], al                         ; 0D179  0x65, 0x00, 0x00
  db 0x00, 0x00                                ; 0D17C
  db 0x00, 0x00                                ; 0D17E
  db 0x00, 0x00                                ; 0D180
  db 0xD8, 0x65, 0x00                          ; 0D182  fsub dword [di]

loc_0D185:                                     ; 0D185
  db 0x00, 0x00                                ; 0D185
  db 0x00, 0x00                                ; 0D187
  db 0x00, 0x00                                ; 0D189
  add dl, ah                                   ; 0D18B  0x00, 0xE2
  add [gs:bx + si], al                         ; 0D18D  0x65, 0x00, 0x00
  db 0x00, 0x00                                ; 0D190
  db 0x00, 0x00                                ; 0D192
  db 0x00, 0x00                                ; 0D194
  in al, dx                                    ; 0D196  0xEC
  add [gs:bx + si], al                         ; 0D197  0x65, 0x00, 0x00
  db 0x00, 0x00                                ; 0D19A
  db 0x00, 0x00                                ; 0D19C
  db 0x00, 0x00                                ; 0D19E
  db 0xF6, 0x65, 0x00                          ; 0D1A0  mul byte [di]
  db 0x00, 0x00                                ; 0D1A3
  db 0x00, 0x00                                ; 0D1A5
  db 0x00, 0x00                                ; 0D1A7
  db 0x00, 0x00                                ; 0D1A9
  db 0x66, 0x00, 0x00                          ; 0D1AB  add byte [bx + si], al
  db 0x00, 0x00                                ; 0D1AE
  db 0x00, 0x00                                ; 0D1B0
  db 0x00, 0x00                                ; 0D1B2
  or ah, [bp]                                  ; 0D1B4  0x0A, 0x66, 0x00
  db 0x00, 0x00                                ; 0D1B7
  db 0x00, 0x00                                ; 0D1B9
  db 0x00, 0x00                                ; 0D1BB
  add [si], dl                                 ; 0D1BD  0x00, 0x14
  db 0x66, 0x00, 0x00                          ; 0D1BF  add byte [bx + si], al
  db 0x00, 0x00                                ; 0D1C2
  db 0x00, 0x00                                ; 0D1C4
  db 0x00, 0x00                                ; 0D1C6
  push ds                                      ; 0D1C8  0x1E
  db 0x66, 0x00, 0x00                          ; 0D1C9  add byte [bx + si], al
  db 0x00, 0x00                                ; 0D1CC
  db 0x00, 0x00                                ; 0D1CE
  db 0x00, 0x00                                ; 0D1D0
  sub [bp], ah                                 ; 0D1D2  0x28, 0x66, 0x00
  db 0x00, 0x00                                ; 0D1D5
  db 0x00, 0x00                                ; 0D1D7
  db 0x00, 0x00                                ; 0D1D9
  add [bp + si], dh                            ; 0D1DB  0x00, 0x32
  db 0x66, 0x00, 0x00                          ; 0D1DD  add byte [bx + si], al
  db 0x00, 0x00                                ; 0D1E0
  db 0x00, 0x00                                ; 0D1E2
  db 0x00, 0x00                                ; 0D1E4
  cmp al, 0x66                                 ; 0D1E6  0x3C, 0x66
  db 0x00, 0x00                                ; 0D1E8
  db 0x00, 0x00                                ; 0D1EA
  db 0x00, 0x00                                ; 0D1EC
  db 0x00, 0x00                                ; 0D1EE
  inc si                                       ; 0D1F0  0x46
  db 0x66, 0x00, 0x00                          ; 0D1F1  add byte [bx + si], al
  db 0x00, 0x00                                ; 0D1F4
  db 0x00, 0x00                                ; 0D1F6
  db 0x00, 0x00                                ; 0D1F8
  push ax                                      ; 0D1FA  0x50
  db 0x66, 0x00, 0x00                          ; 0D1FB  add byte [bx + si], al
  db 0x00, 0x00                                ; 0D1FE
  db 0x00, 0x00                                ; 0D200
  db 0x00, 0x00                                ; 0D202
  pop dx                                       ; 0D204  0x5A
  db 0x66, 0x00, 0x00                          ; 0D205  add byte [bx + si], al
  db 0x00, 0x00                                ; 0D208
  db 0x00, 0x00                                ; 0D20A
  db 0x00, 0x00                                ; 0D20C
  db 0x64, 0x66, 0x00, 0x00                    ; 0D20E  add byte [fs:bx + si], al
  db 0x00, 0x00                                ; 0D212
  db 0x00, 0x00                                ; 0D214
  db 0x00, 0x00                                ; 0D216
  db 0x6E                                      ; 0D218  outsb
  db 0x66, 0x00, 0x00                          ; 0D219  add byte [bx + si], al
  db 0x00, 0x00                                ; 0D21C
  db 0x00, 0x00                                ; 0D21E
  db 0x00, 0x00                                ; 0D220
  js loc_0D28A                                 ; 0D222  0x78, 0x66
  db 0x00, 0x00                                ; 0D224
  db 0x00, 0x00                                ; 0D226
  db 0x00, 0x00                                ; 0D228
  db 0x00, 0x00                                ; 0D22A
  db 0x82, 0x66, 0x00, 0x00                    ; 0D22C  and byte [bp], 0
  db 0x00, 0x00                                ; 0D230
  db 0x00, 0x00                                ; 0D232
  db 0x00, 0x00                                ; 0D234
  mov word [bp], fs                            ; 0D236  0x8C, 0x66, 0x00
  db 0x00, 0x00                                ; 0D239
  db 0x00, 0x00                                ; 0D23B
  db 0x00, 0x00                                ; 0D23D
  db 0x00, 0x96, 0x66, 0x00                    ; 0D23F  add byte [bp + 0x66], dl
  db 0x00, 0x00                                ; 0D243
  db 0x00, 0x00                                ; 0D245
  db 0x00, 0x00                                ; 0D247
  db 0x00, 0xA0, 0x66, 0x00                    ; 0D249  add byte [bx + si + 0x66], ah
  db 0x00, 0x00                                ; 0D24D
  db 0x00, 0x00                                ; 0D24F
  db 0x00, 0x00                                ; 0D251
  db 0x00, 0xAA, 0x66, 0x00                    ; 0D253  add byte [bp + si + 0x66], ch
  db 0x00, 0x00                                ; 0D257
  db 0x00, 0x00                                ; 0D259
  db 0x00, 0x00                                ; 0D25B
  db 0x00, 0xB4, 0x66, 0x00                    ; 0D25D  add byte [si + 0x66], dh
  db 0x00, 0x00                                ; 0D261
  db 0x00, 0x00                                ; 0D263
  db 0x00, 0x00                                ; 0D265
  db 0x00, 0xBE, 0x66, 0x00                    ; 0D267  add byte [bp + 0x66], bh
  db 0x00, 0x00                                ; 0D26B
  db 0x00, 0x00                                ; 0D26D
  db 0x00, 0x00                                ; 0D26F
  add al, cl                                   ; 0D271  0x00, 0xC8
  db 0x66, 0x00, 0x00                          ; 0D273  add byte [bx + si], al
  db 0x00, 0x00                                ; 0D276
  db 0x00, 0x00                                ; 0D278
  db 0x00, 0x00                                ; 0D27A
  db 0xD2, 0x66, 0x00                          ; 0D27C  shl byte [bp], cl
  db 0x00, 0x00                                ; 0D27F
  db 0x00, 0x00                                ; 0D281
  db 0x00, 0x00                                ; 0D283
  add ah, bl                                   ; 0D285  0x00, 0xDC
  db 0x66, 0x00, 0x00                          ; 0D287  add byte [bx + si], al

loc_0D28A:                                     ; 0D28A
  db 0x00, 0x00                                ; 0D28A
  db 0x00, 0x00                                ; 0D28C
  db 0x00, 0x00                                ; 0D28E
  out 0x66, al                                 ; 0D290  0xE6, 0x66
  db 0x00, 0x00                                ; 0D292
  db 0x00, 0x00                                ; 0D294
  db 0x00, 0x00                                ; 0D296
  db 0x00, 0x00                                ; 0D298
  db 0xF0, 0x66, 0x00, 0x00                    ; 0D29A  lock add byte [bx + si], al
  db 0x00, 0x00                                ; 0D29E
  db 0x00, 0x00                                ; 0D2A0
  db 0x00, 0x00                                ; 0D2A2
  cli                                          ; 0D2A4  0xFA
  db 0x66, 0x00, 0x00                          ; 0D2A5  add byte [bx + si], al
  db 0x00, 0x00                                ; 0D2A8
  db 0x00, 0x00                                ; 0D2AA
  db 0x00, 0x00                                ; 0D2AC
  add al, 0x67                                 ; 0D2AE  0x04, 0x67
  db 0x00, 0x00                                ; 0D2B0
  db 0x00, 0x00                                ; 0D2B2
  db 0x00, 0x00                                ; 0D2B4
  db 0x00, 0x00                                ; 0D2B6
  push cs                                      ; 0D2B8  0x0E
  add [eax], al                                ; 0D2B9  0x67, 0x00, 0x00
  db 0x00, 0x00                                ; 0D2BC
  db 0x00, 0x00                                ; 0D2BE
  db 0x00, 0x00                                ; 0D2C0
  db 0x18, 0x67, 0x00                          ; 0D2C2  sbb byte [bx], ah
  db 0x00, 0x00                                ; 0D2C5
  db 0x00, 0x00                                ; 0D2C7
  db 0x00, 0x00                                ; 0D2C9
  add [bp + si], ah                            ; 0D2CB  0x00, 0x22
  add [eax], al                                ; 0D2CD  0x67, 0x00, 0x00
  db 0x00, 0x00                                ; 0D2D0
  db 0x00, 0x00                                ; 0D2D2
  db 0x00, 0x00                                ; 0D2D4
  sub al, 0x67                                 ; 0D2D6  0x2C, 0x67
  db 0x00, 0x00                                ; 0D2D8
  db 0x00, 0x00                                ; 0D2DA
  db 0x00, 0x00                                ; 0D2DC
  db 0x00, 0x00                                ; 0D2DE
  add [ss:eax], al                             ; 0D2E0  0x36, 0x67, 0x00, 0x00
  db 0x00, 0x00                                ; 0D2E4
  db 0x00, 0x00                                ; 0D2E6
  db 0x00, 0x00                                ; 0D2E8
  inc ax                                       ; 0D2EA  0x40
  add [eax], al                                ; 0D2EB  0x67, 0x00, 0x00
  db 0x00, 0x00                                ; 0D2EE
  db 0x00, 0x00                                ; 0D2F0
  db 0x00, 0x00                                ; 0D2F2
  dec dx                                       ; 0D2F4  0x4A
  add [eax], al                                ; 0D2F5  0x67, 0x00, 0x00
  db 0x00, 0x00                                ; 0D2F8
  db 0x00, 0x00                                ; 0D2FA
  db 0x00, 0x00                                ; 0D2FC
  push sp                                      ; 0D2FE  0x54
  add [eax], al                                ; 0D2FF  0x67, 0x00, 0x00
  db 0x00, 0x00                                ; 0D302
  db 0x00, 0x00                                ; 0D304
  db 0x00, 0x00                                ; 0D306
  pop si                                       ; 0D308  0x5E
  add [eax], al                                ; 0D309  0x67, 0x00, 0x00
  db 0x00, 0x00                                ; 0D30C
  db 0x00, 0x00                                ; 0D30E
  db 0x00, 0x00                                ; 0D310
  db 0x68, 0x67, 0x00                          ; 0D312  push 0x67
  db 0x00, 0x00                                ; 0D315
  db 0x00, 0x00                                ; 0D317
  db 0x00, 0x00                                ; 0D319
  add [bp + si + 0x67], dh                     ; 0D31B  0x00, 0x72, 0x67
  db 0x00, 0x00                                ; 0D31E
  db 0x00, 0x00                                ; 0D320
  db 0x00, 0x00                                ; 0D322
  db 0x00, 0x00                                ; 0D324
  db 0x7C, 0x67                                ; 0D326  jl 0xd38f
  db 0x00, 0x00                                ; 0D328
  db 0x00, 0x00                                ; 0D32A
  db 0x00, 0x00                                ; 0D32C
  db 0x00, 0x00                                ; 0D32E
  db 0x86, 0x67, 0x00                          ; 0D330  xchg byte [bx], ah
  db 0x00, 0x00                                ; 0D333
  db 0x00, 0x00                                ; 0D335
  db 0x00, 0x00                                ; 0D337
  db 0x00, 0x90, 0x67, 0x00                    ; 0D339  add byte [bx + si + 0x67], dl
  db 0x00, 0x00                                ; 0D33D
  db 0x00, 0x00                                ; 0D33F
  db 0x00, 0x00                                ; 0D341
  db 0x00, 0x9A, 0x67, 0x00                    ; 0D343  add byte [bp + si + 0x67], bl
  db 0x00, 0x00                                ; 0D347
  db 0x00, 0x00                                ; 0D349
  db 0x00, 0x00                                ; 0D34B
  db 0x00, 0xA4, 0x67, 0x00                    ; 0D34D  add byte [si + 0x67], ah
  db 0x00, 0x00                                ; 0D351
  db 0x00, 0x00                                ; 0D353
  db 0x00, 0x00                                ; 0D355
  db 0x00, 0xAE, 0x67, 0x00                    ; 0D357  add byte [bp + 0x67], ch
  db 0x00, 0x00                                ; 0D35B
  db 0x00, 0x00                                ; 0D35D
  db 0x00, 0x00                                ; 0D35F
  db 0x00, 0xB8, 0x67, 0x00                    ; 0D361  add byte [bx + si + 0x67], bh
  db 0x00, 0x00                                ; 0D365
  db 0x00, 0x00                                ; 0D367
  db 0x00, 0x00                                ; 0D369
  add dl, al                                   ; 0D36B  0x00, 0xC2
  add [eax], al                                ; 0D36D  0x67, 0x00, 0x00
  db 0x00, 0x00                                ; 0D370
  db 0x00, 0x00                                ; 0D372
  db 0x00, 0x00                                ; 0D374
  db 0xCC                                      ; 0D376  int3
  add [eax], al                                ; 0D377  0x67, 0x00, 0x00
  db 0x00, 0x00                                ; 0D37A
  db 0x00, 0x00                                ; 0D37C
  db 0x00, 0x00                                ; 0D37E
  db 0xD6                                      ; 0D380  salc
  add [eax], al                                ; 0D381  0x67, 0x00, 0x00
  db 0x00, 0x00                                ; 0D384
  db 0x00, 0x00                                ; 0D386
  db 0x00, 0x00                                ; 0D388
  db 0xE0, 0x67                                ; 0D38A  loopne 0xd3f3
  db 0x00, 0x00                                ; 0D38C
  db 0x00, 0x00                                ; 0D38E
  db 0x00, 0x00                                ; 0D390
  db 0x00, 0x00                                ; 0D392
  db 0xEA, 0x67, 0x00, 0x00, 0x00              ; 0D394  jmp far 0:0x67
  db 0x00, 0x00, 0x00, 0x00, 0x00              ; 0D399  .....
  hlt                                          ; 0D39E  0xF4
  add [eax], al                                ; 0D39F  0x67, 0x00, 0x00
  db 0x00, 0x00                                ; 0D3A2
  db 0x00, 0x00                                ; 0D3A4
  db 0x00, 0x00                                ; 0D3A6
  db 0xFE                                      ; 0D3A8  .
  add [eax], al                                ; 0D3A9  0x67, 0x00, 0x00
  db 0x00, 0x00                                ; 0D3AC
  db 0x00, 0x00                                ; 0D3AE
  db 0x00, 0x00                                ; 0D3B0
  db 0x08, 0x68, 0x00                          ; 0D3B2  or byte [bx + si], ch
  db 0x00, 0x00                                ; 0D3B5
  db 0x00, 0x00                                ; 0D3B7
  db 0x00, 0x00                                ; 0D3B9
  add [bp + si], dl                            ; 0D3BB  0x00, 0x12
  db 0x68, 0x00, 0x00                          ; 0D3BD  push 0
  db 0x00, 0x00                                ; 0D3C0
  db 0x00, 0x00                                ; 0D3C2
  db 0x00, 0x00                                ; 0D3C4
  sbb al, 0x68                                 ; 0D3C6  0x1C, 0x68
  db 0x00, 0x00                                ; 0D3C8
  db 0x00, 0x00                                ; 0D3CA
  db 0x00, 0x00                                ; 0D3CC
  db 0x00, 0x00                                ; 0D3CE
  db 0x26, 0x68, 0x00, 0x00                    ; 0D3D0  push 0
  db 0x00, 0x00                                ; 0D3D4
  db 0x00, 0x00                                ; 0D3D6
  db 0x00, 0x00                                ; 0D3D8
  db 0x30, 0x68, 0x00                          ; 0D3DA  xor byte [bx + si], ch
  db 0x00, 0x00                                ; 0D3DD
  db 0x00, 0x00                                ; 0D3DF
  db 0x00, 0x00                                ; 0D3E1
  add [bp + si], bh                            ; 0D3E3  0x00, 0x3A
  db 0x68, 0x00, 0x00                          ; 0D3E5  push 0
  db 0x00, 0x00                                ; 0D3E8
  db 0x00, 0x00                                ; 0D3EA
  db 0x00, 0x00                                ; 0D3EC
  inc sp                                       ; 0D3EE  0x44
  db 0x68, 0x00, 0x00                          ; 0D3EF  push 0
  db 0x00, 0x00                                ; 0D3F2
  db 0x00, 0x00                                ; 0D3F4
  db 0x00, 0x00                                ; 0D3F6
  dec si                                       ; 0D3F8  0x4E
  db 0x68, 0x00, 0x00                          ; 0D3F9  push 0
  db 0x00, 0x00                                ; 0D3FC
  db 0x00, 0x00                                ; 0D3FE
  db 0x00, 0x00                                ; 0D400
  pop ax                                       ; 0D402  0x58
  db 0x68, 0x00, 0x00                          ; 0D403  push 0
  db 0x00, 0x00                                ; 0D406
  db 0x00, 0x00                                ; 0D408
  db 0x00, 0x00                                ; 0D40A
  db 0x62, 0x68, 0x00                          ; 0D40C  bound bp, dword [bx + si]
  db 0x00, 0x00                                ; 0D40F
  db 0x00, 0x00                                ; 0D411
  db 0x00, 0x00                                ; 0D413
  add [si + 0x68], ch                          ; 0D415  0x00, 0x6C, 0x68
  db 0x00, 0x00                                ; 0D418
  db 0x00, 0x00                                ; 0D41A
  db 0x00, 0x00                                ; 0D41C
  db 0x00, 0x00                                ; 0D41E
  jbe loc_0D48A                                ; 0D420  0x76, 0x68
  db 0x00, 0x00                                ; 0D422
  db 0x00, 0x00                                ; 0D424
  db 0x00, 0x00                                ; 0D426
  db 0x00, 0x00                                ; 0D428
  db 0x80, 0x68, 0x00, 0x00                    ; 0D42A  sub byte [bx + si], 0
  db 0x00, 0x00                                ; 0D42E
  db 0x00, 0x00                                ; 0D430
  db 0x00, 0x00                                ; 0D432
  db 0x8A, 0x68, 0x00                          ; 0D434  mov ch, byte [bx + si]
  db 0x00, 0x00                                ; 0D437
  db 0x00, 0x00                                ; 0D439
  db 0x00, 0x00                                ; 0D43B
  db 0x00, 0x94, 0x68, 0x00                    ; 0D43D  add byte [si + 0x68], dl
  db 0x00, 0x00                                ; 0D441
  db 0x00, 0x00                                ; 0D443
  db 0x00, 0x00                                ; 0D445
  db 0x00, 0x9E, 0x68, 0x00                    ; 0D447  add byte [bp + 0x68], bl
  db 0x00, 0x00                                ; 0D44B
  db 0x00, 0x00                                ; 0D44D
  db 0x00, 0x00                                ; 0D44F
  db 0x00, 0xA8, 0x68, 0x00                    ; 0D451  add byte [bx + si + 0x68], ch
  db 0x00, 0x00                                ; 0D455
  db 0x00, 0x00                                ; 0D457
  db 0x00, 0x00                                ; 0D459
  db 0x00, 0xB2, 0x68, 0x00                    ; 0D45B  add byte [bp + si + 0x68], dh
  db 0x00, 0x00                                ; 0D45F
  db 0x00, 0x00                                ; 0D461
  db 0x00, 0x00                                ; 0D463
  db 0x00, 0xBC, 0x68, 0x00                    ; 0D465  add byte [si + 0x68], bh
  db 0x00, 0x00                                ; 0D469
  db 0x00, 0x00                                ; 0D46B
  db 0x00, 0x00                                ; 0D46D
  add dh, al                                   ; 0D46F  0x00, 0xC6
  db 0x68, 0x00, 0x00                          ; 0D471  push 0
  db 0x00, 0x00                                ; 0D474
  db 0x00, 0x00                                ; 0D476
  db 0x00, 0x00                                ; 0D478
  db 0xD0, 0x68, 0x00                          ; 0D47A  shr byte [bx + si], 1
  db 0x00, 0x00                                ; 0D47D
  db 0x00, 0x00                                ; 0D47F
  db 0x00, 0x00                                ; 0D481
  add dl, bl                                   ; 0D483  0x00, 0xDA
  db 0x68, 0x00, 0x00                          ; 0D485  push 0
  db 0x00, 0x00                                ; 0D488

loc_0D48A:                                     ; 0D48A
  db 0x00, 0x00                                ; 0D48A
  db 0x00, 0x00                                ; 0D48C
  in al, 0x68                                  ; 0D48E  0xE4, 0x68
  db 0x00, 0x00                                ; 0D490
  db 0x00, 0x00                                ; 0D492
  db 0x00, 0x00                                ; 0D494
  db 0x00, 0x00                                ; 0D496
  out dx, al                                   ; 0D498  0xEE
  db 0x68, 0x00, 0x00                          ; 0D499  push 0
  db 0x00, 0x00                                ; 0D49C
  db 0x00, 0x00                                ; 0D49E
  db 0x00, 0x00                                ; 0D4A0
  clc                                          ; 0D4A2  0xF8
  db 0x68, 0x00, 0x00                          ; 0D4A3  push 0
  db 0x00, 0x00                                ; 0D4A6
  db 0x00, 0x00                                ; 0D4A8
  db 0x00, 0x00                                ; 0D4AA
  db 0x02, 0x69, 0x00                          ; 0D4AC  add ch, byte [bx + di]
  db 0x00, 0x00                                ; 0D4AF
  db 0x00, 0x00                                ; 0D4B1
  db 0x00, 0x00                                ; 0D4B3
  add [si], cl                                 ; 0D4B5  0x00, 0x0C
  db 0x69, 0x00, 0x00, 0x00                    ; 0D4B7  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D4BB
  db 0x00, 0x00                                ; 0D4BD
  add [0x69], dl                               ; 0D4BF  0x00, 0x16, 0x69, 0x00
  db 0x00, 0x00                                ; 0D4C3
  db 0x00, 0x00                                ; 0D4C5
  db 0x00, 0x00                                ; 0D4C7
  add [bx + si], ah                            ; 0D4C9  0x00, 0x20
  db 0x69, 0x00, 0x00, 0x00                    ; 0D4CB  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D4CF
  db 0x00, 0x00                                ; 0D4D1
  add [bp + si], ch                            ; 0D4D3  0x00, 0x2A
  db 0x69, 0x00, 0x00, 0x00                    ; 0D4D5  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D4D9
  db 0x00, 0x00                                ; 0D4DB
  add [si], dh                                 ; 0D4DD  0x00, 0x34
  db 0x69, 0x00, 0x00, 0x00                    ; 0D4DF  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D4E3
  db 0x00, 0x00                                ; 0D4E5
  add [0x69], bh                               ; 0D4E7  0x00, 0x3E, 0x69, 0x00
  db 0x00, 0x00                                ; 0D4EB
  db 0x00, 0x00                                ; 0D4ED
  db 0x00, 0x00                                ; 0D4EF
  add [bx + si + 0x69], cl                     ; 0D4F1  0x00, 0x48, 0x69
  db 0x00, 0x00                                ; 0D4F4
  db 0x00, 0x00                                ; 0D4F6
  db 0x00, 0x00                                ; 0D4F8
  db 0x00, 0x00                                ; 0D4FA
  push dx                                      ; 0D4FC  0x52
  db 0x69, 0x00, 0x00, 0x00                    ; 0D4FD  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D501
  db 0x00, 0x00                                ; 0D503
  add [si + 0x69], bl                          ; 0D505  0x00, 0x5C, 0x69
  db 0x00, 0x00                                ; 0D508
  db 0x00, 0x00                                ; 0D50A
  db 0x00, 0x00                                ; 0D50C
  db 0x00, 0x00                                ; 0D50E
  db 0x66, 0x69, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0D510  imul eax, dword [bx + si], 0
  db 0x00, 0x00                                ; 0D517
  add [bx + si + 0x69], dh                     ; 0D519  0x00, 0x70, 0x69
  db 0x00, 0x00                                ; 0D51C
  db 0x00, 0x00                                ; 0D51E
  db 0x00, 0x00                                ; 0D520
  db 0x00, 0x00                                ; 0D522
  jp loc_0D58F                                 ; 0D524  0x7A, 0x69
  db 0x00, 0x00                                ; 0D526
  db 0x00, 0x00                                ; 0D528
  db 0x00, 0x00                                ; 0D52A
  db 0x00, 0x00                                ; 0D52C
  db 0x84, 0x69, 0x00                          ; 0D52E  test byte [bx + di], ch
  db 0x00, 0x00                                ; 0D531
  db 0x00, 0x00                                ; 0D533
  db 0x00, 0x00                                ; 0D535
  db 0x00, 0x8E, 0x69, 0x00                    ; 0D537  add byte [bp + 0x69], cl
  db 0x00, 0x00                                ; 0D53B
  db 0x00, 0x00                                ; 0D53D
  db 0x00, 0x00                                ; 0D53F
  db 0x00, 0x98, 0x69, 0x00                    ; 0D541  add byte [bx + si + 0x69], bl
  db 0x00, 0x00                                ; 0D545
  db 0x00, 0x00                                ; 0D547
  db 0x00, 0x00                                ; 0D549
  db 0x00, 0xA2, 0x69, 0x00                    ; 0D54B  add byte [bp + si + 0x69], ah
  db 0x00, 0x00                                ; 0D54F
  db 0x00, 0x00                                ; 0D551
  db 0x00, 0x00                                ; 0D553
  db 0x00, 0xAC, 0x69, 0x00                    ; 0D555  add byte [si + 0x69], ch
  db 0x00, 0x00                                ; 0D559
  db 0x00, 0x00                                ; 0D55B
  db 0x00, 0x00                                ; 0D55D
  db 0x00, 0xB6, 0x69, 0x00                    ; 0D55F  add byte [bp + 0x69], dh
  db 0x00, 0x00                                ; 0D563
  db 0x00, 0x00                                ; 0D565
  db 0x00, 0x00                                ; 0D567
  add al, al                                   ; 0D569  0x00, 0xC0
  db 0x69, 0x00, 0x00, 0x00                    ; 0D56B  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D56F
  db 0x00, 0x00                                ; 0D571
  add dl, cl                                   ; 0D573  0x00, 0xCA
  db 0x69, 0x00, 0x00, 0x00                    ; 0D575  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D579
  db 0x00, 0x00                                ; 0D57B
  add ah, dl                                   ; 0D57D  0x00, 0xD4
  db 0x69, 0x00, 0x00, 0x00                    ; 0D57F  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D583
  db 0x00, 0x00                                ; 0D585
  add dh, bl                                   ; 0D587  0x00, 0xDE
  db 0x69, 0x00, 0x00, 0x00                    ; 0D589  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D58D

loc_0D58F:                                     ; 0D58F
  db 0x00, 0x00                                ; 0D58F
  add al, ch                                   ; 0D591  0x00, 0xE8
  db 0x69, 0x00, 0x00, 0x00                    ; 0D593  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D597
  db 0x00, 0x00                                ; 0D599
  add dl, dh                                   ; 0D59B  0x00, 0xF2
  db 0x69, 0x00, 0x00, 0x00                    ; 0D59D  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D5A1
  db 0x00, 0x00                                ; 0D5A3
  add ah, bh                                   ; 0D5A5  0x00, 0xFC
  db 0x69, 0x00, 0x00, 0x00                    ; 0D5A7  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D5AB
  db 0x00, 0x00                                ; 0D5AD
  add [0x6a], al                               ; 0D5AF  0x00, 0x06, 0x6A, 0x00
  db 0x00, 0x00                                ; 0D5B3
  db 0x00, 0x00                                ; 0D5B5
  db 0x00, 0x00                                ; 0D5B7
  add [bx + si], dl                            ; 0D5B9  0x00, 0x10
  push 0                                       ; 0D5BB  0x6A, 0x00
  db 0x00, 0x00                                ; 0D5BD
  db 0x00, 0x00                                ; 0D5BF
  db 0x00, 0x00                                ; 0D5C1
  add [bp + si], bl                            ; 0D5C3  0x00, 0x1A
  push 0                                       ; 0D5C5  0x6A, 0x00
  db 0x00, 0x00                                ; 0D5C7
  db 0x00, 0x00                                ; 0D5C9
  db 0x00, 0x00                                ; 0D5CB
  add [si], ah                                 ; 0D5CD  0x00, 0x24
  push 0                                       ; 0D5CF  0x6A, 0x00
  db 0x00, 0x00                                ; 0D5D1
  db 0x00, 0x00                                ; 0D5D3
  db 0x00, 0x00                                ; 0D5D5
  add [0x6a], ch                               ; 0D5D7  0x00, 0x2E, 0x6A, 0x00
  db 0x00, 0x00                                ; 0D5DB
  db 0x00, 0x00                                ; 0D5DD
  db 0x00, 0x00                                ; 0D5DF
  add [bx + si], bh                            ; 0D5E1  0x00, 0x38
  push 0                                       ; 0D5E3  0x6A, 0x00
  db 0x00, 0x00                                ; 0D5E5
  db 0x00, 0x00                                ; 0D5E7
  db 0x00, 0x00                                ; 0D5E9
  add [bp + si + 0x6a], al                     ; 0D5EB  0x00, 0x42, 0x6A
  db 0x00, 0x00                                ; 0D5EE
  db 0x00, 0x00                                ; 0D5F0
  db 0x00, 0x00                                ; 0D5F2
  db 0x00, 0x00                                ; 0D5F4
  dec sp                                       ; 0D5F6  0x4C
  push 0                                       ; 0D5F7  0x6A, 0x00
  db 0x00, 0x00                                ; 0D5F9
  db 0x00, 0x00                                ; 0D5FB
  db 0x00, 0x00                                ; 0D5FD
  add [bp + 0x6a], dl                          ; 0D5FF  0x00, 0x56, 0x6A
  db 0x00, 0x00                                ; 0D602
  db 0x00, 0x00                                ; 0D604
  db 0x00, 0x00                                ; 0D606
  db 0x00, 0x00                                ; 0D608
  db 0x60                                      ; 0D60A  pusha
  push 0                                       ; 0D60B  0x6A, 0x00
  db 0x00, 0x00                                ; 0D60D
  db 0x00, 0x00                                ; 0D60F
  db 0x00, 0x00                                ; 0D611
  add [bp + si + 0x6a], ch                     ; 0D613  0x00, 0x6A, 0x6A
  db 0x00, 0x00                                ; 0D616
  db 0x00, 0x00                                ; 0D618
  db 0x00, 0x00                                ; 0D61A
  db 0x00, 0x00                                ; 0D61C
  db 0x74, 0x6A                                ; 0D61E  je 0xd68a
  db 0x00, 0x00                                ; 0D620
  db 0x00, 0x00                                ; 0D622
  db 0x00, 0x00                                ; 0D624
  db 0x00, 0x00                                ; 0D626
  db 0x7E, 0x6A                                ; 0D628  jle 0xd694
  db 0x00, 0x00                                ; 0D62A
  db 0x00, 0x00                                ; 0D62C
  db 0x00, 0x00                                ; 0D62E
  db 0x00, 0x00                                ; 0D630
  db 0x88, 0x6A, 0x00                          ; 0D632  mov byte [bp + si], ch
  db 0x00, 0x00                                ; 0D635
  db 0x00, 0x00                                ; 0D637
  db 0x00, 0x00                                ; 0D639
  db 0x00, 0x92, 0x6A, 0x00                    ; 0D63B  add byte [bp + si + 0x6a], dl
  db 0x00, 0x00                                ; 0D63F
  db 0x00, 0x00                                ; 0D641
  db 0x00, 0x00                                ; 0D643
  db 0x00, 0x9C, 0x6A, 0x00                    ; 0D645  add byte [si + 0x6a], bl
  db 0x00, 0x00                                ; 0D649
  db 0x00, 0x00                                ; 0D64B
  db 0x00, 0x00                                ; 0D64D
  db 0x00, 0xA6, 0x6A, 0x00                    ; 0D64F  add byte [bp + 0x6a], ah
  db 0x00, 0x00                                ; 0D653
  db 0x00, 0x00                                ; 0D655
  db 0x00, 0x00                                ; 0D657
  db 0x00, 0xB0, 0x6A, 0x00                    ; 0D659  add byte [bx + si + 0x6a], dh
  db 0x00, 0x00                                ; 0D65D
  db 0x00, 0x00                                ; 0D65F
  db 0x00, 0x00                                ; 0D661
  db 0x00, 0xBA, 0x6A, 0x00                    ; 0D663  add byte [bp + si + 0x6a], bh
  db 0x00, 0x00                                ; 0D667
  db 0x00, 0x00                                ; 0D669
  db 0x00, 0x00                                ; 0D66B
  add ah, al                                   ; 0D66D  0x00, 0xC4
  push 0                                       ; 0D66F  0x6A, 0x00
  db 0x00, 0x00                                ; 0D671
  db 0x00, 0x00                                ; 0D673
  db 0x00, 0x00                                ; 0D675
  add dh, cl                                   ; 0D677  0x00, 0xCE
  push 0                                       ; 0D679  0x6A, 0x00
  db 0x00, 0x00                                ; 0D67B
  db 0x00, 0x00                                ; 0D67D
  db 0x00, 0x00                                ; 0D67F
  add al, bl                                   ; 0D681  0x00, 0xD8
  push 0                                       ; 0D683  0x6A, 0x00
  db 0x00, 0x00                                ; 0D685
  db 0x00, 0x00                                ; 0D687
  db 0x00, 0x00                                ; 0D689
  add dl, ah                                   ; 0D68B  0x00, 0xE2
  push 0                                       ; 0D68D  0x6A, 0x00
  db 0x00, 0x00                                ; 0D68F
  db 0x00, 0x00                                ; 0D691
  db 0x00, 0x00                                ; 0D693
  add ah, ch                                   ; 0D695  0x00, 0xEC
  push 0                                       ; 0D697  0x6A, 0x00
  db 0x00, 0x00                                ; 0D699
  db 0x00, 0x00                                ; 0D69B
  db 0x00, 0x00                                ; 0D69D
  add dh, dh                                   ; 0D69F  0x00, 0xF6
  push 0                                       ; 0D6A1  0x6A, 0x00
  db 0x00, 0x00                                ; 0D6A3
  db 0x00, 0x00                                ; 0D6A5
  db 0x00, 0x00                                ; 0D6A7
  db 0x00, 0x00                                ; 0D6A9
  db 0x6B, 0x00, 0x00                          ; 0D6AB  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D6AE
  db 0x00, 0x00                                ; 0D6B0
  db 0x00, 0x00                                ; 0D6B2
  db 0x0A, 0x6B, 0x00                          ; 0D6B4  or ch, byte [bp + di]
  db 0x00, 0x00                                ; 0D6B7
  db 0x00, 0x00                                ; 0D6B9
  db 0x00, 0x00                                ; 0D6BB
  add [si], dl                                 ; 0D6BD  0x00, 0x14
  db 0x6B, 0x00, 0x00                          ; 0D6BF  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D6C2
  db 0x00, 0x00                                ; 0D6C4
  db 0x00, 0x00                                ; 0D6C6
  push ds                                      ; 0D6C8  0x1E
  db 0x6B, 0x00, 0x00                          ; 0D6C9  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D6CC
  db 0x00, 0x00                                ; 0D6CE
  db 0x00, 0x00                                ; 0D6D0
  db 0x28, 0x6B, 0x00                          ; 0D6D2  sub byte [bp + di], ch
  db 0x00, 0x00                                ; 0D6D5
  db 0x00, 0x00                                ; 0D6D7
  db 0x00, 0x00                                ; 0D6D9
  add [bp + si], dh                            ; 0D6DB  0x00, 0x32
  db 0x6B, 0x00, 0x00                          ; 0D6DD  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D6E0
  db 0x00, 0x00                                ; 0D6E2
  db 0x00, 0x00                                ; 0D6E4
  cmp al, 0x6b                                 ; 0D6E6  0x3C, 0x6B
  db 0x00, 0x00                                ; 0D6E8
  db 0x00, 0x00                                ; 0D6EA
  db 0x00, 0x00                                ; 0D6EC
  db 0x00, 0x00                                ; 0D6EE
  inc si                                       ; 0D6F0  0x46
  db 0x6B, 0x00, 0x00                          ; 0D6F1  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D6F4
  db 0x00, 0x00                                ; 0D6F6
  db 0x00, 0x00                                ; 0D6F8
  push ax                                      ; 0D6FA  0x50
  db 0x6B, 0x00, 0x00                          ; 0D6FB  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D6FE
  db 0x00, 0x00                                ; 0D700
  db 0x00, 0x00                                ; 0D702
  pop dx                                       ; 0D704  0x5A
  db 0x6B, 0x00, 0x00                          ; 0D705  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D708
  db 0x00, 0x00                                ; 0D70A
  db 0x00, 0x00                                ; 0D70C
  db 0x64, 0x6B, 0x00, 0x00                    ; 0D70E  imul ax, word [fs:bx + si], 0
  db 0x00, 0x00                                ; 0D712
  db 0x00, 0x00                                ; 0D714
  db 0x00, 0x00                                ; 0D716
  db 0x6E                                      ; 0D718  outsb
  db 0x6B, 0x00, 0x00                          ; 0D719  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D71C
  db 0x00, 0x00                                ; 0D71E
  db 0x00, 0x00                                ; 0D720
  db 0x78, 0x6B                                ; 0D722  js 0xd78f
  db 0x00, 0x00                                ; 0D724
  db 0x00, 0x00                                ; 0D726
  db 0x00, 0x00                                ; 0D728
  db 0x00, 0x00                                ; 0D72A
  db 0x82, 0x6B, 0x00, 0x00                    ; 0D72C  sub byte [bp + di], 0
  db 0x00, 0x00                                ; 0D730
  db 0x00, 0x00                                ; 0D732
  db 0x00, 0x00                                ; 0D734
  db 0x8C, 0x6B, 0x00                          ; 0D736  mov word [bp + di], gs
  db 0x00, 0x00                                ; 0D739
  db 0x00, 0x00                                ; 0D73B
  db 0x00, 0x00                                ; 0D73D
  db 0x00, 0x96, 0x6B, 0x00                    ; 0D73F  add byte [bp + 0x6b], dl
  db 0x00, 0x00                                ; 0D743
  db 0x00, 0x00                                ; 0D745
  db 0x00, 0x00                                ; 0D747
  db 0x00, 0xA0, 0x6B, 0x00                    ; 0D749  add byte [bx + si + 0x6b], ah
  db 0x00, 0x00                                ; 0D74D
  db 0x00, 0x00                                ; 0D74F
  db 0x00, 0x00                                ; 0D751
  db 0x00, 0xAA, 0x6B, 0x00                    ; 0D753  add byte [bp + si + 0x6b], ch
  db 0x00, 0x00                                ; 0D757
  db 0x00, 0x00                                ; 0D759
  db 0x00, 0x00                                ; 0D75B
  db 0x00, 0xB4, 0x6B, 0x00                    ; 0D75D  add byte [si + 0x6b], dh
  db 0x00, 0x00                                ; 0D761
  db 0x00, 0x00                                ; 0D763
  db 0x00, 0x00                                ; 0D765
  db 0x00, 0xBE, 0x6B, 0x00                    ; 0D767  add byte [bp + 0x6b], bh
  db 0x00, 0x00                                ; 0D76B
  db 0x00, 0x00                                ; 0D76D
  db 0x00, 0x00                                ; 0D76F
  add al, cl                                   ; 0D771  0x00, 0xC8
  db 0x6B, 0x00, 0x00                          ; 0D773  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D776
  db 0x00, 0x00                                ; 0D778
  db 0x00, 0x00                                ; 0D77A
  db 0xD2, 0x6B, 0x00                          ; 0D77C  shr byte [bp + di], cl
  db 0x00, 0x00                                ; 0D77F
  db 0x00, 0x00                                ; 0D781
  db 0x00, 0x00                                ; 0D783
  add ah, bl                                   ; 0D785  0x00, 0xDC
  db 0x6B, 0x00, 0x00                          ; 0D787  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D78A
  db 0x00, 0x00                                ; 0D78C
  db 0x00, 0x00                                ; 0D78E
  out 0x6b, al                                 ; 0D790  0xE6, 0x6B
  db 0x00, 0x00                                ; 0D792
  db 0x00, 0x00                                ; 0D794
  db 0x00, 0x00                                ; 0D796
  db 0x00, 0x00                                ; 0D798
  db 0xF0                                      ; 0D79A  .
  db 0x6B, 0x00, 0x00                          ; 0D79B  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D79E
  db 0x00, 0x00                                ; 0D7A0
  db 0x00, 0x00                                ; 0D7A2
  cli                                          ; 0D7A4  0xFA
  db 0x6B, 0x00, 0x00                          ; 0D7A5  imul ax, word [bx + si], 0
  db 0x00, 0x00                                ; 0D7A8
  db 0x00, 0x00                                ; 0D7AA
  db 0x00, 0x00                                ; 0D7AC
  add al, 0x6c                                 ; 0D7AE  0x04, 0x6C
  db 0x00, 0x00                                ; 0D7B0
  db 0x00, 0x00                                ; 0D7B2
  db 0x00, 0x00                                ; 0D7B4
  db 0x00, 0x00                                ; 0D7B6
  push cs                                      ; 0D7B8  0x0E
  db 0x6C                                      ; 0D7B9  insb
  db 0x00, 0x00                                ; 0D7BA
  db 0x00, 0x00                                ; 0D7BC
  db 0x00, 0x00                                ; 0D7BE
  db 0x00, 0x00                                ; 0D7C0
  db 0x18, 0x6C, 0x00                          ; 0D7C2  sbb byte [si], ch
  db 0x00, 0x00                                ; 0D7C5
  db 0x00, 0x00                                ; 0D7C7
  db 0x00, 0x00                                ; 0D7C9
  add [bp + si], ah                            ; 0D7CB  0x00, 0x22
  db 0x6C                                      ; 0D7CD  insb
  db 0x00, 0x00                                ; 0D7CE
  db 0x00, 0x00                                ; 0D7D0
  db 0x00, 0x00                                ; 0D7D2
  db 0x00, 0x00                                ; 0D7D4
  sub al, 0x6c                                 ; 0D7D6  0x2C, 0x6C
  db 0x00, 0x00                                ; 0D7D8
  db 0x00, 0x00                                ; 0D7DA
  db 0x00, 0x00                                ; 0D7DC
  db 0x00, 0x00                                ; 0D7DE
  db 0x36, 0x6C                                ; 0D7E0  insb
  db 0x00, 0x00                                ; 0D7E2
  db 0x00, 0x00                                ; 0D7E4
  db 0x00, 0x00                                ; 0D7E6
  db 0x00, 0x00                                ; 0D7E8
  inc ax                                       ; 0D7EA  0x40
  db 0x6C                                      ; 0D7EB  insb
  db 0x00, 0x00                                ; 0D7EC
  db 0x00, 0x00                                ; 0D7EE
  db 0x00, 0x00                                ; 0D7F0
  db 0x00, 0x00                                ; 0D7F2
  dec dx                                       ; 0D7F4  0x4A
  db 0x6C                                      ; 0D7F5  insb
  db 0x00, 0x00                                ; 0D7F6
  db 0x00, 0x00                                ; 0D7F8
  db 0x00, 0x00                                ; 0D7FA
  db 0x00, 0x00                                ; 0D7FC
  push sp                                      ; 0D7FE  0x54
  db 0x6C                                      ; 0D7FF  insb
  db 0x00, 0x00                                ; 0D800
  db 0x00, 0x00                                ; 0D802
  db 0x00, 0x00                                ; 0D804
  db 0x00, 0x00                                ; 0D806
  pop si                                       ; 0D808  0x5E
  db 0x6C                                      ; 0D809  insb
  db 0x00, 0x00                                ; 0D80A
  db 0x00, 0x00                                ; 0D80C
  db 0x00, 0x00                                ; 0D80E
  db 0x00, 0x00                                ; 0D810
  db 0x68, 0x6C, 0x00                          ; 0D812  push 0x6c
  db 0x00, 0x00                                ; 0D815
  db 0x00, 0x00                                ; 0D817
  db 0x00, 0x00                                ; 0D819
  add [bp + si + 0x6c], dh                     ; 0D81B  0x00, 0x72, 0x6C
  db 0x00, 0x00                                ; 0D81E
  db 0x00, 0x00                                ; 0D820
  db 0x00, 0x00                                ; 0D822
  db 0x00, 0x00                                ; 0D824
  jl loc_0D894                                 ; 0D826  0x7C, 0x6C
  db 0x00, 0x00                                ; 0D828
  db 0x00, 0x00                                ; 0D82A
  db 0x00, 0x00                                ; 0D82C
  db 0x00, 0x00                                ; 0D82E
  db 0x86, 0x6C, 0x00                          ; 0D830  xchg byte [si], ch
  db 0x00, 0x00                                ; 0D833
  db 0x00, 0x00                                ; 0D835
  db 0x00, 0x00                                ; 0D837
  db 0x00, 0x90, 0x6C, 0x00                    ; 0D839  add byte [bx + si + 0x6c], dl
  db 0x00, 0x00                                ; 0D83D
  db 0x00, 0x00                                ; 0D83F
  db 0x00, 0x00                                ; 0D841
  db 0x00, 0x9A, 0x6C, 0x00                    ; 0D843  add byte [bp + si + 0x6c], bl
  db 0x00, 0x00                                ; 0D847
  db 0x00, 0x00                                ; 0D849
  db 0x00, 0x00                                ; 0D84B
  db 0x00, 0xA4, 0x6C, 0x00                    ; 0D84D  add byte [si + 0x6c], ah
  db 0x00, 0x00                                ; 0D851
  db 0x00, 0x00                                ; 0D853
  db 0x00, 0x00                                ; 0D855
  db 0x00, 0xAE, 0x6C, 0x00                    ; 0D857  add byte [bp + 0x6c], ch
  db 0x00, 0x00                                ; 0D85B
  db 0x00, 0x00                                ; 0D85D
  db 0x00, 0x00                                ; 0D85F
  db 0x00, 0xB8, 0x6C, 0x00                    ; 0D861  add byte [bx + si + 0x6c], bh
  db 0x00, 0x00                                ; 0D865
  db 0x00, 0x00                                ; 0D867
  db 0x00, 0x00                                ; 0D869
  add dl, al                                   ; 0D86B  0x00, 0xC2
  db 0x6C                                      ; 0D86D  insb
  db 0x00, 0x00                                ; 0D86E
  db 0x00, 0x00                                ; 0D870
  db 0x00, 0x00                                ; 0D872
  db 0x00, 0x00                                ; 0D874
  db 0xCC                                      ; 0D876  int3
  db 0x6C                                      ; 0D877  insb
  db 0x00, 0x00                                ; 0D878
  db 0x00, 0x00                                ; 0D87A
  db 0x00, 0x00                                ; 0D87C
  db 0x00, 0x00                                ; 0D87E
  db 0xD6                                      ; 0D880  salc
  db 0x6C                                      ; 0D881  insb
  db 0x00, 0x00                                ; 0D882
  db 0x00, 0x00                                ; 0D884
  db 0x00, 0x00                                ; 0D886
  db 0x00, 0x00                                ; 0D888
  db 0x00, 0x00                                ; 0D88A
  db 0x00, 0x00                                ; 0D88C
  db 0x00, 0x00                                ; 0D88E
  db 0x00, 0x00                                ; 0D890
  db 0x00, 0x00                                ; 0D892

loc_0D894:                                     ; 0D894
  db 0x00, 0x00                                ; 0D894
  db 0x00, 0x00                                ; 0D896
  db 0x00, 0x00                                ; 0D898
  db 0x00, 0x00                                ; 0D89A
  db 0x00, 0x00                                ; 0D89C
  db 0x00, 0x00                                ; 0D89E
  db 0x00, 0x00                                ; 0D8A0
  db 0x00, 0x00                                ; 0D8A2
  db 0x00, 0x00                                ; 0D8A4
  db 0x00, 0x00                                ; 0D8A6
  db 0x00, 0x00                                ; 0D8A8
  db 0x00, 0x00                                ; 0D8AA
  db 0x00, 0x00                                ; 0D8AC
  db 0x00, 0x00                                ; 0D8AE
  db 0x00, 0x00                                ; 0D8B0
  db 0x00, 0x00                                ; 0D8B2
  db 0x00, 0x00                                ; 0D8B4
  db 0x00, 0x00                                ; 0D8B6
  db 0x00, 0x00                                ; 0D8B8
  db 0xEA, 0x6C, 0x00, 0x00, 0x00              ; 0D8BA  jmp far 0:0x6c
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0D8BF  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0D8CF  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0D8DF  ...........
  db 0x1A, 0x6D, 0x00                          ; 0D8EA  sbb ch, byte [di]
  db 0x00, 0x00                                ; 0D8ED
  db 0x00, 0x00                                ; 0D8EF
  db 0x00, 0x00                                ; 0D8F1
  db 0x00, 0x00                                ; 0D8F3
  db 0x00, 0x00                                ; 0D8F5
  db 0x00, 0x00                                ; 0D8F7
  db 0x00, 0x00                                ; 0D8F9
  db 0x00, 0x00                                ; 0D8FB
  db 0x00, 0x00                                ; 0D8FD
  db 0x00, 0x00                                ; 0D8FF
  db 0x00, 0x00                                ; 0D901
  db 0x00, 0x00                                ; 0D903
  db 0x00, 0x00                                ; 0D905
  db 0x00, 0x00                                ; 0D907
  db 0x00, 0x00                                ; 0D909
  db 0x00, 0x00                                ; 0D90B
  db 0x00, 0x00                                ; 0D90D
  db 0x00, 0x00                                ; 0D90F
  db 0x00, 0x00                                ; 0D911
  db 0x00, 0x00                                ; 0D913
  db 0x00, 0x00                                ; 0D915
  db 0x00, 0x00                                ; 0D917
  add [bp + si + 0x6d], cl                     ; 0D919  0x00, 0x4A, 0x6D
  db 0x00, 0x00                                ; 0D91C
  db 0x00, 0x00                                ; 0D91E
  db 0x00, 0x00                                ; 0D920
  db 0x00, 0x00                                ; 0D922
  db 0x00, 0x00                                ; 0D924
  db 0x00, 0x00                                ; 0D926
  db 0x00, 0x00                                ; 0D928
  db 0x00, 0x00                                ; 0D92A
  db 0x00, 0x00                                ; 0D92C
  db 0x00, 0x00                                ; 0D92E
  db 0x00, 0x00                                ; 0D930
  db 0x00, 0x00                                ; 0D932
  db 0x00, 0x00                                ; 0D934
  db 0x00, 0x00                                ; 0D936
  db 0x00, 0x00                                ; 0D938
  db 0x00, 0x00                                ; 0D93A
  db 0x00, 0x00                                ; 0D93C
  db 0x00, 0x00                                ; 0D93E
  db 0x00, 0x00                                ; 0D940
  db 0x00, 0x00                                ; 0D942
  db 0x00, 0x00                                ; 0D944
  db 0x00, 0x00                                ; 0D946
  db 0x00, 0x00                                ; 0D948
  jp loc_0D9B9                                 ; 0D94A  0x7A, 0x6D
  db 0x00, 0x00                                ; 0D94C
  db 0x00, 0x00                                ; 0D94E
  db 0x00, 0x00                                ; 0D950
  db 0x00, 0x00                                ; 0D952
  db 0x00, 0x00                                ; 0D954
  db 0x00, 0x00                                ; 0D956
  db 0x00, 0x00                                ; 0D958
  db 0x00, 0x00                                ; 0D95A
  db 0x00, 0x00                                ; 0D95C
  db 0x00, 0x00                                ; 0D95E
  db 0x00, 0x00                                ; 0D960
  db 0x00, 0x00                                ; 0D962
  db 0x00, 0x00                                ; 0D964
  db 0x00, 0x00                                ; 0D966
  db 0x00, 0x00                                ; 0D968
  db 0x00, 0x00                                ; 0D96A
  db 0x00, 0x00                                ; 0D96C
  db 0x00, 0x00                                ; 0D96E
  db 0x00, 0x00                                ; 0D970
  db 0x00, 0x00                                ; 0D972
  db 0x00, 0x00                                ; 0D974
  db 0x00, 0x00                                ; 0D976
  db 0x00, 0x00                                ; 0D978
  stosb                                        ; 0D97A  0xAA
  db 0x6D                                      ; 0D97B  insw
  db 0x00, 0x00                                ; 0D97C
  db 0x00, 0x00                                ; 0D97E
  db 0x00, 0x00                                ; 0D980
  db 0x00, 0x00                                ; 0D982
  db 0x00, 0x00                                ; 0D984
  db 0x00, 0x00                                ; 0D986
  db 0x00, 0x00                                ; 0D988
  db 0x00, 0x00                                ; 0D98A
  db 0x00, 0x00                                ; 0D98C
  db 0x00, 0x00                                ; 0D98E
  db 0x00, 0x00                                ; 0D990
  db 0x00, 0x00                                ; 0D992
  db 0x00, 0x00                                ; 0D994
  db 0x00, 0x00                                ; 0D996
  db 0x00, 0x00                                ; 0D998
  db 0x00, 0x00                                ; 0D99A
  db 0x00, 0x00                                ; 0D99C
  db 0x00, 0x00                                ; 0D99E
  db 0x00, 0x00                                ; 0D9A0
  db 0x00, 0x00                                ; 0D9A2
  db 0x00, 0x00                                ; 0D9A4
  db 0x00, 0x00                                ; 0D9A6
  db 0x00, 0x00                                ; 0D9A8
  db 0xDA, 0x6D, 0x00                          ; 0D9AA  fisubr dword [di]
  db 0x00, 0x00                                ; 0D9AD
  db 0x00, 0x00                                ; 0D9AF
  db 0x00, 0x00                                ; 0D9B1
  db 0x00, 0x00                                ; 0D9B3
  db 0x00, 0x00                                ; 0D9B5
  db 0x00, 0x00                                ; 0D9B7

loc_0D9B9:                                     ; 0D9B9
  db 0x00, 0x00                                ; 0D9B9
  db 0x00, 0x00                                ; 0D9BB
  db 0x00, 0x00                                ; 0D9BD
  db 0x00, 0x00                                ; 0D9BF
  db 0x00, 0x00                                ; 0D9C1
  db 0x00, 0x00                                ; 0D9C3
  db 0x00, 0x00                                ; 0D9C5
  db 0x00, 0x00                                ; 0D9C7
  db 0x00, 0x00                                ; 0D9C9
  db 0x00, 0x00                                ; 0D9CB
  db 0x00, 0x00                                ; 0D9CD
  db 0x00, 0x00                                ; 0D9CF
  db 0x00, 0x00                                ; 0D9D1
  db 0x00, 0x00                                ; 0D9D3
  db 0x00, 0x00                                ; 0D9D5
  db 0x00, 0x00                                ; 0D9D7
  add [bp + si], cl                            ; 0D9D9  0x00, 0x0A
  db 0x6E                                      ; 0D9DB  outsb
  db 0x00, 0x00                                ; 0D9DC
  db 0x00, 0x00                                ; 0D9DE
  db 0x00, 0x00                                ; 0D9E0
  db 0x00, 0x00                                ; 0D9E2
  db 0x00, 0x00                                ; 0D9E4
  db 0x00, 0x00                                ; 0D9E6
  db 0x00, 0x00                                ; 0D9E8
  db 0x00, 0x00                                ; 0D9EA
  db 0x00, 0x00                                ; 0D9EC
  db 0x00, 0x00                                ; 0D9EE
  db 0x00, 0x00                                ; 0D9F0
  db 0x00, 0x00                                ; 0D9F2
  db 0x00, 0x00                                ; 0D9F4
  db 0x00, 0x00                                ; 0D9F6
  db 0x00, 0x00                                ; 0D9F8
  db 0x00, 0x00                                ; 0D9FA
  db 0x00, 0x00                                ; 0D9FC
  db 0x00, 0x00                                ; 0D9FE
  db 0x00, 0x00                                ; 0DA00
  db 0x00, 0x00                                ; 0DA02
  db 0x00, 0x00                                ; 0DA04
  db 0x00, 0x00                                ; 0DA06
  db 0x00, 0x00                                ; 0DA08
  cmp ch, [bp]                                 ; 0DA0A  0x3A, 0x6E, 0x00
  db 0x00, 0x00                                ; 0DA0D
  db 0x00, 0x00                                ; 0DA0F
  db 0x00, 0x00                                ; 0DA11
  db 0x00, 0x00                                ; 0DA13
  db 0x00, 0x00                                ; 0DA15
  db 0x00, 0x00                                ; 0DA17
  db 0x00, 0x00                                ; 0DA19
  db 0x00, 0x00                                ; 0DA1B
  db 0x00, 0x00                                ; 0DA1D
  db 0x00, 0x00                                ; 0DA1F
  db 0x00, 0x00                                ; 0DA21
  db 0x00, 0x00                                ; 0DA23
  db 0x00, 0x00                                ; 0DA25
  db 0x00, 0x00                                ; 0DA27
  db 0x00, 0x00                                ; 0DA29
  db 0x00, 0x00                                ; 0DA2B
  db 0x00, 0x00                                ; 0DA2D
  db 0x00, 0x00                                ; 0DA2F
  db 0x00, 0x00                                ; 0DA31
  db 0x00, 0x00                                ; 0DA33
  db 0x00, 0x00                                ; 0DA35
  db 0x00, 0x00                                ; 0DA37
  add [bp + si + 0x6e], ch                     ; 0DA39  0x00, 0x6A, 0x6E
  db 0x00, 0x00                                ; 0DA3C
  db 0x00, 0x00                                ; 0DA3E
  db 0x00, 0x00                                ; 0DA40
  db 0x00, 0x00                                ; 0DA42
  db 0x00, 0x00                                ; 0DA44
  db 0x00, 0x00                                ; 0DA46
  db 0x00, 0x00                                ; 0DA48
  db 0x00, 0x00                                ; 0DA4A
  db 0x00, 0x00                                ; 0DA4C
  db 0x00, 0x00                                ; 0DA4E
  db 0x00, 0x00                                ; 0DA50
  db 0x00, 0x00                                ; 0DA52
  db 0x00, 0x00                                ; 0DA54
  db 0x00, 0x00                                ; 0DA56
  db 0x00, 0x00                                ; 0DA58
  db 0x00, 0x00                                ; 0DA5A
  db 0x00, 0x00                                ; 0DA5C
  db 0x00, 0x00                                ; 0DA5E
  db 0x00, 0x00                                ; 0DA60
  db 0x00, 0x00                                ; 0DA62
  db 0x00, 0x00                                ; 0DA64
  db 0x00, 0x00                                ; 0DA66
  db 0x00, 0x00                                ; 0DA68
  db 0x9A, 0x6E, 0x00, 0x00, 0x00              ; 0DA6A  call far 0, 0x6e
  db 0x00, 0x00                                ; 0DA6F
  db 0x00, 0x00                                ; 0DA71
  db 0x00, 0x00                                ; 0DA73
  db 0x00, 0x00                                ; 0DA75
  db 0x00, 0x00                                ; 0DA77
  db 0x00, 0x00                                ; 0DA79
  db 0x00, 0x00                                ; 0DA7B
  db 0x00, 0x00                                ; 0DA7D
  db 0x00, 0x00                                ; 0DA7F
  db 0x00, 0x00                                ; 0DA81
  db 0x00, 0x00                                ; 0DA83
  db 0x00, 0x00                                ; 0DA85
  db 0x00, 0x00                                ; 0DA87
  db 0x00, 0x00                                ; 0DA89
  db 0x00, 0x00                                ; 0DA8B
  db 0x00, 0x00                                ; 0DA8D
  db 0x00, 0x00                                ; 0DA8F
  db 0x00, 0x00                                ; 0DA91
  db 0x00, 0x00                                ; 0DA93
  db 0x00, 0x00                                ; 0DA95
  db 0x00, 0x00                                ; 0DA97
  add dl, cl                                   ; 0DA99  0x00, 0xCA
  db 0x6E                                      ; 0DA9B  outsb
  db 0x00, 0x00                                ; 0DA9C
  db 0x00, 0x00                                ; 0DA9E
  db 0x00, 0x00                                ; 0DAA0
  db 0x00, 0x00                                ; 0DAA2
  db 0x00, 0x00                                ; 0DAA4
  db 0x00, 0x00                                ; 0DAA6
  db 0x00, 0x00                                ; 0DAA8
  db 0x00, 0x00                                ; 0DAAA
  db 0x00, 0x00                                ; 0DAAC
  db 0x00, 0x00                                ; 0DAAE
  db 0x00, 0x00                                ; 0DAB0
  db 0x00, 0x00                                ; 0DAB2
  db 0x00, 0x00                                ; 0DAB4
  db 0x00, 0x00                                ; 0DAB6
  db 0x00, 0x00                                ; 0DAB8
  db 0x00, 0x00                                ; 0DABA
  db 0x00, 0x00                                ; 0DABC
  db 0x00, 0x00                                ; 0DABE
  db 0x00, 0x00                                ; 0DAC0
  db 0x00, 0x00                                ; 0DAC2
  db 0x00, 0x00                                ; 0DAC4
  db 0x00, 0x00                                ; 0DAC6
  db 0x00, 0x00                                ; 0DAC8
  cli                                          ; 0DACA  0xFA
  db 0x6E                                      ; 0DACB  outsb
  db 0x00, 0x00                                ; 0DACC
  db 0x00, 0x00                                ; 0DACE
  db 0x00, 0x00                                ; 0DAD0
  db 0x00, 0x00                                ; 0DAD2
  db 0x00, 0x00                                ; 0DAD4
  db 0x00, 0x00                                ; 0DAD6
  db 0x00, 0x00                                ; 0DAD8
  db 0x00, 0x00                                ; 0DADA
  db 0x00, 0x00                                ; 0DADC
  db 0x00, 0x00                                ; 0DADE
  db 0x00, 0x00                                ; 0DAE0
  db 0x00, 0x00                                ; 0DAE2
  db 0x00, 0x00                                ; 0DAE4
  db 0x00, 0x00                                ; 0DAE6
  db 0x00, 0x00                                ; 0DAE8
  db 0x00, 0x00                                ; 0DAEA
  db 0x00, 0x00                                ; 0DAEC
  db 0x00, 0x00                                ; 0DAEE
  db 0x00, 0x00                                ; 0DAF0
  db 0x00, 0x00                                ; 0DAF2
  db 0x00, 0x00                                ; 0DAF4
  db 0x00, 0x00                                ; 0DAF6
  db 0x00, 0x00                                ; 0DAF8
  db 0x2A, 0x6F, 0x00                          ; 0DAFA  sub ch, byte [bx]
  db 0x00, 0x00                                ; 0DAFD
  db 0x00, 0x00                                ; 0DAFF
  db 0x00, 0x00                                ; 0DB01
  db 0x00, 0x00                                ; 0DB03
  db 0x00, 0x00                                ; 0DB05
  db 0x00, 0x00                                ; 0DB07
  db 0x00, 0x00                                ; 0DB09
  db 0x00, 0x00                                ; 0DB0B
  db 0x00, 0x00                                ; 0DB0D
  db 0x00, 0x00                                ; 0DB0F
  db 0x00, 0x00                                ; 0DB11
  db 0x00, 0x00                                ; 0DB13
  db 0x00, 0x00                                ; 0DB15
  db 0x00, 0x00                                ; 0DB17
  db 0x00, 0x00                                ; 0DB19
  db 0x00, 0x00                                ; 0DB1B
  db 0x00, 0x00                                ; 0DB1D
  db 0x00, 0x00                                ; 0DB1F
  db 0x00, 0x00                                ; 0DB21
  db 0x00, 0x00                                ; 0DB23
  db 0x00, 0x00                                ; 0DB25
  db 0x00, 0x00                                ; 0DB27
  add [bp + si + 0x6f], bl                     ; 0DB29  0x00, 0x5A, 0x6F
  db 0x00, 0x00                                ; 0DB2C
  db 0x00, 0x00                                ; 0DB2E
  db 0x00, 0x00                                ; 0DB30
  db 0x00, 0x00                                ; 0DB32
  db 0x00, 0x00                                ; 0DB34
  db 0x00, 0x00                                ; 0DB36
  db 0x00, 0x00                                ; 0DB38
  db 0x00, 0x00                                ; 0DB3A
  db 0x00, 0x00                                ; 0DB3C
  db 0x00, 0x00                                ; 0DB3E
  db 0x00, 0x00                                ; 0DB40
  db 0x00, 0x00                                ; 0DB42
  db 0x00, 0x00                                ; 0DB44
  db 0x00, 0x00                                ; 0DB46
  db 0x00, 0x00                                ; 0DB48
  db 0x00, 0x00                                ; 0DB4A
  db 0x00, 0x00                                ; 0DB4C
  db 0x00, 0x00                                ; 0DB4E
  db 0x00, 0x00                                ; 0DB50
  db 0x00, 0x00                                ; 0DB52
  db 0x00, 0x00                                ; 0DB54
  db 0x00, 0x00                                ; 0DB56
  db 0x00, 0x00                                ; 0DB58
  db 0x8A, 0x6F, 0x00                          ; 0DB5A  mov ch, byte [bx]
  db 0x00, 0x00                                ; 0DB5D
  db 0x00, 0x00                                ; 0DB5F
  db 0x00, 0x00                                ; 0DB61
  db 0x00, 0x00                                ; 0DB63
  db 0x00, 0x00                                ; 0DB65
  db 0x00, 0x00                                ; 0DB67
  db 0x00, 0x00                                ; 0DB69
  db 0x00, 0x00                                ; 0DB6B
  db 0x00, 0x00                                ; 0DB6D
  db 0x00, 0x00                                ; 0DB6F
  db 0x00, 0x00                                ; 0DB71
  db 0x00, 0x00                                ; 0DB73
  db 0x00, 0x00                                ; 0DB75
  db 0x00, 0x00                                ; 0DB77
  db 0x00, 0x00                                ; 0DB79
  db 0x00, 0x00                                ; 0DB7B
  db 0x00, 0x00                                ; 0DB7D
  db 0x00, 0x00                                ; 0DB7F
  db 0x00, 0x00                                ; 0DB81
  db 0x00, 0x00                                ; 0DB83
  db 0x00, 0x00                                ; 0DB85
  db 0x00, 0x00                                ; 0DB87
  db 0x00, 0xBA, 0x6F, 0x00                    ; 0DB89  add byte [bp + si + 0x6f], bh
  db 0x00, 0x00                                ; 0DB8D
  db 0x00, 0x00                                ; 0DB8F
  db 0x00, 0x00                                ; 0DB91
  db 0x00, 0x00                                ; 0DB93
  db 0x00, 0x00                                ; 0DB95
  db 0x00, 0x00                                ; 0DB97
  db 0x00, 0x00                                ; 0DB99
  db 0x00, 0x00                                ; 0DB9B
  db 0x00, 0x00                                ; 0DB9D
  db 0x00, 0x00                                ; 0DB9F
  db 0x00, 0x00                                ; 0DBA1
  db 0x00, 0x00                                ; 0DBA3
  db 0x00, 0x00                                ; 0DBA5
  db 0x00, 0x00                                ; 0DBA7
  db 0x00, 0x00                                ; 0DBA9
  db 0x00, 0x00                                ; 0DBAB
  db 0x00, 0x00                                ; 0DBAD
  db 0x00, 0x00                                ; 0DBAF
  db 0x00, 0x00                                ; 0DBB1
  db 0x00, 0x00                                ; 0DBB3
  db 0x00, 0x00                                ; 0DBB5
  db 0x00, 0x00                                ; 0DBB7
  add dl, ch                                   ; 0DBB9  0x00, 0xEA
  db 0x6F                                      ; 0DBBB  outsw
  db 0x00, 0x00                                ; 0DBBC
  db 0x00, 0x00                                ; 0DBBE
  db 0x00, 0x00                                ; 0DBC0
  db 0x00, 0x00                                ; 0DBC2
  db 0x00, 0x00                                ; 0DBC4
  db 0x00, 0x00                                ; 0DBC6
  db 0x00, 0x00                                ; 0DBC8
  db 0x00, 0x00                                ; 0DBCA
  db 0x00, 0x00                                ; 0DBCC
  db 0x00, 0x00                                ; 0DBCE
  db 0x00, 0x00                                ; 0DBD0
  db 0x00, 0x00                                ; 0DBD2
  db 0x00, 0x00                                ; 0DBD4
  db 0x00, 0x00                                ; 0DBD6
  db 0x00, 0x00                                ; 0DBD8
  db 0x00, 0x00                                ; 0DBDA
  db 0x00, 0x00                                ; 0DBDC
  db 0x00, 0x00                                ; 0DBDE
  db 0x00, 0x00                                ; 0DBE0
  db 0x00, 0x00                                ; 0DBE2
  db 0x00, 0x00                                ; 0DBE4
  db 0x00, 0x00                                ; 0DBE6
  db 0x00, 0x00                                ; 0DBE8
  db 0x1A, 0x70, 0x00                          ; 0DBEA  sbb dh, byte [bx + si]
  db 0x00, 0x00                                ; 0DBED
  db 0x00, 0x00                                ; 0DBEF
  db 0x00, 0x00                                ; 0DBF1
  db 0x00, 0x00                                ; 0DBF3
  db 0x00, 0x00                                ; 0DBF5
  db 0x00, 0x00                                ; 0DBF7
  db 0x00, 0x00                                ; 0DBF9
  db 0x00, 0x00                                ; 0DBFB
  db 0x00, 0x00                                ; 0DBFD
  db 0x00, 0x00                                ; 0DBFF
  db 0x00, 0x00                                ; 0DC01
  db 0x00, 0x00                                ; 0DC03
  db 0x00, 0x00                                ; 0DC05
  db 0x00, 0x00                                ; 0DC07
  db 0x00, 0x00                                ; 0DC09
  db 0x00, 0x00                                ; 0DC0B
  db 0x00, 0x00                                ; 0DC0D
  db 0x00, 0x00                                ; 0DC0F
  db 0x00, 0x00                                ; 0DC11
  db 0x00, 0x00                                ; 0DC13
  db 0x00, 0x00                                ; 0DC15
  db 0x00, 0x00                                ; 0DC17
  add [bp + si + 0x70], cl                     ; 0DC19  0x00, 0x4A, 0x70
  db 0x00, 0x00                                ; 0DC1C
  db 0x00, 0x00                                ; 0DC1E
  db 0x00, 0x00                                ; 0DC20
  db 0x00, 0x00                                ; 0DC22
  db 0x00, 0x00                                ; 0DC24
  db 0x00, 0x00                                ; 0DC26
  db 0x00, 0x00                                ; 0DC28
  db 0x00, 0x00                                ; 0DC2A
  db 0x00, 0x00                                ; 0DC2C
  db 0x00, 0x00                                ; 0DC2E
  db 0x00, 0x00                                ; 0DC30
  db 0x00, 0x00                                ; 0DC32
  db 0x00, 0x00                                ; 0DC34
  db 0x00, 0x00                                ; 0DC36
  db 0x00, 0x00                                ; 0DC38
  db 0x00, 0x00                                ; 0DC3A
  db 0x00, 0x00                                ; 0DC3C
  db 0x00, 0x00                                ; 0DC3E
  db 0x00, 0x00                                ; 0DC40
  db 0x00, 0x00                                ; 0DC42
  db 0x00, 0x00                                ; 0DC44
  db 0x00, 0x00                                ; 0DC46
  db 0x00, 0x00                                ; 0DC48
  db 0x7A, 0x70                                ; 0DC4A  jp 0xdcbc
  db 0x00, 0x00                                ; 0DC4C
  db 0x00, 0x00                                ; 0DC4E
  db 0x00, 0x00                                ; 0DC50
  db 0x00, 0x00                                ; 0DC52
  db 0x00, 0x00                                ; 0DC54
  db 0x00, 0x00                                ; 0DC56
  db 0x00, 0x00                                ; 0DC58
  db 0x00, 0x00                                ; 0DC5A
  db 0x00, 0x00                                ; 0DC5C
  db 0x00, 0x00                                ; 0DC5E
  db 0x00, 0x00                                ; 0DC60
  db 0x00, 0x00                                ; 0DC62
  db 0x00, 0x00                                ; 0DC64
  db 0x00, 0x00                                ; 0DC66
  db 0x00, 0x00                                ; 0DC68
  db 0x00, 0x00                                ; 0DC6A
  db 0x00, 0x00                                ; 0DC6C
  db 0x00, 0x00                                ; 0DC6E
  db 0x00, 0x00                                ; 0DC70
  db 0x00, 0x00                                ; 0DC72
  db 0x00, 0x00                                ; 0DC74
  db 0x00, 0x00                                ; 0DC76
  db 0x00, 0x00                                ; 0DC78
  stosb                                        ; 0DC7A  0xAA
  jo loc_0DC7D                                 ; 0DC7B  0x70, 0x00

loc_0DC7D:                                     ; 0DC7D
  db 0x00, 0x00                                ; 0DC7D
  db 0x00, 0x00                                ; 0DC7F
  db 0x00, 0x00                                ; 0DC81
  db 0x00, 0x00                                ; 0DC83
  db 0x00, 0x00                                ; 0DC85
  db 0x00, 0x00                                ; 0DC87
  db 0x00, 0x00                                ; 0DC89
  db 0x00, 0x00                                ; 0DC8B
  db 0x00, 0x00                                ; 0DC8D
  db 0x00, 0x00                                ; 0DC8F
  db 0x00, 0x00                                ; 0DC91
  db 0x00, 0x00                                ; 0DC93
  db 0x00, 0x00                                ; 0DC95
  db 0x00, 0x00                                ; 0DC97
  db 0x00, 0x00                                ; 0DC99
  db 0x00, 0x00                                ; 0DC9B
  db 0x00, 0x00                                ; 0DC9D
  db 0x00, 0x00                                ; 0DC9F
  db 0x00, 0x00                                ; 0DCA1
  db 0x00, 0x00                                ; 0DCA3
  db 0x00, 0x00                                ; 0DCA5
  db 0x00, 0x00                                ; 0DCA7
  add dl, bl                                   ; 0DCA9  0x00, 0xDA
  jo loc_0DCAD                                 ; 0DCAB  0x70, 0x00

loc_0DCAD:                                     ; 0DCAD
  db 0x00, 0x00                                ; 0DCAD
  db 0x00, 0x00                                ; 0DCAF
  db 0x00, 0x00                                ; 0DCB1
  db 0x00, 0x00                                ; 0DCB3
  db 0x00, 0x00                                ; 0DCB5
  db 0x00, 0x00                                ; 0DCB7
  db 0x00, 0x00                                ; 0DCB9
  db 0x00, 0x00                                ; 0DCBB
  db 0x00, 0x00                                ; 0DCBD
  db 0x00, 0x00                                ; 0DCBF
  db 0x00, 0x00                                ; 0DCC1
  db 0x00, 0x00                                ; 0DCC3
  db 0x00, 0x00                                ; 0DCC5
  db 0x00, 0x00                                ; 0DCC7
  db 0x00, 0x00                                ; 0DCC9
  db 0x00, 0x00                                ; 0DCCB
  db 0x00, 0x00                                ; 0DCCD
  db 0x00, 0x00                                ; 0DCCF
  db 0x00, 0x00                                ; 0DCD1
  db 0x00, 0x00                                ; 0DCD3
  db 0x00, 0x00                                ; 0DCD5
  db 0x00, 0x00                                ; 0DCD7
  add [bp + si], cl                            ; 0DCD9  0x00, 0x0A
  jno loc_0DCDD                                ; 0DCDB  0x71, 0x00

loc_0DCDD:                                     ; 0DCDD
  db 0x00, 0x00                                ; 0DCDD
  db 0x00, 0x00                                ; 0DCDF
  db 0x00, 0x00                                ; 0DCE1
  db 0x00, 0x00                                ; 0DCE3
  db 0x00, 0x00                                ; 0DCE5
  db 0x00, 0x00                                ; 0DCE7
  db 0x00, 0x00                                ; 0DCE9
  db 0x00, 0x00                                ; 0DCEB
  db 0x00, 0x00                                ; 0DCED
  db 0x00, 0x00                                ; 0DCEF
  db 0x00, 0x00                                ; 0DCF1
  db 0x00, 0x00                                ; 0DCF3
  db 0x00, 0x00                                ; 0DCF5
  db 0x00, 0x00                                ; 0DCF7
  db 0x00, 0x00                                ; 0DCF9
  db 0x00, 0x00                                ; 0DCFB
  db 0x00, 0x00                                ; 0DCFD
  db 0x00, 0x00                                ; 0DCFF
  db 0x00, 0x00                                ; 0DD01
  db 0x00, 0x00                                ; 0DD03
  db 0x00, 0x00                                ; 0DD05
  db 0x00, 0x00                                ; 0DD07
  add [bp + si], bh                            ; 0DD09  0x00, 0x3A
  jno loc_0DD0D                                ; 0DD0B  0x71, 0x00

loc_0DD0D:                                     ; 0DD0D
  db 0x00, 0x00                                ; 0DD0D
  db 0x00, 0x00                                ; 0DD0F
  db 0x00, 0x00                                ; 0DD11
  db 0x00, 0x00                                ; 0DD13
  db 0x00, 0x00                                ; 0DD15
  db 0x00, 0x00                                ; 0DD17
  db 0x00, 0x00                                ; 0DD19
  db 0x00, 0x00                                ; 0DD1B
  db 0x00, 0x00                                ; 0DD1D
  db 0x00, 0x00                                ; 0DD1F
  db 0x00, 0x00                                ; 0DD21
  db 0x00, 0x00                                ; 0DD23
  db 0x00, 0x00                                ; 0DD25
  db 0x00, 0x00                                ; 0DD27
  db 0x00, 0x00                                ; 0DD29
  db 0x00, 0x00                                ; 0DD2B
  db 0x00, 0x00                                ; 0DD2D
  db 0x00, 0x00                                ; 0DD2F
  db 0x00, 0x00                                ; 0DD31
  db 0x00, 0x00                                ; 0DD33
  db 0x00, 0x00                                ; 0DD35
  db 0x00, 0x00                                ; 0DD37
  add [bp + si + 0x71], ch                     ; 0DD39  0x00, 0x6A, 0x71
  db 0x00, 0x00                                ; 0DD3C
  db 0x00, 0x00                                ; 0DD3E
  db 0x00, 0x00                                ; 0DD40
  db 0x00, 0x00                                ; 0DD42
  db 0x00, 0x00                                ; 0DD44
  db 0x00, 0x00                                ; 0DD46
  db 0x00, 0x00                                ; 0DD48
  db 0x00, 0x00                                ; 0DD4A
  db 0x00, 0x00                                ; 0DD4C
  db 0x00, 0x00                                ; 0DD4E
  db 0x00, 0x00                                ; 0DD50
  db 0x00, 0x00                                ; 0DD52
  db 0x00, 0x00                                ; 0DD54
  db 0x00, 0x00                                ; 0DD56
  db 0x00, 0x00                                ; 0DD58
  db 0x00, 0x00                                ; 0DD5A
  db 0x00, 0x00                                ; 0DD5C
  db 0x00, 0x00                                ; 0DD5E
  db 0x00, 0x00                                ; 0DD60
  db 0x00, 0x00                                ; 0DD62
  db 0x00, 0x00                                ; 0DD64
  db 0x00, 0x00                                ; 0DD66
  db 0x00, 0x00                                ; 0DD68
  db 0x9A, 0x71, 0x00, 0x00, 0x00              ; 0DD6A  call far 0, 0x71
  db 0x00, 0x00                                ; 0DD6F
  db 0x00, 0x00                                ; 0DD71
  db 0x00, 0x00                                ; 0DD73
  db 0x00, 0x00                                ; 0DD75
  db 0x00, 0x00                                ; 0DD77
  db 0x00, 0x00                                ; 0DD79
  db 0x00, 0x00                                ; 0DD7B
  db 0x00, 0x00                                ; 0DD7D
  db 0x00, 0x00                                ; 0DD7F
  db 0x00, 0x00                                ; 0DD81
  db 0x00, 0x00                                ; 0DD83
  db 0x00, 0x00                                ; 0DD85
  db 0x00, 0x00                                ; 0DD87
  db 0x00, 0x00                                ; 0DD89
  db 0x00, 0x00                                ; 0DD8B
  db 0x00, 0x00                                ; 0DD8D
  db 0x00, 0x00                                ; 0DD8F
  db 0x00, 0x00                                ; 0DD91
  db 0x00, 0x00                                ; 0DD93
  db 0x00, 0x00                                ; 0DD95
  db 0x00, 0x00                                ; 0DD97
  add dl, cl                                   ; 0DD99  0x00, 0xCA
  jno loc_0DD9D                                ; 0DD9B  0x71, 0x00

loc_0DD9D:                                     ; 0DD9D
  db 0x00, 0x00                                ; 0DD9D
  db 0x00, 0x00                                ; 0DD9F
  db 0x00, 0x00                                ; 0DDA1
  db 0x00, 0x00                                ; 0DDA3
  db 0x00, 0x00                                ; 0DDA5
  db 0x00, 0x00                                ; 0DDA7
  db 0x00, 0x00                                ; 0DDA9
  db 0x00, 0x00                                ; 0DDAB
  db 0x00, 0x00                                ; 0DDAD
  db 0x00, 0x00                                ; 0DDAF
  db 0x00, 0x00                                ; 0DDB1
  db 0x00, 0x00                                ; 0DDB3
  db 0x00, 0x00                                ; 0DDB5
  db 0x00, 0x00                                ; 0DDB7
  db 0x00, 0x00                                ; 0DDB9
  db 0x00, 0x00                                ; 0DDBB
  db 0x00, 0x00                                ; 0DDBD
  db 0x00, 0x00                                ; 0DDBF
  db 0x00, 0x00                                ; 0DDC1
  db 0x00, 0x00                                ; 0DDC3
  db 0x00, 0x00                                ; 0DDC5
  db 0x00, 0x00                                ; 0DDC7
  add dl, bh                                   ; 0DDC9  0x00, 0xFA
  jno loc_0DDCD                                ; 0DDCB  0x71, 0x00

loc_0DDCD:                                     ; 0DDCD
  db 0x00, 0x00                                ; 0DDCD
  db 0x00, 0x00                                ; 0DDCF
  db 0x00, 0x00                                ; 0DDD1
  db 0x00, 0x00                                ; 0DDD3
  db 0x00, 0x00                                ; 0DDD5
  db 0x00, 0x00                                ; 0DDD7
  db 0x00, 0x00                                ; 0DDD9
  db 0x00, 0x00                                ; 0DDDB
  db 0x00, 0x00                                ; 0DDDD
  db 0x00, 0x00                                ; 0DDDF
  db 0x00, 0x00                                ; 0DDE1
  db 0x00, 0x00                                ; 0DDE3
  db 0x00, 0x00                                ; 0DDE5
  db 0x00, 0x00                                ; 0DDE7
  db 0x00, 0x00                                ; 0DDE9
  db 0x00, 0x00                                ; 0DDEB
  db 0x00, 0x00                                ; 0DDED
  db 0x00, 0x00                                ; 0DDEF
  db 0x00, 0x00                                ; 0DDF1
  db 0x00, 0x00                                ; 0DDF3
  db 0x00, 0x00                                ; 0DDF5
  db 0x00, 0x00                                ; 0DDF7
  add [bp + si], ch                            ; 0DDF9  0x00, 0x2A
  jb loc_0DDFD                                 ; 0DDFB  0x72, 0x00

loc_0DDFD:                                     ; 0DDFD
  db 0x00, 0x00                                ; 0DDFD
  db 0x00, 0x00                                ; 0DDFF
  db 0x00, 0x00                                ; 0DE01
  db 0x00, 0x00                                ; 0DE03
  db 0x00, 0x00                                ; 0DE05
  db 0x00, 0x00                                ; 0DE07
  db 0x00, 0x00                                ; 0DE09
  db 0x00, 0x00                                ; 0DE0B
  db 0x00, 0x00                                ; 0DE0D
  db 0x00, 0x00                                ; 0DE0F
  db 0x00, 0x00                                ; 0DE11
  db 0x00, 0x00                                ; 0DE13
  db 0x00, 0x00                                ; 0DE15
  db 0x00, 0x00                                ; 0DE17
  db 0x00, 0x00                                ; 0DE19
  db 0x00, 0x00                                ; 0DE1B
  db 0x00, 0x00                                ; 0DE1D
  db 0x00, 0x00                                ; 0DE1F
  db 0x00, 0x00                                ; 0DE21
  db 0x00, 0x00                                ; 0DE23
  db 0x00, 0x00                                ; 0DE25
  db 0x00, 0x00                                ; 0DE27
  add [bp + si + 0x72], bl                     ; 0DE29  0x00, 0x5A, 0x72
  db 0x00, 0x00                                ; 0DE2C
  db 0x00, 0x00                                ; 0DE2E
  db 0x00, 0x00                                ; 0DE30
  db 0x00, 0x00                                ; 0DE32
  db 0x00, 0x00                                ; 0DE34
  db 0x00, 0x00                                ; 0DE36
  db 0x00, 0x00                                ; 0DE38
  db 0x00, 0x00                                ; 0DE3A
  db 0x00, 0x00                                ; 0DE3C
  db 0x00, 0x00                                ; 0DE3E
  db 0x00, 0x00                                ; 0DE40
  db 0x00, 0x00                                ; 0DE42
  db 0x00, 0x00                                ; 0DE44
  db 0x00, 0x00                                ; 0DE46
  db 0x00, 0x00                                ; 0DE48
  db 0x00, 0x00                                ; 0DE4A
  db 0x00, 0x00                                ; 0DE4C
  db 0x00, 0x00                                ; 0DE4E
  db 0x00, 0x00                                ; 0DE50
  db 0x00, 0x00                                ; 0DE52
  db 0x00, 0x00                                ; 0DE54
  db 0x00, 0x00                                ; 0DE56
  db 0x00, 0x00                                ; 0DE58
  db 0x8A, 0x72, 0x00                          ; 0DE5A  mov dh, byte [bp + si]
  db 0x00, 0x00                                ; 0DE5D
  db 0x00, 0x00                                ; 0DE5F
  db 0x00, 0x00                                ; 0DE61
  db 0x00, 0x00                                ; 0DE63
  db 0x00, 0x00                                ; 0DE65
  db 0x00, 0x00                                ; 0DE67
  db 0x00, 0x00                                ; 0DE69
  db 0x00, 0x00                                ; 0DE6B
  db 0x00, 0x00                                ; 0DE6D
  db 0x00, 0x00                                ; 0DE6F
  db 0x00, 0x00                                ; 0DE71
  db 0x00, 0x00                                ; 0DE73
  db 0x00, 0x00                                ; 0DE75
  db 0x00, 0x00                                ; 0DE77
  db 0x00, 0x00                                ; 0DE79
  db 0x00, 0x00                                ; 0DE7B
  db 0x00, 0x00                                ; 0DE7D
  db 0x00, 0x00                                ; 0DE7F
  db 0x00, 0x00                                ; 0DE81
  db 0x00, 0x00                                ; 0DE83
  db 0x00, 0x00                                ; 0DE85
  db 0x00, 0x00                                ; 0DE87
  db 0x00, 0xBA, 0x72, 0x00                    ; 0DE89  add byte [bp + si + 0x72], bh
  db 0x00, 0x00                                ; 0DE8D
  db 0x00, 0x00                                ; 0DE8F
  db 0x00, 0x00                                ; 0DE91
  db 0x00, 0x00                                ; 0DE93
  db 0x00, 0x00                                ; 0DE95
  db 0x00, 0x00                                ; 0DE97
  db 0x00, 0x00                                ; 0DE99
  db 0x00, 0x00                                ; 0DE9B
  db 0x00, 0x00                                ; 0DE9D
  db 0x00, 0x00                                ; 0DE9F
  db 0x00, 0x00                                ; 0DEA1
  db 0x00, 0x00                                ; 0DEA3
  db 0x00, 0x00                                ; 0DEA5
  db 0x00, 0x00                                ; 0DEA7
  db 0x00, 0x00                                ; 0DEA9
  db 0x00, 0x00                                ; 0DEAB
  db 0x00, 0x00                                ; 0DEAD
  db 0x00, 0x00                                ; 0DEAF
  db 0x00, 0x00                                ; 0DEB1
  db 0x00, 0x00                                ; 0DEB3
  db 0x00, 0x00                                ; 0DEB5
  db 0x00, 0x00                                ; 0DEB7
  add dl, ch                                   ; 0DEB9  0x00, 0xEA
  jb loc_0DEBD                                 ; 0DEBB  0x72, 0x00

loc_0DEBD:                                     ; 0DEBD
  db 0x00, 0x00                                ; 0DEBD
  db 0x00, 0x00                                ; 0DEBF
  db 0x00, 0x00                                ; 0DEC1
  db 0x00, 0x00                                ; 0DEC3
  db 0x00, 0x00                                ; 0DEC5
  db 0x00, 0x00                                ; 0DEC7
  db 0x00, 0x00                                ; 0DEC9
  db 0x00, 0x00                                ; 0DECB
  db 0x00, 0x00                                ; 0DECD
  db 0x00, 0x00                                ; 0DECF
  db 0x00, 0x00                                ; 0DED1
  db 0x00, 0x00                                ; 0DED3
  db 0x00, 0x00                                ; 0DED5
  db 0x00, 0x00                                ; 0DED7
  db 0x00, 0x00                                ; 0DED9
  db 0x00, 0x00                                ; 0DEDB
  db 0x00, 0x00                                ; 0DEDD
  db 0x00, 0x00                                ; 0DEDF
  db 0x00, 0x00                                ; 0DEE1
  db 0x00, 0x00                                ; 0DEE3
  db 0x00, 0x00                                ; 0DEE5
  db 0x00, 0x00                                ; 0DEE7
  add [bp + si], bl                            ; 0DEE9  0x00, 0x1A
  jae loc_0DEED                                ; 0DEEB  0x73, 0x00

loc_0DEED:                                     ; 0DEED
  db 0x00, 0x00                                ; 0DEED
  db 0x00, 0x00                                ; 0DEEF
  db 0x00, 0x00                                ; 0DEF1
  db 0x00, 0x00                                ; 0DEF3
  db 0x00, 0x00                                ; 0DEF5
  db 0x00, 0x00                                ; 0DEF7
  db 0x00, 0x00                                ; 0DEF9
  db 0x00, 0x00                                ; 0DEFB
  db 0x00, 0x00                                ; 0DEFD
  db 0x00, 0x00                                ; 0DEFF
  db 0x00, 0x00                                ; 0DF01
  db 0x00, 0x00                                ; 0DF03
  db 0x00, 0x00                                ; 0DF05
  db 0x00, 0x00                                ; 0DF07
  db 0x00, 0x00                                ; 0DF09
  db 0x00, 0x00                                ; 0DF0B
  db 0x00, 0x00                                ; 0DF0D
  db 0x00, 0x00                                ; 0DF0F
  db 0x00, 0x00                                ; 0DF11
  db 0x00, 0x00                                ; 0DF13
  db 0x00, 0x00                                ; 0DF15
  db 0x00, 0x00                                ; 0DF17
  add [bp + si + 0x73], cl                     ; 0DF19  0x00, 0x4A, 0x73
  db 0x00, 0x00                                ; 0DF1C
  db 0x00, 0x00                                ; 0DF1E
  db 0x00, 0x00                                ; 0DF20
  db 0x00, 0x00                                ; 0DF22
  db 0x00, 0x00                                ; 0DF24
  db 0x00, 0x00                                ; 0DF26
  db 0x00, 0x00                                ; 0DF28
  db 0x00, 0x00                                ; 0DF2A
  db 0x00, 0x00                                ; 0DF2C
  db 0x00, 0x00                                ; 0DF2E
  db 0x00, 0x00                                ; 0DF30
  db 0x00, 0x00                                ; 0DF32
  db 0x00, 0x00                                ; 0DF34
  db 0x00, 0x00                                ; 0DF36
  db 0x00, 0x00                                ; 0DF38
  db 0x00, 0x00                                ; 0DF3A
  db 0x00, 0x00                                ; 0DF3C
  db 0x00, 0x00                                ; 0DF3E
  db 0x00, 0x00                                ; 0DF40
  db 0x00, 0x00                                ; 0DF42
  db 0x00, 0x00                                ; 0DF44
  db 0x00, 0x00                                ; 0DF46
  db 0x00, 0x00                                ; 0DF48
  jp loc_0DFBF                                 ; 0DF4A  0x7A, 0x73
  db 0x00, 0x00                                ; 0DF4C
  db 0x00, 0x00                                ; 0DF4E
  db 0x00, 0x00                                ; 0DF50
  db 0x00, 0x00                                ; 0DF52
  db 0x00, 0x00                                ; 0DF54
  db 0x00, 0x00                                ; 0DF56
  db 0x00, 0x00                                ; 0DF58
  db 0x00, 0x00                                ; 0DF5A
  db 0x00, 0x00                                ; 0DF5C
  db 0x00, 0x00                                ; 0DF5E
  db 0x00, 0x00                                ; 0DF60
  db 0x00, 0x00                                ; 0DF62
  db 0x00, 0x00                                ; 0DF64
  db 0x00, 0x00                                ; 0DF66
  db 0x00, 0x00                                ; 0DF68
  db 0x00, 0x00                                ; 0DF6A
  db 0x00, 0x00                                ; 0DF6C
  db 0x00, 0x00                                ; 0DF6E
  db 0x00, 0x00                                ; 0DF70
  db 0x00, 0x00                                ; 0DF72
  db 0x00, 0x00                                ; 0DF74
  db 0x00, 0x00                                ; 0DF76
  db 0x00, 0x00                                ; 0DF78
  stosb                                        ; 0DF7A  0xAA
  jae loc_0DF7D                                ; 0DF7B  0x73, 0x00

loc_0DF7D:                                     ; 0DF7D
  db 0x00, 0x00                                ; 0DF7D
  db 0x00, 0x00                                ; 0DF7F
  db 0x00, 0x00                                ; 0DF81
  db 0x00, 0x00                                ; 0DF83
  db 0x00, 0x00                                ; 0DF85
  db 0x00, 0x00                                ; 0DF87
  db 0x00, 0x00                                ; 0DF89
  db 0x00, 0x00                                ; 0DF8B
  db 0x00, 0x00                                ; 0DF8D
  db 0x00, 0x00                                ; 0DF8F
  db 0x00, 0x00                                ; 0DF91
  db 0x00, 0x00                                ; 0DF93
  db 0x00, 0x00                                ; 0DF95
  db 0x00, 0x00                                ; 0DF97
  db 0x00, 0x00                                ; 0DF99
  db 0x00, 0x00                                ; 0DF9B
  db 0x00, 0x00                                ; 0DF9D
  db 0x00, 0x00                                ; 0DF9F
  db 0x00, 0x00                                ; 0DFA1
  db 0x00, 0x00                                ; 0DFA3
  db 0x00, 0x00                                ; 0DFA5
  db 0x00, 0x00                                ; 0DFA7
  add dl, bl                                   ; 0DFA9  0x00, 0xDA
  jae loc_0DFAD                                ; 0DFAB  0x73, 0x00

loc_0DFAD:                                     ; 0DFAD
  db 0x00, 0x00                                ; 0DFAD
  db 0x00, 0x00                                ; 0DFAF
  db 0x00, 0x00                                ; 0DFB1
  db 0x00, 0x00                                ; 0DFB3
  db 0x00, 0x00                                ; 0DFB5
  db 0x00, 0x00                                ; 0DFB7
  db 0x00, 0x00                                ; 0DFB9
  db 0x00, 0x00                                ; 0DFBB
  db 0x00, 0x00                                ; 0DFBD

loc_0DFBF:                                     ; 0DFBF
  db 0x00, 0x00                                ; 0DFBF
  db 0x00, 0x00                                ; 0DFC1
  db 0x00, 0x00                                ; 0DFC3
  db 0x00, 0x00                                ; 0DFC5
  db 0x00, 0x00                                ; 0DFC7
  db 0x00, 0x00                                ; 0DFC9
  db 0x00, 0x00                                ; 0DFCB
  db 0x00, 0x00                                ; 0DFCD
  db 0x00, 0x00                                ; 0DFCF
  db 0x00, 0x00                                ; 0DFD1
  db 0x00, 0x00                                ; 0DFD3
  db 0x00, 0x00                                ; 0DFD5
  db 0x00, 0x00                                ; 0DFD7
  add [bp + si], cl                            ; 0DFD9  0x00, 0x0A
  je loc_0DFDD                                 ; 0DFDB  0x74, 0x00

loc_0DFDD:                                     ; 0DFDD
  db 0x00, 0x00                                ; 0DFDD
  db 0x00, 0x00                                ; 0DFDF
  db 0x00, 0x00                                ; 0DFE1
  db 0x00, 0x00                                ; 0DFE3
  db 0x00, 0x00                                ; 0DFE5
  db 0x00, 0x00                                ; 0DFE7
  db 0x00, 0x00                                ; 0DFE9
  db 0x00, 0x00                                ; 0DFEB
  db 0x00, 0x00                                ; 0DFED
  db 0x00, 0x00                                ; 0DFEF
  db 0x00, 0x00                                ; 0DFF1
  db 0x00, 0x00                                ; 0DFF3
  db 0x00, 0x00                                ; 0DFF5
  db 0x00, 0x00                                ; 0DFF7
  db 0x00, 0x00                                ; 0DFF9
  db 0x00, 0x00                                ; 0DFFB
  db 0x00, 0x00                                ; 0DFFD
  db 0x00, 0x00                                ; 0DFFF
  db 0x00, 0x00                                ; 0E001
  db 0x00, 0x00                                ; 0E003
  db 0x00, 0x00                                ; 0E005
  db 0x00, 0x00                                ; 0E007
  add [bp + si], bh                            ; 0E009  0x00, 0x3A
  je loc_0E00D                                 ; 0E00B  0x74, 0x00

loc_0E00D:                                     ; 0E00D
  db 0x00, 0x00                                ; 0E00D
  db 0x00, 0x00                                ; 0E00F
  db 0x00, 0x00                                ; 0E011
  db 0x00, 0x00                                ; 0E013
  db 0x00, 0x00                                ; 0E015
  db 0x00, 0x00                                ; 0E017
  db 0x00, 0x00                                ; 0E019
  db 0x00, 0x00                                ; 0E01B
  db 0x00, 0x00                                ; 0E01D
  db 0x00, 0x00                                ; 0E01F
  db 0x00, 0x00                                ; 0E021
  db 0x00, 0x00                                ; 0E023
  db 0x00, 0x00                                ; 0E025
  db 0x00, 0x00                                ; 0E027
  db 0x00, 0x00                                ; 0E029
  db 0x00, 0x00                                ; 0E02B
  db 0x00, 0x00                                ; 0E02D
  db 0x00, 0x00                                ; 0E02F
  db 0x00, 0x00                                ; 0E031
  db 0x00, 0x00                                ; 0E033
  db 0x00, 0x00                                ; 0E035
  db 0x00, 0x00                                ; 0E037
  add [bp + si + 0x74], ch                     ; 0E039  0x00, 0x6A, 0x74
  db 0x00, 0x00                                ; 0E03C
  db 0x00, 0x00                                ; 0E03E
  db 0x00, 0x00                                ; 0E040
  db 0x00, 0x00                                ; 0E042
  db 0x00, 0x00                                ; 0E044
  db 0x00, 0x00                                ; 0E046
  db 0x00, 0x00                                ; 0E048
  db 0x00, 0x00                                ; 0E04A
  db 0x00, 0x00                                ; 0E04C
  db 0x00, 0x00                                ; 0E04E
  db 0x00, 0x00                                ; 0E050
  db 0x00, 0x00                                ; 0E052
  db 0x00, 0x00                                ; 0E054
  db 0x00, 0x00                                ; 0E056
  db 0x00, 0x00                                ; 0E058
  db 0x00, 0x00                                ; 0E05A
  db 0x00, 0x00                                ; 0E05C
  db 0x00, 0x00                                ; 0E05E
  db 0x00, 0x00                                ; 0E060
  db 0x00, 0x00                                ; 0E062
  db 0x00, 0x00                                ; 0E064
  db 0x00, 0x00                                ; 0E066
  db 0x00, 0x00                                ; 0E068
  db 0x9A, 0x74, 0x00, 0x00, 0x00              ; 0E06A  call far 0, 0x74
  db 0x00, 0x00                                ; 0E06F
  db 0x00, 0x00                                ; 0E071
  db 0x00, 0x00                                ; 0E073
  db 0x00, 0x00                                ; 0E075
  db 0x00, 0x00                                ; 0E077
  db 0x00, 0x00                                ; 0E079
  db 0x00, 0x00                                ; 0E07B
  db 0x00, 0x00                                ; 0E07D
  db 0x00, 0x00                                ; 0E07F
  db 0x00, 0x00                                ; 0E081
  db 0x00, 0x00                                ; 0E083
  db 0x00, 0x00                                ; 0E085
  db 0x00, 0x00                                ; 0E087
  db 0x00, 0x00                                ; 0E089
  db 0x00, 0x00                                ; 0E08B
  db 0x00, 0x00                                ; 0E08D
  db 0x00, 0x00                                ; 0E08F
  db 0x00, 0x00                                ; 0E091
  db 0x00, 0x00                                ; 0E093
  db 0x00, 0x00                                ; 0E095
  db 0x00, 0x00                                ; 0E097
  add dl, cl                                   ; 0E099  0x00, 0xCA
  je loc_0E09D                                 ; 0E09B  0x74, 0x00

loc_0E09D:                                     ; 0E09D
  db 0x00, 0x00                                ; 0E09D
  db 0x00, 0x00                                ; 0E09F
  db 0x00, 0x00                                ; 0E0A1
  db 0x00, 0x00                                ; 0E0A3
  db 0x00, 0x00                                ; 0E0A5
  db 0x00, 0x00                                ; 0E0A7
  db 0x00, 0x00                                ; 0E0A9
  db 0x00, 0x00                                ; 0E0AB
  db 0x00, 0x00                                ; 0E0AD
  db 0x00, 0x00                                ; 0E0AF
  db 0x00, 0x00                                ; 0E0B1
  db 0x00, 0x00                                ; 0E0B3
  db 0x00, 0x00                                ; 0E0B5
  db 0x00, 0x00                                ; 0E0B7
  db 0x00, 0x00                                ; 0E0B9
  db 0x00, 0x00                                ; 0E0BB
  db 0x00, 0x00                                ; 0E0BD
  db 0x00, 0x00                                ; 0E0BF
  db 0x00, 0x00                                ; 0E0C1
  db 0x00, 0x00                                ; 0E0C3
  db 0x00, 0x00                                ; 0E0C5
  db 0x00, 0x00                                ; 0E0C7
  add dl, bh                                   ; 0E0C9  0x00, 0xFA
  je loc_0E0CD                                 ; 0E0CB  0x74, 0x00

loc_0E0CD:                                     ; 0E0CD
  db 0x00, 0x00                                ; 0E0CD
  db 0x00, 0x00                                ; 0E0CF
  db 0x00, 0x00                                ; 0E0D1
  db 0x00, 0x00                                ; 0E0D3
  db 0x00, 0x00                                ; 0E0D5
  db 0x00, 0x00                                ; 0E0D7
  db 0x00, 0x00                                ; 0E0D9
  db 0x00, 0x00                                ; 0E0DB
  db 0x00, 0x00                                ; 0E0DD
  db 0x00, 0x00                                ; 0E0DF
  db 0x00, 0x00                                ; 0E0E1
  db 0x00, 0x00                                ; 0E0E3
  db 0x00, 0x00                                ; 0E0E5
  db 0x00, 0x00                                ; 0E0E7
  db 0x00, 0x00                                ; 0E0E9
  db 0x00, 0x00                                ; 0E0EB
  db 0x00, 0x00                                ; 0E0ED
  db 0x00, 0x00                                ; 0E0EF
  db 0x00, 0x00                                ; 0E0F1
  db 0x00, 0x00                                ; 0E0F3
  db 0x00, 0x00                                ; 0E0F5
  db 0x00, 0x00                                ; 0E0F7
  add [bp + si], ch                            ; 0E0F9  0x00, 0x2A
  jne loc_0E0FD                                ; 0E0FB  0x75, 0x00

loc_0E0FD:                                     ; 0E0FD
  db 0x00, 0x00                                ; 0E0FD
  db 0x00, 0x00                                ; 0E0FF
  db 0x00, 0x00                                ; 0E101
  db 0x00, 0x00                                ; 0E103
  db 0x00, 0x00                                ; 0E105
  db 0x00, 0x00                                ; 0E107
  db 0x00, 0x00                                ; 0E109
  db 0x00, 0x00                                ; 0E10B
  db 0x00, 0x00                                ; 0E10D
  db 0x00, 0x00                                ; 0E10F
  db 0x00, 0x00                                ; 0E111
  db 0x00, 0x00                                ; 0E113
  db 0x00, 0x00                                ; 0E115
  db 0x00, 0x00                                ; 0E117
  db 0x00, 0x00                                ; 0E119
  db 0x00, 0x00                                ; 0E11B
  db 0x00, 0x00                                ; 0E11D
  db 0x00, 0x00                                ; 0E11F
  db 0x00, 0x00                                ; 0E121
  db 0x00, 0x00                                ; 0E123
  db 0x00, 0x00                                ; 0E125
  db 0x00, 0x00                                ; 0E127
  add [bp + si + 0x75], bl                     ; 0E129  0x00, 0x5A, 0x75
  db 0x00, 0x00                                ; 0E12C
  db 0x00, 0x00                                ; 0E12E
  db 0x00, 0x00                                ; 0E130
  db 0x00, 0x00                                ; 0E132
  db 0x00, 0x00                                ; 0E134
  db 0x00, 0x00                                ; 0E136
  db 0x00, 0x00                                ; 0E138
  db 0x00, 0x00                                ; 0E13A
  db 0x00, 0x00                                ; 0E13C
  db 0x00, 0x00                                ; 0E13E
  db 0x00, 0x00                                ; 0E140
  db 0x00, 0x00                                ; 0E142
  db 0x00, 0x00                                ; 0E144
  db 0x00, 0x00                                ; 0E146
  db 0x00, 0x00                                ; 0E148
  db 0x00, 0x00                                ; 0E14A
  db 0x00, 0x00                                ; 0E14C
  db 0x00, 0x00                                ; 0E14E
  db 0x00, 0x00                                ; 0E150
  db 0x00, 0x00                                ; 0E152
  db 0x00, 0x00                                ; 0E154
  db 0x00, 0x00                                ; 0E156
  db 0x00, 0x00                                ; 0E158
  db 0x8A, 0x75, 0x00                          ; 0E15A  mov dh, byte [di]
  db 0x00, 0x00                                ; 0E15D
  db 0x00, 0x00                                ; 0E15F
  db 0x00, 0x00                                ; 0E161
  db 0x00, 0x00                                ; 0E163
  db 0x00, 0x00                                ; 0E165
  db 0x00, 0x00                                ; 0E167
  db 0x00, 0x00                                ; 0E169
  db 0x00, 0x00                                ; 0E16B
  db 0x00, 0x00                                ; 0E16D
  db 0x00, 0x00                                ; 0E16F
  db 0x00, 0x00                                ; 0E171
  db 0x00, 0x00                                ; 0E173
  db 0x00, 0x00                                ; 0E175
  db 0x00, 0x00                                ; 0E177
  db 0x00, 0x00                                ; 0E179
  db 0x00, 0x00                                ; 0E17B
  db 0x00, 0x00                                ; 0E17D
  db 0x00, 0x00                                ; 0E17F
  db 0x00, 0x00                                ; 0E181
  db 0x00, 0x00                                ; 0E183
  db 0x00, 0x00                                ; 0E185
  db 0x00, 0x00                                ; 0E187
  db 0x00, 0xBA, 0x75, 0x00                    ; 0E189  add byte [bp + si + 0x75], bh
  db 0x00, 0x00                                ; 0E18D
  db 0x00, 0x00                                ; 0E18F
  db 0x00, 0x00                                ; 0E191
  db 0x00, 0x00                                ; 0E193
  db 0x00, 0x00                                ; 0E195
  db 0x00, 0x00                                ; 0E197
  db 0x00, 0x00                                ; 0E199
  db 0x00, 0x00                                ; 0E19B
  db 0x00, 0x00                                ; 0E19D
  db 0x00, 0x00                                ; 0E19F
  db 0x00, 0x00                                ; 0E1A1
  db 0x00, 0x00                                ; 0E1A3
  db 0x00, 0x00                                ; 0E1A5
  db 0x00, 0x00                                ; 0E1A7
  db 0x00, 0x00                                ; 0E1A9
  db 0x00, 0x00                                ; 0E1AB
  db 0x00, 0x00                                ; 0E1AD
  db 0x00, 0x00                                ; 0E1AF
  db 0x00, 0x00                                ; 0E1B1
  db 0x00, 0x00                                ; 0E1B3
  db 0x00, 0x00                                ; 0E1B5
  db 0x00, 0x00                                ; 0E1B7
  add dl, ch                                   ; 0E1B9  0x00, 0xEA
  jne loc_0E1BD                                ; 0E1BB  0x75, 0x00

loc_0E1BD:                                     ; 0E1BD
  db 0x00, 0x00                                ; 0E1BD
  db 0x00, 0x00                                ; 0E1BF
  db 0x00, 0x00                                ; 0E1C1
  db 0x00, 0x00                                ; 0E1C3
  db 0x00, 0x00                                ; 0E1C5
  db 0x00, 0x00                                ; 0E1C7
  db 0x00, 0x00                                ; 0E1C9
  db 0x00, 0x00                                ; 0E1CB
  db 0x00, 0x00                                ; 0E1CD
  db 0x00, 0x00                                ; 0E1CF
  db 0x00, 0x00                                ; 0E1D1
  db 0x00, 0x00                                ; 0E1D3
  db 0x00, 0x00                                ; 0E1D5
  db 0x00, 0x00                                ; 0E1D7
  db 0x00, 0x00                                ; 0E1D9
  db 0x00, 0x00                                ; 0E1DB
  db 0x00, 0x00                                ; 0E1DD
  db 0x00, 0x00                                ; 0E1DF
  db 0x00, 0x00                                ; 0E1E1
  db 0x00, 0x00                                ; 0E1E3
  db 0x00, 0x00                                ; 0E1E5
  db 0x00, 0x00                                ; 0E1E7
  add [bp + si], bl                            ; 0E1E9  0x00, 0x1A
  jbe loc_0E1ED                                ; 0E1EB  0x76, 0x00

loc_0E1ED:                                     ; 0E1ED
  db 0x00, 0x00                                ; 0E1ED
  db 0x00, 0x00                                ; 0E1EF
  db 0x00, 0x00                                ; 0E1F1
  db 0x00, 0x00                                ; 0E1F3
  db 0x00, 0x00                                ; 0E1F5
  db 0x00, 0x00                                ; 0E1F7
  db 0x00, 0x00                                ; 0E1F9
  db 0x00, 0x00                                ; 0E1FB
  db 0x00, 0x00                                ; 0E1FD
  db 0x00, 0x00                                ; 0E1FF
  db 0x00, 0x00                                ; 0E201
  db 0x00, 0x00                                ; 0E203
  db 0x00, 0x00                                ; 0E205
  db 0x00, 0x00                                ; 0E207
  db 0x00, 0x00                                ; 0E209
  db 0x00, 0x00                                ; 0E20B
  db 0x00, 0x00                                ; 0E20D
  db 0x00, 0x00                                ; 0E20F
  db 0x00, 0x00                                ; 0E211
  db 0x00, 0x00                                ; 0E213
  db 0x00, 0x00                                ; 0E215
  db 0x00, 0x00                                ; 0E217
  add [bp + si + 0x76], cl                     ; 0E219  0x00, 0x4A, 0x76
  db 0x00, 0x00                                ; 0E21C
  db 0x00, 0x00                                ; 0E21E
  db 0x00, 0x00                                ; 0E220
  db 0x00, 0x00                                ; 0E222
  db 0x00, 0x00                                ; 0E224
  db 0x00, 0x00                                ; 0E226
  db 0x00, 0x00                                ; 0E228
  db 0x00, 0x00                                ; 0E22A
  db 0x00, 0x00                                ; 0E22C
  db 0x00, 0x00                                ; 0E22E
  db 0x00, 0x00                                ; 0E230
  db 0x00, 0x00                                ; 0E232
  db 0x00, 0x00                                ; 0E234
  db 0x00, 0x00                                ; 0E236
  db 0x00, 0x00                                ; 0E238
  db 0x00, 0x00                                ; 0E23A
  db 0x00, 0x00                                ; 0E23C
  db 0x00, 0x00                                ; 0E23E
  db 0x00, 0x00                                ; 0E240
  db 0x00, 0x00                                ; 0E242
  db 0x00, 0x00                                ; 0E244
  db 0x00, 0x00                                ; 0E246
  db 0x00, 0x00                                ; 0E248
  db 0x7A, 0x76                                ; 0E24A  jp 0xe2c2
  db 0x00, 0x00                                ; 0E24C
  db 0x00, 0x00                                ; 0E24E
  db 0x00, 0x00                                ; 0E250
  db 0x00, 0x00                                ; 0E252
  db 0x00, 0x00                                ; 0E254
  db 0x00, 0x00                                ; 0E256
  db 0x00, 0x00                                ; 0E258
  db 0x00, 0x00                                ; 0E25A
  db 0x00, 0x00                                ; 0E25C
  db 0x00, 0x00                                ; 0E25E
  db 0x00, 0x00                                ; 0E260
  db 0x00, 0x00                                ; 0E262
  db 0x00, 0x00                                ; 0E264
  db 0x00, 0x00                                ; 0E266
  db 0x00, 0x00                                ; 0E268
  db 0x00, 0x00                                ; 0E26A
  db 0x00, 0x00                                ; 0E26C
  db 0x00, 0x00                                ; 0E26E
  db 0x00, 0x00                                ; 0E270
  db 0x00, 0x00                                ; 0E272
  db 0x00, 0x00                                ; 0E274
  db 0x00, 0x00                                ; 0E276
  db 0x00, 0x00                                ; 0E278
  stosb                                        ; 0E27A  0xAA
  jbe loc_0E27D                                ; 0E27B  0x76, 0x00

loc_0E27D:                                     ; 0E27D
  db 0x00, 0x00                                ; 0E27D
  db 0x00, 0x00                                ; 0E27F
  db 0x00, 0x00                                ; 0E281
  db 0x00, 0x00                                ; 0E283
  db 0x00, 0x00                                ; 0E285
  db 0x00, 0x00                                ; 0E287
  db 0x00, 0x00                                ; 0E289
  db 0x00, 0x00                                ; 0E28B
  db 0x00, 0x00                                ; 0E28D
  db 0x00, 0x00                                ; 0E28F
  db 0x00, 0x00                                ; 0E291
  db 0x00, 0x00                                ; 0E293
  db 0x00, 0x00                                ; 0E295
  db 0x00, 0x00                                ; 0E297
  db 0x00, 0x00                                ; 0E299
  db 0x00, 0x00                                ; 0E29B
  db 0x00, 0x00                                ; 0E29D
  db 0x00, 0x00                                ; 0E29F
  db 0x00, 0x00                                ; 0E2A1
  db 0x00, 0x00                                ; 0E2A3
  db 0x00, 0x00                                ; 0E2A5
  db 0x00, 0x00                                ; 0E2A7
  add dl, bl                                   ; 0E2A9  0x00, 0xDA
  jbe loc_0E2AD                                ; 0E2AB  0x76, 0x00

loc_0E2AD:                                     ; 0E2AD
  db 0x00, 0x00                                ; 0E2AD
  db 0x00, 0x00                                ; 0E2AF
  db 0x00, 0x00                                ; 0E2B1
  db 0x00, 0x00                                ; 0E2B3
  db 0x00, 0x00                                ; 0E2B5
  db 0x00, 0x00                                ; 0E2B7
  db 0x00, 0x00                                ; 0E2B9
  db 0x00, 0x00                                ; 0E2BB
  db 0x00, 0x00                                ; 0E2BD
  db 0x00, 0x00                                ; 0E2BF
  db 0x00, 0x00                                ; 0E2C1
  db 0x00, 0x00                                ; 0E2C3
  db 0x00, 0x00                                ; 0E2C5
  db 0x00, 0x00                                ; 0E2C7
  db 0x00, 0x00                                ; 0E2C9
  db 0x00, 0x00                                ; 0E2CB
  db 0x00, 0x00                                ; 0E2CD
  db 0x00, 0x00                                ; 0E2CF
  db 0x00, 0x00                                ; 0E2D1
  db 0x00, 0x00                                ; 0E2D3
  db 0x00, 0x00                                ; 0E2D5
  db 0x00, 0x00                                ; 0E2D7
  add [bp + si], cl                            ; 0E2D9  0x00, 0x0A
  ja loc_0E2DD                                 ; 0E2DB  0x77, 0x00

loc_0E2DD:                                     ; 0E2DD
  db 0x00, 0x00                                ; 0E2DD
  db 0x00, 0x00                                ; 0E2DF
  db 0x00, 0x00                                ; 0E2E1
  db 0x00, 0x00                                ; 0E2E3
  db 0x00, 0x00                                ; 0E2E5
  db 0x00, 0x00                                ; 0E2E7
  db 0x00, 0x00                                ; 0E2E9
  db 0x00, 0x00                                ; 0E2EB
  db 0x00, 0x00                                ; 0E2ED
  db 0x00, 0x00                                ; 0E2EF
  db 0x00, 0x00                                ; 0E2F1
  db 0x00, 0x00                                ; 0E2F3
  db 0x00, 0x00                                ; 0E2F5
  db 0x00, 0x00                                ; 0E2F7
  db 0x00, 0x00                                ; 0E2F9
  db 0x00, 0x00                                ; 0E2FB
  db 0x00, 0x00                                ; 0E2FD
  db 0x00, 0x00                                ; 0E2FF
  db 0x00, 0x00                                ; 0E301
  db 0x00, 0x00                                ; 0E303
  db 0x00, 0x00                                ; 0E305
  db 0x00, 0x00                                ; 0E307
  add [bp + si], bh                            ; 0E309  0x00, 0x3A
  ja loc_0E30D                                 ; 0E30B  0x77, 0x00

loc_0E30D:                                     ; 0E30D
  db 0x00, 0x00                                ; 0E30D
  db 0x00, 0x00                                ; 0E30F
  db 0x00, 0x00                                ; 0E311
  db 0x00, 0x00                                ; 0E313
  db 0x00, 0x00                                ; 0E315
  db 0x00, 0x00                                ; 0E317
  db 0x00, 0x00                                ; 0E319
  db 0x00, 0x00                                ; 0E31B
  db 0x00, 0x00                                ; 0E31D
  db 0x00, 0x00                                ; 0E31F
  db 0x00, 0x00                                ; 0E321
  db 0x00, 0x00                                ; 0E323
  db 0x00, 0x00                                ; 0E325
  db 0x00, 0x00                                ; 0E327
  db 0x00, 0x00                                ; 0E329
  db 0x00, 0x00                                ; 0E32B
  db 0x00, 0x00                                ; 0E32D
  db 0x00, 0x00                                ; 0E32F
  db 0x00, 0x00                                ; 0E331
  db 0x00, 0x00                                ; 0E333
  db 0x00, 0x00                                ; 0E335
  db 0x00, 0x00                                ; 0E337
  add [bp + si + 0x77], ch                     ; 0E339  0x00, 0x6A, 0x77
  db 0x00, 0x00                                ; 0E33C
  db 0x00, 0x00                                ; 0E33E
  db 0x00, 0x00                                ; 0E340
  db 0x00, 0x00                                ; 0E342
  db 0x00, 0x00                                ; 0E344
  db 0x00, 0x00                                ; 0E346
  db 0x00, 0x00                                ; 0E348
  db 0x00, 0x00                                ; 0E34A
  db 0x00, 0x00                                ; 0E34C
  db 0x00, 0x00                                ; 0E34E
  db 0x00, 0x00                                ; 0E350
  db 0x00, 0x00                                ; 0E352
  db 0x00, 0x00                                ; 0E354
  db 0x00, 0x00                                ; 0E356
  db 0x00, 0x00                                ; 0E358
  db 0x00, 0x00                                ; 0E35A
  db 0x00, 0x00                                ; 0E35C
  db 0x00, 0x00                                ; 0E35E
  db 0x00, 0x00                                ; 0E360
  db 0x00, 0x00                                ; 0E362
  db 0x00, 0x00                                ; 0E364
  db 0x00, 0x00                                ; 0E366
  db 0x00, 0x00                                ; 0E368
  db 0x9A, 0x77, 0x00, 0x00, 0x00              ; 0E36A  call far 0, 0x77
  db 0x00, 0x00                                ; 0E36F
  db 0x00, 0x00                                ; 0E371
  db 0x00, 0x00                                ; 0E373
  db 0x00, 0x00                                ; 0E375
  db 0x00, 0x00                                ; 0E377
  db 0x00, 0x00                                ; 0E379
  db 0x00, 0x00                                ; 0E37B
  db 0x00, 0x00                                ; 0E37D
  db 0x00, 0x00                                ; 0E37F
  db 0x00, 0x00                                ; 0E381
  db 0x00, 0x00                                ; 0E383
  db 0x00, 0x00                                ; 0E385
  db 0x00, 0x00                                ; 0E387
  db 0x00, 0x00                                ; 0E389
  db 0x00, 0x00                                ; 0E38B
  db 0x00, 0x00                                ; 0E38D
  db 0x00, 0x00                                ; 0E38F
  db 0x00, 0x00                                ; 0E391
  db 0x00, 0x00                                ; 0E393
  db 0x00, 0x00                                ; 0E395
  db 0x00, 0x00                                ; 0E397
  add dl, cl                                   ; 0E399  0x00, 0xCA
  ja loc_0E39D                                 ; 0E39B  0x77, 0x00

loc_0E39D:                                     ; 0E39D
  db 0x00, 0x00                                ; 0E39D
  db 0x00, 0x00                                ; 0E39F
  db 0x00, 0x00                                ; 0E3A1
  db 0x00, 0x00                                ; 0E3A3
  db 0x00, 0x00                                ; 0E3A5
  db 0x00, 0x00                                ; 0E3A7
  db 0x00, 0x00                                ; 0E3A9
  db 0x00, 0x00                                ; 0E3AB
  db 0x00, 0x00                                ; 0E3AD
  db 0x00, 0x00                                ; 0E3AF
  db 0x00, 0x00                                ; 0E3B1
  db 0x00, 0x00                                ; 0E3B3
  db 0x00, 0x00                                ; 0E3B5
  db 0x00, 0x00                                ; 0E3B7
  db 0x00, 0x00                                ; 0E3B9
  db 0x00, 0x00                                ; 0E3BB
  db 0x00, 0x00                                ; 0E3BD
  db 0x00, 0x00                                ; 0E3BF
  db 0x00, 0x00                                ; 0E3C1
  db 0x00, 0x00                                ; 0E3C3
  db 0x00, 0x00                                ; 0E3C5
  db 0x00, 0x00                                ; 0E3C7
  add dl, bh                                   ; 0E3C9  0x00, 0xFA
  ja loc_0E3CD                                 ; 0E3CB  0x77, 0x00

loc_0E3CD:                                     ; 0E3CD
  db 0x00, 0x00                                ; 0E3CD
  db 0x00, 0x00                                ; 0E3CF
  db 0x00, 0x00                                ; 0E3D1
  db 0x00, 0x00                                ; 0E3D3
  db 0x00, 0x00                                ; 0E3D5
  db 0x00, 0x00                                ; 0E3D7
  db 0x00, 0x00                                ; 0E3D9
  db 0x00, 0x00                                ; 0E3DB
  db 0x00, 0x00                                ; 0E3DD
  db 0x00, 0x00                                ; 0E3DF
  db 0x00, 0x00                                ; 0E3E1
  db 0x00, 0x00                                ; 0E3E3
  db 0x00, 0x00                                ; 0E3E5
  db 0x00, 0x00                                ; 0E3E7
  db 0x00, 0x00                                ; 0E3E9
  db 0x00, 0x00                                ; 0E3EB
  db 0x00, 0x00                                ; 0E3ED
  db 0x00, 0x00                                ; 0E3EF
  db 0x00, 0x00                                ; 0E3F1
  db 0x00, 0x00                                ; 0E3F3
  db 0x00, 0x00                                ; 0E3F5
  db 0x00, 0x00                                ; 0E3F7
  add [bp + si], ch                            ; 0E3F9  0x00, 0x2A
  js loc_0E3FD                                 ; 0E3FB  0x78, 0x00

loc_0E3FD:                                     ; 0E3FD
  db 0x00, 0x00                                ; 0E3FD
  db 0x00, 0x00                                ; 0E3FF
  db 0x00, 0x00                                ; 0E401
  db 0x00, 0x00                                ; 0E403
  db 0x00, 0x00                                ; 0E405
  db 0x00, 0x00                                ; 0E407
  db 0x00, 0x00                                ; 0E409
  db 0x00, 0x00                                ; 0E40B
  db 0x00, 0x00                                ; 0E40D
  db 0x00, 0x00                                ; 0E40F
  db 0x00, 0x00                                ; 0E411
  db 0x00, 0x00                                ; 0E413
  db 0x00, 0x00                                ; 0E415
  db 0x00, 0x00                                ; 0E417
  db 0x00, 0x00                                ; 0E419
  db 0x00, 0x00                                ; 0E41B
  db 0x00, 0x00                                ; 0E41D
  db 0x00, 0x00                                ; 0E41F
  db 0x00, 0x00                                ; 0E421
  db 0x00, 0x00                                ; 0E423
  db 0x00, 0x00                                ; 0E425
  db 0x00, 0x00                                ; 0E427
  db 0x00, 0x00                                ; 0E429
  db 0x00, 0x00                                ; 0E42B
  db 0x00, 0x00                                ; 0E42D
  db 0x00, 0x00                                ; 0E42F
  db 0x00, 0x00                                ; 0E431
  db 0x00, 0x00                                ; 0E433
  db 0x00, 0x00                                ; 0E435
  db 0x00, 0x00                                ; 0E437
  db 0x00, 0x00                                ; 0E439
  db 0x00, 0x00                                ; 0E43B
  db 0x00, 0x00                                ; 0E43D
  db 0x00, 0x00                                ; 0E43F
  db 0x00, 0x00                                ; 0E441
  db 0x00, 0x00                                ; 0E443
  db 0x00, 0x8A, 0x78, 0x00                    ; 0E445  add byte [bp + si + 0x78], cl
  db 0x00, 0x00                                ; 0E449
  db 0x00, 0x00                                ; 0E44B
  db 0x00, 0x00                                ; 0E44D
  db 0x00, 0x00                                ; 0E44F
  db 0x00, 0x00                                ; 0E451
  db 0x00, 0x00                                ; 0E453
  db 0x00, 0x00                                ; 0E455
  db 0x00, 0x00                                ; 0E457
  db 0x00, 0x00                                ; 0E459
  db 0x00, 0x00                                ; 0E45B
  db 0x00, 0x00                                ; 0E45D
  db 0x00, 0x00                                ; 0E45F
  db 0x00, 0xA6, 0x78, 0x00                    ; 0E461  add byte [bp + 0x78], ah
  db 0x00, 0x00                                ; 0E465
  db 0x00, 0x00                                ; 0E467
  db 0x00, 0x00                                ; 0E469
  db 0x00, 0x00                                ; 0E46B
  db 0x00, 0x00                                ; 0E46D
  db 0x00, 0x00                                ; 0E46F
  db 0x00, 0x00                                ; 0E471
  db 0x00, 0x00                                ; 0E473
  db 0x00, 0x00                                ; 0E475
  db 0x00, 0x00                                ; 0E477
  db 0x00, 0x00                                ; 0E479
  db 0x00, 0x00                                ; 0E47B
  add dl, al                                   ; 0E47D  0x00, 0xC2
  js loc_0E481                                 ; 0E47F  0x78, 0x00

loc_0E481:                                     ; 0E481
  db 0x00, 0x00                                ; 0E481
  db 0x00, 0x00                                ; 0E483
  db 0x00, 0x00                                ; 0E485
  db 0x00, 0x00                                ; 0E487
  db 0x00, 0x00                                ; 0E489
  db 0x00, 0x00                                ; 0E48B
  db 0x00, 0x00                                ; 0E48D
  db 0x00, 0x00                                ; 0E48F
  db 0x00, 0x00                                ; 0E491
  db 0x00, 0x00                                ; 0E493
  db 0x00, 0x00                                ; 0E495
  db 0x00, 0x00                                ; 0E497
  add dh, bl                                   ; 0E499  0x00, 0xDE
  js loc_0E49D                                 ; 0E49B  0x78, 0x00

loc_0E49D:                                     ; 0E49D
  db 0x00, 0x00                                ; 0E49D
  db 0x00, 0x00                                ; 0E49F
  db 0x00, 0x00                                ; 0E4A1
  db 0x00, 0x00                                ; 0E4A3
  db 0x00, 0x00                                ; 0E4A5
  db 0x00, 0x00                                ; 0E4A7
  db 0x00, 0x00                                ; 0E4A9
  db 0x00, 0x00                                ; 0E4AB
  db 0x00, 0x00                                ; 0E4AD
  db 0x00, 0x00                                ; 0E4AF
  db 0x00, 0x00                                ; 0E4B1
  db 0x00, 0x00                                ; 0E4B3
  add dl, bh                                   ; 0E4B5  0x00, 0xFA
  js loc_0E4B9                                 ; 0E4B7  0x78, 0x00

loc_0E4B9:                                     ; 0E4B9
  db 0x00, 0x00                                ; 0E4B9
  db 0x00, 0x00                                ; 0E4BB
  db 0x00, 0x00                                ; 0E4BD
  db 0x00, 0x00                                ; 0E4BF
  db 0x00, 0x00                                ; 0E4C1
  db 0x00, 0x00                                ; 0E4C3
  db 0x00, 0x00                                ; 0E4C5
  db 0x00, 0x00                                ; 0E4C7
  db 0x00, 0x00                                ; 0E4C9
  db 0x00, 0x00                                ; 0E4CB
  db 0x00, 0x00                                ; 0E4CD
  db 0x00, 0x00                                ; 0E4CF
  add [0x79], dl                               ; 0E4D1  0x00, 0x16, 0x79, 0x00
  db 0x00, 0x00                                ; 0E4D5
  db 0x00, 0x00                                ; 0E4D7
  db 0x00, 0x00                                ; 0E4D9
  db 0x00, 0x00                                ; 0E4DB
  db 0x00, 0x00                                ; 0E4DD
  db 0x00, 0x00                                ; 0E4DF
  db 0x00, 0x00                                ; 0E4E1
  db 0x00, 0x00                                ; 0E4E3
  db 0x00, 0x00                                ; 0E4E5
  db 0x00, 0x00                                ; 0E4E7
  db 0x00, 0x00                                ; 0E4E9
  db 0x00, 0x00                                ; 0E4EB
  add [bp + si], dh                            ; 0E4ED  0x00, 0x32
  jns loc_0E4F1                                ; 0E4EF  0x79, 0x00

loc_0E4F1:                                     ; 0E4F1
  db 0x00, 0x00                                ; 0E4F1
  db 0x00, 0x00                                ; 0E4F3
  db 0x00, 0x00                                ; 0E4F5
  db 0x00, 0x00                                ; 0E4F7
  db 0x00, 0x00                                ; 0E4F9
  db 0x00, 0x00                                ; 0E4FB
  db 0x00, 0x00                                ; 0E4FD
  db 0x00, 0x00                                ; 0E4FF
  db 0x00, 0x00                                ; 0E501
  db 0x00, 0x00                                ; 0E503
  db 0x00, 0x00                                ; 0E505
  db 0x00, 0x00                                ; 0E507
  add [bp + 0x79], cl                          ; 0E509  0x00, 0x4E, 0x79
  db 0x00, 0x00                                ; 0E50C
  db 0x00, 0x00                                ; 0E50E
  db 0x00, 0x00                                ; 0E510
  db 0x00, 0x00                                ; 0E512
  db 0x00, 0x00                                ; 0E514
  db 0x00, 0x00                                ; 0E516
  db 0x00, 0x00                                ; 0E518
  db 0x00, 0x00                                ; 0E51A
  db 0x00, 0x00                                ; 0E51C
  db 0x00, 0x00                                ; 0E51E
  db 0x00, 0x00                                ; 0E520
  db 0x00, 0x00                                ; 0E522
  db 0x00, 0x00                                ; 0E524
  push 0x79                                    ; 0E526  0x6A, 0x79
  db 0x00, 0x00                                ; 0E528
  db 0x00, 0x00                                ; 0E52A
  db 0x00, 0x00                                ; 0E52C
  db 0x00, 0x00                                ; 0E52E
  db 0x00, 0x00                                ; 0E530
  db 0x00, 0x00                                ; 0E532
  db 0x00, 0x00                                ; 0E534
  db 0x00, 0x00                                ; 0E536
  db 0x00, 0x00                                ; 0E538
  db 0x00, 0x00                                ; 0E53A
  db 0x00, 0x00                                ; 0E53C
  db 0x00, 0x00                                ; 0E53E
  db 0x00, 0x00                                ; 0E540
  db 0x86, 0x79, 0x00                          ; 0E542  xchg byte [bx + di], bh
  db 0x00, 0x00                                ; 0E545
  db 0x00, 0x00                                ; 0E547
  db 0x00, 0x00                                ; 0E549
  db 0x00, 0x00                                ; 0E54B
  db 0x00, 0x00                                ; 0E54D
  db 0x00, 0x00                                ; 0E54F
  db 0x00, 0x00                                ; 0E551
  db 0x00, 0x00                                ; 0E553
  db 0x00, 0x00                                ; 0E555
  db 0x00, 0x00                                ; 0E557
  db 0x00, 0x00                                ; 0E559
  db 0x00, 0x00                                ; 0E55B
  db 0x00, 0xA2, 0x79, 0x00                    ; 0E55D  add byte [bp + si + 0x79], ah
  db 0x00, 0x00                                ; 0E561
  db 0x00, 0x00                                ; 0E563
  db 0x00, 0x00                                ; 0E565
  db 0x00, 0x00                                ; 0E567
  db 0x00, 0x00                                ; 0E569
  db 0x00, 0x00                                ; 0E56B
  db 0x00, 0x00                                ; 0E56D
  db 0x00, 0x00                                ; 0E56F
  db 0x00, 0x00                                ; 0E571
  db 0x00, 0x00                                ; 0E573
  db 0x00, 0x00                                ; 0E575
  db 0x00, 0x00                                ; 0E577
  db 0x00, 0xBE, 0x79, 0x00                    ; 0E579  add byte [bp + 0x79], bh
  db 0x00, 0x00                                ; 0E57D
  db 0x00, 0x00                                ; 0E57F
  db 0x00, 0x00                                ; 0E581
  db 0x00, 0x00                                ; 0E583
  db 0x00, 0x00                                ; 0E585
  db 0x00, 0x00                                ; 0E587
  db 0x00, 0x00                                ; 0E589
  db 0x00, 0x00                                ; 0E58B
  db 0x00, 0x00                                ; 0E58D
  db 0x00, 0x00                                ; 0E58F
  db 0x00, 0x00                                ; 0E591
  db 0x00, 0x00                                ; 0E593
  add dl, bl                                   ; 0E595  0x00, 0xDA
  jns loc_0E599                                ; 0E597  0x79, 0x00

loc_0E599:                                     ; 0E599
  db 0x00, 0x00                                ; 0E599
  db 0x00, 0x00                                ; 0E59B
  db 0x00, 0x00                                ; 0E59D
  db 0x00, 0x00                                ; 0E59F
  db 0x00, 0x00                                ; 0E5A1
  db 0x00, 0x00                                ; 0E5A3
  db 0x00, 0x00                                ; 0E5A5
  db 0x00, 0x00                                ; 0E5A7
  db 0x00, 0x00                                ; 0E5A9
  db 0x00, 0x00                                ; 0E5AB
  db 0x00, 0x00                                ; 0E5AD
  db 0x00, 0x00                                ; 0E5AF
  add dh, dh                                   ; 0E5B1  0x00, 0xF6
  jns loc_0E5B5                                ; 0E5B3  0x79, 0x00

loc_0E5B5:                                     ; 0E5B5
  db 0x00, 0x00                                ; 0E5B5
  db 0x00, 0x00                                ; 0E5B7
  db 0x00, 0x00                                ; 0E5B9
  db 0x00, 0x00                                ; 0E5BB
  db 0x00, 0x00                                ; 0E5BD
  db 0x00, 0x00                                ; 0E5BF
  db 0x00, 0x00                                ; 0E5C1
  db 0x00, 0x00                                ; 0E5C3
  db 0x00, 0x00                                ; 0E5C5
  db 0x00, 0x00                                ; 0E5C7
  db 0x00, 0x00                                ; 0E5C9
  db 0x00, 0x00                                ; 0E5CB
  add [bp + si], dl                            ; 0E5CD  0x00, 0x12
  jp loc_0E5D1                                 ; 0E5CF  0x7A, 0x00

loc_0E5D1:                                     ; 0E5D1
  db 0x00, 0x00                                ; 0E5D1
  db 0x00, 0x00                                ; 0E5D3
  db 0x00, 0x00                                ; 0E5D5
  db 0x00, 0x00                                ; 0E5D7
  db 0x00, 0x00                                ; 0E5D9
  db 0x00, 0x00                                ; 0E5DB
  db 0x00, 0x00                                ; 0E5DD
  db 0x00, 0x00                                ; 0E5DF
  db 0x00, 0x00                                ; 0E5E1
  db 0x00, 0x00                                ; 0E5E3
  db 0x00, 0x00                                ; 0E5E5
  db 0x00, 0x00                                ; 0E5E7
  add [0x7a], ch                               ; 0E5E9  0x00, 0x2E, 0x7A, 0x00
  db 0x00, 0x00                                ; 0E5ED
  db 0x00, 0x00                                ; 0E5EF
  db 0x00, 0x00                                ; 0E5F1
  db 0x00, 0x00                                ; 0E5F3
  db 0x00, 0x00                                ; 0E5F5
  db 0x00, 0x00                                ; 0E5F7
  db 0x00, 0x00                                ; 0E5F9
  db 0x00, 0x00                                ; 0E5FB
  db 0x00, 0x00                                ; 0E5FD
  db 0x00, 0x00                                ; 0E5FF
  db 0x00, 0x00                                ; 0E601
  db 0x00, 0x00                                ; 0E603
  add [bp + si + 0x7a], cl                     ; 0E605  0x00, 0x4A, 0x7A
  db 0x00, 0x00                                ; 0E608
  db 0x00, 0x00                                ; 0E60A
  db 0x00, 0x00                                ; 0E60C
  db 0x00, 0x00                                ; 0E60E
  db 0x00, 0x00                                ; 0E610
  db 0x00, 0x00                                ; 0E612
  db 0x00, 0x00                                ; 0E614
  db 0x00, 0x00                                ; 0E616
  db 0x00, 0x00                                ; 0E618
  db 0x00, 0x00                                ; 0E61A
  db 0x00, 0x00                                ; 0E61C
  db 0x00, 0x00                                ; 0E61E
  db 0x00, 0x00                                ; 0E620
  db 0x66, 0x7A, 0x00                          ; 0E622  jp 0xe625

loc_0E625:                                     ; 0E625
  db 0x00, 0x00                                ; 0E625
  db 0x00, 0x00                                ; 0E627
  db 0x00, 0x00                                ; 0E629
  db 0x00, 0x00                                ; 0E62B
  db 0x00, 0x00                                ; 0E62D
  db 0x00, 0x00                                ; 0E62F
  db 0x00, 0x00                                ; 0E631
  db 0x00, 0x00                                ; 0E633
  db 0x00, 0x00                                ; 0E635
  db 0x00, 0x00                                ; 0E637
  db 0x00, 0x00                                ; 0E639
  db 0x00, 0x00                                ; 0E63B
  db 0x00, 0x82, 0x7A, 0x00                    ; 0E63D  add byte [bp + si + 0x7a], al
  db 0x00, 0x00                                ; 0E641
  db 0x00, 0x00                                ; 0E643
  db 0x00, 0x00                                ; 0E645
  db 0x00, 0x00                                ; 0E647
  db 0x00, 0x00                                ; 0E649
  db 0x00, 0x00                                ; 0E64B
  db 0x00, 0x00                                ; 0E64D
  db 0x00, 0x00                                ; 0E64F
  db 0x00, 0x00                                ; 0E651
  db 0x00, 0x00                                ; 0E653
  db 0x00, 0x00                                ; 0E655
  db 0x00, 0x00                                ; 0E657
  db 0x00, 0x9E, 0x7A, 0x00                    ; 0E659  add byte [bp + 0x7a], bl
  db 0x00, 0x00                                ; 0E65D
  db 0x00, 0x00                                ; 0E65F
  db 0x00, 0x00                                ; 0E661
  db 0x00, 0x00                                ; 0E663
  db 0x00, 0x00                                ; 0E665
  db 0x00, 0x00                                ; 0E667
  db 0x00, 0x00                                ; 0E669
  db 0x00, 0x00                                ; 0E66B
  db 0x00, 0x00                                ; 0E66D
  db 0x00, 0x00                                ; 0E66F
  db 0x00, 0x00                                ; 0E671
  db 0x00, 0x00                                ; 0E673
  db 0x00, 0xBA, 0x7A, 0x00                    ; 0E675  add byte [bp + si + 0x7a], bh
  db 0x00, 0x00                                ; 0E679
  db 0x00, 0x00                                ; 0E67B
  db 0x00, 0x00                                ; 0E67D
  db 0x00, 0x00                                ; 0E67F
  db 0x00, 0x00                                ; 0E681
  db 0x00, 0x00                                ; 0E683
  db 0x00, 0x00                                ; 0E685
  db 0x00, 0x00                                ; 0E687
  db 0x00, 0x00                                ; 0E689
  db 0x00, 0x00                                ; 0E68B
  db 0x00, 0x00                                ; 0E68D
  db 0x00, 0x00                                ; 0E68F
  add dh, dl                                   ; 0E691  0x00, 0xD6
  jp loc_0E695                                 ; 0E693  0x7A, 0x00

loc_0E695:                                     ; 0E695
  db 0x00, 0x00                                ; 0E695
  db 0x00, 0x00                                ; 0E697
  db 0x00, 0x00                                ; 0E699
  db 0x00, 0x00                                ; 0E69B
  db 0x00, 0x00                                ; 0E69D
  db 0x00, 0x00                                ; 0E69F
  db 0x00, 0x00                                ; 0E6A1
  db 0x00, 0x00                                ; 0E6A3
  db 0x00, 0x00                                ; 0E6A5
  db 0x00, 0x00                                ; 0E6A7
  db 0x00, 0x00                                ; 0E6A9
  db 0x00, 0x00                                ; 0E6AB
  add dl, dh                                   ; 0E6AD  0x00, 0xF2
  jp loc_0E6B1                                 ; 0E6AF  0x7A, 0x00

loc_0E6B1:                                     ; 0E6B1
  db 0x00, 0x00                                ; 0E6B1
  db 0x00, 0x00                                ; 0E6B3
  db 0x00, 0x00                                ; 0E6B5
  db 0x00, 0x00                                ; 0E6B7
  db 0x00, 0x00                                ; 0E6B9
  db 0x00, 0x00                                ; 0E6BB
  db 0x00, 0x00                                ; 0E6BD
  db 0x00, 0x00                                ; 0E6BF
  db 0x00, 0x00                                ; 0E6C1
  db 0x00, 0x00                                ; 0E6C3
  db 0x00, 0x00                                ; 0E6C5
  db 0x00, 0x00                                ; 0E6C7
  add [0x7b], cl                               ; 0E6C9  0x00, 0x0E, 0x7B, 0x00
  db 0x00, 0x00                                ; 0E6CD
  db 0x00, 0x00                                ; 0E6CF
  db 0x00, 0x00                                ; 0E6D1
  db 0x00, 0x00                                ; 0E6D3
  db 0x00, 0x00                                ; 0E6D5
  db 0x00, 0x00                                ; 0E6D7
  db 0x00, 0x00                                ; 0E6D9
  db 0x00, 0x00                                ; 0E6DB
  db 0x00, 0x00                                ; 0E6DD
  db 0x00, 0x00                                ; 0E6DF
  db 0x00, 0x00                                ; 0E6E1
  db 0x00, 0x00                                ; 0E6E3
  add [bp + si], ch                            ; 0E6E5  0x00, 0x2A
  jnp loc_0E6E9                                ; 0E6E7  0x7B, 0x00

loc_0E6E9:                                     ; 0E6E9
  db 0x00, 0x00                                ; 0E6E9
  db 0x00, 0x00                                ; 0E6EB
  db 0x00, 0x00                                ; 0E6ED
  db 0x00, 0x00                                ; 0E6EF
  db 0x00, 0x00                                ; 0E6F1
  db 0x00, 0x00                                ; 0E6F3
  db 0x00, 0x00                                ; 0E6F5
  db 0x00, 0x00                                ; 0E6F7
  db 0x00, 0x00                                ; 0E6F9
  db 0x00, 0x00                                ; 0E6FB
  db 0x00, 0x00                                ; 0E6FD
  db 0x00, 0x00                                ; 0E6FF
  add [bp + 0x7b], al                          ; 0E701  0x00, 0x46, 0x7B
  db 0x00, 0x00                                ; 0E704
  db 0x00, 0x00                                ; 0E706
  db 0x00, 0x00                                ; 0E708
  db 0x00, 0x00                                ; 0E70A
  db 0x00, 0x00                                ; 0E70C
  db 0x00, 0x00                                ; 0E70E
  db 0x00, 0x00                                ; 0E710
  db 0x00, 0x00                                ; 0E712
  db 0x00, 0x00                                ; 0E714
  db 0x00, 0x00                                ; 0E716
  db 0x00, 0x00                                ; 0E718
  db 0x00, 0x00                                ; 0E71A
  db 0x00, 0x00                                ; 0E71C
  db 0x62, 0x7B, 0x00                          ; 0E71E  bound di, dword [bp + di]
  db 0x00, 0x00                                ; 0E721
  db 0x00, 0x00                                ; 0E723
  db 0x00, 0x00                                ; 0E725
  db 0x00, 0x00                                ; 0E727
  db 0x00, 0x00                                ; 0E729
  db 0x00, 0x00                                ; 0E72B
  db 0x00, 0x00                                ; 0E72D
  db 0x00, 0x00                                ; 0E72F
  db 0x00, 0x00                                ; 0E731
  db 0x00, 0x00                                ; 0E733
  db 0x00, 0x00                                ; 0E735
  db 0x00, 0x00                                ; 0E737
  add [bp + 0x7b], bh                          ; 0E739  0x00, 0x7E, 0x7B
  db 0x00, 0x00                                ; 0E73C
  db 0x00, 0x00                                ; 0E73E
  db 0x00, 0x00                                ; 0E740
  db 0x00, 0x00                                ; 0E742
  db 0x00, 0x00                                ; 0E744
  db 0x00, 0x00                                ; 0E746
  db 0x00, 0x00                                ; 0E748
  db 0x00, 0x00                                ; 0E74A
  db 0x00, 0x00                                ; 0E74C
  db 0x00, 0x00                                ; 0E74E
  db 0x00, 0x00                                ; 0E750
  db 0x00, 0x00                                ; 0E752
  db 0x00, 0x00                                ; 0E754
  db 0x9A, 0x7B, 0x00, 0x00, 0x00              ; 0E756  call far 0, 0x7b
  db 0x00, 0x00                                ; 0E75B
  db 0x00, 0x00                                ; 0E75D
  db 0x00, 0x00                                ; 0E75F
  db 0x00, 0x00                                ; 0E761
  db 0x00, 0x00                                ; 0E763
  db 0x00, 0x00                                ; 0E765
  db 0x00, 0x00                                ; 0E767
  db 0x00, 0x00                                ; 0E769
  db 0x00, 0x00                                ; 0E76B
  db 0x00, 0x00                                ; 0E76D
  db 0x00, 0x00                                ; 0E76F
  db 0x00, 0xB6, 0x7B, 0x00                    ; 0E771  add byte [bp + 0x7b], dh
  db 0x00, 0x00                                ; 0E775
  db 0x00, 0x00                                ; 0E777
  db 0x00, 0x00                                ; 0E779
  db 0x00, 0x00                                ; 0E77B
  db 0x00, 0x00                                ; 0E77D
  db 0x00, 0x00                                ; 0E77F
  db 0x00, 0x00                                ; 0E781
  db 0x00, 0x00                                ; 0E783
  db 0x00, 0x00                                ; 0E785
  db 0x00, 0x00                                ; 0E787
  db 0x00, 0x00                                ; 0E789
  db 0x00, 0x00                                ; 0E78B
  add dl, dl                                   ; 0E78D  0x00, 0xD2
  jnp loc_0E791                                ; 0E78F  0x7B, 0x00

loc_0E791:                                     ; 0E791
  db 0x00, 0x00                                ; 0E791
  db 0x00, 0x00                                ; 0E793
  db 0x00, 0x00                                ; 0E795
  db 0x00, 0x00                                ; 0E797
  db 0x00, 0x00                                ; 0E799
  db 0x00, 0x00                                ; 0E79B
  db 0x00, 0x00                                ; 0E79D
  db 0x00, 0x00                                ; 0E79F
  db 0x00, 0x00                                ; 0E7A1
  db 0x00, 0x00                                ; 0E7A3
  db 0x00, 0x00                                ; 0E7A5
  db 0x00, 0x00                                ; 0E7A7
  add dh, ch                                   ; 0E7A9  0x00, 0xEE
  jnp loc_0E7AD                                ; 0E7AB  0x7B, 0x00

loc_0E7AD:                                     ; 0E7AD
  db 0x00, 0x00                                ; 0E7AD
  db 0x00, 0x00                                ; 0E7AF
  db 0x00, 0x00                                ; 0E7B1
  db 0x00, 0x00                                ; 0E7B3
  db 0x00, 0x00                                ; 0E7B5
  db 0x00, 0x00                                ; 0E7B7
  db 0x00, 0x00                                ; 0E7B9
  db 0x00, 0x00                                ; 0E7BB
  db 0x00, 0x00                                ; 0E7BD
  db 0x00, 0x00                                ; 0E7BF
  db 0x00, 0x00                                ; 0E7C1
  db 0x00, 0x00                                ; 0E7C3
  add [bp + si], cl                            ; 0E7C5  0x00, 0x0A
  jl loc_0E7C9                                 ; 0E7C7  0x7C, 0x00

loc_0E7C9:                                     ; 0E7C9
  db 0x00, 0x00                                ; 0E7C9
  db 0x00, 0x00                                ; 0E7CB
  db 0x00, 0x00                                ; 0E7CD
  db 0x00, 0x00                                ; 0E7CF
  db 0x00, 0x00                                ; 0E7D1
  db 0x00, 0x00                                ; 0E7D3
  db 0x00, 0x00                                ; 0E7D5
  db 0x00, 0x00                                ; 0E7D7
  db 0x00, 0x00                                ; 0E7D9
  db 0x00, 0x00                                ; 0E7DB
  db 0x00, 0x00                                ; 0E7DD
  db 0x00, 0x00                                ; 0E7DF
  add [0x7c], ah                               ; 0E7E1  0x00, 0x26, 0x7C, 0x00
  db 0x00, 0x00                                ; 0E7E5
  db 0x00, 0x00                                ; 0E7E7
  db 0x00, 0x00                                ; 0E7E9
  db 0x00, 0x00                                ; 0E7EB
  db 0x00, 0x00                                ; 0E7ED
  db 0x00, 0x00                                ; 0E7EF
  db 0x00, 0x00                                ; 0E7F1
  db 0x00, 0x00                                ; 0E7F3
  db 0x00, 0x00                                ; 0E7F5
  db 0x00, 0x00                                ; 0E7F7
  db 0x00, 0x00                                ; 0E7F9
  db 0x00, 0x00                                ; 0E7FB
  add [bp + si + 0x7c], al                     ; 0E7FD  0x00, 0x42, 0x7C
  db 0x00, 0x00                                ; 0E800
  db 0x00, 0x00                                ; 0E802
  db 0x00, 0x00                                ; 0E804
  db 0x00, 0x00                                ; 0E806
  db 0x00, 0x00                                ; 0E808
  db 0x00, 0x00                                ; 0E80A
  db 0x00, 0x00                                ; 0E80C
  db 0x00, 0x00                                ; 0E80E
  db 0x00, 0x00                                ; 0E810
  db 0x00, 0x00                                ; 0E812
  db 0x00, 0x00                                ; 0E814
  db 0x00, 0x00                                ; 0E816
  db 0x00, 0x00                                ; 0E818
  pop si                                       ; 0E81A  0x5E
  jl loc_0E81D                                 ; 0E81B  0x7C, 0x00

loc_0E81D:                                     ; 0E81D
  db 0x00, 0x00                                ; 0E81D
  db 0x00, 0x00                                ; 0E81F
  db 0x00, 0x00                                ; 0E821
  db 0x00, 0x00                                ; 0E823
  db 0x00, 0x00                                ; 0E825
  db 0x00, 0x00                                ; 0E827
  db 0x00, 0x00                                ; 0E829
  db 0x00, 0x00                                ; 0E82B
  db 0x00, 0x00                                ; 0E82D
  db 0x00, 0x00                                ; 0E82F
  db 0x00, 0x00                                ; 0E831
  db 0x00, 0x00                                ; 0E833
  add [bp + si + 0x7c], bh                     ; 0E835  0x00, 0x7A, 0x7C
  db 0x00, 0x00                                ; 0E838
  db 0x00, 0x00                                ; 0E83A
  db 0x00, 0x00                                ; 0E83C
  db 0x00, 0x00                                ; 0E83E
  db 0x00, 0x00                                ; 0E840
  db 0x00, 0x00                                ; 0E842
  db 0x00, 0x00                                ; 0E844
  db 0x00, 0x00                                ; 0E846
  db 0x00, 0x00                                ; 0E848
  db 0x00, 0x00                                ; 0E84A
  db 0x00, 0x00                                ; 0E84C
  db 0x00, 0x00                                ; 0E84E
  db 0x00, 0x00                                ; 0E850
  xchg si, ax                                  ; 0E852  0x96
  jl loc_0E855                                 ; 0E853  0x7C, 0x00

loc_0E855:                                     ; 0E855
  db 0x00, 0x00                                ; 0E855
  db 0x00, 0x00                                ; 0E857
  db 0x00, 0x00                                ; 0E859
  db 0x00, 0x00                                ; 0E85B
  db 0x00, 0x00                                ; 0E85D
  db 0x00, 0x00                                ; 0E85F
  db 0x00, 0x00                                ; 0E861
  db 0x00, 0x00                                ; 0E863
  db 0x00, 0x00                                ; 0E865
  db 0x00, 0x00                                ; 0E867
  db 0x00, 0x00                                ; 0E869
  db 0x00, 0x00                                ; 0E86B
  db 0x00, 0xB2, 0x7C, 0x00                    ; 0E86D  add byte [bp + si + 0x7c], dh
  db 0x00, 0x00                                ; 0E871
  db 0x00, 0x00                                ; 0E873
  db 0x00, 0x00                                ; 0E875
  db 0x00, 0x00                                ; 0E877
  db 0x00, 0x00                                ; 0E879
  db 0x00, 0x00                                ; 0E87B
  db 0x00, 0x00                                ; 0E87D
  db 0x00, 0x00                                ; 0E87F
  db 0x00, 0x00                                ; 0E881
  db 0x00, 0x00                                ; 0E883
  db 0x00, 0x00                                ; 0E885
  db 0x00, 0x00                                ; 0E887
  add dh, cl                                   ; 0E889  0x00, 0xCE
  jl loc_0E88D                                 ; 0E88B  0x7C, 0x00

loc_0E88D:                                     ; 0E88D
  db 0x00, 0x00                                ; 0E88D
  db 0x00, 0x00                                ; 0E88F
  db 0x00, 0x00                                ; 0E891
  db 0x00, 0x00                                ; 0E893
  db 0x00, 0x00                                ; 0E895
  db 0x00, 0x00                                ; 0E897
  db 0x00, 0x00                                ; 0E899
  db 0x00, 0x00                                ; 0E89B
  db 0x00, 0x00                                ; 0E89D
  db 0x00, 0x00                                ; 0E89F
  db 0x00, 0x00                                ; 0E8A1
  db 0x00, 0x00                                ; 0E8A3
  add dl, ch                                   ; 0E8A5  0x00, 0xEA
  jl loc_0E8A9                                 ; 0E8A7  0x7C, 0x00

loc_0E8A9:                                     ; 0E8A9
  db 0x00, 0x00                                ; 0E8A9
  db 0x00, 0x00                                ; 0E8AB
  db 0x00, 0x00                                ; 0E8AD
  db 0x00, 0x00                                ; 0E8AF
  db 0x00, 0x00                                ; 0E8B1
  db 0x00, 0x00                                ; 0E8B3
  db 0x00, 0x00                                ; 0E8B5
  db 0x00, 0x00                                ; 0E8B7
  db 0x00, 0x00                                ; 0E8B9
  db 0x00, 0x00                                ; 0E8BB
  db 0x00, 0x00                                ; 0E8BD
  db 0x00, 0x00                                ; 0E8BF
  add [0x7d], al                               ; 0E8C1  0x00, 0x06, 0x7D, 0x00
  db 0x00, 0x00                                ; 0E8C5
  db 0x00, 0x00                                ; 0E8C7
  db 0x00, 0x00                                ; 0E8C9
  db 0x00, 0x00                                ; 0E8CB
  db 0x00, 0x00                                ; 0E8CD
  db 0x00, 0x00                                ; 0E8CF
  db 0x00, 0x00                                ; 0E8D1
  db 0x00, 0x00                                ; 0E8D3
  db 0x00, 0x00                                ; 0E8D5
  db 0x00, 0x00                                ; 0E8D7
  db 0x00, 0x00                                ; 0E8D9
  db 0x00, 0x00                                ; 0E8DB
  add [bp + si], ah                            ; 0E8DD  0x00, 0x22
  jge loc_0E8E1                                ; 0E8DF  0x7D, 0x00

loc_0E8E1:                                     ; 0E8E1
  db 0x00, 0x00                                ; 0E8E1
  db 0x00, 0x00                                ; 0E8E3
  db 0x00, 0x00                                ; 0E8E5
  db 0x00, 0x00                                ; 0E8E7
  db 0x00, 0x00                                ; 0E8E9
  db 0x00, 0x00                                ; 0E8EB
  db 0x00, 0x00                                ; 0E8ED
  db 0x00, 0x00                                ; 0E8EF
  db 0x00, 0x00                                ; 0E8F1
  db 0x00, 0x00                                ; 0E8F3
  db 0x00, 0x00                                ; 0E8F5
  db 0x00, 0x00                                ; 0E8F7
  add [0x7d], bh                               ; 0E8F9  0x00, 0x3E, 0x7D, 0x00
  db 0x00, 0x00                                ; 0E8FD
  db 0x00, 0x00                                ; 0E8FF
  db 0x00, 0x00                                ; 0E901
  db 0x00, 0x00                                ; 0E903
  db 0x00, 0x00                                ; 0E905
  db 0x00, 0x00                                ; 0E907
  db 0x00, 0x00                                ; 0E909
  db 0x00, 0x00                                ; 0E90B
  db 0x00, 0x00                                ; 0E90D
  db 0x00, 0x00                                ; 0E90F
  db 0x00, 0x00                                ; 0E911
  db 0x00, 0x00                                ; 0E913
  add [bp + si + 0x7d], bl                     ; 0E915  0x00, 0x5A, 0x7D
  db 0x00, 0x00                                ; 0E918
  db 0x00, 0x00                                ; 0E91A
  db 0x00, 0x00                                ; 0E91C
  db 0x00, 0x00                                ; 0E91E
  db 0x00, 0x00                                ; 0E920
  db 0x00, 0x00                                ; 0E922
  db 0x00, 0x00                                ; 0E924
  db 0x00, 0x00                                ; 0E926
  db 0x00, 0x00                                ; 0E928
  db 0x00, 0x00                                ; 0E92A
  db 0x00, 0x00                                ; 0E92C
  db 0x00, 0x00                                ; 0E92E
  db 0x00, 0x00                                ; 0E930
  db 0x76, 0x7D                                ; 0E932  jbe 0xe9b1
  db 0x00, 0x00                                ; 0E934
  db 0x00, 0x00                                ; 0E936
  db 0x00, 0x00                                ; 0E938
  db 0x00, 0x00                                ; 0E93A
  db 0x00, 0x00                                ; 0E93C
  db 0x00, 0x00                                ; 0E93E
  db 0x00, 0x00                                ; 0E940
  db 0x00, 0x00                                ; 0E942
  db 0x00, 0x00                                ; 0E944
  db 0x00, 0x00                                ; 0E946
  db 0x00, 0x00                                ; 0E948
  db 0x00, 0x00                                ; 0E94A
  db 0x00, 0x00                                ; 0E94C
  xchg dx, ax                                  ; 0E94E  0x92
  jge loc_0E951                                ; 0E94F  0x7D, 0x00

loc_0E951:                                     ; 0E951
  db 0x00, 0x00                                ; 0E951
  db 0x00, 0x00                                ; 0E953
  db 0x00, 0x00                                ; 0E955
  db 0x00, 0x00                                ; 0E957
  db 0x00, 0x00                                ; 0E959
  db 0x00, 0x00                                ; 0E95B
  db 0x00, 0x00                                ; 0E95D
  db 0x00, 0x00                                ; 0E95F
  db 0x00, 0x00                                ; 0E961
  db 0x00, 0x00                                ; 0E963
  db 0x00, 0x00                                ; 0E965
  db 0x00, 0x00                                ; 0E967
  db 0x00, 0x00                                ; 0E969
  db 0x00, 0x00                                ; 0E96B
  db 0x00, 0x00                                ; 0E96D
  db 0x00, 0x00                                ; 0E96F
  db 0x00, 0x00                                ; 0E971
  add dl, cl                                   ; 0E973  0x00, 0xCA
  jge loc_0E977                                ; 0E975  0x7D, 0x00

loc_0E977:                                     ; 0E977
  db 0x00, 0x00                                ; 0E977
  db 0x00, 0x00                                ; 0E979
  db 0x00, 0x00                                ; 0E97B
  add ah, dl                                   ; 0E97D  0x00, 0xD4
  jge loc_0E981                                ; 0E97F  0x7D, 0x00

loc_0E981:                                     ; 0E981
  db 0x00, 0x00                                ; 0E981
  db 0x00, 0x00                                ; 0E983
  db 0x00, 0x00                                ; 0E985
  add dh, bl                                   ; 0E987  0x00, 0xDE
  jge loc_0E98B                                ; 0E989  0x7D, 0x00

loc_0E98B:                                     ; 0E98B
  db 0x00, 0x00                                ; 0E98B
  db 0x00, 0x00                                ; 0E98D
  db 0x00, 0x00                                ; 0E98F
  add al, ch                                   ; 0E991  0x00, 0xE8
  jge loc_0E995                                ; 0E993  0x7D, 0x00

loc_0E995:                                     ; 0E995
  db 0x00, 0x00                                ; 0E995
  db 0x00, 0x00                                ; 0E997
  db 0x00, 0x00                                ; 0E999
  add dl, dh                                   ; 0E99B  0x00, 0xF2
  jge loc_0E99F                                ; 0E99D  0x7D, 0x00

loc_0E99F:                                     ; 0E99F
  db 0x00, 0x00                                ; 0E99F
  db 0x00, 0x00                                ; 0E9A1
  db 0x00, 0x00                                ; 0E9A3
  add ah, bh                                   ; 0E9A5  0x00, 0xFC
  jge loc_0E9A9                                ; 0E9A7  0x7D, 0x00

loc_0E9A9:                                     ; 0E9A9
  db 0x00, 0x00                                ; 0E9A9
  db 0x00, 0x00                                ; 0E9AB
  db 0x00, 0x00                                ; 0E9AD
  add [0x7e], al                               ; 0E9AF  0x00, 0x06, 0x7E, 0x00
  db 0x00, 0x00                                ; 0E9B3
  db 0x00, 0x00                                ; 0E9B5
  db 0x00, 0x00                                ; 0E9B7
  add [bx + si], dl                            ; 0E9B9  0x00, 0x10
  jle loc_0E9BD                                ; 0E9BB  0x7E, 0x00

loc_0E9BD:                                     ; 0E9BD
  db 0x00, 0x00                                ; 0E9BD
  db 0x00, 0x00                                ; 0E9BF
  db 0x00, 0x00                                ; 0E9C1
  add [bp + si], bl                            ; 0E9C3  0x00, 0x1A
  jle loc_0E9C7                                ; 0E9C5  0x7E, 0x00

loc_0E9C7:                                     ; 0E9C7
  db 0x00, 0x00                                ; 0E9C7
  db 0x00, 0x00                                ; 0E9C9
  db 0x00, 0x00                                ; 0E9CB
  add [si], ah                                 ; 0E9CD  0x00, 0x24
  jle loc_0E9D1                                ; 0E9CF  0x7E, 0x00

loc_0E9D1:                                     ; 0E9D1
  db 0x00, 0x00                                ; 0E9D1
  db 0x00, 0x00                                ; 0E9D3
  db 0x00, 0x00                                ; 0E9D5
  add [0x7e], ch                               ; 0E9D7  0x00, 0x2E, 0x7E, 0x00
  db 0x00, 0x00                                ; 0E9DB
  db 0x00, 0x00                                ; 0E9DD
  db 0x00, 0x00                                ; 0E9DF
  add [bx + si], bh                            ; 0E9E1  0x00, 0x38
  jle loc_0E9E5                                ; 0E9E3  0x7E, 0x00

loc_0E9E5:                                     ; 0E9E5
  db 0x00, 0x00                                ; 0E9E5
  db 0x00, 0x00                                ; 0E9E7
  db 0x00, 0x00                                ; 0E9E9
  add [bp + si + 0x7e], al                     ; 0E9EB  0x00, 0x42, 0x7E
  db 0x00, 0x00                                ; 0E9EE
  db 0x00, 0x00                                ; 0E9F0
  db 0x00, 0x00                                ; 0E9F2
  db 0x00, 0x00                                ; 0E9F4
  dec sp                                       ; 0E9F6  0x4C
  jle loc_0E9F9                                ; 0E9F7  0x7E, 0x00

loc_0E9F9:                                     ; 0E9F9
  db 0x00, 0x00                                ; 0E9F9
  db 0x00, 0x00                                ; 0E9FB
  db 0x00, 0x00                                ; 0E9FD
  add [bp + 0x7e], dl                          ; 0E9FF  0x00, 0x56, 0x7E
  db 0x00, 0x00                                ; 0EA02
  db 0x00, 0x00                                ; 0EA04
  db 0x00, 0x00                                ; 0EA06
  db 0x00, 0x00                                ; 0EA08
  db 0x60                                      ; 0EA0A  pusha
  jle loc_0EA0D                                ; 0EA0B  0x7E, 0x00

loc_0EA0D:                                     ; 0EA0D
  db 0x00, 0x00                                ; 0EA0D
  db 0x00, 0x00                                ; 0EA0F
  db 0x00, 0x00                                ; 0EA11
  add [bp + si + 0x7e], ch                     ; 0EA13  0x00, 0x6A, 0x7E
  db 0x00, 0x00                                ; 0EA16
  db 0x00, 0x00                                ; 0EA18
  db 0x00, 0x00                                ; 0EA1A
  db 0x00, 0x00                                ; 0EA1C
  db 0x74, 0x7E                                ; 0EA1E  je 0xea9e
  db 0x00, 0x00                                ; 0EA20
  db 0x00, 0x00                                ; 0EA22
  db 0x00, 0x00                                ; 0EA24
  db 0x00, 0x00                                ; 0EA26
  db 0x7E, 0x7E                                ; 0EA28  jle 0xeaa8
  db 0x00, 0x00                                ; 0EA2A
  db 0x00, 0x00                                ; 0EA2C
  db 0x00, 0x00                                ; 0EA2E
  db 0x00, 0x00                                ; 0EA30
  mov [bp], bh                                 ; 0EA32  0x88, 0x7E, 0x00
  db 0x00, 0x00                                ; 0EA35
  db 0x00, 0x00                                ; 0EA37
  db 0x00, 0x00                                ; 0EA39
  db 0x00, 0x92, 0x7E, 0x00                    ; 0EA3B  add byte [bp + si + 0x7e], dl
  db 0x00, 0x00                                ; 0EA3F
  db 0x00, 0x00                                ; 0EA41
  db 0x00, 0x00                                ; 0EA43
  db 0x00, 0x9C, 0x7E, 0x00                    ; 0EA45  add byte [si + 0x7e], bl
  db 0x00, 0x00                                ; 0EA49
  db 0x00, 0x00                                ; 0EA4B
  db 0x00, 0x00                                ; 0EA4D
  db 0x00, 0xA6, 0x7E, 0x00                    ; 0EA4F  add byte [bp + 0x7e], ah
  db 0x00, 0x00                                ; 0EA53
  db 0x00, 0x00                                ; 0EA55
  db 0x00, 0x00                                ; 0EA57
  db 0x00, 0xB0, 0x7E, 0x00                    ; 0EA59  add byte [bx + si + 0x7e], dh
  db 0x00, 0x00                                ; 0EA5D
  db 0x00, 0x00                                ; 0EA5F
  db 0x00, 0x00                                ; 0EA61
  db 0x00, 0xBA, 0x7E, 0x00                    ; 0EA63  add byte [bp + si + 0x7e], bh
  db 0x00, 0x00                                ; 0EA67
  db 0x00, 0x00                                ; 0EA69
  db 0x00, 0x00                                ; 0EA6B
  add ah, al                                   ; 0EA6D  0x00, 0xC4
  jle loc_0EA71                                ; 0EA6F  0x7E, 0x00

loc_0EA71:                                     ; 0EA71
  db 0x00, 0x00                                ; 0EA71
  db 0x00, 0x00                                ; 0EA73
  db 0x00, 0x00                                ; 0EA75
  add dh, cl                                   ; 0EA77  0x00, 0xCE
  jle loc_0EA7B                                ; 0EA79  0x7E, 0x00

loc_0EA7B:                                     ; 0EA7B
  db 0x00, 0x00                                ; 0EA7B
  db 0x00, 0x00                                ; 0EA7D
  db 0x00, 0x00                                ; 0EA7F
  add al, bl                                   ; 0EA81  0x00, 0xD8
  jle loc_0EA85                                ; 0EA83  0x7E, 0x00

loc_0EA85:                                     ; 0EA85
  db 0x00, 0x00                                ; 0EA85
  db 0x00, 0x00                                ; 0EA87
  db 0x00, 0x00                                ; 0EA89
  add dl, ah                                   ; 0EA8B  0x00, 0xE2
  jle loc_0EA8F                                ; 0EA8D  0x7E, 0x00

loc_0EA8F:                                     ; 0EA8F
  db 0x00, 0x00                                ; 0EA8F
  db 0x00, 0x00                                ; 0EA91
  db 0x00, 0x00                                ; 0EA93
  add ah, ch                                   ; 0EA95  0x00, 0xEC
  jle loc_0EA99                                ; 0EA97  0x7E, 0x00

loc_0EA99:                                     ; 0EA99
  db 0x00, 0x00                                ; 0EA99
  db 0x00, 0x00                                ; 0EA9B
  db 0x00, 0x00                                ; 0EA9D
  add dh, dh                                   ; 0EA9F  0x00, 0xF6
  jle loc_0EAA3                                ; 0EAA1  0x7E, 0x00

loc_0EAA3:                                     ; 0EAA3
  db 0x00, 0x00                                ; 0EAA3
  db 0x00, 0x00                                ; 0EAA5
  db 0x00, 0x00                                ; 0EAA7
  db 0x00, 0x00                                ; 0EAA9
  jg loc_0EAAD                                 ; 0EAAB  0x7F, 0x00

loc_0EAAD:                                     ; 0EAAD
  db 0x00, 0x00                                ; 0EAAD
  db 0x00, 0x00                                ; 0EAAF
  db 0x00, 0x00                                ; 0EAB1
  add [bp + si], cl                            ; 0EAB3  0x00, 0x0A
  jg loc_0EAB7                                 ; 0EAB5  0x7F, 0x00

loc_0EAB7:                                     ; 0EAB7
  db 0x00, 0x00                                ; 0EAB7
  db 0x00, 0x00                                ; 0EAB9
  db 0x00, 0x00                                ; 0EABB
  add [si], dl                                 ; 0EABD  0x00, 0x14
  jg loc_0EAC1                                 ; 0EABF  0x7F, 0x00

loc_0EAC1:                                     ; 0EAC1
  db 0x00, 0x00                                ; 0EAC1
  db 0x00, 0x00                                ; 0EAC3
  db 0x00, 0x00                                ; 0EAC5
  add [0x7f], bl                               ; 0EAC7  0x00, 0x1E, 0x7F, 0x00
  db 0x00, 0x00                                ; 0EACB
  db 0x00, 0x00                                ; 0EACD
  db 0x00, 0x00                                ; 0EACF
  add [bx + si], ch                            ; 0EAD1  0x00, 0x28
  jg loc_0EAD5                                 ; 0EAD3  0x7F, 0x00

loc_0EAD5:                                     ; 0EAD5
  db 0x00, 0x00                                ; 0EAD5
  db 0x00, 0x00                                ; 0EAD7
  db 0x00, 0x00                                ; 0EAD9
  add [bp + si], dh                            ; 0EADB  0x00, 0x32
  jg loc_0EADF                                 ; 0EADD  0x7F, 0x00

loc_0EADF:                                     ; 0EADF
  db 0x00, 0x00                                ; 0EADF
  db 0x00, 0x00                                ; 0EAE1
  db 0x00, 0x00                                ; 0EAE3
  add [si], bh                                 ; 0EAE5  0x00, 0x3C
  jg loc_0EAE9                                 ; 0EAE7  0x7F, 0x00

loc_0EAE9:                                     ; 0EAE9
  db 0x00, 0x00                                ; 0EAE9
  db 0x00, 0x00                                ; 0EAEB
  db 0x00, 0x00                                ; 0EAED
  add [bp + 0x7f], al                          ; 0EAEF  0x00, 0x46, 0x7F
  db 0x00, 0x00                                ; 0EAF2
  db 0x00, 0x00                                ; 0EAF4
  db 0x00, 0x00                                ; 0EAF6
  db 0x00, 0x00                                ; 0EAF8
  push ax                                      ; 0EAFA  0x50
  jg loc_0EAFD                                 ; 0EAFB  0x7F, 0x00

loc_0EAFD:                                     ; 0EAFD
  db 0x00, 0x00                                ; 0EAFD
  db 0x00, 0x00                                ; 0EAFF
  db 0x00, 0x00                                ; 0EB01
  add [bp + si + 0x7f], bl                     ; 0EB03  0x00, 0x5A, 0x7F
  db 0x00, 0x00                                ; 0EB06
  db 0x00, 0x00                                ; 0EB08
  db 0x00, 0x00                                ; 0EB0A
  db 0x00, 0x00                                ; 0EB0C
  db 0x64, 0x7F, 0x00                          ; 0EB0E  jg 0xeb11

loc_0EB11:                                     ; 0EB11
  db 0x00, 0x00                                ; 0EB11
  db 0x00, 0x00                                ; 0EB13
  db 0x00, 0x00                                ; 0EB15
  add [bp + 0x7f], ch                          ; 0EB17  0x00, 0x6E, 0x7F
  db 0x00, 0x00                                ; 0EB1A
  db 0x00, 0x00                                ; 0EB1C
  db 0x00, 0x00                                ; 0EB1E
  db 0x00, 0x00                                ; 0EB20
  js loc_0EBA3                                 ; 0EB22  0x78, 0x7F
  db 0x00, 0x00                                ; 0EB24
  db 0x00, 0x00                                ; 0EB26
  db 0x00, 0x00                                ; 0EB28
  db 0x00, 0x00                                ; 0EB2A
  db 0x82, 0x7F, 0x00, 0x00                    ; 0EB2C  cmp byte [bx], 0
  db 0x00, 0x00                                ; 0EB30
  db 0x00, 0x00                                ; 0EB32
  db 0x00, 0x00                                ; 0EB34
  db 0x8C                                      ; 0EB36  .
  jg loc_0EB39                                 ; 0EB37  0x7F, 0x00

loc_0EB39:                                     ; 0EB39
  db 0x00, 0x00                                ; 0EB39
  db 0x00, 0x00                                ; 0EB3B
  db 0x00, 0x00                                ; 0EB3D
  db 0x00, 0x96, 0x7F, 0x00                    ; 0EB3F  add byte [bp + 0x7f], dl
  db 0x00, 0x00                                ; 0EB43
  db 0x00, 0x00                                ; 0EB45
  db 0x00, 0x00                                ; 0EB47
  db 0x00, 0xA0, 0x7F, 0x00                    ; 0EB49  add byte [bx + si + 0x7f], ah
  db 0x00, 0x00                                ; 0EB4D
  db 0x00, 0x00                                ; 0EB4F
  db 0x00, 0x00                                ; 0EB51
  db 0x00, 0xAA, 0x7F, 0x00                    ; 0EB53  add byte [bp + si + 0x7f], ch
  db 0x00, 0x00                                ; 0EB57
  db 0x00, 0x00                                ; 0EB59
  db 0x00, 0x00                                ; 0EB5B
  db 0x00, 0xB4, 0x7F, 0x00                    ; 0EB5D  add byte [si + 0x7f], dh
  db 0x00, 0x00                                ; 0EB61
  db 0x00, 0x00                                ; 0EB63
  db 0x00, 0x00                                ; 0EB65
  db 0x00, 0xBE, 0x7F, 0x00                    ; 0EB67  add byte [bp + 0x7f], bh
  db 0x00, 0x00                                ; 0EB6B
  db 0x00, 0x00                                ; 0EB6D
  db 0x00, 0x00                                ; 0EB6F
  add al, cl                                   ; 0EB71  0x00, 0xC8
  jg loc_0EB75                                 ; 0EB73  0x7F, 0x00

loc_0EB75:                                     ; 0EB75
  db 0x00, 0x00                                ; 0EB75
  db 0x00, 0x00                                ; 0EB77
  db 0x00, 0x00                                ; 0EB79
  add dl, dl                                   ; 0EB7B  0x00, 0xD2
  jg loc_0EB7F                                 ; 0EB7D  0x7F, 0x00

loc_0EB7F:                                     ; 0EB7F
  db 0x00, 0x00                                ; 0EB7F
  db 0x00, 0x00                                ; 0EB81
  db 0x00, 0x00                                ; 0EB83
  add ah, bl                                   ; 0EB85  0x00, 0xDC
  jg loc_0EB89                                 ; 0EB87  0x7F, 0x00

loc_0EB89:                                     ; 0EB89
  db 0x00, 0x00                                ; 0EB89
  db 0x00, 0x00                                ; 0EB8B
  db 0x00, 0x00                                ; 0EB8D
  add dh, ah                                   ; 0EB8F  0x00, 0xE6
  jg loc_0EB93                                 ; 0EB91  0x7F, 0x00

loc_0EB93:                                     ; 0EB93
  db 0x00, 0x00                                ; 0EB93
  db 0x00, 0x00                                ; 0EB95
  db 0x00, 0x00                                ; 0EB97
  add al, dh                                   ; 0EB99  0x00, 0xF0
  jg loc_0EB9D                                 ; 0EB9B  0x7F, 0x00

loc_0EB9D:                                     ; 0EB9D
  db 0x00, 0x00                                ; 0EB9D
  db 0x00, 0x00                                ; 0EB9F
  db 0x00, 0x00                                ; 0EBA1

loc_0EBA3:                                     ; 0EBA3
  add dl, bh                                   ; 0EBA3  0x00, 0xFA
  jg loc_0EBA7                                 ; 0EBA5  0x7F, 0x00

loc_0EBA7:                                     ; 0EBA7
  db 0x00, 0x00                                ; 0EBA7
  db 0x00, 0x00                                ; 0EBA9
  db 0x00, 0x00                                ; 0EBAB
  add [si], al                                 ; 0EBAD  0x00, 0x04
  add byte [bx + si], 0                        ; 0EBAF  0x80, 0x00, 0x00
  db 0x00, 0x00                                ; 0EBB2
  db 0x00, 0x00                                ; 0EBB4
  db 0x00, 0x00                                ; 0EBB6
  push cs                                      ; 0EBB8  0x0E
  add byte [bx + si], 0                        ; 0EBB9  0x80, 0x00, 0x00
  db 0x00, 0x00                                ; 0EBBC
  db 0x00, 0x00                                ; 0EBBE
  db 0x00, 0x00                                ; 0EBC0
  db 0x18, 0x80, 0x00, 0x00                    ; 0EBC2  sbb byte [bx + si], al
  db 0x00, 0x00                                ; 0EBC6
  db 0x00, 0x00                                ; 0EBC8
  db 0x00, 0x00                                ; 0EBCA
  db 0x22, 0x80, 0x00, 0x00                    ; 0EBCC  and al, byte [bx + si]
  db 0x00, 0x00                                ; 0EBD0
  db 0x00, 0x00                                ; 0EBD2
  db 0x00, 0x00                                ; 0EBD4
  sub al, 0x80                                 ; 0EBD6  0x2C, 0x80
  db 0x00, 0x00                                ; 0EBD8
  db 0x00, 0x00                                ; 0EBDA
  db 0x00, 0x00                                ; 0EBDC
  db 0x00, 0x00                                ; 0EBDE
  add byte [ss:bx + si], 0                     ; 0EBE0  0x36, 0x80, 0x00, 0x00
  db 0x00, 0x00                                ; 0EBE4
  db 0x00, 0x00                                ; 0EBE6
  db 0x00, 0x00                                ; 0EBE8
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EBEA  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EBFA  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EC0A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EC1A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EC2A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EC3A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EC4A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EC5A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EC6A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EC7A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EC8A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EC9A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0ECAA  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0ECBA  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0ECCA  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0ECDA  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0ECEA  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0ECFA  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0ED0A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0ED1A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0ED2A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0ED3A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0ED4A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0ED5A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0ED6A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0ED7A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0ED8A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0ED9A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EDAA  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EDBA  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EDCA  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EDDA  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EDEA  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EDFA  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EE0A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EE1A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EE2A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EE3A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EE4A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EE5A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EE6A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EE7A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EE8A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EE9A  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EEAA  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EEBA  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EECA  ................
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 0EEDA  ............
  inc word [bx + si]                           ; 0EEE6  0xFF, 0x00
  db 0x00, 0x00                                ; 0EEE8
  db 0x00, 0x00                                ; 0EEEA
  db 0x00, 0x00                                ; 0EEEC
  db 0x00, 0x00                                ; 0EEEE
  db 0x61                                      ; 0EEF0  popa
  db 0x00, 0x00                                ; 0EEF1
  db 0x00, 0x00                                ; 0EEF3
  cmp al, [di + 0x800]                         ; 0EEF5  0x3A, 0x85, 0x00, 0x08
  db 0x00, 0x00                                ; 0EEF9
  db 0x00, 0x00                                ; 0EEFB
  db 0x00, 0x00                                ; 0EEFD
  db 0x00, 0x00                                ; 0EEFF
  db 0x00, 0x00                                ; 0EF01
  db 0x00, 0x00                                ; 0EF03
  db 0x00, 0x00                                ; 0EF05
  db 0x00, 0x00                                ; 0EF07
  db 0x00, 0x00                                ; 0EF09
  db 0x00, 0x00                                ; 0EF0B
  db 0x00, 0x00                                ; 0EF0D
  db 0x00, 0x00                                ; 0EF0F
  db 0x00, 0x00                                ; 0EF11
  db 0x00, 0x00                                ; 0EF13
  db 0x00, 0x00                                ; 0EF15
  db 0x00, 0x00                                ; 0EF17
  db 0x00, 0x00                                ; 0EF19
  db 0x00, 0x00                                ; 0EF1B
  db 0x00, 0x00                                ; 0EF1D
  db 0x00, 0x00                                ; 0EF1F
  db 0x00, 0x00                                ; 0EF21
  db 0x00, 0x00                                ; 0EF23
  db 0x00, 0x00                                ; 0EF25
  db 0x00, 0x00                                ; 0EF27
  db 0x00, 0x00                                ; 0EF29
  db 0x00, 0x00                                ; 0EF2B
  db 0x00, 0x00                                ; 0EF2D
  db 0x00, 0x00                                ; 0EF2F
  db 0x00, 0x00                                ; 0EF31
  db 0x00, 0x00                                ; 0EF33
  db 0x00, 0x00                                ; 0EF35
  db 0x00, 0x00                                ; 0EF37
  db 0x00, 0x00                                ; 0EF39
  db 0x00, 0x00                                ; 0EF3B
  db 0x00, 0x00                                ; 0EF3D
  db 0x00, 0x00                                ; 0EF3F
  db 0x00, 0x00                                ; 0EF41
  db 0x00, 0x00                                ; 0EF43
  db 0x00, 0x00                                ; 0EF45
  db 0x00, 0x00                                ; 0EF47
  db 0x00, 0x00                                ; 0EF49
  db 0x00, 0x00                                ; 0EF4B
  db 0x00, 0x00                                ; 0EF4D
  db 0x00, 0x00                                ; 0EF4F
  db 0x00, 0x00                                ; 0EF51
  db 0x00, 0x00                                ; 0EF53
  db 0x00, 0x00                                ; 0EF55
  db 0x00, 0x00                                ; 0EF57
  db 0x00, 0x00                                ; 0EF59
  db 0x00, 0x00                                ; 0EF5B
  db 0x00, 0x00                                ; 0EF5D
  db 0x00, 0x00                                ; 0EF5F
  db 0x00, 0x00                                ; 0EF61
  db 0x00, 0x00                                ; 0EF63
  db 0x00, 0x00                                ; 0EF65
  db 0x00, 0x00                                ; 0EF67
  db 0x00, 0x00                                ; 0EF69
  db 0x00, 0x00                                ; 0EF6B
  db 0x00, 0x00                                ; 0EF6D
  db 0x00, 0x00                                ; 0EF6F
  db 0x00, 0x00                                ; 0EF71
  db 0x00, 0x00                                ; 0EF73
  db 0x00, 0x00                                ; 0EF75
  db 0x00, 0x00                                ; 0EF77
  db 0x00, 0x00                                ; 0EF79
  db 0x00, 0x00                                ; 0EF7B
  db 0x00, 0x00                                ; 0EF7D
  db 0x00, 0x00                                ; 0EF7F
  db 0x00, 0x00                                ; 0EF81
  db 0x00, 0x00                                ; 0EF83
  db 0x00, 0x00                                ; 0EF85
  db 0x00, 0x00                                ; 0EF87
  db 0x00, 0x00                                ; 0EF89
  db 0x00, 0x00                                ; 0EF8B
  db 0x00, 0x00                                ; 0EF8D
  db 0x00, 0x00                                ; 0EF8F
  db 0x00, 0x00                                ; 0EF91
  db 0x00, 0x00                                ; 0EF93
  db 0x00, 0x00                                ; 0EF95
  db 0x00, 0x00                                ; 0EF97
  db 0x00, 0x00                                ; 0EF99
  db 0x00, 0x00                                ; 0EF9B
  db 0x00, 0x00                                ; 0EF9D
  db 0x00, 0x00                                ; 0EF9F
  db 0x00, 0x00                                ; 0EFA1
  db 0x00, 0x00                                ; 0EFA3
  db 0x00, 0x00                                ; 0EFA5
  db 0x00, 0x00                                ; 0EFA7
  db 0x00, 0x00                                ; 0EFA9
  db 0x00, 0x00                                ; 0EFAB
  db 0x00, 0x00                                ; 0EFAD
  db 0x00, 0x00                                ; 0EFAF
  db 0x00, 0x00                                ; 0EFB1
  db 0x00, 0x00                                ; 0EFB3
  db 0x00, 0x00                                ; 0EFB5
  db 0x00, 0x00                                ; 0EFB7
  db 0x00, 0x00                                ; 0EFB9
  db 0x00, 0x00                                ; 0EFBB
  db 0x00, 0x00                                ; 0EFBD
  db 0x00, 0x00                                ; 0EFBF
  db 0x00, 0x00                                ; 0EFC1
  db 0x00, 0x00                                ; 0EFC3
  db 0x00, 0x00                                ; 0EFC5
  db 0x00, 0x00                                ; 0EFC7
  db 0x00, 0x00                                ; 0EFC9
  db 0x00, 0x00                                ; 0EFCB
  db 0x00, 0x00                                ; 0EFCD
  db 0x00, 0x00                                ; 0EFCF
  db 0x00, 0x00                                ; 0EFD1
  db 0x00, 0x00                                ; 0EFD3
  db 0x00, 0x00                                ; 0EFD5
  db 0x00, 0x00                                ; 0EFD7
  db 0x00, 0x00                                ; 0EFD9
  db 0x00, 0x00                                ; 0EFDB
  db 0x00, 0x00                                ; 0EFDD
  db 0x00, 0x00                                ; 0EFDF
  db 0x00, 0x00                                ; 0EFE1
  db 0x00, 0x00                                ; 0EFE3
  db 0x00, 0x00                                ; 0EFE5
  db 0x00, 0x00                                ; 0EFE7
  db 0x00, 0x00                                ; 0EFE9
  db 0x00, 0x00                                ; 0EFEB
  db 0x00, 0x00                                ; 0EFED
  db 0x00, 0x00                                ; 0EFEF
  db 0x00, 0x00                                ; 0EFF1
  db 0x00, 0x00                                ; 0EFF3
  db 0x00, 0x00                                ; 0EFF5
  db 0x00, 0x00                                ; 0EFF7
  db 0x00, 0x00                                ; 0EFF9
  db 0x00, 0x00                                ; 0EFFB
  db 0x00, 0x00                                ; 0EFFD
  db 0x00, 0x00                                ; 0EFFF
  db 0x00, 0x00                                ; 0F001
  db 0x00, 0x00                                ; 0F003
  db 0x00, 0x00                                ; 0F005
  db 0x00, 0x00                                ; 0F007
  db 0x00, 0x00                                ; 0F009
  db 0x00, 0x00                                ; 0F00B
  db 0x00, 0x00                                ; 0F00D
  db 0x00, 0x00                                ; 0F00F
  db 0x00, 0x00                                ; 0F011
  db 0x00, 0x00                                ; 0F013
  db 0x00, 0x00                                ; 0F015
  db 0x00, 0x00                                ; 0F017
  db 0x00, 0x00                                ; 0F019
  db 0x00, 0x00                                ; 0F01B
  db 0x00, 0x00                                ; 0F01D
  db 0x00, 0x00                                ; 0F01F
  db 0x00, 0x00                                ; 0F021
  db 0x00, 0x00                                ; 0F023
  db 0x00, 0x00                                ; 0F025
  db 0x00, 0x00                                ; 0F027
  db 0x00, 0x00                                ; 0F029
  db 0x00, 0x00                                ; 0F02B
  db 0x00, 0x00                                ; 0F02D
  db 0x00, 0x00                                ; 0F02F
  db 0x00, 0x00                                ; 0F031
  db 0x00, 0x00                                ; 0F033
  db 0x00, 0x00                                ; 0F035
  db 0x00, 0x00                                ; 0F037
  db 0x00, 0x00                                ; 0F039
  db 0x00, 0x00                                ; 0F03B
  db 0x00, 0x00                                ; 0F03D
  db 0x00, 0x00                                ; 0F03F
  db 0x00, 0x00                                ; 0F041
  db 0x00, 0x00                                ; 0F043
  db 0x00, 0x00                                ; 0F045
  db 0x00, 0x00                                ; 0F047
  db 0x00, 0x00                                ; 0F049
  db 0x00, 0x00                                ; 0F04B
  db 0x00, 0x00                                ; 0F04D
  db 0x00, 0x00                                ; 0F04F
  db 0x00, 0x00                                ; 0F051
  db 0x00, 0x00                                ; 0F053
  db 0x00, 0x00                                ; 0F055
  db 0x00, 0x00                                ; 0F057
  db 0x00, 0x00                                ; 0F059
  db 0x00, 0x00                                ; 0F05B
  db 0x00, 0x00                                ; 0F05D
  db 0x00, 0x00                                ; 0F05F
  db 0x00, 0x00                                ; 0F061
  db 0x00, 0x00                                ; 0F063
  db 0x00, 0x00                                ; 0F065
  db 0x00, 0x00                                ; 0F067
  db 0x00, 0x00                                ; 0F069
  db 0x00, 0x00                                ; 0F06B
  db 0x00, 0x00                                ; 0F06D
  db 0x00, 0x00                                ; 0F06F
  db 0x00, 0x00                                ; 0F071
  db 0x00, 0x00                                ; 0F073
  db 0x00, 0x00                                ; 0F075
  db 0x00, 0x00                                ; 0F077
  db 0x00, 0x00                                ; 0F079
  db 0x00, 0x00                                ; 0F07B
  db 0x00, 0x00                                ; 0F07D
  db 0x00, 0x00                                ; 0F07F
  db 0x00, 0x00                                ; 0F081
  db 0x00, 0x00                                ; 0F083
  db 0x00, 0x00                                ; 0F085
  db 0x00, 0x00                                ; 0F087
  db 0x00, 0x00                                ; 0F089
  db 0x00, 0x00                                ; 0F08B
  db 0x00, 0x00                                ; 0F08D
  db 0x00, 0x00                                ; 0F08F
  db 0x00, 0x00                                ; 0F091
  db 0x00, 0x00                                ; 0F093
  db 0x00, 0x00                                ; 0F095
  db 0x00, 0x00                                ; 0F097
  db 0x00, 0x00                                ; 0F099
  db 0x00, 0x00                                ; 0F09B
  db 0x00, 0x00                                ; 0F09D
  db 0x00, 0x00                                ; 0F09F
  db 0x00, 0x00                                ; 0F0A1
  db 0x00, 0x00                                ; 0F0A3
  db 0x00, 0x00                                ; 0F0A5
  db 0x00, 0x00                                ; 0F0A7
  db 0x00, 0x00                                ; 0F0A9
  db 0x00, 0x00                                ; 0F0AB
  db 0x00, 0x00                                ; 0F0AD
  db 0x00, 0x00                                ; 0F0AF
  db 0x00, 0x00                                ; 0F0B1
  db 0x00, 0x00                                ; 0F0B3
  db 0x00, 0x00                                ; 0F0B5
  db 0x00, 0x00                                ; 0F0B7
  db 0x00, 0x00                                ; 0F0B9
  db 0x00, 0x00                                ; 0F0BB
  db 0x00, 0x00                                ; 0F0BD
  db 0x00, 0x00                                ; 0F0BF
  db 0x00, 0x00                                ; 0F0C1
  db 0x00, 0x00                                ; 0F0C3
  db 0x00, 0x00                                ; 0F0C5
  db 0x00, 0x00                                ; 0F0C7
  db 0x00, 0x00                                ; 0F0C9
  db 0x00, 0x00                                ; 0F0CB
  db 0x00, 0x00                                ; 0F0CD
  db 0x00, 0x00                                ; 0F0CF
  db 0x00, 0x00                                ; 0F0D1
  db 0x00, 0x00                                ; 0F0D3
  db 0x00, 0x00                                ; 0F0D5
  db 0x00, 0x00                                ; 0F0D7
  db 0x00, 0x00                                ; 0F0D9
  db 0x00, 0x00                                ; 0F0DB
  db 0x00, 0x00                                ; 0F0DD
  db 0x00, 0x00                                ; 0F0DF
  db 0x00, 0x00                                ; 0F0E1
  db 0x00, 0x00                                ; 0F0E3
  db 0x00, 0x00                                ; 0F0E5
  db 0x00, 0x00                                ; 0F0E7
  db 0x00, 0x00                                ; 0F0E9
  db 0x00, 0x00                                ; 0F0EB
  db 0x00, 0x00                                ; 0F0ED
  db 0x00, 0x00                                ; 0F0EF
  db 0x00, 0x00                                ; 0F0F1
  db 0x00, 0x00                                ; 0F0F3
  db 0x00, 0x00                                ; 0F0F5
  db 0x00, 0x00                                ; 0F0F7
  db 0x00, 0x00                                ; 0F0F9
  db 0x00, 0x00                                ; 0F0FB
  db 0x00, 0x00                                ; 0F0FD
  db 0x00, 0x00                                ; 0F0FF
  db 0x00, 0x00                                ; 0F101
  db 0x00, 0x00                                ; 0F103
  db 0x00, 0x00                                ; 0F105
  db 0x00, 0x00                                ; 0F107
  db 0x00, 0x00                                ; 0F109
  db 0x00, 0x00                                ; 0F10B
  db 0x00, 0x00                                ; 0F10D
  db 0x00, 0x00                                ; 0F10F
  db 0x00, 0x00                                ; 0F111
  db 0x00, 0x00                                ; 0F113
  db 0x00, 0x00                                ; 0F115
  db 0x00, 0x00                                ; 0F117
  db 0x00, 0x00                                ; 0F119
  db 0x00, 0x00                                ; 0F11B
  db 0x00, 0x00                                ; 0F11D
  db 0x00, 0x00                                ; 0F11F
  db 0x00, 0x00                                ; 0F121
  db 0x00, 0x00                                ; 0F123
  db 0x00, 0x00                                ; 0F125
  db 0x00, 0x00                                ; 0F127
  db 0x00, 0x00                                ; 0F129
  db 0x00, 0x00                                ; 0F12B
  db 0x00, 0x00                                ; 0F12D
  db 0x00, 0x00                                ; 0F12F
  db 0x00, 0x00                                ; 0F131
  db 0x00, 0x00                                ; 0F133
  db 0x00, 0x00                                ; 0F135
  db 0x00, 0x00                                ; 0F137
  db 0x00, 0x00                                ; 0F139
  db 0x00, 0x00                                ; 0F13B
  db 0x00, 0x00                                ; 0F13D
  db 0x00, 0x00                                ; 0F13F
  db 0x00, 0x00                                ; 0F141
  db 0x00, 0x00                                ; 0F143
  db 0x00, 0x00                                ; 0F145
  db 0x00, 0x00                                ; 0F147
  db 0x00, 0x00                                ; 0F149
  db 0x00, 0x00                                ; 0F14B
  db 0x00, 0x00                                ; 0F14D
  db 0x00, 0x00                                ; 0F14F
  db 0x00, 0x00                                ; 0F151
  db 0x00, 0x00                                ; 0F153
  db 0x00, 0x00                                ; 0F155
  db 0x00, 0x00                                ; 0F157
  db 0x00, 0x00                                ; 0F159
  db 0x00, 0x00                                ; 0F15B
  db 0x00, 0x00                                ; 0F15D
  db 0x00, 0x00                                ; 0F15F
  db 0x00, 0x00                                ; 0F161
  db 0x00, 0x00                                ; 0F163
  db 0x00, 0x00                                ; 0F165
  db 0x00, 0x00                                ; 0F167
  db 0x00, 0x00                                ; 0F169
  db 0x00, 0x00                                ; 0F16B
  db 0x00, 0x00                                ; 0F16D
  db 0x00, 0x00                                ; 0F16F
  db 0x00, 0x00                                ; 0F171
  db 0x00, 0x00                                ; 0F173
  db 0x00, 0x00                                ; 0F175
  db 0x00, 0x00                                ; 0F177
  db 0x00, 0x00                                ; 0F179
  db 0x00, 0x00                                ; 0F17B
  db 0x00, 0x00                                ; 0F17D
  db 0x00, 0x00                                ; 0F17F
  db 0x00, 0x00                                ; 0F181
  db 0x00, 0x00                                ; 0F183
  db 0x00, 0x00                                ; 0F185
  db 0x00, 0x00                                ; 0F187
  db 0x00, 0x00                                ; 0F189
  db 0x00, 0x00                                ; 0F18B
  db 0x00, 0x00                                ; 0F18D
  db 0x00, 0x00                                ; 0F18F
  db 0x00, 0x00                                ; 0F191
  db 0x00, 0x00                                ; 0F193
  db 0x00, 0x00                                ; 0F195
  db 0x00, 0x00                                ; 0F197
  db 0x00, 0x00                                ; 0F199
  db 0x00, 0x00                                ; 0F19B
  db 0x00, 0x00                                ; 0F19D
  db 0x00, 0x00                                ; 0F19F
  db 0x00, 0x00                                ; 0F1A1
  db 0x00, 0x00                                ; 0F1A3
  db 0x00, 0x00                                ; 0F1A5
  db 0x00, 0x00                                ; 0F1A7
  db 0x00, 0x00                                ; 0F1A9
  db 0x00, 0x00                                ; 0F1AB
  db 0x00, 0x00                                ; 0F1AD
  db 0x00, 0x00                                ; 0F1AF
  db 0x00, 0x00                                ; 0F1B1
  db 0x00, 0x00                                ; 0F1B3
  db 0x00, 0x00                                ; 0F1B5
  db 0x00, 0x00                                ; 0F1B7
  db 0x00, 0x00                                ; 0F1B9
  db 0x00, 0x00                                ; 0F1BB
  db 0x00, 0x00                                ; 0F1BD
  db 0x00, 0x00                                ; 0F1BF
  db 0x00, 0x00                                ; 0F1C1
  db 0x00, 0x00                                ; 0F1C3
  db 0x00, 0x00                                ; 0F1C5
  db 0x00, 0x00                                ; 0F1C7
  db 0x00, 0x00                                ; 0F1C9
  db 0x00, 0x00                                ; 0F1CB
  db 0x00, 0x00                                ; 0F1CD
  db 0x00, 0x00                                ; 0F1CF
  db 0x00, 0x00                                ; 0F1D1
  db 0x00, 0x00                                ; 0F1D3
  db 0x00, 0x00                                ; 0F1D5
  db 0x00, 0x00                                ; 0F1D7
  db 0x00, 0x00                                ; 0F1D9
  db 0x00, 0x00                                ; 0F1DB
  db 0x00, 0x00                                ; 0F1DD
  db 0x00, 0x00                                ; 0F1DF
  db 0x00, 0x00                                ; 0F1E1
  db 0x00, 0x00                                ; 0F1E3
  db 0x00, 0x00                                ; 0F1E5
  db 0x00, 0x00                                ; 0F1E7
  db 0x00, 0x00                                ; 0F1E9
  db 0x00, 0x00                                ; 0F1EB
  db 0x00, 0x00                                ; 0F1ED
  db 0x00, 0x00                                ; 0F1EF
  db 0x00, 0x00                                ; 0F1F1
  db 0x00, 0x00                                ; 0F1F3
  db 0x00, 0x00                                ; 0F1F5
  db 0x00, 0x00                                ; 0F1F7
  db 0x00, 0x00                                ; 0F1F9
  db 0x00, 0x00                                ; 0F1FB
  db 0x00, 0x00                                ; 0F1FD
  db 0x00, 0x00                                ; 0F1FF
  db 0x00, 0x00                                ; 0F201
  db 0x00, 0x00                                ; 0F203
  db 0x00, 0x00                                ; 0F205
  db 0x00, 0x00                                ; 0F207
  db 0x00, 0x00                                ; 0F209
  db 0x00, 0x00                                ; 0F20B
  db 0x00, 0x00                                ; 0F20D
  db 0x00, 0x00                                ; 0F20F
  db 0x00, 0x00                                ; 0F211
  db 0x00, 0x00                                ; 0F213
  db 0x00, 0x00                                ; 0F215
  db 0x00, 0x00                                ; 0F217
  db 0x00, 0x00                                ; 0F219
  db 0x00, 0x00                                ; 0F21B
  db 0x00, 0x00                                ; 0F21D
  db 0x00, 0x00                                ; 0F21F
  db 0x00, 0x00                                ; 0F221
  db 0x00, 0x00                                ; 0F223
  db 0x00, 0x00                                ; 0F225
  db 0x00, 0x00                                ; 0F227
  db 0x00, 0x00                                ; 0F229
  db 0x00, 0x00                                ; 0F22B
  db 0x00, 0x00                                ; 0F22D
  db 0x00, 0x00                                ; 0F22F
  db 0x00, 0x00                                ; 0F231
  db 0x00, 0x00                                ; 0F233
  db 0x00, 0x00                                ; 0F235
  db 0x00, 0x00                                ; 0F237
  db 0x00, 0x00                                ; 0F239
  db 0x00, 0x00                                ; 0F23B
  db 0x00, 0x00                                ; 0F23D
  db 0x00, 0x00                                ; 0F23F
  db 0x00, 0x00                                ; 0F241
  db 0x00, 0x00                                ; 0F243
  db 0x00, 0x00                                ; 0F245
  db 0x00, 0x00                                ; 0F247
  db 0x00, 0x00                                ; 0F249
  db 0x00, 0x00                                ; 0F24B
  db 0x00, 0x00                                ; 0F24D
  db 0x00, 0x00                                ; 0F24F
  db 0x00, 0x00                                ; 0F251
  db 0x00, 0x00                                ; 0F253
  db 0x00, 0x00                                ; 0F255
  db 0x00, 0x00                                ; 0F257
  db 0x00, 0x00                                ; 0F259
  db 0x00, 0x00                                ; 0F25B
  db 0x00, 0x00                                ; 0F25D
  db 0x00, 0x00                                ; 0F25F
  db 0x00, 0x00                                ; 0F261
  db 0x00, 0x00                                ; 0F263
  db 0x00, 0x00                                ; 0F265
  db 0x00, 0x00                                ; 0F267
  db 0x00, 0x00                                ; 0F269
  db 0x00, 0x00                                ; 0F26B
  db 0x00, 0x00                                ; 0F26D
  db 0x00, 0x00                                ; 0F26F
  db 0x00, 0x00                                ; 0F271
  db 0x00, 0x00                                ; 0F273
  db 0x00, 0x00                                ; 0F275
  db 0x00, 0x00                                ; 0F277
  db 0x00, 0x00                                ; 0F279
  db 0x00, 0x00                                ; 0F27B
  db 0x00, 0x00                                ; 0F27D
  db 0x00, 0x00                                ; 0F27F
  db 0x00, 0x00                                ; 0F281
  db 0x00, 0x00                                ; 0F283
  db 0x00, 0x00                                ; 0F285
  db 0x00, 0x00                                ; 0F287
  db 0x00, 0x00                                ; 0F289
  db 0x00, 0x00                                ; 0F28B
  db 0x00, 0x00                                ; 0F28D
  db 0x00, 0x00                                ; 0F28F
  db 0x00, 0x00                                ; 0F291
  db 0x00, 0x00                                ; 0F293
  db 0x00, 0x00                                ; 0F295
  db 0x00, 0x00                                ; 0F297
  db 0x00, 0x00                                ; 0F299
  db 0x00, 0x00                                ; 0F29B
  db 0x00, 0x00                                ; 0F29D
  db 0x00, 0x00                                ; 0F29F
  db 0x00, 0x00                                ; 0F2A1
  db 0x00, 0x00                                ; 0F2A3
  db 0x00, 0x00                                ; 0F2A5
  db 0x00, 0x00                                ; 0F2A7
  db 0x00, 0x00                                ; 0F2A9
  db 0x00, 0x00                                ; 0F2AB
  db 0x00, 0x00                                ; 0F2AD
  db 0x00, 0x00                                ; 0F2AF
  db 0x00, 0x00                                ; 0F2B1
  db 0x00, 0x00                                ; 0F2B3
  db 0x00, 0x00                                ; 0F2B5
  db 0x00, 0x00                                ; 0F2B7
  db 0x00, 0x00                                ; 0F2B9
  db 0x00, 0x00                                ; 0F2BB
  db 0x00, 0x00                                ; 0F2BD
  db 0x00, 0x00                                ; 0F2BF
  db 0x00, 0x00                                ; 0F2C1
  db 0x00, 0x00                                ; 0F2C3
  db 0x00, 0x00                                ; 0F2C5
  db 0x00, 0x00                                ; 0F2C7
  db 0x00, 0x00                                ; 0F2C9
  db 0x00, 0x00                                ; 0F2CB
  db 0x00, 0x00                                ; 0F2CD
  db 0x00, 0x00                                ; 0F2CF
  db 0x00, 0x00                                ; 0F2D1
  db 0x00, 0x00                                ; 0F2D3
  db 0x00, 0x00                                ; 0F2D5
  db 0x00, 0x00                                ; 0F2D7
  db 0x00, 0x00                                ; 0F2D9
  db 0x00, 0x00                                ; 0F2DB
  db 0x00, 0x00                                ; 0F2DD
  db 0x00, 0x00                                ; 0F2DF
  db 0x00, 0x00                                ; 0F2E1
  db 0x00, 0x00                                ; 0F2E3
  db 0x00, 0x00                                ; 0F2E5
  db 0x00, 0x00                                ; 0F2E7
  db 0x00, 0x00                                ; 0F2E9
  db 0x00, 0x00                                ; 0F2EB
  db 0x00, 0x00                                ; 0F2ED
  db 0x00, 0x00                                ; 0F2EF
  db 0x00, 0x00                                ; 0F2F1
  db 0x00, 0x00                                ; 0F2F3
  db 0x00, 0x00                                ; 0F2F5
  db 0x00, 0x00                                ; 0F2F7
  db 0x00, 0x00                                ; 0F2F9
  db 0x00, 0x00                                ; 0F2FB
  db 0x00, 0x00                                ; 0F2FD
  db 0x00, 0x00                                ; 0F2FF
  db 0x00, 0x00                                ; 0F301
  db 0x00, 0x00                                ; 0F303
  db 0x00, 0x00                                ; 0F305
  db 0x00, 0x00                                ; 0F307
  db 0x00, 0x00                                ; 0F309
  db 0x00, 0x00                                ; 0F30B
  db 0x00, 0x00                                ; 0F30D
  db 0x00, 0x00                                ; 0F30F
  db 0x00, 0x00                                ; 0F311
  db 0x00, 0x00                                ; 0F313
  db 0x00, 0x00                                ; 0F315
  db 0x00, 0x00                                ; 0F317
  db 0x00, 0x00                                ; 0F319
  db 0x00, 0x00                                ; 0F31B
  db 0x00, 0x00                                ; 0F31D
  db 0x00, 0x00                                ; 0F31F
  db 0x00, 0x00                                ; 0F321
  db 0x00, 0x00                                ; 0F323
  db 0x00, 0x00                                ; 0F325
  db 0x00, 0x00                                ; 0F327
  db 0x00, 0x00                                ; 0F329
  db 0x00, 0x00                                ; 0F32B
  db 0x00, 0x00                                ; 0F32D
  db 0x00, 0x00                                ; 0F32F
  db 0x00, 0x00                                ; 0F331
  db 0x00, 0x00                                ; 0F333
  db 0x00, 0x00                                ; 0F335
  db 0x00, 0x00                                ; 0F337
  db 0x00, 0x00                                ; 0F339
  db 0x00, 0x00                                ; 0F33B
  db 0x00, 0x00                                ; 0F33D
  db 0x00, 0x00                                ; 0F33F
  db 0x00, 0x00                                ; 0F341
  db 0x00, 0x00                                ; 0F343
  db 0x00, 0x00                                ; 0F345
  db 0x00, 0x00                                ; 0F347
  db 0x00, 0x00                                ; 0F349
  db 0x00, 0x00                                ; 0F34B
  db 0x00, 0x00                                ; 0F34D
  db 0x00, 0x00                                ; 0F34F
  db 0x00, 0x00                                ; 0F351
  db 0x00, 0x00                                ; 0F353
  db 0x00, 0x00                                ; 0F355
  db 0x00, 0x00                                ; 0F357
  db 0x00, 0x00                                ; 0F359
  db 0x00, 0x00                                ; 0F35B
  db 0x00, 0x00                                ; 0F35D
  db 0x00, 0x00                                ; 0F35F
  db 0x00, 0x00                                ; 0F361
  db 0x00, 0x00                                ; 0F363
  db 0x00, 0x00                                ; 0F365
  db 0x00, 0x00                                ; 0F367
  db 0x00, 0x00                                ; 0F369
  db 0x00, 0x00                                ; 0F36B
  db 0x00, 0x00                                ; 0F36D
  db 0x00, 0x00                                ; 0F36F
  db 0x00, 0x00                                ; 0F371
  db 0x00, 0x00                                ; 0F373
  db 0x00, 0x00                                ; 0F375
  db 0x00, 0x00                                ; 0F377
  db 0x00, 0x00                                ; 0F379
  db 0x00, 0x00                                ; 0F37B
  db 0x00, 0x00                                ; 0F37D
  db 0x00, 0x00                                ; 0F37F
  db 0x00, 0x00                                ; 0F381
  db 0x00, 0x00                                ; 0F383
  db 0x00, 0x00                                ; 0F385
  db 0x00, 0x00                                ; 0F387
  db 0x00, 0x00                                ; 0F389
  db 0x00, 0x00                                ; 0F38B
  db 0x00, 0x00                                ; 0F38D
  db 0x00, 0x00                                ; 0F38F
  db 0x00, 0x00                                ; 0F391
  db 0x00, 0x00                                ; 0F393
  db 0x00, 0x00                                ; 0F395
  db 0x00, 0x00                                ; 0F397
  db 0x00, 0x00                                ; 0F399
  db 0x00, 0x00                                ; 0F39B
  db 0x00, 0x00                                ; 0F39D
  db 0x00, 0x00                                ; 0F39F
  db 0x00, 0x00                                ; 0F3A1
  db 0x00, 0x00                                ; 0F3A3
  db 0x00, 0x00                                ; 0F3A5
  db 0x00, 0x00                                ; 0F3A7
  db 0x00, 0x00                                ; 0F3A9
  db 0x00, 0x00                                ; 0F3AB
  db 0x00, 0x00                                ; 0F3AD
  db 0x00, 0x00                                ; 0F3AF
  db 0x00, 0x00                                ; 0F3B1
  db 0x00, 0x00                                ; 0F3B3
  db 0x00, 0x00                                ; 0F3B5
  db 0x00, 0x00                                ; 0F3B7
  db 0x00, 0x00                                ; 0F3B9
  db 0x00, 0x00                                ; 0F3BB
  db 0x00, 0x00                                ; 0F3BD
  db 0x00, 0x00                                ; 0F3BF
  db 0x00, 0x00                                ; 0F3C1
  db 0x00, 0x00                                ; 0F3C3
  db 0x00, 0x00                                ; 0F3C5
  db 0x00, 0x00                                ; 0F3C7
  db 0x00, 0x00                                ; 0F3C9
  db 0x00, 0x00                                ; 0F3CB
  db 0x00, 0x00                                ; 0F3CD
  db 0x00, 0x00                                ; 0F3CF
  db 0x00, 0x00                                ; 0F3D1
  db 0x00, 0x00                                ; 0F3D3
  db 0x00, 0x00                                ; 0F3D5
  db 0x00, 0x00                                ; 0F3D7
  db 0x00, 0x00                                ; 0F3D9
  db 0x00, 0x00                                ; 0F3DB
  db 0x00, 0x00                                ; 0F3DD
  db 0x00, 0x00                                ; 0F3DF
  db 0x00, 0x00                                ; 0F3E1
  db 0x00, 0x00                                ; 0F3E3
  db 0x00, 0x00                                ; 0F3E5
  db 0x00, 0x00                                ; 0F3E7
  db 0x00, 0x00                                ; 0F3E9
  db 0x00, 0x00                                ; 0F3EB
  db 0x00, 0x00                                ; 0F3ED
  db 0x00, 0x00                                ; 0F3EF
  db 0x00, 0x00                                ; 0F3F1
  db 0x00, 0x00                                ; 0F3F3
  db 0x00, 0x00                                ; 0F3F5
  db 0x00, 0x00                                ; 0F3F7
  db 0x00, 0x00                                ; 0F3F9
  db 0x00, 0x00                                ; 0F3FB
  db 0x00, 0x00                                ; 0F3FD
  db 0x00, 0x00                                ; 0F3FF
  db 0x00, 0x00                                ; 0F401
  db 0x00, 0x00                                ; 0F403
  db 0x00, 0x00                                ; 0F405
  db 0x00, 0x00                                ; 0F407
  db 0x00, 0x00                                ; 0F409
  db 0x00, 0x00                                ; 0F40B
  db 0x00, 0x00                                ; 0F40D
  db 0x00, 0x00                                ; 0F40F
  db 0x00, 0x00                                ; 0F411
  db 0x00, 0x00                                ; 0F413
  db 0x00, 0x00                                ; 0F415
  db 0x00, 0x00                                ; 0F417
  db 0x00, 0x00                                ; 0F419
  db 0x00, 0x00                                ; 0F41B
  db 0x00, 0x00                                ; 0F41D
  db 0x00, 0x00                                ; 0F41F
  db 0x00, 0x00                                ; 0F421
  db 0x00, 0x00                                ; 0F423
  db 0x00, 0x00                                ; 0F425
  db 0x00, 0x00                                ; 0F427
  db 0x00, 0x00                                ; 0F429
  db 0x00, 0x00                                ; 0F42B
  db 0x00, 0x00                                ; 0F42D
  db 0x00, 0x00                                ; 0F42F
  db 0x00, 0x00                                ; 0F431
  db 0x00, 0x00                                ; 0F433
  db 0x00, 0x00                                ; 0F435
  db 0x00, 0x00                                ; 0F437
  db 0x00, 0x00                                ; 0F439
  db 0x00, 0x00                                ; 0F43B
  db 0x00, 0x00                                ; 0F43D
  db 0x00, 0x00                                ; 0F43F
  db 0x00, 0x00                                ; 0F441
  db 0x00, 0x00                                ; 0F443
  db 0x00, 0x00                                ; 0F445
  db 0x00, 0x00                                ; 0F447
  db 0x00, 0x00                                ; 0F449
  db 0x00, 0x00                                ; 0F44B
  db 0x00, 0x00                                ; 0F44D
  db 0x00, 0x00                                ; 0F44F
  db 0x00, 0x00                                ; 0F451
  db 0x00, 0x00                                ; 0F453
  db 0x00, 0x00                                ; 0F455
  db 0x00, 0x00                                ; 0F457
  db 0x00, 0x00                                ; 0F459
  db 0x00, 0x00                                ; 0F45B
  db 0x00, 0x00                                ; 0F45D
  db 0x00, 0x00                                ; 0F45F
  db 0x00, 0x00                                ; 0F461
  db 0x00, 0x00                                ; 0F463
  db 0x00, 0x00                                ; 0F465
  db 0x00, 0x00                                ; 0F467
  db 0x00, 0x00                                ; 0F469
  db 0x00, 0x00                                ; 0F46B
  db 0x00, 0x00                                ; 0F46D
  db 0x00, 0x00                                ; 0F46F
  db 0x00, 0x00                                ; 0F471
  db 0x00, 0x00                                ; 0F473
  db 0x00, 0x00                                ; 0F475
  db 0x00, 0x00                                ; 0F477
  db 0x00, 0x00                                ; 0F479
  db 0x00, 0x00                                ; 0F47B
  db 0x00, 0x00                                ; 0F47D
  db 0x00, 0x00                                ; 0F47F
  db 0x00, 0x00                                ; 0F481
  db 0x00, 0x00                                ; 0F483
  db 0x00, 0x00                                ; 0F485
  db 0x00, 0x00                                ; 0F487
  db 0x00, 0x00                                ; 0F489
  db 0x00, 0x00                                ; 0F48B
  db 0x00, 0x00                                ; 0F48D
  db 0x00, 0x00                                ; 0F48F
  db 0x00, 0x00                                ; 0F491
  db 0x00, 0x00                                ; 0F493
  db 0x00, 0x00                                ; 0F495
  db 0x00, 0x00                                ; 0F497
  db 0x00, 0x00                                ; 0F499
  db 0x00, 0x00                                ; 0F49B
  db 0x00, 0x00                                ; 0F49D
  db 0x00, 0x00                                ; 0F49F
  db 0x00, 0x00                                ; 0F4A1
  db 0x00, 0x00                                ; 0F4A3
  db 0x00, 0x00                                ; 0F4A5
  db 0x00, 0x00                                ; 0F4A7
  db 0x00, 0x00                                ; 0F4A9
  db 0x00, 0x00                                ; 0F4AB
  db 0x00, 0x00                                ; 0F4AD
  db 0x00, 0x00                                ; 0F4AF
  db 0x00, 0x00                                ; 0F4B1
  db 0x00, 0x00                                ; 0F4B3
  db 0x00, 0x00                                ; 0F4B5
  db 0x00, 0x00                                ; 0F4B7
  db 0x00, 0x00                                ; 0F4B9
  db 0x00, 0x00                                ; 0F4BB
  db 0x00, 0x00                                ; 0F4BD
  db 0x00, 0x00                                ; 0F4BF
  db 0x00, 0x00                                ; 0F4C1
  db 0x00, 0x00                                ; 0F4C3
  db 0x00, 0x00                                ; 0F4C5
  db 0x00, 0x00                                ; 0F4C7
  db 0x00, 0x00                                ; 0F4C9
  db 0x00, 0x00                                ; 0F4CB
  db 0x00, 0x00                                ; 0F4CD
  db 0x00, 0x00                                ; 0F4CF
  db 0x00, 0x00                                ; 0F4D1
  db 0x00, 0x00                                ; 0F4D3
  db 0x00, 0x00                                ; 0F4D5
  db 0x00, 0x00                                ; 0F4D7
  db 0x00, 0x00                                ; 0F4D9
  db 0x00, 0x00                                ; 0F4DB
  db 0x00, 0x00                                ; 0F4DD
  db 0x00, 0x00                                ; 0F4DF
  db 0x00, 0x00                                ; 0F4E1
  db 0x00, 0x00                                ; 0F4E3
  db 0x00, 0x00                                ; 0F4E5
  db 0x00, 0x00                                ; 0F4E7
  db 0x00, 0x00                                ; 0F4E9
  db 0x00, 0x00                                ; 0F4EB
  db 0x00, 0x00                                ; 0F4ED
  db 0x00, 0x00                                ; 0F4EF
  db 0x00, 0x00                                ; 0F4F1
  db 0x00, 0x00                                ; 0F4F3
  db 0x00, 0x00                                ; 0F4F5
  db 0x00, 0x00                                ; 0F4F7
  db 0x00, 0x00                                ; 0F4F9
  db 0x00, 0x00                                ; 0F4FB
  db 0x00, 0x00                                ; 0F4FD
  db 0x00, 0x00                                ; 0F4FF
  db 0x00, 0x00                                ; 0F501
  db 0x00, 0x00                                ; 0F503
  db 0x00, 0x00                                ; 0F505
  db 0x00, 0x00                                ; 0F507
  db 0x00, 0x00                                ; 0F509
  db 0x00, 0x00                                ; 0F50B
  db 0x00, 0x00                                ; 0F50D
  db 0x00, 0x00                                ; 0F50F
  db 0x00, 0x00                                ; 0F511
  db 0x00, 0x00                                ; 0F513
  db 0x00, 0x00                                ; 0F515
  db 0x00, 0x00                                ; 0F517
  db 0x00, 0x00                                ; 0F519
  db 0x00, 0x00                                ; 0F51B
  db 0x00, 0x00                                ; 0F51D
  db 0x00, 0x00                                ; 0F51F
  db 0x00, 0x00                                ; 0F521
  db 0x00, 0x00                                ; 0F523
  db 0x00, 0x00                                ; 0F525
  db 0x00, 0x00                                ; 0F527
  db 0x00, 0x00                                ; 0F529
  db 0x00, 0x00                                ; 0F52B
  db 0x00, 0x00                                ; 0F52D
  db 0x00, 0x00                                ; 0F52F
  db 0x00, 0x00                                ; 0F531
  db 0x00, 0x00                                ; 0F533
  db 0x00, 0x00                                ; 0F535
  db 0x00, 0x00                                ; 0F537
  db 0x00, 0x00                                ; 0F539
  db 0x00, 0x00                                ; 0F53B
  db 0x00, 0x00                                ; 0F53D
  db 0x00, 0x00                                ; 0F53F
  db 0x00, 0x00                                ; 0F541
  db 0x00, 0x00                                ; 0F543
  db 0x00, 0x00                                ; 0F545
  db 0x00, 0x00                                ; 0F547
  db 0x00, 0x00                                ; 0F549
  db 0x00, 0x00                                ; 0F54B
  db 0x00, 0x00                                ; 0F54D
  db 0x00, 0x00                                ; 0F54F
  db 0x00, 0x00                                ; 0F551
  db 0x00, 0x00                                ; 0F553
  db 0x00, 0x00                                ; 0F555
  db 0x00, 0x00                                ; 0F557
  db 0x00, 0x00                                ; 0F559
  db 0x00, 0x00                                ; 0F55B
  db 0x00, 0x00                                ; 0F55D
  db 0x00, 0x00                                ; 0F55F
  db 0x00, 0x00                                ; 0F561
  db 0x00, 0x00                                ; 0F563
  db 0x00, 0x00                                ; 0F565
  db 0x00, 0x00                                ; 0F567
  db 0x00, 0x00                                ; 0F569
  db 0x00, 0x00                                ; 0F56B
  db 0x00, 0x00                                ; 0F56D
  db 0x00, 0x00                                ; 0F56F
  db 0x00, 0x00                                ; 0F571
  db 0x00, 0x00                                ; 0F573
  db 0x00, 0x00                                ; 0F575
  db 0x00, 0x00                                ; 0F577
  db 0x00, 0x00                                ; 0F579
  db 0x00, 0x00                                ; 0F57B
  db 0x00, 0x00                                ; 0F57D
  db 0x00, 0x00                                ; 0F57F
  db 0x00, 0x00                                ; 0F581
  db 0x00, 0x00                                ; 0F583
  db 0x00, 0x00                                ; 0F585
  db 0x00, 0x00                                ; 0F587
  db 0x00, 0x00                                ; 0F589
  db 0x00, 0x00                                ; 0F58B
  db 0x00, 0x00                                ; 0F58D
  db 0x00, 0x00                                ; 0F58F
  db 0x00, 0x00                                ; 0F591
  db 0x00, 0x00                                ; 0F593
  db 0x00, 0x00                                ; 0F595
  db 0x00, 0x00                                ; 0F597
  db 0x00, 0x00                                ; 0F599
  db 0x00, 0x00                                ; 0F59B
  db 0x00, 0x00                                ; 0F59D
  db 0x00, 0x00                                ; 0F59F
  db 0x00, 0x00                                ; 0F5A1
  db 0x00, 0x00                                ; 0F5A3
  db 0x00, 0x00                                ; 0F5A5
  db 0x00, 0x00                                ; 0F5A7
  db 0x00, 0x00                                ; 0F5A9
  db 0x00, 0x00                                ; 0F5AB
  db 0x00, 0x00                                ; 0F5AD
  db 0x00, 0x00                                ; 0F5AF
  db 0x00, 0x00                                ; 0F5B1
  db 0x00, 0x00                                ; 0F5B3
  db 0x00, 0x00                                ; 0F5B5
  db 0x00, 0x00                                ; 0F5B7
  db 0x00, 0x00                                ; 0F5B9
  db 0x00, 0x00                                ; 0F5BB
  db 0x00, 0x00                                ; 0F5BD
  db 0x00, 0x00                                ; 0F5BF
  db 0x00, 0x00                                ; 0F5C1
  db 0x00, 0x00                                ; 0F5C3
  db 0x00, 0x00                                ; 0F5C5
  db 0x00, 0x00                                ; 0F5C7
  db 0x00, 0x00                                ; 0F5C9
  db 0x00, 0x00                                ; 0F5CB
  db 0x00, 0x00                                ; 0F5CD
  db 0x00, 0x00                                ; 0F5CF
  db 0x00, 0x00                                ; 0F5D1
  db 0x00, 0x00                                ; 0F5D3
  db 0x00, 0x00                                ; 0F5D5
  db 0x00, 0x00                                ; 0F5D7
  db 0x00, 0x00                                ; 0F5D9
  db 0x00, 0x00                                ; 0F5DB
  db 0x00, 0x00                                ; 0F5DD
  db 0x00, 0x00                                ; 0F5DF
  db 0x00, 0x00                                ; 0F5E1
  db 0x00, 0x00                                ; 0F5E3
  db 0x00, 0x00                                ; 0F5E5
  db 0x00, 0x00                                ; 0F5E7
  db 0x00, 0x00                                ; 0F5E9
  db 0x00, 0x00                                ; 0F5EB
  db 0x00, 0x00                                ; 0F5ED
  db 0x00, 0x00                                ; 0F5EF
  db 0x00, 0x00                                ; 0F5F1
  db 0x00, 0x00                                ; 0F5F3
  db 0x00, 0x00                                ; 0F5F5
  db 0x00, 0x00                                ; 0F5F7
  db 0x00, 0x00                                ; 0F5F9
  db 0x00, 0x00                                ; 0F5FB
  db 0x00, 0x00                                ; 0F5FD
  db 0x00, 0x00                                ; 0F5FF
  db 0x00, 0x00                                ; 0F601
  db 0x00, 0x00                                ; 0F603
  db 0x00, 0x00                                ; 0F605
  db 0x00, 0x00                                ; 0F607
  db 0x00, 0x00                                ; 0F609
  db 0x00, 0x00                                ; 0F60B
  db 0x00, 0x00                                ; 0F60D
  db 0x00, 0x00                                ; 0F60F
  db 0x00, 0x00                                ; 0F611
  db 0x00, 0x00                                ; 0F613
  db 0x00, 0x00                                ; 0F615
  db 0x00, 0x00                                ; 0F617
  db 0x00, 0x00                                ; 0F619
  db 0x00, 0x00                                ; 0F61B
  db 0x00, 0x00                                ; 0F61D
  db 0x00, 0x00                                ; 0F61F
  db 0x00, 0x00                                ; 0F621
  db 0x00, 0x00                                ; 0F623
  db 0x00, 0x00                                ; 0F625
  db 0x00, 0x00                                ; 0F627
  db 0x00, 0x00                                ; 0F629
  db 0x00, 0x00                                ; 0F62B
  db 0x00, 0x00                                ; 0F62D
  db 0x00, 0x00                                ; 0F62F
  db 0x00, 0x00                                ; 0F631
  db 0x00, 0x00                                ; 0F633
  db 0x00, 0x00                                ; 0F635
  db 0x00, 0x00                                ; 0F637
  db 0x00, 0x00                                ; 0F639
  db 0x00, 0x00                                ; 0F63B
  db 0x00, 0x00                                ; 0F63D
  db 0x00, 0x00                                ; 0F63F
  db 0x00, 0x00                                ; 0F641
  db 0x00, 0x00                                ; 0F643
  db 0x00, 0x00                                ; 0F645
  db 0x00, 0x00                                ; 0F647
  db 0x00, 0x00                                ; 0F649
  db 0x00, 0x00                                ; 0F64B
  db 0x00, 0x00                                ; 0F64D
  db 0x00, 0x00                                ; 0F64F
  db 0x00, 0x00                                ; 0F651
  db 0x00, 0x00                                ; 0F653
  db 0x00, 0x00                                ; 0F655
  db 0x00, 0x00                                ; 0F657
  db 0x00, 0x00                                ; 0F659
  db 0x00, 0x00                                ; 0F65B
  db 0x00, 0x00                                ; 0F65D
  db 0x00, 0x00                                ; 0F65F
  db 0x00, 0x00                                ; 0F661
  db 0x00, 0x00                                ; 0F663
  db 0x00, 0x00                                ; 0F665
  db 0x00, 0x00                                ; 0F667
  db 0x00, 0x00                                ; 0F669
  db 0x00, 0x00                                ; 0F66B
  db 0x00, 0x00                                ; 0F66D
  db 0x00, 0x00                                ; 0F66F
  db 0x00, 0x00                                ; 0F671
  db 0x00, 0x00                                ; 0F673
  db 0x00, 0x00                                ; 0F675
  db 0x00, 0x00                                ; 0F677
  db 0x00, 0x00                                ; 0F679
  db 0x00, 0x00                                ; 0F67B
  db 0x00, 0x00                                ; 0F67D
  db 0x00, 0x00                                ; 0F67F
  db 0x00, 0x00                                ; 0F681
  db 0x00, 0x00                                ; 0F683
  db 0x00, 0x00                                ; 0F685
  db 0x00, 0x00                                ; 0F687
  db 0x00, 0x00                                ; 0F689
  db 0x00, 0x00                                ; 0F68B
  db 0x00, 0x00                                ; 0F68D
  db 0x00, 0x00                                ; 0F68F
  db 0x00, 0x00                                ; 0F691
  db 0x00, 0x00                                ; 0F693
  db 0x00, 0x00                                ; 0F695
  db 0x00, 0x00                                ; 0F697
  db 0x00, 0x00                                ; 0F699
  db 0x00, 0x00                                ; 0F69B
  db 0x00, 0x00                                ; 0F69D
  db 0x00, 0x00                                ; 0F69F
  db 0x00, 0x00                                ; 0F6A1
  db 0x00, 0x00                                ; 0F6A3
  db 0x00, 0x00                                ; 0F6A5
  db 0x00, 0x00                                ; 0F6A7
  db 0x00, 0x00                                ; 0F6A9
  db 0x00, 0x00                                ; 0F6AB
  db 0x00, 0x00                                ; 0F6AD
  db 0x00, 0x00                                ; 0F6AF
  db 0x00, 0x00                                ; 0F6B1
  db 0x00, 0x00                                ; 0F6B3
  db 0x00, 0x00                                ; 0F6B5
  db 0x00, 0x00                                ; 0F6B7
  db 0x00, 0x00                                ; 0F6B9
  db 0x00, 0x00                                ; 0F6BB
  db 0x00, 0x00                                ; 0F6BD
  db 0x00, 0x00                                ; 0F6BF
  db 0x00, 0x00                                ; 0F6C1
  db 0x00, 0x00                                ; 0F6C3
  db 0x00, 0x00                                ; 0F6C5
  db 0x00, 0x00                                ; 0F6C7
  db 0x00, 0x00                                ; 0F6C9
  db 0x00, 0x00                                ; 0F6CB
  db 0x00, 0x00                                ; 0F6CD
  db 0x00, 0x00                                ; 0F6CF
  db 0x00, 0x00                                ; 0F6D1
  db 0x00, 0x00                                ; 0F6D3
  db 0x00, 0x00                                ; 0F6D5
  db 0x00, 0x00                                ; 0F6D7
  db 0x00, 0x00                                ; 0F6D9
  db 0x00, 0x00                                ; 0F6DB
  db 0x00, 0x00                                ; 0F6DD
  db 0x00, 0x00                                ; 0F6DF
  db 0x00, 0x00                                ; 0F6E1
  db 0x00, 0x00                                ; 0F6E3
  db 0x00, 0x00                                ; 0F6E5
  db 0x00, 0x00                                ; 0F6E7
  db 0x00, 0x00                                ; 0F6E9
  db 0x00, 0x00                                ; 0F6EB
  db 0x00, 0x00                                ; 0F6ED
  db 0x00, 0x00                                ; 0F6EF
  db 0x00, 0x00                                ; 0F6F1
  db 0x00, 0x00                                ; 0F6F3
  db 0x00, 0x00                                ; 0F6F5
  db 0x00, 0x00                                ; 0F6F7
  db 0x00, 0x00                                ; 0F6F9
  db 0x00, 0x00                                ; 0F6FB
  db 0x00, 0x00                                ; 0F6FD
  db 0x00, 0x00                                ; 0F6FF
  db 0x00, 0x00                                ; 0F701
  db 0x00, 0x00                                ; 0F703
  db 0x00, 0x00                                ; 0F705
  db 0x00, 0x00                                ; 0F707
  db 0x00, 0x00                                ; 0F709
  db 0x00, 0x00                                ; 0F70B
  db 0x00, 0x00                                ; 0F70D
  db 0x00, 0x00                                ; 0F70F
  db 0x00, 0x00                                ; 0F711
  db 0x00, 0x00                                ; 0F713
  db 0x00, 0x00                                ; 0F715
  db 0x00, 0x00                                ; 0F717
  db 0x00, 0x00                                ; 0F719
  db 0x00, 0x00                                ; 0F71B
  db 0x00, 0x00                                ; 0F71D
  db 0x00, 0x00                                ; 0F71F
  db 0x00, 0x00                                ; 0F721
  db 0x00, 0x00                                ; 0F723
  db 0x00, 0x00                                ; 0F725
  db 0x00, 0x00                                ; 0F727
  db 0x00, 0x00                                ; 0F729
  db 0x00, 0x00                                ; 0F72B
  db 0x00, 0x00                                ; 0F72D
  db 0x00, 0x00                                ; 0F72F
  db 0x00, 0x00                                ; 0F731
  db 0x00, 0x00                                ; 0F733
  db 0x00, 0x00                                ; 0F735
  db 0x00, 0x00                                ; 0F737
  db 0x00, 0x00                                ; 0F739
  db 0x00, 0x00                                ; 0F73B
  db 0x00, 0x00                                ; 0F73D
  db 0x00, 0x00                                ; 0F73F
  db 0x00, 0x00                                ; 0F741
  db 0x00, 0x00                                ; 0F743
  db 0x00, 0x00                                ; 0F745
  db 0x00, 0x00                                ; 0F747
  db 0x00, 0x00                                ; 0F749
  db 0x00, 0x00                                ; 0F74B
  db 0x00, 0x00                                ; 0F74D
  db 0x00, 0x00                                ; 0F74F
  db 0x00, 0x00                                ; 0F751
  db 0x00, 0x00                                ; 0F753
  db 0x00, 0x00                                ; 0F755
  db 0x00, 0x00                                ; 0F757
  db 0x00, 0x00                                ; 0F759
  db 0x00, 0x00                                ; 0F75B
  db 0x00, 0x00                                ; 0F75D
  db 0x00, 0x00                                ; 0F75F
  db 0x00, 0x00                                ; 0F761
  db 0x00, 0x00                                ; 0F763
  db 0x00, 0x00                                ; 0F765
  db 0x00, 0x00                                ; 0F767
  db 0x00, 0x00                                ; 0F769
  db 0x00, 0x00                                ; 0F76B
  db 0x00, 0x00                                ; 0F76D
  db 0x00, 0x00                                ; 0F76F
  db 0x00, 0x00                                ; 0F771
  db 0x00, 0x00                                ; 0F773
  db 0x00, 0x00                                ; 0F775
  db 0x00, 0x00                                ; 0F777
  db 0x00, 0x00                                ; 0F779
  db 0x00, 0x00                                ; 0F77B
  db 0x00, 0x00                                ; 0F77D
  db 0x00, 0x00                                ; 0F77F
  db 0x00, 0x00                                ; 0F781
  db 0x00, 0x00                                ; 0F783
  db 0x00, 0x00                                ; 0F785
  db 0x00, 0x00                                ; 0F787
  db 0x00, 0x00                                ; 0F789
  db 0x00, 0x00                                ; 0F78B
  db 0x00, 0x00                                ; 0F78D
  db 0x00, 0x00                                ; 0F78F
  db 0x00, 0x00                                ; 0F791
  db 0x00, 0x00                                ; 0F793
  db 0x00, 0x00                                ; 0F795
  db 0x00, 0x00                                ; 0F797
  db 0x00, 0x00                                ; 0F799
  db 0x00, 0x00                                ; 0F79B
  db 0x00, 0x00                                ; 0F79D
  db 0x00, 0x00                                ; 0F79F
  db 0x00, 0x00                                ; 0F7A1
  db 0x00, 0x00                                ; 0F7A3
  db 0x00, 0x00                                ; 0F7A5
  db 0x00, 0x00                                ; 0F7A7
  db 0x00, 0x00                                ; 0F7A9
  db 0x00, 0x00                                ; 0F7AB
  db 0x00, 0x00                                ; 0F7AD
  db 0x00, 0x00                                ; 0F7AF
  db 0x00, 0x00                                ; 0F7B1
  db 0x00, 0x00                                ; 0F7B3
  db 0x00, 0x00                                ; 0F7B5
  db 0x00, 0x00                                ; 0F7B7
  db 0x00, 0x00                                ; 0F7B9
  db 0x00, 0x00                                ; 0F7BB
  db 0x00, 0x00                                ; 0F7BD
  db 0x00, 0x00                                ; 0F7BF
  db 0x00, 0x00                                ; 0F7C1
  db 0x00, 0x00                                ; 0F7C3
  db 0x00, 0x00                                ; 0F7C5
  db 0x00, 0x00                                ; 0F7C7
  db 0x00, 0x00                                ; 0F7C9
  db 0x00, 0x00                                ; 0F7CB
  db 0x00, 0x00                                ; 0F7CD
  db 0x00, 0x00                                ; 0F7CF
  db 0x00, 0x00                                ; 0F7D1
  db 0x00, 0x00                                ; 0F7D3
  db 0x00, 0x00                                ; 0F7D5
  db 0x00, 0x00                                ; 0F7D7
  db 0x00, 0x00                                ; 0F7D9
  db 0x00, 0x00                                ; 0F7DB
  db 0x00, 0x00                                ; 0F7DD
  db 0x00, 0x00                                ; 0F7DF
  db 0x00, 0x00                                ; 0F7E1
  db 0x00, 0x00                                ; 0F7E3
  db 0x00, 0x00                                ; 0F7E5
  db 0x00, 0x00                                ; 0F7E7
  db 0x00, 0x00                                ; 0F7E9
  db 0x00, 0x00                                ; 0F7EB
  db 0x00, 0x00                                ; 0F7ED
  db 0x00, 0x00                                ; 0F7EF
  db 0x00, 0x00                                ; 0F7F1
  db 0x00, 0x00                                ; 0F7F3
  db 0x00, 0x00                                ; 0F7F5
  db 0x00, 0x00                                ; 0F7F7
  db 0x00, 0x00                                ; 0F7F9
  db 0x00, 0x00                                ; 0F7FB
  db 0x00, 0x00                                ; 0F7FD
  db 0x00, 0x00                                ; 0F7FF
  db 0x00, 0x00                                ; 0F801
  db 0x00, 0x00                                ; 0F803
  db 0x00, 0x00                                ; 0F805
  db 0x00, 0x00                                ; 0F807
  db 0x00, 0x00                                ; 0F809
  db 0x00, 0x00                                ; 0F80B
  db 0x00, 0x00                                ; 0F80D
  db 0x00, 0x00                                ; 0F80F
  db 0x00, 0x00                                ; 0F811
  db 0x00, 0x00                                ; 0F813
  db 0x00, 0x00                                ; 0F815
  db 0x00, 0x00                                ; 0F817
  db 0x00, 0x00                                ; 0F819
  db 0x00, 0x00                                ; 0F81B
  db 0x00, 0x00                                ; 0F81D
  db 0x00, 0x00                                ; 0F81F
  db 0x00, 0x00                                ; 0F821
  db 0x00, 0x00                                ; 0F823
  db 0x00, 0x00                                ; 0F825
  db 0x00, 0x00                                ; 0F827
  db 0x00, 0x00                                ; 0F829
  db 0x00, 0x00                                ; 0F82B
  db 0x00, 0x00                                ; 0F82D
  db 0x00, 0x00                                ; 0F82F
  db 0x00, 0x00                                ; 0F831
  db 0x00, 0x00                                ; 0F833
  db 0x00, 0x00                                ; 0F835
  db 0x00, 0x00                                ; 0F837
  db 0x00, 0x00                                ; 0F839
  db 0x00, 0x00                                ; 0F83B
  db 0x00, 0x00                                ; 0F83D
  db 0x00, 0x00                                ; 0F83F
  db 0x00, 0x00                                ; 0F841
  db 0x00, 0x00                                ; 0F843
  db 0x00, 0x00                                ; 0F845
  db 0x00, 0x00                                ; 0F847
  db 0x00, 0x00                                ; 0F849
  db 0x00, 0x00                                ; 0F84B
  db 0x00, 0x00                                ; 0F84D
  db 0x00, 0x00                                ; 0F84F
  db 0x00, 0x00                                ; 0F851
  db 0x00, 0x00                                ; 0F853
  db 0x00, 0x00                                ; 0F855
  db 0x00, 0x00                                ; 0F857
  db 0x00, 0x00                                ; 0F859
  db 0x00, 0x00                                ; 0F85B
  db 0x00, 0x00                                ; 0F85D
  db 0x00, 0x00                                ; 0F85F
  db 0x00, 0x00                                ; 0F861
  db 0x00, 0x00                                ; 0F863
  db 0x00, 0x00                                ; 0F865
  db 0x00, 0x00                                ; 0F867
  db 0x00, 0x00                                ; 0F869
  db 0x00, 0x00                                ; 0F86B
  db 0x00, 0x00                                ; 0F86D
  db 0x00, 0x00                                ; 0F86F
  db 0x00, 0x00                                ; 0F871
  db 0x00, 0x00                                ; 0F873
  db 0x00, 0x00                                ; 0F875
  db 0x00, 0x00                                ; 0F877
  db 0x00, 0x00                                ; 0F879
  db 0x00, 0x00                                ; 0F87B
  db 0x00, 0x00                                ; 0F87D
  db 0x00, 0x00                                ; 0F87F
  db 0x00, 0x00                                ; 0F881
  db 0x00, 0x00                                ; 0F883
  db 0x00, 0x00                                ; 0F885
  db 0x00, 0x00                                ; 0F887
  db 0x00, 0x00                                ; 0F889
  db 0x00, 0x00                                ; 0F88B
  db 0x00, 0x00                                ; 0F88D
  db 0x00, 0x00                                ; 0F88F
  db 0x00, 0x00                                ; 0F891
  db 0x00, 0x00                                ; 0F893
  db 0x00, 0x00                                ; 0F895
  db 0x00, 0x00                                ; 0F897
  db 0x00, 0x00                                ; 0F899
  db 0x00, 0x00                                ; 0F89B
  db 0x00, 0x00                                ; 0F89D
  db 0x00, 0x00                                ; 0F89F
  db 0x00, 0x00                                ; 0F8A1
  db 0x00, 0x00                                ; 0F8A3
  db 0x00, 0x00                                ; 0F8A5
  db 0x00, 0x00                                ; 0F8A7
  db 0x00, 0x00                                ; 0F8A9
  db 0x00, 0x00                                ; 0F8AB
  db 0x00, 0x00                                ; 0F8AD
  db 0x00, 0x00                                ; 0F8AF
  db 0x00, 0x00                                ; 0F8B1
  db 0x00, 0x00                                ; 0F8B3
  db 0x00, 0x00                                ; 0F8B5
  db 0x00, 0x00                                ; 0F8B7
  db 0x00, 0x00                                ; 0F8B9
  db 0x00, 0x00                                ; 0F8BB
  db 0x00, 0x00                                ; 0F8BD
  db 0x00, 0x00                                ; 0F8BF
  db 0x00, 0x00                                ; 0F8C1
  db 0x00, 0x00                                ; 0F8C3
  db 0x00, 0x00                                ; 0F8C5
  db 0x00, 0x00                                ; 0F8C7
  db 0x00, 0x00                                ; 0F8C9
  db 0x00, 0x00                                ; 0F8CB
  db 0x00, 0x00                                ; 0F8CD
  db 0x00, 0x00                                ; 0F8CF
  db 0x00, 0x00                                ; 0F8D1
  db 0x00, 0x00                                ; 0F8D3
  db 0x00, 0x00                                ; 0F8D5
  db 0x00, 0x00                                ; 0F8D7
  db 0x00, 0x00                                ; 0F8D9
  db 0x00, 0x00                                ; 0F8DB
  db 0x00, 0x00                                ; 0F8DD
  db 0x00, 0x00                                ; 0F8DF
  db 0x00, 0x47, 0x00                          ; 0F8E1  add byte [bx], al
  db 0x00, 0x00                                ; 0F8E4
  db 0x00, 0x00                                ; 0F8E6
  db 0x00, 0x00                                ; 0F8E8
  db 0x00, 0x00                                ; 0F8EA
  db 0x00, 0x00                                ; 0F8EC
  db 0x00, 0x00                                ; 0F8EE
  db 0x00, 0x00                                ; 0F8F0
  db 0x00, 0x00                                ; 0F8F2
  add dh, al                                   ; 0F8F4  0x00, 0xC6
  add ax, [bx + si]                            ; 0F8F6  0x03, 0x00
  push sp                                      ; 0F8F8  0x54
  db 0x6D                                      ; 0F8F9  insw
  jo loc_0F92C                                 ; 0F8FA  0x70, 0x30
  and [bx + si], ah                            ; 0F8FC  0x20, 0x20
  and [bx + si], ah                            ; 0F8FE  0x20, 0x20
  add al, 0                                    ; 0F900  0x04, 0x00
  db 0x00, 0x00                                ; 0F902
  db 0x00, 0x00                                ; 0F904
  or [bx + si], al                             ; 0F906  0x08, 0x00
  db 0x00, 0x00                                ; 0F908
  db 0x00, 0x00                                ; 0F90A
  db 0x00, 0x00                                ; 0F90C
  db 0x00, 0x00                                ; 0F90E
  db 0x00, 0x00                                ; 0F910
  db 0x00, 0x00                                ; 0F912
  db 0x00, 0x00                                ; 0F914
  db 0x00, 0x00                                ; 0F916
  db 0x00, 0x00                                ; 0F918
  db 0x00, 0x00                                ; 0F91A
  db 0x00, 0x00                                ; 0F91C
  db 0x00, 0x00                                ; 0F91E
  db 0x00, 0x00                                ; 0F920
  db 0x00, 0x00                                ; 0F922
  db 0x00, 0x00                                ; 0F924
  db 0x00, 0x00                                ; 0F926
  db 0x00, 0x00                                ; 0F928
  db 0x00, 0x00                                ; 0F92A

loc_0F92C:                                     ; 0F92C
  db 0x00, 0x00                                ; 0F92C
  db 0x00, 0x00                                ; 0F92E
  db 0x00, 0x00                                ; 0F930
  db 0x00, 0x00                                ; 0F932
  db 0x00, 0x00                                ; 0F934
  db 0x00, 0x00                                ; 0F936
  db 0x00, 0x00                                ; 0F938
  db 0x00, 0x00                                ; 0F93A
  db 0x00, 0x00                                ; 0F93C
  db 0x00, 0x00                                ; 0F93E
  db 0x00, 0x00                                ; 0F940
  db 0x00, 0x00                                ; 0F942
  db 0x00, 0x00                                ; 0F944
  db 0x00, 0x00                                ; 0F946
  db 0x00, 0x00                                ; 0F948
  db 0x00, 0x00                                ; 0F94A
  db 0x00, 0x00                                ; 0F94C
  db 0x00, 0x00                                ; 0F94E
  db 0x00, 0x00                                ; 0F950
  db 0x00, 0x00                                ; 0F952
  cmp al, [bx + di]                            ; 0F954  0x3A, 0x01
  db 0x00, 0x00                                ; 0F956
  db 0x00, 0x00                                ; 0F958
  db 0x00, 0x00                                ; 0F95A
  db 0x00, 0x00                                ; 0F95C
  db 0x00, 0x00                                ; 0F95E
  db 0x00, 0x00                                ; 0F960
  db 0x00, 0x00                                ; 0F962
  db 0x00, 0x00                                ; 0F964
  db 0x00, 0x00                                ; 0F966
  db 0x00, 0x00                                ; 0F968
  db 0x00, 0x00                                ; 0F96A
  db 0x00, 0x00                                ; 0F96C
  db 0x00, 0x00                                ; 0F96E
  adc al, 0x10                                 ; 0F970  0x14, 0x10
  into                                         ; 0F972  0xCE
  db 0x0F, 0xCE                                ; 0F973  bswap si
  db 0x0F, 0xCE                                ; 0F975  bswap si
  db 0x0F, 0x00, 0x00                          ; 0F977  sldt word [bx + si]
  db 0x00, 0x00                                ; 0F97A
  db 0x00, 0x00                                ; 0F97C
  db 0x00, 0x00                                ; 0F97E
  add [bx + si], ax                            ; 0F980  0x01, 0x00
  db 0x00, 0x00                                ; 0F982
  db 0x00, 0x00                                ; 0F984
  db 0x00, 0x00                                ; 0F986
  mov bx, 0xccbb                               ; 0F988  0xBB, 0xBB, 0xCC
  db 0xCC                                      ; 0F98B  int3
  db 0xCC                                      ; 0F98C  int3
  db 0xCC                                      ; 0F98D  int3
  db 0xCC                                      ; 0F98E  int3
  db 0xCC                                      ; 0F98F  int3
  db 0xCC                                      ; 0F990  int3
  db 0xCC                                      ; 0F991  int3
  db 0xCC                                      ; 0F992  int3
  db 0xCC                                      ; 0F993  int3
  db 0xCC                                      ; 0F994  int3
  db 0xCC                                      ; 0F995  int3
  db 0xCC                                      ; 0F996  int3
  db 0xCC                                      ; 0F997  int3
  db 0xCC                                      ; 0F998  int3
  db 0xCC                                      ; 0F999  int3
  db 0xCC                                      ; 0F99A  int3
  db 0xCC                                      ; 0F99B  int3
  db 0xCC                                      ; 0F99C  int3
  db 0xCC                                      ; 0F99D  int3
  db 0xCC                                      ; 0F99E  int3
  db 0xCC                                      ; 0F99F  int3
  db 0xCC                                      ; 0F9A0  int3
  db 0xCC                                      ; 0F9A1  int3
  db 0xCC                                      ; 0F9A2  int3
  db 0xCC                                      ; 0F9A3  int3
  db 0xCC                                      ; 0F9A4  int3
  db 0xCC                                      ; 0F9A5  int3
  db 0xCC                                      ; 0F9A6  int3
  db 0xCC                                      ; 0F9A7  int3
  db 0xCC                                      ; 0F9A8  int3
  db 0xCC                                      ; 0F9A9  int3
  db 0xCC                                      ; 0F9AA  int3
  db 0xCC                                      ; 0F9AB  int3
  db 0xCC                                      ; 0F9AC  int3
  db 0xCC                                      ; 0F9AD  int3
  db 0xCC                                      ; 0F9AE  int3
  db 0xCC                                      ; 0F9AF  int3
  db 0xCC                                      ; 0F9B0  int3
  db 0xCC                                      ; 0F9B1  int3
  db 0xCC                                      ; 0F9B2  int3
  db 0xCC                                      ; 0F9B3  int3
  db 0xCC                                      ; 0F9B4  int3
  db 0xCC                                      ; 0F9B5  int3
  db 0xCC                                      ; 0F9B6  int3
  db 0xCC                                      ; 0F9B7  int3
  db 0xCC                                      ; 0F9B8  int3
  db 0xCC                                      ; 0F9B9  int3
  db 0xCC                                      ; 0F9BA  int3
  db 0xCC                                      ; 0F9BB  int3
  db 0xCC                                      ; 0F9BC  int3
  db 0xCC                                      ; 0F9BD  int3
  db 0xCC                                      ; 0F9BE  int3
  db 0xCC                                      ; 0F9BF  int3
  db 0xCC                                      ; 0F9C0  int3
  db 0xCC                                      ; 0F9C1  int3
  db 0xCC                                      ; 0F9C2  int3
  db 0xCC                                      ; 0F9C3  int3
  db 0xCC                                      ; 0F9C4  int3
  db 0xCC                                      ; 0F9C5  int3
  db 0xCC                                      ; 0F9C6  int3
  db 0xCC                                      ; 0F9C7  int3
  db 0xCC                                      ; 0F9C8  int3
  db 0xCC                                      ; 0F9C9  int3
  db 0xCC                                      ; 0F9CA  int3
  db 0xCC                                      ; 0F9CB  int3
  db 0xCC                                      ; 0F9CC  int3
  db 0xCC                                      ; 0F9CD  int3
  db 0xCC                                      ; 0F9CE  int3
  db 0xCC                                      ; 0F9CF  int3
  db 0xCC                                      ; 0F9D0  int3
  db 0xCC                                      ; 0F9D1  int3
  db 0xCC                                      ; 0F9D2  int3
  db 0xCC                                      ; 0F9D3  int3
  db 0xCC                                      ; 0F9D4  int3
  db 0xCC                                      ; 0F9D5  int3
  db 0xCC                                      ; 0F9D6  int3
  db 0xCC                                      ; 0F9D7  int3
  db 0xCC                                      ; 0F9D8  int3
  db 0xCC                                      ; 0F9D9  int3
  db 0xCC                                      ; 0F9DA  int3
  db 0xCC                                      ; 0F9DB  int3
  db 0xCC                                      ; 0F9DC  int3
  db 0xCC                                      ; 0F9DD  int3
  db 0xCC                                      ; 0F9DE  int3
  db 0xCC                                      ; 0F9DF  int3
  db 0xCC                                      ; 0F9E0  int3
  db 0xCC                                      ; 0F9E1  int3
  db 0xCC                                      ; 0F9E2  int3
  db 0xCC                                      ; 0F9E3  int3
  db 0xCC                                      ; 0F9E4  int3
  db 0xCC                                      ; 0F9E5  int3
  db 0xCC                                      ; 0F9E6  int3
  db 0xCC                                      ; 0F9E7  int3
  db 0xCC                                      ; 0F9E8  int3
  db 0xCC                                      ; 0F9E9  int3
  db 0xCC                                      ; 0F9EA  int3
  db 0xCC                                      ; 0F9EB  int3
  db 0xCC                                      ; 0F9EC  int3
  db 0xCC                                      ; 0F9ED  int3
  db 0xCC                                      ; 0F9EE  int3
  db 0xCC                                      ; 0F9EF  int3
  db 0xCC                                      ; 0F9F0  int3
  db 0xCC                                      ; 0F9F1  int3
  db 0xCC                                      ; 0F9F2  int3
  db 0xCC                                      ; 0F9F3  int3
  db 0xCC                                      ; 0F9F4  int3
  db 0xCC                                      ; 0F9F5  int3
  db 0xCC                                      ; 0F9F6  int3
  db 0xCC                                      ; 0F9F7  int3
  db 0xCC                                      ; 0F9F8  int3
  db 0xCC                                      ; 0F9F9  int3
  db 0xCC                                      ; 0F9FA  int3
  db 0xCC                                      ; 0F9FB  int3
  db 0xCC                                      ; 0F9FC  int3
  db 0xCC                                      ; 0F9FD  int3
  db 0xCC                                      ; 0F9FE  int3
  db 0xCC                                      ; 0F9FF  int3
  db 0xCC                                      ; 0FA00  int3
  db 0xCC                                      ; 0FA01  int3
  db 0xCC                                      ; 0FA02  int3
  db 0xCC                                      ; 0FA03  int3
  db 0xCC                                      ; 0FA04  int3
  db 0xCC                                      ; 0FA05  int3
  db 0xCC                                      ; 0FA06  int3
  db 0xCC                                      ; 0FA07  int3
  db 0xCC                                      ; 0FA08  int3
  db 0xCC                                      ; 0FA09  int3
  db 0xCC                                      ; 0FA0A  int3
  db 0xCC                                      ; 0FA0B  int3
  db 0xCC                                      ; 0FA0C  int3
  db 0xCC                                      ; 0FA0D  int3
  db 0xCC                                      ; 0FA0E  int3
  db 0xCC                                      ; 0FA0F  int3
  db 0xCC                                      ; 0FA10  int3
  db 0xCC                                      ; 0FA11  int3
  db 0xCC                                      ; 0FA12  int3
  db 0xCC                                      ; 0FA13  int3
  db 0xCC                                      ; 0FA14  int3
  db 0xCC                                      ; 0FA15  int3
  db 0xCC                                      ; 0FA16  int3
  db 0xCC                                      ; 0FA17  int3
  db 0xCC                                      ; 0FA18  int3
  db 0xCC                                      ; 0FA19  int3
  db 0x00, 0x00                                ; 0FA1A
  db 0x00, 0x00                                ; 0FA1C
  db 0x00, 0x00                                ; 0FA1E
  db 0x00, 0x00                                ; 0FA20
  db 0x00, 0x00                                ; 0FA22
  db 0x00, 0x00                                ; 0FA24
  db 0x00, 0x00                                ; 0FA26
  add byte [bx + si], 0                        ; 0FA28  0x80, 0x00, 0x00
  db 0x00, 0x00                                ; 0FA2B
  db 0x00, 0x00                                ; 0FA2D
  db 0x00, 0x00                                ; 0FA2F
  db 0x00, 0x00                                ; 0FA31
  db 0x00, 0x00                                ; 0FA33
  db 0x00, 0x00                                ; 0FA35
  db 0x00, 0x00                                ; 0FA37
  db 0x00, 0x00                                ; 0FA39
  db 0x00, 0x00                                ; 0FA3B
  db 0x00, 0x00                                ; 0FA3D
  db 0x00, 0x00                                ; 0FA3F
  db 0x00, 0x00                                ; 0FA41
  db 0x00, 0x00                                ; 0FA43
  db 0x00, 0x00                                ; 0FA45
  db 0x00, 0x00                                ; 0FA47
  db 0x00, 0x00                                ; 0FA49
  db 0x00, 0x00                                ; 0FA4B
  db 0x00, 0x00                                ; 0FA4D
  db 0x00, 0x00                                ; 0FA4F
  db 0x00, 0x00                                ; 0FA51
  db 0x00, 0x00                                ; 0FA53
  db 0x00, 0x00                                ; 0FA55
  db 0x00, 0x00                                ; 0FA57
  db 0x00, 0x00                                ; 0FA59
  db 0x00, 0x00                                ; 0FA5B
  db 0x00, 0x00                                ; 0FA5D
  db 0x00, 0x00                                ; 0FA5F
  db 0x00, 0x00                                ; 0FA61
  db 0x00, 0x00                                ; 0FA63
  db 0x00, 0x00                                ; 0FA65
  db 0x00, 0x00                                ; 0FA67
  db 0x00, 0x00                                ; 0FA69
  db 0x00, 0x00                                ; 0FA6B
  db 0x00, 0x00                                ; 0FA6D
  db 0x00, 0x00                                ; 0FA6F
  db 0x00, 0x00                                ; 0FA71
  db 0x00, 0x00                                ; 0FA73
  db 0x00, 0x00                                ; 0FA75
  db 0x00, 0x00                                ; 0FA77
  db 0x00, 0x00                                ; 0FA79
  db 0x00, 0x00                                ; 0FA7B
  db 0x00, 0x00                                ; 0FA7D
  db 0x00, 0x00                                ; 0FA7F
  db 0x00, 0x00                                ; 0FA81
  db 0x00, 0x00                                ; 0FA83
  db 0x00, 0x00                                ; 0FA85
  db 0x00, 0x00                                ; 0FA87
  db 0x00, 0x00                                ; 0FA89
  db 0x00, 0x00                                ; 0FA8B
  db 0x00, 0x00                                ; 0FA8D
  db 0x00, 0x00                                ; 0FA8F
  db 0x00, 0x00                                ; 0FA91
  db 0x00, 0x00                                ; 0FA93
  db 0x00, 0x00                                ; 0FA95
  db 0x00, 0x00                                ; 0FA97
  db 0x00, 0x00                                ; 0FA99
  db 0x00, 0x00                                ; 0FA9B
  db 0x00, 0x00                                ; 0FA9D
  db 0x00, 0x00                                ; 0FA9F
  db 0x00, 0x00                                ; 0FAA1
  db 0x00, 0x00                                ; 0FAA3
  db 0x00, 0x00                                ; 0FAA5
  db 0x00, 0x00                                ; 0FAA7
  db 0x00, 0x00                                ; 0FAA9
  db 0x00, 0x00                                ; 0FAAB
  db 0x00, 0x00                                ; 0FAAD
  db 0x00, 0x00                                ; 0FAAF
  db 0x00, 0x00                                ; 0FAB1
  db 0x00, 0x80, 0x00, 0x00                    ; 0FAB3  add byte [bx + si], al
  db 0x00, 0x00                                ; 0FAB7
  db 0x00, 0x00                                ; 0FAB9
  db 0x00, 0x00                                ; 0FABB
  db 0x00, 0x00                                ; 0FABD
  db 0x00, 0x00                                ; 0FABF
  db 0x00, 0x00                                ; 0FAC1
  db 0x00, 0x00                                ; 0FAC3
  db 0x00, 0x00                                ; 0FAC5
  db 0x00, 0x00                                ; 0FAC7
  db 0x00, 0x00                                ; 0FAC9
  db 0x00, 0x00                                ; 0FACB
  db 0x00, 0x00                                ; 0FACD
  db 0x00, 0x00                                ; 0FACF
  db 0x00, 0x00                                ; 0FAD1
  db 0x00, 0x00                                ; 0FAD3
  db 0x00, 0x00                                ; 0FAD5
  db 0x00, 0x00                                ; 0FAD7
  db 0x00, 0x00                                ; 0FAD9
  db 0x00, 0x00                                ; 0FADB
  db 0x00, 0x00                                ; 0FADD
  db 0x00, 0x00                                ; 0FADF
  db 0x00, 0x00                                ; 0FAE1
  db 0x00, 0x00                                ; 0FAE3
  db 0x00, 0x00                                ; 0FAE5
  db 0x00, 0x00                                ; 0FAE7
  db 0x00, 0x00                                ; 0FAE9
  db 0x00, 0x00                                ; 0FAEB
  db 0x00, 0x00                                ; 0FAED
  db 0x00, 0x00                                ; 0FAEF
  db 0x00, 0x00                                ; 0FAF1
  db 0x00, 0x00                                ; 0FAF3
  db 0x00, 0x00                                ; 0FAF5
  db 0x00, 0x00                                ; 0FAF7
  db 0x00, 0x00                                ; 0FAF9
  db 0x00, 0x00                                ; 0FAFB
  db 0x00, 0x00                                ; 0FAFD
  db 0x00, 0x00                                ; 0FAFF
  db 0x00, 0x00                                ; 0FB01
  db 0x00, 0x00                                ; 0FB03
  db 0x00, 0x00                                ; 0FB05
  db 0x00, 0x00                                ; 0FB07
  db 0x00, 0x00                                ; 0FB09
  db 0x00, 0x00                                ; 0FB0B
  db 0x00, 0x00                                ; 0FB0D
  db 0x00, 0x00                                ; 0FB0F
  db 0x00, 0x00                                ; 0FB11
  db 0x00, 0x00                                ; 0FB13
  db 0x00, 0x00                                ; 0FB15
  db 0x00, 0x00                                ; 0FB17
  db 0x00, 0x00                                ; 0FB19
  db 0x00, 0x00                                ; 0FB1B
  db 0x00, 0x00                                ; 0FB1D
  db 0x00, 0x00                                ; 0FB1F
  db 0x00, 0x00                                ; 0FB21
  db 0x00, 0x00                                ; 0FB23
  db 0x00, 0x00                                ; 0FB25
  db 0x00, 0x00                                ; 0FB27
  db 0x00, 0x00                                ; 0FB29
  db 0x00, 0x00                                ; 0FB2B
  db 0x00, 0x00                                ; 0FB2D
  db 0x00, 0x00                                ; 0FB2F
  db 0x00, 0x00                                ; 0FB31
  db 0x00, 0x00                                ; 0FB33
  db 0x00, 0x00                                ; 0FB35
  db 0x00, 0x00                                ; 0FB37
  db 0x00, 0x00                                ; 0FB39
  add dl, dl                                   ; 0FB3B  0x00, 0xD2
  add ch, [bx + 0x4a02]                        ; 0FB3D  0x02, 0xAF, 0x02, 0x4A
  add [bx + si], ax                            ; 0FB41  0x01, 0x00
  db 0x00, 0x80, 0x00, 0x00                    ; 0FB43  add byte [bx + si], al
  inc si                                       ; 0FB47  0x46
  push bp                                      ; 0FB48  0x55
  dec si                                       ; 0FB49  0x4E
  inc bx                                       ; 0FB4A  0x43
  push sp                                      ; 0FB4B  0x54
  dec cx                                       ; 0FB4C  0x49
  dec di                                       ; 0FB4D  0x4F
  dec si                                       ; 0FB4E  0x4E
  push bx                                      ; 0FB4F  0x53
  pop cx                                       ; 0FB50  0x59
  push bx                                      ; 0FB51  0x53
  db 0x00, 0x00                                ; 0FB52
  db 0x00, 0x00                                ; 0FB54
  db 0x00, 0x00                                ; 0FB56
  db 0x00, 0x00                                ; 0FB58
  db 0x00, 0x00                                ; 0FB5A
  db 0x00, 0x00                                ; 0FB5C
  db 0x00, 0x00                                ; 0FB5E
  db 0x00, 0x00                                ; 0FB60
  db 0x00, 0x00                                ; 0FB62
  db 0x00, 0x00                                ; 0FB64
  db 0x00, 0x00                                ; 0FB66
  db 0x00, 0x00                                ; 0FB68
  add [bp + di + 0x54], dl                     ; 0FB6A  0x00, 0x53, 0x54
  inc cx                                       ; 0FB6D  0x41
  push dx                                      ; 0FB6E  0x52
  push sp                                      ; 0FB6F  0x54
  push bp                                      ; 0FB70  0x55
  push ax                                      ; 0FB71  0x50
  and [bx + si + 0x20], bh                     ; 0FB72  0x20, 0x78, 0x20
  and [bx + si], al                            ; 0FB75  0x20, 0x00
  db 0x00, 0x00                                ; 0FB77
  db 0x00, 0x00                                ; 0FB79
  db 0x00, 0x00                                ; 0FB7B
  db 0x00, 0x00                                ; 0FB7D
  db 0x00, 0x00                                ; 0FB7F
  db 0x00, 0x00                                ; 0FB81
  db 0x00, 0x00                                ; 0FB83
  db 0x00, 0x00                                ; 0FB85
  db 0x00, 0x00                                ; 0FB87
  db 0x00, 0x00                                ; 0FB89
  db 0x00, 0x00                                ; 0FB8B
  add [bx], bh                                 ; 0FB8D  0x00, 0x3F
  db 0x00, 0x00                                ; 0FB8F
  db 0x00, 0x00                                ; 0FB91
  db 0x00, 0x00                                ; 0FB93
  db 0x00, 0x00                                ; 0FB95
  db 0x00, 0x00                                ; 0FB97
  db 0x00, 0x00                                ; 0FB99
  db 0x00, 0x00                                ; 0FB9B
  db 0x00, 0x00                                ; 0FB9D
  db 0x00, 0x00                                ; 0FB9F
  db 0x00, 0x00                                ; 0FBA1
  db 0x00, 0x00                                ; 0FBA3
  db 0x00, 0x00                                ; 0FBA5
  db 0x00, 0x00                                ; 0FBA7
  db 0x00, 0x00                                ; 0FBA9
  db 0x00, 0x00                                ; 0FBAB
  db 0x00, 0x00                                ; 0FBAD
  db 0x00, 0x00                                ; 0FBAF
  db 0x00, 0x00                                ; 0FBB1
  db 0x00, 0x00                                ; 0FBB3
  db 0x00, 0x00                                ; 0FBB5
  db 0x00, 0x00                                ; 0FBB7
  db 0x00, 0x00                                ; 0FBB9
  db 0x00, 0x00                                ; 0FBBB
  db 0x00, 0x00                                ; 0FBBD
  db 0x00, 0x00                                ; 0FBBF
  db 0x00, 0x00                                ; 0FBC1
  db 0x00, 0x00                                ; 0FBC3
  db 0x00, 0x00                                ; 0FBC5
  db 0x00, 0x00                                ; 0FBC7
  db 0x00, 0x00                                ; 0FBC9
  db 0x00, 0x00                                ; 0FBCB
  db 0x00, 0x00                                ; 0FBCD
  db 0x00, 0x00                                ; 0FBCF
  db 0x00, 0x00                                ; 0FBD1
  db 0x00, 0x00                                ; 0FBD3
  db 0x00, 0x00                                ; 0FBD5
  db 0x00, 0x00                                ; 0FBD7
  db 0x00, 0x00                                ; 0FBD9
  db 0x00, 0x00                                ; 0FBDB
  db 0x00, 0x00                                ; 0FBDD
  db 0x00, 0x00                                ; 0FBDF
  db 0x00, 0x00                                ; 0FBE1
  db 0x00, 0x00                                ; 0FBE3
  db 0x00, 0x00                                ; 0FBE5
  db 0x00, 0x00                                ; 0FBE7
  db 0x00, 0x00                                ; 0FBE9
  db 0x00, 0x00                                ; 0FBEB
  db 0x00, 0x00                                ; 0FBED
  db 0x00, 0x00                                ; 0FBEF
  db 0x00, 0x00                                ; 0FBF1
  db 0x00, 0x00                                ; 0FBF3
  db 0x00, 0x00                                ; 0FBF5
  db 0x00, 0x00                                ; 0FBF7
  db 0x00, 0x00                                ; 0FBF9
  db 0x00, 0x00                                ; 0FBFB
  db 0x00, 0x00                                ; 0FBFD
  db 0x00, 0x00                                ; 0FBFF
  db 0x00, 0x00                                ; 0FC01
  db 0x00, 0x00                                ; 0FC03
  db 0x00, 0x00                                ; 0FC05
  db 0x00, 0x00                                ; 0FC07
  db 0x00, 0x00                                ; 0FC09
  db 0x00, 0x00                                ; 0FC0B
  db 0x00, 0x00                                ; 0FC0D
  db 0x00, 0x00                                ; 0FC0F
  db 0x00, 0x00                                ; 0FC11
  db 0x00, 0x00                                ; 0FC13
  db 0x00, 0x00                                ; 0FC15
  db 0x00, 0x00                                ; 0FC17
  db 0x00, 0x00                                ; 0FC19
  db 0x00, 0x00                                ; 0FC1B
  db 0x00, 0x00                                ; 0FC1D
  db 0x00, 0x00                                ; 0FC1F
  db 0x00, 0x00                                ; 0FC21
  db 0x00, 0x00                                ; 0FC23
  db 0x00, 0x00                                ; 0FC25
  db 0x00, 0x00                                ; 0FC27
  db 0x00, 0x00                                ; 0FC29
  db 0x00, 0x00                                ; 0FC2B
  db 0x00, 0x00                                ; 0FC2D
  db 0x00, 0x00                                ; 0FC2F
  db 0x00, 0x00                                ; 0FC31
  db 0x00, 0x00                                ; 0FC33
  db 0x00, 0x00                                ; 0FC35
  db 0x00, 0x00                                ; 0FC37
  add [si + 0x6d], dl                          ; 0FC39  0x00, 0x54, 0x6D
  jo loc_0FC5E                                 ; 0FC3C  0x70, 0x20
  and [bx + si], ah                            ; 0FC3E  0x20, 0x20
  and [bx + si], ah                            ; 0FC40  0x20, 0x20
  jo loc_0FC44                                 ; 0FC42  0x70, 0x00

loc_0FC44:                                     ; 0FC44
  add [bx + si], ax                            ; 0FC44  0x01, 0x00
  db 0x00, 0x00                                ; 0FC46
  db 0x00, 0x00                                ; 0FC48
  db 0x00, 0x00                                ; 0FC4A
  db 0x00, 0x00                                ; 0FC4C
  db 0x70, 0x03                                ; 0FC4E  jo 0xfc53
  db 0x00, 0x00                                ; 0FC50
  db 0x00, 0x00                                ; 0FC52
  db 0x00, 0x00                                ; 0FC54
  db 0x00, 0x00                                ; 0FC56
  db 0x00, 0x00                                ; 0FC58
  db 0x00, 0x00                                ; 0FC5A
  db 0x00, 0x00                                ; 0FC5C

loc_0FC5E:                                     ; 0FC5E
  db 0x00, 0x00                                ; 0FC5E
  db 0x00, 0x00                                ; 0FC60
  db 0x00, 0x00                                ; 0FC62
  db 0x00, 0x00                                ; 0FC64
  db 0x00, 0x00                                ; 0FC66
  db 0x00, 0x00                                ; 0FC68
  db 0x00, 0x00                                ; 0FC6A
  db 0x00, 0x00                                ; 0FC6C
  db 0x00, 0x00                                ; 0FC6E
  db 0x00, 0x00                                ; 0FC70
  db 0x00, 0x00                                ; 0FC72
  db 0x00, 0x00                                ; 0FC74
  db 0x00, 0x00                                ; 0FC76
  db 0x00, 0x00                                ; 0FC78
  db 0x00, 0x00                                ; 0FC7A
  db 0x00, 0x00                                ; 0FC7C
  db 0x00, 0x00                                ; 0FC7E
  db 0x00, 0x00                                ; 0FC80
  db 0x00, 0x00                                ; 0FC82
  db 0x00, 0x00                                ; 0FC84
  db 0x00, 0x00                                ; 0FC86
  db 0x00, 0x00                                ; 0FC88
  db 0x00, 0x00                                ; 0FC8A
  db 0x00, 0x00                                ; 0FC8C
  db 0x00, 0x00                                ; 0FC8E
  db 0x00, 0x00                                ; 0FC90
  db 0x00, 0x00                                ; 0FC92
  db 0x00, 0x00                                ; 0FC94
  db 0x00, 0x00                                ; 0FC96
  db 0x00, 0x00                                ; 0FC98
  db 0x00, 0x00                                ; 0FC9A
  db 0x00, 0x00                                ; 0FC9C
  db 0x00, 0x00                                ; 0FC9E
  db 0x00, 0x00                                ; 0FCA0
  db 0x00, 0x00                                ; 0FCA2
  db 0x00, 0x00                                ; 0FCA4
  db 0x00, 0x00                                ; 0FCA6
  db 0x00, 0x00                                ; 0FCA8
  db 0x00, 0x00                                ; 0FCAA
  db 0x00, 0x00                                ; 0FCAC
  db 0x00, 0x00                                ; 0FCAE
  db 0x00, 0x00                                ; 0FCB0
  db 0x00, 0x00                                ; 0FCB2
  db 0x00, 0x00                                ; 0FCB4
  db 0x00, 0x00                                ; 0FCB6
  db 0x00, 0x00                                ; 0FCB8
  db 0x00, 0x00                                ; 0FCBA
  db 0x00, 0x00                                ; 0FCBC
  db 0x00, 0x00                                ; 0FCBE
  db 0x00, 0x00                                ; 0FCC0
  db 0x00, 0x00                                ; 0FCC2
  db 0x00, 0x00                                ; 0FCC4
  dec ax                                       ; 0FCC6  0x48
  add [si + 0x6d], dx                          ; 0FCC7  0x01, 0x54, 0x6D
  db 0x70, 0x20                                ; 0FCCA  jo 0xfcec
  and [bx + si], ah                            ; 0FCCC  0x20, 0x20
  and [bx + si], ah                            ; 0FCCE  0x20, 0x20
  add [fs:bp + si], cl                         ; 0FCD0  0x64, 0x00, 0x0A
  add [bx + di], al                            ; 0FCD3  0x00, 0x01
  add [bp + di], bl                            ; 0FCD5  0x00, 0x1B
  pop cx                                       ; 0FCD7  0x59
  and [bx + si], ah                            ; 0FCD8  0x20, 0x20
  add [bp + di + 0x69], dl                     ; 0FCDA  0x00, 0x53, 0x69
  db 0x7A, 0x65                                ; 0FCDD  "ze" i "Size ="
  and [di], bh                                 ; 0FCDF  0x20, 0x3D
  and [bx + si], ah                            ; 0FCE1  0x20, 0x20
  and [bx + si], ah                            ; 0FCE3  0x20, 0x20
  and [bp + di + 0x20], cl                     ; 0FCE5  0x20, 0x4B, 0x20
  db 0x62, 0x79, 0x74                          ; 0FCE8  bound di, dword [bx + di + 0x74]
  db 0x65, 0x73, 0x0D                          ; 0FCEB  jae 0xfcfb
  or al, [bx + si]                             ; 0FCEE  0x0A, 0x00
  add al, al                                   ; 0FCF0  0x00, 0xC0
  db 0x00, 0x00                                ; 0FCF2
  push ax                                      ; 0FCF4  0x50
  inc cx                                       ; 0FCF5  0x41
  push bx                                      ; 0FCF6  0x53
  push bx                                      ; 0FCF7  0x53
  push di                                      ; 0FCF8  0x57
  dec di                                       ; 0FCF9  0x4F
  push dx                                      ; 0FCFA  0x52

loc_0FCFB:                                     ; 0FCFB
  inc sp                                       ; 0FCFB  0x44
  db 0x00, 0x00                                ; 0FCFC
  db 0x00, 0x00                                ; 0FCFE
  adc [bp + 0x41], cl                          ; 0FD00  0x10, 0x4E, 0x41
  dec bp                                       ; 0FD03  0x4D
  push bx                                      ; 0FD04  0x53
  push si                                      ; 0FD05  0x56
  push dx                                      ; 0FD06  0x52
  and [bx + si], ah                            ; 0FD07  0x20, 0x20
  inc sp                                       ; 0FD09  0x44
  inc cx                                       ; 0FD0A  0x41
  push sp                                      ; 0FD0B  0x54
  db 0x00, 0x00                                ; 0FD0C
  db 0x00, 0x00                                ; 0FD0E
  db 0x00, 0x00                                ; 0FD10
  db 0x00, 0x00                                ; 0FD12
  db 0x00, 0x00                                ; 0FD14
  db 0x00, 0x00                                ; 0FD16
  db 0x00, 0x00                                ; 0FD18
  db 0x00, 0x00                                ; 0FD1A
  db 0x00, 0x00                                ; 0FD1C
  db 0x00, 0x00                                ; 0FD1E
  db 0x00, 0x00                                ; 0FD20
  db 0x00, 0x00                                ; 0FD22
  and [bx + si], ah                            ; 0FD24  0x20, 0x20
  and [bx + si], ah                            ; 0FD26  0x20, 0x20
  and [bx + si], ah                            ; 0FD28  0x20, 0x20
  and [bx + si], ah                            ; 0FD2A  0x20, 0x20
  and [bx + si], ah                            ; 0FD2C  0x20, 0x20
  and [bx + si], ah                            ; 0FD2E  0x20, 0x20
  and [bx + si], ah                            ; 0FD30  0x20, 0x20
  and [bx + si], ah                            ; 0FD32  0x20, 0x20
  and [bx + si], ah                            ; 0FD34  0x20, 0x20
  db 0x00, 0x00                                ; 0FD36
  db 0x00, 0x00                                ; 0FD38
  db 0x00, 0x00                                ; 0FD3A
  db 0x00, 0x00                                ; 0FD3C
  db 0x00, 0x00                                ; 0FD3E

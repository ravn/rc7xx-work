; ===========================================================================
; Regnecentralen RC759 Piccoline — VOUT.RSP Code Segment
; Virtual OUTput multiplexer (skærmoutput for Piccoline)
; 116 paragraphs = 1.856 bytes (0x125E0 - 0x12D1F)
; ===========================================================================

%include "rasm86.inc"

  ; Digital Research copyright banner (37 bytes, 0x125E0 - 0x12604)
  db 'COPYRIGHT (C) 1983, DIGITAL RESEARCH '

vout_xdos:                                     ; 12605
  push bp                                      ; 12605  0x55
  mov_bp_sp                                    ; 12606  mov bp, sp
  mov dx, [bp + 4]                             ; 12608  0x8B, 0x56, 0x04
  mov cx, [bp + 6]                             ; 1260B  0x8B, 0x4E, 0x06
  int 0xe0                                     ; 1260E  0xCD, 0xE0
  pop bp                                       ; 12610  0x5D
  ret 4                                        ; 12611  0xC2, 0x04, 0x00

vout_intsys:                                     ; 12614
  push bp                                      ; 12614  0x55
  mov_bp_sp                                    ; 12615  mov bp, sp
  mov bx, [bp + 4]                             ; 12617  0x8B, 0x5E, 0x04
  mov dx, [bp + 6]                             ; 1261A  0x8B, 0x56, 0x06
  mov cx, [bp + 8]                             ; 1261D  0x8B, 0x4E, 0x08
  push ds                                      ; 12620  0x1E
  mov ds, [0]                                  ; 12621  0x8E, 0x1E, 0x00, 0x00
  mov si, [0x68]                               ; 12625  0x8B, 0x36, 0x68, 0x00
  mov es, [si + 0x10]                          ; 12629  0x8E, 0x44, 0x10
  call far [0]                                 ; 1262C  0xFF, 0x1E, 0x00, 0x00
  pop ds                                       ; 12630  0x1F
  pop bp                                       ; 12631  0x5D
  ret 6                                        ; 12632  0xC2, 0x06, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 12635  ...........

vout_pxios1:                                     ; 12640
  push bp                                      ; 12640  0x55
  mov_bp_sp                                    ; 12641  mov bp, sp
  mov ax, [bp + 8]                             ; 12643  0x8B, 0x46, 0x08
  mov cx, [bp + 6]                             ; 12646  0x8B, 0x4E, 0x06
  mov dx, [bp + 4]                             ; 12649  0x8B, 0x56, 0x04
  push ds                                      ; 1264C  0x1E
  mov ds, [0]                                  ; 1264D  0x8E, 0x1E, 0x00, 0x00
  mov si, [0x68]                               ; 12651  0x8B, 0x36, 0x68, 0x00
  mov es, [si + 0x10]                          ; 12655  0x8E, 0x44, 0x10
  call far [0x28]                              ; 12658  0xFF, 0x1E, 0x28, 0x00
  pop ds                                       ; 1265C  0x1F
  pop bp                                       ; 1265D  0x5D
  ret 6                                        ; 1265E  0xC2, 0x06, 0x00
  db 0x00                                      ; 12661  .

vout_sleep:                                     ; 12662
  push bp                                      ; 12662  0x55
  mov_bp_sp                                    ; 12663  mov bp, sp
  mov ax, 0x212                                ; 12665  0xB8, 0x12, 0x02
  push ax                                      ; 12668  0x50
  push word [bp + 4]                           ; 12669  0xFF, 0x76, 0x04
  mov ax, 9                                    ; 1266C  0xB8, 0x09, 0x00
  push ax                                      ; 1266F  0x50
  call vout_intsys                               ; 12670  0xE8, 0xA1, 0xFF
  pop bp                                       ; 12673  0x5D
  ret 2                                        ; 12674  0xC2, 0x02, 0x00

vout_wakeup:                                     ; 12677
  push bp                                      ; 12677  0x55
  mov_bp_sp                                    ; 12678  mov bp, sp
  mov ax, 0x213                                ; 1267A  0xB8, 0x13, 0x02
  push ax                                      ; 1267D  0x50
  push word [bp + 4]                           ; 1267E  0xFF, 0x76, 0x04
  mov ax, 0                                    ; 12681  0xB8, 0x00, 0x00
  push ax                                      ; 12684  0x50
  call vout_intsys                               ; 12685  0xE8, 0x8C, 0xFF
  pop bp                                       ; 12688  0x5D
  ret 2                                        ; 12689  0xC2, 0x02, 0x00

vout_read_change_mxq:                                     ; 1268C
  push bp                                      ; 1268C  0x55
  mov_bp_sp                                    ; 1268D  mov bp, sp
  les bx, [vout_cur_ccb]                              ; 1268F  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 0x16]                       ; 12693  0x26, 0x8B, 0x47, 0x16
  mov [vout_mxq_msg], ax                              ; 12697  0xA3, 0x34, 0x02
  mov al, 0x89                                 ; 1269A  0xB0, 0x89
  push ax                                      ; 1269C  0x50
  mov ax, 0x232                                ; 1269D  0xB8, 0x32, 0x02
  push ax                                      ; 126A0  0x50
  call vout_xdos                               ; 126A1  0xE8, 0x61, 0xFF
  pop bp                                       ; 126A4  0x5D
  ret                                          ; 126A5  0xC3

vout_write_change_mxq:                                     ; 126A6
  push bp                                      ; 126A6  0x55
  mov_bp_sp                                    ; 126A7  mov bp, sp
  les bx, [vout_cur_ccb]                              ; 126A9  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 0x16]                       ; 126AD  0x26, 0x8B, 0x47, 0x16
  mov [vout_mxq_msg], ax                              ; 126B1  0xA3, 0x34, 0x02
  mov al, 0x8b                                 ; 126B4  0xB0, 0x8B
  push ax                                      ; 126B6  0x50
  mov ax, 0x232                                ; 126B7  0xB8, 0x32, 0x02
  push ax                                      ; 126BA  0x50
  call vout_xdos                               ; 126BB  0xE8, 0x47, 0xFF
  pop bp                                       ; 126BE  0x5D
  ret                                          ; 126BF  0xC3

vout_delete_file:                                     ; 126C0
  push bp                                      ; 126C0  0x55
  mov_bp_sp                                    ; 126C1  mov bp, sp
  mov al, 0x10                                 ; 126C3  0xB0, 0x10
  push ax                                      ; 126C5  0x50
  mov ax, 0x372                                ; 126C6  0xB8, 0x72, 0x03
  push ax                                      ; 126C9  0x50
  call vout_xdos                               ; 126CA  0xE8, 0x38, 0xFF
  mov al, 0x13                                 ; 126CD  0xB0, 0x13
  push ax                                      ; 126CF  0x50
  mov ax, 0x372                                ; 126D0  0xB8, 0x72, 0x03
  push ax                                      ; 126D3  0x50
  call vout_xdos                               ; 126D4  0xE8, 0x2E, 0xFF
  mov byte [vout_vcmxq_flag1], 0                          ; 126D7  0xC6, 0x06, 0x45, 0x02, 0x00
  mov byte [vout_vcmxq_flag2], 0xff                       ; 126DC  0xC6, 0x06, 0x46, 0x02, 0xFF
  pop bp                                       ; 126E1  0x5D
  ret                                          ; 126E2  0xC3

vout_make_file:                                     ; 126E3
  push bp                                      ; 126E3  0x55
  mov_bp_sp                                    ; 126E4  mov bp, sp
  lea di, [vout_work_buf]                              ; 126E6  0x8D, 0x3E, 0x7E, 0x03
  mov al, 0                                    ; 126EA  0xB0, 0x00
  mov cx, 0x18                                 ; 126EC  0xB9, 0x18, 0x00
  push ds                                      ; 126EF  0x1E
  pop es                                       ; 126F0  0x07
  cld                                          ; 126F1  0xFC
  repne stosb                                  ; 126F2  0xF2, 0xAA
  les bx, [vout_sysdat_ptr]                              ; 126F4  0xC4, 0x1E, 0x40, 0x01
  mov al, [es:bx + 0x50]                       ; 126F8  0x26, 0x8A, 0x47, 0x50
  inc al                                       ; 126FC  0xFE, 0xC0
  mov [vout_buf_last], al                              ; 126FE  0xA2, 0x72, 0x03
  mov al, 0x13                                 ; 12701  0xB0, 0x13
  push ax                                      ; 12703  0x50
  mov ax, 0x372                                ; 12704  0xB8, 0x72, 0x03
  push ax                                      ; 12707  0x50
  call vout_xdos                               ; 12708  0xE8, 0xFA, 0xFE
  mov al, 0x16                                 ; 1270B  0xB0, 0x16
  push ax                                      ; 1270D  0x50
  mov ax, 0x372                                ; 1270E  0xB8, 0x72, 0x03
  push ax                                      ; 12711  0x50
  call vout_xdos                               ; 12712  0xE8, 0xF0, 0xFE
  cmp al, 0xff                                 ; 12715  0x3C, 0xFF
  jne loc_1271D                                ; 12717  0x75, 0x04
  mov al, 0                                    ; 12719  0xB0, 0x00
  pop bp                                       ; 1271B  0x5D
  ret                                          ; 1271C  0xC3

loc_1271D:                                     ; 1271D
  mov byte [vout_vcmxq_flag2], 0                          ; 1271D  0xC6, 0x06, 0x46, 0x02, 0x00
  mov al, 0xff                                 ; 12722  0xB0, 0xFF
  pop bp                                       ; 12724  0x5D
  ret                                          ; 12725  0xC3

vout_reset_file:                                     ; 12726
  push bp                                      ; 12726  0x55
  mov_bp_sp                                    ; 12727  mov bp, sp
  mov byte [vout_vcmxq_flag1], 0xff                       ; 12729  0xC6, 0x06, 0x45, 0x02, 0xFF
  mov byte [vout_vcmxq_flag3], 0xff                       ; 1272E  0xC6, 0x06, 0x47, 0x02, 0xFF
  mov al, 0                                    ; 12733  0xB0, 0x00
  mov [vout_vcmxq_data], al                              ; 12735  0xA2, 0x44, 0x02
  mov ah, 0                                    ; 12738  0xB4, 0x00
  mov [vout_q_end], ax                              ; 1273A  0xA3, 0x50, 0x01
  mov [vout_q_start], ax                              ; 1273D  0xA3, 0x4E, 0x01
  pop bp                                       ; 12740  0x5D
  ret                                          ; 12741  0xC3

vout_write_buf:                                     ; 12742
  push bp                                      ; 12742  0x55
  mov_bp_sp                                    ; 12743  mov bp, sp
  mov al, [vout_vcmxq_flag2]                              ; 12745  0xA0, 0x46, 0x02
  rcr al, 1                                    ; 12748  0xD0, 0xD8
  jae loc_12757                                ; 1274A  0x73, 0x0B
  call vout_make_file                               ; 1274C  0xE8, 0x94, 0xFF

loc_1274F:                                     ; 1274F
  not al                                       ; 1274F  0xF6, 0xD0
  rcr al, 1                                    ; 12751  0xD0, 0xD8
  jae loc_12765                                ; 12753  0x73, 0x10
  jmp short loc_12799                          ; 12755  0xEB, 0x42

loc_12757:                                     ; 12757
  mov ax, [vout_q_start]                              ; 12757  0xA1, 0x4E, 0x01
  cmp ax, [vout_q_end]                              ; 1275A  0x3B, 0x06, 0x50, 0x01
  jne loc_12765                                ; 1275E  0x75, 0x05
  mov al, [vout_vcmxq_flag3]                              ; 12760  0xA0, 0x47, 0x02
  jmp short loc_1274F                          ; 12763  0xEB, 0xEA

loc_12765:                                     ; 12765
  mov al, [vout_vcmxq_data]                              ; 12765  0xA0, 0x44, 0x02
  not al                                       ; 12768  0xF6, 0xD0
  rcr al, 1                                    ; 1276A  0xD0, 0xD8
  jae loc_1277D                                ; 1276C  0x73, 0x0F
  mov al, 0x1a                                 ; 1276E  0xB0, 0x1A
  push ax                                      ; 12770  0x50
  mov ax, 0x248                                ; 12771  0xB8, 0x48, 0x02
  push ax                                      ; 12774  0x50
  call vout_xdos                               ; 12775  0xE8, 0x8D, 0xFE
  mov byte [vout_vcmxq_data], 0xff                       ; 12778  0xC6, 0x06, 0x44, 0x02, 0xFF

loc_1277D:                                     ; 1277D
  mov ax, [vout_q_end]                              ; 1277D  0xA1, 0x50, 0x01
  mov [vout_ws1], al                              ; 12780  0xA2, 0x93, 0x03
  mov ax, [vout_q_end]                              ; 12783  0xA1, 0x50, 0x01
  mov al, ah                                   ; 12786  0x88, 0xE0
  mov [vout_ws2], al                              ; 12788  0xA2, 0x94, 0x03
  mov al, 0x22                                 ; 1278B  0xB0, 0x22
  push ax                                      ; 1278D  0x50
  mov ax, 0x372                                ; 1278E  0xB8, 0x72, 0x03
  push ax                                      ; 12791  0x50
  call vout_xdos                               ; 12792  0xE8, 0x70, 0xFE
  cmp al, 0                                    ; 12795  0x3C, 0x00
  je loc_1279D                                 ; 12797  0x74, 0x04

loc_12799:                                     ; 12799
  mov al, 0                                    ; 12799  0xB0, 0x00
  pop bp                                       ; 1279B  0x5D
  ret                                          ; 1279C  0xC3

loc_1279D:                                     ; 1279D
  mov byte [vout_vcmxq_flag3], 0                          ; 1279D  0xC6, 0x06, 0x47, 0x02, 0x00
  mov word [vout_char_pend], 0xffff                     ; 127A2  0xC7, 0x06, 0x52, 0x01, 0xFF, 0xFF
  mov ax, [vout_q_end]                              ; 127A8  0xA1, 0x50, 0x01
  inc ax                                       ; 127AB  0x40
  les bx, [vout_cur_ccb]                              ; 127AC  0xC4, 0x1E, 0x44, 0x01
  push ax                                      ; 127B0  0x50
  mov ax, [es:bx + 0x10]                       ; 127B1  0x26, 0x8B, 0x47, 0x10
  mov cx, 8                                    ; 127B5  0xB9, 0x08, 0x00
  mul_cx                                       ; 127B8  mul cx
  mov cx, ax                                   ; 127BA  0x89, 0xC1
  pop ax                                       ; 127BC  0x58
  xor dx, dx                                   ; 127BD  0x31, 0xD2
  div_cx                                       ; 127BF  div cx
  mov [vout_q_end], dx                              ; 127C1  0x89, 0x16, 0x50, 0x01
  mov al, 0xff                                 ; 127C5  0xB0, 0xFF
  pop bp                                       ; 127C7  0x5D
  ret                                          ; 127C8  0xC3

vout_read_buf:                                     ; 127C9
  push bp                                      ; 127C9  0x55
  mov_bp_sp                                    ; 127CA  mov bp, sp
  mov al, [vout_vcmxq_flag3]                              ; 127CC  0xA0, 0x47, 0x02
  rcr al, 1                                    ; 127CF  0xD0, 0xD8
  jae loc_127E3                                ; 127D1  0x73, 0x10
  mov al, [vout_vcmxq_flag2]                              ; 127D3  0xA0, 0x46, 0x02
  not al                                       ; 127D6  0xF6, 0xD0
  rcr al, 1                                    ; 127D8  0xD0, 0xD8
  jae loc_127DF                                ; 127DA  0x73, 0x03
  call vout_reset_file                               ; 127DC  0xE8, 0x47, 0xFF

loc_127DF:                                     ; 127DF
  mov al, 0                                    ; 127DF  0xB0, 0x00
  pop bp                                       ; 127E1  0x5D
  ret                                          ; 127E2  0xC3

loc_127E3:                                     ; 127E3
  mov al, [vout_vcmxq_data]                              ; 127E3  0xA0, 0x44, 0x02
  rcr al, 1                                    ; 127E6  0xD0, 0xD8
  jae loc_127F9                                ; 127E8  0x73, 0x0F
  mov al, 0x1a                                 ; 127EA  0xB0, 0x1A
  push ax                                      ; 127EC  0x50
  mov ax, 0x2c8                                ; 127ED  0xB8, 0xC8, 0x02
  push ax                                      ; 127F0  0x50
  call vout_xdos                               ; 127F1  0xE8, 0x11, 0xFE
  mov byte [vout_vcmxq_data], 0                          ; 127F4  0xC6, 0x06, 0x44, 0x02, 0x00

loc_127F9:                                     ; 127F9
  mov ax, [vout_q_start]                              ; 127F9  0xA1, 0x4E, 0x01
  mov [vout_ws1], al                              ; 127FC  0xA2, 0x93, 0x03
  mov ax, [vout_q_start]                              ; 127FF  0xA1, 0x4E, 0x01
  mov al, ah                                   ; 12802  0x88, 0xE0
  mov [vout_ws2], al                              ; 12804  0xA2, 0x94, 0x03
  mov al, 0x21                                 ; 12807  0xB0, 0x21
  push ax                                      ; 12809  0x50
  mov ax, 0x372                                ; 1280A  0xB8, 0x72, 0x03
  push ax                                      ; 1280D  0x50
  call vout_xdos                               ; 1280E  0xE8, 0xF4, 0xFD
  cmp al, 0                                    ; 12811  0x3C, 0x00
  mov al, 0xff                                 ; 12813  0xB0, 0xFF
  je loc_12818                                 ; 12815  0x74, 0x01
  inc ax                                       ; 12817  0x40

loc_12818:                                     ; 12818
  mov [vout_ostate], al                              ; 12818  0xA2, 0x48, 0x03
  mov ax, [vout_q_start]                              ; 1281B  0xA1, 0x4E, 0x01
  inc ax                                       ; 1281E  0x40
  les bx, [vout_cur_ccb]                              ; 1281F  0xC4, 0x1E, 0x44, 0x01
  push ax                                      ; 12823  0x50
  mov ax, [es:bx + 0x10]                       ; 12824  0x26, 0x8B, 0x47, 0x10
  mov cx, 8                                    ; 12828  0xB9, 0x08, 0x00
  mul_cx                                       ; 1282B  mul cx
  mov cx, ax                                   ; 1282D  0x89, 0xC1
  pop ax                                       ; 1282F  0x58
  xor dx, dx                                   ; 12830  0x31, 0xD2
  div_cx                                       ; 12832  div cx
  mov [vout_q_start], dx                              ; 12834  0x89, 0x16, 0x4E, 0x01
  cmp dx, [vout_q_end]                              ; 12838  0x3B, 0x16, 0x50, 0x01
  jne loc_12841                                ; 1283C  0x75, 0x03
  call vout_reset_file                               ; 1283E  0xE8, 0xE5, 0xFE

loc_12841:                                     ; 12841
  mov al, [vout_ostate]                              ; 12841  0xA0, 0x48, 0x03
  pop bp                                       ; 12844  0x5D
  ret                                          ; 12845  0xC3

vout_read_voutq:                                     ; 12846
  push bp                                      ; 12846  0x55
  mov_bp_sp                                    ; 12847  mov bp, sp
  mov al, [vout_active]                              ; 12849  0xA0, 0x49, 0x03
  rcr al, 1                                    ; 1284C  0xD0, 0xD8
  jae loc_12852                                ; 1284E  0x73, 0x02
  pop bp                                       ; 12850  0x5D
  ret                                          ; 12851  0xC3

loc_12852:                                     ; 12852
  les bx, [vout_cur_ccb]                              ; 12852  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 0x14]                       ; 12856  0x26, 0x8B, 0x47, 0x14
  mov [vout_mxq_msg], ax                              ; 1285A  0xA3, 0x34, 0x02
  mov word [vout_ccb_state_ptr], 0x14c                      ; 1285D  0xC7, 0x06, 0x38, 0x02, 0x4C, 0x01
  mov al, 0x89                                 ; 12863  0xB0, 0x89
  push ax                                      ; 12865  0x50
  mov ax, 0x232                                ; 12866  0xB8, 0x32, 0x02
  push ax                                      ; 12869  0x50
  call vout_xdos                               ; 1286A  0xE8, 0x98, 0xFD
  cmp byte [vout_ccb_busy], 0                          ; 1286D  0x80, 0x3E, 0x4D, 0x01, 0x00
  jne loc_12879                                ; 12872  0x75, 0x05
  mov byte [vout_active], 0xff                       ; 12874  0xC6, 0x06, 0x49, 0x03, 0xFF

loc_12879:                                     ; 12879
  pop bp                                       ; 12879  0x5D
  ret                                          ; 1287A  0xC3

vout_drain_voutq:                                     ; 1287B
  push bp                                      ; 1287B  0x55
  mov_bp_sp                                    ; 1287C  mov bp, sp
  les bx, [vout_cur_ccb]                              ; 1287E  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 0x14]                       ; 12882  0x26, 0x8B, 0x47, 0x14
  mov [vout_mxq_msg], ax                              ; 12886  0xA3, 0x34, 0x02
  mov word [vout_ccb_state_ptr], 0x14c                      ; 12889  0xC7, 0x06, 0x38, 0x02, 0x4C, 0x01
  mov byte [vout_col], 0                          ; 1288F  0xC6, 0x06, 0x4A, 0x03, 0x00
  mov byte [vout_row], 0                          ; 12894  0xC6, 0x06, 0x4B, 0x03, 0x00

loc_12899:                                     ; 12899
  mov al, [vout_col]                              ; 12899  0xA0, 0x4A, 0x03
  not al                                       ; 1289C  0xF6, 0xD0
  mov cl, [vout_row]                              ; 1289E  0x8A, 0x0E, 0x4B, 0x03
  not cl                                       ; 128A2  0xF6, 0xD1
  and_al_cl                                    ; 128A4  and al, cl
  rcr al, 1                                    ; 128A6  0xD0, 0xD8
  jae loc_128CE                                ; 128A8  0x73, 0x24
  mov al, 0x8a                                 ; 128AA  0xB0, 0x8A
  push ax                                      ; 128AC  0x50
  mov ax, 0x232                                ; 128AD  0xB8, 0x32, 0x02
  push ax                                      ; 128B0  0x50
  call vout_xdos                               ; 128B1  0xE8, 0x51, 0xFD
  cmp al, 0                                    ; 128B4  0x3C, 0x00
  jne loc_128C7                                ; 128B6  0x75, 0x0F
  cmp byte [vout_ccb_busy], 0                          ; 128B8  0x80, 0x3E, 0x4D, 0x01, 0x00
  mov al, 0xff                                 ; 128BD  0xB0, 0xFF
  je loc_128C2                                 ; 128BF  0x74, 0x01
  inc ax                                       ; 128C1  0x40

loc_128C2:                                     ; 128C2
  mov [vout_col], al                              ; 128C2  0xA2, 0x4A, 0x03
  jmp short loc_12899                          ; 128C5  0xEB, 0xD2

loc_128C7:                                     ; 128C7
  mov byte [vout_row], 0xff                       ; 128C7  0xC6, 0x06, 0x4B, 0x03, 0xFF
  jmp short loc_12899                          ; 128CC  0xEB, 0xCB

loc_128CE:                                     ; 128CE
  mov al, [vout_ccb_state]                              ; 128CE  0xA0, 0x4C, 0x01
  mov bx, [bp + 4]                             ; 128D1  0x8B, 0x5E, 0x04
  mov [bx], al                                 ; 128D4  0x88, 0x07
  mov al, [vout_row]                              ; 128D6  0xA0, 0x4B, 0x03
  rcr al, 1                                    ; 128D9  0xD0, 0xD8
  jae loc_128E1                                ; 128DB  0x73, 0x04
  mov al, 0                                    ; 128DD  0xB0, 0x00
  jmp short loc_128E3                          ; 128DF  0xEB, 0x02

loc_128E1:                                     ; 128E1
  mov al, 0xff                                 ; 128E1  0xB0, 0xFF

loc_128E3:                                     ; 128E3
  pop bp                                       ; 128E3  0x5D
  ret 2                                        ; 128E4  0xC2, 0x02, 0x00

vout_put_char:                                     ; 128E7
  push bp                                      ; 128E7  0x55
  mov_bp_sp                                    ; 128E8  mov bp, sp
  mov byte [vout_active], 0                          ; 128EA: active = false
  cmp byte [vout_ccb_busy], 0                          ; 128EF  0x80, 0x3E, 0x4D, 0x01, 0x00
  jne loc_12916                                ; 128F4  0x75, 0x20
  mov byte [vout_ccb_busy], 0xff                       ; 128F6  0xC6, 0x06, 0x4D, 0x01, 0xFF
  mov ax, [vout_char_pend]                              ; 128FB  0xA1, 0x52, 0x01
  inc ax                                       ; 128FE  0x40
  mov [vout_char_pend], ax                              ; 128FF  0xA3, 0x52, 0x01
  mov cl, [vout_ccb_state]                              ; 12902  0x8A, 0x0E, 0x4C, 0x01
  mov bx, ax                                   ; 12906  0x89, 0xC3
  mov [bx + 0x248], cl                         ; 12908  0x88, 0x8F, 0x48, 0x02
  cmp ax, 0x7f                                 ; 1290C  0x83, 0xF8, 0x7F
  jne loc_12916                                ; 1290F  0x75, 0x05
  call vout_write_buf                               ; 12911  0xE8, 0x2E, 0xFE
  pop bp                                       ; 12914  0x5D
  ret                                          ; 12915  0xC3

loc_12916:                                     ; 12916
  mov al, 0xff                                 ; 12916  0xB0, 0xFF
  pop bp                                       ; 12918  0x5D
  ret                                          ; 12919  0xC3

vout_get_char:                                     ; 1291A
  push bp                                      ; 1291A  0x55
  mov_bp_sp                                    ; 1291B  mov bp, sp
  mov ax, [vout_attr_pend]                              ; 1291D  0xA1, 0x54, 0x01
  inc ax                                       ; 12920  0x40
  cmp ax, [vout_attr_limit]                              ; 12921  0x3B, 0x06, 0x56, 0x01
  jne loc_129A6                                ; 12925  0x75, 0x7F
  call vout_read_buf                               ; 12927  0xE8, 0x9F, 0xFE
  rcr al, 1                                    ; 1292A  0xD0, 0xD8
  jae loc_1293C                                ; 1292C  0x73, 0x0E
  mov word [vout_attr_limit], 0x80                       ; 1292E  0xC7, 0x06, 0x56, 0x01, 0x80, 0x00

loc_12934:                                     ; 12934
  mov word [vout_attr_pend], 0xffff                     ; 12934  0xC7, 0x06, 0x54, 0x01, 0xFF, 0xFF
  jmp short loc_129A6                          ; 1293A  0xEB, 0x6A

loc_1293C:                                     ; 1293C
  cmp word [vout_char_pend], -1                         ; 1293C  0x83, 0x3E, 0x52, 0x01, 0xFF
  je loc_12967                                 ; 12941  0x74, 0x24
  mov cx, [vout_char_pend]                              ; 12943  0x8B, 0x0E, 0x52, 0x01
  inc cx                                       ; 12947  0x41
  mov si, 0x248                                ; 12948  0xBE, 0x48, 0x02
  mov di, 0x2c8                                ; 1294B  0xBF, 0xC8, 0x02
  push ds                                      ; 1294E  0x1E
  pop es                                       ; 1294F  0x07
  cld                                          ; 12950  0xFC
  repne movsb                                  ; 12951  0xF2, 0xA4
  mov byte [vout_omode], 0                          ; 12953  0xC6, 0x06, 0x4C, 0x03, 0x00
  mov ax, [vout_char_pend]                              ; 12958  0xA1, 0x52, 0x01
  inc ax                                       ; 1295B  0x40
  mov [vout_attr_limit], ax                              ; 1295C  0xA3, 0x56, 0x01
  mov word [vout_char_pend], 0xffff                     ; 1295F  0xC7, 0x06, 0x52, 0x01, 0xFF, 0xFF
  jmp short loc_12934                          ; 12965  0xEB, 0xCD

loc_12967:                                     ; 12967
  mov al, [vout_active]                              ; 12967  0xA0, 0x49, 0x03
  rcr al, 1                                    ; 1296A  0xD0, 0xD8
  jae loc_12978                                ; 1296C  0x73, 0x0A
  mov byte [vout_active], 0                          ; 1296E  0xC6, 0x06, 0x49, 0x03, 0x00
  mov al, [vout_ccb_state]                              ; 12973  0xA0, 0x4C, 0x01
  jmp short loc_129B3                          ; 12976  0xEB, 0x3B

loc_12978:                                     ; 12978
  push word [bp + 4]                           ; 12978  0xFF, 0x76, 0x04
  call vout_drain_voutq                               ; 1297B  0xE8, 0xFD, 0xFE
  not al                                       ; 1297E  0xF6, 0xD0
  rcr al, 1                                    ; 12980  0xD0, 0xD8
  jae loc_129B8                                ; 12982  0x73, 0x34

loc_12984:                                     ; 12984
  les bx, [vout_cur_ccb]                              ; 12984  0xC4, 0x1E, 0x44, 0x01
  mov al, [es:bx + 4]                          ; 12988  0x26, 0x8A, 0x47, 0x04
  and al, 0x10                                 ; 1298C  0x24, 0x10
  cmp al, 0                                    ; 1298E  0x3C, 0x00
  je loc_1299E                                 ; 12990  0x74, 0x0C
  mov al, 0x8d                                 ; 12992  0xB0, 0x8D
  push ax                                      ; 12994  0x50
  mov ax, 2                                    ; 12995  0xB8, 0x02, 0x00
  push ax                                      ; 12998  0x50
  call vout_xdos                               ; 12999  0xE8, 0x69, 0xFC
  jmp short loc_12984                          ; 1299C  0xEB, 0xE6

loc_1299E:                                     ; 1299E
  push word [bp + 4]                           ; 1299E  0xFF, 0x76, 0x04
  call vout_drain_voutq                               ; 129A1  0xE8, 0xD7, 0xFE
  jmp short loc_129BA                          ; 129A4  0xEB, 0x14

loc_129A6:                                     ; 129A6
  mov ax, [vout_attr_pend]                              ; 129A6  0xA1, 0x54, 0x01
  inc ax                                       ; 129A9  0x40
  mov [vout_attr_pend], ax                              ; 129AA  0xA3, 0x54, 0x01
  mov bx, ax                                   ; 129AD  0x89, 0xC3
  mov al, [bx + 0x2c8]                         ; 129AF  0x8A, 0x87, 0xC8, 0x02

loc_129B3:                                     ; 129B3
  mov bx, [bp + 4]                             ; 129B3  0x8B, 0x5E, 0x04
  mov [bx], al                                 ; 129B6  0x88, 0x07

loc_129B8:                                     ; 129B8
  mov al, 0xff                                 ; 129B8  0xB0, 0xFF

loc_129BA:                                     ; 129BA
  pop bp                                       ; 129BA  0x5D
  ret 2                                        ; 129BB  0xC2, 0x02, 0x00

vout_full_disk:                                     ; 129BE
  push bp                                      ; 129BE  0x55
  mov_bp_sp                                    ; 129BF  mov bp, sp
  call vout_read_change_mxq                               ; 129C1  0xE8, 0xC8, 0xFC
  les bx, [vout_cur_ccb]                              ; 129C4  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 0xe]                        ; 129C8  0x26, 0x8B, 0x47, 0x0E
  and ax, strict word 4                        ; 129CC  25 04 00
  cmp ax, 0                                    ; 129CF  0x83, 0xF8, 0x00
  jne loc_129DA                                ; 129D2  0x75, 0x06
  or word [es:bx + 0xe], strict word 0x40     ; 129D4

loc_129DA:                                     ; 129DA
  call vout_write_change_mxq                               ; 129DA  0xE8, 0xC9, 0xFC
  pop bp                                       ; 129DD  0x5D
  ret                                          ; 129DE  0xC3

vout_buffer:                                     ; 129DF
  push bp                                      ; 129DF  0x55
  mov_bp_sp                                    ; 129E0  mov bp, sp
  mov al, [vout_omode]                              ; 129E2  0xA0, 0x4C, 0x03
  rcr al, 1                                    ; 129E5  0xD0, 0xD8
  jae loc_129EE                                ; 129E7  0x73, 0x05
  call vout_write_buf                               ; 129E9  0xE8, 0x56, 0xFD
  jmp short loc_12A04                          ; 129EC  0xEB, 0x16

loc_129EE:                                     ; 129EE
  les bx, [vout_cur_ccb]                              ; 129EE  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 0xe]                        ; 129F2  0x26, 0x8B, 0x47, 0x0E
  and ax, 0xfdff                               ; 129F6  0x25, 0xFF, 0xFD
  cmp ax, 3                                    ; 129F9  0x83, 0xF8, 0x03
  jne loc_12A12                                ; 129FC  0x75, 0x14
  call vout_read_voutq                               ; 129FE  0xE8, 0x45, 0xFE
  call vout_put_char                               ; 12A01  0xE8, 0xE3, 0xFE

loc_12A04:                                     ; 12A04
  not al                                       ; 12A04  0xF6, 0xD0
  mov [vout_omode], al                              ; 12A06  0xA2, 0x4C, 0x03
  rcr al, 1                                    ; 12A09  0xD0, 0xD8
  jae loc_129EE                                ; 12A0B  0x73, 0xE1
  call vout_full_disk                               ; 12A0D  0xE8, 0xAE, 0xFF
  pop bp                                       ; 12A10  0x5D
  ret                                          ; 12A11  0xC3

loc_12A12:                                     ; 12A12
  pop bp                                       ; 12A12  0x5D
  ret                                          ; 12A13  0xC3

vout_purge:                                     ; 12A14
  push bp                                      ; 12A14  0x55
  mov_bp_sp                                    ; 12A15  mov bp, sp
  mov byte [vout_line_attr2], 0xff                      ; 12A17  0xC6, 0x06, 0x50, 0x03, 0xFF

loc_12A1C:                                     ; 12A1C
  les bx, [vout_cur_ccb]                              ; 12A1C  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 0xe]                        ; 12A20  0x26, 0x8B, 0x47, 0x0E
  and ax, 0xa2                                 ; 12A24  0x25, 0xA2, 0x00
  cmp ax, 0                                    ; 12A27  0x83, 0xF8, 0x00
  mov al, 0xff                                 ; 12A2A  0xB0, 0xFF
  je loc_12A2F                                 ; 12A2C  0x74, 0x01
  inc ax                                       ; 12A2E  0x40

loc_12A2F:                                     ; 12A2F
  and al, [vout_line_attr2]                             ; 12A2F  0x22, 0x06, 0x50, 0x03
  rcr al, 1                                    ; 12A33  0xD0, 0xD8
  jb loc_12A3A                                 ; 12A35  0x72, 0x03
  jmp near loc_12B14                           ; 12A37  0xE9, 0xDA, 0x00

loc_12A3A:                                     ; 12A3A
  call vout_read_change_mxq                               ; 12A3A  0xE8, 0x4F, 0xFC
  les bx, [vout_cur_ccb]                              ; 12A3D  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 0xe]                        ; 12A41  0x26, 0x8B, 0x47, 0x0E
  push ax                                      ; 12A45  0x50
  and ax, 0x200                                ; 12A46  0x25, 0x00, 0x02
  cmp ax, 0                                    ; 12A49  0x83, 0xF8, 0x00
  mov al, 0xff                                 ; 12A4C  0xB0, 0xFF
  jne loc_12A51                                ; 12A4E  0x75, 0x01
  inc ax                                       ; 12A50  0x40

loc_12A51:                                     ; 12A51
  mov [vout_line_attr], al                              ; 12A51  0xA2, 0x4F, 0x03
  pop ax                                       ; 12A54  0x58
  and ax, 0xa2                                 ; 12A55  0x25, 0xA2, 0x00
  cmp ax, 0                                    ; 12A58  0x83, 0xF8, 0x00
  je loc_12A60                                 ; 12A5B  0x74, 0x03
  jmp near loc_12B0E                           ; 12A5D  0xE9, 0xAE, 0x00

loc_12A60:                                     ; 12A60
  cli                                          ; 12A60  0xFA

loc_12A61:                                     ; 12A61
  les bx, [vout_cur_ccb]                              ; 12A61  0xC4, 0x1E, 0x44, 0x01
  mov al, [es:bx + 4]                          ; 12A65  0x26, 0x8A, 0x47, 0x04
  and al, 8                                    ; 12A69  0x24, 0x08
  cmp al, 0                                    ; 12A6B  0x3C, 0x00
  je loc_12A78                                 ; 12A6D  0x74, 0x09
  lea ax, [bx + 0x22]                          ; 12A6F  0x8D, 0x47, 0x22
  push ax                                      ; 12A72  0x50
  call vout_sleep                               ; 12A73  0xE8, 0xEC, 0xFB
  jmp short loc_12A61                          ; 12A76  0xEB, 0xE9

loc_12A78:                                     ; 12A78
  les bx, [vout_cur_ccb]                              ; 12A78  0xC4, 0x1E, 0x44, 0x01
  or byte [es:bx + 4], 8                       ; 12A7C  0x26, 0x80, 0x4F, 0x04, 0x08
  sti                                          ; 12A81  0xFB
  mov byte [vout_line_cnt], 0                          ; 12A82  0xC6, 0x06, 0x4E, 0x03, 0x00

loc_12A87:                                     ; 12A87
  cmp byte [vout_line_cnt], 0x28                       ; 12A87  0x80, 0x3E, 0x4E, 0x03, 0x28
  mov al, 0xff                                 ; 12A8C  0xB0, 0xFF
  jb loc_12A91                                 ; 12A8E  0x72, 0x01
  inc ax                                       ; 12A90  0x40

loc_12A91:                                     ; 12A91
  and al, [vout_line_attr2]                             ; 12A91  0x22, 0x06, 0x50, 0x03
  rcr al, 1                                    ; 12A95  0xD0, 0xD8
  jae loc_12AF5                                ; 12A97  0x73, 0x5C
  mov ax, 0x34d                                ; 12A99  0xB8, 0x4D, 0x03
  push ax                                      ; 12A9C  0x50
  call vout_get_char                               ; 12A9D  0xE8, 0x7A, 0xFE
  mov [vout_line_attr2], al                             ; 12AA0  0xA2, 0x50, 0x03
  les bx, [vout_cur_ccb]                              ; 12AA3  0xC4, 0x1E, 0x44, 0x01
  mov cx, [es:bx + 0xe]                        ; 12AA7  0x26, 0x8B, 0x4F, 0x0E
  and cx, 0x100                                ; 12AAB  0x81, 0xE1, 0x00, 0x01
  push ax                                      ; 12AAF  0x50
  cmp cx, 0                                    ; 12AB0  0x83, 0xF9, 0x00
  mov al, 0xff                                 ; 12AB3  0xB0, 0xFF
  je loc_12AB8                                 ; 12AB5  0x74, 0x01
  inc ax                                       ; 12AB7  0x40

loc_12AB8:                                     ; 12AB8
  pop cx                                       ; 12AB8  0x59
  and_al_cl                                    ; 12AB9  and al, cl
  rcr al, 1                                    ; 12ABB  0xD0, 0xD8
  jae loc_12AEF                                ; 12ABD  0x73, 0x30
  mov al, 2                                    ; 12ABF  0xB0, 0x02
  push ax                                      ; 12AC1  0x50
  mov al, [vout_saved_char]                              ; 12AC2  0xA0, 0x4D, 0x03
  mov ah, 0                                    ; 12AC5  0xB4, 0x00
  push ax                                      ; 12AC7  0x50
  mov al, [4]                                  ; 12AC8  0xA0, 0x04, 0x00
  mov ah, 0                                    ; 12ACB  0xB4, 0x00
  push ax                                      ; 12ACD  0x50
  call vout_pxios1                               ; 12ACE  0xE8, 0x6F, 0xFB
  mov al, [vout_line_attr]                              ; 12AD1  0xA0, 0x4F, 0x03
  rcr al, 1                                    ; 12AD4  0xD0, 0xD8
  jae loc_12AEF                                ; 12AD6  0x73, 0x17
  mov al, 4                                    ; 12AD8  0xB0, 0x04
  push ax                                      ; 12ADA  0x50
  mov al, [vout_saved_char]                              ; 12ADB  0xA0, 0x4D, 0x03
  mov ah, 0                                    ; 12ADE  0xB4, 0x00
  push ax                                      ; 12AE0  0x50
  les bx, [vout_cur_ccb]                              ; 12AE1  0xC4, 0x1E, 0x44, 0x01
  mov al, [es:bx + 8]                          ; 12AE5  0x26, 0x8A, 0x47, 0x08
  mov ah, 0                                    ; 12AE9  0xB4, 0x00
  push ax                                      ; 12AEB  0x50
  call vout_pxios1                               ; 12AEC  0xE8, 0x51, 0xFB

loc_12AEF:                                     ; 12AEF
  inc byte [vout_line_cnt]                             ; 12AEF  0xFE, 0x06, 0x4E, 0x03
  jmp short loc_12A87                          ; 12AF3  0xEB, 0x92

loc_12AF5:                                     ; 12AF5
  les bx, [vout_cur_ccb]                              ; 12AF5  0xC4, 0x1E, 0x44, 0x01
  and byte [es:bx + 4], 0xf7                   ; 12AF9  0x26, 0x80, 0x67, 0x04, 0xF7
  call vout_write_change_mxq                               ; 12AFE  0xE8, 0xA5, 0xFB
  les bx, [vout_cur_ccb]                              ; 12B01  0xC4, 0x1E, 0x44, 0x01
  lea ax, [bx + 0x22]                          ; 12B05  0x8D, 0x47, 0x22
  push ax                                      ; 12B08  0x50
  call vout_wakeup                               ; 12B09  0xE8, 0x6B, 0xFB
  jmp short loc_12B11                          ; 12B0C  0xEB, 0x03

loc_12B0E:                                     ; 12B0E
  call vout_write_change_mxq                               ; 12B0E  0xE8, 0x95, 0xFB

loc_12B11:                                     ; 12B11
  jmp near loc_12A1C                           ; 12B11  0xE9, 0x08, 0xFF

loc_12B14:                                     ; 12B14
  mov al, [vout_line_attr2]                             ; 12B14  0xA0, 0x50, 0x03
  not al                                       ; 12B17  0xF6, 0xD0
  rcr al, 1                                    ; 12B19  0xD0, 0xD8
  jae loc_12B5C                                ; 12B1B  0x73, 0x3F
  mov word [vout_attr_limit], 0                          ; 12B1D  0xC7, 0x06, 0x56, 0x01, 0x00, 0x00
  mov word [vout_attr_pend], 0xffff                     ; 12B23  0xC7, 0x06, 0x54, 0x01, 0xFF, 0xFF
  mov word [vout_char_pend], 0xffff                     ; 12B29  0xC7, 0x06, 0x52, 0x01, 0xFF, 0xFF
  call vout_read_change_mxq                               ; 12B2F  0xE8, 0x5A, 0xFB
  les bx, [vout_cur_ccb]                              ; 12B32  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 0xe]                        ; 12B36  0x26, 0x8B, 0x47, 0x0E
  and ax, strict word 4                        ; 12B3A  25 04 00
  cmp ax, 0                                    ; 12B3D  0x83, 0xF8, 0x00
  je loc_12B59                                 ; 12B40  0x74, 0x17
  and word [es:bx + 0xe], strict word 0xfffb  ; 12B42
  mov al, 8                                    ; 12B48  0xB0, 0x08
  push ax                                      ; 12B4A  0x50
  mov ax, 0                                    ; 12B4B  0xB8, 0x00, 0x00
  push ax                                      ; 12B4E  0x50
  mov al, [es:bx + 0xa]                        ; 12B4F  0x26, 0x8A, 0x47, 0x0A
  mov ah, 0                                    ; 12B53  0xB4, 0x00
  push ax                                      ; 12B55  0x50
  call vout_pxios1                               ; 12B56  0xE8, 0xE7, 0xFA

loc_12B59:                                     ; 12B59
  call vout_write_change_mxq                               ; 12B59  0xE8, 0x4A, 0xFB

loc_12B5C:                                     ; 12B5C
  les bx, [vout_cur_ccb]                              ; 12B5C  0xC4, 0x1E, 0x44, 0x01
  lea ax, [bx + 0x24]                          ; 12B60  0x8D, 0x47, 0x24
  push ax                                      ; 12B63  0x50
  call vout_wakeup                               ; 12B64  0xE8, 0x10, 0xFB
  pop bp                                       ; 12B67  0x5D
  ret                                          ; 12B68  0xC3

vout_abort:                                     ; 12B69
  push bp                                      ; 12B69  0x55
  mov_bp_sp                                    ; 12B6A  mov bp, sp

loc_12B6C:                                     ; 12B6C
  mov ax, 0x158                                ; 12B6C  0xB8, 0x58, 0x01
  push ax                                      ; 12B6F  0x50
  call vout_drain_voutq                               ; 12B70  0xE8, 0x08, 0xFD
  rcr al, 1                                    ; 12B73  0xD0, 0xD8
  jb loc_12B6C                                 ; 12B75  0x72, 0xF5
  call vout_read_change_mxq                               ; 12B77  0xE8, 0x12, 0xFB
  les bx, [vout_cur_ccb]                              ; 12B7A  0xC4, 0x1E, 0x44, 0x01
  and word [es:bx + 0xe], strict word 0xffdf  ; 12B7E
  call vout_write_change_mxq                               ; 12B84  0xE8, 0x1F, 0xFB
  call vout_reset_file                               ; 12B87  0xE8, 0x9C, 0xFB
  mov byte [vout_omode], 0                          ; 12B8A  0xC6, 0x06, 0x4C, 0x03, 0x00
  mov word [vout_attr_pend], 0xffff                     ; 12B8F  0xC7, 0x06, 0x54, 0x01, 0xFF, 0xFF
  mov word [vout_char_pend], 0xffff                     ; 12B95  0xC7, 0x06, 0x52, 0x01, 0xFF, 0xFF
  mov word [vout_attr_limit], 0                          ; 12B9B  0xC7, 0x06, 0x56, 0x01, 0x00, 0x00
  les bx, [vout_cur_ccb]                              ; 12BA1  0xC4, 0x1E, 0x44, 0x01
  lea ax, [bx + 0x24]                          ; 12BA5  0x8D, 0x47, 0x24
  push ax                                      ; 12BA8  0x50
  call vout_wakeup                               ; 12BA9  0xE8, 0xCB, 0xFA
  pop bp                                       ; 12BAC  0x5D
  ret                                          ; 12BAD  0xC3

vout_initq:                                     ; 12BAE
  push bp                                      ; 12BAE  0x55
  mov_bp_sp                                    ; 12BAF  mov bp, sp
  mov si, [bp + 4]                             ; 12BB1  0x8B, 0x76, 0x04
  lea si, [si + 6]                             ; 12BB4  0x8D, 0x74, 0x06
  mov cx, 8                                    ; 12BB7  0xB9, 0x08, 0x00
  mov di, 0x23a                                ; 12BBA  0xBF, 0x3A, 0x02
  push ds                                      ; 12BBD  0x1E
  pop es                                       ; 12BBE  0x07
  cld                                          ; 12BBF  0xFC
  repne movsb                                  ; 12BC0  0xF2, 0xA4
  mov al, 0x86                                 ; 12BC2  0xB0, 0x86
  push ax                                      ; 12BC4  0x50
  push word [bp + 4]                           ; 12BC5  0xFF, 0x76, 0x04
  call vout_xdos                               ; 12BC8  0xE8, 0x3A, 0xFA
  mov [vout_line_flags], al                              ; 12BCB  0xA2, 0x51, 0x03
  mov al, 0x87                                 ; 12BCE  0xB0, 0x87
  push ax                                      ; 12BD0  0x50
  mov ax, 0x232                                ; 12BD1  0xB8, 0x32, 0x02
  push ax                                      ; 12BD4  0x50
  call vout_xdos                               ; 12BD5  0xE8, 0x2D, 0xFA
  or [vout_line_flags], al                               ; 12BD8  0x08, 0x06, 0x51, 0x03
  mov ax, [vout_mxq_msg]                              ; 12BDC  0xA1, 0x34, 0x02
  pop bp                                       ; 12BDF  0x5D
  ret 2                                        ; 12BE0  0xC2, 0x02, 0x00

; -----------------------------------------------------------------------------
; vout_plmstart — Main initialization and event loop for VOUT RSP
; Entry point at offset 0x0603 from code segment start (0x125E0 + 0x0603 = 0x12BE3).
; Loops forever checking CCB state:
;   - delete_flag -> vout_delete_file
;   - buffered background -> vout_buffer
;   - purging -> vout_purge
;   - abort -> vout_abort
; -----------------------------------------------------------------------------
vout_plmstart:                                 ; 12BE3
  push bp                                      ; 12BE3  0x55
  mov_bp_sp                                    ; 12BE4  mov bp, sp
  mov al, 0x2d                                 ; 12BE6  0xB0, 0x2D
  push ax                                      ; 12BE8  0x50
  mov ax, 0xff                                 ; 12BE9  0xB8, 0xFF, 0x00
  push ax                                      ; 12BEC  0x50
  call vout_xdos                               ; 12BED  0xE8, 0x15, 0xFA
  mov ax, [0]                                  ; 12BF0  0xA1, 0x00, 0x00
  mov [vout_ccb_seg], ax                              ; 12BF3  0xA3, 0x46, 0x01
  mov [vout_sysdat_seg], ax                              ; 12BF6  0xA3, 0x42, 0x01
  mov word [vout_sysdat_ptr], 0                          ; 12BF9  0xC7, 0x06, 0x40, 0x01, 0x00, 0x00
  mov al, [4]                                  ; 12BFF  0xA0, 0x04, 0x00
  mov ah, 0                                    ; 12C02  0xB4, 0x00
  mov cx, 0x2c                                 ; 12C04  0xB9, 0x2C, 0x00
  mul_cx                                       ; 12C07  mul cx
  les bx, [vout_sysdat_ptr]                              ; 12C09  0xC4, 0x1E, 0x40, 0x01
  add ax, [es:bx + 0x54]                       ; 12C0D  0x26, 0x03, 0x47, 0x54
  mov [vout_cur_ccb], ax                              ; 12C11  0xA3, 0x44, 0x01
  mov al, 0x9c                                 ; 12C14  0xB0, 0x9C
  push ax                                      ; 12C16  0x50
  mov ax, 0                                    ; 12C17  0xB8, 0x00, 0x00
  push ax                                      ; 12C1A  0x50
  call vout_xdos                               ; 12C1B  0xE8, 0xE7, 0xF9
  mov [vout_ccb_ptr2], bx                              ; 12C1E  0x89, 0x1E, 0x5A, 0x01
  mov [vout_ccb_seg2], es                              ; 12C22  0x8C, 0x06, 0x5C, 0x01
  les si, [vout_ccb_ptr2]                              ; 12C26  0xC4, 0x36, 0x5A, 0x01
  lea si, [si + 8]                             ; 12C2A  0x8D, 0x74, 0x08
  lea di, [vout_prompt_str]                              ; 12C2D  0x8D, 0x3E, 0x73, 0x03
  mov cx, 8                                    ; 12C31  0xB9, 0x08, 0x00
  push ds                                      ; 12C34  0x1E
  push es                                      ; 12C35  0x06
  push ds                                      ; 12C36  0x1E
  pop es                                       ; 12C37  0x07
  pop ds                                       ; 12C38  0x1F
  cld                                          ; 12C39  0xFC
  repne movsb                                  ; 12C3A  0xF2, 0xA4
  pop ds                                       ; 12C3C  0x1F
  mov cx, 4                                    ; 12C3D  0xB9, 0x04, 0x00
  mov si, 0x377                                ; 12C40  0xBE, 0x77, 0x03
  mov di, 0x204                                ; 12C43  0xBF, 0x04, 0x02
  push ds                                      ; 12C46  0x1E
  pop es                                       ; 12C47  0x07
  cld                                          ; 12C48  0xFC
  repne movsb                                  ; 12C49  0xF2, 0xA4
  mov ax, 0x1fa                                ; 12C4B  0xB8, 0xFA, 0x01
  push ax                                      ; 12C4E  0x50
  call vout_initq                               ; 12C4F  0xE8, 0x5C, 0xFF
  les bx, [vout_cur_ccb]                              ; 12C52  0xC4, 0x1E, 0x44, 0x01
  mov [es:bx + 0x12], ax                       ; 12C56  0x26, 0x89, 0x47, 0x12
  mov cx, 3                                    ; 12C5A  0xB9, 0x03, 0x00
  mov si, 0x377                                ; 12C5D  0xBE, 0x77, 0x03
  mov di, 0x169                                ; 12C60  0xBF, 0x69, 0x01
  push ds                                      ; 12C63  0x1E
  pop es                                       ; 12C64  0x07
  cld                                          ; 12C65  0xFC
  repne movsb                                  ; 12C66  0xF2, 0xA4
  mov ax, 0x15e                                ; 12C68  0xB8, 0x5E, 0x01
  push ax                                      ; 12C6B  0x50
  call vout_initq                               ; 12C6C  0xE8, 0x3F, 0xFF
  les bx, [vout_cur_ccb]                              ; 12C6F  0xC4, 0x1E, 0x44, 0x01
  mov [es:bx + 0x14], ax                       ; 12C73  0x26, 0x89, 0x47, 0x14
  mov cx, 3                                    ; 12C77  0xB9, 0x03, 0x00
  mov si, 0x377                                ; 12C7A  0xBE, 0x77, 0x03
  mov di, 0x221                                ; 12C7D  0xBF, 0x21, 0x02
  push ds                                      ; 12C80  0x1E
  pop es                                       ; 12C81  0x07
  cld                                          ; 12C82  0xFC
  repne movsb                                  ; 12C83  0xF2, 0xA4
  mov ax, 0x216                                ; 12C85  0xB8, 0x16, 0x02
  push ax                                      ; 12C88  0x50
  call vout_initq                               ; 12C89  0xE8, 0x22, 0xFF
  les bx, [vout_cur_ccb]                              ; 12C8C  0xC4, 0x1E, 0x44, 0x01
  mov [es:bx + 0x16], ax                       ; 12C90  0x26, 0x89, 0x47, 0x16
  mov al, 0x94                                 ; 12C94  0xB0, 0x94
  push ax                                      ; 12C96  0x50
  mov al, [4]                                  ; 12C97  0xA0, 0x04, 0x00
  mov ah, 0                                    ; 12C9A  0xB4, 0x00
  push ax                                      ; 12C9C  0x50
  call vout_xdos                               ; 12C9D  0xE8, 0x65, 0xF9
  les bx, [vout_sysdat_ptr]                              ; 12CA0  0xC4, 0x1E, 0x40, 0x01
  mov al, [es:bx + 0x50]                       ; 12CA4  0x26, 0x8A, 0x47, 0x50
  inc al                                       ; 12CA8  0xFE, 0xC0
  mov [vout_buf_last], al                              ; 12CAA  0xA2, 0x72, 0x03
  call vout_write_change_mxq                               ; 12CAD  0xE8, 0xF6, 0xF9
  mov al, 0x91                                 ; 12CB0  0xB0, 0x91
  push ax                                      ; 12CB2  0x50
  mov ax, 0xc8                                 ; 12CB3  0xB8, 0xC8, 0x00
  push ax                                      ; 12CB6  0x50
  call vout_xdos                               ; 12CB7  0xE8, 0x4B, 0xF9

loc_12CBA:                                     ; 12CBA
  mov al, [vout_vcmxq_flag1]                              ; 12CBA  0xA0, 0x45, 0x02
  rcr al, 1                                    ; 12CBD  0xD0, 0xD8
  jae loc_12CC4                                ; 12CBF  0x73, 0x03
  call vout_delete_file                               ; 12CC1  0xE8, 0xFC, 0xF9

loc_12CC4:                                     ; 12CC4
  les bx, [vout_cur_ccb]                              ; 12CC4  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 0xe]                        ; 12CC8  0x26, 0x8B, 0x47, 0x0E
  and ax, 0xfcff                               ; 12CCC  0x25, 0xFF, 0xFC
  cmp ax, 3                                    ; 12CCF  0x83, 0xF8, 0x03
  jne loc_12CD9                                ; 12CD2  0x75, 0x05
  call vout_buffer                               ; 12CD4  0xE8, 0x08, 0xFD
  jmp short loc_12D04                          ; 12CD7  0xEB, 0x2B

loc_12CD9:                                     ; 12CD9
  les bx, [vout_cur_ccb]                              ; 12CD9  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 0xe]                        ; 12CDD  0x26, 0x8B, 0x47, 0x0E
  and ax, 0xfcff                               ; 12CE1  0x25, 0xFF, 0xFC
  and ax, strict word 4                        ; 12CE4  25 04 00
  cmp ax, 0                                    ; 12CE7  0x83, 0xF8, 0x00
  je loc_12CF1                                 ; 12CEA  0x74, 0x05
  call vout_purge                               ; 12CEC  0xE8, 0x25, 0xFD
  jmp short loc_12D04                          ; 12CEF  0xEB, 0x13

loc_12CF1:                                     ; 12CF1
  les bx, [vout_cur_ccb]                              ; 12CF1  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 0xe]                        ; 12CF5  0x26, 0x8B, 0x47, 0x0E
  and ax, strict word 0x20                     ; 12CF9  25 20 00
  cmp ax, 0                                    ; 12CFC  0x83, 0xF8, 0x00
  je loc_12D04                                 ; 12CFF  0x74, 0x03
  call vout_abort                               ; 12D01  0xE8, 0x65, 0xFE

loc_12D04:                                     ; 12D04
  mov al, [vout_vcmxq_flag1]                              ; 12D04  0xA0, 0x45, 0x02
  rcr al, 1                                    ; 12D07  0xD0, 0xD8
  jae loc_12D10                                ; 12D09  0x73, 0x05
  call vout_delete_file                               ; 12D0B  0xE8, 0xB2, 0xF9
  jmp short loc_12CBA                          ; 12D0E  0xEB, 0xAA

loc_12D10:                                     ; 12D10
  call vout_read_voutq                               ; 12D10  0xE8, 0x33, 0xFB
  jmp short loc_12CBA                          ; 12D13  0xEB, 0xA5
  pop bp                                       ; 12D15  0x5D
  ret                                          ; 12D16  0xC3
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 12D17  .........

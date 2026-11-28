; ===========================================================================
; Regnecentralen RC759 Piccoline — NETDRV / NETDRVB Code Segment
; RC-Net Datalink Driver for Intel 82586 Ethernet LAN Controller
; Fælles master-kildetekst for Revision A og Revision B
; ===========================================================================

cpu 186

%include "rasm86.inc"

%ifndef NETDRV_REV
  %define NETDRV_REV 'A'
%endif

%if NETDRV_REV == 'B'
  MAX_CONNS        equ 0x64
  CONN_TABLE_PAD   equ 7714
  CONN_TABLE_SIZE  equ 0x1D4C
  TRAILING_PAD     equ 2
  SHIFT            equ 0x13EC
%else
  MAX_CONNS        equ 0x20
  CONN_TABLE_PAD   equ 2614
  CONN_TABLE_SIZE  equ 0x0960
  TRAILING_PAD     equ 14
  SHIFT            equ 0
%endif

; ---------------------------------------------------------------------------
; Symbolske adresser forskudt med SHIFT for Revision B
; ---------------------------------------------------------------------------
sap_conn_state_base            equ (0x1EA5 + SHIFT)
timer_tick_counter_1eac        equ (0x1EAC + SHIFT)
conn_flag_1f0c                 equ (0x1F0C + SHIFT)
conn_flag_1f0d                 equ (0x1F0D + SHIFT)
timer_tick_counter_1f14        equ (0x1F14 + SHIFT)
conn_flag_1f74                 equ (0x1F74 + SHIFT)
lan_multicast_table            equ (0x1F75 + SHIFT)
lan_multicast_addr2            equ (0x1F7B + SHIFT)
lan_multicast_addr3            equ (0x1F81 + SHIFT)
i82586_scb                     equ (0x1F88 + SHIFT)
scb_status                     equ (0x1F8A + SHIFT)
scb_command                    equ (0x1F8C + SHIFT)
scb_cbl_offset                 equ (0x1F8E + SHIFT)
scb_rfa_offset                 equ (0x1F90 + SHIFT)
scb_crc_errs                   equ (0x1F98 + SHIFT)
scb_aln_errs                   equ (0x1F9A + SHIFT)
scb_rsc_errs                   equ (0x1F9E + SHIFT)
scb_ovrn_errs                  equ (0x1FA0 + SHIFT)
cb_status                      equ (0x1FA6 + SHIFT)
cb_command                     equ (0x1FA8 + SHIFT)
tbd_buffer_addr                equ (0x1FB0 + SHIFT)
lan_hw_config_bytes            equ (0x2468 + SHIFT)
lan_init_hardware              equ (0x24A4 + SHIFT)
calc_20bit_phys_addr           equ (0x26E3 + SHIFT)
setup_xios_call_vector         equ (0x2700 + SHIFT)
lan_init_ir5_isr               equ (0x2732 + SHIFT)
init_isr_ir5                   equ (0x2738 + SHIFT)
lan_ia_cmd                     equ (0x2798 + SHIFT)
lan_cfg_cmd                    equ (0x279E + SHIFT)
lan_mc_cmd                     equ (0x27A4 + SHIFT)
lan_rbd_pool                   equ (0x27C2 + SHIFT)
timer_short_active             equ (0x3DF4 + SHIFT)
timer_short_queue_head         equ (0x3DF5 + SHIFT)
timer_enqueue_short            equ (0x3DF7 + SHIFT)
timer_dequeue_short            equ (0x3E46 + SHIFT)
timer_check_short_expired      equ (0x3EA4 + SHIFT)
timer_long_hdr                 equ (0x3ED6 + SHIFT)
timer_long_queue_head          equ (0x3ED7 + SHIFT)
timer_enqueue_long             equ (0x3ED9 + SHIFT)
timer_dequeue_long             equ (0x3F2A + SHIFT)
timer_check_long_expired       equ (0x3F86 + SHIFT)
timer_tick_flag                equ (0x3FB8 + SHIFT)
timer_tick_routine             equ (0x3FB9 + SHIFT)
lan_isr_ir5                    equ (0x403A + SHIFT)
isr_ack_int29                  equ (0x419B + SHIFT)
saved_stacks                   equ (0x4239 + SHIFT)
saved_bdos_vector              equ (0x423B + SHIFT)
saved_bdos_segment             equ (0x423D + SHIFT)
saved_ir5_vector               equ (0x423F + SHIFT)
saved_ir5_segment              equ (0x4241 + SHIFT)
saved_ds                       equ (0x4243 + SHIFT)
saved_ss                       equ (0x4245 + SHIFT)
saved_sp                       equ (0x4247 + SHIFT)
lan_private_stack_top          equ (0x42C9 + SHIFT)
pending_event_flags            equ (0x42CB + SHIFT)
pending_rec_flag               equ (0x42CC + SHIFT)
sap_lookup_by_local_num        equ (0x42CD + SHIFT)
sap_lookup_connection          equ (0x42E7 + SHIFT)
sap_increment_tx_seq           equ (0x4311 + SHIFT)
sap_deliver_confirm_success    equ (0x435D + SHIFT)
sap_deliver_indication_event   equ (0x4377 + SHIFT)
sap_build_disconnect_ind       equ (0x43A3 + SHIFT)
sap_build_connect_ind          equ (0x43B7 + SHIFT)
sap_init_indication_header     equ (0x43D8 + SHIFT)
lan_reset_flag                 equ (0x440C + SHIFT)
lan_controller_reset           equ (0x440D + SHIFT)
channel_attention_delay        equ (0x441C + SHIFT)
get_remote_conn_index          equ (0x4430 + SHIFT)
bdos_wait_flag_16              equ (0x443E + SHIFT)
bdos_set_flag_dx               equ (0x4452 + SHIFT)

; RSP Header (16 bytes)
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

; Process Descriptor 1
pd_netdrv:
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x03, 0x00
%if NETDRV_REV == 'B'
  db 0x4E, 0x45, 0x54, 0x44, 0x52, 0x56, 0x42, 0x20 ; 'NETDRVB '
%else
  db 0x4E, 0x45, 0x54, 0x44, 0x52, 0x56, 0x20, 0x20 ; 'NETDRV  '
%endif
  db 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

; Padding (16 bytes)
  times 16 db 0

; UDA NETDRV scratch (52 bytes)
  times 52 db 0

; NETDRV u_sp (2 bytes)
  db 0x5E, 0x01

; UDA NETDRV scratch (202 bytes)
  times 202 db 0

; NETDRV Stack Guard (30 bytes)
  times 30 db 0xCC

; NETDRV Initial Stack Registers (SP=0x015E, IP=0x0726) (32 bytes)
  db 0x26, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

; NETDRV Stack Area (242 bytes)
  times 242 db 0

; PD REC (Process Descriptor, priority 2) (32 bytes)
  db 0xD0, 0x04, 0x00, 0x00, 0x00, 0x02, 0x03, 0x00, 0x52, 0x45, 0x43, 0x20, 0x20, 0x20, 0x20, 0x20
  db 0x2A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

; Padding (16 bytes)
  times 16 db 0

; UDA REC scratch (52 bytes)
  times 52 db 0

; REC u_sp (2 bytes)
  db 0xBE, 0x03

; UDA REC scratch (202 bytes)
  times 202 db 0

; REC Stack Guard (30 bytes)
  times 30 db 0xCC

; REC Initial Stack Registers (SP=0x03BE, IP=0x0E15) (32 bytes)
  db 0x15, 0x0E, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

; REC Stack Area (242 bytes)
  times 242 db 0

; PD XMIT (Process Descriptor, priority 3) (32 bytes)
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x03, 0x00, 0x58, 0x4D, 0x49, 0x54, 0x20, 0x20, 0x20, 0x20
  db 0x50, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

; Padding (16 bytes)
  times 16 db 0

; UDA XMIT scratch (52 bytes)
  times 52 db 0

; XMIT u_sp (2 bytes)
  db 0x1E, 0x06

; UDA XMIT scratch (202 bytes)
  times 202 db 0

; XMIT Stack Guard (30 bytes)
  times 30 db 0xCC

; XMIT Initial Stack Registers (SP=0x061E, IP=0x0BF8) (32 bytes)
  db 0xF8, 0x0B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

; XMIT Stack Area (232 bytes)
  times 232 db 0

; ---------------------------------------------------------------------------
; NETDRV Main Entry & Dispatch Loop
; ---------------------------------------------------------------------------
netdrv_entry:
  cli                                      ; 0726
  mov sp, 0x264                            ; 0727
  mov ax, cs                               ; 072A
  mov ss, ax                               ; 072C
  sti                                      ; 072E
  mov word [cs:saved_ds], ds               ; 072F
  call near lan_init_hardware              ; 0734
  mov dx, 0xbbe                            ; 0737
  mov cl, 0x87                             ; 073A
  int 0xe0                                 ; 073C
  mov dx, 0xbae                            ; 073E
  mov cl, 0x87                             ; 0741
  int 0xe0                                 ; 0743
loc_0745:
  mov cl, 0x89                             ; 0745
  mov dx, 0xbae                            ; 0747
  int 0xe0                                 ; 074A
  mov bl, byte [cs:0xbd6]                  ; 074C
  cmp bl, 9                                ; 0751
  ja short loc_0745                        ; 0754
  xor_bh_bh                                    ; xor bh, bh               ; 0756
  shl bx, 1                                ; 0758
  add bx, 0x762                            ; 075A
  call word [bx]                           ; 075E
  jmp short loc_0745                       ; 0760

; netdrv_req_table
netdrv_req_table:
  dw netdrv_req_activate            ; 0x0776
  dw netdrv_req_deactivate          ; 0x0823
  dw netdrv_req_udata               ; 0x08D4
  dw netdrv_req_udata_ack           ; 0x0941
  dw netdrv_req_test                ; 0x096B
  dw netdrv_req_data                ; 0x09CD
  dw netdrv_req_disconnect_ack      ; 0x0AB8
  dw netdrv_req_07                  ; 0x0B22
  dw netdrv_req_08                  ; 0x0B35
  dw netdrv_req_09                  ; 0x0B66

; ---------------------------------------------------------------------------
; NETDRV Request Handlers (Part 1)
; ---------------------------------------------------------------------------
netdrv_req_activate:
  mov bx, 0xbd7                            ; 0776
  mov al, byte [bx]                        ; 0779
  cmp al, 0                                ; 077B
  je short loc_0783                        ; 077D
  cmp al, 0x3f                             ; 077F
  jle short loc_0788                       ; 0781
loc_0783:
  mov al, 8                                ; 0783
  jmp near loc_0810                        ; 0785
loc_0788:
  mov cl, 2                                ; 0788
  shl byte [bx], cl                        ; 078A
  xor_al_al                                    ; xor al, al               ; 078C
  call near sap_lookup_by_local_num        ; 078E
  jae short loc_0798                       ; 0791
  mov al, 7                                ; 0793
  jmp near loc_0810                        ; 0795
loc_0798:
  push si                                  ; 0798
  mov al, byte [bx]                        ; 0799
  call near sap_lookup_by_local_num        ; 079B
  pop di                                   ; 079E
  jb short loc_07A6                        ; 079F
  mov al, 6                                ; 07A1
  jmp near loc_0810                        ; 07A3
loc_07A6:
  cmp word [bx + 6], 0x2e                  ; 07A6
  jle short loc_07B1                       ; 07AA
  mov al, 9                                ; 07AC
  jmp near loc_0810                        ; 07AE
loc_07B1:
  mov_si_bx                                    ; mov si, bx               ; 07B1
  mov es, word [cs:saved_ds]               ; 07B3
  mov cx, 3                                ; 07B8
  push di                                  ; 07BB
  pushf                                    ; 07BC
  cli                                      ; 07BD
  rep movsw                                ; 07BE
  popf                                     ; 07C0
  pop di                                   ; 07C1
  cmp byte [bx + 1], 0                     ; 07C2
  je short loc_07CD                        ; 07C6
  mov al, 0                                ; 07C8
  jmp near loc_0810                        ; 07CA
loc_07CD:
  push ds                                  ; 07CD
  lds si, [bx + 8]                         ; 07CE
  mov al, byte [es:bx]                     ; 07D1
  mov byte [si], al                        ; 07D4
  mov byte [si + 1], al                    ; 07D6
  mov byte [si + 2], 3                     ; 07D9
  mov byte [si + 3], 0                     ; 07DD
  mov cx, word [es:bx + 6]                 ; 07E1
  mov word [es:di + 9], cx                 ; 07E5
  push di                                  ; 07E9
  add di, 0xb                              ; 07EA
  push si                                  ; 07ED
  push cx                                  ; 07EE
  rep movsb                                ; 07EF
  pop cx                                   ; 07F1
  pop si                                   ; 07F2
  mov byte [si + 3], 1                     ; 07F3
  pop di                                   ; 07F7
  push di                                  ; 07F8
  add di, 0x39                             ; 07F9
  rep movsb                                ; 07FC
  pop si                                   ; 07FE
  pop ds                                   ; 07FF
  mov dx, 0xbbe                            ; 0800
  mov di, 0xbe5                            ; 0803
  call near sap_increment_tx_seq           ; 0806
  mov word [si + 7], 0x14                  ; 0809
  mov al, 0                                ; 080E
loc_0810:
  les di, [bx + 8]                         ; 0810
  mov byte [es:di + 1], 0                  ; 0813
  mov byte [es:di + 2], al                 ; 0818
  mov ax, word [bx + 4]                    ; 081C
  call near q_write_temp_confirm           ; 081F
  ret                                      ; 0822
netdrv_req_deactivate:
  mov bx, 0xbd7                            ; 0823
  les si, [bx + 1]                         ; 0826
  mov byte [es:si + 1], 1                  ; 0829
  mov byte [es:si + 2], 0                  ; 082E
  push si                                  ; 0833
  push es                                  ; 0834
  mov cl, 2                                ; 0835
  shl byte [bx], cl                        ; 0837
  mov al, byte [bx]                        ; 0839
  call near sap_lookup_by_local_num        ; 083B
  jb short loc_084E                        ; 083E
  mov ax, word [si + 4]                    ; 0840
  push ax                                  ; 0843
  call near sap_deactivate_cleanup         ; 0844
  pop ax                                   ; 0847
  pop es                                   ; 0848
  pop di                                   ; 0849
  call near q_write_temp_confirm           ; 084A
  ret                                      ; 084D
loc_084E:
  pop es                                   ; 084E
  pop si                                   ; 084F
  ret                                      ; 0850
sap_deactivate_cleanup:
  pushf                                    ; 0851
  cli                                      ; 0852
  cmp byte [si + 0x67], 0xff               ; 0853
  jne short loc_0865                       ; 0857
  popf                                     ; 0859
  push si                                  ; 085A
  mov cl, 0x8d                             ; 085B
  mov dx, 1                                ; 085D
  int 0xe0                                 ; 0860
  pop si                                   ; 0862
  jmp short sap_deactivate_cleanup         ; 0863
loc_0865:
  mov dl, byte [si + 1]                    ; 0865
  mov_di_si                                    ; mov di, si               ; 0868
  mov es, word [cs:saved_ds]               ; 086A
  mov cx, 0x68                             ; 086F
  xor_al_al                                    ; xor al, al               ; 0872
  rep stosb                                ; 0874
  cmp dl, 1                                ; 0876
  je short loc_08A2                        ; 0879
  mov cx, MAX_CONNS                        ; 087B
  mov di, 0x1545                           ; 087E
loc_0881:
  push di                                  ; 0881
  push si                                  ; 0882
  cmp word [di + 7], si                    ; 0883
  jne short loc_0890                       ; 0886
  add di, 7                                ; 0888
  call near sap_confirm_write              ; 088B
  jmp short loc_089B                       ; 088E
loc_0890:
  cmp word [di + 0x29], si                 ; 0890
  jne short loc_089B                       ; 0893
  add di, 0x29                             ; 0895
  call near sap_confirm_write              ; 0898
loc_089B:
  pop si                                   ; 089B
  pop di                                   ; 089C
  add di, 0x4b                             ; 089D
  loop loc_0881                            ; 08A0
loc_08A2:
  popf                                     ; 08A2
  ret                                      ; 08A3
sap_confirm_write:
  push cx                                  ; 08A4
  push ax                                  ; 08A5
  cmp word [di + 0xe], 0                   ; 08A6
  jne short loc_08B2                       ; 08AA
  cmp word [di + 0xc], 0                   ; 08AC
  je short loc_08B9                        ; 08B0
loc_08B2:
  push di                                  ; 08B2
  mov_si_di                                    ; mov si, di               ; 08B3
  call near timer_dequeue_short            ; 08B5
  pop di                                   ; 08B8
loc_08B9:
  cmp word [di + 9], 0                     ; 08B9
  jne short loc_08C5                       ; 08BD
  cmp word [di + 7], 0                     ; 08BF
  je short loc_08CC                        ; 08C3
loc_08C5:
  push di                                  ; 08C5
  mov_si_di                                    ; mov si, di               ; 08C6
  call near timer_dequeue_long             ; 08C8
  pop di                                   ; 08CB
loc_08CC:
  pop ax                                   ; 08CC
  mov cx, 0x22                             ; 08CD
  rep stosb                                ; 08D0
  pop cx                                   ; 08D2
  ret                                      ; 08D3
netdrv_req_udata:
  mov bx, 0xbd7                            ; 08D4
  mov cl, 2                                ; 08D7
  shl byte [bx + 1], cl                    ; 08D9
  shl byte [bx], cl                        ; 08DC
  mov al, byte [bx + 1]                    ; 08DE
  call near sap_lookup_by_local_num        ; 08E1
  jb short loc_0922                        ; 08E4
  cmp byte [si + 1], 1                     ; 08E6
  jne short loc_0927                       ; 08EA
  cmp word [bx + 8], 0x434                 ; 08EC
  ja short loc_0923                        ; 08F1
  les di, [bx + 0xa]                       ; 08F3
  mov byte [es:di + 1], al                 ; 08F6
  mov al, byte [bx]                        ; 08FA
  mov byte [es:di], al                     ; 08FC
  mov byte [es:di + 2], 3                  ; 08FF
  mov es, word [cs:saved_ds]               ; 0904
  mov di, 0xbe5                            ; 0909
  mov al, 1                                ; 090C
  stosb                                    ; 090E
  push si                                  ; 090F
  mov_si_bx                                    ; mov si, bx               ; 0910
  add si, 2                                ; 0912
  mov cx, 6                                ; 0915
  rep movsw                                ; 0918
  pop si                                   ; 091A
  mov ax, word [si + 4]                    ; 091B
  stosw                                    ; 091E
  call near q_write_xmit_req               ; 091F
loc_0922:
  ret                                      ; 0922
loc_0923:
  mov al, 9                                ; 0923
  jmp short loc_0929                       ; 0925
loc_0927:
  mov al, 5                                ; 0927
loc_0929:
  les di, [bx + 0xa]                       ; 0929
  mov ah, byte [bx]                        ; 092C
  mov byte [es:di], ah                     ; 092E
  mov byte [es:di + 1], 2                  ; 0931
  mov byte [es:di + 2], al                 ; 0936
  mov ax, word [si + 4]                    ; 093A
  call near q_write_temp_confirm           ; 093D
  ret                                      ; 0940
netdrv_req_udata_ack:
  mov bx, 0xbd7                            ; 0941
  mov cl, 2                                ; 0944
  shl byte [bx + 7], cl                    ; 0946
  shl byte [bx + 6], cl                    ; 0949
  mov al, byte [bx + 7]                    ; 094C
  jb short loc_096A                        ; 094F
  les di, [bx + 0xa]                       ; 0951
  mov al, byte [bx + 6]                    ; 0954
  mov byte [es:di], al                     ; 0957
  mov byte [es:di + 1], 3                  ; 095A
  mov byte [es:di + 2], 0xff               ; 095F
  mov ax, word [si + 4]                    ; 0964
  call near q_write_temp_confirm           ; 0967
loc_096A:
  ret                                      ; 096A
netdrv_req_test:
  mov bx, 0xbd7                            ; 096B
  mov cl, 2                                ; 096E
  shl byte [bx + 1], cl                    ; 0970
  shl byte [bx], cl                        ; 0973
  mov al, byte [bx + 1]                    ; 0975
  call near sap_lookup_by_local_num        ; 0978
  jb short loc_09B3                        ; 097B
  cmp word [bx + 8], 0x434                 ; 097D
  ja short loc_09B4                        ; 0982
  les di, [bx + 0xa]                       ; 0984
  mov byte [es:di + 1], al                 ; 0987
  mov al, byte [bx]                        ; 098B
  mov byte [es:di], al                     ; 098D
  mov byte [es:di + 2], 0xf3               ; 0990
  mov es, word [cs:saved_ds]               ; 0995
  mov di, 0xbe5                            ; 099A
  mov al, 1                                ; 099D
  stosb                                    ; 099F
  push si                                  ; 09A0
  mov_si_bx                                    ; mov si, bx               ; 09A1
  add si, 2                                ; 09A3
  mov cx, 6                                ; 09A6
  rep movsw                                ; 09A9
  pop si                                   ; 09AB
  mov ax, word [si + 4]                    ; 09AC
  stosw                                    ; 09AF
  call near q_write_xmit_req               ; 09B0
loc_09B3:
  ret                                      ; 09B3
loc_09B4:
  les di, [bx + 0xa]                       ; 09B4
  mov ah, byte [bx]                        ; 09B7
  mov byte [es:di], ah                     ; 09B9
  mov byte [es:di + 1], 4                  ; 09BC
  mov byte [es:di + 2], 9                  ; 09C1
  mov ax, word [si + 4]                    ; 09C6
  call near q_write_temp_confirm           ; 09C9
  ret                                      ; 09CC
netdrv_req_data:
  mov bx, 0xbd7                            ; 09CD
  mov cl, 2                                ; 09D0
  shl byte [bx + 2], cl                    ; 09D2
  shl byte [bx + 1], cl                    ; 09D5
  mov al, byte [bx + 2]                    ; 09D8
  call near sap_lookup_by_local_num        ; 09DB
  jae short loc_09E3                       ; 09DE
  jmp near loc_0A62                        ; 09E0
loc_09E3:
  cmp byte [si + 1], 0                     ; 09E3
  je short loc_09EE                        ; 09E7
  mov al, 4                                ; 09E9
  jmp near loc_0A63                        ; 09EB
loc_09EE:
  cmp word [bx + 3], 0x434                 ; 09EE
  jbe short loc_09FA                       ; 09F3
  mov al, 9                                ; 09F5
  jmp near loc_0A63                        ; 09F7
loc_09FA:
  mov al, byte [bx]                        ; 09FA
  call near sap_lookup_connection          ; 09FC
  jae short loc_0A06                       ; 09FF
  mov al, 1                                ; 0A01
  jmp near loc_0A63                        ; 0A03
loc_0A06:
  push bx                                  ; 0A06
  xor_bh_bh                                    ; xor bh, bh               ; 0A07
  mov bl, byte [si + 2]                    ; 0A09
  jmp word [cs:bx + 0xa11]                 ; 0A0C

; sap_state_table_0a11
sap_state_table_0a11:
  dw 0x0A24                         ; 0x0A24
  dw 0x0A2B                         ; 0x0A2B
  dw 0x0A41                         ; 0x0A41
  dw 0x0A1D                         ; 0x0A1D
  dw 0x0A24                         ; 0x0A24
  dw 0x0A1D                         ; 0x0A1D

; ---------------------------------------------------------------------------
; NETDRV Request Handlers (Part 2)
; ---------------------------------------------------------------------------
  pop bx                                   ; 0A1D
  mov si, word [si]                        ; 0A1E
  mov al, 2                                ; 0A20
  jmp short loc_0A63                       ; 0A22
  pop bx                                   ; 0A24
  mov si, word [si]                        ; 0A25
  mov al, 1                                ; 0A27
  jmp short loc_0A63                       ; 0A29
  pop bx                                   ; 0A2B
  call near sap_conn_abort                 ; 0A2C
  mov word [si + 0x1d], di                 ; 0A2F
  mov word [si + 0x1f], es                 ; 0A32
  mov ax, word [bx + 3]                    ; 0A35
  mov word [si + 0x1b], ax                 ; 0A38
  mov byte [si + 2], 0xa                   ; 0A3B
  jmp short loc_0A62                       ; 0A3F
  pop bx                                   ; 0A41
  call near sap_conn_abort                 ; 0A42
  mov word [si + 0x15], di                 ; 0A45
  mov word [si + 0x17], es                 ; 0A48
  mov ax, word [bx + 3]                    ; 0A4B
  mov word [si + 0x13], ax                 ; 0A4E
  mov byte [si + 0x10], 5                  ; 0A51
  mov byte [si + 2], 6                     ; 0A55
  mov dx, 0xbbe                            ; 0A59
  mov di, 0xbe5                            ; 0A5C
  call near sap_deliver_confirm_success    ; 0A5F
loc_0A62:
  ret                                      ; 0A62
loc_0A63:
  les di, [bx + 5]                         ; 0A63
  mov cl, 2                                ; 0A66
  shr byte [es:di], cl                     ; 0A68
  mov byte [es:di + 2], al                 ; 0A6B
  mov byte [es:di + 1], 5                  ; 0A6F
  mov al, byte [bx + 1]                    ; 0A74
  mov byte [es:di], al                     ; 0A77
  mov ax, word [si + 4]                    ; 0A7A
  call near q_write_temp_confirm           ; 0A7D
  ret                                      ; 0A80
sap_conn_abort:
  les di, [bx + 5]                         ; 0A81
  mov al, byte [bx + 1]                    ; 0A84
  mov byte [es:di], al                     ; 0A87
  mov al, byte [bx + 2]                    ; 0A8A
  mov byte [es:di + 1], al                 ; 0A8D
  mov byte [es:di + 2], 3                  ; 0A91
  mov byte [es:di + 3], 3                  ; 0A96
  mov al, byte [si + 0x11]                 ; 0A9B
  mov byte [es:di + 4], al                 ; 0A9E
  mov al, byte [si + 4]                    ; 0AA2
  mov byte [es:di + 5], al                 ; 0AA5
  cmp byte [si + 0x11], 0                  ; 0AA9
  je short loc_0AB4                        ; 0AAD
  dec byte [si + 0x11]                     ; 0AAF
  jmp short loc_0AB7                       ; 0AB2
loc_0AB4:
  inc byte [si + 0x11]                     ; 0AB4
loc_0AB7:
  ret                                      ; 0AB7
netdrv_req_disconnect_ack:
  mov bx, 0xbd7                            ; 0AB8
  mov cl, 2                                ; 0ABB
  shl byte [bx + 2], cl                    ; 0ABD
  shl byte [bx + 1], cl                    ; 0AC0
  mov al, byte [bx + 2]                    ; 0AC3
  call near sap_lookup_by_local_num        ; 0AC6
  jb short loc_0B21                        ; 0AC9
  push si                                  ; 0ACB
  push ax                                  ; 0ACC
  mov al, byte [bx]                        ; 0ACD
  call near sap_lookup_connection          ; 0ACF
  jb short loc_0B07                        ; 0AD2
  pushf                                    ; 0AD4
  cli                                      ; 0AD5
  cmp byte [si + 2], 8                     ; 0AD6
  jne short loc_0B06                       ; 0ADA
  mov_di_si                                    ; mov di, si               ; 0ADC
  mov es, word [cs:saved_ds]               ; 0ADE
  mov cx, 0x22                             ; 0AE3
  xor_al_al                                    ; xor al, al               ; 0AE6
  rep stosb                                ; 0AE8
  popf                                     ; 0AEA
  les di, [bx + 5]                         ; 0AEB
  mov byte [es:di + 1], 6                  ; 0AEE
  mov byte [es:di + 2], 0                  ; 0AF3
  pop ax                                   ; 0AF8
  pop si                                   ; 0AF9
  cmp al, 8                                ; 0AFA
  je short loc_0B21                        ; 0AFC
  mov ax, word [si + 4]                    ; 0AFE
  call near q_write_temp_confirm           ; 0B01
  jmp short loc_0B21                       ; 0B04
loc_0B06:
  popf                                     ; 0B06
loc_0B07:
  pop ax                                   ; 0B07
  pop si                                   ; 0B08
  mov ax, word [si + 4]                    ; 0B09
  push ax                                  ; 0B0C
  call near sap_deactivate_cleanup         ; 0B0D
  les di, [bx + 5]                         ; 0B10
  mov byte [es:di + 1], 6                  ; 0B13
  mov byte [es:di + 2], 0xa                ; 0B18
  pop ax                                   ; 0B1D
  call near q_write_temp_confirm           ; 0B1E
loc_0B21:
  ret                                      ; 0B21
netdrv_req_07:
  mov di, 0xbbe                            ; 0B22
  mov word [di + 6], 0xbd6                 ; 0B25
  push di                                  ; 0B2A
  call near q_write_xmit_req               ; 0B2B
  pop di                                   ; 0B2E
  mov word [di + 6], 0xbe5                 ; 0B2F
  ret                                      ; 0B34
netdrv_req_08:
  mov bx, 0xbd7                            ; 0B35
  mov cx, MAX_CONNS                        ; 0B38
  xor_al_al                                    ; xor al, al               ; 0B3B
  les di, [bx]                             ; 0B3D
  mov si, 0x1545                           ; 0B3F
  inc di                                   ; 0B42
loc_0B43:
  cmp byte [si], 0                         ; 0B43
  je short loc_0B55                        ; 0B46
  inc si                                   ; 0B48
  push cx                                  ; 0B49
  mov cx, 3                                ; 0B4A
  rep movsw                                ; 0B4D
  sub si, 7                                ; 0B4F
  pop cx                                   ; 0B52
  inc al                                   ; 0B53
loc_0B55:
  add si, 0x4b                             ; 0B55
  loop loc_0B43                            ; 0B58
  les di, [bx]                             ; 0B5A
  mov byte [es:di], al                     ; 0B5C
  mov ax, word [bx + 4]                    ; 0B5F
  call near q_write_temp_confirm           ; 0B62
  ret                                      ; 0B65
netdrv_req_09:
  mov bx, 0xbd7                            ; 0B66
  les di, [bx]                             ; 0B69
  mov si, scb_rfa_offset                   ; 0B6B
  mov cx, 4                                ; 0B6E
  rep movsw                                ; 0B71
  mov ax, word [cs:0x1541]                 ; 0B73
  stosw                                    ; 0B77
  mov ax, word [cs:0xe12]                  ; 0B78
  stosw                                    ; 0B7C
  mov ax, word [cs:0x1543]                 ; 0B7D
  stosw                                    ; 0B81
  mov ax, word [cs:0x153f]                 ; 0B82
  stosw                                    ; 0B86
  les di, [bx]                             ; 0B87
  mov ax, word [bx + 4]                    ; 0B89
  call near q_write_temp_confirm           ; 0B8C
  ret                                      ; 0B8F
q_write_xmit_req:
  mov dx, 0xbbe                            ; 0B90
  mov cl, 0x8b                             ; 0B93
  int 0xe0                                 ; 0B95
  ret                                      ; 0B97
q_write_temp_confirm:
  mov word [cs:0xbd0], ax                  ; 0B98
  mov word [cs:0xbf4], di                  ; 0B9C
  mov word [cs:0xbf6], es                  ; 0BA1
  mov dx, 0xbce                            ; 0BA6
  mov cl, 0x8b                             ; 0BA9
  int 0xe0                                 ; 0BAB
  ret                                      ; 0BAD

; Queue Parameter Blocks (74 bytes)
qpb_link_req:
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xD6, 0x0B, 0x6C, 0x69, 0x6E, 0x6B, 0x5F, 0x72, 0x65, 0x71
qpb_xmit_req:
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xE5, 0x0B, 0x58, 0x4D, 0x49, 0x54, 0x5F, 0x52, 0x45, 0x51
qpb_temp_confirm:
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF4, 0x0B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

; ---------------------------------------------------------------------------
; XMIT Main Entry & Dispatch Loop
; ---------------------------------------------------------------------------
xmit_entry:
  cli                                      ; 0BF8
  mov ax, cs                               ; 0BF9
  mov ss, ax                               ; 0BFB
  mov sp, 0x724                            ; 0BFD
  sti                                      ; 0C00
  mov cl, 0x87                             ; 0C01
  mov dx, 0xde7                            ; 0C03
  int 0xe0                                 ; 0C06
loc_0C08:
  mov cl, 0x89                             ; 0C08
  mov dx, 0xde7                            ; 0C0A
  int 0xe0                                 ; 0C0D
  mov al, byte [cs:0xe03]                  ; 0C0F
  cmp al, 7                                ; 0C13
  jg short loc_0C08                        ; 0C15
  xor_ah_ah                                    ; xor ah, ah               ; 0C17
  mov_si_ax                                    ; mov si, ax               ; 0C19
  shl si, 1                                ; 0C1B
  mov bx, 0xe04                            ; 0C1D
  jmp word [cs:si + 0xc25]                 ; 0C20

; xmit_req_table
xmit_req_table:
  dw xmit_req_00                    ; 0x0C35
  dw xmit_req_01                    ; 0x0C98
  dw xmit_req_02                    ; 0x0CC7
  dw xmit_req_03                    ; 0x0CDD
  dw xmit_req_04                    ; 0x0C62
  dw xmit_req_05                    ; 0x0CEF
  dw loc_0C08                       ; 0x0C08
  dw xmit_req_07                    ; 0x0CF5

; ---------------------------------------------------------------------------
; XMIT Transmit Handlers
; ---------------------------------------------------------------------------
xmit_req_00:
  pushf                                    ; 0C35
  cli                                      ; 0C36
  mov si, word [bx]                        ; 0C37
  cmp byte [si + 0x21], 1                  ; 0C39
  jne short loc_0C5E                       ; 0C3D
  mov al, byte [bx + 2]                    ; 0C3F
  cmp al, byte [si + 0x11]                 ; 0C42
  jne short loc_0C5E                       ; 0C45
  mov byte [si + 0x21], 2                  ; 0C47
  popf                                     ; 0C4B
  push si                                  ; 0C4C
  call near xmit_prepare_frame             ; 0C4D
  call near xmit_start_tx_dma              ; 0C50
  pop si                                   ; 0C53
  call near timer_enqueue_short            ; 0C54
  mov byte [si + 0x21], 1                  ; 0C57
  jmp near loc_0C08                        ; 0C5B
loc_0C5E:
  popf                                     ; 0C5E
  jmp near loc_0C08                        ; 0C5F
xmit_req_04:
  pushf                                    ; 0C62
  cli                                      ; 0C63
  mov si, word [bx]                        ; 0C64
  cmp byte [si + 0x21], 1                  ; 0C66
  jne short loc_0C5E                       ; 0C6A
  cmp byte [si + 2], 2                     ; 0C6C
  je short loc_0C78                        ; 0C70
  cmp byte [si + 2], 0xa                   ; 0C72
  jne short loc_0C5E                       ; 0C76
loc_0C78:
  mov byte [si + 0x21], 2                  ; 0C78
  popf                                     ; 0C7C
  push si                                  ; 0C7D
  call near xmit_prepare_frame             ; 0C7E
  mov si, tbd_buffer_addr                  ; 0C81
  mov al, byte [bx + 2]                    ; 0C84
  mov byte [si + 4], al                    ; 0C87
  call near xmit_start_tx_dma              ; 0C8A
  pop si                                   ; 0C8D
  call near timer_enqueue_short            ; 0C8E
  mov byte [si + 0x21], 1                  ; 0C91
  jmp near loc_0C08                        ; 0C95
xmit_req_01:
  push bx                                  ; 0C98
  call near xmit_dequeue_and_free          ; 0C99
  pop bx                                   ; 0C9C
  les si, [bx + 8]                         ; 0C9D
  mov cl, 2                                ; 0CA0
  shr byte [es:si], cl                     ; 0CA2
  mov al, byte [es:si + 2]                 ; 0CA5
  mov byte [es:si + 2], 0                  ; 0CA9
  cmp al, 3                                ; 0CAE
  jne short loc_0CB9                       ; 0CB0
  mov byte [es:si + 1], 2                  ; 0CB2
  jmp short loc_0CBE                       ; 0CB7
loc_0CB9:
  mov byte [es:si + 1], 4                  ; 0CB9
loc_0CBE:
  mov ax, word [bx + 0xc]                  ; 0CBE
  call near xmit_queue_write_internal      ; 0CC1
  jmp near loc_0C08                        ; 0CC4
xmit_req_02:
  mov_si_bx                                    ; mov si, bx               ; 0CC7
  call near xmit_copy_mac_header           ; 0CC9
  mov di, tbd_buffer_addr                  ; 0CCC
  mov cx, 3                                ; 0CCF
  rep movsw                                ; 0CD2
  mov cx, 6                                ; 0CD4
  call near xmit_start_tx_dma              ; 0CD7
  jmp near loc_0C08                        ; 0CDA
xmit_req_03:
  push bx                                  ; 0CDD
  call near xmit_dequeue_and_free          ; 0CDE
  pop bx                                   ; 0CE1
  mov ax, word [bx + 0xc]                  ; 0CE2
  push ds                                  ; 0CE5
  push ax                                  ; 0CE6
  int 0x29                                 ; 0CE7
  add sp, 4                                ; 0CE9
  jmp near loc_0C08                        ; 0CEC
xmit_req_05:
  call near xmit_dequeue_and_free          ; 0CEF
  jmp near loc_0C08                        ; 0CF2
xmit_req_07:
  push bx                                  ; 0CF5
  mov word [cs:scb_aln_errs], 0x8005       ; 0CF6
  mov ax, 0x100                            ; 0CFD
  call near channel_attention_delay        ; 0D00
  mov ax, ds                               ; 0D03
  add ax, strict word 0x0050               ; 0D05
  mov es, ax                               ; 0D08
  mov dx, 0x16                             ; 0D0A
  call near bdos_wait_flag_16              ; 0D0D
  pop bx                                   ; 0D10
  les si, [bx]                             ; 0D11
  mov byte [es:si], 7                      ; 0D13
  mov ax, word [cs:scb_rsc_errs]           ; 0D17
  mov word [es:si + 1], ax                 ; 0D1B
  mov ax, word [bx + 4]                    ; 0D1F
  call near xmit_queue_write_internal      ; 0D22
  mov word [cs:scb_rsc_errs], cb_command   ; 0D25
  mov word [cs:scb_crc_errs], 0            ; 0D2C
  jmp near loc_0C08                        ; 0D33
xmit_prepare_frame:
  push si                                  ; 0D36
  mov si, word [si + 0x19]                 ; 0D37
  inc si                                   ; 0D3A
  call near xmit_copy_mac_header           ; 0D3B
  pop si                                   ; 0D3E
  push di                                  ; 0D3F
  push ds                                  ; 0D40
  mov cx, word [si + 0x13]                 ; 0D41
  push cx                                  ; 0D44
  lds si, [si + 0x15]                      ; 0D45
  mov di, tbd_buffer_addr                  ; 0D48
  rep movsb                                ; 0D4B
  pop cx                                   ; 0D4D
  pop ds                                   ; 0D4E
  pop di                                   ; 0D4F
  ret                                      ; 0D50
xmit_dequeue_and_free:
  mov_si_bx                                    ; mov si, bx               ; 0D51
  call near xmit_copy_mac_header           ; 0D53
  mov di, tbd_buffer_addr                  ; 0D56
  push di                                  ; 0D59
  push ds                                  ; 0D5A
  mov cx, word [bx + 6]                    ; 0D5B
  lds si, [bx + 8]                         ; 0D5E
  rep movsb                                ; 0D61
  pop ds                                   ; 0D63
  pop di                                   ; 0D64
  mov cx, word [bx + 6]                    ; 0D65
  call near xmit_start_tx_dma              ; 0D68
  ret                                      ; 0D6B
xmit_copy_mac_header:
  mov es, word [cs:saved_ds]               ; 0D6C
  mov di, scb_ovrn_errs                    ; 0D71
  mov cx, 3                                ; 0D74
  rep movsw                                ; 0D77
  ret                                      ; 0D79
xmit_start_tx_dma:
  xchg_ch_cl                                   ; xchg ch, cl              ; 0D7A
  mov word [cs:cb_status], cx              ; 0D7C
  xchg_ch_cl                                   ; xchg ch, cl              ; 0D81
  cmp cx, 0x2e                             ; 0D83
  jae short loc_0D8B                       ; 0D86
  mov cx, 0x2e                             ; 0D88
loc_0D8B:
  or cx, 0x8000                            ; 0D8B
  mov word [cs:cb_command], cx             ; 0D8F
  mov word [cs:scb_aln_errs], 0x8004       ; 0D94
  mov byte [cs:0xe14], 2                   ; 0D9B
loc_0DA1:
  mov ax, 0x100                            ; 0DA1
  call near channel_attention_delay        ; 0DA4
  mov ax, ds                               ; 0DA7
  add ax, strict word 0x0050               ; 0DA9
  mov es, ax                               ; 0DAC
  mov dx, 0x16                             ; 0DAE
  call near bdos_wait_flag_16              ; 0DB1
  inc word [cs:0xe12]                      ; 0DB4
  mov ax, word [cs:scb_crc_errs]           ; 0DB9
  mov word [cs:scb_crc_errs], 0            ; 0DBD
  test ax, 0xa000                          ; 0DC4
  jne short loc_0DD0                       ; 0DC7
  dec byte [cs:0xe14]                      ; 0DC9
  jne short loc_0DA1                       ; 0DCE
loc_0DD0:
  ret                                      ; 0DD0
xmit_queue_write_internal:
  mov word [cs:0xdf9], ax                  ; 0DD1
  mov word [cs:0xdff], si                  ; 0DD5
  mov word [cs:0xe01], es                  ; 0DDA
  mov dx, 0xdf7                            ; 0DDF
  mov cl, 0x8b                             ; 0DE2
  int 0xe0                                 ; 0DE4
  ret                                      ; 0DE6

; XMIT Internal Queue & Scratch State (46 bytes)
qpb_xmit_internal:
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x0E, 0x58, 0x4D, 0x49, 0x54, 0x5F, 0x52, 0x45, 0x51
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0x0D, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

; ---------------------------------------------------------------------------
; REC Main Entry & Dispatch Loop
; ---------------------------------------------------------------------------
rec_entry:
  cli                                      ; 0E15
  mov ax, cs                               ; 0E16
  mov ss, ax                               ; 0E18
  mov sp, 0x4c4                            ; 0E1A
  sti                                      ; 0E1D
  mov dx, 0x1503                           ; 0E1E
  mov cl, 0x87                             ; 0E21
  int 0xe0                                 ; 0E23
loc_0E25:
  pushf                                    ; 0E25
  cli                                      ; 0E26
  mov byte [cs:timer_tick_flag], 0xff      ; 0E27
  mov byte [cs:conn_flag_1f0c], 0          ; 0E2D
  mov byte [cs:conn_flag_1f74], 0          ; 0E33
  popf                                     ; 0E39
  mov ax, ds                               ; 0E3A
  add ax, strict word 0x002A               ; 0E3C
  mov es, ax                               ; 0E3F
  mov dx, 0x17                             ; 0E41
  call near bdos_wait_flag_16              ; 0E44
  pushf                                    ; 0E47
  cli                                      ; 0E48
  mov byte [cs:timer_tick_flag], 0         ; 0E49
  mov byte [cs:conn_flag_1f0c], 0xff       ; 0E4F
  mov byte [cs:conn_flag_1f74], 0xff       ; 0E55
  cmp byte [cs:pending_rec_flag], 0xff     ; 0E5B
  je short loc_0E67                        ; 0E61
  popf                                     ; 0E63
  jmp near loc_0F03                        ; 0E64
loc_0E67:
  mov byte [cs:pending_rec_flag], 0        ; 0E67
  xor_cx_cx ; xor cx, cx               ; 0E6D
  xchg word [cs:0x152e], cx                ; 0E6F
  mov bx, 0                                ; 0E74
  xchg word [cs:0x1530], bx                ; 0E77
  mov word [cs:0x1532], 0                  ; 0E7C
  popf                                     ; 0E83
  add word [cs:0x1541], cx                 ; 0E84
  or_cx_cx                                     ; or cx, cx                ; 0E89
  je short loc_0E90                        ; 0E8B
  call near rec_handle_ack_nak             ; 0E8D
loc_0E90:
  cmp byte [cs:0x1534], 0                  ; 0E90
  je short loc_0F03                        ; 0E96
loc_0E98:
  pushf                                    ; 0E98
  cli                                      ; 0E99
  cmp byte [cs:0x1535], 0                  ; 0E9A
  je short loc_0EAA                        ; 0EA0
  cmp byte [cs:0x153a], 0                  ; 0EA2
  jne short loc_0EBC                       ; 0EA8
loc_0EAA:
  cmp byte [cs:pending_rec_flag], 0xff     ; 0EAA
  je short loc_0E67                        ; 0EB0
  popf                                     ; 0EB2
  mov cl, 0x8d                             ; 0EB3
  mov dx, 1                                ; 0EB5
  int 0xe0                                 ; 0EB8
  jmp short loc_0E98                       ; 0EBA
loc_0EBC:
  mov si, word [cs:0x1536]                 ; 0EBC
  mov di, word [cs:0x153b]                 ; 0EC1
  mov word [si + 6], di                    ; 0EC6
  mov word [cs:scb_cbl_offset], si         ; 0EC9
  mov byte [cs:0x1535], 0                  ; 0ECE
  mov word [cs:0x1536], 0                  ; 0ED4
  mov word [cs:0x1538], 0                  ; 0EDB
  mov byte [cs:0x153a], 0                  ; 0EE2
  mov word [cs:0x153b], 0                  ; 0EE8
  mov word [cs:0x153d], 0                  ; 0EEF
  mov byte [cs:0x1534], 0                  ; 0EF6
  popf                                     ; 0EFC
  mov ax, 0x10                             ; 0EFD
  call near channel_attention_delay        ; 0F00
loc_0F03:
  xor_al_al                                    ; xor al, al               ; 0F03
  xchg byte [cs:pending_event_flags], al   ; 0F05
  cmp al, 0                                ; 0F0A
  jne short loc_0F11                       ; 0F0C
  jmp near loc_0E25                        ; 0F0E
loc_0F11:
  test al, 1                               ; 0F11
  je short loc_0F1A                        ; 0F13
  push ax                                  ; 0F15
  call near rec_check_sap_active           ; 0F16
  pop ax                                   ; 0F19
loc_0F1A:
  test al, 2                               ; 0F1A
  je short loc_0F23                        ; 0F1C
  push ax                                  ; 0F1E
  call near rec_validate_connection        ; 0F1F
  pop ax                                   ; 0F22
loc_0F23:
  test al, 4                               ; 0F23
  je short loc_0F2F                        ; 0F25
  push ax                                  ; 0F27
  mov si, sap_conn_state_base              ; 0F28
  call near rec_update_seq_num             ; 0F2B
  pop ax                                   ; 0F2E
loc_0F2F:
  test al, 8                               ; 0F2F
  je short loc_0F39                        ; 0F31
  mov si, conn_flag_1f0d                   ; 0F33
  call near rec_update_seq_num             ; 0F36
loc_0F39:
  jmp near loc_0E25                        ; 0F39
rec_check_sap_active:
  call near timer_check_short_expired      ; 0F3C
  or_cx_cx                                     ; or cx, cx                ; 0F3F
  jne short loc_0F44                       ; 0F41
  ret                                      ; 0F43
loc_0F44:
  push cx                                  ; 0F44
  mov di, word [si + 0xc]                  ; 0F45
  push di                                  ; 0F48
  cmp byte [si + 2], 2                     ; 0F49
  je short loc_0F8F                        ; 0F4D
  cmp byte [si + 2], 0xa                   ; 0F4F
  je short loc_0F8F                        ; 0F53
  dec byte [si + 0x10]                     ; 0F55
  je short loc_0F6A                        ; 0F58
  mov di, 0x151f                           ; 0F5A
  mov dx, 0x1503                           ; 0F5D
  inc word [cs:0x1543]                     ; 0F60
  call near sap_deliver_confirm_success    ; 0F65
  jmp short loc_0FA4                       ; 0F68
loc_0F6A:
  les di, [si + 0x15]                      ; 0F6A
  mov cl, 2                                ; 0F6D
  shr byte [es:di], cl                     ; 0F6F
  mov byte [es:di + 1], 5                  ; 0F72
  mov byte [es:di + 2], 1                  ; 0F77
  push si                                  ; 0F7C
  mov si, word [si]                        ; 0F7D
  call near rec_queue_write_client         ; 0F7F
  pop si                                   ; 0F82
  call near timer_dequeue_long             ; 0F83
  mov byte [si + 2], 8                     ; 0F86
  call near rec_parse_frame_header         ; 0F8A
  jmp short loc_0FA4                       ; 0F8D
loc_0F8F:
  dec byte [si + 0x10]                     ; 0F8F
  je short loc_0F9E                        ; 0F92
  inc word [cs:0x1543]                     ; 0F94
  call near sap_deliver_indication_event   ; 0F99
  jmp short loc_0FA4                       ; 0F9C
loc_0F9E:
  call near timer_dequeue_long             ; 0F9E
  call near rec_parse_frame_header         ; 0FA1
loc_0FA4:
  pop si                                   ; 0FA4
  pop cx                                   ; 0FA5
  loop loc_0F44                            ; 0FA6
  ret                                      ; 0FA8
rec_validate_connection:
  call near timer_check_long_expired       ; 0FA9
  or_cx_cx                                     ; or cx, cx                ; 0FAC
  jne short loc_0FB1                       ; 0FAE
  ret                                      ; 0FB0
loc_0FB1:
  push cx                                  ; 0FB1
  mov di, word [si + 7]                    ; 0FB2
  push di                                  ; 0FB5
  call near rec_parse_frame_header         ; 0FB6
  mov word [si + 7], 0                     ; 0FB9
  mov word [si + 9], 0                     ; 0FBE
  pop si                                   ; 0FC3
  pop cx                                   ; 0FC4
  loop loc_0FB1                            ; 0FC5
  ret                                      ; 0FC7
rec_parse_frame_header:
  xor_bh_bh                                    ; xor bh, bh               ; 0FC8
  mov bl, byte [si + 2]                    ; 0FCA
  jmp word [cs:bx + 0xfd2]                 ; 0FCD

; rec_dispatch_table_0fd2
rec_dispatch_table_0fd2:
  dw loc_1017                       ; 0x1017
  dw loc_1017                       ; 0x1017
  dw loc_1017                       ; 0x1017
  dw 0x0FF9                         ; 0x0FF9
  dw loc_1017                       ; 0x1017
  dw 0x0FDE                         ; 0x0FDE

; ---------------------------------------------------------------------------
; REC Dispatch Handlers
; ---------------------------------------------------------------------------
  les di, [si + 0x1d]                      ; 0FDE
  mov cl, 2                                ; 0FE1
  shr byte [es:di], cl                     ; 0FE3
  mov byte [es:di + 1], 5                  ; 0FE6
  mov byte [es:di + 2], 1                  ; 0FEB
  push si                                  ; 0FF0
  mov si, word [si]                        ; 0FF1
  call near rec_queue_write_client         ; 0FF3
  pop si                                   ; 0FF6
  jmp short loc_1017                       ; 0FF7
  push si                                  ; 0FF9
  call near timer_dequeue_short            ; 0FFA
  pop si                                   ; 0FFD
  les di, [si + 0x15]                      ; 0FFE
  mov cl, 2                                ; 1001
  shr byte [es:di], cl                     ; 1003
  mov byte [es:di + 1], 5                  ; 1006
  mov byte [es:di + 2], 1                  ; 100B
  push si                                  ; 1010
  mov si, word [si]                        ; 1011
  call near rec_queue_write_client         ; 1013
  pop si                                   ; 1016
loc_1017:
  mov byte [si + 2], 8                     ; 1017
  call near get_remote_conn_index          ; 101B
  mov byte [si + 4], al                    ; 101E
  mov byte [si + 3], 0                     ; 1021
  mov_bx_si                                    ; mov bx, si               ; 1025
  add bx, 3                                ; 1027
  push si                                  ; 102A
  mov si, word [si]                        ; 102B
  call near rec_queue_write_alt            ; 102D
  pop si                                   ; 1030
  ret                                      ; 1031
rec_update_seq_num:
  mov dx, 0x1503                           ; 1032
  mov di, 0x151f                           ; 1035
  call near sap_increment_tx_seq           ; 1038
  ret                                      ; 103B
rec_handle_ack_nak:
  push cx                                  ; 103C
  mov si, word [bx + 4]                    ; 103D
  push si                                  ; 1040
  mov si, word [bx + 6]                    ; 1041
  test word [si], 0x8000                   ; 1044
  jne short loc_104F                       ; 1048
  call near int29_ack_return_buffer        ; 104A
  jmp short loc_108E                       ; 104D
loc_104F:
  mov di, word [si + 4]                    ; 104F
  mov ax, word [si + 6]                    ; 1052
  push di                                  ; 1055
  mov cx, 4                                ; 1056
loc_1059:
  clc                                      ; 1059
  rcr ax, 1                                ; 105A
  rcr di, 1                                ; 105C
  loop loc_1059                            ; 105E
  mov es, di                               ; 1060
  pop di                                   ; 1062
  and di, strict word 0x000F               ; 1063
  cmp byte [es:di + 2], 3                  ; 1067
  jne short loc_1073                       ; 106C
  call near rec_dispatch_event             ; 106E
  jmp short loc_108E                       ; 1071
loc_1073:
  cmp byte [es:di + 2], 0xf3               ; 1073
  jne short loc_107F                       ; 1078
  call near rec_deliver_data_ind           ; 107A
  jmp short loc_108E                       ; 107D
loc_107F:
  cmp byte [es:di + 2], 0xbf               ; 107F
  jne short loc_108B                       ; 1084
  call near rec_deliver_connect_ind        ; 1086
  jmp short loc_108E                       ; 1089
loc_108B:
  call near int29_ack_return_buffer        ; 108B
loc_108E:
  pop bx                                   ; 108E
  pop cx                                   ; 108F
  loop rec_handle_ack_nak                  ; 1090
  ret                                      ; 1092
rec_dispatch_event:
  mov al, byte [es:di]                     ; 1093
  call near sap_lookup_by_local_num        ; 1096
  jae short loc_10A1                       ; 1099
  call near int29_ack_return_buffer        ; 109B
  jmp near loc_10C8                        ; 109E
loc_10A1:
  mov ax, word [bx + 0x14]                 ; 10A1
  xchg_ah_al                                   ; xchg ah, al              ; 10A4
  mov word [bx + 2], ax                    ; 10A6
  mov word [bx + 8], di                    ; 10A9
  mov word [bx + 0xa], es                  ; 10AC
  cmp byte [si + 1], 0                     ; 10AF
  je short loc_10C9                        ; 10B3
  cmp byte [cs:0x1534], 0xff               ; 10B5
  jne short loc_10C2                       ; 10BB
  call near int29_ack_return_buffer        ; 10BD
  jmp short loc_10C8                       ; 10C0
loc_10C2:
  mov byte [bx], 2                         ; 10C2
  call near rec_queue_write_alt            ; 10C5
loc_10C8:
  ret                                      ; 10C8
loc_10C9:
  push bx                                  ; 10C9
  xor_bh_bh                                    ; xor bh, bh               ; 10CA
  mov bl, byte [es:di + 3]                 ; 10CC
  cmp bl, 4                                ; 10D0
  jle short loc_10D8                       ; 10D3
  jmp near loc_10E9                        ; 10D5
loc_10D8:
  shl bx, 1                                ; 10D8
  jmp word [cs:bx + 0x10df]                ; 10DA

; rec_event_table
rec_event_table:
  dw rec_event_disconnect_ind       ; 0x10ED
  dw rec_event_test_ind             ; 0x118B
  dw rec_event_udata_ind            ; 0x11F4
  dw rec_event_connect_ind          ; 0x1270
  dw rec_event_data_ind             ; 0x12CF

; ---------------------------------------------------------------------------
; REC Receive Handlers (Part 1)
; ---------------------------------------------------------------------------
loc_10E9:
  call near int29_ack_return_buffer        ; 10E9
  ret                                      ; 10EC
rec_event_disconnect_ind:
  mov ax, word [si + 0x11]                 ; 10ED
  and ax, word [es:di + 6]                 ; 10F0
  jne short loc_10F9                       ; 10F4
  jmp near loc_1186                        ; 10F6
loc_10F9:
  pop bx                                   ; 10F9
  push di                                  ; 10FA
  push es                                  ; 10FB
  call near rec_match_source_sap           ; 10FC
  pop es                                   ; 10FF
  pop di                                   ; 1100
  jb short loc_1107                        ; 1101
  push bx                                  ; 1103
  jmp near loc_1186                        ; 1104
loc_1107:
  mov byte [bx], 3                         ; 1107
  mov byte [bx + 1], al                    ; 110A
  push bx                                  ; 110D
  xor_bh_bh                                    ; xor bh, bh               ; 110E
  mov bl, byte [si + 2]                    ; 1110
  jmp word [cs:bx + 0x1118]                ; 1113

; rec_state_table_1118
rec_state_table_1118:
  dw 0x1143                         ; 0x1143
  dw 0x1124                         ; 0x1124
  dw 0x1124                         ; 0x1124
  dw 0x1124                         ; 0x1124
  dw loc_1186                       ; 0x1186
  dw 0x1124                         ; 0x1124

; ---------------------------------------------------------------------------
; REC Receive Handlers (Part 2)
; ---------------------------------------------------------------------------
  call near timer_dequeue_long             ; 1124
  mov al, byte [es:di + 5]                 ; 1127
  or_al_al                                     ; or al, al                ; 112B
  jne short loc_1132                       ; 112D
  jmp near loc_1174                        ; 112F
loc_1132:
  cmp al, byte [si + 3]                    ; 1132
  jae short loc_113A                       ; 1135
  jmp near loc_1174                        ; 1137
loc_113A:
  mov byte [si + 3], al                    ; 113A
  call near timer_enqueue_long             ; 113D
  jmp near loc_1186                        ; 1140
  cmp byte [cs:0x1534], 0xff               ; 1143
  je short loc_1186                        ; 1149
  pop bx                                   ; 114B
  push si                                  ; 114C
  mov si, word [si]                        ; 114D
  call near rec_queue_write_alt            ; 114F
  pop si                                   ; 1152
  mov byte [si + 2], 2                     ; 1153
  mov byte [si + 0x10], 5                  ; 1157
  mov bx, word [si]                        ; 115B
  mov ax, word [bx + 9]                    ; 115D
  mov word [si + 0x13], ax                 ; 1160
  add bx, 0x39                             ; 1163
  mov word [si + 0x15], bx                 ; 1166
  mov word [si + 0x17], ds                 ; 1169
  call near sap_deliver_indication_event   ; 116C
  call near timer_enqueue_long             ; 116F
  jmp short loc_118A                       ; 1172
loc_1174:
  cmp byte [si + 2], 2                     ; 1174
  je short loc_1180                        ; 1178
  cmp byte [si + 2], 0xa                   ; 117A
  jne short loc_1183                       ; 117E
loc_1180:
  call near timer_dequeue_short            ; 1180
loc_1183:
  call near rec_parse_frame_header         ; 1183
loc_1186:
  pop bx                                   ; 1186
  call near int29_ack_return_buffer        ; 1187
loc_118A:
  ret                                      ; 118A
rec_event_test_ind:
  pop bx                                   ; 118B
  push di                                  ; 118C
  push es                                  ; 118D
  call near rec_match_source_sap           ; 118E
  pop es                                   ; 1191
  pop di                                   ; 1192
  jb short loc_1199                        ; 1193
  push bx                                  ; 1195
  jmp near loc_11EF                        ; 1196
loc_1199:
  mov byte [bx], 3                         ; 1199
  mov byte [bx + 1], al                    ; 119C
  push bx                                  ; 119F
  xor_bh_bh                                    ; xor bh, bh               ; 11A0
  mov bl, byte [si + 2]                    ; 11A2
  jmp word [cs:bx + 0x11aa]                ; 11A5

; rec_state_table_11aa
rec_state_table_11aa:
  dw 0x11B6                         ; 0x11B6
  dw 0x11E0                         ; 0x11E0
  dw 0x11E9                         ; 0x11E9
  dw 0x11E9                         ; 0x11E9
  dw loc_11EF                       ; 0x11EF
  dw 0x11E0                         ; 0x11E0

; ---------------------------------------------------------------------------
; REC Receive Handlers (Part 3)
; ---------------------------------------------------------------------------
  cmp byte [cs:0x1534], 0xff               ; 11B6
  je short loc_11EF                        ; 11BC
  mov ah, byte [es:di + 5]                 ; 11BE
  mov byte [si + 3], ah                    ; 11C2
  mov ah, byte [es:di + 4]                 ; 11C5
  mov byte [si + 4], ah                    ; 11C9
  mov byte [si + 2], 4                     ; 11CC
  pop bx                                   ; 11D0
  call near sap_build_disconnect_ind       ; 11D1
  push si                                  ; 11D4
  mov si, word [si]                        ; 11D5
  call near rec_queue_write_alt            ; 11D7
  pop si                                   ; 11DA
  call near timer_enqueue_long             ; 11DB
  jmp short loc_11F3                       ; 11DE
  mov ah, byte [es:di + 4]                 ; 11E0
  call near sap_build_disconnect_ind       ; 11E4
  jmp short loc_11EF                       ; 11E7
  call near timer_dequeue_long             ; 11E9
  call near rec_parse_frame_header         ; 11EC
loc_11EF:
  pop bx                                   ; 11EF
  call near int29_ack_return_buffer        ; 11F0
loc_11F3:
  ret                                      ; 11F3
rec_event_udata_ind:
  mov al, byte [es:di + 5]                 ; 11F4
  call near sap_lookup_connection          ; 11F8
  jb short loc_1251                        ; 11FB
  mov al, byte [es:di + 4]                 ; 11FD
  mov byte [si + 4], al                    ; 1201
  xor_bh_bh                                    ; xor bh, bh               ; 1204
  mov bl, byte [si + 2]                    ; 1206
  jmp word [cs:bx + 0x120e]                ; 1209

; rec_state_table_120e
rec_state_table_120e:
  dw loc_1251                       ; 0x1251
  dw 0x1247                         ; 0x1247
  dw loc_1251                       ; 0x1251
  dw loc_1251                       ; 0x1251
  dw loc_1251                       ; 0x1251
  dw 0x121A                         ; 0x121A

; ---------------------------------------------------------------------------
; REC Receive Handlers (Part 4)
; ---------------------------------------------------------------------------
  call near rec_deliver_udata_ind          ; 121A
  call near timer_dequeue_short            ; 121D
  push si                                  ; 1220
  mov es, word [cs:saved_ds]               ; 1221
  mov_di_si                                    ; mov di, si               ; 1226
  add si, 0x1b                             ; 1228
  add di, 0x13                             ; 122B
  mov cx, 3                                ; 122E
  rep movsw                                ; 1231
  pop si                                   ; 1233
  mov byte [si + 0x10], 5                  ; 1234
  mov byte [si + 2], 6                     ; 1238
  mov di, 0x151f                           ; 123C
  mov dx, 0x1503                           ; 123F
  call near sap_deliver_confirm_success    ; 1242
  jmp short loc_1251                       ; 1245
  call near rec_deliver_udata_ind          ; 1247
  call near timer_dequeue_short            ; 124A
  mov byte [si + 2], 4                     ; 124D
loc_1251:
  pop bx                                   ; 1251
  call near int29_ack_return_buffer        ; 1252
  ret                                      ; 1255
rec_deliver_udata_ind:
  pushf                                    ; 1256
  cli                                      ; 1257
  cmp byte [si + 0x21], 2                  ; 1258
  je short loc_1264                        ; 125C
  mov byte [si + 0x21], 0                  ; 125E
  popf                                     ; 1262
  ret                                      ; 1263
loc_1264:
  popf                                     ; 1264
  pusha                                    ; 1265
  mov cl, 0x8d                             ; 1266
  mov dx, 0                                ; 1268
  int 0xe0                                 ; 126B
  popa                                     ; 126D
  jmp short rec_deliver_udata_ind          ; 126E
rec_event_connect_ind:
  cmp byte [cs:0x1534], 0xff               ; 1270
  je short loc_12CA                        ; 1276
  pop bx                                   ; 1278
  mov byte [bx], 4                         ; 1279
  mov al, byte [es:di + 5]                 ; 127C
  mov byte [bx + 1], al                    ; 1280
  push bx                                  ; 1283
  call near sap_lookup_connection          ; 1284
  jb short loc_12CA                        ; 1287
  mov bl, byte [si + 2]                    ; 1289
  xor_bh_bh                                    ; xor bh, bh               ; 128C
  jmp word [cs:bx + 0x1293]                ; 128E

; rec_state_table_1293
rec_state_table_1293:
  dw loc_12CA                       ; 0x12CA
  dw loc_12CA                       ; 0x12CA
  dw 0x129F                         ; 0x129F
  dw 0x129F                         ; 0x129F
  dw loc_12CA                       ; 0x12CA
  dw loc_12CA                       ; 0x12CA

; ---------------------------------------------------------------------------
; REC Receive Handlers (Part 5)
; ---------------------------------------------------------------------------
  mov al, byte [si + 0x12]                 ; 129F
  mov ah, byte [es:di + 4]                 ; 12A2
  cmp_al_ah                                    ; cmp al, ah               ; 12A6
  jne short loc_12C5                       ; 12A8
  cmp byte [si + 0x12], 0                  ; 12AA
  je short loc_12B5                        ; 12AE
  dec byte [si + 0x12]                     ; 12B0
  jmp short loc_12B8                       ; 12B3
loc_12B5:
  inc byte [si + 0x12]                     ; 12B5
loc_12B8:
  pop bx                                   ; 12B8
  call near sap_build_connect_ind          ; 12B9
  push si                                  ; 12BC
  mov si, word [si]                        ; 12BD
  call near rec_queue_write_alt            ; 12BF
  pop si                                   ; 12C2
  jmp short loc_12CE                       ; 12C3
loc_12C5:
  pop bx                                   ; 12C5
  push bx                                  ; 12C6
  call near sap_build_connect_ind          ; 12C7
loc_12CA:
  pop bx                                   ; 12CA
  call near int29_ack_return_buffer        ; 12CB
loc_12CE:
  ret                                      ; 12CE
rec_event_data_ind:
  mov al, byte [es:di + 5]                 ; 12CF
  call near sap_lookup_connection          ; 12D3
  jb short loc_1320                        ; 12D6
  mov al, byte [si + 0x11]                 ; 12D8
  xor al, byte [es:di + 4]                 ; 12DB
  je short loc_1320                        ; 12DF
  cmp byte [si + 2], 6                     ; 12E1
  jne short loc_1320                       ; 12E5
loc_12E7:
  pushf                                    ; 12E7
  cli                                      ; 12E8
  cmp byte [si + 0x21], 2                  ; 12E9
  je short loc_12F6                        ; 12ED
  mov byte [si + 0x21], 0                  ; 12EF
  popf                                     ; 12F3
  jmp short loc_1302                       ; 12F4
loc_12F6:
  popf                                     ; 12F6
  pusha                                    ; 12F7
  mov cl, 0x8d                             ; 12F8
  mov dx, 0                                ; 12FA
  int 0xe0                                 ; 12FD
  popa                                     ; 12FF
  jmp short loc_12E7                       ; 1300
loc_1302:
  call near timer_dequeue_short            ; 1302
  les di, [si + 0x15]                      ; 1305
  mov cl, 2                                ; 1308
  shr byte [es:di], cl                     ; 130A
  mov byte [es:di + 1], 5                  ; 130D
  mov byte [es:di + 2], 0                  ; 1312
  mov byte [si + 2], 4                     ; 1317
  mov si, word [si]                        ; 131B
  call near rec_queue_write_client         ; 131D
loc_1320:
  pop bx                                   ; 1320
  call near int29_ack_return_buffer        ; 1321
  ret                                      ; 1324
rec_deliver_data_ind:
  test byte [es:di + 1], 1                 ; 1325
  je short loc_132F                        ; 132A
  jmp near loc_13AC                        ; 132C
loc_132F:
  mov ah, byte [es:di]                     ; 132F
  cmp ah, 0                                ; 1332
  je short loc_134B                        ; 1335
  cmp ah, byte [cs:sap_conn_state_base]    ; 1337
  je short loc_134B                        ; 133C
  cmp ah, byte [cs:conn_flag_1f0d]         ; 133E
  je short loc_134B                        ; 1343
  call near int29_ack_return_buffer        ; 1345
  jmp near loc_13D5                        ; 1348
loc_134B:
  or ah, 1                                 ; 134B
  mov al, byte [es:di + 1]                 ; 134E
  mov byte [es:di], al                     ; 1352
  mov byte [es:di + 1], ah                 ; 1355
  push es                                  ; 1359
  push di                                  ; 135A
  mov es, word [cs:saved_ds]               ; 135B
  mov di, 0x151f                           ; 1360
  cmp byte [cs:0x1534], 0xff               ; 1363
  je short loc_136F                        ; 1369
  mov al, 3                                ; 136B
  jmp short loc_1371                       ; 136D
loc_136F:
  mov al, 2                                ; 136F
loc_1371:
  stosb                                    ; 1371
  mov_si_bx                                    ; mov si, bx               ; 1372
  add si, 0xe                              ; 1374
  mov cx, 3                                ; 1377
  rep movsw                                ; 137A
  cmp byte [cs:0x1534], 0xff               ; 137C
  je short loc_1396                        ; 1382
  mov ax, word [bx + 0x14]                 ; 1384
  xchg_ah_al                                   ; xchg ah, al              ; 1387
  stosw                                    ; 1389
  pop ax                                   ; 138A
  stosw                                    ; 138B
  pop ax                                   ; 138C
  stosw                                    ; 138D
  mov_ax_bx                                    ; mov ax, bx               ; 138E
  stosw                                    ; 1390
  mov byte [bx], 0xff                      ; 1391
  jmp short loc_13A4                       ; 1394
loc_1396:
  mov ax, ds                               ; 1396
  pop si                                   ; 1398
  pop ds                                   ; 1399
  push ax                                  ; 139A
  mov cx, 3                                ; 139B
  rep movsb                                ; 139E
  pop ds                                   ; 13A0
  call near int29_ack_return_buffer        ; 13A1
loc_13A4:
  mov dx, 0x1503                           ; 13A4
  mov cl, 0x8b                             ; 13A7
  int 0xe0                                 ; 13A9
  ret                                      ; 13AB
loc_13AC:
  cmp byte [cs:0x1534], 0xff               ; 13AC
  je short loc_13D2                        ; 13B2
  mov al, byte [es:di]                     ; 13B4
  call near sap_lookup_by_local_num        ; 13B7
  jb short loc_13D2                        ; 13BA
  mov byte [bx], 1                         ; 13BC
  mov ax, word [bx + 0x14]                 ; 13BF
  xchg_ah_al                                   ; xchg ah, al              ; 13C2
  mov word [bx + 2], ax                    ; 13C4
  mov word [bx + 8], di                    ; 13C7
  mov word [bx + 0xa], es                  ; 13CA
  call near rec_queue_write_alt            ; 13CD
  jmp short loc_13D5                       ; 13D0
loc_13D2:
  call near int29_ack_return_buffer        ; 13D2
loc_13D5:
  ret                                      ; 13D5
rec_deliver_connect_ind:
  test byte [es:di + 1], 1                 ; 13D6
  je short loc_13DF                        ; 13DB
  jmp short loc_1421                       ; 13DD
loc_13DF:
  mov al, 0                                ; 13DF
  cmp al, 0                                ; 13E1
  je short loc_13F5                        ; 13E3
  cmp al, byte [cs:sap_conn_state_base]    ; 13E5
  je short loc_13F5                        ; 13EA
  cmp al, byte [cs:conn_flag_1f0d]         ; 13EC
  je short loc_13F5                        ; 13F1
  jmp short loc_1421                       ; 13F3
loc_13F5:
  mov si, 0x151f                           ; 13F5
  or al, 1                                 ; 13F8
  mov byte [si + 2], al                    ; 13FA
  mov al, 1                                ; 13FD
  mov byte [si + 1], al                    ; 13FF
  mov al, byte [es:di + 2]                 ; 1402
  mov byte [si + 3], al                    ; 1406
  mov byte [si + 4], 0x81                  ; 1409
  mov byte [si + 5], 0                     ; 140D
  mov byte [si + 6], 0                     ; 1411
  mov byte [si], 2                         ; 1415
  push bx                                  ; 1418
  mov dx, 0x1503                           ; 1419
  mov cl, 0x8b                             ; 141C
  int 0xe0                                 ; 141E
  pop bx                                   ; 1420
loc_1421:
  call near int29_ack_return_buffer        ; 1421
  ret                                      ; 1424
int29_ack_return_buffer:
  push ds                                  ; 1425
  push bx                                  ; 1426
  mov byte [bx], 0xff                      ; 1427
  int 0x29                                 ; 142A
  pop bx                                   ; 142C
  pop ds                                   ; 142D
  ret                                      ; 142E
rec_match_source_sap:
  mov es, word [cs:saved_ds]               ; 142F
  push si                                  ; 1434
  mov_di_bx                                    ; mov di, bx               ; 1435
  add di, 0xe                              ; 1437
  mov si, 0x1545                           ; 143A
  mov cx, MAX_CONNS                        ; 143D
  xor_al_al                                    ; xor al, al               ; 1440
loc_1442:
  cmp byte [si], 0                         ; 1442
  je short loc_1455                        ; 1445
  push cx                                  ; 1447
  push di                                  ; 1448
  push si                                  ; 1449
  inc si                                   ; 144A
  mov cx, 3                                ; 144B
  repe cmpsw                               ; 144E
  pop si                                   ; 1450
  pop di                                   ; 1451
  pop cx                                   ; 1452
  je short loc_145F                        ; 1453
loc_1455:
  add si, 0x4b                             ; 1455
  inc al                                   ; 1458
  loop loc_1442                            ; 145A
  jmp near loc_149C                        ; 145C
loc_145F:
  pop di                                   ; 145F
  cmp word [si + 7], di                    ; 1460
  jne short loc_146A                       ; 1463
  add si, 7                                ; 1465
  jmp short loc_149A                       ; 1468
loc_146A:
  cmp word [si + 0x29], di                 ; 146A
  jne short loc_1474                       ; 146D
  add si, 0x29                             ; 146F
  jmp short loc_149A                       ; 1472
loc_1474:
  cmp word [si + 7], 0                     ; 1474
  jne short loc_1486                       ; 1478
  mov_dx_si                                    ; mov dx, si               ; 147A
  add si, 7                                ; 147C
  mov word [si + 0x19], dx                 ; 147F
  mov word [si], di                        ; 1482
  jmp short loc_149A                       ; 1484
loc_1486:
  cmp word [si + 0x29], 0                  ; 1486
  jne short loc_1498                       ; 148A
  mov_dx_si                                    ; mov dx, si               ; 148C
  add si, 0x29                             ; 148E
  mov word [si + 0x19], dx                 ; 1491
  mov word [si], di                        ; 1494
  jmp short loc_149A                       ; 1496
loc_1498:
  clc                                      ; 1498
  ret                                      ; 1499
loc_149A:
  stc                                      ; 149A
  ret                                      ; 149B
loc_149C:
  mov cx, MAX_CONNS                        ; 149C
  mov si, 0x1545                           ; 149F
  xor_dl_dl                                    ; xor dl, dl               ; 14A2
loc_14A4:
  cmp byte [si], 0                         ; 14A4
  je short loc_14B4                        ; 14A7
  add si, 0x4b                             ; 14A9
  inc dl                                   ; 14AC
  loop loc_14A4                            ; 14AE
  pop si                                   ; 14B0
  clc                                      ; 14B1
  jmp short loc_14D0                       ; 14B2
loc_14B4:
  push si                                  ; 14B4
  mov_di_si                                    ; mov di, si               ; 14B5
  mov al, 0xff                             ; 14B7
  stosb                                    ; 14B9
  mov_si_bx                                    ; mov si, bx               ; 14BA
  add si, 0xe                              ; 14BC
  mov cx, 3                                ; 14BF
  rep movsw                                ; 14C2
  pop si                                   ; 14C4
  mov word [di + 0x19], si                 ; 14C5
  pop si                                   ; 14C8
  mov word [di], si                        ; 14C9
  mov_si_di                                    ; mov si, di               ; 14CB
  mov_al_dl                                    ; mov al, dl               ; 14CD
  stc                                      ; 14CF
loc_14D0:
  ret                                      ; 14D0
rec_queue_write_client:
  mov ax, word [si + 4]                    ; 14D1
  mov word [cs:0x1515], ax                 ; 14D4
  mov word [cs:0x151b], di                 ; 14D8
  mov word [cs:0x151d], es                 ; 14DD
  jmp short loc_14F5                       ; 14E2
rec_queue_write_alt:
  mov ax, word [si + 2]                    ; 14E4
  mov word [cs:0x1515], ax                 ; 14E7
  mov word [cs:0x151b], bx                 ; 14EB
  mov word [cs:0x151d], ds                 ; 14F0
loc_14F5:
  push bx                                  ; 14F5
  push di                                  ; 14F6
  push si                                  ; 14F7
  mov dx, 0x1513                           ; 14F8
  mov cl, 0x8b                             ; 14FB
  int 0xe0                                 ; 14FD
  pop si                                   ; 14FF
  pop di                                   ; 1500
  pop bx                                   ; 1501
  ret                                      ; 1502

; REC Internal Queue & Scratch State (50 bytes)
qpb_rec_internal:
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x1F, 0x15, 0x58, 0x4D, 0x49, 0x54, 0x5F, 0x52, 0x45, 0x51
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x1B, 0x15, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0xFF

; ---------------------------------------------------------------------------
; SAP State Tables & Connection Tables (0x1535..)
; ---------------------------------------------------------------------------
%if NETDRV_REV == 'B'
  db 0x06, 0xD0, 0x37, 0x3E, 0x38, 0x06, 0x54, 0x38, 0x86, 0x38
%else
  db 0x06, 0xE4, 0x23, 0x52, 0x24, 0x06, 0x68, 0x24, 0x9A, 0x24
%endif
  times CONN_TABLE_PAD db 0

; ---------------------------------------------------------------------------
; Multicast Addresses, i82586 SCB & Command Descriptors
; ---------------------------------------------------------------------------
%if NETDRV_REV == 'B'
  db 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF
  db 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x7A, 0x3B, 0xD0, 0x37, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x94, 0x33, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0xE6, 0x37, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFC, 0x37, 0xFF, 0xFF, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x12
  db 0x38, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x28, 0x38, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3E, 0x38, 0xFF, 0xFF, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x80, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x5E, 0x38, 0x00, 0x00, 0x00, 0x00, 0x38, 0x04, 0x00, 0x00, 0x68
  db 0x38, 0x00, 0x00, 0x00, 0x00, 0x38, 0x04, 0x00, 0x00, 0x72, 0x38, 0x00, 0x00, 0x00, 0x00, 0x38
  db 0x04, 0x00, 0x00, 0x7C, 0x38, 0x00, 0x00, 0x00, 0x00, 0x38, 0x04, 0x00, 0x00, 0x86, 0x38, 0x00
  db 0x00, 0x00, 0x00, 0x38, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x38, 0x84
%else
  db 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF
  db 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x8E, 0x27, 0xE4, 0x23, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xA8, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0xFA, 0x23, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x24, 0xFF, 0xFF, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x26
  db 0x24, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x3C, 0x24, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x52, 0x24, 0xFF, 0xFF, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x80, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x72, 0x24, 0x00, 0x00, 0x00, 0x00, 0x38, 0x04, 0x00, 0x00, 0x7C
  db 0x24, 0x00, 0x00, 0x00, 0x00, 0x38, 0x04, 0x00, 0x00, 0x86, 0x24, 0x00, 0x00, 0x00, 0x00, 0x38
  db 0x04, 0x00, 0x00, 0x90, 0x24, 0x00, 0x00, 0x00, 0x00, 0x38, 0x04, 0x00, 0x00, 0x9A, 0x24, 0x00
  db 0x00, 0x00, 0x00, 0x38, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x38, 0x84
%endif

; ---------------------------------------------------------------------------
; LAN Controller Hardware Initialization & Setup
; ---------------------------------------------------------------------------
loc_24A4:
  mov ax, 4                                ; 24A4
  int 0x28                                 ; 24A7
  cmp byte [es:si + 0xd], 0xff             ; 24A9
  je short loc_24B3                        ; 24AE
  jmp near loc_26B9                        ; 24B0
loc_24B3:
  mov cl, 0x9a                             ; 24B3
  int 0xe0                                 ; 24B5
  mov word [cs:saved_stacks], es           ; 24B7
  mov ax, word [es:bx + 0x38]              ; 24BC
  mov word [cs:saved_ir5_vector], ax       ; 24C0
  mov ax, word [es:bx + 0x3a]              ; 24C4
  mov word [cs:saved_ir5_segment], ax      ; 24C8
  mov ax, word [es:bx]                     ; 24CC
  mov word [cs:saved_bdos_vector], ax      ; 24CF
  mov ax, word [es:bx + 2]                 ; 24D3
  mov word [cs:saved_bdos_segment], ax     ; 24D7
  mov es, word [cs:saved_ds]               ; 24DB
  mov ax, ds                               ; 24E0
  mov es, ax                               ; 24E2
  mov di, 0x1545                           ; 24E4
  mov cx, CONN_TABLE_SIZE                  ; 24E7
  xor_al_al                                    ; xor al, al               ; 24EA
  rep stosb                                ; 24EC
  mov bx, tbd_buffer_addr                  ; 24EE
  mov di, cb_command                       ; 24F1
  call near calc_20bit_phys_addr           ; 24F4
  mov bx, lan_init_hardware                ; 24F7
  mov cx, 6                                ; 24FA
  mov di, lan_hw_config_bytes              ; 24FD
loc_2500:
  push cx                                  ; 2500
  call near calc_20bit_phys_addr           ; 2501
  pop cx                                   ; 2504
  add di, 0xa                              ; 2505
  add bx, 0x438                            ; 2508
  loop loc_2500                            ; 250C
  mov ax, 0x3000                           ; 250E
  mov es, ax                               ; 2511
  mov di, 0xfff6                           ; 2513
  mov word [es:di], 0                      ; 2516
  mov ax, 0x3000                           ; 251B
  mov bx, 0xffe0                           ; 251E
  mov cl, 4                                ; 2521
  rol ax, cl                               ; 2523
  mov_ch_al                                    ; mov ch, al               ; 2525
  and al, 0xf0                             ; 2527
  add_ax_bx                                    ; add ax, bx               ; 2529
  adc ch, 0                                ; 252B
  and ch, 0xf                              ; 252E
  xchg_cl_ch                                   ; xchg cl, ch              ; 2531
  xor_ch_ch                                    ; xor ch, ch               ; 2533
  mov word [es:di + 6], ax                 ; 2535
  mov word [es:di + 8], cx                 ; 2539
  push ds                                  ; 253D
  mov ax, 0xf000                           ; 253E
  mov ds, ax                               ; 2541
  mov es, word [cs:saved_ds]               ; 2543
  mov di, lan_rbd_pool                     ; 2548
  mov si, 0x6000                           ; 254B
  mov cx, 4                                ; 254E
  rep movsw                                ; 2551
  mov ax, ds                               ; 2553
  pop ds                                   ; 2555
  mov es, ax                               ; 2556
  mov di, 0x6000                           ; 2558
  mov word [es:di], 1                      ; 255B
  mov word [es:di + 2], i82586_scb         ; 2560
  mov ax, ds                               ; 2566
  mov cl, 4                                ; 2568
  shl ax, cl                               ; 256A
  mov word [es:di + 4], ax                 ; 256C
  mov ax, ds                               ; 2570
  mov cl, 0xc                              ; 2572
  shr ax, cl                               ; 2574
  mov word [es:di + 6], ax                 ; 2576
  mov ax, 0x3000                           ; 257A
  mov es, ax                               ; 257D
  mov di, 0xffe0                           ; 257F
  mov word [es:di], 1                      ; 2582
  mov word [es:di + 2], i82586_scb         ; 2587
  mov ax, ds                               ; 258D
  mov cl, 4                                ; 258F
  shl ax, cl                               ; 2591
  mov word [es:di + 4], ax                 ; 2593
  mov ax, ds                               ; 2597
  mov cl, 0xc                              ; 2599
  shr ax, cl                               ; 259B
  mov word [es:di + 6], ax                 ; 259D
  cli                                      ; 25A1
  xor_ax_ax                                    ; xor ax, ax               ; 25A2
  mov es, ax                               ; 25A4
  mov ax, init_isr_ir5                     ; 25A6
  mov di, 0x94                             ; 25A9
  stosw                                    ; 25AC
  mov ax, cs                               ; 25AD
  stosw                                    ; 25AF
  mov ax, isr_ack_int29                    ; 25B0
  mov di, 0xa4                             ; 25B3
  stosw                                    ; 25B6
  mov ax, cs                               ; 25B7
  stosw                                    ; 25B9
  mov dx, 2                                ; 25BA
  mov al, 0x80                             ; 25BD
  out dx, al                               ; 25BF
  sti                                      ; 25C0
  mov ax, ds                               ; 25C1
  mov es, ax                               ; 25C3
  mov dx, 0x100                            ; 25C5
  in al, dx                                ; 25C8
  mov ax, ds                               ; 25C9
  add ax, strict word 0x0004               ; 25CB
  mov es, ax                               ; 25CE
  mov dx, 0x16                             ; 25D0
  call near bdos_wait_flag_16              ; 25D3
  mov di, 0x6000                           ; 25D6
  mov si, lan_rbd_pool                     ; 25D9
  mov cx, 4                                ; 25DC
  mov ax, 0xf000                           ; 25DF
  mov es, ax                               ; 25E2
  rep movsw                                ; 25E4
  mov ax, ds                               ; 25E6
  mov es, ax                               ; 25E8
  mov di, lan_cfg_cmd                      ; 25EA
  call near setup_xios_call_vector         ; 25ED
  mov ax, 0x100                            ; 25F0
  call near channel_attention_delay        ; 25F3
  mov ax, ds                               ; 25F6
  add ax, strict word 0x0004               ; 25F8
  mov es, ax                               ; 25FB
  mov dx, 0x16                             ; 25FD
  call near bdos_wait_flag_16              ; 2600
  mov si, lan_ia_cmd                       ; 2603
  cmp word [si], 0xa000                    ; 2606
  je short loc_260F                        ; 260A
  jmp near loc_26B9                        ; 260C
loc_260F:
  mov si, lan_mc_cmd                       ; 260F
  cmp word [si], 0xa000                    ; 2612
  je short loc_261B                        ; 2616
  jmp near loc_26B9                        ; 2618
loc_261B:
  cli                                      ; 261B
  xor_ax_ax                                    ; xor ax, ax               ; 261C
  mov es, ax                               ; 261E
  mov ax, lan_isr_ir5                      ; 2620
  mov di, 0x94                             ; 2623
  stosw                                    ; 2626
  mov ax, cs                               ; 2627
  stosw                                    ; 2629
  sti                                      ; 262A
  mov ax, 0x20                             ; 262B
  mov dx, timer_tick_routine               ; 262E
  mov cx, cs                               ; 2631
  int 0x28                                 ; 2633
  mov ax, 0x22                             ; 2635
  mov dx, lan_controller_reset             ; 2638
  mov cx, cs                               ; 263B
  int 0x28                                 ; 263D
  mov ax, ds                               ; 263F
  mov es, ax                               ; 2641
  mov word [cs:scb_command], scb_crc_errs  ; 2643
  mov si, 0x500                            ; 264A
  mov word [si + 0x50], cs                 ; 264D
  mov word [si + 0x52], ds                 ; 2650
  mov word [si + 0x54], es                 ; 2653
  mov word [si + 0x56], ss                 ; 2656
  mov si, 0x2a0                            ; 2659
  mov word [si + 0x50], cs                 ; 265C
  mov word [si + 0x52], ds                 ; 265F
  mov word [si + 0x54], es                 ; 2662
  mov word [si + 0x56], ss                 ; 2665
  mov dx, 0x270                            ; 2668
  mov cl, 0x90                             ; 266B
  int 0xe0                                 ; 266D
  pushf                                    ; 266F
  cli                                      ; 2670
  mov si, word [cs:0x1536]                 ; 2671
  mov di, word [cs:0x153b]                 ; 2676
  mov word [si + 6], di                    ; 267B
  mov word [cs:scb_cbl_offset], si         ; 267E
  mov byte [cs:0x1535], 0                  ; 2683
  mov word [cs:0x1536], 0                  ; 2689
  mov word [cs:0x1538], 0                  ; 2690
  mov byte [cs:0x153a], 0                  ; 2697
  mov word [cs:0x153b], 0                  ; 269D
  mov word [cs:0x153d], 0                  ; 26A4
  mov byte [cs:0x1534], 0                  ; 26AB
  popf                                     ; 26B1
  mov ax, 0x10                             ; 26B2
  call near channel_attention_delay        ; 26B5
  ret                                      ; 26B8
loc_26B9:
  mov dx, 0xbae                            ; 26B9
  mov cl, 0x87                             ; 26BC
  int 0xe0                                 ; 26BE
  or_ax_ax                                     ; or ax, ax                ; 26C0
  jne short loc_26CB                       ; 26C2
  mov dx, 0xbae                            ; 26C4
  mov cl, 0x88                             ; 26C7
  int 0xe0                                 ; 26C9
loc_26CB:
  mov dx, 0xbbe                            ; 26CB
  mov cl, 0x87                             ; 26CE
  int 0xe0                                 ; 26D0
  or_ax_ax                                     ; or ax, ax                ; 26D2
  jne short loc_26DD                       ; 26D4
  mov dx, 0xbbe                            ; 26D6
  mov cl, 0x88                             ; 26D9
  int 0xe0                                 ; 26DB
loc_26DD:
  mov cl, 0x8f                             ; 26DD
  mov dl, 0xff                             ; 26DF
  int 0xe0                                 ; 26E1
loc_26E3:
  mov ax, ds                               ; 26E3
  mov cl, 4                                ; 26E5
  rol ax, cl                               ; 26E7
  mov_ch_al                                    ; mov ch, al               ; 26E9
  and al, 0xf0                             ; 26EB
  add_ax_bx                                    ; add ax, bx               ; 26ED
  adc ch, 0                                ; 26EF
  and ch, 0xf                              ; 26F2
  xchg_cl_ch                                   ; xchg cl, ch              ; 26F5
  xor_ch_ch                                    ; xor ch, ch               ; 26F7
  mov word [di + 4], ax                    ; 26F9
  mov word [di + 6], cx                    ; 26FC
  ret                                      ; 26FF
loc_2700:
  push di                                  ; 2700
  mov ax, 3                                ; 2701
  int 0x28                                 ; 2704
  pop di                                   ; 2706
  mov ax, word [es:si + 5]                 ; 2707
  mov dx, word [es:si + 1]                 ; 270B
  shl dx, 1                                ; 270F
  clc                                      ; 2711
  rcl ax, 1                                ; 2712
  jae short loc_2717                       ; 2714
  inc dx                                   ; 2716
loc_2717:
  mov si, lan_init_ir5_isr                 ; 2717
  add ax, word [si]                        ; 271A
  mov word [di], ax                        ; 271C
  adc dx, word [si + 2]                    ; 271E
  mov word [di + 2], dx                    ; 2721
  mov ax, 0                                ; 2724
  adc ax, word [si + 4]                    ; 2727
  mov word [di + 4], ax                    ; 272A
  mov ax, ds                               ; 272D
  mov es, ax                               ; 272F
  ret                                      ; 2731
  add byte [bx + si], al                   ; 2732
  add byte [bx + si], al                   ; 2734
  add byte [bx + si], al                   ; 2736

; ---------------------------------------------------------------------------
; Temporary IR5 ISR during Initialization
; ---------------------------------------------------------------------------
  push ax                                  ; 2738
  mov word [cs:saved_ss], ss               ; 2739
  mov word [cs:saved_sp], sp               ; 273E
  mov sp, lan_private_stack_top            ; 2743
  mov ax, cs                               ; 2746
  mov ss, ax                               ; 2748
  pusha                                    ; 274A
  push ds                                  ; 274B
  mov ds, ax                               ; 274C
  mov ax, word [cs:i82586_scb]             ; 274E
  and ax, 0xf000                           ; 2752
  mov word [cs:scb_status], ax             ; 2755
  mov dx, 0x16                             ; 2759
  call near bdos_set_flag_dx               ; 275C
  mov byte [cs:lan_reset_flag], 0xff       ; 275F
  or word [cs:scb_status], strict word 0   ; 2765
  mov dx, 0x100                            ; 276C
  in al, dx                                ; 276F
  mov al, 0x20                             ; 2770
  out 0, al                                ; 2772
  mov dx, 0xff22                           ; 2774
  mov ax, 0x8000                           ; 2777
  out dx, ax                               ; 277A
  pop ds                                   ; 277B
  popa                                     ; 277C
  mov sp, word [cs:saved_sp]               ; 277D
  mov ss, word [cs:saved_ss]               ; 2782
  pop ax                                   ; 2787
  jmp far [cs:saved_ir5_vector]            ; 2788

; ---------------------------------------------------------------------------
; Initialization Jump Vector & Configuration Descriptors
; ---------------------------------------------------------------------------
%if NETDRV_REV == 'B'
  db 0x00, 0x00, 0x00, 0x02, 0x00, 0x84, 0x3B, 0x04, 0x08, 0x00, 0x66, 0x00, 0x00, 0x01, 0x00, 0x90
  db 0x3B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0xA4, 0x3B, 0x0C, 0x00, 0x03
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x80, 0x84
  db 0x3B, 0x04, 0x08, 0x00, 0x26
%else
  db 0x00, 0x00, 0x00, 0x02, 0x00, 0x98, 0x27, 0x04, 0x08, 0x00, 0x66, 0x00, 0x00, 0x01, 0x00, 0xA4
  db 0x27, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0xB8, 0x27, 0x0C, 0x00, 0x03
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x80, 0x98
  db 0x27, 0x04, 0x08, 0x00, 0x26
%endif

; ---------------------------------------------------------------------------
; Intel 82586 Receive Buffer Pool (RBD / Frame Buffers)
; ---------------------------------------------------------------------------
  times 5685 db 0

; ---------------------------------------------------------------------------
; Short Timer Helper Routines
; ---------------------------------------------------------------------------
loc_3DF7:
  pushf                                    ; 3DF7
  cli                                      ; 3DF8
  inc byte [cs:timer_short_active]         ; 3DF9
  cmp byte [cs:timer_short_active], 1      ; 3DFE
  jne short loc_3E1B                       ; 3E04
  mov word [cs:timer_short_queue_head], si ; 3E06
  mov byte [si + 0xb], 0x3f                ; 3E0B
  mov word [si + 0xe], 0                   ; 3E0F
  mov word [si + 0xc], 0                   ; 3E14
  jmp short loc_3E44                       ; 3E19
loc_3E1B:
  push di                                  ; 3E1B
  xor_al_al                                    ; xor al, al               ; 3E1C
  mov di, word [cs:timer_short_queue_head] ; 3E1E
loc_3E23:
  add al, byte [di + 0xb]                  ; 3E23
  cmp word [di + 0xc], 0                   ; 3E26
  je short loc_3E31                        ; 3E2A
  mov di, word [di + 0xc]                  ; 3E2C
  jmp short loc_3E23                       ; 3E2F
loc_3E31:
  mov ah, 0x3f                             ; 3E31
  sub_ah_al                                    ; sub ah, al               ; 3E33
  mov byte [si + 0xb], ah                  ; 3E35
  mov word [si + 0xe], di                  ; 3E38
  mov word [si + 0xc], 0                   ; 3E3B
  mov word [di + 0xc], si                  ; 3E40
  pop di                                   ; 3E43
loc_3E44:
  popf                                     ; 3E44
  ret                                      ; 3E45
loc_3E46:
  pushf                                    ; 3E46
  cli                                      ; 3E47
  push di                                  ; 3E48
  push bx                                  ; 3E49
  cmp byte [cs:timer_short_active], 0      ; 3E4A
  je short loc_3E96                        ; 3E50
  dec byte [cs:timer_short_active]         ; 3E52
  je short loc_3E96                        ; 3E57
  cmp word [si + 0xc], 0                   ; 3E59
  jne short loc_3E69                       ; 3E5D
  mov di, word [si + 0xe]                  ; 3E5F
  mov word [di + 0xc], 0                   ; 3E62
  jmp short loc_3E96                       ; 3E67
loc_3E69:
  cmp word [si + 0xe], 0                   ; 3E69
  je short loc_3E83                        ; 3E6D
  mov al, byte [si + 0xb]                  ; 3E6F
  mov di, word [si + 0xc]                  ; 3E72
  add byte [di + 0xb], al                  ; 3E75
  mov bx, word [si + 0xe]                  ; 3E78
  mov word [di + 0xe], bx                  ; 3E7B
  mov word [bx + 0xc], di                  ; 3E7E
  jmp short loc_3E96                       ; 3E81
loc_3E83:
  mov di, word [si + 0xc]                  ; 3E83
  mov word [cs:timer_short_queue_head], di ; 3E86
  mov al, byte [si + 0xb]                  ; 3E8B
  add byte [di + 0xb], al                  ; 3E8E
  mov word [di + 0xe], 0                   ; 3E91
loc_3E96:
  pop bx                                   ; 3E96
  pop di                                   ; 3E97
  mov word [si + 0xc], 0                   ; 3E98
  mov word [si + 0xe], 0                   ; 3E9D
  popf                                     ; 3EA2
  ret                                      ; 3EA3
loc_3EA4:
  pushf                                    ; 3EA4
  cli                                      ; 3EA5
  xor_cx_cx ; xor cx, cx               ; 3EA6
  cmp byte [cs:timer_short_active], 0      ; 3EA8
  je short loc_3ED4                        ; 3EAE
  mov si, word [cs:timer_short_queue_head] ; 3EB0
  push si                                  ; 3EB5
loc_3EB6:
  cmp byte [si + 0xb], 0                   ; 3EB6
  jne short loc_3EC9                       ; 3EBA
  inc cx                                   ; 3EBC
  dec byte [cs:timer_short_active]         ; 3EBD
  je short loc_3EC9                        ; 3EC2
  mov si, word [si + 0xc]                  ; 3EC4
  jmp short loc_3EB6                       ; 3EC7
loc_3EC9:
  mov word [cs:timer_short_queue_head], si ; 3EC9
  mov word [si + 0xe], 0                   ; 3ECE
  pop si                                   ; 3ED3
loc_3ED4:
  popf                                     ; 3ED4
  ret                                      ; 3ED5

; Long Timer Queue Header State (3 bytes)
  db 0x00, 0x00, 0x00

; ---------------------------------------------------------------------------
; Long Timer Helper Routines
; ---------------------------------------------------------------------------
loc_3ED9:
  pushf                                    ; 3ED9
  cli                                      ; 3EDA
  inc byte [cs:timer_long_hdr]             ; 3EDB
  cmp byte [cs:timer_long_hdr], 1          ; 3EE0
  jne short loc_3EFE                       ; 3EE6
  mov word [cs:timer_long_queue_head], si  ; 3EE8
  mov word [si + 5], 0x1068                ; 3EED
  mov word [si + 9], 0                     ; 3EF2
  mov word [si + 7], 0                     ; 3EF7
  jmp short loc_3F28                       ; 3EFC
loc_3EFE:
  push di                                  ; 3EFE
  xor_ax_ax                                    ; xor ax, ax               ; 3EFF
  mov di, word [cs:timer_long_queue_head]  ; 3F01
loc_3F06:
  add ax, word [di + 5]                    ; 3F06
  cmp word [di + 7], 0                     ; 3F09
  je short loc_3F14                        ; 3F0D
  mov di, word [di + 7]                    ; 3F0F
  jmp short loc_3F06                       ; 3F12
loc_3F14:
  mov dx, 0x1068                           ; 3F14
  sub_dx_ax                                    ; sub dx, ax               ; 3F17
  mov word [si + 5], dx                    ; 3F19
  mov word [si + 9], di                    ; 3F1C
  mov word [si + 7], 0                     ; 3F1F
  mov word [di + 7], si                    ; 3F24
  pop di                                   ; 3F27
loc_3F28:
  popf                                     ; 3F28
  ret                                      ; 3F29
loc_3F2A:
  pushf                                    ; 3F2A
  cli                                      ; 3F2B
  push di                                  ; 3F2C
  cmp byte [cs:timer_long_hdr], 0          ; 3F2D
  je short loc_3F79                        ; 3F33
  dec byte [cs:timer_long_hdr]             ; 3F35
  je short loc_3F79                        ; 3F3A
  cmp word [si + 7], 0                     ; 3F3C
  jne short loc_3F4C                       ; 3F40
  mov di, word [si + 9]                    ; 3F42
  mov word [di + 7], 0                     ; 3F45
  jmp short loc_3F79                       ; 3F4A
loc_3F4C:
  cmp word [si + 9], 0                     ; 3F4C
  je short loc_3F66                        ; 3F50
  mov ax, word [si + 5]                    ; 3F52
  mov di, word [si + 7]                    ; 3F55
  add word [di + 5], ax                    ; 3F58
  mov bx, word [si + 9]                    ; 3F5B
  mov word [di + 9], bx                    ; 3F5E
  mov word [bx + 7], di                    ; 3F61
  jmp short loc_3F79                       ; 3F64
loc_3F66:
  mov di, word [si + 7]                    ; 3F66
  mov word [cs:timer_long_queue_head], di  ; 3F69
  mov ax, word [si + 5]                    ; 3F6E
  add word [di + 5], ax                    ; 3F71
  mov word [di + 9], 0                     ; 3F74
loc_3F79:
  pop di                                   ; 3F79
  mov word [si + 7], 0                     ; 3F7A
  mov word [si + 9], 0                     ; 3F7F
  popf                                     ; 3F84
  ret                                      ; 3F85
loc_3F86:
  pushf                                    ; 3F86
  cli                                      ; 3F87
  xor_cx_cx ; xor cx, cx               ; 3F88
  cmp byte [cs:timer_long_hdr], 0          ; 3F8A
  je short loc_3FB6                        ; 3F90
  mov si, word [cs:timer_long_queue_head]  ; 3F92
  push si                                  ; 3F97
loc_3F98:
  cmp word [si + 5], 0                     ; 3F98
  jne short loc_3FAB                       ; 3F9C
  inc cx                                   ; 3F9E
  dec byte [cs:timer_long_hdr]             ; 3F9F
  je short loc_3FAB                        ; 3FA4
  mov si, word [si + 7]                    ; 3FA6
  jmp short loc_3F98                       ; 3FA9
loc_3FAB:
  mov word [cs:timer_long_queue_head], si  ; 3FAB
  mov word [si + 9], 0                     ; 3FB0
  pop si                                   ; 3FB5
loc_3FB6:
  popf                                     ; 3FB6
  ret                                      ; 3FB7

; Timer Tick Active Flag (1 bytes)
  db 0xFF

; ---------------------------------------------------------------------------
; Timer Tick Handler
; ---------------------------------------------------------------------------
  mov ax, cs                               ; 3FB9
  mov ds, ax                               ; 3FBB
  cmp byte [cs:timer_short_active], 0      ; 3FBD
  je short loc_3FDB                        ; 3FC3
  mov bx, word [cs:timer_short_queue_head] ; 3FC5
  cmp byte [bx + 0xb], 0                   ; 3FCA
  je short loc_3FDB                        ; 3FCE
  dec byte [bx + 0xb]                      ; 3FD0
  jne short loc_3FDB                       ; 3FD3
  or byte [cs:pending_event_flags], 1      ; 3FD5
loc_3FDB:
  cmp byte [cs:timer_long_hdr], 0          ; 3FDB
  je short loc_3FF9                        ; 3FE1
  mov bx, word [cs:timer_long_queue_head]  ; 3FE3
  cmp word [bx + 5], 0                     ; 3FE8
  je short loc_3FF9                        ; 3FEC
  dec word [bx + 5]                        ; 3FEE
  jne short loc_3FF9                       ; 3FF1
  or byte [cs:pending_event_flags], 2      ; 3FF3
loc_3FF9:
  cmp word [cs:timer_tick_counter_1eac], 0 ; 3FF9
  je short loc_400E                        ; 3FFF
  dec word [cs:timer_tick_counter_1eac]    ; 4001
  jne short loc_400E                       ; 4006
  or byte [cs:pending_event_flags], 4      ; 4008
loc_400E:
  cmp word [cs:timer_tick_counter_1f14], 0 ; 400E
  je short loc_4023                        ; 4014
  dec word [cs:timer_tick_counter_1f14]    ; 4016
  jne short loc_4023                       ; 401B
  or byte [cs:pending_event_flags], 8      ; 401D
loc_4023:
  cmp byte [cs:timer_tick_flag], 0         ; 4023
  je short loc_4039                        ; 4029
  cmp byte [cs:pending_event_flags], 0     ; 402B
  je short loc_4039                        ; 4031
  mov dx, 0x17                             ; 4033
  call near bdos_set_flag_dx               ; 4036
loc_4039:
  retf                                     ; 4039

; ---------------------------------------------------------------------------
; LAN IR5 Hardware ISR
; ---------------------------------------------------------------------------
  push ax                                  ; 403A
  mov word [cs:saved_ss], ss               ; 403B
  mov word [cs:saved_sp], sp               ; 4040
  mov sp, lan_private_stack_top            ; 4045
  mov ax, cs                               ; 4048
  mov ss, ax                               ; 404A
  pusha                                    ; 404C
  push ds                                  ; 404D
  mov ds, ax                               ; 404E
loc_4050:
  cmp word [cs:scb_status], 0              ; 4050
  jne short loc_4050                       ; 4056
  mov ax, word [cs:i82586_scb]             ; 4058
  and ax, 0xf000                           ; 405C
  mov word [cs:scb_status], ax             ; 405F
  test word [cs:scb_status], 0xa000        ; 4063
  je short loc_4072                        ; 406A
  mov dx, 0x16                             ; 406C
  call near bdos_set_flag_dx               ; 406F
loc_4072:
  test word [cs:scb_status], 0x5000        ; 4072
  jne short loc_4085                       ; 4079
  or word [cs:scb_status], strict word 0   ; 407B
  jmp near loc_417A                        ; 4082
loc_4085:
  mov bx, word [cs:scb_cbl_offset]         ; 4085
  cmp bx, 0                                ; 408A
  je short loc_4107                        ; 408D
loc_408F:
  test word [bx], 0x4000                   ; 408F
  jne short loc_40F6                       ; 4093
  cmp word [bx], 0xa000                    ; 4095
  jne short loc_40D2                       ; 4099
  inc word [cs:0x152e]                     ; 409B
  cmp word [cs:0x1530], 0                  ; 40A0
  jne short loc_40B4                       ; 40A6
  mov word [cs:0x1530], bx                 ; 40A8
  mov word [cs:0x1532], bx                 ; 40AD
  jmp short loc_40C1                       ; 40B2
loc_40B4:
  mov si, word [cs:0x1532]                 ; 40B4
  mov word [si + 4], bx                    ; 40B9
  mov word [cs:0x1532], bx                 ; 40BC
loc_40C1:
  test word [bx + 2], 0x8000               ; 40C1
  je short loc_40CD                        ; 40C6
  mov bx, 0                                ; 40C8
  jmp short loc_40F6                       ; 40CB
loc_40CD:
  mov bx, word [bx + 4]                    ; 40CD
  jmp short loc_408F                       ; 40D0
loc_40D2:
  inc word [cs:0x153f]                     ; 40D2
  mov si, word [bx + 4]                    ; 40D7
  mov ax, word [bx + 2]                    ; 40DA
  push ds                                  ; 40DD
  push bx                                  ; 40DE
  mov word [bx], 0xff                      ; 40DF
  int 0x29                                 ; 40E3
  add sp, 4                                ; 40E5
  test ax, 0x8000                          ; 40E8
  je short loc_40F2                        ; 40EB
  mov bx, 0                                ; 40ED
  jmp short loc_40F6                       ; 40F0
loc_40F2:
  mov_bx_si                                    ; mov bx, si               ; 40F2
  jmp short loc_408F                       ; 40F4
loc_40F6:
  mov word [cs:scb_cbl_offset], bx         ; 40F6
  mov dx, 0x17                             ; 40FB
  call near bdos_set_flag_dx               ; 40FE
  mov byte [cs:pending_rec_flag], 0xff     ; 4101
loc_4107:
  test word [cs:scb_status], 0x1000        ; 4107
  jne short loc_411A                       ; 410E
  or word [cs:scb_status], strict word 0   ; 4110
  jmp near loc_417A                        ; 4117
loc_411A:
  cmp byte [cs:0x1535], 0                  ; 411A
  je short loc_416D                        ; 4120
  cmp byte [cs:0x153a], 0                  ; 4122
  je short loc_416D                        ; 4128
  or word [cs:scb_status], strict word 0x0010 ; 412A
  mov si, word [cs:0x1536]                 ; 4131
  mov di, word [cs:0x153b]                 ; 4136
  mov word [si + 6], di                    ; 413B
  mov word [cs:scb_cbl_offset], si         ; 413E
  mov byte [cs:0x1535], 0                  ; 4143
  mov word [cs:0x1536], 0                  ; 4149
  mov word [cs:0x1538], 0                  ; 4150
  mov byte [cs:0x153a], 0                  ; 4157
  mov word [cs:0x153b], 0                  ; 415D
  mov word [cs:0x153d], 0                  ; 4164
  jmp short loc_417A                       ; 416B
loc_416D:
  or word [cs:scb_status], strict word 0   ; 416D
  mov byte [cs:0x1534], 0xff               ; 4174
loc_417A:
  mov dx, 0x100                            ; 417A
  in al, dx                                ; 417D
  mov al, 0x20                             ; 417E
  out 0, al                                ; 4180
  mov dx, 0xff22                           ; 4182
  mov ax, 0x8000                           ; 4185
  out dx, ax                               ; 4188
  pop ds                                   ; 4189
  popa                                     ; 418A
  mov sp, word [cs:saved_sp]               ; 418B
  mov ss, word [cs:saved_ss]               ; 4190
  pop ax                                   ; 4195
  jmp far [cs:saved_ir5_vector]            ; 4196

; ---------------------------------------------------------------------------
; Indication Acknowledge ISR
; ---------------------------------------------------------------------------
  cli                                      ; 419B
  pusha                                    ; 419C
  mov_bp_sp                                    ; mov bp, sp               ; 419D
  push ds                                  ; 419F
  lds bx, [bp + 0x16]                      ; 41A0
  cmp byte [bx], 0                         ; 41A3
  jne short loc_41AB                       ; 41A6
  jmp near loc_4236                        ; 41A8
loc_41AB:
  mov di, word [bx + 6]                    ; 41AB
  cmp di, -1                               ; 41AE
  je short loc_41FD                        ; 41B1
  cmp byte [cs:0x153a], 0                  ; 41B3
  jne short loc_41C2                       ; 41B9
  mov word [cs:0x153b], di                 ; 41BB
  jmp short loc_41CF                       ; 41C0
loc_41C2:
  mov si, word [cs:0x153d]                 ; 41C2
  and word [si + 8], 0x7fff                ; 41C7
  mov word [si + 2], di                    ; 41CC
loc_41CF:
  inc byte [cs:0x153a]                     ; 41CF
loc_41D4:
  test word [di + 8], 0x8000               ; 41D4
  jne short loc_41EF                       ; 41D9
  test word [di], 0x8000                   ; 41DB
  jne short loc_41EF                       ; 41DF
  inc byte [cs:0x153a]                     ; 41E1
  mov word [di], 0                         ; 41E6
  mov di, word [di + 2]                    ; 41EA
  jmp short loc_41D4                       ; 41ED
loc_41EF:
  mov word [di], 0                         ; 41EF
  or word [di + 8], 0x8000                 ; 41F3
  mov word [cs:0x153d], di                 ; 41F8
loc_41FD:
  inc byte [cs:0x1535]                     ; 41FD
  mov word [bx], 0                         ; 4202
  mov word [bx + 2], 0x8000                ; 4206
  mov word [bx + 6], 0xffff                ; 420B
  cmp byte [cs:0x1535], 1                  ; 4210
  jne short loc_4224                       ; 4216
  mov word [cs:0x1536], bx                 ; 4218
  mov word [cs:0x1538], bx                 ; 421D
  jmp short loc_4236                       ; 4222
loc_4224:
  mov si, word [cs:0x1538]                 ; 4224
  mov word [si + 2], 0                     ; 4229
  mov word [si + 4], bx                    ; 422E
  mov word [cs:0x1538], bx                 ; 4231
loc_4236:
  pop ds                                   ; 4236
  popa                                     ; 4237
  iret                                     ; 4238

; Interrupt State & Saved Stacks (16 bytes)
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

; Interrupt Private Stack (130 bytes)
  times 130 db 0xCC

; Pending Event Flags (2 bytes)
  db 0x00, 0x00

; ---------------------------------------------------------------------------
; Low-level SAP & Connection Lookup Helpers
; ---------------------------------------------------------------------------
loc_42CD:
  cmp al, byte [cs:sap_conn_state_base]    ; 42CD
  jne short loc_42D9                       ; 42D2
  mov si, sap_conn_state_base              ; 42D4
  clc                                      ; 42D7
  ret                                      ; 42D8
loc_42D9:
  cmp al, byte [cs:conn_flag_1f0d]         ; 42D9
  jne short loc_42E5                       ; 42DE
  mov si, conn_flag_1f0d                   ; 42E0
  clc                                      ; 42E3
  ret                                      ; 42E4
loc_42E5:
  stc                                      ; 42E5
  ret                                      ; 42E6
loc_42E7:
  push di                                  ; 42E7
  mov di, 0x1545                           ; 42E8
  xor_ah_ah                                    ; xor ah, ah               ; 42EB
  mov cx, 0x4b                             ; 42ED
  mul cx                                   ; 42F0
  add_di_ax                                    ; add di, ax               ; 42F2
  cmp word [di + 7], si                    ; 42F4
  jne short loc_4301                       ; 42F7
  mov_si_di                                    ; mov si, di               ; 42F9
  add si, 7                                ; 42FB
  clc                                      ; 42FE
  jmp short loc_430F                       ; 42FF
loc_4301:
  cmp word [di + 0x29], si                 ; 4301
  jne short loc_430E                       ; 4304
  mov_si_di                                    ; mov si, di               ; 4306
  add si, 0x29                             ; 4308
  clc                                      ; 430B
  jmp short loc_430F                       ; 430C
loc_430E:
  stc                                      ; 430E
loc_430F:
  pop di                                   ; 430F
  ret                                      ; 4310
loc_4311:
  mov al, byte [si + 6]                    ; 4311
  cmp al, 0xfe                             ; 4314
  je short loc_431B                        ; 4316
  inc byte [si + 6]                        ; 4318
loc_431B:
  mov byte [si + 0x10], al                 ; 431B
  mov es, word [cs:saved_ds]               ; 431E
  mov al, 5                                ; 4323
  stosb                                    ; 4325
  mov al, byte [si]                        ; 4326
  push si                                  ; 4328
  mov si, lan_multicast_table              ; 4329
  cmp al, 8                                ; 432C
  je short loc_433C                        ; 432E
  cmp al, 4                                ; 4330
  jne short loc_4339                       ; 4332
  mov si, lan_multicast_addr2              ; 4334
  jmp short loc_433C                       ; 4337
loc_4339:
  mov si, lan_multicast_addr3              ; 4339
loc_433C:
  mov cx, 3                                ; 433C
  rep movsw                                ; 433F
  pop si                                   ; 4341
  mov ax, word [si + 9]                    ; 4342
  stosw                                    ; 4345
  mov_ax_si                                    ; mov ax, si               ; 4346
  add ax, strict word 0x000B               ; 4348
  stosw                                    ; 434B
  mov ax, ds                               ; 434C
  stosw                                    ; 434E
  push si                                  ; 434F
  push bx                                  ; 4350
  mov cl, 0x8b                             ; 4351
  int 0xe0                                 ; 4353
  pop bx                                   ; 4355
  pop si                                   ; 4356
  mov word [si + 7], 0x3e8                 ; 4357
  ret                                      ; 435C
loc_435D:
  mov es, word [cs:saved_ds]               ; 435D
  mov al, 0                                ; 4362
  stosb                                    ; 4364
  mov_ax_si                                    ; mov ax, si               ; 4365
  stosw                                    ; 4367
  mov al, byte [si + 0x11]                 ; 4368
  stosb                                    ; 436B
  mov byte [si + 0x21], 1                  ; 436C
  push si                                  ; 4370
  mov cl, 0x8b                             ; 4371
  int 0xe0                                 ; 4373
  pop si                                   ; 4375
  ret                                      ; 4376
loc_4377:
  les di, [si + 0x15]                      ; 4377
  mov bx, word [si]                        ; 437A
  mov al, byte [bx + 6]                    ; 437C
  mov byte [es:di + 5], al                 ; 437F
  mov di, 0x151f                           ; 4383
  mov es, word [cs:saved_ds]               ; 4386
  mov al, 4                                ; 438B
  stosb                                    ; 438D
  mov_ax_si                                    ; mov ax, si               ; 438E
  stosw                                    ; 4390
  call near get_remote_conn_index          ; 4391
  stosb                                    ; 4394
  mov byte [si + 0x21], 1                  ; 4395
  push si                                  ; 4399
  mov dx, 0x1503                           ; 439A
  mov cl, 0x8b                             ; 439D
  int 0xe0                                 ; 439F
  pop si                                   ; 43A1
  ret                                      ; 43A2
loc_43A3:
  call near sap_init_indication_header     ; 43A3
  push bx                                  ; 43A6
  mov bx, 0x151f                           ; 43A7
  mov byte [bx + 0xa], 2                   ; 43AA
  mov byte [bx + 0xb], al                  ; 43AE
  mov byte [bx + 0xc], ah                  ; 43B1
  jmp near loc_43CB                        ; 43B4
loc_43B7:
  call near sap_init_indication_header     ; 43B7
  push bx                                  ; 43BA
  mov bx, 0x151f                           ; 43BB
  mov byte [bx + 0xa], 4                   ; 43BE
  mov byte [bx + 0xb], ah                  ; 43C2
  mov al, byte [si + 4]                    ; 43C5
  mov byte [bx + 0xc], al                  ; 43C8
loc_43CB:
  push si                                  ; 43CB
  push di                                  ; 43CC
  mov cl, 0x8b                             ; 43CD
  mov dx, 0x1503                           ; 43CF
  int 0xe0                                 ; 43D2
  pop di                                   ; 43D4
  pop si                                   ; 43D5
  pop bx                                   ; 43D6
  ret                                      ; 43D7
loc_43D8:
  push ax                                  ; 43D8
  push bx                                  ; 43D9
  push si                                  ; 43DA
  push es                                  ; 43DB
  push di                                  ; 43DC
  mov di, 0x151f                           ; 43DD
  mov es, word [cs:saved_ds]               ; 43E0
  mov al, 2                                ; 43E5
  stosb                                    ; 43E7
  mov_si_bx                                    ; mov si, bx               ; 43E8
  add si, 0xe                              ; 43EA
  mov cx, 3                                ; 43ED
  rep movsw                                ; 43F0
  pop di                                   ; 43F2
  pop es                                   ; 43F3
  pop si                                   ; 43F4
  mov al, byte [es:di + 1]                 ; 43F5
  mov bx, 0x151f                           ; 43F9
  mov byte [bx + 7], al                    ; 43FC
  mov al, byte [es:di]                     ; 43FF
  mov byte [bx + 8], al                    ; 4402
  mov byte [bx + 9], 3                     ; 4405
  pop bx                                   ; 4409
  pop ax                                   ; 440A
  ret                                      ; 440B

; LAN Controller Reset Flag Byte (1 bytes)
  db 0x00

; ---------------------------------------------------------------------------
; LAN Controller Reset Helper
; ---------------------------------------------------------------------------
  cmp byte [cs:lan_reset_flag], 0xff       ; 440D
  jne short loc_441B                       ; 4413
  mov ax, 0x80                             ; 4415
  call near channel_attention_delay        ; 4418
loc_441B:
  retf                                     ; 441B

; ---------------------------------------------------------------------------
; Channel Attention Trigger & Flag Sync
; ---------------------------------------------------------------------------
loc_441C:
  pushf                                    ; 441C
  cli                                      ; 441D
loc_441E:
  cmp word [cs:scb_status], 0              ; 441E
  jne short loc_441E                       ; 4424
  mov word [cs:scb_status], ax             ; 4426
  mov dx, 0x100                            ; 442A
  in al, dx                                ; 442D
  popf                                     ; 442E
  ret                                      ; 442F
loc_4430:
  mov ax, word [si + 0x19]                 ; 4430
  sub ax, 0x1545                           ; 4433
  xor_dx_dx                                    ; xor dx, dx               ; 4436
  mov cx, 0x4b                             ; 4438
  div cx                                   ; 443B
  ret                                      ; 443D
loc_443E:
  push ds                                  ; 443E
  mov ds, word [cs:saved_stacks]           ; 443F
  mov cx, 0x84                             ; 4444
  call far [cs:saved_bdos_vector]          ; 4447
  pop cx                                   ; 444C
  mov ds, cx                               ; 444D
  mov es, cx                               ; 444F
  ret                                      ; 4451
loc_4452:
  push ds                                  ; 4452
  mov ds, word [cs:saved_stacks]           ; 4453
  mov cx, 0x85                             ; 4458
  call far [cs:saved_bdos_vector]          ; 445B
  pop ds                                   ; 4460
  ret                                      ; 4461

; ---------------------------------------------------------------------------
; Trailing Padding to 16-byte boundary
; ---------------------------------------------------------------------------
  times TRAILING_PAD db 0


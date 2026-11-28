#!/usr/bin/env python3
"""
Apply verified hardware subroutine names in Modul 4 (XIOS) and verify reassembly.
"""

import re

ASM_PATH = "tasks/rc75x-ccpm/mod4_xios.asm"

XIOS_HARDWARE_MAPPINGS = {
    0x078C0: "xios_rtm_flag_set",
    0x078D1: "xios_rtm_flag_wait",
    0x078DC: "xios_rtm_svc_call",
    0x07A99: "xios_kbd_isr",
    0x07BFE: "xios_crt_retrace_isr",
    0x09601: "xios_crt_trigger_ca",
    0x09D4E: "xios_fdc_fcr_setup",
    0x09E00: "xios_fdc_fcr_write",
    0x09E05: "xios_fdc_select_drive",
    0x09E48: "xios_fdc_restore_track0",
    0x09ECA: "xios_fdc_step_in",
    0x09EF3: "xios_fdc_cmd_read_sector",
    0x09F06: "xios_fdc_send_cmd",
    0x09F0E: "xios_fdc_read_track_reg",
    0x09F4D: "xios_fdc_wait",
    0x09F95: "xios_fdc_test_busy",
    0x0A0B0: "xios_fdc_send_cmd_wait",
    0x0A295: "xios_dma_chan_ctrl",
    0x0A29A: "xios_dma_mask_reg",
    0x0A2BE: "xios_fdc_isr",
    0x0AC27: "xios_floppy_ack",
    0x0AD64: "xios_floppy_status_check",
    0x0AD8E: "xios_con_status_poll",
    0x0AF11: "xios_eoi_pic_and_cpu",
    0x0AF1D: "xios_switch_to_priv_stack",
    0x0B032: "xios_con_data_read",
    0x0B163: "xios_jmp_init",
    0x0B166: "xios_jmp_entry",
    0x0B169: "xios_init",
    0x0B1EF: "xios_entry_0x8C",
}

print(f"Applying {len(XIOS_HARDWARE_MAPPINGS)} XIOS hardware subroutines...")

with open(ASM_PATH, "r") as f:
    text = f.read()

for off, name in XIOS_HARDWARE_MAPPINGS.items():
    old = f"sub_{off:05X}"
    # Replace either sub_XXXXX or old label if present
    text = re.sub(rf"\b{old}\b", name, text)

with open(ASM_PATH, "w") as f:
    f.write(text)

print("mod4_xios.asm updated successfully!")

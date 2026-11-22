#!/usr/bin/env python3
"""
disassemble_bootrom.py — 1-til-1 disassembler og annotering af RC759 Piccoline Boot PROM v2.1.
Genererer en komplet, annoteret assembly-fil samt symbol- og funktionskort.
"""

import os
import sys
import struct
import ctypes
import re

class DisOp(ctypes.Structure):
    _fields_ = [
        ("flags", ctypes.c_uint),
        ("seg", ctypes.c_uint),
        ("ip", ctypes.c_ushort),
        ("dat_n", ctypes.c_uint),
        ("dat", ctypes.c_ubyte * 16),
        ("op", ctypes.c_char * 64),
        ("arg_n", ctypes.c_uint),
        ("arg1", ctypes.c_char * 64),
        ("arg2", ctypes.c_char * 64),
    ]

ROM_PATH = "mame/roms/rc759/rc759-1-2.1.rom"
LIB_PATH = "scratch/rc759-bootprom/libdis86.dylib"
OUT_ASM  = "tasks/rc759-bootprom/rc759_bootloader_v2.1.asm"
OUT_MAP  = "tasks/rc759-bootprom/bootprom_map.txt"
TASK_DIR = os.path.dirname(OUT_ASM)

# Known labels (code offset in segment FB84 -> name)
KNOWN_CODE_LABELS = {
    0x0004: "cold_boot_entry",
    0x0084: "init_pic_8259",
    0x00A3: "init_i186_timer0",
    0x00D9: "init_palette",
    0x011C: "serial_tx_banner_loop",
    0x0187: "char_out_helper",
    0x01BF: "clear_screen_or_cursor",
    0x0279: "set_cursor_pos",
    0x0298: "conout_char",
    0x03AC: "print_string_es_ax",
    0x03C9: "wait_key_press",
    0x03D3: "read_key_poll",
    0x03F6: "check_hotkey_ctrl_alt_del",
    0x0428: "isr_keyboard_int1",
    0x04D1: "test_prom_checksum",
    0x0548: "test_crt_vram_start",
    0x056E: "test_crt_vram_verify",
    0x05B2: "error_crt_vram",
    0x066C: "init_video_and_fonts",
    0x06A9: "load_fonts_50hz",
    0x06DB: "load_fonts_60hz",
    0x0736: "init_82730_buffers",
    0x076F: "setup_82730_cb_scb",
    0x0828: "check_warm_boot_skip_memtest",
    0x0831: "delay_40k_and_show_banner",
    0x086B: "test_system_ram_start",
    0x0896: "ram_write_loop",
    0x0918: "ram_verify_loop",
    0x0988: "error_ram_memory",
    0x098C: "ram_test_passed",
    0x0A44: "post_ram_test_return",
    0x0A4F: "skip_memtest_dest",
    0x0A60: "isr_82730_command_done",
    0x0AE5: "issue_82730_channel_attention",
    0x0B2B: "setup_interrupt_vectors",
    0x0B5B: "clear_memory_words",
    0x0BBE: "busy_loop_delay_ax",
    0x0BC8: "timer_tick_wait_ax",
    0x0BD7: "init_video_buffers_and_selftest",
    0x0CFF: "selftest_countdown_loop",
    0x0D28: "start_bootloader_sequence",
    0x1110: "selftest_check_keyboard",
    0x117C: "menu_list_of_tests",
    0x12DE: "menu_show_hw_config",
    0x1354: "cursor_blink_handler",
    0x1436: "mute_sound_chip",
    0x144F: "selftest_status_display",
    0x1470: "selftest_poll_devices",
    0x2178: "menu_enter_snooper",
    0x2700: "bootloader_main_entry",
    0x278C: "boot_device_table",
    0x27AC: "boot_from_floppy_a_or_b",
    0x27CE: "boot_from_network",
    0x37A3: "fdc_boot_read_sector",
    0x389E: "validate_boot_device_char",
    0x38DE: "init_fdc_hardware",
    0x3906: "fdc_recalibrate_track0",
    0x39FC: "fdc_wait_ready_timeout",
    0x3A55: "fdc_read_sector_dma",
    0x3BA2: "fdc_compute_geometry",
    0x3BBA: "nvram_read_byte_al",
    0x3BEC: "nvram_write_byte_al",
    0x3CE1: "fdc_check_status",
    0x3D0D: "fdc_motor_off",
    0x3D24: "fdc_release_bus",
    0x3D3E: "fdc_reserve_bus",
    0x3E3B: "boot_setup_memory_params",
}

# Known data labels (ROM offset -> name)
KNOWN_DATA_LABELS = {
    0x0000: "i82730_header_and_signature",
    0x0005: "i82730_scb_block",
    0x000C: "i82730_cb_block",
    0x0032: "i82730_mode_params_50hz",
    0x0068: "i82730_mode_params_60hz",
    0x009E: "special_glyphs_01_to_1f",
    0x01DD: "font_table_50hz",
    0x0D40: "font_table_60hz",
    0x2162: "table_keyboard_scancodes",
    0x21D2: "str_prom_checksum_error",
    0x21E9: "str_ram_memory_error",
    0x21FC: "str_memory_test_header",
    0x2248: "prototype_ivt_table",
    0x22B8: "str_snooper_banner",
    0x2379: "str_piccoline_test_banner",
    0x2396: "str_piccoline_selftest_banner",
    0x23CD: "str_error_details_format",
    0x247A: "str_menu_header",
    0x2512: "str_hw_config_header",
    0x2609: "diag_test_table",
    0x26E7: "str_ram_refresh_test",
    0x2707: "str_i186_timer_test",
    0x2724: "str_i186_dma_test",
    0x2743: "str_8259_interrupt_test",
    0x277E: "str_keyboard_test",
    0x27A7: "str_lan_82586_test",
    0x27D5: "str_ppi_8255_test",
    0x27EF: "str_nvram_test",
    0x280D: "str_centronics_test",
    0x283B: "str_cassette_test",
    0x2859: "str_display_test",
    0x2887: "str_flexible_disk_test",
    0x317A: "str_bootloader_banner",
    0x319A: "str_boot_error_messages",
    0x320C: "str_load_medium_options",
    0x3348: "str_default_os_filename",
    0x336B: "str_network_boot_errors",
    0x35E0: "str_net_params_menu",
    0x3840: "rom_segment_header_f800",
    0x7F88: "reset_entry_fff8_0008",
    0x7FF0: "reset_vector_ffff_0000",
}

# I/O port equates and hardware symbols
IO_PORT_SYMBOLS = {
    0x0000: ("io_pic_icw1", "8259A PIC ICW1 (Base port 00h)"),
    0x0002: ("io_pic_icw2_ocw", "8259A PIC ICW2/OCW (Base vector 20h)"),
    0x0020: ("io_kbd_data", "Keyboard Data / Status register"),
    0x0056: ("io_sn76494_sound", "SN76494 Sound Generator (Volume / Frequency)"),
    0x005A: ("io_rtc_data", "MM58167 RTC Data register"),
    0x005C: ("io_rtc_addr", "MM58167 RTC Address / Control register"),
    0x0060: ("io_i82730_ca", "82730 Channel Attention (CA) trigger"),
    0x0070: ("io_ppi_porta", "8255 PPI Port A (Memory size, Cassette, iSBX)"),
    0x0072: ("io_ppi_portb", "8255 PPI Port B (Monitor type 50/60Hz, RTC type)"),
    0x0074: ("io_ppi_portc", "8255 PPI Port C (Kbd enable, Gfx mode, NVRAM bank)"),
    0x0076: ("io_ppi_ctrl", "8255 PPI Control word (Mode setup)"),
    0x0080: ("io_nvram_base", "NVRAM start (128 bytes bank-switched, 80h-FFh)"),
    0x0180: ("io_palette_base", "Palette RAM base (180h - 19Fh)"),
    0x0230: ("io_i82730_reset", "Intel 82730 CRT Text Coprocessor Reset (IRST)"),
    0x0240: ("io_i82730_ca_pulse", "Intel 82730 Channel Attention (CA pulse)"),
    0x0250: ("io_centronics_data", "Centronics Printer Data register"),
    0x0260: ("io_centronics_ctrl", "Centronics Printer Control register"),
    0x0280: ("io_wd2797_status_cmd", "WD2797 FDC Status / Command register"),
    0x0282: ("io_wd2797_track", "WD2797 FDC Track register"),
    0x0284: ("io_wd2797_sector", "WD2797 FDC Sector register"),
    0x0286: ("io_wd2797_data", "WD2797 FDC Data register"),
    0x0288: ("io_floppy_ctrl", "Floppy Control register (Motor 0/1, Drive sel, DDEN)"),
    0x028C: ("io_floppy_ext", "Floppy Extended register"),
    0x028E: ("io_floppy_reserve_ack", "Floppy Reserve / Acknowledge register"),
    0x0290: ("io_floppy_release", "Floppy Release register"),
    0x0292: ("io_floppy_status_aux", "Floppy Auxiliary Status register"),
    0x0294: ("io_floppy_param", "Floppy Parameter register"),
    0x0300: ("io_isbx0_data", "iSBX Multimodule Slot 0 Data (8274 / 8251 serial)"),
    0x0302: ("io_isbx0_ctrl", "iSBX Multimodule Slot 0 Control / Status"),
    0x0314: ("io_isbx1_data", "iSBX Multimodule Slot 1 Data"),
    0x0316: ("io_isbx1_ctrl", "iSBX Multimodule Slot 1 Control / Status"),
    0xFF22: ("io_i186_eoi", "80186 INTC End-Of-Interrupt (EOI) register"),
    0xFF28: ("io_i186_int_mask", "80186 INTC Interrupt Mask register"),
    0xFF30: ("io_i186_timer_int_ctrl", "80186 INTC Timer Interrupt Control register"),
    0xFF32: ("io_i186_dma0_int_ctrl", "80186 INTC DMA 0 Interrupt Control register"),
    0xFF34: ("io_i186_dma1_int_ctrl", "80186 INTC DMA 1 Interrupt Control register"),
    0xFF38: ("io_i186_int1_ctrl", "80186 INTC INT 1 Control register"),
    0xFF3A: ("io_i186_int2_ctrl", "80186 INTC INT 2 Control register"),
    0xFF3E: ("io_i186_int_poll", "80186 INTC Interrupt Poll register"),
    0xFF50: ("io_i186_timer0_count", "80186 Timer 0 Count register (T0CNT)"),
    0xFF52: ("io_i186_timer0_max_a", "80186 Timer 0 Max Count A register (T0CMPA)"),
    0xFF54: ("io_i186_timer0_max_b", "80186 Timer 0 Max Count B register (T0CMPB)"),
    0xFF56: ("io_i186_timer0_ctrl", "80186 Timer 0 Mode / Control register (T0CON)"),
    0xFF58: ("io_i186_timer1_count", "80186 Timer 1 Count register (T1CNT)"),
    0xFF5A: ("io_i186_timer1_max_a", "80186 Timer 1 Max Count A register (T1CMPA)"),
    0xFF5C: ("io_i186_timer1_max_b", "80186 Timer 1 Max Count B register (T1CMPB)"),
    0xFF5E: ("io_i186_timer1_ctrl", "80186 Timer 1 Mode / Control register (T1CON)"),
    0xFF60: ("io_i186_timer2_count", "80186 Timer 2 Count register (T2CNT)"),
    0xFF62: ("io_i186_timer2_max_a", "80186 Timer 2 Max Count A register (T2CMPA)"),
    0xFF66: ("io_i186_timer2_ctrl", "80186 Timer 2 Mode / Control register (T2CON)"),
    0xFFA0: ("io_i186_umcs", "80186 UMCS (Upper Memory Chip Select: Boot ROM 32KB)"),
    0xFFA2: ("io_i186_pacs", "80186 PACS (Peripheral Chip Select: Base 0000h)"),
    0xFFA4: ("io_i186_lmcs", "80186 LMCS (Lower Memory Chip Select: Base RAM)"),
    0xFFA6: ("io_i186_mpcs", "80186 MPCS (Mid-Range Memory / Peripheral Chip Select)"),
    0xFFA8: ("io_i186_mmcs", "80186 MMCS (Mid-Range Memory Chip Select: CRT-RAM D0000h)"),
    0xFFC0: ("io_i186_dma0_src_lo", "80186 DMA 0 Lower Source Address"),
    0xFFC2: ("io_i186_dma0_src_hi", "80186 DMA 0 Upper Source Address"),
    0xFFC4: ("io_i186_dma0_dst_lo", "80186 DMA 0 Lower Destination Address"),
    0xFFC6: ("io_i186_dma0_dst_hi", "80186 DMA 0 Upper Destination Address"),
    0xFFC8: ("io_i186_dma0_count", "80186 DMA 0 Transfer Count"),
    0xFFCA: ("io_i186_dma0_ctrl", "80186 DMA 0 Control register"),
    0xFFD0: ("io_i186_dma1_src_lo", "80186 DMA 1 Lower Source Address"),
    0xFFD2: ("io_i186_dma1_src_hi", "80186 DMA 1 Upper Source Address"),
    0xFFD4: ("io_i186_dma1_dst_lo", "80186 DMA 1 Lower Destination Address"),
    0xFFD6: ("io_i186_dma1_dst_hi", "80186 DMA 1 Upper Destination Address"),
    0xFFD8: ("io_i186_dma1_count", "80186 DMA 1 Transfer Count"),
    0xFFDA: ("io_i186_dma1_ctrl", "80186 DMA 1 Control register"),
    0xFFFE: ("io_i186_pcb_reloc", "80186 PCB Relocation Register"),
}

def replace_io_symbols(mnemonic, args_str):
    """Replace raw I/O port numbers with symbolic equates."""
    op = mnemonic.strip().upper()
    if op == "MOV":
        m = re.match(r"^DX\s*,\s*0*([0-9A-Fa-f]{1,4})[Hh]?$", args_str.strip(), re.IGNORECASE)
        if m:
            val = int(m.group(1), 16)
            if val in IO_PORT_SYMBOLS:
                return f"DX, {IO_PORT_SYMBOLS[val][0]}"
    elif op == "IN":
        m = re.match(r"^(AL|AX)\s*,\s*0*([0-9A-Fa-f]{1,4})[Hh]?$", args_str.strip(), re.IGNORECASE)
        if m:
            val = int(m.group(2), 16)
            if val in IO_PORT_SYMBOLS:
                return f"{m.group(1)}, {IO_PORT_SYMBOLS[val][0]}"
    elif op == "OUT":
        m = re.match(r"^0*([0-9A-Fa-f]{1,4})[Hh]?\s*,\s*(AL|AX)$", args_str.strip(), re.IGNORECASE)
        if m:
            val = int(m.group(1), 16)
            if val in IO_PORT_SYMBOLS:
                return f"{IO_PORT_SYMBOLS[val][0]}, {m.group(2)}"
    return args_str

def render_bits8(b):
    return "".join("#" if (b & (1 << (7 - i))) else "." for i in range(8))

def format_char_desc(c):
    if 32 <= c <= 126:
        return f"'{chr(c)}'"
    elif c == 0x86:
        return "'æ' / 'å'"
    elif c == 0x8F:
        return "'Å'"
    elif c == 0x91:
        return "'æ'"
    elif c == 0x92:
        return "'Æ'"
    elif c == 0x9B:
        return "'ø'"
    elif c == 0x9D:
        return "'Ø'"
    else:
        return f"char {c:02X}h"

# RAM scratchpad variables and hardware data allocations (Segment 0000h)
RAM_SCRATCHPAD_SYMBOLS = {
    # System base segments (defined at FB84:0000 and FB84:0002 in code segment)
    0x0000: ("rom_segment_base", "DW", "Base segment for ROM data (F800h)"),
    0x0002: ("ram_segment_base", "DW", "Base segment for RAM (0000h)"),

    # DMA Channel 0 cached I/O registers & accumulators (0001h - 0013h)
    0x0001: ("var_dma0_status", "DB", "DMA Channel 0 statusflag"),
    0x0003: ("var_dma0_channel_id", "DB", "DMA aktiv kanal-ID"),
    0x0004: ("var_dma0_byte_count", "DW", "DMA overførsels-akkumulator"),
    0x0006: ("var_dma0_mode_flags", "DB", "DMA mode kontrolflag"),
    0x0007: ("var_dma0_reg_dest_hi", "DW", "Cached I/O port: FFC6h (DMA 0 Dest Hi)"),
    0x0009: ("var_dma0_reg_dest_lo", "DW", "Cached I/O port: FFC4h (DMA 0 Dest Lo)"),
    0x000B: ("var_dma0_reg_src_hi", "DW", "Cached I/O port: FFC2h (DMA 0 Src Hi)"),
    0x000D: ("var_dma0_reg_src_lo", "DW", "Cached I/O port: FFC0h (DMA 0 Src Lo)"),
    0x000F: ("var_dma0_reg_count", "DW", "Cached I/O port: FFC8h (DMA 0 Transfer Count)"),
    0x0011: ("var_dma0_reg_control", "DW", "Cached I/O port: FFCAh (DMA 0 Control Word)"),

    # Boot loader / Drive parameters (0014h - 001Dh)
    0x0014: ("var_boot_status", "DB", "Resultat af sektor 1 indlæsning (FFh = gyldig bootsektor)"),
    0x0015: ("var_boot_drive_table", "BYTES 4", "Drev-tabel og status for floppy drev A, B, C, D (4 bytes, 0015h-0018h)"),
    0x0019: ("var_boot_device_char", "DB", "Aktivt boot-medie tegn ('A'=Floppy, 'N'=Net, 'M'=PROM)"),
    0x001A: ("var_boot_entry_addr", "DD", "32-bit far pointer til startadresse for indlæst bootsektor"),

    # Floppy configuration & parameters (005Dh - 0081h)
    0x005D: ("var_boot_retry_counter", "DB", "Antal gensøgningsforsøg ved diskfejl"),
    0x005E: ("var_boot_step_rate", "DB", "FDC stepping rate parameter"),
    0x005F: ("var_boot_head_settle", "DB", "FDC head settle time parameter"),
    0x0060: ("var_floppy_motor_off_delay", "DW", "FDC motor-off forsinkelsestæller"),
    0x0062: ("var_floppy_motor_timer", "DB", "Diskette motor off timeout"),
    0x0063: ("var_floppy_target_drive", "DB", "Valgt diskettedrev buffer (0=A, 1=B, 2=C, 3=D)"),
    0x0064: ("var_floppy_current_drive", "DB", "Nuværende aktive diskettedrev"),
    0x0065: ("var_nvram_valid_magic", "DB", "NVRAM valideringsbyte (skal matche AAh)"),
    0x0066: ("var_nvram_checksum", "DB", "NVRAM beregnet kontrolsum"),
    0x0067: ("var_boot_drive_preselect", "DB", "Forvalgt bootdrev fra tastatur under countdown ('A', 'B', ...)"),
    0x0068: ("var_floppy_boot_unit", "DB", "Diskette bootdrev enhedsnummer"),
    0x0069: ("var_floppy_boot_flag", "DB", "Diskette boot aktiv flag (sat til 1 ved boot)"),
    0x006A: ("var_floppy_drive_type", "DB", "Diskettedrev type (3.5 / 5.25 tommer)"),
    0x006B: ("var_floppy_sector_num", "DW", "Sektornummer til diskette-læsning"),
    0x006D: ("var_floppy_buffer_ptr", "DW", "RAM-bufferadresse til indlæst diskettesektor"),
    0x006F: ("var_floppy_head_num", "DW", "Aktivt diskettehoved (0 eller 1)"),
    0x0071: ("var_floppy_media_density", "DW", "Diskette mediadensitet (FM / MFM)"),
    0x0073: ("var_floppy_track_num", "DW", "Spurnummer til diskette-læsning"),
    0x0075: ("var_floppy_last_seek", "DW", "Sidste søgte spor / kalibrering"),
    0x0077: ("var_floppy_step_delay", "DW", "FDC stepping forsinkelse ord"),
    0x0079: ("var_floppy_bytes_per_sec", "DB", "Bytes pr. sektor kode"),
    0x007A: ("var_floppy_sectors_per_trk", "DW", "Sektorer pr. spor"),
    0x007C: ("var_floppy_gap_length", "DW", "FDC gap length parameter"),
    0x007E: ("var_floppy_data_length", "DW", "FDC data length parameter"),
    0x0080: ("var_nvram_boot_default", "DW", "Standard boot-enhed læst fra NVRAM"),

    # Screen / 82730 Display parameters (00C7h - 011Fh)
    0x00C7: ("var_screen_tab_stop", "DW", "Tabulatorstop interval"),
    0x00C9: ("var_screen_bell_duration", "DB", "Bip-varighed for skærm-klokke"),
    0x00CA: ("var_screen_bell_pitch", "DB", "Tonehøjde for skærm-klokke"),
    0x00CB: ("var_screen_esc_state", "DB", "ANSI / VT escape-sekvens dekodningstilstand"),
    0x00CC: ("var_screen_esc_param1", "DB", "ANSI escape parameter 1"),
    0x00CD: ("var_screen_esc_param2", "DB", "ANSI escape parameter 2"),
    0x00CE: ("var_screen_char_temp", "DB", "Midlertidigt skærmtegn"),
    0x00CF: ("var_screen_attrib_temp", "DB", "Midlertidig skærm-attribut"),
    0x00D0: ("var_screen_insert_mode", "DB", "Indsætningstilstand (insert mode) flag"),
    0x00D1: ("var_screen_keyclick_en", "DB", "Tastatur-klik lyd aktiveringsflag"),
    0x00D2: ("var_screen_cursor_type", "DW", "Markørtype (blok / understregning / skjult)"),
    0x00D4: ("var_screen_page_offset", "DW", "Side-offset i skærmhukommelse"),
    0x00D6: ("var_screen_line_wrap", "DB", "Automatisk linjeskift flag"),
    0x00D7: ("var_screen_reverse_video", "DB", "Inverteret video (reverse) flag"),
    0x00D8: ("var_screen_charset_mode", "DB", "Tegnsæt-tilstand (G0/G1/grafik)"),
    0x00D9: ("var_screen_field_attr", "DB", "Aktivt feltattribut"),
    0x00DA: ("var_screen_underl_attr", "DB", "Understregnings-attribut"),
    0x00DB: ("var_screen_font_select", "DB", "Aktivt skærmtegnsæt (50Hz / 60Hz)"),
    0x00DC: ("var_screen_dim_attr", "DB", "Dæmpet/halv lysstyrke attribut"),
    0x00DD: ("var_screen_color_mode", "DB", "Farve / monokrom tilstand"),
    0x00DE: ("var_screen_active_page", "DB", "Aktiv skærmside nummer"),
    0x00DF: ("var_screen_display_flags", "DB", "Skærm-status og opdateringsflag"),
    0x00E0: ("var_screen_cursor_col", "DW", "Aktiv tekstmarkør kolonneposition (0 - 79)"),
    0x00E2: ("var_screen_cursor_row", "DW", "Aktiv tekstmarkør rækkeposition (0 - 24)"),
    0x00E4: ("var_screen_buffer_base", "DW", "Skærmbuffer basesegment i RAM (3000h)"),
    0x00E6: ("var_screen_attribute", "DW", "Aktiv skærm-attribut (farve, fremhævning, inverteret)"),
    0x00E8: ("var_screen_window_top", "DW", "Skærmvindue top-linje"),
    0x00EA: ("var_screen_window_bottom", "DW", "Skærmvindue bund-linje"),
    0x00EC: ("var_screen_window_left", "DW", "Skærmvindue venstre kolonne"),
    0x00EE: ("var_screen_window_right", "DW", "Skærmvindue højre kolonne"),
    0x00F0: ("var_screen_scroll_count", "DW", "Antal linjer der skal scrolles"),
    0x00F2: ("var_screen_scroll_direction", "DW", "Scroll-retning (0=op, 1=ned)"),
    0x00F4: ("var_screen_fill_char", "DW", "Udfyldningstegn ved scroll / ryd"),
    0x00F6: ("var_screen_fill_attr", "DW", "Udfyldningsattribut"),
    0x00F8: ("var_screen_status_buffer", "BYTES 6", "Skærm-status descriptor buffer (6 bytes, 00F8h-00FDh)"),
    0x00FE: ("var_82730_row_table_ptr", "DW", "Pointer til aktiv rækketabel i 82730 displaybuffer"),
    0x0100: ("var_82730_row_attrib", "DW", "82730 rækkeattribut ord"),
    0x0102: ("var_82730_ctrl_flags", "DW", "82730 interne kontrolflag"),
    0x0104: ("var_82730_sync_status", "DW", "82730 synkroniseringsstatus"),
    0x0106: ("var_82730_frame_count", "DW", "82730 billedtæller / VSYNC frames"),
    0x0108: ("var_lan_packet_header", "BYTES 24", "Netværks/konsol pakkestyreblok (24 bytes, 0108h-011Fh)"),

    # Selftest & POST diagnostics (0120h - 013Fh)
    0x0120: ("var_selftest_error_flags", "DB", "Diagnostisk fejlstatus (00h = alt OK, 01h = fejl)"),
    0x0121: ("var_selftest_error_subcode", "DB", "Detaljeret fejlkode / fejlet register for hardwaretest"),
    0x0122: ("var_selftest_failing_reg", "DB", "Fejlet register-ID under selftest"),
    0x0123: ("var_selftest_error_count", "DW", "Akkumuleret antal hardwarefejl under selftest"),
    0x0125: ("var_selftest_failing_dev", "DB", "ID på fejlet hardware-enhed (FDC, LAN, Timer, DMA, etc.)"),
    0x0126: ("var_selftest_dev_subindex", "DB", "Underindeks på fejlet hardwareenhed"),
    0x0127: ("var_selftest_loop_count", "DW", "Løkke-tæller ved gentagne diagnostiske tests"),
    0x0129: ("var_selftest_pattern", "DW", "Diagnostisk testmønster ord"),
    0x012B: ("var_selftest_dma_timer", "DW", "Diagnostisk DMA/timer timeout tæller"),
    0x012D: ("var_boot_status_flags", "DW", "Boot-status & warm-boot flag word (bit 9=spring RAM-test over, bit 11=fortsæt)"),
    0x012F: ("var_kbd_ctrl_alt_state", "DB", "Tastatur modifier status (Ctrl + Alt detektering)"),
    0x0130: ("var_kbd_shift_state", "DB", "Tastatur Shift-tast tracking"),
    0x0131: ("var_kbd_caps_lock_state", "DB", "Tastatur Caps Lock tilstand"),
    0x0132: ("var_kbd_key_ready", "DB", "Tastatur event-flag (FFh = tastetryk klar i buffer)"),
    0x0133: ("var_kbd_ascii_char", "DB", "Modtaget ASCII tegn fra tastaturet"),
    0x0134: ("var_kbd_raw_scancode", "DB", "Rå scancode fra tastatur-controller"),
    0x0135: ("var_timer0_tick_count", "DW", "Timer 0 interrupt tæller (opdateres hvert 10 ms af timer ISR)"),
    0x0137: ("var_console_cursor_pos", "DW", "Aktiv konsol markørposition (AL=kolonne, AH=række)"),
    0x0139: ("var_boot_countdown_sec", "DB", "Nedtællingssekunder for bootprompt (10 sekunder nedtælling)"),

    # Network / LAN 82586 Subsystem (Segment 0000:4Bxx)
    0x4B00: ("var_lan_rx_base_buf", "BYTES 24", "LAN modtagebuffer startområde (24 bytes, 4B00h-4B17h)"),
    0x4B18: ("var_lan_desc_ptr", "DW", "LAN buffer descriptor pointer"),
    0x4B1A: ("var_lan_desc_len", "DW", "LAN buffer descriptor længde"),
    0x4B1C: ("var_lan_desc_flags", "DW", "LAN buffer descriptor kontrolflag"),
    0x4B1E: ("var_lan_station_id", "DW", "Ethernet/LAN lokal maskin-adresse (82586 station ID)"),
    0x4B20: ("var_lan_server_id", "DB", "Ethernet/LAN boot-server adresse"),
    0x4B21: ("var_lan_client_ip_lo", "DW", "Klient netværksadresse lav"),
    0x4B23: ("var_lan_client_ip_hi", "DW", "Klient netværksadresse høj"),
    0x4B25: ("var_lan_subnet_mask", "DW", "Netværks subnet maske"),
    0x4B27: ("var_lan_gateway_id", "DW", "Netværks gateway station"),
    0x4B29: ("var_lan_retry_limit", "DW", "Maksimalt antal genudsendelser"),
    0x4B2B: ("var_lan_packet_len", "DW", "Modtaget netværkspakke længde"),
    0x4B2D: ("var_lan_rx_status", "DW", "Netværks modtage-status flag"),
    0x4B2F: ("var_lan_response_buf", "BYTES 5", "Netværks svarmodtagelse buffer (5 bytes, 4B2Fh-4B33h)"),
    0x4B34: ("var_lan_tx_timeout", "DB", "Sende-timeout tæller"),
    0x4B35: ("var_lan_protocol_type", "DB", "Protokoltype (NDOS / CCP/M Net)"),
    0x4B36: ("var_lan_buffer_offset", "DB", "Netværks DMA buffer-adresse"),
    0x4B37: ("var_lan_command_code", "DB", "Netværks kommando / NDOS protokolkode"),
    0x4B38: ("var_lan_sub_command", "DB", "Netværks underkommando"),
    0x4B39: ("var_lan_param_buf", "BYTES 8", "Netværks parameter buffer (8 bytes, 4B39h-4B40h)"),
    0x4B41: ("var_lan_window_size", "DB", "Pakkestrøm vinduesstørrelse"),
    0x4B42: ("var_lan_ack_expected", "DB", "Forventet kvitteringsnummer"),
    0x4B43: ("var_lan_last_ack", "DB", "Sidst modtagne kvittering"),
    0x4B44: ("var_lan_sequence_num", "DB", "Netværkspakke sekvensnummer"),
    0x4B45: ("var_lan_tx_packets", "DB", "Sendte pakker tæller"),
    0x4B46: ("var_lan_rx_packets", "DB", "Modtagne pakker tæller"),
    0x4B47: ("var_lan_nak_count", "DB", "Modtagne NAK tæller"),
    0x4B48: ("var_lan_crc_error_count", "DB", "Modtagne CRC fejl tæller"),
    0x4B49: ("var_lan_collision_count", "DB", "Ethernet kollisionstæller"),
    0x4B4A: ("var_lan_mac_address", "BYTES 6", "Ethernet hardware MAC-adresse (6 bytes, 4B4Ah-4B4Fh)"),
    0x4B50: ("var_lan_multicast_flag", "DB", "Multicast modtageflag"),
    0x4B51: ("var_lan_tx_packet_buf", "BYTES 36", "Netværks sendepakkebuffer (36 bytes, 4B51h-4B74h)"),
    0x4B75: ("var_lan_scb_status", "DW", "82586 System Control Block status"),
    0x4B77: ("var_lan_scb_command", "DB", "82586 SCB kommandoord"),
    0x4B78: ("var_lan_timeout_counter", "DB", "Timeout tæller for netværkssvar"),
    0x4B79: ("var_lan_boot_entry", "DW", "32-bit entry point for netværks-bootet OS"),
    0x4B7B: ("var_lan_dma_channel", "DW", "DMA kanal til 82586"),
    0x4B7D: ("var_lan_irq_vector", "DW", "Afbrudsvektor for LAN interrupt"),
    0x4B7F: ("var_lan_tx_buffer_ptr", "DW", "Sendebuffer pointer"),
    0x4B81: ("var_lan_rx_buffer_ptr", "DW", "Modtagebuffer pointer"),
    0x4B83: ("var_lan_alt_mac_addr", "BYTES 6", "Alternativ Ethernet MAC-adresse (6 bytes, 4B83h-4B88h)"),
    0x4B89: ("var_lan_conn_state_block", "BYTES 8", "Netværks forbindelsesblok (8 bytes, 4B89h-4B90h)"),
    0x4B91: ("var_lan_frame_error_count", "DB", "Modtagne fejlrammer (CRC / Alignment)"),
    0x4B92: ("var_lan_activity_flag", "DB", "Netværksaktivitets-indikator"),
    0x4B93: ("var_lan_link_status", "DB", "Fysisk kabel / link status"),
    0x4B94: ("var_lan_last_error", "DB", "Sidste rapporterede netværksfejlkode"),
    0x4B95: ("var_lan_connection_state", "DB", "Forbindelsestilstand"),
    0x4B96: ("var_lan_remote_port", "DB", "Fjernport nummer"),
    0x4B97: ("var_lan_remote_node_params", "BYTES 6", "Fjernstations parametre (6 bytes, 4B97h-4B9Ch)"),
    0x4B9D: ("var_lan_local_port", "DB", "Lokal port nummer"),
    0x4B9E: ("var_lan_tx_retry_count", "DB", "Sendeforsøg tæller"),
    0x4B9F: ("var_lan_rx_ready_flag", "DB", "Pakke modtaget og klar til behandling"),
    0x4BA0: ("var_lan_rx_retries", "DW", "Gensendelsesforsøg"),
    0x4BA2: ("var_lan_transfer_len", "DW", "Netværks overførselslængde"),
    0x4BA4: ("var_lan_boot_file_desc", "BYTES 12", "Bootfil descriptor blok (12 bytes, 4BA4h-4BAFh)"),
    0x4BB0: ("var_lan_block_index", "DB", "Nuværende blokindeks i bootfil"),
    0x4BB1: ("var_lan_file_eof_flag", "DW", "Slut på bootfil (EOF) flag"),
    0x4BB3: ("var_lan_data_byte_count", "DW", "Antal databytes i modtaget blok"),
    0x4BB5: ("var_lan_buf_pointer", "DW", "Aktiv bufferpointer i modtaget datablok"),
    0x4BB7: ("var_lan_payload_buffer", "BYTES 128", "Bootfil data payload buffer (128 bytes, 4BB7h-4C36h)"),

    # Floppy Disk Controller subsystem (Segment 0000:64xx)
    0x6400: ("var_fdc_text_work_buffer", "BYTES 10", "Tekst/diagnostik arbejdsbuffer (10 bytes, 6400h-6409h)"),
    0x640A: ("var_fdc_cmd_desc_block", "BYTES 16", "Diskette kommandoblok (16 bytes, 640Ah-6419h)"),
    0x641A: ("var_fdc_result_phase_buf", "BYTES 30", "FDC resultatfase buffer (30 bytes, 641Ah-6437h)"),
    0x6438: ("var_fdc_geometry_params", "BYTES 20", "Diskette geometriparametre (20 bytes, 6438h-644Bh)"),
    0x644C: ("var_fdc_calibration_block", "BYTES 42", "Drev kalibrerings- og statusblok (42 bytes, 644Ch-6475h)"),
    0x6476: ("var_fdc_status_word", "DW", "Diskette-controller statusord"),
    0x6478: ("var_fdc_busy_state", "DB", "Diskette-operation tilstand (FFh=i gang, 01h=færdig, 00h=fejl)"),
    0x6479: ("var_fdc_error_phase", "DB", "Fejlfase under disketteoperation"),
    0x647A: ("var_fdc_timeout_accum", "DW", "FDC timeout akkumulator ord"),
    0x647C: ("var_fdc_seek_target_trk", "DW", "FDC søgemål cylinder/spor ord"),
    0x647E: ("var_fdc_head_settle_cnt", "DW", "FDC head settle tæller ord"),
    0x6480: ("var_fdc_motor_state", "DW", "Diskettedrev motor-tilstand ord"),
    0x6482: ("var_fdc_step_rate_cached", "DW", "Cached stepping rate ord"),
    0x6484: ("var_fdc_head_load_time", "DW", "FDC head load tid ord"),
    0x6486: ("var_fdc_dma_buffer_seg", "DW", "Diskette DMA buffer segment i RAM"),
    0x6488: ("var_fdc_transfer_len", "DW", "Antal bytes overført via DMA til/fra diskette"),
    0x648A: ("var_fdc_cylinder_num", "DB", "Aktiv diskette cylinder/spor"),
    0x648B: ("var_fdc_head_sector", "DB", "Aktivt diskette hoved og sektornummer"),
    0x648C: ("var_fdc_drive_unit", "DB", "Aktivt diskettedrev (0=A:, 1=B:, 2=C:, 3=D:)"),
    0x648D: ("var_fdc_retry_count", "DB", "Akkumuleret diskette genprøvningstæller"),
    0x648E: ("var_fdc_last_error_code", "DB", "Sidste rapporterede diskette controller fejlkode"),
}

def replace_ram_symbols(args_str):
    """Replace raw memory addresses with meaningful symbol names."""
    def repl(m):
        prefix = m.group(1) or ""
        addr = m.group(2)
        try:
            val = int(addr, 16)
            if val in RAM_SCRATCHPAD_SYMBOLS:
                sym_name = RAM_SCRATCHPAD_SYMBOLS[val][0]
                return f"[{prefix}{sym_name}]"
        except ValueError:
            pass
        return m.group(0)
    
    return re.sub(r"\[(BYTE |WORD |DWORD |CS:|DS:|ES:)?0*([0-9A-Fa-f]{1,4})[Hh]?\]", repl, args_str)

def annotate_instruction(op_str, args_str):
    """Add explanatory hardware comments to instruction."""
    comments = []
    op_upper = op_str.strip().upper()
    args_upper = args_str.upper()
    
    # Check for I/O ports when instruction is IN/OUT or loading DX with an immediate port number
    if op_upper in ("IN", "OUT") or (op_upper == "MOV" and re.match(r"^DX\s*,\s*0*[0-9A-F]+H?$", args_upper)):
        for port, (sym_name, desc) in IO_PORT_SYMBOLS.items():
            pattern = rf"\b0*{port:02X}H?\b" if port < 0x100 else rf"\b0*{port:04X}H?\b"
            if re.search(pattern, args_upper):
                comments.append(desc)
                break
            
    # Check for NVRAM and RAM scratch variables in memory references
    if re.search(r"\[.*?(?:0019|019H).*?\]", args_upper):
        comments.append("NVRAM Byte 25 (0x19): Boot device parameter ('A'=Floppy, 'N'=Net)")
    elif re.search(r"\[.*?(?:0065|065H).*?\]", args_upper):
        comments.append("NVRAM Magic byte 0xAA validation")
    elif re.search(r"\[.*?(?:0067|067H).*?\]", args_upper):
        comments.append("Boot drive preselection buffer ('A', 'B', etc.)")
    elif re.search(r"\[.*?(?:0120|120H).*?\]", args_upper):
        comments.append("Selftest error flags buffer")
    elif re.search(r"\[.*?(?:012D|12DH).*?\]", args_upper):
        comments.append("Selftest status / warm-boot flag word (bit 9 = skip memtest)")
    elif re.search(r"\[.*?(?:012F|12FH).*?\]", args_upper):
        comments.append("Keyboard modifier counter (Ctrl + Alt)")
    elif re.search(r"\[.*?(?:0132|132H).*?\]", args_upper):
        comments.append("Keyboard event flag (FFh = key pressed)")
    elif re.search(r"\[.*?(?:0133|133H).*?\]", args_upper):
        comments.append("Keyboard ASCII char buffer")
    elif re.search(r"\[.*?(?:0134|134H).*?\]", args_upper):
        comments.append("Keyboard raw scancode buffer")
    elif re.search(r"\[.*?(?:0135|135H).*?\]", args_upper):
        comments.append("Timer 0 tick counter (incremented by timer ISR)")
        
    return "; ".join(comments)

def replace_segment_equates(mnemonic, args):
    """Replace literal memory segment base numbers with calculated/symbolic equates."""
    if mnemonic == "MOV":
        if args == "AX, F800":
            return "AX, ROM_DATA_SEGMENT"
        args = re.sub(r"\bD000\b", "CRT_VRAM_SEGMENT", args)
        args = re.sub(r"\b3600\b", "LAN_BUFFER_SEGMENT", args)
        args = re.sub(r"\b3000\b", "LAN_BUFFER_ALT_SEGMENT", args)
    return args

DISPATCH_TABLE_SYMBOLS = {
    "262D": "diag_test_jump_table",
    "2935": "diag_test_handler_vector_table",
    "3F99": "menu_format_vector_table",
    "037F": "decimal_divisor_table",
}

def replace_table_symbols(args):
    """Replace hardcoded table offsets in indexed jumps/calls with symbolic names."""
    for hex_addr, sym in DISPATCH_TABLE_SYMBOLS.items():
        args = args.replace(hex_addr, sym)
    return args

IVT_ISR_LABELS = {
    0x0483: "isr_fdc_wd2797",
    0x0AB5: "isr_default_trap",
    0x0ABB: "isr_keyboard_raw",
    0x0AC1: "isr_nmi",
    0x0AD7: "isr_hardware_irq_default",
    0x0428: "isr_i186_internal",
    0x0A60: "isr_82730_command_done",
    0x1703: "isr_dma0_selftest",
    0x17DE: "isr_lan_selftest",
    0x2E30: "isr_lan_rx_frame",
    0x2E68: "isr_lan_tx_done",
    0x355A: "isr_net_packet_received",
    0x41CF: "boot_from_winchester_alt",
}

CODE_POINTER_SYMBOLS = {
    "0026": "loc_0026",
    "002D": "loc_002d",
    "0034": "loc_0034",
    "005F": "loc_005f",
    "04D1": "test_prom_checksum",
    "0518": "loc_0518",
    "05CA": "loc_05ca",
    "05D6": "loc_05d6",
    "05F4": "loc_05f4",
    "0600": "loc_0600",
    "0618": "loc_0618",
    "0624": "loc_0624",
    "063C": "loc_063c",
    "0648": "loc_0648",
    "0660": "loc_0660",
    "0677": "loc_0677",
    "09CE": "loc_09ce",
    "09EA": "loc_09ea",
    "0A0F": "loc_0a0f",
    "0A34": "loc_0a34",
    "0BF8": "loc_0bf8",
    "1703": "isr_dma0_selftest",
    "17DE": "isr_lan_selftest",
    "2E30": "isr_lan_rx_frame",
    "2E68": "isr_lan_tx_done",
    "355A": "isr_net_packet_received",
}

def replace_code_pointer_symbols(mnemonic, args):
    """Replace immediate code/continuation addresses loaded into registers with symbolic labels."""
    if mnemonic == "MOV":
        for hex_addr, sym in CODE_POINTER_SYMBOLS.items():
            args = re.sub(rf"\b{hex_addr}\b", sym, args)
    return args

def main():
    if not os.path.exists(LIB_PATH):
        print(f"Error: {LIB_PATH} not found", file=sys.stderr)
        sys.exit(1)

    lib = ctypes.CDLL(LIB_PATH)
    lib.e86_disasm.argtypes = [ctypes.POINTER(DisOp), ctypes.c_char_p, ctypes.c_ushort]
    lib.e86_disasm.restype = None

    with open(ROM_PATH, "rb") as f:
        rom = f.read()

    assert len(rom) == 32768, f"Unexpected ROM size: {len(rom)}"

    CODE_EMBEDDED_DATA = {
        0x037F: {
            "name": "decimal_divisor_table",
            "desc": "16-bit divisortabel for binær-til-decimal ASCII rutine (FB84:0393)",
            "type": "words",
            "len": 10,
            "comments": ["10000 decimal", "1000 decimal", "100 decimal", "10 decimal", "1 decimal"]
        },
        0x04C1: {
            "name": "ram_top_segment_table",
            "desc": "RAM top-segmenter ud fra Port 70h DIP-switches (FB84:0884)",
            "type": "words",
            "len": 16,
            "comments": [
                "0000h (Reserved/Invalid)", "1000h (64 KB)", "2000h (128 KB)", "3000h (192 KB)",
                "4000h (256 KB)", "5000h (320 KB)", "6000h (384 KB)", "7000h (448 KB)",
                "8000h (512 KB)", "9000h (576 KB)", "A000h (640 KB)", "B000h (704 KB)",
                "C000h (768 KB)", "D000h (832 KB)", "E000h (896 KB)", "F000h (960 KB)"
            ]
        },
        0x0D51: {
            "name": "ascii_hex_digits_table",
            "desc": "ASCII heksadecimale cifre opslagstabel (FB84:0D8D, FB84:22EC)",
            "type": "bytes",
            "len": 16,
            "comments": ["'0'", "'1'", "'2'", "'3'", "'4'", "'5'", "'6'", "'7'", "'8'", "'9'", "'A'", "'B'", "'C'", "'D'", "'E'", "'F'"]
        },
        0x0F86: {
            "name": "decimal_base_ten_const",
            "desc": "Inline konstant 10 decimal efter RETN instruktion (FB84:0FAC, FB84:0FC2)",
            "type": "words",
            "len": 2,
            "comments": ["10 decimal (div/mul base)"]
        },
        0x278C: {
            "name": "boot_device_vector_table",
            "desc": "Boot device funktionstabeller for CALL [CS:DI] (FB84:277C)",
            "type": "words",
            "len": 20,
            "comments": [
                "Boot Medium 'A': Floppy A (27ACh)",
                "Boot Medium 'B': Floppy B (27ACh)",
                "Boot Medium 'C': Floppy C (27ACh)",
                "Boot Medium 'D': Floppy D (27ACh)",
                "Boot Medium 'N': Net (28BDh)",
                "Boot Medium 'M': ROM-disk (27EEh)",
                "Boot Medium 'W': Winchester (4191h)",
                "Boot Medium Default/Invalid (27CEh)",
                "Boot Medium Default/Invalid (27CEh)",
                "Boot Medium Winchester Alt (41CFh)"
            ]
        },
        0x2935: {
            "name": "diag_test_handler_vector_table",
            "desc": "Selftest sub-handler funktionstabel for CALL [CS:BX+2935] (FB84:299D)",
            "type": "words",
            "len": 10,
            "comments": ["Handler 0 (29FCh)", "Handler 1 (29FDh)", "Handler 2 (29FCh)", "Handler 3 (2A96h)", "Handler 4 (2A73h)"]
        },
        0x3F99: {
            "name": "menu_format_vector_table",
            "desc": "Skærmformat og menu dispatch-tabel for CALL [CS:BX+3F99] (FB84:3EF9, 3F92)",
            "type": "words",
            "len": 12,
            "comments": ["Menu 0 (3FA5h)", "Menu 1 (4088h)", "Menu 2 (40EAh)", "Menu 3 (4058h)", "Menu 4 (402Fh)", "Menu 5 (4164h)"]
        }
    }

    BRANCH_OPS = {'CALL', 'JMP', 'JMPS', 'JMPN', 'JZ', 'JNZ', 'JC', 'JNC', 'JA', 'JAE', 'JB', 'JBE', 
                  'JG', 'JGE', 'JL', 'JLE', 'JS', 'JNS', 'JO', 'JNO', 'JP', 'JNP', 
                  'LOOP', 'LOOPE', 'LOOPNE', 'JCXZ'}
    UNCOND_OPS = {'JMP', 'JMPS', 'JMPN', 'JMPF', 'RET', 'RETN', 'RETF', 'IRET'}

    call_targets = set()
    jump_targets = set()
    table_targets = set()

    # Targets from Section 2 diag_test_jump_table (262Dh - 264Bh)
    for i in range(0x262D, 0x264B, 2):
        table_targets.add(rom[i] | (rom[i+1] << 8))

    # Targets from Section 3 tables
    for tbl_ip in (0x278C, 0x2935, 0x3F99):
        tbl_info = CODE_EMBEDDED_DATA[tbl_ip]
        tbl_rom = 0x3840 + tbl_ip
        for i in range(tbl_rom, tbl_rom + tbl_info["len"], 2):
            table_targets.add(rom[i] | (rom[i+1] << 8))

    op_scan = DisOp()
    scan_pos = 0x3844
    prev_was_uncond = False

    while scan_pos < 0x7F88:
        scan_ip = scan_pos - 0x3840
        if scan_pos == 0x7A2E:
            break
        if scan_ip in CODE_EMBEDDED_DATA:
            scan_pos += CODE_EMBEDDED_DATA[scan_ip]["len"]
            prev_was_uncond = False
            continue

        if prev_was_uncond:
            jump_targets.add(scan_ip)

        raw_slice = rom[scan_pos:min(scan_pos+16, len(rom))]
        buf = raw_slice + b"\x90" * (16 - len(raw_slice))
        lib.e86_disasm(ctypes.byref(op_scan), buf, scan_ip)
        n = min(op_scan.dat_n if op_scan.dat_n > 0 else 1, len(raw_slice))
        mnem = op_scan.op.decode("latin1", errors="replace")
        a1 = op_scan.arg1.decode("latin1", errors="replace")
        if mnem == "CALL" and len(a1) == 4:
            try:
                call_targets.add(int(a1, 16))
            except ValueError:
                pass
        elif mnem in BRANCH_OPS and len(a1) == 4:
            try:
                jump_targets.add(int(a1, 16))
            except ValueError:
                pass

        prev_was_uncond = (mnem in UNCOND_OPS)
        scan_pos += n

    all_labels = dict(KNOWN_CODE_LABELS)
    all_labels.update(IVT_ISR_LABELS)
    for hex_addr, sym in CODE_POINTER_SYMBOLS.items():
        all_labels[int(hex_addr, 16)] = sym

    for t in sorted(table_targets | call_targets):
        if t not in all_labels:
            all_labels[t] = f"sub_{t:04x}"
    for t in sorted(jump_targets):
        if t not in all_labels:
            all_labels[t] = f"loc_{t:04x}"

    lines = []
    lines.append("; ============================================================================")
    lines.append("; REGNECENTRALEN RC759 PICCOLINE BOOT PROM VERSION 2.1 (32 KB)")
    lines.append("; Binary: mame/roms/rc759/rc759-1-2.1.rom (CRC32: 3a777d56, SHA1: a8592d61...)")
    lines.append("; EPROM: ROA955 (Low Byte) + ROA956 (High Byte) interleaved")
    lines.append(";")
    lines.append("; MEMORY ARCHITECTURE:")
    lines.append(";   Physical mapping:  0xF8000 - 0xFFFFF (32 KB, mirrored at 0xE8000)")
    lines.append(";   Data Segment:      F800h (Offset == ROM file offset 0000h - 7FFFh)")
    lines.append(";   Code Segment:      FB84h (Physical 0xFB840, ROM file offset 3840h)")
    lines.append(";   Reset Entry:       FFF8:0008h (Physical 0xFFF88, ROM file offset 7F88h)")
    lines.append(";   Reset Vector:      FFFF:0000h (Physical 0xFFFF0, ROM file offset 7FF0h)")
    lines.append("; ============================================================================")
    lines.append("")
    lines.append("; ============================================================================")
    lines.append("; MEMORY ARCHITECTURE & SEGMENT CALCULATION EQUATES")
    lines.append("; ============================================================================")
    lines.append("ROM_SIZE_BYTES          EQU 08000h                       ; 32 KB Boot PROM")
    lines.append("ROM_BASE_PHYSICAL       EQU (0100000h - ROM_SIZE_BYTES)  ; 0F8000h (Toppen af 1 MB CPU-adresserum)")
    lines.append("ROM_DATA_SEGMENT        EQU (ROM_BASE_PHYSICAL >> 4)     ; 0F800h (Fuld PROM dækkes fra offset 0000h)")
    lines.append("")
    lines.append("; Datasektion (0000h - 383Bh) og beregning af kodesegment-base via 16-byte paragrafjustering (ALIGN 16)")
    lines.append("ROM_DATA_SIZE_BYTES     EQU 0383Ch                       ; Datasektionens faktiske slutning før padding")
    lines.append("ROM_CODE_OFFSET         EQU ((ROM_DATA_SIZE_BYTES + 15) & ~15) ; 03840h (Næste paragrafgrænse, ALIGN 16)")
    lines.append("ROM_CODE_PHYSICAL       EQU (ROM_BASE_PHYSICAL + ROM_CODE_OFFSET) ; 0FB840h")
    lines.append("CODE_SEGMENT_BASE       EQU (ROM_CODE_PHYSICAL >> 4)     ; 0FB84h")
    lines.append("")
    lines.append("; 80186 Reset-stub (initial far jump target fra CPU reset-vektor)")
    lines.append("RESET_ENTRY_ROM_OFFSET  EQU 07F88h                       ; 80186 Reset-stub filoffset i PROM")
    lines.append("RESET_STUB_PHYSICAL     EQU (ROM_BASE_PHYSICAL + RESET_ENTRY_ROM_OFFSET) ; 0FFF88h")
    lines.append("RESET_STUB_IP           EQU 00008h                       ; Entry offset i reset-stub segmentet")
    lines.append("RESET_STUB_SEGMENT      EQU ((RESET_STUB_PHYSICAL - RESET_STUB_IP) >> 4) ; 0FFF8h")
    lines.append("")
    lines.append("; 80186 CPU Power-On Reset Vektor (fysisk fastlagt af CPU-arkitekturen til CS:IP = FFFF:0000h)")
    lines.append("CPU_RESET_PHYSICAL      EQU 0FFFF0h                      ; CPU Power-on hardware reset entry")
    lines.append("RESET_VECTOR_ROM_OFFSET EQU (CPU_RESET_PHYSICAL - ROM_BASE_PHYSICAL) ; 07FF0h (ROM filoffset for reset-vektor)")
    lines.append("RESET_VECTOR_SEGMENT    EQU (CPU_RESET_PHYSICAL >> 4)    ; 0FFFFh")
    lines.append("")
    lines.append("; Eksterne hardware- og buffersegmenter")
    lines.append("CRT_VRAM_SEGMENT        EQU 0D000h                       ; Intel 82730 VRAM & display-controller styreblok (D000:0000)")
    lines.append("LAN_BUFFER_SEGMENT      EQU 03600h                       ; Intel 82586 Ethernet LAN controller buffersegment (3600:0000)")
    lines.append("LAN_BUFFER_ALT_SEGMENT  EQU 03000h                       ; Intel 82586 LAN buffer / alternativt testområde (3000:0000)")
    lines.append("")

    # Section 1: Display Coprocessor Blocks & Font Tables (0000h - 2161h)
    lines.append("; ============================================================================")
    lines.append("; SECTION 1: INTEL 82730 DISPLAY BLOCKS & FONT TABLES (ROM 0000h - 2161h)")
    lines.append("; ============================================================================")
    lines.append("SEGMENT DATA_F800 AT ROM_DATA_SEGMENT")
    lines.append("ORG 0000h")
    lines.append("")
    lines.append("i82730_header_and_signature:")
    lines.append("    DB  059h, 0F4h, 0FAh, 037h, 0FFh   ; Hardware signatur / 82730 header")
    lines.append("")
    lines.append("i82730_scb_block:")
    lines.append("    ; Intel 82730 System Configuration Block (SCB, 7 bytes) -> kopieres til D000:6000")
    lines.append("    DB  001h, 000h, 000h, 020h, 00Dh, 000h, 061h")
    lines.append("")
    lines.append("i82730_cb_block:")
    lines.append("    ; Intel 82730 General Command Block (CB, 38 bytes) -> kopieres til D000:2000")
    p = 0x000C
    cb_end = 0x0032
    while p < cb_end:
        chunk = rom[p:min(p+16, cb_end)]
        hex_b = ", ".join(f"0{b:02X}h" for b in chunk)
        lines.append(f"    DB  {hex_b}")
        p += len(chunk)
    lines.append("")

    def format_82730_mode_block(offset, label, monitor_desc):
        mb = rom[offset:offset+54]
        res = []
        res.append(f"{label}:")
        res.append(f"    ; Intel 82730 Mode Block ({monitor_desc}, 54 bytes)")
        res.append(f"    ; Kopieres af bootprom (FB84:07B5) til D000:2026 i display controllerens styreblok")
        
        # Word 0: DMA Burst
        w = mb[0] | (mb[1] << 8)
        res.append(f"    DB  0{mb[0]:02X}h, 0{mb[1]:02X}h            ; +00h: DMA Burst Space={w&0x7F}, Burst Length={(w>>8)&0x7F}")
        
        # Word 1: HSync / Line length
        w = mb[2] | (mb[3] << 8)
        res.append(f"    DB  0{mb[2]:02X}h, 0{mb[3]:02X}h            ; +02h: HSync Stop={w&0xFF} tegn, Linjelængde={(w>>8)&0xFF} tegn ({(w>>8)&0xFF}*16 clocks)")
        
        # Word 2: H Field
        w = mb[4] | (mb[5] << 8)
        res.append(f"    DB  0{mb[4]:02X}h, 0{mb[5]:02X}h            ; +04h: H-Field Stop kolonne {w&0xFF}, Start kolonne {(w>>8)&0xFF} ({(w&0xFF)-((w>>8)&0xFF)} tegn aktiv bredde)")
        
        # Word 3: H Border
        w = mb[6] | (mb[7] << 8)
        res.append(f"    DB  0{mb[6]:02X}h, 0{mb[7]:02X}h            ; +06h: H-Border Stop {w&0xFF}, Start {(w>>8)&0xFF}")
        
        # Word 4: Scroll margin
        w = mb[8] | (mb[9] << 8)
        res.append(f"    DB  0{mb[8]:02X}h, 0{mb[9]:02X}h            ; +08h: Blød scroll margin ({w&0x1F} scanlines)")
        
        # Word 5: Lines per row (lpr)
        w = mb[10] | (mb[11] << 8)
        res.append(f"    DB  0{mb[10]:02X}h, 0{mb[11]:02X}h            ; +0Ah: Lines Per Row (lpr)={w&0x1F} ({(w&0x1F)+1} scanlines pr. tekstlinje)")
        
        # Word 6: Normal sub/super start/stop
        w = mb[12] | (mb[13] << 8)
        res.append(f"    DB  0{mb[12]:02X}h, 0{mb[13]:02X}h            ; +0Ch: Normal tekst start scanline {(w>>8)&0x1F}, stop {w&0x1F}")
        
        # Word 7: Superscript start/stop
        w = mb[14] | (mb[15] << 8)
        res.append(f"    DB  0{mb[14]:02X}h, 0{mb[15]:02X}h            ; +0Eh: Hævet skrift (superscript) start {(w>>8)&0x1F}, stop {w&0x1F}")
        
        # Word 8: Subscript start/stop
        w = mb[16] | (mb[17] << 8)
        res.append(f"    DB  0{mb[16]:02X}h, 0{mb[17]:02X}h            ; +10h: Sænket skrift (subscript) start {(w>>8)&0x1F}, stop {w&0x1F}")
        
        # Word 9: Cursor 1 start/stop
        w = mb[18] | (mb[19] << 8)
        res.append(f"    DB  0{mb[18]:02X}h, 0{mb[19]:02X}h            ; +12h: Markør 1 (understregning): start scanline {(w>>8)&0x1F}, stop {w&0x1F}")
        
        # Word 10: Cursor 2 start/stop
        w = mb[20] | (mb[21] << 8)
        res.append(f"    DB  0{mb[20]:02X}h, 0{mb[21]:02X}h            ; +14h: Markør 2 (blokmarkør): start scanline {(w>>8)&0x1F}, stop {w&0x1F}")
        
        # Word 11: Underline line select
        w = mb[22] | (mb[23] << 8)
        res.append(f"    DB  0{mb[22]:02X}h, 0{mb[23]:02X}h            ; +16h: Understregning linjeplacering: U1={w&0x1F}, U2={(w>>8)&0x1F}")
        
        # Word 12: Field attribute mask
        w = mb[24] | (mb[25] << 8)
        res.append(f"    DB  0{mb[24]:02X}h, 0{mb[25]:02X}h            ; +18h: Feltattribut-maske ({w:04X}h = default)")
        
        # Word 13: Frame length
        w = mb[26] | (mb[27] << 8)
        res.append(f"    DB  0{mb[26]:02X}h, 0{mb[27]:02X}h            ; +1Ah: Billedhøjde (Frame length)={w&0x7FF} scanlines total")
        
        # Word 14: VSync stop
        w = mb[28] | (mb[29] << 8)
        res.append(f"    DB  0{mb[28]:02X}h, 0{mb[29]:02X}h            ; +1Ch: VSync Stop={w&0x7FF} scanlines")
        
        # Word 15: V Field start
        w = mb[30] | (mb[31] << 8)
        res.append(f"    DB  0{mb[30]:02X}h, 0{mb[31]:02X}h            ; +1Eh: V-Field Start scanline {w&0x7FF}")
        
        # Word 16: V Field stop
        w = mb[32] | (mb[33] << 8)
        v_start = (mb[30] | (mb[31] << 8)) & 0x7FF
        v_stop = w & 0x7FF
        res.append(f"    DB  0{mb[32]:02X}h, 0{mb[33]:02X}h            ; +20h: V-Field Stop scanline {v_stop} ({v_stop-v_start} aktive scanlines)")
        
        # Word 17 & 18: Reserved
        res.append(f"    DB  0{mb[34]:02X}h, 0{mb[35]:02X}h            ; +22h: Reserveret")
        res.append(f"    DB  0{mb[36]:02X}h, 0{mb[37]:02X}h            ; +24h: Reserveret")
        
        # Word 19: Cursor blink & duty cycle
        w = mb[38] | (mb[39] << 8)
        res.append(f"    DB  0{mb[38]:02X}h, 0{mb[39]:02X}h            ; +26h: Markør-blink: FrameIntCount={(w&0xF)}, Rate={((w>>8)&0xF)}, Duty={((w>>12)&0xF)}")
        
        # Word 20: Character blink & display flags
        w = mb[40] | (mb[41] << 8)
        res.append(f"    DB  0{mb[40]:02X}h, 0{mb[41]:02X}h            ; +28h: Tegn-blink: Mode-flag={w&0xFF:02X}h, Rate={((w>>8)&0xF)}, Duty={((w>>12)&0xF)}")
        
        # Word 21: Attributes / underlines
        res.append(f"    DB  0{mb[42]:02X}h, 0{mb[43]:02X}h            ; +2Ah: Attributkontrol / usynlige tegn / linjetæller")
        
        # Word 22..26: DMA channel & buffer config
        w = mb[44] | (mb[45] << 8)
        res.append(f"    DB  0{mb[44]:02X}h, 0{mb[45]:02X}h            ; +2Ch: Display kanal / FIFO timing ({w:04X}h)")
        w = mb[46] | (mb[47] << 8)
        res.append(f"    DB  0{mb[46]:02X}h, 0{mb[47]:02X}h            ; +2Eh: Display buffer basesegment i RAM ({w:04X}h)")
        w = mb[48] | (mb[49] << 8)
        res.append(f"    DB  0{mb[48]:02X}h, 0{mb[49]:02X}h            ; +30h: Row table pointer / kanalstyring ({w:04X}h)")
        w = mb[50] | (mb[51] << 8)
        res.append(f"    DB  0{mb[50]:02X}h, 0{mb[51]:02X}h            ; +32h: Skærmhukommelse / VRAM offset ({w:04X}h)")
        w = mb[52] | (mb[53] << 8)
        res.append(f"    DB  0{mb[52]:02X}h, 0{mb[53]:02X}h            ; +34h: Slutparameter ({w:04X}h)")
        res.append("")
        return res

    lines.extend(format_82730_mode_block(0x0032, "i82730_mode_params_50hz", "15 kHz DK710 Piccoline / 50 Hz PAL"))
    lines.extend(format_82730_mode_block(0x0068, "i82730_mode_params_60hz", "22 kHz DK914 Partner / 60 Hz"))

    lines.append("special_glyphs_01_to_1f:")
    lines.append("    ; Specialtegn og grafik-ikoner (ROM offset 009Eh - 01DCh)")
    p = 0x009E
    sg_end = 0x01DD
    while p < sg_end:
        b = rom[p]
        lines.append(f"    DB  0{b:02X}h                  ; {render_bits8(b)} [{p:04X}h]")
        p += 1
    lines.append("")

    # File paths for include files
    FONT_50HZ_INC = os.path.join(TASK_DIR, "font_50hz_dk710.inc")
    FONT_60HZ_INC = os.path.join(TASK_DIR, "font_60hz_dk914.inc")

    # Generate 50 Hz Font Include File
    lines_50hz = []
    lines_50hz.append("; ============================================================================")
    lines_50hz.append("; REGNECENTRALEN RC759 PICCOLINE - 15 kHz SKÆRMFONT (DK710, 7x10 MATRIX)")
    lines_50hz.append("; ROM offset: 01DDh - 0D3Fh (2,915 bytes)")
    lines_50hz.append("; Format pr. post: Tegnkode (1 byte) + 10 scanlines (10 bytes)")
    lines_50hz.append("; ============================================================================")
    lines_50hz.append("")
    lines_50hz.append("font_table_50hz:")
    p = 0x01DD
    while p < 0x0D40 and rom[p] != 0:
        c = rom[p]
        desc = format_char_desc(c)
        lines_50hz.append(f"; --- Tegn 0{c:02X}h ({desc}) ---")
        lines_50hz.append(f"    DB  0{c:02X}h                  ; Tegnkode {c:02X}h ({desc})")
        p += 1
        for line_idx in range(10):
            b = rom[p]
            lines_50hz.append(f"    DB  0{b:02X}h                  ; {render_bits8(b)}")
            p += 1
        lines_50hz.append("")

    if p < 0x0D40 and rom[p] == 0:
        lines_50hz.append(f"    DB  000h                  ; Slutmarkør for 15 kHz fonttabel [{p:04X}h]")
        p += 1
        while p < 0x0D40:
            b = rom[p]
            lines_50hz.append(f"    DB  0{b:02X}h")
            p += 1
    lines_50hz.append("")

    with open(FONT_50HZ_INC, "w", encoding="utf-8") as f:
        f.write("\n".join(lines_50hz) + "\n")
    print(f"Generated {FONT_50HZ_INC} ({len(lines_50hz)} lines)")

    # Generate 60 Hz Partner Font Include File
    lines_60hz = []
    lines_60hz.append("; ============================================================================")
    lines_60hz.append("; REGNECENTRALEN RC750 PARTNER - 22 kHz SKÆRMFONT (DK914, 9x14 MATRIX)")
    lines_60hz.append("; ROM offset: 0D40h - 2161h (5,154 bytes)")
    lines_60hz.append("; Del 1: Standard ASCII (20h - 7Eh): 1 byte tegnkode + 14 bytes scanlines")
    lines_60hz.append("; Del 2: Udvidet tegnsæt (80h - FFh): 1 byte tegnkode + 14 16-bit ord (DW)")
    lines_60hz.append("; ============================================================================")
    lines_60hz.append("")
    lines_60hz.append("font_table_60hz:")
    p = 0x0D40
    while p < 0x2162 and rom[p] != 0:
        c = rom[p]
        desc = format_char_desc(c)
        lines_60hz.append(f"; --- Tegn 0{c:02X}h ({desc}) ---")
        lines_60hz.append(f"    DB  0{c:02X}h                  ; Tegnkode {c:02X}h ({desc})")
        p += 1
        for line_idx in range(14):
            b = rom[p]
            lines_60hz.append(f"    DB  0{b:02X}h                  ; {render_bits8(b)}")
            p += 1
        lines_60hz.append("")

    if p < 0x2162 and rom[p] == 0:
        lines_60hz.append(f"    DB  000h                  ; Slutmarkør for 22 kHz standardfont [{p:04X}h]")
        p += 1
        lines_60hz.append("")
        lines_60hz.append("    ; Del 2: Udvidet tegnsæt (80h - FFh) - 14 16-bit ord (DW) pr. tegn")
        while p < 0x2162 and rom[p] != 0:
            c = rom[p]
            desc = format_char_desc(c)
            lines_60hz.append(f"; --- Tegn 0{c:02X}h ({desc}) [16-bit bredde] ---")
            lines_60hz.append(f"    DB  0{c:02X}h                  ; Tegnkode {c:02X}h ({desc})")
            p += 1
            for line_idx in range(14):
                if p + 1 < len(rom):
                    w = rom[p] | (rom[p+1] << 8)
                    lo = rom[p]
                    hi = rom[p+1]
                    p += 2
                    lines_60hz.append(f"    DW  0{w:04X}h                ; {render_bits8(hi)} (attr: 0{lo:02X}h)")
                else:
                    break
            lines_60hz.append("")

    if p < 0x2162:
        while p < 0x2162:
            b = rom[p]
            lines_60hz.append(f"    DB  0{b:02X}h")
            p += 1
    lines_60hz.append("")

    with open(FONT_60HZ_INC, "w", encoding="utf-8") as f:
        f.write("\n".join(lines_60hz) + "\n")
    print(f"Generated {FONT_60HZ_INC} ({len(lines_60hz)} lines)")

    # Reference includes in main ASM file
    lines.append("; ----------------------------------------------------------------------------")
    lines.append("; 15 kHz Piccoline skærmfont (DK710, 10 scanlines pr. tegn, ROM 01DDh - 0D3Fh)")
    lines.append("; ----------------------------------------------------------------------------")
    lines.append('%include "font_50hz_dk710.inc"')
    lines.append("")
    lines.append("; ----------------------------------------------------------------------------")
    lines.append("; 22 kHz Partner-skærm font (DK914, 14 scanlines pr. tegn, ROM 0D40h - 2161h)")
    lines.append("; ----------------------------------------------------------------------------")
    lines.append('%include "font_60hz_dk914.inc"')
    lines.append("")

    lines.append("; ============================================================================")
    lines.append("; SECTION 2: LOOKUP TABLES, SYSTEM STRINGS & IVT PROTOTYPE (2162h - 383Fh)")
    lines.append("; ============================================================================")
    
    data_ranges = [
        (0x2162, 0x21D2, "table_keyboard_scancodes", "Scancode til ASCII / styretaster konverteringstabel"),
        (0x21D2, 0x2248, "str_selftest_error_messages", "Selftest og POST fejlmeddelelser (Pascal counted strings)"),
        (0x2248, 0x22B8, "prototype_ivt_table", "Initialiseringsvektorer for Interrupt Vector Table (IVT 0000:0000)"),
        (0x22B8, 0x2379, "str_snooper_commands", "Snooper monitor / memory debugger prompt-tekster"),
        (0x2379, 0x2396, "str_piccoline_test_banner", "Banner: *** PICCOLINE TEST, V.2.1 ***"),
        (0x2396, 0x23CD, "str_piccoline_selftest_banner", "Banner: *** PICCOLINE, PC, Selftest, V.2.1 ***"),
        (0x23CD, 0x247A, "str_error_formatting", "Register- og adresseudskriftsformater"),
        (0x247A, 0x2512, "str_selftest_menu", "Selftest menu (<0> proceed, <1> list, <2> snooper, etc.)"),
        (0x2512, 0x2609, "str_hardware_config", "Hardwarekonfiguration visningstekster"),
        (0x2609, 0x262D, "diag_test_menu_config", "Selftest menustyring og konfigurationsparametre"),
        (0x262D, 0x264B, "diag_test_jump_table", "Tabel over de 15 POST selftest-funktioner i FB84-segmentet (CALL [ES:DI+262Dh])"),
        (0x264B, 0x2683, "diag_test_descriptor_table", "Deskriptorer for de 14 selftest-titler (DW text_ptr, DW text_len)"),
        (0x2683, 0x26E7, "diag_error_code_table", "Selftest fejlkodetabel med pointere til fejltekster (DB kode, DW str_ptr)"),
        (0x26E7, 0x28B0, "str_diagnostic_tests", "Tekster for RAM refresh, Timer, DMA, 8259, LAN 82586, FDC"),
        (0x28B0, 0x317A, "data_subsystems_and_messages", "Undersystem-parametre og perifere testblokke"),
        (0x317A, 0x31B0, "str_bootloader_banner", "Banner: PICCOLINE BOOTLOADER version 2.1"),
        (0x31B0, 0x320C, "str_bootloader_errors", "Fejlmeddelelser: NON EXISTING MEDIUM, INSERT DISKETTE, etc."),
        (0x320C, 0x3348, "str_boot_media_menu", "Boot-medier (A: DRIVE A, B: DRIVE B, N: NET, M: PROM, etc.)"),
        (0x3348, 0x336B, "str_default_boot_os", "Standard OS filnavn: 'CCPM    SYS'"),
        (0x336B, 0x35E0, "str_network_boot_errors", "Netværks-boot fejlmeddelelser og NDOS protokol"),
        (0x35E0, 0x383C, "str_net_params_config", "Konfigurationsmenu for netværk og maskin-ID"),
    ]

    IVT_COMMENTS = [
        "Int 00h (0000:0000h): Divide Error ISR",
        "Int 01h (0000:0004h): Single Step / Debug ISR",
        "Int 02h (0000:0008h): NMI Non-Maskable Interrupt ISR",
        "Int 03h (0000:000Ch): Breakpoint ISR",
        "Int 04h (0000:0010h): Overflow (INTO) ISR",
        "Int 05h (0000:0014h): Print Screen / BOUND ISR",
        "Int 06h (0000:0018h): Invalid Opcode ISR",
        "Int 07h (0000:001Ch): Coprocessor Not Available ISR",
        "Int 08h (0000:0020h): IRQ 0 System Timer ISR",
        "Int 09h (0000:0024h): IRQ 1 Keyboard ISR",
        "Int 0Ah (0000:0028h): IRQ 2 Slave PIC / Reserved ISR",
        "Int 0Bh (0000:002Ch): IRQ 3 Serial COM2 ISR",
        "Int 0Ch (0000:0030h): IRQ 4 Serial COM1 ISR",
        "Int 0Dh (0000:0034h): IRQ 5 Floppy Disk Controller (WD2797) ISR",
        "Int 0Eh (0000:0038h): IRQ 6 Centronics Printer ISR",
        "Int 0Fh (0000:003Ch): IRQ 7 Real Time Clock (MM58167) ISR",
        "Int 10h (0000:0040h): 80186 Internal Timer 0 ISR",
        "Int 11h (0000:0044h): 80186 Internal Timer 1 ISR",
        "Int 12h (0000:0048h): 80186 Internal Timer 2 ISR",
        "Int 13h (0000:004Ch): 80186 DMA Channel 0 ISR",
        "Int 14h (0000:0050h): 80186 DMA Channel 1 ISR",
        "Int 15h (0000:0054h): 80186 Internal Interrupt ISR",
        "Int 16h (0000:0058h): Reserveret hardware afbrydelse ISR",
        "Int 17h (0000:005Ch): Reserveret hardware afbrydelse ISR",
        "Int 18h (0000:0060h): DMA Channel 0 Handler ISR",
        "Int 19h (0000:0064h): Reserveret hardware afbrydelse ISR",
        "Int 1Ah (0000:0068h): Reserveret hardware afbrydelse ISR",
        "Int 1Bh (0000:006Ch): Reserveret hardware afbrydelse ISR",
    ]

    DIAG_TEST_NAMES = [
        "Selftest initialisering / dummy",
        "RAM refresh & hukommelsestest (FB84:14D6h)",
        "Intel 8255 PPI interface test (FB84:1A79h)",
        "Lokal Centronics printerport test (FB84:1AF6h)",
        "Non-volatile memory (NVRAM) test (FB84:1ADAh)",
        "80186 Timer 0/1/2 test (FB84:1530h)",
        "80186 DMA kanal 0/1 test (FB84:1693h)",
        "80186 Interne afbrydelser test (FB84:1752h)",
        "Intel 8259A PIC afbrydelsestest (FB84:170Ch)",
        "Tastatur-interface test (FB84:17B6h)",
        "Båndoptager (Cassette) interface test (FB84:1B89h)",
        "Ekstern Centronics printerport test (FB84:1D88h)",
        "Intel 82586 Ethernet LAN controller test (FB84:186Eh)",
        "Diskette-controller (WD2797 FDC) test (FB84:1EE3h)",
        "Intel 82730 Display tekstcontroller test (FB84:1C59h)",
    ]

    for start_off, end_off, lbl, desc in data_ranges:
        lines.append(f"; --- {lbl}: {desc} ({start_off:04X}h - {end_off:04X}h) ---")
        lines.append(f"{lbl}:")

        if lbl == "prototype_ivt_table":
            for i in range(start_off, end_off, 4):
                ip = rom[i] | (rom[i+1] << 8)
                cs = rom[i+2] | (rom[i+3] << 8)
                vec = (i - start_off) // 4
                desc_c = IVT_COMMENTS[vec]
                cs_str = "CODE_SEGMENT_BASE" if cs == 0xFB84 else f"0{cs:04X}h"
                ip_str = all_labels[ip] if ip in all_labels else f"0{ip:04X}h"
                lines.append(f"    DW  {ip_str:<24}, {cs_str:<18} ; {desc_c} ({cs:04X}:{ip:04X}h)")
        elif lbl == "diag_test_jump_table":
            for idx, i in enumerate(range(start_off, end_off, 2)):
                w = rom[i] | (rom[i+1] << 8)
                val_str = all_labels[w] if w in all_labels else f"0{w:04X}h"
                lines.append(f"    DW  {val_str:<28} ; Test {idx:2d}: {DIAG_TEST_NAMES[idx]}")
        elif lbl == "diag_test_descriptor_table":
            for idx, i in enumerate(range(start_off, end_off, 4)):
                w1 = rom[i] | (rom[i+1] << 8)
                w2 = rom[i+2] | (rom[i+3] << 8)
                txt = "".join(chr(rom[w1+k]) if 32 <= rom[w1+k] < 127 else "." for k in range(w2))
                lines.append(f"    DW  0{w1:04X}h, 0{w2:04X}h            ; Test {idx+1:2d}: \"{txt}\"")
        elif lbl == "diag_error_code_table":
            p = start_off
            lines.append(f"    DB  0{rom[p]:02X}h, 0{rom[p+1]:02X}h, 0{rom[p+2]:02X}h            ; Tabel-header ({rom[p+1]|(rom[p+2]<<8):04X}h)")
            p += 3
            while p < end_off and rom[p] != 0:
                err_code = rom[p]
                str_ptr = rom[p+1] | (rom[p+2] << 8)
                str_len = rom[str_ptr]
                txt = "".join(chr(rom[str_ptr+1+k]) if 32 <= rom[str_ptr+1+k] < 127 else "." for k in range(str_len))
                lines.append(f"    DB  0{err_code:02X}h, 0{rom[p+1]:02X}h, 0{rom[p+2]:02X}h      ; Fejlkode {err_code:02X}h: \"{txt.strip()}\" ({str_ptr:04X}h)")
                p += 3
            if p < end_off:
                lines.append(f"    DB  000h                           ; Afslutning på fejlkodetabel ({p:04X}h)")
        else:
            p = start_off
            while p < end_off:
                chunk = rom[p:min(p+16, end_off)]
                # Check if printable ascii
                printable = all(32 <= b < 127 or b in (10, 13) for b in chunk)
                if printable and len(chunk) > 4:
                    # Format as string
                    s = "".join(chr(b) if 32 <= b < 127 else f"' , {b:02X}h , '" for b in chunk)
                    s = f"'{s}'".replace("'', ", "").replace(", ''", "")
                    lines.append(f"    DB  {s}")
                else:
                    hex_b = ", ".join(f"0{b:02X}h" for b in chunk)
                    lines.append(f"    DB  {hex_b}")
                p += len(chunk)
        lines.append("")

    lines.append("; ----------------------------------------------------------------------------")
    lines.append("; Datasektionens afslutning og paragraf-justering (ROM 383Ch - 383Fh, 4 bytes padding)")
    lines.append("; Sørger for at CODE_SEGMENT_BASE / rom_code_start flugter med en 16-byte paragrafgrænse")
    lines.append("; ----------------------------------------------------------------------------")
    lines.append("data_section_end:")
    lines.append("    ALIGN   16, DB 0FFh                          ; 4 bytes padding (0383Ch - 0383Fh) til 16-byte paragrafgrænse")
    lines.append("")

    # Section 3: Primary Code Segment (3840h - 7F87h) -> FB84:0000 - 4747h
    lines.append("; ============================================================================")
    lines.append("; SECTION 3: PRIMARY CODE SEGMENT (ROM offset 3840h - 7F87h)")
    lines.append("; Segment FB84h (CS:0000h = Physical 0xFB840 = ROM offset 3840h)")
    lines.append("; Indeholder koldstarts-initialisering, POST, RAM-test, skærmopsætning og bootloader")
    lines.append("; ============================================================================")
    lines.append("")
    lines.append("; ============================================================================")
    lines.append("; RAM SCRATCHPAD & HARDWARE VARIABLES (Segment 0000h)")
    lines.append("; ============================================================================")
    lines.append("SEGMENT RAM_0000 AT 0000h")
    lines.append("")
    curr_addr = None
    for addr in sorted(RAM_SCRATCHPAD_SYMBOLS.keys()):
        if addr in (0x0000, 0x0002):
            continue  # Defined as real labels at FB84:0000 and FB84:0002 below
        sym_name, dtype, desc = RAM_SCRATCHPAD_SYMBOLS[addr]
        if curr_addr != addr:
            hex_addr = f"0{addr:04X}h" if addr >= 0xA000 else f"{addr:04X}h"
            lines.append(f"ORG {hex_addr}")
        lbl = sym_name + ":"
        if dtype.startswith("BYTES "):
            count = int(dtype.split()[1])
            lines.append(f"{lbl:<28} TIMES {count} DB 0               ; [{addr:04X}h] {desc}")
            size = count
        else:
            lines.append(f"{lbl:<28} {dtype:<4} 0                           ; [{addr:04X}h] {desc}")
            size = 1 if dtype == "DB" else (2 if dtype == "DW" else 4)
        curr_addr = addr + size
    lines.append("")
    lines.append("; ============================================================================")
    lines.append("; I/O PORT EQUATES & HARDWARE REGISTERS")
    lines.append("; ============================================================================")
    for port in sorted(IO_PORT_SYMBOLS.keys()):
        sym_name, desc = IO_PORT_SYMBOLS[port]
        hex_val = f"0{port:04X}h" if port >= 0xA000 else f"{port:04X}h"
        lines.append(f"{sym_name:<26} EQU  {hex_val}    ; {desc}")
    lines.append("")
    lines.append("SEGMENT CODE_FB84 AT CODE_SEGMENT_BASE")
    lines.append("ORG 0000h")
    lines.append("")

    # Offset 3840h has [CS:0000] and [CS:0002]
    lines.append("rom_segment_base:")
    lines.append("    DW  ROM_DATA_SEGMENT       ; [CS:0000] = Base segment for ROM data (F800h)")
    lines.append("ram_segment_base:")
    lines.append("    DW  0000h                  ; [CS:0002] = Base segment for RAM (0000h)")
    lines.append("")

    op = DisOp()
    pos = 0x3844
    code_end = 0x7F88

    while pos < code_end:
        code_ip = pos - 0x3840

        # Check for ROM padding between code end (7A2Eh) and 7F80h
        if pos == 0x7A2E:
            pad_len = 0x7F80 - 0x7A2E
            if lines and lines[-1] != "":
                lines.append("")
            lines.append(f"; ----------------------------------------------------------------------------")
            lines.append(f"; ROM Padding / Ubrugt ROM-plads (ROM 7A2Eh - 7F7Fh, {pad_len} bytes)")
            lines.append(f"; ----------------------------------------------------------------------------")
            lines.append(f"    TIMES {pad_len} DB 0FFh")
            lines.append("")
            lines.append(f"; ----------------------------------------------------------------------------")
            lines.append(f"; ROM Vektorer / Tabelfarpointere (ROM 7F80h - 7F87h)")
            lines.append(f"; ----------------------------------------------------------------------------")
            lines.append(f"    DW  0009Eh, ROM_DATA_SEGMENT ; [7F80h] Far pointer til special_glyphs_01_to_1f")
            lines.append(f"    DW  00B7Eh, ROM_DATA_SEGMENT ; [7F84h] Far pointer til font/display tabel")
            pos = 0x7F88
            break

        # Check for embedded data table in code segment
        if code_ip in CODE_EMBEDDED_DATA:
            tbl = CODE_EMBEDDED_DATA[code_ip]
            if lines and lines[-1] != "":
                lines.append("")
            lines.append(f"; ----------------------------------------------------------------------------")
            lines.append(f"; {tbl['name']} (ROM: {pos:04X}h, FB84:{code_ip:04X}h)")
            lines.append(f"; {tbl['desc']}")
            lines.append(f"; ----------------------------------------------------------------------------")
            lines.append(f"{tbl['name']}:")
            tbl_len = tbl["len"]
            tbl_type = tbl["type"]
            comments = tbl["comments"]
            
            if tbl_type == "words":
                for w_idx in range(tbl_len // 2):
                    w_pos = pos + w_idx * 2
                    w = rom[w_pos] | (rom[w_pos+1] << 8)
                    c_text = comments[w_idx] if w_idx < len(comments) else ""
                    val_str = all_labels[w] if w in all_labels else f"0{w:04X}h"
                    lines.append(f"    DW  {val_str:<28} ; [{code_ip + w_idx*2:04X}h] {c_text}")
            elif tbl_type == "bytes":
                for b_idx in range(tbl_len):
                    b_pos = pos + b_idx
                    b = rom[b_pos]
                    c_text = comments[b_idx] if b_idx < len(comments) else ""
                    lines.append(f"    DB  0{b:02X}h                    ; [{code_ip + b_idx:04X}h] {c_text}")
            
            pos += tbl_len
            continue

        # Check for label
        if code_ip in all_labels:
            lbl = all_labels[code_ip]
            if code_ip in KNOWN_CODE_LABELS:
                if lines and lines[-1] != "":
                    lines.append("")
                lines.append(f"; ----------------------------------------------------------------------------")
                lines.append(f"; {lbl} (ROM: {pos:04X}h, FB84:{code_ip:04X}h)")
                lines.append(f"; ----------------------------------------------------------------------------")
                lines.append(f"{lbl}:")
            else:
                lines.append(f"{lbl}:")

        raw_slice = rom[pos:min(pos+16, len(rom))]
        buf = raw_slice + b"\x90" * (16 - len(raw_slice))
        lib.e86_disasm(ctypes.byref(op), buf, code_ip)

        n = min(op.dat_n if op.dat_n > 0 else 1, len(raw_slice))
        dat_bytes = [raw_slice[i] for i in range(n)]
        hex_bytes = " ".join(f"{b:02X}" for b in dat_bytes)

        mnemonic = op.op.decode("latin1", errors="replace")
        arg1 = op.arg1.decode("latin1", errors="replace")
        arg2 = op.arg2.decode("latin1", errors="replace")

        # Resolve branch targets to symbolic labels
        if mnemonic in BRANCH_OPS and len(arg1) == 4:
            try:
                target_ip = int(arg1, 16)
                if target_ip in all_labels:
                    arg1 = all_labels[target_ip]
            except ValueError:
                pass

        args = ""
        if op.arg_n == 1:
            args = arg1
        elif op.arg_n >= 2:
            args = f"{arg1}, {arg2}"

        comment = annotate_instruction(mnemonic, args)
        comment_str = f" ; {comment}" if comment else ""

        args = replace_ram_symbols(args)
        args = replace_io_symbols(mnemonic, args)
        args = replace_segment_equates(mnemonic, args)
        args = replace_table_symbols(args)
        args = replace_code_pointer_symbols(mnemonic, args)
        asm_line = f"    {mnemonic:<7} {args:<28}{comment_str}"
        lines.append(f"{asm_line:<60} ; [{code_ip:04X}: {hex_bytes}]")

        if mnemonic in UNCOND_OPS and (pos + n) < code_end:
            if lines and lines[-1] != "":
                lines.append("")

        pos += n

    # Section 4: 80186 Reset Entry Stub (7F88h - 7FDFh) -> FFF8:0008 - 005Fh
    if lines and lines[-1] != "":
        lines.append("")
    lines.append("; ============================================================================")
    lines.append("; SECTION 4: 80186 RESET ENTRY STUB (ROM offset 7F88h - 7FDFh)")
    lines.append("; Target for initial far jump from reset vector (FFFF:0000h)")
    lines.append("; Konfigurerer 80186 integrerede Peripheral Control Block (PCB) chip-selects")
    lines.append("; ============================================================================")
    lines.append("SEGMENT RESET_FFF8 AT RESET_STUB_SEGMENT")
    lines.append("ORG RESET_STUB_IP")
    lines.append("")
    lines.append("reset_entry_fff8_0008:")

    pos = 0x7F88
    reset_stub_end = 0x7FF0
    while pos < reset_stub_end:
        if pos == 0x7FDD:
            pad_len = 0x7FF0 - 0x7FDD
            if lines and lines[-1] != "":
                lines.append("")
            lines.append(f"; ----------------------------------------------------------------------------")
            lines.append(f"; Reset Stub Padding (ROM 7FDDh - 7FEFh, {pad_len} bytes)")
            lines.append(f"; ----------------------------------------------------------------------------")
            lines.append(f"    TIMES {pad_len} DB 0FFh")
            pos = 0x7FF0
            break

        code_ip = (pos - 0x7F88) + 8
        if code_ip == 0x0015:
            lines.append("reset_check_test_lock:")
        elif code_ip == 0x0035:
            lines.append("reset_config_pcb_chips:")

        raw_slice = rom[pos:min(pos+16, len(rom))]
        buf = raw_slice + b"\x90" * (16 - len(raw_slice))
        lib.e86_disasm(ctypes.byref(op), buf, code_ip)

        n = min(op.dat_n if op.dat_n > 0 else 1, len(raw_slice))
        dat_bytes = [raw_slice[i] for i in range(n)]
        hex_bytes = " ".join(f"{b:02X}" for b in dat_bytes)

        mnemonic = op.op.decode("latin1", errors="replace")
        arg1 = op.arg1.decode("latin1", errors="replace")
        arg2 = op.arg2.decode("latin1", errors="replace")

        if mnemonic == "JNC" and arg1 == "0035":
            arg1 = "reset_config_pcb_chips"
        elif mnemonic == "JZ" and arg1 == "0015":
            arg1 = "reset_check_test_lock"
        elif mnemonic == "JMPF" and "FB84:0004" in arg1:
            arg1 = "CODE_SEGMENT_BASE:cold_boot_entry"

        args = ""
        if op.arg_n == 1:
            args = arg1
        elif op.arg_n >= 2:
            args = f"{arg1}, {arg2}"

        comment = annotate_instruction(mnemonic, args)
        comment_str = f" ; {comment}" if comment else ""

        args = replace_ram_symbols(args)
        args = replace_io_symbols(mnemonic, args)
        args = replace_segment_equates(mnemonic, args)
        args = replace_table_symbols(args)
        args = replace_code_pointer_symbols(mnemonic, args)
        asm_line = f"    {mnemonic:<7} {args:<28}{comment_str}"
        lines.append(f"{asm_line:<60} ; [{code_ip:04X}: {hex_bytes}]")

        if mnemonic in UNCOND_OPS and (pos + n) < reset_stub_end:
            if lines and lines[-1] != "":
                lines.append("")

        pos += n

    # Section 5: Reset Vector and Intel 82730 SCP (7FF0h - 7FFFh) -> FFFF:0000h
    if lines and lines[-1] != "":
        lines.append("")
    lines.append("; ============================================================================")
    lines.append("; SECTION 5: 80186 RESET VECTOR & INTEL 82730 SCP (ROM offset 7FF0h - 7FFFh)")
    lines.append("; Fysisk adresse 0xFFFF0 (CPU opstartsadresse efter hardware RESET)")
    lines.append("; ============================================================================")
    lines.append("SEGMENT RESET_FFFF AT RESET_VECTOR_SEGMENT")
    lines.append("ORG 0000h")
    lines.append("")
    lines.append("reset_vector_ffff_0000:")
    lines.append("    CLI                                                      ; [0000: FA]")
    lines.append("    JMPF    RESET_STUB_SEGMENT:reset_entry_fff8_0008         ; [0001: EA 08 00 F8 FF]")
    lines.append("")
    lines.append("; ----------------------------------------------------------------------------")
    lines.append("; Intel 82730 System Configuration Pointer (SCP)")
    lines.append("; Fast placering i toppen af hukommelsen (fysisk 0xFFFF6 - 0xFFFFFh).")
    lines.append("; Intel 82730 Text Coprocessor læser denne blok ved RESET / initial Channel")
    lines.append("; Attention (CA-puls på port 0240h) for at bestemme busbredde og finde IBP/SCB.")
    lines.append("; ----------------------------------------------------------------------------")
    lines.append("i82730_system_configuration_pointer:")
    lines.append("    DB  001h                                                 ; [0006: 01] SYSBUS: 16-bit system bus mode (bit 0 = 1)")
    lines.append("    DB  0FFh, 000h, 000h, 000h, 000h                         ; [0007: FF 00 00 00 00] Reserveret / padding")
    lines.append("    DW  06000h                                               ; [000C: 00 60] IBP base address lav word")
    lines.append("    DW  0000Dh                                               ; [000E: 0D 00] IBP base address høj word -> fysisk 0D6000h (D000:6000h)")


    # Write output ASM
    out_asm_content = "\n".join(lines) + "\n"
    with open(OUT_ASM, "w", encoding="utf-8") as f:
        f.write(out_asm_content)

    print(f"Generated {OUT_ASM} ({len(lines)} lines, {len(out_asm_content)} bytes)")

if __name__ == "__main__":
    main()

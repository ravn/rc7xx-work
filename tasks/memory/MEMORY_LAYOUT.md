---
name: memory-layout-rules
description: Rules for memory layout, linker, address, and BSS changes in RC702 firmware
metadata:
  type: feedback
---

Read this file before ANY linker script / BSS / address / defsym change.

- **[RC702 IVT page constraint](project_rc702_ivt_page_constraint.md) — IM 2 IVT must not overlap 0xF800..0xFFCF; valid: 0xEC00/0xED00 or 0xF500**
- **[RC702 bank2h PROM mirror](feedback_rc702_bank2h_mirror.md) — HARD: 0x2800..0x2FFF is PROM1-mirror, NOT RAM**
- **[Grep mem_map before BSS literal](feedback_grep_memmap_before_bss.md) — HARD: grep emulator mem_map before allocating BSS at a literal address**
- **[Slave RAM state outside TPA](feedback_slave_state_outside_tpa.md) — HARD: pin slave state to SNIOS 0xED00..0xF7FF, never inside TPA**
- **[Phase-boundary state-address audit](feedback_state_address_phase_audit.md) — HARD: re-audit state addresses when lifecycle changes**
- **[No literal memory addresses](feedback_no_literal_addresses.md) — HARD: linker-derived or .sym-extracted only; literals OK for ports/vectors/magic**
- **[Cross-stage --defsym atomic](feedback_relink_dependencies_atomically.md) — HARD: C decl + linker script + Makefile awk + defsym in same commit**
- **[Ring-shrink + INIR coupling](feedback_ring_shrink_inir_coupled.md) — HARD: pio_rx_buf 256->16 B ASSUMES INIR; without INIR 41B block overflows -> deadlock**
- **[Verify HW register is load-bearing](feedback_verify_hw_register_load_bearing.md) — HARD: verify bit is load-bearing before modifying init-time hw reg writes**
- **[Bundle layout migrations proactively](feedback_bundle_layout_migrations_proactively.md) — HARD: if region headroom <200 B, bundle layout move now**
- [rcbios 32-bit RTC = diffs only](reference_rcbios_rtc_counter_diffs_only.md) — rtc0/rtc2 is 50Hz boot-relative; never as since-epoch timestamp

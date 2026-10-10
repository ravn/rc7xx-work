## Lesson: OUT (0x18) PROM disable must run from RAM, not ROM

When disabling the RC702 PROMs via OUT (0x18),A, the instruction itself
executes from ROM but the **next instruction fetch** will read RAM (all
zeros post-disable, NOP sled). Symptom: CPU runs off into random RAM.

Fix: put the OUT (0x18),A in code that already lives in high RAM
(resident chunk at 0xF580+ for cpnos-rom). The RC702 PROMs cover
0x0000-0x07FF and 0x2000-0x27FF; 0xF580 is unaffected by the port
write, so execution continues cleanly.

Found in cpnos-rom Phase 1 MAME bringup. Symptom was PC stuck at
~0x7400 after reset, nothing happening at display memory. Breadcrumbs
at 0xE100 were empty; resident code was correctly copied to 0xF580;
the CPU just never reached it.


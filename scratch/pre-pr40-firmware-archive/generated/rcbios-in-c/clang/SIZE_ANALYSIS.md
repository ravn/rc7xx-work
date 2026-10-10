# Clang vs SDCC BIOS Size Analysis (2026-03-31)

## Overall

| Section | SDCC | Clang | Delta |
|---------|------|-------|-------|
| Boot | 1145 B | 1320 B | +175 B |
| BIOS code (.text) | 3906 B | 4303 B | +397 B |
| BIOS rodata | ~260 B | 303 B | +43 B |
| JP table | 113 B | 113 B | 0 |
| **Binary total** | **5561 B** | **6041 B** | **+480 B (+8.6%)** |

## Boot section (+175B)

- coldboot in bios_shims.s (assembly) vs SDCC inline
- relocate_bios not inlined (non-static for clang shim access)
- memcpy/memset inlined as LDIR in both compilers
- Linker symbol arithmetic for BSS size slightly less efficient

## BIOS code (+397B)

Clang inlines many small functions that SDCC keeps separate. The top-level
function sizes aren't directly comparable. Grouped analysis needed.

### Largest clang functions

| Function | Clang | Notes |
|----------|-------|-------|
| bios_conout_c | 1188 B | CONOUT display driver (inlined specc, xyadd, displ, etc.) |
| sec_rw | 287 B | Sector read/write |
| bg_clear_from | 264 B | Background bitmap clear |
| rwoper | 261 B | Read/write operation dispatcher |
| isr_crt | 225 B | CRT refresh ISR |
| bios_seldsk_c | 209 B | Disk select |
| bios_write_c | 176 B | Write entry |
| chktrk | 136 B | Track check/format |
| wboot_c | 125 B | Warm boot |

### SDCC functions NOT in clang (inlined or eliminated)

| Function | SDCC | Inlined into |
|----------|------|--------------|
| specc | 125 B | bios_conout_c |
| insert_line | 220 B | bios_conout_c |
| delete_line | 121 B | bios_conout_c |
| xyadd | 86 B | bios_conout_c |
| xwrite | 169 B | bios_conout_c |
| clear_foreground | 75 B | bios_conout_c / bg_clear_from |
| displ | 73 B | bios_conout_c |
| erase_to_eol | 71 B | bios_conout_c |
| flp_dma_setup | 48 B | sec_rw / rwoper |
| fdc_general_cmd | 41 B | sec_rw / rwoper |
| clear_screen | 39 B | bios_conout_c |

## Detailed findings (2026-03-31)

### ISRs: clang WINS
Clang's `__attribute__((interrupt))` saves only clobbered registers.
SDCC's `__critical __interrupt` saves AF,BC,DE,HL,IY unconditionally.
Example: `isr_sio_b_tx` — clang 14B, SDCC 24B. Not an optimization target.

### Redundant BSS variable loads (biggest opportunity)
Clang reloads BSS variables from memory repeatedly instead of keeping
them in registers. Example in `delete_line` (inlined in bios_conout_c):
`cury` (0xFFD2) loaded 3 times in 20 instructions — each load is 3B.

Total BSS loads in BIOS: 161. Many are redundant reloads of the same
variable within a basic block or across simple calls. This is the
+static-stack BSS spill problem (ravn/llvm-z80#20).

Estimated savings: ~100-150B if redundant loads eliminated.

### Loop counter as 16-bit (wboot_c)
The `for (sec = 0; sec < NSECTS; sec++)` loop in wboot_c uses 16-bit
HL as loop counter even though `sec` is `byte` and NSECTS=0x2C. The
16-bit compare (`LD A,L; SUB $2C; OR H`) costs 2 extra bytes per
iteration vs a simple 8-bit `CP` or `DJNZ`.

### Address computation for fixed-address writes
Writing to page zero (`wboot_jp`, `bdos_jp` at address 0x0000, 0x0005)
uses `LD DE,addr; LD (DE),A` (4B) where `LD (addr),A` (3B) would work.

### 16-bit LD (addr),HL for word stores
Clang uses `LD (HL),E; INC HL; LD (HL),D` (3B) to store 16-bit values
where `LD (addr),DE` (4B ED opcode) or `LD (addr),HL` (3B) could be
used directly.

## Optimization targets (prioritized)

1. **Redundant BSS loads** (~100-150B): ravn/llvm-z80#20, core compiler issue
2. **8-bit loop counters** (~20-30B): byte variables promoted to 16-bit
3. **Direct address stores** (~10-20B): fixed addresses via LD (addr),A
4. **Boot section** (~50B): structural (shim overhead, non-inlined relocate)

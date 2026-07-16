# tm 3.43x-vs-dcc root cause: 87 % is the `chkmem` byte-compare loop (2026-07-16)

## Landscape (zcc +cpm -compiler=llvmz80 -O2 vs dcc, z88dk-ticks cycle-accurate)

| bench    | cyc-rat (zcc/dcc) | winner       |
|----------|-------------------|--------------|
| ackerman | 0.43x             | clang (big)  |
| hanoi    | 0.85x             | clang        |
| sieve    | 0.98x             | clang (#250) |
| e        | 1.18x             | dcc          |
| nqueens  | 1.19x             | dcc          |
| tak      | 1.47x             | dcc          |
| ttt      | 1.63x             | dcc          |
| **tm**   | **3.43x**         | **dcc (big)**|

tm is the outlier.

## Isolation experiment (VERIFIED)

Neutering `chkmem` (early `return;`, so calloc/malloc/free/memset still run):

- full tm (clang -O2):        272,275,536 cyc
- tm, chkmem neutered:         34,958,676 cyc
- dcc full tm:                 79,435,464 cyc

=> `chkmem` = 272M - 35M = **237M = 87 % of clang's tm runtime**.
The allocator + memset path is only ~35M — *faster* than dcc's whole 79M.
**tm's gap is NOT the allocator; it is pure clang codegen of one byte loop.**

## The loop (`chk.c`, reduced)

```c
void chkmem(char *p, int v, size_t c) {
    register unsigned char *pc = (unsigned char *)p;
    unsigned char val = (unsigned char)(v & 0xff);
    for (size_t i = 0; i < c; i++) {
        if (*pc != val) { err(); return; }
        pc++;
    }
}
```

clang -O2 inner loop (VERIFIED):

```
LBB0_2:
	ld	l,c            ; 4   pc -> HL ...
	ld	h,b            ; 4   ... pc kept in BC, copied every iter
	ld	a,(ix+-2)      ; 19  val RELOADED from frame every iter (loop-invariant!)
	cp	(hl)           ; 7
	jr	nz,LBB0_4      ; 7
	inc	bc             ; 6   pc++
	dec	de             ; 6   counter--
	ld	l,e            ; 4 } 16-bit
	ld	h,d            ; 4 } zero
	ld	a,l            ; 4 } test
	or	h              ; 4 } of DE
	jr	nz,LBB0_2      ; 12
```

~81 T/iteration.

## Two concrete inefficiencies (both regalloc quality)

1. **`ld a,(ix+-2)` every iteration = 19 T.** `val` is loop-invariant but was
   spilled to the IX frame slot and is reloaded via an IX-indexed load in the
   hottest loop. Should live in a register (`ld a,b` = 4 T; -15 T/iter).
2. **`ld l,c; ld h,b` every iteration = 8 T.** The walking pointer is parked in
   BC and copied into HL each iteration for `cp (hl)`; it should live in HL so
   `inc hl` walks it directly (drops the 8 T copy).

Only 7 GP 8-bit regs exist (A,B,C,D,E,H,L); this loop needs pointer(2)+counter(2)
+val(1) = 5 plus HL as the `cp (hl)` address — it *fits* if the pointer is in HL,
counter in DE, val in B. Hand-derived tight loop (NOT yet measured):

```
loop: ld a,b (4) | cp (hl) (7) | jr nz,err (7) | inc hl (6)
      dec de (6) | ld a,e (4) | or d (4) | jr nz,loop (12)   ~= 50 T/iter
```

~50 T vs ~81 T = ~38 % fewer cycles on the loop that is 87 % of tm, i.e. tm
~272M -> ~181M, ratio 3.43x -> ~2.3x (estimate). Still behind dcc, but the bulk
of the outlier is this one allocation choice.

## Relation to existing issues

- Distinct from #250 (CLOSED: base-address reload / pointer strength reduction) —
  here the *pointer* IS strength-reduced (`inc bc`), the waste is the **invariant
  `val` reload** + the BC->HL copy.
- Same family as #249 / #251 (walking pointer parked off-HL when the counter pins
  another pair) and the #258 tm/ttt tracker, but with a specific second cause
  (invariant-in-frame reload) that those don't call out.
- Filed as ravn/llvm-z80 issue (see below) with `chk.c` as the reduced repro.

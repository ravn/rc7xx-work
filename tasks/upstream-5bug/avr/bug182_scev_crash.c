/* AVR-side check for ravn/llvm-z80#182 (CLOSED 2026-05-23, dup of Bug 1).
   Original repro crashed Z80 backend at -O1+ via deleteDeadLoop SSA malform.
   AVR does NOT crash — its pipeline doesn't run Z80LoopIdiomFill (the trigger).
   This file is here to document the cross-target check, not as an action item.
   Action lives at ravn/llvm-z80#217 (formDedicatedExitBlocks fix). */
unsigned char a[100];
void g(void) {
   unsigned short i;
   for (i = 0; i < 100; ++i) a[i] = 0;
   for (i = 0; i < 100; ++i) ++a[i];
}

---
name: reference_reddit_i80186_dma_question
description: Reddit r/MAME thread asking how to model prompt i80186 internal-DMA servicing for a fast synchronised FDC (rc759 LOST DATA)
metadata:
  type: reference
---

Posted 2026-09-05 to r/MAME asking experienced MAME devs how to correctly model
prompt servicing of a **source-synchronised i80186 internal DMA** transfer feeding
a fast FDC (the rc759 WD2797 LOST DATA problem). Deliberately neutral: facts +
experiment outcomes only, no root-cause or fix assumption.

- Thread: https://www.reddit.com/r/MAME/comments/1w7yj9j/q_i80186_internal_dma_a_fast_sourcesynchronised/
- Canonical text (committed): `rc700-gensmedet/docs/mame_i80186_dma_floppy_question.md`

Data behind it (verified this session, valid seeded NVRAM): stock `drq0_w` -> LOST
DATA; `perfect_quantum` -> no change; inline `drq_callback(0)` in `drq0_w` (armed +
synchronised + `!m_dma_latency`) -> fixes it, A/B causal. Survey: every i80186 +
FDC machine on **drq1** is `MACHINE_NOT_WORKING`; working drq0+FDC = lb186/slicer/
compis. Work-in-progress branch: `rc759-fdc-dma-bringup` (also carries the separate
NVRAM checksum fix byte0 0x5f->0xdf). Check the thread for maintainer guidance
before generalising the shared i80186 core. See [[reference_rc7xx_mame_boot_disks]].

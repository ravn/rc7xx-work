---
name: feedback_zoom_out_on_recurring_pattern
description: "When fixing repeated instances of the same bug class (or naming a recurring pattern), stop and investigate the systemic generating cause before continuing"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 90439589-e8b2-4e34-94a8-798e56731341
---

When I notice I'm fixing **repeated instances of the same class** — or catch myself **narrating the pattern** ("same family", "recurring root", "the Nth time", "both in the same peephole"), or **filing a cluster of issues in one subsystem** — treat that as a first-class prompt to **stop and investigate the systemic cause that generates the class**, before fixing the next instance. This is the "dig UP / zoom out" complement to [[feedback_dig_deeper_before_parking]] ("dig down"). Don't wait to be told to step back.

**Why:** Session 73s — I shipped 5 same-family peephole bugs (#14/#192/#193/#195×2), wrote "same family / recurring" in nearly every commit, filed a cluster of issues in one pass (#192–#197), yet treated each as an isolated ticket and only did the systemic analysis (optimization machinery outrunning verification machinery; verifier/assertions off; production config untested) when explicitly asked. I have a strong reflex to dig *down* (root-cause before parking) but none to zoom *out* (after a cluster, ask what produces it). Worse: a "keep going" throughput loop actively suppressed it — stepping back *feels* like not-progress, so momentum won every time. The signal was in my own words and I logged it without escalating.

**How to apply:** My own pattern-naming language IS the trigger — when I write "same family / recurring / Nth instance", pause and ask "what system generates this?" After ~2–3 same-class fixes, run the global query before the next fix. The cheapest systemic remedies (test/CI/verification gaps that hide the class) usually beat any single instance fix (cf. [[feedback_extract_rules_from_time_sinks]] — but escalate past "propose a rule that catches the class" to "find what produces the class"). Even inside a "go / keep going" loop, periodically synthesize *what the batch implies*, not just *what was done*. Related: [[feedback_peephole_safety_guards]].

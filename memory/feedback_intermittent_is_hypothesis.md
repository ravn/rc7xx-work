---
name: "Intermittent" is a hypothesis label, not a property
description: When inheriting a "race / intermittent / suspected timing" framing from a prior session, write the smallest falsifying experiment first — usually a data-content check
type: feedback
originSessionId: 5295f669-4bd6-4de0-8588-d661b7498d99
---
When picking up debugging work that's labeled "intermittent" /
"suspected race" / "fourth bug remaining" — *especially* in a prior
session's notes — treat that label as a hypothesis to falsify, not a
fact about the bug. Before pursuing timing/concurrency causes:

1. Correlate the failure point with the *data* being processed at that
   point. Count byte distributions. Hash sectors. Look for content
   patterns that vary across runs.
2. Re-derive the symptom from raw observation, not from the prior
   session's framing.
3. Only after explicitly ruling out data-dependence should I investigate
   chip emulation, threading, or timer races.

**Why:** Session 33's filing of ravn/rc700-gensmedet#56 framed the
snios-on-PIO failure as "stalls intermittently after 4-25 READ-SEQ
iterations". I inherited that framing in session 34 and went hunting
for a "fourth race" through chip-emulation quirks (BRDY priming, mode
flip ordering, cascade timing) for hours. The actual bug was
deterministic data-byte conflation: a 0xFF data byte was treated as
"empty FIFO" sentinel, dropped, and shifted the frame. Running
`data.count(b'\\xff')` on cpnos.com — 30 seconds of work — would have
shown sector 4 has 19 of them, exactly matching the "fail at iteration
~4" pattern. The "4-25" range was just mpm-net2's retry semantics
sometimes recovering past one bad sector before the next.

**How to apply:** When I open a session and the prior notes say "X
appears to be intermittent" or "we suspect a race in Y", the next step
is *not* "continue debugging where they left off". The next step is:

- Articulate what would make the bug *deterministic* (specific input,
  specific path, specific data content).
- Run the cheapest experiment that would falsify each — a histogram on
  the input, a hash diff, a content-vs-failure-point correlation.
- Only continue down the race/timing path if those falsify cleanly.

Prior-session diagnoses are evidence, not conclusions. Treat them like
a witness statement: useful, possibly wrong, always worth re-deriving.

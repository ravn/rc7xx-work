---
name: Don't ask permission to launch MAME or z80pack mpm-net2
description: User has standing authorization to spawn / kill MAME and z80pack MP/M processes during cpnet / cpnos work — just do it
type: feedback
originSessionId: 5295f669-4bd6-4de0-8588-d661b7498d99
---
The user has given **standing authorization** to launch and kill MAME
(`regnecentralend rc702 …`) and z80pack mpm-net2 (`./mpm-net2`) as
part of normal RC702 / cpnet-fast-link / cpnos bring-up.  Do not ask
"shall I launch MAME?" or "shall I kill the existing cpmsim?" before
each invocation.

**Why:** Restated by the user 2026-04-26: "can I tell you to do this
work automatically without asking me for every invocation of
mame+mp/m?"  Yes — they're tired of the per-invocation permission
prompt during iterative debugging.  The processes are local, the
build/run cycle is short, and stale instances accumulating on
:4002/:4003 just need to be killed and restarted, not deliberated
over.

**How to apply:**
- Just `pkill -9 cpmsim mame` and relaunch when needed.
- Same for z80pack mpm-net2: spawn/kill freely as part of harness
  setup.
- Same for the cpnet_bridge listener on :4003 — kill/relaunch.
- **Do still ask** for explicitly destructive operations on user
  state: `git push --force`, `rm -rf` of anything outside build dirs,
  modifying durable config the user maintains by hand.  Process
  spawning is not in that category.
- This rule applies to RC702-related processes specifically.  For
  unrelated tools (a compiler the user usually drives by hand, an
  external service), default back to the cautious behaviour.

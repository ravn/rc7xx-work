---
name: feedback_verify_artifact_freshness
description: Before trusting a build/test artifact (snapshot PNG, .lis, .ic66, log), check its mtime — a silently-failing generator leaves a stale file that looks current.
metadata:
  type: feedback
---

Bruger 2026-09-11: "hvorfor rammer du så tit ind i at snapshots er gamle?"

**Rod:** autoloads `mame_boot_test.lua` tager screenshot via `pcall(function()
screen:snapshot(...) end)` — pcall **sluger fejlen tavst**. På den aktuelle MAME-build
fejler kaldet (signatur/dir), så INGEN frisk PNG skrives; den eneste på disk er
måneder gammel. Jeg stolede på den uden at tjekke mtime. Sekundært: `roa375.ic66`
overskrives af sidst-byggede compiler (clang↔sdcc), så den er tit stale ift. det jeg
tror jeg tester.

**Why:** en tavst-fejlende generator efterlader en fil der *ser* aktuel ud → forkerte
konklusioner.

**How to apply:** før du stoler på en artefakt (snapshot, .lis, .ic66, .cim, log),
tjek `ls -la`/mtime mod den kørsel du lige lavede. En pcall-sluget snapshot er ikke
bevis. Foretræk en DIREKTE måling (fx MAME IO-write-tap-tæller: `io:install_write_tap`
på en port ISR'en skriver — beviste at CRT-ISR'en fyrer: 216 CTC2-OUT/3s) frem for en
artefakt hvis friskhed ikke er verificeret. Overvej at fjerne pcall-swallow så
snapshot-fejl bliver synlige.

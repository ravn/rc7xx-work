---
name: When fixing CMake/CLion config, always verify with the real compile database
description: A CMake/clangd include-path fix is not done until you generate compile_commands.json and confirm the actual flags for the failing file — not just that the compiler resolves the header.
metadata:
  type: feedback
---

**HARD (user, 2026-07-04): when fixing CMake, always verify.**

A "fix" to CMakeLists.txt / `.clangd` / include paths is NOT verified by
checking that the cross-compiler resolves the header, or by reasoning that the
`-I` "should" work.  Those miss what CLion/clangd actually sees.  Verify by
generating the real compile database and inspecting the failing file's flags:

```
cmake -S . -B /tmp/verify -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
python3 - <<'PY'
import json
for e in json.load(open('/tmp/verify/compile_commands.json')):
    if 'FAILING_FILE.c' in e['file']:
        print([t for t in (e.get('command') or ' '.join(e['arguments'])).split() if t.startswith('-I')])
PY
```

Confirm the include that was missing is now PRESENT (and absolute) for that
exact file.  Only then is it fixed.

**Why:** on 2026-07-04 a `#include "compiler/compat.h"` fix (adding `-I.` to
`.clangd` + the root to CMakeLists) was reported "done" after only checking the
compiler resolved it — but CLion still failed, because clangd resolves relative
`-I` in `.clangd` from an unpredictable base (the source dir, not the `.clangd`
dir).  The CMakeLists path (`${CMAKE_CURRENT_SOURCE_DIR}`, absolute) was the
real fix; the `.clangd` relative flag was inert/misleading.  Generating
compile_commands.json would have shown this immediately.

**Corollary:** prefer CMake `target_include_directories` with
`${CMAKE_CURRENT_SOURCE_DIR}`-based (absolute, portable) paths as the source of
truth; keep `.clangd` for defines/tidy config, not for relative `-I` that
duplicates and can shadow the compile database.

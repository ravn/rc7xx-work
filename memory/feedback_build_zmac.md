---
name: Build zmac from source if missing
description: When `zmac` is unavailable, build it from source at the `zmac/` subfolder; do not suggest brew install
type: feedback
originSessionId: 57254a72-8bad-4840-ab6e-f5fbc35df805
---
If the `zmac` assembler is not on PATH or not at the expected location,
build it from the in-repo source.

**How to apply:** `cd` into the repo's `zmac/` subfolder and run `make`.
The binary lands at `zmac/bin/zmac` (or similar). Add that to PATH or
reference it directly.

**Why:** No brew on this system. The in-repo `zmac/` source is
pre-cloned from http://48k.ca/zmac.zip specifically so this build path
works without any network or package-manager dependency.

**Don't** suggest `brew install zmac` (violates the no-brew rule) or
point the user at manual download instructions (the source is already
cloned in-tree).

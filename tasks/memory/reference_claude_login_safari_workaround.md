---
name: reference_claude_login_safari_workaround
description: Claude CLI's OAuth login flow opens the default browser and expects a localhost callback. Safari does not complete that callback (security/extension scheme issue). Bypass: set ANTHROPIC_API_KEY directly, or change the default browser to Chrome/Firefox for the login dance.
metadata:
  type: reference
---

**Observation (user, 2026-06-06):**

> "Safari does not support claude login callback."

When the Claude CLI (`claude` from `@anthropic-ai/claude-code`) runs
without `ANTHROPIC_API_KEY` set, it triggers an OAuth flow that opens
the user's default browser, then waits for a `http://localhost:NNNN/...`
callback to land the access token.  **Safari does not complete this
callback** -- the browser opens, the user signs in at console.anthropic.com,
and the redirect to the local CLI silently fails (no callback, no token,
CLI times out waiting).

## Workarounds (pick one)

### Workaround A -- API key, skip OAuth entirely

Set the env var BEFORE running `claude`.  This is the path the
BOOTSTRAP.md procedure expects:

```sh
export ANTHROPIC_API_KEY=sk-ant-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
claude
```

`scripts/setup-ubuntu.sh` arranges PATH but does NOT set the key; the
user installs it themselves (per the user's explicit direction
2026-06-06).  Put the export in `~/.bashrc` / `~/.zshenv` so future
shells pick it up automatically.

### Workaround B -- run the OAuth dance in Chrome/Firefox

Either change macOS's default browser:

```
System Settings -> Desktop & Dock -> Default web browser -> Chrome / Firefox
```

Or invoke `claude login` after pointing the URL handler at a different
browser for that one launch.

## How to apply

* On Macs configured with Safari as default: assume the OAuth path is
  broken.  Instruct the user (or auto-write in BOOTSTRAP-style docs) to
  use Workaround A unless they explicitly want OAuth.
* On Linux / Ubuntu: doesn't apply (Firefox / Chromium / no default
  browser configured; OAuth typically works).  Memory rule still useful
  because users may shell-jump between hosts.
* When troubleshooting "claude is just hanging on startup": ask whether
  this is a Mac with Safari as default; if yes, this is the likely
  cause.

Related: [[feedback_cross_machine_workflow]] (this is one of the
host-specific quirks that matters when switching machines).

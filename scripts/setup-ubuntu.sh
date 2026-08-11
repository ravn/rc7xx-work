#!/usr/bin/env bash
# setup-ubuntu.sh — bring a stock Ubuntu install to a state where the
# z80-compiler-suite workspace builds end-to-end, including Claude CLI.
#
# Tested on Ubuntu 24.04 LTS and 26.04 LTS.  Re-runnable: each step
# checks before doing work.  Sudo is used for apt + docker group; all
# other installs stay in $HOME so re-running on a different user is
# trivial.
#
# Usage:
#   bash setup-ubuntu.sh                  # default
#   bash setup-ubuntu.sh --no-mame        # skip MAME (saves ~600 MB)
#   bash setup-ubuntu.sh --no-docker      # skip Docker setup
#   bash setup-ubuntu.sh --no-claude      # skip Claude CLI
#
# After it finishes:
#   1. Open a new shell (PATH + group membership picks up changes).
#   2. Export your ANTHROPIC_API_KEY.
#   3. Follow BOOTSTRAP.md to clone the workspace.

set -euo pipefail

# ---------- argument parsing ----------
INSTALL_MAME=1
INSTALL_DOCKER=1
INSTALL_CLAUDE=1
for arg in "$@"; do
    case "$arg" in
        --no-mame)   INSTALL_MAME=0 ;;
        --no-docker) INSTALL_DOCKER=0 ;;
        --no-claude) INSTALL_CLAUDE=0 ;;
        -h|--help)
            sed -n '2,/^set/p' "$0" | sed '$d' | sed 's/^# \{0,1\}//'
            exit 0
            ;;
        *)
            echo "Unknown argument: $arg" >&2
            exit 1
            ;;
    esac
done

# ---------- sanity ----------
if [[ $EUID -eq 0 ]]; then
    echo "Do not run this script as root.  Run as your normal user;" >&2
    echo "sudo is invoked only for the apt + docker-group steps." >&2
    exit 1
fi

if ! command -v lsb_release >/dev/null 2>&1; then
    echo "[!] lsb_release not found; not an Ubuntu system?" >&2
    echo "    Continuing anyway, but APT package names may differ." >&2
else
    UBUNTU_VERSION=$(lsb_release -rs)
    case "$UBUNTU_VERSION" in
        24.*|25.*|26.*) : ;;
        *) echo "[!] Tested on Ubuntu 24/25/26; you have $UBUNTU_VERSION — proceeding."
        ;;
    esac
fi

log() { printf '\n=== %s ===\n' "$*"; }

# ---------- 1. apt packages ----------
log "Installing system packages via apt"

# Build tools used by llvm-z80, z88dk, rc700-gensmedet asm:
PKGS_BUILD=(
    build-essential
    cmake
    ninja-build
    clang
    lld
    ccache
    flex
    bison
    m4
    pkg-config
    python3-dev
    python3-pip
    python3-venv
    git
)

# Test-runner / value-oracle:
PKGS_TEST_RUNNER=(
    rustup       # toolchain manager; we'll `rustup default stable` below
)

# GitHub work + node for Claude CLI:
PKGS_TOOLING=(
    gh
    nodejs
    npm
)

# MAME runtime + SDL2 deps for headless (-aviwrite, -snap) and built variants:
PKGS_MAME=(
    mame
    xvfb
    libsdl2-dev
    libsdl2-ttf-dev
    libfontconfig1-dev
    libpulse-dev
    libasound2-dev
    libxml2-dev
    libusb-1.0-0-dev
    libpixman-1-dev
    qt6-base-dev
    qt6-tools-dev
)

# Misc useful utilities:
PKGS_UTIL=(
    rsync
    curl
    jq
    htop
    iotop
    less
    tree
    ripgrep
    fd-find
)

PKGS=("${PKGS_BUILD[@]}" "${PKGS_TEST_RUNNER[@]}" "${PKGS_TOOLING[@]}" "${PKGS_UTIL[@]}")
(( INSTALL_MAME )) && PKGS+=("${PKGS_MAME[@]}")
(( INSTALL_DOCKER )) && PKGS+=(docker.io docker-compose-v2)

# Update + install (single transaction, cleaner than per-package).
sudo apt update
sudo apt install -y "${PKGS[@]}"

# ---------- 2. Rust toolchain ----------
log "Installing Rust stable via rustup"
if ! rustup show 2>/dev/null | grep -q stable; then
    rustup default stable
fi

# ---------- 3. npm user-prefix + Claude CLI ----------
if (( INSTALL_CLAUDE )); then
    log "Configuring npm user prefix + installing Claude CLI"
    mkdir -p "$HOME/.local"
    npm config set prefix "$HOME/.local"

    # Persist PATH ($HOME/.local/bin, $HOME/.cargo/bin) for future shells.
    PROFILE="$HOME/.bashrc"
    if ! grep -q 'z80-compiler-suite/setup-ubuntu' "$PROFILE" 2>/dev/null; then
        cat >> "$PROFILE" <<'BASHRC'

# Added by z80-compiler-suite/setup-ubuntu.sh
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
BASHRC
    fi
    export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

    npm install -g @anthropic-ai/claude-code
fi

# ---------- 4. Docker (group only; service starts via systemd already) ----------
if (( INSTALL_DOCKER )); then
    log "Adding $USER to the docker group"
    if ! groups | grep -q '\bdocker\b'; then
        sudo usermod -aG docker "$USER"
        echo "[!] You need to log out and back in for docker group to apply."
    fi
fi

# ---------- 5. Git HTTPS-to-SSH rewrite (sub-modules clone without SSH key) ----------
log "Configuring git to use HTTPS for github.com (works without SSH key)"
git config --global --get url.https://github.com/.insteadof >/dev/null 2>&1 \
    || git config --global url.https://github.com/.insteadOf git@github.com:

# ---------- 6. Verify ----------
log "Verifying installation"
ok=1
check_cmd() {
    local cmd="$1" label="${2:-$1}"
    if command -v "$cmd" >/dev/null 2>&1; then
        printf "  %-12s %s\n" "$label" "$(command -v "$cmd")"
    else
        printf "  %-12s MISSING\n" "$label"
        ok=0
    fi
}
check_cmd cmake
check_cmd ninja
check_cmd clang
check_cmd lld
check_cmd ccache
check_cmd flex
check_cmd bison
check_cmd cargo "cargo (rust)"
check_cmd rustc "rustc"
check_cmd node "node (for npm)"
check_cmd npm
check_cmd gh "gh (GitHub CLI)"
(( INSTALL_DOCKER )) && check_cmd docker
(( INSTALL_MAME )) && check_cmd mame
(( INSTALL_MAME )) && check_cmd xvfb-run
(( INSTALL_CLAUDE )) && check_cmd claude "claude (CLI)"

if (( ok )); then
    log "All checks passed"
else
    log "Some tools are still missing — see above"
    exit 1
fi

# ---------- 7. Next steps ----------
cat <<EOF

NEXT STEPS:

  1. Open a new shell so PATH + (if Docker was installed) group membership
     pick up the changes:

        exec \$SHELL -l

  2. Export your Anthropic API key.  Put this in ~/.bashrc so future
     shells pick it up:

        export ANTHROPIC_API_KEY=sk-ant-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

  3. Clone the workspace per BOOTSTRAP.md:

        git clone --recurse-submodules \\
            git@github.com:ravn/rc7xx-work.git ~/z80
        # (or use the HTTPS URL: https://github.com/ravn/rc7xx-work.git)

  4. Authenticate gh for issue/PR work (interactive):

        gh auth login

  5. Run claude inside the workspace:

        cd ~/z80
        claude
EOF

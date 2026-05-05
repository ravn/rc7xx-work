# Top-level Makefile for z80 workspace
#
# After a fresh clone of llvm-z80 and rc700-gensmedet:
#   make toolchain      Build native Z80 clang compiler
#   make bios           Build BIOS with clang
#   make prom           Build PROM with clang
#   make test           Boot BIOS in MAME

UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Darwin)
  # macOS: use CLion-bundled cmake/ninja (no brew)
  CMAKE     = /Applications/CLion.app/Contents/bin/cmake/mac/aarch64/bin/cmake
  NINJA     = /Applications/CLion.app/Contents/bin/ninja/mac/aarch64/bin/ninja
  BUILD_DIR = build-macos
else
  # Linux (and anything else): system cmake/ninja
  CMAKE     = /usr/bin/cmake
  NINJA     = /usr/bin/ninja
  BUILD_DIR = build-linux
endif

LLVM_Z80 = $(CURDIR)/llvm-z80
BIOS_DIR = $(CURDIR)/rc700-gensmedet/rcbios-in-c
PROM_DIR = $(CURDIR)/rc700-gensmedet/autoload-in-c

LLVM_BUILD = $(LLVM_Z80)/$(BUILD_DIR)

TOOLS = clang lld llvm-objcopy llvm-objdump llvm-nm llc

# Native z88dk + bundled zsdcc toolchain.  See `make z88dk-toolchain`
# section below for the macOS prereqs.
Z88DK_DIR    = $(CURDIR)/z88dk
Z88DK_ZSDCC  = $(Z88DK_DIR)/bin/z88dk-zsdcc
Z88DK_BOOST  = $(Z88DK_DIR)/third_party/boost
Z88DK_PATCH  = $(CURDIR)/z88dk-macos.patch

.PHONY: toolchain bios prom test clean-toolchain z88dk-toolchain z88dk-clean

# ================================================================
# Z80 clang toolchain (native build)
# ================================================================

toolchain: $(LLVM_BUILD)/bin/clang

$(LLVM_BUILD)/bin/clang: $(LLVM_Z80)/clang/cmake/caches/Z80.cmake
	@echo "=== Configuring LLVM-Z80 for $(UNAME_S) in $(BUILD_DIR) ==="
	$(CMAKE) -C $(LLVM_Z80)/clang/cmake/caches/Z80.cmake \
		-G Ninja \
		-DCMAKE_MAKE_PROGRAM=$(NINJA) \
		-S $(LLVM_Z80)/llvm -B $(LLVM_BUILD)
	@echo "=== Building Z80 clang toolchain ==="
	$(NINJA) -C $(LLVM_BUILD) $(TOOLS)
	@echo "=== Verifying ==="
	$(LLVM_BUILD)/bin/clang --version
	@echo "=== Z80 clang toolchain ready ==="

clean-toolchain:
	rm -rf $(LLVM_BUILD)

# ================================================================
# BIOS and PROM builds
# ================================================================

bios: toolchain
	$(MAKE) -C $(BIOS_DIR) bios

prom: toolchain
	$(MAKE) -C $(PROM_DIR) prom

test: bios
	$(MAKE) -C $(BIOS_DIR) mame-maxi

# ================================================================
# z88dk + zsdcc native toolchain (macOS)
# ================================================================
#
# The rc700-gensmedet SDCC build path needs zcc + z88dk-zsdcc.  By
# default the rcbios-in-c/sdcc/Makefile falls back to the
# `z88dk:2.4` Docker image; this target builds them natively for a
# Docker-free flow.
#
# macOS prereqs (no brew used):
#   - Docker Desktop running (ONLY for the one-time boost-headers
#     extract; the produced toolchain runs natively after that)
#   - Xcode command line tools (gcc/g++, make)
#
# Two upstream-z88dk dependencies don't exist on macOS without brew:
#   - GMP (used only by `appmake/ti8xk` for TI-83+ output)
#   - libxml2 (used only by `z80svg` for SVG-to-Z80 rendering)
# Neither is needed for RC700 work, so `z88dk-macos.patch` removes
# `ti8xk.c` from the appmake source list and drops `z80svg` from
# the top-level BINS.
#
# A third upstream-z88dk dependency, `boost::graph` (used by SDCC's
# register allocator), is header-only.  We extract the headers from
# a debian:stable-slim Docker image (`apt-get install libboost-dev
# libboost-graph-dev`) into `z88dk/third_party/boost/`.  Headers are
# architecture-independent, so a 1.83 build pulled out of a linux
# image works fine on macOS arm64 at compile time.
#
# After the first `make z88dk-toolchain` succeeds, the `RUN`
# branch in `rc700-gensmedet/rcbios-in-c/sdcc/Makefile` switches to
# the native path automatically (it tests `wildcard z88dk/bin/zcc`).

z88dk-toolchain: $(Z88DK_ZSDCC)

$(Z88DK_BOOST)/graph/adjacency_list.hpp:
	@echo "=== extracting boost headers from debian:stable-slim ==="
	@mkdir -p $(Z88DK_DIR)/third_party
	@CID=$$(docker run -d --platform linux/amd64 debian:stable-slim sleep 120) && \
	  docker exec $$CID sh -c "apt-get update -qq && apt-get install -y -qq libboost-dev libboost-graph-dev" >/dev/null && \
	  docker cp $$CID:/usr/include/boost $(Z88DK_BOOST) && \
	  docker rm -f $$CID >/dev/null
	@echo "    extracted to $(Z88DK_BOOST) ($$(du -sh $(Z88DK_BOOST) | cut -f1))"

$(Z88DK_DIR)/.macos-patched: $(Z88DK_PATCH)
	@echo "=== applying $(Z88DK_PATCH) to $(Z88DK_DIR) ==="
	@cd $(Z88DK_DIR) && \
	  if git apply --check $(Z88DK_PATCH) >/dev/null 2>&1; then \
	    git apply $(Z88DK_PATCH) && echo "    patch applied"; \
	  else \
	    echo "    patch already applied or conflicts — leaving source as-is"; \
	  fi
	@touch $@

$(Z88DK_ZSDCC): | $(Z88DK_BOOST)/graph/adjacency_list.hpp $(Z88DK_DIR)/.macos-patched
	@echo "=== building z88dk + bundled zsdcc (~10-15 min first time) ==="
	cd $(Z88DK_DIR) && \
	  BUILD_SDCC=1 BUILD_SDCC_HTTP=1 \
	  CPPFLAGS="-I$(Z88DK_DIR)/third_party" \
	  CXXFLAGS="-I$(Z88DK_DIR)/third_party" \
	  ./build.sh
	@echo "=== z88dk toolchain ready: $(Z88DK_DIR)/bin/{zcc,z88dk-zsdcc,...} ==="

z88dk-clean:
	rm -rf $(Z88DK_DIR)/bin $(Z88DK_DIR)/lib $(Z88DK_DIR)/include \
	       $(Z88DK_DIR)/src/sdcc-build $(Z88DK_DIR)/.macos-patched

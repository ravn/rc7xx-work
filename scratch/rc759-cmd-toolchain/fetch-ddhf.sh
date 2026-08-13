#!/usr/bin/env bash
# fetch-ddhf.sh - cache DDHF (datamuseum.dk) artifacts locally in this repo so
# diskettes fetched from the archive are stored in-tree and NEVER re-downloaded.
#
# Archive reference (RC750/RC759 keyword pages, addressing scheme):
#   docs/datamuseum-rc750-rc759-archive.md
#
# Usage:
#   ./fetch-ddhf.sh <id> [<id> ...]     # cache one or more bitstore artifacts
#   ./fetch-ddhf.sh --index RC759       # (re)cache a keyword index page
#   ./fetch-ddhf.sh --coll rc750 <id>   # set analysis collection (default rc759)
#
# Each artifact id is a datamuseum "Bits" number, e.g. 30003020. For each id we
# cache two things (fetch-if-missing):
#   bits/<id>.bin        raw bitstore blob  (https://datamuseum.dk/bits/<id>)
#   aa/<coll>/<id>.html  analysis/dir page  (https://datamuseum.dk/aa/<coll>/<id>.html)
set -euo pipefail

CACHE_DIR="$(cd "$(dirname "$0")" && pwd)/ddhf-cache"
COLL="rc759"

get() { # url dest  -- download only if missing/empty
    local url="$1" dest="$2"
    if [ -s "$dest" ]; then
        echo "  cached: ${dest#"$CACHE_DIR"/} ($(wc -c <"$dest") B)"
        return 0
    fi
    mkdir -p "$(dirname "$dest")"
    if curl -fsSL --max-time 120 "$url" -o "$dest"; then
        echo "  FETCHED: ${dest#"$CACHE_DIR"/} ($(wc -c <"$dest") B) <- $url"
    else
        echo "  MISS (http error): $url" >&2
        rm -f "$dest"
        return 1
    fi
}

fetch_index() {
    local kw="$1"
    get "https://datamuseum.dk/wiki/Bits:Keyword/RC/$kw" "$CACHE_DIR/index/$kw.html"
}

fetch_artifact() {
    local id="$1"
    echo "artifact $id:"
    get "https://datamuseum.dk/bits/$id"            "$CACHE_DIR/bits/$id.bin" || true
    local aa="$CACHE_DIR/aa/$COLL/$id.html"
    get "https://datamuseum.dk/aa/$COLL/$id.html"   "$aa" || true
    # The aa page is usually an HTML meta-refresh to a hashed analysis page that
    # actually lists the disk's directory. Follow it once and cache the target.
    if [ -s "$aa" ]; then
        local rel target
        rel=$(grep -oiE 'url=[^"'\'' ]+' "$aa" | head -1 | sed 's/^url=//I')
        if [ -n "$rel" ]; then
            target="$CACHE_DIR/aa/$COLL/analysis-$id.html"
            get "https://datamuseum.dk/aa/$COLL/$rel" "$target" || true
        fi
    fi
}

[ $# -gt 0 ] || { grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 1; }

while [ $# -gt 0 ]; do
    case "$1" in
        --index) shift; fetch_index "$1"; shift ;;
        --coll)  shift; COLL="$1"; shift ;;
        -*)      echo "unknown option: $1" >&2; exit 2 ;;
        *)       fetch_artifact "$1"; shift ;;
    esac
done

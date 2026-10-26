# build-progress.sh - sourced helpers for the rebuild-*.sh scripts.
#
#   refuse_if_building            exit 1 if any ninja/make is already running
#   progress_run LOG MODE TOTALF -- CMD...
#       Run CMD in the background (stdout+stderr -> LOG) and show progress.
#       MODE=ninja  exact "[n/N]" taken from ninja's own output
#       MODE=count  lines matching $PROGRESS_RE; percent is relative to the
#                   step count saved in TOTALF by the last successful run
#       Sets PROGRESS_RC, PROGRESS_DONE, PROGRESS_ELAPSED afterwards.
#
# On a terminal a single line is updated in place every 2 s; otherwise one
# line is printed about every 30 s. Either way the latest status is also in
# LOG.progress (watch -n2 cat LOG.progress). Ctrl-C once is forwarded to the
# build as SIGINT (clean stop, never SIGKILL).

PROGRESS_INTERVAL=2
PROGRESS_RE="${PROGRESS_RE:-.}"

refuse_if_building() {
	# wmake/builder: Open Watcom's own build tools (not covered by make).
	if pgrep -x ninja >/dev/null || pgrep -x make >/dev/null ||
	   pgrep -x wmake >/dev/null || pgrep -x builder >/dev/null; then
		echo "error: a ninja/make/wmake build is already running; one build at a time" >&2
		exit 1
	fi
}

_progress_line() {   # done total elapsed last
	local done=$1 total=$2 el=$3 last=$4 pct=""
	((total > 0 && done <= total)) && pct=" $((done * 100 / total))% of ~$total"
	printf '[%d:%02d] %d steps%s  %s' $((el / 60)) $((el % 60)) "$done" "$pct" "$last"
}

_progress_last() {   # trimmed last log line, without the leading step marker
	tail -n 1 "$1" | sed -E 's/^\[[0-9]+\/[0-9]+\] //; s/^(Compiling|Building) //; s/\.\.\.$//; s/^=+ [0-9:]+ //; s/ =+$//' |
		awk '{print substr($0, length($0) > 45 ? length($0) - 44 : 1)}'
}

progress_run() {
	local log=$1 mode=$2 totalf=$3
	shift 4   # LOG MODE TOTALF --
	local tty=0 start=$SECONDS total=0 done_=0 pid line n
	[[ -t 1 ]] && tty=1
	[[ $mode == count ]] && total=$(cat "$totalf" 2>/dev/null || echo 0)

	: >"$log"
	"$@" >>"$log" 2>&1 &
	pid=$!
	trap 'kill -INT "$pid" 2>/dev/null' INT

	while kill -0 "$pid" 2>/dev/null; do
		if [[ $mode == ninja ]]; then
			n=$(tail -n 20 "$log" | grep -o -E '^\[[0-9]+/[0-9]+\]' | tail -n 1 | tr -d '[]' || true)
			done_=${n%/*}; total=${n#*/}
			[[ -z $n ]] && { done_=0; total=0; }
		else
			done_=$(grep -c -E "$PROGRESS_RE" "$log" || true)
		fi
		line=$(_progress_line "$done_" "$total" "$((SECONDS - start))" "$(_progress_last "$log")")
		# Status file for `watch -n2 cat LOG.progress` from another terminal.
		echo "$line" >"$log.progress"
		if ((tty)); then
			printf '\r\033[K%s' "$line"
		elif (((SECONDS - start) % 30 < PROGRESS_INTERVAL)); then
			echo "$line"
		fi
		sleep "$PROGRESS_INTERVAL"
	done
	set +e; wait "$pid"; PROGRESS_RC=$?; set -e
	trap - INT
	((tty)) && printf '\r\033[K'

	if [[ $mode == ninja ]]; then
		n=$(grep -o -E '^\[[0-9]+/[0-9]+\]' "$log" | tail -n 1 | tr -d '[]' || true)
		PROGRESS_DONE=${n%/*}; PROGRESS_DONE=${PROGRESS_DONE:-0}
	else
		PROGRESS_DONE=$(grep -c -E "$PROGRESS_RE" "$log" || true)
		# Remember a real (non-trivial) build as the next run's 100%.
		((PROGRESS_RC == 0 && PROGRESS_DONE > 50)) && echo "$PROGRESS_DONE" >"$totalf"
	fi
	PROGRESS_ELAPSED=$((SECONDS - start))
}

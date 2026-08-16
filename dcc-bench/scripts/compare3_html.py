#!/usr/bin/env python3
"""Render compare3_results.csv as a color-coded HTML comparison table."""
import sys, csv, html, datetime

src = sys.argv[1] if len(sys.argv) > 1 else "compare3_results.csv"
out = sys.argv[2] if len(sys.argv) > 2 else "/tmp/compare3.html"

rows = list(csv.DictReader(open(src)))

tests, by_test = [], {}
for r in rows:
    t = r["test"]
    if t not in by_test:
        by_test[t] = []
        tests.append(t)
    by_test[t].append(r)

vcolor = {
    "AGREE": "#1a7f37", "DIFF": "#cf222e", "SOLO": "#0969da",
    "BUILD_FAIL": "#6e7781", "TIMEOUT": "#9a6700", "ERROR": "#cf222e",
}


def fmt_int(s):
    try:
        return f"{int(s):,}"
    except (ValueError, TypeError):
        return html.escape(s or "")


def best(metric):
    res = {}
    for t in tests:
        vals = []
        for r in by_test[t]:
            try:
                vals.append((int(r[metric]), r["compiler"]))
            except (ValueError, TypeError):
                pass
        if vals:
            res[t] = min(vals)[1]
    return res


best_size = best("size_bytes")
best_ts = best("tstates")

CSS = """
 body{font:14px -apple-system,Segoe UI,Roboto,sans-serif;margin:2rem;color:#1f2328;background:#fff}
 h1{font-size:1.4rem;margin-bottom:.2rem} .sub{color:#6e7781;margin-bottom:1rem}
 table{border-collapse:collapse;width:100%;max-width:920px}
 th,td{padding:6px 12px;border-bottom:1px solid #d0d7de;text-align:right}
 th:first-child,td:first-child,th:nth-child(2),td:nth-child(2){text-align:left}
 tr.tsep td{border-top:2px solid #d0d7de}
 .v{font-weight:600;color:#fff;border-radius:4px;padding:2px 8px;font-size:12px}
 .best{background:#ddf4e4;border-radius:4px}
 .legend{margin-bottom:1rem} .legend span{margin-right:14px;font-size:13px}
 .dot{display:inline-block;width:10px;height:10px;border-radius:50%;margin-right:4px;vertical-align:middle}
 .note{color:#6e7781;font-size:12px;margin-top:10px;max-width:920px}
"""

p = []
p.append('<!doctype html><html><head><meta charset="utf-8">')
p.append("<title>compare3 - dcc vs clang vs zsdcc</title>")
p.append("<style>" + CSS + "</style></head><body>")
p.append("<h1>Compiler comparison - dcc vs clang vs zsdcc</h1>")
p.append(
    '<div class="sub">Z80 / CP/M .COM size (bytes) and execution T-states '
    "(z88dk-ticks). Generated %s.</div>" % datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
)
p.append('<div class="legend">')
for k in ["AGREE", "DIFF", "SOLO", "BUILD_FAIL"]:
    p.append('<span><span class="dot" style="background:%s"></span>%s</span>' % (vcolor[k], k))
p.append('<span><span class="best" style="padding:2px 6px">&nbsp;</span> best in row</span></div>')
p.append("<table><thead><tr><th>test</th><th>compiler</th><th>size (B)</th>"
         "<th>T-states</th><th>verdict</th></tr></thead><tbody>")

for ti, t in enumerate(tests):
    for ri, r in enumerate(by_test[t]):
        sep = ' class="tsep"' if ri == 0 and ti > 0 else ""
        comp, v = r["compiler"], r["verdict"]
        col = vcolor.get(v, "#6e7781")
        size_raw, ts_raw = r["size_bytes"], r["tstates"]
        scls = ' class="best"' if best_size.get(t) == comp and size_raw not in ("BUILD_FAIL", "") else ""
        tcls = ' class="best"' if best_ts.get(t) == comp and ts_raw not in ("BUILD_FAIL", "") else ""
        sdisp = "&mdash;" if size_raw in ("BUILD_FAIL", "") else fmt_int(size_raw)
        tdisp = "&mdash;" if ts_raw in ("", "BUILD_FAIL") else fmt_int(ts_raw)
        p.append(
            "<tr%s><td>%s</td><td>%s</td><td%s>%s</td><td%s>%s</td>"
            '<td><span class="v" style="background:%s">%s</span></td></tr>'
            % (sep, html.escape(t) if ri == 0 else "", html.escape(comp),
               scls, sdisp, tcls, tdisp, col, html.escape(v))
        )
p.append("</tbody></table>")
p.append(
    '<div class="note">AGREE = output matches at least one peer (cross-validated) &middot; '
    "DIFF = outlier vs every peer (suspect) &middot; BUILD_FAIL = compiler could not build &middot; "
    "best = smallest size / fewest T-states in the row.</div>"
)
p.append("</body></html>")

open(out, "w").write("".join(p))
print("wrote", out)


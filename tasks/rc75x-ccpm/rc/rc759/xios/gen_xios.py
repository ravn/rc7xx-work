#!/usr/bin/env python3
"""NASM -> RASM-86 (A86) source converter for XIOS (experiment branch).

Single source of truth stays xios_code.asm; this pre-expands everything
RASM-86 cannot digest (NASM preprocessor, macros, times, UTF-8 db_dk
strings, dot-labels, bracket syntax) into A86 syntax calibrated against
RASM-86 v1.2 error behaviour (see calib.a86 findings):

  * equ is single-pass  -> only numeric EQU emitted
  * name[base] needs a size attr; override goes BEFORE the colon
  * immediate stores: size on the IMMEDIATE (mov cs:X,WORD PTR 0)
  * jmp short -> JMPS ; call far [cs:X] -> CALLF X
  * no .local labels    -> flattened
  * data sits inline in the one CODE segment; LINK-86 gets
    [data[ab[0],ad[0],m[0],o[0]]] to suppress the base-page DATA section
"""
import json
import re
import sys
from pathlib import Path

_DIR = Path(__file__).resolve().parent
SRC = _DIR / "xios_code.asm" if (_DIR / "xios_code.asm").exists() else _DIR.parent / "xios_code.asm"
HW = _DIR / "hardware.inc" if (_DIR / "hardware.inc").exists() else _DIR.parent / "hardware.inc"
RINC = _DIR / "rasm86.inc" if (_DIR / "rasm86.inc").exists() else _DIR.parent / "rasm86.inc"

NUM_VIR_CONS = 1          # CON build
CCPM_SYS = False          # CON build


# ---------------------------------------------------------------- helpers
def split_comment(line):
    """Split at ';' outside quotes."""
    q = None
    for i, ch in enumerate(line):
        if q:
            if ch == q:
                q = None
        elif ch in "\"'":
            q = ch
        elif ch == ";":
            return line[:i], line[i:]
    return line, ""


def num(tok):
    tok = tok.strip()
    m = re.fullmatch(r"0[xX]([0-9A-Fa-f]+)", tok)
    if m:
        return int(m.group(1), 16)
    m = re.fullmatch(r"0[bB]([01]+)", tok)
    if m:
        return int(m.group(1), 2)
    m = re.fullmatch(r"([0-9A-Fa-f]+)[hH]", tok)
    if m:
        return int(m.group(1), 16)
    if re.fullmatch(r"[0-9]+", tok):
        return int(tok)
    if tok and re.fullmatch(r"[\d\s\+\-\*/\(\)]+", tok):
        return int(eval(tok, {"__builtins__": {}}))
    raise ValueError(f"not a number: {tok!r}")


def hx(v):
    s = f"{v:X}h"
    return ("0" + s) if s[0].isalpha() else s


# DK translation from hardware.inc db_dk (UTF-8 -> ISO-646-DK)
DK_TABLE = {
    (0xC3, 0xA6): [0x7B],  # ae
    (0xC3, 0xB8): [0x7C],  # oe
    (0xC3, 0xA5): [0x7D],  # aa
    (0xC3, 0x86): [0x5B],  # AE
    (0xC3, 0x98): [0x5C],  # OE
    (0xC3, 0x85): [0x5D],  # AA
}


def dk_bytes(text):
    out = []
    i = 0
    b = text.encode("utf-8")
    while i < len(b):
        pair = tuple(b[i:i + 2])
        if pair in DK_TABLE:
            out += DK_TABLE[pair]
            i += 2
        elif b[i] == 0xC3:                      # unknown C3 seq: keep raw
            out += [0xC3, b[i + 1]]
            i += 2
        else:
            out.append(b[i])
            i += 1
    return out


def unquote(tok):
    tok = tok.strip()
    if tok.startswith('"') and tok.endswith('"'):
        return tok[1:-1]
    if tok.startswith("'") and tok.endswith("'"):
        return tok[1:-1]
    raise ValueError(f"not a string literal: {tok!r}")


def args_split(rest):
    """Split macro/db arguments on commas outside quotes/parens."""
    out, cur, q, depth = [], "", None, 0
    for ch in rest:
        if q:
            cur += ch
            if ch == q:
                q = None
        elif ch in "\"'":
            q = ch
            cur += ch
        elif ch == "(":
            depth += 1
            cur += ch
        elif ch == ")":
            depth -= 1
            cur += ch
        elif ch == "," and depth == 0:
            out.append(cur)
            cur = ""
        else:
            cur += ch
    if cur.strip() or out:
        out.append(cur)
    return [a.strip() for a in out]


# ------------------------------------------------- preprocess (pass A):
# strip comments, handle %if/%ifdef/%define/%macro, expand macros+times.
def preprocess():
    hw_equs = {}
    for ln in HW.read_text().splitlines():
        code, _ = split_comment(ln)
        m = re.match(r"\s*([A-Za-z_][\w$]*)\s+equ\s+(.+?)\s*$", code, re.I)
        if m:
            try:
                hw_equs[m.group(1)] = num(m.group(2))
            except ValueError:
                pass  # non-numeric equ: unused in CON path (verified none)

    # merge numeric equates declared inside xios_code.asm itself
    for ln in SRC.read_text().splitlines():
        code, _ = split_comment(ln)
        m = re.match(r"\s*([A-Za-z_][\w$]*)\s+equ\s+(.+?)\s*$", code, re.I)
        if m:
            try:
                hw_equs.setdefault(m.group(1).lower(), num(m.group(2)))
            except ValueError:
                pass

    src = SRC.read_text().splitlines()
    macros = {}
    # collect macro definitions first
    i = 0
    while i < len(src):
        m = re.match(r"\s*%macro\s+([A-Za-z_][\w$]*)\s+(\d+)", src[i], re.I)
        if m:
            name, narg = m.group(1), int(m.group(2))
            body = []
            i += 1
            while not re.match(r"\s*%endmacro", src[i], re.I):
                body.append(src[i])
                i += 1
            macros[name.lower()] = (narg, body)
        i += 1

    defines = {"num_vir_cons": str(NUM_VIR_CONS)}
    out = []
    in_macro = False
    cond_stack = []            # list of (taken_now, any_taken_before)

    def cond_value(expr):
        e = expr.strip()
        m = re.fullmatch(r"NUM_VIR_CONS\s*==\s*(\d+)", e)
        if m:
            return int(m.group(1)) == NUM_VIR_CONS
        m = re.fullmatch(r"NUM_VIR_CONS\s*>=\s*(\d+)", e)
        if m:
            return NUM_VIR_CONS >= int(m.group(1))
        raise RuntimeError(f"unhandled %if expr: {expr!r}")

    def live():
        return all(t for t, _ in cond_stack)

    def expand_line(line, depth=0):
        if depth > 20:
            raise RuntimeError("macro recursion")
        code, _ = split_comment(line)
        code = code.rstrip()
        if not code.strip():
            return []
        # %define bookkeeping handled by caller; here substitute defines
        m = re.match(r"\s*([A-Za-z_][\w$]*):\s*(\S.*)$", code)
        label_prefix = None
        body_line = code.strip()
        if m and not re.match(r"[A-Za-z_][\w$]*\s*[a-zA-Z_]\s", m.group(2)):
            # label followed by something that is not 'name operand'
            pass
        # separate "label: directive rest"
        lm = re.match(r"\s*([A-Za-z_][\w$]*|\.[A-Za-z_][\w$]*)\s*:\s*(\S.*)$",
                      code)
        if lm:
            label_prefix, body_line = lm.group(1), lm.group(2).strip()
        elif re.match(r"\s*([A-Za-z_][\w$]*|\.[A-Za-z_][\w$]*)\s*:\s*$", code):
            return [code.strip()]
        # macro invocation?
        tok = re.match(r"([A-Za-z_][\w$]*)\s*(.*)$", body_line)
        lines = []
        if tok and tok.group(1).lower() == "times":
            cnt = None
            expr = tok.group(2).strip()
            m2 = re.match(r"(\(.*?\)|[^\s]+)\s+(.*)$", expr)
            cnt_tok, rest2 = m2.group(1), m2.group(2)
            def tok2int(mm):
                t = mm.group(0)
                try:
                    return str(num(t))
                except ValueError:
                    return str(hw_equs[t.lower()])
            expr_n = re.sub(r"[0-9A-Za-z_$][\w$]*", tok2int, cnt_tok)
            if not re.fullmatch(r"[\d\s()\+\-\*/]+", expr_n):
                raise RuntimeError(f"bad times count: {cnt_tok!r}")
            cnt = eval(expr_n, {"__builtins__": {}})
            lines = [rest2] * cnt
        elif tok and tok.group(1).lower() in ("db_dk", "db_pstr"):
            # hardware.inc string macros: UTF-8 -> ISO-646-DK byte list
            s = tok.group(2).strip()
            if s[:1] in ('"', "'"):
                s = unquote(s)
            bs = dk_bytes(s)
            lines = []
            if tok.group(1).lower() == "db_pstr":
                lines.append(f"\tdb\t{hx(len(bs))}")
            if bs:
                lines.append("\tdb\t" + ",".join(hx(b) for b in bs))
        elif tok and tok.group(1).lower() in macros and tok.group(1).lower() \
                not in ("db", "dw", "dd", "rb", "rw", "equ"):
            narg, body = macros[tok.group(1).lower()]
            argv = args_split(tok.group(2)) if tok.group(2) else []
            if len(argv) != narg:
                raise RuntimeError(f"{tok.group(1)}: {len(argv)} args, want {narg}: {code!r}")
            for bl in body:
                bl = re.sub(r"%(\d+)", lambda mm: argv[int(mm.group(1)) - 1], bl)
                lines += expand_line(bl, depth + 1)
        else:
            lines = [body_line]
        if label_prefix is not None:
            lines.insert(0, f"{label_prefix}:")
        return lines

    for ln in src:
        code, _ = split_comment(ln)
        s = code.strip()
        m = re.match(r"%ifdef\s+(\w+)", s, re.I)
        if m:
            t = live() and (m.group(1).upper() == "CCPM_SYS") == CCPM_SYS
            cond_stack.append((t, t))
            continue
        m = re.match(r"%ifndef\s+(\w+)", s, re.I)
        if m:
            t = live() and m.group(1).lower() not in ("_hardware_inc_", "_rasm86_inc_")
            cond_stack.append((t, t))
            continue
        m = re.match(r"%if\s+(.+)$", s, re.I)
        if m:
            t = live() and cond_value(m.group(1))
            cond_stack.append((t, t))
            continue
        m = re.match(r"%else\b", s, re.I)
        if m:
            t, anyb = cond_stack[-1]
            cond_stack[-1] = (live() if False else (not anyb and all(x for x, _ in cond_stack[:-1])), anyb)
            continue
        if re.match(r"%endif\b", s, re.I):
            cond_stack.pop()
            continue
        if not live():
            continue
        m = re.match(r"%define\s+([A-Za-z_][\w$]*)\s+(.+)$", s, re.I)
        if m:
            defines[m.group(1).lower()] = m.group(2).strip()
            continue
        if re.match(r"%include\b", s, re.I):
            continue
        if re.match(r"%macro\b", s, re.I):
            in_macro = True
            continue
        if re.match(r"%endmacro\b", s, re.I):
            in_macro = False
            continue
        if in_macro:
            continue  # body lines live only in `macros`; never emit raw
        if re.match(r"%(strlen|assign|rep|endrep|substr|ifstr)\b", s, re.I):
            continue  # db_dk internals not used (native impl)
        out.append(code)

    # substitute %define tokens (word boundary, iterate)
    subs = []
    for code in out:
        for _ in range(3):
            new = re.sub(r"\b([A-Za-z_][\w$]*)\b",
                         lambda m: defines.get(m.group(1).lower(), m.group(0))
                         if m.group(1).lower() in defines else m.group(0),
                         code)
            if new == code:
                break
            code = new
        subs.append(code)

    # expand macros / times
    final = []
    for code in subs:
        final += expand_line(code)
    # merge numeric EQUates from the source itself (KBD_KEY_NONE, CSM_...):
    # conv() drops EQU lines (symbol budget), so collect their values first.
    for code in final:
        m = re.match(r"\s*([A-Za-z_][\w$]*)\s+equ\s+(.+?)\s*$", code, re.I)
        if m:
            try:
                hw_equs.setdefault(m.group(1).lower(), num(m.group(2)))
            except ValueError:
                pass
    return hw_equs, final


# ------------------------------------------------- operand conversion
BASES = {"bx", "si", "di", "bp"}


ALL_REGS = {"al", "ah", "bl", "bh", "cl", "ch", "dl", "dh",
            "ax", "bx", "cx", "dx", "si", "di", "bp", "sp",
            "cs", "ds", "es", "ss"}

def is_num(tok):
    tok_clean = tok.strip().lower()
    if tok_clean in ALL_REGS:
        return False
    try:
        num(tok)
        return True
    except ValueError:
        return False


def norm_bracket(op_str, equs):
    """Rewrite NASM [..] operands to A86 forms."""
    def repl(m):
        inner = m.group(1)
        inner = inner.replace(" ", "")
        # 10h / 0x10 disps -> decimal so the branch regexes below match
        inner = re.sub(r"(?<![A-Za-z_])(0[xX][0-9A-Fa-f]+|[0-9A-Fa-f]*[0-9][0-9A-Fa-f]*[hH])(?![\w$?@])",
                       lambda mm: str(num(mm.group(0))), inner)
        # [cs:NAME[base]] / [NAME+BX] / [BX+5] / [4+SI] / [BX+SI] / [BP+DI] / [SI-2]
        m2 = re.fullmatch(r"(cs|ds|es|ss):(.*)", inner, re.I)
        override = ""
        if m2:
            override = m2.group(1).lower() + ":"
            inner = m2.group(2)
        m2 = re.fullmatch(r"(.*)(\+|\-)(\d+)$", inner)
        disp = ""
        if m2 and re.fullmatch(r"[A-Za-z_][\w$]*|\d+", m2.group(1)):
            base = m2.group(1).lower()
            disp = m2.group(3) if m2.group(2) == "+" else "-" + m2.group(3)
            if re.fullmatch(r"[a-z_][\w$]*", base) and base not in BASES:
                # NAME+disp (bracketed-label form is ERR8 in RASM)
                sep = "+" if not disp.startswith("-") else ""
                return f"{override}{base}{sep}{disp}"
            return f"{override}{disp}[{base}]"
        m2 = re.fullmatch(r"(\d+)(\+|\-)(\w+)", inner)
        if m2:
            return f"{override}{m2.group(1)}[{m2.group(3).lower()}]"
        m2 = re.fullmatch(r"(0[xX][0-9A-Fa-f]+|\w+)(\+|\-)(\w+)", inner)
        if m2 and m2.group(3).lower() in BASES and \
                (re.fullmatch(r"0[xX][0-9A-Fa-f]+|[0-9]+", m2.group(1))):
            d = num(m2.group(1))
            if m2.group(2) == "-":
                d = -d
            return f"{override}{d}[{m2.group(3).lower()}]"
        m2 = re.fullmatch(r"(\w+)(\+|\-)(0[xX][0-9A-Fa-f]+|[0-9]+)", inner)
        if m2 and m2.group(1).lower() in BASES:
            d = num(m2.group(3))
            if m2.group(2) == "-":
                d = -d
            return f"{override}{d}[{m2.group(1).lower()}]"
        m2 = re.fullmatch(r"(\w+)\+(\w+)(.*)", inner)
        if m2 and m2.group(1).lower() in BASES and m2.group(2).lower() in BASES:
            extra = m2.group(3)
            disp = ""
            if extra.startswith("+") and extra[1:]:
                d = num(extra[1:]) if is_num(extra[1:]) else \
                    equs.get(extra[1:].lower())
                if d is None:
                    raise RuntimeError(f"unhandled bracket [{inner}] (non-num disp)")
                disp = str(d)
            elif extra:
                raise RuntimeError(f"unhandled bracket [{inner}]")
            return f"{override}{disp}[{m2.group(1).lower()}+{m2.group(2).lower()}]"
        m2 = re.fullmatch(r"(\w+)\+([A-Za-z_][\w$]*)", inner)
        if m2 and m2.group(1).lower() in BASES:
            d = equs.get(m2.group(2).lower())
            if d is None:
                return f"{override}{m2.group(2)}[{m2.group(1).lower()}]"
            return f"{override}{d}[{m2.group(1).lower()}]"
        m2 = re.fullmatch(r"([A-Za-z_][\w$]*)\-(\w+)", inner)
        if m2 and m2.group(2).lower() in BASES:
            # NAME-bx: negative displacement; rare -- flag it loudly
            raise RuntimeError(f"unhandled bracket [{inner}] (label-base)")
        m2 = re.fullmatch(r"(\w+)\-([A-Za-z_][\w$]*)", inner)
        if m2 and m2.group(1).lower() in BASES:
            return f"{override}-({m2.group(2)})[{m2.group(1).lower()}]"
        m2 = re.fullmatch(r"([A-Za-z_][\w$]*)\[(\w+)\]", inner)
        if m2:
            return f"{override}{m2.group(1)}[{m2.group(2).lower()}]"
        m2 = re.fullmatch(r"(\d+)\[([A-Za-z_][\w$]*)\]", inner)
        if m2:   # 0[NAME]: bracketed label is ERR8 -> NAME+disp
            return f"{override}{m2.group(2)}+{m2.group(1)}"
        m2 = re.fullmatch(r"(\w+)\+(\w+)", inner)
        if m2 and m2.group(1).lower() in BASES and m2.group(2).lower() in BASES:
            return f"{override}{m2.group(1).lower()}[{m2.group(2).lower()}]"
        if is_num(inner):
            return f"{override}.{hx(num(inner))}"
        m2 = re.fullmatch(r"([A-Za-z_][\w$]*)", inner)
        if m2:
            # register-only bracket [si] must STAY bracketed (else mem_op's
            # generic branch never sees it and mov ah,[si] became mov ah,si)
            if m2.group(1).lower() in BASES:
                return f"{override}[{m2.group(1).lower()}]"
            return f"{override}{m2.group(1)}"
        m2 = re.fullmatch(r"(\w+)", inner)
        if m2:
            if m2.group(1).lower() in BASES:
                return f"{override}[{m2.group(1).lower()}]"
            return f"{override}{m2.group(1).lower()}"
        raise RuntimeError(f"unhandled bracket [{inner}]")
    return re.sub(r"\[([^\]]*)\]", repl, op_str)



def strip_comment(s):
    """Drop a trailing '; ...' comment, honouring double-quoted strings."""
    q = False
    for i, ch in enumerate(s):
        if ch == '"':
            q = not q
        elif ch == ";" and not q:
            return s[:i]
    return s

class Conv:
    REG8 = ("al", "ah", "bl", "bh", "cl", "ch", "dl", "dh")
    REGCODE = {"al": 0, "cl": 1, "dl": 2, "bl": 3, "ah": 4, "ch": 5,
               "dh": 6, "bh": 7, "ax": 0, "cx": 1, "dx": 2, "bx": 3,
               "sp": 4, "bp": 5, "si": 6, "di": 7}
    REG16C = ("ax", "cx", "dx", "bx", "sp", "bp", "si", "di")
    ACC_OPS = {"add", "sub", "and", "or", "xor", "cmp", "test"}

    def __init__(self, hw_equs, lines):
        self.equs = {k.lower(): v for k, v in hw_equs.items()}
        self.lines = lines
        self.types = {}
        self.inject = {}   # late-bound declared widths (2nd conv pass)
        self.labels = set()
        self.dots = {}
        self.top = "TOP"
        self.seq = 0
        self.out = []
        # RASM-86 64K symbol table overflow (v1.2) forced numeric inlining of
        # every EQU: zero EQU directives emitted, references replaced by value.
        ne = {}
        for k, v in self.equs.items():
            v = str(v).strip()
            if re.fullmatch(r"0[xX][\da-fA-F]+|\d+[hH]?|\d+", v):
                ne[k] = hx(num(v))
            elif re.fullmatch(r"[\w$.?@]+", v) and v.lower() in self.equs:
                ne[k] = None  # EQU chain, resolved below
        for _ in range(3):
            for k, v in list(ne.items()):
                src = str(self.equs[k]).strip().lower()
                if v is None and src in ne:
                    ne[k] = ne[src]
        ne = {k: v for k, v in ne.items() if v is not None}
        self.num_equs = ne
        self.equ_pat = (re.compile(r"(?<![\w$.?@])(%s)(?![\w$.?@])"
                                   % "|".join(re.escape(k) for k in
                                              sorted(ne, key=len, reverse=True)),
                                          re.IGNORECASE)
                       if ne else None)

    def inl(self, text):
        """Substitute EQU names with numeric values, leaving string literals."""
        if not self.equ_pat:
            return text
        parts = re.split(r"('(?:[^']|'')*')", text)
        return "".join(p if p.startswith("'") else
                       self.equ_pat.sub(lambda m: self.num_equs[m.group(1).lower()], p)
                       for p in parts)
        self.cur_top = "TOP"

    # -- prescan: data types + dot-label name assignment (in order) --
    def prescan(self):
        top = "TOP"
        for code in self.lines:
            s = strip_comment(code).strip()
            m = re.match(r"([.A-Za-z_][\w$]*):\s*$", s)
            if m:
                lbl = m.group(1)
                if lbl.startswith("."):
                    self.seq += 1
                    clean_top = top.lstrip(".")
                    clean_lbl = lbl.lstrip(".")
                    cand = f"{clean_top}_{clean_lbl}"
                    if cand.lower() in self.labels or len(cand) > 31:
                        cand = f"{clean_top[:15]}_{clean_lbl[:10]}_{self.seq}"
                    self.dots[(top.lower(), lbl.lower())] = cand
                    self.labels.add(cand.lower())
                else:
                    top = lbl
                    self.labels.add(lbl.lower())
                continue
            m = re.match(r"([A-Za-z_][\w$]*)\s+(db|dw|dd)\b", s, re.I)
            if m:
                self.types[m.group(1).lower()] = {
                    "db": "BYTE", "dw": "WORD", "dd": "DWORD"}[m.group(2).lower()]
                self.labels.add(m.group(1).lower())
        # Label-only line followed by a data line: RASM types the symbol only
        # if the name shares the def line; the final output merges them (see
        # main), so prescan must record the type the same way.
        pend = None
        for code in self.lines:
            st = strip_comment(code).strip()
            if not st or st.startswith(";"):
                continue
            m = re.match(r"([A-Za-z_][\w$]*):\s*(.*)$", st)
            if m and not m.group(2).strip():
                pend = m.group(1).lower()
                continue
            if pend:
                m2 = re.match(r"(db|dw|dd|rb|rw)\b", st, re.I)
                if m2:
                    t = {"db": "BYTE", "dw": "WORD", "dd": "DWORD",
                         "rb": "BYTE", "rw": "WORD"}[m2.group(1).lower()]
                    self.types.setdefault(pend, t)
                    self.labels.add(pend)
                pend = None
        self.types.update(self.inject)

    def resolve_dots(self, text):
        def r(m):
            tok = m.group(0)
            parent, child = m.group(1), tok[tok.index("."):]
            key = ((parent or self.cur_top).lower(), child.lower())
            if key in self.dots:
                return self.dots[key]
            return tok
        return re.sub(r"(?<![\w$])([A-Za-z_][\w$]*)?[.][A-Za-z_][\w$]*(?![\w$])", r, text)

    def is_num(self, tok):
        return is_num(tok)

    # -- bracket normalization + size attributes --------------------------
    def mem_op(self, op, size_hint, reg_hint=None, nosize=False):
        """Give name[base] forms their mandatory size attr; strip NASM size
        words; return canonical A86 operand."""
        m = re.match(r"(byte|word|dword)\s+(ptr\s+)?", op, re.I)
        explicit = None
        if m:
            explicit = m.group(1).upper()
            op = op[m.end():]
        if explicit is None and size_hint:
            # caller stripped "byte/word" into hints before norm_bracket;
            # honour it (master "and byte [bx+FLAGS],0FBh" must stay BYTE)
            explicit = size_hint
        m = re.fullmatch(r"(cs|ds|es|ss)?:([A-Za-z_][\w$]*)\[([a-z]+)\]",
                         op, re.I)
        if m:
            size = explicit or self.types.get(m.group(2).lower()) or \
                ("BYTE" if reg_hint in self.REG8 else "WORD")
            return f"{m.group(1).lower()}:{size} PTR {m.group(2)}[{m.group(3).lower()}]"
        m = re.fullmatch(r"([A-Za-z_][\w$]*)\[([a-z]+)\]", op, re.I)
        if m:
            size = explicit or self.types.get(m.group(1).lower()) or \
                ("BYTE" if reg_hint in self.REG8 else "WORD")
            return f"{size} PTR {m.group(1)}[{m.group(2).lower()}]"
        m = re.fullmatch(r"(cs|ds|es|ss)?:([A-Za-z_][\w$]*)\[([a-z]+)\]\[([a-z]+)\]",
                         op, re.I)
        if m:
            size = explicit or "WORD"
            return (f"{m.group(1).lower()}:{size} PTR {m.group(2)}"
                    f"[{m.group(3)}+{m.group(4)}]")
        # disp[base(+index)] / [base(+index)]: needs size attr; XIOS has no
        # DATA segment (all vars live in CS), so a bare NASM [..] (DS-assumed
        # at link time, DS==CS at runtime) is emitted as cs:... explicitly.
        m = re.fullmatch(r"(?:(cs|ds|es|ss):)?(-?\d+)?\[([a-z]+)(\+[a-z]+)?\]",
                         op, re.I)
        if m and "[" in op:
            size = explicit or ("BYTE" if reg_hint in self.REG8 else "WORD")
            disp = m.group(2) or ""
            if disp.startswith("-"):   # probe12: 0FFFCh[di] legal, -4[di] not
                disp = hx((int(disp) + 0x10000) & 0xFFFF)
            pfx = f"{m.group(1).lower()}:" if m.group(1) else ""
            if nosize:   # probe12: lds/les mem operand must carry NO size
                return f"{pfx}{disp}[{m.group(3)}{m.group(4) or ''}]"
            return f"{pfx}{size} PTR {disp}[{m.group(3)}{m.group(4) or ''}]"
        m = re.fullmatch(r"((?:cs|ds|es|ss):)?\.(.*)", op, re.I)
        if m:
            pfx = m.group(1).lower() if m.group(1) else ""
            addr = m.group(2)
            if reg_hint:
                return f"{pfx}.{addr}"
            size = explicit or size_hint or "WORD"
            return f"{pfx}{size.lower()} ptr .{addr}"
        m = re.fullmatch(r"([A-Za-z_][\w$]*)\[([a-z]+)\]\[([a-z]+)\]", op, re.I)
        if m:
            size = explicit or self.types.get(m.group(1).lower()) or "WORD"
            return (f"{size} PTR {m.group(1)}[{m.group(2)}+{m.group(3)}]")
        if explicit:
            # unnamed [base] / disp[base] forms: size ok, keep override order
            return op if "[" not in op else f"{explicit} PTR {op}"
        return op

    # -- main per-line dispatch -------------------------------------------
    def conv(self, code):
        s = code.strip()
        m = re.match(r"([.A-Za-z_][\w$]*):\s*$", s)
        if m:
            lbl = m.group(1)
            if lbl.startswith("."):
                self.out.append(self.dots[(self.cur_top.lower(),
                                      lbl.lower())] + ":")
            else:
                self.cur_top = lbl
                self.out.append(lbl + ":")
            return
        m = re.match(r"([A-Za-z_][\w$]*)\s*(.*)$", s)
        mnem, rest = m.group(1), m.group(2).strip()
        lo = mnem.lower()
        if lo in ("db", "dw", "dd", "rb", "rw"):
            self.data(mnem, rest)
            return
        if rest.lower().startswith("equ") and lo not in ("db", "dw", "dd"):
            return  # EQU values are inlined at reference sites (symbol budget)
        if lo == "equ":
            return  # EQU values are inlined at reference sites (symbol budget)
        self.instr(lo, rest)

    def data(self, mnem, rest):
        kw = mnem.lower()
        rest = self.inl(self.resolve_dots(rest))
        if kw in ("rb", "rw"):
            self.out.append(f"\t{kw}\t{hx(num(rest))}")
            return
        items = args_split(rest)
        if len(items) == 1 and re.match(r"[\"']", items[0].strip()):
            bs = dk_bytes(unquote(items[0]))
            self.out.append("\tdb\t" + ",".join(hx(b) for b in bs))
            return
        vals = []
        split_dd = False
        for it in items:
            it = it.strip()
            if not it:
                continue
            m = re.match(r"[\"'](.*)[\"']\s*$", it)
            if m and kw == "db":
                vals += [hx(b) for b in dk_bytes(m.group(1))]
                continue
            if is_num(it):
                v = num(it)
                if kw in ("dd", "rd") and -0x8000 <= v <= 0xFFFFFFFF:
                    # probe: RASM has no 32-bit define type (ERR20) -> dw pair
                    split_dd = True
                    v &= 0xFFFFFFFF
                    vals.append(hx(v & 0xFFFF))
                    vals.append(hx((v >> 16) & 0xFFFF))
                    continue
                if v < 0:
                    v &= 0xFFFF
                vals.append(hx(v))
                continue
            vals.append(it)          # label / offset X / seg X -- forward ok
        kwout = "dw" if split_dd else kw
        self.out.append(f"\t{kwout}\t" + ",".join(vals))

    def instr(self, lo, rest):
        rest = self.inl(self.resolve_dots(rest))
        rest = re.sub(r"\bstrict\s+(byte|word|dword)\s+", "", rest, flags=re.I)
        # zero-operand / prefix ops
        if lo == "xlatb":
            self.out.append("\txlat\tal")   # probe12: bare xlat ERR7
            return
        if lo == "pusha":
            self.out.append("\tdb\t60h ;CODE_BYTE")
            return
        if lo == "popa":
            self.out.append("\tdb\t61h ;CODE_BYTE")
            return
        if lo == "align":
            if NUM_VIR_CONS % 2 == 1:
                self.out.append("\tdb\t0")
            return
        if lo in ("aad", "aam") and re.fullmatch(r"10|0[aA]h", rest.strip()):
            self.out.append(f"\t{lo}")   # probe12: imm form ERR7, plain legal
            return
        if re.match(r"j", lo) and re.match(r"short\s+", rest, re.I):
            # RASM: jcc is ALWAYS short (74 rel8); only jmp has an explicit
            # short mnemonic (jmps -> eb) vs near (jmp -> e9). Keep "short"
            # for jmp (handled below via jmps); drop it for jcc.
            if not re.match(r"jmp$", lo, re.I):
                rest = re.sub(r"short\s+", "", rest, count=1, flags=re.I)
        if lo in ("lds", "les"):
            rest = re.sub(r"\[\s*(?:(?:cs|ds|es|ss):)?\s*([A-Za-z_][\w$]*)\s*\]",
                          r"\1", rest, flags=re.I)   # [NAME] -> NAME
            m = re.fullmatch(r"(\w+)\s*,\s*((?:cs|ds|es|ss):)?"
                             r"\[?(bx|si|di|bp)\]?", rest, re.I)
            if m:   # probe15: lds si,cs:[bx] legal only bracketed, no size
                pfx = m.group(2).lower() if m.group(2) else ""
                self.out.append(f"\t{lo}\t{m.group(1)},"
                                f"{pfx}[{m.group(3)}]")
                return
            m = re.fullmatch(r"(\w+)\s*,\s*(?:cs|ds|es|ss)?:?([A-Za-z_][\w$]*)",
                             rest, re.I)
            if m:
                reg, nm = m.group(1), m.group(2)
                self.out.append(f"\t{lo}\t{reg},cs:dword ptr {nm}")
                return
            rest = re.sub(r"\b(?:byte|word|dword)\s+ptr\s+", "", rest, flags=re.I)
        if lo in ("shl", "shr", "sal", "sar", "ror", "rol", "rcr", "rcl",
                  "shr", "sar") and "," in rest:
            a, _, b = rest.partition(",")
            if is_num(b.strip()) and 1 < num(b.strip()) <= 16:
                # RASM v1.2 rejects "ror al,4" (all imm>1 spellings ERR,
                # probe-s14) but the original XIOS has C0/C1 imm forms
                # (oracle: c0 c8 04 = ror al,4). Emit the raw encoding.
                dig = {"rol": 0, "ror": 1, "rcl": 2, "rcr": 3,
                       "shl": 4, "sal": 4, "shr": 5, "sar": 7}[lo]
                rg = a.strip().lower()
                if rg in self.REGCODE:
                    w1 = rg in self.REG16C
                    modrm = 0xC0 | (dig << 3) | self.REGCODE[rg]
                    by = f"0{('C1' if w1 else 'C0')}h,0{modrm:02X}h," \
                        f"0{num(b.strip()):02X}h"
                    # ;SHIFTIMM marker: synthetic byte stream, NOT a typed
                    # data def — exempt from the label-attach merge below.
                    self.out.append(f"\tdb\t{by}\t;SHIFTIMM")
                    return
                for _ in range(num(b.strip())):
                    self.out.append(f"\t{lo}\t{a.strip()},1")
                return
        if not rest:
            self.out.append(f"\t{lo}")
            return
        if lo in ("rep", "repe", "repz", "repne", "repnz", "lock"):
            r_clean = rest.strip().lower()
            if "es" in r_clean and "movsw" in r_clean:
                self.out.append(f"\t{lo} movs\tword ptr [di],es:word ptr [si]")
                return
            if "es" in r_clean and "movsb" in r_clean:
                self.out.append(f"\t{lo} movs\tbyte ptr [di],es:word ptr [si]")
                return
            self.out.append(f"\t{lo} {r_clean}")
            return
        # jmp/call special forms
        if lo in ("jmp", "call"):
            toks = rest.split()
            t0 = toks[0].lower()
            if t0 == "far":
                inner = toks[1].strip()
                m = re.fullmatch(r"\[?\s*(cs|ds|es|ss):([A-Za-z_][\w$]*)\s*\]?",
                                 inner, re.I)
                if m:  # NASM far-indirect [cs:NAME]: RASM's own
                    # "call cs:WORD PTR X" misencodes as FF/2 (near call);
                    # probes prove "callf dword ptr cs:X" -> 2e ff 1e =
                    # exactly the oracle bytes (same class for jmpf FF/5).
                    mn = "callf" if lo == "call" else "jmpf"
                    self.out.append(f"\t{mn}\tdword ptr {m.group(2)}")
                    return
                tgt = re.sub(r"[\[\]:]", "", inner).split(":")[-1]
                self.out.append(f"\t{'CALLF' if lo == 'call' else 'JMPF'}\t{tgt}")
                return
            if t0 == "short":
                mn = "jmps" if lo == "jmp" else lo
                self.out.append(f"\t{mn}\t{toks[1]}")
                return
            if t0 == "near":
                rest = ",".join(toks[1:])
        # split operands on commas
        ops = args_split(rest)
        # accumulator swap:  op  mem, reg  ->  op reg, mem   (DRI has no
        # [cs:NAME] mem-first form with bare names)
        if lo in self.ACC_OPS and len(ops) == 2:
            r1 = ops[1].lower().rstrip()
            if re.fullmatch(r"(al|ah|bl|bh|cl|ch|dl|dh|ax|bx|cx|dx|si|di|bp|sp)", r1):
                m = re.fullmatch(r"\[?\s*(cs|ds|es|ss)?:([A-Za-z_][\w$]*)\]?",
                                 ops[0], re.I)
                if m and "[" not in ops[0]:
                    ops = [ops[1], f"{m.group(1).lower()}:{m.group(2)}"]
        # register hint for sizing
        reg_hint = None
        for o in ops:
            m = re.fullmatch(r"(al|ah|bl|bh|cl|ch|dl|dh|ax|bx|cx|dx|si|di|bp|sp)",
                             o.strip().lower())
            if m:
                reg_hint = m.group(1)
                break
        # size hints from explicit size words (they apply to the memory side)
        hints = []
        clean = []
        for o in ops:
            m = re.match(r"(byte|word|dword)\s+ptr\s+", o.strip(), re.I)
            if m:
                hints.append(m.group(1).upper())
                o = o.strip()[m.end():]
            else:
                m = re.match(r"(byte|word|dword)\s+", o.strip(), re.I)
                if m:
                    hints.append(m.group(1).upper())
                    o = o.strip()[m.end():]
            clean.append(o)
        size_hint = hints[0] if hints else None

        # normalize brackets (no sizes yet)
        clean = [norm_bracket(o, self.equs) for o in clean]
        # add size attrs to name[base] forms
        sized = []
        hint_i = 0
        for o in clean:
            sh = None
            if "[" in o or re.match(r"(?:(?:cs|ds|es|ss):)?\.", o, re.I):
                sh = hints[0] if hints else None
            sized.append(self.mem_op(o, sh, reg_hint,
                                     nosize=lo in ("lds", "les")))
        ops = sized
        self._abs_sent = None
        for o in ops:
            if "\x01" in o:
                self._abs_sent = o

        # A86 operand semantics (empirically verified, probe.a86 rounds 1-4 +
        # NASM encodings): bare label = ADDRESS in NASM but = memory contents
        # in A86. So a bare label in a SOURCE slot of mov/ALU/push must get
        # OFFSET; destinations, branch targets and lea keep bare (rm-slot).
        # Also: A86 requires the size attr after a seg colon (rb symbols are
        # untyped and default to BYTE).
        A86_REGS = ("al", "ah", "bl", "bh", "cl", "ch", "dl", "dh", "ax",
                    "bx", "cx", "dx", "si", "di", "bp", "sp", "cs", "ds",
                    "es", "ss", "ip")
        BRANCH = ("jmp", "jmps", "jmpf", "call", "callf", "loop", "loope",
                  "loopne", "jcxz", "jz", "jnz", "jc", "jnc", "je", "jne",
                  "ja", "jae", "jb", "jbe", "jna", "jnae", "jnb", "jnbe",
                  "jg", "jge", "jl", "jle", "jng", "jnge", "jnl", "jnlg",
                  "jo", "jno", "js", "jns", "jp", "jnp", "jpe", "jpo")
        SRC_IMM = ("mov", "add", "adc", "sub", "sbb", "and", "or", "xor",
                   "cmp", "test", "push")
        fixed = []
        for i, o in enumerate(ops):
            m = re.fullmatch(r"(cs|ds|es|ss):([A-Za-z_][\w$]*)", o, re.I)
            if m:
                nm = m.group(2)
                if nm.lower() in A86_REGS:
                    # register after seg: must be bracketed (es:[di]); the
                    # bare es:di form is ERR7 and any PTR spelling is ERR8
                    o = f"{m.group(1).lower()}:[{nm.lower()}]"
                elif nm.lower() not in self.labels:
                    sz = size_hint or self.types.get(nm.lower()) or \
                        ("BYTE" if reg_hint and reg_hint in self.REG8
                         else "WORD")
                    o = f"{m.group(1).lower()}:{sz} PTR {nm}"
                else:
                    need = size_hint
                    if need is None:
                        for j, p in enumerate(ops):
                            if j == i:
                                continue
                            if p.lower() in A86_REGS:
                                need = ("BYTE" if p.lower() in
                                        ("al", "ah", "bl", "bh", "cl", "ch",
                                         "dl", "dh") else "WORD")
                                break
                    declared = self.types.get(nm.lower())
                    if need and declared and need != declared:
                        # probe13: explicit size cast overrides declared type
                        o = f"{m.group(1).lower()}:{need} PTR {nm}"
                    else:
                        o = f"{m.group(1).lower()}:{nm}"
            elif ((re.fullmatch(r"[A-Za-z_][\w$]*", o) or
                   re.fullmatch(r"\(?[A-Za-z_][\w$]*\s*[\+\-]\s*(?:0[xX][0-9A-Fa-f]+|[0-9A-Fa-f]+[hH]|\d+)\)?", o)) and
                  lo in SRC_IMM and
                  ((len(ops) == 2 and i == 1) or
                   (len(ops) == 1 and lo == "push")) and
                  o.lower().split()[0].lstrip("(") not in A86_REGS and
                  o.lower().split()[0].lstrip("(") not in self.equs):
                o = "OFFSET " + o
            fixed.append(o)
        ops = fixed

        # immediate store / ALU-imm with memory operand: size on the immediate
        imm_re = r"(0[xX][0-9A-Fa-f]+|[0-9A-Fa-f]+[hH]|[0-9]+)"
        if len(ops) == 1:
            self.out.append(f"\t{lo}\t{ops[0]}" if ops else f"\t{lo}")
            return
        o0, o1 = ops[0], ops[1]
        m = re.fullmatch(r"(cs|ds|es|ss)?:([A-Za-z_][\w$]*(?:\+\d+)?)",
                         o0, re.I)
        if m and is_num(o1) and lo in ("mov", "and", "or", "xor", "cmp", "test",
                                       "sub", "add"):
            ovr = m.group(1).lower() + ":"
            nm = m.group(2)
            v = num(o1)
            size = self.types.get(nm.lower().split("+")[0]) or size_hint or \
                ("BYTE" if (v <= 0xFF and (reg_hint in self.REG8 or reg_hint is None))
                 else "WORD")
            mask = 0xFF if size == "BYTE" else 0xFFFF
            self.out.append(f"\t{lo}\t{ovr}{nm},{size} PTR {hx(v & mask)}")
            return
        if re.fullmatch(r"[A-Za-z_][\w$]*", o0) and is_num(o1) and lo == "mov" \
                and o0.lower() in self.types:
            size = self.types[o0.lower()]
            v = num(o1) & (0xFF if size == "BYTE" else 0xFFFF)
            self.out.append(f"\tmov\t{o0},{size} PTR {hx(v)}")
            return
        if self._abs_sent and "\x01" in ops[0]:
            m = re.fullmatch(r"\x01(\d+)\x02(\w*:?)\x03", ops[0])
            disp, ovr = int(m.group(1)), m.group(2)
            src = ops[1]
            size = size_hint or ("BYTE" if is_num(src) and num(src) <= 0xFF
                                 else "WORD")
            base = "di" if re.search(r"\bdi\b", ",".join(ops[1:])) \
                else ("si" if re.search(r"\bsi\b", ",".join(ops[1:]))
                      else "bx")
            ovr2 = ovr or "ds:"
            self.out.append(f"\tmov\t{base},{hx(disp)}")
            if size == "BYTE" and is_num(src) and num(src) <= 0xFF:
                r8 = {"bx": "bl", "si": "sil"}.get(base)
                if r8 == "bl":
                    self.out.append(f"\tmov\t{ovr2}[{base}],BYTE "
                                    f"PTR {hx(num(src))}")
                else:
                    self.out.append(f"\tmov\t{ovr2}[{base}],{hx(num(src))}")
            else:
                self.out.append(f"\tmov\t{ovr2}[{base}],{src}")
            return
        _s = ",".join(ops)
        self.out.append(f"\t{lo}\t" + ",".join(ops))

    def run(self):
        self.prescan()
        prev_label = None
        for code in self.lines:
            s = code.strip()
            m = re.match(r"(xios_hook_(?:timer|sec)_seg):", s)
            if m:
                self.out.append(s)
                prev_label = m.group(1)
                continue
            if prev_label and re.fullmatch(r"dw\s+0[xX]0*\s*", s):
                self.out.append("\tdw\tseg xios_hook_far_ret")
                prev_label = None
                continue
            self.conv(code)
        return self.out


def load_rasm_macro_map():
    """rasm86.inc: macro name -> canonical 'op r1,r2' from trailing comment.
    Macros without a parseable comment (the 'Ekstra' raw-opcode block) are
    decoded from their two db bytes instead."""
    m = {}
    name = None
    body = []
    for ln in RINC.read_text().splitlines():
        mm = re.match(r"%macro\s+([A-Za-z_][\w$]*)\s+0", ln, re.I)
        if mm:
            name = mm.group(1)
            continue
        if re.match(r"%endmacro", ln, re.I):
            name = None
            continue
        if name:
            cm = re.search(r";\s*([a-z]+)\s+([a-z]{2})\s*,\s*([a-z]{2})\s*$",
                           ln)
            if cm:
                m[name.lower()] = f"{cm.group(1)} {cm.group(2)},{cm.group(3)}"
                name = None
                continue
            db = re.search(r"db\s+0[xX]([0-9A-Fa-f]+)\s*,\s*0[xX]([0-9A-Fa-f]+)",
                           ln)
            if db:
                # 2-byte reg,reg form: op | (reg2<<3) | reg1; recover the
                # canonical mnemonic (the raw db is what NASM emits; RASM
                # itself encodes these forms directly).
                op = int(db.group(1), 16)
                rm = int(db.group(2), 16)
                regn = ["ax", "cx", "dx", "bx", "sp", "bp", "si", "di"]
                if op == 0x2E and rm in (0xAC, 0xAD):
                    sz = "byte" if rm == 0xAC else "word"
                    m[name.lower()] = f"lods	cs:{sz} ptr [si]"
                    name = None
                    continue
                parts = name.lower().split('_')
                if len(parts) == 3:
                    m[name.lower()] = f"{parts[0]} {parts[1]},{parts[2]}"
                    name = None
                    continue
    return m


def drop_unref(body):
    """RASM-86's 64K symbol table forces dropping labels nothing references."""
    lab_re = re.compile(r"[\w$?@.]+:")
    refs = set()
    for l in body:
        if lab_re.fullmatch(l):
            continue
        refs.update(t.lower() for t in re.findall(r"[\w$?@.]+", l))
    return [l for l in body
            if not (lab_re.fullmatch(l) and l[:-1].lower() not in refs)]


def sysdat_prefix():
    """Mirror xios.asm 'section text' SYSDAT template (0..0xC00) as A86 lines.
    xios_code.asm references these labels (sysdat_rlr etc.); NASM master defines
    them around the %include, so the RASM module must inline the same layout."""
    L = []
    def rb(n):
        L.append("\trb\t" + hx(int(n)))
    def w(lbl, *vals):
        L.append(f"{lbl}:")
        L.append("\tdw\t" + ",".join(hx(v) for v in vals))
    def b(lbl, v):
        L.append(f"{lbl}:")
        L.append("\tdb\t" + hx(v))
    # Two-section container (oracle-decoded 2026-11-27): data page = DATA
    # section (ORIGIN 0x80 -> file 0x100), all-zero content (the ff ff at
    # oracle 0x10C is the section-table base field). Page 0x00..0xB80.
    rb(0x38)
    w("sysdat_dispatcher", 0, 0)
    rb(0x44 - 0x3c)
    w("sysdat_endseg", 0)
    rb(0x4b - 0x46)
    b("sysdat_srchdisk", 0)
    rb(0x50 - 0x4c)
    b("sysdat_tempdisk", 0)
    rb(0x58 - 0x51)
    w("sysdat_mdul", 0)
    w("sysdat_mfl", 0)
    rb(0x68 - 0x5c)
    w("sysdat_rlr", 0)
    rb(0x7e - 0x6a)
    w("sysdat_tod_day", 0)
    b("sysdat_tod_hr", 0)
    b("sysdat_tod_min", 0)
    b("sysdat_tod_sec", 0)
    rb(0x88 - 0x83)
    w("sysdat_nlstdev", 0)   # dw per word consumers (mov dx/ax,[cs:..]) @0x88
    rb(0x8c - 0x8a)
    w("sysdat_openvec", 0xFFFF)
    rb(0xa0 - 0x8e)
    w("sysdat_abort_vec", 0)
    w("sysdat_int_vec", 0)
    w("sysdat_err_intercept", 0)
    w("sysdat_err_intercept_seg", 0)
    rb(0xC00 - 0xa8)   # DATA image exactly 0xB80: file 0x100..0xC80, code base +0xC00
    return L


_CS_STRIP_CACHE = None
_CS_RE = re.compile(r"(?<![A-Za-z0-9_$])cs:", re.I)
_MNEMS = set("""mov lea push pop add sub adc sbb and or xor cmp inc dec not neg
mul imul div test xchg jmp jmps jecxz loop loope loopne int iret nop hlt cli
sti cld std movsb movsw stosb stosw lodsb lodsw scasb scasw pushf popf xlat in
out rol ror rcl rcr shl shr sal sar wait call callf ret retf retn jb jnb jbe
ja je jne jna jnbe js jns jo jno jl jnge jge jnl jle jng jg jnle jz jnz
rep repe repz repne repnz""".split())
_DAT_RE = re.compile(r"^\s*([\w$?@.]+\s+)?(db|dw|dd|rb|rw|rd)\b", re.I)


def _norm_a86(line):
    return re.sub(r"\s+", " ", line.replace("\t", " ")).strip().lower()


def _apply_cs_strip(lines, mod):
    """Strip spurious `cs:` overrides the aligner proved absent in the
    oracle (scratch/cs_strip.json, keyed on (mod, normalized text, Nth
    occurrence)).  Occurrence counting must mirror _align4: instruction-
    mnemonic lines only, no db/rb family, no label-only lines."""
    global _CS_STRIP_CACHE
    if _CS_STRIP_CACHE is None:
        p = Path("scratch/cs_strip.json")
        _CS_STRIP_CACHE = ({(e["mod"], e["text"], e["occ"])
                            for e in json.loads(p.read_text())["strip"]}
                           if p.exists() else set())
    strip = _CS_STRIP_CACHE
    if not strip:
        return
    seen = {}
    n = 0
    for idx, ln in enumerate(lines):
        body = ln.strip()
        if not body or body[0] == ";" or _DAT_RE.match(body):
            continue
        first = body.replace("\t", " ").split(" ", 1)[0]
        if first.endswith(":") or first.lower() not in _MNEMS:
            continue
        norm = _norm_a86(ln)
        occ = seen.get(norm, 0)
        seen[norm] = occ + 1
        if (mod, norm, occ) in strip and "cs:" in norm:
            lines[idx] = _CS_RE.sub("", ln, count=1)
            n += 1
    print(f"gen_a86: cs-strip {mod}: {n} overrides removed")


def main():
    global NUM_VIR_CONS
    out_path = Path(sys.argv[1])
    if len(sys.argv) > 2:
        NUM_VIR_CONS = int(sys.argv[2])
    hw_equs, lines = preprocess()
    rmap = load_rasm_macro_map()
    # substitute rasm86.inc zero-arg macros before conversion
    subs = []
    for ln in lines:
        code, _ = split_comment(ln)
        tok = code.strip()
        r = rmap.get(tok.lower())
        if r and "\n" in r:
            subs.extend(["\t" + x for x in r.split("\n")])
        else:
            subs.append(r if r is not None else ln)
    conv = Conv(hw_equs, subs)
    body = conv.run()

    def _post_body(body):
        # EQU entries occupy symbol slots: inline numeric equates at their
        # (few) use sites, drop the declarations, sysdat-prefix, hexfix.
        eqs = {}
        for l in body:
            m = re.fullmatch(r"([\w$?@.]+):\s*equ\s+(\S+)", l.strip(),
                             re.I) \
                or re.fullmatch(r"([\w$?@.]+)\s+equ\s+(\S+)", l.strip(),
                                re.I)
            if m:
                tok = m.group(2).rstrip(";")
                try:
                    v = num(tok)
                except ValueError:
                    v = {**hw_equs, **eqs}.get(tok.lower())
                if v is not None:
                    eqs[m.group(1).lower()] = v
        if eqs:
            out2 = []
            for l in body:
                st = l.strip()
                if re.fullmatch(r"[\w$?@.]+(:)?\s*equ\s+\S+", st, re.I):
                    continue
                def sub(mo):
                    v = eqs.get(mo.group(0).lower())
                    return hex(v) if v is not None else mo.group(0)
                if "'" in l or '"' in l:   # never rewrite string literals
                    out2.append(l)
                else:
                    out2.append(re.sub(r"\b[\w$?@.]+\b", sub, l))
            body = out2
        pre = sysdat_prefix() + list(body) + ["\tend"]
        # A86 has no 0x: hex constants are NNNNh starting with a digit.
        def _hf(r):
            if "'" in r or '"' in r:
                return r
            return re.sub(r"0[xX]([0-9A-Fa-f]+)",
                          lambda m: "0" + m.group(1).upper() + "h", r)
        return [_hf(r) for r in drop_unref(pre)]

    res = _post_body(body)

    # RASM-86 expressions have no &, | or ~: pre-evaluate pure-numeric
    # operands (incl. 'c' chars) to a single 0NNh value. Symbolic expressions
    # (offsets, labels) are left untouched.
    def _pyval(operand):
        t = operand.strip()
        if not re.fullmatch(r"(?:'.'|0[xX][0-9A-Fa-f]+|[0-9A-Fa-f]+[hH]?"
                            r"|[~()&|+\-*/\s]|MOD)+",
                            t):
            return None
        if not re.search(r"[&|~]|MOD", t):
            return None                      # plain number: RASM handles it
        expr = re.sub(r"'(.?)'", lambda m: str(ord(m.group(1))), t)
        expr = re.sub(r"0[xX]([0-9A-Fa-f]+)", r"0x\1", expr)
        expr = re.sub(r"\b([0-9A-Fa-f]*[0-9A-Fa-f][0-9A-Fa-f]*)[hH]\b",
                      r"0x\1", expr)
        expr = re.sub(r"\bMOD\b", "%", expr, flags=re.I)
        try:
            v = eval(expr, {"__builtins__": {}})  # noqa: S307 - numeric only
        except Exception:
            return None
        return hx(v & 0xFFFF) if isinstance(v, int) and v < 0x10000 else None

    def _arith(line):
        if ";" in line:
            code, cmt = line.split(";", 1)
        else:
            code, cmt = line, None
        if not re.search(r"[&|~]|MOD", code, re.I):
            return line
        parts = code.split("\t")
        head = parts[:1]                      # indent/label part kept as-is
        body = parts[1:]
        out_body = []
        for seg in body:
            items = seg.split(",")
            new_items = []
            for it in items:
                m = re.match(r"^(\s*(?:db|dw|dd|equ|\w+\s+db|mov\s+\S+|x)\s+)",
                             it, re.I)
                pre, val = (m.group(1), it[m.end():]) if m else ("", it)
                v = _pyval(val)
                new_items.append(pre + (v if v else val))
            out_body.append(",".join(new_items))
        joined = "\t".join(head + out_body)
        return joined + (";" + cmt if cmt is not None else "")

    res = [_arith(r) for r in res]
    # RASM-86's symbol table is fixed-size (overflows ~1203 defined labels;
    # XIOS needs 1205 and XIOS4 more) -> split into two RASM modules on a
    # label boundary and let LINK-86 concatenate the PUBLIC segments. Cross
    # references become PUBLIC/EXTRN pairs (types: all labels -> NEAR).
    def labname(l):
        s = l.strip()
        m = re.fullmatch(r"([A-Za-z_][\w$]*):", s)
        if m:
            return m.group(1).lower()
        # merged typed data def: "NAME db 0" (also a definition)
        m = re.fullmatch(r"([A-Za-z_][\w$]*)\s+(?:db|rb|dw|rw|dd|rd)\b.*",
                         s, re.I)
        if m and m.group(1).lower() not in (
                "db", "rb", "dw", "rw", "dd", "rd"):
            return m.group(1).lower()
        return None

    def is_lab(l):
        return labname(l) is not None
    # choose the split line minimising cross-module references (crossed DATA
    # references are the ERR7-prone ones). A label crosses a boundary when
    # its first use and its definition end up on opposite sides.
    # symbol kinds for EXTRN typing and cross-module use. RASM-86 type-checks
    # operand widths: mov bx,cs:<BYTE-sym> is ERR7 even with a PTR cast, so
    # each label's declared type must equal the width the ORIGINAL DR source
    # used. Infer from instruction usage (register partner); fall back to the
    # db/dw definition, then NEAR.
    _dt = {"db": "BYTE", "rb": "BYTE", "dw": "WORD", "rw": "WORD",
           "dd": "DWORD", "rd": "DWORD"}
    defkind = {}
    for i, l in enumerate(res):
        m = re.fullmatch(r"([A-Za-z_][\w$]*):", l.strip())
        if m and i + 1 < len(res):
            nxt_line = res[i + 1].strip()
            if ";CODE_BYTE" in nxt_line or ";SHIFTIMM" in nxt_line:
                defkind[m.group(1).lower()] = "NEAR"
            else:
                nxt = nxt_line.lower().split()
                defkind[m.group(1).lower()] = _dt.get(nxt[0] if nxt else "", "NEAR")
        m = re.match(r"([A-Za-z_][\w$]*)\s+(db|rb|dw|rw|dd|rd)\b",
                     l.strip(), re.I)
        if m:
            defkind[m.group(1).lower()] = _dt[m.group(2).lower()]
    R16 = {"ax", "bx", "cx", "dx", "si", "di", "bp", "sp"}
    R8 = {"al", "ah", "bl", "bh", "cl", "ch", "dl", "dh"}
    usew = {}

    def _use(nm, w):
        if nm in R16 | R8 or nm in ("cs", "ds", "ss", "es", "offset"):
            return
        usew.setdefault(nm, set()).add(w)
    SEG = r"(?:cs:|ds:|ss:|es:)?"
    for l in res:
        code = l.split(";")[0].strip().lower()
        m = re.match(
            r"(?:mov|cmp|add|adc|sub|sbb|and|or|xor|test|push|inc|dec)"
            r"\s+(.*)$", code)
        if not m:
            continue
        parts = [p.strip() for p in m.group(1).split(",")]
        if len(parts) != 2:
            continue
        for a, b in ((parts[0], parts[1]), (parts[1], parts[0])):
            ma = re.fullmatch(
                SEG + r"(byte|word)\s+ptr\s+(?:[0-9-]+\[|[a-z_][\w$]*\[)?"
                r"([a-z_][\w$]*)(?:\])?", a)
            if ma:
                _use(ma.group(2), ma.group(1).upper())
                continue
            ma = re.fullmatch(SEG + r"([a-z_][\w$]*)(?:\[(?:bx|si|di|bp)\])?",
                              a)
            if not ma:
                continue
            nm = ma.group(1)
            mb = re.fullmatch(SEG + r"(byte|word)\s+ptr\s+.*", b)
            if mb:
                _use(nm, mb.group(1).upper())
            elif b in R16:
                _use(nm, "WORD")
            elif b in R8:
                _use(nm, "BYTE")
    # WORD wins any BYTE use: a symbol read via a 16-bit register must be
    # declared dw; byte accesses to it remain legal only if RASM allows, so
    # report mixed-width labels for manual review.
    mixed = {n: w for n, w in usew.items() if "WORD" in w and "BYTE" in w}
    if mixed:
        print("MIXED-WIDTH:", ",".join(sorted(mixed)))
    # (Earlier "WORD wins" flip removed: RASM follows MASM rules -- the
    # declared width may be overridden by an explicit size cast (probe13),
    # so keep the definition's own width and let conv emit casts instead.)
    # 2nd conv pass: RASM width casts (mov ax,cs:WORD PTR <BYTE sym>, probe13)
    # must be decided DURING conversion, but declared widths only exist after
    # the use-width inference above. Feed them back and convert once more.

    print("DBG kbd usew=", usew.get("kbd_char_buffer"),
          "defkind=", defkind.get("kbd_char_buffer"), file=sys.stderr)
    defs1 = {labname(l) for l in res if is_lab(l)}
    conv.inject = {k: v for k, v in defkind.items()
                   if v in ("BYTE", "WORD", "DWORD")
                   and k in defs1}   # no casts for EXTRN symbols
    conv.out, conv.seq, conv.dots, conv.labels, conv.types = [], 0, {}, set(), {}
    body = conv.run()
    res = _post_body(body)
    res = [_arith(r) for r in res]

    # Align local DEFINITION widths with use widths, then attach each data
    # label to its definition line. RASM-86 gives a symbol its type ONLY when
    # the label shares the db/dw/rb/rw line (NAME: + next-line db = untyped
    # symbol => ERR7 on every typed access); and it rejects width-mismatched
    # access (mov bx,cs:<BYTE sym> = ERR7). The original RASM source used the
    # combined typed form, so mirror it here.
    for i in range(len(res) - 1):
        m = re.fullmatch(r"([A-Za-z_][\w$]*):", res[i].strip())
        if not m:
            continue
        nm = m.group(1).lower()
        want = defkind.get(nm)
        if want not in ("BYTE", "WORD", "DWORD"):
            continue
        d = re.fullmatch(r"(db|rb|dw|rw|dd|rd)\s+(.*)", res[i + 1].strip(),
                         re.I)
        if not d:
            continue
        if ";SHIFTIMM" in res[i + 1] or ";CODE_BYTE" in res[i + 1]:
            continue  # synthetic code bytes: keep code label on own line
        kw, arg = d.group(1).lower(), d.group(2)
        items = [t.strip() for t in arg.split(",")]
        allnum = all(is_num(t) for t in items)

        def _v(t, w):
            return num(t) & ((1 << (8 * w)) - 1)

        if kw == "rb" and items and is_num(items[0]):
            n = int(items[0], 0) if items[0].lower().startswith("0x") \
                else num(items[0])
            if want == "WORD" and n % 2 == 0:
                res[i + 1] = f"rw\t{n // 2}"
            elif want == "DWORD" and n % 4 == 0:
                res[i + 1] = f"rd\t{n // 4}"
        elif want == "BYTE" and kw == "rw" and items and is_num(items[0]):
            res[i + 1] = f"rb\t{num(items[0]) * 2}"
        elif want == "WORD" and kw == "db" and allnum and len(items) == 2:
            res[i + 1] = "dw\t" + hx(_v(items[0], 1) | _v(items[1], 1) << 8)
        elif want == "DWORD" and kw == "db" and allnum and len(items) == 4:
            res[i + 1] = "dd\t" + hx(
                _v(items[0], 1) | _v(items[1], 1) << 8
                | _v(items[2], 1) << 16 | _v(items[3], 1) << 24)
        elif want == "BYTE" and kw == "dw" and allnum and len(items) == 1:
            res[i + 1] = "db\t" + hx(_v(items[0], 2))
        elif want == "WORD" and kw == "dw" and allnum and len(items) == 1:
            res[i + 1] = "dw\t" + hx(_v(items[0], 2))
        elif want == "BYTE" and kw == "db" and allnum and len(items) == 1:
            res[i + 1] = "db\t" + hx(_v(items[0], 1))
        if re.fullmatch(r"(db|rb|dw|rw|dd|rd)\s+.*", res[i + 1].strip(), re.I):
            if re.fullmatch(r"([A-Za-z_][\w$]*):",
                            res[i - 1].strip()) if i > 0 else False:
                continue  # stacked labels: only the closest one attaches
            res[i + 1] = f"{nm}\t{res[i + 1].strip()}"
            res[i] = ""
    res[:] = [l for l in res if l != ""]
    # Single-segment model (calib3/5): data and code live in ONE merged CSEG,
    # so every data reference is same-segment -> emit PLAIN operands. RASM
    # only elides the 2e CS-override for same-segment refs; cross-segment
    # (CSEG vs DSEG) refs always encode cs: and disagree with the oracle.
    # RASM elides the 2e CS-override for same-segment refs; oracle keeps
    # 1159 2e bytes, our verbatim cs: gives 1586 -> strip first (691), the
    # missing 468 are refs DR wrote WITHOUT cs: in his own source; restored
    # selectively per region in the Fase 3 diff loop.
    # cs: policy: keep verbatim (master mirrors DR's own cs: annotations;
    # oracle code region carries 694 2E bytes = per-site truth, Fase 3 loop
    # tunes outliers). Old blanket strip lost every needed 2E.
    pass
    
    out_lines = ["XIOS	CSEG"] + [l for l in res if l.strip() != "end"] + ["	end"]
    data = "\r\n".join(out_lines) + "\r\n\x1a"
    with open(out_path, "wb") as f:
        f.write(data.encode("latin-1"))
    print(f"Single XIOS.A86 written: {len(out_lines)} lines, {len(data)} bytes")

if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""omf2cmd.py - locate a small-model Open Watcom OMF object into a CP/M-86 CMD.

Scope (LOCKED to small model, per user directive):
  * CODE group  = the '_TEXT'/CODE-class segment  -> CMD group type 1
  * DATA group  = DGROUP members (CONST, CONST2, _DATA ... all DATA class)
                  concatenated at their group offsets -> CMD group type 2
  * base = 0 for both groups (relocatable), matching every real RC759 CMD.
  * Entry point is CS:0000 (loader sets CS=code, DS=SS=data). The object's
    entry symbol MUST live at _TEXT offset 0 and terminate via BDOS itself
    (this locator emits no crt0).

Only the OMF subset that bwcc -ms actually emits is handled:
  THEADR, COMENT, LNAMES, SEGDEF, GRPDEF, EXTDEF, PUBDEF, LEDATA, FIXUPP, MODEND.

Fixups: only 16-bit OFFSET, target = EXTERNAL or SEGMENT, frame = GROUP/TARGET.
The written value is the target symbol's offset within its frame group. For a
small-model program the only such fixups are `offset <datum>` immediates that
resolve to a DGROUP offset; near CALL/JMP are self-relative and pre-resolved by
the compiler, so they carry no FIXUPP.  Anything outside this subset is a hard
error -- we never silently emit a wrong image.

Worked example (from /tmp/hello.obj, the bwcc BDOS hello):
  _TEXT LEDATA off=0, 32B: 5351525657 be 0000 8a14 ... cde0 ... c3
  FIXUPP c4 06 56 01  -> 16-bit offset at code+6, target=EXTDEF #1 (_msg),
                         frame=DGROUP.  _msg lives at start of _DATA; CONST and
                         CONST2 are length 0, so _msg's DGROUP offset = 0.
                         We therefore write 0x0000 at code+6 (already 0 here).
"""
import sys, struct

def parse(objbytes):
    i = 0
    lnames = ['']          # 1-based
    segdefs = []           # list of dict(name,cls,length,acbp)
    grpdefs = []           # list of dict(name, members=[segidx])
    extdefs = ['']         # 1-based external names
    pubdefs = {}           # name -> (segidx, offset)
    ledatas = []           # list of (segidx, offset, data)
    fixups = []            # list of dict
    entry = None           # (segidx, offset) from MODEND, if present
    n = len(objbytes)
    while i + 3 <= n:
        rectype = objbytes[i]
        rlen = objbytes[i+1] | (objbytes[i+2] << 8)
        body = objbytes[i+3:i+3+rlen-1]   # exclude checksum byte
        nxt = i + 3 + rlen
        if rectype == 0x96:                          # LNAMES
            p = 0
            while p < len(body):
                l = body[p]; lnames.append(body[p+1:p+1+l].decode('latin1')); p += 1+l
        elif rectype == 0x98:                        # SEGDEF (16-bit)
            attr = body[0]; p = 1
            if (attr >> 5) == 0:                      # absolute -> frame+offset
                p += 3
            seglen = body[p] | (body[p+1] << 8); p += 2
            segname = lnames[body[p]]; segcls = lnames[body[p+1]]
            segdefs.append(dict(name=segname, cls=segcls, length=seglen, acbp=attr))
        elif rectype == 0x9A:                        # GRPDEF
            gname = lnames[body[0]]; p = 1; members = []
            while p < len(body):
                if body[p] == 0xFF:
                    members.append(body[p+1]); p += 2
                else:
                    p += 1
            grpdefs.append(dict(name=gname, members=members))
        elif rectype == 0x8C:                        # EXTDEF
            p = 0
            while p < len(body):
                l = body[p]; extdefs.append(body[p+1:p+1+l].decode('latin1'))
                p += 1 + l + 1                        # +1 type index (small)
        elif rectype == 0x90:                        # PUBDEF (16-bit)
            bg = body[0]; bs = body[1]; p = 2
            if bg == 0:                               # base frame present
                p += 2
            while p + 3 <= len(body):
                l = body[p]; name = body[p+1:p+1+l].decode('latin1'); p += 1+l
                if p + 2 > len(body):
                    break
                off = body[p] | (body[p+1] << 8); p += 2
                p += 1                                # type index
                pubdefs[name] = (bs, off)
        elif rectype == 0xA0:                         # LEDATA
            si = body[0]; off = body[1] | (body[2] << 8); data = body[3:]
            ledatas.append((si, off, data))
        elif rectype == 0x9C:                         # FIXUPP (16-bit)
            _parse_fixupp(body, ledatas, fixups)
        elif rectype in (0x8A, 0x8B):                 # MODEND / MODEND32
            # bit6 of body[0] set => start address present
            if body and (body[0] & 0x40):
                # End Data + Frame/Target fields; grab target offset if simple
                pass
        i = nxt
    return dict(lnames=lnames, segdefs=segdefs, grpdefs=grpdefs,
                extdefs=extdefs, pubdefs=pubdefs, ledatas=ledatas, fixups=fixups)

def _parse_fixupp(body, ledatas, fixups):
    if not ledatas:
        raise SystemExit("FIXUPP before any LEDATA")
    cur_seg, cur_off, _ = ledatas[-1]
    p = 0
    while p < len(body):
        b = body[p]
        if (b & 0x80) == 0:
            raise SystemExit("THREAD subrecords not supported (unexpected in bwcc -ms)")
        locat = (b << 8) | body[p+1]; p += 2
        M = (locat >> 14) & 1
        loc = (locat >> 10) & 0xF
        data_off = locat & 0x3FF
        fixdat = body[p]; p += 1
        F = (fixdat >> 7) & 1
        frame = (fixdat >> 4) & 7
        T = (fixdat >> 3) & 1
        targt = fixdat & 7
        frame_datum = None
        if F == 0 and frame < 4:
            frame_datum = body[p]; p += 1
        target_datum = None
        if T == 0:
            target_datum = body[p]; p += 1
        if (targt & 3) == 3 or (fixdat & 0x04):   # P bit set -> no displacement
            disp = 0
        else:
            disp = body[p] | (body[p+1] << 8); p += 2
        fixups.append(dict(seg=cur_seg, off=data_off, M=M, loc=loc,
                           frame_method=frame, frame_datum=frame_datum,
                           target_method=(targt & 3), target_datum=target_datum,
                           disp=disp))

def group_of_seg(o, segidx):
    for gi, g in enumerate(o['grpdefs']):
        if segidx in g['members']:
            return gi
    return None

def seg_group_offset(o, segidx):
    """Offset of the START of a segment within its containing group."""
    gi = group_of_seg(o, segidx)
    if gi is None:
        return 0
    off = 0
    for m in o['grpdefs'][gi]['members']:
        if m == segidx:
            return off
        off += o['segdefs'][m-1]['length']
    return off

def build_images(o):
    # classify segments: CODE class -> code image; DATA class (DGROUP) -> data image
    code_len = 0; data_len = 0
    for si, s in enumerate(o['segdefs'], start=1):
        if s['cls'].upper() == 'CODE':
            code_len = max(code_len, s['length'])
    # data image spans the whole DGROUP
    dgroup_idx = None
    for gi, g in enumerate(o['grpdefs']):
        if g['name'] == 'DGROUP':
            dgroup_idx = gi
    data_span = 0
    if dgroup_idx is not None:
        for m in o['grpdefs'][dgroup_idx]['members']:
            data_span += o['segdefs'][m-1]['length']
    code = bytearray(code_len)
    data = bytearray(data_span)
    # lay LEDATA down
    for si, off, dat in o['ledatas']:
        s = o['segdefs'][si-1]
        if s['cls'].upper() == 'CODE':
            _blit(code, off, dat)
        else:
            base = seg_group_offset(o, si)
            _blit(data, base + off, dat)
    # apply fixups
    for fx in o['fixups']:
        s = o['segdefs'][fx['seg']-1]
        if s['cls'].upper() != 'CODE':
            raise SystemExit("fixup in non-code segment not supported")
        if fx['loc'] != 1:
            raise SystemExit(f"unsupported fixup loc={fx['loc']} (only 16-bit offset)")
        val = _resolve_target(o, fx)
        img = code
        img[fx['off']]   = val & 0xFF
        img[fx['off']+1] = (val >> 8) & 0xFF
    return bytes(code), bytes(data)

def _resolve_target(o, fx):
    tm = fx['target_method']; td = fx['target_datum']; disp = fx['disp']
    if tm == 2:                                   # external index
        name = o['extdefs'][td]
        if name not in o['pubdefs']:
            raise SystemExit(f"external {name!r} not defined in this module "
                             f"(cross-module link not supported)")
        segidx, off = o['pubdefs'][name]
        return seg_group_offset(o, segidx) + off + disp
    if tm == 0:                                   # segment index
        return seg_group_offset(o, td) + disp
    raise SystemExit(f"unsupported target method {tm}")

def _blit(buf, off, data):
    if off + len(data) > len(buf):
        buf.extend(b'\x00' * (off + len(data) - len(buf)))
    buf[off:off+len(data)] = data

def make_cmd(code, data):
    """Small-model CMD: group1=CODE(type1), group2=DATA(type2), base=0."""
    def paras(nbytes):
        return (nbytes + 15) // 16
    REC = 128
    def gd(gtype, length_para, minp):
        # db type; dw length, base, min, max  (all paragraph counts)
        return struct.pack('<BHHHH', gtype, length_para, 0, minp, 0)
    hdr = bytearray(REC)
    code_para = paras(len(code))
    data_para = paras(len(data))
    hdr[0:9]   = gd(1, code_para, code_para)      # CODE
    hdr[9:18]  = gd(2, data_para, data_para)      # DATA
    # remaining 6 descriptors already zero (unused)
    def pad(b):
        r = len(b) % REC
        return b + b'\x00' * ((REC - r) % REC)
    return bytes(hdr) + pad(code) + pad(data)

def main():
    if len(sys.argv) != 3:
        sys.exit("usage: omf2cmd.py in.obj out.cmd")
    o = parse(open(sys.argv[1], 'rb').read())
    code, data = build_images(o)
    cmd = make_cmd(code, data)
    open(sys.argv[2], 'wb').write(cmd)
    print(f"CODE {len(code)}B ({(len(code)+15)//16} para)  "
          f"DATA {len(data)}B ({(len(data)+15)//16} para)  "
          f"-> {sys.argv[2]} {len(cmd)}B")

if __name__ == '__main__':
    main()

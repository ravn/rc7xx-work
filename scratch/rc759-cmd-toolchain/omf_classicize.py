#!/usr/bin/env python3
"""Normalize Open Watcom 16-bit OMF so DR LINK-86 v1.4 (1984) can link it.
LPUBDEF(0xB6)->PUBDEF(0x90) and LEXTDEF(0xB4)->EXTDEF(0x8C): bodies are
byte-identical (only symbol scope differs), so we swap the type byte and
recompute the OMF checksum. Index space & record order are preserved, so
FIXUPP external indices stay valid.

Equivalent copy: open-watcom-v2/contrib/ravn/owc-drc/stdcbench/omf-delocal.py
carries the same LEXTDEF/LPUBDEF swap and --merge-text-into-code logic for the
upstreamable contrib tree; this scratch copy ALSO shortens long THEADR records
(OBJECT FILE ERROR 10) so it can classicize objects compiled with long paths.
Keep the two in sync when the shared logic changes.
"""
import sys,struct,os
MAP={0xB6:0x90, 0xB4:0x8C}   # local publics/externals -> classic
def _fixsum(rec):
    # OMF checksum: sum of all bytes in record == 0 (mod 256).
    s=sum(rec[:-1]) & 0xFF
    rec[-1]=(256-s)&0xFF
    return rec
def _lnames(data):
    # Collect LNAMES strings in OMF order (1-indexed as the linker sees them).
    names=['']; i=0
    while i+3<=len(data):
        t=data[i]; ln=struct.unpack('<H',data[i+1:i+3])[0]; body=data[i+3:i+3+ln]
        if t==0x96:
            j=0
            while j<len(body)-1:
                sl=body[j]; names.append(body[j+1:j+1+sl].decode('latin1')); j+=1+sl
        i+=3+ln
    return names
def classicize(data,merge_text_into_code=False):
    # merge_text_into_code: repoint any SEGDEF whose segment name is '_TEXT'
    # to the LNAMES entry 'CODE' so DR LINK-86 (which merges by SEGMENT NAME,
    # not class) folds Open Watcom's own helper code (e.g. cgsupp i4m/i4d
    # __U4M/__U4D) into the small-model CODE group produced by `bwcc -nt=CODE`.
    # Without this a near CALL from CODE to the helper's separate _TEXT segment
    # is "TARGET OUT OF RANGE". Example (ms/i4m.obj): LNAMES = ['','CODE',
    # '_TEXT','DATA','_DATA','DGROUP']; SEGDEF #1 seg-name idx 3 (_TEXT),
    # class idx 2 (CODE) -> we rewrite the seg-name idx 3 -> 2. Large model
    # far-calls the helper so it is left untouched there.
    names=_lnames(data)
    def _idx(nm):
        return names.index(nm) if nm in names else None
    ti,ci=_idx('_TEXT'),_idx('CODE')
    out=bytearray(); i=0; changed=0
    while i+3<=len(data):
        t=data[i]; ln=struct.unpack('<H',data[i+1:i+3])[0]
        rec=bytearray(data[i:i+3+ln])
        if t in MAP:
            rec[0]=MAP[t]; _fixsum(rec); changed+=1
        elif merge_text_into_code and t in (0x98,0x99) and ti is not None and ci is not None and ti<0x80 and ci<0x80:
            # SEGDEF: ACBP[0], then optional absolute frame/offset (A=0 only),
            # then length (2), seg-name-index (1B when <0x80). Our helper objs
            # use A=2 (para-relative) and small 1-byte indices, so the seg-name
            # index sits at body offset 3 (after ACBP + 2-byte length).
            acbp=rec[3]; a=(acbp>>5)&7
            off=4 + (3 if a==0 else 0) + 2   # ACBP + optabs + length -> seg-name idx
            if off<len(rec)-1 and rec[off]==ti:
                rec[off]=ci; _fixsum(rec); changed+=1
        elif t==0x80:  # THEADR: shorten module name to <=8 basename.
            # LINK-86 v1.4 rejects long THEADR names (OBJECT FILE ERROR 10).
            nl=rec[3]; name=bytes(rec[4:4+nl]).decode('latin1')
            short=os.path.basename(name).split('.')[0][:8].upper() or 'MOD'
            body=bytes([len(short)])+short.encode('latin1')+b'\x00'  # +checksum slot
            rec=bytearray([0x80])+struct.pack('<H',len(body))+body
            _fixsum(rec); changed+=1
        out+=rec; i+=3+ln
    return bytes(out),changed
if __name__=="__main__":
    args=[a for a in sys.argv[1:] if not a.startswith('--')]
    merge='--merge-text-into-code' in sys.argv[1:]
    src,dst=args[0],args[1]
    data=open(src,"rb").read()
    o,c=classicize(data,merge_text_into_code=merge)
    open(dst,"wb").write(o)
    print(f"{src} -> {dst}: rewrote {c} local record(s) to classic")

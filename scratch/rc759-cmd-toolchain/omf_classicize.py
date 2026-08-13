#!/usr/bin/env python3
"""Normalize Open Watcom 16-bit OMF so DR LINK-86 v1.4 (1984) can link it.
LPUBDEF(0xB6)->PUBDEF(0x90) and LEXTDEF(0xB4)->EXTDEF(0x8C): bodies are
byte-identical (only symbol scope differs), so we swap the type byte and
recompute the OMF checksum. Index space & record order are preserved, so
FIXUPP external indices stay valid.
"""
import sys,struct,os
MAP={0xB6:0x90, 0xB4:0x8C}   # local publics/externals -> classic
def _fixsum(rec):
    # OMF checksum: sum of all bytes in record == 0 (mod 256).
    s=sum(rec[:-1]) & 0xFF
    rec[-1]=(256-s)&0xFF
    return rec
def classicize(data):
    out=bytearray(); i=0; changed=0
    while i+3<=len(data):
        t=data[i]; ln=struct.unpack('<H',data[i+1:i+3])[0]
        rec=bytearray(data[i:i+3+ln])
        if t in MAP:
            rec[0]=MAP[t]; _fixsum(rec); changed+=1
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
    src,dst=sys.argv[1],sys.argv[2]
    data=open(src,"rb").read()
    o,c=classicize(data)
    open(dst,"wb").write(o)
    print(f"{src} -> {dst}: rewrote {c} local record(s) to classic")

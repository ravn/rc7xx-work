import sys,os
# unpack_l86.py -- unpack a Digital Research .L86 library into individual OMF
# modules so Open Watcom wlink (or wlib) can consume DR C's runtime.
#
# WHY: wlink CANNOT read a DR .L86 library directly -- it rejects it with
#   "E2012: invalid library file attribute" because the file starts with DR's
#   own library-header records (0xA4/0xA6/0xA8/0xAA) + a trailing symbol
#   dictionary, NOT wlink's expected 0xF0 OMF LIB_HEADER_REC or the "!<arch>"
#   AR magic (verified 2026-08-13, bld/wl/c/libr.c).
# BUT: the individual modules INSIDE a .L86 are ordinary Intel-8086 OMF
#   (RASM-86 output) and wlink's OMF reader accepts them cleanly -- all 131
#   modules of CLEARL.L86 parse with zero object-format errors (only benign
#   undefined-symbol E2028 for DR group frames _NES/_WCS/... when linked in
#   isolation).  So: unpack here, then feed the .obj modules to wlink, or
#   repackage them into a real OMF .lib with wlib.
#
# Layout of a DR .L86:  [0xA4/A6/A8/AA header+dictionary]
#                       [ N x (THEADR 0x80 .. MODEND 0x8A) OMF modules ]
#                       [ trailing symbol index ]
#
# Usage:  python3 unpack_l86.py CLEARL.L86 outdir/
#   -> writes outdir/NNN_<name>.obj per module + outdir/MODULES.txt

src=sys.argv[1]; outdir=sys.argv[2]; os.makedirs(outdir,exist_ok=True)
d=open(src,'rb').read(); n=len(d); i=0; mods=[]; cur=None; other={}
while i+3<=n:
    t=d[i]; ln=d[i+1]|(d[i+2]<<8); rec_end=i+3+ln
    if rec_end>n: 
        print('TRUNCATED at %d (rec 0x%02X len %d > eof)'%(i,t,ln)); break
    if t in (0x80,0x82):
        cur=[i]
    elif t in (0x8A,0x8B) and cur is not None:
        cur.append(rec_end); mods.append(tuple(cur)); cur=None
    elif cur is None:
        other[t]=other.get(t,0)+1
    i=rec_end
print('consumed %d of %d bytes; %d modules; inter-module records: %s'%(
    i,n,len(mods),{('0x%02X'%k):v for k,v in other.items()}))
names=[]
for idx,(s,e) in enumerate(mods):
    m=d[s:e]; nl=m[3]; nm=m[4:4+nl].decode('latin1').strip() or ('m%03d'%idx)
    safe=''.join(c if c.isalnum() else '_' for c in nm)[:8] or ('m%03d'%idx)
    fn=os.path.join(outdir,'%03d_%s.obj'%(idx,safe))
    open(fn,'wb').write(m); names.append(fn)
open(os.path.join(outdir,'MODULES.txt'),'w').write('\n'.join(names))
print('wrote %d module .obj files to %s'%(len(names),outdir))

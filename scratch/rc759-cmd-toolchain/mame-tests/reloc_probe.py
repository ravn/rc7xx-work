import sys,struct
data=open(sys.argv[1],'rb').read()
hdr=data[:128]
# parse group descriptors
groups=[]  # (type,length_paras,base,min,max,file_off)
fpos=128
for i in range(8):
    d=hdr[i*9:i*9+9]
    t=d[0]
    if t==0: continue
    length=d[1]|d[2]<<8
    groups.append(dict(type=t,length=length,base=d[3]|d[4]<<8,
                       min=d[5]|d[6]<<8,max=d[7]|d[8]<<8,file_off=fpos))
    fpos+=length*16
fixrec=hdr[0x7d]|hdr[0x7e]<<8
lbyte=hdr[0x7f]
print("byte127 (ch_lbyte) = 0x%02x  (bit7 fixups=%s)"%(lbyte, bool(lbyte&0x80)))
print("ch_fixrec = 0x%x  -> fixup table at file offset 0x%x"%(fixrec,fixrec*128))
print("groups:",[(g['type'],'off=0x%x'%g['file_off'],'len=0x%x'%g['length']) for g in groups])
def gfile(t):  # file_off of group with type t (9->1)
    if t==9: t=1
    for g in groups:
        if g['type']==t: return g['file_off']
    return None
tname={1:'CODE',2:'DATA',3:'EXTRA',4:'STACK',5:'AUX1',6:'AUX2',7:'AUX3',8:'AUX4',9:'SHARED-CODE'}
print("\n  # loc_grp para  off  -> tgt_grp   stored_word (group-relative segment, UN-relocated)")
off=fixrec*128
n=0
while True:
    rec=data[off:off+4]
    if len(rec)<4 or rec==b'\x00\x00\x00\x00': break
    b0,para_lo,para_hi,fo=rec
    loc=b0>>4; tgt=b0&0xf; para=para_lo|para_hi<<8
    gf=gfile(loc)
    fileloc=gf+para*16+fo
    word=data[fileloc]|data[fileloc+1]<<8
    tag=" <== FAR POINTER TO CODE" if tgt in (1,9) else ""
    if n<20 or tag:
        print("  %2d  g%d(%-5s) 0x%03x  %2d  -> g%d(%-5s)  stored=0x%04x%s"%(
            n,loc,tname.get(loc,'?'),para,fo,tgt,tname.get(tgt,'?'),word,tag))
    n+=1
    off+=4
print("\ntotal fixups:",n)

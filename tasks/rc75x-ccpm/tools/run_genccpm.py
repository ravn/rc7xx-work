#!/usr/bin/env python3
"""
run_genccpm.py — Kør Digital Research GENCCPM.CMD via emu2 for at genskabe CCPM.SYS
ud fra de individuelle .CON moduler og .RSP processer.
"""
import os
import sys
import subprocess
import shutil

ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..'))
DIST_DIR = os.path.join(ROOT_DIR, 'scratch/tmp/dist')
EMU2_BIN = os.path.join(ROOT_DIR, 'emu2-cpm86/emu2')

def main():
    if not os.path.exists(EMU2_BIN):
        print(f"FEJL: emu2 ikke fundet ved {EMU2_BIN}", file=sys.stderr)
        sys.exit(1)

    variant = sys.argv[1] if len(sys.argv) > 1 else "1"
    if variant == "1":
        xios_src = "XIOS1.CON"
        oslabel = "System med 1 konsol"
        expected_size = 77568
        print("=== Konfigurerer til 1 virtuel konsol (CCPM1.SYS) ===")
    elif variant == "4":
        xios_src = "XIOS4.CON"
        oslabel = "System med 4 konsoller"
        expected_size = 87168
        print("=== Konfigurerer til 4 virtuelle konsoller (CCPM4.SYS) ===")
    else:
        print("Brug: run_genccpm.py [1|4]")
        sys.exit(1)

    # Forbered XIOS.CON
    shutil.copyfile(os.path.join(DIST_DIR, xios_src), os.path.join(DIST_DIR, "XIOS.CON"))

    # Response stream til GENCCPM interaktive menuer
    input_text = f"""verb=y
dest=a:
delete=n
sysparams
sys=a: tmp=a: cmd=n mem=3000 nq=30 qb=800 nf=ff
osstart=48

oslabel
{oslabel}

rsps
exclude=*
include=tmp759.rsp,clock.rsp,pin.rsp,vout.rsp,scroll.rsp

mem
d=1 a=1400,4000,200 a=4000,8000,400 a=8000,c000,1000

gensys
"""

    p = subprocess.Popen(
        [EMU2_BIN, 'GENCCPM.CMD'],
        cwd=DIST_DIR,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )

    stdout, stderr = p.communicate(input=input_text, timeout=10)
    print("GENCCPM kørsel afsluttet med kode:", p.returncode)

    out_sys = os.path.join(DIST_DIR, 'ccpm.sys')
    if os.path.exists(out_sys):
        actual_size = os.path.getsize(out_sys)
        print(f"Genereret fil: {out_sys} ({actual_size} bytes)")
        if actual_size == expected_size:
            print(f"SUCCESS: Størrelsen matcher {expected_size} bytes!")
        else:
            print(f"BEMÆRK: Størrelse er {actual_size}, forventet {expected_size}")

if __name__ == '__main__':
    main()

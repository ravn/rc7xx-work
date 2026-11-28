#!/usr/bin/env python3
"""
compare_ocr.py — Sammenlign embedded OCR vs Tesseract 5 på PICCOLINE Programmers Guide

Metrikker:
- Hex-adresser med 'H'-suffix (embedded OCR fejler ofte H→8/B)
- Danske tegn (æøå/ÆØÅ)
- Specifikke tekniske fraser
"""
import re, zlib, os, sys

PDF = "/Users/ravn/z80/scratch/rc759-xios/ddhf-cache/PICCOLINE_Programmers_Guide_v2_rc700dk.pdf"
TESS_DIR = "/Users/ravn/z80/tasks/rc75x-ccpm/ocr/pages"

def embedded_ocr():
    """Træk embedded OCR fra PDF-tekstlag"""
    pdf = open(PDF, "rb").read()
    streams = re.findall(rb'stream\r?\n(.*?)\r?\nendstream', pdf, re.DOTALL)
    text_all = []
    for s in streams:
        try:
            dec = zlib.decompress(s)
            for w in re.findall(rb'\(([^\)]{1,150})\)\s*(?:Tj|\')', dec):
                try: text_all.append(w.decode('latin-1'))
                except: pass
            for tj in re.findall(rb'\[([^\]]+)\]\s*TJ', dec):
                for p in re.findall(rb'\(([^\)]+)\)', tj):
                    try: text_all.append(p.decode('latin-1'))
                    except: pass
        except: pass
    return re.sub(r'\s+', ' ', ' '.join(text_all))

def tesseract_ocr():
    """Træk Tesseract OCR fra TXT-filer"""
    files = sorted(os.listdir(TESS_DIR))
    txts = [f for f in files if f.endswith('.txt')]
    all_text = []
    for f in txts:
        with open(os.path.join(TESS_DIR, f)) as fp:
            all_text.append(fp.read())
    return '\n'.join(all_text)

def analyze(text, name):
    # Hex-adresser med H
    hex_h = re.findall(r'\b0[0-9A-F]{3,4}H\b', text)
    hex_bad = re.findall(r'\b0[0-9A-F]{3,4}[8B]\b', text)
    # Danske tegn
    danish = len(re.findall(r'[æøåÆØÅ]', text))
    # Kvantitet
    words = len(re.findall(r'[A-Za-zæøåÆØÅ]{3,}', text))
    # OCR-fejl mønstre
    bad_patterns = len(re.findall(r'OOO|O00|[0-9]{3,}O[0-9]', text))
    
    return {
        "navn": name,
        "ord_total": words,
        "danske_tegn": danish,
        "hex_med_H": len(hex_h),
        "hex_med_8_eller_B": len(hex_bad),
        "åbenlyse_fejl": bad_patterns,
    }

print("Analyse af OCR-kvalitet\n")
emb = embedded_ocr()
tess = tesseract_ocr()

for data in [analyze(emb, "Embedded PDF OCR"), analyze(tess, "Tesseract 5 dan+eng")]:
    print(f"=== {data['navn']} ===")
    for k, v in data.items():
        if k == "navn": continue
        print(f"  {k}: {v}")
    print()

# Konkret test: 10 tekniske fraser
print("=== Konkret tekst-tjek ===")
phrases = [
    "0280H", "0282H", "0284H", "0288H", "028EH", "0290H",
    "WD2797", "C. Itoh", "København", "Vedligeholdelse",
    "ændres", "tværs", "diskette", "lager",
]
print(f"{'Frase':<25} {'Embedded':>10} {'Tesseract':>10}")
for p in phrases:
    ec = emb.count(p)
    tc = tess.count(p)
    print(f"  {p:<23} {ec:>10} {tc:>10}")

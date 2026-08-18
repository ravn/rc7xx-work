# RC759 firmware keyboard-oversættelsestabeller (2026-08-18)

Dette dokumenterer de tre keyboard-oversættelsestabeller, som XIOS/firmwaren på
RC759 CCP/M-bootdisken bruger til at omsætte en **positionskode** fra tastaturets
scan-matrix til en ASCII-/kontrolværdi. Fundet under root-cause af host-ESC-fejlen
(se `rc759-i82730-cursor-and-cmdq-2026-08-17.md`).

## Placering på disken

Boot-disk: `scratch/rc759-pce/images/sw1400_r31a_d1.img` (SW1400 r3.1a, disk 1).

| tabel  | fil-offset | længde |
|--------|-----------|--------|
| normal | `0x36a30` | 99 bytes |
| shift  | `0x36a93` | 99 bytes |
| ctrl   | `0x36af6` | 99 bytes |

Tre sammenhængende 99-byte-tabeller. Hver indekseres af **positionskoden**
(0..98), som MAME's HLE-tastatur (`rc759_kbd.cpp`) beregner som
`position = row*16 + bit`. Værdi `0xff` = "ingen tast" (positionen giver intet).
Værdier `0x80`–`0xcf`/`0xf5`–`0xfe` er interne funktions-/piletast-koder (ikke ASCII).

Alignment er 100% krydsverificeret mod driverens tast-labels: pos 1=TAB=0x09,
16='q', 28=Enter=0x0d, 57=space=0x20 osv. — se tabellen nedenfor.

## Rå hex

```
normal @0x36a30:
ff 09 31 32 33 34 35 36 37 38 39 30 2d 60 08 1b 71 77 65 72 74 79 75 69 6f 70 7b 7d 0d ff
61 73 64 66 67 68 6a 6b 6c 3b ff 3a ff 7c 7a 78 63 76 62 6e 6d 2c 2e 2f ff ff 7e 20 c1 80
81 82 83 84 85 86 87 88 89 8a 8b 97 8e 8f 93 94 ff 90 92 8d 95 8c 98 c2 c3 c4 c5 c6 c7 c8
c9 ca 96 cb cc cd 91 ce cf

shift @0x36a93:
ff 0c 21 22 23 24 25 26 27 28 29 5f 3d 40 08 1b 51 57 45 52 54 59 55 49 4f 50 5b 5d 0d ff
41 53 44 46 47 48 4a 4b 4c 2b ff 2a ff 5c 5a 58 43 56 42 4e 4d 3c 3e 3f ff ff 5e 20 c1 ad
ae af b0 b1 b2 b3 b4 b5 b6 9f a0 e6 99 9a 9b 9c ff 90 92 8d 95 8c e7 c2 c3 c4 c5 c6 c7 c8
c9 ca 96 cb cc cd 91 ce cf

ctrl @0x36af6:
ff 09 ff ff ff ff ff ff ff ff ff 1f ff 00 7f 1b 11 17 05 12 14 19 15 09 0f 10 1b 1d 0d ff
01 13 04 06 07 08 0a 0b 0c ff ff ff ff 1c 1a 18 03 16 02 0e 0d ff ff ff ff ff 1e 20 fe b7
b8 b9 ba bb bc bd be bf c0 a1 a2 97 fd ff fb fa ff 90 92 8d 95 8c 98 ff ff ff ff ff ff ff
ff ff 96 f6 f7 f8 91 f5 ff
```

## Dekodet tabel

`--` = 0xff (ingen tast). Kontroltegn vist ved navn (ESC=0x1b, CR=0x0d, BS=0x08,
TAB=0x09, DEL=0x7f, NUL=0x00, US=0x1f, FS=0x1c, GS=0x1d, RS=0x1e). Rå hex vist for
firmwarens interne funktions-/piletast-koder (0x80+). "driver key" = navnet i
`rc759_kbd.cpp`; trailing note = driverens kommentar (nordiske tegn mm.).

```
pos driver key     normal  shift   ctrl   note
----------------------------------------------------------------------
  0 (row_0 bit0)      --     --     --   ubrugt
  1 TAB               TAB     --    TAB
  2 1                 '1'    '!'     --
  3 2                 '2'    '"'     --
  4 3                 '3'    '#'     --   (shift § på fysisk tast)
  5 4                 '4'    '$'     --
  6 5                 '5'    '%'     --
  7 6                 '6'    '&'     --
  8 7                 '7'    '''     --
  9 8                 '8'    '('     --
 10 9                 '9'    ')'     --
 11 0                 '0'    '_'     US
 12 MINUS             '-'    '='     --
 13 EQUALS            '`'    '@'    NUL
 14 BACKSPACE          BS     BS    DEL
 15 Esc               ESC    ESC    ESC   ** den ægte ESC-tast (var mislabeled "Alt")
 16 Q                 'q'    'Q'     11
 17 W                 'w'    'W'     17
 18 E                 'e'    'E'     05
 19 R                 'r'    'R'     12
 20 T                 't'    'T'     14
 21 Y                 'y'    'Y'     19
 22 U                 'u'    'U'     15
 23 I                 'i'    'I'    TAB
 24 O                 'o'    'O'     0f
 25 P                 'p'    'P'     10
 26 COLON             '{'    '['    ESC   æ Æ  (Ctrl+[ = ESC → brugerens Ctrl-Æ)
 27 OPENBRACE         '}'    ']'     GS   å Å
 28 ENTER              CR     CR     CR
 29 LCONTROL           --     --     --   modifier
 30 A                 'a'    'A'     01
 31 S                 's'    'S'     13
 32 D                 'd'    'D'     04
 33 F                 'f'    'F'     06
 34 G                 'g'    'G'     07
 35 H                 'h'    'H'     BS
 36 J                 'j'    'J'     LF
 37 K                 'k'    'K'     0b
 38 L                 'l'    'L'     FF
 39 CLOSEBRACE        ';'    '+'     --
 40 CAPSLOCK           --     --     --   modifier
 41 BACKSLASH         ':'    '*'     --
 42 Left Shift         --     --     --   modifier
 43 QUOTE             '|'    '\'     FS   ø Ø
 44 Z                 'z'    'Z'     1a
 45 X                 'x'    'X'     18
 46 C                 'c'    'C'     03
 47 V                 'v'    'V'     16
 48 B                 'b'    'B'     02
 49 N                 'n'    'N'     0e
 50 M                 'm'    'M'     CR
 51 COMMA             ','    '<'     --
 52 STOP              '.'    '>'     --
 53 SLASH             '/'    '?'     --
 54 Right Shift        --     --     --   modifier
 55 (row_3 bit7)       --     --     --   ** død position (0xff); host ESC lå fejlagtigt her
 56 BACKSLASH2        '~'    '^'     RS   ü Ü
 57 SPACE             ' '    ' '    ' '
 58 Print              c1     c1     fe
 59 F1                 80     ad     b7
 60 F2                 81     ae     b8
 61 F3                 82     af     b9
 62 F4                 83     b0     ba
 63 F5                 84     b1     bb
 64 F6                 85     b2     bc
 65 F7                 86     b3     bd
 66 F8                 87     b4     be
 67 F9                 88     b5     bf
 68 F10                89     b6     c0
 69 F11                8a     9f     a1
 70 F12                8b     a0     a2
 71 Tegn Ind           97     e6     97
 72 A1                 8e     99     fd
 73 A2                 8f     9a     --
 74 A3                 93     9b     fb
 75 A4                 94     9c     fa
 76 (((O)))            --     --     --
 77 LEFT               90     90     90
 78 RIGHT              92     92     92
 79 UP                 8d     8d     8d
 80 DOWN               95     95     95
 81 ↖ (home-diag)      8c     8c     8c
 82 Slet Tegn          98     e7     98
 83 7_PAD              c2     c2     --
 84 8_PAD              c3     c3     --
 85 9_PAD              c4     c4     --
 86 MINUS_PAD          c5     c5     --
 87 PLUS_PAD           c6     c6     --
 88 4_PAD              c7     c7     --
 89 5_PAD              c8     c8     --
 90 6_PAD              c9     c9     --
 91 Keypad ,           ca     ca     --
 92 Keypad Tab         96     96     96
 93 1_PAD              cb     cb     f6
 94 2_PAD              cc     cc     f7
 95 3_PAD              cd     cd     f8
 96 ENTER_PAD          91     91     91
 97 0_PAD              ce     ce     f5
 98 COMMA_PAD          cf     cf     --
```

## Nøgleobservationer

- **Position 15 = ESC** i alle tre tabeller (0x1b). Dette er den fysiske,
  dedikerede ESC-tast. Driveren kaldte den fejlagtigt "Alt" → host-ESC-fejlen.
- **Position 55 = 0xff** i alle tre tabeller = død position. Driveren lagde
  fejlagtigt host-ESC her → intet skete. Rettet: host-ESC → position 15.
- **Ctrl-Æ = ESC**: position 26 (Æ, hvor `[` sidder) giver under Ctrl `0x1b`,
  fordi Ctrl+`[` = ESC. Dette var brugerens eneste virkende vej til ESC før fixet.
- **Nordiske tegn** (æ/ø/å + Æ/Ø/Å, ü/Ü) sidder på positionerne 26/27/43/56 og
  omsættes til Latin-1-punkter (0xe6/0xf8/0xe5 osv.) via normal/shift.
- **Funktions- og piletaster** (pos 58–98) giver ikke ASCII men interne
  firmware-koder 0x80–0xcf (+ 0xf5–0xfe under Ctrl); piletaster (77–82) og
  keypad-Enter/Tab er modifier-invariante.
- **Ctrl-kolonnen** for bogstaver følger den klassiske Ctrl-A..Ctrl-Z =
  0x01..0x1a-mapping (pos 30=A→0x01, 44=Z→0x1a).

## Krydstjek: er andre mapninger forkerte? (2026-08-18)

Efter ESC-fixet blev alle 99 positioner krydstjekket (host-tast i
`rc759_kbd.cpp` mod firmwarens funktion). Resultat: **ingen andre ESC-klasse-fejl.**

- **Firmware-døde positioner** (0xff i normal+shift+ctrl): `0, 29, 40, 42, 54, 55, 76`.
  - 0 og 55 → `IPT_UNUSED` (korrekt; 55 rettet).
  - 29/40/42/54 → modifiers (Ctrl, Caps Lock, venstre/højre Shift) — korrekt at de
    ikke giver en kode; de håndteres i matricen, ikke via keymap.
  - **76 → `KEYCODE_SCRLOCK` "(((O)))"**: eneste rigtige host-tast på en død position.
    Harmløs — positionen er reelt død på denne disk (bell/højttaler-tast firmwaren
    ikke bruger), så ingen funktion mistes (modsat ESC, hvor pos 15 var *levende*
    men fejl-labeled "Alt"). Kan evt. gøres til `IPT_UNUSED` for konsistens, men det
    er ikke en fejl.
- **Alle firmware-levende positioner** har en semantisk korrekt host-tast:
  bogstaver, tal og tegnsætning matcher firmwaren; funktions-, pile- og
  keypad-taster giver deres interne firmware-koder.
- **æ/ø/å/ü**: driverens `PORT_CHAR` (0xe6/0xf8/0xe5/0xfc) afspejler de fysiske
  danske keycaps, men *denne* disks normal/shift-tabel giver `{ } | ~` (US/programmør-
  layout) på pos 26/27/43/56. Det er en national-keymap-forskel bundet til
  bootdisken — ikke en driver-fejl. Positionerne (host-tasterne) er korrekte.

## Reproduktion

```
cd /Users/ravn/z80; python3 -c "d=open('scratch/rc759-pce/images/sw1400_r31a_d1.img','rb').read(); b=0x36a30; N=99; print('normal',d[b:b+N].hex()); print('shift',d[b+N:b+2*N].hex()); print('ctrl',d[b+2*N:b+3*N].hex())"
```

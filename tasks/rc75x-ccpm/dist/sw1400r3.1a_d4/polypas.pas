
CONST
  versno : INTEGER = $8324;
  ppasmodif  = 41;
  valuepar   = 0;
  refpar     = 1;
  realpar    = 0;
  stringpar  = 2;
  proc       = 5;
  realfunc   = 9;
  stringfunc = 10;
  ppaserr    = 190;
  konverr    = 191;   

TYPE
  navne = STRING[16];
    
VAR
  (* de fire reserver m} ikke slettes *)
  reserver,
  reserver1,
  reserver2,
  reserver3 : INTEGER;
  hovedfil  : FILE OF BYTE;
  helptal   : ARRAY [1..8] OF BYTE;



(* -------------------------------- *)
(* RUTINER TIL UDSKRIVNING AF HOVED *)
  
PROCEDURE openfile(filnavn : navne);
BEGIN
  assign(hovedfil, filnavn);
  rewrite(hovedfil);
END;

PROCEDURE closefile;
BEGIN
  close(hovedfil);
END;

PROCEDURE skriv_byte(tal : byte);
BEGIN
  write(hovedfil,tal);
END;

PROCEDURE skriv_navn(varnavn : navne);
VAR 
  i : integer;
BEGIN
  skriv_byte(len(varnavn));
  FOR i:=1 TO len(varnavn) DO
    skriv_byte(ord(varnavn[i]));
END;

PROCEDURE skriv_offset(offset : integer);
BEGIN
  skriv_byte(lo(offset));
  skriv_byte(hi(offset));
END;

PROCEDURE skriv_packtype;
BEGIN
  skriv_offset(ppasmodif);
END;

PROCEDURE skriv_versionsno;
BEGIN
  skriv_offset(versno);
END;

PROCEDURE skriv_proc;
BEGIN
  skriv_byte(proc);
END;

PROCEDURE skriv_realfunc;
BEGIN
  skriv_byte(realfunc);
END;

PROCEDURE skriv_stringfunc;
BEGIN
  skriv_byte(stringfunc);
END;

PROCEDURE skriv_typeogdim(partype, pardim : byte);
BEGIN
  
  
  skriv_byte(partype);
  skriv_byte(pardim);
END;

PROCEDURE skriv_reserver;
BEGIN
  skriv_offset(ofs(reserver));
END;


(* -------------------------------- *)
(* RUTINER TIL PARAMETER BEHANDLING *)
  
TYPE
  stringmax = STRING[255];


PROCEDURE comalerror(errorkode : integer);
BEGIN CODE
  $8B,$76,$04,           (* MOV SI,4[BP]  ; ERRORKODE   *)
  $BB,$20,$00,           (* MOV BX,32                   *)
  $8B,$2E,reserver3,     (* MOV BP,RESERVER3            *)
  $1E,                   (* PUSH DS                     *)
  $8E,$5E,$04,           (* MOV DS,4[BP]                *)
  $FF,$5E,$00,           (* CALLF DWORD PTR [BP]        *)       
  $1F,                   (* POP DS                      *)
  $8B,$2E,reserver3,     (* MOV BP,RESERVER3            *)
  $83,$ED,$06,           (* SUB BP,6                    *)
  $8B,$E5,               (* MOV SP,BP                   *)
  $CB;                   (* RETF                        *)
END;

(* UNDERRUTINER *)  
    
PROCEDURE henttal(segadr, ofsadr : integer; VAR tal : real);
VAR 
  i,
  ord0,
  expo : integer;
  s    : string[25];
  
  FUNCTION konv(segadr, ofsadr, no : integer): integer;
  VAR
    j,
    k : integer;
  BEGIN
    j:=no div 2;
    k:=mem[segadr:ofsadr+j];
    IF no mod 2 = 0 THEN konv:=k div 16
                    ELSE konv:=k mod 16;
  END; (* konv *)

BEGIN
  ord0:=ord('0');
  s:=chr(ord0+konv(segadr, ofsadr, 1)) + '.';
  FOR i:=2 TO 13 DO
  BEGIN
    s:=s+chr(ord0+konv(segadr, ofsadr, i));
  END;
  IF konv(segadr,ofsadr,0) <> 0 THEN s:='-'+s;
  expo:=mem[segadr:ofsadr+7];
  IF (expo=0) AND (konv(segadr,ofsadr,1)=0) THEN
  BEGIN
    tal:=0.0;
  END
  ELSE
  BEGIN
    expo:=expo-129;
    s:=s+'E';
    IF expo<0 THEN s:=s+'-';
    expo:=abs(expo);
    s:=s+chr(ord0+expo div 10)+chr(ord0+expo mod 10);
    val(s,tal,i);
    IF i<>0 THEN comalerror(konverr);
  END;
END; (* henttal *)


PROCEDURE gemtal(segadr, ofsadr : integer; tal : real);
VAR
  expo,
  k,
  ciffer  : integer;
  mystr   : string[18];

  PROCEDURE nibble(segadr, ofsadr : integer; no, value : byte);
  VAR
    j,
    k : integer;
  BEGIN
    j:=no div 2;
    k:=mem[segadr:ofsadr+j];
    IF no mod 2 = 0 THEN mem[segadr:ofsadr+j]:=value*16+k mod 16
                    ELSE mem[segadr:ofsadr+j]:=(k div 16)*16+value;
  END; (* nibble *)    
  
  FUNCTION somtal(ch :char): integer;
  BEGIN
    somtal:=ord(ch)-ord('0');
  END;
  
BEGIN
  str(tal,mystr);
  IF mystr[2]='-' THEN nibble(segadr,ofsadr,0,8)
                  ELSE nibble(segadr,ofsadr,0,0);
  k:=1;
  WHILE (k<=13) DO
  BEGIN
    IF k>=12 THEN ciffer:=0
    ELSE
      IF k=1 THEN ciffer:=somtal(mystr[3])
      ELSE ciffer:=somtal(mystr[k+3]);
    nibble(segadr, ofsadr, k, ciffer);
    k:=k+1;
  END;
  expo:=somtal(mystr[17])*10+somtal(mystr[18]);
  IF mystr[16]='-' THEN expo:=-expo;
  expo:=129+expo;
  IF tal = 0 THEN expo:=0;
  mem[segadr:ofsadr+7]:=expo;
END; (* gemtal *)

PROCEDURE hentstring(segadr, ofsadr : integer; VAR mystr : stringmax);
VAR
  i,
  antal,
  myseg,
  myofs  : integer;

BEGIN
  antal:=memw[segadr:ofsadr+2];
  IF antal>255 THEN comalerror(konverr);
  myseg:=seg(mystr);
  myofs:=ofs(mystr);
  FOR i:=1 TO antal DO
  BEGIN
    mem[myseg:myofs+i]:=mem[segadr:ofsadr+i+3];
  END;
  mem[myseg:myofs]:=antal;
END; (* hentstring *)

PROCEDURE gemstring(segadr, ofsadr : integer; mystr : stringmax);
VAR
  i,
  antal,
  myseg,
  myofs  : integer;

BEGIN
  antal:=len(mystr);
  IF antal > memw[segadr:ofsadr] THEN comalerror(konverr);
  myseg:=seg(mystr);
  myofs:=ofs(mystr);
  FOR i:=1 TO antal DO
  BEGIN
    mem[segadr:ofsadr+i+3]:=mem[myseg:myofs+i];
  END;
  memw[segadr:ofsadr+2]:=antal;
END; (* gemstring *)


(* DE V[SENTLIGE RUTINER *)

PROCEDURE getrealpar(no : byte; VAR tal : real);
VAR
  stackadr : integer;
BEGIN
  stackadr:=memw[seg(reserver):ofs(reserver)+6];
  henttal(memw[sseg:stackadr+4],memw[sseg:stackadr+4+no*2],tal);
END; (* getrealpar *)

PROCEDURE putrealpar(no : byte; tal : real);
VAR
  stackadr : integer;
BEGIN
  stackadr:=memw[seg(reserver):ofs(reserver)+6];
  gemtal(memw[sseg:stackadr+4],memw[sseg:stackadr+4+no*2],tal);
END; (* putrealpar *)

PROCEDURE getstringpar(no : byte; VAR mystr : stringmax);
VAR
  stackadr : integer;
BEGIN
  stackadr:=memw[seg(reserver):ofs(reserver)+6];
  hentstring(memw[sseg:stackadr+4],memw[sseg:stackadr+4+no*2],mystr);
END; (* getstringpar *)

PROCEDURE putstringpar(no : byte; mystr : stringmax);
VAR
  stackadr : integer;
BEGIN
  stackadr:=memw[seg(reserver):ofs(reserver)+6];
  gemstring(memw[sseg:stackadr+4],memw[sseg:stackadr+4+no*2],mystr);
END; (* putstringpar *)


(* CODE RUTINER *)

PROCEDURE returnfar;
BEGIN CODE
  $8B,$2E,reserver3,     (* MOV BP,RESERVER3 *)
  $83,$ED,$06,           (* SUB BP,6         *)
  $8B,$E5,               (* MOV SP,BP        *)
  $CB;                   (* RETF             *)
END;

PROCEDURE comalprgfunckey;
BEGIN CODE
  $55,                   (* PUSH BP              *)
  $BB,$1F,$00,           (* MOV BX,31            *)
  $8B,$2E,reserver3,     (* MOV BP,RESERVER3     *)
  $1E,                   (* PUSH DS              *)
  $8E,$5E,$04,           (* MOV DS,4[BP]         *)
  $FF,$5E,$00,           (* CALLF DWORD PTR [BP] *)       
  $1F,                   (* POP DS               *)
  $5D;                   (* POP BP               *)
END;

PROCEDURE returnresult(resseg, resofs, mylen : integer);
BEGIN CODE
  $8B,$46,$08,           (* MOV AX,8[BP]  ; RESSEG   *)
  $8B,$4E,$06,           (* MOV CX,6[BP]  ; RESOFS   *)
  $8B,$56,$04,           (* MOV DX,4[BP]  ; MYLEN    *)
  $8B,$2E,reserver3,     (* MOV BP,RESERVER3         *)
  $83,$ED,$06,           (* SUB BP,6                 *)
  $8B,$E5,               (* MOV SP,BP                *)
  $CB;                   (* RETF                     *)
END;

PROCEDURE return_realresult(tal : real);
BEGIN
  gemtal(seg(helptal),ofs(helptal),tal);
  returnresult(seg(helptal),ofs(helptal),0);
END;

PROCEDURE return_stringresult(mystr : stringmax);
VAR
  leng : integer;
BEGIN
  leng:=len(mystr);
  returnresult(seg(mystr),ofs(mystr)+1,leng);
END;


(* BEHANDLING AF POLYPASCAL-FEJL *)

PROCEDURE error(errno, errofs : integer);

  PROCEDURE hexwrite(no, antalfelter : integer);
  
    PROCEDURE hexciffer(cif : integer);
    BEGIN
      IF cif<=9 THEN write(cif:1)
      ELSE
      BEGIN
        write(chr(ord(cif-10)+ord('A')));
      END;
    END;
  
  BEGIN
    IF antalfelter = 1 THEN
    BEGIN
      hexciffer(no);
    END
    ELSE
    BEGIN
      hexwrite(no div 16, antalfelter-1);
      hexciffer(no mod 16);
    END;
  END;

BEGIN
  write('PolyPascal ');
  CASE hi(errno) OF
    0 : write('programafbrydelse (Ctrl C) ');
    1 : BEGIN
          write('I/0 fejl ');
          hexwrite(lo(errno),2);
        END;
    2 : BEGIN
          write('k|rselsfejl ');
          hexwrite(lo(errno),2);
        END;
  END;
  write(' ved PC=');
  hexwrite(errofs,4);
  comalerror(ppaserr);
END;

PROCEDURE init_errorhandler;
BEGIN
  ehofs:=ofs(error);
END;


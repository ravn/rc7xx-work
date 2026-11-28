PROGRAM mus;
(*$i polypas *)

CONST
  xios_int     = 40;
  mouse_read   = 30;
  mouse_init   = 1;
  mouse_status = 3;

  dok_mus  : stringmax =
     'brug af mus uden grafik';
  dok_init : stringmax = 
     'initialiserer musen';
  dok_status : stringmax =
     '0 ikke sket noget'@13@10'  1 knap er trykket, keyinf {ndret'@13@10'  2 musen er flyttet, dx og dy er {ndret';


VAR
  regs : RECORD
          ax,bx,cx,dx,bp,si,di,ds,es,flags : INTEGER;
         END;
  res,
  help : REAL;
  
PROCEDURE init_mouse;
BEGIN
  regs.ax:=mouse_read;
  regs.cx:=mouse_init;
  swint(xios_int,regs);
  returnfar;
END;
  
PROCEDURE status_mouse;
BEGIN
  regs.ax:=mouse_read;
  regs.cx:=mouse_status;
  swint(xios_int,regs);
  res:=lo(regs.ax);
  IF res = 2 THEN
  BEGIN
    help:=regs.bx;
    putrealpar(1,help);
    help:=regs.cx;
    putrealpar(2,help);
  END
  ELSE
    IF res = 1 THEN
    BEGIN
      help:=hi(regs.ax);
      putrealpar(3,help);
    END;
  return_realresult(res);
END;

BEGIN
  openfile('mus.hov');
  skriv_versionsno;
  skriv_packtype;
  skriv_offset(ofs(dok_mus));
  skriv_offset(ofs(init_mouse));
  skriv_offset(0);
  
  skriv_navn('musinit');
  skriv_proc;
  skriv_offset(ofs(dok_init));
  skriv_offset(ofs(init_mouse));
  skriv_byte(0);
  
  skriv_navn('musstatus');
  skriv_realfunc;
  skriv_offset(ofs(dok_status));
  skriv_offset(ofs(status_mouse));
  skriv_byte(3);
  skriv_navn('dx');
  skriv_typeogdim(refpar+realpar,0);
  skriv_navn('dy');
  skriv_typeogdim(refpar+realpar,0);
  skriv_navn('keyinf');
  skriv_typeogdim(refpar+realpar,0);
  
  skriv_byte(0);
  skriv_reserver;
  skriv_packtype;
  closefile;
  
END.


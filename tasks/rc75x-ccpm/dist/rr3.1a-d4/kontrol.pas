Program controle_board;

(*$I GSX*)

CONST
  bdos_int  = 224;
  c_rawio   =   6;
  inp_stat  = 255;
  xios_int  =  40;
  Xnvm_read =   3;
  RemXY     =  @27@106;
  GoRem     =  @27@107;
  RevOn     =  @27@112;
  RevOff    =  @27@113;
  CurOn     =  @27@109; (* t{ndcursor *)
  CurOff    =  @27@110; (* slukcursor *)
  Marker    =  @27@112@32@27@113@27@68; (* RevOn,' ',RevOff,CurLe *)
  ant_switch_ind =   4;
  ant_switch_ud  =   4;
  ant_meters     =   5;
  PICCOLINE      = 254; (* PICCOLINE => (6MHz -> FF) V (8MHz -> FE) *)
  Partner        =   0;

TYPE
  motor_step = 0..1000;

VAR
  ind                   : Array[1..ant_switch_ind,1..8] OF coor;
  relae                 : Array[1..ant_switch_ud,1..2] OF coor;
  neadle                : Array[1..ant_meters,1..2] OF coor;
  motor                 : Array[0..2] OF motor_step;
  direction             : Array[0..2] OF Integer;
  frame                 : Array[1..5] OF coor;
  pot                   : Array[1..5] OF coor;
  volt                  : Array[1..5] OF Real;
  i, x, y, tast         : Integer;
  step_type             : Integer;
  sw_ind                : Integer;
  sw_ud                 : Integer;
  step, slut            : Boolean;
  s                     : Real;

  Regs                  : Record
                            ax,bx,cx,dx,bp,si,di,ds,es,flags  : Integer;
                          End;

FUNCTION get_type : Integer;
  BEGIN
    regs.ax:= Xnvm_read;
    swint(xios_int,regs);
    get_type:= mem[regs.es:regs.si+53];
  END; (* get_type *)

FUNCTION key    : Integer;
  VAR
    ch : Char;
  BEGIN
    if keypress then
    Begin
      read(kbd,ch);
      key:= ord(ch);
    End
    else
     key:= 0;
  END; (* key *)

FUNCTION pwr(x,y: Integer):Integer;
  BEGIN
    pwr:= round(exp(y*ln(x)));
  END; (* pwr *)

PROCEDURE slet_funk_keys;
  VAR i : Integer;
  BEGIN
    for i:= 1 to 42 do
     write(@27@58,chr(i),@0);
    (* her ligger den numeriske talblok *)
    for i:= 58 to 126 do
     write(@27@58,chr(i),@0);
  END; (* Slet_funk_keys *)

PROCEDURE esc_test;
  VAR  ch : Char;
  BEGIN
    gotoxy(43,16);
    write(@7,RemXY,RevOn,'\nsker du at slutte (J/N) :',RevOff);
    Repeat
      ch:= chr(key);
    Until pos(ch,'jJnN'+@27)>0;
    if pos(ch,'jJ')>0 then slut:= TRUE;
    write(GoRem,'':27);
  END; (* esc_test *)

PROCEDURE init_stats;
  BEGIN
    step_type:= 0;
    for i:= 0 to 2 do
    Begin motor[i]:= 0; direction[i]:= 0; End;
    sw_ind:= 15;
    sw_ud :=  0;
    port[776]:= sw_ud;
    for i:= 1 to 5 do
     volt[i]:= 0;
    port[784]:= round(volt[5]);
  END; (* init_stats *)

PROCEDURE init_meters;
  VAR
    v       : 1..41;
    met     : Array[1..40] OF COOR;
    co, si  : Real;
    r       : Integer;
  PROCEDURE scale(x,y,r:Integer);
    VAR
      st      : String[2];
      co,si,i : Integer;
    BEGIN
      for i:= 0 to 10 do
      Begin
        charupvec(round(4050-(i*90)) mod 3600);
        str(i,st);
        co:= round(1.1*r*cos((43-3*i)*s))+x;
        si:= round(1.7*r*sin((43-3*i)*s))+y;
        gtext(co,si,st);
      End;
      charupvec(0);
    END; (* scale *)
  BEGIN (* init_meters *)
    s:= 2*PI/108;
    for i:= 1 to ant_meters do
    Begin
      CASE i OF
        1 : Begin x:=  5000; y:= 22000; r:= 3300; End;
        2 : Begin x:= 12000; y:= 22000; r:= 3300; End;
        3 : Begin x:=  5000; y:= 13800; r:= 3300; End;
        4 : Begin x:= 12000; y:= 13800; r:= 3300; End;
        5 : Begin x:= 27000; y:= 22000; r:= 3300; End;
      End; (* CASE *)
      met[1].x:= x;      met[1].y:= y;
      v:= 2;
      repeat
        co:= cos((v+7)*s);
        si:= sin((v+7)*s);
        met[v].x:= round(r*CO)+x;        met[v].y:= round(1.5*r*SI)+y;
        met[v+1].x:= round(0.9*r*co)+x;  met[v+1].y:= round(1.35*r*si)+y;
        met[v+2].x:= met[v].x;           met[v+2].y:= met[v].y;
        v:= v+3;
      until v=41;
      met[40]:= met[1];
      polyline(40,met);

      frame[1].x:= round(x+1.04*r);   frame[1].y:= round(y-0.3*r);
      frame[2].x:= round(x+1.04*r);   frame[2].y:= round(y+2.1*r);
      frame[3].x:= round(x-1.04*r);   frame[3].y:= round(y+2.1*r);
      frame[4].x:= round(x-1.04*r);   frame[4].y:= y-round(0.3*r);
      frame[5] := frame[1];
      polyline(5,frame);
      scale(x,y,r);

      neadle[i,1].x:= x; neadle[i,1].y:= y+200;
      neadle[i,2].x:= round(0.8*r*cos(43*s))+x;
      neadle[i,2].y:= round(1.3*r*sin(43*s))+y;
      polyline(2,neadle[i]);
      if i<>5 then gtext(x-r+400,y,chr(i+47));
    End; (* FOR *)
    s:= 2*pi/1024;
  END; (* init_meters *)

PROCEDURE init_switches;
  VAR
    ud       : Array[1..ant_switch_ud,1..8] OF coor;
  BEGIN
    for i:= 1 to ant_switch_ind do
    Begin
      case i of
        1 : Begin x:= 5000;  y:= 7000; End;
        2 : Begin x:= 12000; y:= 7000; End;
        3 : Begin x:= 5000;  y:= 3900; End;
        4 : Begin x:= 12000; y:= 3900; End;
      End; (* CASE *)
      ind[i,1].x:= x;      ind[i,1].y:= y;
      ind[i,2].x:= x;      ind[i,2].y:= y+1000;
      ind[i,3].x:= x-1000; ind[i,3].y:= y+1000;
      ind[i,4].x:= x-1000; ind[i,4].y:= y;
      ind[i,5].x:= x;      ind[i,5].y:= y;
      ind[i,6].x:= x+1000; ind[i,6].y:= y;
      ind[i,7].x:= x+1000; ind[i,7].y:= y+1000;
      ind[i,8].x:= x;      ind[i,8].y:= y+1000;
      polyline(8,ind[i]);
      polyfill(5,ind[i]);
      gtext(x-2400,y+100,'H\J');
      gtext(x+1200,y+100,'LAV');
      gtext(x-100,y-1000,chr(i+47));
    End; (* FOR *)

    for i:=1 to ant_switch_ud do
    Begin
      case i of
        1 : Begin x:= 20000; y:= 7000; End;
        2 : Begin x:= 27000; y:= 7000; End;
        3 : Begin x:= 20000; y:= 3900; End;
        4 : Begin x:= 27000; y:= 3900; End;
      End; (* CASE *)

      ud[i,1].x:= x-1000;  ud[i,1].y:= y+500;
      ud[i,2].x:= x-1000;  ud[i,2].y:= y+1000;
      ud[i,3].x:= x-400;   ud[i,3].y:= y+500;
      ud[i,4].x:= x-1000;  ud[i,4].y:= y;
      ud[i,5]:= ud[i,1];
      ud[i,6].x:= x-2000;  ud[i,6].y:= y+500;
      ud[i,7].x:= x-2000;  ud[i,7].y:= y;
      polyline(7,ud[i]);

      ud[i,1].x:= x+1000;  ud[i,1].y:= y+500;
      ud[i,2].x:= x+1000;  ud[i,2].y:= y+1000;
      ud[i,3].x:= x+400;   ud[i,3].y:= y+500;
      ud[i,4].x:= x+1000;  ud[i,4].y:= y;
      ud[i,5]:= ud[i,1];
      ud[i,6].x:= x+2000;  ud[i,6].y:= y+500;
      ud[i,7].x:= x+2000;  ud[i,7].y:= y;
      ud[i,8]:= ud[i,6];
      polyfill(8,ud[i]);
      relae[i,1].x:= x;    relae[i,1].y:= y-50;
      relae[i,2].x:= x+400; relae[i,2].y:= y+900;
      polyline(2,relae[i]);
      gtext(x-100,y-1000,chr(i+47));
    End; (* for *)
  END; (* init_switches *)

PROCEDURE init_pot_meter;
  VAR
    pkt  : Array[1..31] OF coor;
    st   : String[2];
  BEGIN
    pkt[1].x:= 21000; pkt[1].y:= 19000; i:= 2;
    repeat
      pkt[i].x:= 21500; pkt[i].y:= 19000+trunc(i/3)*1000;
      pkt[i+1].x:= 21500; pkt[i+1].y:= 19000+trunc(i/3+1)*1000;
      pkt[i+2].x:= 21000; pkt[i+2].y:= 19000+trunc(i/3+1)*1000;
      i:= i+3;
    until i>=30;
    polyline(31,pkt);

    pkt[1].x:= 20000; pkt[1].y:= 29000;
    pkt[2].x:= 20000; pkt[2].y:= 19000;
    polyline(2,pkt);

    pot[1].x:= 19250;       pot[1].y:= 18872;
    pot[2].x:= 19250;       pot[2].y:= 19000;
    pot[3].x:= 20750;       pot[3].y:= 19000;
    pot[4].x:= 20750;       pot[4].y:= 18872;
    pot[5].x:= pot[1].x+50;
    pot[5].y:= pot[1].y;
    writemode(3);
    polyline(5,pot);
    writemode(1);

    for i:= 0 to 10 do
    Begin
      str(i,st);
      gtext(22000,18700+i*1000,st);
    End; (* FOR *)
  END; (* init_pot_meter *)

PROCEDURE pynt;
  BEGIN
    (* ramme om sk{rm *)
    frame[1].x:=     0; frame[1].y:= 32000;
    frame[2].x:= 32000; frame[2].y:= 32000;
    frame[3].x:= 32000; frame[3].y:=     0;
    frame[4].x:=     0; frame[4].y:=     0;
    frame[5]:= frame[1];
    polyline(5,frame);
    frame[1].y:= 30500; frame[2].y:=  30500;
    polyline(2,frame);
    gtext(9600,30800,'PICCOLINE-ADAM  KONTROL BORD');

    (* ramme om digital ind *)
    frame[1].x:=  1000; frame[1].y:=  1000;
    frame[2].x:= 16000; frame[2].y:=  1000;
    frame[3].x:= 16000; frame[3].y:=  9000;
    frame[4].x:=  1000; frame[4].y:=  9000;
    frame[5]:= frame[1];
    polyline(5,frame);
    frame[1].y:=  2200; frame[2].y:=  2200;
    polyline(2,frame);
    gtext(5500,1200,'DIGITAL M]LING');

    (* ramme om digital ud *)
    frame[1].x:= 17000; frame[1].y:=  1000;
    frame[2].x:= 31000; frame[2].y:=  1000;
    frame[3].x:= 31000; frame[3].y:=  9000;
    frame[4].x:= 17000; frame[4].y:=  9000;
    frame[5]:= frame[1];
    polyline(5,frame);
    frame[1].y:=  2200; frame[2].y:=  2200;
    polyline(2,frame);
    gtext(20000,1200,'DIGITAL STYRING');

    (* ramme om analog ind *)
    frame[1].x:=  1000; frame[1].y:= 11000;
    frame[2].x:= 16000; frame[2].y:= 11000;
    frame[3].x:= 16000; frame[3].y:= 30000;
    frame[4].x:=  1000; frame[4].y:= 30000;
    frame[5]:= frame[1];
    polyline(5,frame);
    frame[1].y:= 12200; frame[2].y:=  12200;
    polyline(2,frame);
    gtext(5500,11200,'ANALOG M]LING');

    (* ramme om analog ud *)
    frame[1].x:= 17000; frame[1].y:= 30000;
    frame[2].x:= 17000; frame[2].y:= 16200;
    frame[3].x:= 24000; frame[3].y:= 16200;
    frame[4].x:= 24000; frame[4].y:= 20000;
    polyline(4,frame);
    (* - fortsat *)
    frame[2].x:= 31000; frame[2].y:= 30000;
    frame[3].x:= 31000; frame[3].y:= 20000;
    polyline(4,frame);
    frame[1].x:= 17000; frame[1].y:= 17500;
    frame[2].x:= 24000; frame[2].y:= 17500;
    polyline(2,frame);
    gtext(17400,16500,'ANALOG STYRING');

    (* ramme om stepmotor styring *)
    frame[1].x:= 17000; frame[1].y:= 11000;
    frame[2].x:= 17000; frame[2].y:= 15500;
    frame[3].x:= 24300; frame[3].y:= 15500;
    frame[4].x:= 24300; frame[4].y:= 19500;
    polyline(4,frame);
    (* - fortsat *)
    frame[2].x:= 31000; frame[2].y:= 11000;
    frame[3].x:= 31000; frame[3].y:= 19500;
    polyline(4,frame);
    frame[1].x:= 17000; frame[1].y:= 14300;
    frame[2].x:= 24300; frame[2].y:= 14300;
    frame[3].x:= 24300; frame[3].y:= 15500;
    polyline(3,frame);
    gtext(17600,14500,'MOTOR STYRING');
    gotoxy(60,11);
    write('MOTOR 0:');
    gotoxy(60,13);
    write('MOTOR 1:');
    gotoxy(60,15);
    write('MOTOR 2:');

    (* skriv RC logoet i |verste h|jre hj|rne *)
    frame[1].x:= 31400; frame[1].y:= 31600;
    frame[2].x:= 31000; frame[2].y:= 31600;
    frame[3].x:= 31000; frame[3].y:= 30800;
    polyline(3,frame);
    frame[1].x:= 31400; frame[1].y:= 31300;
    frame[2].x:= 31150; frame[2].y:= 31300;
    frame[3].x:= 31150; frame[3].y:= 30800;
    frame[4].x:= 31400; frame[4].y:= 30800;
    polyline(4,frame);
  END; (* pynt *)

PROCEDURE init_motor;
  VAR
    nr, dummy,
    long        : Integer;
    ch          : Char;
  BEGIN
    step:= false;
    gotoxy(65,16);
    write(RevOn,'PAUSERER',RevOff);
    gotoxy(42,15);
    write(RemXY,'':17,GoRem,'MOTOR NR : ',Marker);
    repeat
      ch:= chr(key);
    until pos(ch,'012')>0;
    write(ch);
    nr:= ord(ch)-48;
    gotoxy(42,16);
    write(RemXY,'':17,GoRem,'HEL/HALV Step (0/1) ',Marker);
    repeat
      ch:= chr(key);
    until pos(ch,'01')>0;
    write(ch);
    gotoxy(42,16);
    if ch='1' then
    Begin
     step_type:= (step_type and 255) or pwr(2,nr+5); (* det drejer sig om bit 5,6 og 7 *)
     write('HEL/',RevOn,'HALV',RevOff);
    End
    else
    Begin
     step_type:= step_type and (255-pwr(2,nr+5));
     write(RevOn,'HEL',RevOff);
    End;
    (* l{s antal steps fra keyboard *)
    long:= 0;
    gotoxy(69,11+nr*2);
    write(RemXY,'':5,GoRem,Marker);
    repeat
      ch:= chr(key);
    until pos(ch,'+-0123456789'+@27)<>0;
    if ch<>@27 then
    Begin
      if ch='-' then
       Begin direction[nr]:= 2; write(ch,Marker); End
      else
       Begin direction[nr]:= 0; write('+',Marker); End;
      if pos(ch,'0123456789')>0 then
       Begin motor[nr]:= ord(ch)-48; write(ch,Marker); long:= succ(long); End
      else motor[nr]:= 0;
      repeat
        repeat
          ch:= chr(key);
        until (pos(ch,'0123456789')>0) or (ch=@13) or (ch=@27);
        if (ch<>@13) and (ch<>@27) then
        Begin
          motor[nr]:= motor[nr]*10+ord(ch)-48;
          write(ch,Marker); long:= succ(long);
        End;
      until (long=3) or (ch=@13) or (ch=@27);
      write(' ');
      if ch=@27 then motor[nr]:= 0;
    End; (* if *)
    if motor[nr]=0 then
     Begin gotoxy(69,11+nr*2); write('':5); end;
    gotoxy(42,15);
    write('':16);
    gotoxy(42,16);
    write('':33);
    step:= TRUE;
  END;(* init_motor *)

PROCEDURE update_neadle(n,r:Integer;volt:Real);
  BEGIN
    x:= round(0.85*r*cos((384-(volt*256/10))*s))+neadle[n,1].x;
    y:= round(1.1*r*sin((384-(volt*256/10))*s))+neadle[n,1].y-200;
    polyline(2,neadle[n]);
    neadle[n,2].x:= x;
    neadle[n,2].y:= y;
    polyline(2,neadle[n]);
  END; (* update_neadle *)

PROCEDURE update_pot_meter;
  VAR
    dy   : Integer;
  BEGIN
    if (((tast=43) and (pot[2].y<29000)) or ((tast=45) AND (pot[2].y>19000))) then
    Begin
      polyline(5,pot);
      if tast=43 then dy:= +125
      else dy:= -125;
      pot[1].y:= pot[1].y+dy;
      pot[2].y:= pot[2].y+dy;
      pot[3].y:= pot[3].y+dy;
      pot[4].y:= pot[4].y+dy;
      pot[5].y:= pot[1].y;
      polyline(5,pot);
      volt[5]:= (pot[2].y-19000)/1000;
      update_neadle(5,3300,volt[5]);
    End; (* IF *)
  END; (* update_pot_meter *)

PROCEDURE skift(nr : Integer);
  BEGIN
    polyline(2,relae[nr]);
    relae[nr,2].x:= relae[nr,1].x+(relae[nr,1].x-relae[nr,2].x);
    polyline(2,relae[nr]);
  END; (* skift *)

PROCEDURE switch(VAR points);
  BEGIN
    polyfill(8,points);
    writemode(1);
    polyline(8,points);
    writemode(3);
  END; (* switch *)

PROCEDURE set_output;
  VAR  times : Integer;
  BEGIN
    times:= 0;
    repeat
      if (tast=43) or (tast=45) then
      Begin
        update_pot_meter;
        port[784]:= round(volt[5]/0.03937);
      End
      else
      Begin (* tast = 0,1,2,3 *)
        sw_ud:= sw_ud exor pwr(2,tast-48);
        port[776]:= sw_ud;
        skift(tast-47);
      End; (* if *)
      times:= succ(times);
      if times<4 then tast:= key;
    until (times=4) or (NOT (chr(tast) IN ['+','-','0','1','2','3']));
  END; (* set_output *)

PROCEDURE read_input;
  VAR
    wait, digiind, nr,
    channel, test               : Integer;
  BEGIN
    (* digi ind *)
    digiind:= port[770] mod 256;
    test:= sw_ind exor digiind;
    for i:= 0 to 3 do
     if (test and pwr(2,i))=pwr(2,i) then
      switch(ind[i+1]);
    sw_ind:= digiind;
    (* ana ind *)
    for channel:= 0 to 3 do
    Begin
      port[774]:= channel+16+step_type;
      if step then
      Begin
        (* k|r step motor *)
        step:= FALSE;
        for nr:= 0 to 2 do
        Begin
          gotoxy(70,11+nr*2);
          if motor[nr]>0 then
          Begin
            motor[nr]:= pred(motor[nr]);
            write(motor[nr]:3);
            port[768+nr*2]:= direction[nr]+1;
            if motor[nr]>0 then step:= TRUE
            else Begin gotoxy(69,11+nr*2); write('':4); End;
            port[768+nr*2]:= direction[nr];
          End;(* if *)
        End;(* for *)
      End
      else
      Begin
        wait:= 10;
        while wait>=0 do wait:= pred(wait);
      End;
      port[774]:= channel+step_type;
      repeat
      until (port[768] and 1)=1;
      volt[channel+1]:= (port[784] mod 256)*0.03937;
      port[774]:= channel+16+step_type;
      update_neadle(channel+1,3300,volt[channel+1]);
    End; (* for *)
  END; (* read_input *)


BEGIN
  if get_type >= PICCOLINE then
  Begin
    slet_funk_keys;
    (* programering af cursor pilene *)
    write(@27@58@72@43@0);  (* í := + *)
    write(@27@58@80@45@0);  (* ì := - *)
    write(@27@58@78@43@43@43@43@0);  (* A3 := ++++ *)
    write(@27@58@79@45@45@45@45@0);  (* A4 := ---- *)
    (* programering af motor tasterne *)
    write(@27@58@59,'M00',@0);  (* F1 := M00 *)
    write(@27@58@60,'M01',@0);  (* F2 := M01 *)
    write(@27@58@64,'M10',@0);  (* F6 := M10 *)
    write(@27@58@65,'M11',@0);  (* F7 := M11 *)
    write(@27@58@69,'M20',@0);  (* F11:= M20 *)
    write(@27@58@70,'M21',@0);  (* F12:= M21 *)
    (* programering af num retur til retur *)
    write(@27@58@76@13@0);  (* num êÉ := êÉ *)

    openws(1);

    init_meters;

    init_switches;

    init_stats;

    init_pot_meter;    

    pynt;

    writemode(3);

    slut := FALSE;

    repeat
      tast:= key;
      if (chr(tast) IN ['+','-','0','1','2','3']) then set_output;
      if (chr(tast) IN ['m','M']) then init_motor;
      read_input;
      if tast=27 then esc_test;
    until slut; { tast=27; }                   (* ESC *)

    writemode(1);

    closews;

  End (* if *)
  else (* Partner *)
    writeln('Maskine IKKE PICCOLINE');
END.mering afÈ}'  ßõ§áááá                    P
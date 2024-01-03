20 VDU 23,0,192,0 : REM logical screen scaling off
30 VDU 23,1,0 : REM disable text cursor
100 MODE 0 : SW%=640: SH%=480 : W%=640 : H%=480 : F$="img/purple_lori_640x480_r3g2b2.data"

150 PROCsetPalette

200 FHAN%=OPENIN(F$)
210 IF FHAN% = 0 THEN PRINT "No file" : GOTO 1000
220 REM FLEN%=EXT#FHAN%
230 REM IF W%*H%*4 <> FLEN% THEN PRINT "Bad Size" : GOTO 1000

300 X%=0:Y%=0:DRW%=1
310 FOR I%=0 TO 1228800-1 : REM FLEN%-1
320 R%=BGET#FHAN%
330 G%=BGET#FHAN%
340 B%=BGET#FHAN%
350 A%=BGET#FHAN%
360 C% = R%/127 + (G%/255)*3 + (B%/255)*6
370 IF DRW%=1 THEN GCOL 0,C%: PLOT 69,X%,Y%
380 X%=X%+1
390 IF X%>=W% THEN X%=0 : Y%=Y%+1 : DRW%=1 
400 IF X%>=SW% THEN DRW%=0
410 NEXT
420 CLOSE#FHAN%

500 REPEAT UNTIL INKEY(0)=-1 : REM Clear key buffer
510 REPEAT : key=INKEY(10) : UNTIL key <> -1 

1000 VDU 23,0,192,1 : REM logical screen scaling on
1010 VDU 23,1,1 : REM enable text cursor
1020 END

4000 DEF PROCsetPalette
4005 COLOUR 15,255,255,255
4010 r%=0 : g%=0 : b%=0
4020 DIM A%(3) : A%(0)=0 : A%(1)=127 : A%(2)=255
4030 DIM B%(2) : B%(0)=0 : B%(1)=255
4040 FOR COL%=0 TO 11
4050   r%=COL% MOD 3
4060   g%=(COL% DIV 3) MOD 2
4070   b%=(COL% DIV 6) MOD 2
4080   COLOUR COL%, A%(r%), B%(g%), B%(b%)
4085   C.15 : PRINT "Col "+RIGHT$("  "+STR$(COL%),2)+" RGB "+RIGHT$("  "+STR$~(A%(r%)),2)+","+RIGHT$("  "+STR$~(B%(g%)),2)+","+RIGHT$("  "+STR$~(B%(b%)),2)
4090 NEXT
4100 ENDPROC

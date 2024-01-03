20 VDU 23,0,192,0 : REM logical screen scaling off
30 VDU 23,1,0 : REM disable text cursor
50 DIM REVLU%(64) : PROCloadLUT
60 SW%=320:SH%=240

100 REM MODE 8 : SW%=320: SH%=240 : W%=320 : H%=240 : F$="img/purple_lori.bgr2"
110 MODE 3 : SW%=640: SH%=240 : W%=640 : H%=240 : F$="img/purple_lori_640x240.bgr2"

200 FHAN%=OPENIN(F$)
210 IF FHAN% = 0 THEN PRINT "No file" : GOTO 1000
220 FLEN%=EXT#FHAN%
230 IF W%*H% <> FLEN% THEN PRINT "Bad Size" : GOTO 1000

300 X%=0:Y%=0:DRW%=1
310 FOR I%=0 TO FLEN%-1
320 D%=BGET#FHAN%
330 C%=REVLU%(D% AND &3F)
340 IF DRW%=1 THEN GCOL 0,C%: PLOT 69,X%,Y%
350 X%=X%+1
360 IF X%>=W% THEN X%=0 : Y%=Y%+1 : DRW%=1 
370 IF X%>=SW% THEN DRW%=0
380 NEXT
390 CLOSE#FHAN%

500 REPEAT UNTIL INKEY(0)=-1 : REM Clear key buffer
510 REPEAT : key=INKEY(10) : UNTIL key <> -1 

1000 VDU 23,0,192,1 : REM logical screen scaling on
1010 VDU 23,1,1 : REM enable text cursor
1020 END

4000 DEF PROCloadLUT
4010 REM Load the RGB Look up table
4040 REM REVLU%() is a reverse lookup table to get the colour  
4050 LOCAL I%
4060 RESTORE 4210
4070 FOR I%=0 TO 63
4080 READ REVLU%(I%)
4090 NEXT
4095 ENDPROC

4200 REM - RGB reverse map to colour
4210 DATA  0, 16,  4, 12, 17, 18, 19, 20,  2, 21,  6, 22, 10, 23, 24, 14
4220 DATA 25, 26, 27, 28, 29,  8, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39
4230 DATA  1, 40,  5, 41, 42, 43, 44, 45,  3, 46,  7, 47, 48, 49, 50, 51
4240 DATA  9, 52, 53, 13, 54, 55, 56, 57, 58, 59, 60, 61, 11, 62, 63, 15

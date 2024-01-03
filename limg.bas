10 MODE 8
20 VDU 23,0,192,0,23,1,0
30 IF HIMEM>65536 THEN ADL=1 ELSE ADL=0 : REM 24-bit addr basic
40 IF ADL=1 THEN MB%=0 ELSE MB%=&40000
50 DIM REVLU%(64) : PROCloadLUT
60 SW%=320:SH%=240
70 RGBA=1
80 NI%=9 : DIM F$(NI%),T$(NI%),W%(NI%),H%(NI%),ALPHA%(NI%)
90 FLINE%=NI%+2

100 CLS : C.15: PRINT TAB(0,0);"Choose an Image:"; : C.2
110 RESTORE 200 
120 FOR I%=1 TO NI%
130 READ T$(I%),F$(I%),W%(I%),H%(I%),ALPHA%(I%)
140 PRINT TAB(1,I%);RIGHT$("    "+STR$(I%),(I% DIV 10)+1);TAB(4,I%);T$(I%);
150 NEXT
160 C.15 : img = FNinputInt("Number 1-"+STR$(NI%)+":")
170 IF img < 1 OR img > NI% THEN GOTO 160
180 GOTO 400

200 DATA "Rialto Bridge","img/rialto.bgr2",320,213,0
210 DATA "Pinata Assif","img/asshat.bgr2",197,231,0
220 DATA "Gundam","img/gundam1.bgr2",228,240,0
230 DATA "Cyberpunk Girl","img/girl2.bgr2",192,240,0
240 DATA "Flower Girl","img/girl1.bgr2",240,240,0
250 DATA "Parrot","img/parrot_small3.bgr2",188,240,0
260 DATA "Geisha","img/girl3.bgr2",160,240,0
270 DATA "Osaka Palace","img/osaka.bgr2",320,240,0
280 DATA "Purple Lorikeet","img/purple_lori.bgr2",320,240,0

400 s%=3+ALPHA%(img)
410 efs%=W%(img)*H%(img)
420 x%=0:y%=0:d%=1

430 FHAN%=OPENIN(F$(img))
440 IF FHAN% = 0 THEN PROCstatusMsg("No file",1) : k=INKEY(100) : GOTO 100
450 FLEN%=EXT#FHAN% : REM PROCstatusMsg(STR$(FLEN%)+" bytes",10)
460 IF efs% <> FLEN% THEN PROCstatusMsg("Bad size",1) : CLOSE#FHAN% : k=INKEY(100) :  GOTO 100

500 pix%=0 : pos%=0
510 FOR i%=0 TO FLEN%
520 c2%=BGET#FHAN%
540 c%=REVLU%(c2% AND &3F)
550 GCOL 0,c%: PLOT 69,x%,y%
560 x%=x%+1
570 IF x%>=W%(img) THEN x%=0 : y%=y%+1 : d%=1 
580 IF x%>=SW% THEN d%=0
600 NEXT
610 CLOSE#FHAN%

620 REPEAT UNTIL INKEY(0)=-1 : REM Clear key buffer
630 REPEAT : key=INKEY(10) : UNTIL key <> -1 
640 GOTO 100

999 END

1000 DEF PROCclearStatusLine
1010 PRINT TAB(0,FLINE%);SPC(40);
1025 ENDPROC

1030 DEF PROCstatusMsg(Msg$,col%)
1035 Xpos%=40-LEN(Msg$)
1040 COLOUR col% : PRINT TAB(Xpos%,FLINE%);Msg$;
1045 ENDPROC

1100 DEF FNinputStr(prompt$)
1110 PROCclearStatusLine
1120 COLOUR 31 : PRINT TAB(0,FLINE%);prompt$; : COLOUR 15 : INPUT s$
1130 =s$

1150 DEF FNinputInt(prompt$)
1160 PROCclearStatusLine
1170 COLOUR 31 : PRINT TAB(0,FLINE%);prompt$; : COLOUR 15 : INPUT i%
1180 =i%

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

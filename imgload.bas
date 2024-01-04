   10 MODE 0
   20 VDU 23,0,192,0,23,1,0 : REM set logical draw and turn off cursor
   30 :
   40 PRINT "Enter Filename (RGBA2222 format) "; : INPUT F$
   50 PRINT "Width "; : INPUT W%
   60 PRINT "Height "; : INPUT H%
   80 :
  120 FHAN%=OPENIN(F$)
  130 IF FHAN% = 0 THEN PRINT "failed to open "+F$ : GOTO 1000
  140 FLEN%=EXT#FHAN% 
  150 IF FLEN%<>W%*H% THEN PRINT "wrong size, expected "+STR$(W%*H%) : GOTO 1000
  155 :
  160 BYTES%=W%*H% : BLOCK%=1024
  170 BM%=0 : BUFID%=&FA00 + BM%
  175 :
  190 VDU 23,0,&A0,BUFID%;2 : REM adv bufffer cmd 2 = Clear
  200 REM Loading of data 
  210 REPEAT
  240   VDU 23,0,&A0,BUFID%;0,BLOCK%; : REM adv buffer cmd 0 Write Block.
  245   :
  250   REM Stream data
  260   FOR I%=0 TO BLOCK%-1 : VDU BGET#FHAN% : NEXT I%
  265   PRINT ".";
  270   BYTES%=BYTES%-BLOCK% : IF BYTES%>0 AND BYTES%<BLOCK% THEN BLOCK%=BYTES%
  275   :
  280 UNTIL BYTES%=0
  300 REM create bitmap from buffer
  310 VDU 23,27,0,BM% : REM select bitmap (buffer &FA00+BM%)
  320 VDU 23,0,&A0,BUFID%;14 : REM consolidate
  330 VDU 23,27,&21,W%;H%;1 : REM create bitmap from buffer format 1
  335 :
  360 CLOSE#FHAN%
  365 :
  400 PRINT "Press Return to draw";
  410 INPUT A%
  420 MODE 8
  425 :
  430 X%=(320-W%)/2 : Y%=(240-H%)/2 
  450 VDU 23,27,0,BM% : REM select bitmap (buffer &FA00+BM%)
  480 VDU 23,27,3,X%;Y%; : REM draw current bitmap
  495 :
  500 REM wait for a key
  510 REPEAT UNTIL INKEY(0)=-1 : REM Clear key buffer
  520 REPEAT : key=INKEY(10) : UNTIL key <> -1 
  530 :
 1000 VDU 23,0,192,1,23,1,1 : REM restore cursor and logical drawing
 1010 END

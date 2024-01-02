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
  160 SIZE%=W%*H% : NUMBM%=1 : ROWS%=H% : BLOCK%=SIZE%
  170 IF SIZE% <= 65536 THEN GOTO 200
  175 :
  180 PRINT "Image too large: Splitting" : NUMBM%=2 : REM hack
  190 ROWS%=65536/W% : BLOCK%=W%*ROWS%
  195 :
  200 REM Loading of data 
  210 FOR BM%=0 TO NUMBM%-1 
  215   BUFID%=&FA00 + BM%
  220   PRINT "Load bitmap "+STR$(BM%)+" bufId "+STR$(BUFID%)+" "+STR$(ROWS%)+" rows "+STR$(BLOCK%)+" bytes ...";
  225   :
  230   VDU 23,0,&A0,BUFID%;2 : REM adv bufffer cmd 2 = Clear
  240   VDU 23,0,&A0,BUFID%;0,BLOCK%; : REM adv buffer cmd 0 Write Block.
  245   :
  250   REM Stream data
  260   FOR I%=0 TO BLOCK%-1 : VDU BGET#FHAN% : NEXT I%
  270   PRINT " done."
  275   :
  300   REM create bitmap from buffer
  305   PRINT "Create bitmap "+STR$(BM%)+" W "+STR$(W%)+" H "+STR$(ROWS%)
  310   VDU 23,27,0,BM% : REM select bitmap (buffer &FA00+BM%)
  320   VDU 23,27,&21,W%;ROWS%;1 : REM create bitmap from buffer format 1
  325   :
  330   BLOCK%=SIZE%-BLOCK%
  340   ROWS%=H%-ROWS%
  350 NEXT BM%
  360 CLOSE#FHAN%
  365 :
  400 PRINT "Press Return to draw";
  410 INPUT A%
  420 MODE 8
  425 :
  430 ROW%=0 : COL%=(320-W%)/2
  440 FOR BM%=0 TO NUMBM%-1 
  450   VDU 23,27,0,BM% : REM select bitmap (buffer &FA00+BM%)
  460   IF BM%>0 THEN ROW%=65536/W%
  470   REM PRINT "Draw bitmap "+STR$(BM%)" at "+STR$(COL%)+","+STR$(ROW%)
  480   VDU 23,27,3,COL%;ROW%; : REM draw current bitmap
  490 NEXT BM%
  495 :
  500 REM wait for a key
  510 REPEAT UNTIL INKEY(0)=-1 : REM Clear key buffer
  520 REPEAT : key=INKEY(10) : UNTIL key <> -1 
  530 :
 1000 VDU 23,0,192,1,23,1,1 : REM restore cursor and logical drawing
 1010 END

    5 REM https://github.com/breakintoprogram/agon-bbc-basic/blob/main/tests/udg.bas
   10 READ A
   20 IF A=-1 THEN GOTO 120
   30 VDU 23,A
   40 FOR I=0 TO 7
   50   READ A
   60   VDU A
   70 NEXT
   80 GOTO 10
   90 DATA 128,60,66,165,129,165,153,66,60
  100 DATA 129,170,85,170,85,170,85,170,85
  110 DATA -1
  120 VDU 128,129
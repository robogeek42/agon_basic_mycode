   10 REM AMAZING GRACE
   11 REM https://github.com/breakintoprogram/agon-bbc-basic/blob/main/tests/sound_1.bas
   20 REM
   30 REM
   40 REPEAT
   50   REPEAT
   60     READ P%,D%
   70     SOUND 1,-10,P%,D%
   80   UNTIL P%=0 AND D%=0
   90   RESTORE
  100 UNTIL FALSE
  110 REM
  120 DATA 33,12,53,24,69,4,61,4,53,4,69,24,61,12,53,24,41,12,33,36,53,24,69,4,61,4,53,4,69,24,61,12,81,60
  130 DATA 69,12,81,24,69,4,61,4,53,4,69,24,61,12,53,24,41,12,33,36,53,24,69,4,61,4,53,4,69,24,61,4,69,4,61,4,53,60,0,0

10 REM From gunrock00 YouTube via Agon discord
20 REM Modified for the Agon Light2
30 MODE 0
40 n=200 
50 r= 2*PI/235 
60 x=0: u=0: v=0: t=0.22
70 s=180
80 REPEAT
90 PRINT "Bubble Universe Agon Light2"
100 VDU 23,1,1
110 VDU 29,640;520;
120 FOR i=0 TO n STEP 2
130 FOR j=0 TO n STEP 2
140 u=SIN(i+v) + SIN(r*i+x)
150 v=COS(i+v) + COS(r*i+x)
160 x=u+t
170 GCOL 0,j
180 PLOT 69, u*s, v*s
190 NEXT j
200 NEXT i
210 i=t+0.025
220 VDU 12
230 UNTIL FALSE

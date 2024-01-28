   10 DIM A(16):A(0)=0:A(1)=24:A(2)=6:A(3)=30:A(4)=36:A(5)=12:A(6)=42:A(7)=18:A(8)=9:A(9)=33:A(10)=3:A(11)=27:A(12)=45:A(13)=21:A(14)=39:A(15)=15
   20 REM ordered dither pattern stored in A() array above; 4x4 grid of thresholds
   30 MODE 10:REM set 320x240, 4 colour graphics mode
   40 VDU 23,1,0:REM hide flashing text cursor
   45 VDU 23,0,192,0:REM logical screen scaling off
   50 X=0:Y=-.1:Z=3:REM camera position
   60 FOR N=8 TO 238:REM iterate over screen pixel rows
   70   FOR M=0 TO 319:REM iterate over screen pixel columns
   80     U=(M-159.5)/160:REM x component of ray vector
   90     V=(N-127.5)/160:REM y component of ray vector
  100     W=1/SQR(U*U+V*V+1):REM z component of ray vector
  110     U=U*W:V=V*W:REM normalise x and y components
  120     I=SGNU:REM is ray facing left or right? I becomes x and y coordinates for sphere
  130     C=FNray(X,Y,Z,U,V,W,I):REM fire ray from X,Y,Z along U,V,W
  140     GCOL0,3-(48*SQRC+A(M MOD4+N MOD4*4)/3)DIV16:REM set draw colour using ordered dithering
  150     PLOT69,M,247-N:REM plot pixel (4x multiplier due to resolution-independent graphics coordinates - 1280x1024)
  160   NEXT
  170 NEXT
  175 VDU 23,0,192,1: REM logical screen scaling back on
  176 VDU 23,1,1: REM show cursor
  180 END
  190 DEFFNray(X,Y,Z,U,V,W,I)
  200 E=X-I:F=Y-I:G=Z:REM vector from sphere centre to ray start
  210 P=U*E+V*F-W*G:REM dot product? Z seems to be flipped
  220 D=P*P-E*E-F*F-G*G+1
  230 IF D<=0 THEN =FNc(X,Y,Z,U,V,W):REM didn't hit anything; return colour
  240 T=-P-SQRD:IF T<=0 =FNc(X,Y,Z,U,V,W):REM still didn't hit anything; return colour
  250 X=X+T*U:Y=Y+T*V:Z=Z-T*W:REM new ray start position
  260 E=X-I:F=Y-I:G=Z:REM vector from sphere centre to new ray start
  270 P=2*(U*E+V*F-W*G):REM dot product shenanigans?
  280 U=U-P*E:V=V-P*F:W=W+P*G:REM new ray direction vector
  290 I=-I:REM we'd hit one sphere, so flip x and y coordinates to give other
  300 =FNray(X,Y,Z,U,V,W,I):REM return colour from new ray
  310 DEFFNc(X,Y,Z,U,V,W):REM generate pixel colour
  320 IF V>=0 =V:REM facing up at all? return ray Y component for simple sky gradient
  330 P=(Y+2)/V:REM use height for overall checkerboard scale and y component of vector for perspective
  340 =-V*((INT(X-U*P)+INT(Z-W*P)AND1)/2+.3)+.2:REM multiply simple gradient by checkerboard

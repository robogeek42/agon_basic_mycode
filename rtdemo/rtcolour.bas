   10 DATA 0,8,2,10, 12,4,14,6, 3,11,1,9, 15,7,13,5 : REM data pre-divided by 3
   20 DIM A%(16) : RESTORE 10 : FOR I=0 TO 14 : READ A%(I) : NEXT
   30 DIM CR%(8): DIM CG%(8) : DIM CB%(8) : PROCcolourTables
   40 REM ordered dither pattern stored in A() array above; 4x4 grid of thresholds
   50 MODE 0:REM set 640x480, 16 colour graphics mode
   55 PROCpalette
   60 VDU 23,1,0:REM hide flashing text cursor
   70 VDU 23,0,192,0:REM logical screen scaling off
   80 X=0:Y=-.1:Z=3:REM camera position
   90 FOR N=4 TO 474 STEP1:REM iterate over screen pixel rows
  100   FOR M=0 TO 639 STEP1:REM iterate over screen pixel columns
  110     U=(M-319.5)/320:REM x component of ray vector
  120     V=(N-239.5)/320:REM y component of ray vector
  130     W=1/SQR(U*U+V*V+1):REM z component of ray vector
  140     U=U*W:V=V*W:REM normalise x and y components
  150     I=SGNU/1.5:REM is ray facing left or right? I becomes x and y coordinates for sphere
  160     C=FNray(X,Y,Z,U,V,W,I):REM fire ray from X,Y,Z along U,V,W
  170     GCOL0, FNgetCol(C,M,N) : REM straight colour fucntion without gradient
  180     PLOT69,M,477-N:REM plot pixel (4x multiplier due to resolution-independent graphics coordinates - 1280x1024)
  190   NEXT
  200 NEXT
  210 VDU 23,0,192,1: REM logical screen scaling back on
  220 VDU 23,1,1: REM show cursor
  230 END
  240 :
  250 DEFFNray(X,Y,Z,U,V,W,I)
  260 E=X-I*1.5:F=Y-I:G=Z:REM vector from sphere centre to ray start
  270 P=U*E+V*F-W*G:REM dot product? Z seems to be flipped
  280 D=P*P-E*E-F*F-G*G+1
  290 IF D<=0 THEN =FNc2(X,Y,Z,U,V,W):REM didn't hit anything; return colour
  300 T=-P-SQRD:IF T<=0 =FNc2(X,Y,Z,U,V,W):REM still didn't hit anything; return colour
  310 X=X+T*U:Y=Y+T*V:Z=Z-T*W:REM new ray start position
  320 E=X-I:F=Y-I:G=Z:REM vector from sphere centre to new ray start
  330 P=2*(U*E+V*F-W*G):REM dot product shenanigans?
  340 U=U-P*E:V=V-P*F:W=W+P*G:REM new ray direction vector
  350 I=-I:REM we'd hit one sphere, so flip x and y coordinates to give other
  360 =FNray(X,Y,Z,U,V,W,I):REM return colour from new ray
  365 :
  370 REM colour s returned as a 16 bit value. 
  380 REM Top 8 bits are hue, Bottom 8 are shade. Shade was decimal, but we turn it into 
  385 REM an integer to make it possible to return a single value from this function
  400 DEF FNc2(X,Y,Z,U,V,W) 
  410 LOCAL C
  420 IF V>=0 = V*256 + 3*256 :REM sky : 3 = blue. 
  430 P=(Y+2)/V:REM use height for overall checkerboard scale and y component of vector for perspective
  440 K=INT(X-U*P)+INT(Z-W*P)AND1 : REM This bit of the calc returns 0 or 1 depending on checkerboard 
  450 C=-V*(K/2+.3)+.2:REM multiply simple gradient by checkerboard. 
  460 SC=SQRC
  470 IF K=0 THEN = SC*256 + 2*256 ELSE = SC*256 + 1*256 : REM 2 colour checkerboard
 475:
  480 REM function to return a real colour from the Hue/Shade
  500 DEF FNgetCol(C,X,Y)
  510 LOCAL S, H, DP
  520 S = C AND 255 : REM extract shader from lower 4 bits
  525 S=S/128 : REM Shade. Turn back into a decimal number
  530 H = INT(C / 256) : REM extract Hue as an exact number
  540 DP=A%(X MOD 4 + (Y MOD 4)*4) : REM DP is in range 0-15
  550 REM dithering. Apply 1 colour dither to whatever shader we calculate for this colour value
  560 IF H=1 THEN = CR%( (DP + 5*16*S) DIV 16 MOD 5) : REM return Red shades
  570 IF H=2 THEN = CG%( (DP + 5*16*S) DIV 16 MOD 5) : REM return Green shades
  580 IF H=3 THEN = CB%( (DP + 7*8*S) DIV 16 MOD 7) : REM return Blue shades
  590 = S : REM return Shade if I somehow messed-up
  600 :
  605 REM generate the 3 arrays of colour data
  610 DEF PROCcolourTables
  620 RESTORE 680
  630 FOR I=0 TO 4 : READ CR%(4-I) : NEXT
  640 RESTORE 690
  650 FOR I=0 TO 4 : READ CG%(4-I) : NEXT
  660 RESTORE 700
  670 FOR I=0 TO 6 : READ CB%(6-I) : NEXT
  680 REM DATA 0,25,1,9,52 : REM Red 4 shades and black
  685 DATA 0,1,2,3,4
  690 REM DATA 0,17,2,10,36: REM Green 4 shades and black
  695 DATA 0,5,6,7,8
  700 REM DATA 16,4,12,20,35,39,51: REM Blue->Cyan. 7 shades
  705 DATA 9,10,11,12,13,14,15
  710 ENDPROC

  790 :
  795 REM In a paletted colour mode, we can adjust the palette of colours to be any
  796 REM of the 64 possible colours in any order.
  800 DEF PROCpalette
  805 LOCAL R,G,B,L
  810 REM set palette for 16 colour mode
  820 DATA &55,0,0, &AA,0,0, &FF,0,0, &FF,&55,0
  822 DATA 0,&55,0, 0,&AA,0, 0,&FF,0, &55,&FF,&55
  824 DATA 0,0,&55, 0,0,&AA, 0,0,&FF, &00,&55,&FF, &55,&AA,&FF, &55,&FF,&FF, &AA,&FF,&FF
  830 FOR L=1 TO 15 
  840 READ R,G,B : COLOUR L,R,G,B
  844 REM Uncomment bwlow to show palette
  845 MOVE L*18,50 : GCOL 0,L : PLOT 101,L*18+16,90
  850 NEXT
  890 ENDPROC

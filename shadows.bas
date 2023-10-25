   10 REM Shadows
   11 REM https://github.com/breakintoprogram/agon-bbc-basic/blob/main/tests/shadows.bas
   20 REM Version B0.25
   30 REM Author: David Williams
   40 REM BEEBUG July 1988
   50 :
  100 MODE 8: ON ERROR GOTO 210
  110 REM VDU 23,1,0;0;0;0;
  120 VDU 29,640;512;
  130 REM VDU 19,2,4,0,0,0
  140 DIM d(11)
  150 PROCinitrotate(0,0,-20)
  160 PROCboard
  170 PROCscan(-50,100,50)
  180 REM *BPRINT
  190 END
  200 :
  210 IF ERR=17 END
  220 REPORT:PRINT " at line ";ERL
  230 END
  240 :
 1000 DEF FNBallLineIntersect(a,b,c,ra,p,q,r,s,t,u)
 1010 LOCAL d,e,f,A,B,C,f%
 1020 d=q-a:e=s-b:f=u-c
 1030 A=p*p+r*r+t*t: IF A=0 THEN =TRUE
 1040 B=2*(p*d+r*e+t*f)
 1050 C=(d*d+e*e+f*f)-(ra*ra)
 1060 =B*B-4*A*C>0
 1070 :
 1080 DEF PROCinitrotate(A,B,C)
 1090 LOCAL a,b,c
 1100 a=RAD(A):d(4)=COS(a):d(5)=SIN(a):d(6)=-d(5):d(7)=d(4)
 1110 b=RAD(B):d(8)=COS(b):d(9)=SIN(b):d(10)=-d(9):d(11)=d(8)
 1120 c=RAD(C):d(0)=COS(c):d(1)=SIN(c):d(2)=-d(1):d(3)=d(0)
 1130 ENDPROC
 1140 :
 1150 DEF PROCrotate
 1160 Rx=0:Ry=0:Rz=400
 1170 x=x-Rx:y=y-Ry:z=z-Rz
 1180 LOCAL xs,ys
 1190 xs=x
 1200 x=(xs*d(4))+(y*d(6)):y=(xs*d(5))+(y*d(7))
 1210 xs=x
 1220 x=(xs*d(8))+(z*d(10)):z=(xs*d(9))+(z*d(11))
 1230 ys=y
 1240 y=(ys*d(0))+(z*d(2)):z=(ys*d(1))+(z*d(3))
 1250 x=x+Rx:y=y+Ry:z=z+Rz
 1260 PROCperspective(800)
 1270 ENDPROC
 1280 :
 1290 DEF PROCperspective(F)
 1300 x=(F*x)/(F+z)
 1310 y=(F*y)/(F+z)
 1320 ENDPROC
 1330 :
 1340 DEF PROCmove(x,y,z)
 1350 PROCrotate:MOVE x,y
 1360 ENDPROC
 1370 :
 1380 DEF PROCdraw(x,y,z)
 1390 PROCrotate:DRAW x,y
 1400 ENDPROC
 1410 :
 1420 DEF PROCplot85(x,y,z)
 1430 PROCrotate:PLOT 85,x,y
 1440 ENDPROC
 1450 :
 1460 DEF PROCboard
 1470 LOCAL X%,Y%,C%
 1480 FOR X%=-400 TO 350 STEP 100
 1490   FOR Y%=-250 TO 400 STEP 100
 1500     IF C%=3 C%=1 ELSE C%=3
 1510     GCOL 0,C%
 1520     PROCmove(X%,-100,Y%):PROCmove(X%+100,-100,Y%):PROCplot85(X%,-100,Y%+100):PROCplot85(X%+100,-100,Y%+100)
 1530   NEXT:NEXT
 1540 PROCDefinePlane(-400,-100,-250,350,-100,-250,350,-100,400)
 1550 ENDPROC
 1560 :
 1570 DEF PROCDefinePlane(x1,y1,z1,x2,y2,z2,x3,y3,z3)
 1580 LOCAL a,b,c,d,e,f,g,h,i
 1590 x=x1:y=y1:z=z1:PROCrotate
 1600 x1=x:y1=y:z1=z
 1610 x=x2:y=y2:z=z2:PROCrotate
 1620 x2=x:y2=y:z2=z
 1630 x=x3:y=y3:z=z3:PROCrotate
 1640 x3=x:y3=y:z3=z
 1650 a=x2-x1:b=y2-y1:c=z2-z1
 1660 d=x3-x1:e=y3-y1:f=z3-z1
 1670 g=b*f-e*c:h=c*d-a*f:i=a*e-b*d
 1680 A=g:B=h:C=i:D=A*x2+B*y2+C*z2
 1690 ENDPROC
 1700 :
 1710 DEF PROCPlaneLineIntersect(A,B,C,D,p,r,t,q,s,u)
 1720 LOCAL k
 1730 k=(D-(A*q+B*s+C*u))/(A*p+B*r+C*t)
 1740 Vx=p*k+q:Vy=r*k+s:Vz=t*k+u
 1750 ENDPROC
 1760 :
 1770 DEF PROCscan(SLx,SLy,SLz)
 1780 LOCAL x%,y%,col%,test%,Vx,Vy,Vz
 1790 PROCcircle(0,0,100,200)
 1800 PROCcircle(-350,-100,100,100)
 1810 FOR x%=-400 TO 555 STEP 4
 1820   FOR y%=-50 TO -430 STEP -4
 1830     col%=POINT(x%,y%)
 1840     IF col%=0 OR col%=2 GOTO 1910
 1850     PROCPlaneLineIntersect(A,B,C,D,0,0,-800,x%,y%,0)
 1860     test%=FNBallLineIntersect(0,0,100,200,SLx,Vx,SLy,Vy,SLz,Vz)
 1870     IF test%=FALSE test%=FNBallLineIntersect(-350,-100,100,100,SLx,Vx,SLy,Vy,SLz,Vz)
 1880     IF test%=TRUE AND col%=1 col%=0
 1890     IF test%=TRUE AND col%=3 col%=2
 1900     GCOL 0,col%:PLOT 69,x%,y%
 1910   NEXT:NEXT
 1920 PROCsphere(0,0,100,200,SLx,SLy,SLz)
 1930 PROCsphere(-350,-100,100,100,SLx,SLy,SLz)
 1940 ENDPROC
 1950 :
 1960 DEF PROCcircle(x,y,z,ra)
 1970 LOCAL a
 1980 PROCmove(x,y,z):GCOL 0,2
 1990 FOR a=0 TO 2*PI+0.1 STEP 0.1
 2000   PROCmove(x,y,z):PROCplot85(x+ra*COS(a),y+ra*SIN(a),z)
 2010 NEXT a
 2020 ENDPROC
 2030 :
 2040 DEF PROCsphere(x,y,z,ra,Lx,Ly,Lz)
 2050 LOCAL a,b,da,db,I,s,c,sd,cd
 2060 da=0.4:db=0.3
 2070 I=0:PROCmove(x+ra*COS(I),y+ra*SIN(I),z)
 2080 FOR b=-0.5*PI TO 0.5*PI STEP db
 2090   s=SIN(b):c=COS(b):sd=SIN(b+db):cd=COS(b+db)
 2100   FOR I=0 TO 2*PI STEP da
 2110     sini=SIN(I):cosi=COS(I):sinida=SIN(I+da):cosida=COS(I+da)
 2120     PROCtriangle(x+(ra*c)*cosi,y+s*ra,z+(ra*c)*sini,x+(ra*cd)*cosi,y+sd*ra,z+(ra*cd)*sini,x+(ra*c)*cosida,y+s*ra,z+(ra*c)*sinida)
 2130     PROCtriangle(x+(ra*cd)*cosi,y+sd*ra,z+(ra*cd)*sini,x+(ra*cd)*cosida,y+sd*ra,z+(ra*cd)*sinida,x+(ra*c)*cosida,y+s*ra,z+(ra*c)*sinida)
 2140     PROCmove(x+(ra*c)*cosi,y+s*ra,z+(ra*c)*sini)
 2150     GCOL 0,3:PROCdraw(x+(ra*c)*cosida,y+s*ra,z+(ra*c)*sinida)
 2160   NEXT
 2170 NEXT
 2180 ENDPROC
 2190 :
 2200 DEF PROCtriangle(x1,y1,z1,x2,y2,z2,x3,y3,z3)
 2210 PROCillumination(x1,y1,z1,x2,y2,z2,x3,y3,z3,Lx,Ly,Lz)
 2220 PROCmove(x1,y1,z1)
 2230 PROCmove(x2,y2,z2)
 2240 PROCplot85(x3,y3,z3)
 2250 ENDPROC
 2260 :
 2270 DEF PROCillumination(x1,y1,z1,x2,y2,z2,x3,y3,z3,Lx,Ly,Lz)
 2280 LOCAL a,b,c,d,e,f,g,h,i,ans
 2290 a=x2-x1:b=y2-y1:c=z2-z1
 2300 d=x3-x1:e=y3-y1:f=z3-z1
 2310 g=b*f-e*c:h=c*d-a*f:i=a*e-b*d
 2320 temp1=(g*g+h*h+i*i):temp2=(Lx*Lx+Ly*Ly+Lz*Lz)
 2330 IF temp1*temp2=0 THEN ans=0 ELSE ans=(g*Lx+h*Ly+i*Lz)/SQR(temp1*temp2)
 2340 IF ans>0 GCOL 0,1 ELSE GCOL 0,2
 2350 ENDPROC

10 DIM copy 5, set 10
20 DIM Arr1 255, Arr2 255
40 REM set values in Array1
50 FOR I%=0 TO 255 : Arr1?I%=I% : NEXT

100 REM load and compile machine code to do copy
105 REM expects loop length in BC (B% msb,C% - lsb)
106 REM Dest address in DE (D%,E%) Source in HL (H%,L%)
110 FOR opt=0 TO 3 STEP 3
120 P%=copy
130 [        OPT opt
160          LDIR ; Load, Increment, Repeat
290          RET
300 ]
310 NEXT
400 FOR opt=0 TO 3 STEP 3
410 P%=set
420 [        OPT opt
430  .LOOP   
440          LD (DE),A
450          INC DE
455          DJNZ LOOP
460          DEC C
465          JP NZ, LOOP
475          RET
480 ]
490 NEXT

500 B%=1 : C%=0
505 REM Destination in DE
510 E%=Arr2 AND 255
520 D%=Arr2 DIV 256
525 REM Source in HL
530 L%=Arr1 AND 255
540 H%=Arr1 DIV 256
550 PRINT "Copy array1 to array2"
560 CALL copy
570 PRINT "Arr2:"
580 PROCprintArray(Arr2)
590 PRINT "Set array 2 to AA"
600 B%=0 : C%=1 : REM B is LSB this time, C is MSB
605 REM Destination in DE
610 E%=Arr2 AND 255
620 D%=Arr2 DIV 256
630 A% = &AA
640 CALL set
650 PRINT "Arr2"
660 PROCprintArray(Arr2)
1000 END

2000 DEF PROCprintArray(arr)
2010 FOR I%=0 TO 255 
2020 s$=RIGHT$("    "+STR$(arr?I%),3)
2030 PRINT s$;" ";
2040 IF I% MOD 8 = 7 THEN PRINT
2050 NEXT 
2060 ENDPROC

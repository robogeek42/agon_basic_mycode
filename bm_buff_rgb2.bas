10 REM bitmap test - try using the buffer api throughout
12 REM - found that buffer backed bitmaps require VDP 2.0 or greater
14 REM this version uses a different colour format - RGB2 instead of RGBA8
20 :
30 MODE 8
40 SW%=320 : SH%=200 : REM Screen size
50 BMWidth%=128 : BMHeight%=128 : REM bitmap size
60 BMX%=30 : BMY%=30 : REM bitmap postion
70 REM Create a simple bitmap
80 BMNum%=0 : REM Bitmap no.
90 BuffID% = BMNum% + &FA00
92 REM VDU 23, 27, 16 : REM Reset bitmaps
93 VDU 23, 0, &A0, BuffID%; 2 : REM clear buffer
95 VDU 23,0, &A0, BuffID%; 3, BMWidth%*BMHeight%; : REM create a buffer length 256 (=16*16) 
100 VDU 23, 27, &20, BuffID%;               : REM select bitmap using bufferID
110 VDU 23, 27, &21, BMWidth%; BMHeight%; 1 : REM create bitmap from buffer. Type 1 RGBA2222
120 REM colour = 8bits, 2bpp, &aabbggrr
130 VDU 23, 27, 0, BMNum%; : REM Select bitmap
140 PRINT "BMNum ";BMNum%;" BuffID ";BuffID%

300 REM Load bitmap with colour
320 FOR Y%=0 TO BMHeight%-1 
325 REM PRINT STR$(Y%);" ";
330 C%=&C0 OR ((Y%+1) MOD 255)

335 REM Set colours Byte by Byte
340 REM VDU 23, 0, &A0, BuffID%; 5, &C2, Y%*BMWidth%; BMWidth%;
350 REM FOR X%=0 TO BMWidth%-1 
360 REM VDU C% 
370 REM NEXT X%

372 REM Set colours line by line
375 VDU 23, 0, &A0, BuffID%; 5, &42, Y%*BMWidth%; BMWidth%; C%
380 NEXT Y%

400 REM draw bitmap
410 VDU 23, 27, 3, BMX%; BMY%; : REM draw bitmap
420 VDU 23, 27, 3, BMX%+20; BMY%+20; : REM draw bitmap

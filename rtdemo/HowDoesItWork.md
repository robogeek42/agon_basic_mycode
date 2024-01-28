# Ray Tracing Demo - *a breakdown by robogeekoid*

So a couple of weeks ago this gem appeared on the Agon Discord

`rtdemo.bbc`

A very respectable demonstration of a Ray Tracing scene from "back-in-the-day" when we could only dream of our modern world with realistic 3d real-time rendered full colour gorgeousness that we are so used to now.

This was a conversion to 37 lines of Agon BASIC of an original lost to time.

It looked like this:
![RTDemo screenshot](AgonRTDemo.png "RTDemo screenshot")

You can see a checkerboard floor receding into the horizon with a graduated sky overhead. Floating in mid air are two perfectly mirrored balls, impossibly reflecting the scene around them.  It uses **just 5 colours** but uses a dithering effect to give a sense of depth to the world.

## The CODE
Sure, I hear you say - this is BASIC, how hard can it be to understand?  Well, it turns out, it is not so easy.  There is no "define sphere" function, no vertices or plane equation describing the floor, and certainly not a line of OpenGL in sight.

But, fortunately for us, it is heavily commented. Here it is in it's full glory:

```
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
```

My intention in this article is to breakdown the code a little and explain what I think the various lines do.

Here goes!

## Part 1 Ray Tracing : *Who is this Ray chap anyway?*
First you need to know a little about what we are trying to achieve here.  This code is rendering a 3D scene using a technique called "Ray Tracing".

Ray tracing is essentially paining each pixel in a scene using rays of light bouncing off objects to give each pixel its colour.
Our eyes essentially work by taking in light (rays) from the surrounding world either directly from a light source or after they have hit one or many objects many many times. 

Ray tracing takes this idea but simplifies it by going backwards.  That is, it fires out imaginary rays from our eye *in the direction of a pixel*, until it hits an object and then saying that the pixel should have the colour of the object it hits. The ray is of course welcome to bounce off the object and take the colour of a different object it hits - that way you see a reflection.

That is essentially it.

So, the fundamental loop in this kind of Ray Tracing is

``` 
FOR EVERY PIXEL IN THE SCREEN
   FIRE A RAY FROM THE CAMERA TO THE PIXEL
   IF THE RAY HITS A REFLECTIVE OBJECT, FIRE A NEW RAY 
   IF THE RAY HITS THE "FLOOR" OR "SKY" COLOUR THE PIXEL APPROPRIATELY
NEXT PIXEL
```

The Code listed above does thin in lines 60-170.  I will break this down a little more as we go on. 

But first, lets talk about the setup and write some info about the lines in the code.

## Part 2 Setup : 

```
30 MODE 10:REM set 320x240, 4 colour graphics mode
40 VDU 23,1,0:REM hide flashing text cursor
45 VDU 23,0,192,0:REM logical screen scaling off
50 X=0:Y=-.1:Z=3:REM camera position
```

This should be fairly self explanatory, but I want to point our the following:
* MODE 10 is a 4 colour mode with a resolution of 320x240 pixels.
* The colours are 0=BLACK, 1=RED, 2=YELLOW, 3=WHITE. Very BBC like :D
* VDU Commands also come from BBC BASIC and are used to send commands to the display and sound processors - In this case, the ESP32 that is the video/sound coprocessor in the Agon machines.
* Logical screen scaling is also a BBC thing.  Sophie Wilson's lovely BBC BASIC made sure us programmers would never have to worry about how many pixels any given mode had, and instead let us draw to a 1280x1024 imaginary screen and let the BBC take care of the scrolling.  This code turns this off here though as itis going to be easier for us to draw pixel by pixel.
* You will not that the Camera Position variables have no suffix ("%" or "$") so in BBC BASIC they can be any kind of decimal number.  
* X being 0 means that the camera is positioned centrally horizontally. Y, our position in the vertical, is negative, which means we are looking slightly upwards.  Z represents depth in the scene, and is positive. This is just convention, and you will note in later parts of the code that Z appears reversed. This is why.

```
   60 FOR N=8 TO 238:REM iterate over screen pixel rows
   70   FOR M=0 TO 319:REM iterate over screen pixel columns
```

M,N give the X,Y pixel positions.

As mentioned there are 320x240 pixels in this mode.  Conventionally, 0,0 is at the top-left of the screen, and 320x240 is at the bottom right.

BUT, the programmer here has chosen to skip a few vertical pixels AND draw from bottom to top while counting up. This is why line subtracts this from 247
```
150     PLOT69,M,247-N:
```

You should also note that the BBC loops are not like C loops, they count *inclusively* - so M counts from 0 to 319 inclusively traversing 320 pixels.

## Part 3 Firing Ray. : *Sorry Ray.*

```
   80     U=(M-159.5)/160:REM x component of ray vector
   90     V=(N-127.5)/160:REM y component of ray vector
  100     W=1/SQR(U*U+V*V+1):REM z component of ray vector
  110     U=U*W:V=V*W:REM normalise x and y components
  120     I=SGNU:REM is ray facing left or right? I becomes x and y coordinates for sphere
  130     C=FNray(X,Y,Z,U,V,W,I):REM fire ray from X,Y,Z along U,V,W
```

Given my earlier ramblings, this should be fairly easy to follow :)

Remember, we are firing a Ray from the camera (situated more or less in the middle of the scene set 3 units back) towards each and every pixel in the scene we are about to render.

So lines 80 and 90 calculate the position of the pixel relative to the centre of the screen, and then turn that into a vector by dividing by the maximum distance to give a value from 0-1.
Note here that both X and Y are divided by the same 160, even though the screen is only 240 pixels high - shouldn't that be 120 for Y?  No, if we did that we would add a distortion, so choose 160 to keep everything "square".
Try it, change line 90 to "V=(N-127.5)/120". You get squashed balls ...

![RTDemo screenshot Squashed](AgonRTDemoSquashed.png "RTDemo screenshot Squashed")

So that gives us the X and Y directions to fire the ray (stated as U and V), but we are in 3D so we also need the Z direction or depth - W.  The next line 100 calculates that using pythagoras. 
It is inverted though as we will always be using this number in a division.

But note the stray 1?  If that wasn't there you'd get division by zero and things would likely catch fire.

But the programmer isn't finished.  He knows that things are a little off, because we used a shortcut to working out the vector direction of the ray, it is currently still the distance from the centre of the screen in 2D.  To correct this, all you need to do is divide by the calculated Z direction of the ray - i.e. W.  Luckily, it is already a reciprocal so we can simply multiply. Nice.

*Diagram needed here *

Next, we have this wonderful little line:
```
  120     I=SGNU:REM is ray facing left or right? I becomes x and y coordinates for sphere
```

The BASIC function SGN(var) will return -1 if "var" is negative, +1 if it is positive, and 0 otherwise.

But what does that mean for SGN(U)?  Well, U is the component of the ray direction in the X direction.  So it simply tells us if the pixel is in the left or right half of the screen.  This will be important in giving us the two balls later.

Finally Line 130 calls a function with all the calculated values describing the ray's origin (X,Y,Z) and it's direction vector (U,V,W), along with that magical little I.

## Part 4 : The RAY function : *It all happens here!*

```
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
```

Lets take this bit by bit.

```
  200 E=X-I:F=Y-I:G=Z:REM vector from sphere centre to ray start
```
Rember I is -1 or +1 depending on if we are on the left or right.  X and Y are the ray starting position (initially the camera position), so if we take or add 1 to X or Y we get a point in space to the left and below or to the right and above the camera.  This is where the spheres are placed.

```
  210 P=U*E+V*F-W*G:REM dot product? Z seems to be flipped
```
A dot-product of the ray direction vector and the sphere centre position. 
In vector maths the dot-product is a simple sum of the multiplication of components, but it has the effect of telling you the magnitude of one vector in the direction of another.
This gives the magintude of the ray pointed towards the sphere. But the Z direction is flipped, as the commentator notes. The reason is because Z reduces going into the screen, and you want the sphere to be ahead of you, not behind.

*Fun fact* : you can change the spheres size and distance from the camera here - but careful because it is easy to make the numbers too large for subsequent calculations.

```
  220 D=P*P-E*E-F*F-G*G+1
```
So, we have the magnitude of the amount of the ray pointed at a sphere, and a vector pointing to the sphere.  We xan use this to determine whether a ray hits a sphere or not.
That is what D will denote here.  


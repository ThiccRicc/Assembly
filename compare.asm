.orig x3000
ld r1, xaddr
ldr r1, r1, #0
ld r2, yaddr
ldr r2, r2, #0

not r2, r2
add r2, r2, #1
add r3, r1, r2

brp pos
brz zer
brn neg


pos
and r4, r4, #0
add r4, r4, #-1
ld r5, resaddr
str r4, r5, #0
halt

zer
and r4, r4, #0
ld r5, resaddr
str r4, r5, #0
halt

neg
and r4, r4, #0
add r4, r4, #1
ld r5, resaddr
str r4, r5, #0
halt

xaddr .fill x3100
yaddr .fill x3101

resaddr .fill x3102
.end
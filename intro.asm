.orig x3000
and R1, R1, x0
and R4, R4, x0
add R4, R4, #10
LEA R2, x0FC
LOOP LDR R3, R2, x0
add R2, R2, #1
add R1, R1, R3
add R4, R4, #-1
BRp LOOP
HALT
.end
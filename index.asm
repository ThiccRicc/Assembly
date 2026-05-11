.orig x3000

ld r1, numAddr
ldr r1, r1, #0

ld r2, init

loop
add r2, r2, #-1
add r1, r1, r1
brp loop
brn loop

ld r3, numAddr
str r2, r3, #1

halt

numAddr .fill x3100
init .fill #16

.end
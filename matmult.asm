.orig x3000

lea r4, c
and r5, r5, #0


str r5, r4, #0
str r5, r4, #1
str r5, r4, #2
str r5, r4, #3


start

lea r1, array
ld r2, offset
not r2, r2
add r2, r2, #1
ld r3, counter

lea r0, prompt
puts

setVals

getc
out

add r0, r0, r2
str r0, r1, #0
add r1, r1, #1

add r3, r3, #-1

brp setVals









lea r1, array
lea r2, placeHolderMat
;if alpha is zero
ldr r7, r1, #0
brz az


;dotProd1

and r7, r7, #0 ;total
ldr r5, r1, #1 ;first number to be mult
ldr r6, r1, #5 ;second
brz z1 ;if it's zero, skip

mult1
add r7, r7, r5
add r6, r6, #-1
brp mult1

z1

ldr r5, r1, #2 ;first number to be mult
ldr r6, r1, #7 ;second
brz z2 ;if it's zero, skip

mult2
add r7, r7, r5
add r6, r6, #-1
brp mult2

z2

str r7, r2, #0

;dotProd2

and r7, r7, #0
ldr r5, r1, #1 ;first number to be mult
ldr r6, r1, #6 ;second
brz z3 ;if it's zero, skip

mult3
add r7, r7, r5
add r6, r6, #-1
brp mult3

z3

ldr r5, r1, #2 ;first number to be mult
ldr r6, r1, #8 ;second
brz z4 ;if it's zero, skip

mult4
add r7, r7, r5
add r6, r6, #-1
brp mult4

z4

str r7, r2, #1








;dotProd3

and r7, r7, #0 
ldr r5, r1, #3 ;first number to be mult
ldr r6, r1, #5 ;second
brz z5 ;if it's zero, skip

mult5
add r7, r7, r5
add r6, r6, #-1
brp mult5

z5

ldr r5, r1, #4 ;first number to be mult
ldr r6, r1, #7 ;second
brz z6 ;if it's zero, skip

mult6
add r7, r7, r5
add r6, r6, #-1
brp mult6

z6

str r7, r2, #2

;dotProd4

and r7, r7, #0
ldr r5, r1, #3 ;first number to be mult
ldr r6, r1, #6 ;second
brz z7 ;if it's zero, skip

mult7
add r7, r7, r5
add r6, r6, #-1
brp mult7

z7

ldr r5, r1, #4 ;first number to be mult
ldr r6, r1, #8 ;second
brz z8 ;if it's zero, skip

mult8
add r7, r7, r5
add r6, r6, #-1
brp mult8

z8

str r7, r2, #3


;multiply alpha
lea r2, placeHolderMat
add r2, r2, #3 ;initialize matrix pointer to last element
and r0, r0, #0
add r0, r0, #3

loop1
ldr r5, r1, #0 ;alpha
and r6, r6, #0 ;sum
ldr r7, r2, #0 ;val of mat, starts with last
mult11
add r6, r6, r7
add r5, r5, #-1
brp mult11

str r6, r2, #0
add r2, r2, #-1 
add r0, r0, #-1
brzp loop1
brn skip1


az ;now set placeholder to zero matrix
lea r2, placeHolderMat
add r2, r2, #3
and r0, r0, #0
add r0, r0, #3

and r7, r7, #0
alphazero
str r7, r2, #0
add r2, r2, #-1
add r0, r0, #-1
brzp alphazero



skip1

;multiply beta
lea r4, c
add r4, r4, #3 ;initialize matrix pointer to last element
and r0, r0, #0
add r0, r0, #3

loop2
ldr r5, r1, #9 ;beta
brz bz
and r6, r6, #0 ;sum
ldr r7, r4, #0 ;val of mat, starts with last
mult12
add r6, r6, r7
add r5, r5, #-1
brp mult12

str r6, r4, #0
add r4, r4, #-1 
add r0, r0, #-1
brzp loop2
brn skip2

bz
lea r4, c
add r4, r4, #3
and r0, r0, #0
add r0, r0, #3

and r7, r7, #0
betazero
str r7, r4, #0
add r4, r4, #-1
add r0, r0, #-1
brzp betazero


skip2

;reset and add the two matricies to get C final
lea r2, placeHolderMat
add r2, r2, #3
lea r4, c
add r4, r4, #3

and r0, r0, #0
add r0, r0, #3

loop3
ldr r6, r2, #0 ;input
ldr r7, r4, #0 ;origanl
add r7, r7, r6
str r7, r4, #0
add r2, r2, #-1
add r4, r4, #-1
add r0, r0, #-1
brzp loop3





lea r4, c
and r6, r6, #0
add r6, r6, #2

ld r0, newLine
out

printC1
ldr r0, r4, #0
ld r7, offset
add r0, r0, r7
out

lea r0, space
puts

add r4, r4, #1
add r6, r6, #-1
brp printC1





ld r0, newLine
out
and r6, r6, #0
add r6, r6, #2

printC2
ldr r0, r4, #0
ld r7, offset
add r0, r0, r7
out

lea r0, space
puts

add r4, r4, #1
add r6, r6, #-1
brp printC2

ld r0, newLine
out

add r6, r6, #-1
brn start



prompt .stringz "Enter Values: "
space .stringz " "
newLine .fill x000A
array .blkw #10
offset .fill #0048
counter .fill #10
c .blkw #4
placeHolderMat .blkw #4

.end


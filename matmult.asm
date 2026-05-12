.orig x3000

; ============================================================
; Initialize matrix C to all zeros.
;
; C has four entries:
;   c[0] = C00
;   c[1] = C01
;   c[2] = C10
;   c[3] = C11
; ============================================================

lea r4, c              ; R4 points to start of C
and r5, r5, #0         ; R5 = 0

str r5, r4, #0         ; C00 = 0
str r5, r4, #1         ; C01 = 0
str r5, r4, #2         ; C10 = 0
str r5, r4, #3         ; C11 = 0

; ============================================================
; Main program loop.
; Each iteration reads a new alpha, A, B, and beta.
; Matrix C persists between iterations
; ============================================================

start

; Prepare to read 10 values into ARRAY.

lea r1, array          ; R1 points to ARRAY write location
ld r2, offset          ; R2 = 48 (ASCII value of '0')
not r2, r2             ; Begin computing -48
add r2, r2, #1         ; R2 = -48
ld r3, counter         ; R3 = 10 values to read

lea r0, prompt         ; R0 points to prompt string
puts                   ; Print "Enter Values: "

; ============================================================
; Read 10 characters from keyboard.
; For each character:
;   - GETC reads it into R0
;   - OUT echoes it
;   - subtract 48 to convert ASCII digit to numeric value
;   - store numeric value into ARRAY
; ============================================================

setVals

getc                   ; Read one character into R0
out                    ; Echo the character

add r0, r0, r2         ; Convert ASCII digit to integer (R0 - 48)
str r0, r1, #0         ; Store converted value into ARRAY
add r1, r1, #1         ; Move ARRAY pointer to next slot

add r3, r3, #-1        ; Decrement input counter

brp setVals            ; Continue until 10 values have been read

; ============================================================
; Set up pointers for matrix computation.
;
; ARRAY layout after input:
;   array[0] = alpha
;   array[1] = A00
;   array[2] = A01
;   array[3] = A10
;   array[4] = A11
;   array[5] = B00
;   array[6] = B01
;   array[7] = B10
;   array[8] = B11
;   array[9] = beta
;
; A is stored in ARRAY[1] through ARRAY[4]
; B is stored in ARRAY[5] through ARRAY[8]
; C is stored separately in c[0] through c[3]
; ============================================================

lea r1, array          ; R1 points to ARRAY
lea r2, placeHolderMat ; R2 points to temporary matrix storage

; If alpha is zero, skip A*B computation and directly zero placeholder.

;if alpha is zero
ldr r7, r1, #0         ; R7 = alpha
brz az                 ; If alpha == 0, branch to alpha-zero handling

; ============================================================
; dotProd1
;
; Computes first element of A*B:
;   placeHolderMat[0] = A00*B00 + A01*B10
;
; In ARRAY indices:
;   A00 = array[1]
;   A01 = array[2]
;   B00 = array[5]
;   B10 = array[7]
; ============================================================

;dotProd1

and r7, r7, #0         ; R7 = total = 0
ldr r5, r1, #1         ; R5 = A00
ldr r6, r1, #5         ; R6 = B00
brz z1                 ; If B00 is zero, skip multiplication

mult1
add r7, r7, r5         ; total += A00
add r6, r6, #-1        ; multiplier--
brp mult1              ; Repeat while multiplier > 0

z1

ldr r5, r1, #2         ; R5 = A01
ldr r6, r1, #7         ; R6 = B10
brz z2                 ; If B10 is zero, skip multiplication

mult2
add r7, r7, r5         ; total += A01
add r6, r6, #-1        ; multiplier--
brp mult2              ; Repeat while multiplier > 0

z2

str r7, r2, #0         ; Store dot product into placeHolderMat[0]

;dotProd2

and r7, r7, #0
ldr r5, r1, #1 
ldr r6, r1, #6
brz z3

mult3
add r7, r7, r5
add r6, r6, #-1
brp mult3

z3

ldr r5, r1, #2
ldr r6, r1, #8
brz z4

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
ldr r5, r1, #3
ldr r6, r1, #6
brz z7

mult7
add r7, r7, r5
add r6, r6, #-1
brp mult7

z7

ldr r5, r1, #4
ldr r6, r1, #8
brz z8

mult8
add r7, r7, r5
add r6, r6, #-1
brp mult8

z8

str r7, r2, #3

; ============================================================
; Multiply placeholder matrix by alpha.
;
; At this point:
;   placeHolderMat = A * B
;
; This loop computes:
;   placeHolderMat = alpha * placeHolderMat
;
; The loop starts at the last element and works backward.
; ============================================================

;multiply alpha
lea r2, placeHolderMat ; R2 points to placeholder matrix
add r2, r2, #3         ; R2 points to last element, placeHolderMat[3]
and r0, r0, #0         ; R0 = 0
add r0, r0, #3         ; R0 = loop counter starting at 3

loop1
ldr r5, r1, #0         ; R5 = alpha
and r6, r6, #0         ; R6 = sum = 0
ldr r7, r2, #0         ; R7 = current placeholder matrix value
mult11
add r6, r6, r7         ; sum += current placeholder value
add r5, r5, #-1        ; alpha counter--
brp mult11             ; Repeat while alpha counter > 0

str r6, r2, #0         ; Store alpha-scaled value back to placeholder
add r2, r2, #-1        ; Move to previous placeholder element
add r0, r0, #-1        ; Decrement loop counter
brzp loop1             ; Continue while counter >= 0
brn skip1              ; Finished alpha multiply, skip alpha-zero block

; ============================================================
; Alpha-zero case.
;
; If alpha == 0, then:
;   alpha * A * B = zero matrix
;
; So placeHolderMat is set to all zeros.
; ============================================================

az ;now set placeholder to zero matrix
lea r2, placeHolderMat ; R2 points to placeholder matrix
add r2, r2, #3         ; R2 points to last element
and r0, r0, #0         ; R0 = 0
add r0, r0, #3         ; R0 = loop counter starting at 3

and r7, r7, #0         ; R7 = 0
alphazero
str r7, r2, #0         ; Store zero into current placeholder element
add r2, r2, #-1        ; Move to previous element
add r0, r0, #-1        ; Decrement loop counter
brzp alphazero         ; Continue while counter >= 0

skip1

; ============================================================
; Multiply existing C matrix by beta.
;
; This computes:
;   C = beta * C
;
; The loop starts at the last element and works backward.
; ============================================================

;multiply beta
lea r4, c              ; R4 points to C
add r4, r4, #3         ; R4 points to last element, C[3]
and r0, r0, #0         ; R0 = 0
add r0, r0, #3         ; R0 = loop counter starting at 3

loop2
ldr r5, r1, #9         ; R5 = beta
brz bz                 ; If beta == 0, branch to beta-zero block
and r6, r6, #0         ; R6 = sum = 0
ldr r7, r4, #0         ; R7 = current C value
mult12
add r6, r6, r7         ; sum += current C value
add r5, r5, #-1        ; beta counter--
brp mult12             ; Repeat while beta counter > 0

str r6, r4, #0         ; Store beta-scaled C value
add r4, r4, #-1        ; Move to previous C element
add r0, r0, #-1        ; Decrement loop counter
brzp loop2             ; Continue while counter >= 0
brn skip2              ; Finished beta multiply, skip beta-zero block

; ============================================================
; Beta-zero case.
;
; If beta == 0, then:
;   beta * C = zero matrix
;
; So C is set to all zeros.
; ============================================================

bz
lea r4, c              ; R4 points to C
add r4, r4, #3         ; R4 points to last element
and r0, r0, #0         ; R0 = 0
add r0, r0, #3         ; R0 = loop counter starting at 3

and r7, r7, #0         ; R7 = 0
betazero
str r7, r4, #0         ; Store zero into current C element
add r4, r4, #-1        ; Move to previous element
add r0, r0, #-1        ; Decrement loop counter
brzp betazero          ; Continue while counter >= 0

skip2

; ============================================================
; Add alpha*A*B and beta*C.
;
; At this point:
;   placeHolderMat = alpha * A * B
;   C              = beta * C
;
; This loop computes:
;   C = placeHolderMat + C
; ============================================================

;reset and add the two matricies to get C final
lea r2, placeHolderMat ; R2 points to placeholder matrix
add r2, r2, #3         ; R2 points to last placeholder element
lea r4, c              ; R4 points to C
add r4, r4, #3         ; R4 points to last C element

and r0, r0, #0         ; R0 = 0
add r0, r0, #3         ; R0 = loop counter starting at 3

loop3
ldr r6, r2, #0         ; R6 = placeholder value
ldr r7, r4, #0         ; R7 = current C value
add r7, r7, r6         ; R7 = C value + placeholder value
str r7, r4, #0         ; Store final C value
add r2, r2, #-1        ; Move to previous placeholder element
add r4, r4, #-1        ; Move to previous C element
add r0, r0, #-1        ; Decrement loop counter
brzp loop3             ; Continue while counter >= 0

; ============================================================
; Print C as a 2x2 matrix.
;
; This output logic assumes every C value is a single digit.
; It prints each value by adding 48 and using OUT.
; ============================================================

lea r4, c              ; R4 points to C
and r6, r6, #0         ; R6 = 0
add r6, r6, #2         ; R6 = number of values in first row

ld r0, newLine         ; R0 = newline character
out                    ; Print newline

; ============================================================
; Print first row of C:
;   C00 C01
; ============================================================

printC1
ldr r0, r4, #0         ; Load current C value
ld r7, offset          ; R7 = 48
add r0, r0, r7         ; Convert numeric digit to ASCII character
out                    ; Print digit

lea r0, space          ; R0 points to space string
puts                   ; Print space

add r4, r4, #1         ; Move to next C element
add r6, r6, #-1        ; Decrement row counter
brp printC1            ; Continue until two values printed

ld r0, newLine         ; R0 = newline character
out                    ; Print newline
and r6, r6, #0         ; R6 = 0
add r6, r6, #2         ; R6 = number of values in second row

; ============================================================
; Print second row of C:
;   C10 C11
; ===========================================================

printC2
ldr r0, r4, #0         ; Load current C value
ld r7, offset          ; R7 = 48
add r0, r0, r7         ; Convert numeric digit to ASCII character
out                    ; Print digit

lea r0, space          ; R0 points to space string
puts                   ; Print space

add r4, r4, #1         ; Move to next C element
add r6, r6, #-1        ; Decrement row counter
brp printC2            ; Continue until two values printed

ld r0, newLine         ; R0 = newline character
out                    ; Print newline

; ============================================================
; Loop forever.
;
; After printC2, R6 is zero.
; This makes R6 negative, then BRn branches back to START.
; ============================================================

add r6, r6, #-1        ; R6 = -1
brn start              ; Since R6 is negative, branch back to START

; ============================================================
; Data section
; ============================================================

prompt .stringz "Enter Values: " ; Prompt shown before reading input
space .stringz " "               ; Space printed between matrix values
newLine .fill x000A              ; Newline character
array .blkw #10                  ; Stores alpha, A, B, and beta values
offset .fill #0048               ; ASCII offset for character conversion, 48
counter .fill #10                ; Number of input values to read
c .blkw #4                       ; Persistent 2x2 C matrix
placeHolderMat .blkw #4          ; Temporary matrix for alpha*A*B

.end

.orig x3000
ld R6, ASCII
ld R5, NEGASCII
trap x23
add R1, R0, x0
add R1, R1, R5
trap x23
add R0, R0, R5
add R2, R0, R1
add R2, R2, R6
lea R0, MESG
trap x22
add R0, R2, x0
trap x21
halt
ASCII .fill x30
NEGASCII .fill xFFD0
MESG .STRINGZ "The sum is "
.end
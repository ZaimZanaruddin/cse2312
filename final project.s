/******************************************************************************
 * @file p1_1001106858.s
 * @Pragram 1
 *
 * Simple Program using ARM assembly to find the sum, difference, product, and max of
 * two different positive integers.
 *
 * @author Syed Zaim Zanaruddin
 * @ID:1001106858
 * @CSE 2313
 * @Dr.Mcmurrough
 ******************************************************************************/



.global main
.func main

main:
    BL  _prompt             @ branch to prompt procedure with return
    BL _scanf
    VMOV S0, R0             @ move return value R0 to FPU register S0
    VCVT.F64.F32 S1, S0     @ covert the result to double precision for printing
    BL _getchar
    MOV R9,R0
    BL _getop
    MOV R1,R0
    BL _printf
    B main

_scanf:
    PUSH {LR}
    SUB SP,SP,#4
    LDR R0,=format_str
    MOV R1,SP
    BL scanf
    LDR R0,[SP]
    ADD SP,SP,#4
    POP {PC}

_getchar:
    MOV R7,#3
    MOV R0,#0
    MOV R2,#1
    LDR R1,=read_char
    SWI 0
    LDR R0, [R1]
    AND R0, #0xFF
    MOV PC,LR

_getop:
    PUSH {LR}
    CMP R9, #'a'
    BEQ _abs
    CMP R9,#'s'
    BEQ _squareroot
    CMP R9,#'p'
    BEQ _pow
    CMP R9,#'i'
    BEQ _inverse
    POP {PC}


_printf:
    PUSH {LR}
    LDR R0,=printf_str
    MOV R1,R1
    BL printf
    POP {LR}
    MOV PC,LR

_prompt:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #31             @ print string length
    LDR R1, =prompt_str     @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return

_abs:
    MOV R5,LR
    ADD R0,R8,R10
    MOV PC,LR

_squareroot:
    MOV R5,LR
    SUB R0,R8,R10
    MOV PC,R5

_pow:
    MOV R5,LR
    MUL R0,R8,R10
    MOV PC,R5

_inverse:
    MOV R5,LR
    CMP  R10,R8
    MOVLE R0,R8
    MOVGT R0,R10
    MOV PC,R5

.data
format_str:         .asciz       "%f"
prompt_str:         .asciz      "Type a number and press enter: "
printf_str:         .asciz       "%d\n"

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
    BL _getchar
    MOV R9,R0
    BL _getop
    VCVT.F64.F32 D4, S0     @ covert the result to double precision for printing
    VMOV R1, R2, D4         @ split the double VFP register into two ARM registers
    BL  _printf_result      @ branch to print procedure with return
    B _exit

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
    BLEQ _abs
    CMP R9, #'s'
    BLEQ _squareroot
    CMP R9, #'i'
    BLEQ _inverse
    CMP R9, #'p'
    BLEQ _pow
    POP {PC}


_printf_result:
    PUSH {LR}               @ push LR to stack
    LDR R0, =result_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ pop LR from stack and return


_prompt:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #31             @ print string length
    LDR R1, =prompt_str     @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return

_abs:
    PUSH {LR}
    VABS.F32 S0,S0
    POP {PC}

_squareroot:
    PUSH {LR}
    VSQRT.F32 S0,S0
    POP {PC}

_inverse:
    PUSH {LR}
    MOV R3, #1
    VMOV S1, R3
    VCVT.F32.U32 S1, S1     @ convert unsigned bit representation to single float
    VDIV.F32 S0, S1, S0
    POP {PC}

_pow:
    PUSH {LR}
    BL _prompt
    BL _scanf
    MOV R6, R0
    CMP R6, #1
    MOVEQ R0, #1
    POPEQ {PC}              @ restore stack pointer and return if equal

    PUSH {R1}
    VMUL.F32 S0, S0, S0
    SUB R6, R6, #1
    BL _pow
    POP {R1}
    POP {PC}



_exit:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall


.data
format_str:         .asciz       "%f"
prompt_str:         .asciz      "Type a number and press enter: "
read_char:          .asciz       " "
result_str:         .asciz       "%f\n"
exit_str:           .ascii      "Terminating program.\n"

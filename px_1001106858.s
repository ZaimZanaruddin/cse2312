/******************************************************************************
 * @file px_1001106858.s
 * @Final Exam Program
 *
 * Simple Program using ARM assembly to create a calculator that will take a float
 * value and find the absolute, inverse, square root and power of the float value
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
    BL _scanf               @ branch to scanf to get input value
    VMOV S0, R0             @ move return value R0 to FPU register S0
    BL _getchar             @ branch to getchar to get operation input
    MOV R9,R0               @ move return value R0 to argument register R1
    BL _getop               @ branch to getop procedure with return
    VCVT.F64.F32 D4, S0     @ covert the result to double precision for printing
    VMOV R1, R2, D4         @ split the double VFP register into two ARM registers
    BL  _printf_result      @ branch to print procedure with return
    B main

_scanf:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                @ return LR from stack and return

_scand:
    PUSH {LR}               @ push LR to stack
    SUB SP,SP,#4            @ make room on stack
    LDR R0,=integer_str     @ R0 contains address of integer string
    MOV R1,SP               @ move SP to R1 to store of format string
    BL scanf                @ call scanf
    LDR R0,[SP]             @ load value at SP into R0
    ADD SP,SP,#4            @ restore the stack pointer
    POP {PC}                @ pop LR from stack and return



_getchar:
    MOV R7, #3              @ write syscall, 3
    MOV R0, #0              @ input stream from monitor, 0
    MOV R2, #1              @ read a single character
    LDR R1, =read_char      @ store the character in data memory
    SWI 0                   @ execute the system call
    LDR R0, [R1]            @ move the character to the return register
    AND R0, #0xFF           @ mask out all but the lowest 8 bits
    MOV PC, LR              @ return

_getop:
    PUSH {LR}               @ push LR to stack
    CMP R9, #'a'            @ compare the char from getops to 'a'
    BLEQ _abs               @ Branch link to abs if equal with return
    CMP R9, #'s'            @ compare the char from getops to 's'
    BLEQ _squareroot        @ Branch link to squareroot if equal with return
    CMP R9, #'i'            @ compare the char from getops to 'i'
    BLEQ _inverse           @ Branch link to inverse if equal with return
    CMP R9, #'p'            @ compare the char from getops to 'p'
    BLEQ _pow               @ Branch link to pow if equal with return
    POP {PC}                @ pop LR from stack and return


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

_promptpow:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #27             @ print string length
    LDR R1, =promptpow_str  @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return




_abs:
    PUSH {LR}               @ push LR to stack
    VABS.F32 S0,S0          @ Compute absolute and update S0
    POP {PC}                @ pop LR from stack and return

_squareroot:
    PUSH {LR}               @ push LR to stack
    VSQRT.F32 S0,S0         @ Compute Square Root and update S0
    POP {PC}                @ pop LR from stack and return

_inverse:
    PUSH {LR}               @ push LR to stack
    MOV R3, #1              @ load the numerator with 1
    VMOV S1, R3             @ move the numerator to floating point register
    VCVT.F32.U32 S1, S1     @ convert unsigned bit representation to single float
    VDIV.F32 S0, S1, S0     @ compute division and update S0
    POP {PC}                @ pop LR from stack and return

_pow:
    PUSH {LR}               @ push LR to stack
    BL _promptpow           @ branch to promptpow with return
    BL _scand               @ branch to scand to get user integer
    MOV R6, R0              @ move return value R0 to argument register R6
    MOV R0, #1              @ set R0 to 1 for counter
    VMOV S1, S0             @ move S0 to S1


    powloop:
        CMP R0, R6          @ check to see of we are done iterating
        POPEQ {PC}          @ if equal pop LR from stack and return
        VMUL.F32 S0, S1, S0 @ Compute multiplcation
        ADD R0, R0, #1      @ add 1 to R0 in increment
        B powloop           @ branch to next loop iteration



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
integer_str:        .asciz       "%d"
prompt_str:         .asciz      "Type a number and press enter: "
promptpow_str:      .asciz      "Pow value and press enter: "
read_char:          .asciz       " "
result_str:         .asciz       "%f\n"
exit_str:           .ascii      "Terminating program.\n"

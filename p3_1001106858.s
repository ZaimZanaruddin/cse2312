/******************************************************************************
 * @file p3_1001106858
 * @author Syed Zaim Zanaruddin
 * CSE 2312
 * Program 3 
 * Professor McMurrough
 * 
 * Program creates an array of 10 random intgers and displays the max, min, and 
 * any value the user searches for.
 ******************************************************************************/

.global main
.func main

main:
    BL _seedrand            @ get time and seed random number generator
    MOV R0, #0              @ resets register

writeloop:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ writedone           @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    PUSH {R0}               @ backup iterator before procedure call
    PUSH {R2}               @ backup element address before procedure call
    BL _getrand             @ get a random number
    POP {R2}                @ restore element address
    STR R0, [R2]            @ write the address of a[i] to a[i]
    POP {R0}                @ restore iterator
    ADD R0, R0, #1          @ increment index
    B   writeloop           @ branch to next loop iteration
writedone:
    MOV R0, #0              @ initialze index variable

readloop:
    CMP R0, #10            @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration

readdone:
    MOV R0, #0              @ resets register
    MOV R1, #0              @ resets register
    MOV R2, #0              @ resets register
    LDR R1, =a              @ gets address of the array
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array and dereferences it
    MOV R12, R0             @ obtain min index
    MOV R11, R1             @ create min value
    MOV R10, R2             @ get min address
    MOV R9, R0              @ obtain max index
    MOV R8, R1              @ create max value
    MOV R7, R2              @ get max address
    B _maxMin               @ branches to func that will evaluate the max and min values


_maxMin:
    CMP R0, #10             @ checks to see if we have already looped through the whole array
    BEQ _printMinMax        @ If so, after finding max and min and jump to display
    LDR R3, =a              @ get address of a
    LSL R4, R0, #2          @ multiply index*4 to move to next array value
    ADD R4, R3, R4          @ R4 now has the element address of R3
    LDR R3, [R4]            @ read the array at address and dereference it to get the value of a
    CMP R11, R3
    MOVGT R12, R0           
    MOVGT R11, R3          
    CMP R8, R3
    MOVLT R9, R0            @ set the index of the max to register 9
    MOVLT R8, R3            @ set the value of the max to register 3 
    ADD R0, R0, #1          @ increment index
    B _maxMin               @ return back to max and min 

_printMinMax:
    MOV R1, R11             @Gets the min value and moves it into R1
    BL  _printf_min         @branch to print min value
    MOV R1, R8              @Gets the max value and moves it into R1
    BL  _printf_max         @branch to print max value
    B _search

_search:
    BL  _prompt             @ branch to prompt procedure with return
    BL  _scanf              @ branch to scan procedure with return
    MOV R6, #-1             @ index return value. Sets the print to -1
    MOV R5, R0              @ user input and value that we need to find
    MOV R0, #0              @ reset values
    MOV R1, #0              @ reset values
    MOV R2, #0              @ reset values

_searchLoop:
    CMP R0, #10             @index starts at 0 and when it reaches 9 we leave to print the indexes
    BEQ _printf_index
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get to next array 
    ADD R2, R1, R2      
    LDR R1, [R2]            @ dereferecing the array
    CMP R5, R1
    MOVEQ R6, R0
    BEQ _printf_index
    ADD R0, R0, #1          @ increment index
    B _searchLoop


_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return

_printf_min:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_min     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return

_printf_max:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_max     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return

_printf_index:
    MOV R1, R6              @move result index to R0
    LDR R0, =printf_index   @ R0 contains formatted string address
    BL printf               @ call printf
    B _search


_prompt:
    PUSH {R1}               @ backup register value
    PUSH {R2}               @ backup register value
    PUSH {R7}               @ backup register value
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #31             @ print string length
    LDR R1, =prompt_str     @ string at label prompt_str:
    SWI 0                   @ execute syscall
    POP {R7}                @ restore register value
    POP {R2}                @ restore register value
    POP {R1}                @ restore register value
    MOV PC, LR              @ return


_scanf:
    PUSH {LR}               @ store LR since scanf call overwrites
    PUSH {R1}               @ backup regsiter value
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {R1}
    POP {PC}                @ return
    

_seedrand:
    PUSH {LR}               @ backup return address
    MOV R0, #0              @ pass 0 as argument to time call
    BL time                 @ get system time
    MOV R1, R0              @ pass sytem time as argument to srand
    BL srand                @ seed the random number generator
    POP {PC}                @ return

_getrand:
    PUSH {LR}               @ backup return address
    BL rand                 @ get a random number
    MOV R1, R0              @ set value for mod evaulation
    MOV R2, #1000           @ set second value for mod evaluation
    BL _mod_unsigned        @ call modulus
    POP {PC}                @ return

_mod_unsigned:
    cmp R2, R1              @ check to see if R1 >= R2
    MOVHS R0, R1            @ swap R1 and R2 if R2 > R1
    MOVHS R1, R2            @ swap R1 and R2 if R2 > R1
    MOVHS R2, R0            @ swap R1 and R2 if R2 > R1
    MOV R0, #0              @ initialize return value
    B _modloopcheck         @ check to see if

_modloop:
    ADD R0, R0, #1          @ increment R0
    SUB R1, R1, R2          @ subtract R2 from R1

_modloopcheck:
    CMP R1, R2              @ check for loop termination
    BHS _modloop            @ continue loop if R1 >= R2
    MOV R0, R1              @ move remainder to R0
    MOV PC, LR              @ return


.data

.balign 4
a:              .skip       40
printf_str:     .asciz      "a[%d] = %d\n"
printf_min:     .asciz      "MINIMUM VALUE = %d\n"
printf_max:     .asciz      "MAXIMUM VALUE = %d\n"
printf_index:     .asciz    "%d\n"
number:         .word       0
format_str:     .asciz      "%d"
prompt_str:     .asciz      "ENTER SEARCH VALUE: "

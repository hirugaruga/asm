; Саар Т.В. (МП-202)
; Задача: шестнадцатеричное предствление числа.
.486
.model flat, stdcall
option casemap :none
include includes\masm32.inc
include includes\kernel32.inc
include includes\macros\macros.asm
includelib includes\masm32.lib
includelib includes\kernel32.lib
.data
	EOL 	EQU 00h
	del256	DD 	0100h
	del16   DD 	010h      
	temp1 	DD 	?       
	temp2 	DD 	?    
	;define signs
	sign1 	DB 	2 dup (EOL)
	sign2 	DB 	2 dup (EOL)

.code
start:
	mov EAX, uval(input("Input number [0..4*10^9]:")) 
	bswap EAX
	xor ECX,ECX
	mov ECX, 00000004h
	mov [temp1],EAX
metka1:
	mov EAX,[temp1]
	xor EDX,EDX
	div [del256]
	mov [temp1],EAX
	mov EAX,EDX

    xor EDX, EDX            
    div [del16]             
    cmp EDX, 9
    mov [temp2],EAX
    ja gt9      ; EDX > 9 -> gt9

    ; EDX % 16 <= 9
    mov AL, 48             
    add AL, DL
    mov [sign2], AL
    jmp end_if

gt9:
	mov AL, 55
    add AL, DL
    mov [sign2], AL
 
end_if:
	xor EDX, EDX
	mov EAX, [temp2]
    div [del16]
    cmp EDX, 9
	ja  gt9_1
    
    ;EDX % 16 <= 9
	mov AL, 48
	add AL, DL
    mov [sign1], AL
    jmp end_if1

gt9_1:
    mov AL, 55
    add AL, DL
    mov [sign1], AL
end_if1:
	pushad
	print offset sign1
	popad
	pushad
	print offset sign2
	popad
	loop metka1
	print "h"
	
end start
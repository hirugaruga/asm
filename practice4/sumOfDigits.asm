; Саар Т.В. (МП-202)
; Задача: Сумма цифр шестизначного числа числа
.486
.model flat, stdcall
option casemap :none
include includes\masm32.inc
include includes\kernel32.inc
include includes\macros\macros.asm
includelib includes\masm32.lib
includelib includes\kernel32.lib

.code
start:
	mov ESI,10 ;put to ESI int 10
	mov EAX,uval(input("input [100000..999999]: "))
	
	xor ECX,ECX ; reuslt
	xor EDX,EDX
	div ESI; 
	add ECX,EDX;
	xor EDX,EDX
	div ESI
	add ECX,EDX;
	xor EDX,EDX
	div ESI
	add ECX,EDX;
	xor EDX,EDX
	div ESI
	add ECX,EDX;
	xor EDX,EDX
	div ESI
	add ECX,EDX;
	xor EDX,EDX
	div ESI
	add ECX,EDX;
	pushad
	print str$(ECX),13,10	
	POPAD
end start
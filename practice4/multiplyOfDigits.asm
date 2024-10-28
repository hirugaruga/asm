; Саар Т.В. (МП-202)
; Произведение чисел шестизначного числа
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
	mov ESI,10 		;put to ESI int 10
	mov EAX,uval(input("input [100000..999999]: "))
	xor ECX,ECX 	;0
	xor EDX,EDX 	;0
	xor EBX,EBX
	div ESI 		; EAX = EAX // 10 EDX = EAX % 10
	mov EBX,EAX		; EBX = EAX // 10
	xor EAX,EAX 
	mov EAX,dword ptr 01h
	mul EDX 		;EAX = EAX * EDX; => EAX = result, EDX = 0
	;EDX = 0 ; ESI = 10 EBX = num // 10; EAX = result
	mov ECX,EAX
	xor EAX,EAX
	mov EAX,EBX
	;-2
	div ESI 
	mov EBX,EAX
	mov EAX,ECX
	mul EDX
	mov ECX,EAX
	xor EAX,EAX
	mov EAX,EBX
	;-3
	div ESI 
	mov EBX,EAX
	mov EAX,ECX
	mul EDX
	mov ECX,EAX
	xor EAX,EAX
	mov EAX,EBX
	;-4
	div ESI 
	mov EBX,EAX
	mov EAX,ECX
	mul EDX
	mov ECX,EAX
	xor EAX,EAX
	mov EAX,EBX
	;-5
	div ESI 
	mov EBX,EAX
	mov EAX,ECX
	mul EDX
	mov ECX,EAX
	xor EAX,EAX
	mov EAX,EBX
	;-6
	div ESI 
	mov EBX,EAX
	mov EAX,ECX
	mul EDX
	mov ECX,EAX
	xor EAX,EAX
	mov EAX,EBX
	pushad
	print str$(ECX)
	popad
end start
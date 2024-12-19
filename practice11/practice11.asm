; Саар Т.В. (МП-202)

; practice 11

.686
.model flat, stdcall
option casemap :none
include includes\masm32.inc
include includes\kernel32.inc
include includes\fpu.inc
include includes\macros\macros.asm
includelib includes\masm32.lib
includelib includes\kernel32.lib
includelib includes\fpu.lib
.data

x0 		real10 	1.85217
forma 	EQU 	3*256+8
bufstr 	DB 		80 dup (0)

.code

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
f0 		PROTO 	C xf0:REAL10
f1 		PROTO 	C xf2:REAL10
fun1 	PROTO 	C xf1:REAL10, fn0:DWORD ; stack

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

f0 PROC C xf0 :real10					; пример базовой функции (процедуры ) результат в st(0) = значение квадрата аргумента (x2)
	fld [xf0]
	fld1 
	fadd
	fmul st,st
	ret
f0 ENDP

f1 PROC C xf2 :real10
	fldpi
	fld [xf2]
	fsub
	ret
f1 ENDP


fun1  PROC  C  xf1:REAL10, fn0 :DWORD 	; пример функции высшего порядка от базовой функции
	push word ptr [xf1+8] 				;результат = значение функции-аргумента (колбэка) умноженное на x
	push dword ptr [xf1+ 4] 			; передаем через стек старшую половину числа
	push dword ptr [xf1] 				; передаем через стек старшую половину числа
										; передаем через стек младшую половину числа
	call [fn0]                        	; косвенный вызов подпрограммы (базовой функции)
	fld1
	fadd
	fsqrt
	fld [xf1]
	fadd									
	add ESP,10                     		; выполняем очистку стека после fn0 (т.к. cdecl)
ret                                 	; результат возвращается по стандарту в st(0)

fun1  ENDP

start:

	finit
	fld [x0]
	fldz 
	fcomip st, st(1)
	jbe metka1
	INVOKE fun1, x0, addr f1
	jmp metka2

metka1:
	INVOKE fun1, x0, addr f0

metka2:
	invoke FpuFLtoA, 0, forma, ADDR bufstr, SRC1_FPU OR SRC2_DIMM OR STR_REG
	print ADDR bufstr,13,10
exit

end start
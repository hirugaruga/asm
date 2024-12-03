; Саар Т.В. (МП-202)
; Сопроцессорные вычисления
.586
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
	x1 REAL4 12.0;.98463
	x2 REAL4 21.0;.74525
	x3 REAL4 3.0;.510480
	
	result REAL10 ?
	forma EQU 3*256+6
	bufstr DB 80 dup (0)
.code
start:
	finit
	fld [x1]
	fld [x2]
	fld st(1)
	fld st(1)
	FYL2X
	fld st(1)
	fsub st, st(3)
	fdivp st(1), st
	fld [x3]
	fadd st, st(3)
	fld st
	fmul
	fld st(2)
	fsub st, st(4)
	FSQRT
	FLDPI
	FMUL
	fdivp st(1), st
	fadd

	fstp [result]
	invoke FpuFLtoA, ADDR result, forma, ADDR bufstr, SRC1_REAL OR SRC2_DIMM OR STR_REG
	print ADDR bufstr,13,10
	exit 
end start
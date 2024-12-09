; Саар Т.В. (МП-202)
; Написать программу на ассемблере MASM-32 для вычисления формулы в сопроцессоре при заранее заданных значениях чисел.
; (2^x3)/x3+arctg( (x1-x3*pi)/(x2-x1) )
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
        x1 REAL4 12.98463
        x2 REAL4 21.74525
        x3 REAL4 3.510480
        temp REAL4 0.22
        mem DW ?
        result REAL10 ?
        forma EQU 3*256+6
        bufstr DB 80 dup (0)
.code
start:
        finit
        fld1
        fld [x3]
        fld st
		fstcw [mem]
		OR [mem],0C00h
		fldcw [mem]
		frndint
		and [mem],0F3FFh
		fldcw [mem]
		fsub st(1), st
		fld1
		fscale
		fld st(2)
		f2xm1
		faddp st(4),st
		fmulp st(3),st
		fadd
		fld st
		fdivp st(2), st
		fldpi
		fmul
		fld[x2]
		fld[x1]
		fsub st(2), st
		fsubp st(1), st
		fdivp st(1), st
		fabs
		fld1
		fpatan
		fadd
		fstp[result]
		
        invoke FpuFLtoA, ADDR result, forma, ADDR bufstr, SRC1_REAL OR SRC2_DIMM OR STR_REG
        
        print ADDR bufstr,13,10
        exit 
end start

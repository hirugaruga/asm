; Саар Т.В. (МП-202)
;Final task
.686
.model flat, stdcall
option casemap :none
include includes\windows.inc
include includes\masm32.inc
include includes\kernel32.inc
include includes\fpu.inc
include includes\msvcrt.inc
include includes\macros\macros.asm
includelib includes\masm32.lib
includelib includes\kernel32.lib
includelib includes\fpu.lib
includelib includes\lib\msvcrt.lib

.data
	EOL 	EQU 		00h
	vector  REAL10		3  			dup (?)		
	temp 	DB			80 			dup (EOL)
	temp1 	DB			80 			dup (EOL)
	temp2 	DB			80 			dup (EOL)
	answer  DD			?
	forma  	EQU 		3*256+6       				; 3-кол-во места для знаков слева от запятой, 6-кол-во знаков после запятой
	bufstr  DB 			80 			dup (EOL)     	; буфер (строка) для символьного представления выводимого числа
	x1 		REAL10 		?
.code
convert1 proc
	mov EAX,[ESP+4]
	fld real10 ptr [EAX+20] ;load z 
	fld real10 ptr [EAX] 	;load x
	fld real10 ptr [EAX+10] ;load y
	fld st(0) 				;load Y
	fld st(2)
	fpatan
	fstp real10 ptr [eax+20]
	fld st(0)
	fmul
	fld st(1)
	fmulp st(2),st(0)
	fadd
	fld st(0)
	fsqrt
	fdiv st(0),st(2)
	fld1
	fpatan
	fstp real10 ptr [eax+10]
	fld st(1)
	fmulp st(2), st(0)
	fadd
	fstp real10 ptr [eax]
	ret
convert1 endp

convert2 proc
	mov EAX,[ESP+4]
	fld real10 ptr [EAX]
	fld real10 ptr [EAX+10]
	fld st(1)
	fld st(2)
	fpatan
	fstp real10 ptr [EAX+10]
	fld st(0)
	fmul
	fld st(1)
	fmulp st(2),st(0)
	fadd
	fsqrt
	fstp real10 ptr [eax]

	ret
convert2 endp

start:
	finit
	mov [answer],uval(input("Enter 1 for DEKART to SPHERE || 2 for POLAR to SPHERE:",13,10))
;###################start of input data################
	mov ESI,input("Input float number x or p:",13,10)
	lea EDI,temp
input_split:
    lodsb           			;copy byte from SI:DI to AL, after that DF == 0 ? SI++ : SI--; 
    cmp AL,EOL					
    je gg						
    stosb						;saving AL in DI after that DI++
    jmp input_split
gg:
	invoke FpuAtoFL, ADDR temp, 0, DEST_FPU
	fstp [vector[0]]
;######################################################	
	mov ESI,input("Input float number y or z:",13,10)
	lea EDI,temp1
input_split1:
    lodsb
    cmp AL,EOL					
    je gg1						
    stosb
    jmp input_split1
gg1:
	invoke FpuAtoFL, ADDR temp1, 0, DEST_FPU
	fstp [vector[10]]	
;#######################################################	
	mov ESI,input("Input float number z or angle:",13,10)
	lea EDI,temp2
input_split2:
    lodsb           			;copy byte from SI:DI to AL, after that DF == 0 ? SI++ : SI--; 
    cmp AL,EOL					
    je gg2						
    stosb						;saving AL in DI after that DI++
    jmp input_split2
gg2:
	invoke FpuAtoFL, ADDR temp2, 0, DEST_FPU
	fstp [vector[20]]	
;###############end of input data#######################
	
	cmp [answer],1
	je dekart
	jmp sphere
	
dekart:	
	lea ESI,vector
	push ESI
	call convert1
	add esp,4
	jmp end_of_programm
sphere:
	lea ESI,vector
	push ESI
	call convert2
	add esp,4
	
end_of_programm:
	invoke FpuFLtoA, ADDR vector[0], forma, ADDR bufstr, SRC1_REAL OR SRC2_DIMM OR STR_REG
	print ADDR bufstr,13,10
	invoke FpuFLtoA, ADDR vector[10], forma, ADDR bufstr, SRC1_REAL OR SRC2_DIMM OR STR_REG
	print ADDR bufstr,13,10
	invoke FpuFLtoA, ADDR vector[20], forma, ADDR bufstr, SRC1_REAL OR SRC2_DIMM OR STR_REG
	print ADDR bufstr,13,10
end start
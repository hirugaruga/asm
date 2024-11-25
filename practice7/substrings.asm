; Саар Т.В. (МП-202)
; Задача: Разбиение строки на подстроки, нахождение самой длинной подстроки

.486
.model flat, stdcall
option casemap :none
include includes\masm32.inc
include includes\kernel32.inc
include includes\macros\macros.asm
includelib includes\masm32.lib
includelib includes\kernel32.lib
.data
	EOL 			EQU 	00h
    dvs_comma 		DB 		','
    dvs_dot			DB 		'.'
    temp_string		DB		256 	DUP (EOL)
.code
start:
    mov ESI,input("Input string with separating signs {,} and {.} and max lenght 256 symbols:",13,10)
    lea EDI,temp_string	;pointer to current subsring, replace of stack, cause i am swiming in theme /25.11.2025 11.13 upd.
    xor ECX,ECX 		;counter substrings
    xor EBX,EBX			;max length of substinrg
    xor EDX,EDX			;current length of substring

input_split:
    lodsb           	;copy byte from SI:DI to AL, after that DF == 0 ? SI++ : SI--; 
    cmp AL,EOL			;/fun fact compeiring works on subtructing
    je last_substring	;ZF flag 
    cmp AL,dvs_comma
    je substring
    cmp AL,dvs_dot
    je substring

    stosb				;saving AL in DI after that DI++
    inc EDX
    jmp input_split

substring:
	mov AL,EOL
    stosb                   
    inc ECX
    cmp EDX,EBX			;current > max
    jbe go_to			;false
    mov EBX,EDX
    
go_to:
	pushad
    print offset temp_string,13,10
    popad
    lea EDI,temp_string	;reset pointer
    xor EDX,EDX
    jmp input_split

last_substring:
    cmp EDX,EOL			;end? 
    je output			;yes
    mov AL,EOL
    stosb
    inc ECX
    cmp EDX,EBX
    jbe output
    mov EBX,EDX

output:
	pushad
    print offset temp_string,13,10
    popad
	
	pushad
	print "Substrings: "
	popad
	
	pushad
    print str$(ECX),13,10
    popad
    
    pushad
    print "Max length: "
    popad
    
    pushad
    print str$(EBX),13,10
    popad

end start
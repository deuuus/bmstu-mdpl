.model TINY

SG SEGMENT
	ORG 100h
	
MAIN:
	JMP INSTALL
	IS_INSTALL DW 1
	UNINSTALL_MSG DB "Program uninstalled. $", 13, 10
	OLD_9H DD ?
	
MY_9H PROC
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH ES
	PUSH DS
	PUSHF
	
	CALL CS:OLD_9H
	
INSTALL:
	MOV AX, 3509h ;AH 35 - возвращает в ES:BX адрес обработчика, AL 09 - прерывание с клавиатуры. Считывание адреса обработчика.
	INT 21h
	
	CMP ES:IS_INSTALL, 1
	JE UNINSTALL
	
	MOV WORD PTR OLD_9H, BX
	MOV WORD PTR OLD_9H + 2, ES
	
	MOV AX, 2509h
	MOV DX, OFFSET MY_9H
	INT 21H
	
	MOV AH, 09h
	MOV DX, OFFSET INSTALL_MSG
	INT 21h
	
	MOV DX, OFFSET INSTALL
	INT 27h
	
UNINSTALL:
	PUSH ES
	PUSH DS
	
	MOV DX, WORD PTR ES:OLD_9H
	MOV DS, WORD PTR ES:OLD_9H + 2
	MOV AX, 2509h ;Установить вектор прерывания
	INT 21h
	
	POP DS
	POP ES

	MOV AH, 49H
	int 21h
	
	MOV DX, OFFSET UNINSTALL_MSG
	MOV AX, 09h
	INT 21h

	MOV AX, 4C00h
	INT 21h
	
SG ENDS
END MAIN
PUBLIC READ_ACTION
PUBLIC READ_SB_NUM

PUBLIC NUMBER

DSEG SEGMENT PARA PUBLIC 'DATA'
	NUMBER DW 0
	INPUT_MSG DB 13, 10, 13, 10, "Enter signed 16-digit number in binary notation: $"
	RES_MSG DB 13, 10, "Number entered. $"
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	ASSUME DS:DSEG, CS:CSEG
	
READ_ACTION PROC NEAR
	MOV AH, 01h
	INT 21h
	SUB AL, '0'
	SUB AL, 1 ;Корректировка индексации
	MOV CL, 2 
	MUL CL ;Умножаем индекс на 2, т.к. каждая команда занимает в памяти 2 байта
	MOV SI, AX
	RET
READ_ACTION ENDP

READ_SB_NUM PROC NEAR

	MOV AH, 09H 
	MOV DX, OFFSET INPUT_MSG
	INT 21H
	
	XOR DX, DX
	XOR DI, DI
	MOV AH, 01H
	MOV BX, 16
	
	READ_DIGIT:
		INT 21H
		
		CMP AL, '-'
		JNE PROC_DIGIT
		MOV DI, 1 ;Признак того, что введено отрицательное число
		JMP READ_DIGIT
		
		PROC_DIGIT:
		
		CMP AL, 13 ;Признак того, что нажата клавиша ENTER
		JE END_READ
		
		SUB AL, '0'
		SAL DX, 1
		ADD DL, AL
		
		DEC BX
		JNZ READ_DIGIT
	
	END_READ:
		XOR AX, AX
		MOV AH, 09h
		MOV DX, OFFSET RES_MSG
		INT 21h
		RET
		
READ_SB_NUM ENDP

CSEG ENDS
END
	
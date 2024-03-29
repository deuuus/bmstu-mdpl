PUBLIC CONVERT_TO_UD
PUBLIC CONVERT_TO_SH

EXTRN NUMBER : WORD
PUBLIC BUFFER
PUBLIC MASK_SIGN

DSEG SEGMENT PARA PUBLIC 'DATA'
	MASK2 DW 1
	MASK16 DW 15
	MASK_SIGN DW 32768
	BUFFER DB 20 DUP('$')
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	ASSUME DS:DSEG, CS:CSEG
	
CONVERT_TO_SH PROC NEAR

	MOV DI, 4 ;Счетчик цикла
	XOR SI, SI ;Индексация буффера
	MOV BX, NUMBER
	
	MOV AX, NUMBER ;Определение знака двоичного числа
	AND AX, MASK_SIGN
	CMP AX, MASK_SIGN
	JNE CONVERT
	
	NEG BX
	
	CONVERT:
		MOV DX, BX
		AND DX, MASK16
		
		CMP DL, 10
		JB IS_DIGIT
		
		ADD DL, 7
		
		IS_DIGIT:
		ADD DL, '0'
		MOV BUFFER[SI], DL
		MOV CL, 4 ;Перевод осуществляется по тетрадам - 4 бита
		SHR BX, CL
		INC SI
		DEC DI
		JNZ CONVERT
	
	MOV CX, AX
	
	RET 

CONVERT_TO_SH ENDP

CONVERT_TO_UD PROC NEAR
	MOV AX, 1 ;Счетчик степени
	MOV DI, 16 ;Счетчик цикла
	XOR BX, BX ;Переведенное число
	MOV CX, NUMBER
	
	CONVERT:
		MOV DX, CX
		AND DX, MASK2
		
		CMP DX, 0
		JE INDEX

		ADD BX, AX
		
		INDEX:
		
		SHL AX, 1
		SHR CX, 1
		DEC DI
		JNZ CONVERT
		
	MOV AX, BX
	MOV CX, 10 ;Делитель для получения последней цифры
	XOR SI, SI
	
	DIGIT_TO_SYMB:
		XOR DX, DX
		DIV CX
		XCHG AX, DX ;Получаем остаток от деления на 10 в AX
		ADD AL, '0'
		MOV BUFFER[SI], AL
		INC SI
		XCHG AX, DX ;Меняем обратно частное и остаток
		OR AX, AX
		JNE DIGIT_TO_SYMB
		
	RET

CONVERT_TO_UD ENDP
CSEG ENDS
END
;Описание сегмента стека.
SSEG SEGMENT PARA STACK 'STACK'
	DB 100 DUP (0)
SSEG ENDS

;Описание сегмента данных
DSEG SEGMENT PARA 'DATA'
	ROW_MSG DB 'ENTER NUM OF ROWS: $'
	COL_MSG DB 'ENTER NUM OF COLS: $'
	MTRX_MSG DB 'ENTER MATRIX ELEMS: $'
	RES_MSG DB 'RESULT: $'
	ROWS DB 0
	COLS DB 0
	DECR DW 0 ;переменная для корректировки индексирования матрицы
	MAX_NUM_OF_ODD DW 0 ;максимальное количество нечетных элементов в строке
	ROW_TO_DEL DW 0 ;номер строки с максимальным количеством нечетных элементов
	MATRIX DB 9 * 9 DUP (0)
DSEG ENDS

;Описание сегмента кода
CSEG SEGMENT PARA 'CODE'
	ASSUME CS:CSEG, DS:DSEG, SS:SSEG
	
;Ввод символа с эхом
INPUT_SYMB:
	MOV AH, 1h
	INT 21h
	RET
	
;Печать символа на экран
OUTPUT_SYMB:
	MOV AH, 2h
	INT 21h
	RET
	
;Перевод строки
CRLF:
	MOV AH, 2h
	MOV DL, 13
	INT 21h
	MOV DL, 10
	INT 21h
	RET
	
;Печать пробела
PRINT_SPACE:
	MOV AH, 2h
	MOV DL, ' '
	INT 21h
	RET
	
;Основная функция, реализующая удаление из матрицы строки, содержащей максимальное количество нечетных элементов
MAIN:
	;Инициализация сегментного регистра
	MOV AX, DSEG
	MOV DS, AX
	
	;Приглашение ввода
	MOV AH, 9h
	MOV DX, OFFSET ROW_MSG
	INT 21H
	CALL CRLF
	
	;Ввод количества строк
	CALL INPUT_SYMB
	MOV ROWS, AL
	SUB ROWS, '0'
	CALL CRLF
	
	;Приглашение ввода
	MOV AH, 9h
	MOV DX, OFFSET COL_MSG
	INT 21H
	CALL CRLF
	
	;Ввод количества столбцов
	CALL INPUT_SYMB
	MOV COLS, AL
	SUB COLS, '0'
	CALL CRLF
	
	;Приглашение ввода
	MOV AH, 9h
	MOV DX, OFFSET MTRX_MSG
	INT 21H
	CALL CRLF

	;Построчный ввод матрицы
	MOV BX, 0
	MOV CL, ROWS ;Установка регистра-счетчика
	INPUT_MTRX:
		MOV CL, COLS ;Переустановка регистра-счетчика
		INPUT_ROW:
			CALL INPUT_SYMB
			MOV MATRIX[BX], AL ;Ввод очередного элемента
			SUB MATRIX[BX], '0'
			INC BX ;Увеличение индекса
			CALL PRINT_SPACE
			LOOP INPUT_ROW
		CALL CRLF
		MOV CL, ROWS
		MOV SI, DECR 
		SUB CX, SI ;Обновление регистра-счетчика
		INC DECR ;Очередная строка прочитана
		LOOP INPUT_MTRX
	
	MOV DECR, 0 
	MOV BX, 0
	MOV CL, ROWS ;Установка регистра-счетчика
	FIND_ROW: ;Нахождение номера строки с указанным свойством
		MOV DI, 0
		MOV CL, COLS ;Переустановка регистра-счетчика
		CHECK_ROW:
			TEST MATRIX[BX], 1 ;Проверка цифры на нечетность
			JP EVN
			INC DI
			EVN:
			INC BX
			LOOP CHECK_ROW
		CMP DI, MAX_NUM_OF_ODD ;Определение максимального количества нечетных элементов в строке
		JNAE NOT_AE
		MOV MAX_NUM_OF_ODD, DI
		MOV DI, DECR
		MOV ROW_TO_DEL, DI ;Сохранение номера нужной строки
		NOT_AE:
		MOV CL, ROWS
		MOV SI, DECR
		SUB CX, SI ;Обновление регистра-счетчика
		INC DECR ;Очередная строка проанализирована
		LOOP FIND_ROW
		
	MOV BL, COLS
	MOV AX, 1
	MUL BX
	MUL ROW_TO_DEL
	MOV BX, AX ;Установка регистра базы на начало удаляемой строки
	
	MOV DI, ROW_TO_DEL
	MOV DECR, DI ;Инициализация вспомогательной переменной, используемой для индексации
	
	MOV CL, ROWS
	SUB CX, ROW_TO_DEL ;Установка регистра-счетчика
	
	DEL: ;Удаление строки с указанным свойством
		MOV CL, COLS
		SHIFT_ROW:
			ADD BL, COLS
			MOV AH, MATRIX[BX]
			SUB BL, COLS
			MOV MATRIX[BX], AH ;Реализация сдвига строки на одну позицию влево
			INC BX
			LOOP SHIFT_ROW
		MOV CL, ROWS
		MOV SI, DECR
		SUB CX, SI ;Обновление регистра-счетчика
		INC DECR ;Очередная строка проанализирована
		LOOP DEL
		
	SUB ROWS, 1 ;Строка удалена
	
	;Вывод результата
	MOV AH, 9h
	MOV DX, OFFSET RES_MSG
	INT 21H
	CALL CRLF
	
	MOV DECR, 0
	MOV BX, 0
	MOV CL, ROWS
	OUTPUT_MTRX: ;Печать матрицы
		MOV CL, COLS
		OUTPUT_ROW:
			MOV DL, MATRIX[BX]
			ADD DL, '0'
			CALL OUTPUT_SYMB
			INC BX
			CALL PRINT_SPACE
			LOOP OUTPUT_ROW
		CALL CRLF
		MOV CL, ROWS
		MOV SI, DECR
		SUB CX, SI
		INC DECR
		LOOP OUTPUT_MTRX
		
	MOV AX, 4C00h ;Завершение работы программы
	INT 21h

CSEG ENDS
END MAIN
	
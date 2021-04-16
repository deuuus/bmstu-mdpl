.model TINY

SG SEGMENT
	ASSUME CS:SG, DS:SG
	ORG 100h
	
MAIN:
	JMP INIT
	IS_INIT DW 1
	OLD_8H DD 0 ;Сюда процедура инициализации запишет адрес предыдущего обработчика INT 08h.
	
INT_8H_HANDLER PROC NEAR

	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	
	PUSH ES
	PUSH DS

	PUSHF
	
	MOV AH, 2
	INT 1Ah
	MOV CH, DH ;Получение текущей секунды

	MOV BX, 1Fh ;Самая медленная скорость автоповтора
	
	MAIN_LOOP:
	
	CALL CHANGE_SPEED ;Установить скорость автоповтора в соответствии с BX
	
	SUB BX, 1h ;Увеличить скорость на один пункт (0 - самая быстрая)
	JNZ CONTINUE
	MOV BX, 1Fh ;Зацикливание скорости по кругу
	
	CONTINUE: ;Здесь осуществляется ожидание прошедствия 1 секунды
	
	PUSH CX ;1Ah изменит CX, поэтому его надо запомнить и восстановить потом
	MOV AH, 2 ;Считать время
	INT 1Ah 
	POP CX
	
	CMP CH, DH ;Сравнение текущей секунды(в DH) с сохраненной ранее (в CH)
	MOV CH, DH ;Обновить значение
	JE CONTINUE ;Если это та же самая секунда - не менять скорость автоповтора и перейти к ожиданию
	
	JMP SHORT MAIN_LOOP ;Если секунды разные, переключить скорость
	
	IN AL,61h
	PUSH AX
	OR AL, 80h
	OUT 61h, AL
	POP AX
	OUT 61h, AL
	
	mov AL, 20h
	out 20h, aL
	
	POP DS
	POP ES
	
	POP CX
	POP DX
	POP BX
	POP AX
	
	POPF
	
	IRET

INT_8H_HANDLER ENDP

CHANGE_SPEED PROC NEAR
	CALL WAIT_BTN
	MOV AL, 0F3h
	OUT 60h, AL
	CALL WAIT_BTN
	MOV AX, BX
	OUT 60h, AX ;Новое состояние скорости автоповтора
	RET
CHANGE_SPEED ENDP

WAIT_BTN PROC NEAR
	IN AL, 64h ; Проверка состояния клавиатуры
	TEST AL, 0010b ; Первый бит == 1 => процессор не готов к приему команды
	JNZ WAIT_BTN ; Ожидание ввода
	RET
WAIT_BTN ENDP
	
INIT:
	MOV AX, 3508h
	INT 21h
	
	CMP ES:IS_INIT, 1
	JE UNINSTALL
	
	MOV WORD PTR OLD_8H, BX
	MOV WORD PTR OLD_8H + 2, ES
	
	MOV AX, 2508h ;Установка вектора прерывания
	MOV DX, OFFSET INT_8H_HANDLER ;в DX помещается адрес программы обработки обрывания
	INT 21h
	
	MOV DX, OFFSET INIT ;Адрес последнего байта программы
	INT 27h ;Резидентное завершение
	
UNINSTALL:
	PUSH ES
	PUSH DS
	
	MOV DX, WORD PTR ES:OLD_8H ;Восстановление старого вектора прерывания
	MOV DS, WORD PTR ES:OLD_8H + 2
	
	POP DS
	POP ES
	
	MOV AH, 49h ;Освободить блок распределенной памяти
	INT 21h
	
	MOV AX, 4C00h ;Завершить программу
	INT 21h
	
SG ENDS
END MAIN
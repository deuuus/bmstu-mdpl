.MODEL TINY
.CODE
.386

ORG 100h 

MAIN:
    TIME DB 0
    MOV AH, 02h
    INT 1Ah
    MOV TIME, DH
	
    SPEED DB 01Fh
    OLD_08H DD ?
    IS_INIT DB 'I'

    JMP INIT

INT_08h_HANDLER PROC NEAR
    PUSHA
    PUSHF
    PUSH ES
    PUSH DS

    MOV AH, 02h
    INT 1Ah ;Считать время из постоянных часов реального времени. Секунды будут в DH

    CMP DH, TIME
    MOV TIME, DH ;Обновление таймера
    JE QUIT ;Если секунды равны, пропустить такт работы

    MOV AL, 0F3h ;Команда клавиатуры для регулировки скорости автоповтора
    OUT 60h, AL
    MOV AL, SPEED ;Изменение скорости
    OUT 60h, AL

    DEC SPEED
    JNZ QUIT
    MOV SPEED, 01fh ;Зацикливание скорости по кругу

    QUIT:
        POP DS
	POP ES
	POPF
	POPA

        JMP CS:OLD_08H
INT_08h_HANDLER ENDP

INIT:
    MOV AX, 3508h ;Получение адреса обработчика вектора прерывания (расп. в ES:BX)
    INT 21H

    CMP ES:IS_INIT, 'I'
    JE UNINSTALL

    MOV WORD PTR OLD_08H, BX ;Сохранение адреса обработчика
    MOV WORD PTR OLD_08H + 2, ES

    MOV AX, 2508h ; Установка вектора прерывания. DS:DX = вектор прерывания: адрес программы обработки прерывания
    MOV DX, OFFSET INT_08h_HANDLER ;адрес программы обработки обрывания
    INT 21H

    MOV DX, OFFSET INIT ;Адрес последнего байта резидентной программы
    INT 27H ;Резидентное завершение 

UNINSTALL:
    PUSH ES
    PUSH DS

    ;Установка старого вектора прерывания
    MOV DX, WORD PTR ES:OLD_08H
    MOV DS, WORD PTR ES:OLD_08H + 2
    MOV AX, 2508h 
    INT 21H
  
    POP DS
    POP ES
    MOV AH, 49h ;Освобождение распределенного блока памяти
    INT 21h

    MOV AX, 4C00h ;Завершение программы
    INT 21h
    
END MAIN

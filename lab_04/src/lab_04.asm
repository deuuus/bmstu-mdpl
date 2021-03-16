;Описание сегмента стека
SSEG SEGMENT PARA STACK 'STACK'
    DB 100 DUP(0)
SSEG ENDS

;Описание сегмента данных
DSEG SEGMENT PARA 'DATA'
	X DB 0 ;выделение памяти под 2 переменные
	Y DB 0
DSEG ENDS

;Описание сегмента кода
CSEG SEGMENT PARA 'CODE'
    ASSUME CS:CSEG, DS:DSEG, SS:SSEG ;Установление связи сегментных регистров с сегментами
MAIN:
	;Подготовка DSEG
    MOV AX, DSEG
    MOV DS, AX

    MOV AH, 01H ;Считать один символ из stdin с эхом
    INT 21H
	MOV [X], AL ;Сохранение значения в переменной
	
	MOV DL, 32 ; Загрузка ASCII-кода символа пробела для выделения отступа между вводом цифр
	MOV AH, 02H ;Вывод символа в stdout
    INT 21H
	
	MOV AH, 01H ;Считать один символ из stdin с эхом
    INT 21H
	MOV [Y], AL ;Сохранение значения в переменной
    
    MOV AH, 02H ;Режим печати по одному символу в stdout
    MOV DL, 13 ;Курсор поместить в начало строки
    INT 21H
    MOV DL, 10 ;Перевести курсор на новую строку
    INT 21H
    MOV DL, [X]
	SUB DL, [Y] ;Разность цифр
	ADD DL, 48 ;Преобразование кода символа в значение цифры
    INT 21H
    
    MOV AH, 4CH ;Завершение программы
    INT 21H
CSEG ENDS
END MAIN
	
	
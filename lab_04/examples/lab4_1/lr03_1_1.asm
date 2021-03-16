EXTRN output_X: near ;Указание, что идентификатор output_X с типом near(ближний переход, 
;если адрес перехода находится в том же сегменте, что и вызов) определен в другом модуле

;это заключенная в кавычки строка, помогающая компоновщику определить соответствующий порядок 
;следования сегментов при собирании программы из сегментов нескольких модулей. Компоновщик 
;объединяет вместе в памяти все сегменты с одним и тем же именем класса (имя класса, в общем
; случае, может быть любым, но лучше, если оно будет отражать функциональное назначение сегмента).

STK SEGMENT PARA STACK 'STACK' ;Описание сегмента стека с выравниванием по параграфу(16 байт) класса STACK,
							;типа STACK (все сегменты стека одинаковым именем, но разными классами, будут объединены в один,)
	db 100 dup(0) ; выделение 100 байт, инициализированных нулями
STK ENDS ;Завершение описания сегмента стека

DSEG SEGMENT PARA PUBLIC 'DATA' ;Описание сегмента данных с выравниванием по параграфу типа PUBLIC (означает, что все такие
								;сегменты с одинаковым именем, но разными классами, будут объединены в один)
	X db 'R' ;Выделение памяти под символ R
DSEG ENDS ;Завершение описания сегмента данных

CSEG SEGMENT PARA PUBLIC 'CODE' ;Описание сегмента кода с выравниваем по параграфу типа PUBLIC класса 'CODE'
	assume CS:CSEG, DS:DSEG, SS:STK ;Установление связи сегментных регистров с сегментами
main: ;определение точки входа(команда, с которой начнется выполнение команды)
	mov ax, DSEG
	mov ds, ax ;инициализация регистра DS

	call output_X ;вызов процедуры output_X (передача управления по метке с сохранением адреса возврата в стек)

	mov ax, 4c00h ; DOS функция выхода из программы
	int 21h ;Выход из программы
CSEG ENDS ;Завершение сегмента кода

PUBLIC X ;Указание, что идентификатор Х может использоваться в других модулях.

END main ;Завершение описания модуля и указание точки входа.
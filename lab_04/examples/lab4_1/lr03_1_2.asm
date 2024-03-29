PUBLIC output_X ; Указание, что идентификатор output_X доступен для других модулей
EXTRN X: byte ;Идентификатор Х определен в другом модуле и имеет тип byte.

DS2 SEGMENT AT 0b800h ;Видеопамять текстового режима доступна по этому адресу.
					;Описание второго сегмента данных. Сегмент должен располагаться по фиксированному адресу в памяти.
					;Результат выражения, использующегося в качестве операнда AT, равен этому адресу, деленному на 16.
	CA LABEL byte ;Директива label определяет метку и задает ее тип. Метка получает значение, равное адресу следующей команды
				;или следующих данных, и тип, указанный явно.
	ORG 80 * 2 * 2 + 2 * 2 ;2 * (80 * 2 + 2) По 2 байта на каждый символ. Установка значения программного счетчика
	;Программный счетчик - внутренняя переменная ассемблера, равная смещению
	;текущей команды или данных относительно начала сегмента. Используется для преобразования меток в адреса.
	SYMB LABEL word 
DS2 ENDS ;Завершение описания второго сегмента данных

CSEG SEGMENT PARA PUBLIC 'CODE' ;Описание сегмента кода с выравниваем PARA типа PUBLIC класса 'CODE'
	assume CS:CSEG, ES:DS2 ;Описание связей между сегментными регистрами и самими сегментами
output_X proc near ;Начало процедуры, связанной с меткой output_X, имеющей тип near(ближняя адресация)
	mov ax, DS2
	mov es, ax ;инициализация соответствующего регистра
	mov ah, 10
	mov al, X
	mov symb, ax
	ret ;возращает управление по адресу из стека.
output_X endp ;Завершение процедуры
CSEG ENDS ;Завершение сегмента кода
END ;Конец программы
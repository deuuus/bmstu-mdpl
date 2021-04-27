app.exe: src/asm_strcpy.asm src/main.c
	nasm -f elf64 -o asm_strcpy.o src/asm_strcpy.asm
	gcc -c -Wall -masm=intel src/main.c
	gcc -o $@ main.o asm_strcpy.o

run:
	./app.exe

clean:
	rm -f *.o *.exe

global asm_strcpy

section .text

asm_strcpy:
    MOV RCX, RDX
    CMP RDI, RSI
    JNE NOT_EQUAL
    JMP QUIT

NOT_EQUAL:
    CMP RDI, RSI
    JL COPY ;RDI < RSI

    MOV RAX, RDI
    SUB RAX, RSI

    CMP RAX, RCX
    JGE COPY

REVERSE_COPY:
    ADD RDI, RCX
    ADD RSI, RCX
    DEC RDI
    DEC RSI
    STD

COPY:
    REP MOVSB
    CLD ; DF=0 => АДРЕСА DI, SI УВЕЛИЧИВАЮТСЯ

QUIT:
    RET
    
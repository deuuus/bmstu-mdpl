SRC = ./src
INC = ./inc
OUT = ./out

SOURCES = $(wildcard $(SRC)/*.c)
INCS = $(wildcard $(INC)/*.h)
OBJS = $(SOURCES:$(SRC)/%.c=$(OUT)/%.o)

CC = gcc
CFLAGS = -std=c99 -I$(INC)/ -masm=intel -g3

APP = $(OUT)/app.exe

.PHONY: run clean

app.exe: run

run: build
	$(APP)

build: $(OBJS) $(INCS)
	$(CC) $(CFLAGS) -o $(APP) $(OBJS)

$(OUT)/%.o: $(SRC)/%.c $(OUT)
	$(CC) $(CFLAGS) -c $< -o $@

$(OUT):
	mkdir -p $(OUT)

clean:
	rm -f *.o
	rm -f *.exe
	rm -rf $(OUT)
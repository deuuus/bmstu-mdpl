SRC = ./src
INC = ./inc
OUT = ./out

SOURCES = $(wildcard $(SRC)/*.c)
INCS = $(wildcard $(INC)/*.h)
OBJS = $(SOURCES:$(SRC)/%.c=$(OUT)/%.o)

CC = gcc
CFLAGS = -std=c99 -I$(INC)/ -masm=intel 

APP = $(OUT)/main.out
APP_M_80387 = $(OUT)/main_m_80387.out
APP_MNO_80387 = $(OUT)/main_mno_80387.out

.PHONY: build build_m_80387 build_mno_80387 run run_m_80387 run_mno_80387 clean

run: build
	$(APP)

run_m_80387: build_m_80387
	$(APP_M_80387)

run_mno_80387: build_mno_80387
	$(APP_MNO_80387)

build: $(OBJS) $(INCS)
	$(CC) $(CFLAGS) -o $(APP) $(OBJS)

build_m_80387 : CFLAGS += -m80387
build_m_80387: $(OBJS) $(INCS)
	$(CC) $(CFLAGS) -o $(APP_M_80387) $(OBJS)

build_mno_80387 : CFLAGS += -mno-80387 -DX87
build_mno_80387: $(OBJS) $(INCS)
	$(CC) $(CFLAGS) -o $(APP_MNO_80387) $(OBJS)

$(OUT)/%.o: $(SRC)/%.c $(OUT)
	$(CC) $(CFLAGS) -c $< -o $@

$(OUT):
	mkdir -p $(OUT)

clean:
	rm -f *.o
	rm -f *.out
	rm -rf $(OUT)
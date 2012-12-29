# makefile
#
# use make command under current directory

# Variable Definition
CC = gcc
LEX = flex
CFLAGS = -Wall -O -g
LFLAGS = -lfl
SOURCE = LexicalAnalyzer.lex
TARGET = ./LexicalAnalyzer

#Compile .c file to .exe file
$(TARGET) : LexicalAnalyzer.yy.c
	$(CC) $(CFLAGS) $^ -o $@ $(LFLAGS)

#Compile .lex file to .c file
LexicalAnalyzer.yy.c : $(SOURCE)
	$(LEX) -o $@ $^

# make clean command to delete all .c files and .exe file
clean:
	rm -rf *.c LexicalAnalyzer

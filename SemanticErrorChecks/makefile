# Project: CMSC430, Compiler Theory & Design, Project 4, Semantic Error Checks
# Date: 08 December 2021
# Filename: makefile
# Description: This makefile is used to automatically recompile the required programs of project 2.
# The user needs only to enter the command "make" from the project directory, and then is able to run
# the project using ./compile in a terminal.
#
# Adapted From Source, Authored by: Dr. Duane J. Jarc

compile: scanner.o parser.o listing.o types.o
	g++ -o compile scanner.o parser.o listing.o types.o
	
scanner.o: scanner.c types.h listing.h tokens.h
	g++ -c scanner.c

scanner.c: scanner.l	
	flex scanner.l
	mv lex.yy.c scanner.c

parser.o: parser.c types.h listing.h symbols.h
	g++ -c parser.c

parser.c tokens.h: parser.y
	bison -d -v parser.y
	mv parser.tab.c parser.c
	cp parser.tab.h tokens.h

listing.o: listing.cc listing.h
	g++ -c listing.cc

types.o: types.cc types.h
	g++ -c types.cc

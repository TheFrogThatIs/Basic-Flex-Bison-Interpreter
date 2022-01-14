/*
 * Project: CMSC430, Compiler Theory & Design, Project 3, Interpreter
 * Date: 27 November 2021
 * Filename: listing.h
 * Description: Header file for the C++ file listing.cc that defines the function prototypes
 * and error categories that are used in the compilation process.
 *
 * Adapted From Source, Authored by: Dr. Duane J. Jarc
 */

// This file contains the function prototypes for the functions that produce the // compilation listing

enum ErrorCategories {LEXICAL, SYNTAX, GENERAL_SEMANTIC, DUPLICATE_IDENTIFIER,
	UNDECLARED};

void firstLine();
void nextLine();
int lastLine();
void appendError(ErrorCategories errorCategory, string message);

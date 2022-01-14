/*
 * Project: CMSC430, Compiler Theory & Design, Project 4, Semantic Error Checks
 * Date: 08 December 2021
 * Filename: listing.h
 * Description: Header file for the C++ file listing.cc that defines the function prototypes
 * and error categories that are used in the compilation process.
 *
 * Adapted From Source, Authored by: Dr. Duane J. Jarc
 */

enum ErrorCategories {LEXICAL, SYNTAX, GENERAL_SEMANTIC, DUPLICATE_IDENTIFIER, UNDECLARED};

void firstLine();
void nextLine();
int lastLine();
void appendError(ErrorCategories errorCategory, string message);


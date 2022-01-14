/*
 * Project: CMSC430, Compiler Theory & Design, Project 4, Semantic Error Checks
 * Date: 08 December 2021
 * Filename: listing.cc
 * Description: The C++ file that contains the functions that are used in the compilation process.
 * Includes function that aid in parsing input file, as well as track lexical, syntax, and semantic
 * compilation errors and provide them to the user by line of the input file.
 *
 * Adapted From Source, Authored by: Dr. Duane J. Jarc
 */

#include <cstdio>
#include <string>
#include <sstream>
#include <iostream>
#include <queue>

using namespace std;

#include "listing.h"

static int lineNumber;
static string error = "";
static int totalErrors = 0;
static int lexErrors = 0;
static int syntaxErrors = 0;
static int semanticErrors = 0;
static queue<string> q;

static void displayErrors();

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine()
{
    printf("\r");
    displayErrors();
    printf("     \n");
    if (totalErrors == 0){
        printf("Compiled Successfully.\n");
    } else{
        std::cout << "Lexical Errors: " << lexErrors;
        std::cout << "\nSyntax Errors: " << syntaxErrors;
        std::cout << "\nSemantic Errors: " << semanticErrors;
        cout << "\n";
    }
    return totalErrors;
}
    
void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = { "Lexical Error, Invalid Character ", "",
		"Semantic Error, ", "Semantic Error, Duplicate Identifier: ",
		"Semantic Error, Undeclared " };

    error = messages[errorCategory] + message;
    q.push(error);
    switch (errorCategory) {
        case LEXICAL:
            lexErrors++;
            break;
        case SYNTAX:
            syntaxErrors++;
            break;
        default:
            semanticErrors++;
            break;
    }
    totalErrors++;
}

void displayErrors()
{
    while(!q.empty()) {
        cout << q.front();
        q.pop();
        cout << "\n";
    }
}

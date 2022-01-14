/* Project: CMSC430, Compiler Theory & Design, Project 3, Interpreter
   Date: 27 November 2021
   Filename: scanner.l
   Description: Lexical Analyzer file used by Flex to perform lexical analysis using the language
   specifications provided for the project. File contains the flex input file with definitions,
   rules, and user code.

   Adapted From Source, Authored by: Dr. Duane J. Jarc
   */

/* This file contains flex input file */

/* Definitions */
%{
#include <cstdio>
#include <string>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		        [ \t\r]+
comment		    \-\-.*\n
commenttwo	    \/\/.*\n
line		    [\n]
real            [0-9]+(\.[0-9]*)([eE][+-]?[0-9]+)?
digit		    [0-9]
int		        {digit}+
id		        [A-Za-z]([_]?[A-Za-z0-9])*
punc		    [\(\),:;]
arrow           =>
%%

{ws}		    { ECHO; }
{comment}	    { ECHO; nextLine();}
{commenttwo}	{ ECHO; nextLine();}
{line}		    { ECHO; nextLine();}
">="	        { ECHO; yylval.oper = GREATEROREQUAL;   return(RELOP); }
">"		        { ECHO; yylval.oper = GREATER;          return(RELOP); }
"<="	        { ECHO; yylval.oper = LESSOREQUAL;      return(RELOP); }
"<"		        { ECHO; yylval.oper = LESS;             return(RELOP); }
"/="	        { ECHO; yylval.oper = NOTEQUAL;         return(RELOP); }
"="		        { ECHO; yylval.oper = EQUAL;            return(RELOP); }
"+"		        { ECHO; yylval.oper = ADD;              return(ADDOP); }
"-"		        { ECHO; yylval.oper = SUBTRACT;         return(ADDOP); }
"**"            { ECHO; yylval.oper = EXPONENT;         return(EXPOP); }
"*"		        { ECHO; yylval.oper = MULTIPLY;         return(MULOP); }
"/"		        { ECHO; yylval.oper = DIVIDE;           return(MULOP); }
or		        { ECHO; return(OROP); }
not	            { ECHO; return(NOTOP); }
begin		    { ECHO; return(BEGIN_); }
boolean		    { ECHO; return(BOOLEAN); }
endcase	        { ECHO; return(ENDCASE); }
case	        { ECHO; return(CASE); }
endif	        { ECHO; return(ENDIF); }
if		        { ECHO; return(IF); }
endreduce	    { ECHO; return(ENDREDUCE); }
end		        { ECHO; return(END); }
function	    { ECHO; return(FUNCTION); }
integer		    { ECHO; return(INTEGER); }
is		        { ECHO; return(IS); }
reduce		    { ECHO; return(REDUCE); }
returns		    { ECHO; return(RETURNS); }
and		        { ECHO; return(ANDOP); }
else	        { ECHO; return(ELSE); }
others	        { ECHO; return(OTHERS); }
real	        { ECHO; return(REAL); }
then	        { ECHO; return(THEN); }
when	        { ECHO; return(WHEN); }
rem             { ECHO; yylval.oper = REMAINDER;     return(REMOP); }
true	        { ECHO; yylval.value = 1;            return(BOOL_LITERAL); }
false	        { ECHO; yylval.value = 0;            return(BOOL_LITERAL); }
{id}		    { ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1);
			    strcpy(yylval.iden, yytext);         return(IDENTIFIER); }
{real}          { ECHO; yylval.value = atof(yytext); return(REAL_LITERAL); }
{int}		    { ECHO; yylval.value = atof(yytext); return(INT_LITERAL); }
{punc}		    { ECHO; return(yytext[0]); }
{arrow}         { ECHO; return(ARROW); }
.		        { ECHO; appendError(LEXICAL, yytext); }

%%

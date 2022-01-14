/* Project: CMSC430, Compiler Theory & Design, Project 3, Interpreter
   Date: 27 November 2021
   Filename: parser.y
   Description: Interpreter file used by Yacc/Bison to perform syntactic analysis using
   the language specifications provided for the project. File contains the bison input file with
   definitions, rules, and user code.

   Adapted From Source, Authored by: Dr. Duane J. Jarc
   */

%{
    #include <iostream>
    #include <string>
    #include <vector>
    #include <map>
    #include <list>

    using namespace std;

    #include "values.h"
    #include "listing.h"
    #include "symbols.h"
    #include "float.h"

    int yylex();
    void yyerror(const char* message);

    Symbols<double> symbols;

    double switchVariable;
    double switchValue = -DBL_MAX;

    list<double> params;

    double result;
%}

%define parse.error verbose

%union
{
	CharPtr     iden;
	Operators   oper;
	double      value;
}

%token <iden> IDENTIFIER

/* Literals */
%token <value> INT_LITERAL REAL_LITERAL BOOL_LITERAL

/* Operators */
%token <oper> ADDOP MULOP RELOP
%token ANDOP OROP NOTOP REMOP EXPOP

/* Reserved Words */
%token BEGIN_ END ENDREDUCE FUNCTION IS REDUCE RETURNS
%token CASE ENDCASE ELSE IF ENDIF OTHERS THEN WHEN
%token INTEGER BOOLEAN REAL

/* Arrow Symbol */
%token ARROW

%type <value> body statement_ statement reductions expression relation term
	factor primary
%type <oper> operator

%%
/* Function */
function:
	function_header variable_ body {result = $3;} ;

/* Function Header */
function_header:
	FUNCTION IDENTIFIER optional_parameter RETURNS type ';' |
    error ';' ;

/* Variable Repetitions {0 or more} */
variable_:
    /* Empty */ |
	variable_ variable ';' |
    error ';' ;

/* Variable Definition -> G2G */
variable:
	IDENTIFIER ':' type IS statement {symbols.insert($1, $5);} ;

/* Parameter Optional [] */
optional_parameter:
    parameter |
    optional_parameter ',' parameter |
    /* Empty */ ;

/* Parameter Definition */
parameter:
    IDENTIFIER ':' type { double input = 1;
                          if(!params.empty()) {
                              input = params.front();
                              params.pop_front();
                          } else {
                              appendError(UNDECLARED, $1);
                          }
                          symbols.insert($1, input); } ; /* Initialize to Arguments */

/* Type */
type:
	INTEGER |
	BOOLEAN |
	REAL ;

/* Body */
body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;

/* Statement */
statement_:
	statement ';' |
	error ';' {$$ = 0;} ;

/* Statement Definitions */
statement:
	expression |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} |
    IF expression THEN statement ';' ELSE statement ';' ENDIF {$$ = $2 ? $4 : $7;} |
    CASE case_expression IS cases_ OTHERS ARROW statement ';' ENDCASE
    {$$ = switchValue == -DBL_MAX ? $7 : switchValue; switchValue = -DBL_MAX;} ;

/* Cases Repetitions {0 or more} */
cases_:
    /* Empty */ |
    cases_ case ';' |
    error ';' ;

/* Case Definition */
case:
    WHEN INT_LITERAL ARROW statement {
        if($2 == switchVariable){
            switchValue = $4;
        }
    };

/* Reduce Operators */
operator:
	ADDOP |
	MULOP ;

/* Reductions Recursion */
reductions:
	reductions statement_ {$$ = evaluateReduction($<oper>0, $<value>1, $<value>2);} |
	{$$ = ($<oper>0 == ADD || $<oper>0 == SUBTRACT) ? 0 : 1;} ;

/* Expression Precedence, Low to High */
case_expression:
    case_expression OROP combination {$<value>$ = $<value>1 || $<value>3; switchVariable = $<value>$;} |
    combination {$<value>1; switchVariable = $<value>$;} ;

expression:
    expression OROP combination {$<value>$ = $<value>1 || $<value>3;} |
    combination {$<value>1;} ;

combination:
	combination ANDOP relation {$<value>$ = $<value>1 && $<value>3;} |
	relation ;

relation:
	relation RELOP term {$<value>$ = evaluateRelational($<value>1, $<oper>2, $<value>3);} |
	term ;

term:
	term ADDOP factor {$$ = evaluateArithmetic($<value>1, $<oper>2, $<value>3);} |
	factor ;

factor:
    factor REMOP exponential {$<value>$ = evaluateArithmetic($<value>1, $<oper>2, $<value>3);} |
	factor MULOP exponential {$<value>$ = evaluateArithmetic($<value>1, $<oper>2, $<value>3);} |
	exponential {$<value>1;} ;

exponential:
    negation EXPOP exponential {$<value>$ = evaluateArithmetic($<value>1, $<oper>2, $<value>3);} |
    negation ;

negation:
    NOTOP primary {$<value>$ = !($<value>2); } |
    primary ;

primary:
	'(' expression ')' {$<value>$ = $<value>2;} |
    BOOL_LITERAL |
    REAL_LITERAL |
	INT_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;

%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])
{
	for(int i = 1; i < argc; i++)
        params.push_back(atof(argv[i]));
	firstLine();
	yyparse();
	if (lastLine() == 0)
		cout << "Result = " << result << endl;
	return 0;
}

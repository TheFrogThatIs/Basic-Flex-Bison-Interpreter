/* Project: CMSC430, Compiler Theory & Design, Project 4, Semantic Error Checks
   Date: 08 December 2021
   Filename: parser.y
   Description: Interpreter file used by Yacc/Bison to perform syntactic analysis using
   the language specifications provided for the project. File contains the bison input file with
   definitions, rules, and user code.

   Adapted From Source, Authored by: Dr. Duane J. Jarc
   */

%{

    #include <string>
    #include <vector>
    #include <map>

    using namespace std;

    #include "types.h"
    #include "listing.h"
    #include "symbols.h"

    int yylex();
    void yyerror(const char* message);

    Symbols<Types> symbols;
    Types functionReturn;
    Types tempCaseType;

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Types type;
}

%token <iden> IDENTIFIER

/* Literals */
%token <type> INT_LITERAL REAL_LITERAL BOOL_LITERAL

/* Operators */
%token ADDOP MULOP RELOP ANDOP OROP NOTOP REMOP EXPOP

/* Reserved Words */
%token BEGIN_ END ENDREDUCE FUNCTION IS REDUCE RETURNS
%token CASE ENDCASE ELSE IF ENDIF OTHERS THEN WHEN
%token INTEGER BOOLEAN REAL

/* Arrow Symbol */
%token ARROW

%type <type> body type statement statement_ reductions cases_ case expression combination relation
    term factor exponential negation primary case_expression

%%
/* Function */
function:	
	function_header variable_ body { checkAssignment(functionReturn, $3, "Function Return"); } ;

/* Function Header */
function_header:	
	FUNCTION IDENTIFIER optional_parameter RETURNS type ';' { functionReturn = $5;} |
    error ';' ;


/* Variable Repetitions {0 or more} */
variable_:
    /* Empty */ |
	variable_ variable ';' |
    error ';' ;

/* Variable Definition -> G2G */
variable:
	IDENTIFIER ':' type IS statement {checkAssignment($3, $5, "Variable Initialization");
	                                    if(!symbols.alreadyExists($1)) symbols.insert($1, $3);} ;

/* Parameter Optional [] */
optional_parameter:
    parameter |
    optional_parameter ',' parameter |
    /* Empty */ ;

/* Parameter Definition */
parameter:
    IDENTIFIER ':' type { if(!symbols.alreadyExists($1)) symbols.insert($1, $3); } ;

/* Type */
type:
	INTEGER {$$ = INT_TYPE;}  |
	BOOLEAN {$$ = BOOL_TYPE;} |
    REAL    {$$ = REAL_TYPE;} ;

/* Body */
body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;

/* Statement */
statement_:
	statement ';' { $$ = $1; } |
	error ';' {$$ = MISMATCH;} ;

/* Statement Definitions -- WORKING */
statement:
	expression { $$ = $1; } |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} |
    IF expression THEN statement ';' ELSE statement ';' ENDIF { $$ = checkIfThenElse($2, $4, $7); } |
    CASE case_expression IS cases_ OTHERS ARROW statement ';' ENDCASE {
     if($2 != INT_TYPE){  $$ = MISMATCH; }
     else if($4 != MISMATCH && $7 != MISMATCH && $4 == $7){ $$ = $7; }
     else { $$ = MISMATCH; }
     };

/* Cases Repetitions {0 or more} */
cases_:
    /* Empty */ { $$ = tempCaseType; } |
    cases_ case ';' {  $$ = checkCases($1, $2); } |
    error ';' {$$ = MISMATCH;} ;

/* Case Definition */
case:
    WHEN INT_LITERAL ARROW statement { $$ = $4;
        if(tempCaseType == (Types) NULL){
            tempCaseType = $4;
        } else if(tempCaseType != $4){
            appendError(GENERAL_SEMANTIC, "Type Mismatch, Cases Need to Be Same Type.");
            tempCaseType = MISMATCH;
        }
    };

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_ {$$ = checkArithmetic($1, $2);} |
	{$$ = INT_TYPE;} ;

/* Expression Precedence, Low to High */
case_expression:
    expression { if($1 != INT_TYPE){ appendError(GENERAL_SEMANTIC, "Type Mismatch, Case Expression Needs to Be INT_TYPE"); $$ = MISMATCH; } } ;

expression:
	expression OROP combination {$$ = checkLogical($1, $3);} |
	combination ;

combination:
	combination ANDOP relation {$$ = checkLogical($1, $3);} |
	relation ;

relation:
	relation RELOP term {$$ = checkRelational($1, $3);}|
	term ;

term:
	term ADDOP factor {$$ = checkArithmetic($1, $3);} |
	factor ;
      
factor:
	factor REMOP exponential  {$$ = checkRemainder($1, $3);} |
	factor MULOP exponential  {$$ = checkArithmetic($1, $3);} |
	exponential ;

exponential:
    negation EXPOP exponential { $$ = checkArithmetic($1, $3); } |
    negation ;

negation:
    NOTOP primary { $$ = checkLogicalNot($2); } |
    primary ;

primary:
	'(' expression ')' {$$ = $2;}       |
	BOOL_LITERAL { $$ = BOOL_TYPE; }    |
    REAL_LITERAL { $$ = REAL_TYPE; }    |
	INT_LITERAL { $$ = INT_TYPE; }      |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;
    
%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 

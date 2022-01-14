# Flex-Bison-Interpreter
Flex/Bison Interpreter for Pre-Defined Language

The Interpreter/ folder contains the source code for the interpreter of the language. The SemanticErrorChecks contains a modified version of the semantic analyzer, capable of identifying select semantic errors which are not identified by the interpreter. Both are capable of identifying syntax and lexical errors.  

**Requirements:**
-  make
-  flex
-  bison
-  g++

***Usage (From Folder Containing Makefile):***
```
>make
>./compile < TestData/<filename>
```

**Grammar Specifications of Language:**
```
function:
  function_header {variable} body

function_header:
  FUNCTION IDENTIFIER [parameters] RETURNS type ;

variable:
  IDENTIFIER : type IS statement

parameters:
  parameter {, parameter}

parameter:
  IDENTIFIER : type

type:
  INTEGER | REAL | BOOLEAN

body:
  BEGIN statement END ;

statement:
  expression ; |
  REDUCE operator {statement} ENDREDUCE ; |
  IF expression THEN statement ELSE statement ENDIF ; |
  CASE expression IS {case} OTHERS ARROW statement ; ENDCASE ;

operator:
  ADDOP | MULOP

case:
  WHEN INT_LITERAL ARROW statement

expression:
  ( expression ) |
  expression binary_operator expression |
  NOT expression |
  INT_LITERAL | REAL_LITERAL | BOOL_LITERAL |
  IDENTIFIER

binary_operator: 
  ADDOP | MULOP | REMOP | EXPOP | RELOP | ANDOP | OROP
```

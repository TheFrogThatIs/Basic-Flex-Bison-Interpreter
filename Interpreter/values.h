/*
 * Project: CMSC430, Compiler Theory & Design, Project 3, Interpreter
 * Date: 27 November 2021
 * Filename: values.h
 * Description: Header file for the C++ file values.cc that defines the functions
 * for evaluating reductions, relational, and arithmetic operations.
 *
 * Adapted From Source, Authored by: Dr. Duane J. Jarc
 */

typedef char* CharPtr;
enum Operators {LESS, LESSOREQUAL, GREATER, GREATEROREQUAL, NOTEQUAL, EQUAL,
        ADD, SUBTRACT, MULTIPLY, DIVIDE, REMAINDER, EXPONENT }; // AND, OR, NOT not needed here

double evaluateReduction(Operators operator_, double head, double tail);
double evaluateRelational(double left, Operators operator_, double right);
double evaluateArithmetic(double left, Operators operator_, double right);

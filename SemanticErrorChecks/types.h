/*
 * Project: CMSC430, Compiler Theory & Design, Project 4, Semantic Error Checks
 * Date: 08 December 2021
 * Filename: types.h
 * Description: Header file that contains type definitions, and header file for the C++ file types.cc that defines
 * the type checking functions.
 *
 * Adapted From Source, Authored by: Dr. Duane J. Jarc
 */

typedef char* CharPtr;

enum Types {MISMATCH, INT_TYPE, BOOL_TYPE, REAL_TYPE};

void checkAssignment(Types lValue, Types rValue, string message);
Types checkArithmetic(Types left, Types right);
Types checkLogical(Types left, Types right);
Types checkLogicalNot(Types right);
Types checkRelational(Types left, Types right);
Types checkRemainder(Types left, Types right);
Types checkIfThenElse(Types left, Types middle, Types right);
Types checkCases(Types left, Types right);

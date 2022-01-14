/*
 * Project: CMSC430, Compiler Theory & Design, Project 4, Semantic Error Checks
 * Date: 08 December 2021
 * Filename: types.cc
 * Description: C++ file that contains the bodies of the type checking functions.
 *
 * Adapted From Source, Authored by: Dr. Duane J. Jarc
 */

#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"

void checkAssignment(Types lValue, Types rValue, string message)
{
    if(lValue == INT_TYPE && rValue == REAL_TYPE) { // Narrowing
        appendError(GENERAL_SEMANTIC, "Type Narrowing not allowed, " + message);
        return;
    }
    if(lValue == REAL_TYPE && rValue == INT_TYPE) // Widening
        return;

	if (lValue != MISMATCH && rValue != MISMATCH && lValue != rValue)
		appendError(GENERAL_SEMANTIC, "Type Mismatch on " + message);

}

Types checkArithmetic(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == BOOL_TYPE || right == BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Integer or Real Type Required");
		return MISMATCH;
	}

	if(left != right)
	    return REAL_TYPE; // Type Coercion
    else
        return left;
}

Types checkRemainder(Types left, Types right)
{
    if (left == MISMATCH || right == MISMATCH)
        return MISMATCH;
    if (left != INT_TYPE || right != INT_TYPE)
    {
        appendError(GENERAL_SEMANTIC, "Integer Type Required");
        return MISMATCH;
    }
    return INT_TYPE;
}


Types checkLogical(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left != BOOL_TYPE || right != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Boolean Type Required");
		return MISMATCH;
	}	
		return BOOL_TYPE;
	return MISMATCH;
}
Types checkLogicalNot(Types right)
{
    if (right == MISMATCH)
        return MISMATCH;
    if (right != BOOL_TYPE)
    {
        appendError(GENERAL_SEMANTIC, "Boolean Type Required");
        return MISMATCH;
    }
    return BOOL_TYPE;
}

Types checkRelational(Types left, Types right)
{
	if (checkArithmetic(left, right) == MISMATCH)
		return MISMATCH;
	return BOOL_TYPE;
}

Types checkIfThenElse(Types left, Types middle, Types right)
{
    if(left == MISMATCH || middle == MISMATCH || right == MISMATCH){
        return MISMATCH; // Error Already Identified
    }
    if(left != BOOL_TYPE){
        appendError(GENERAL_SEMANTIC, "Type Mismatch on If-Condition, Must be Boolean");
        return MISMATCH;
    }
    if(middle != right){
        appendError(GENERAL_SEMANTIC, "Type Mismatch on Then-Else Statements, Must Return Same Type");
        return MISMATCH;
    }
    return right;
}
Types checkCases(Types left, Types right)
{
    if(left == MISMATCH || right == MISMATCH){
        return MISMATCH;
    }
    if(left != right){
        appendError(GENERAL_SEMANTIC, "Type Mismatch, Cases Need to Be Same Type.");
        return MISMATCH;
    }
    return left;
}

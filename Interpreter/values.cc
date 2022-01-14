/*
 * Project: CMSC430, Compiler Theory & Design, Project 3, Interpreter
 * Date: 27 November 2021
 * Filename: values.cc
 * Description: The C++ file that contains the bodies of the functions used
 * for evaluating reductions, relational, and arithmetic operations.
 *
 * Adapted From Source, Authored by: Dr. Duane J. Jarc
 */

#include <string>
#include <vector>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"

double evaluateReduction(Operators operator_, double head, double tail)
{
	if (operator_ == ADD)
		return head + tail;
    if (operator_ == SUBTRACT)
        return head - tail;
    if (operator_ == DIVIDE)
        return head / tail;
	return head * tail;
}


double evaluateRelational(double left, Operators operator_, double right)
{
    double result;
	switch (operator_){
		case LESS:
			result = left < right;
			break;
        case LESSOREQUAL:
            result = left <= right;
            break;
        case GREATER:
            result = left > right;
            break;
        case GREATEROREQUAL:
            result = left >= right;
            break;
        case EQUAL:
            result = left == right;
            break;
        case NOTEQUAL:
            result = left != right;
            break;
	}
	return result;
}

double evaluateArithmetic(double left, Operators operator_, double right)
{
    double result;
	switch (operator_){
		case ADD:
			result = left + right;
			break;
        case SUBTRACT:
            result = left - right;
            break;
		case MULTIPLY:
			result = left * right;
			break;
        case DIVIDE:
            result = left / right;
            break;
	    case REMAINDER:
	        result = fmod(left, right);
            break;
        case EXPONENT:
            result = pow(left, right);
            break;
	}
	return result;
}

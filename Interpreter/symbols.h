/*
 * Project: CMSC430, Compiler Theory & Design, Project 3, Interpreter
 * Date: 27 November 2021
 * Filename: symbols.h
 * Description: Header file that defines the functions for the symbol table used
 * by this bison interpreter.
 *
 * Adapted From Source, Authored by: Dr. Duane J. Jarc
 */

template <typename T>
class Symbols
{
public:
	void insert(char* lexeme, T entry);
	bool find(char* lexeme, T& entry);
private:
	map<string, T> symbols;
};

template <typename T>
void Symbols<T>::insert(char* lexeme, T entry)
{
	string name(lexeme);
	symbols[name] = entry;
}

template <typename T>
bool Symbols<T>::find(char* lexeme, T& entry)
{
	string name(lexeme);
	typedef typename map<string, T>::iterator Iterator;
	Iterator iterator = symbols.find(name);
	bool found = iterator != symbols.end();
	if (found)
		entry = iterator->second;
	return found;
}

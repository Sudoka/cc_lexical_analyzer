cc_lexical_analyzer
===================

The first step in the construction of your compiler is to implement a lexical analyzer for a Pascal-like language.
You should use lexical analyzer generator flex.
The lexical analyzer generator is a function that returns the token and places the lexeme in a variable visible to the outside world.
The lexical analyzer should recognize identifiers, integer literals, string literals, keywords, and predefined symbols.


1. The code was written under the Ubuntu Linux System (Version 11.10)
2. The Compiler version is GCC 4.6.1
3. I have written a "makefile" document
   So just type "make" command under current directory to compile source code.
   Also, type "make clean" under current directory to remove .c and execution files. 
4. The format of running source code is as below:

    ./LexicalAnalyzer <input file name> [<lexeme&token file name>] [<symbol table file name>]

   (1) The <input file name> argument is necessary;
   (2) The <lexeme&token file name> argument is optional;
       *This argument stores lexeme, token name, and attribute value information in format.
       *The first column is lexeme, the second column is token name, and the third column is attribute value.
       *If you do not input this argument, the lexeme&token file's name would be "LexemeAndToken.txt" automatically.
   (3) The <symbol table file name> argument is also optional;
       *This argument stores symbol table information, which includes identifier, number, and string separately.
       *The first column is lexeme, and the second column is symbol table entry in format "<token name, index>".
       *If you do not input this argument, the symbol table file's name would be "SymbolTable.txt" automatically.
5. Some additional information about Lexical Analyzer
   *keyword's token name is itself, and it has no attribute value.
   e.g.     begin       begin       
   *identifier's token name is "id", and its attribute value is the identifier symbol table entry.
   e.g.     errorfree   id      <ID, 6>
   *number's token name is "number", and its attribute value is the number symbol table entry.
    Also, number includes integer, float, and exponentent three types.
   e.g.     6.9e-1.8    number  <NUMBER, 4>
   *string's token name is "string", and its attribute value is the string symbol table entry.
   e.g.     "hello world\n"     string      <STRING, 17>
   *Moreover, I add the "/" as division operation. Its token name is "multop" and attribute value is "DIVIS".
   e.g.     /           multop      DIVIS

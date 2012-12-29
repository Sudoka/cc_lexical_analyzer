/*
    File Name:      LexicalAnalyzer.lex
    Instructor:     Prof. Mohamed Zahran
    Grader:         Robert Soule
    Author:         Shen Li
    UID:            N14361265
    Department:     Computer Science
    Note:           This LexicalAnalyzer.lex file
                    includes Rule Definitions and
                    User Functions.
*/

/*Declarations*/
%{
    /*MACRO*/
    #define TOKEN_FILE_NAME     "LexemeAndToken.txt"
    #define SYMBOL_FILE_NAME    "SymbolTable.txt"

    /*Constant Variables*/
    enum    size_constants{
        TABLE_SIZE      =   3,
        ATTRIBUTE_SIZE  =   32,
        STRING_SIZE     =   256,
    };
    enum    token_name{
        UNREC,
        AND, BEGIN_T, FORWARD, DIV, DO, ELSE, END, FOR, FUNCTION, IF, ARRAY, MOD, NOT, OF, OR, PROCEDURE, PROGRAM, RECORD, THEN, TO, TYPE, VAR, WHILE,
        NUMBER,
        STRING,
        ID,
        PLUSOP, MULTOP, ASSIGNOP, RELOP,
        PRESYMBOL,
        PARENTHESIS, BRACKET,
        EOF_T,
    };
    enum    plus_op{
        PLUS = 1,
        MINUS,
    };
    enum    mult_op{
        MULTI = 1,
        DIVIS,
    };
    enum    rel_op{
        LT = 1,
        LE,
        EQ,
        GE,
        GT,
        NE,
    };
    enum    pre_symbol{
        DOT = 1,
        COMMA,
        COLON,
        SEMICOLON,
        DOTDOT,
    };
    enum    brace{
        LEFT = 1,
        RIGHT,
    };

    /*Struct Definition*/
    typedef struct _symbol_table{
        char    lexeme[STRING_SIZE];        //lexeme
        struct _symbol_table    *next;      //next pointer
    }SYMBOL_TABLE;

    /*Global Variables*/
    SYMBOL_TABLE    *table_head[TABLE_SIZE];    //identifier, number, and string symbol table head node
    char            attr_str[ATTRIBUTE_SIZE];   //attribute value string
    int             attr_value = 0;             //attribute value

    /*Function Declaration*/
    void    initializeSymbolTable();
    void    clearSymbolTable();
    void    installSymbolTable();
    int     installID();
    int     installNumber();
    int     installString();
    void    installTokenNameAndAttribute(const char *token, const char *attribute);
    void    dieWithUserMessage(const char *message, const char *detail);
    void    dieWithSystemMessage(const char *message);
%}

    /*Definition Section*/
DIGIT       [0-9]
NUMBER      {DIGIT}+(\.{DIGIT}+)?
LETTER      [a-zA-Z]
DELIM       [ \t\n]

%%
    /*Translation Rules*/
{DELIM}+                        {   /*eat up whitespace*/   }
\{[^}]*\}                       {   /*eat up comments*/ }
and                             {   installTokenNameAndAttribute("and", "");        return  (AND);  }
begin                           {   installTokenNameAndAttribute("begin", "");      return  (BEGIN_T);  }
forward                         {   installTokenNameAndAttribute("forward", "");    return  (FORWARD);  }
div                             {   installTokenNameAndAttribute("div", "");        return  (DIV);  }
do                              {   installTokenNameAndAttribute("do", "");         return  (DO);   }
else                            {   installTokenNameAndAttribute("else","");        return  (ELSE); }
end                             {   installTokenNameAndAttribute("end", "");        return  (END);  }
for                             {   installTokenNameAndAttribute("for", "");        return  (FOR);  }
function                        {   installTokenNameAndAttribute("function", "");   return  (FUNCTION); }
if                              {   installTokenNameAndAttribute("if", "");         return  (IF);   }
array                           {   installTokenNameAndAttribute("array", "");      return  (ARRAY);}
mod                             {   installTokenNameAndAttribute("mod", "");        return  (MOD);  }
not                             {   installTokenNameAndAttribute("not", "");        return  (NOT);  }
of                              {   installTokenNameAndAttribute("of", "");         return  (OF);   }
or                              {   installTokenNameAndAttribute("or", "");         return  (OR);   }
procedure                       {   installTokenNameAndAttribute("procedure", "");  return  (PROCEDURE);}
program                         {   installTokenNameAndAttribute("program", "");    return  (PROGRAM);  }
record                          {   installTokenNameAndAttribute("record", "");     return  (RECORD);   }
then                            {   installTokenNameAndAttribute("then", "");       return  (THEN); }
to                              {   installTokenNameAndAttribute("to", "");         return  (TO);   }
type                            {   installTokenNameAndAttribute("type", "");       return  (TYPE); }
var                             {   installTokenNameAndAttribute("var", "");        return  (VAR);  }
while                           {   installTokenNameAndAttribute("while", "");      return  (WHILE);}
{NUMBER}(e[+-]?{NUMBER})?       {   attr_value = installNumber();
                                    if (sprintf(attr_str, "<NUMBER, %d>", attr_value) == -1){
                                        dieWithUserMessage("sprintf() failed", "<NUMBER> attribute value!");
                                    }
                                    installTokenNameAndAttribute("number", attr_str);   return  (NUMBER);   }
\"[^\"]*\"                      {   attr_value = installString();
                                    if (sprintf(attr_str, "<STRING, %d>", attr_value) == -1){
                                        dieWithUserMessage("sprintf() failed", "<STRING> attribute value!");
                                    }
                                    installTokenNameAndAttribute("string", attr_str);   return  (STRING);   }
{LETTER}({LETTER}|{DIGIT}|_)*   {   attr_value = installID();
                                    if (sprintf(attr_str, "<ID, %d>", attr_value) == -1){
                                        dieWithUserMessage("sprintf() failed", "<ID> attribute value!");
                                    }
                                    installTokenNameAndAttribute("id", attr_str);       return  (ID);       }
"+"                             {   attr_value = PLUS;  installTokenNameAndAttribute("plusop", "PLUS");     return  (PLUSOP);   }
"-"                             {   attr_value = MINUS; installTokenNameAndAttribute("plusop", "MINUS");    return  (PLUSOP);   }
"*"                             {   attr_value = MULTI; installTokenNameAndAttribute("multop", "MULTI");    return  (MULTOP);   }
"/"                             {   attr_value = DIVIS; installTokenNameAndAttribute("multop", "DIVIS");    return  (MULTOP);   }
":="                            {   installTokenNameAndAttribute("assignop", "");   return  (ASSIGNOP); }
"<"                             {   attr_value = LT;    installTokenNameAndAttribute("relop", "LT");    return  (RELOP);    }
"<="                            {   attr_value = LE;    installTokenNameAndAttribute("relop", "LE");    return  (RELOP);    }
"="                             {   attr_value = EQ;    installTokenNameAndAttribute("relop", "EQ");    return  (RELOP);    }
">="                            {   attr_value = GE;    installTokenNameAndAttribute("relop", "GE");    return  (RELOP);    }
">"                             {   attr_value = GT;    installTokenNameAndAttribute("relop", "GT");    return  (RELOP);    }
"<>"                            {   attr_value = NE;    installTokenNameAndAttribute("relop", "NE");    return  (RELOP);    }
"."                             {   attr_value = DOT;       installTokenNameAndAttribute("predefinedsymbol", "DOT");        return  (PRESYMBOL);}
","                             {   attr_value = COMMA;     installTokenNameAndAttribute("predefinedsymbol", "COMMA");      return  (PRESYMBOL);}
":"                             {   attr_value = COLON;     installTokenNameAndAttribute("predefinedsymbol", "COLON");      return  (PRESYMBOL);}
";"                             {   attr_value = SEMICOLON; installTokenNameAndAttribute("predefinedsymbol", "SEMICOLON");  return  (PRESYMBOL);}
".."                            {   attr_value = DOTDOT;    installTokenNameAndAttribute("predefinedsymbol", "DOTDOT");     return  (PRESYMBOL);}
"("                             {   attr_value = LEFT;  installTokenNameAndAttribute("parenthesis", "LEFT");    return  (PARENTHESIS);  }
")"                             {   attr_value = RIGHT; installTokenNameAndAttribute("parenthesis", "RIGHT");   return  (PARENTHESIS);  }
"["                             {   attr_value = LEFT;  installTokenNameAndAttribute("bracket", "LEFT");        return  (BRACKET);  }
"]"                             {   attr_value = RIGHT; installTokenNameAndAttribute("bracket", "RIGHT");       return  (BRACKET);  }
<<EOF>>                         {   return  (EOF_T);    }
.                               {   return  (UNREC);    }

%%
/*Auxiliary Functions*/
/*  Main Function
    Variable Definition:
    -- argc: the number of command arguments
    -- argv[]: each variable of command arguments(argv[0]is the path of execution file forever)
*/
int main(int argc, char *argv[]){
    //Test for correct number of arguments
    if (argc < 2 || argc > 4){
        dieWithUserMessage("Parameter(s)", "<input file name> [<lexeme and token file name>] [<symbol table file name>]");
    }

    char    *input_file_name = argv[1];                                             //input file name
    char    *output_file_name = (argc == 3 || argc == 4)? argv[2]:TOKEN_FILE_NAME;  //output file name
    int     rtn_value = 0;                                                          //yylex() function return value

    //Open file for reading input stream
    if ((yyin = fopen(input_file_name, "r")) == NULL){
        dieWithUserMessage("fopen() failed", "Cannot open file to read input stream!");
    }
    //Open file for writing output token and lexeme
    if ((yyout = fopen(output_file_name, "w")) == NULL){
        dieWithUserMessage("fopen() failed", "Cannot open file to write lexeme and token results!");
    }

    //Initialize identifier, number, and string symbol table head node
    initializeSymbolTable();
    //Start lexical analysis
    do {
        //Output the newline character
        fputc('\n', yyout);
        //Get the lexeme's type
        rtn_value = yylex();
        //Test the unrecognized characters
        if (rtn_value == UNREC){
            dieWithUserMessage("Cannot recognize characters", yytext);
        }
    } while (rtn_value != EOF_T);

    //Set the symbol table output file name
    output_file_name = (argc == 4)? argv[3]:SYMBOL_FILE_NAME;
    //Open file for writing output symbol table
    if ((yyout = fopen(output_file_name, "w")) == NULL){
        dieWithUserMessage("fopen() failed", "Cannot open file to write symbol table results!");
    }
    //Output identifier, number, and string symbol table
    installSymbolTable();
    //Deallocate space for identifier, number, and string symbol table
    clearSymbolTable();

    //Close read file
    fclose(yyin);
    //Close write file
    fclose(yyout);

    return 0;
}

/*  Initialize Symbol Table Entry Function
    Variable Definition:
    -- NULL
    Return Value: NULL
*/
void initializeSymbolTable(){
    int     count;      //index

    //Allocate space for identifier, number, and string table head node
    for (count = 0; count < TABLE_SIZE; count++){
        table_head[count] = (SYMBOL_TABLE*)malloc(sizeof(SYMBOL_TABLE));
        //Initialize lexeme buffer
        memset(table_head[count]->lexeme, 0, STRING_SIZE);
        //Initialize head node next pointer
        table_head[count]->next = NULL;
    }
    //Initialize head node lexeme
    strcpy(table_head[0]->lexeme, "ID");
    strcpy(table_head[1]->lexeme, "NUMBER");
    strcpy(table_head[2]->lexeme, "STRING");

    return;
}

/*  Clear Symbol Table Entry Function
    Variable Definition
    -- NULL
    Return Value: NULL
*/
void clearSymbolTable(){
    SYMBOL_TABLE    *node;      //_symbol_table structure node
    int             count;      //index

    for (count = 0; count < TABLE_SIZE; count++){
        //Set the node as the symbol table first element
        node = table_head[count]->next;
        //Deallocate all element in the link lists
        while (node != NULL){
            table_head[count]->next = node->next;
            free(node);
            node = table_head[count]->next;
        }
        //Deallocate the symbol table head node
        free(table_head[count]);
    }

    return;
}

/*  Install Symbol Table Function
    Variable Definition:
    -- NULL
    Return Value: NULL
*/
void installSymbolTable(){
    SYMBOL_TABLE    *node;          //_symbol_table structure node
    int             count;          //count
    int             index;          //index

    for (count = 0; count < TABLE_SIZE; count++){
        //Set the node as the symbol table first element
        node = table_head[count]->next;
        //Set the index variable
        index = 1;
        //Output the identifier, number, and string symbol table
        while (node != NULL){
            switch (count){
                case 0:
                    if (sprintf(attr_str, "<ID, %d>", index) == -1){
                        dieWithUserMessage("sprintf() failed", "<ID> symbol table entry!");
                    }
                    break;
                case 1:
                    if (sprintf(attr_str, "<NUMBER, %d>", index) == -1){
                        dieWithUserMessage("sprintf() failed", "<NUMBER> symbol table entry!");
                    }
                    break;
                case 2:
                    if (sprintf(attr_str, "<STRING, %d>", index) == -1){
                        dieWithUserMessage("sprintf() failed", "<STRING> symbol table entry!");
                    }
                    break;
                default:
                    break;
            }
            if (fprintf(yyout, "%20s    %15s\n", node->lexeme, attr_str) == -1){
                dieWithUserMessage("fprintf() failed", "symbol table write error");
            }
            node = node->next;
            index++;
        }
        fputc('\n', yyout);
    }

    return;
}

/*  Install Identifier Function
    Variable Definition:
    -- NULL
    Return Value: lexeme's index
*/
int installID(){
    SYMBOL_TABLE    *node;          //_symbol_table structure node
    int             count = 1;      //index

    //Set the node as the identifier symbol table head
    node = table_head[0];
    //First find whether the identifier is in symbol table
    while (node->next != NULL){
        node = node->next;
        if (strcmp(node->lexeme, yytext) == 0){
            return count;
        }
        //Increase the index
        count++;
    }
    //Second insert the new identifier in symbol table
    node->next = (SYMBOL_TABLE*)malloc(sizeof(SYMBOL_TABLE));
    node = node->next;
    memset(node->lexeme, 0, STRING_SIZE);
    strcpy(node->lexeme, yytext);
    node->next = NULL;

    return count;
}

/*  Install Number Function
    Variable Definition
    -- NULL
    Return Value: lexeme's index
*/
int installNumber(){
    SYMBOL_TABLE    *node;          //_symbol_table structure node
    int             count = 1;      //index

    //Set the node as the number symbol table head
    node = table_head[1];
    //Find the last element in symbol table
    while (node->next != NULL){
        node = node->next;
        //Increase the index
        count++;
    }
    //Insert the new number in symbol table
    node->next = (SYMBOL_TABLE*)malloc(sizeof(SYMBOL_TABLE));
    node = node->next;
    memset(node->lexeme, 0, STRING_SIZE);
    strcpy(node->lexeme, yytext);
    node->next = NULL;

    return count;
}

/*  Install String Function
    Variable Definition:
    -- NULL
    Return Value: lexeme's index
*/
int installString(){
    SYMBOL_TABLE    *node;          //_symbol_table structure node
    int             count = 1;      //index

    //Set the node as the string symbol table head
    node = table_head[2];
    //Find the last element in symbol table
    while (node->next != NULL){
        node = node->next;
        //Increase the index
        count++;
    }
    //Insert the new string in symbol table
    node->next = (SYMBOL_TABLE*)malloc(sizeof(SYMBOL_TABLE));
    node = node->next;
    memset(node->lexeme, 0, STRING_SIZE);
    strcpy(node->lexeme, yytext);
    node->next = NULL;

    return count;
}

/*  Install Token Name and Attribute Value Function
    Variable Definition:
    -- token: token name string
    -- attribute: attribute value string
    Return Value: NULL
*/
void installTokenNameAndAttribute(const char *token, const char *attribute){
    //Output the lexemes, token names, and attribute value to the file
    if (fprintf(yyout, "%20s    %20s    %15s", yytext, token, attribute) == -1){
        dieWithUserMessage("fprintf() failed", "Cannot write lexemes, token names, and attribute value to the file!");
    }

    return;
}

/*  User Error Message Function
    Variable Definition:
    -- message: summary of error message
    -- detail: detail error message based on error code
    Return Value: NULL
*/
void dieWithUserMessage(const char *message, const char *detail){
    fputs(message, stderr);
    fputs(": ", stderr);
    fputs(detail, stderr);
    fputc('\n', stderr);
    exit(1);
}

/*  System Error Message Function
    Variable Definition:
    -- message: summary of error message
    Return Value: NULL
*/
void dieWithSystemMessage(const char *message){
    perror(message);
    exit(1);
}

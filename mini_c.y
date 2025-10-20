%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex(); // Lexer function
void yyerror(const char *s);
%}

%union {
    int num;
    char* str;
}

%token DEFINE INCLUDE IF ELSE INT RETURN
%token PLUS MINUS MULT DIV ASSIGN
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON
%token <num> NUMBER
%token <str> IDENTIFIER HEADER_FILE
%token ERROR



%%

program:
    statements { printf("Success\n"); }
    ;

statements:
    statements statement
    | statement
    ;

statement:
    preprocessor
    | declaration
    | assignment
    | if_else
    | return_stmt
    ;

preprocessor:
    DEFINE IDENTIFIER NUMBER
    | INCLUDE HEADER_FILE
    ;



declaration:
    INT IDENTIFIER SEMICOLON
    ;

assignment:
    IDENTIFIER ASSIGN expression SEMICOLON
    ;

if_else:
    IF LPAREN condition RPAREN LBRACE statements RBRACE
    | IF LPAREN condition RPAREN LBRACE statements RBRACE ELSE LBRACE statements RBRACE
    ;

return_stmt:
    RETURN expression SEMICOLON
    ;

expression:
    expression PLUS term
    | expression MINUS term
    | term
    ;

term:
    term MULT factor
    | term DIV factor
    | factor
    ;

factor:
    NUMBER
    | IDENTIFIER
    | LPAREN expression RPAREN
    ;

condition:
    expression
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Failure: %s\n", s);
}

int main() {
    yyparse();
    return 0;
}

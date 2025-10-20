%{
#include "mini_c.tab.h"
#include <stdio.h>
#include <string.h>
%}

%option noyywrap

DIGIT   [0-9]+
ID      [a-zA-Z_][a-zA-Z0-9_]*
HEADER  "<"[a-zA-Z0-9_/.]+">"
COMMENT_SINGLE "//".*
COMMENT_MULTI  "/*"[^*]*"*"*([^*/][^*]*"*"*)*"*/"
WHITESPACE     [ \t\r\n]+

%%

"#define"       { return DEFINE; }
"#include"      { return INCLUDE; }

{COMMENT_SINGLE} { /* Ignore */ }
{COMMENT_MULTI}  { /* Ignore */ }
{WHITESPACE}     { /* Ignore */ }

"if"           { return IF; }
"else"         { return ELSE; }
"int"          { return INT; }
"return"       { return RETURN; }

"+"            { return PLUS; }
"-"            { return MINUS; }
"*"            { return MULT; }
"/"            { return DIV; }
"="            { return ASSIGN; }

"("            { return LPAREN; }
")"            { return RPAREN; }
"{"            { return LBRACE; }
"}"            { return RBRACE; }
";"            { return SEMICOLON; }

{DIGIT}        { yylval.num = atoi(yytext); return NUMBER; }
{ID}           { yylval.str = strdup(yytext); return IDENTIFIER; }
{HEADER}       { yylval.str = strdup(yytext); return HEADER_FILE; }

.              { printf("Invalid character: %s\n", yytext); return ERROR; }

%%

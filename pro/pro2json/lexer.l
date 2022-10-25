%{
// filename: lexer.l
#include "parser.h"
#include <string.h>

extern void yyerror(const char * message);
#define ECHO fwrite( yytext, yyleng, 1, yyout )

%}

%option noyywrap
EXP ([Ee][-+]?[0-9]+)

%%

"{" { ECHO; return LCURLY; }
"}" { ECHO; return RCURLY; }
"[" { ECHO; return LBRAC; }
"]" { ECHO; return RBRAC; }
"," { ECHO; return COMMA; }
":" { ECHO; return COLON; }
"true" { ECHO; return VTRUE; }
"false" { ECHO; return VFALSE; }
"null" { ECHO; return VNULL; }
[ \t\r\n]+ { /* eat whitespace */ }
\"[^"]*\" { yylval.string = strdup(yytext); ECHO; return STRING; }
[1-9]+"."?[0-9]*{EXP}? { ECHO; yylval.decimal = atof(yytext); return DECIMAL; }

%%

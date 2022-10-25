%{
// filename: lexer.l
#include "parser.h"
#include <string.h>

extern void yyerror(const char * message);
#define ECHO fwrite( yytext, yyleng, 1, yyout )

%}

%option noyywrap

letter	[A-Za-z]
digit	[0-9]

/*" "	{ ECHO; return SINGLESPACE;}*/
/*
"true" { ECHO; return VTRUE; }
"false" { ECHO; return VFALSE; }
*/

%%

"<" { ECHO; return LANGLE; }
">" { ECHO; return RANGLE; }
({letter})({letter}|{digit})* { ECHO; return NAME; }
"{" { ECHO; return LCURLY; }
"}" { ECHO; return RCURLY; }
\"[^"]*\" { yylval.string = strdup(yytext); ECHO; return STRING; }
[A-Za-z]+ { ECHO; return KEYNAME; }
[ \t\n]+ { /* eat whitespace */ }

%%

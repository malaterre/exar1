%{
// filename: lexer.l
#include "parser.h"
#include <string.h>

extern void yyerror(const char * message);
#define ECHO fwrite( yytext, yyleng, 1, yyout ); putc( '\n', yyout )

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
"{" { ECHO; return LCURLY; }
"}" { ECHO; return RCURLY; }
"." { ECHO; return DOT; }
({letter})({letter}|{digit})* { ECHO; return NAME; }
\"[^"]*\" { yylval.string = strdup(yytext); ECHO; return STRING; }
[1-9]+\.?[0-9]* { ECHO; return DECIMAL; }
[ \t\n]+ { /* eat whitespace */ }

%%

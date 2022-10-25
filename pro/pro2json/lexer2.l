%{
// filename: lexer2.l
#include "parser2.h"
#include <string.h>

extern void yyerror(const char * message);
#define ECHO fwrite( yytext, yyleng, 1, yyout ); putc( '\n', yyout )

%}

%option noyywrap

upper	[A-Z]
lower	[a-z]
letter	[A-Za-z]
digit	[0-9]

e1      "### ASCCONV BEGIN "
e2      " ###"
e3	"### ASCCONV END ###"
 /* this one starts with double underscore */
e4	"__attribute__.size"
 /* most starts with lower case, except: MaxOnlineTxAmpl, CompProtectionValues ... */
e8	{letter}({letter}|{digit}|_)+

%%

"=" 					{ ECHO; return EQUAL; }
({e8}(\[{digit}+\])?[.]?)+{e4}?		{ ECHO; return NAME; }
\"[^"]+\"				{ yylval.string = strdup(yytext);
                                          ECHO; return STRING; }
([1-9][0-9]*)?[0-9](\.[0-9]*)? 		{ ECHO; return DECIMAL; }
0x[0-9]+				{ ECHO; return HEX; }
{e1}[^#]+{e2}				{ ECHO; return HEADER; }
{e3}					{ ECHO; return FOOTER; }
[ \t\n]+ { /* eat whitespace */ }

%%

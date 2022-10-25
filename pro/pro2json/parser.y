%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylineno;
extern char* yytext;
int yylex();
void yyerror(const char *s);

// gives good debug information
int yydebug=1;

%}

%token LCURLY RCURLY LANGLE RANGLE NAME DOT
%token DECIMAL
%token <string> STRING;

%union {
  char *string;
}

%start xprotocol

%%

xprotocol:
    | entry
    ;

value: entry
     | STRING
     | DECIMAL
     | array
     ;

entry: LANGLE NAME RANGLE value
     | LANGLE NAME DOT STRING RANGLE value
     ;

array: LCURLY RCURLY
     | LCURLY values RCURLY
     ;

values: value
      | values value
      ;

%%

void
yyerror(const char *s)
{
  fprintf(stderr,"error: %s on line %d\n", s, yylineno);
}

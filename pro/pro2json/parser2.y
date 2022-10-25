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

%token NAME EQUAL HEADER FOOTER HEX
%token DECIMAL
%token <string> STRING;

%union {
  char *string;
}

%start ascconv

%%

ascconv: HEADER entries FOOTER
    ;

entries: entry
        | entries entry
        ;

entry: NAME EQUAL value
     ;

value: STRING
      | DECIMAL
      | HEX
      ;

%%

void
yyerror(const char *s)
{
  fprintf(stderr,"error: %s on line %d\n", s, yylineno);
}

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

%token LCURLY RCURLY LANGLE RANGLE SINGLESPACE ENDOFLINE KEYNAME NAME
%token VTRUE VFALSE
%token <string> STRING;

%union {
  char *string;
}

%start xprotocol

%%

xprotocol:
    | entry
    ;

entry: LANGLE NAME RANGLE value

value: object
     | STRING
     ;

object: LCURLY RCURLY
      | LCURLY members RCURLY
      ;

members: member
       | members ENDOFLINE member
       ;

member: LANGLE KEYNAME RANGLE value
      ;

%%

void
yyerror(const char *s)
{
  fprintf(stderr,"error: %s on line %d\n", s, yylineno);
}

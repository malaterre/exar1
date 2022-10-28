/* parser2.y */

/* a "pure" api means communication variables like yylval
   won't be global variables, and yylex is assumed to
   have a different signature */

/*%define api.pure true*/

/* change prefix of symbols from yy to "lisp" to avoid
   clashes with any other parsers we may want to link */

/*%define api.prefix {asc}*/

/* generate much more meaningful errors rather than the
   uninformative string "syntax error" */

%define parse.error verbose

%code top {

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// gives good debug information
int yydebug=1;
}

%code requires {

extern int yylineno;
extern char* yytext;
int yylex();
void yyerror(const char *s);
}

/* These are the semantic types available for tokens,
   which we name num, str, and node.

   The %union construction is classic yacc as well. It
   generates a C union and sets its as the YYSTYPE, which
   will be the type of yylval */
%union {
  char *string;
}


/* Now when we declare tokens, we add their type
   in brackets. The type names come from our %union */

%token NAME EQUAL HEADER FOOTER
%token DECIMAL HEX
%token <string> STRING;


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

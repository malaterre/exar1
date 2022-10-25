#include <stdio.h>
#include <stdlib.h>
#include "parser.h"

extern FILE* yyin;

int
main(int argc, char *argv[])
{
  // if a file is given read from it
  // otherwise we'll read from STDIN
  if(argc == 2)
  {
    if(!(yyin = fopen(argv[1],"r")))
    {
      perror(argv[1]);
      return EXIT_FAILURE;
    }
  }
  return yyparse();
}

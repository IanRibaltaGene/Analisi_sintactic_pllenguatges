        /************************************************/
        /*              ESPECIFICACIO YACC              */
        /************************************************/

%{
    #include <stdio.h>
	#include<ctype.h>

    #define NUL 0
    
	
    extern int line_number;
    extern int yylex();
    extern FILE * yyin;
    
    void yyerror (char const *);
}%
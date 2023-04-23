        /************************************************/
        /*              ESPECIFICACIO YACC              */
        /************************************************/

%{
    #include <stdio.h>
	#include<ctype.h>

    #define NUL 0
    
	
    extern int nlin;
    extern int yylex();
    extern FILE * yyin;
    
    void yyerror (char const *);
}%

%start 


%left IMPL DUBL /* associativitat, implicacio i doble implicacio */
%left OR /* disjunció */
%left AND /* conjunció */
%right NEG /* negació */
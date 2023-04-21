        /*************************************************/
        /*               ESPECIFICACIO LEX               */
        /*************************************************/

%{
	#include "picosat.tab.h"
	int nlin=1;
%}

%array
%option nounput
%option noinput
%option noyywrap


%%
[ \t]+        ;

^"c".*\n         nlin++;   /* Ignora comentaris, però comptar línia */

\n             nlin++;          /* comptar línies */    

"p"             return P;   /* paraula reservada */

"cnf"           return CNF;   /* paraula reservada */

"-"             return NEG;   /* paraula reservada */

0                   return FINAL;   /* token sincronització */

[0-9]+                          {	yylval.valor=atoi(yytext);
                               	 	 return(INT);
                                }

.                     		 {	return(yytext[0]);	}	/*  Els errors es processaran a nvell sintàctic */



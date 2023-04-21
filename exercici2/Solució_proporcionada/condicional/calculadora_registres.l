        /*************************************************/
        /*               ESPECIFICACIO LEX               */
        /*************************************************/

%{
	#include "calculadora_registres.tab.h"
	int nlin=1;
%}

%array
%option nounput
%option noinput
%option noyywrap


%%
[ \t]+                          ;

"//".*\n                nlin++;         /* Ignora comentaris, però comptar línia */

\n                      nlin++;          /* comptar línies */

[a-z]                 {	yylval.reg=yytext[0]-'a'; 		// definim registres amb noms a-z
                        return(REG);
                        }

"<="                return MEI; //Operadors relacionals
">="                return MAI;
"=="                return IG;
"!="                return DIF;

"&&"                return AND; //Operadors lògics
"||"                return OR;

"<<"                return DE;  //Operadors desplaçament bit
">>"                return DD;

[0-9]+                          {	yylval.valor=atoi(yytext);
                               	 	 return(INT);
                                }

\n                             {	nlin++;
                                }

.                     		 {	return(yytext[0]);	}	/*  Els errors es processaran a nvell sintàctic */



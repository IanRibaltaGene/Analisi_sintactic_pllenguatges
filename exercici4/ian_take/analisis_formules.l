        /*************************************************/
        /*               ESPECIFICACIO LEX               */
        /*************************************************/


%{
	#include "analisis_formules.tab.h"
	int line_number=1;
%}

%array
%option nounput
%option noinput
%option noyywrap
%x COMMENT

separador ","
variable [x-z][1-9]
constant [a-c][1-9]
%%

[ \t]+                  /* ignorar espais blancs i tabs */ 

	/* Comentaris, incrementa line_number */
"//"			{ BEGIN COMMENT; }
<COMMENT>\n		{ line_number++; 
				BEGIN 0; }
<COMMENT>.

{variable}              { return VAR;    } /* match variable */
{constant}		{ return CONS;	 } /* match constant */
[P-T][1-9]		{ return PRED;   } /* match predicats */
[f-g][1-9]		{ return FUNC;	 } /* match funcions */

\!                      { return NEG;    } /* match negat */
"^"                    { return CONJ;   } /* match conj */
"v"                    { return DISJ;   } /* match disj */
"->"                    { return IMP;    } /* match imp */
"<->"                   { return DIMP;   } /* match doble imp */

"forAll"		{ return FORALL; } /* match forall */
"exists"		{ return EXISTS; } /* match exists */

"("                      { return yytext[0];    } /* match parentesis esquerra */ 
")"                      { return yytext[0];    } /* match parentesis dreta */
{separador}				{ return yytext[0];    } /* match separator */

\n                      { line_number++;
						return NEWLINE; } /* match newline, incrementa line_number i retorna separador de clausules */
.                       {return yytext[0];} /* match tota la resta de caracters */

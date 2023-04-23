        /*************************************************/
        /*               ESPECIFICACIO LEX               */
        /*************************************************/

%{
	#include "eliminar_implicacions.tab.h"
	int nlin=1;
%}

%array
%option nounput
%option noinput
%option noyywrap
%x COMMENT

%%

[ \t]+                  /* ignorar espais blancs i tabs */ 

	/* Comentaris, incrementa line_number */
"#"				{ BEGIN COMMENT; }
<COMMENT>\n		{ nlin++; 
			    BEGIN 0; }
<COMMENT>. ;

[A-Z]                   { return VAR;    } /* match variable */
\!                      { return NEG;    } /* match negat */
\&\&                    { return CONJ;   } /* match conj */
\|\|                    { return DISJ;   } /* match disj */
"->"                    { return IMP;    } /* match imp */
"<->"                   { return DIMP;   } /* match doble imp */
\n                      { nlin++; } /* match newline, incrementa line_number */
.                       { return yytext[0]; } /* match qualsevol altre caracter */

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

[ \t]+        ;           /* ignorar espais blancs i tabs */ 

	/* Comentaris, incrementa line_number */
"#"				{ BEGIN COMMENT; }
<COMMENT>\n		{ nlin++; 
			    BEGIN 0; }
<COMMENT>. ;

[A-Z]                   { yylval.var= yytext[0]-'A';
						return VAR;    } /* match variable */
"!"                     { return NEG;    } /* match negat */
"^"                    { return AND;   } /* match conj */
"v"                    { return OR;   } /* match disj */
"->"                    { return IMPL;    } /* match imp */
"<->"                   { return DUBL;   } /* match doble imp */
\n                      { nlin++;
						return FIN; } /* match newline, incrementa nlin i retorna final de clausula */
.                       { return yytext[0]; } /* match qualsevol altre caracter */

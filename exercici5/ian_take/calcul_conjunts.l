        /*************************************************/
        /*               ESPECIFICACIO LEX               */
        /*************************************************/

%{
	#include "calcul_cojunts.tab.h"
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
"//"				{ BEGIN COMMENT; }
<COMMENT>\n		{ nlin++; 
			    BEGIN 0; }
<COMMENT>. ;

[A-Z]                   { yylval.var = yytext[0] -'A';
						return CONST;    } /* match constructor */
[a-z]                   { yylval.var = yytext[0] - 'a';
						return TERM;    } /* match terminals */
":"                     { return PROD;    } /* match producció */
"|"                     { return ALTER;   } /* match alternativa */
";"                     { return FIN;   } /* match final producció */
<<EOF>>       			{return END_OF_FILE;}
\n                      { nlin++; } /* incrementa nlin */
.                       { return yytext[0]; } /* match qualsevol altre caracter */

        /************************************************/
        /*              ESPECIFICACIO YACC              */
        /************************************************/

	
		
%{
	#include<stdio.h>
	#include<ctype.h>
    
    #define NUL 0
    
    int regs[26]={0};
	
    extern int nlin;
    extern int yylex();
    extern FILE * yyin;
    
    void yyerror (char const *);
    
%}
	

%start calculadora

%union{	int valor;
        bool logic;
		int reg;
        void *sense;
		}

%token <reg> REG
%token <valor> INT

%left OR           /* OR lògic */
%left AND           /* AND lògic */
%left '!'           /* Not lògic */
%left '|'           /* OR bit a bit */
%left '^'           /* ^XOR bit a bit */
%left '&'           /* AND bit a bit */
%right '~'          /* Complement a u */
%left IG DIF
%left '<' '>' MEI MAI
%left DE DD         /* precedencia dels operadors desplaçament  bit */
%left '+' '-'       /* Binaris */
%left '*' '/' '%'
%left UMENYS   UMES     /* precedencia dels operadors unaris + i -  */


%type <valor> expr
%type <sense> sentencia calculadora sent_cond
%type <logic> exp_lo aux1 aux2 aux

%%

calculadora	:       {$$=NUL;}
            |       calculadora sentencia   {$$=NUL;}
            ;

sentencia:  ';'                {$$=NUL;}
        |   expr ';'           {fprintf(stdout,"%i \n", $1);}
        |   REG '=' expr ';'   {regs[$1] = $3;
                                $$=NUL;}
        |   '(' exp_lo ')' '?' aux1 sent_cond ':' aux2 sent_cond ';'    { $$=NUL; }

        |   error ';'        {fprintf(stderr,"ERROR EXPRESSIO INCORRECTA Línea %d \n", nlin);
                              yyerrok;}
        ;

sent_cond:   aux expr           { if ($1) fprintf(stdout,"%i \n", $2);
                                 $$=NUL;}
        |    aux REG '=' expr    { if ($1) regs[$2] = $4;
                                $$=NUL;}
        ;

aux:  { $$=$<logic>0;   }
    ;

aux1:       {   $$=$<logic>-2; }        // avaluació del IF quan condició es certa
        ;

aux2:       {   $$=!($<logic>-5); }       // avaluació del ELSE quan condició es falsa
        ;

expr  :        '(' expr ')'             {$$ = $2;}
      |        expr '+' expr            {$$ = $1 + $3;}
      |        expr '-' expr            {$$ = $1 - $3;} 
      |        expr '*' expr            {$$ = $1 * $3;}
      |        expr '/' expr            {if ($3)
                                          $$ = $1 / $3;
                                         else
                                          {fprintf(stderr,"Divisio per zero \n");
                                           YYERROR;}
                                          }
    |       expr '%' expr           {$$ = $1 % $3;}
    |       '-' expr %prec UMENYS   {$$ = -$2;}
    |       '+' expr %prec UMENYS   {$$ = $2;}
    |       expr DE expr           {$$ = $1 << $3;}
    |       expr DD expr           {$$ = $1 >> $3;}
    |       '~' expr               {$$ = ~$2;}
    |       expr '&' expr           {$$ = $1 & $3;}
    |       expr '^' expr           {$$ = $1 ^ $3;}
    |       expr '|' expr           {$$ = $1 | $3;}
    |       REG                     {$$ = regs[$1];}
    |       INT                      {$$ = $1;}
    ;

exp_lo :    exp_lo AND exp_lo       {$$ = $1 && $3;}
        |   exp_lo OR exp_lo        {$$ = $1 || $3;}
        |   '!'exp_lo               {$$ = !$2;}
        |   '('exp_lo ')'           {$$ = $2;}
        |   expr '<' expr           {$$ = $1 < $3;}
        |   expr '>' expr           {$$ = $1 > $3;}
        |   expr MEI expr           {$$ = $1 <= $3;}
        |   expr MAI expr           {$$ = $1 >= $3;}
        |   expr IG expr            {$$ = $1 == $3;}
        |   expr DIF expr           {$$ = $1 != $3;}
        ;

%%

// Called by yyparse on error

void yyerror (char const *s){
    fprintf (stderr, "%s\n", s);
}

int main( int argc, char *argv[] ) {
    if (argc>2)
    fprintf(stderr,"Error, ús: decla [file] \n");
    else{
        if (argc==2){
            yyin = fopen( argv[ 1 ], "r" );
            if ( yyin == NULL ){
                fprintf(stderr,"Error fitxer entrada %s \n", argv[ 1 ]);
                return(1);
            }
        }
        if (yyparse()==0){
            for (int i=0; i<26; i++)
            if (regs[i]!=0)
            printf("%c = %d \n", 'a'+i, regs[i]);
            return(0);
        }
        else {
            fprintf(stderr,"Acabament fitxer inesperad Línea %d \n", nlin);
            return(1);
        }
    }
}


        /************************************************/
        /*              ESPECIFICACIO YACC              */
        /*          Notació CNF DIMACS                  */
        /************************************************/

	
		
%{
	#include<stdio.h>
	#include<ctype.h>
    
    #define NUL 0
    
	
    extern int nlin;
    extern int yylex();
    extern FILE * yyin;
    
    void yyerror (char const *);
    
    int num_vari;
    int num_clau_def;
    int num_clau_prog=0;
    bool ok=true;
    
%}
	

%start programa

%union{	int valor;
        void *sense;
		}

%token P CNF NEG FINAL
%token <valor> INT


%type <sense> programa ll_clausules capcalera clausula ll_literals literal variable


%%

programa	:       { $$=NUL; }
            |       capcalera ll_clausules   { $$=NUL; }
            ;

ll_clausules:  clausula                {$$=NUL;}
        |   ll_clausules clausula       {$$=NUL;}
        ;

capcalera: P CNF INT INT   {    num_vari=$3;
                                num_clau_def=$4;
                                $$=NUL;
                            }
        ;

clausula:  ll_literals FINAL     { num_clau_prog++;
                                    $$=NUL;
                                }
        | error FINAL       { fprintf(stderr,"ERROR CLÀUSULA INCORRECTA Línea %d \n", nlin);
                              ok=false;
                              yyerrok;}
        ;

ll_literals: literal  {$$=NUL;}
        | ll_literals literal   {$$=NUL;}
        ;

literal: variable   {$$=NUL;}
        | NEG variable   {$$=NUL;}
        ;

variable: INT   { if ($1>num_vari){
                        fprintf(stderr,"Variable num. %i no definida\n", $1);
                        ok=false;
                        YYERROR;
                    }else{
                        $$=NUL;
                    }
                }
        ;

%%

// Called by yyparse on error

void yyerror (char const *s){
    fprintf (stderr, "%s\n", s);
}

int main( int argc, char *argv[] ) {
    if (argc>2){
      fprintf(stderr,"Error, ús: picosat [file] \n");
      return(1);
    }else if (argc==2){
            yyin = fopen( argv[ 1 ], "r" );
            if ( yyin == NULL ){
                fprintf(stderr,"Error fitxer entrada %s \n", argv[ 1 ]);
                return(1);
            }
        }
    if (yyparse()==0){
                if (ok){
                    if (num_clau_prog==num_clau_def){
                    printf("Especificació correcta!\n");
                    return(0);
                    }else if (num_clau_prog>num_clau_def){
                        fprintf(stderr,"Sobren %d clàusules\nEspecificació INCORRECTA!!\n", num_clau_prog-num_clau_def);
                        return(1);
                        }else{
                            fprintf(stderr,"Falten %d clàusules\nEspecificació INCORRECTA!!\n", num_clau_def-num_clau_prog);
                            return(1);
                        }
            }else{
                 printf("Especificació INCORRECTA!!\n");
                 return(1);
            }
        }else {
                fprintf(stderr,"Especificació INCORRECTA!\nAcabament fitxer inesperad Línea %d \n", nlin);
                return(1);
        }
}


    /*************************************************/
    /*               ESPECIFICACIO YACC               */
    /*************************************************/

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <ctype.h>

    #define NUL 0

    extern int nlin;
    extern int yylex();
    extern FILE * yyin;

    void yyerror(const char *s);

    char c;

%}

%start starter

%union {
    char str[1000];
    char var; 
    void *sense; 
}

%token <var> VAR
%token FIN
%left IMPL DUBL /* implication and iff */
%left OR /* disjunction */
%left AND /* conjunction*/
%right NEG /* negation*/

%type <sense> starter formula
%type <str> clause expr

%%
starter : {$$=NUL;}
        | starter formula {$$=NUL;}
        ;
formula : FIN                   {$$ = NUL;}
        | clause FIN            { printf("Formula without implications and iff: %s\n", $1);
                                $$ = NUL; }
        | error FIN             { fprintf(stderr,"ERROR EXPRESSIO INCORRECTA Línea %d \n", nlin);
                                yyerrok; }
        ;

clause  : expr                  { strcpy($$, $1); }
        | clause AND expr       { strcpy($$, "(");
                                 strcat($$, $1);
                                 strcat($$, " ^ ");
                                 strcat($$, $3);
                                 strcat($$, ")");}
        | clause OR expr        {strcpy($$, "("); 
                                 strcat($$, $1); 
                                 strcat($$, " v ");
                                 strcat($$, $3);
                                 strcat($$, ")");}
        | clause IMPL expr      { strcpy($$, "!");
                                 strcat($$, $1);
                                 strcat($$, " v ");
                                 strcat($$, $3);}
        | clause DUBL expr      { strcpy($$, "(!");
                                 strcat($$, $1);
                                 strcat($$, ")");
                                 strcat($$, " v ");
                                 strcat($$, $3);
                                 strcat($$, " ^ ");
                                 strcat($$, "(!");
                                 strcat($$, $3);
                                 strcat($$, " v ");
                                 strcat($$,$1);
                                 strcat($$, ")");}
        ;

expr    : VAR                   { c = $1+'A';
                                strcpy($$, "(");
                                strcat($$, &c);
                                strcat($$, ")");}
        | NEG expr %prec NEG    { strcpy($$,"(!");
                                strcat($$,$2);
                                strcat($$,")"); }
        | '(' clause ')'        { strcpy($$, "(");
                                strcat($$,$2);
                                strcat($$,")"); }
        ;

%%
void yyerror(const char *s) {
    fprintf(stderr, "Error in line %d: %s\n", nlin, s);
}

int main(int argc, char **argv) {
    FILE *input;

    if (argc != 2) {
        printf("Usage: %s input_file\n", argv[0]);
        exit(1);
    }

    input = fopen(argv[1], "r");
    if (input == NULL) {
        printf("Error: Cannot open input file %s\n", argv[1]);
        exit(1);
    }

    yyin = input;

    yyparse();

    fclose(input);

    return 0;
}
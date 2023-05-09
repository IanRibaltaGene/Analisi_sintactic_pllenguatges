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

%type <sense> starter formula formulas
%type <str> clause expr

%%
starter : {$$=NUL;}
        | formulas {$$=NUL;}
        ;

formulas: formula              { $$=NUL; }
        | formulas formula FIN    { $$=NUL; }
        ;

formula : ';'                   {$$ = NUL;}
        | clause ';'        { printf("Formula without implications and iff: %s\n", $1);
                                $$ = NUL; }
        | error FIN             { yyerrok; }
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
                                 strcat($$, "(");
                                 strcat($$, $1);
                                 strcat($$, ")");
                                 strcat($$, " v ");
                                 strcat($$, "(");
                                 strcat($$, $3);
                                 strcat($$, ")");}
        | clause DUBL expr      { strcpy($$, "(");
                                 strcat($$, "!");
                                 strcat($$, $1);
                                 strcat($$, " v ");
                                 strcat($$, $3);
                                 strcat($$, ")");
                                 strcat($$, " ^ ");
                                 strcat($$, "(");
                                 strcat($$, "!");
                                 strcat($$, $3);
                                 strcat($$, " v ");
                                 strcat($$,$1);
                                 strcat($$, ")");}
        ;

expr    : VAR                   { c = $1+'A';
                                strcpy($$, &c);}
        | NEG expr %prec NEG    { strcpy($$,"!");
                                strcat($$,$2); }
        | '(' clause ')'        { strcpy($$, "(");
                                strcat($$,$2);
                                strcat($$,")"); }
        ;

%%
void yyerror(const char *s) {
    fprintf(stderr, "Error a la línea %d: %s\n", nlin, s);
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
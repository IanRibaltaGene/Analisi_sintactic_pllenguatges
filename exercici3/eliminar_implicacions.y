    /*************************************************/
    /*               ESPECIFICACIO YACC               */
    /*************************************************/

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <ctype.h>

    extern int nlin;
    extern int yylex();
    extern FILE * yyin;

    void yyerror(const char *s);

    char c;

%}

%start formula

%union {
    char str[1000];
    char var;
}

%token <var> VAR
%token FIN
%left IMPL DUBL /* implication and iff */
%left OR /* disjunction */
%left AND /* conjunction*/
%right NEG /* negation*/

%type <str> formula clause expr

%%
formula : clause FIN            { printf("Formula without implications and iff: %s\n", $1); }
        | error FIN             { fprintf(stderr,"ERROR EXPRESSIO INCORRECTA  %s \n", $1);
                                yyerrok; }
        ;

clause  : expr                  { strcpy($$, $1); }
        | clause AND expr       { strcpy($$, $1);
                                 strcat($$, " && ");
                                 strcat($$, $3);}
        | clause OR expr        { strcpy($$, $1); 
                                 strcat($$, " || ");
                                 strcat($$, $3);}
        | clause IMPL expr      { strcpy($$, "!");
                                 strcat($$, $1);
                                 strcat($$, " || ");
                                 strcat($$, $3);}
        | clause DUBL expr      { strcpy($$, "(!");
                                 strcat($$, $1);
                                 strcat($$, ") ");
                                 strcat($$, " || ");
                                 strcat($$, $3);
                                 strcat($$, " && ");
                                 strcat($$, "(!");
                                 strcat($$, $3);
                                 strcat($$, " || ");
                                 strcat($$,$1);
                                 strcat($$, ") ");}
        ;

expr    : VAR                   { c = $1+'A';
                                strcpy($$, &c); }
        | NEG expr %prec NEG    { strcpy($$,"!( ");
                                strcat($$,$2);
                                strcat($$,") "); }
        | '(' clause ')'        { strcpy($$, "(");
                                strcat($$,$2);
                                strcat($$,") "); }
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
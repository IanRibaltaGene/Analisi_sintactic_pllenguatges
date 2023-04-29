    /*************************************************/
    /*               ESPECIFICACIO YACC               */
    /*************************************************/

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <ctype.h>

    void yyerror(const char *s);
    int yylex();
    void elimina_implicacions();

    typedef struct {
        char* name;
        int value;
    } Var;

    Var vars[100];
    int num_vars = 0;

%}

%start formula

%union {
    int value;
}

%token VAR FIN
%left IMPL DUBL /* implication and iff */
%left OR /* disjunction */
%left AND /* conjunction*/
%right NEG /* negation*/

%type <value> formula clause expr

%%
formula : clause FIN            { printf("Formula without implications and iff: %d\n", $1); }
        | error FIN             { fprintf(stderr,"ERROR EXPRESSIO INCORRECTA Línea %d \n", nlin);
                                yyerrok; }
        ;

clause  : expr                  { $$ = $1; }
        | clause AND expr       { $$ = $1 && $3; }
        | clause OR expr        { $$ = $1 || $3; }
        | clause IMPL expr      { $$ = !$1 || $3; }
        | clause DUBL expr      { $$ = (!$1 || $3) && (!$3 || $1); }
        ;

expr    : VAR                   { $$ = get_var($1); }
        | NEG expr %prec NEG    { $$ = !($2); }
        | '(' clause ')'        { $$ = $2; }
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

int get_var(char* name) {
        for (int i = 0; i < num_vars; i++) {
            if (strcmp(vars[i].name, name) == 0) {
                return vars[i].value;
            }
        }

        yyerror("Undefined variable");
        return 0;
}
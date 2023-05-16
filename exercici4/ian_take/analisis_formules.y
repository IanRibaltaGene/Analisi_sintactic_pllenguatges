        /************************************************/
        /*              ESPECIFICACIO YACC              */
        /************************************************/

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include <string.h>

    #define NUL 0

    extern FILE * yyin;

    extern int line_number;

    void yyerror(const char *s);
    extern int yylex();
    extern int yyparse();
%}

%start program

%union {
    char val;
    void *sense;
}

%token <val> VAR CONS PRED FUNC
%token NEWLINE

%type <sense> program input fbf formula atomic_formula quantified_formula terms term

%left IMP DIMP
%left DISJ
%left CONJ
%right FORALL EXISTS
%right NEG


%%

program: { $$ = NUL;}
       | input { $$ = NUL;}
       ;

input: fbf { $$ = NUL;}
     | input fbf { $$ = NUL;}
     ;

fbf: formula NEWLINE { $$ = NUL; fprintf(stdout, "Línia %d: Formula fbf correcta\n", line_number);}
   | NEWLINE { $$ = NUL;}
   | error NEWLINE { yyerrok;
                    $$ = NUL;}
   ;

formula: atomic_formula { $$ = NUL;}
       | NEG formula { $$ = NUL;}
       | quantified_formula { $$ = NUL;}
       | '(' formula ')' { $$ = NUL;}
       | formula CONJ formula { $$ = NUL;}
       | formula DISJ formula { $$ = NUL;}
       | formula IMP formula { $$ = NUL;}
       | formula DIMP formula { $$ = NUL;}
       ;

atomic_formula: PRED '(' terms ')' { $$ = NUL;}
              ;

quantified_formula: FORALL VAR formula %prec FORALL { $$ = NUL;}
                  | EXISTS VAR formula %prec EXISTS { $$ = NUL;}
                  ;

terms: { $$ = NUL;}
     | term { $$ = NUL;}
     | terms ',' term { $$ = NUL;}
     ;

term: VAR { $$ = NUL;}
    | CONS { $$ = NUL;}
    | FUNC '(' terms ')' { $$ = NUL;}
    ;


%%

void yyerror(const char *s) {
    fprintf(stderr, "Error a la línia %d: %s\n", line_number, s);
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Ús: %s filename\n", argv[0]);
        return 1;
    }

    FILE *input_file = fopen(argv[1], "r");

    if (input_file == NULL) {
        perror("Error obrint el fitxer");
        return 1;
    }

    yyin = input_file;

    yyparse();

    fclose(input_file);

    return 0;
}

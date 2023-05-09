        /************************************************/
        /*              ESPECIFICACIO YACC              */
        /************************************************/

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include <string.h>

    #define NUL 0

    #define YYSTYPE char*
    #define MAX_LINE_LENGTH 1000

    extern FILE * yyin;

    extern int line_number;

    void yyerror(const char *s);
    extern int yylex();
    extern int yyparse();
%}

%start input

%union {
    char val;
    void *sense;
}

%token <val> VAR CONS PRED FUNC
%token NEG CONJ DISJ IMP DIMP
%token FORALL EXISTS
%token NEWLINE

%left NEG
%right FORALL EXISTS
%left CONJ
%left DISJ
%left IMP DIMP

%type <sense> input formula atomic_formula quantified_formula terms term

%%

input: { $$ = NUL; }
     | input formula NEWLINE { $$ = NUL;}
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

quantified_formula: FORALL VAR formula { $$ = NUL;}
                  | EXISTS VAR formula { $$ = NUL;}
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
    fprintf(stderr, "Error a la linea %d: %s\n", line_number, s);
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

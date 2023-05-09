        /************************************************/
        /*              ESPECIFICACIO YACC              */
        /************************************************/

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include<ctype.h>
    #include <string.h>

    #define NUL 0

    #define YYSTYPE char*
    #define MAX_LINE_LENGTH 1000

    extern FILE * yyin;

    extern int line_number;

    void yyerror(const char *s);
    extern int yylex();
    extern int yyparse();
}%

%union {
    char *val;
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

%start input

%%

input: %empty
     | input formula NEWLINE
     | input NEWLINE
     ;

formula: atomic_formula
       | NEG formula
       | quantified_formula
       | '(' formula ')'
       | formula CONJ formula
       | formula DISJ formula
       | formula IMP formula
       | formula DIMP formula
       ;

atomic_formula: PRED '(' terms ')'
              ;

quantified_formula: FORALL VAR formula
                  | EXISTS VAR formula
                  ;

terms: %empty
     | term
     | terms ',' term
     ;

term: VAR
    | CONS
    | FUNC '(' terms ')'
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

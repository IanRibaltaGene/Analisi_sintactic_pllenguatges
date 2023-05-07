    /*************************************************/
    /*               ESPECIFICACIO YACC               */
    /*************************************************/

%{
    #include <stdio.h>
    #include <stdbool.h>
    #include <string.h>
    #include <ctype.h>
    #include <stdlib.h>

    #define MAX_CONSTRUCTORS 26
    #define MAX_TERMINALS 26

    #define NUL 0

    bool firstSets[MAX_CONSTRUCTORS][MAX_TERMINALS];
    bool processed[MAX_CONSTRUCTORS];
    bool dependency[MAX_CONSTRUCTORS][MAX_CONSTRUCTORS];

    extern int nlin;
    extern int yylex();
    extern FILE * yyin;

    int constructorTemp;
    int order[MAX_CONSTRUCTORS] = {0};
    int orderIndex = 0;
        // Constructors [A...Z]
        // Terminals [a...z]
        // Constructors x (Terminals U Constructors) -> Booleans

    char c;

    void yyerror(const char* message);
    void initializeData();
    void printFirstSet(int constructor);
    void addToFirstSet(int constructor, char terminal);
    void processDependencies(int constructor);
    void calculateFirstSet(int constructor);
%}

%start program

%union {
    int constructor;
    char* terminal;
    int var;
    void* sense;
    char* production;
}

%type <constructor> constructor
%type <terminal> symbol
%type <production> production
%type <sense> program rules rule productions

%token <var> CONST TERM
%token PROD ALTER FIN END_OF_FILE


%%

program: { $$ = NUL; }
       | rules END_OF_FILE
       ;

rules : rule {  }
      | rules rule {  }
      ;

rule : constructor PROD productions FIN {}
     ;

productions : production { /* if($/1 < 'A'){ 
                            addToFirstSet(constructorTemp, $/1);
                           } else if ($/1 >= 'A') {
                            dependency[constructorTemp][$/1 - 'A'] = true;
                           } */
                          }
            | productions ALTER production {  }
            ;

production : symbol { printf(" asd1 "); strcpy($$, $1); printf(" asd3 "); printf("production symbol 1 - %s", $$); printf(" asd "); }
           | production symbol { printf(" asd2 "); strcpy($$, $1); printf(" asd4 "); printf("production symbol 2 - %s", $$); printf(" asd "); }
           ;

symbol : CONST { c = $1 + 'A'; 
                strcpy($$,&c); //Pensar-ho be
              // dependency[constructorTemp][$1] = true;
               }
       | TERM { printf(" asd12 ");
                c = $1 + 'a';
                strcpy($$,&c);
                printf(" asd12 ");
                // addToFirstSet(constructorTemp, $1 + 'a');
                 }
       ;

constructor : CONST { $$ = $1;
                      constructorTemp = $1;
                      printf("constructor %d\n", $$);
                      order[orderIndex] = constructorTemp;
                      printf("constructor %d\n", $$);
                      orderIndex++;
                      printf("constructor %d\n", $$);
                    }
            ;


%%

void yyerror(const char* message) {
    fprintf(stderr, "Error: %s at line %d\n", message, nlin);
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
        fprintf(stderr, "Error: could not open file %s\n", argv[1]);
        return 1;
    }

    initializeData();
    yyparse();
    fclose(yyin);

    // Calculate dependencies
    for (int i = 0; i < orderIndex; i++) {
        calculateFirstSet(order[i]);
        printFirstSet(order[i]);
    }

    return 0;
}

  // Function to initialize the firstSets and processed arrays
  void initializeData() {
      memset(firstSets, false, sizeof(firstSets));
      memset(processed, false, sizeof(processed));
      memset(dependency, false, sizeof(dependency));
  }

  // Function to print the first sets for each constructor
  void printFirstSet(int constructor) {
      printf("%c = ", 'A' + constructor);
      for (int j = 0; j < MAX_TERMINALS; j++) {
          if (firstSets[constructor][j]) {
              printf("%c ", 'a' + j);
          }
      }
      printf("\n");
  }

  // Function to add a terminal to the first set of a constructor
  void addToFirstSet(int constructor, char terminal) {
      if (islower(terminal)) {
          firstSets[constructor][terminal - 'a'] = true;
      }
  }

  // Function to process the dependencies for a constructor
  void processDependencies(int constructor) {
      processed[constructor] = true;
      for (int i = 0; i < MAX_CONSTRUCTORS; i++) {
        if (dependency[i][constructor] && !processed[i]) { // Si no esta processat entra???? pq? Que comporta la condicio?
            calculateFirstSet(i);
        }
      }
  }

  // Function to calculate the first set for a constructor
  void calculateFirstSet(int constructor) {
      for (int i = 0; i < MAX_CONSTRUCTORS; i++) {
          if (dependency[constructor][i] && !processed[i]) {
              processDependencies(i);
          }
      }

      // Calculate first set for the constructor
      for (int i = 0; i < MAX_CONSTRUCTORS; i++) {
          if (dependency[constructor][i]) {
              for (int j = 0; j < MAX_TERMINALS; j++) {
                  if (firstSets[i][j]) {
                      addToFirstSet(constructor, 'a' + j);
                  }
              }
          }
      }
  }

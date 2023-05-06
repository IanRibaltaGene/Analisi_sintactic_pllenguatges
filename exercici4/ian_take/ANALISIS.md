# Exercici 4
## Enunciat
Implentar l’analitzador sintàctic de manera que reconegui les fòrmules de CP1 ben formades.

## Formula ben formada (fbf's) de CP1
- Variables i constants són termes
- f símbol funció, t1...tn termes, llavors f(t1,...,tn) és un terme
- P símbol predicat, t1...tn termes, llavors P(t1,...,tn) és una fòrmula atòmica i per tant fbf
- Tota formula atòmica és una fbf
### Exemples de fbf's
- \forAll x A
- \exists x A
- (A)
- !A
- A && B
- A || B
- A -> B
- A <-> B

## Tokens
- NEG "!" associatiu per la dreta 
- FORALL "\forAll" associatiu per la dreta 
- EXISTS "\exists" associatiu per la dreta
- CONJ "&&" associatiu per l'esquerra
- DISJ "||" associatiu per l'esquerra
- IMP "->" associatiu per l'esquerra
- DIMP "<->" associatiu per l'esquerra
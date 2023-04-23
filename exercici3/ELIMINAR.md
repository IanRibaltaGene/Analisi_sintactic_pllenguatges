# Exercici 3: Eliminar les implicacions i dobles implicacions al llenguatge CP0


## Descripció
Aquest exercici consisteix en eliminar les implicacions i dobles implicacions d'una fórmula proposicional en el llenguatge CP0.

## Entrada
La entrada consisteix en una fórmula proposicional en el llenguatge CP0.

## Sortida
La sortida consisteix en la fórmula proposicional en el llenguatge CP0 sense implicacions ni dobles implicacions.

## Exemple
```
Entrada: (p->q)<->(r->s)
Sortida: (p^!q)v(!r^s)
```
```
Entrada: (p->q)<->(r->s)<->(t->u)
Sortida: (p^!q)v(!r^s)v(!t^u)
```
```
Entrada: (p->q)<->(r->s)<->(t->u)<->(v->w)
Sortida: (p^!q)v(!r^s)v(!t^u)v(!v^w)
```


## Restriccions
- La fórmula proposicional no contindrà espais en blanc.

## Comentaris
- Els comentaris comencen amb el caràcter `#` i finalitzen al final de la línia.

## Sincronitzador de clausula CP0
- newLine: `\n` separador de clausules

## Caracter a despreciar
- ` ` espai en blanc i `\t` tabulador en l'entrada
- Comentaris

## Tokens
- CHAR [A-Z]
- NEG "!" unari associatiu a la dreta
- AND "^" binari associatiu a l'esquerra
- OR "v" binari associatiu a l'esquerra
- IMPL "->" binari associatiu a l'esquerra
- DUBL "<->" binari associatiu a l'esquerra

## Consideracions ordre de precedència
- '(' i ')' tenen precedència sobre tots els altres operadors i poden alterlar l'ordre d'avaluació.
- Els operadors unaris tenen precedència sobre els binaris.
- Els operadors binaris tenen la mateixa precedència i s'avaluen de l'esquerra a la dreta.

## Gramàtica
- Fórmula proposicional: `F = CHAR | NEG F | F CONJ F | F DISH F | F IMPL F | F DUBL F | "(" F ")"`

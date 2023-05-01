# Exercici 3: Eliminar les implicacions i dobles implicacions al llenguatge CP0


## Index
- [Exercici 3: Eliminar les implicacions i dobles implicacions al llenguatge CP0](#exercici-3-eliminar-les-implicacions-i-dobles-implicacions-al-llenguatge-cp0)
  - [Index](#index)
  - [Descripció](#descripció)
  - [Execució](#execució)
  - [Entrada](#entrada)
  - [Sortida](#sortida)
  - [Exemple](#exemple)
  - [Restriccions](#restriccions)
  - [Comentaris](#comentaris)
  - [Sincronitzador de clausula CP0](#sincronitzador-de-clausula-cp0)
  - [Caracter a despreciar](#caracter-a-despreciar)
  - [Tokens](#tokens)
  - [Consideracions ordre de precedència](#consideracions-ordre-de-precedència)

## Descripció
Aquest exercici consisteix en eliminar les implicacions i dobles implicacions d'una fórmula proposicional en el llenguatge CP0.

## Execució
```./eliminar_implicacions fitxer_entrada```

## Entrada
La entrada consisteix en una fórmula proposicional en el llenguatge CP0.

## Sortida
La sortida consisteix en la fórmula proposicional en el llenguatge CP0 sense implicacions ni dobles implicacions.

## Exemple
```
Entrada: A->B v C->D;

Sortida: !((!(A) v (B) v C)) v (D)
```

## Restriccions
- La fórmula proposicional no contindrà espais en blanc.

## Comentaris
- Els comentaris comencen amb el caràcter `#` i finalitzen al final de la línia.

## Sincronitzador de clausula CP0
- newLine: `\n` separador de clausules

## Caracter a despreciar
- ` ` espai en blanc i `\t` tabulador en l'entrada
- Comentaris que comencen amb `#` i finalitzen al final de la línia

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

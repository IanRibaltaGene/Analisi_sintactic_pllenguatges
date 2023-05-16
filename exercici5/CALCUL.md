# Calcul conjunts


## Index
- [Calcul conjunts](#calcul-conjunts)
  - [Index](#index)
  - [Descripció](#descripció)
  - [Execució](#execució)
  - [Entrada](#entrada)
  - [Sortida](#sortida)
  - [Exemple](#exemple)
  - [Restriccions](#restriccions)
  - [Comentaris](#comentaris)
  - [Marcador final de regla](#marcador-final-de-regla)
  - [Marcador final de programa](#marcador-final-de-programa)
  - [Tokens](#tokens)


## Descripció
Aquest exercici consiteix en calcular els conjunts de primers de les regles d'una gramàtica.

## Execució
```./calcul_conjunts fitxer_entrada```

## Entrada
La entrada consisteix en una gramàtica LL(1).

## Sortida
La sortida consisteix en els conjunts de primers de les regles de la gramàtica.

## Exemple
```
Entrada:
    S : aAc | fA | Bdef
        ;
    B : Ab | Ad | k
        ;
    A : ilm | ml
        ;
    D : Ab | dB
        ;
Sortida:
    S : f i k m
    B : i m k
    A : i m
    D : d i m

```


## Restriccions
La gramàtica no contindrà cicles ni produccions buides.

## Comentaris
Els comentaris començaran per ```//``` i acabaran amb un final de línia.

## Marcador final de regla
Cada norma acabarà amb un ```;```.

## Marcador final de programa
La gramàtica acabarà amb un End Of File.

## Tokens
Els tokens que es poden utilitzar són:
- ```[a-z]+``` : Identificador de terminal.
- ```[A-Z]+``` : Identificador de constructor.
- ```;``` : Final de regla.
- ```|``` : Separador de regles.
- ```//.*\n``` : Comentari.
- ```\n``` : Final de línia.
- ```EOF``` : Final de fitxer.

# Definicje grafów

## Skierowane/nieskierowane

### Graf skierowany — graf, w którym krawędzie są zorientowanymi parami wierzchołków.  
Pomiędzy dwoma wierzchołkami może być co najwyżej jedna krawędź w każdym kierunku.  
Na rysunku kreski łączące wierzchołki mają strzałki.

### Graf nieskierowany — krawędzie nie mają kierunku.  
Pomiędzy dwoma wierzchołkami może być tylko jedna krawędź (bo V jest zbiorem);  
zazwyczaj nie chcemy pętli w wierzchołkach.  
Dalej wszystkie grafy są nieskierowane, jeśli nie zaznaczymy inaczej

# Inne
set.seed() psuje losowość.
layouty grafów psują losowość.

# Plan
Rozpoznwanie podstawowych typów grafów.
Ścieżki, pełne, cykle, itp.
Najpierw stała liczba wierzchołków. Zaczynam od 4. Potem więcej.
Generalnie więcej klas do modelu dodać.

# Typy grafów
https://pl.wikipedia.org/wiki/Klasa_grafów
Ścieżka
Cykl
Pełny
Bezkrawędziowe

Dwudzielne (nie używam)

Ścieżka, cykl, pełny to grafy spójne.
Grafy dwudzielne mogą być spójne lub niespójne. 

##################-odrzucone-##################
- Graf gwiazda (star graph)
Definicja: Graf dwudzielny który składa się z jednego wierzchołka centralnego, połączonego krawędziami z innymi wierzchołkami (liśćmi).
Wierzchołki liści nie są ze sobą połączone.

- Graf koło (wheel graph)
​Definicja: Graf, który powstaje przez dodanie jednego wierzchołka do grafu cyklu i połączenie go krawędziami ze wszystkimi wierzchołkami cyklu.
Taki wierzchołek nazywany jest "centrum koła".

##################-do testów-##################
- Drzewo
Graf nieskierowany, który jest spójny i nie zawiera cykli. Każdy graf będący drzewem ma dokładnie n-1 krawędzi, n to liczba wierzchołków

- Graf hiper-kostki (hypercube graph)
Definicja: Graf, którego wierzchołki reprezentują wszystkie możliwe ciągi binarne o długości n,
a krawędzie łączą te wierzchołki, które różnią się dokładnie jednym bitem.
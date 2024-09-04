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

# 1
Chyba do wywalenia te dwudzielne
Dodaj wiecej obrotów, np. 100 grafów z obrotem 0.3, a 100 z 0.5

# 2
- Wstęp
Wprowadzenie do tematu: Wyjaśnij, czym są grafy i dlaczego są ważne w matematyce, informatyce i innych dziedzinach.
Cel pracy: Określ, dlaczego wybrałeś klasyfikację typów grafów jako temat swojej pracy.
- Podstawowe definicje
Omów podstawowe pojęcia związane z grafami, takie jak wierzchołki, krawędzie, grafy skierowane i nieskierowane.
Przedstaw różne reprezentacje grafów, takie jak macierze sąsiedztwa i listy sąsiedztwa.
- Klasyfikacja grafów
Opisz różne typy grafów, takie jak grafy spójne, drzewa, grafy planarne, grafy regularne itp.
Wyjaśnij, jak można klasyfikować grafy na podstawie ich właściwości (np. liczby wierzchołków, stopnia wierzchołków).
- Algorytmy klasyfikacji grafów
Przedstaw istniejące algorytmy służące do klasyfikacji grafów.
Omów ich złożoność obliczeniową i efektywność.
- Przykłady zastosowań
Zbadaj, jak klasyfikacja typów grafów jest używana w praktyce. Przykłady mogą obejmować sieci społecznościowe, analizę sieci, planowanie tras, układanie grafów itp.
- Badania własne
Przeprowadź własne badania na temat klasyfikacji grafów. Możesz zbadać nowe algorytmy, porównać istniejące metody lub zastosować je w konkretnym kontekście.
- Podsumowanie
Podsumuj wyniki swoich badań i wnioski dotyczące klasyfikacji typów grafów.
Zastanów się nad możliwościami dalszych badań w tej dziedzinie.

##################-te nie-##################
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

#####################
Wydajność przy definicji walidacji krzyżowej to odpowiednie słowo, bo to definicja z książki.

https://wmifs.prz.edu.pl/studenci/praca-dyplomowa/zasady-i-tryb-wykonania-pracy-dyplomowej

##################### Plan 03.09 #####################
1. Zrobić kopie obecnych modeli. ---- done
2. Rozrysować na kartce więcej rysunków. ---- done
3. Puścić przygotowane modele na nowych danych zewnętrznych. ---- done
4. Edytować opisy modeli (nie powinno tego być wiele). 
5. Napisać wnioski z testów.
6. Napisać podsumowanie.
7. Napisac abstract.
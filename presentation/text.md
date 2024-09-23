# Wstęp
Moja praca skupiała się na temacie rozpoznawania wzorców, tutaj w postaci grafów, głównie od strony algorytmicznej.

**Slajd**

Przedstawiłem w niej pokrótce temat teorii grafów oraz podstawowe koncepty uczenia maszynowego.
Opisałem wykorzystane technologie oraz dokładnie przedstawiłem podstawową wersję
stworzonego modelu sieci neuronowej.
Najobszerniejszym rozdziałem był ten o testach i modyfikacjach modeli.

**Slajd**

Słowem wstępu, dla nas, ludzi, zdolność do rozpoznawania wzorców jest kluczowa w procesie nauki.
Dzięki temu, że potrafimy identyfikować elementy, które już wcześniej widzieliśmy,
jesteśmy w stanie szybciej przyswajać nową wiedzę.

W podobny sposób działają algorytmy uczenia maszynowego.
Po prawidłowym przeszkoleniu modelu na określonych danych,
algorytm potrafi rozpoznać podobne wzorce w nowych, wcześniej nieznanych danych
Jest to fundament działania większości współczesnych technologii opartych na sztucznej inteligencji.

**Slajd**

# Wykorzystane technologie
Jako podstawa generatora grafów, wykorzystana została bibliteka igraph w języku R.

W języku Python, wykorzystana została biblioteka Keras z pakietu Tensorflow.
Warto nadmienić również PIL oraz sklearn, które posłużyły do obróbki danych wykorzystanych w modelach.

**Slajd**

# Generator grafów
Generator zaprojektowano w sposób funkcyjny, aby maksymalnie zautomatyzować testy.
Grafy rysowano w rozmiarze 800x600 pikseli, na białym tle z pomarańczowymi wierzchołkami, bez jakichkolwiek oznaczeń.
Zapisywano je w katalogach odpowiadających klasom,
a przygotowane skrypty generowały ścieżki, cykle, grafy pełne, grafy bezkrawędziowe i drzewa binarne.

Pełny skrypy jest oczywiście dostępny w załączonym do pracy repozytorium.

**Slajd**

W testach użyto łącznie 10 tys. grafów, generowanych w liczbie 500 na każdy typ,
z wariantami od 4 do 7 wierzchołków.
Testy przeprowadzono dla losowych krzywiznach krawędzi, parametr z przedziału [0-1].

**Slajd**

# Dane zewnętrzne
Dane zewnętrzne, które nazwane tutaj są obrazami testowymi,
są rysunkami grafów pochodzącymi spoza przygotowanego testu.
Dzielą się na obrazy pobrane z internetu oraz w głównej mierze, rysunki odręczne grafów.

Pozwoliły one na określenie realnej dokładności modeli, a nie tylko teoretycznej.

**Slajd**

# Model
Dalej, przechodząc do omówienia modelu.
Wszystkie skrypty testowe rozpoczynają się od przygotowania środowiska do trenowania modelu.

Obrazy przed uczeniem modelu przekształca się do rozmiaru 180x180 pikseli i skaluje do odcieni szarości.

Grafy są dzielone na zestawy treningowe (80% danych) i walidacyjne (20% danych),
co daje łącznie 8 tys. grafik do treningu i 2 tys. do testów.
W przypadku walidacji krzyżowej dane są dzielone inaczej dla każdej iteracji.

Model sieci neuronowej został zdefiniowany jako sekwencyjny stos warstw.
Pierwsza warstwa, Rescaling, normalizuje piksele do zakresu [0, 1],
a trzy kolejne warstwy konwolucyjne dwuwymiarowe
z funkcją aktywacji ReLU (Conv2D) służą do automatycznego wykrywania wzorców
i są następowane przez warstwy MaxPooling2D, które to zmniejszają rozmiar map cech.

Po wcześniej wspomnianych warstwach,
warstwa Flatten (czyli spłaszczająca) przekształca dane w wektor jednowymiarowy.
Dalej mamy warstwę w pełni połączoną (czyli Dense) ze 128 neuronami i funkcją aktywacji ReLU,
która odpowiada za podjęcie ostatecznej decyzji w klasyfikacji.
Mamy tutaj również regularyzacje L2 i parametr Dropout dla redukcji przeuczenia.
Model trenowano przez 75 epok, gdyż w testach na mniejszych liczbach epok sprawdzone zostało,
że wartości takie jak 10, czy 20, są zbyt małe, by poprawnie nauczyć większość modeli
Modele dość szybko osiągały wysokie dokładności, więc większe liczby epok też nie były konieczne.

**Slajd**

Po wytrenowaniu modelu, skrypt wizualizuje dokładność i stratę modelu.

**Slajd**

# Testy
Testy sprawdzają realną dokładność modeli.
Przy pięciu klasach losowy wybór daje 20% trafności.
Modele z dokładnością poniżej tego progu lub blisko niego są nieprzydatne.

Sprawdzane warianty modeli wyświetlone są na obecnym slajdzie.

Model podstawowy został przedstawiony w poprzednim rozdziale.
Model z walidacją krzyżową, to wersja modelu podstawowego z zastosowaną walidacją krzyżową.
Model ze zmienną liczbą wierzchołków to model podstawowy, uczony na grafach bez podziału na liczbę ich wierzchołków.
Model ze zmienną liczbą wierzchołków i walidacją krzyżową to połaczenie dwóch wcześniej wymienionych modeli.

**Slajd**

Zastosowano modyfikacje modeli w celu polepszenia dokładności oraz zmniejszenia ich podatności na przeuczenie.
- Zmieniono liczbę filtrów w warstwach Conv2D z 32 w każdej warstwie, do kolejno 32, 64 oraz 128.
    Jednocześnie zwiększono parametr Dropout z 0,2 do 0,5.
- Zastosowano normalizację wsadową pomiędzy warstwami modelu.
- Wprowadzenie augmentacji danych przed budową modelu, która dodaje więcej wariacji do zbioru treningowego.
    Wykorzystano również GPU w procesie pobierania wstępnego danych i cachingu, by przypsieszyć przetwarzanie danych.
- Skorzystanie z wywołania zwrotnego, które zmniejsza szybkość uczenia.
    Może to pomóc w konwergencji modelu w przypadku stagnacji dokładnosci.

**Slajd**

Omówię tutaj jeden z testowanych modeli. Jest to model z walidajcą krzyżową.

Model uczy się poprawnie, osiągając wysoką dokładność i niską stratę,
jednak fluktuacje w danych walidacyjnych sugerują problemy z generalizacją,
prawdopodobnie z powodu niestabilności lub przeuczenia.
Zwiększenie liczby epok nie poprawiłoby wyników, gdyż model przeucza się bardzo szybko.

**Slajd**

Z powodu przeuczenia model słabo radził sobie z zewnętrznymi obrazami testowymi,
klasyfikując większość jako grafy pełne, co nie odzwierciedla rzeczywistości.

**Slajd**

Jego realna dokładność wynosi około 24%.

Tutaj mamy przykład jednego z klasyfikowanych grafów.
Przypisana klasa to graf pełny z 99,62% pewnością.
Biorąc pod uwagę wysoką pewność przy klasyfikacji,
można by spodziewać się lepszego wyniku niż otrzymany.

Wiele innych modeli również osiągnęło niezadowalające wyniki,
ale zdarzyły się jednak również modele znacznie lepsze,
których dokładności znajdowały się w przedziale od 35% do 45%.

# Podsumowanie
Podsumowując, celem pracy było stworzenie modeli sieci neuronowych,
rozpoznających pięć typów grafów i zostało to osiągnięte.

Generalnie, uczenie modeli na grafach o stałej liczbie wierzchołków
okazało się skuteczniejsze niż na grafach o zmiennej liczbie wierzchołków.
Skomplikowanie modelu i zastosowane techniki optymalizacyjne rzadko zwiększały realną dokładność.

W bardziej zmodyfikowanych modelach dominowały grafy pełne,
przez co większość zewnętrznych testowych grafów była klasyfikowana jako pełne.

Mimo problemów z przeuczeniem, część modeli osiągnęła całkiem wysoką dokładność,
która przełożyła się na dobre wyniki na danych zewnętrznych.

Praca pokazała, że możliwe jest zbudowanie modelu rozpoznającego rysunki grafów lepiej niż przy losowym wyborze.
Najlepszy model osiągnął dokładność 45%, co wskazuje na potrzebę ewentualnego dalszego rozwoju.
Był to model podstawowy, uczony na grafach o sześciu wierzchołkach.

**Slajd**

# Zakończenie
Dziękuję za uwagę.
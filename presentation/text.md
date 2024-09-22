# Wstęp
Moja praca skupiała się na temacie rozpoznawania wzorców, tutaj w postaci grafów, głównie od strony algorytmicznej.

Przedstawiłem w niej pokrótce temat teorii grafów oraz podstawowe koncepty uczenia maszynowego.
Opisałem wykorzystane technologie oraz dokładnie przedstawiłem podstawową wersję
stworzonego modelu sieci neuronowej.
Najobszerniejszym rozdziałem był ten o testach i modyfikacjach modeli.

**Slajd**

Dla nas, ludzi, zdolność do rozpoznawania wzorców jest kluczowa w procesie nauki.
Dzięki temu, że potrafimy identyfikować elementy, które już wcześniej widzieliśmy,
jesteśmy w stanie szybciej przyswajać nową wiedzę.

W podobny sposób działają algorytmy uczenia maszynowego.
Po prawidłowym przeszkoleniu modelu na określonych danych,
algorytm potrafi rozpoznać podobne wzorce w nowych, wcześniej nieznanych danych
Jest to fundament działania większości współczesnych technologii opartych na sztucznej inteligencji.

# Wykorzystane technologie
Jako podstawa generatora grafów, wykorzystana została bibliteka igraph w języku R.

Python jako język posiada wiele narzędzi i bibliotek przystosowanych do zastosowań w dziedzinie uczenia maszynowego.
Dlatego też wybrany został do stworzenia modelu klasyfikacji grafów.
Wykorzystana została biblioteka Keras z pakietu Tensorflow.
Warto nadmienić również PIL oraz sklearn, które posłużyły do obróbki danych wykorzystanych w modelach.

# Generator grafów
Dane wygenerowano za pomocą skryptu w języku R i biblioteki igraph,
zaprojektowanego w sposób funkcyjny, aby maksymalnie zautomatyzować testy.
Grafy rysowano w rozmiarze 800x600 pikseli, z pomarańczowymi wierzchołkami na białym tle, bez jakichkolwiek oznaczeń.
Zapisywano je w katalogach odpowiadających klasom,
a przygotowane skrypty generowały ścieżki, cykle, grafy pełne, grafy bezkrawędziowe i drzewa binarne.

**Slajd**

W testach użyto łącznie 10 tys. grafów, generowanych w liczbie 500 na każdy typ,
z wariantami od 4 do 7 wierzchołków.
Testy przeprowadzono na dwóch poziomach krzywizny krawędzi: stałej (0.3) oraz losowej (0-1).
Wyniki testów ze stałą krzywizną zostały pominięte ze względu na ich niską wartość merytoryczną.

# Dane zewnętrzne
Obrazy testowe, które nazwane są tutaj danymi zewnętrznymi,
są rysunkami grafów pochodzącymi spoza przygotowanego testu.
Dzielą się na obrazy pobrane z internetu oraz głównie rysunki odręczne grafów (tych było najwięcej).

# Model
Wszystkie skrypty testowe rozpoczynają się od przygotowania środowiska do trenowania modelu.
Grafy dla różnych liczby wierzchołków są dzielone na zestawy treningowe (80%) i walidacyjne (20%),
co daje łącznie 8 tys. grafik do treningu i 2 tys. do testów.

Obrazy przed uczeniem modelu przekształca się do rozmiaru 180x180 pikseli i skaluje do odcieni szarości.
W przypadku walidacji krzyżowej dane są dzielone inaczej dla każdej iteracji.

Model sieci neuronowej został zdefiniowany jako sekwencyjny stos warstw z 5-krotną walidacją krzyżową.
Pierwsza warstwa, Rescaling, normalizuje piksele do zakresu [0, 1],
a trzy kolejne warstwy Conv2D są następowane przez MaxPooling2D.

Po wcześniej wspomnianych warstwach, warstwa Flatten przekształca dane w wektor jednowymiarowy.
Dalej mamy warstwę Dense ze 128 neuronami i funkcją ReLU,
z regularyzacją L2 i Dropout dla redukcji przeuczenia.
Warstwa wyjściowa dopasowuje liczbę jednostek do liczby klas.
Model trenowano przez 75 epok.
Przeprowadzono również testy na mniejszych liczbach epok, lecz wartości takie jak 10, czy 20,
są za małe, by poprawnie nauczyć większość modeli
Modele dość szybko osiągały wysokie dokładności, więc większe liczby epok też nie były konieczne.

W toku badań i przygotowań prac, testowane były różne wariancje i kombinacje powyższych parametrów
w celu osiągnięcia najlepszej dokładności teoretycznej.
Oczywiście z uwzględnieniem ryzyka przeuczenia modelu.

**Slajd**

Po wytrenowaniu modelu, skrypt wizualizuje dokładność i stratę modelu.

# Testy
Testy sprawdzają realną dokładność modeli.
Przy pięciu klasach losowy wybór daje 20% trafności.
Modele z dokładnością poniżej tego progu lub blisko niego są nieprzydatne.
Użyteczność modeli można wyznaczyć na około 35%, co oznacza znaczną poprawę względem wyboru losowego.

Sprawdzane warianty modeli wyświetlone są na obecnym slajdzie.

Model podstawowy został przedstawiony w poprzednim rozdziale.
Model z walidacją krzyżową, to wersja modelu podstawowego,
która sprawdza różne podziały zbiorów danych testowych i uczących za pomocą walidacji krzyżowej.
Model ze zmienną liczbą wierzchołków to model podstawowy,
który uczony był na grafach bez podziału na liczbę ich wierzchołków.
Model ze zmienną liczbą wierzchołków i walidacją krzyżową to połaczenie dwóch wcześniej wymienionych modeli.

**Slajd**

Zastosowano modyfikacje modeli w celu polepszenia dokładności modeli oraz zmniejszenia ich podatności na przeuczenie.
- Zmieniono liczbę filtrów w warstwach Conv2D z 32 w każdej warstwie, do kolejno 32, 64 oraz 128.
    Jednocześnie zwiększono parametr Dropout z 0,2 do 0,5.
- Zastosowano normalizację wsadową pomiędzy warstwami modelu - konkretnie po każdej warstwie Conv2D.
- Wprowadzenie augmentacji danych przed budową modelu, która dodaje więcej wariacji do zbioru treningowego,
    w celu poprawy zdolności generalizacyjnych.
    Wykorzystano również GPU w procesie pobierania wstępnego danych i cachingu zbiorów danych,
    by przypsieszyć przetwarzanie danych.
- Skorzystanie z wywołania zwrotnego, które zmniejsza szybkość uczenia.
    W przypadku stagnacji dokładności w procesie przechodzenia przez kolejne epoki uczenia modelu
    może pomóc w lepszej konwergencji modelu.

**Slajd**

Omówię tutaj jeden z testowanych modeli.

Model uczy się poprawnie, osiągając wysoką dokładność i niską stratę,
jednak fluktuacje w danych walidacyjnych sugerują problemy z generalizacją,
prawdopodobnie z powodu niestabilności lub przeuczenia.
Zwiększenie liczby epok nie poprawiłoby wyników, gdyż model przeucza się zbyt szybko.

**Slajd**

Z powodu przeuczenia model słabo radził sobie z zewnętrznymi obrazami testowymi,
klasyfikując większość jako grafy pełne, co nie odzwierciedla rzeczywistości.

**Slajd**

Jego realna dokładność wynosi około 24%.

Tutaj mamy przykład jednego z klasyfikowanych grafów.
Przypisana klasa to graf pełny z 99,62% pewnością.
Biorąc pod uwagę wysoką pewność przy klasyfikacji,
można by spodziewać się lepszego wyniku niż otrzymany nieprawidłowy.

Wiele innych modeli również osiągnęło podobne niezadowalające wyniki.
Zdarzyły się jednak również modele znacznie lepsze,
których dokładności znajdowały się w przedziale od 35% do 45%.

# Podsumowanie
Podsumowując, celem pracy było stworzenie modeli sieci neuronowych
rozpoznających pięć typów grafów i zostało to osiągnięte.
Do generowania danych użyto języka R, a modele zaprojektowano i przetestowano w Pythonie z pakietem Tensorflow.

Generalnie, uczenie modeli na grafach o stałej liczbie wierzchołków
okazało się skuteczniejsze niż na grafach o zmiennej liczbie wierzchołków.
Skomplikowanie modelu i zastosowane techniki optymalizacyjne rzadko zwiększały realną dokładność.

W bardziej zmodyfikowanych modelach dominowały grafy pełne,
przez co na danych zewnętrznych większość testowych grafów była klasyfikowana jako pełne.

Mimo problemów z przeuczeniem, część modeli osiągnęła całkiem wysoką dokładność,
która przełożyła się na dobre wyniki na danych zewnętrznych.

Praca pokazała, że możliwe jest zbudowanie modelu rozpoznającego rysunki grafów lepiej niż przy losowym wyborze.
Najlepszy model osiągnął dokładność 45%, co wskazuje na potrzebę ewentualnego dalszego rozwoju.

# Zakończenie
Dziękuję za uwagę.
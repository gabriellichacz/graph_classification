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

Python jest językiem szeroko stosowanym w dziedzinie Data Science do wizualizacji,
analizy i przetwarzania danych oraz w uczeniu maszynowym.
Ostatnie z wymienionych zastosowań zadecydowało o wyborze języka Python jako narzędzia do stworzenia modelu klasyfikacji grafów.
Wykorzystana została biblioteka Keras z pakietu Tensorflow,
a do wizualizacji danych wykorzystana została biblioteka Matplotlib.
Warto nadmienić również PIL oraz sklearn, które posłużyły do obróbki danych wykorzystanych w modelach.

# Generator grafów
Dane wygenerowano za pomocą skryptu w języku R i biblioteki igraph,
zaprojektowanego w sposób funkcyjny, aby maksymalnie zautomatyzować testy.
Grafy rysowano w rozmiarze 800x600 pikseli, z pomarańczowymi wierzchołkami na białym tle, bez jakichkolwiek oznaczeń.
Zapisywano je w katalogach odpowiadających klasom,
a przygotowane skrypty generowały ścieżki, cykle, grafy pełne, grafy bezkrawędziowe i drzewa binarne.

**Slajd**

W testach użyto łącznie 10 000 grafów, generowanych w liczbie 500 na każdy typ, z wariantami od 4 do 7 wierzchołków.
Testy przeprowadzono na dwóch poziomach krzywizny krawędzi: stałej (0,3) oraz losowej (0-1).
Wyniki testów ze stałą krzywizną zostały pominięte ze względu na ich niską wartość merytoryczną.

# Dane zewnętrzne
Obrazy testowe, które nazwane są tutaj danymi zewnętrznymi, są rysunkami grafów pochodzącymi spoza przygotowanego testu.
Dzielą się na obrazy pobrane z internetu, obrazy wygenerowane przez skrypt w R,
ale nie używane w treningu, oraz rysunki odręczne grafów.
Typy danych zewnętrznych wybiegają poza klasy grafów wykorzystywanych przy uczeniu modelu.

# Model
Wszystkie skrypty testowe rozpoczynają się od przygotowania środowiska do trenowania modelu.
Ustawiane są ścieżki do katalogów z grafami oraz danymi treningowymi i walidacyjnymi.
Skrypty definiują wielkość obrazów i partii danych używanych podczas treningu.
Grafy dla różnych liczby wierzchołków są dzielone na zestawy treningowe (80%) i walidacyjne (20%),
co daje łącznie 8 tys. grafik do treningu i 2 tys. do testów.

Następnie wczytywane są owe obrazy, które następnie przekształca się do formatu 180x180 px i skaluje do odcieni szarości.
W przypadku walidacji krzyżowej dane są dzielone inaczej dla każdej iteracji.

Model sieci neuronowej został zdefiniowany jako sekwencyjny stos warstw z 5-krotną walidacją krzyżową.
Pierwsza warstwa, Rescaling, normalizuje piksele do zakresu [0, 1],
a trzy kolejne warstwy Conv2D (32 filtry 3x3, ReLU) są następowane przez MaxPooling2D (2x2).

Po tych warstwach, warstwa Flatten przekształca dane w wektor 1D.
Następnie znajduje się warstwa Dense z 128 neuronami i funkcją ReLU,
z regularyzacją L2 (0,01) i Dropout (20%) dla redukcji przeuczenia.
Warstwa wyjściowa dopasowuje liczbę jednostek do liczby klas. Model trenowano przez 75 epok.

W kolejnych wariantach modeli zmieniano parametry warstw i funkcje aktywacji, aby znaleźć optymalną kombinację.

**Slajd**

Po wytrenowaniu, skrypt wizualizuje dokładność i stratę modelu.
W konsoli wyświetla dokładność dla zbioru treningowego i walidacyjnego,
a także tworzy wykresy tych wartości oraz straty (entropii krzyżowej), która mierzy różnicę między etykietami a przewidywaniami.
Im mniejsza entropia, tym lepsza skuteczność modelu.

Następnie skrypt przeszukuje katalog z danymi, wczytuje testowe obrazy, przeskalowuje je,
konwertuje na odcienie szarości i przewiduje ich klasy, wyświetlając wyniki w konsoli.

# Testy
Testy sprawdzają realną dokładność modeli. Przy pięciu klasach losowy wybór daje 20% trafności. Modele z dokładnością poniżej tego progu lub blisko niego są nieprzydatne. Użyteczność modeli można wyznaczyć na około 35%, co oznacza znaczną poprawę względem losowego wyboru.

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
- Wprowadzenie augmentacji danych przed budową modelu, która wprowadza więcej wariacji do zbioru treningowego,
    w celu poprawy zdolności generalizacyjnych.
    Wykorzystano również GPU w procesie pobierania wstępnego danych i cachingu zbiorów danych, by przypsieszyć przetwarzanie danych.
- Skorzystanie z wywołania zwrotnego, które zmniejsza szybkość uczenia.
    W przypadku stagnacji dokładności w procesie przechodzenia przez kolejne epoki uczenia modelu
    może pomóc w lepszej konwergencji modelu.

**Slajd**

Omówię tutaj jeden z modeli

W modelu z walidacją krzyżową, trenowanym na grafach z 4 wierzchołkami, dokładność szybko rośnie i osiąga ponad 80% po 10 epokach, stabilizując się na poziomie 90%. Widać jednak fluktuacje, zwłaszcza w danych walidacyjnych, co może wynikać z problemów z generalizacją.

Strata modelu spada w pierwszych 10 epokach, co sugeruje szybkie uczenie, a potem stabilizuje się, z pojedynczymi skokami na zbiorze walidacyjnym, wskazującymi możliwe przeuczenie.

# Podsumowanie
Podsumowując, celem pracy było stworzenie modeli sieci neuronowych rozpoznających pięć typów grafów
i zostało to osiągnięte.
Do generowania danych użyto języka R, a modele zaprojektowano i przetestowano w Pythonie z pakietem Tensorflow. Praca pokazała, że możliwe jest zbudowanie modelu rozpoznającego rysunki grafów lepiej niż przy losowym wyborze. Najlepszy model osiągnął dokładność 45%, co wskazuje na potrzebę ewentualnego dalszego rozwoju.

# Zakończenie
Dziękuję za uwagę.
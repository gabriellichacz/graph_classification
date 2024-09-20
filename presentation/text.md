# Wstęp
Moja praca skupiała się na temacie rozpoznawania wzorców, tutaj w postaci grafów, głównie od strony algorytmicznej.

Przedstawiłem w niej pokrótce temat teorii grafów oraz podstawowe koncepty uczenia maszynowego.
Opisałem wykorzystane technologie oraz dokładnie przedstawiłem podstawową wersję
stworzonego modelu sieci neuronowej.
Najobszerniejszym rozdziałem był ten o testach i modyfikacjach modeli.

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

W testach użyto łącznie 10 000 grafów, generowanych w liczbie 500 na każdy typ, z wariantami od 4 do 7 wierzchołków.
Testy przeprowadzono na dwóch poziomach krzywizny krawędzi: stałej (0,3) oraz losowej (0-1).
Wyniki testów ze stałą krzywizną zostały pominięte ze względu na ich niską wartość merytoryczną.

# Dane zewnętrzne
Obrazy testowe, które nazwane są tutaj danymi zewnętrznymi, są rysunkami grafów pochodzącymi spoza przygotowanego testu.
Dzielą się na obrazy pobrane z internetu, obrazy wygenerowane przez skrypt w R, ale nie używane w treningu,
oraz rysunki odręczne grafów. Typy danych zewnętrznych wybiegają poza klasy grafów wykorzystywanych przy uczeniu modelu.

# Model
Wszystkie przygotowane skrypty testowe rozpoczynają się od przygotowania środowiska do trenowania modelu.
Najpierw ustawiana jest ścieżka do katalogów z wygenerowanymi grafami oraz do katalogów na dane treningowe i walidacyjne.
Następnie sprawdzane jest, czy te katalogi istnieją, a jeśli nie, są tworzone.
Dalej, skrypty definiują parametry dotyczące wielkości obrazów oraz wielkości partii danych, które będą używane podczas treningu.
Dla każdej wartości liczby wierzchołków ustawiana jest ścieżka do katalogu z wygenerowanymi grafami,
pobierana lista podkatalogów oraz obrazów w każdym z nich.
Następnie obrazy dzielone są na zestawy treningowe i walidacyjne w stosunku 80:20.
Daje to 8 tys. grafów w zbiorze uczącym i 2 tys. grafów w zbiorze testowym.
W przypadku modeli wykorzystujących wszystkie warianty liczby wierzchołków, dane przenoszone są do jednego katalogu
i od razu dzielone na zbiory treningowe i walidacyjne.

Każdy typ modelu tworzony jest w inny sposób. Opisana zostanie tu główna zasada i ich elementy wspólne.
Na początku, skrypt wczytuje obrazy przygotowane na wcześniejszym etapie do odpowiednich zmiennych - treningowe i walidacyjne.
W przypadku modeli z walidacją krzyżową, dla każdej itreacji walidacyjnej, dane zostały podzielone inaczej.
Po wczytaniu danych, zostają one przeskalowane do wielkości 180x180 pikseli i przekształcone do odcieni szarości.

Model sieci neuronowej został zdefiniowany jako sekwencyjny stos warstw.
Dla standaryzacji danego testu, w przypadku modeli z walidacją krzyżową, ustalono $k$-Fold z liczbą podziałów równą 5.
Pierwsza warstwa to warstwa Rescaling, która normalizuje wartości pikseli do zakresu [0, 1].
W przykładzie, parametr $1./255$ oznacza, że każda wartość piksela mnożona jest przez $\frac{1}{255}$.
Następne trzy warstwy to Conv2D, z których każda jest następowana warstwą MaxPooling2D.
W przykładzie, warstwa kolwolucyjna stosuje 32 filtry o wymiarach 3x3 oraz funkcję aktywacji ReLU,
która wprowadza nieliniowość do modelu.
MaxPooling2D redukuje rozmiar danych wejściowych,
wybierając maksymalną wartość z każdego regionu (domyślnie oraz tutaj - 2x2). 
Po wyżej wymienionych warstwach, znajduje się warstwa Flatten, która przekształca mapy cech 2D w wektor 1D.
Innymi słowy, przekształca wielowymiarową macierz wyjściową z poprzedniej warstwy do jednowymiarowego wektora.
Następnie, dodana jest w pełni połączona (Dense) warstwa z 128 neuronami
i funkcją aktywacji, podobnie jak w przypadku Conv2D, ReLU.
Wprowadzona jest również regularyzacja L2, która dodaje karę za duże wartości wag,
by zmniejszyć ryzyko przeuczenia. Została zastosowana z siłą 0,01.
Kolejna warstwa to Dropout, która losowo wyłącza 20\% neuronów podczas uczenia,
co również jest moetodą zapobiegającą przeuczeniu.
Warstwa wyjściowa zawiera tyle jednostek, ile występuje klas w danych uczących.
Zależnie od danego testu, może być to różna liczba.
W przypadku warstw konwolucyjnych, wybrano 32 filtry, a dla warstwy w pełni połączonej zastosowano 128 jednostek.
Liczba epok w podstawowej wersji modelu wyniosła 75.

W kolejnych wariantach modeli, zmieniane były parametry poszczególnych warstw, funkcje aktywacji,
czy również same warstwy, w celu znalezienia najbardziej optymalnej kombinacji.

Po wytrenowaniu modelu, skrypt dokonuje wizualizacji dokładności i straty modelu.
Najpierw wyświetla w konsoli wartości dokładności dla obu zbiorów z historii treningu.
Dalej tworzy wykresy, gdzie na pierwszym z nich pokazuje dokładność na zbiorze treningowym i walidacyjnym,
a na drugim wykresie prezentuje stratę modelu dla obu zbiorów.
Jednostką straty jest entropia krzyżowa (cross-entropy), która jest wyrażana jako liczba bezwzględna.
Entropia krzyżowa mierzy różnicę między rzeczywistymi etykietami a przewidywanymi prawdopodobieństwami klas.
Im mniejsza wartość entropii krzyżowej, tym lepiej model przewiduje klasy.
Dokładność jest wyrażana jako wartość procentowa lub ułamek, gdzie 1 oznacza 100\% dokładności.
Na przykład, jeśli model przewiduje poprawnie 90 na 100 przypadków, dokładność wynosi 0.9 lub 90\%.

Po wyświetleniu dokładnosci modelu skrypt przeszukuje katalog z danymi i jego podkatalogi, by przygotować obrazy zewnętrzne.
Następnie ustawia ścieżkę do katalogu z obrazami testowymi i pobiera ich listę.
Dla każdego obrazu w tej liście wczytuje go, przeskalowuje do odpowiedniego rozmiaru i konwertuje do skali szarości
Następnie model przewiduje klasę obrazu, a wynik jest wyświetlany w konsoli.
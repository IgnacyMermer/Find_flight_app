## Aplikacja pozwala na znajdowanie połączeń lotniczych pomiędzy wybranymi lotniskami

#### W aplikacji należy na samym początku wpisać miasto lotniska wylotu i przylotu i wybrać odpowiednie lotniska. Następnie należy wybrać datę lub zakres dat w których użytkownik planuje odbyć podróż. Można również wybrać ilość pasażerów, aby program obliczył koszt wycieczki. 
#### Po naciśnięciu przycisku Szukaj wyświetli się 10 najbardziej odpowiadających połączęń, przy scrollowaniu do dołu ekranu będą ładować się kolejne loty.
#### Dzięki skorzystaniu z bazy danych sqlite istnieje możliwość zapisywania lotów do lokalnej pamięci urządzenia. Ta opcja jest dostępna po wejściu w szczegóły lotu. W tym samym miejscu jest również możliwe znalezenie lotu powrotnego, gdy na początku został wybrany zakres dat podróży.

### Do stworzenia aplikacji wykorzystałem takie biblioteki jak:
- Dio
- provider
- flutter_spinkit
- sqflite
- uuid

#### Aby uruchomić aplikację należy dodać plik lib/Keys/Api.dart, w którym należy umieścic zmienne final apiKey oraz final secretKey (z developer.amadeus.com).
##### Do aplikacji zostały dodane również proste testy.

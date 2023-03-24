# The following code depends on a database that is available in a folder named "databases" under the name "database3


# Usun zbedne spacje
UPDATE klienci
SET 
    imie_klienta = REPLACE(imie_klienta, ' ', ''), 
    nazwisko_klienta = TRIM(nazwisko_klienta);

# Wyswietl nazwy domen bez duplikatow
SELECT DISTINCT 
    substring(email_klienta, 
    instr(email_klienta, '@') + 1) domena 
FROM klienci;

# Wyswiettl adresy email w domenie wp.pl zamieniajac pl na eu
SELECT replace(email_klienta, '@wp.pl', '@wp.eu')
FROM klienci 
WHERE email_klienta like '%@wp.pl%';

# Wyswietl pole z informacja o imieniu i nazwisku klienta wraz z forma grzecznosciowa
SELECT 
    CONCAT_WS(' ', 
        IF(plec = 'M', 'Pan', 'Pani'),
        imie_klienta,
        nazwisko_klienta) klient
FROM klienci;

# Wyswietl informacje o marce oraz modelu kazdego z aut oraz oblicz ile razy byly one wypozyczone
SELECT 
    CONCAT(
        IF( 
            CHAR_LENGTH(samochody.marka)<4,
            UCASE(samochody.marka),
            CONCAT(UCASE(LEFT(samochody.marka, 1)), SUBSTRING(samochody.marka, 2))
            ),
		' ',
        IF(
            CHAR_LENGTH(samochody.model)<4,
            UCASE(samochody.model),
            CONCAT(UCASE(LEFT(samochody.model, 1)), SUBSTRING(samochody.model, 2))
            )
	) auto, 
    CONCAT(
        COUNT(dane_wypozyczen.id_samochodu),
        ' ',
        CASE WHEN COUNT(dane_wypozyczen.id_samochodu) <> 1 THEN 'razy' ELSE 'raz' END
        ) 'liczba wypozyczen'
FROM samochody
    LEFT JOIN dane_wypozyczen ON samochody.id_samochodu = dane_wypozyczen.id_samochodu
GROUP BY dane_wypozyczen.id_samochodu;

# Wyswietl dzien, miesiac i rok wypozyczenia w oddzielnych kolumnach
SELECT
    LEFT(TRIM(data_wyp), 4) Rok,
    SUBSTRING(TRIM(data_wyp), 6, 2) Miesiac,
    RIGHT(TRIM(data_wyp), 2) Dzien
FROM wypozyczenia;

# Wyswietl w jednej kolumnie imie i nazwisko klienta a w drugiej dodaj adres z nazwa ulicy
SELECT 
    CONCAT_WS(' ', imie_klienta, nazwisko_klienta) klient,  
    CONCAT('ul.', ' ', ulica_klienta) ulica
FROM klienci;

# Zamien domene pl na com i odwrotnie. Nie modyfikuj domeny onet.pl
SELECT 
    CASE
        WHEN email_klienta LIKE '%@onet.pl'THEN email_klienta
        WHEN email_klienta LIKE '%@gmail.com' THEN REPLACE(email_klienta, 'gmail.com' , 'gmail.pl)')
        ELSE REPLACE(email_klienta, '@wp.pl', '@wp.com')
	END AS 'modified email'
FROM klienci;

# INNER JOIN
SELECT
    klienci.kod_klienta,
    wypozyczenia.data_zwr,
    dane_wypozyczen.ilosc_dob,
    samochody.marka,
    samochody.model,
    pracownicy.email_pracownika,
    pracownicy.szef_id
FROM klienci
    INNER JOIN wypozyczenia ON klienci.id_klienta = wypozyczenia.id_klienta
    INNER JOIN dane_wypozyczen ON wypozyczenia.id_wypozyczenia = dane_wypozyczen.id_wypozyczenia
    INNER JOIN samochody ON dane_wypozyczen.id_samochodu = samochody.id_samochodu
    INNER JOIN pracownicy ON wypozyczenia.id_pracownika = pracownicy.id_pracownika
ORDER BY ilosc_dob;

# Wyswietl informacje o wypozyczeniach obslugiwane przez pracownika o nazwisku Nowacki
SELECT
    nazwisko_pracownika,
    data_wyp,
    data_zwr,
    cena_doba,
    ilosc_dob
FROM pracownicy p
    LEFT JOIN wypozyczenia w ON w.id_pracownika=p.id_pracownika
    LEFT JOIN dane_wypozyczen dw ON w.id_wypozyczenia=dw.id_wypozyczenia
WHERE p.nazwisko_pracownika="Nowacki";

# LEFT JOIN
# Wybierz pracownikkow, ktorzy nie zrealizowali ani jednego wypozyczenia auta
SELECT
    p.imie_pracownika,
    p.nazwisko_pracownika
FROM pracownicy p
    LEFT JOIN wypozyczenia w ON p.id_pracownika = w.id_pracownika
    WHERE w.id_wypozyczenia IS NULL;
    
# RIGHT JOIN
# wybier samochod, ktory nie zostal jeszcze wypozyczony
select samochody.id_samochodu, marka, model from dane_wypozyczen
RIGHT JOIN samochody ON dane_wypozyczen.id_samochodu = samochody.id_samochodu
WHERE dane_wypozyczen.id_wypozyczenia IS NULL;

# FULL JOIN. Niedostepny w MariaDB. Jako zastapienie left i right joins oraz union.
# Wybierz imiona i nazwiska pracownikow, ktorzy nie obslugiwali zadnych wypozyczen oraz 
# daty wypozyczen bez przypisanych pracownikow
SELECT
    p.imie_pracownika,
    p.nazwisko_pracownika,
    w.data_wyp
FROM pracownicy p
    LEFT JOIN wypozyczenia w ON p.id_pracownika = w.id_pracownika
WHERE w.id_pracownika IS NULL

UNION

SELECT
    p.imie_pracownika,
    p.nazwisko_pracownika,
    w.data_wyp
FROM pracownicy p
    RIGHT JOIN wypozyczenia w ON p.id_pracownika = w.id_pracownika
WHERE w.id_pracownika IS NULL;

# przedstaw wartosc wszystkich wypozyczen dla kazdego klienta
SELECT
    k.id_klienta,
    k.imie_klienta,
    k.nazwisko_klienta,
    SUM(dw.cena_doba * dw.ilosc_dob) 'Lacznie zl'
FROM klienci k
    INNER JOIN  wypozyczenia w ON k.id_klienta = w.id_klienta
    INNER JOIN dane_wypozyczen dw ON w.id_wypozyczenia = dw.id_wypozyczenia
Group By k.id_klienta;

# Laczenie tabel za pomoca kolumn nie bedacych kluczami
# Wybierz pracownikow i klientow pochodzacych z tego samego miasta
SELECT
    k.imie_klienta,
    k.nazwisko_klienta,
    p.imie_pracownika,
    p.nazwisko_pracownika,
    k.miasto_klienta,
    p.miasto_pracownika
FROM klienci k
    INNER JOIN pracownicy p ON k.miasto_klienta = p.miasto_pracownika;
        
# SELF JOIN
# Znajdz przelozonych wszystkch pracownikow
SELECT
    p.nazwisko_pracownika,
    s.nazwisko_pracownika
FROM pracownicy p
    JOIN pracownicy s ON p.szef_id = s.id_pracownika;

# UNION
# Wyswietl date wypozyczenia, imiona i nazwiska klientow, ktorzy wypozyczali i pracownikow, ktorzy obslugiwali wypozyczenia samochodu Audi A4
# imiona i nazwiska klientow i pracownikow musza znalezc sie w tych samych kolumnach
SELECT 
    'Audi A4' AS samochod,
    data_wyp,
    imie_klienta AS imie,
    nazwisko_klienta AS nazwisko,
    'klient' rola
FROM klienci k
    INNER JOIN wypozyczenia w ON k.id_klienta = w.id_klienta
    INNER JOIN dane_wypozyczen dw ON w.id_wypozyczenia = dw.id_wypozyczenia
    INNER JOIN samochody s ON dw.id_samochodu = s.id_samochodu
WHERE 
    marka = 'Audi'
        AND model = 'A4'

UNION

SELECT 
    'Audi A4',
    data_wyp,
    imie_pracownika,
    nazwisko_pracownika,
    'pracownik'
FROM pracownicy p
    INNER JOIN wypozyczenia w ON p.id_pracownika = w.id_pracownika
    INNER JOIN dane_wypozyczen dw ON w.id_wypozyczenia = dw.id_wypozyczenia
    INNER JOIN samochody s ON dw.id_samochodu = s.id_samochodu
WHERE 
    marka = 'Audi'
    AND model = 'A4'
ORDER BY data_wyp;

# Wyswietl imie i nazwisko wszystkich klientow, ktorzy wypozyczyli Renault Clio i Opla Astre
# MySQL nie obsluguje komendy INTERSECT, wiec wykorzystane zostanie podzapytanie.
SELECT 
    imie_klienta,
    nazwisko_klienta
FROM klienci k
    INNER JOIN wypozyczenia w ON k.id_klienta = w.id_klienta
    INNER JOIN dane_wypozyczen dw ON w.id_wypozyczenia = dw.id_wypozyczenia
    INNER JOIN samochody s ON dw.id_samochodu = s.id_samochodu
    WHERE 
        marka = 'Renault' 
	AND model = 'Clio'
        AND k.id_klienta IN (
	    SELECT k.id_klienta 
            FROM samochody s
	        INNER JOIN dane_wypozyczen dw ON dw.id_samochodu = s.id_samochodu
		INNER JOIN wypozyczenia w ON w.id_wypozyczenia = dw.id_wypozyczenia
                INNER JOIN klienci k ON w.id_klienta = k.id_klienta
		WHERE 
		    marka = 'Opel' 
		    AND model = 'Astra');

# EXCEPT dostepny w MySQL od aktualizacji MySQL version 8.0.31
# Wyswietl imiona i nazwiska klientow, którzy wypozyczali Renault Clio ale nie wypozyczali nigdy BMW 3
SELECT 
    k.imie_klienta, 
    k.nazwisko_klienta
FROM klienci k
    INNER JOIN wypozyczenia w ON k.id_klienta = w.id_klienta
    INNER JOIN dane_wypozyczen dw ON w.id_wypozyczenia = dw.id_wypozyczenia
    INNER JOIN samochody s ON dw.id_samochodu = s.id_samochodu
WHERE 
    marka = 'Renault' 
    AND model = 'Clio'

EXCEPT

SELECT 
    k.imie_klienta, 
    k.nazwisko_klienta
FROM klienci k
    INNER JOIN wypozyczenia w ON k.id_klienta = w.id_klienta
    INNER JOIN dane_wypozyczen dw ON w.id_wypozyczenia = dw.id_wypozyczenia
    INNER JOIN samochody s ON dw.id_samochodu = s.id_samochodu
WHERE 
    marka = 'BMW' 
    AND model = '3';

# Wyswietl imiona i nazwiska klientow oraz dane kontaktowe, ktorzy w okresie od maja do konca wrzesnia wypozyczyli auta marki BMW model 3 oraz Mercedesa model CLK
SELECT 
    k.imie_klienta, 
    k.nazwisko_klienta,
    k.telefon_klienta,
    k.email_klienta
FROM klienci k
    INNER JOIN wypozyczenia w ON k.id_klienta = w.id_klienta
    INNER JOIN dane_wypozyczen dw ON w.id_wypozyczenia = dw.id_wypozyczenia
    INNER JOIN samochody s ON dw.id_samochodu = s.id_samochodu
WHERE marka = 'BMW' AND model = '3'
    AND data_wyp BETWEEN '2022-05-01' AND '2022-09-30'
    AND k.id_klienta IN (
        SELECT k.id_klienta
	FROM klienci k
	    INNER JOIN wypozyczenia w ON k.id_klienta = w.id_klienta
	    INNER JOIN dane_wypozyczen dw ON w.id_wypozyczenia = dw.id_wypozyczenia
	    INNER JOIN samochody s ON dw.id_samochodu = s.id_samochodu
	    WHERE 
	        marka = 'Mercedes' 
		AND model = 'CLK'
		AND data_wyp BETWEEN '2022-05-01' AND '2022-09-30');
            
# 

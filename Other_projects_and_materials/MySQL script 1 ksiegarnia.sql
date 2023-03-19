-- phpMyAdmin SQL Dump
-- version 4.0.4.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Czas wygenerowania: 04 Lut 2015, 13:07
-- Wersja serwera: 5.5.32
-- Wersja PHP: 5.4.19
ksiazki
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Baza danych: `ksiegarnia`
--
CREATE DATABASE IF NOT EXISTS `ksiegarnia` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `ksiegarnia`;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `klienci`
--

CREATE TABLE IF NOT EXISTS `klienci` (
  `idklienta` int(11) NOT NULL AUTO_INCREMENT,
  `imie` text COLLATE utf8_polish_ci NOT NULL,
  `nazwisko` text COLLATE utf8_polish_ci NOT NULL,
  `miejscowosc` text COLLATE utf8_polish_ci NOT NULL,
  PRIMARY KEY (`idklienta`),
  KEY `id` (`idklienta`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=11 ;

--
-- Zrzut danych tabeli `klienci`
--

INSERT INTO `klienci` (`idklienta`, `imie`, `nazwisko`, `miejscowosc`) VALUES
(1, 'Łukasz', 'Lewandowski', 'Poznań'),
(2, 'Jan', 'Nowak', 'Katowice'),
(3, 'Maciej', 'Wójcik', 'Bydgoszcz'),
(4, 'Agnieszka', 'Jankowska', 'Lublin'),
(5, 'Tomasz', 'Mazur', 'Jelenia Góra'),
(6, 'Michał', 'Zieliński', 'Kraków'),
(7, 'Artur', 'Rutkowski', 'Kielce'),
(8, 'Mateusz', 'Skorupa', 'Gdańsk'),
(9, 'Jerzy', 'Rutkowski', 'Rybnik'),
(10, 'Anna', 'Karenina', 'Pułtusk');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ksiazki`
--

CREATE TABLE IF NOT EXISTS `ksiazki` (
  `idksiazki` int(11) NOT NULL AUTO_INCREMENT,
  `imieautora` text COLLATE utf8_polish_ci NOT NULL,
  `nazwiskoautora` text COLLATE utf8_polish_ci NOT NULL,
  `tytul` text COLLATE utf8_polish_ci NOT NULL,
  `cena` float NOT NULL,
  PRIMARY KEY (`idksiazki`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=6 ;

--
-- Zrzut danych tabeli `ksiazki`
--

INSERT INTO `ksiazki` (`idksiazki`, `imieautora`, `nazwiskoautora`, `tytul`, `cena`) VALUES
(1, 'Jan', 'Michalak', 'Zaawansowane programowanie w PHP', 47.29),
(2, 'Andrzej', 'Krawczyk', 'Windows 8 PL. Zaawansowana administracja systemem', 49.99),
(3, 'Paweł', 'Jakubowski', 'HTML5. Tworzenie witryn', 53.65),
(4, 'Tomasz', 'Kowalski', 'Urządzenia techniki komputerowej', 34.15),
(5, 'Łukasz', 'Pasternak', 'PHP. Tworzenie nowoczesnych stron WWW', 29.99);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `zamowienia`
--

CREATE TABLE IF NOT EXISTS `zamowienia` (
  `idzamowienia` int(11) NOT NULL AUTO_INCREMENT,
  `idklienta` int(11) NOT NULL,
  `idksiazki` int(11) NOT NULL,
  `data` date NOT NULL,
  `status` text COLLATE utf8_polish_ci NOT NULL,
  PRIMARY KEY (`idzamowienia`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=11 ;

--
-- Zrzut danych tabeli `zamowienia`
--

INSERT INTO `zamowienia` (`idzamowienia`, `idklienta`, `idksiazki`, `data`, `status`) VALUES
(1, 2, 4, '2014-10-08', 'oczekiwanie'),
(2, 7, 1, '2014-09-05', 'wyslano'),
(3, 9, 1, '2014-10-11', 'wyslano'),
(4, 2, 2, '2014-10-15', 'oczekiwanie'),
(5, 2, 5, '2014-08-12', 'oczekiwanie'),
(6, 3, 2, '2014-10-20', 'wyslano'),
(7, 4, 3, '2014-08-14', 'wyslano'),
(8, 8, 1, '2014-08-19', 'wyslano'),
(9, 3, 5, '2014-11-19', 'wyslano'),
(10, 9, 2, '2014-12-28', 'oczekiwanie');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

# 1. Książki ułożone alfabetycznie wg tytułu:
select * from ksiazki order by tytul;
# 2. Najdroższą książkę w bazie
select * from ksiazki order by cena desc limit 1;
# 3. Wszystkie wysłane zamówienia
select * from zamowienia where status = 'wyslano';
# 4. Wszystkich klientów o nazwisku Rutkowski
select * from klienci where nazwisko = "Rutkowski";
# 5. Książki zawierające wyrażenie "PHP" w tytule
SELECT *
FROM ksiazki
WHERE tytul LIKE '%PHP%';
# 6. Zamówienia ułożone od ostatnio dokonanego
SELECT *
FROM zamowienia
ORDER BY data DESC;
# 7. Wyjmij dla wszystkich zamówień: imię i nazwisko klienta zamawiającego, id zamówienia, datę zamówienia
SELECT imie, nazwisko, idzamowienia, data
FROM klienci k, zamowienia z
WHERE k.idklienta = z.idklienta;
# 8. Imiona i nazwiska osób, które zamówiły kiedykolwiek książkę nr 2
SELECT imie, nazwisko
FROM klienci k, zamowienia z
WHERE z.idksiazki = 2 
AND k.idklienta = z.idklienta;
# 9. Jakie książki (tytuł, autor) zamówiła osoba: Jan Nowak?
SELECT imie, nazwisko, tytul, imieautora, nazwiskoautora 
FROM klienci k, zamowienia z, ksiazki ks
WHERE imie='Jan' AND nazwisko='Nowak'
AND k.idklienta = z.idklienta 
AND ks.idksiazki = z.idksiazki;
# 10. Zamówienia dokonane przez osoby o nazwisku Rutkowski ułożone wg daty od najpóźniej dokonanych 
# (imię i nazwisko osoby zamawiającej, id, datę i status zamówienia, tytuł zamówionej książki)
SELECT imie, nazwisko, idzamowienia, data, status, tytul
FROM klienci k, zamowienia z, ksiazki ks
where nazwisko='Rutkowski'
AND k.idklienta = z.idklienta 
AND ks.idksiazki = z.idksiazki; 
 # Zmien naszwisko klientki Agnieszka Jankowska
 update klienci set nazwisko = 'Stankiewicz' where imie = 'Agnieszka' and nazwisko = 'Jankowska';
# Zwieksz cene wszystkch ksiazek o 10%
update ksiazki set cena = round(cena * 1.1, 2);
# Zmniejsz cene najdrozszej ksiazki w bazie o 10 zl
update ksiazki set cena = cena-10 order by cena desc limit 1;
# Zmien status zamowienia na wyslana dla zamowien o id 4 i 5
update zamowienia set status = 'wyslano' where idzamowienia between 4 and 5;
# Dodaj nowe zamowienie
insert into zamowienia (idklienta, idksiazki, status, data) values (7, 3, 'oczekiwanie', '2023-01-01');
# Usun zamowienie o id zamowienia rownym 11
delete from zamowienia where idzamowienia = 11;
# Usun informacje o miejscu zamieszkania klienta o id rownym 7
update klienci set miejscowosc = '' where idklienta = 7;
# Usun pieciu najnowszych klientow
delete from klienci order by idklieenta desc limit 5;
# Usun tabele zamowienia
drop table if exists zamowienia;
# Usun wszystkie dane z tabeli zamowienia
truncate table  zamowienia;
# Usun baze danych ksiegarnia
drop database if exists ksiegarnia;


 select * from klienci;

drop index id_klienta on wypozyczenia;
-- Duy Tien Nguyen, s80287, 47464
-- Aufgabe A7
-- A7_1
-- Umsatzbetrag je Monat, Mitarbeiter, Produkt und Bundesland
-- Bundesland: Sachsen u. Th�ringen
-- SUM unn�tig: Mon, Mit, Produkt, Bundesland Kombination eindeutig

SELECT u.Mon_ID, u.Mitarbeiter_ID, u.Produkt_ID, g.Bundesland, SUM(u.Umsatzbetrag) AS Umsatzbetragssumme
FROM Umsatzdaten u
JOIN Zeit z ON u.Mon_ID = z.Mon_ID
JOIN MitarbeiterShop m ON u.Mitarbeiter_ID = m.Mitarbeiter_ID
JOIN Produkt p ON u.Produkt_ID = p.Produkt_ID
JOIN Geografie g ON u.Land_ID = g.Land_ID
WHERE g.Bundesland IN ('Sachsen', 'Th�ringen')
GROUP BY u.Mon_ID, u.Mitarbeiter_ID, u.Produkt_ID, g.Bundesland;

-- A7_2
-- Summe v. Umsatzbetrag u. Umsatzmenge Bundesland Sachsen, Th�ringen
SELECT g.Bundesland, SUM(u.Umsatzbetrag) AS Umsatzbetragssumme, SUM(u.Umsatzmenge) AS Umsatzmengensumme
FROM Umsatzdaten u
JOIN Geografie g ON u.Land_ID = g.Land_ID
WHERE g.Bundesland IN ('Sachsen', 'Th�ringen')
GROUP BY g.Bundesland;

-- A7_3
-- erweitern A7_2, Anzeige Quartal (Q_ID)
SELECT z.Q_ID, g.Bundesland, SUM(u.Umsatzbetrag) AS Umsatzbetragssumme, SUM(u.Umsatzmenge) AS Umsatzmengensumme
FROM Umsatzdaten u
JOIN Geografie g ON u.Land_ID = g.Land_ID
JOIN Zeit z ON u.Mon_ID = u.Mon_ID
WHERE g.Bundesland IN ('Sachsen', 'Th�ringen')
GROUP BY z.Q_ID, g.Bundesland;

-- A7_4
-- Umsatzbetrag je Staat u. Produktsubkategorie
SELECT ps.Subkategorie, g.Staat, SUM(u.Umsatzbetrag) AS Umsatzbetrag
FROM Umsatzdaten u
JOIN Geografie g ON u.Land_ID = g.Land_ID
JOIN Produkt p ON u.Produkt_ID = p.Produkt_ID
JOIN Produktsubkategorie ps ON p.Subkategorie_ID = ps.Subkategorie_ID
GROUP BY ps.Subkategorie, g.Staat;

-- A7_5
-- erweitern A7_4, Teilsumme
SELECT ps.Subkategorie, g.Staat, SUM(u.Umsatzbetrag) AS Umsatzbetrag
FROM Umsatzdaten u
JOIN Geografie g ON u.Land_ID = g.Land_ID
JOIN Produkt p ON u.Produkt_ID = p.Produkt_ID
JOIN Produktsubkategorie ps ON p.Subkategorie_ID = ps.Subkategorie_ID
GROUP BY CUBE(ps.Subkategorie, g.Staat);

-- A7_6
-- erweitern A7_5, Jahre
SELECT z.Jahr, ps.Subkategorie, g.Staat, SUM(u.Umsatzbetrag) AS Umsatzbetrag
FROM Umsatzdaten u
JOIN Zeit z ON u.Mon_ID = z.Mon_ID
JOIN Geografie g ON u.Land_ID = g.Land_ID
JOIN Produkt p ON u.Produkt_ID = p.Produkt_ID
JOIN Produktsubkategorie ps ON p.Subkategorie_ID = ps.Subkategorie_ID
GROUP BY CUBE(z.Jahr, ps.Subkategorie, g.Staat);

-- A7_7
-- Umsatzbetr�ge je Staat, Region, Bundesland + Teilsumme Hierarchie
SELECT g.Staat, g.Region, g.Bundesland, SUM(u.Umsatzbetrag) AS Umsatzbetr�ge
FROM Umsatzdaten u
JOIN Geografie g ON u.Land_ID = g.Land_ID
GROUP BY ROLLUP(g.Staat, g.Region, g.Bundesland);

-- A7_8
-- Umsatzbetr�ge je Kategorie, Subkategorie, Produktname + Teilsumme Hierarchie
SELECT k.Kategorie, sk.Subkategorie, p.Produktname, SUM(u.Umsatzbetrag) AS Umsatzbetr�ge
FROM Umsatzdaten u
JOIN Produkt p ON u.Produkt_ID = p.Produkt_ID
JOIN Produktsubkategorie sk ON p.Subkategorie_ID = sk.Subkategorie_ID
JOIN Produktkategorie k ON sk.Kategorie_ID = k.Kategorie_ID
GROUP BY ROLLUP(k.Kategorie, sk.Subkategorie, p.Produktname);

-- A7_9
-- modifizieren A7_9: statt Produktname -> Kombi. Markenname + Produktname
SELECT k.Kategorie, sk.Subkategorie, p.Markenname + ' ' + p.Produktname AS Produkt
	, SUM(u.Umsatzbetrag) AS Umsatzbetr�ge
FROM Umsatzdaten u
JOIN Produkt p ON u.Produkt_ID = p.Produkt_ID
JOIN Produktsubkategorie sk ON p.Subkategorie_ID = sk.Subkategorie_ID
JOIN Produktkategorie k ON sk.Kategorie_ID = k.Kategorie_ID
GROUP BY ROLLUP(k.Kategorie, sk.Subkategorie, p.Markenname + ' ' + p.Produktname);

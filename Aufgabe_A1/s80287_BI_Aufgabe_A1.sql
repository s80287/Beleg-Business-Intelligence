-- s80287, Duy Tien Nguyen

-- Aufgabe A_1

-- Aufgabe A_1-2
-- Tabelle Geografie
CREATE TABLE Geografie (
	Land_ID		VARCHAR(2) PRIMARY KEY,
	Bundesland	VARCHAR(25),
	Region		VARCHAR(25),
	Staat		VARCHAR(25)
);

-- Tabelle MitarbeiterShop
CREATE TABLE MitarbeiterShop (
	Mitarbeiter_ID	VARCHAR(2) PRIMARY KEY,
	Name VARCHAR(25)
);

-- Tabelle Produktkategorie
CREATE TABLE Produktkategorie (
	Kategorie_ID		VARCHAR(2) PRIMARY KEY,
	Kategorie			VARCHAR(25),
	Kategorie_Manager	VARCHAR(25)
);

-- Tabelle Produktsubkategorie
CREATE TABLE Produktsubkategorie (
	Subkategorie_ID			VARCHAR(3) PRIMARY KEY,
	Subkategorie			VARCHAR(25),
	Subkategorie_Manager	VARCHAR(25),
	Kategorie_ID			VARCHAR(2)
		FOREIGN KEY REFERENCES Produktkategorie(Kategorie_ID)
);

-- Tabelle Produkt
CREATE TABLE Produkt (
	Produkt_ID		VARCHAR(4) PRIMARY KEY,
	Markenname		VARCHAR(25),
	Produktname		VARCHAR(40),
	Preis			MONEY,
	Subkategorie_ID	VARCHAR(3)
		FOREIGN KEY REFERENCES Produktsubkategorie(Subkategorie_ID)	
);

-- Tabelle Zeit
CREATE TABLE Zeit (
	Mon_ID		VARCHAR(6) PRIMARY KEY,
	Monatsname	VARCHAR(20),
	Q_ID		VARCHAR(6),
	Quartal		VARCHAR(10),
	Jahr		VARCHAR(4)
);

SELECT * FROM Zeit;

-- Tabelle Umsatzdaten
CREATE TABLE Umsatzdaten (
	Mon_ID			VARCHAR(6) FOREIGN KEY REFERENCES Zeit(Mon_ID),
	-- Fehler erst vor dem Ausf�hren ignorieren
	Land_ID			VARCHAR(2) FOREIGN KEY REFERENCES Geografie(Land_ID),
	Produkt_ID		VARCHAR(4) FOREIGN KEY REFERENCES Produkt(Produkt_ID),
	Mitarbeiter_ID	VARCHAR(2) FOREIGN KEY REFERENCES MitarbeiterShop(Mitarbeiter_ID),
	Umsatzbetrag	MONEY,
	Umsatzmenge		INTEGER,
	PRIMARY KEY (Mon_ID, Land_ID, Produkt_ID, Mitarbeiter_ID)
);


-- Aufgabe A_1-3
-- INSERT INTO Geografie
INSERT INTO Geografie VALUES('01', 'Sachsen', 'Ost', 'Deutschland');
INSERT INTO Geografie VALUES('02', 'Bayern', 'S�d', 'Deutschland');
INSERT INTO Geografie VALUES('03', 'Saarland', 'West', 'Deutschland');
INSERT INTO Geografie VALUES('04', 'Nordrhein-Westfalen', 'West', 'Deutschland');
INSERT INTO Geografie VALUES('05', 'Baden-W�rttemberg', 'S�d', 'Deutschland');
INSERT INTO Geografie VALUES('06', 'Rheinland-Pfalz', 'West', 'Deutschland');
INSERT INTO Geografie VALUES('07', 'Niedersachsen', 'West', 'Deutschland');
INSERT INTO Geografie VALUES('08', 'Schleswig-Holstein', 'Nord', 'Deutschland');
INSERT INTO Geografie VALUES('09', 'Hamburg', 'Nord', 'Deutschland');
INSERT INTO Geografie VALUES('10', 'Bremen', 'Nord', 'Deutschland');
INSERT INTO Geografie VALUES('11', 'Mecklenburg-Vorpommern', 'Nord', 'Deutschland');
INSERT INTO Geografie VALUES('12', 'Brandenburg', 'Ost', 'Deutschland');
INSERT INTO Geografie VALUES('13', 'Berlin', 'Ost', 'Deutschland');
INSERT INTO Geografie VALUES('14', 'Sachsen-Anhalt', 'Ost', 'Deutschland');
INSERT INTO Geografie VALUES('15', 'Th�ringen', 'Ost', 'Deutschland');
INSERT INTO Geografie VALUES('16', 'Hessen', 'West', 'Deutschland');
INSERT INTO Geografie VALUES('17', 'Valais', 'S�d', 'Schweiz');
INSERT INTO Geografie VALUES('18', 'Ticino', 'S�d', 'Schweiz');
INSERT INTO Geografie VALUES('19', 'Graub�nden', 'Ost', 'Schweiz');
INSERT INTO Geografie VALUES('20', 'Geneva', 'S�d', 'Schweiz');
INSERT INTO Geografie VALUES('21', 'Vaud', 'West', 'Schweiz');
INSERT INTO Geografie VALUES('22', 'Fribourg', 'West', 'Schweiz');
INSERT INTO Geografie VALUES('23', 'Bern', 'West', 'Schweiz');
INSERT INTO Geografie VALUES('24', 'Neuch�tel', 'West', 'Schweiz');
INSERT INTO Geografie VALUES('25', 'Jura', 'Nord', 'Schweiz');
INSERT INTO Geografie VALUES('26', 'Basel', 'Nord', 'Schweiz');
INSERT INTO Geografie VALUES('27', 'Solothurn', 'Nord', 'Schweiz');
INSERT INTO Geografie VALUES('28', 'Aargau', 'Nord', 'Schweiz');
INSERT INTO Geografie VALUES('29', 'Schaffhausen', 'Nord', 'Schweiz');
INSERT INTO Geografie VALUES('30', 'Z�rich', 'Nord', 'Schweiz');
INSERT INTO Geografie VALUES('31', 'Luzern', 'West', 'Schweiz');
INSERT INTO Geografie VALUES('32', 'Unterwalden', 'West', 'Schweiz');
INSERT INTO Geografie VALUES('33', 'Appenzell', 'Ost', 'Schweiz');
INSERT INTO Geografie VALUES('34', 'Sankt Gallen', 'Ost', 'Schweiz');
INSERT INTO Geografie VALUES('35', 'Zug', 'Ost', 'Schweiz');
INSERT INTO Geografie VALUES('36', 'Schwyz', 'Ost', 'Schweiz');
INSERT INTO Geografie VALUES('37', 'Glarus', 'Ost', 'Schweiz');
INSERT INTO Geografie VALUES('38', 'Uri', 'Ost', 'Schweiz');
INSERT INTO Geografie VALUES('39', 'Vorarlberg', '�sterreich', '�sterreich');
INSERT INTO Geografie VALUES('40', 'Tirol', '�sterreich', '�sterreich');
INSERT INTO Geografie VALUES('41', 'Salzburg', '�sterreich', '�sterreich');
INSERT INTO Geografie VALUES('42', 'Ober�sterreich', '�sterreich', '�sterreich');
INSERT INTO Geografie VALUES('43', 'Nieder�sterreich', '�sterreich', '�sterreich');
INSERT INTO Geografie VALUES('44', 'Burgenland', '�sterreich', '�sterreich');
INSERT INTO Geografie VALUES('45', 'Steiermark', '�sterreich', '�sterreich');
INSERT INTO Geografie VALUES('46', 'K�rnten', '�sterreich', '�sterreich');


-- INSERT INTO MitarbeiterShop
INSERT INTO MitarbeiterShop VALUES('01', 'Sybille Neubert');
INSERT INTO MitarbeiterShop VALUES('02', 'NULL');
INSERT INTO MitarbeiterShop VALUES('03', 'Maja G�nther');
INSERT INTO MitarbeiterShop VALUES('04', 'B�rbel Blumberg');
INSERT INTO MitarbeiterShop VALUES('05', 'Jonas M�ller');
INSERT INTO MitarbeiterShop VALUES('06', 'Rebecca Kunze');
INSERT INTO MitarbeiterShop VALUES('08', 'Horst Lehmann');
INSERT INTO MitarbeiterShop VALUES('09', 'Ralf F�rster');
INSERT INTO MitarbeiterShop VALUES('10', 'Heidemarie Fl�gel');
INSERT INTO MitarbeiterShop VALUES('11', 'Lucie Heinrich');
INSERT INTO MitarbeiterShop VALUES('12', 'Gudrun Dammeier');
INSERT INTO MitarbeiterShop VALUES('14', 'Heinrich Gans');
INSERT INTO MitarbeiterShop VALUES('16', 'Lutz �resund');
INSERT INTO MitarbeiterShop VALUES('17', 'Sven Klaus');
INSERT INTO MitarbeiterShop VALUES('18', 'Jens Meier');
INSERT INTO MitarbeiterShop VALUES('20', 'Dorit Gille');



-- INSERT INTO Produkt
-- Preis mit '.' trennen, nicht mit ','

--DELETE FROM Umsatzdaten;
--DROP TABLE Umsatzdaten;

--DELETE FROM UmsatzdatenTMP;
--DROP TABLE UmsatzdatenTMP;

--DROP TABLE BelegeTMP;

--DELETE FROM Produkt;

--SELECT * FROM Produkt;

INSERT INTO Produkt VALUES('1001', 'German', 'Leinsamen', '2.45', '007');
INSERT INTO Produkt VALUES('1002', 'German', '�pfel', '1.2', '006');
INSERT INTO Produkt VALUES('1003', 'German', 'Aubergine', '3', '005');
INSERT INTO Produkt VALUES('1004', 'German', 'Blumenkohl', '2.05', '005');
INSERT INTO Produkt VALUES('1005', 'German', 'Brokkoli', '1.1', '005');
INSERT INTO Produkt VALUES('1006', 'German', 'gr�ne Linsen', '0.26', '003');
INSERT INTO Produkt VALUES('1007', 'German', 'Berglinsen', '1.48', '003');
INSERT INTO Produkt VALUES('1008', 'German', 'rote Linsen', '3.05', '003');
INSERT INTO Produkt VALUES('1009', 'German', 'Kichererbsen', '2.49', '003');
INSERT INTO Produkt VALUES('1010', 'German', 'R�uchertofu', '2.04', '004');
INSERT INTO Produkt VALUES('1011', 'German', 'Walln�sse', '2.15', '007');
INSERT INTO Produkt VALUES('1012', 'German', 'Birnen', '0.97', '006');
INSERT INTO Produkt VALUES('1013', 'German', 'Pinienkerne', '2.21', '007');
INSERT INTO Produkt VALUES('1101', 'Selfcooking', 'Walln�sse', '1.4', '007');
INSERT INTO Produkt VALUES('1102', 'Selfcooking', '�pfel', '0.79', '006');
INSERT INTO Produkt VALUES('1103', 'Selfcooking', 'Aubergine', '1.15', '005');
INSERT INTO Produkt VALUES('1104', 'Selfcooking', 'Blumenkohl', '0.86', '005');
INSERT INTO Produkt VALUES('1105', 'Selfcooking', 'Brokkoli', '2.29', '005');
INSERT INTO Produkt VALUES('1106', 'Selfcooking', 'gr�ne Linsen', '1.68', '003');
INSERT INTO Produkt VALUES('1107', 'Selfcooking', 'Berglinsen', '0.66', '003');
INSERT INTO Produkt VALUES('1108', 'Selfcooking', 'rote Linsen', '2.51', '003');
INSERT INTO Produkt VALUES('1109', 'Selfcooking', 'Kichererbsen', '1.23', '003');
INSERT INTO Produkt VALUES('1110', 'Selfcooking', 'R�uchertofu', '1.02', '004');
INSERT INTO Produkt VALUES('1111', 'Selfcooking', 'Pinienkerne', '1.47', '007');
INSERT INTO Produkt VALUES('1112', 'Selfcooking', 'Birnen', '1.31', '006');
INSERT INTO Produkt VALUES('1113', 'Selfcooking', 'Leinsamen', '1.14', '007');
INSERT INTO Produkt VALUES('1201', 'Biom�hle', 'Dinkelbrot', '1.36', '010');
INSERT INTO Produkt VALUES('1202', 'Biom�hle', 'Vollkornbrot', '1.65', '010');
INSERT INTO Produkt VALUES('1203', 'Biom�hle', 'Heidelbeermuffins', '1.96', '009');
INSERT INTO Produkt VALUES('1204', 'Biom�hle', 'Bagels', '1.09', '001');
INSERT INTO Produkt VALUES('1205', 'Biom�hle', 'Schokomuffins', '1.58', '009');
INSERT INTO Produkt VALUES('1206', 'Biom�hle', 'Preiselbeermuffins', '1.5', '009');
INSERT INTO Produkt VALUES('1207', 'Biom�hle', 'Roggenbrot', '3.49', '010');
INSERT INTO Produkt VALUES('1208', 'Biom�hle', 'Pumpernickel', '2.01', '010');
INSERT INTO Produkt VALUES('1209', 'Biom�hle', 'engl. Muffins', '1.42', '009');
INSERT INTO Produkt VALUES('1301', 'Carmens', 'Heidelbeerjoghurt', '2.58', '012');
INSERT INTO Produkt VALUES('1302', 'Carmens', 'Reisdrink', '0.85', '008');
INSERT INTO Produkt VALUES('1303', 'Carmens', 'Dinkeldrink', '1.03', '008');
INSERT INTO Produkt VALUES('1304', 'Carmens', 'Mandelmilch', '0.6', '008');
INSERT INTO Produkt VALUES('1305', 'Carmens', 'Cheddar, mild', '1.74', '002');
INSERT INTO Produkt VALUES('1306', 'Carmens', 'Sojamilch', '1.02', '008');
INSERT INTO Produkt VALUES('1307', 'Carmens', 'Naturjoghurt', '1.61', '012');
INSERT INTO Produkt VALUES('1308', 'Carmens', 'Hafermilch', '3.05', '008');
INSERT INTO Produkt VALUES('1309', 'Carmens', 'Creme fraiche', '0.52', '011');
INSERT INTO Produkt VALUES('1310', 'Carmens', 'Creme legere', '2.22', '011');
INSERT INTO Produkt VALUES('1311', 'Carmens', 'Leerdammer', '0.71', '002');
INSERT INTO Produkt VALUES('1312', 'Carmens', 'M�nster K�se', '0.5', '002');
INSERT INTO Produkt VALUES('1313', 'Carmens', 'Cheddar, scharf', '1.35', '002');
INSERT INTO Produkt VALUES('1314', 'Carmens', 'Appenzeller', '1.64', '002');
INSERT INTO Produkt VALUES('1315', 'Carmens', 'Old Amsterdam', '0.78', '002');
INSERT INTO Produkt VALUES('1316', 'Carmens', 'Havarti K�se', '3.39', '002');
INSERT INTO Produkt VALUES('1317', 'Carmens', 'Leerdammer charactere', '1.83', '002');
INSERT INTO Produkt VALUES('1318', 'Carmens', 'Leerdammer lite', '3.55', '002');
INSERT INTO Produkt VALUES('1401', 'Ich Darf', 'Blumenkohl', '1.13', '005');
INSERT INTO Produkt VALUES('1402', 'Ich Darf', 'Aubergine', '1.81', '005');
INSERT INTO Produkt VALUES('1403', 'Ich Darf', 'Birnen', '1.22', '006');
INSERT INTO Produkt VALUES('1404', 'Ich Darf', 'Brokkoli', '0.9', '005');
INSERT INTO Produkt VALUES('1405', 'Ich Darf', 'Seidentofu', '2.34', '004');
INSERT INTO Produkt VALUES('1406', 'Ich Darf', '�pfel', '2.68', '006');
INSERT INTO Produkt VALUES('1407', 'Ich Darf', 'Leinsamen', '1.46', '007');
INSERT INTO Produkt VALUES('1408', 'Ich Darf', 'Berglinsen', '2.39', '003');
INSERT INTO Produkt VALUES('1409', 'Ich Darf', 'rote Linsen', '1.79', '003');
INSERT INTO Produkt VALUES('1410', 'Ich Darf', 'Kichererbsen', '2.3', '003');
INSERT INTO Produkt VALUES('1411', 'Ich Darf', 'Walln�sse', '1.37', '007');
INSERT INTO Produkt VALUES('1412', 'Ich Darf', 'Pinienkerne', '0.53', '007');
INSERT INTO Produkt VALUES('1413', 'Ich Darf', 'gr�ne Linsen', '1.31', '003');
INSERT INTO Produkt VALUES('1501', 'Bioweide', 'Old Amsterdam', '0.96', '002');
INSERT INTO Produkt VALUES('1502', 'Bioweide', 'Appenzeller', '0.41', '002');
INSERT INTO Produkt VALUES('1503', 'Bioweide', 'Cheddar, scharf', '0.99', '002');
INSERT INTO Produkt VALUES('1504', 'Bioweide', 'Cheddar, mild', '0.62', '002');
INSERT INTO Produkt VALUES('1505', 'Bioweide', 'Havarti K�se', '2.55', '002');
INSERT INTO Produkt VALUES('1506', 'Bioweide', 'Mandelmilch', '0.41', '008');
INSERT INTO Produkt VALUES('1507', 'Bioweide', 'Leerdammer', '1.8', '002');
INSERT INTO Produkt VALUES('1508', 'Bioweide', 'Dinkeldrink', '2.16', '008');
INSERT INTO Produkt VALUES('1509', 'Bioweide', 'Reisdrink', '1.03', '008');
INSERT INTO Produkt VALUES('1510', 'Bioweide', 'Hafermilch', '2.53', '008');
INSERT INTO Produkt VALUES('1511', 'Bioweide', 'Leerdammer charactere', '1.11', '002');
INSERT INTO Produkt VALUES('1512', 'Bioweide', 'M�nster K�se', '1.43', '002');
INSERT INTO Produkt VALUES('1513', 'Bioweide', 'Creme fraiche', '1.85', '011');
INSERT INTO Produkt VALUES('1514', 'Bioweide', 'Creme legere', '1.41', '011');
INSERT INTO Produkt VALUES('1515', 'Bioweide', 'Sojamilch', '2.93', '008');
INSERT INTO Produkt VALUES('1516', 'Bioweide', 'Naturjoghurt', '2.97', '012');
INSERT INTO Produkt VALUES('1517', 'Bioweide', 'Heidelbeerjoghurt', '3.12', '012');
INSERT INTO Produkt VALUES('1518', 'Bioweide', 'Leerdammer lite', '1.65', '002');
INSERT INTO Produkt VALUES('1601', 'Regiom�hle', 'Vollkornbrot', '1.3', '010');
INSERT INTO Produkt VALUES('1602', 'Regiom�hle', 'Dinkelbrot', '0.75', '010');
INSERT INTO Produkt VALUES('1603', 'Regiom�hle', 'Pumpernickel', '2.69', '010');
INSERT INTO Produkt VALUES('1604', 'Regiom�hle', 'engl. Muffins', '1.23', '009');
INSERT INTO Produkt VALUES('1605', 'Regiom�hle', 'Preiselbeermuffins', '1.38', '009');
INSERT INTO Produkt VALUES('1606', 'Regiom�hle', 'Schokomuffins', '0.59', '009');
INSERT INTO Produkt VALUES('1607', 'Regiom�hle', 'Roggenbrot', '1.53', '010');
INSERT INTO Produkt VALUES('1608', 'Regiom�hle', 'Bagels', '2.58', '001');
INSERT INTO Produkt VALUES('1609', 'Regiom�hle', 'Heidelbeermuffins', '0.61', '009');
INSERT INTO Produkt VALUES('1701', 'Black Toast', 'engl. Muffins', '0.96', '009');
INSERT INTO Produkt VALUES('1702', 'Black Toast', 'Pumpernickel', '0.22', '010');
INSERT INTO Produkt VALUES('1703', 'Black Toast', 'Roggenbrot', '0.67', '010');
INSERT INTO Produkt VALUES('1704', 'Black Toast', 'Preiselbeermuffins', '2.05', '009');
INSERT INTO Produkt VALUES('1705', 'Black Toast', 'Schokomuffins', '1.22', '009');
INSERT INTO Produkt VALUES('1706', 'Black Toast', 'Bagels', '1.26', '001');
INSERT INTO Produkt VALUES('1707', 'Black Toast', 'Heidelbeermuffins', '2.3', '009');
INSERT INTO Produkt VALUES('1708', 'Black Toast', 'Dinkelbrot', '1.69', '010');
INSERT INTO Produkt VALUES('1709', 'Black Toast', 'Vollkornbrot', '2.75', '010');
INSERT INTO Produkt VALUES('1801', 'Freiland', 'engl. Muffins', '2.21', '009');
INSERT INTO Produkt VALUES('1802', 'Freiland', 'Dinkelbrot', '0.73', '010');
INSERT INTO Produkt VALUES('1803', 'Freiland', 'Heidelbeermuffins', '2.5', '009');
INSERT INTO Produkt VALUES('1804', 'Freiland', 'Bagels', '1.75', '001');
INSERT INTO Produkt VALUES('1805', 'Freiland', 'Schokomuffins', '2.6', '009');
INSERT INTO Produkt VALUES('1806', 'Freiland', 'Preiselbeermuffins', '2.58', '009');
INSERT INTO Produkt VALUES('1807', 'Freiland', 'Vollkornbrot', '3.03', '010');
INSERT INTO Produkt VALUES('1808', 'Freiland', 'Pumpernickel', '3.07', '010');
INSERT INTO Produkt VALUES('1809', 'Freiland', 'Roggenbrot', '2.31', '010');
INSERT INTO Produkt VALUES('1901', 'Dresdner', 'Leinsamen', '1.4', '007');
INSERT INTO Produkt VALUES('1902', 'Dresdner', 'Kichererbsen', '1.75', '003');
INSERT INTO Produkt VALUES('1903', 'Dresdner', 'Birnen', '2.6', '006');
INSERT INTO Produkt VALUES('1904', 'Dresdner', '�pfel', '2.35', '006');
INSERT INTO Produkt VALUES('1905', 'Dresdner', 'Aubergine', '2.61', '005');
INSERT INTO Produkt VALUES('1906', 'Dresdner', 'R�uchertofu', '0.66', '004');
INSERT INTO Produkt VALUES('1907', 'Dresdner', 'Pinienkerne', '0.59', '007');
INSERT INTO Produkt VALUES('1908', 'Dresdner', 'Blumenkohl', '2.76', '005');
INSERT INTO Produkt VALUES('1909', 'Dresdner', 'Brokkoli', '2.07', '005');
INSERT INTO Produkt VALUES('1910', 'Dresdner', 'gr�ne Linsen', '1.72', '003');
INSERT INTO Produkt VALUES('1911', 'Dresdner', 'Berglinsen', '1.54', '003');
INSERT INTO Produkt VALUES('1912', 'Dresdner', 'rote Linsen', '0.46', '003');
INSERT INTO Produkt VALUES('1913', 'Dresdner', 'Walln�sse', '3.66', '007');
INSERT INTO Produkt VALUES('2001', 'Veggieland', 'Leinsamen', '2.68', '007');
INSERT INTO Produkt VALUES('2002', 'Veggieland', 'rote Linsen', '1.83', '003');
INSERT INTO Produkt VALUES('2003', 'Veggieland', 'Pinienkerne', '1.69', '007');
INSERT INTO Produkt VALUES('2004', 'Veggieland', 'Walln�sse', '3.68', '007');
INSERT INTO Produkt VALUES('2005', 'Veggieland', 'Kichererbsen', '2.34', '003');
INSERT INTO Produkt VALUES('2006', 'Veggieland', 'Berglinsen', '1.26', '003');
INSERT INTO Produkt VALUES('2007', 'Veggieland', 'gr�ne Linsen', '1.52', '003');
INSERT INTO Produkt VALUES('2008', 'Veggieland', 'Brokkoli', '2.35', '005');
INSERT INTO Produkt VALUES('2009', 'Veggieland', 'Blumenkohl', '1.32', '005');
INSERT INTO Produkt VALUES('2010', 'Veggieland', 'Aubergine', '3.38', '005');
INSERT INTO Produkt VALUES('2011', 'Veggieland', '�pfel', '1.78', '006');
INSERT INTO Produkt VALUES('2012', 'Veggieland', 'Birnen', '1.29', '006');
INSERT INTO Produkt VALUES('2013', 'Veggieland', 'Seidentofu', '2.37', '004');
INSERT INTO Produkt VALUES('2101', 'Bergwiese', 'Appenzeller', '2.24', '002');
INSERT INTO Produkt VALUES('2102', 'Bergwiese', 'Hafermilch', '0.95', '008');
INSERT INTO Produkt VALUES('2103', 'Bergwiese', 'Heidelbeerjoghurt', '0.38', '012');
INSERT INTO Produkt VALUES('2104', 'Bergwiese', 'Havarti K�se', '3.07', '002');
INSERT INTO Produkt VALUES('2105', 'Bergwiese', 'Sojamilch', '0.54', '008');
INSERT INTO Produkt VALUES('2106', 'Bergwiese', 'Creme legere', '0.67', '011');
INSERT INTO Produkt VALUES('2107', 'Bergwiese', 'Reisdrink', '1.38', '008');
INSERT INTO Produkt VALUES('2108', 'Bergwiese', 'Dinkeldrink', '1.25', '008');
INSERT INTO Produkt VALUES('2109', 'Bergwiese', 'Mandelmilch', '3.75', '008');
INSERT INTO Produkt VALUES('2110', 'Bergwiese', 'Cheddar, mild', '2.96', '002');
INSERT INTO Produkt VALUES('2111', 'Bergwiese', 'Cheddar, scharf', '2.79', '002');
INSERT INTO Produkt VALUES('2112', 'Bergwiese', 'Old Amsterdam', '2.47', '002');
INSERT INTO Produkt VALUES('2113', 'Bergwiese', 'Leerdammer charactere', '2.95', '002');
INSERT INTO Produkt VALUES('2114', 'Bergwiese', 'Leerdammer lite', '1.54', '002');
INSERT INTO Produkt VALUES('2115', 'Bergwiese', 'Leerdammer', '3.12', '002');
INSERT INTO Produkt VALUES('2116', 'Bergwiese', 'Naturjoghurt', '2.06', '012');
INSERT INTO Produkt VALUES('2117', 'Bergwiese', 'Creme fraiche', '2.26', '011');
INSERT INTO Produkt VALUES('2118', 'Bergwiese', 'M�nster K�se', '1.1', '002');
INSERT INTO Produkt VALUES('2201', 'Biowelt', 'Naturjoghurt', '3.94', '012');
INSERT INTO Produkt VALUES('2202', 'Biowelt', 'Old Amsterdam', '2.6', '002');
INSERT INTO Produkt VALUES('2203', 'Biowelt', 'Leerdammer lite', '0.95', '002');
INSERT INTO Produkt VALUES('2204', 'Biowelt', 'Havarti K�se', '1.04', '002');
INSERT INTO Produkt VALUES('2205', 'Biowelt', 'Heidelbeerjoghurt', '1.82', '012');
INSERT INTO Produkt VALUES('2206', 'Biowelt', 'Appenzeller', '0.74', '002');
INSERT INTO Produkt VALUES('2207', 'Biowelt', 'Sojamilch', '0.35', '008');
INSERT INTO Produkt VALUES('2208', 'Biowelt', 'Hafermilch', '0.89', '008');
INSERT INTO Produkt VALUES('2209', 'Biowelt', 'Reisdrink', '2.08', '008');
INSERT INTO Produkt VALUES('2210', 'Biowelt', 'Leerdammer', '1.74', '002');
INSERT INTO Produkt VALUES('2211', 'Biowelt', 'Mandelmilch', '3.19', '008');
INSERT INTO Produkt VALUES('2212', 'Biowelt', 'Cheddar, mild', '3.17', '002');
INSERT INTO Produkt VALUES('2213', 'Biowelt', 'Cheddar, scharf', '2.02', '002');
INSERT INTO Produkt VALUES('2214', 'Biowelt', 'Creme legere', '0.78', '011');
INSERT INTO Produkt VALUES('2215', 'Biowelt', 'Creme fraiche', '2.04', '011');
INSERT INTO Produkt VALUES('2216', 'Biowelt', 'Dinkeldrink', '0.9', '008');
INSERT INTO Produkt VALUES('2217', 'Biowelt', 'Leerdammer charactere', '1.27', '002');
INSERT INTO Produkt VALUES('2218', 'Biowelt', 'M�nster K�se', '3.74', '002');
INSERT INTO Produkt VALUES('2301', 'Regionalvertrieb', 'Naturjoghurt', '0.62', '012');
INSERT INTO Produkt VALUES('2302', 'Regionalvertrieb', 'Sojamilch', '2.58', '008');
INSERT INTO Produkt VALUES('2303', 'Regionalvertrieb', 'Hafermilch', '1.18', '008');
INSERT INTO Produkt VALUES('2304', 'Regionalvertrieb', 'Reisdrink', '1.78', '008');
INSERT INTO Produkt VALUES('2305', 'Regionalvertrieb', 'Dinkeldrink', '0.62', '008');
INSERT INTO Produkt VALUES('2306', 'Regionalvertrieb', 'Cheddar, mild', '2.51', '002');
INSERT INTO Produkt VALUES('2307', 'Regionalvertrieb', 'Cheddar, scharf', '2.72', '002');
INSERT INTO Produkt VALUES('2308', 'Regionalvertrieb', 'Heidelbeerjoghurt', '3.5', '012');
INSERT INTO Produkt VALUES('2309', 'Regionalvertrieb', 'Mandelmilch', '0.68', '008');
INSERT INTO Produkt VALUES('2310', 'Regionalvertrieb', 'Old Amsterdam', '1.24', '002');
INSERT INTO Produkt VALUES('2311', 'Regionalvertrieb', 'Havarti K�se', '3.1', '002');
INSERT INTO Produkt VALUES('2312', 'Regionalvertrieb', 'Leerdammer charactere', '3.28', '002');
INSERT INTO Produkt VALUES('2313', 'Regionalvertrieb', 'Leerdammer lite', '1.48', '002');
INSERT INTO Produkt VALUES('2314', 'Regionalvertrieb', 'M�nster K�se', '1.56', '002');
INSERT INTO Produkt VALUES('2315', 'Regionalvertrieb', 'Leerdammer', '3.22', '002');
INSERT INTO Produkt VALUES('2316', 'Regionalvertrieb', 'Creme legere', '1.93', '011');
INSERT INTO Produkt VALUES('2317', 'Regionalvertrieb', 'Appenzeller', '1.58', '002');
INSERT INTO Produkt VALUES('2318', 'Regionalvertrieb', 'Creme fraiche', '0.47', '011');
INSERT INTO Produkt VALUES('2401', 'Sachsenm�hle', 'Dinkelbrot', '0.36', '010');
INSERT INTO Produkt VALUES('2402', 'Sachsenm�hle', 'Pumpernickel', '0.67', '010');
INSERT INTO Produkt VALUES('2403', 'Sachsenm�hle', 'Vollkornbrot', '0.65', '010');
INSERT INTO Produkt VALUES('2404', 'Sachsenm�hle', 'Roggenbrot', '3.57', '010');
INSERT INTO Produkt VALUES('2405', 'Sachsenm�hle', 'engl. Muffins', '1.5', '009');
INSERT INTO Produkt VALUES('2406', 'Sachsenm�hle', 'Preiselbeermuffins', '2.45', '009');
INSERT INTO Produkt VALUES('2407', 'Sachsenm�hle', 'Bagels', '3.2', '001');
INSERT INTO Produkt VALUES('2408', 'Sachsenm�hle', 'Heidelbeermuffins', '1.1', '009');
INSERT INTO Produkt VALUES('2409', 'Sachsenm�hle', 'Schokomuffins', '1.57', '009');



-- INSERT INTO Produktsubkategorie
INSERT INTO Produktsubkategorie VALUES('001','Bagels', 'Heidemarie Fl�gel', '01');
INSERT INTO Produktsubkategorie VALUES('002','K�se', 'Ralf F�rster', '02');
INSERT INTO Produktsubkategorie VALUES('003','H�lsenfr�chte', 'B�rbel Blumberg', '03');
INSERT INTO Produktsubkategorie VALUES('004','Sojaprodukte', 'Jonas M�ller', '03');
INSERT INTO Produktsubkategorie VALUES('005','Gem�se', 'Lucie Heinrich', '03');
INSERT INTO Produktsubkategorie VALUES('006','Obst', 'Rebecca Kunze', '03');
INSERT INTO Produktsubkategorie VALUES('007','N�sse und �lsamen', 'Jens Meier', '03');
INSERT INTO Produktsubkategorie VALUES('008','pflanzliche Milch', 'Gudrun Dammeier', '02');
INSERT INTO Produktsubkategorie VALUES('009','Muffins', 'Lutz �resund', '01');
INSERT INTO Produktsubkategorie VALUES('010','Brot', 'Heinrich Gans', '01');
INSERT INTO Produktsubkategorie VALUES('011','Sauerrahm', 'Sven Klaus', '02');
INSERT INTO Produktsubkategorie VALUES('012','Joghurt', 'Dorit Gille', '02');


-- INSERT INTO Produktkategorie
INSERT INTO Produktkategorie VALUES('01', 'Backwaren', 'NULL');
INSERT INTO Produktkategorie VALUES('02', 'Frischwaren', 'Horst Lehmann');
INSERT INTO Produktkategorie VALUES('03', 'Veggie', 'Maja G�nther');


-- Aufgabe A_1-4
-- INSERT INTO Zeit
-- INSERT INTO Zeit VALUES();

INSERT INTO Zeit VALUES('202101', 'Januar', '202101', '1. Quartal', '2021');
INSERT INTO Zeit VALUES('202102', 'Februar', '202101', '1. Quartal', '2021');
INSERT INTO Zeit VALUES('202103', 'M�rz', '202101', '1. Quartal', '2021');
INSERT INTO Zeit VALUES('202104', 'April', '202102', '2. Quartal', '2021');
INSERT INTO Zeit VALUES('202105', 'Mai', '202102', '2. Quartal', '2021');
INSERT INTO Zeit VALUES('202106', 'Juni', '202102', '2. Quartal', '2021');
INSERT INTO Zeit VALUES('202107', 'Juli', '202103', '3. Quartal', '2021');
INSERT INTO Zeit VALUES('202108', 'August', '202103', '3. Quartal', '2021');
INSERT INTO Zeit VALUES('202109', 'September', '202103', '3. Quartal', '2021');
INSERT INTO Zeit VALUES('202110', 'Oktober', '202104', '4. Quartal', '2021');
INSERT INTO Zeit VALUES('202111', 'November', '202104', '4. Quartal', '2021');
INSERT INTO Zeit VALUES('202112', 'Dezember', '202104', '4. Quartal', '2021');
INSERT INTO Zeit VALUES('202201', 'Januar', '202201', '1. Quartal', '2022');
INSERT INTO Zeit VALUES('202202', 'Februar', '202201', '1. Quartal', '2022');
INSERT INTO Zeit VALUES('202203', 'M�rz', '202201', '1. Quartal', '2022');
INSERT INTO Zeit VALUES('202204', 'April', '202202', '2. Quartal', '2022');
INSERT INTO Zeit VALUES('202205', 'Mai', '202202', '2. Quartal', '2022');
INSERT INTO Zeit VALUES('202206', 'Juni', '202202', '2. Quartal', '2022');
INSERT INTO Zeit VALUES('202207', 'Juli', '202203', '3. Quartal', '2022');
INSERT INTO Zeit VALUES('202208', 'August', '202203', '3. Quartal', '2022');
INSERT INTO Zeit VALUES('202209', 'September', '202203', '3. Quartal', '2022');
INSERT INTO Zeit VALUES('202210', 'Oktober', '202204', '4. Quartal', '2022');
INSERT INTO Zeit VALUES('202211', 'November', '202204', '4. Quartal', '2022');
INSERT INTO Zeit VALUES('202212', 'Dezember', '202204', '4. Quartal', '2022');


-- Aufgabe A_1-5
-- �ndern Namen Mitarbeiters in meinen Namen mit Mitarbeiter_ID = '02', Tabelle Mitarbeitershop
UPDATE MitarbeiterShop
SET Name = 'Tien Nguyen'
WHERE Mitarbeiter_ID = '02';

-- �ndern Kategoriemanager in meinen Namen mit Kategorie_ID = '01', Tabelle Produktkategorie 
UPDATE Produktkategorie 
SET Kategorie_Manager = 'Tien Nguyen'
WHERE Kategorie_ID = '01';

-- Neue Spalte Manager_ID in Table MitarbeiterShop einf�gen + Fremdschl�ssel
ALTER TABLE MitarbeiterShop
ADD Manager_ID VARCHAR(2) FOREIGN KEY REFERENCES MitarbeiterShop(Mitarbeiter_ID);

-- Erg�nzen Datens�tze, um Parent-Child-Beziehung-Hierarchie abzubilden
-- INSERT INTO MitarbeiterShop VALUES('', '',);

-- L�schen alter Datens�tze
DELETE FROM MitarbeiterShop;

INSERT INTO MitarbeiterShop VALUES('01', 'Sybille Neubert', '01');
INSERT INTO MitarbeiterShop VALUES('02', 'Tien Nguyen', '01');
INSERT INTO MitarbeiterShop VALUES('03', 'Maja G�nther', '01');
INSERT INTO MitarbeiterShop VALUES('04', 'B�rbel Blumberg', '03');
INSERT INTO MitarbeiterShop VALUES('05', 'Jonas M�ller', '03');
INSERT INTO MitarbeiterShop VALUES('06', 'Rebecca Kunze', '03');
INSERT INTO MitarbeiterShop VALUES('08', 'Horst Lehmann', '01');
INSERT INTO MitarbeiterShop VALUES('09', 'Ralf F�rster', '08');
INSERT INTO MitarbeiterShop VALUES('10', 'Heidemarie Fl�gel', '02');
INSERT INTO MitarbeiterShop VALUES('11', 'Lucie Heinrich', '03');
INSERT INTO MitarbeiterShop VALUES('12', 'Gudrun Dammeier', '08');
INSERT INTO MitarbeiterShop VALUES('14', 'Heinrich Gans', '02');
INSERT INTO MitarbeiterShop VALUES('16', 'Lutz �resund', '02');
INSERT INTO MitarbeiterShop VALUES('17', 'Sven Klaus', '08');
INSERT INTO MitarbeiterShop VALUES('18', 'Jens Meier', '03');
INSERT INTO MitarbeiterShop VALUES('20', 'Dorit Gille', '08');



-- Aufgabe A_1-6
-- Datenbankdiagramm Namen DWH-Schema
-- Diagramm in SQL Server Management Studio


-- Aufgabe A_1-7
-- csv-Dateien herunterladen


-- Aufgabe A_1-8
-- Tabelle BelegeTMP herstellen
CREATE TABLE BelegeTMP(
	Bon_ID VARCHAR(4),
	-- Foreign key zu welcher Tabelle? kann, muss aber nicht
	Fil_ID VARCHAR(5),
	Datum DATE,
	Prod_ID VARCHAR(4),
	Preis MONEY,
	Anzahl INTEGER
);

-- Tabelle UmsatzdatenTMP herstellen
-- gleich Tabelle Umsatzdaten? ja
CREATE TABLE UmsatzdatenTMP (
	Mon_ID			VARCHAR(6),
	-- Fehler erst vor dem Ausf�hren ignorieren
	Land_ID			VARCHAR(2),
	Produkt_ID		VARCHAR(4),
	Mitarbeiter_ID	VARCHAR(2),
	Umsatzbetrag	MONEY,
	Umsatzmenge		INTEGER,
);


-- Daten�bernahme von csv-Dateien
-- 1. Import Daten aus csv-Datei in Tabelle BelegeTMP
-- 8 Male f�r 8 Quartale machen
BULK INSERT BelegeTMP
FROM 'D:\BI\Belege_2021_1.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n');

BULK INSERT BelegeTMP
FROM 'D:\BI\Belege_2021_2.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n');

BULK INSERT BelegeTMP
FROM 'D:\BI\Belege_2021_3.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n');

BULK INSERT BelegeTMP
FROM 'D:\BI\Belege_2021_4.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n');

BULK INSERT BelegeTMP
FROM 'D:\BI\Belege_2022_1.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n');

BULK INSERT BelegeTMP
FROM 'D:\BI\Belege_2022_2.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n');

BULK INSERT BelegeTMP
FROM 'D:\BI\Belege_2022_3.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n');

BULK INSERT BelegeTMP
FROM 'D:\BI\Belege_2022_4.csv'
WITH (FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n');


-- sql-Datei bis hier schon durchgef�hrt

-- 2. Daten�bernahme aus Tabelle BelegTMP in Tabelle UmsatzdatenTMP
-- und Transformation der Daten
-- Mitarbeiter_ID?
INSERT INTO UmsatzdatenTMP (Mon_ID, Land_ID, Produkt_ID, Mitarbeiter_ID, Umsatzbetrag, Umsatzmenge)
-- Erste zwei Stellen von Fil_ID bilden Land_ID
SELECT
	DATEPART(YEAR, Datum) *100 + DATEPART(MONTH, Datum), 
	SUBSTRING(Fil_ID, 1, 2), Prod_ID, '01'
	, SUM(Preis * Anzahl)
	, SUM(Anzahl)
FROM BelegeTMP
GROUP BY 
	DATEPART(YEAR, Datum) *100 + DATEPART(MONTH, Datum), 
		SUBSTRING(Fil_ID, 1, 2), Prod_ID;

-- SELECT * FROM BelegeTMP;

-- 3. Datenanpassung Tabelle UmsatzdatenTMP
-- Mitarbeiter_ID entsprechend Zust�ndigkeit von MA f�r Produktsubkategorie
-- Erweitern Tabelle Produktsubkategorie um 1 Spalte Mitarbeiter_ID
ALTER TABLE Produktsubkategorie
ADD Mitarbeiter_ID VARCHAR(2) 
	FOREIGN KEY REFERENCES MitarbeiterShop(Mitarbeiter_ID);

SELECT * FROM Produktsubkategorie;

SELECT * FROM UmsatzdatenTMP;

SELECT * FROM MitarbeiterShop;

-- weitermachen?
-- Korrelierte Unterabfrage zum Setzen Mitarbeiter_IDs in Tabelle UmsatzdatenTMP
UPDATE Produktsubkategorie 
SET Mitarbeiter_ID =
	(SELECT Mitarbeiter_ID FROM MitarbeiterShop
	WHERE MitarbeiterShop.Name = Produktsubkategorie.Subkategorie_Manager);


-- UPDATE UmsatzdatenTMP
-- SET Mitarbeiter_ID
-- (Product_ID gleich)

-- noch JOIN

--UPDATE UmsatzdatenTMP
--SET Mitarbeiter_ID =
--	(SELECT Mitarbeiter_ID FROM Produktsubkategorie
--	INNER JOIN MitarbeiterShop
--	ON Produktsubkategorie.Subkategorie_Manager = MitarbeiterShop.Name);


UPDATE UmsatzdatenTMP
SET Mitarbeiter_ID = (SELECT Mitarbeiter_ID FROM Produktsubkategorie, Produkt
	WHERE Produktsubkategorie.Subkategorie_ID = Produkt.Subkategorie_ID
		AND Produkt.Produkt_ID = UmsatzdatenTMP.Produkt_ID);

-- 4. �bernahme Daten aus UmsatzTMP in Umsatzdaten
INSERT INTO Umsatzdaten SELECT * FROM UmsatzdatenTMP;

SELECT * FROM Umsatzdaten;

SELECT COUNT(*) AS Anzahl, SUM(Umsatzbetrag) AS Umsatz 
FROM Umsatzdaten;

-- Preis �ndern
SELECT * FROM Produkt;
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
        
class Data:
    """
    Klasse zur Ablage der Daten für die Berechnung
    """
    
    def __init__(self, df : pd.DataFrame):
        """ Konstruktor der Klasse Data
        
        Args:
            df (pd.DataFrame): DataFrame mit den Daten zum Erzeugen des Modells
        """
        
        # Typ-Prüfungen des Übergabeparameters
        if not isinstance(df, pd.DataFrame):
            raise TypeError("Der Übergabeparameter df muss vom Typ pandas.DataFrame sein sein.")
        if len(df) == 0:
            raise ValueError("Das Dateframe df ist leer.")
  
        # DataFrame
        self.Df  = df
        
        # Zielvariable
        self.ClassLabel : str
        
        # Liste mit Werten der Zielvariable
        self.ListOfClassValues : list
        
        # Dictionary der Predictotvariablen mit deren jeweiligen Werten
        self.DictOfAttributes : dict
        
        # Aufteilung der Daten für Training, Validierung und Test
        self.TrainProportion : float   
        self.ValProportion   : float
        self.TestProportion  : float
        
        # max Ausprägungen der Werte in den Ziel- und Predictorvariablen
        self.MaxValues = 20


    def initialize(self, listOfAttributes: list, classLabel: str, trainProportion = 0.6, valProportion = 0.2):
        """Initialisieren der Daten für die Berechnung:\n
        Liste der Attribute und Zielvariable setzen, 
        Labeln der Daten durch Einfügen einer Spalte _split in self.Df mit den Werten \'train\', \'val\' oder \'test\',\n
        optionale Angabe der Anteile an Trainings- und Validierungsdaten, 
        Der Anteil Testdaten wird berechnet mittels: testProportion = 1 - (trainProportion + valProportion).
        
        Args:
            listOfAttributes (list): Liste der Spalten, die aus self.Df als Predictorvaraibele verwendet werden
            classLabel (str): Spalte, die aus self.Df als Zielvariable verwendet wird
            trainProportion (float, optional): Anteil Trainingsdaten, der im Split der Gesamtdatenmenge verwendet wird (Wertebereich 0. - 1.0) Default ist 0.6.
            valProportion (float, optional): Anteil Valierungsdaten, der im Split der Gesamtdatenmenge verwendet wird (Wertebereich 0. - 1.0) Default ist 0.2.
       """
        # Typ-Prüfungen der Übergabeparameter
        if not isinstance(listOfAttributes, list):
            raise TypeError("Der Übergabeparameter listOfAttributes muss vom Typ list sein.")
        if not isinstance(classLabel, str):
            raise TypeError("Der Übergabeparameter classLabel muss vom Typ str sein.")
        if not isinstance(trainProportion, float):
            raise TypeError("Der Übergabeparameter trainProportion muss vom Typ float sein.")
        if not isinstance(valProportion, float):
            raise TypeError("Der Übergabeparameter valProportion muss vom Typ float sein.")
     
        # Prüfung, dass alle Predictorvariablen aus listOfAttributes im DataFrame self enthalten sind
        for attribute in listOfAttributes:
            if attribute not in list(self.Df):
                raise ValueError(f'Die beim Aufruf im Parameter listAttributes angegebene Prediktorvariable \'{attribute}\' ist nicht im Dataframe self.Df enthalten.')

        # Prüfung, dass die Zielvariable classlabel im DataFrame self.Df enthalten ist
        if classLabel not in list(self.Df):
            raise ValueError(f'Die beim Aufruf im Parameter classLabel angegebene Zielvariable \'{classLabel}\' ist nicht im Dataframe self.Df enthalten.')

        # Dictionary der Predictorvariablen mit deren jeweiligen Werten
        self.DictOfAttributes = {}
        for attribute in listOfAttributes:
        # Prüfung, dass max. MaxValues Wertausprägungen der Predictorvariable vorhanden sind
            if len(self.Df[attribute].unique()) > self.MaxValues:
                raise ValueError(f'Die Anzahl der Wertausprägungen der Predictorvariable \'{attribute}\' im DataFrame self.Df ist mit {len(self.Df[attribute].unique())} größer als der maximal zulässige Wert von {self.MaxValues}.')
            self.DictOfAttributes[attribute] = self.Df[attribute].unique()

         # Zielvariable setzen
        self.ClassLabel = classLabel
        
        # Werteliste der Zielvariable
        self.ListOfClassValues = self.Df[self.ClassLabel].unique().tolist()
        # Prüfung, dass max. MaxValues Wertausprägungen der Zielvariable vorhanden sind
        if len(self.ListOfClassValues) > self.MaxValues:
            raise ValueError(f'Die Anzahl der Wertausprägungen der Zielvariable \'{self.ClassLabel}\' im DataFrame self.Df ist mit {len(self.ListOfClassValues)} größer als der maximal zulässige Wert von {self.MaxValues}.')
        
        # Anteil Training- und Validierungsdaten
        self.TrainProportion = trainProportion
        self.ValProportion   = valProportion
        
        # Anteil Testdaten berechnen
        self.TestProportion  = 1.0 - trainProportion - valProportion
        if self.TestProportion < 0.0 :
            self.TestProportion = 0.0   
        
        # DataFrame aufteilen
        self.__split()
        
   
    def __split(self):
        """Aufteilung der Daten in Trainings- Test- udn Valisierungsdaten
        """
        # Spalte _split zum DataFrame hinzufügen
        self.Df['_split'] = np.NAN
    
        # Aufteilung in die Label der Zielvariable im gesamten DataFrame
        # für jeden Wert der Zielvariable Split durchführen
        #  (Beim Split soll die Aufteilung in die Werte der Zielvariable erhalten bleiben)
        for classValue in self.ListOfClassValues:
            mask = self.Df[self.ClassLabel] == classValue
            
            # Anzahl in der Datensätze je Split
            nTotal = len(self.Df[mask])
            nTrain = int(self.TrainProportion * nTotal)
            nVal   = int(self.ValProportion * nTotal)

            i = 0
            # Datensätze mischen und aufteilen
            for row in self.Df[mask].sample(frac = 1, random_state = 1234).iterrows():
                if i < nTrain:
                    # in row[0] steht der von Pandas.DataFrame vergebene Index (Zeilennummer)
                    self.Df.at[row[0],'_split'] = 'train'
                else:
                    if i < (nTrain + nVal):
                        self.Df.at[row[0],'_split'] = 'val'
                    else:
                        self.Df.at[row[0],'_split'] = 'test'    
                i = i + 1
                
        
    def splitCheck(self)-> pd.DataFrame:
        """Ausgabe von Kennzahlen des Splits der Daten
        
        Returns:
            pd.DataFrame: Zusammenfassung des Split-Ergebnisses als DataFrame
        """
        results = {}
        datenBereiche = ['Gesamt','Trainingsdaten','Validierungsdaten','Testdaten']
        
        # Gesamtdatenmenge und Anteil an Gesamt
        dfGes = len(self.Df)
        trainGes = len(self.Df[self.Df["_split"] == "train"])   
        valGes = len(self.Df[self.Df["_split"] == "val"])
        testGes = len(self.Df[self.Df["_split"] == "test"])
        results.update({'Anzahl Datensätze' : [dfGes, trainGes, valGes, testGes]})                      
        results.update({'Anteil an Gesamt' : [1.0, 0.0 if dfGes==0 else trainGes/dfGes, 0.0 if dfGes==0 else valGes/dfGes, 0.0 if dfGes==0 else testGes/dfGes]})
        
        # Datenmengen und Anteile in den Klassifikationen der Zielvariable
        for classValue in self.ListOfClassValues:
            mask = self.Df[self.ClassLabel] == classValue
            dfClassVaulue = self.Df[mask]
            
            dfGesClassValue = len(dfClassVaulue)
            trainGesClassvalue = len(dfClassVaulue[dfClassVaulue["_split"] == "train"])   
            valGesClassvalue = len(dfClassVaulue[dfClassVaulue["_split"] == "val"])
            testGesClassValue = len(dfClassVaulue[dfClassVaulue["_split"] == "test"])
            results.update({f'Anzahl \'{classValue}\'' : [dfGesClassValue, trainGesClassvalue, valGesClassvalue, testGesClassValue]})
            results.update({f'Anteil \'{classValue}\'' : [0.0 if dfGes==0 else dfGesClassValue/dfGes, 0.0 if trainGes==0 else trainGesClassvalue/trainGes,\
                 0.0 if valGes==0 else valGesClassvalue/valGes, 0.0 if testGes==0 else testGesClassValue/testGes]})

        # DataFrame erzeugen
        dataFrameOfResults = pd.DataFrame(results, index = datenBereiche)
        
        return dataFrameOfResults
    
    
    @staticmethod
    def __func(pct, allvalues): 
        absolute = int(pct / 100.*np.sum(allvalues)) 
        return "{:.1f}%\n{:d}".format(pct, absolute)


    @staticmethod
    def showPieCharts(df: pd.DataFrame, attribute : str, classLabel: str):
        """Ausgabe von Kreisdiagrammen zur Datenanalyse für die Werte einer Predictorvariablen

        Args:
            df (pd.DataFrame): DataFrame zur Erzeugung der Diagramme
            attribute (str): Predictorvariable, für deren Werte Diagramme ausgegeben werden
            classLabel (str): Zielvariable, auf deren Grundlage die Diagramme ausgegeben werden
        """
        
        # Typ-Prüfungen der Übergabeparameter
        if not isinstance(df, pd.DataFrame):
            raise TypeError("Der Übergabeparameter df muss vom Typ pandas.DataFrame sein.")
        if not isinstance(attribute, str):
            raise TypeError("Der Übergabeparameter attribute muss vom Typ str sein.")
        if not isinstance(classLabel, str):
            raise TypeError("Der Übergabeparameter classLabel muss vom Typ str sein.")
        if len(df) == 0:
            raise ValueError("Das Dateframe df ist leer.")
        # Prüfung, dass die Zielvariable classlabel im DataFrame df enthalten ist
        if classLabel not in list(df):
            raise ValueError(f'Die beim Aufruf im Parameter classLabel angegebene Zielvariable \'{classLabel}\' ist nicht im Dataframe df enthalten.')
        # Prüfung, dass die Predictorvariable = attribute im DataFrame df enthalten ist
        if attribute not in list(df):
            raise ValueError(f'Die beim Aufruf im Parameter attribute angegebene Predictorvariable \'{attribute}\' ist nicht im Dataframe df enthalten.')
                
        # Wertliste für die Predictorvariable
        groups = df.groupby(attribute).count()
        listOfAttributeValues = groups.index.tolist()
    
        # Grafik für alle Diagramme der Predictorvariable
        plt.figure(figsize=(24,8))
        
        # 1. Zeile - 1. Diagramm:
        # Aufteilung aller Daten laut Predictorvariable
        groups = df.groupby(attribute).count()
        listOfClassValues = groups.index.tolist()
        listOfCountInClass = groups[classLabel].tolist()    
        plt.subplot2grid((2,len(listOfAttributeValues)),(0,0))
        plt.pie(listOfCountInClass, labels= listOfClassValues, autopct = lambda pct: Data.__func(pct, listOfCountInClass))
        plt.title(f'{attribute}', fontdict={'weight': 'bold'})
        plt.text(1, 1, f'{np.sum(listOfCountInClass)}')
        
        # 1.Zeile - 2. Diagramm:
        # Aufteilung aller Daten laut Zielvariable
        groups = df.groupby(classLabel).count()
        listOfClassValues = groups.index.tolist()
        listOfCountInClass = groups[attribute].tolist()
        # wenn mehr als 2 Spalten im Plot vorhanden sind, dann Ausgabe in 3. Spalte
        # sonst Ausagbe in 2. Spalte
        if len(listOfAttributeValues) > 2:
            plt.subplot2grid((2,len(listOfAttributeValues)),(0,2))
        else:
            plt.subplot2grid((2,len(listOfAttributeValues)),(0,1))
        plt.pie(listOfCountInClass, labels= listOfClassValues, autopct = lambda pct: Data.__func(pct, listOfCountInClass))
        plt.title(f'{classLabel}\nalle Werte in {attribute}', fontdict={'style': 'italic'})
        plt.text(1, 1, f'{np.sum(listOfCountInClass)}')
        
        # 2. Zeile:
        # Diagramme für die einzelnen Werte der Predictorvariable
        pos = 0
        for attributeValue in listOfAttributeValues:
            mask = df[attribute] == attributeValue
            labeled_df = df[mask] 
            # Aufteilung für den Attributwert laut Zielvariable
            groups = labeled_df.groupby(classLabel).count()
            listOfClassValues = groups.index.tolist()
            listOfCountInClass = groups[attribute].tolist()
            plt.subplot2grid((2,len(listOfAttributeValues)),(1,pos))
            plt.pie(listOfCountInClass, labels= listOfClassValues, autopct = lambda pct: Data.__func(pct, listOfCountInClass))
            plt.title(f'{attributeValue}', fontdict={'style': 'italic'})
            plt.text(1, 1, f'{np.sum(listOfCountInClass)}')
            # Position im Plot
            pos = pos + 1
        
        plt.show()
        return
 
        
        
        
        
        
    


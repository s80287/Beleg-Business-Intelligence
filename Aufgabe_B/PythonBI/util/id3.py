import pandas as pd
import numpy as np

from util.base import Data

class Node:
    """Klasse der Daten eines Knotens im Entscheidungsbaum
    """
    counter = 0
    
    def __init__(self, parentNumber: int, parentValue: str):
        self.ParentNumber = parentNumber
        self.ParentValue = parentValue
        self.ListOfChilds = list()
        
        # Nummer des Knotens       
        Node.counter = Node.counter + 1
        self.Number = Node.counter
        
        # nur im Nichtblattknoten: Attribut (Predigtorvariable) 
        self.Attribute = ""
        
        # Label, d.h. Werte der Zielvariable und Anzahl der Datensätze mit diesem Label im Knoten
        self.ClassValues = {}
        self.Info = 0.0
        
    
class Tree:
    """Klasse der Daten und Funktionen des Entscheidungsbaums 
    """
    def __init__(self):
        
        self.DictOfNodes = {}
        
        # Datenbasis zur Berchnung des Baums
        self.Data : Data
        
        # Pruning-Bedingungen
        #  minimale Elementanzahl in einem Blattknoten
        self.MinElements: int
        #  maximale Anzahl an Ebenen im Baum
        self.MaxLevel: int

    def generateTree(self, data : Data, minElements = 1, maxLevel = 99):
        """Erzeugung eines Entscheidungsbaums nach dem ID3-Algorithmus
        
        Args:
            data (Base.Data): Daten, auf deren Grundlage der Entscheidungsbaum erstellt wird 
            minElements (int, optional): minimale Elementanzahl in einem Blattknoten - Default ist 1.
            maxLevel (int, optional): maximale Anzahl Ebenen im Baum - Default ist 99.
        """
        
        # Typ-Prüfungen der Übergabeparameter
        if not isinstance(data, Data):
            raise TypeError("Der Übergabeparameter data muss vom Typ Base.Data sein.")
        if not isinstance(minElements, int):
            raise TypeError("Der Übergabeparameter minElements muss vom Typ int sein.")
        if not isinstance(maxLevel, int):
            raise TypeError("Der Übergabeparameter maxLevel muss vom Typ int sein.")

        # Daten setzen
        self.Data = data

        # Pruning-Parameter setzen
        self.MinElements = minElements
        self.MaxLevel = maxLevel

        # Node-Counter zurücksetzen
        Node.counter = 0
        
        # Liste der Knoten leeren
        self.DictOfNodes.clear()    
        
        # rekursive Generierung des Entscheidungsbaums auf Basis der Traingsdatenmenge:
        # dafür Wurzelknoten anlegen mit parentNumber = 0 und parentValue = ""
        mask = self.Data.Df["_split"] == "train"
        self.__generateNode(df=self.Data.Df[mask], listOfCandidates=list(self.Data.DictOfAttributes.keys()), parentNumber= 0, parentValue= "")    
        return


    def applyTree(self, dfTest : pd.DataFrame) -> pd.DataFrame:
        """Anwenden des Modells (Entscheidungsbaum) auf die Datensätze des übergebenen DataFrames dfTest

        Args:
            dfTest (pd.DataFrame): DataFrame, auf dessen Datensätze der Entschiedungsbaum angewendet wird
            
        Returns:
            pd.DataFrame: DataFrame mit dem Ergebnis der Anwendung des Modells:\n
            Die Spalte Modell enthält im DataFrame das Ergebnis der Anwendung des Modells auf den Datensatz.\n
            Die Spalte Real enthält im DataFrame das gewünschte Ergebnis für den Datensatz.
        """
        # Typ-Prüfungen der Übergabeparameter
        if not isinstance(dfTest, pd.DataFrame):
            raise TypeError("Der Übergabeparameter dfTest muss vom Typ pandas.DataFrame sein sein.")
        if len(dfTest) == 0:
            raise ValueError("Das Dateframe dfTest ist leer.")
              
        # Wurzelknoten ermitteln (hat immer die Nummer 1)
        node = self.DictOfNodes.get(1)
        if (not isinstance(node, Node)):
            raise TypeError("Der Wurzelknotem muss vom Typ id3.Node sein.")
        
        # Ergebnis des Tests in Listen        
        indizes = []
        modelClassValues = []
        realClassValues = []        
                       
        for ind in dfTest.index:
            real = dfTest[self.Data.ClassLabel][ind]
            row = dfTest.loc[ind]
                
            # Einstiegspunkt je Datensatz ist der Wurzelknoten
            node = self.DictOfNodes.get(1)
            
            while len(node.ListOfChilds) > 0:
                # Liste der Node-Objekte der Childs
                childs = list({self.DictOfNodes.get(number) for number in node.ListOfChilds})
                
                # ParentVaule im Child muss dem Wert von node.Attribute im Datensatz row entsprechen
                child = list(filter(lambda x: x.ParentValue == row[node.Attribute], childs ))
                if(len(child) == 1):  
                    # im Baum eine Ebene gehen           
                    node = child[0] 
            
            # Blattknoten
            # für den Knoten gibt es keine Werte der Klassenaufteilun
            if sum(node.ClassValues.values()) == 0:
                result = 'unbestimmt' 
            else:
                # maximale Klasse nehmen
                result = max(node.ClassValues, key = node.ClassValues.get)    
            
            # Eintrag speichern
            indizes.append(ind)
            modelClassValues.append(result)
            realClassValues.append(real)

        model = pd.Series(modelClassValues, index = indizes)
        real  = pd.Series(realClassValues, index = indizes)
        
        # pd.concat liefert pd.DataFrame
        dfResult = pd.concat([model, real], axis = 1)
        dfResult.columns = ['Modell', 'Real']

        return dfResult     


    def __generateNode(self, df: pd.DataFrame, listOfCandidates: list, parentNumber: int, parentValue: str):
        """Erzeugen des nächsten Knoten im rekursiven Aufruf

        Args:
            df (pd.DataFrame): pandas.DataFrame für das der Knoten erzeugt werden soll
            listOfCandidates (list): Liste der Predictorvariablen, für die Bildung des nächsten Knotesn
            parentNumber (int): Nummer des Vorgängerknotens (0 beim Wurzelknoten)
            parentValue (str): Wert der Predictorvariable an der Kante des Vorgängerknotens ("" beim Wurzelknoten) 
        """
        # Knoten anlegen und in den Baum einhängen
        newNode = self.__createNode(df, parentNumber, parentValue)
        
        # nächstes Attribut bestimmen
        nextAttribute = self.__nextAttribute(df, listOfCandidates)
        
        # 1. Abbruchbedingungen prüfen (Pruning-Bedingung):
        #     Für mindestens einen Wert des Attributs ist der Teilbaum kleiner als self.MinElements.
        #     => Abbruch
        for attributeValue in self.Data.DictOfAttributes[nextAttribute]:
            if len(df[df[nextAttribute] == attributeValue]) < self.MinElements:
               return

        # 2. Abbruchbedingungen prüfen (Pruning-Bedingung):
        #     Die Tiefe des Baums ist größer als self.Maxlevel.
        #     => Abbruch
        level = 1
        parent = self.DictOfNodes.get(newNode.ParentNumber)
        while(parent != None):            
            level = level + 1
            parent = parent = self.DictOfNodes.get(parent.ParentNumber)
        if level > self.MaxLevel:
            return

        # nächstes Attribut in den Knoten schreiben
        newNode.Attribute = nextAttribute
        
        # nächstes Attribut aus Liste der Attributkandidaten entfernen
        updatedListOfCandidates = listOfCandidates.copy()
        updatedListOfCandidates.remove(nextAttribute)        
       
        # 3. Abbruchbedingungen prüfen:
        #     Das aktuelle Attribut ist das letzte vorhandene Attribut, 
        #     d.h. es ist kein weiteres Attribut mehr vorhanden.
        #     => Je Wert des Attributs einen Blattkonten schreiben und Abbruch.
        if len(updatedListOfCandidates) == 0:
            # für jeden Wert des Attributs einen Blattknoten schreiben
            for attribute_value in self.Data.DictOfAttributes[nextAttribute]:
                # Teilbaum für den Wert des Attributs berücksichtigen
                mask = df[nextAttribute] == attribute_value
                self.__createNode(df=df[mask], parentNumber=newNode.Number, parentValue=attribute_value)
            return
                
        # für jeden Wert des ausgewählten Attributs:
        for attribute_value in self.Data.DictOfAttributes[nextAttribute]:
            partitioned_df = df[df[nextAttribute] == attribute_value]
            
            # Wenn ein Teilbaum für den Wert des Attributs vorhanden ist: 
            # => den Teilbaum für den Wert des Attributs weiter betrachten.
            if len(partitioned_df) != 0:
                
                # 4. Abbruchbedingung prüfen:
                #      Die Aufteilung durch den Wert des Attributs ist eindeutig 
                #      in die Klassen der Zielvariable erfolgt, d.h. die Entscheidung ist gefallen. 
                #      (Entropy des Teilbaums ist 0)  
                #      => Blattknoten für den Wert des Attributs schreiben
                if abs(self.__entropy(partitioned_df)) < 0.00001:        
                    self.__createNode(df=partitioned_df, parentNumber=newNode.Number,parentValue=attribute_value)
                    
                #      Anlegen eines neuen Knoten
                else:
                    self.__generateNode(df=partitioned_df, listOfCandidates=updatedListOfCandidates, 
                                            parentNumber=newNode.Number, parentValue=attribute_value)
            
            # wenn kein Teilbaum mehr für den Wert des Attributes vorhanden ist
            # => Blattknoten für den Wert des Attributs schreiben
            else:
                self.__createNode(df=partitioned_df,parentNumber=newNode.Number, parentValue=attribute_value)

    def __createNode(self, df: pd.DataFrame, parentNumber: int, parentValue : str) -> Node:
        """Anlegen des Knotens und Einhängen in den Entscheidungsbaum

        Args:
            df (pd.DataFrame):  pandas.DataFrame für das der Knoten angelegt werden soll
            parentNumber (int): Nummer des Vorgängerknotens (0 beim Wurzelknoten)
            parentValue (str): Wert der Predictorvariable an der Kante des Vorgängerknotens ("" beim Wurzelknoten) 

        Returns:
            Node: Verwei auf den angelegten Knoten
        """
        # Knoten anlegen
        newNode = Node(parentNumber = parentNumber, parentValue = parentValue) 
                
        # Liste der Knoten ergänzen
        self.DictOfNodes[newNode.Number] = newNode
                
        # Liste der Childknoten im Parent ergänzen
        parent = self.DictOfNodes.get(newNode.ParentNumber)
        if(parent != None):             
            parent.ListOfChilds.append(newNode.Number)                                              
      
        # Wertausprägungen der Zielvariable in den Knoten schreiben      
        for label in self.Data.ListOfClassValues:
            mask = df[self.Data.ClassLabel] == label
            labeledDf = df[mask]
            newNode.ClassValues[label] = len(labeledDf)

        # info in den Knoten schreiben
        newNode.Info = self.__entropy(df)
            
        return newNode

    # Ermittlung des Attributs mit dem höchsten Informationsgewinn gain
    def __nextAttribute(self, df: pd.DataFrame, listOfCandidates: list) -> str:
        attributeGains = {}
        for attribute in listOfCandidates:
            attributeGains[attribute] = self.__informationGain(df, attribute)
        return max(attributeGains, key=attributeGains.get)

    # Berechung des Informationsgewinns gain durch den Split es Dataframes df mit dem Attribute attribute
    def __informationGain(self, df: pd.DataFrame, attribute: str) -> float:
        if len(df) == 0:
            return 0
        # Entrpoie vor dem Split
        entropyBefore = self.__entropy(df)
        # Entrophie nach dem Split
        entropyAfter = self.__entropyAfter(df, attribute)
        # Informationsgewinn gain
        return entropyBefore - entropyAfter

    # Entrophie nach dem potentiellen Split mit dem Atrribut attribute
    def __entropyAfter(self, df: pd.DataFrame, attribute: str) -> float:
        entropyAfter = 0
        for attributeValue in df[attribute].unique():
            mask = df[attribute] == attributeValue
            partitionedDf = df[mask]
            entropyAfter += len(partitionedDf) / len(df) * self.__entropy(partitionedDf)
        return entropyAfter
         
    # Entrophie des DataFrames df
    def __entropy(self, df: pd.DataFrame) -> float:
        # Klassenanteile = Anzahl der Datensätze mit dem ClassLabel der Zielvariablen / Gesamtanzahl der Datensätze
        classRatios = []
        total_instances = len(df.index)
        for classValue in df[self.Data.ClassLabel].unique():
            mask = df[self.Data.ClassLabel] == classValue
            partitionedDf = df[mask]
            partitionedInstances = len(partitionedDf.index)
            classRatios.append(partitionedInstances / total_instances)
        # Berechnung der Entrophie
        return sum([-class_ratio * np.log2(class_ratio) for class_ratio in classRatios])

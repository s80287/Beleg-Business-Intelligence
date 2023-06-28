from graphviz import Digraph

from lincoln.network import NeuralNetwork
from lincoln.layers import Dense
from lincoln.layers import Layer
from lincoln.activations import Sigmoid, Tanh, ReLU, Linear

class NetVisualizer:
    
    def __init__(self):
        
        self.ListOfInput: list[str]
        self.ListOfOutput: list[str]
        self.Net: NeuralNetwork
        self.Dot: Digraph
        self.Counter = 0
          
    def DrawNet(self, net: NeuralNetwork, listOfInput: list[str], listOfOutput: list[str], nodesep = 0.25, ranksep = 5, showWeights = False):
         
        """Zeichnen eines Neuronalen Netzes
        
        Args:
            net: lincoln.network.NeuralNetwork-Objekt, dass gezeichnet werden soll
            listOfInput (list[str]): Namen der Prediktovariablen (features)
            listOfOutput(list[str]): Namen der Zielvariablen (lables)
            nodesep (float, optional): Abstand zwischen den Neuronen einer Schicht (Wertebereich: 0.02 - 5.0) - Default ist 0.25.
            ranksep (float, optional): Abstand zwischen den Schichten des Netzes (Wertebereich: 0.02 - 5.0) - Default ist 0.5.
            showWeights (boool, optional): Anzeige der Werte der Gewichte - Default ist False.
        """
        
        if not isinstance(net, NeuralNetwork):
            raise TypeError("Der Übergabeparameter net muss vom Typ lincoln.network.NeuralNetwork sein.")
        if not isinstance(listOfInput, list):
            raise TypeError("Der Übergabeparameter listOfInput muss vom Typ list[str] sein.")
        if not isinstance(listOfOutput, list):
            raise TypeError("Der Übergabeparameter listOfOutput muss vom Typ list[str] sein.")
        if len(net.layers) < 1:
            raise ValueError("In net sind keine Layer enthalten - net.layers enthält keine Eintäge.")
        for layer in net.layers:
            if not isinstance(layer, Dense):
                raise TypeError("Alle Layer in net müssen vom Typ  lincoln.layers.Dense sein.")   
        if net.layers[0].params[0].shape[0] != len(listOfInput):
            raise ValueError(f"Die Anzahl der Eintäger in listOfInput ist mit {len(listOfInput)} unterschiedlich zur Zeilenanzahl der ersten Gewichtsmatrix mit {net.layers[0].params[0].shape[0]} .")
        if net.layers[len(net.layers)-1].params[0].shape[1] != len(listOfOutput):
            raise ValueError(f"Die Anzahl der Eintäger in listOfOutput ist mit {len(listOfInput)} unterschiedlich zur Spaltenanzahl der letzten Gewichtsmatrix mit {net.layers[len(net.layers)-1].params[0].shape[1]} .")
        if nodesep < 0.02 or nodesep > 5.0 :
            raise ValueError(f"Der Übergabeparameter nodesep muss im Wertebereich 0.02 - 5.0 liegen. Der übergebene Wert ist {nodesep} .")
        if ranksep < 0.02 or nodesep > 5.0 :
            raise ValueError(f"Der Übergabeparameter ranksep muss im Wertebereich 0.02 - 5.0 liegen. Der übergebene Wert ist {ranksep} .")
        
        self.Net = net
        self.ListOfInput = listOfInput
        self.ListOfOutput = listOfOutput
        self.ShowWeights = showWeights
 
        nodeAttrs = {
            'shape': 'circle',
            'fontname': 'Sans',
            'fontsize': '6',
            'fontcolor': 'white',
            'margin': '0',
            'height': '0.2',
            'width': '0.2',
            'style': 'filled',
            'color' : '#00 6E B7',
            'fillcolor': '#00 6E B7'}
        
        edgeAttrs = {
            'shape': 'box',
            'fontname': 'Sans',
            'fontsize': '6',
            'color' : '#CB D5 E6',
            'height': '0.1',
            'width': '0.1',
            'arrowhead': 'normal',
            'arrowsize': '0.3'} 
        
        self.Dot = Digraph(strict=True, node_attr= nodeAttrs, edge_attr=edgeAttrs)
        
        # Grafik von links nach rechts aufbauen 
        self.Dot.attr(rankdir ='LR')
        
        # nur gerade Linien verwenden
        self.Dot.attr(splines ='false')
        
        # Abstand zwischen den Knoten einer Ebene
        self.Dot.attr(nodesep = f'{nodesep}')
        
        # Abstand zwischen den Ebenen
        self.Dot.attr(ranksep = f'{ranksep}')
        
        # InputLayer
        lastNodes = self.__drawInputLayer()
        
        # Hidden- und Outputlayer
        #for layer in net.layers:
        for i in range(len(net.layers)):
            if i == len(net.layers)-1:
                label = f'Ausgangsschicht\n(output layer)'
            else:
                label = f'verdeckte Schicht\n(hidden layer {i+1})'
            lastNodes = self.__drawLayer(net.layers[i], lastNodes, label)
        
        # Output
        self.__drawOutput(lastNodes)
        
        return self.Dot


    # Input-Layer zeichnen 
    def __drawInputLayer(self) -> list:

        outputNodes = []
        inputNodes = []
        
        # unsichtbare Nodes
        with self.Dot.subgraph(name = "clusterInputInvisible") as cluster:    
            # Rahmenfarbe des Cluster: weiss 
            cluster.attr(color='white') 
            cluster.attr(rank='same')      
            for input in self.ListOfInput:
                self.Counter = self.Counter + 1
                strInvisible = f'{self.Counter}'
                inputNodes.append(strInvisible)
                cluster.node(strInvisible, label='', style = "invis")
                
        # sichtbare Nodes und Edges zu unsichtbaren Nodes
        with self.Dot.subgraph(name = "clusterOutput") as cluster:        
             # Rahmenfarbe des Cluster: weiss 
            cluster.attr(color='white')      
            cluster.attr(rank='same')        
            cluster.attr(label='Eingangsschicht\n(input layer)', fontcolor = "#00 6E B7", fontname = 'Sans', fontsize = '8')    
            for i in range(len(inputNodes)):                
                self.Counter = self.Counter + 1
                strName = f'{self.Counter}'
                outputNodes.append(strName)
                cluster.node(strName, label='')
                
                # Verbindung für den Input anlegen - Name des Inputvariable steht in ListOfInput[i]
                self.Dot.edge(inputNodes[i],strName, label=self.ListOfInput[i], fillcolor = "black", color = "black", fontsize = '8')
        
        return outputNodes
            
    # Layer zeichnen 
    def __drawLayer(self, layer: Dense, inputNodes: list, clusterLabel: str):
        
        outputNodes = []
        
        # Skalierung der Liniestärke bestimmen
        maxPenwidth = 2.0
        minPenwidth = 0.2
        maxWeight = layer.params[0].max()
        
        # label des Neurons
        nodeLabel = ''
        if isinstance(layer.activation, Sigmoid):
            nodeLabel = 'Sigm'
        if isinstance(layer.activation, Tanh):
            nodeLabel = 'Tanh'
        if isinstance(layer.activation, ReLU):
            nodeLabel = 'ReLu'
        if isinstance(layer.activation, Linear):
            nodeLabel = 'Lin'
                                                
        with self.Dot.subgraph(name = f'cluster{self.Counter}') as cluster:
             # Rahmenfarbe des Cluster: weiss 
            cluster.attr(color='white')   
            cluster.attr(rank='same')           
            cluster.attr(label=clusterLabel, fontcolor = "#00 6E B7", fontname = 'Sans', fontsize = '8')    
                    
            # für alle Spalten in den Gewichten des Layer, d.h. je Neuron des Layers
            for col in range(layer.params[0].shape[1]):
                # Node für das Neuron anlegen
                self.Counter = self.Counter + 1
                strName = f'{self.Counter}'
                outputNodes.append(strName)
                cluster.node(strName, label = nodeLabel)
        
        # für jedes Neuron des Layers Verbindungen zeichnen zu allen vorherigen Neuronen
        for j in range(len(outputNodes)):
            weigths = layer.params[0]
            for i in range(len(inputNodes)):            
                # Strichstärke skalieren
                penwidth = weigths[i,col] * maxPenwidth / maxWeight
                if penwidth < minPenwidth:
                    penwidth = minPenwidth
                
                # nur jeweils die Verbindungen des ersten und letzten Neurons sind Relavant für die Positionierung
                # (Andernfalls werden die Nodes im Cluster breit auseinander gezogen, d.h. die Grafik wird extrem breit.)
                if j==0 or j==len(outputNodes)-1 or i==0 or i== len(inputNodes)-1:
                    constraint = f'true'
                else:
                    constraint = f'false'
                     
                # Verbindung anlegen     
                if self.ShowWeights:
                    self.Dot.edge(inputNodes[i], outputNodes[j], penwidth = f'{penwidth}', xlabel=f'{weigths[i,col]:.2f}', forcelabel = 'true', decorate='true', constraint = constraint)
                else:   
                    #if (constraint == 'true'):
                        self.Dot.edge(inputNodes[i], outputNodes[j], label='', penwidth = f'{penwidth}', constraint = constraint)
        
        return outputNodes
    
    def __drawOutput(self, outputNodes: list):
    
        with self.Dot.subgraph(name = "clusterInvisibleOutput") as cluster:        
            # Rahmenfarbe des Cluster: weiss 
            cluster.attr(color='white')          
            cluster.attr(rank='same')    

            for i in range(len(outputNodes)):
                # unsichtbaren Node anlegen
                self.Counter = self.Counter + 1
                strInvisible = f'{self.Counter}'
                cluster.node(strInvisible, label='', style = "invis")
                # Verbindung für den Output zeichnen - Name des Outputvariable steht in ListOfOutput[i]
                self.Dot.edge(outputNodes[i], strInvisible, label=self.ListOfOutput[i], fillcolor = "black", color = "black", fontsize = '8')

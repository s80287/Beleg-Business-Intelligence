from graphviz import Digraph
from util.id3 import Tree, Node


class TreeVisualizer:
    
    def __init__(self):
        
        self.Tree: Tree
        self.Dot : Digraph
        
        
    def DrawTree(self, tree: Tree):
        """Zeichnen eines Entscheidungsbaums für das übergebene Tree-Objekt
        
        Args:
            tree (Tree): Tree-Objekt, für das der Baum gezeichnet werden soll.
        """
        
        if not isinstance(tree, Tree):
            raise TypeError("Übergabeparameter tree muss vom Typ Tree sein.")
        if not tree.DictOfNodes:
            raise ValueError("Das Dictionary der Knoten DictOfNode des Übergabeparameters tree ist leer.")
        
        self.Tree = tree
 
        # Wurzelknoten ermitteln
        root = self.Tree.DictOfNodes.get(1)
        if (not isinstance(root, Node)):
            raise TypeError("Der Wurzelknotem muss vom Typ id3.Node sein.")
        nodeAttrs = {
            'shape': 'box',
            'fontname': 'Sans',
            'fontsize': '8',
            'height': '0.2',
            'width': '0.2',
            'fontcolor':"black"}
        
        edgeAttrs = {
            'shape': 'box',
            'fontname': 'Sans',
            'fontsize': '8',
            'color' : '#00 6E B7',
            'height': '0.2',
            'width': '0.2'} 
        self.Dot = Digraph(strict=True, node_attr= nodeAttrs, edge_attr=edgeAttrs)
        
        # Baum Zeichnen
        self.__drawNode(root)
        
        return self.Dot

    # Zeichnen eines Knoten und seiner Verbindung zum Vorgängerknoten, falls Vorgänger vorhanden ist
    def __drawNode(self, node: Node):
        
        # Knoten zeichnen
        strName = f'Knoten{node.Number}'
       
        strLabel = '''<
                    <TABLE border="0" cellborder="1" cellspacing="0" bgcolor="#E7 EB F3">'''
            
        # Attribut nur im Nichtblattknoten anzeigen            
        if node.Attribute != "":            
            strLabel = strLabel + \
                   ''' <TR>
                        <TD cellpadding="3" align="center" colspan=" ''' \
                        +  f' {len(self.Tree.Data.ListOfClassValues)} ' \
                        + ''' " color="#00 6E B7" bgcolor="#00 6E B7">''' \
                        + ''' <font color="white" point-size = "12"> <b>''' \
                        + f' {node.Attribute} ' \
                        + '''</b> </font> </TD>                       
                    </TR>'''

        # info des Knoten
        strLabel = strLabel + \
                   '''<TR>
                        <TD align="left" colspan="''' \
                        +  f' {len(self.Tree.Data.ListOfClassValues)} ' \
                        + ''' " cellpadding="2" '''
                        
        # Rahmenfarbe im Blattknoten weiß, sonst hellgrau
        if node.Attribute != "":
            strLabel = strLabel + '''color="#E7 EB F3" '''
        else:
            strLabel = strLabel + '''color="white" '''

        strLabel = strLabel + \
                        '''  bgcolor="#E7 EB F3"> ''' \
                        + f'info = {node.Info:8.4f}' \
                        + ''' </TD>
                    </TR>'''

        # label der Zielvariable    
        strLabel = strLabel + ''' <TR>'''
        for label in self.Tree.Data.ListOfClassValues:
            strLabel = strLabel \
            + ''' <TD cellpadding="2" color="white" '''
            # Kopfzeile des Maximalwertes im Blattknoten hervorheben, sonst grau
            if label != max(node.ClassValues, key = node.ClassValues.get) and node.Attribute == "":
                strLabel = strLabel + ''' bgcolor="#CB D5 E6">'''
            else:
                strLabel = strLabel + ''' bgcolor="#00 6E B7">'''
            strLabel = strLabel + ''' <font color="white" point-size = "8"> <b>''' \
            + f' {label} ' \
            + '''</b> </font> </TD>'''            
        strLabel = strLabel + '''</TR>'''

        # Werte der Zielvariable    
        strLabel = strLabel + ''' <TR>'''
        for label in self.Tree.Data.ListOfClassValues:
            strLabel = strLabel \
            + ''' <TD cellpadding="2" color="white" bgcolor="#CB D5 E6">''' \
            + ''' <font color="black" point-size = "8">''' \
            + f' {node.ClassValues[label]} ' \
            + '''</font> </TD>'''            
        strLabel = strLabel + '''</TR>'''

        # Nummer des Knoten
        strLabel = strLabel + \
                   '''<TR>
                        <TD align="center" colspan="''' \
                        +  f' {len(self.Tree.Data.ListOfClassValues)} ' \
                        + ''' " cellpadding="2" '''
        
        # Rahmenfarbe im Blattknoten weiß, sonst hellgrau
        if node.Attribute != "":
            strLabel = strLabel + '''color="#E7 EB F3" '''
        else:
            strLabel = strLabel + '''color="white" '''
                        
        strLabel = strLabel + \
                        ''' bgcolor="#E7 EB F3"> ''' \
                        + f'Knoten {node.Number}' \
                        + ''' </TD>
                    </TR>
                         </TABLE>>'''
        
        # color, fillcolor und style für Trenn- und Blattknoten unterscheiden
        if node.Attribute != "":            
            self.Dot.node(strName, strLabel, fillcolor = "#E7 EB F3")  
            self.Dot.node(strName, strLabel, color = "#E7 EB F3")  
            self.Dot.node(strName, strLabel, style = "filled, rounded")  
        else:
            self.Dot.node(strName, strLabel, fillcolor = "white")  
            # Blattknoten mit 0 Elementen => roter Rahmen
            if sum(node.ClassValues.values()) == 0:
                self.Dot.node(strName, strLabel, color = "red")  
            else:
                self.Dot.node(strName, strLabel, color = "white")
            self.Dot.node(strName, strLabel, style = "filled")  
                    
        # Childknoten und dessen Verbindung zum Parentknoten zeichnen
        for childNumber in node.ListOfChilds:
            # in Tree.DictOfNodes ist nur ein Element enthalten
            child = self.Tree.DictOfNodes[childNumber]
            self.__drawNode(child)  
            self.Dot.edge(f'Knoten{node.Number}', f'Knoten{child.Number}', label = f'{child.ParentValue}')

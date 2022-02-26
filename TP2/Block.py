class Block:
    """_summary_
    Classe d'interface de bloc. Un bloc est definit par sa longueur, sa hauteur et sa profondeur.
    """
    def __init__(self, l: int, p: int, h: int):
        self.l = l
        self.p = p
        self.h = h
        
    def print(self):
        print(self.l, self.p, self.h)
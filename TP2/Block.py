class Block:
    """_summary_
    Classe d'interface de bloc. Un bloc est definit par sa longueur, sa hauteur et sa profondeur.
    """
    def __init__(self, h: int, l: int, p: int):
        self.l = l
        self.p = p
        self.h = h
        
    def is_smaller(self, block):
        return self.l < block.l and self.p < block.p
        
    def print(self):
        print(self.h, self.l, self.p)
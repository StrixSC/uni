from CriticalPoint import CriticalPoint

class Building:
    """_summary_
    Un batiment est une représentation abstraite d'une ligne d'entrée du fichier d'exemplaire.
    _example_
    10 24 143 -> Building(x1=10, x2=24, height=143)
    """
    def __init__(self, x1, x2, height):
        self.x1 = x1
        self.x2 = x2
        self.height = height
    
    
    """_summary_
    Cette méthode retourne la liste de points critique (soit les deux points critiques) d'un batîment.
    Les deux points critiques seront le point du coin gauche supérieur et le coin droit inférieur.
    """
    def get_critical_points(self):
        return [CriticalPoint(self.x1, self.height), CriticalPoint(self.x2, 0)]
from Building import Building
from CriticalPoint import CriticalPoint
from time import time

class Skyline:
    """_summary_
    Classe skyline contenant les méthodes nécessaires pour résolver un skyline à partir d'une liste de Building.
    """
    
    def __init__(self, buildings: list[Building]):
        self.buildings = buildings
        
    """_summary_
    Cette methode est appelé afin de resolver le Skyline à partir de l'algorithme voulu.
    """
    def solve(self, algorithm='brute', seuil=0, p=False):
        t0 = time()        
        if algorithm == 'brute':
            skyline = self.solve_brute(buildings=self.buildings)
        elif algorithm == 'recursif':
            skyline = self.solve_recursively(buildings=self.buildings)
        elif algorithm == 'seuil':
            # L'algorithme recursif avec seuil n'est qu'un appel à l'appel recursif
            skyline = self.solve_recursively(buildings=self.buildings, has_seuil=True, seuil=seuil)
        t1 = time()
        return skyline, t1 - t0

    def solve_brute(self, buildings: list[Building]):
        critical_points: list[CriticalPoint] = []
        skyline: list[CriticalPoint] = []
        
        for building in buildings:
            critical_points.extend(building.get_critical_points())

        # On trie les points critiques en terme d'abcisses ascendants.
        critical_points.sort(key=lambda cp: cp.x)
        
        if len(critical_points) == 0:
            return []

        # Le point critique le plus à gauche du premier bâtiment apparaîtra toujours dans la ligne d'horizon finale.
        skyline.append(critical_points[0])
        
        # Nous parcourons tous les bâtiments et vérifions si leurs points critiques sont "cachés" par d'autres points.
        for cp in critical_points:
            for building in buildings:
                if cp.x >= building.x1 and cp.x < building.x2:
                    # Nous faisons correspondre la hauteur du point critique avec la hauteur du bâtiment 
                    # si la hauteur du point critique est inférieure à la hauteur du bâtiment.
                    if cp.height < building.height:
                        cp.height = building.height
            self.append(skyline, cp)

        return skyline
    
    def solve_recursively(self, buildings, has_seuil=False, seuil=0):
        building_count = len(buildings)
        
        # On vérifie si le seuil est atteint (si l'option de seuil est activé). 
        # Si oui, on retourne une liste de points critiques représentant le Skyline résolu à partir de l'algorithme de force brute.
        if has_seuil and building_count <= seuil:
            return self.solve_brute(buildings)
        
        if(building_count == 0):
            return []
        
        # Si la subdivision possède une taille de 1, nous retournons la liste de points critiques du batiment dans la liste.
        if(building_count == 1):
            return buildings[0].get_critical_points()
        
        # Appels recursifs sur les subdivions gauches et droites de la liste d'entrés. 
        left_skyline = self.solve_recursively(buildings=buildings[:len(buildings) // 2], has_seuil=has_seuil, seuil=seuil)
        right_skyline = self.solve_recursively(buildings=buildings[len(buildings) // 2:], has_seuil=has_seuil, seuil=seuil)
        
        return self.merge_skylines(left_skyline, right_skyline)
        
        
    """_summary_
    Methode de combinaison de deux listes de points critiques. Utilisé lors des résolutions du problème par l'algorithme recursif
    avec ou sans seuil.
    """
    def merge_skylines(self, left_skyline: list[CriticalPoint], right_skyline: list[CriticalPoint]):
        left_index = right_index = 0
        left_cp_height = right_cp_height = 0
        left_skyline_length = len(left_skyline)
        right_skyline_length = len(right_skyline)
        
        merged_skyline = []
        
        # Nous parcourons les deux listes de Skylines (lignes d'horizons)
        while left_index < left_skyline_length and right_index < right_skyline_length:
            left_cp = left_skyline[left_index]
            right_cp = right_skyline[right_index]
            
            # Comme nous parcourons les deux listes de gauche à droite, nous devons nous assurer que le point critique que nous traitons
            # dans cette itération correspond au point situé le plus à gauche.
            if left_cp.x < right_cp.x:
                final_cp = CriticalPoint(left_cp.x, 0)
                left_cp_height = left_cp.height
                left_index += 1
            else:
                final_cp = CriticalPoint(right_cp.x, 0)
                right_cp_height = right_cp.height
                right_index += 1
            
            # Nous élevons la hauteur du point critique selectionné au maximum de hauteur entre le point critique "bleu" 
            # et le point critique "vert". Le point critique bleu étant le dernier point critique évalué de la liste de gauche 
            # et vice versa pour le point "vert".
            final_cp.height = max(left_cp_height, right_cp_height)
            self.append(merged_skyline, final_cp)
        
        # Tout les points critiques des deux listes qui n'ont pas été évalué lors de la boucle vont inévitablement 
        # faire partie du Skyline final.
        merged_skyline.extend(left_skyline[left_index:])
        merged_skyline.extend(right_skyline[right_index:])
        return merged_skyline
    
    def append(self, skyline: list[CriticalPoint], critical_point: CriticalPoint):
        skyline_length = len(skyline)

        # Si notre ligne d'horizon est vide, nous pouvons directement ajouter le nouveau point critique.
        if skyline_length <= 0:
            skyline.append(critical_point)
            return
        
        last_added_cp = skyline[-1]
        
        # Un point critique sera redondant si le point gauche ou la hauteur est la même que le dernier point critique ajouté.
        if last_added_cp.height != critical_point.height:
            if last_added_cp.x == critical_point.x:
                # Si la hauteur du dernier point diffère, mais que leurs valeurs de X correspondent, nous changeons la taille du 
                # dernier point ajouté pour correspondre à la taille du point critique.
                last_added_cp.height = max(last_added_cp.height, critical_point.height)
            else:
                skyline.append(critical_point)
        
    def get_skyline(self):
        return self.skyline

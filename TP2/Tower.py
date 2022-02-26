from Block import Block
from time import time

class Tower:
    def solve(self, blocks: list[Block], algorithm="glouton"):
        t0 = time()
        if algorithm == "glouton":
            solved, height = self.solve_greedy(blocks)
        elif algorithm == "progdyn":
            solved, height = self.solve_dynamic_programming(blocks)
        elif algorithm == "tabou":
            solved, height = self.solve_tabu(blocks)
        else:
            print("Algorithm pas implémenté")
            exit(-1)
        return solved, height, (time() - t0)
    
    def solve_greedy(self, blocks: list[Block]):
        # Tout d'abord, on trie selon la longueur de chaque bloc, en ordre decroissant.
        # TODO: Better sorting method that takes into account not only the length of the block
        tower = []
        blocks.sort(key=lambda x: x.l, reverse=True)
        
        # On pose le premier block de la liste comme fondation de la tour. 
        # On pose la hauteur de se dernier comme la hauteur initiale de la tour.
        tower.append(blocks[0])
        hauteur = tower[-1].h

        # Pour chaque block restant, on verifie si la longueur et la profondeur sont strictement inférieur à celle du dernier block ajouté à la tour.    
        for i in range(1, len(blocks)):
            block = blocks[i]
            if block.l < tower[-1].l and block.p < tower[-1].p:
                # Si oui, on l'ajoute à la tour et on augmente la hauteur totale de la tour.
                tower.append(block)
                hauteur += block.h

        return tower, hauteur
        
    def solve_dynamic_programming(self, blocks: list[Block]):
        # Tout d'abord, on trie la liste de block selon l'aire des blocs en ordre decroissant
        blocks.sort(key=lambda x: x.l*x.p) 
        hauteur = 0
        
        
        return []
    
    def solve_tabu(self, blocks: list[Block]):
        return []
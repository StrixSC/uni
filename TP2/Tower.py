from Block import Block
from time import time

class Tower:
    def solve(self, blocks: list[Block], algorithm="glouton"):
        t0 = time()
        if algorithm == "glouton":
            solved, height, _ = self.solve_greedy(blocks)
        elif algorithm == "progdyn":
            solved, height = self.solve_dynprog(blocks)
        elif algorithm == "tabou":
            solved, height = self.solve_tabu(blocks)
        else:
            print("Algorithme pas implémenté")
            exit(-1)
        return solved, height, (time() - t0)
    
    def solve_greedy(self, blocks: list[Block], keep_unused_blocks=False):
        # Tout d'abord, on trie selon la longueur de chaque bloc, en ordre decroissant.
        # TODO: Better sorting method that takes into account not only the length of the block
        tower = []
        blocks.sort(key=lambda x: x.l, reverse=True)
        
        # On pose le premier block de la liste comme fondation de la tour. 
        # On pose la hauteur de se dernier comme la hauteur initiale de la tour.
        tower.append(blocks[0])
        hauteur = tower[-1].h
        unused_blocks = []
        # Pour chaque block restant, on verifie si la longueur et la profondeur sont strictement inférieur à celle du dernier block ajouté à la tour.    
        for block in blocks[1:]:
            if block.is_smaller(tower[-1]):
                # Si oui, on l'ajoute à la tour et on augmente la hauteur totale de la tour.
                tower.append(block)
                hauteur += block.h
            elif keep_unused_blocks:
                unused_blocks.append(block)
                
        return tower, hauteur, unused_blocks
        
    def solve_dynprog(self, blocks: list[Block]):
        blocks.sort(key=lambda x: x.l*x.p, reverse=True)
        heights = [0 for b in blocks]
        lasts = [None for b in blocks]
        for i, current_block in enumerate(blocks):
            heights[i] = current_block.h
            max_potential_height = 0
            for j, previous_block in enumerate(blocks[0:i]):
                if current_block.is_smaller(previous_block) and max_potential_height < heights[j]:
                    max_potential_height = heights[j]
                    lasts[i] = j
            heights[i] += max_potential_height

        tower = []
        max_height_index = next = max(range(len(heights)), key=heights.__getitem__)
        while next is not None:
            tower.append(blocks[next])
            next = lasts[next]
        
        return list(reversed(tower)), heights[max_height_index]

    def solve_tabu(self, blocks: list[Block]):
        greedy_tower, _, unused_blocks = self.solve_greedy(blocks, keep_unused_blocks=True)
        max_height = 0
        max_neighbour = []
        for block in unused_blocks:
            neighbour, height = self.create_neighbour(block, greedy_tower)
            if max_height < height:
                max_height = height
                max_neighbour = neighbour

        return max_neighbour, max_height
    
    def create_neighbour(self, unused_block: Block, tower: list[Block]):
        neighbour = []
        for i, block in reversed(list(enumerate(tower))):
            if unused_block.is_smaller(block):
                neighbour.extend(tower[:i+1])
                neighbour.append(unused_block)
                for j, remaining_block in enumerate(tower[i:]):
                    if remaining_block.is_smaller(unused_block):
                        neighbour.extend(tower[j:])
                        break
                break
        
        height = 0
        for block in neighbour:
            height += block.h
        
        return neighbour, height
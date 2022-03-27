from Block import Block
from time import time
from random import randint, seed

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
        # On trie selon la longueur de chaque bloc, en ordre decroissant.
        tower = []
        blocks.sort(key=lambda x: x.l * x.p, reverse=True)
        
        # On pose le premier block de la liste comme fondation de la tour. 
        tower.append(blocks[0])
        
        # On pose la hauteur du premier block comme la hauteur initiale de la tour.
        unused_blocks = []
        # Pour chaque block restant, on verifie si la longueur et la profondeur sont strictement inférieur à celle du dernier block ajouté à la tour.    
        for block in blocks[1:]:
            if block.is_smaller(tower[-1]):
                # Si oui, on l'ajoute à la tour et on augmente la hauteur totale de la tour.
                tower.append(block)
            elif keep_unused_blocks:
                unused_blocks.append(block)
        
        hauteur = 0
        for block in tower:
            hauteur += block.h
            
        return tower, hauteur, unused_blocks
        
    def solve_dynprog(self, blocks: list[Block]):
        blocks.sort(key=lambda x: x.l*x.p, reverse=True)
        heights = [0 for _ in blocks]
        lasts = [None for _ in blocks]
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
        TABU_COUNTER_LOWER_BOUND = 7
        TABU_COUNTER_UPPER_BOUND = 10
        best_neighbour, best_height, unused_blocks = self.solve_greedy(blocks, keep_unused_blocks=True)
        tabu_lists = [[] for _ in range(TABU_COUNTER_UPPER_BOUND + 1)]
        
        for _ in range(100): 
            freed_blocks = tabu_lists.pop(0)
            unused_blocks.extend(freed_blocks)
            current_tabu_list = []
            for block in unused_blocks:
                neighbour, height, tabu_blocks = self.create_neighbour(block, best_neighbour)
                if best_height < height:
                    best_height = height
                    best_neighbour = neighbour
                    current_tabu_list.extend(tabu_blocks)
            unused_blocks = list(set(unused_blocks) - (set(current_tabu_list)))
            tabu_lists.append([])
            tabu_lists[randint(TABU_COUNTER_LOWER_BOUND, TABU_COUNTER_UPPER_BOUND)].extend(current_tabu_list)
                
        return best_neighbour, best_height
    
    def create_neighbour(self, unused_block: Block, tower: list[Block]):
        neighbour = []
        tabu_list = []
        found = False
        for i, block in reversed(list(enumerate(tower))):
            if unused_block.is_smaller(block):
                found = True
                neighbour.extend(tower[:i+1])
                neighbour.append(unused_block)
                for j, remaining_block in enumerate(tower[i+1:]):
                    if remaining_block.is_smaller(unused_block):
                        neighbour.extend(tower[i+j+1:])
                        break
                    else:
                        tabu_list.append(remaining_block)
                        
            if found:
                break
        
        if not neighbour:
            neighbour.append(unused_block)
        
        height = 0
        for block in neighbour:
            height += block.h
        
        return neighbour, height, tabu_list
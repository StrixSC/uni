from Block import Block
from time import time
from random import randint, seed

class Tower:
    TABU_COUNTER_LOWER_BOUND = 7 
    TABU_COUNTER_UPPER_BOUND = 10
        
    def solve(self, blocks, algorithm="glouton"):
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
    
    def solve_greedy(self, blocks, keep_unused_blocks=False):
        tower = []
        # First, we sort the blocks by their area. 
        blocks.sort(key=lambda x: x.l * x.p, reverse=True)
        
        # Set the first block as the foundation of the tower. 
        tower.append(blocks[0])
        
        # The total height of the tower is set to the height of the foundation.
        total_height = tower[-1].h
        unused_blocks = []
        
        # Loop through each remaining block in our blocks array.   
        for block in blocks[1:]:
            # If the block we're currently evaluating is "smaller" than the highest block in the tower, we can add it to the tower.
            # A block is smaller if the length and the depth of the block is strictly smaller than the one underneath it.
            if block.is_smaller(tower[-1]):
                tower.append(block)
                total_height += block.h
            elif keep_unused_blocks:
                unused_blocks.append(block)
        
        return tower, total_height, unused_blocks
    
    """
    @description
    solve_dynprog solves the Tower given a list of blocks, through a dynamic programming approach.
    
    @params:
        - The available list of blocks to build the tower :  list[Block]
    @return:
        - The list of blocks representing the solution -> list[Block]
        - The height of the tower -> int
    """
    def solve_dynprog(self, blocks):
        # First, sort the list of available blocks using the area of each block
        blocks.sort(key=lambda x: x.l*x.p, reverse=True)
        
        # Initialize two empty lists. 
        heights = [0 for _ in blocks] # The first one will contain the max height of the tower should we chose to add the block at index i to the solution.
        lasts = [None for _ in blocks] # The second one will contain pointers to the next block on the tower. I.e.: last[5] = 4 means that block #5 is directly on top of block #4.
        
        for i, current_block in enumerate(blocks): 
            heights[i] = current_block.h
            max_potential_height = 0 # The max potential height is the maximum height that the tower can reach given the addition of current_block.
            for j, previous_block in enumerate(blocks[0:i]):    # Loop through each previously evaluated blocks.
                if current_block.is_smaller(previous_block) and max_potential_height < heights[j]: # If the previously evaluated block is "smaller" and maximizes the height of the solution tower,
                    max_potential_height = heights[j] # We update the maximum potential height of the tower
                    lasts[i] = j # We set it as the block on which to put current_block
            heights[i] += max_potential_height

        tower = []
        
        # Finally, to construct the tower, we loop through each of our pointers by setting our starting index at the max of our heights array.
        max_height_index = next = max(range(len(heights)), key=heights.__getitem__)
        while next is not None: # Loop until the pointer does not point to anything anymore.
            tower.append(blocks[next]) # Append the block being pointed to, to the solution.
            next = lasts[next]
        
        return list(reversed(tower)), heights[max_height_index]

    """
    @description
    solve_tabu solves for the tallest tower given a list of blocks.
    The method uses a heuristic procedure called tabu search, designed to solve optimization problems.

    @params: 
        - The available list of blocks to build the tower :  list[Block]
    @return:
        - The list of blocks representing the solution: list[Block]
        - The height of the tower -> int
    """    
    def solve_tabu(self, blocks):
        # Each iteration of tabu search that does not provide a neighbour with a better solution 
        # will increment a counter for a max tries of 100.
        MAX_TRIES = 100  

        # The first solution is obtained through the greedy method.
        # The best neighbour contains a list of tabu blocks, meaning blocks that we cannot use for a certain amount of time.
        best_neighbour, best_height, unused_blocks = self.solve_greedy(blocks, keep_unused_blocks=True)

        # Initialize and fill a list that will hold the list of other tabu lists generated upon creation neighbours.
        tabu_lists = [[] for _ in range(self.TABU_COUNTER_UPPER_BOUND + 1)]
        
        # We add the list of tabu blocks received from the greedy method into the tabu lists
        self.add_to_tabu_list(tabu_lists, best_neighbour)
        
        counter = 0

        while counter != MAX_TRIES: 
            unused_blocks.extend(tabu_lists.pop(0)) # Dequeue the oldest list of tabu blocks into the list of available blocks
            current_tabu_list = []
            counter += 1
            for block in unused_blocks: 
                neighbour, height, tabu_blocks = self.create_neighbour(block, best_neighbour)
                if best_height < height: 
                    # If the height of the neighbour exceeds the current best solution
                    # We set the neighbour as our best solution and refresh the max_tries counter.
                    best_height = height
                    best_neighbour = neighbour
                    current_tabu_list.extend(tabu_blocks)
                    counter = 0
            # We refresh the available blocks and remove the tabu'd blocks from it. 
            unused_blocks = list(set(blocks) - (set(current_tabu_list)))
            tabu_lists.append([])
            self.add_to_tabu_list(tabu_lists, current_tabu_list)

        return best_neighbour, best_height

    """
    @description
    Method used to create a neighbour given a block and a list of blocks used in the solution.
    
    @param: 
        - unused_block -> Block
        - existing_solution -> list[Block]
    
    @returns:
        - neighbour -> list[Block]: The list of blocks representing the neighbour solution
        - height -> int: Height of the created neighbour
        - tabu_list -> List of blocks that mustn't be used for the generations of neighbours in the upcoming iterations.
    """
    def create_neighbour(self, unused_block: Block, existing_solution):
        neighbour = []
        tabu_list = []
        for i, block in reversed(list(enumerate(existing_solution))): # Starting from the topmost block of the existing solution
            if unused_block.is_smaller(block):
                # We append every block starting from the bottom of the existing solution to the neighbour
                neighbour.extend(existing_solution[:i+1])
                # We append the unused block
                neighbour.append(unused_block)
                for j, remaining_block in enumerate(existing_solution[i+1:]):
                    # The remaining blocks are checked to ensure that they fit on top of the newly added unused block.
                    if remaining_block.is_smaller(unused_block):
                        # Once the current remaining block fits, we can assume the following blocks will also fit.
                        neighbour.extend(existing_solution[i+j+1:])
                        break
                    else:
                        # Otherwise, we add them to the list of blocks to be tabu'd
                        tabu_list.append(remaining_block)
                break   

        # If the existing solution cannot fit the unused block, the resulting neibhour will only contain the unused_block.
        if not neighbour:
            neighbour.append(unused_block)

        height = 0
        for block in neighbour:
            height += block.h

        return neighbour, height, tabu_list
    
    """
    @description
    Adds a block to a bounded index in a list of tabu lists.
    
    @params: 
        - tabu_lists -> list[list[Block]]
        - blocks_to_add -> list[Block]
    """
    def add_to_tabu_list(self, tabu_lists, blocks_to_add):
        seed()
        tabu_lists[randint(self.TABU_COUNTER_LOWER_BOUND, self.TABU_COUNTER_UPPER_BOUND)].extend(blocks_to_add)
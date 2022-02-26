from Block import Block
from time import time

class Tower:
    def solve(self, blocks: list[Block], algorithm="glouton"):
        t0 = time()
        if algorithm == "glouton":
            solved = self.solve_greedy(blocks), time() - t0
        elif algorithm == "progdyn":
            solved = self.solve_dynamic_programming(blocks), time() - t0
        elif algorithm == "tabou":
            solved = self.solve_tabou(blocks)
        else:
            print("Algorithm pas implémenté")
            exit(-1)
        return solved, (time() - t0)
    
    def solve_greedy(blocks: list[Block]):
        pass
    
    def solve_dynamic_programming(blocks: list[Block]):
        pass
    
    def solve_tabou(blocks: list[Block]):
        pass
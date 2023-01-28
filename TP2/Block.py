class Block:
    """
    Block interface class. A block is defined by its length, height and depth.
    """
    def __init__(self, h: int, l: int, p: int):
        self.h = h
        self.l = l
        self.p = p
        
    """
    This method allows us to compare two blocks and to check if we can place the first block
    on top of the second one.
    """
    def is_smaller(self, block):
        return self.l < block.l and self.p < block.p
        
    def print(self):
        print(self.h, self.l, self.p)
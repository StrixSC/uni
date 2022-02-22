from CriticalPoint import CriticalPoint

class Building:
    def __init__(self, x1, x2, height):
        self.x1 = x1
        self.x2 = x2
        self.height = height
        
    def get_critical_points(self):
        return [CriticalPoint(self.x1, self.height), CriticalPoint(self.x2, 0)]
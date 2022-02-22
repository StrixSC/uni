from Building import Building
from CriticalPoint import CriticalPoint
from time import time

class Skyline:
    def __init__(self, buildings: list[Building]):
        self.buildings = buildings
        
    def solve(self, algorithm='brute', seuil=0, p=False):
        t0 = time()        
        if algorithm == 'brute':
            skyline = self.solve_brute(buildings=self.buildings)
        elif algorithm == 'recursif':
            skyline = self.solve_recursively(buildings=self.buildings)
        elif algorithm == 'seuil':
            skyline = self.solve_recursively(has_seuil=True, seuil=seuil)
        t1 = time()
        return skyline, t1 - t0

    def solve_brute(self, buildings: list[Building]):
        critical_points: list[CriticalPoint] = []
        skyline: list[CriticalPoint] = []
        
        for building in buildings:
            critical_points.extend(building.get_critical_points())

        # Sort the critical points in ascending order of their x values
        critical_points.sort(key=lambda cp: cp.x)
        
        # The leftmost critical point of the first building will always appear in the final skyline.
        skyline.append(critical_points[0])
        
        # We go through all of the buildings and check whether or not their critical points are overshadowed by other points
        for cp in critical_points:
            for building in buildings:
                if cp.x >= building.x1 and cp.x < building.x2:
                    # We match the critical point's height with the building's height if they do not correspond
                    if cp.height < building.height:
                        cp.height = building.height
            if cp.height != skyline[-1].height:
                skyline.append(cp)

        return skyline
    
    def solve_recursively(self, buildings, has_seuil=False, seuil=0):
        building_count = len(buildings)
        
        if has_seuil and building_count <= seuil:
            return self.solve_brute(buildings)
        
        if(building_count == 0):
            return []
        
        if(building_count == 1):
            return buildings[0].get_critical_points()
        
        left_skyline = self.solve_recursively(buildings=buildings[:len(buildings) // 2])
        right_skyline = self.solve_recursively(buildings=buildings[len(buildings) // 2:])
        
        return self.merge_skylines(left_skyline, right_skyline)
        
    def merge_skylines(self, left_skyline: list[CriticalPoint], right_skyline: list[CriticalPoint]):
        left_index = right_index = 0
        left_cp_height = right_cp_height = 0
        left_skyline_length = len(left_skyline)
        right_skyline_length = len(right_skyline)
        
        merged_skyline = []
        
        while left_index < left_skyline_length and right_index < right_skyline_length:
            left_cp = left_skyline[left_index]
            right_cp = right_skyline[right_index]
            
            if left_cp.x < right_cp.x:
                final_cp = CriticalPoint(left_cp.x, 0)
                left_cp_height = left_cp.height
                left_index += 1
            else:
                final_cp = CriticalPoint(right_cp.x, 0)
                right_cp_height = right_cp.height
                right_index += 1
            
            final_cp.height = max(left_cp_height, right_cp_height)
            self.append(merged_skyline, final_cp)
        
        merged_skyline.extend(left_skyline[left_index:])
        merged_skyline.extend(right_skyline[right_index:])
        return merged_skyline
    
    def append(self, skyline: list[CriticalPoint], critical_point: CriticalPoint):
        skyline_length = len(skyline)

        # If our skyline is empty, we can directly add the new critical point.
        if skyline_length <= 0:
            skyline.append(critical_point)
            return
        
        last_added_cp = skyline[-1]
        
        # A critical point will be redundant if the left or the height is the same as the last added critical point.
        if last_added_cp.height != critical_point.height:
            if last_added_cp.x == critical_point.x:
                last_added_cp.height = max(last_added_cp.height, critical_point.height)
            else:
                skyline.append(critical_point)
        
    def get_skyline(self):
        return self.skyline
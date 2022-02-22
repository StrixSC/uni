import argparse
import sys
import os

from Building import Building
from CriticalPoint import CriticalPoint
from Skyline import Skyline

def sort_by_xcoords(inputs):
    from operator import itemgetter
    return sorted(inputs, key=itemgetter('x')) 
    
# Total: n*log(n) + n^2 => n^2 E O(n^2)
def brute(inputs):
    critical_points = []
    saved_points = []

    for input in inputs:
        critical_points.append({"x": input["x1"], "y": input["height"]})
        critical_points.append({"x": input["x2"], "y": 0})
    
    critical_points = sort_by_xcoords(critical_points)
    
    saved_points.append(critical_points[0]) 
    for i in range(1, len(critical_points)):
        critical_point = critical_points[i]
        for building in inputs: # m
            # On regarde si le critical point est contenu dans le batiment
            if critical_point['x'] >= building['x1'] and critical_point['x'] < building['x2']:
                # On regarde la hauteur, si la hauteur est plus elevee, on sureleve le point critique
                if critical_point['y'] < building['height']:
                    critical_point['y'] = building['height']
        
        # On verifie si le point est redondant:
        if critical_point['y'] != saved_points[len(saved_points) - 1]['y']:
            saved_points.append(critical_point)
            
    return saved_points

def merge_points(points_1, points_2):    
    index_1 = index_2 = h_blue = h_green = 0
    len1 = len(points_1)
    len2 = len(points_2)
    merged = []

    while index_1 < len1 and index_2 < len2:
        blue_point = points_1[index_1]
        green_point = points_2[index_2]

        if  blue_point['x'] < green_point['x']:
            x = blue_point['x']
            h_blue = blue_point['y']
            index_1 += 1
        else:
            x = green_point['x']
            h_green = green_point['y']
            index_2 += 1

        max_h = max(h_green, h_blue)
        if len(merged) == 0 or merged[-1]['y'] != max_h:
            merged.append({'x': x, 'y': max_h})

    merged.extend(points_1[index_1:])
    merged.extend(points_2[index_2:])
    return merged

def recursif(inputs, has_seuil=False, seuil=0):
    input_size = len(inputs)
    
    if has_seuil and input_size <= seuil:
        return brute(inputs)
    
    if input_size == 0:
        return []
    
    if input_size == 1:
        return [
            {'x': inputs[0]['x1'], 'y': inputs[0]['height']},
            {'x': inputs[0]['x2'], 'y': 0}
        ]

    b1 = recursif(inputs[: len(inputs) // 2])
    b2 = recursif(inputs[len(inputs) // 2:])
    return merge_points(b1, b2)

def parse_args():
    parser = argparse.ArgumentParser(description='TP1 INF8775')
    parser.add_argument('-a', '--algorithm', dest='algo', type=str, help="Algorithme à utiliser. Choix disponibles: 'brute', 'recursif', 'seuil'")
    parser.add_argument('-e', '--exemplaire', dest='input', type=str, help="Fichier contenant l'exemplaire à utiliser.")
    parser.add_argument('-p', action='store_true', dest='p', help="""
                        Afficher, sur chaque ligne, les couples définissant la silhouette de bâtiments, triés selon l’abscisse
                    """)
    parser.add_argument('-t', action='store_true', dest='t', help="Affiche le temps d’exécution en millisecondes")

    if len(sys.argv) <= 1:
        parser.print_help()
        sys.exit(0)

    return parser.parse_args()

def generate_buildings(file):
    buildings = []
    
    with open(file, mode='r') as f:
        lines = f.readlines()
        total = int(lines[0])
        for i in range(1, total):
            line = lines[i].strip()
            split = line.split(' ')
            buildings.append(Building(int(split[0]), int(split[1]), int(split[2])))

    return buildings

def main():
    args = parse_args()
    
    if(not (os.path.isfile(args.input))):
        print("Input file is not good.")
        sys.exit(-1)
    
    skyline = Skyline(generate_buildings(args.input))
    solved, time = skyline.solve(algorithm=args.algo, p=args.p, seuil=100)
    
    if args.p:
        for cp in solved:
            print(cp.x, cp.height)
    
    if args.t:
        print("Total execution time: ", time)
    
    exit(0)
    
if __name__ == "__main__":
    main()
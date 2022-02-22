import argparse
import sys
import os
import math
import time
from types import coroutine

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

def merge_dnc_points(points_1, points_2):    
    index_1 = 0
    index_2 = 0
    len1 = len(points_1)
    len2 = len(points_2)
    h_blue = 0
    h_green = 0
    merged = []

    while (index_1 < len1 and index_2 < len2):
        blue_point = points_1[index_1]
        green_point = points_2[index_2]

        if green_point['x'] >= blue_point['x']:
            h_blue = blue_point['y']
            blue_point['y'] = max(h_green, blue_point['y'])
            index_1 += 1
        else:
            h_green = green_point['y']
            green_point['y'] = max(h_blue, green_point['y'])
            index_2 += 1

        merge_point = blue_point if h_blue > h_green else green_point
        if len(merged) == 0:
            merged.append(merge_point)
        elif merged[-1]['y'] != merge_point['y']:
            merged.append(merge_point)

    return merged

def recursif(inputs):
    if len(inputs) == 0:
        return []
    
    if len(inputs) == 1:
        return [
            {'x': inputs[0]['x1'], 'y': inputs[0]['height']},
            {'x': inputs[0]['x2'], 'y': 0}
        ]

    b1 = recursif(inputs[: len(inputs) // 2])
    b2 = recursif(inputs[len(inputs) // 2:])
    return merge_dnc_points(b1, b2)

def seuil(inputs):
    pass

def main():
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

    args = parser.parse_args()
    algo = args.algo
    input = args.input
    p = args.p
    t = args.t
    
    if(algo not in ['brute', 'recursif', 'seuil']):
        print("Mauvais algo, choisir parmis: 'brute', 'recursif', 'seuil'...")
        sys.exit(-1)
        
    if(not (os.path.isfile(input))):
        print("Input file is not good.")
        sys.exit(-1)
    
    inputs = []
    
    with open(input, mode='r') as f:
        lines = f.readlines()
        total = int(lines[0])
        for i in range(1, len(lines)):
            line = lines[i].strip()
            split = line.split(' ')
            inputs.append({
                "x1": int(split[0]),
                "x2": int(split[1]),
                "height": int(split[2])
            })
    
    results = []
    t0 = time.time()
    if algo == 'brute':
        results = brute(inputs)
    elif algo == 'recursif':
        results = recursif(inputs)
    elif algo == 'seuil':
        results = seuil(inputs)
    t1 = time.time()
    
    if p:
        for output in results:
            print(output['x'], output['y'], sep=' ')
    if t:   
        print("Temps d'execution: ", t1 - t0, sep=" ")
    
if __name__ == "__main__":
    main()
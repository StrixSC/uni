import argparse
import sys
import os
import time

def brute(inputs):
    critical_points = []
    saved_points = []

    for input in inputs:
        critical_points.append({"x": input["x1"], "y": input["height"]})
        critical_points.append({"x": input["x2"], "y": 0})

    saved_points.append(critical_points[0])
    for i in range(1, len(critical_points)):
        critical_point = critical_points[i]
        for building in inputs:
            # On regarde si le critical point est contenu dans le building
            if critical_point['x'] >= building['x1'] and critical_point['x'] <= building['x2']:
                # On regarde la hauteur, si la hauteur est plus elevee sureleve le point critique
                if critical_point['y'] < building['height']:
                    critical_point['y'] = building['height']
        
        if critical_point['y'] != saved_points[len(saved_points) - 1]['y']:
            saved_points.append(critical_point)
            
    return saved_points

def divide(inputs):
    pass

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
    elif algo == 'divide':
        results = divide(inputs)
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
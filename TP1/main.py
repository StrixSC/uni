import argparse
import sys
import os

def brute(inputs, p, t):
    print(inputs)
    pass

def divide(inputs, p, t):
    pass

def seuil(inputs, p, t):
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
            line = lines[i]
            split = line.split(' ')
            inputs.append({
                "x1": int(split[0]),
                "x2": int(split[1]),
                "height": int(split[2])
            })
    
    if algo == 'brute':
        brute(inputs, p, t)
    elif algo == 'divide':
        divide(inputs, p, t)
    elif algo == 'seuil':
        seuil(inputs, p, t)
        
if __name__ == "__main__":
    main()
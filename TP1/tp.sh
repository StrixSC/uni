#!/bin/bash

print_help_message() {
    echo ""
    echo "Usage:"
    echo "    tp.sh [-h] [-p] [-t] -a <Algorithme> -e <Fichier contenant les exemplaires>"
    echo "    [-h]      Montre ce menu."
    echo "    [-p]      Affiche, sur chaque ligne, les couples définissant la silhouette de bâtiments, triés selon l’abscisse."
    echo "    [-t]      Affiche le temps d’exécution en millisecondes"
    echo "    [-a]      Algorithme à utiliser. Choix disponibles: 'brute', 'recursif', 'seuil'"
    echo "    [-e]      Fichier contenant la liste des exemplaire."
    exit 0
}

while getopts ":hpt:a:e:" opt; do
    case ${opt} in
        h )
            print_help_message
            ;;
        p )
            P=true
            ;;
        t ) 
            T=true
            ;;
        a )
            ALGO=$OPTARG
            ;;
        e )
            INPUT=$OPTARG
            ;;
        \? )
            echo "Option invalide: -$OPTARG" 1>&2
            print_help_message
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

ARGS="-a $ALGO -e $INPUT"

if [[ $P == "true" ]]
then
    ARGS="$ARGS -p"
fi

if [[ $T == "true" ]]
then
    ARGS="$ARGS -t"
fi

echo $ARGS

python3 main.py $ARGS
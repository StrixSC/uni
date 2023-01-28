#!/bin/bash
print_help_message() {
    echo "Utilisation: tp.sh -e [chemin_vers_exemplaire] [-p]"
    echo "[-p]: Imprime le resultat au lieu du coût en énergie"
    echo " -e : Fichier exemplaire"
}

while getopts ":hpe:" opt; do
    case ${opt} in
        h )
            print_help_message
            exit 1
            ;;
        e ) IN_FILE=$OPTARG
            ;;
        p ) SHOW_RESULTS=true
            ;;
        \? )
            print_help_message
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

if [[ $SHOW_RESULTS = true ]]
then
    ./tp -e $IN_FILE -p
else
    ./tp -e $IN_FILE
fi
/*
 * Init Lab - q2.c
 * 
 * Ecole polytechnique de Montreal, 2018
 */

// TODO
// Si besoin, ajouter ici les directives d'inclusion
// -------------------------------------------------
#include <stdio.h>
#include <unistd.h>
#include <string.h>
// -------------------------------------------------

/*
 * Vous devez imprimer le message indiqué dans l'énoncé:
 * - En exécutant un premier appel à printf AVANT l'appel à write
 * - Sans utiliser la fonction fflush
 * - En terminant chaque ligne par le caractère '\n' de fin de ligne
 */
void question2() {
    // TODO
    char tmp[] = "5ca9c734a820 (printed using write)\n";
    printf("5ca9c734a820 (printed using printf)");  //Input in writer buffer
    write(STDOUT_FILENO, tmp, strlen(tmp));    //Use write to init a new output buffer and flush after insert
    printf("\n");   //Flush input printf buffer.
}

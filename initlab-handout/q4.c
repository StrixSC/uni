/*
 * Init Lab - q4.c
 * 
 * Ecole polytechnique de Montreal, 2018
 */

#include <stdint.h>

#include "q4/libq4.h"

// TODO
// Si besoin, ajouter ici les directives d'inclusion
// -------------------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
// -------------------------------------------------

uint64_t question4A(uint64_t x) {
    return ((67 * x * x) + (72 * x) + 6847);
}

void question4B(uint64_t x, uint64_t *result) {
    // take result location, apply question4A's result to it.
    *result = question4A(x);
}

uint64_t *question4C(uint64_t x) {
    // put result of question4A(x) and put it into the memory using malloc.-
    uint64_t* result = malloc(sizeof(uint64_t));
    question4B(x, result);
    return result; 
}

void question4D(uint64_t x, uint64_t **resultPtr) {
    // resultPtr is a double pointer. I have to change the first 
    //pointer to point to a different pointer where the result of the operation is given
    uint64_t* result = malloc(sizeof(uint64_t));    //created a new poitner.
    question4B(x, result); //put the result of the operation in result.
    *resultPtr = result; 
}

/*
 * Attention: Vous devez impérativement obtenir le résultat du calcul de
 * l’expression demandée par un appel à la fonction _question4B (et non
 * question4B!) définie dans le fichier q4/libq4.h, que nous avons programmée
 * et qui a la même signature que votre fonction question4B.
 */
uint64_t question4E(uint64_t x) {
    // make a pointer and give it to a _question4B();
    uint64_t* result = malloc(sizeof(uint64_t));
    _question4B(x, result);
    return *result;
}
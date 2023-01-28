#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include<sys/wait.h> 
#include <string.h>
/*
 * Clone Lab - part1.c
 * 
 * Ecole polytechnique de Montreal, 2018
 */

// TODO
// Si besoin, ajouter ici les directives d'inclusion
// -------------------------------------------------

// -------------------------------------------------

void part1() {
    pid_t pidPere = getpid();
    pid_t pidFils = fork();
    char pid[64];

    sprintf(pid, "%d", pidPere); 

    if(pidFils == 0){
        //On est dans le fils:
        execl("./part1/trenton","trenton", "--pid", pid , NULL);
        exit(1);
    }

    sprintf(pid, "%d", pidFils);
    execl("./part1/digna", "digna", "--pid", pid, NULL); 
    exit(0);   
}
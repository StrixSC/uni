/*
 * Clone Lab - part2.c
 * 
 * Ecole polytechnique de Montreal, 2018
 */

#include "libclonelab.h"
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include<sys/wait.h> 
#include <string.h>
#include <stdio.h>

// TODO
// Si besoin, ajouter ici les directives d'inclusion
// -------------------------------------------------

// -------------------------------------------------

#define PART2_OUTPUT_FILE_PATH "part2Output.txt"

void part2() {
    // Ouverture du fichier de sortie pour la question 2.3
    FILE* part2OutputFile = fopen(PART2_OUTPUT_FILE_PATH, "a");
    char pidPere[64]; 
    pid_t pere = getpid(); 
    sprintf(pidPere, "%d", pere);
    char* environment[] = {"NO_CHILD_TOKEN=03c8532ed5f0090eb1da05b8", NULL};

    fprintf(part2OutputFile, "Root process has pid %s", pidPere);
    
    if(fork() == 0){
        //child 1.1
        registerProc(1, 1, getpid(), getppid());

        if(fork() == 0){
            //child 2.1
            registerProc(2, 1, getpid(), getppid());
            fprintf(part2OutputFile, " (message from process level2.1)\n");
            fclose(part2OutputFile);
            execl("./part2/level2.1", "level2.1", NULL, NULL);
        }

        if(fork() == 0){
            //child 2.2
            registerProc(2, 2, getpid(), getppid());
            fprintf(part2OutputFile, " (message from process level2.2)\n");
            fclose(part2OutputFile);
            execl("./part2/level2.2", "level2.2", NULL, NULL);
            

        }
        execl("./part2/level1.1", "level1.1", pidPere, NULL);
    }
    wait(NULL);

    if(fork() == 0){
        //child 1.2
        registerProc(1, 2, getpid(), getppid());


        if(fork() == 0){
            //child 2.3 
            registerProc(2, 3, getpid(), getppid());
            // execl("./part2/level2.3", "level2.3", NULL);
            execle("./part2/level2.3", "level2.3", NULL, environment);



        }
        fprintf(part2OutputFile, " (message from process level1.2)\n");
        fclose(part2OutputFile);
        execl("./part2/level1.2", "level1.2", pidPere, NULL);
        
    }
    wait(NULL);

    if(fork() == 0){
        //child 1.3
        registerProc(1, 3, getpid(), getppid());

        if(fork() == 0){
            //child 2.4
            registerProc(2, 4, getpid(), getppid());
            fprintf(part2OutputFile, " (message from process level2.4)\n");
            fclose(part2OutputFile);
            // execl("./part2/level2.4", "level2.4", NULL);

        }

        fprintf(part2OutputFile, " (message from process level1.3)\n");
        fclose(part2OutputFile);
        execl("./part2/level1.3", "level1.3", pidPere, NULL);
    }
    wait(NULL);

    if(fork() == 0){
        //child 1.4
        registerProc(1, 4, getpid(), getppid());

        if(fork() == 0){
            //child 2.5
            registerProc(2, 5, getpid(), getppid());
            execl("./part2/level2.5", "level2.5", NULL);
    
        }
        execl("./part2/level1.4", "level1.4", pidPere, NULL);
    }
    wait(NULL);
    
    fprintf(part2OutputFile, " (message from process level0)\n");
    fclose(part2OutputFile);
    execl("./part2/level0", "level0", "cce46951b761cbdf2b93646b", NULL);
    
}
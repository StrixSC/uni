// Fonction "main" pour l'exécution des tests

// Librairies CppUnit nécessaires
#include <cppunit/ui/text/TestRunner.h>

// Fichiers contenant les tests
#include "rabais_test.h"

int main( int argc, char **argv)
{
    CppUnit::TextUi::TestRunner runner;
    runner.addTest(RabaisTest::suite());
    runner.run();

    return 0; 
}
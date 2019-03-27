// Librairies CppUnit nécessaires
#include <cppunit/ui/text/TestRunner.h>

// Fichiers contenant les tests
#include "rabais_test.h"

int main(int argc, char **argv)
{
    // Crée un objet pour exécuter les tests.
    // Va résenter les résultats sous forme textuelle.
    CppUnit::TextUi::TestRunner runner;
    TestFactoryRegistry &registry = TestFactoryRegistry::getRegistry();
    // La classe DiviseurTest contient des macros. 
    // Ces macros définissent une suite de tests.
    // Cela lui donne la méthode statique "suite" qui est appelée ici.
    // Cette méthode statique retourne des pointeurs vers les méthodes de tests.
    runner.addTest(registry.makeTest());

    // Exécute les tests et affiche les résultats.
    runner.run();

    return (EXIT_SUCCESS);
}
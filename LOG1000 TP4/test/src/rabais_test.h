#ifndef RABAISTEST_H
#define RABAISTEST_H

#include "../../src/rabais.h"
#include <cppunit/TestCase.h>
#include <cppunit/TestFixture.h>
#include <cppunit/extensions/HelperMacros.h>

using namespace CppUnit;

class RabaisTest : public CppUnit::TestFixture {

    CPPUNIT_TEST_SUITE(RabaisTest);
    CPPUNIT_TEST(test_rabais_employe);
    CPPUNIT_TEST_SUITE_END();

private:
    Rabais* objet_a_tester;

public:
    //Fonctions d'échafaudage
    void setUp();
    void tearDown();

    //Fonctions de tests
    void test_rabais_employe();
};

#endif
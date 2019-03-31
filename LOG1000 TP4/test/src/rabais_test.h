#ifndef RABAISTEST_H
#define RABAISTEST_H

#include "../../src/rabais.h"
#include <cppunit/TestCase.h>
#include <cppunit/TestFixture.h>
#include <cppunit/extensions/HelperMacros.h>

using namespace CppUnit;

class RabaisTest : public CppUnit::TestFixture {

    CPPUNIT_TEST_SUITE(RabaisTest);
    CPPUNIT_TEST(test_rabais_SRS01);
    CPPUNIT_TEST(test_rabais_SRS02);
    CPPUNIT_TEST(test_rabais_SRS03);
    CPPUNIT_TEST(test_rabais_SRS04);
    CPPUNIT_TEST(test_rabais_SRS05_1);
    CPPUNIT_TEST(test_rabais_SRS05_2);
    CPPUNIT_TEST(test_rabais_SRS05_3);
    CPPUNIT_TEST(test_rabais_SRS06);
    CPPUNIT_TEST(test_rabais_SRS07);
    CPPUNIT_TEST(test_rabais_SRS08);
    CPPUNIT_TEST(test_rabais_SRS09);
    CPPUNIT_TEST_SUITE_END();

private:
    Rabais* objet_a_tester;

public:
    //Fonctions d'échafaudage
    void setUp();
    void tearDown();

    //Fonctions de tests
    void test_rabais_SRS01();
    void test_rabais_SRS02();
    void test_rabais_SRS03();
    void test_rabais_SRS04();
    void test_rabais_SRS05_1();
    void test_rabais_SRS05_2();
    void test_rabais_SRS05_3();
    void test_rabais_SRS06();
    void test_rabais_SRS07();
    void test_rabais_SRS08();
    void test_rabais_SRS09();
};

#endif
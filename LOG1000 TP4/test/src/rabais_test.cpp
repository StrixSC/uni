#include "rabais_test.h"

#include "diviseur_test.h"

void RabaisTest::setUp() {
		this->objet_a_tester = new RabaisTest();
}

void RabaisTest::tearDown() {
		delete this->objet_a_tester;
}

void RabaisTest::test_rabais_employe(){
    this->objet_a_tester->getRabais(f, 90001);
    CPPUNIT_ASSERT_EQUAL(0.2,getRabais);
}

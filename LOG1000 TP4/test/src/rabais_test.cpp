#include "rabais_test.h"

void RabaisTest::setUp() {
		this->objet_a_tester = new Rabais();
}

void RabaisTest::tearDown() {
		delete this->objet_a_tester;
}

void RabaisTest::test_rabais_employe(){
        tm date;
        date.tm_year = 2019;
        date.tm_mon = 12;
        date.tm_mday = 13;

        Client* client = new Client(90102, "Simmons", "Marcos", 66, "H4B", date);
        this->objet_a_tester->ajouterClient(client);

        Facture facture;
        facture.ajouterItem(5.0);

        double rabais = this->objet_a_tester->getRabais(facture, 90102);

        CPPUNIT_ASSERT_DOUBLES_EQUAL(0.2, rabais, FLT_EPSILON);
}

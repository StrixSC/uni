#include "rabais_test.h"

void RabaisTest::setUp() {
		this->objet_a_tester = new Rabais();
}

void RabaisTest::tearDown() {
		delete this->objet_a_tester;
}

void RabaisTest::test_rabais_SRS01(){
        tm date;
        date.tm_year = 2019 - 1900; 
        date.tm_mon = 01;
        date.tm_mday = 01;

        Client* client = new Client(90001, "Amin", "Nawras", 21, "L0L", date);
        this->objet_a_tester->ajouterClient(client);

        Facture facture;
        facture.ajouterItem(1.0);

        double rabais = this->objet_a_tester->getRabais(facture, 90001);

        CPPUNIT_ASSERT_DOUBLES_EQUAL(0.2, rabais, FLT_EPSILON);
        
}

void RabaisTest::test_rabais_SRS02(){
        tm date;
        date.tm_year = 2019 - 1900; 
        date.tm_mon = 01;
        date.tm_mday = 01;

        Client* client = new Client(90001, "Amin", "Nawras", 21, "L0L", date);
        this->objet_a_tester->ajouterClient(client);

        Facture facture;
        facture.ajouterItem(1.0);

        double rabais = this->objet_a_tester->getRabais(facture, 90001);

        CPPUNIT_ASSERT_DOUBLES_EQUAL(0.2, rabais, FLT_EPSILON);
        
}

void RabaisTest::test_rabais_SRS03(){
        tm date;
        date.tm_year = 2019 - 1900; 
        date.tm_mon = 01;
        date.tm_mday = 01;

        Client* client = new Client(90002, "Amin", "Nawras", 65, "L0L", date);
        this->objet_a_tester->ajouterClient(client);

        Facture facture;
        facture.ajouterItem(1.0);

        double rabais = this->objet_a_tester->getRabais(facture, 90002);

        CPPUNIT_ASSERT_DOUBLES_EQUAL(0.2, rabais, FLT_EPSILON);
        
}

void RabaisTest::test_rabais_SRS04(){
        tm date;
        date.tm_year = 2019 - 1900; 
        date.tm_mon = 01;
        date.tm_mday = 01;

        Client* client = new Client(00002, "Amin", "Nawras", 65, "L0L", date);
        this->objet_a_tester->ajouterClient(client);

        Facture facture;
        facture.ajouterItem(1.0);

        double rabais = this->objet_a_tester->getRabais(facture, 00002);

        CPPUNIT_ASSERT_DOUBLES_EQUAL(0.05, rabais, FLT_EPSILON);

}


void RabaisTest::test_rabais_SRS05_1(){
        tm date;
        date.tm_year = 2019 - 1900; 
        date.tm_mon = 01;
        date.tm_mday = 01;

        Client* client = new Client(00001, "Amin", "Nawras", 21, "G0X", date);
        this->objet_a_tester->ajouterClient(client);

        Facture facture;
        facture.ajouterItem(1.0);

        double rabais = this->objet_a_tester->getRabais(facture, 00001);

        CPPUNIT_ASSERT_DOUBLES_EQUAL(0.02, rabais, FLT_EPSILON);
        
}

void RabaisTest::test_rabais_SRS05_2(){
        tm date;
        date.tm_year = 2019 - 1900; 
        date.tm_mon = 01;
        date.tm_mday = 01;

        Client* client = new Client(00001, "Amin", "Nawras", 21, "H4L", date);
        this->objet_a_tester->ajouterClient(client);

        Facture facture;
        facture.ajouterItem(1.0);

        double rabais = this->objet_a_tester->getRabais(facture, 00001);

        CPPUNIT_ASSERT_DOUBLES_EQUAL(0.02, rabais, FLT_EPSILON);
        
}

void RabaisTest::test_rabais_SRS05_3(){
        tm date;
        date.tm_year = 2019 - 1900; 
        date.tm_mon = 01;
        date.tm_mday = 01;

        Client* client = new Client(00001, "Amin", "Nawras", 21, "H2X", date);
        this->objet_a_tester->ajouterClient(client);

        Facture facture;
        facture.ajouterItem(0.0);

        double rabais = this->objet_a_tester->getRabais(facture, 00001);

        CPPUNIT_ASSERT_DOUBLES_EQUAL(0.01, rabais, FLT_EPSILON);
        
}

void RabaisTest::test_rabais_SRS06(){
        tm date;
        date.tm_year = 2010 - 1900; 
        date.tm_mon = 01;
        date.tm_mday = 01;

        Client* client = new Client(00001, "Amin", "Nawras", 21, "L0L", date);
        this->objet_a_tester->ajouterClient(client);

        Facture facture;
        facture.ajouterItem(1.0);

        double rabais = this->objet_a_tester->getRabais(facture, 00001);

        CPPUNIT_ASSERT_DOUBLES_EQUAL(0.01, rabais, FLT_EPSILON);
        
}

void RabaisTest::test_rabais_SRS07(){
        tm date;
        date.tm_year = 2000 - 1900; 
        date.tm_mon = 01;
        date.tm_mday = 01;

        Client* client = new Client(00001, "Amin", "Nawras", 21, "L0L", date);
        this->objet_a_tester->ajouterClient(client);

        Facture facture;
        facture.ajouterItem(1.0);

        double rabais = this->objet_a_tester->getRabais(facture, 00001);

        CPPUNIT_ASSERT_DOUBLES_EQUAL(0.05, rabais, FLT_EPSILON);
        
        
}

void RabaisTest::test_rabais_SRS08(){
        tm date;
        date.tm_year = 2019 - 1900; 
        date.tm_mon = 01;
        date.tm_mday = 01;

        Client* client = new Client(00001, "Amin", "Nawras", 21, "L0L", date);
        this->objet_a_tester->ajouterClient(client);

        Facture facture;
        facture.ajouterItem(300.0);

        double rabais = this->objet_a_tester->getRabais(facture, 00001);

        CPPUNIT_ASSERT_DOUBLES_EQUAL(0.03, rabais, FLT_EPSILON);
        
        
}

void RabaisTest::test_rabais_SRS09(){
        tm date;
        date.tm_year = 2019 - 1900; 
        date.tm_mon = 01;
        date.tm_mday = 01;

        Client* client = new Client(00001, "Amin", "Nawras", 21, "L0L", date);
        this->objet_a_tester->ajouterClient(client);

        Facture facture;
        facture.ajouterItem(1000.0);

        double rabais = this->objet_a_tester->getRabais(facture, 00001);

        CPPUNIT_ASSERT_DOUBLES_EQUAL(0.05, rabais, FLT_EPSILON);
        
        
}
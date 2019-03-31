#include "rabais_test.h"

void RabaisTest::setUp() {
		this->objet_a_tester = new Rabais();
}

void RabaisTest::tearDown() {
		delete this->objet_a_tester;
}

void RabaisTest::test_rabais_SRS01(){
        tm date;
        date.tm_year = 2019; 
        date.tm_mon = 01;
        date.tm_mday = 15;

        Client* client = new Client(90034, "Travaillant", "Mark", 25, "H1K", date);
        this->objet_a_tester->ajouterClient(client);

        Facture facture;
        facture.ajouterItem(5.0);

        double rabais = this->objet_a_tester->getRabais(facture, 90034);

        CPPUNIT_ASSERT_DOUBLES_EQUAL(0.2, rabais, FLT_EPSILON);
}

void RabaisTest::test_rabais_SRS02(){
        tm date;
        date.tm_year = 2019; 
        date.tm_mon = 01;
        date.tm_mday = 15;

        Client* client = new Client(90034, "Travaillant", "Mark", 25, "H1K", date);
        this->objet_a_tester->ajouterClient(client);

        Facture facture;
        facture.ajouterItem(5.0);

        double rabais = this->objet_a_tester->getRabais(facture, 90034);

        CPPUNIT_ASSERT_DOUBLES_EQUAL(0.2, rabais, FLT_EPSILON);
}

void RabaisTest::test_rabais_SRS03(){
        tm date;
        date.tm_year = 2008;
        date.tm_mon = 12;
        date.tm_mday = 13; // On set la date d'adhesion du client, ici elle est d'environ 12 ans, ce qui devrait donner un rabais supplementaire de 12/3 = 4% (donc 0.04, mais comme le client est un employe, il n'y devrait pas y avoir de rabais supplementaire)

        Client* client = new Client(90102, "Simmons", "Marcos", 66, "H4B", date); //On creer le Client selon le fichier client.dat
        this->objet_a_tester->ajouterClient(client);

        Facture facture; //On creer une facture
        facture.ajouterItem(500.0); //Ajout de 500 items, qui devrait donner 0.05 sur le rabais, mais comme le client est un employe, il n'y devrait pas y avoir de rabais supplementaire;

        double rabais = this->objet_a_tester->getRabais(facture, 90102);

        CPPUNIT_ASSERT_DOUBLES_EQUAL(0.2, rabais, FLT_EPSILON);
}

void RabaisTest::test_rabais_SRS04(){
        tm date;
        date.tm_year = 2010; 
        date.tm_mon = 01;
        date.tm_mday = 30;

        //Creation du client selon un des clients dans le fichier client.dat
        //Comme le code du client est <90 000, le(la) client(e) n'est pas un(e) employe(e), donc le rabais n'est pas bloque a 0.2.
        //Ce(Cette) client(e) a + de 65 ans, donc rabais commence a 0.05
        //Le(La) client(e) est abonne(e) depuis 2010-01-03 (donc 2019-2010 = 9 ans -> 9/3 = 0.03 de plus sur le rabais total)
        //Le(La) client(e) n'est pas situee dans une des zones: G0X, H4L, H2X, donc aucun rabais supplementaire
        Client* client = new Client(14770, "Bean", "Paula", 78, "H2H", date);
        this->objet_a_tester->ajouterClient(client);

        //On creer une facture avec que 5 items dedans, donc aucun rabais supplementaire;
        Facture facture;
        facture.ajouterItem(5.0);

        double rabais = this->objet_a_tester->getRabais(facture, 14770);
        //Le rabais que nous devons avoir (oracle) = 0.08 == rabais_personne_agee + rabais_adhesion
        CPPUNIT_ASSERT_DOUBLES_EQUAL(0.08, rabais, FLT_EPSILON);
}

void RabaisTest::test_rabais_SRS05(){
        tm date;
        date.tm_year = 2016; 
        date.tm_mon = 10;
        date.tm_mday = 25;

        //Creation du client selon un des clients dans le fichier client.dat
        //Comme le code du client est <90 000, le(la) client(e) n'est pas un(e) employe(e), donc le rabais n'est pas bloque a 0.2.
        
        //Ce(Cette) client(e) a moins de 65 ans, donc aucun rabais supplementaire de personne agee
        //Le(La) client(e) est abonne(e) depuis 2016-10-25 (donc 2019-2016 = 3 ans -> 3/3 = 0.01 de plus sur le rabais total)
        //Le(La) client(e) est situe(e) dans une des zones: G0X, H4L, H2X, donc rabais supplementaire de: 0.02 (car G0X)
        Client* client = new Client(10456, "Tremblay", "Anna", 45, "G0X", date);
        this->objet_a_tester->ajouterClient(client);

        //On creer une facture avec que 5 items dedans, donc aucun rabais supplementaire;
        Facture facture;
        facture.ajouterItem(5.0);

        double rabais = this->objet_a_tester->getRabais(facture, 10456);
        //Le rabais que nous devons avoir (oracle) = 0.03 == rabais_zone(G0X) + rabais_adhesion
        CPPUNIT_ASSERT_DOUBLES_EQUAL(0.03, rabais, FLT_EPSILON);
}


void RabaisTest::test_rabais_SRS05(){
        tm date;
        date.tm_year = 2016; 
        date.tm_mon = 10;
        date.tm_mday = 25;

        //Creation du client selon un des clients dans le fichier client.dat
        //Comme le code du client est <90 000, le(la) client(e) n'est pas un(e) employe(e), donc le rabais n'est pas bloque a 0.2.
        
        //Ce(Cette) client(e) a moins de 65 ans, donc aucun rabais supplementaire de personne agee
        //Le(La) client(e) est abonne(e) depuis 2016-10-25 (donc 2019-2016 = 3 ans -> 3/3 = 0.01 de plus sur le rabais total)
        //Le(La) client(e) est situe(e) dans une des zones: G0X, H4L, H2X, donc rabais supplementaire de: 0.02 (car G0X)
        Client* client = new Client(10456, "Tremblay", "Anna", 45, "G0X", date);
        this->objet_a_tester->ajouterClient(client);

        //On creer une facture avec que 5 items dedans, donc aucun rabais supplementaire;
        Facture facture;
        facture.ajouterItem(5.0);

        double rabais = this->objet_a_tester->getRabais(facture, 10456);
        //Le rabais que nous devons avoir (oracle) = 0.03 == rabais_zone(G0X) + rabais_adhesion
        CPPUNIT_ASSERT_DOUBLES_EQUAL(0.03, rabais, FLT_EPSILON);
}

void RabaisTest::test_rabais_SRS05(){
        tm date;
        date.tm_year = 2016; 
        date.tm_mon = 10;
        date.tm_mday = 25;

        //Creation du client selon un des clients dans le fichier client.dat
        //Comme le code du client est <90 000, le(la) client(e) n'est pas un(e) employe(e), donc le rabais n'est pas bloque a 0.2.
        
        //Ce(Cette) client(e) a moins de 65 ans, donc aucun rabais supplementaire de personne agee
        //Le(La) client(e) est abonne(e) depuis 2016-10-25 (donc 2019-2016 = 3 ans -> 3/3 = 0.01 de plus sur le rabais total)
        //Le(La) client(e) est situe(e) dans une des zones: G0X, H4L, H2X, donc rabais supplementaire de: 0.02 (car G0X)
        Client* client = new Client(10456, "Tremblay", "Anna", 45, "G0X", date);
        this->objet_a_tester->ajouterClient(client);

        //On creer une facture avec que 5 items dedans, donc aucun rabais supplementaire;
        Facture facture;
        facture.ajouterItem(5.0);

        double rabais = this->objet_a_tester->getRabais(facture, 10456);
        //Le rabais que nous devons avoir (oracle) = 0.03 == rabais_zone(G0X) + rabais_adhesion
        CPPUNIT_ASSERT_DOUBLES_EQUAL(0.03, rabais, FLT_EPSILON);
}


void RabaisTest::test_rabais_SRS06(){
        tm date;
        date.tm_year = 2011; 
        date.tm_mon = 01;
        date.tm_mday = 01;

        //Creation du client selon un des clients dans le fichier client.dat
        //Comme le code du client est <90 000, le(la) client(e) n'est pas un(e) employe(e), donc le rabais n'est pas bloque a 0.2.
        
        //Ce(Cette) client(e) a moins de 65 ans, donc aucun rabais supplementaire de personne agee
        //Le(La) client(e) est abonne(e) depuis 2016-10-25 (donc 2019-2016 = 3 ans -> 3/3 = 0.01 de plus sur le rabais total)
        //Le(La) client(e) est situe(e) dans une des zones: G0X, H4L, H2X, donc rabais supplementaire de: 0.02 (car G0X)
        Client* client = new Client(00001, "Amin", "Nawras", 21ç, "H3L", date);
        this->objet_a_tester->ajouterClient(client);

        //On creer une facture avec que 5 items dedans, donc aucun rabais supplementaire;
        Facture facture;
        facture.ajouterItem(5.0);

        double rabais = this->objet_a_tester->getRabais(facture, 10456);
        //Le rabais que nous devons avoir (oracle) = 0.03 == rabais_zone(G0X) + rabais_adhesion
        CPPUNIT_ASSERT_DOUBLES_EQUAL(0.03, rabais, FLT_EPSILON);
}


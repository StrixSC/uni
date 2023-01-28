import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.Socket;
import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Scanner;

public class ClientHandler extends Thread {
    private Socket client;
    private int clientNumber;
    private PrintWriter outToClient;
    private BufferedReader inFromClient;
    private HashMap<String, String> users;
    private File userDB;
    private boolean authentified = false;

    /*
    @Brief: Constructeur de ClientHandler. Lit la database (users.txt) et stock les infos dans un hashmap
    si elle existe, sinon elle l'a crée. Instancie aussi son BufferedReader et PrintWriter pour la communication
    end-to-end avec le client.
    @Param: client Socket et clientNumber (int);
    @Return: void
    */
    public ClientHandler(Socket client, int clientNumber) throws IOException {

        userDB = new File("users.txt");
        if(!userDB.exists()){
            userDB.createNewFile();
        }
        this.users = new HashMap<String, String>();

        Scanner fileReader = new Scanner(userDB);
        while (fileReader.hasNextLine()) {
            String username = fileReader.nextLine();
            String password = fileReader.nextLine();
            users.put(username, password);
        }

        this.client = client;
        this.clientNumber = clientNumber;
        outToClient = new PrintWriter(client.getOutputStream(), true);
        inFromClient = new BufferedReader(new InputStreamReader(client.getInputStream()));
        System.out.format("[*] Nouvelle connection avec client #%d \n", clientNumber);
    }

    public int getClientNumber() { return clientNumber; }

    /*
    @Brief: Classe run qui override de Thread. Permet de rouler le clienthandler en tant que nouveau processus.
    C'est la classe qui gére les erreurs dans la connection et qui loop sans cesse la methode de gestion des options,
    tant que l'utilisateur n'a pas quitté sa connection avec le socket.
    @Param: void;
    @Return: void;
    */
    public void run() {
        try {
            //To send messages to client
            outToClient.println("[*] Serveur prêt, en attente des requêtes du client...\n");
            while(!handleClient());

        } catch (Exception e) {
            System.out.format("[!] Erreur dans la gestion du client #%d\n", clientNumber);
        }
        finally {
            try {
                client.close();
            } catch (IOException e) {
                System.out.println("[!] Erreur dans la fermeture du socket avec le client\n" + e);
            }

            System.out.format("[*] Connexion avec le client #%d fermée\n", clientNumber);
        }
    }

    /*
    @Brief: Cette classe roule tant que l'utilisateur n'a pas fermé sa connection.
    Elle recoit le choix d'option de l'utilisateur et emmet le resultat correspondant.
    @Param: void
    @Return: boolean permettant a run() de savoir si le client a arreter l'envoie de choix.
    */
    public boolean handleClient() throws IOException {
        System.out.println("[*] En attente d'entree de l'utilisateur... ");
        String selectedOption = inFromClient.readLine();
        System.out.format("[*] Client %d - Option choisie: %s\n", clientNumber, selectedOption);
        String username = null, password = null;

        if(selectedOption.equals("register") && !authentified) {
            System.out.println("[*] Inscription en cours...");
            username = inFromClient.readLine();
            password = inFromClient.readLine();
            if(writeToDisk(username, password)) {
                System.out.println("[*] Ajout d'utilisateur avec succès");
                outToClient.println("false");
                authentified = true;
            }
            else {
                outToClient.println("true");
            }
        }
        else if(selectedOption.equals("auth") && !authentified) {
            username = inFromClient.readLine();
            password = inFromClient.readLine();
            if(findUser(username, password)) {
                outToClient.println("true");
                authentified = true;
                System.out.println("[*] Authenthification faite avec succès!");
            }
            else
                outToClient.println("false");
        }
        else if(selectedOption.equals("sobel") && authentified){
            BufferedImage img = getImg();
            outToClient.println("incoming");
            sendImg(img);
        }
        return false;
    }

    /*
    @Brief: Cette classe permet la reception de l'image auquel appliquer le filtre de Sobel.
    Cette méthode est beaucoup plus documentée que les autre pour pouvoir montrer la façon utiliser pour obtenir l'image.
    @Param: void;
    @Return: Renvoie un objet BufferedImage qui contient les bytes de l'image sur lequel appliquer le filtre.
    */
    public BufferedImage getImg() throws IOException {
        InputStream in = client.getInputStream();   //On créer un nouveau InputStream pour générer le BufferedImage

        byte[] bytes = new byte[4];     //creation d'un tableau de byte pour pouvoir le fournir in.read().
        //Stock le tableau de bytes que nous avons créer par l'information venant du Inputstream
        in.read(bytes);

        //Cette ligne de code permet d'utilizer les bytes lu dans la ligne de code précédant et les lires avec .get()
        //Puis de stocker la taille entière une fois fini dans le imgSize. Maintenant nous avons une taille pour l'image.
        Integer imgSize = ByteBuffer.wrap(bytes).asIntBuffer().get();

        byte[] img = new byte[imgSize]; //On peut maintenant créer un nouveau tableau de bytes avec la taille précise de l'image.
        in.read(img);

        //Que nous passsons ensuite dans un BufferedImage grâce a ImageIO qui  permet de lire des tableau de Bytes.
        System.out.format("[!] Fichier image reçue du client #%d\n", clientNumber);
        BufferedImage receivedImg = ImageIO.read(new ByteArrayInputStream(img));
        outToClient.println("received");        //Alert le client de la reception de l'image.

        //On retourne l'image filtrée.
        return Sobel.process(receivedImg);
    }

    /*
    @Brief: Permet d'envoyer l'image filtrée au client.
    Cette classe reprend un peu les mêmes méthodes que pour receiveImg.
    @Param: Le BufferedImage filtrée avec le filtre de Sobel.
    @Return: void;
    */
    public void sendImg(BufferedImage img) throws IOException {
        OutputStream out = client.getOutputStream();
        ByteArrayOutputStream byteOut = new ByteArrayOutputStream();
        ImageIO.write(img,"jpg", byteOut);  //Ici on envoie créer un nouveau fichier jpg avec Image.write;

        //ByteBuffer.allocate(4) retourne un ByteBuffer de capacite 4
        //putInt(byteOut.size()) écrit dans ByteBuffer la valeur de byteout.size() à sa position actuelle.
        //.array() transforme le ByteBuffer en array et le donne a size[];
        byte size[] = ByteBuffer.allocate(4).putInt(byteOut.size()).array();
        out.write(size);
        out.write(byteOut.toByteArray());
        out.flush(); //On vide le stream pour permettre l'envoie.
    }

    /*
   @Brief: Cette classe verifie si l'utilisateur existe dans la base de donnee
   @Param: String nom identificateur et String Mot de passe
   @Return: boolean validant ou non l'existence de l'utilisateur.
   */
    public boolean findUser(String username, String password) {
        if(users.containsKey(username)) {
            if (users.get(username).equals(password))
                return true;        //Si on trouve le username avec le bon password;
            else
                return false;       //Si on trouve le username sans le bon password;
        } else return false;
    }

    /*
    @Brief: permet l'ecriture d'un nouvel utilisateur dans la base de donnee (users.txt);
    @Param: String username et String password
    @Return: boolean permettant de savoir si l'ecriture a ete faite.
    */
    public boolean writeToDisk(String username, String password) throws IOException {
       //Username could already exist with the given password in the DB.
        if(!findUser(username, password)) {
            users.put(username, password);
            FileWriter writer = new FileWriter(userDB, true);
            writer.write(username + "\n");
            writer.write(password + "\n");
            writer.close();
            return true;
        }
        else {
            System.out.println("[!] L'utilisateur existe deja.");
            return false;
        }
    }
}

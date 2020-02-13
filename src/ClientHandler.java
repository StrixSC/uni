import javax.xml.crypto.Data;
import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Scanner;

public class ClientHandler extends Thread {
    private Socket client;
    private int clientNumber;
    PrintWriter outToClient;
    BufferedReader inFromClient;
    HashMap<String, String> users;
    File userDB;

    public ClientHandler(Socket client, int clientNumber) throws IOException {

        userDB = new File("users.txt");
        if(!userDB.exists()){
            userDB.createNewFile();
        }

        this.users = new HashMap<String, String>();
        Scanner fileReader = new Scanner(userDB);
        while(fileReader.hasNextLine()) {
            String username = fileReader.nextLine();
            String password = fileReader.nextLine();
            this.users.put(username, password);
        }
        this.client = client;
        this.clientNumber = clientNumber;
        outToClient = new PrintWriter(client.getOutputStream(), true);
        inFromClient = new BufferedReader(new InputStreamReader(client.getInputStream()));
        System.out.format("[*] Nouvelle connection avec client #%d \n", clientNumber);
    }

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

    public boolean handleClient() throws IOException {
        System.out.println("[*] En attente d'entree de l'utilisateur... ");
        String selectedOption = inFromClient.readLine();
        String username = null, password = null;

        if(selectedOption.equals("register")) {
            System.out.println("[*] Registering...");
            username = inFromClient.readLine();
            password = inFromClient.readLine();
            this.users.put(username, password);
            writeToDisk(username, password);
            System.out.println("[*] Ajout d'utilisateur avec succès");
        }
        else if(selectedOption.equals("auth")) {
            username = inFromClient.readLine();
            password = inFromClient.readLine();
            if(this.users.get(username) == password)
                outToClient.println(true);
            else
                outToClient.println(false);
        }
        return false;
    }

    public boolean findUser(String username, String password) {
        if(this.users.get(username).equals(password)){
            return true;
        }
        return false;
    }

    public void writeToDisk(String username, String password) throws IOException {
       //Username could already exist with the given password in the DB.
        FileWriter writer = new FileWriter(userDB, true);
        writer.write(username + "-" + password);
        writer.close();
    }
}

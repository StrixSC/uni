import javafx.util.Pair;

import java.io.*;
import java.net.Socket;
import java.util.Scanner;

public class Client {
    private static Scanner input = new Scanner(System.in);
    private static Socket server;
    private static PrintWriter toServer;
    private static BufferedReader fromServer;

    public static void main(String args[]) throws IOException, InterruptedException {
        connect(Validator.validate());
        while(!UI.initOptions());
        while(!UI.showMenu());
    }

    /*
    Getter et setters pour obtenir les buffers d'ecriture pour le end-to-end communication.
     */
    public static Scanner getInput() { return input; }
    public static PrintWriter getToServer() { return toServer; }
    public static BufferedReader getFromServer() { return fromServer; }
    public static Socket getServer() { return server; }

    /*
    * @brief: On utilise les ips validés par le validator pour se connecter au serveur avec les deux ips obtenus.
    * Une fois la connection réussie, on créer les nouveaux buffers pour envoyer et recevoir du serveur.
    * @param: Pair<String, Integer>;
    * @return: void;
     * */
    public static void connect(Pair<String, Integer> ipAndPort) throws IOException {
        System.out.println("[*] Connexion au serveur en cours...");
        System.out.println("[*] Veuillez patienté...");
        try {
            server = new Socket(ipAndPort.getKey(), ipAndPort.getValue());
            toServer = new PrintWriter(server.getOutputStream(), true);
            fromServer = new BufferedReader( new InputStreamReader(server.getInputStream()));
            System.out.println("[*] Connexion au serveur réussie!");
        } catch (IOException e) {
            System.out.println("[!] Le serveur ne roule pas en ce moment " +
                    "ou bien les paramètres de IP et de Port entrés ne correspondent pas a un serveur actif...");
            System.exit(0);
        }
    }

    public static void exit() {
        System.out.println("[*] Fermeture du programme...");
        System.exit(0);
    }

    public static boolean register(String username, String password) throws IOException{
        toServer.println(username);
        toServer.println(password);
        String userExists = "";
        boolean response = false;
        while(!response){
            userExists = fromServer.readLine();
            if(userExists.equals("false") || userExists.equals("true"))
                response = true;
        }

        if(userExists.equals("false")) {
            System.out.format("[*] Succès! Bienvenu %s\n", username);
            return true;
        }
        else if(userExists.equals("true")){
            System.out.println("[!] Cet utilisateur existe deja.");
            return false;
        }
        else return false;
    }

    public static boolean auth(String username, String password) throws IOException {
        toServer.println(username);
        toServer.println(password);

        String userExists = "";
        boolean response = false;
        while(!response){
            userExists = fromServer.readLine();
            if(userExists.equals("false") || userExists.equals("true"))
                response = true;
        }
        if(userExists.equals("false")) {
            System.out.format("[!] Erreur, cet utilisateur n'existe pas.\n");
            return false;
        }
        else if(userExists.equals("true")) {
            System.out.format("[*] Succès! Bienvenu %s\n", username);
            return true;
        }
        else return false;
    }
}


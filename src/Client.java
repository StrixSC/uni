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
    Getter et setters pour obtenir les buffers d'écriture pour le end-to-end communication.
     */
    public static Scanner getInput() { return input; }
    public static PrintWriter getToServer() { return toServer; }
    public static BufferedReader getFromServer() { return fromServer; }
    public static Socket getServer() { return server; }

    /*
     * @brief: On utilise les IPs validés par le validator pour se connecter au serveur avec les deux ips obtenus.
     * Une fois la connection réussie, on créer les nouveaux buffers pour envoyer et recevoir du serveur.
     * @param: Pair<String, Integer> contenant le ip et le port saisie et validé par le Validateur.
     * @return: void;
     */
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

    public static void exit() throws IOException {
        System.out.println("[*] Fermeture du programme...");
        server.close();
        System.exit(0);
    }

    /*
     * @brief: Cette méthode recoit les parametres username et password saisie par le UI et les envoie au serveur
     * pour validation. Le serveur envoie une reponse "true" ou "false", dépendamment de si la pair d'information existe
     * deja dans la base de donnée.
     * @param: String username et String password.
     * @return: boolean indiquant is la registration à été faite ou non.
     */
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

    /*
     * @brief: Même processus que pour la registration, cependant dans le cas de réponse false du serveur,
     * la méthodologie est différente: l'utilisateur et son password sont automatiquement entrée dans la base de donnée.
     * @param: String username et String password.
     * @return: boolean indiquant is la authentification à été faite ou non.
     */
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


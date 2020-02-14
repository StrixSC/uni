import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.Socket;
import java.nio.Buffer;
import java.nio.ByteBuffer;
import java.util.Scanner;

public class Client {
    private static Scanner input = new Scanner(System.in);
    private static Socket server;
    private static PrintWriter toServer;
    private static BufferedReader fromServer;

    public static void main(String args[]) throws IOException, InterruptedException {
        while(!Validator.validate());
        connect();
        while(!UI.initOptions());
        while(!UI.showMenu());
    }

    public static Scanner getInput() { return input; }
    public static PrintWriter getToServer() { return toServer; }
    public static BufferedReader getFromServer() { return fromServer; }
    public static Socket getServer() { return server; }

    public static void connect() throws IOException {
        System.out.println("[*] Connexion au serveur en progres...");
        try {
            server = new Socket(Validator.getIp(), Validator.getPort());
            toServer = new PrintWriter(server.getOutputStream(), true);
            fromServer = new BufferedReader( new InputStreamReader(server.getInputStream()));
            System.out.println("[*] Connexion au serveur réussie");
        } catch (IOException e) {
            System.out.println("[X] Le serveur ne roule pas en ce moment...");
            System.exit(0);
        }
    }

    public static void exit() {
        System.out.println("[*] Fermeture du programme...");
        System.exit(0);
    }

    public static boolean register() throws IOException{
        String username = "", password = "";
        Boolean usernameEntered = false, passwordEntered = false;
        System.out.println("[*] Bienvenue sur le serveur Sobel!");

        while(!usernameEntered) {
            System.out.println("[*] Entrez un nom d'utilisateur unique: ");
            username = input.nextLine().trim();
            if(Validator.verify(username)){
                usernameEntered = true;
            }
        }

        while(!passwordEntered) {
            System.out.println("[*] Entrez un mot de passe secure:");
            password = input.nextLine().trim();
            if(Validator.verify(password)){
                passwordEntered= true;
            }
        }

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

    public static boolean auth() throws IOException {
        String username = null, password = null;
        boolean usernameEntered = false, passwordEntered = false;

        System.out.println("[*] Entrez votre nom d'utilisateur: ");
        while(!usernameEntered){
            username = input.nextLine();
            if(Validator.verify(username))
                usernameEntered = true;
        }

        System.out.println("[*] Entrez votre mot de passe:");
        while(!passwordEntered){
            password = input.nextLine();
            if(Validator.verify(password))
                passwordEntered = true;
        }

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


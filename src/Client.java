import javax.imageio.stream.FileImageOutputStream;
import javax.swing.*;
import java.io.*;
import java.net.Socket;
import java.nio.file.Paths;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Client {
    private static Scanner input = new Scanner(System.in);
    private static Integer port;            //Empty port, user defined.
    private static String ip = "";      //Empty IPAdr, user defined.
    private static Socket server;
    private static Pattern regex;
    private static Matcher regexMatcher;
    private static String imgPath;
    private static PrintWriter toServer;
    private static BufferedReader fromServer;


    public static void main(String args[]) throws IOException {
        while(!validate());
        connect();

        while(!initOptions());
        while(!showMenu());
    }

    public static boolean validate() {
        while(!validateIP());
        while(!validatePort());
        System.out.println("[*] Validated...");
        return true;
    }

    public static boolean validateIP() {
        //get user input:
        System.out.println("[*] Entrez l'adresse IP du serveur auquel vous voulez vous connectez");
        ip = input.nextLine();

        /*
            Utilise regex pour valider le ip:
            d{1,3}: digit 1 a 3 fois. (ex.: 192 = 3 digits)
            \\.   : on accept un '.' comme prochain input
        */
        regex = Pattern.compile("^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$");
        regexMatcher = regex.matcher(ip);
        boolean matched = regexMatcher.find();
        if(matched){
            System.out.println("[*] IP Valide...");
            return matched;
        }
        else {
            System.out.println("[X] IP Invalide, saisir une nouvelle adresse IP...");
            return matched;
        }
    }

    public static boolean validatePort() {
        //get user input:
        System.out.println("[*] Entrez le Port auquel vous voulez vous connectez (entre 5000 et 5050)");
        port = Integer.parseInt(input.nextLine());

        regex = Pattern.compile("^(\\d{4})$");
        regexMatcher = regex.matcher(port.toString());

        if(port > 5050 || port < 5000){
            System.out.println("[X] Port Invalide, saisir un nouveau port (entre 5000 et 5050)...");
            return false;
        }
        else if(regexMatcher.find()) {
            System.out.println("[*] Port Valide...");
            return true;
        }
        else {
            System.out.println("[X] Port Invalide, saisir un nouveau port (entre 5000 et 5050)...");
            return false;
        }
    }

    public static void connect() throws IOException {
        System.out.println("[*] Connexion au serveur en progres...");
        try {
            server = new Socket(ip, port);
            toServer = new PrintWriter(server.getOutputStream(), true);
            fromServer = new BufferedReader( new InputStreamReader(server.getInputStream()));
            System.out.println("[*] Connexion au serveur réussie");
        } catch (IOException e) {
            System.out.println("[X] Le serveur ne roule pas en ce moment...");
            System.exit(0);
        }
    }

    public static void sendImg() throws IOException {
        System.out.println("[*] Entrez le nom du fichier que vous voulez envoyer au serveur " +
                "(son nom dans le repertoire actuel avec son extension)");
        imgPath = input.nextLine();
        while(!requestImg());

        InputStream inputStream = server.getInputStream();
        FileOutputStream fileOutput = new FileOutputStream(imgPath);
        byte[] imgBytes = new byte[10000];

        inputStream.read(imgBytes, 0, imgBytes.length);
        fileOutput.write(imgBytes, 0, imgBytes.length);
    }

    public static boolean requestImg() {
        while(!checkFile()) {
            System.out.println("[X] Fichier n'existe pas, entrez un nouveau nom et son extension...");
            imgPath = input.nextLine();
        }
        System.out.println("Fichier trouvé...");
        return true;
    }

    public static boolean checkFile() {
        File file = new File((imgPath).trim());
        if(file.exists() && !file.isDirectory()){
            return true;
        }
        return false;
    }

    public static boolean initOptions() throws IOException {
        System.out.println("[*] S'inscrire (première utilisation)     (1)");
        System.out.println("[*] S'authentifier                        (2)");
        int choice = input.nextInt();
        boolean completed = false;

        switch(choice) {
            default:
            case 1:
                toServer.println("register");    //Envoyer l'info qu'on veut register au serveur.
                register();
                completed = true;
                break;
            case 2:
                toServer.println("auth");       //Envoyer l'info qu'on veut s'authentifier au serveur.
                auth();
                completed = true;
                break;
        }

        return completed;
    }

    public static boolean  register() throws IOException{
        String username = "", password = "";
        System.out.println("[*] Bienvenue sur le serveur Sobel!");

        while(username.length() == 0) {
            System.out.println("[*] Entrez un nom d'utilisateur unique: ");
            username = input.nextLine();

            if(username.length() == 0){
                System.out.println("[!] Vous ne pouvez pas utiliser un nom d'utilisateur vide");
            }
        }

        while(password.length() == 0) {
            System.out.println("[*] Entrez un mot de passe secure:");
            password = input.nextLine();

            if(password.length() == 0){
                System.out.println("[!] Vous ne pouvez pas utiliser un mot de passe vide");
            }
        }

        toServer.println(username);
        toServer.println(password);

        System.out.format("[*] Succès! Bienvenu %s\n", username);
        return true;
    }

    public static boolean auth() throws IOException {
        String username = null, password = null;
        int authentified = 0;
        do {
            System.out.println("[*] Entrez votre nom d'utilisateur: ");
            username = input.nextLine();
            System.out.println("[*] Entrez votre mot de passe:");
            password = input.nextLine();

            toServer.println(username);
            toServer.println(password);
            authentified = fromServer.read();
        } while(authentified == 0);

        return false;
    }

    public static boolean showMenu() throws IOException {
        int chosenOption = 0;

        System.out.println("[*] Selectionnez l'option que vous voulez:");
        System.out.println("[*] Appliquer le filtre de Sobel sur une image: (1)");
        System.out.println("[*] Quitter:                                    (2)");

        boolean selecting = true;
        while(selecting) {
            if(input.hasNextInt()) {
                chosenOption = input.nextInt();
                selecting = false;
            }
            else if (input.hasNext()) {
                System.out.println("[!] SVP, n'entrez que le numero de l'option (1 ou 2)...");
            }
        }

        toServer.println(chosenOption);
        return false;
    }
}


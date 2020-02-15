import javafx.util.Pair;
import java.io.File;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Validator {
    private static Pattern regex;
    private static Matcher regexMatcher;
    private static Integer portNum;
    private static String ipAdr;

    public static Integer getPort() { return portNum; }
    public static String getIp() { return ipAdr; }

    public static void setPort(Integer port) { portNum = port; };
    public static void setIp(String ip) { ipAdr = ip; };

    /*
    @Brief: Appel ValidateIP et ValidatePort tant que les deux ne sont pas valide.
    @Params: Void
    @Return: La pair de IP et Port validé.
    */
    public static Pair<String, Integer> validate() {
        String adr = null;
        Integer port = null;

        do{
            adr = validateIP();
        } while(adr == null);

        do {
            port = validatePort();
        } while(port == null);

        return new Pair<String, Integer>(adr, port);
    }

    /*
    @Brief: Valide que l'extension de l'image en paramètre est un JPG ou JPEG.
    @Params: Fichier a validé (File)
    @Return: Boolean pour dire si le fichier un JPG/JPEG ou non.
    */
    public static boolean isJpeg(File file) {
        String name = file.getName();
        if(
            (name.substring(name.lastIndexOf(".")+1).equals("jpg")) ||
            (name.substring(name.lastIndexOf(".")+1).equals("jpeg"))
        )
            return true;
        else {
            System.out.println("[!] Erreur: Le fichier doit être du format JPG/JPEG !");
            return false;
        }
    }

    /*
    @Brief: Valide l'adresse IP entrée par l'utilisateur grâce a Regex Pattern et Matcher.
    @Params: void
    @Return: L'IP validé
    */
    public static String validateIP() {
        //get user input:
        Scanner input = new Scanner(System.in);
        System.out.println("[*] Entrez l'adresse IP du serveur: ");
        String ip = input.nextLine();

        /*
            Utilise regex pour valider le ip:
            d{1,3}: digit 1 a 3 fois. (ex.: 192 = 3 digits)
            \\.   : on accept un '.' comme prochain input
        */
        regex = Pattern.compile("^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$");
        regexMatcher = regex.matcher(ip);
        boolean matched = regexMatcher.find();      //Verifie si le pattern est trouvé dans l'entré
        if(matched){
            System.out.println("[*] IP Valide...");
            return ip;
        }
        else {
            System.out.println("[!] IP Invalide, saisir une nouvelle adresse IP...");
            return null;
        }
    }

    /*
    @Brief: Valide le port entrée par l'utilisateur grâce a Regex Pattern et Matcher.
    Utilise la même logique que pour ValidateIP.
    @Params: void
    @Return: Le port validé
    */
    public static Integer validatePort() {
        //get user input:
        Scanner input = new Scanner(System.in);
        System.out.println("[*] Entrez le Port: (entre 5000 et 5050) ");
        Integer port = Integer.parseInt(input.nextLine());

        regex = Pattern.compile("^(\\d{4})$");
        regexMatcher = regex.matcher(port.toString());

        if(port > 5050 || port < 5000){
            System.out.println("[!] Port Invalide, saisir un nouveau port (entre 5000 et 5050)...");
            return null;
        }
        else if(regexMatcher.find()) {
            System.out.println("[*] Port Valide...");
            return port;
        }
        else {
            System.out.println("[!] Port Invalide, saisir un nouveau port (entre 5000 et 5050)...");
            return null;
        }
    }

    /*
    @Brief: Verifie si le fichier existe ou non.
    @Params: File fichier a verifier.
    @Return: Boolean disant si le fichier existe ou non.
    */
    public static boolean exists(File file){
        if(!file.isDirectory() && file.exists())
            return true;
        else {
            System.out.println("[!] Erreur: Le fichier désiré n'existe pas");
            return false;
        }
    }

    /*
    @Brief: Verifie que l'entrée saisie par l'utilisateur est valide sous quelques conditions.
    @Params: String entrée quelconque.
    @Return: Retourne boolean pour dire si valide ou non.
    */
    public static boolean verifyInput(String input) {
        int min = 4;
        int max = 16;

        if (input.length() >= min && input.length() <= max) {
            return true;
        } else if (input.length() > 0 && input.length() < min) {
            System.out.println("[!] Entrée trop courte");
        } else if (input.length() > max) {
            System.out.println("[!] Entrée de passe trop long");
        }
        return false;
    }

    /*
    @Brief: Permet de faire la correspondance entre le client et le serveur (savoir si les deux on le même IP et port).
    Par contre, nous ne l'avons pas utilisé, car connect() fait la tâche pour nous.
    @Params: String du IP du client et le port saisie par le client aussi.
    @Return: Retourne boolean contenant le resultat de la correspondance.
    */
    public static boolean correspondsToServer(String ip, Integer port){
        if(ipAdr == ip && portNum == port)
            return true;
        else {
            System.out.println("Aucun serveur ne roule sur cet IP et/ou ce port");
            return false;
        }
    }
}

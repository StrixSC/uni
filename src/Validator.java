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

    public static boolean validate() {
        while(!Validator.validateIP());
        while(!Validator.validatePort());
        return true;
    }

    public static boolean isJpeg(File file) {
        String name = file.getName();
        if((name.substring(name.lastIndexOf(".")+1).equals("jpg")))
            return true;
        else {
            System.out.println("[!] Erreur: Le fichier doit être du format JPG/JPEG !");
            return false;
        }
    }

    public static boolean validateIP() {
        //get user input:
        Scanner input = new Scanner(System.in);
        System.out.println("[*] Entrez l'adresse IP du serveur auquel vous voulez vous connectez");
        String ip = input.nextLine();

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
            ipAdr = ip;
            return true;
        }
        else {
            System.out.println("[X] IP Invalide, saisir une nouvelle adresse IP...");
            return false;
        }
    }

    public static boolean validatePort() {
        //get user input:
        Scanner input = new Scanner(System.in);
        System.out.println("[*] Entrez le Port auquel vous voulez vous connectez (entre 5000 et 5050)");
        Integer port = Integer.parseInt(input.nextLine());

        regex = Pattern.compile("^(\\d{4})$");
        regexMatcher = regex.matcher(port.toString());

        if(port > 5050 || port < 5000){
            System.out.println("[X] Port Invalide, saisir un nouveau port (entre 5000 et 5050)...");
            return false;
        }
        else if(regexMatcher.find()) {
            System.out.println("[*] Port Valide...");
            portNum = port;
            return true;
        }
        else {
            System.out.println("[X] Port Invalide, saisir un nouveau port (entre 5000 et 5050)...");
            return false;
        }
    }

    public static boolean exists(String imgPath){
        File tmp = new File(imgPath);
        if(!tmp.isDirectory() && tmp.exists()){
            return true;
        }
        return false;
    }

    public static boolean verify(String input) {
        if(input.length() == 0){
            System.out.println("[!] Vous ne pouvez pas avoir un nom d'utilisateur vide...");
            return false;
        }
        else if(input.length() != 0){
            return true;
        }
        else return false;
    }
}

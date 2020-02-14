import java.io.File;
import java.io.IOException;
import java.util.InputMismatchException;
import java.util.Scanner;

public class UI {

    public static boolean initOptions() throws IOException {
        Scanner input = new Scanner(System.in);

        System.out.println("[*] S'inscrire (première utilisation)     (1)");
        System.out.println("[*] S'authentifier                        (2)");
        int choice = input.nextInt();

        switch(choice) {
            default:
            case 1:
                Client.getToServer().println("register");    //Envoyer l'info qu'on veut register au serveur.
                if(Client.register())
                    return true;
                break;
            case 2:
                Client.getToServer().println("auth");       //Envoyer l'info qu'on veut s'authentifier au serveur.
                if(Client.auth())
                    return true;
                break;
        }
        return false;
    }

    public static boolean showMenu() throws IOException, InterruptedException {
        Integer chosenOption = 0;
        System.out.println("[*] Selectionnez l'option que vous voulez:");
        System.out.println("[*] Appliquer le filtre de Sobel sur une image: (1)");
        System.out.println("[*] Quitter:                                    (2)");

        boolean selecting = true;
        while(selecting) {
            chosenOption = Client.getInput().nextInt();
            if(chosenOption == 1 || chosenOption == 2){
                if(chosenOption == 1)
                    Client.getToServer().println("sobel");
                selecting = false;
            }
            else
                System.out.println("[!] SVP Entrez un nombre (1 ou 2)");
        }

        handleOption(chosenOption);
        return false;
    }

    public static void handleOption(Integer option) throws IOException, InterruptedException {
        switch(option){
            case 1:
                ImageHandler.sendImg();
                ImageHandler.receiveImg();
                break;
            default: Client.exit();
                break;
        }
    }

    public static String getImg() {
        System.out.println("[*] Choisissez la methode de saisie d'image: ");
        System.out.println("[*] Saisie par nom de fichier:              (1) ");
        System.out.println("[*] Saisie par selection fenêtre:           (2) ");

        Integer method = null;
        boolean selecting = true;
        while(selecting) {
            try {
                method = Client.getInput().nextInt();
                if(method == 1 || method == 2)
                    selecting = false;
            } catch (InputMismatchException e) {
                System.out.println("[!] SVP Entrez un nombre (1 ou 2)");
                Client.getInput().next();
            }
        }

        return ((method == 1) ? Request.input() : Request.dialog()).getAbsolutePath();
    }
}

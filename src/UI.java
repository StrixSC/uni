import java.io.IOException;
import java.util.ArrayList;
import java.util.InputMismatchException;

public class UI {

    /*
    @Brief: Permet la saisie de l'option d'authentification de l'utilisateur.
    @Params: Void;
    @Return: Boolean, indiquant si l'authentification est faite.
    */
    public static boolean initOptions() throws IOException {
        System.out.println("[*] S'inscrire (première utilisation)                                               (1)");
        System.out.println("[*] S'authentifier (Crée un compte automatiquement si le compte n'existe pas)       (2)");

        Boolean selecting = true;
        Integer choice = null;
        while(selecting){
            try {
                choice = Client.getInput().nextInt();
                if(choice == 1 || choice == 2)
                    selecting = false;
                else throw new InputMismatchException();
            } catch (InputMismatchException e){
                System.out.println("[!] SVP Entrez un nombre (1 ou 2)");
                Client.getInput().nextLine();
            }
        }

        switch(choice) {
            default:
                break;
            case 1:
                System.out.println("[*] Bienvenue sur le serveur Sobel!");
                Client.getToServer().println("register");    //Envoyer l'info qu'on veut register au serveur.
                String[] userInfo = inputAuthInfo();
                if(Client.register(userInfo[0], userInfo[1]))
                    return true;
                break;
            case 2:
                System.out.println("[*] Rebonjour!");
                Client.getToServer().println("auth");       //Envoyer l'info qu'on veut s'authentifier au serveur.
                userInfo = inputAuthInfo();
                if(Client.auth(userInfo[0], userInfo[1]))
                    return true;
                else {
                    System.out.println("[*] Création automatique du compte en cours...");
                    Client.getToServer().println("register");
                    Client.register(userInfo[0], userInfo[1]);
                    return true;
                }
        }
        return false;
    }

    /*
    @Brief: Permet la saisie de l'option de Sobel ou de Quitter.
    @Params: Void;
    @Return: Boolean, indiquant si l'option est choisie et executée.
    */
    public static boolean showMenu() throws IOException, InterruptedException {
        System.out.println("[*] Selectionnez l'option que vous voulez:");
        System.out.println("[*] Appliquer le filtre de Sobel sur une image: (1)");
        System.out.println("[*] Quitter:                                    (2)");

        Integer chosenOption = 0;
        boolean selecting = true;
        while(selecting) {
            try {
                chosenOption = Client.getInput().nextInt();
                if(chosenOption == 1 || chosenOption == 2){
                    if(chosenOption == 1)
                        Client.getToServer().println("sobel");
                    selecting = false;
                }
                else throw new InputMismatchException();
            } catch (InputMismatchException e){
                System.out.println("[!] SVP Entrez un nombre (1 ou 2)");
                Client.getInput().nextLine();
            }
        }

        handleOption(chosenOption);
        return false;
    }

    /*
    @Brief: Permet l'execution de l'option choisie par showMenu();
    @Params: Option choisie (Integer);
    @Return: void
    */
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

    /*
    @Brief: Permet la saisie de la méthode de selection de l'image.
    @Params: void
    @Return: Retourne le path de l'image choisie.
    */
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
                else throw new InputMismatchException();
            } catch (InputMismatchException e) {
                System.out.println("[!] SVP Entrez un nombre (1 ou 2)");
                Client.getInput().nextLine();
            }
        }

        return ((method == 1) ? Request.input() : Request.dialog()).getAbsolutePath();
    }

    /*
    @Brief: Permet la saisie des informations d'authentification ou d'inscription de l'utilisateur
    @Params: void
    @Return: Retourne un tableau de String contenant le nom d'utilisateur et le mot de passe validés.
    */
    public static String[] inputAuthInfo() throws IOException{
        String username = null, password = null;
        Boolean usernameEntered = false, passwordEntered = false;

        System.out.println("[*] Entrez votre nom d'utilisateur: (4 à 16 caractères)");
        while(!usernameEntered) {
            username = Client.getInput().nextLine().trim();
            if(Validator.verifyInput(username))
                usernameEntered = true;
        }

        System.out.println("[*] Entrez votre mot de passe: (4 à 16 caractères)");
        while(!passwordEntered) {
            password = Client.getInput().nextLine().trim();
            if(Validator.verifyInput(password))
                passwordEntered = true;
        }

        return new String[]{username, password};
    }
}

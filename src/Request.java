import java.awt.*;
import java.io.File;
import java.util.Scanner;

public class Request {

    public static File dialog(){
        FileDialog imageChooser = new FileDialog((Frame)null,"Choisir l'image");
        imageChooser.setVisible(true);
        File imgFile = new File(imageChooser.getFile());
        while(!Validator.isJpeg(imgFile)) {
            imageChooser = new FileDialog((Frame)null,"Choisir l'image");
            imageChooser.setVisible(true);
            imgFile = new File(imageChooser.getFile());
        }

        System.out.println("[*] Fichier trouvé!");
        System.out.println("[*] Veuillez patienté...");

        return imgFile;
    }

    public static File input() {
        Scanner input = new Scanner(System.in);
        System.out.println("[*] Entrez le nom du fichier que vous voulez envoyer au serveur " +
                "(son nom dans le repertoire (doit être un jpg))");
        String imgPath = input.nextLine();
        while(!Validator.exists(imgPath) && !Validator.isJpeg(new File(imgPath))){
            System.out.println("Erreur, fichier invalide. Entrez le nom d'un nouveau fichier!");
            imgPath = input.nextLine();
        }

        return new File(imgPath);
    }
}

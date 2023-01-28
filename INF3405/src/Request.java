import java.awt.*;
import java.io.File;
import java.util.Scanner;

public class Request {

    //IMPORTANT:
    //Le fichier de l'image doit absolument être dans le fichier de l'executable, sinon IMAGE.IO ne pourra pas lire l'image.

    /*
    @Brief: Permet l'ouverture d'un FileDialog tant et aussi longtemps que l'image choisie n'est pas valide.
    @Param: Void;
    @Return un File object contenant le fichier que l'utilisateur a choisie.
    */
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

    /*
    @Brief: Permet l'entrée d'un nom de fichier tant et aussi longtemps que l'image choisie n'est pas valide.
    @Param: Void;
    @Return un File object contenant le fichier que l'utilisateur a choisie.
    */
    public static File input() {
        String imgPath = null;
        System.out.println("[*] Entrez le nom du fichier que vous voulez envoyer au serveur " +
                "(son nom dans le repertoire de cet executable et doit être un JPG/JPEG!)");

        Boolean goodFile = false;
        while (!goodFile) {
            imgPath = Client.getInput().nextLine();
            if (Validator.exists(new File(imgPath)) && Validator.isJpeg(new File(imgPath)))
                    goodFile = true;
        }

        return new File(imgPath);
    }
}

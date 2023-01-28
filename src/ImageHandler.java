import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.nio.ByteBuffer;

public class ImageHandler {

    /*
    @Brief: Envoie une image au serveur à travers le outputStreamBuffer du socket du serveur.
    @Param: Void;
    @Return void;
    */
    public static void sendImg() throws IOException, InterruptedException {
        String imgPath = UI.getImg();
        OutputStream out = Client.getServer().getOutputStream();
        BufferedImage imgNoSobel;
        try {
            imgNoSobel = ImageIO.read(new File(imgPath));
        } catch (IOException e){
            System.out.println("[!] Erreur! Image non lisible...");
            return;
        }

        ByteArrayOutputStream byteOut = new ByteArrayOutputStream();
        ImageIO.write(imgNoSobel,"jpg", byteOut);

        //Plus d'information sur cette partie expliquée dans le ClientHandler.receiveImg() et Clienthandler.sendImg();
        byte size[] = ByteBuffer.allocate(4).putInt(byteOut.size()).array();
        out.write(size);
        out.write(byteOut.toByteArray());
        out.flush();
        System.out.println("[*] Image envoyée au serveur avec succès!");
        Boolean response = false;
        while(!response){
            String serverResponse = Client.getFromServer().readLine();
            if(serverResponse.equals("received")) {
                System.out.println("[*] Image reçue par le serveur! ");
                System.out.println("[*] Patientez pour la \"sobelization\" de l'image!");
                response = true;
            }
        }

    }

    /*
    @Brief: Reçois une image au serveur à travers le inputStreamBuffer du socket du serveur.
    @Param: Void;
    @Return void;
    */
    public static void receiveImg() throws IOException {
        Boolean response = false;
        while(!response){
            String serverResponse = Client.getFromServer().readLine();
            if(serverResponse.equals("incoming")){
                response = true;
            }
        }

        InputStream in = Client.getServer().getInputStream();
        //Plus d'information sur cette partie dans le ClientHandler.receiveImg();
        byte[] bytes = new byte[4];
        in.read(bytes);
        Integer imgSize = ByteBuffer.wrap(bytes).asIntBuffer().get();

        byte[] img = new byte[imgSize];
        in.read(img);
        BufferedImage sobelized = ImageIO.read(new ByteArrayInputStream(img));

        File sobelizedImg = new File("sobelizedImg.jpg");
        ImageIO.write(sobelized, "jpg", sobelizedImg);
        System.out.println("[*] Nouvelle image reçue et enregistrée à " + sobelizedImg.getAbsolutePath());
    }


}

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.Socket;
import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Scanner;

public class ClientHandler extends Thread {
    private Socket client;
    private int clientNumber;
    PrintWriter outToClient;
    BufferedReader inFromClient;
    HashMap<String, String> users;
    File userDB;
    boolean authentified = false;

    public ClientHandler(Socket client, int clientNumber) throws IOException {

        userDB = new File("users.txt");
        if(!userDB.exists()){
            userDB.createNewFile();
        }
        this.users = new HashMap<String, String>();

        Scanner fileReader = new Scanner(userDB);
        while (fileReader.hasNextLine()) {
            String username = fileReader.nextLine();
            String password = fileReader.nextLine();
            users.put(username, password);
        }

        this.client = client;
        this.clientNumber = clientNumber;
        outToClient = new PrintWriter(client.getOutputStream(), true);
        inFromClient = new BufferedReader(new InputStreamReader(client.getInputStream()));
        System.out.format("[*] Nouvelle connection avec client #%d \n", clientNumber);
    }

    public int getClientNumber() { return clientNumber; }

    public void run() {
        try {
            //To send messages to client
            outToClient.println("[*] Serveur prêt, en attente des requêtes du client...\n");
            System.out.println(this.users);
            while(!handleClient());

        } catch (Exception e) {
            System.out.format("[!] Erreur dans la gestion du client #%d\n", clientNumber);
        }
        finally {
            try {
                client.close();
            } catch (IOException e) {
                System.out.println("[!] Erreur dans la fermeture du socket avec le client\n" + e);
            }

            System.out.format("[*] Connexion avec le client #%d fermée\n", clientNumber);
        }
    }

    public boolean handleClient() throws IOException {
        System.out.println("[*] En attente d'entree de l'utilisateur... ");
        String selectedOption = inFromClient.readLine();
        System.out.println(selectedOption);
        String username = null, password = null;

        if(selectedOption.equals("register") && !authentified) {
            System.out.println("[*] Inscription en cours...");
            username = inFromClient.readLine();
            password = inFromClient.readLine();
            if(writeToDisk(username, password)) {
                System.out.println("[*] Ajout d'utilisateur avec succès");
                outToClient.println("false");
                authentified = true;
            }
            else {
                System.out.println("[!] Utilisateur existe deja...");
                outToClient.println("true");
            }
        }
        else if(selectedOption.equals("auth") && !authentified) {
            username = inFromClient.readLine();
            password = inFromClient.readLine();
            if(findUser(username, password)) {
                outToClient.println("true");
                authentified = true;
            }
            else
                outToClient.println("false");
        }
        else if(selectedOption.equals("sobel") && authentified){
            BufferedImage img = getImg();
            outToClient.println("incoming");
            sendImg(img);
        }
        return false;
    }

    public BufferedImage getImg() throws IOException {
        boolean received = false;

        InputStream in = client.getInputStream();

        byte[] bytes = new byte[4];
        in.read(bytes);
        Integer imgSize = ByteBuffer.wrap(bytes).asIntBuffer().get();

        byte[] img = new byte[imgSize];
        in.read(img);

        System.out.format("New image file received from client #%d\n", clientNumber);
        BufferedImage receivedImg = ImageIO.read(new ByteArrayInputStream(img));
        outToClient.println("received");        //Alert le client de la reception de l'image.

        return Sobel.process(receivedImg);
    }

    public void sendImg(BufferedImage img) throws IOException {
        OutputStream out = client.getOutputStream();
        ByteArrayOutputStream byteOut = new ByteArrayOutputStream();
        ImageIO.write(img,"jpg", byteOut);

        byte size[] = ByteBuffer.allocate(4).putInt(byteOut.size()).array();
        out.write(size);
        out.write(byteOut.toByteArray());
        out.flush();
    }

    public boolean findUser(String username, String password) {
        if(users.containsKey(username)) {
            if (users.get(username).equals(password))
                return true;        //Si on trouve le username avec le bon password;
            else
                return false;       //Si on trouve le username sans le bon password;
        } else return false;
    }

    public boolean writeToDisk(String username, String password) throws IOException {
       //Username could already exist with the given password in the DB.
        if(!findUser(username, password)) {
            users.put(username, password);
            FileWriter writer = new FileWriter(userDB, true);
            writer.write(username + "\n");
            writer.write(password + "\n");
            writer.close();
            return true;
        }
        else {
            System.out.println("L'utilisateur existe deja...");
            return false;
        }
    }
}

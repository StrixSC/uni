import javafx.util.Pair;

import java.io.*;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;


public class Server {
    private static ServerSocket server;
    private static int clientCounter = 0;

    public static void main(String[] args) throws IOException {

        server = new ServerSocket();
        //Permet la validation des entrés de ip et de port.
        Pair<String, Integer> ipAndPort = Validator.validate();

        //On set le current IP et port dans le validator
        Validator.setIp(ipAndPort.getKey());
        Validator.setPort(ipAndPort.getValue());

        server.setReuseAddress(true);
        //On set le current port à un Ip adresse.
        InetAddress ip = InetAddress.getByName(ipAndPort.getKey());

        //On vérifie si le IP et le Port connecte a un Hôte valide.
        try {
            server.bind(new InetSocketAddress(ip, ipAndPort.getValue()));
            System.out.format("[*] Le serveur roule sur %s:%d%n", ipAndPort.getKey(), ipAndPort.getValue());
        } catch (Exception e) {
            //Sinon on catch l'exception et on ferme le programe.
            System.out.println("[!] Erreur: Mauvais hôte de l'IP");
        }

        try {
            //On accepte des client tant que le serveur roule correctement.
            while(true){
                new ClientHandler(server.accept(), clientCounter++).start();
            }
        } catch(IOException e){
            System.out.println("[!] Erreur dans la reception du client: " + e);
            System.out.println("[*] Fermeture du programe en cours... ");
        }
        finally {
            server.close();
        }
    }
}

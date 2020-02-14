import javafx.util.Pair;

import java.io.*;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;


public class Server {
    private static ServerSocket server;
    private static String serverIp = "127.0.0.1";
    private static int port = 5000;
    private static int clientCounter = 0;

    public static void main(String[] args) throws IOException {

        server = new ServerSocket();
        Pair<String, Integer> ipAndPort = Validator.validate();

        Validator.setIp(ipAndPort.getKey());
        Validator.setPort(ipAndPort.getValue());

        server.setReuseAddress(true);
        InetAddress ip = InetAddress.getByName(ipAndPort.getKey());

        try {
            server.bind(new InetSocketAddress(ip, ipAndPort.getValue()));
            System.out.format("[*] Le serveur roule sur %s:%d%n", ipAndPort.getKey(), ipAndPort.getValue());
        } catch (Exception e) {
            System.out.println("[!] Erreur: Mauvais hôte de l'IP");
        }

        try {
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

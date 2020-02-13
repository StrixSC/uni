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
        server.setReuseAddress(true);
        InetAddress ip = InetAddress.getByName(serverIp);

        server.bind(new InetSocketAddress(ip, port));

        System.out.format("Le serveur roule sur %s:%d%n", ip, port);

        try {
            while(true){
                new ClientHandler(server.accept(), clientCounter++).start();
            }
        } catch(IOException e){
            System.out.println("Erreur dans la reception du client" + e);
        }
        finally {
            server.close();
        }
    }
}

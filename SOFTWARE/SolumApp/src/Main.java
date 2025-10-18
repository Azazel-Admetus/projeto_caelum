import java.util.*;
import java.nio.file.*;

public class Main {
    public static void main(String[] args) throws Exception {
        String pasta = "data"; // garante que a pasta exista com .json dentro
        List<Model> dados = CarregadorJSON.carregarTodos(pasta);
        if (dados.isEmpty()) {
            System.err.println("Nenhum dado carregado. Verifique a pasta 'dados' e os arquivos JSON.");
            return;
        }
        ChatEngine engine = new ChatEngine(dados);
        System.out.println("SolumChat pronto. Digite perguntas (digite 'sair' para encerrar).");
        Scanner sc = new Scanner(System.in);
        while (true) {
            System.out.print("> ");
            String line = sc.nextLine();
            if (line == null) break;
            line = line.trim();
            if (line.equalsIgnoreCase("sair")) break;
            if (line.isEmpty()) continue;
            String resp = engine.responder(line);
            System.out.println("Solum: " + resp);
        }
        sc.close();
    }
}

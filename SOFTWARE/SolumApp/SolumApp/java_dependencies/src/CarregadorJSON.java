import com.google.gson.*;
import com.google.gson.reflect.TypeToken;
import java.io.IOException;
import java.nio.file.*;
import java.util.*;

public class CarregadorJSON {
    public static List<Model> carregarTodos(String pasta) {
        List<Model> resultados = new ArrayList<>();
        Gson gson = new Gson();

        try {
            Files.list(Paths.get(pasta))
                .filter(p -> p.toString().endsWith(".json"))
                .forEach(path -> {
                    try {
                        String conteudo = Files.readString(path);
                        JsonElement elemento = JsonParser.parseString(conteudo);

                        if (elemento.isJsonArray()) {
                            List<Model> lista = gson.fromJson(elemento, new TypeToken<List<Model>>(){}.getType());
                            if (lista != null) resultados.addAll(lista);
                        } else if (elemento.isJsonObject()) {
                            JsonObject obj = elemento.getAsJsonObject();
                            Model m = new Model();

                            // Perguntas
                            if (obj.has("perguntas")) {
                                List<String> perguntas = gson.fromJson(obj.get("perguntas"),
                                        new TypeToken<List<String>>() {}.getType());
                                m.setPerguntas(perguntas);
                            }

                            // Respostas — suporta "resposta" (única) ou "respostas" (lista)
                            if (obj.has("respostas")) {
                                List<String> respostas = gson.fromJson(obj.get("respostas"),
                                        new TypeToken<List<String>>() {}.getType());
                                m.setRespostas(respostas);
                            } else if (obj.has("resposta")) {
                                m.setRespostas(Collections.singletonList(obj.get("resposta").getAsString()));
                            }

                            // Tags
                            if (obj.has("tags")) {
                                List<String> tags = gson.fromJson(obj.get("tags"),
                                        new TypeToken<List<String>>() {}.getType());
                                m.setTags(tags);
                            }

                            resultados.add(m);
                        }

                    } catch (IOException e) {
                        System.err.println("Erro lendo " + path + ": " + e.getMessage());
                    }
                });
        } catch (IOException e) {
            System.err.println("Erro acessando pasta: " + e.getMessage());
        }

        return resultados;
    }
}

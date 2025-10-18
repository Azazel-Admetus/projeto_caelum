import java.util.*;
import java.util.stream.*;

public class ChatEngine {
    private final List<Model> dataset;
    private final Map<String,Integer> vocab;
    private final List<double[]> perguntaVectors;
    private final List<String> flatQuestions;
    private final List<Model> questionToModel; // vínculo pergunta→objeto Model

    private final Random random = new Random();

    public ChatEngine(List<Model> dataset) {
        this.dataset = dataset;

        this.flatQuestions = new ArrayList<>();
        this.questionToModel = new ArrayList<>();

        for (Model m : dataset) {
            if (m.getPerguntas() != null) {
                for (String p : m.getPerguntas()) {
                    flatQuestions.add(TextProcessor.normalize(p));
                    questionToModel.add(m);
                }
            }
        }

        // construir vocabulário e vetores
        this.vocab = Vectorizer.buildVocab(flatQuestions);
        this.perguntaVectors = flatQuestions.stream()
                .map(q -> Vectorizer.textToVector(q, vocab))
                .collect(Collectors.toList());
    }

    public String responder(String entrada) {
        String norm = TextProcessor.normalize(entrada);
        double[] qVec = Vectorizer.textToVector(norm, vocab);

        double bestScore = -1.0;
        int bestIdx = -1;

        for (int i = 0; i < perguntaVectors.size(); i++) {
            double s = Vectorizer.cosine(qVec, perguntaVectors.get(i));
            if (s > bestScore) {
                bestScore = s;
                bestIdx = i;
            }
        }

        double LIMIAR = 0.35; // sensibilidade um pouco maior
        if (bestScore < LIMIAR || bestIdx < 0) {
            return gerarRespostaDesconhecida();
        }

        Model modelo = questionToModel.get(bestIdx);

        // --- Escolher resposta aleatória ---
        List<String> respostas = modelo.getRespostas();
        String resposta = respostas != null && !respostas.isEmpty()
                ? respostas.get(random.nextInt(respostas.size()))
                : "Hmm... não tenho certeza sobre isso.";

        // --- Personalização com base em tags ---
        String respostaPersonalizada = personalizarResposta(resposta, modelo.getTags(), bestScore);
        return respostaPersonalizada;
    }

    private String gerarRespostaDesconhecida() {
        String[] respostas = {
            "Hmm... ainda não sei responder isso direito.",
            "Boa pergunta! Mas acho que ainda não aprendi sobre isso.",
            "Desculpe, ainda não sei o suficiente sobre esse assunto.",
            "Poxa, não tenho certeza. Quer tentar perguntar de outro jeito?"
        };
        return respostas[random.nextInt(respostas.length)];
    }

    private String personalizarResposta(String resposta, List<String> tags, double score) {
        if (tags == null) tags = Collections.emptyList();

        if (tags.contains("saudacao")) {
            String[] variações = {
                "E aí! " + resposta,
                "Opa! " + resposta,
                "Fala aí! " + resposta
            };
            return variações[random.nextInt(variações.length)] + " (score=" + String.format("%.2f", score) + ")";
        }

        if (tags.contains("despedida")) {
            String[] variações = {
                resposta + " Até logo!",
                resposta + " Falamos depois!",
                resposta + " Tchau por enquanto!"
            };
            return variações[random.nextInt(variações.length)] + " (score=" + String.format("%.2f", score) + ")";
        }

        // Resposta padrão, mas com leve variação de tom
        String[] tons = {
            resposta,
            resposta + " 😄",
            resposta + " hehe",
            "Ah, " + resposta
        };
        return tons[random.nextInt(tons.length)] + " (score=" + String.format("%.2f", score) + ")";
    }
}

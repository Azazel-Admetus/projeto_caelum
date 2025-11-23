import java.util.*;

public class Vectorizer {

    // Cria vocabulário global a partir de todas as perguntas
    public static Map<String, Integer> buildVocab(List<String> corpus) {
        Map<String, Integer> vocab = new HashMap<>();
        int idx = 0;
        for (String text : corpus) {
            if (text == null) continue;
            for (String token : TextProcessor.tokenize(text.toLowerCase())) {
                if (!vocab.containsKey(token)) {
                    vocab.put(token, idx++);
                }
            }
        }
        return vocab;
    }

    // Converte texto em vetor TF normalizado (L2)
    public static double[] textToVector(String text, Map<String, Integer> vocab) {
        if (text == null) return new double[vocab.size()];
        double[] vec = new double[vocab.size()];
        List<String> tokens = TextProcessor.tokenize(text.toLowerCase());

        for (String t : tokens) {
            Integer i = vocab.get(t);
            if (i != null) vec[i] += 1.0;
        }

        // Normalização L2
        double norm = 0.0;
        for (double v : vec) norm += v * v;
        if (norm > 0.0) {
            norm = Math.sqrt(norm);
            for (int i = 0; i < vec.length; i++) vec[i] /= norm;
        }

        return vec;
    }

    // Similaridade cosseno entre dois vetores
    public static double cosine(double[] a, double[] b) {
        if (a.length != b.length) throw new IllegalArgumentException("Dimensões diferentes");

        double dot = 0.0, na = 0.0, nb = 0.0;
        for (int i = 0; i < a.length; i++) {
            dot += a[i] * b[i];
            na += a[i] * a[i];
            nb += b[i] * b[i];
        }

        if (na == 0 || nb == 0) return 0.0;
        return dot / (Math.sqrt(na) * Math.sqrt(nb));
    }
}

import java.text.Normalizer;
import java.util.*;
import java.util.regex.*;

public class TextProcessor {

    // Normaliza: minúsculo, remove acentos e pontuação extra, mantém tags (#, @)
    public static String normalize(String s) {
        if (s == null) return "";
        s = s.toLowerCase(Locale.ROOT);
        s = Normalizer.normalize(s, Normalizer.Form.NFD).replaceAll("\\p{M}", ""); // remove acentos
        // mantém letras, números, espaços, # e @
        s = s.replaceAll("[^a-z0-9#@\\s]", " ");
        s = s.replaceAll("\\s+", " ").trim();
        return s;
    }

    // Tokeniza com opção de normalizar ou não
    public static List<String> tokenize(String s) {
        return tokenize(s, true);
    }

    public static List<String> tokenize(String s, boolean normalizeFirst) {
        if (s == null) return Collections.emptyList();
        if (normalizeFirst) s = normalize(s);
        if (s.isEmpty()) return Collections.emptyList();
        return Arrays.asList(s.split(" "));
    }
}

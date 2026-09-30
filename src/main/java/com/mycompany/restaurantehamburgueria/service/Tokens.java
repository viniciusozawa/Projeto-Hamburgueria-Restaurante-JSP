package com.mycompany.restaurantehamburgueria.service;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Geração e conferência dos tokens de verificação de email.
 *
 * O token em claro existe em um lugar só: dentro do email enviado. No banco
 * guardamos o SHA-256 dele. Assim, quem conseguir ler a tabela não consegue
 * verificar a conta de ninguém.
 *
 * SHA-256 sem salt é o certo aqui (diferente de senha): o token já tem 256
 * bits de aleatoriedade, então não existe ataque de dicionário a fazer, e
 * precisamos procurar pelo hash no índice único.
 */
public final class Tokens {

    /** 32 bytes aleatórios: espaço grande demais para tentar adivinhar. */
    private static final int BYTES = 32;

    /** Validade do link. Depois disso é preciso pedir outro. */
    public static final int HORAS_DE_VALIDADE = 24;

    private static final SecureRandom SORTEIO = new SecureRandom();

    private Tokens() {
    }

    /** Sorteia um token novo, em texto, pronto para ir na URL do email. */
    public static String gerar() {
        byte[] bruto = new byte[BYTES];
        SORTEIO.nextBytes(bruto);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bruto);
    }

    /** O que vai para o banco: hash hexadecimal de 64 caracteres. */
    public static String hashDe(String token) {
        try {
            MessageDigest sha = MessageDigest.getInstance("SHA-256");
            byte[] resumo = sha.digest(token.getBytes(StandardCharsets.UTF_8));

            StringBuilder hex = new StringBuilder(resumo.length * 2);
            for (byte b : resumo) {
                hex.append(Character.forDigit((b >> 4) & 0xF, 16));
                hex.append(Character.forDigit(b & 0xF, 16));
            }
            return hex.toString();
        } catch (NoSuchAlgorithmException e) {
            // SHA-256 é obrigatório em toda JVM; se faltar, algo está muito errado.
            throw new IllegalStateException("SHA-256 indisponível nesta JVM", e);
        }
    }
}

package com.mycompany.restaurantehamburgueria.service;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

/**
 * Lê configuração sem deixar segredo no código.
 *
 * Procura nesta ordem, e para no primeiro que achar:
 *   1. variável de ambiente
 *   2. propriedade de sistema (-D no GlassFish)
 *   3. arquivo .env
 *
 * O .env existe porque é o jeito mais simples de guardar a chave numa máquina
 * de desenvolvimento. Ele está no .gitignore — quem clonar o projeto copia o
 * .env.example e preenche o seu.
 *
 * ONDE O .env É PROCURADO: o GlassFish não roda com o diretório do projeto
 * como diretório de trabalho, então procurar só em "./.env" não funcionaria.
 * A lista de lugares está no método achar(), e o primeiro que existir é usado.
 * Para apontar um caminho exato: -DBIGTITES_ENV=C:/caminho/para/.env
 */
public final class Config {

    private static final Logger LOG = Logger.getLogger(Config.class.getName());

    private static final Map<String, String> DO_ARQUIVO = carregar();

    private Config() {
    }

    /** Valor da configuração, ou null se não estiver em lugar nenhum. */
    public static String get(String chave) {
        String v = System.getenv(chave);
        if (vazio(v)) {
            v = System.getProperty(chave);
        }
        if (vazio(v)) {
            v = DO_ARQUIVO.get(chave);
        }
        return vazio(v) ? null : v.trim();
    }

    /** Valor, ou o padrão se não houver. */
    public static String get(String chave, String padrao) {
        String v = get(chave);
        return v == null ? padrao : v;
    }

    private static boolean vazio(String v) {
        return v == null || v.trim().isEmpty();
    }

    private static Map<String, String> carregar() {
        Map<String, String> mapa = new HashMap<>();

        Path arquivo = achar();
        if (arquivo == null) {
            LOG.info("Nenhum .env encontrado; usando só ambiente e -D.");
            return mapa;
        }

        try {
            List<String> linhas = Files.readAllLines(arquivo, StandardCharsets.UTF_8);
            for (String linha : linhas) {
                String limpa = linha.trim();

                // Linha em branco ou comentário
                if (limpa.isEmpty() || limpa.startsWith("#")) {
                    continue;
                }
                // Aceita "export CHAVE=valor", como num .env de shell
                if (limpa.startsWith("export ")) {
                    limpa = limpa.substring(7).trim();
                }

                int igual = limpa.indexOf('=');
                if (igual <= 0) {
                    continue;
                }

                String chave = limpa.substring(0, igual).trim();
                String valor = limpa.substring(igual + 1).trim();

                // Tira aspas em volta do valor, se houver
                if (valor.length() >= 2
                        && ((valor.startsWith("\"") && valor.endsWith("\""))
                         || (valor.startsWith("'")  && valor.endsWith("'")))) {
                    valor = valor.substring(1, valor.length() - 1);
                }

                if (!chave.isEmpty()) {
                    mapa.put(chave, valor);
                }
            }
            // Nunca registrar os valores: são segredos.
            LOG.info("Configuração lida de " + arquivo + " (" + mapa.size() + " chaves)");

        } catch (IOException e) {
            LOG.warning("Não consegui ler " + arquivo + ": " + e.getMessage());
        }
        return mapa;
    }

    /**
     * Primeiro caminho existente, ou null.
     *
     * A lista é montada aqui, e não num campo estático: campos estáticos são
     * inicializados na ordem do arquivo, e um campo declarado depois de
     * DO_ARQUIVO ainda seria null quando carregar() rodasse.
     */
    private static Path achar() {
        String dominioGlassfish = System.getProperty("com.sun.aas.instanceRoot");
        String pastaDoUsuario   = System.getProperty("user.home");

        String[] caminhos = {
            // 1. caminho explícito, se alguém quiser mandar
            System.getProperty("BIGTITES_ENV"),
            System.getenv("BIGTITES_ENV"),

            // 2. diretório de trabalho do processo
            ".env",

            // 3. config do domínio GlassFish — onde faz sentido guardar o
            //    segredo do servidor, junto do resto da configuração dele
            dominioGlassfish == null ? null : dominioGlassfish + "/config/.env",

            // 4. pasta do usuário, para valer em qualquer projeto da máquina
            pastaDoUsuario == null ? null : pastaDoUsuario + "/.bigtites.env"
        };

        for (String caminho : caminhos) {
            if (caminho == null || caminho.trim().isEmpty()) {
                continue;
            }
            try {
                Path p = Paths.get(caminho);
                if (Files.isRegularFile(p)) {
                    return p;
                }
            } catch (RuntimeException e) {
                // caminho inválido nesta máquina; tenta o próximo
            }
        }
        return null;
    }
}

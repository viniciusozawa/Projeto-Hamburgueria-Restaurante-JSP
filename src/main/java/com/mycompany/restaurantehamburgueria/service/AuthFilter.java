/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.restaurantehamburgueria.service;


import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;

import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import com.mycompany.restaurantehamburgueria.model.entity.Perfil;
import com.mycompany.restaurantehamburgueria.model.entity.Usuario;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
//import com.mycompany.restaurantehamburgueria.model.entity.Perfil;
import com.mycompany.restaurantehamburgueria.model.entity.Usuario;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 *
 * @author tulio
 */

@WebFilter(urlPatterns = {"/*"})
/*Um filtro em Java EE é uma classe Java que pode ser usada para interceptar solicitações a um aplicativo antes que elas cheguem a 
um servlet ou JSP. Isso é útil para verificar se um usuário está logado antes de permitir acesso a páginas restritas.*/
public class AuthFilter implements Filter {

    public AuthFilter() {
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Configuração de inicialização do filtro, se necessário.
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        // Obter o caminho da requisição
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

      
        // Verifica se "user" está na sessão
        // System.out.println("USER: "+httpRequest.getSession().getAttribute("user"));
        if (aberto(path)) {
            chain.doFilter(request, response); // Continuar sem bloquear essas requisições
        } else {
            HttpSession sessao = httpRequest.getSession(false);
            Usuario usuario = sessao == null ? null : (Usuario) sessao.getAttribute("usuario");

            if (usuario == null) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");

            } else if (!podeAcessar(path, usuario.getPerfil())) {
                // Esconder o item do menu não basta: sem esta checagem bastaria
                // digitar a URL do controlador para entrar onde não devia.
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Seu perfil não tem acesso a esta tela.");

            } else {
                chain.doFilter(request, response);
            }
        }
    }

    /**
     * Telas e arquivos que quem não está logado precisa alcançar: a vitrine
     * pública, o login, a criação de conta e os estáticos que dão forma a tudo.
     *
     * Atenção ao que NÃO está aqui: painel.jsp e os controllers de CRUD
     * continuam exigindo sessão.
     */
    private boolean aberto(String path) {
        // raiz do contexto cai na vitrine
        if (path.isEmpty() || path.equals("/")) {
            return true;
        }
        // estáticos: a pasta se chama /styles (a regra antiga procurava /estilo/
        // e por isso o login carregava sem folha de estilo nenhuma). /js guarda
        // o script do login e da criação de conta — bloqueá-lo quebra as duas.
        if (path.startsWith("/styles/") || path.startsWith("/js/")
                || path.startsWith("/img/") || path.startsWith("/public/")) {
            return true;
        }
        return path.equalsIgnoreCase("/index.jsp")
                || path.equalsIgnoreCase("/menu.jsp")
                || path.equalsIgnoreCase("/MenuPublic.jsp")
                || path.equalsIgnoreCase("/login.jsp")
                || path.equalsIgnoreCase("/CadastroUsuario.jsp")
                // quem chega aqui, por definição, ainda não conseguiu entrar
                || path.equalsIgnoreCase("/verificar-email.jsp")
                || path.equalsIgnoreCase("/esqueci-senha.jsp")
                || path.equalsIgnoreCase("/nova-senha.jsp")
                || path.equalsIgnoreCase(WebConstante.BASE_PATH + "/LoginControlador")
                || path.equalsIgnoreCase(WebConstante.BASE_PATH + "/CadastroControlador")
                || path.equalsIgnoreCase(WebConstante.BASE_PATH + "/VerificacaoControlador")
                || path.equalsIgnoreCase(WebConstante.BASE_PATH + "/SenhaControlador");
    }

    /**
     * Quem pode abrir cada controlador.
     *
     * ADMIN abre tudo. Os demais recebem só o que o trabalho exige — e o
     * padrão é negar: um caminho desconhecido não passa por engano.
     */
    private boolean podeAcessar(String path, Perfil perfil) {
        if (perfil == null) {
            return false;
        }
        if (perfil == Perfil.ADMIN) {
            return true;
        }

        // Telas do cliente, abertas a qualquer pessoa logada.
        if (path.equalsIgnoreCase("/completar-cadastro.jsp")
                || path.equalsIgnoreCase(WebConstante.BASE_PATH + "/PerfilControlador")) {
            return true;
        }

        if (!path.startsWith(WebConstante.BASE_PATH + "/")) {
            return perfil.temPainel() || perfil == Perfil.CLIENTE;
        }

        String controlador = path.substring(path.lastIndexOf('/') + 1);

        switch (perfil) {
            case GARCOM:
                return controlador.equals("PedidoController")
                    || controlador.equals("PagamentoController")
                    || controlador.equals("MesaController")
                    || controlador.equals("CardapioController");
            case COZINHA:
                return controlador.equals("PedidoController")
                    || controlador.equals("CardapioController")
                    || controlador.equals("IngredienteController");
            default:
                return false;
        }
    }

    @Override
    public void destroy() {
        // Recursos de limpeza do filtro, se necessário.
    }
}

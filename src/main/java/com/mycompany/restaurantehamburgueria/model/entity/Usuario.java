package com.mycompany.restaurantehamburgueria.model.entity;

import com.mycompany.restaurantehamburgueria.service.Permissoes;

/**
 * Quem está logado.
 *
 * ATENÇÃO: isto NÃO é uma tabela. Não existe `usuario` no banco. Este objeto
 * é montado a partir de uma linha de `cliente` ou de `funcionario` — as duas
 * já guardam nome, email e senha, e `pedido` já aponta para as duas.
 *
 * O campo `codigo` é o codCliente OU o codFuncionario, conforme o `tipo`.
 * É ele que vai para a comanda na hora de abrir um pedido.
 */
public class Usuario {

    public enum Tipo { CLIENTE, FUNCIONARIO }

    private Integer codigo;
    private String nome;
    private String email;
    private String senhaHash;
    private Tipo tipo;

    /** Só para funcionário: define quais módulos do painel aparecem. */
    private Integer codCargo;
    private String nomeCargo;

    /** O que esta pessoa pode fazer. Cliente sempre entra como CLIENTE. */
    private Perfil perfil = Perfil.OUTRO;

    /** Só para cliente: estado da conta. */
    private boolean emailVerificado;
    private boolean cadastroCompleto;

    public Usuario() {
    }

    public static Usuario deCliente(Integer codigo, String nome, String email, String senhaHash) {
        Usuario u = new Usuario();
        u.codigo = codigo;
        u.nome = nome;
        u.email = email;
        u.senhaHash = senhaHash;
        u.tipo = Tipo.CLIENTE;
        u.perfil = Perfil.CLIENTE;
        return u;
    }

    public static Usuario deFuncionario(Integer codigo, String nome, String email, String senhaHash,
                                        Integer codCargo, String nomeCargo, Perfil perfil) {
        Usuario u = new Usuario();
        u.codigo = codigo;
        u.nome = nome;
        u.email = email;
        u.senhaHash = senhaHash;
        u.tipo = Tipo.FUNCIONARIO;
        u.codCargo = codCargo;
        u.nomeCargo = nomeCargo;
        u.perfil = perfil == null ? Perfil.OUTRO : perfil;
        return u;
    }

    /** Usado pelas JSPs para decidir o que mostrar: ${usuario.funcionario}. */
    public boolean isFuncionario() {
        return tipo == Tipo.FUNCIONARIO;
    }

    public boolean isCliente() {
        return tipo == Tipo.CLIENTE;
    }

    /** Primeiro nome, que é como a barra do painel cumprimenta. */
    public String getPrimeiroNome() {
        if (nome == null || nome.trim().isEmpty()) {
            return "";
        }
        String limpo = nome.trim();
        int espaco = limpo.indexOf(' ');
        return espaco > 0 ? limpo.substring(0, espaco) : limpo;
    }

    public Integer getCodigo() { return codigo; }
    public void setCodigo(Integer codigo) { this.codigo = codigo; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getSenhaHash() { return senhaHash; }
    public void setSenhaHash(String senhaHash) { this.senhaHash = senhaHash; }

    public Tipo getTipo() { return tipo; }
    public void setTipo(Tipo tipo) { this.tipo = tipo; }

    public Integer getCodCargo() { return codCargo; }
    public void setCodCargo(Integer codCargo) { this.codCargo = codCargo; }

    public String getNomeCargo() { return nomeCargo; }
    public void setNomeCargo(String nomeCargo) { this.nomeCargo = nomeCargo; }

    public Perfil getPerfil() { return perfil; }
    public void setPerfil(Perfil perfil) { this.perfil = perfil == null ? Perfil.OUTRO : perfil; }

    public boolean isEmailVerificado() { return emailVerificado; }
    public void setEmailVerificado(boolean emailVerificado) { this.emailVerificado = emailVerificado; }

    public boolean isCadastroCompleto() { return cadastroCompleto; }
    public void setCadastroCompleto(boolean cadastroCompleto) { this.cadastroCompleto = cadastroCompleto; }

    /* Atalhos para a EL das JSPs: ${usuario.podeAdministrar} e afins. */
    public boolean isPodeAdministrar()  { return perfil.podeAdministrar(); }
    public boolean isPodeAtenderSalao() { return perfil.podeAtenderSalao(); }
    public boolean isPodeVerPreparo()   { return perfil.podeVerPreparo(); }
    public boolean isTemPainel()        { return perfil.temPainel(); }

    /**
     * Esta pessoa pode executar esta ação? Para esconder na JSP o botão que o
     * AuthFilter barraria: ${usuario.pode('MesaController', 'enviarExcluir')}.
     * A regra mora em Permissoes, a mesma que o filtro consulta.
     */
    public boolean pode(String controlador, String opcao) {
        return Permissoes.permite(perfil, controlador, opcao);
    }

    @Override
    public String toString() {
        return "Usuario{" + tipo + "/" + perfil + " #" + codigo + " " + email + "}";
    }
}

package com.mycompany.restaurantehamburgueria.model.entity;

import java.time.LocalDateTime;

/**
 * Um link de verificação enviado por email.
 *
 * `tokenHash` guarda o SHA-256 do token — o valor em claro nunca chega aqui.
 * `usadoEm` é preenchido em vez de a linha ser apagada, para conseguirmos
 * dizer "este link já foi usado" a quem clicar duas vezes.
 */
public class TokenVerificacao {

    private Integer codToken;
    private Integer codCliente;
    private String tokenHash;
    private LocalDateTime criadoEm;
    private LocalDateTime expiraEm;
    private LocalDateTime usadoEm;

    public TokenVerificacao() {
    }

    public boolean estaUsado() {
        return usadoEm != null;
    }

    public boolean estaExpirado() {
        return expiraEm == null || expiraEm.isBefore(LocalDateTime.now());
    }

    public boolean estaValido() {
        return !estaUsado() && !estaExpirado();
    }

    public Integer getCodToken() { return codToken; }
    public void setCodToken(Integer codToken) { this.codToken = codToken; }

    public Integer getCodCliente() { return codCliente; }
    public void setCodCliente(Integer codCliente) { this.codCliente = codCliente; }

    public String getTokenHash() { return tokenHash; }
    public void setTokenHash(String tokenHash) { this.tokenHash = tokenHash; }

    public LocalDateTime getCriadoEm() { return criadoEm; }
    public void setCriadoEm(LocalDateTime criadoEm) { this.criadoEm = criadoEm; }

    public LocalDateTime getExpiraEm() { return expiraEm; }
    public void setExpiraEm(LocalDateTime expiraEm) { this.expiraEm = expiraEm; }

    public LocalDateTime getUsadoEm() { return usadoEm; }
    public void setUsadoEm(LocalDateTime usadoEm) { this.usadoEm = usadoEm; }
}

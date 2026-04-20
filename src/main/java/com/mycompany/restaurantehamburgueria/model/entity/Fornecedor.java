package com.mycompany.restaurantehamburgueria.model.entity;

public class Fornecedor {

    private Integer codFornecedor;
    private String nomeFornecedor;
    private String cnpj;
    private String endereco;
    private String bairro;
    private String cidade;
    private String estado;

    public Fornecedor() {}

    public Integer getCodFornecedor() { return codFornecedor; }
    public void setCodFornecedor(Integer codFornecedor) { this.codFornecedor = codFornecedor; }

    public String getNomeFornecedor() { return nomeFornecedor; }
    public void setNomeFornecedor(String nomeFornecedor) { this.nomeFornecedor = nomeFornecedor; }

    public String getCnpj() { return cnpj; }
    public void setCnpj(String cnpj) { this.cnpj = cnpj; }

    public String getEndereco() { return endereco; }
    public void setEndereco(String endereco) { this.endereco = endereco; }

    public String getBairro() { return bairro; }
    public void setBairro(String bairro) { this.bairro = bairro; }

    public String getCidade() { return cidade; }
    public void setCidade(String cidade) { this.cidade = cidade; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    @Override
    public String toString() {
        return "Fornecedor{codFornecedor=" + codFornecedor + ", nomeFornecedor=" + nomeFornecedor + "}";
    }
}

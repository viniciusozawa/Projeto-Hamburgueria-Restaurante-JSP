# 🍔 Restaurante Hamburgueria

Sistema web de gerenciamento de cadastros para uma hamburgueria, desenvolvido com **Java 17**, **Jakarta EE 10**, **GlassFish 7** e **MySQL**.

---

## 📋 Módulos de Cadastro

| Módulo | Descrição |
|---|---|
| Cargo | Gerencia os cargos dos funcionários |
| Categoria | Gerencia as categorias do cardápio |
| Cliente | Gerencia os clientes cadastrados |
| Fornecedor | Gerencia os fornecedores de ingredientes |
| Mesa | Gerencia as mesas do restaurante |
| Turnos | Gerencia os turnos de trabalho |

---

## 🛠️ Tecnologias Utilizadas

- **Java 17**
- **Jakarta EE 10**
- **GlassFish 7.0.14**
- **MySQL 8**
- **Maven**
- **JSP + JSTL**
- **Servlet**
- **JDBC (sem JPA)**

---

## 📁 Estrutura do Projeto
```plaintext
restauranteHamburgueria/
├── src/
│   └── main/
│       ├── java/com/mycompany/restaurantehamburgueria/
│       │   ├── model/
│       │   │   ├── entity/         # Entidades (Cargo, Cliente, Mesa...)
│       │   │   └── dao/            # DAOs e ConnectionFactory
│       │   ├── controller/         # Servlets controllers
│       │   ├── service/            # ConfigListener, WebConstante
│       │   └── JakartaRestConfiguration.java
│       ├── webapp/
│       │   ├── styles/             # estilo.css
│       │   ├── WEB-INF/
│       │   │   ├── web.xml
│       │   │   └── beans.xml
│       │   ├── CadastroCargo.jsp
│       │   ├── CadastroCategoria.jsp
│       │   ├── CadastroCliente.jsp
│       │   ├── CadastroFornecedor.jsp
│       │   ├── CadastroMesa.jsp
│       │   ├── CadastroTurnos.jsp
│       │   └── index.html
│       └── resources/
│           └── META-INF/
│               └── persistence.xml
└── pom.xml
```
---

## ⚙️ Configuração

### Pré-requisitos

- JDK 17
- GlassFish 7.0.14
- MySQL 8
- Apache Maven
- NetBeans (recomendado)

### Banco de Dados

1. Crie o banco no MySQL:
```sql
CREATE DATABASE bd_restaurante;
```

2. Importe o arquivo `backup_restaurante.sql` para popular as tabelas.

### Conexão com o Banco

Edite o arquivo `ConnectionFactory.java` com suas credenciais:

```java
private static final String DB_URL = "jdbc:mysql://localhost:3306/bd_restaurante?useSSL=false&serverTimezone=America/Sao_Paulo";
private static final String DB_USER = "root";
private static final String DB_PASSWORD = "sua_senha";
```

---

## ▶️ Como Executar

1. Clone o repositório
2. Abra no **NetBeans**
3. Configure o **GlassFish 7.0.14** em Services → Servers
4. Ajuste as credenciais do MySQL no `ConnectionFactory.java`
5. Clique com botão direito no projeto → **Run**
6. Acesse: `http://localhost:8080/restauranteHamburgueria`

---

## 🗂️ Padrão Utilizado

O projeto segue o padrão **MVC** com Servlets:

- **Model** → Entidades + DAOs com `GenericoDAO<T>`
- **View** → JSPs com JSTL
- **Controller** → Servlets com `@WebServlet`

Cada tela possui as operações: **Cadastrar**, **Alterar**, **Excluir** e **Listar**.

---

## 👥 Autores

Desenvolvido por Vinicius e Otávio, como projeto acadêmico no **Instituto Federal Sul de Minas Gerais — Campus Machado**.



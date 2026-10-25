# Ligar o envio de email

O sistema manda um link de confirmação quando alguém cria conta, e outro
quando alguém pede para redefinir a senha.

**Provedor em uso: Brevo.** Sem chave configurada, o link vai para o
`server.log` em vez da caixa de entrada — o fluxo continua testável.

Por que Brevo: o plano gratuito envia **300 emails por dia para qualquer
destinatário**, sem exigir domínio próprio. Mailgun (sandbox) e Resend sem
domínio só entregam para uma lista fechada de endereços.

---

## 1. Preparar a conta na Brevo

1. Crie a conta em **brevo.com**.
2. **Settings → Senders, Domains, IPs → Senders → Add a sender**: cadastre o
   email que vai aparecer como remetente (pode ser um Gmail) e confirme o
   código de 6 dígitos que chega nele.
3. **SMTP & API → API Keys**: gere uma chave.

> Remetente `@gmail.com` não pode ser autenticado com SPF/DKIM (o domínio é do
> Google), então o email tem mais chance de cair no **spam**. Para o trabalho
> isso não atrapalha: confira a caixa de spam na primeira vez.

## 2. O arquivo `.env`

Copie `.env.example` para `.env` e preencha:

```
BREVO_API_KEY=suachaveaqui
BREVO_REMETENTE=o.email.que.voce.confirmou@gmail.com
BREVO_REMETENTE_NOME=Big Tites
```

O `.env` está no `.gitignore` — **chave de API nunca entra no repositório**.
O `.env.example` é versionado e não tem segredo.

### Onde o `.env` é procurado

O GlassFish não roda com a pasta do projeto como diretório de trabalho, então
o sistema procura em vários lugares, nesta ordem:

| # | Lugar | Quando usar |
|---|---|---|
| 1 | caminho em `-DBIGTITES_ENV=...` | controle explícito |
| 2 | `./.env` | rodando fora do servidor |
| 3 | **`<dominio-glassfish>/config/.env`** | **o certo para o servidor** |
| 4 | `~/.bigtites.env` | vale para a máquina toda |

Para este projeto:

```bash
cp .env "$GLASSFISH/glassfish/domains/domain1/config/.env"
```

Variáveis de ambiente e `-D` têm prioridade sobre o arquivo.

O `.env` é lido **uma vez, quando a aplicação sobe**. Depois de trocar a chave
ou o remetente, reinicie o GlassFish (ou reimplante a aplicação).

### Trocar a conta que envia

Basta outra conta Brevo (ou outro remetente confirmado na mesma conta): troque
`BREVO_API_KEY` e `BREVO_REMETENTE` no `.env` e reinicie. Para **receber**,
ninguém precisa configurar nada — é só se cadastrar no site com o próprio email.

---

## 3. ⚠️ O truststore do GlassFish

**Este passo já foi feito neste projeto**, mas fica registrado porque o sintoma
engana muito.

O domínio GlassFish tem um `cacerts.jks` próprio, separado do JDK. Neste
projeto ele vinha com **2 certificados** (só os do próprio servidor) contra os
144 do JDK — ou seja, **nenhuma CA pública**. Qualquer chamada HTTPS externa
falhava com:

```
PKIX path building failed: unable to find valid certification path
```

Parece erro de rede ou de código. Não é: é o servidor não confiando na CA do
provedor. O conserto é mesclar as CAs do JDK no truststore do domínio:

```bash
keytool -importkeystore \
  -srckeystore  "$JAVA_HOME/lib/security/cacerts" -srcstorepass changeit \
  -destkeystore "$GLASSFISH/glassfish/domains/domain1/config/cacerts.jks" \
  -deststorepass changeit -noprompt
```

Faça backup do `cacerts.jks` antes, e reinicie o domínio depois. Os
certificados próprios do GlassFish (`s1as`, `glassfish-instance`) são
preservados.

O código detecta esse erro e explica o que fazer, em vez de dizer só
"não consegui conectar".

---

## 4. Conferir se pegou

Ao subir o domínio, procure no `server.log`:

```
INFO: Envio de email por Brevo (Big Tites <seuemail@gmail.com>)
```

Envio aceito grava o id da mensagem:

```
INFO: Brevo aceitou o email para fulano@exemplo.com (<id da mensagem>)
```

Se aparecer o aviso abaixo, a chave ou o remetente não chegaram:

```
WARNING: Nenhum provedor configurado (BREVO_API_KEY+BREVO_REMETENTE): ...
```

No painel da Brevo, **Transactional → Logs** mostra cada email e se foi
entregue.

---

## Se der erro

| Resposta | O que houve |
|---|---|
| **401** | Chave errada, ou o IP do servidor está bloqueado (ver abaixo) |
| `unrecognised IP address` | A Brevo bloqueia IPs desconhecidos: libere em **Settings → Security → Authorised IPs** |
| erro citando `sender` | Remetente não cadastrado ou não confirmado (seção 1, passo 2) |
| `PKIX path building failed` | Truststore do GlassFish (seção 3) |

O código traduz esses casos para português, com o que fazer.

---

## Por que não usar o SDK da Brevo

O SDK oficial puxa okhttp e gson junto. O `HttpClient` do **Java 11** faz o
mesmo sem dependência nenhuma no `pom.xml`.

## Trocar de provedor

Escreva uma classe que implemente `service/EnviadorDeEmail.java` e ajuste
`Emails.escolher()`. Nenhum controlador conhece o provedor — eles só chamam
`Emails.enviador()`.

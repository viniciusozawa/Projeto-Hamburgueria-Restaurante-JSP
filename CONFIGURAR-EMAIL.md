# Ligar o envio de email

O sistema manda um link de confirmação quando alguém cria conta.

**Provedor em uso: Mailgun.** Sem chave configurada, o link vai para o
`server.log` em vez da caixa de entrada — o fluxo continua testável.

A escolha é automática, nesta ordem: **Mailgun → Twilio → log**. Basta
preencher as chaves de um deles; nenhum código muda.

---

## 1. O arquivo `.env`

Copie `.env.example` para `.env` e preencha:

```
MAILGUN_API_KEY=suachaveaqui
MAILGUN_DOMINIO=sandboxXXXXXXXX.mailgun.org
MAILGUN_REMETENTE=postmaster@sandboxXXXXXXXX.mailgun.org
MAILGUN_REMETENTE_NOME=Big Tites
```

O `.env` está no `.gitignore` — **chave de API nunca entra no repositório**.
O `.env.example` é versionado e não tem segredo.

A chave sai de **app.mailgun.com → Sending → Domain settings → API keys**.

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

---

## 2. ⚠️ O truststore do GlassFish

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

## 3. Autorizar quem pode receber (sandbox)

O domínio sandbox entrega **apenas para destinatários autorizados — até 5**.
Qualquer outro endereço volta com `not an authorized recipient`.

Cada autorizado recebe um email da Mailgun e **precisa clicar no link de
confirmação**. Antes disso fica como *pendente* e continua sem receber nada —
é o erro mais comum: autorizar e achar que já está valendo.

### Pelo script (mais rápido)

```bash
./autorizar-email.sh                          # lista quem já está autorizado
./autorizar-email.sh fulano@gmail.com         # autoriza um
./autorizar-email.sh a@x.com b@y.com c@z.com  # autoriza vários
```

Ele lê a chave do `.env`, então nada de segredo no histórico do shell. A saída
mostra quem está *ativado* e quem está *PENDENTE*, e quantas vagas restam.

### Pelo painel

**app.mailgun.com → Sending → Overview**, aba *Authorized Recipients*, botão
**Add Recipient**. Mesma coisa, mais cliques.

### Quando 5 não bastar

O limite é do sandbox. Para enviar a qualquer endereço, registre um domínio
próprio em **Sending → Domains → Add New Domain** e configure os registros DNS
(SPF, DKIM). Aí a lista de autorizados deixa de existir.

> **Diferença importante:** o sandbox da Mailgun **aceita conteúdo próprio**.
> O Twilio em modo trial não aceita — só três templates fixos, o que inviabiliza
> um link de verificação. Foi por isso que este projeto ficou na Mailgun.

---

## 4. Conferir se pegou

Ao subir o domínio, procure no `server.log`:

```
INFO: Configuração lida de ...\config\.env (4 chaves)
INFO: Envio de email por Mailgun (Big Tites <postmaster@sandbox....mailgun.org>)
```

Envio aceito grava o id da mensagem:

```
INFO: Mailgun aceitou o email para fulano@exemplo.com (<2026...@sandbox....>)
```

Se aparecer o aviso abaixo, nenhuma chave chegou:

```
WARNING: Nenhum provedor configurado (...): os emails vão para o log
```

Para conferir a entrega de fora, consulte os eventos:

```bash
curl -s "https://api.mailgun.net/v3/$DOMINIO/events?limit=5" --user "api:$CHAVE"
```

Procure `"event": "delivered"`.

---

## Se der erro

| Resposta | O que houve |
|---|---|
| **403** `activate your Mailgun account` | Falta clicar no link de ativação que a Mailgun mandou |
| **400** `not an authorized recipient` | Destinatário fora da lista do sandbox (seção 3) |
| **401** | Chave errada |
| `PKIX path building failed` | Truststore do GlassFish (seção 2) |

Os dois primeiros e o de PKIX o código traduz para português, com o que fazer.

---

## Por que não usar Unirest

O exemplo da Mailgun sugere Unirest. Não usamos: é de 2017, está sem
manutenção e puxa httpclient e jackson junto. O `HttpClient` do **Java 11** faz
o mesmo sem dependência nenhuma no `pom.xml`.

## Trocar de provedor

Escreva uma classe que implemente `service/EnviadorDeEmail.java` e ajuste
`Emails.escolher()`. Nenhum controlador conhece o provedor — eles só chamam
`Emails.enviador()`.

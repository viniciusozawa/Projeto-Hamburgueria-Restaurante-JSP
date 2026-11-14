# Relatórios gerenciais: Big Tites

Atividade: **no mínimo 10 relatórios** que ajudem a tomar decisões, em duas abordagens, com exportação.
O sistema tem **11 relatórios**:

- **Abordagem 1, JasperReports:** relatórios 01 a 06, em PDF e Excel.
- **Abordagem 3, Apache POI:** relatórios 07 a 11, em Excel montado célula por célula.

> Os números deste documento foram conferidos no banco em **13/11/2026**. Com dados novos, os relatórios mudam sozinhos.

---

## 1. Como usar

1. Entre no sistema como **administrador**.
2. Clique em **Relatórios** no menu ou no painel (bloco "Gestão").
3. Escolha o período no topo, com as datas ou com os atalhos *Este mês*, *Mês passado* etc. Ele vale para todos os relatórios marcados com "período".
4. Em cada cartão:
   - **PDF** abre o relatório em outra aba;
   - **Excel** baixa a planilha.
   - Na *Comanda do pedido*, digite antes o número do pedido.

Quem não é administrador não vê o menu e recebe "acesso negado" se tentar abrir o endereço direto. A regra fica em `service/Permissoes.java`.

---

## 2. Como foi feito

### O caminho de um relatório

```
Relatorios.jsp ──(opcao=faturamento&formato=pdf&datas)──> RelatorioController
                                                          │
         ┌────────────── Abordagem 1 (Jasper) ────────────┤
         │  1. compila o .jrxml (só na 1ª vez)            │
         │  2. preenche: roda o SQL do .jrxml no MySQL    │
         │  3. exporta para PDF ou Excel                  │
         │                                                │
         └────────────── Abordagem 3 (POI) ───────────────┘
            1. RelatorioDao busca os dados (SQL em Java)
            2. a classe RelatorioXxxExcel monta a planilha:
               células, estilos, fórmulas, gráfico
            3. devolve o .xlsx
```

### Onde está cada parte

| Arquivo | Papel |
|---|---|
| `relatorio/Relatorio.java` | **Catálogo** dos 11 relatórios: título, pergunta, decisão e abordagem. A tela e o controlador leem daqui |
| `controller/RelatorioController.java` | Recebe o pedido, valida datas e número do pedido, e devolve o arquivo |
| `relatorio/RelatorioJasper.java` | As 3 etapas do Jasper: compilar, preencher e exportar |
| `src/main/resources/relatorios/*.jrxml` | O desenho de cada relatório Jasper, com o SQL dentro |
| `relatorio/PlanilhaExcel.java` | Base comum do POI: cores, formatos de R$ e data, total com `=SOMA()`, fórmulas e gráfico |
| `relatorio/Relatorio*Excel.java` | Uma classe por planilha, como no exemplo do professor |
| `model/dao/RelatorioDao.java` | As consultas das planilhas |
| `Relatorios.jsp`, `js/relatorios.js` | A tela, com período, atalhos e um cartão por relatório |

### Decisões técnicas

- **JasperReports 6.21.5, e não a 7.** A versão 7 exige Java 17, e o projeto usa Java 11, que é o Java dos computadores da escola.
- **Os `.jrxml` foram escritos à mão, no formato da versão 6.** O Jaspersoft Studio 6.21 não está mais disponível sem cadastro, e o Studio 7 salva num formato que a biblioteca 6 não lê. O `.jrxml` é só um XML, então dá para escrever e comentar direto. A biblioteca compila o arquivo na primeira vez que o relatório é aberto e guarda o resultado.
- **A fonte DejaVu vai dentro do PDF.** Assim o acento sai igual em qualquer computador.
- **A planilha POI usa fórmulas de verdade.** Totais, percentuais, médias, "dias em aberto" e a faixa de cliente são fórmulas do Excel, e não valores fixos. Se alguém editar um número, o resto se recalcula.
- **Todos os relatórios usam a mesma regra de dinheiro do painel:**
  - total do pedido = quantidade × preço;
  - pago = soma dos pagamentos do pedido;
  - pedido em aberto = pago menor que o total.

---

## 3. Os 11 relatórios e as decisões que eles permitem

### Abordagem 1: JasperReports

**01 · Faturamento por dia** (PDF com gráfico de barras)
- *Pergunta:* quanto vendemos e recebemos em cada dia?
- *O que mostrou:* R$ 1.368,40 vendidos em 31 pedidos, com ticket médio de R$ 44,14.
  - O melhor dia foi 24/11/2025 (R$ 389,78).
  - Em 23/11/2025 houve 15 pedidos, mas com ticket de só R$ 17,79: muito movimento e pouco valor por pedido.
- *Decisão:* em quais dias reforçar a equipe e o estoque, e quanto ainda falta receber (R$ 494,96).

**02 · Pratos mais vendidos** (PDF com ranking e barras)
- *Pergunta:* quais pratos vendem mais e quais quase não saem?
- *O que mostrou:*
  - O BIGTITES é o campeão em unidades (24).
  - O Smash Duplo vende menos unidades (13), mas é o que **mais fatura** (25,6% da receita).
  - **Cheesebacon e Cheeseburger Clássico nunca venderam.**
- *Decisão:* promover o que dá dinheiro e repensar ou tirar do cardápio os dois pratos parados.

**03 · Vendas por categoria** (PDF com gráfico de pizza)
- *Pergunta:* quanto cada categoria pesa no faturamento?
- *O que mostrou:* as **sobremesas são 54,7% da receita** e os hambúrgueres só 27%, numa hamburgueria. Bebida tem um único item no cardápio.
- *Decisão:* investir em hambúrgueres novos ou rever os preços deles, e ampliar a carta de bebidas.

**04 · Desempenho por funcionário** (PDF com barras)
- *Pergunta:* quantos pedidos e quanto em vendas cada funcionário registrou?
- *O que mostrou:* um único funcionário abriu **77% dos pedidos**, e os pedidos estão sendo lançados por cozinheiros, porque não há garçom cadastrado.
- *Decisão:* distribuir melhor a escala e cadastrar garçons, para o atendimento não depender de uma só pessoa.

**05 · Estoque a vencer** (PDF com etiquetas coloridas e indicadores)
- *Pergunta:* quais ingredientes estão vencidos, vencem logo ou estão acabando?
- *O que mostrou:* **os 13 ingredientes estão vencidos**, o mais antigo desde 30/05/2023, num **prejuízo de R$ 1.934,00**.
- *Decisão:* descartar, comprar menos de cada vez e acompanhar a validade toda semana.

**06 · Comanda do pedido** (PDF em formato de cupom)
- *Pergunta:* o que foi pedido, quanto custou e quanto já foi pago?
- *Exemplo:* o pedido 1 tem total de R$ 145,40, foram pagos R$ 60,00 e faltam R$ 85,40, com o carimbo **EM ABERTO**.
  O mesmo prato lançado várias vezes aparece somado ("7x BIGTITES").
- *Decisão:* entregar o comprovante ao cliente e conferir o caixa antes de dar baixa.

### Abordagem 3: Apache POI (Excel)

**07 · Contas a receber**
- *Pergunta:* quais pedidos ainda não foram pagos por completo?
- *O que mostrou:* 19 pedidos em aberto, **R$ 494,96 a receber**, e o mais antigo está há 424 dias sem pagamento.
- *Decisão:* quem cobrar primeiro (a coluna "Dias em aberto" se atualiza sozinha) e quanto dinheiro ainda vai entrar.

**08 · Recebimentos por forma de pagamento** (com pizza e aba de lançamentos)
- *Pergunta:* como os clientes preferem pagar?
- *O que mostrou:* Dinheiro responde por 76,1% do valor e Pix por 15,5%.
  - Em 8,4% dos pagamentos **a forma não foi registrada**.
  - A forma é gravada de jeitos diferentes ("pix", "Pix"); o relatório junta as variações.
- *Decisão:* planejar o troco do caixa, negociar a maquininha e **obrigar a escolher a forma** no cadastro de pagamento.

**09 · Melhores clientes**
- *Pergunta:* quem compra mais e com que frequência?
- *O que mostrou:* 7 clientes. Dois estão na faixa **Ouro** (R$ 200 ou mais); um deles fez 21 pedidos e o outro tem o maior valor médio por pedido (R$ 130,67).
- *Decisão:* quem recompensar num programa de fidelidade e quais bons clientes sumiram (coluna "Dias sem voltar").

**10 · Folha por cargo e turno** (3 abas, com pizza)
- *Pergunta:* quanto custa a equipe em cada cargo e turno?
- *O que mostrou:*
  - Folha de R$ 7.503,00, com os gerentes somando 73,3%.
  - Todos trabalham no mesmo turno.
  - Há **salários de R$ 1,00 e R$ 2,00**: cadastro de teste ou erro de digitação.
- *Decisão:* corrigir o cadastro, criar turnos diferentes e avaliar contratação para o salão.

**11 · Uso das mesas**
- *Pergunta:* quais mesas recebem mais pedidos e quanto rendem?
- *O que mostrou:*
  - Uma mesa concentra **58,1% dos pedidos**.
  - Uma mesa nunca foi usada.
  - Há duas mesas com o mesmo número em locais diferentes.
- *Decisão:* rearrumar o salão, posicionar o garçom perto das mesas mais usadas e corrigir a numeração.

---

## 4. Validação: os números conferem?

Os totais foram comparados com consultas SQL independentes e entre os próprios relatórios:

| Conferência | Resultado |
|---|---|
| Vendido: Faturamento = Categorias = Clientes = Mesas | R$ 1.368,40 nos quatro |
| Pedidos e itens: Faturamento = Funcionários = Mesas | 31 pedidos e 92 itens |
| Recebido: Faturamento = Formas de pagamento = soma da tabela `pagamento` | R$ 897,98 |
| Falta receber: Faturamento = Contas a receber | R$ 494,96 |
| Estoque: soma de quantidade × preço no banco | R$ 1.934,00 |
| Período sem dados (jan/2030) | Os relatórios mostram um aviso em vez de tabela vazia |
| Pedido inexistente na comanda | Mensagem "O pedido nº X não existe." |

**Erro que a validação encontrou.** O Faturamento dizia que faltavam R$ 470,42, e o Contas a receber dizia R$ 494,96. A diferença (R$ 24,54) veio de dois pedidos pagos **a mais**:
- o pedido 46 foi **pago duas vezes** (R$ 16,50 em 24/11/2025 e de novo em 21/06/2026);
- o pedido 3 recebeu R$ 24,00 por R$ 15,96.

O relatório usava esse dinheiro a mais para abater a dívida de outros clientes. Foi corrigido para calcular pedido por pedido. Esse é o tipo de problema que só aparece quando os dados são organizados num relatório.

---

## 5. Roteiro para a apresentação (cerca de 7 minutos)

1. **(30 s) O problema.** O sistema registra pedidos, pagamentos e estoque, mas dado solto não ajuda a decidir.
2. **(1 min) A tela.** Abrir *Relatórios*:
   - mostrar o período único e os atalhos;
   - mostrar os cartões, cada um com a pergunta e a decisão;
   - apontar as duas abordagens separadas.
3. **(2 min) JasperReports.** Abrir em PDF:
   - **05 Estoque**: o choque dos R$ 1.934,00 vencidos;
   - **02 Pratos**: dois pratos nunca vendidos, e o Smash Duplo fatura mais com menos unidades;
   - **06 Comanda** do pedido 1, em formato de cupom.
   - Mostrar um `.jrxml` rapidamente: o SQL fica dentro do desenho.
4. **(2 min) Apache POI.** Baixar e abrir no Excel:
   - **07 Contas a receber**: clicar numa célula de "Falta" e mostrar que é a fórmula `=H6-I6`;
   - **08 Formas**: a pizza e a aba de lançamentos;
   - **09 Clientes**: a faixa Ouro/Prata/Bronze calculada com `SE()`.
5. **(1 min) Validação.** Os totais batem entre relatórios, e a conferência descobriu o **pagamento em dobro** do pedido 46.
6. **(30 s) Conclusão.** Cada relatório responde a uma pergunta e aponta uma ação: comprar menos, cobrar, mudar o cardápio, corrigir cadastro.

### Perguntas que o professor pode fazer

- **Por que não usou o Jaspersoft Studio?**
  - O Studio 7 grava o formato da biblioteca 7, que exige Java 17, e o 6.21 só é baixado com cadastro.
  - O `.jrxml` é XML e foi escrito no formato 6, com comentários.
  - O Studio 7 consegue abrir o arquivo para visualizar.
- **Qual a diferença entre as duas abordagens?**
  - No **Jasper**, o layout é desenhado num arquivo (`.jrxml`) e a biblioteca preenche os dados. É bom para documento pronto para imprimir: PDF, gráfico, cupom.
  - No **POI**, o Java escreve cada célula. É bom para planilha que a pessoa vai continuar usando, com filtro e fórmulas.
- **Por que o relatório de estoque não tem período?** Ele mostra a situação de hoje. O mesmo vale para a folha.
- **O que acontece com muitos dados?** Os relatórios paginam sozinhos: o cabeçalho das colunas se repete em cada página do PDF, e na planilha o cabeçalho fica fixo e tem filtro.

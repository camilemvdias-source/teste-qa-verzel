# Execução dos testes: VZS-142 (Cupom de desconto e frete grátis, v2.3.0)

- **Ambiente:** Chrome/Edge e PowerShell (Invoke-WebRequest), Windows
- **Loja:** https://verzel-store.qa-test-verzel-store.workers.dev/
- **Data:** execução original em 06/10/2026; complemento exploratório em 07/10/2026; cenários de quantidade absurda em 09/10/2026; cupom só com espaços e execução da automação em 10/10/2026
- **Cenários em Gherkin:** pasta `../cenarios/` (arquivos `.feature`). Cada cenário tem a tag com o seu ID (por exemplo `@CT03`).

## Resumo

| Camada | Executados | Passaram | Falharam |
|---|---|---|---|
| Interface (CT01 a CT15) | 15 | 13 | 2 |
| API (CT16 a CT54) | 39 | 31 | 8 |
| Exploratórios na interface (EXP01 a EXP09) | 9 | 9 | 0 |
| **Total** | **63** | **53** | **10** |

| Bug | Cenários que falharam |
|---|---|
| [BUG-01](../bugs/BUG-01.md): frete cobrado com subtotal de exatamente R$ 200,00 | CT03, CT14, CT47 |
| [BUG-02](../bugs/BUG-02.md): API não valida o limite de quantidade (aceita de 6 até 1e21 unidades e altera valores acima de 2^53) | CT16, CT17, CT52, CT53, CT54 |
| [BUG-03](../bugs/BUG-03.md): cupom só com espaços diverge do cupom vazio e entre endpoints | CT50, CT51 |

## Interface

| ID | Cenário | Regra | Esperado | Obtido | Status | Evidência |
|---|---|---|---|---|---|---|
| CT01 | Exemplo da documentação (1 Calça + 2 Bonés + BEMVINDO10) | CA01, CA06, CA08 | Desconto 23,97, frete grátis, total 215,73 | Igual | Passou | ../evidencias/CT01_exemplo-doc.png |
| CT02 | 1 Mochila + BEMVINDO10 | CA01, CA07, CA09 | Desconto 10,00, frete 19,90, total 109,90, "Faltam R$ 100,00" | Igual | Passou | ../evidencias/CT02_cupom-frete-pago.png |
| CT03 | 2 Mochilas (R$ 200,00 exatos), sem cupom | CA06 | Frete grátis, total 200,00 | Frete 19,90, total 219,90 | **Falhou (BUG-01)** | ../evidencias/BUG01_CT03_frete-limite-200.png |
| CT04 | Calça + Camiseta (R$ 199,80) | CA07 | Frete 19,90, "Faltam R$ 0,20", total 219,70 | Igual | Passou | ../evidencias/CT04_abaixo-limite.png |
| CT05 | Tênis + Meias (R$ 219,80) + BEMVINDO10 | CA08 | Desconto 21,98, frete grátis, total 197,82 | Igual | Passou | ../evidencias/CT05_desconto-nao-afeta-frete.png |
| CT06 | 5 Camisetas no carrinho | CA10 | Aceita 5 e desabilita o "+" | Igual | Passou | ../evidencias/CT06_5-unidades.png |
| CT07 | Tentar adicionar a 6ª Camiseta | CA10 | Botão desabilitado com aviso de limite | Igual | Passou | ../evidencias/CT07_limite-5-unidades.png |
| CT08 | Cupom VERAO2026 | CA04 | "Cupom expirado." sem desconto | Igual | Passou | ../evidencias/CT08_cupom-expirado.png |
| CT09 | Cupom "bem vindo10" (espaço no meio) | CA03, AMB06 | "Cupom inválido." | Igual | Passou | ../evidencias/CT09_espaco-no-meio.png |
| CT10 | Cupom "BEM VINDO10" (espaço no meio) | CA03, AMB06 | "Cupom inválido." | Igual | Passou | ../evidencias/CT10_espaco-no-meio-maiusculo.png |
| CT11 | Cupom BEMVINDO10 em maiúsculo (caso base) | CA01 | 10% de desconto | Igual | Passou | Mesmo cupom e mesma regra do CT02 (e do CT01, CT05): ../evidencias/CT02_cupom-frete-pago.png; com a Calça Jeans Slim, ver CT12 e CT15 |
| CT12 | Cupom "bemvindo10" | CA02 | Aplica 10% | Igual | Passou | ../evidencias/CT12_CA02_variacoes-cupom-bemvindo10_minusculo.mp4 |
| CT13 | Cupom "BemVindo10" | CA02 | Aplica 10% | Igual | Passou | ../evidencias/CT13_CA02_variacoes-cupom-BemVindo10_misto.mp4 |
| CT14 | 2 Mochilas + BEMVINDO10 | CA06, CA08 | Desconto 20,00, frete grátis, total 180,00 | Frete 19,90, total 199,90 | **Falhou (BUG-01)** | ../evidencias/BUG01_CT14_carrinho-limite-com-cupom.png |
| CT15 | Cupom " BEMVINDO10 " (espaço no início e no fim) | CA02 | Aplica 10% | Igual | Passou | ../evidencias/CT15_CA02_variacoes-cupom-BEMVINDO10_com_espaco.mp4 |

## API

| ID | Cenário | Regra | Esperado | Obtido | Status | Evidência |
|---|---|---|---|---|---|---|
| CT16 | Calcular com 6 unidades | CA10 | 422 QUANTIDADE_MAXIMA_EXCEDIDA | 200, calculou com 6 | **Falhou (BUG-02)** | ../evidencias/BUG02_API_quantidade-6.png |
| CT17 | Pedido com 6 unidades | CA10 | 422 QUANTIDADE_MAXIMA_EXCEDIDA | 201, pedido confirmado com 6 | **Falhou (BUG-02)** | ../evidencias/BUG02_API_pedido-quantidade-6.png |
| CT18 | Calcular com 5 unidades | CA10 | 200 | 200, total 299,50 | Passou | ../evidencias/CT17-CT24_API_lote1.png |
| CT19 | Quantidade 0 | API06 | 422 QUANTIDADE_INVALIDA | Igual | Passou | ../evidencias/CT17-CT24_API_lote1.png |
| CT20 | Cupom expirado no cálculo | CA04, API03 | 200, sem desconto, "Cupom expirado." | Igual | Passou | ../evidencias/CT17-CT24_API_lote1.png |
| CT21 | Cupom expirado no pedido | CA04, API05 | 422 CUPOM_EXPIRADO | Igual | Passou | ../evidencias/CT17-CT24_API_lote1.png |
| CT22 | Cupom inexistente no pedido | CA03, API05 | 422 CUPOM_INVALIDO | Igual | Passou | ../evidencias/CT17-CT24_API_lote1.png |
| CT23 | Produto duplicado | API06 | 422 ITEM_DUPLICADO | Igual | Passou | ../evidencias/CT17-CT24_API_lote1.png |
| CT24 | Nome sem sobrenome | PRE01 | 422 DADOS_INVALIDOS | Igual | Passou | ../evidencias/CT17-CT24_API_lote1.png |
| CT25 | Cupom "bemvindo10" | CA02 | Desconto 5,99, total 73,81 | Igual | Passou | ../evidencias/CT25-CT36_API_resultados.png (comandos: ../evidencias/CT25-CT36_API_comandos.png) |
| CT26 | Cupom com espaços nas pontas | CA02 | Igual ao CT25 | Igual | Passou | ../evidencias/CT25-CT36_API_resultados.png (comandos: ../evidencias/CT25-CT36_API_comandos.png) |
| CT27 | 3 Camisetas + cupom (arredondamento) | CA11 | Desconto 17,97, total 181,63 | Igual | Passou | ../evidencias/CT25-CT36_API_resultados.png (comandos: ../evidencias/CT25-CT36_API_comandos.png) |
| CT28 | 3 Bonés + cupom (arredondamento) | CA11 | Desconto 14,97, total 154,63 | Igual | Passou | ../evidencias/CT25-CT36_API_resultados.png (comandos: ../evidencias/CT25-CT36_API_comandos.png) |
| CT29 | Lista de itens vazia | API06 | 422 ITENS_OBRIGATORIOS | Igual | Passou | ../evidencias/CT25-CT36_API_resultados.png (comandos: ../evidencias/CT25-CT36_API_comandos.png) |
| CT30 | JSON inválido | API06 | 400 JSON_INVALIDO | Igual | Passou | ../evidencias/CT25-CT36_API_resultados.png (comandos: ../evidencias/CT25-CT36_API_comandos.png) |
| CT31 | Produto inexistente no cálculo | API06 | 422 PRODUTO_NAO_ENCONTRADO | Igual | Passou | ../evidencias/CT25-CT36_API_resultados.png (comandos: ../evidencias/CT25-CT36_API_comandos.png) |
| CT32 | Quantidade 1,5 | API06 | 422 QUANTIDADE_INVALIDA | Igual | Passou | ../evidencias/CT25-CT36_API_resultados.png (comandos: ../evidencias/CT25-CT36_API_comandos.png) |
| CT33 | CEP "123" no pedido | PRE03 | 422 DADOS_INVALIDOS (cliente.cep) | Igual | Passou | ../evidencias/CT25-CT36_API_resultados.png (comandos: ../evidencias/CT25-CT36_API_comandos.png) |
| CT34 | GET produto inexistente | API02 | 404 PRODUTO_NAO_ENCONTRADO | Igual | Passou | ../evidencias/CT25-CT36_API_resultados.png (comandos: ../evidencias/CT25-CT36_API_comandos.png) |
| CT35 | GET em rota que só aceita POST | API06 | 405 METODO_NAO_PERMITIDO | Igual | Passou | ../evidencias/CT25-CT36_API_resultados.png (comandos: ../evidencias/CT25-CT36_API_comandos.png) |
| CT36 | Rota inexistente | API06 | 404 ROTA_NAO_ENCONTRADA | Igual | Passou | ../evidencias/CT25-CT36_API_resultados.png (comandos: ../evidencias/CT25-CT36_API_comandos.png) |
| CT37 | Listar produtos | API01 | 200, 8 produtos com os preços da doc | Igual | Passou | ../evidencias/CT37-CT47_API_resultados.png |
| CT38 | GET produto P001 | API02 | 200, Camiseta Essencial, 59,90 | Igual | Passou | ../evidencias/CT37-CT47_API_resultados.png |
| CT39 | Quantidade como texto ("2") | API06 | 422 QUANTIDADE_INVALIDA | Igual | Passou | ../evidencias/CT37-CT47_API_resultados.png |
| CT40 | Quantidade negativa | API06 | 422 QUANTIDADE_INVALIDA | Igual | Passou | ../evidencias/CT37-CT47_API_resultados.png |
| CT41 | Item que não é objeto | API06 | 422 ITEM_INVALIDO | Igual | Passou | ../evidencias/CT37-CT47_API_resultados.png |
| CT42 | Cupom vazio | AMB01 | Não definido na doc (assumido: sem cupom) | 200, sem desconto, `cupom: null` | Passou conforme interpretação (ver AMB01) | ../evidencias/CT37-CT47_API_resultados.png |
| CT43 | Pedido válido com cupom, frete pago | API04 | 201, desconto 10, frete 19,90, total 109,90 | Igual, número no formato VZ-000000 | Passou | ../evidencias/CT37-CT47_API_resultados.png |
| CT44 | E-mail inválido no pedido | PRE02 | 422 DADOS_INVALIDOS (cliente.email) | Igual | Passou | ../evidencias/CT37-CT47_API_resultados.png |
| CT45 | Vários dados inválidos de uma vez | PRE01, PRE02, PRE03 | 422 com os 3 campos listados | Igual | Passou | ../evidencias/CT37-CT47_API_resultados.png |
| CT46 | GET em /api/pedidos | API06 | 405 METODO_NAO_PERMITIDO | Igual | Passou | ../evidencias/CT37-CT47_API_resultados.png |
| CT47 | Pedido com 2 Mochilas (R$ 200,00 exatos) | CA06 | 201, frete 0, total 200,00 | 201, frete 19,90, total 219,90 | **Falhou (BUG-01)** | ../evidencias/CT37-CT47_API_resultados.png |
| CT48 | Cálculo com cupom inexistente (XYZ) | CA03, API03 | 200, `aplicado: false`, "Cupom inválido." | Igual | Passou | ../evidencias/CT48-CT49_API_cupom-inexistente-e-misto.png |
| CT49 | Cálculo com cupom "BemVindo10" (maiúsculas e minúsculas misturadas) | CA02 | Desconto 5,99, total 73,81 | Igual | Passou | ../evidencias/CT48-CT49_API_cupom-inexistente-e-misto.png |
| CT50 | Cálculo com cupom só com espaços ("   ") | CA02, AMB01 | Igual ao cupom vazio: `cupom: null`, sem mensagem | 200 com `cupom: {codigo: "", aplicado: false, mensagem: "Cupom inválido."}` | **Falhou (BUG-03)** | ../evidencias/BUG03_API_cupom-vazio-vs-espacos.png |
| CT51 | Pedido com cupom só com espaços ("   ") | CA02, AMB01 | 201, igual ao pedido com cupom vazio | 422 CUPOM_INVALIDO (o pedido com cupom vazio retornou 201) | **Falhou (BUG-03)** | ../evidencias/BUG03_API_cupom-vazio-vs-espacos.png |
| CT52 | Cálculo com 1000000000000000 unidades | CA10 | 422 QUANTIDADE_MAXIMA_EXCEDIDA | 200, subtotal 59900000000000000 | **Falhou (BUG-02)** | ../evidencias/BUG02_API_quantidade-absurda.png |
| CT53 | Cálculo com 1e21 unidades | CA10, CA11 | 422 QUANTIDADE_MAXIMA_EXCEDIDA | 200, subtotal 5.989999999999999e+22 (notação científica) | **Falhou (BUG-02)** | ../evidencias/BUG02_API_quantidade-absurda.png |
| CT54 | Cálculo com 9007199254740993 unidades | CA10 | 422 QUANTIDADE_MAXIMA_EXCEDIDA | 200, quantidade devolvida 9007199254740992 (valor alterado sem aviso) | **Falhou (BUG-02)** | ../evidencias/BUG02_API_quantidade-absurda.png |

## Exploratórios na interface

| ID | Objetivo | Regra | Esperado | Obtido | Status | Evidência |
|---|---|---|---|---|---|---|
| EXP01 | Tentar aplicar um 2º cupom sem remover o 1º | CA05, AMB02 | Não permitir 2 cupons ao mesmo tempo | Com um cupom aplicado, o campo para digitar outro não é exibido; só aparece "Remover cupom". Não há como acumular descontos. | Passou | ../evidencias/CT02_cupom-frete-pago.png |
| EXP02 | Alterar a quantidade depois de aplicar o cupom (1 → 3 → 2 Camisetas) | AMB05, CA01, CA11 | Desconto sempre igual a 10% do subtotal atual, total recalculado | 1 un.: desconto 5,99, total 73,81. 3 un.: desconto 17,97, total 181,63. 2 un.: desconto 11,98, total 127,72. O texto "Faltam..." também acompanhou (140,10, 20,30 e 80,20). | Passou | ../evidencias/EXP02_passo2_cupom-1-unidade.png, ../evidencias/EXP02_passo3_cupom-3-unidades.png, ../evidencias/EXP02_passo4_cupom-2-unidades.png |
| EXP03 | Clicar em "Remover cupom" | CA01 | Desconto some e o total volta ao valor sem desconto | Desconto R$ 0,00, total 139,70 (119,80 + 19,90) e o campo de cupom voltou a aparecer | Passou | ../evidencias/EXP03_cupom-removido.png |
| EXP04 | Recarregar a página (F5) duas vezes com o carrinho montado | Sobre este ambiente | O carrinho fica guardado na aba, então deve continuar igual depois de recarregar | O carrinho continuou como estava depois das duas recargas | Passou | ../evidencias/EXP04_recarregar-pagina.mp4 |
| EXP05 | Formulário de finalizar compra: A) nome sem sobrenome, B) e-mail inválido, C) CEP com 7 dígitos, D) CEP com hífen, E) tudo vazio | PRE01, PRE02, PRE03 | A, B, C e E mostram erro no campo certo; D é aceito e confirma o pedido | A: "Informe nome e sobrenome." B: "Informe um e-mail válido." C: "Informe um CEP com 8 dígitos." E: erro nos 3 campos ("Informe o nome completo.", "Informe o e-mail.", "Informe o CEP."). D: pedido aceito. | Passou | ../evidencias/EXP05A_nome-sem-sobrenome.png, ../evidencias/EXP05B_email-invalido.png, ../evidencias/EXP05C_cep-7-digitos.png, ../evidencias/EXP05D_cep-com-hifen.mp4, ../evidencias/EXP05E_campos-vazios.png |
| EXP06 | Conferir os preços dos 8 produtos com a documentação (pedido com os 8 produtos + BEMVINDO10) | Dados para teste, CA01, CA06 | Preços da doc: 59,90 / 139,90 / 189,90 / 49,90 / 100,00 / 29,90 / 229,90 / 50,00. Subtotal 849,40, desconto 84,94, frete grátis, total 764,46 | Os 8 preços batem com a documentação. Subtotal 849,40, desconto 84,94, frete grátis, total 764,46, número no formato VZ-000000 | Passou | ../evidencias/EXP06_precos-8-produtos-pedido.png |
| EXP07 | Clicar em "Aplicar cupom" com o campo vazio | AMB01 | Não definido na documentação | Mensagem "Informe um cupom.", nenhum desconto aplicado e o carrinho não mudou | Passou conforme interpretação (ver AMB01) | ../evidencias/EXP07_cupom-vazio.png |
| EXP08 | Tentar reduzir a quantidade de 1 para 0 e remover o item | AMB03, CA10 | Quantidade 0 não deve ser aceita; item pode ser removido pelo controle próprio | Botão de diminuir desabilitado com 1 unidade. O botão Remover excluiu o item do carrinho. | Passou (ver AMB03) | ../evidencias/EXP08_quantidade-minima-uma-unidade.png, ../evidencias/EXP08_item-removido.png |
| EXP09 | Digitar apenas espaços no campo de cupom e clicar em "Aplicar cupom" | CA02, AMB01 | Mesmo tratamento do campo vazio | Mensagem "Informe um cupom.", sem desconto | Passou | ../evidencias/EXP09_cupom-so-espacos.png |

Todos os exploratórios planejados foram executados.

## Execução automatizada complementar (Playwright)

- **Navegador:** Chromium do Playwright (projeto `chromium` do `playwright.config.js` do repositório)
- **Como executar:** na pasta `automacao`, seguindo o README: `npm ci`, `npx playwright install chromium` e `npx playwright test`.
- **Evidência:** [`../evidencias/AUTOMACAO_execucao-playwright.png`](../evidencias/AUTOMACAO_execucao-playwright.png)
- **Resumo da última execução:** 10/10/2026: 18 testes executados e 18 passaram, em 10,2 s. Dez são testes funcionais e oito são de caracterização dos bugs BUG-01, BUG-02 e BUG-03.
- Os testes de bugs conhecidos são de **caracterização**: confirmam primeiro as pré-condições e depois o comportamento defeituoso, então passam enquanto o bug existir e falham quando ele for corrigido. Assim uma falha por outro motivo (loja fora do ar, contrato alterado) não é confundida com o bug.
- Esta execução automatizada é complementar e não altera a contagem dos 63 cenários manuais, de API e exploratórios acima.

| ID | Cenário automatizado | Tipo |
|---|---|---|
| API-EXTRA-01 | Exemplo da documentação com cupom válido e frete grátis | Funcional |
| API-EXTRA-02 | Subtotal R$ 0,20 abaixo do mínimo | Funcional |
| CT25/CT26/CT49 | Cupom ignora maiúsculas, minúsculas e espaços nas pontas | Funcional |
| CT48 | Cálculo com cupom inexistente | Funcional |
| CT20 | Cálculo com cupom expirado | Funcional |
| CT21 | Pedido com cupom expirado | Funcional |
| CT47 | Pedido exatamente no mínimo de frete grátis | Bug conhecido (BUG-01) |
| CT16 | Cálculo com 6 unidades do mesmo produto | Bug conhecido (BUG-02) |
| CT52 | Cálculo com 1 quatrilhão de unidades | Bug conhecido (BUG-02) |
| CT53 | Cálculo com 1e21 unidades | Bug conhecido (BUG-02) |
| CT54 | Cálculo com 9007199254740993 unidades | Bug conhecido (BUG-02) |
| CT50 | Cálculo com cupom só com espaços | Bug conhecido (BUG-03) |
| CT51 | Pedido com cupom só com espaços | Bug conhecido (BUG-03) |
| CT02 | Cupom válido em compra abaixo do mínimo (subtotal, desconto, frete e total) | Funcional |
| CT08 | Cupom expirado na interface (subtotal, desconto, frete e total) | Funcional |
| CT03 | Interface com subtotal exatamente R$ 200,00 | Bug conhecido (BUG-01) |
| EXP09 | Cupom só com espaços na interface | Funcional |
| EXP08 | Interface impede quantidade zero e permite remover o item | Funcional |

# Evidências da execução

Índice de todos os prints e vídeos desta pasta, com o que cada um comprova. Os resultados completos de cada cenário estão em [`../execucao/resultados.md`](../execucao/resultados.md).

## Bug 1: frete cobrado com subtotal de exatamente R$ 200,00

| Arquivo | O que mostra | Cenário |
|---|---|---|
| [BUG01_CT03_frete-limite-200.png](BUG01_CT03_frete-limite-200.png) | Pedido com 2 Mochilas (R$ 200,00) e frete de R$ 19,90, total 219,90 | CT03 |
| [BUG01_CT14_carrinho-limite-com-cupom.png](BUG01_CT14_carrinho-limite-com-cupom.png) | Carrinho com cupom: frete de R$ 19,90 e "Faltam R$ 0,00 para o frete grátis" ao mesmo tempo | CT14 |
| [BUG01_API_frete-limite-200.png](BUG01_API_frete-limite-200.png) | API de cálculo devolve `frete: 19.9` e `freteGratis: false` com `valorFaltanteFreteGratis: 0` | BUG-01 (API) |
| [CT37-CT47_API_resultados.png](CT37-CT47_API_resultados.png) | Último resultado: pedido VZ-034638 com 2 Mochilas e frete de R$ 19,90 | CT47 |

## Bug 2: API aceita mais de 5 unidades

| Arquivo | O que mostra | Cenário |
|---|---|---|
| [BUG02_API_quantidade-6.png](BUG02_API_quantidade-6.png) | Cálculo com 6 unidades responde com sucesso | CT16 |
| [BUG02_API_pedido-quantidade-6.png](BUG02_API_pedido-quantidade-6.png) | Pedido com 6 unidades confirmado (status 201, VZ-024054) | CT17 |
| [BUG02_API_quantidade-absurda.png](BUG02_API_quantidade-absurda.png) | Cálculo com 1000000000000000, 1e21 e 9007199254740993 unidades responde 200 (notação científica e quantidade alterada para ...992) | CT52, CT53, CT54 |

## Bug 3: cupom só com espaços

| Arquivo | O que mostra | Cenário |
|---|---|---|
| [BUG03_API_cupom-vazio-vs-espacos.png](BUG03_API_cupom-vazio-vs-espacos.png) | Cupom vazio contra cupom só com espaços, no cálculo e no pedido: respostas diferentes | CT50, CT51 |

## Observações adicionais

| Arquivo | O que mostra | Item |
|---|---|---|
| [OBS_API_i-turco-e-array.png](OBS_API_i-turco-e-array.png) | Letra "ı" aceita como "I" e cupom enviado como lista | OBS01, OBS02 |

## Interface: cupom e frete

| Arquivo | O que mostra | Cenário |
|---|---|---|
| [CT01_exemplo-doc.png](CT01_exemplo-doc.png) | Exemplo da documentação: desconto 23,97, frete grátis, total 215,73 | CT01 |
| [CT02_cupom-frete-pago.png](CT02_cupom-frete-pago.png) | 1 Mochila com cupom: desconto 10,00, frete 19,90, total 109,90 | CT02, CT11, EXP01 |
| [CT04_abaixo-limite.png](CT04_abaixo-limite.png) | Subtotal 199,80: frete 19,90 e "Faltam R$ 0,20" | CT04 |
| [CT05_desconto-nao-afeta-frete.png](CT05_desconto-nao-afeta-frete.png) | Subtotal 219,80 com cupom: frete grátis e total 197,82 | CT05 |
| [CT06_5-unidades.png](CT06_5-unidades.png) | 5 Camisetas no carrinho com o botão "+" desabilitado | CT06 |
| [CT07_limite-5-unidades.png](CT07_limite-5-unidades.png) | Produto com "Limite de 5 unidades atingido." | CT07 |
| [CT08_cupom-expirado.png](CT08_cupom-expirado.png) | "Cupom expirado." sem desconto | CT08 |
| [CT09_espaco-no-meio.png](CT09_espaco-no-meio.png) | "bem vindo10" é inválido | CT09 |
| [CT10_espaco-no-meio-maiusculo.png](CT10_espaco-no-meio-maiusculo.png) | "BEM VINDO10" é inválido | CT10 |
| [CT12_CA02_variacoes-cupom-bemvindo10_minusculo.mp4](CT12_CA02_variacoes-cupom-bemvindo10_minusculo.mp4) | Cupom em minúsculo é aplicado | CT12 |
| [CT13_CA02_variacoes-cupom-BemVindo10_misto.mp4](CT13_CA02_variacoes-cupom-BemVindo10_misto.mp4) | Cupom em maiúsculas e minúsculas misturadas é aplicado | CT13 |
| [CT15_CA02_variacoes-cupom-BEMVINDO10_com_espaco.mp4](CT15_CA02_variacoes-cupom-BEMVINDO10_com_espaco.mp4) | Cupom com espaços no início e no fim é aplicado | CT15 |

## API

| Arquivo | O que mostra | Cenários |
|---|---|---|
| [CT17-CT24_API_lote1.png](CT17-CT24_API_lote1.png) | Respostas do primeiro lote de testes da API | CT17 a CT24 |
| [CT25-CT36_API_comandos.png](CT25-CT36_API_comandos.png) | Comandos enviados no segundo lote | CT25 a CT36 |
| [CT25-CT36_API_resultados.png](CT25-CT36_API_resultados.png) | Respostas do segundo lote (cupom, arredondamento, erros 400, 404, 405 e 422) | CT25 a CT36 |
| [CT37-CT47_API_resultados.png](CT37-CT47_API_resultados.png) | Respostas do terceiro lote (produtos, validações, pedido válido, pedido no limite de R$ 200,00) | CT37 a CT47 |
| [CT48-CT49_API_cupom-inexistente-e-misto.png](CT48-CT49_API_cupom-inexistente-e-misto.png) | Cupom inexistente ("Cupom inválido.") e cupom "BemVindo10" aplicado no cálculo | CT48, CT49 |

## Exploratórios na interface

| Arquivo | O que mostra | Cenário |
|---|---|---|
| [EXP02_passo2_cupom-1-unidade.png](EXP02_passo2_cupom-1-unidade.png) | 1 Camiseta com cupom: desconto 5,99, total 73,81 | EXP02 |
| [EXP02_passo3_cupom-3-unidades.png](EXP02_passo3_cupom-3-unidades.png) | 3 Camisetas com cupom: desconto 17,97, total 181,63 | EXP02 |
| [EXP02_passo4_cupom-2-unidades.png](EXP02_passo4_cupom-2-unidades.png) | 2 Camisetas com cupom: desconto 11,98, total 127,72 | EXP02 |
| [EXP03_cupom-removido.png](EXP03_cupom-removido.png) | Cupom removido: desconto zerado e total 139,70 | EXP03 |
| [EXP04_recarregar-pagina.mp4](EXP04_recarregar-pagina.mp4) | Recarga da página: carrinho e cupom continuam aplicados | EXP04 |
| [EXP05A_nome-sem-sobrenome.png](EXP05A_nome-sem-sobrenome.png) | "Informe nome e sobrenome." | EXP05 |
| [EXP05B_email-invalido.png](EXP05B_email-invalido.png) | "Informe um e-mail válido." | EXP05 |
| [EXP05C_cep-7-digitos.png](EXP05C_cep-7-digitos.png) | "Informe um CEP com 8 dígitos." | EXP05 |
| [EXP05D_cep-com-hifen.mp4](EXP05D_cep-com-hifen.mp4) | CEP com hífen é aceito e o pedido é confirmado | EXP05 |
| [EXP05E_campos-vazios.png](EXP05E_campos-vazios.png) | Erro nos três campos vazios | EXP05 |
| [EXP06_precos-8-produtos-pedido.png](EXP06_precos-8-produtos-pedido.png) | Pedido com os 8 produtos: preços conferem e total 764,46 | EXP06 |
| [EXP07_cupom-vazio.png](EXP07_cupom-vazio.png) | "Informe um cupom." sem alterar o carrinho | EXP07 |
| [EXP08_quantidade-minima-uma-unidade.png](EXP08_quantidade-minima-uma-unidade.png) | Com 1 unidade, o botão de diminuir fica desabilitado | EXP08 |
| [EXP08_item-removido.png](EXP08_item-removido.png) | Botão Remover esvazia o carrinho | EXP08 |
| [EXP09_cupom-so-espacos.png](EXP09_cupom-so-espacos.png) | Só espaços no campo de cupom: "Informe um cupom." | EXP09 |

## Automação

| Arquivo | O que mostra | Origem |
|---|---|---|
| [AUTOMACAO_execucao-playwright.png](AUTOMACAO_execucao-playwright.png) | Execução de `npx playwright test` na pasta `automacao`: 18 testes, 18 passaram (10 funcionais e 8 de caracterização dos bugs BUG-01, BUG-02 e BUG-03) | `automacao/tests/` |

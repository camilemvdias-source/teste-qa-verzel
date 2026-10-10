# Teste técnico QA Júnior: Verzel Store (card VZS-142)

Validação da entrega **Cupom de desconto e frete grátis** (v2.3.0) da Verzel Store: cenários em Gherkin, execução manual e exploratória, testes de API, report de bugs, evidências e automação com Playwright.

- Loja: https://verzel-store.qa-test-verzel-store.workers.dev/
- Documentação da entrega: https://verzel-store.qa-test-verzel-store.workers.dev/documentacao
- API: https://verzel-store.qa-test-verzel-store.workers.dev/api

## Resumo do resultado

| Camada | Cenários | Passaram | Falharam |
|---|---|---|---|
| Interface (CT01 a CT15) | 15 | 13 | 2 |
| API (CT16 a CT54) | 39 | 31 | 8 |
| Exploratórios na interface (EXP01 a EXP09) | 9 | 9 | 0 |
| **Total** | **63** | **53** | **10** |

As 10 falhas correspondem a **3 bugs**:

| Bug | Resumo | Severidade |
|---|---|---|
| [BUG-01](bugs/BUG-01.md) | Frete de R$ 19,90 é cobrado quando o subtotal é exatamente R$ 200,00 (a regra CA06 diz "a partir de R$ 200,00, inclusive"). Acontece na interface e na API. | Alta |
| [BUG-02](bugs/BUG-02.md) | A API não valida o limite de quantidade por produto (regra CA10): aceita 6 unidades e também valores absurdos (1e21, 9007199254740993, este com perda de precisão), tanto no cálculo quanto no pedido. A interface bloqueia corretamente. | Alta |
| [BUG-03](bugs/BUG-03.md) | Cupom com apenas espaços não é tratado como cupom vazio (regra CA02) e os endpoints de cálculo e de pedido respondem de formas diferentes. | Baixa |

## Onde encontrar cada entrega

| Entrega | Onde |
|---|---|
| Regras de negócio extraídas da documentação | [`cenarios/regras.md`](cenarios/regras.md) |
| Cenários de teste em Gherkin | [`cenarios/`](cenarios/) (arquivos `.feature`) |
| Ambiguidades e interpretações adotadas | [`cenarios/ambiguidades.md`](cenarios/ambiguidades.md) |
| Execução dos testes, com o resultado de cada cenário | [`execucao/resultados.md`](execucao/resultados.md) |
| Report dos bugs | [`bugs/`](bugs/) |
| Observações adicionais (comportamentos não classificados como bug) | [`bugs/observacoes-adicionais.md`](bugs/observacoes-adicionais.md) |
| Script para reproduzir os achados na API | [`bugs/reproduzir-api.ps1`](bugs/reproduzir-api.ps1) |
| Documento com as evidências | [`evidencias/evidencias.md`](evidencias/evidencias.md) |
| Prints e vídeos | [`evidencias/`](evidencias/) |
| Automação Playwright | [`automacao/`](automacao/) |

## Como os arquivos se conectam

- Cada cenário Gherkin tem uma tag com o seu ID (por exemplo `@CT03`, `@EXP05`) e as tags das regras que cobre (`@CA06`).
- A tabela de `execucao/resultados.md` usa os mesmos IDs e aponta para a evidência de cada cenário.
- Cada bug lista os cenários que o encontraram e a regra da documentação que ele viola.

## Como rodar a automação

Pré-requisitos: Node.js 20 ou superior e acesso à internet.

```bash
cd automacao
npm ci
npx playwright install chromium
npx playwright test
```

Mais detalhes (rodar só interface ou só API, relatório HTML) em [`automacao/README.md`](automacao/README.md).

Resultado esperado: 18 testes passando. Oito deles são testes de caracterização dos bugs BUG-01, BUG-02 e BUG-03: passam enquanto o bug existir na loja e falham quando ele for corrigido.

## Limitações e escopo

- Fora do escopo, conforme o enunciado: testes de carga, estresse e segurança.
- Comportamentos listados em "Sobre este ambiente" da documentação (carrinho guardado só na aba, pedidos não armazenados, sem e-mail, sem estoque) não foram tratados como bugs.
- Testes realizados em Chrome, no Windows.

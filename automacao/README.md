# Automação Playwright — Verzel Store

Automação dos fluxos de cupom de desconto e frete grátis da Verzel Store, cobrindo a interface e a API. A configuração usa Chromium e a URL base da loja está definida em `playwright.config.js`.

## Pré-requisitos

- Node.js 20 ou superior.
- npm.
- Acesso à internet para abrir a loja de teste.

## Instalação

No terminal, entre nesta pasta (`automacao`) e execute:

```bash
npm ci
npx playwright install chromium
```

O primeiro comando instala as dependências registradas no `package-lock.json`. O segundo instala o navegador usado pela configuração.

## Executar os testes

Ainda dentro da pasta `automacao`:

```bash
# Suíte completa (interface e API)
npm test   # equivale a: npx playwright test

# Somente testes de interface
npx playwright test tests/ui.spec.js

# Somente testes de API
npx playwright test tests/api.spec.js
```

Os testes usam um worker para executar um caso de cada vez no ambiente compartilhado. O relatório de execução é exibido no terminal e o Playwright gera também um relatório HTML em `automacao/playwright-report/`.

## Cenários automatizados

- `tests/ui.spec.js`: cupom válido, cupom expirado, frete no limite de R$ 200,00 (BUG-01), cupom só com espaços (EXP09) e prevenção de quantidade zero (EXP08). Os valores do resumo do pedido são lidos pelos atributos `data-valor` (`subtotal`, `desconto`, `frete` e `total`).
- `tests/api.spec.js`: cálculo de subtotal/desconto/frete, normalização de cupom, cupom expirado e validação do pedido.
- Os testes CT03, CT47 (BUG-01), CT16, CT52, CT53 e CT54 (BUG-02) e CT50 e CT51 (BUG-03) são testes de caracterização: confirmam as pré-condições e depois o comportamento defeituoso, com o comportamento esperado indicado em comentário. Enquanto o bug existir, o teste passa. Quando for corrigido, o teste falha e deve ser atualizado.
- Os testes `API-EXTRA-01` e `API-EXTRA-02` são cenários complementares de API, descritos em `cenarios/api-validacoes.feature` e identificados como extras para não conflitar com os IDs dos testes de interface.

## Onde encontrar as entregas

Partindo da raiz do repositório:

| Entrega | Local |
|---|---|
| Cenários de teste em Gherkin e regras | `cenarios/` |
| Resultados dos testes manuais, de API e exploratórios | `execucao/resultados.md` |
| Relatos dos bugs encontrados | `bugs/` |
| Evidências (imagens e vídeos) | `evidencias/` |
| Configuração e testes Playwright | `automacao/` |
| Este guia de execução | `automacao/README.md` |

## Observação sobre o ambiente

A loja é compartilhada entre candidatos. Os testes estão configurados para rodar sequencialmente; evite aumentar o número de workers. Quando um bug conhecido for corrigido pela equipe da loja, o teste de caracterização correspondente falha: nesse caso, troque a asserção do comportamento defeituoso pela do comportamento esperado, descrita no comentário do próprio teste.

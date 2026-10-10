# Regras de negócio: VZS-142 (Cupom de desconto e frete grátis, v2.3.0)

Fonte: página /documentacao da Verzel Store (publicada em 30/09/2026).

## Critérios de aceite

| ID | Regra |
|---|---|
| CA01 | O cupom BEMVINDO10 aplica 10% de desconto sobre o subtotal dos produtos. |
| CA02 | O código do cupom não diferencia maiúsculas de minúsculas e ignora espaços no início e no fim. |
| CA03 | Cupom inexistente exibe "Cupom inválido." e nenhum desconto é aplicado. |
| CA04 | Cupom fora da validade exibe "Cupom expirado." e nenhum desconto é aplicado. |
| CA05 | Apenas um cupom por vez. Para trocar, remover o atual e aplicar outro. |
| CA06 | Frete grátis para subtotal a partir de R$ 200,00, inclusive. |
| CA07 | Abaixo de R$ 200,00, frete fixo de R$ 19,90 e o carrinho informa quanto falta para o frete grátis. |
| CA08 | O frete grátis considera o subtotal ANTES do desconto do cupom. |
| CA09 | O desconto do cupom não incide sobre o frete. |
| CA10 | Máximo de 5 unidades por produto por pedido (interface e API). |
| CA11 | Todos os valores arredondados para 2 casas decimais. |

## Fórmulas

- total = subtotal - desconto + frete
- subtotal = soma de (preço unitário x quantidade)
- frete = 0,00 se subtotal >= 200,00; senão 19,90
- faltante = 200,00 - subtotal (mínimo 0)

## Regras que já existiam (validação do pedido)

| ID | Regra |
|---|---|
| PRE01 | Nome precisa ter nome e sobrenome. |
| PRE02 | E-mail com formato válido. |
| PRE03 | CEP com 8 dígitos, com ou sem hífen. |
| PRE04 | Pagamento na entrega (não existe pagamento online). |

## API

| ID | Regra |
|---|---|
| API01 | GET /api/produtos lista os produtos (200). |
| API02 | GET /api/produtos/{id}: 200 se existe, 404 se não existe. |
| API03 | POST /api/carrinho/calcular: cupom inválido/expirado retorna 200 sem desconto, com o motivo em cupom.mensagem. |
| API04 | POST /api/pedidos: retorna 201 com número no formato VZ-000000. |
| API05 | POST /api/pedidos: cupom inválido ou expirado retorna 422 (CUPOM_INVALIDO / CUPOM_EXPIRADO). |
| API06 | Erros seguem o formato { erro: { codigo, mensagem, campo } } com os status e códigos da tabela da documentação. |

## Fora do escopo / comportamentos esperados (não são bugs)

Conforme a seção "Sobre este ambiente" da documentação:

- O carrinho fica guardado apenas na aba do navegador.
- Pedidos não são armazenados; o número gerado é fictício e não existe consulta de pedidos.
- Nenhum e-mail é enviado e nenhuma cobrança é feita.
- Produtos, preços e cupons são fixos; não existe controle de estoque.
- A API não guarda nada entre chamadas.
- Fora do escopo: login, cadastro de clientes, pagamento online e consulta de pedidos.

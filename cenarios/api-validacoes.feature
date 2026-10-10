# language: pt
Funcionalidade: Validações da API
  Cobre os códigos de erro e as regras de cupom e frete na API

  Contexto:
    Dado que a API está em "/api"

  @API-EXTRA-01 @api
  Cenário: Exemplo da documentação com cupom válido e frete grátis
    Quando envio POST para "/api/carrinho/calcular" com 1 "P002", 2 "P004" e o cupom "BEMVINDO10"
    Então o status é 200
    E o subtotal é R$ 239,70
    E o desconto é R$ 23,97
    E o frete é grátis
    E o total é R$ 215,73

  @API-EXTRA-02 @api @limite
  Cenário: Subtotal R$ 0,20 abaixo do mínimo paga frete e informa o valor que falta
    Quando envio POST para "/api/carrinho/calcular" com 1 "P002" e 1 "P001"
    Então o status é 200
    E o subtotal é R$ 199,80
    E o frete é R$ 19,90
    E o valor faltante para o frete grátis é R$ 0,20
    E o total é R$ 219,70

  @CT19 @api
  Cenário: Quantidade zero é inválida
    Quando envio POST para "/api/carrinho/calcular" com quantidade 0
    Então o status é 422 e o código é "QUANTIDADE_INVALIDA"

  @CT39 @CT40 @CT32 @api
  Esquema do Cenário: Quantidade que não é inteiro maior ou igual a 1 é inválida
    Quando envio POST para "/api/carrinho/calcular" com quantidade <valor>
    Então o status é 422 e o código é "QUANTIDADE_INVALIDA"

    Exemplos:
      | valor |
      | "2"   |
      | -1    |
      | 1.5   |

  @CT20 @CA04 @API03
  Cenário: Cálculo com cupom expirado não gera erro
    Quando envio POST para "/api/carrinho/calcular" com 1 "P001" e o cupom "VERAO2026"
    Então o status é 200
    E o desconto é 0
    E a mensagem do cupom é "Cupom expirado."

  @CT21 @CA04 @API05
  Cenário: Pedido com cupom expirado é recusado
    Quando envio POST para "/api/pedidos" com cliente válido e o cupom "VERAO2026"
    Então o status é 422 e o código é "CUPOM_EXPIRADO"

  @CT22 @CA03 @API05
  Cenário: Pedido com cupom inexistente é recusado
    Quando envio POST para "/api/pedidos" com cliente válido e o cupom "XXXX"
    Então o status é 422 e o código é "CUPOM_INVALIDO"

  @CT23 @api
  Cenário: Produto repetido na lista de itens
    Quando envio POST para "/api/carrinho/calcular" com "P001" duas vezes
    Então o status é 422 e o código é "ITEM_DUPLICADO"

  @CT24 @PRE01 @api
  Cenário: Nome sem sobrenome no pedido
    Quando envio POST para "/api/pedidos" com o nome "Maria"
    Então o status é 422 e o código é "DADOS_INVALIDOS"
    E o detalhe aponta o campo "cliente.nome"

  @CT25 @CA02 @api
  Esquema do Cenário: Cupom na API ignora maiúsculas
    Quando envio POST para "/api/carrinho/calcular" com 1 "P001" e o cupom "<codigo>"
    Então o desconto é 5,99
    E o total é 73,81
    E o cupom "BEMVINDO10" é aplicado

    Exemplos:
      | codigo         |
      | bemvindo10     |
      | BemVindo10     |

  @CT26 @CA02 @api
  Cenário: Cupom na API ignora espaços no início e no fim
    Quando envio POST para "/api/carrinho/calcular" com 1 "P001" e o cupom "  BEMVINDO10  " (com dois espaços antes e dois depois do código)
    Então o desconto é 5,99
    E o total é 73,81
    E o cupom "BEMVINDO10" é aplicado

  @CT27 @CT28 @CA11 @api
  Esquema do Cenário: Valores arredondados em 2 casas decimais
    Quando envio POST para "/api/carrinho/calcular" com <qtd> "<produto>" e o cupom "BEMVINDO10"
    Então o desconto é <desconto>
    E o total é <total>

    Exemplos:
      | qtd | produto | desconto | total  |
      | 3   | P001    | 17,97    | 181,63 |
      | 3   | P004    | 14,97    | 154,63 |

  @CT29 @CT30 @CT31 @CT41 @api
  Esquema do Cenário: Erros de formato na requisição de cálculo
    Quando envio POST para "/api/carrinho/calcular" com o corpo <corpo>
    Então o status é <status> e o código é "<codigo>"

    Exemplos:
      | corpo                                           | status | codigo                |
      | {"itens":[]}                                    | 422    | ITENS_OBRIGATORIOS    |
      | {"itens":                                       | 400    | JSON_INVALIDO         |
      | {"itens":[{"produtoId":"P999","quantidade":1}]} | 422    | PRODUTO_NAO_ENCONTRADO |
      | {"itens":["P001"]}                              | 422    | ITEM_INVALIDO         |

  @CT33 @CT44 @CT45 @PRE02 @PRE03 @api
  Esquema do Cenário: Dados do cliente inválidos no pedido
    Quando envio POST para "/api/pedidos" com nome "<nome>", e-mail "<email>" e CEP "<cep>"
    Então o status é 422 e o código é "DADOS_INVALIDOS"
    E os campos inválidos listados são "<campos>"

    Exemplos:
      | nome        | email           | cep       | campos                   |
      | Maria Silva | maria@exemplo.com | 123     | cliente.cep              |
      | Maria Silva | maria@          | 01310100  | cliente.email            |
      |             | x               | 1         | cliente.nome, cliente.email, cliente.cep |

  @CT34 @CT35 @CT36 @CT46 @api
  Esquema do Cenário: Rotas e métodos inválidos
    Quando envio <metodo> para "<rota>"
    Então o status é <status> e o código é "<codigo>"

    Exemplos:
      | metodo | rota               | status | codigo                |
      | GET    | /api/produtos/P999 | 404    | PRODUTO_NAO_ENCONTRADO |
      | GET    | /api/carrinho/calcular | 405 | METODO_NAO_PERMITIDO  |
      | GET    | /api/pedidos       | 405    | METODO_NAO_PERMITIDO  |
      | GET    | /api/xyz           | 404    | ROTA_NAO_ENCONTRADA   |

  @CT37 @CT38 @API01 @API02
  Cenário: Listagem e consulta de produtos
    Quando envio GET para "/api/produtos"
    Então o status é 200 e recebo 8 produtos com os preços da documentação
    Quando envio GET para "/api/produtos/P001"
    Então o status é 200 e recebo "Camiseta Essencial" por 59,90

  @CT42 @AMB01 @api
  Cenário: Cupom vazio é tratado como sem cupom
    Quando envio POST para "/api/carrinho/calcular" com 1 "P001" e o cupom ""
    Então o status é 200
    E nenhum desconto é aplicado

  @CT43 @API04 @api
  Cenário: Pedido válido com cupom em compra abaixo do valor do frete grátis
    Quando envio POST para "/api/pedidos" com cliente válido, 1 "P005" e o cupom "BEMVINDO10"
    Então o status é 201
    E o número do pedido segue o formato "VZ-000000"
    E o desconto é 10,00 e o frete é 19,90 e o total é 109,90

  @CT47 @CA06 @limite @api @BUG-01
  Cenário: Pedido com subtotal exatamente igual ao mínimo recebe frete grátis
    Quando envio POST para "/api/pedidos" com cliente válido e 2 "P005"
    Então o status é 201
    E o frete é 0 e freteGratis é verdadeiro
    E o total é 200,00

  @CT48 @CA03 @API03 @api
  Cenário: Cálculo com cupom inexistente responde 200 com mensagem
    Quando envio POST para "/api/carrinho/calcular" com 1 "P001" e o cupom "XYZ"
    Então o status é 200
    E o cupom não é aplicado
    E a mensagem do cupom é "Cupom inválido."

  @CT49 @CA02 @api
  Cenário: Cálculo com cupom em maiúsculas e minúsculas misturadas
    Quando envio POST para "/api/carrinho/calcular" com 1 "P001" e o cupom "BemVindo10"
    Então o status é 200
    E o desconto é 5,99
    E o total é 73,81

  @CT50 @CA02 @AMB01 @api @BUG-03
  Cenário: Cupom só com espaços equivale a nenhum cupom no cálculo
    Quando envio POST para "/api/carrinho/calcular" com 1 "P001" e o cupom "   "
    Então o status é 200
    E o resultado é igual ao do cupom vazio
    E o cupom retornado é nulo

  @CT51 @CA02 @AMB01 @api @BUG-03
  Cenário: Cupom só com espaços equivale a nenhum cupom no pedido
    Quando envio POST para "/api/pedidos" com cliente válido, 1 "P001" e o cupom "   "
    Então o status é 201
    E o pedido é criado sem cupom, igual ao pedido com cupom vazio

  @CT52 @CT53 @CT54 @CA10 @CA11 @api @BUG-02
  Esquema do Cenário: API rejeita quantidade muito acima do limite
    Quando envio POST para "/api/carrinho/calcular" com <quantidade> unidades de "P001"
    Então o status é 422 e o código é "QUANTIDADE_MAXIMA_EXCEDIDA"

    Exemplos:
      | quantidade       |
      | 1000000000000000 |
      | 1e21             |
      | 9007199254740993 |


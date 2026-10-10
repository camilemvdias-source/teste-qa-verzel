# language: pt
Funcionalidade: Testes exploratórios do carrinho
  Sessões de exploração na interface, fora do roteiro dos critérios de aceite

  @EXP01 @CA05 @AMB02
  Cenário: Não é possível aplicar um segundo cupom com um cupom já aplicado
    Dado que tenho 1 "Camiseta Essencial" no carrinho
    E apliquei o cupom "BEMVINDO10"
    Então o campo para digitar outro cupom não é exibido
    E só existe a opção "Remover cupom"

  @EXP02 @AMB05 @CA01 @CA11
  Esquema do Cenário: O desconto acompanha a quantidade depois de aplicar o cupom
    Dado que tenho "Camiseta Essencial" no carrinho com o cupom "BEMVINDO10" aplicado
    Quando altero a quantidade para <quantidade>
    Então o subtotal é <subtotal>
    E o desconto é <desconto>
    E o total é <total>

    Exemplos:
      | quantidade | subtotal | desconto | total  |
      | 1          | 59,90    | 5,99     | 73,81  |
      | 3          | 179,70   | 17,97    | 181,63 |
      | 2          | 119,80   | 11,98    | 127,72 |

  @EXP03 @CA01
  Cenário: Remover o cupom devolve o total sem desconto
    Dado que tenho 2 "Camiseta Essencial" no carrinho com o cupom "BEMVINDO10" aplicado
    Quando clico em "Remover cupom"
    Então o desconto é R$ 0,00
    E o total é R$ 139,70
    E o campo para digitar cupom volta a ser exibido

  @EXP08 @AMB03 @CA10
  Cenário: Interface impede quantidade zero e oferece remoção do item
    Dado que tenho 1 "Camiseta Essencial" no carrinho
    Quando tento diminuir a quantidade
    Então o controle de diminuir está desabilitado
    E a quantidade do item continua em 1
    Quando clico em "Remover Camiseta Essencial do carrinho"
    Então o item é removido do carrinho

  @EXP04
  Cenário: Recarregar a página mantém o carrinho e o cupom
    Dado que tenho itens no carrinho com o cupom "BEMVINDO10" aplicado
    Quando recarrego a página duas vezes
    Então o carrinho continua como estava
    E o cupom continua aplicado

  @EXP05 @PRE01 @PRE02 @PRE03
  Esquema do Cenário: Validação dos dados do cliente no formulário de finalizar compra
    Dado que tenho itens no carrinho e abri "Finalizar compra"
    Quando preencho nome "<nome>", e-mail "<email>" e CEP "<cep>"
    Então o resultado é "<resultado>"

    Exemplos:
      | nome        | email             | cep       | resultado                                 |
      | Maria       | maria@exemplo.com | 01310100  | Informe nome e sobrenome.                 |
      | Maria Silva | maria@            | 01310100  | Informe um e-mail válido.                 |
      | Maria Silva | maria@exemplo.com | 0131010   | Informe um CEP com 8 dígitos.             |
      | Maria Silva | maria@exemplo.com | 01310-100 | pedido confirmado                         |
      |             |                   |           | erro nos três campos (nome, e-mail e CEP) |

  @EXP06 @CA01 @CA06
  Cenário: Os preços dos 8 produtos conferem com a documentação
    Dado que adiciono ao carrinho 1 unidade de cada um dos 8 produtos
    Quando aplico o cupom "BEMVINDO10" e finalizo o pedido
    Então os preços unitários são 59,90, 139,90, 189,90, 49,90, 100,00, 29,90, 229,90 e 50,00
    E o subtotal é R$ 849,40
    E o desconto é R$ 84,94
    E o frete é grátis
    E o total é R$ 764,46

  @EXP07 @AMB01
  Cenário: Aplicar cupom com o campo vazio
    Dado que tenho itens no carrinho
    Quando clico em "Aplicar cupom" sem digitar nada
    Então vejo a mensagem "Informe um cupom."
    E nenhum desconto é aplicado

  @EXP09 @CA02 @AMB01
  Cenário: Cupom só com espaços na interface é tratado como campo vazio
    Dado que tenho itens no carrinho
    Quando digito apenas espaços no campo de cupom e clico em "Aplicar cupom"
    Então vejo a mensagem "Informe um cupom."
    E nenhum desconto é aplicado


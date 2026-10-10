# language: pt
Funcionalidade: Cupom de desconto
  Como cliente da Verzel Store
  Quero aplicar um cupom de desconto no carrinho
  Para pagar menos nas minhas compras

  @CT01 @CA01 @CA06 @CA08
  Cenário: Exemplo da documentação com cupom válido e frete grátis
    Dado que tenho no carrinho 1 "Calça Jeans Slim" e 2 "Boné Aba Curva"
    Quando aplico o cupom "BEMVINDO10"
    Então o subtotal é R$ 239,70
    E o desconto é R$ 23,97
    E o frete é grátis
    E o total é R$ 215,73

  @CT02 @CA01 @CA07 @CA09
  Cenário: Cupom válido em compra abaixo do valor do frete grátis
    Dado que tenho no carrinho 1 "Mochila Urbana 20L"
    Quando aplico o cupom "BEMVINDO10"
    Então o desconto é R$ 10,00
    E o frete é R$ 19,90
    E o desconto não incide sobre o frete
    E o total é R$ 109,90
    E o carrinho informa "Faltam R$ 100,00 para o frete grátis."

  @CT08 @CA04
  Cenário: Cupom expirado
    Dado que tenho no carrinho 1 "Calça Jeans Slim"
    Quando aplico o cupom "VERAO2026"
    Então vejo a mensagem "Cupom expirado."
    E nenhum desconto é aplicado

  @CT09 @CT10 @CA03
  Esquema do Cenário: Código com espaço no meio é tratado como cupom inexistente
    Dado que tenho no carrinho 1 "Tênis Casual Urbano"
    Quando aplico o cupom "<codigo>"
    Então vejo a mensagem "Cupom inválido."
    E nenhum desconto é aplicado

    Exemplos:
      | codigo       |
      | bem vindo10  |
      | BEM VINDO10  |

  @CT11 @CT12 @CT13 @CA02
  Esquema do Cenário: O código do cupom ignora maiúsculas, minúsculas e espaços nas pontas
    Dado que tenho no carrinho 1 "Calça Jeans Slim"
    Quando aplico o cupom "<codigo>"
    Então o cupom "BEMVINDO10" é aplicado
    E o desconto é R$ 13,99
    E o total é R$ 145,81

    Exemplos:
      | codigo         |
      | BEMVINDO10     |
      | bemvindo10     |
      | BemVindo10     |

  @CT15 @CA02
  Cenário: O código do cupom ignora espaços no início e no fim
    Dado que tenho no carrinho 1 "Calça Jeans Slim"
    Quando aplico o cupom " BEMVINDO10 " (com um espaço antes e outro depois do código)
    Então o cupom "BEMVINDO10" é aplicado
    E o desconto é R$ 13,99
    E o total é R$ 145,81

# language: pt
Funcionalidade: Frete grátis
  Como cliente da Verzel Store
  Quero ganhar frete grátis em compras maiores
  Para pagar menos nas minhas compras

  @CT03 @CA06 @limite @BUG-01
  Cenário: Subtotal exatamente igual ao valor mínimo recebe frete grátis
    Dado que tenho no carrinho 2 "Mochila Urbana 20L"
    Quando abro o resumo do pedido
    Então o subtotal é R$ 200,00
    E o frete é grátis
    E o total é R$ 200,00

  @CT04 @CA07 @limite
  Cenário: Subtotal R$ 0,20 abaixo do mínimo paga frete e vê quanto falta
    Dado que tenho no carrinho 1 "Calça Jeans Slim" e 1 "Camiseta Essencial"
    Quando abro o resumo do pedido
    Então o subtotal é R$ 199,80
    E o frete é R$ 19,90
    E o carrinho informa "Faltam R$ 0,20 para o frete grátis."
    E o total é R$ 219,70

  @CT05 @CA08
  Cenário: O frete grátis considera o subtotal antes do desconto
    Dado que tenho no carrinho 1 "Tênis Casual Urbano" e 1 "Kit 3 Pares de Meias"
    Quando aplico o cupom "BEMVINDO10"
    Então o subtotal é R$ 219,80
    E o desconto é R$ 21,98
    E o frete é grátis
    E o total é R$ 197,82

  @CT14 @CA06 @CA08 @limite @BUG-01
  Cenário: Subtotal exatamente igual ao mínimo com cupom mantém o frete grátis
    Dado que tenho no carrinho 2 "Mochila Urbana 20L"
    Quando aplico o cupom "BEMVINDO10"
    Então o desconto é R$ 20,00
    E o frete é grátis
    E o total é R$ 180,00

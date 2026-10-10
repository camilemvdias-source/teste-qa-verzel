# language: pt
Funcionalidade: Limite de 5 unidades por produto
  O limite vale para a interface e para a API (CA10)

  @CT06 @CA10 @limite
  Cenário: Interface aceita exatamente 5 unidades
    Dado que adiciono 5 "Camiseta Essencial" ao carrinho
    Então o carrinho mostra 5 unidades
    E o botão "+" fica desabilitado com o aviso "Limite de 5 unidades por produto."

  @CT07 @CA10
  Cenário: Interface não permite adicionar a 6ª unidade
    Dado que já tenho 5 "Camiseta Essencial" no carrinho
    Quando vou à lista de produtos
    Então o botão "Adicionar ao carrinho" fica desabilitado
    E vejo a mensagem "Limite de 5 unidades atingido."

  @CT16 @CA10 @api @BUG-02
  Cenário: API de cálculo rejeita mais de 5 unidades
    Quando envio POST para "/api/carrinho/calcular" com 6 unidades de "P001"
    Então o status é 422
    E o código do erro é "QUANTIDADE_MAXIMA_EXCEDIDA"

  @CT17 @CA10 @api @BUG-02
  Cenário: API de pedidos rejeita mais de 5 unidades
    Quando envio POST para "/api/pedidos" com cliente válido e 6 unidades de "P001"
    Então o status é 422
    E o código do erro é "QUANTIDADE_MAXIMA_EXCEDIDA"

  @CT18 @CA10 @api @limite
  Cenário: API aceita exatamente 5 unidades
    Quando envio POST para "/api/carrinho/calcular" com 5 unidades de "P001"
    Então o status é 200
    E o total é 299,50

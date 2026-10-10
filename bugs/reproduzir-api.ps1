# Reproducao dos achados na API da Verzel Store (card VZS-142)
#
# Uso (na pasta do projeto):
#   powershell -ExecutionPolicy Bypass -File .\bugs\reproduzir-api.ps1 -Grupo A
#
# Grupos:
#   A = quantidades acima do limite (BUG-02): A0 e A0b = 6 unidades; A1 a A3 = quantidades absurdas
#   B = cupom vazio contra cupom so com espacos (BUG-03)
#   C = cupom inexistente e cupom em maiusculas/minusculas misturadas (CT48 e CT49)
#   D = observacoes adicionais (OBS01 e OBS02)
#
# Cada requisicao e impressa antes da resposta, entao um print da tela ja mostra o que foi enviado.
# Os pedidos criados sao de teste: a loja nao armazena pedidos.

param([ValidateSet('A','B','C','D')][string]$Grupo = 'A')

$base = 'https://verzel-store.qa-test-verzel-store.workers.dev'
$cli  = '"cliente":{"nome":"Maria Silva","email":"maria@exemplo.com","cep":"01310100"}'
$item = '"itens":[{"produtoId":"P001","quantidade":1}]'

function T($path, $json) {
  "POST /api/$path  $json"
  try {
    $r = Invoke-WebRequest -Method Post -Uri "$base/api/$path" -ContentType 'application/json' -Body $json -UseBasicParsing
    "STATUS: $($r.StatusCode)"; $r.Content
  } catch {
    "STATUS: $([int]$_.Exception.Response.StatusCode)"; $_.ErrorDetails.Message
  }
  ''
}

function G($caminho) {
  "GET $caminho"
  try {
    $r = Invoke-WebRequest -Method Get -Uri "$base$caminho" -UseBasicParsing
    "STATUS: $($r.StatusCode)"
    $c = $r.Content; if ($c.Length -gt 120) { $c = $c.Substring(0,120) + ' ...' }; $c
  } catch {
    "STATUS: $([int]$_.Exception.Response.StatusCode)"; $_.ErrorDetails.Message
  }
  ''
}

switch ($Grupo) {
  'A' {
    '## A0 calcular com 6 unidades (esperado: 422 QUANTIDADE_MAXIMA_EXCEDIDA)'
    T 'carrinho/calcular' '{"itens":[{"produtoId":"P001","quantidade":6}]}'
    '## A0b pedido com 6 unidades (esperado: 422 QUANTIDADE_MAXIMA_EXCEDIDA)'
    T 'pedidos' ('{' + $cli + ',"itens":[{"produtoId":"P001","quantidade":6}]}')
    '## A1 quantidade 1000000000000000 (esperado: 422 QUANTIDADE_MAXIMA_EXCEDIDA)'
    T 'carrinho/calcular' '{"itens":[{"produtoId":"P001","quantidade":1000000000000000}]}'
    '## A2 quantidade 1e21 (esperado: 422 QUANTIDADE_MAXIMA_EXCEDIDA)'
    T 'carrinho/calcular' '{"itens":[{"produtoId":"P001","quantidade":1e21}]}'
    '## A3 quantidade 9007199254740993 (opcional: perda de precisao acima de 2^53)'
    T 'carrinho/calcular' '{"itens":[{"produtoId":"P001","quantidade":9007199254740993}]}'
  }
  'B' {
    '## B1 cupom vazio, calcular'
    T 'carrinho/calcular' ('{' + $item + ',"cupom":""}')
    '## B2 cupom so com 3 espacos, calcular (esperado: igual ao B1)'
    T 'carrinho/calcular' ('{' + $item + ',"cupom":"   "}')
    '## B3 cupom vazio, pedido'
    T 'pedidos' ('{' + $cli + ',' + $item + ',"cupom":""}')
    '## B4 cupom so com 3 espacos, pedido (esperado: igual ao B3)'
    T 'pedidos' ('{' + $cli + ',' + $item + ',"cupom":"   "}')
  }
  'C' {
    '## C1 cupom inexistente XYZ, calcular (esperado: 200, aplicado false, Cupom invalido.)'
    T 'carrinho/calcular' ('{' + $item + ',"cupom":"XYZ"}')
    '## C2 cupom BemVindo10, calcular (esperado: desconto 5.99, total 73.81)'
    T 'carrinho/calcular' ('{' + $item + ',"cupom":"BemVindo10"}')
  }
  'D' {
    '## D1 i turco sem ponto no lugar do i, calcular'
    T 'carrinho/calcular' ('{' + $item + ',"cupom":"bemv\u0131ndo10"}')
    '## D2 cupom como array, calcular'
    T 'carrinho/calcular' ('{' + $item + ',"cupom":["BEMVINDO10"]}')
  }
}

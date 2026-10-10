// Testes de API: cupom de desconto e frete grátis (VZS-142)
// Cada teste cita o ID do cenário em /cenarios e /execucao/resultados.md
const { test, expect } = require('@playwright/test');

const CLIENTE = { nome: 'Maria Silva', email: 'maria@exemplo.com', cep: '01310-100' };
const ITEM = [{ produtoId: 'P001', quantidade: 1 }];

test.describe('API: cupom e frete grátis', () => {
  test('API-EXTRA-01 - exemplo da documentação: cupom BEMVINDO10 com frete grátis', async ({ request }) => {
    const res = await request.post('/api/carrinho/calcular', {
      data: {
        itens: [
          { produtoId: 'P002', quantidade: 1 },
          { produtoId: 'P004', quantidade: 2 },
        ],
        cupom: 'BEMVINDO10',
      },
    });
    expect(res.status()).toBe(200);
    const body = await res.json();
    expect(body.subtotal).toBeCloseTo(239.7, 2);
    expect(body.desconto).toBeCloseTo(23.97, 2);
    expect(body.frete).toBe(0);
    expect(body.freteGratis).toBe(true);
    expect(body.total).toBeCloseTo(215.73, 2);
  });

  test('API-EXTRA-02 - subtotal R$ 0,20 abaixo do mínimo cobra frete e informa o que falta', async ({ request }) => {
    const res = await request.post('/api/carrinho/calcular', {
      data: {
        itens: [
          { produtoId: 'P002', quantidade: 1 },
          { produtoId: 'P001', quantidade: 1 },
        ],
      },
    });
    expect(res.status()).toBe(200);
    const body = await res.json();
    expect(body.subtotal).toBeCloseTo(199.8, 2);
    expect(body.frete).toBeCloseTo(19.9, 2);
    expect(body.freteGratis).toBe(false);
    expect(body.valorFaltanteFreteGratis).toBeCloseTo(0.2, 2);
    expect(body.total).toBeCloseTo(219.7, 2);
  });

  test('CT25/CT26/CT49 - cupom ignora maiúsculas, minúsculas e espaços nas pontas', async ({ request }) => {
    for (const cupom of ['bemvindo10', 'BemVindo10', '  BEMVINDO10  ']) {
      const res = await request.post('/api/carrinho/calcular', { data: { itens: ITEM, cupom } });
      expect(res.status(), `cupom "${cupom}"`).toBe(200);
      const body = await res.json();
      expect(body.cupom.aplicado, `cupom "${cupom}"`).toBe(true);
      expect(body.desconto).toBeCloseTo(5.99, 2);
      expect(body.total).toBeCloseTo(73.81, 2);
    }
  });

  test('CT48 - cálculo com cupom inexistente responde 200 com "Cupom inválido."', async ({ request }) => {
    const res = await request.post('/api/carrinho/calcular', { data: { itens: ITEM, cupom: 'XYZ' } });
    expect(res.status()).toBe(200);
    const body = await res.json();
    expect(body.desconto).toBe(0);
    expect(body.cupom.aplicado).toBe(false);
    expect(body.cupom.mensagem).toBe('Cupom inválido.');
  });

  test('CT20 - cálculo com cupom expirado responde 200 sem desconto', async ({ request }) => {
    const res = await request.post('/api/carrinho/calcular', { data: { itens: ITEM, cupom: 'VERAO2026' } });
    expect(res.status()).toBe(200);
    const body = await res.json();
    expect(body.desconto).toBe(0);
    expect(body.cupom.aplicado).toBe(false);
    expect(body.cupom.mensagem).toBe('Cupom expirado.');
  });

  test('CT21 - pedido com cupom expirado é recusado com 422', async ({ request }) => {
    const res = await request.post('/api/pedidos', { data: { cliente: CLIENTE, itens: ITEM, cupom: 'VERAO2026' } });
    expect(res.status()).toBe(422);
    const body = await res.json();
    expect(body.erro.codigo).toBe('CUPOM_EXPIRADO');
  });
});

// Bugs conhecidos: testes de caracterização.
// Cada teste confirma primeiro as pré-condições (a API respondeu, o cenário está correto) e depois
// verifica o comportamento defeituoso. Enquanto o bug existir, o teste passa. Quando a equipe corrigir,
// o teste falha e deve ser atualizado para o comportamento descrito em "Esperado".
// Assim uma falha por outro motivo (loja fora do ar, contrato mudou) nunca é confundida com o bug.
test.describe('API: bugs conhecidos (caracterização)', () => {
  test('CT47 - BUG-01: pedido com subtotal exatamente R$ 200,00 ainda cobra frete', async ({ request }) => {
    test.info().annotations.push({ type: 'bug', description: 'BUG-01' });
    const res = await request.post('/api/pedidos', {
      data: { cliente: CLIENTE, itens: [{ produtoId: 'P005', quantidade: 2 }] },
    });
    // pré-condições
    expect(res.status()).toBe(201);
    const body = await res.json();
    expect(body.subtotal).toBe(200);
    // Esperado: frete 0, freteGratis true, total 200 (CA06). Comportamento atual (bug):
    expect(body.freteGratis).toBe(false);
    expect(body.frete).toBe(19.9);
    expect(body.total).toBe(219.9);
  });

  test('CT16 - BUG-02: cálculo com 6 unidades é aceito', async ({ request }) => {
    test.info().annotations.push({ type: 'bug', description: 'BUG-02' });
    const res = await request.post('/api/carrinho/calcular', {
      data: { itens: [{ produtoId: 'P001', quantidade: 6 }] },
    });
    // Esperado: 422 QUANTIDADE_MAXIMA_EXCEDIDA (CA10). Comportamento atual (bug):
    expect(res.status()).toBe(200);
    const body = await res.json();
    expect(body.itens[0].quantidade).toBe(6);
  });

  test('CT52 - BUG-02: cálculo com 1 quatrilhão de unidades é aceito', async ({ request }) => {
    test.info().annotations.push({ type: 'bug', description: 'BUG-02' });
    const res = await request.post('/api/carrinho/calcular', {
      data: { itens: [{ produtoId: 'P001', quantidade: 1e15 }] },
    });
    // Esperado: 422 QUANTIDADE_MAXIMA_EXCEDIDA. Comportamento atual (bug):
    expect(res.status()).toBe(200);
    const body = await res.json();
    expect(body.itens[0].quantidade).toBe(1e15);
    expect(body.subtotal).toBeGreaterThan(1e16);
  });

  test('CT53 - BUG-02: cálculo com 1e21 unidades é aceito e devolve notação científica', async ({ request }) => {
    test.info().annotations.push({ type: 'bug', description: 'BUG-02' });
    const res = await request.post('/api/carrinho/calcular', {
      data: { itens: [{ produtoId: 'P001', quantidade: 1e21 }] },
    });
    // Esperado: 422 QUANTIDADE_MAXIMA_EXCEDIDA. Comportamento atual (bug):
    expect(res.status()).toBe(200);
    const texto = await res.text();
    expect(texto).toContain('e+22');
  });

  test('CT54 - BUG-02: 9007199254740993 unidades voltam alteradas para ...992', async ({ request }) => {
    test.info().annotations.push({ type: 'bug', description: 'BUG-02' });
    // O corpo vai como texto para preservar o número exato (em JavaScript, 9007199254740993 vira ...992)
    const res = await request.post('/api/carrinho/calcular', {
      headers: { 'Content-Type': 'application/json' },
      data: '{"itens":[{"produtoId":"P001","quantidade":9007199254740993}]}',
    });
    // Esperado: 422 QUANTIDADE_MAXIMA_EXCEDIDA. Comportamento atual (bug):
    expect(res.status()).toBe(200);
    const texto = await res.text();
    expect(texto).toContain('"quantidade":9007199254740992');
  });

  test('CT50 - BUG-03: cálculo com cupom só com espaços diverge do cupom vazio', async ({ request }) => {
    test.info().annotations.push({ type: 'bug', description: 'BUG-03' });
    // pré-condição (CT42): cupom vazio equivale a "sem cupom"
    const controle = await request.post('/api/carrinho/calcular', { data: { itens: ITEM, cupom: '' } });
    expect(controle.status()).toBe(200);
    expect((await controle.json()).cupom).toBeNull();

    const res = await request.post('/api/carrinho/calcular', { data: { itens: ITEM, cupom: '   ' } });
    expect(res.status()).toBe(200);
    // Esperado: cupom nulo, igual ao controle (CA02). Comportamento atual (bug):
    expect((await res.json()).cupom).toEqual({ codigo: '', aplicado: false, mensagem: 'Cupom inválido.' });
  });

  test('CT51 - BUG-03: pedido com cupom só com espaços é recusado', async ({ request }) => {
    test.info().annotations.push({ type: 'bug', description: 'BUG-03' });
    // pré-condição: pedido com cupom vazio é criado
    const controle = await request.post('/api/pedidos', { data: { cliente: CLIENTE, itens: ITEM, cupom: '' } });
    expect(controle.status()).toBe(201);

    const res = await request.post('/api/pedidos', { data: { cliente: CLIENTE, itens: ITEM, cupom: '   ' } });
    // Esperado: 201, igual ao controle (CA02). Comportamento atual (bug):
    expect(res.status()).toBe(422);
    expect((await res.json()).erro.codigo).toBe('CUPOM_INVALIDO');
  });
});

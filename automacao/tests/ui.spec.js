// Testes de interface: carrinho com cupom e frete grátis (VZS-142)
const { test, expect } = require('@playwright/test');

// Abre a loja, adiciona o produto ao carrinho `qtd` vezes e abre o carrinho.
async function adicionarEAbrirCarrinho(page, nomeProduto, qtd = 1) {
  await page.goto('/');
  await page.getByRole('link', { name: 'Produtos' }).first().click();

  // Encontra o cartão do produto: o ancestral mais próximo do nome que contém um botão
  const cartao = page.getByText(nomeProduto, { exact: true }).first().locator('xpath=ancestor::*[.//button][1]');
  for (let i = 0; i < qtd; i++) {
    await cartao.getByRole('button', { name: 'Adicionar ao carrinho' }).click();
  }
  await page.getByRole('link', { name: /Carrinho/ }).first().click();
}

async function aplicarCupom(page, codigo) {
  await page.getByLabel('Cupom de desconto').fill(codigo);
  await page.getByRole('button', { name: 'Aplicar cupom' }).click();
}

// Valores do "Resumo do pedido": subtotal, desconto, frete e total
const resumo = (page, campo) => page.locator(`[data-valor="${campo}"]`);

test.describe('Interface: cupom e frete', () => {
  test('CT02 - cupom válido em compra abaixo do valor do frete grátis', async ({ page }) => {
    await adicionarEAbrirCarrinho(page, 'Mochila Urbana 20L', 1);
    await aplicarCupom(page, 'BEMVINDO10');

    await expect(page.getByText('Cupom BEMVINDO10 aplicado.')).toBeVisible();
    await expect(resumo(page, 'subtotal')).toHaveText('R$ 100,00');
    await expect(resumo(page, 'desconto')).toHaveText(/10,00/);
    await expect(resumo(page, 'frete')).toHaveText('R$ 19,90'); // o desconto não incide sobre o frete (CA09)
    await expect(resumo(page, 'total')).toHaveText('R$ 109,90');
    await expect(page.getByText('Faltam R$ 100,00 para o frete grátis.')).toBeVisible();
  });

  test('CT08 - cupom expirado mostra mensagem e não aplica desconto', async ({ page }) => {
    await adicionarEAbrirCarrinho(page, 'Calça Jeans Slim', 1);
    await aplicarCupom(page, 'VERAO2026');

    await expect(page.getByText('Cupom expirado.')).toBeVisible();
    await expect(resumo(page, 'subtotal')).toHaveText('R$ 139,90');
    await expect(resumo(page, 'desconto')).toHaveText('R$ 0,00');
    await expect(resumo(page, 'frete')).toHaveText('R$ 19,90');
    await expect(resumo(page, 'total')).toHaveText('R$ 159,80');
  });

  // Bug conhecido: teste de caracterização (ver comentário em api.spec.js).
  // Enquanto o BUG-01 existir, o teste passa. Quando corrigirem, ele falha e deve ser atualizado
  // para o comportamento esperado: frete "Grátis" e total "R$ 200,00".
  test('CT03 - BUG-01: subtotal exatamente R$ 200,00 ainda cobra frete', async ({ page }) => {
    test.info().annotations.push({ type: 'bug', description: 'BUG-01' });
    await adicionarEAbrirCarrinho(page, 'Mochila Urbana 20L', 2);

    // pré-condições: a página carregou e o cenário está no valor limite
    await expect(resumo(page, 'subtotal')).toHaveText('R$ 200,00');
    await expect(resumo(page, 'desconto')).toHaveText('R$ 0,00');
    // comportamento atual (bug)
    await expect(resumo(page, 'frete')).toHaveText('R$ 19,90');
    await expect(resumo(page, 'total')).toHaveText('R$ 219,90');
  });

  test('EXP09 - cupom só com espaços mostra o aviso de campo vazio', async ({ page }) => {
    await adicionarEAbrirCarrinho(page, 'Calça Jeans Slim', 1);
    await aplicarCupom(page, '   ');

    await expect(page.getByText('Informe um cupom.')).toBeVisible();
    await expect(resumo(page, 'desconto')).toHaveText('R$ 0,00');
  });
});

test('EXP08 - interface impede quantidade zero e permite remover o item', async ({ page }) => {
  await adicionarEAbrirCarrinho(page, 'Camiseta Essencial');

  await expect(page.getByRole('button', { name: 'Diminuir quantidade de Camiseta Essencial' })).toBeDisabled();
  await expect(page.getByRole('button', { name: 'Remover Camiseta Essencial do carrinho' })).toBeEnabled();

  await page.getByRole('button', { name: 'Remover Camiseta Essencial do carrinho' }).click();
  await expect(page.getByText('Camiseta Essencial', { exact: true })).toHaveCount(0);
});

# Twiddle factors em ponto fixo - modelo do multiplicador de Gauss

# W8^k = e^(-j*2*pi*k/8) = c + jd
# Q1.14: valor_inteiro = round(valor * 2^14)

import numpy as np

FRAC   = 14
ESCALA = 2 ** FRAC          # 16384

def quantiza(x):
    return int(round(x * ESCALA))

# modelo em inteiros do cmul_Gauss.v
def gauss(a, b, c, d):
    k1 = c * (a + b)
    k2 = a * (d - c)
    k3 = b * (c + d)
    re = k1 - k3
    im = k1 + k2
    return re >> FRAC, im >> FRAC 

# tabela dos twiddles
print("k |  c(int)  d(int) | c+d     d-c")
tw = {}
for k in range(4):
    w = np.exp(-2j * np.pi * k / 8)
    c = quantiza(w.real)
    d = quantiza(w.imag)
    tw[k] = (c, d)
    print(f"{k} | {c:7d} {d:7d} | {c+d:7d} {d-c:7d}")

# linhas prontas para o Verilog
print("\nPara o Verilog (FFT, k = 1 e 3):")
for k in (1, 3):
    c, d = tw[k]
    print(f"W{k}: c = {c}, d = {d}, c+d = {c+d}, d-c = {d-c}")

# Gauss em inteiros x multiplicacao exata
rng = np.random.default_rng(0)
erro_max = 0.0
for _ in range(10000):
    a = int(rng.integers(-128, 128))
    b = int(rng.integers(-128, 128))
    k = int(rng.choice([1, 3]))
    c, d = tw[k]
    re_hw, im_hw = gauss(a, b, c, d)
    ref = (a + 1j * b) * np.exp(-2j * np.pi * k / 8)
    erro_max = max(erro_max, abs(re_hw - ref.real), abs(im_hw - ref.imag))

print(f"\nErro absoluto maximo (Gauss inteiro x exato): {erro_max:.3f}")

# referência para o testbench
# Tem que dar os mesmo valores no testbench de tb_cmulW1 e tb_cmulW3
entradas = [(100,50),(-80,60),(0,0),(1,0),(0,1),(127,127),(-128,-128),(127,-128)]

for k in (1, 3):
    print(f"\nW{k} ")
    c, d = tw[k]
    for a, b in entradas:
        re, im = gauss(a, b, c, d)
        print(f"testa({a}, {b}, {re}, {im});")
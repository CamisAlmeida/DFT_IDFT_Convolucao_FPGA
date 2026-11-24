import numpy as np

K = 11585  # round(0.7071 * 2**14)

def rot(br, bi, w):
    # T = W*B em inteiro, igual ao cmulW1 / cmulW3
    if w == 1:  return (K*(br+bi)) >> 14, (K*(bi-br)) >> 14
    if w == 3:  return (K*(bi-br)) >> 14, (-K*(br+bi)) >> 14

def bfly(ar, ai, br, bi, w):
    if w == 0:   tr, ti = br, bi
    elif w == 2: tr, ti = bi, -br          # W2 = -j
    else:        tr, ti = rot(br, bi, w)
    return (ar+tr, ai+ti), (ar-tr, ai-ti)

def fft8_hw(x):
    s = [(v, 0) for v in (x[0],x[4],x[2],x[6],x[1],x[5],x[3],x[7])]
    # estágio 1
    s1 = []
    for i in (0,2,4,6):
        a, b = bfly(*s[i], *s[i+1], 0); s1 += [a, b]
    # estágio 2
    e0,e2 = bfly(*s1[0],*s1[2],0); e1,e3 = bfly(*s1[1],*s1[3],2)
    o0,o2 = bfly(*s1[4],*s1[6],0); o1,o3 = bfly(*s1[5],*s1[7],2)
    # estágio 3
    X0,X4 = bfly(*e0,*o0,0); X1,X5 = bfly(*e1,*o1,1)
    X2,X6 = bfly(*e2,*o2,2); X3,X7 = bfly(*e3,*o3,3)
    return [X0,X1,X2,X3,X4,X5,X6,X7]

def confere(x):
    hw = np.array([complex(r, i) for r, i in fft8_hw(x)])
    ref = np.fft.fft(x)
    return hw, ref

# teste
erro_max = 0
for _ in range(10000):
    x = np.random.randint(-128, 128, 8)
    hw, ref = confere(x)
    erro_max = max(erro_max, np.max(np.abs(hw - ref)))
print("erro maximo (modulo complexo):", erro_max)


import numpy as np

def to16(v):
    return v & 0xFFFF

casos = []

casos.append([0]*8)                                   # nulo
for p in range(8):                                    # impulsos
    v = [0]*8; v[p] = 100; casos.append(v)
casos.append([50]*8)                                  # constante
casos.append([-50]*8)
casos.append([127,-128,127,-128,127,-128,127,-128])   # extremos
casos.append([-128]*8)
casos.append([127]*8)
casos.append([1,2,2,1,0,0,0,0])                       # filtro h
casos.append([10,-20,30,-40,0,0,0,0])                 # 4 amostras + 4 zeros
casos.append([127,127,127,127,0,0,0,0])
rng = np.random.default_rng(1)
for _ in range(200):                                  # aleatórios
    casos.append(list(rng.integers(-128, 128, 8)))

with open("vetores_fft8.hex", "w") as f:
    for x in casos:
        X = fft8_hw(x)
        linha = [to16(int(v)) for v in x]
        for (r, i) in X:
            linha += [to16(int(r)), to16(int(i))]
        # 8 entradas + 16 saídas = 24 palavras de 16 bits por caso
        f.write(" ".join(f"{w:04x}" for w in linha) + "\n")

print("casos:", len(casos))
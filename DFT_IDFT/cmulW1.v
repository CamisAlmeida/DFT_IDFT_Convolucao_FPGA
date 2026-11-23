/**
Multiplicação complexa pelo twiddle W1 = e^(-j*2*pi/8) = 0.7071 - 0.7071j
Algoritmo de Gauss com constantes

(a + jb) * (c + jd)

k1 = c * (a + b)
k2 = a * (d - c)
k3 = b * (c + d)

Real = k1 - k3
Imag = k1 + k2

Constantes pré-calculadas em Python (twiddles.py), conforme o documento
do projeto (Projeto 2, pág. 3). Q1.14 (valor * 2^14):

c = 11585    d = -11585
c + d = 0        -> k3 = 0 (o multiplicador some)
d - c = -23170

Resultado simplificado: Real = 11585*(a+b)   Imag = 11585*(b-a)   (>>> 14)
**/

// Declaração do modulo
module cmulW1(a,b,re,im);
	//declaração das portas
	input signed [15:0] a,b;     // entrada variável: a + jb
	output signed [16:0] re,im;  // resultado: re + j*im

	//fios intermediarios
	wire signed [15:0] c;          // constante c
	wire signed [16:0] soma_cd;    // constante c + d
	
	wire signed [16:0] sub_dc;     // constante d - c
	wire signed [16:0] soma_ab;    // a + b (única pré-soma em tempo de execução)
	
	wire signed [32:0] k1,k2,k3;   // as 3 multiplicações
	
	wire signed [33:0] re_full;
	wire signed [33:0] im_full;

	//constantes (pré-calculadas em Python)
	assign c       = 16'sd11585;
	assign soma_cd = 17'sd0;
	assign sub_dc  = -17'sd23170;

	//funcionamento do circuito
	assign soma_ab = a + b;

	assign k1 = soma_ab * c;
	assign k2 = a * sub_dc;
	assign k3 = b * soma_cd;     // = 0

	assign re_full = k1 - k3;
	assign im_full = k1 + k2;

	// volta para a escala original (divide por 2^14)
	assign re = re_full >>> 14;
	assign im = im_full >>> 14;

endmodule
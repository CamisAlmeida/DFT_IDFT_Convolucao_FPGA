/**
Borboleta radix-2 com twiddle W3 = e^(-j*2*pi*3/8) = -0.7071 - 0.7071j
(decimação no tempo)

X = A + W*B
Y = A - W*B

Primeiro a rotação T = W3*B, feita pelo cmulW3 (Gauss com constantes,
2 multiplicações reais), depois a borboleta pura A +/- T.

A = ar + j*ai
B = br + j*bi
T = tr + j*ti = W3*B

Xr = ar + tr     Xi = ai + ti
Yr = ar - tr     Yi = ai - ti

Larguras: entradas de 16 bits, T com 17 bits (saída do cmulW3), saídas
de 17 bits. A soma A + T só cabe em 17 bits por causa da faixa real de
operação (valores da FFT na ordem de +-2000). Premissa a documentar.
**/

// Declaração do modulo
module butterflyW3(ar,ai,br,bi,xr,xi,yr,yi);
	//declaração das portas
	input signed [15:0] ar,ai;     // entrada A - parte real e imaginaria
	input signed [15:0] br,bi;     // entrada B - parte real e imaginaria
	output signed [16:0] xr,xi;    // saída X = A + W3*B
	output signed [16:0] yr,yi;    // saída Y = A - W3*B

	//fios intermediarios
	wire signed [16:0] tr,ti;      // T = W3*B

	//rotação de B pelo twiddle W3
	cmulW3 rot(.a(br), .b(bi), .re(tr), .im(ti));

	//funcionamento do circuito
	assign xr = ar + tr;
	assign xi = ai + ti;
	assign yr = ar - tr;
	assign yi = ai - ti;

endmodule
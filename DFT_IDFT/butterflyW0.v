/**
Borboleta radix-2 com twiddle W0 = 1 (decimação no tempo)

X = A + W*B = A + B
Y = A - W*B = A - B

W0 = 1  ->  W*B = B
Não precisa de multiplicador: só soma e subtração, separadas em parte
real e parte imaginária.

A = ar + j*ai
B = br + j*bi

Xr = ar + br     Xi = ai + bi
Yr = ar - br     Yi = ai - bi

Larguras: entradas de 16 bits, saídas de 17 bits (a soma/subtração de
dois números de 16 bits pode crescer 1 bit).
**/

// Declaração do modulo
module butterflyW0(ar,ai,br,bi,xr,xi,yr,yi);
	//declaração das portas
	input signed [15:0] ar,ai;     // entrada A - parte real e imaginaria
	input signed [15:0] br,bi;     // entrada B - parte real e imaginaria
	output signed [16:0] xr,xi;    // saída X = A + B
	output signed [16:0] yr,yi;    // saída Y = A - B

	//funcionamento do circuito
	assign xr = ar + br;
	assign xi = ai + bi;
	assign yr = ar - br;
	assign yi = ai - bi;

endmodule
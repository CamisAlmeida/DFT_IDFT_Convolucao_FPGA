/**
Borboleta radix-2 com twiddle W2 = -j (decimação no tempo)

X = A + W*B
Y = A - W*B

W2 = -j  ->  W*B = (br + j*bi) * (-j) = bi - j*br
Não precisa de multiplicador: só troca real/imaginário e inverte um sinal.

A = ar + j*ai
B = br + j*bi

Xr = ar + bi     Xi = ai - br
Yr = ar - bi     Yi = ai + br
**/

// Declaração do modulo
module butterflyW2(ar,ai,br,bi,xr,xi,yr,yi);
	//declaração das portas
	input signed [15:0] ar,ai;     // entrada A - parte real e imaginaria
	input signed [15:0] br,bi;     // entrada B - parte real e imaginaria
	output signed [16:0] xr,xi;    // saída X = A + W*B
	output signed [16:0] yr,yi;    // saída Y = A - W*B

	//funcionamento do circuito
	assign xr = ar + bi;
	assign xi = ai - br;
	assign yr = ar - bi;
	assign yi = ai + br;

endmodule
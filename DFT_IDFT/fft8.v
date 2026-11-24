/**
FFT de 8 pontos - Cooley-Tukey radix-2, decimação no tempo (DIT)
Versão combinacional (3 estágios de borboletas)

Entrada: 8 amostras reais (16 bits), em ordem natural
Saída:   8 coeficientes complexos, em ordem natural

Estágio 1: 4 borboletas W0 (entrada bit-reversa: x0 x4 x2 x6 x1 x5 x3 x7)
Estágio 2: 2 borboletas W0 e 2 borboletas W2
Estágio 3: W0, W1, W2, W3

Larguras: borboletas saem com 17 bits; a faixa real da FFT (|X| <= 1024
para x de 8 bits) cabe em 16 bits, então cada estágio é truncado para 16
bits ao entrar no seguinte (descartando só o bit de sinal redundante).
**/

module fft8(x0,x1,x2,x3,x4,x5,x6,x7,
            X0r,X0i,X1r,X1i,X2r,X2i,X3r,X3i,
            X4r,X4i,X5r,X5i,X6r,X6i,X7r,X7i);

	input signed [15:0] x0,x1,x2,x3,x4,x5,x6,x7;
	output signed [15:0] X0r,X0i,X1r,X1i,X2r,X2i,X3r,X3i,
	                     X4r,X4i,X5r,X5i,X6r,X6i,X7r,X7i;

	// saídas brutas (17 bits) de cada estágio
	wire signed [16:0] p0r_f,p0i_f,p1r_f,p1i_f,p2r_f,p2i_f,p3r_f,p3i_f;
	wire signed [16:0] p4r_f,p4i_f,p5r_f,p5i_f,p6r_f,p6i_f,p7r_f,p7i_f;
	wire signed [16:0] E0r_f,E0i_f,E1r_f,E1i_f,E2r_f,E2i_f,E3r_f,E3i_f;
	wire signed [16:0] O0r_f,O0i_f,O1r_f,O1i_f,O2r_f,O2i_f,O3r_f,O3i_f;
	wire signed [16:0] X0r_f,X0i_f,X1r_f,X1i_f,X2r_f,X2i_f,X3r_f,X3i_f;
	wire signed [16:0] X4r_f,X4i_f,X5r_f,X5i_f,X6r_f,X6i_f,X7r_f,X7i_f;

	// versões de 16 bits (entrada do próximo estágio)
	wire signed [15:0] p0r,p0i,p1r,p1i,p2r,p2i,p3r,p3i;
	wire signed [15:0] p4r,p4i,p5r,p5i,p6r,p6i,p7r,p7i;
	wire signed [15:0] E0r,E0i,E1r,E1i,E2r,E2i,E3r,E3i;
	wire signed [15:0] O0r,O0i,O1r,O1i,O2r,O2i,O3r,O3i;

	// Estágio 1 (todas W0, parte imaginária da entrada = 0)
	butterflyW0 s1a(.ar(x0),.ai(16'sd0),.br(x4),.bi(16'sd0),
	                .xr(p0r_f),.xi(p0i_f),.yr(p1r_f),.yi(p1i_f));
	butterflyW0 s1b(.ar(x2),.ai(16'sd0),.br(x6),.bi(16'sd0),
	                .xr(p2r_f),.xi(p2i_f),.yr(p3r_f),.yi(p3i_f));
	butterflyW0 s1c(.ar(x1),.ai(16'sd0),.br(x5),.bi(16'sd0),
	                .xr(p4r_f),.xi(p4i_f),.yr(p5r_f),.yi(p5i_f));
	butterflyW0 s1d(.ar(x3),.ai(16'sd0),.br(x7),.bi(16'sd0),
	                .xr(p6r_f),.xi(p6i_f),.yr(p7r_f),.yi(p7i_f));

	assign p0r = p0r_f[15:0];  assign p0i = p0i_f[15:0];
	assign p1r = p1r_f[15:0];  assign p1i = p1i_f[15:0];
	assign p2r = p2r_f[15:0];  assign p2i = p2i_f[15:0];
	assign p3r = p3r_f[15:0];  assign p3i = p3i_f[15:0];
	assign p4r = p4r_f[15:0];  assign p4i = p4i_f[15:0];
	assign p5r = p5r_f[15:0];  assign p5i = p5i_f[15:0];
	assign p6r = p6r_f[15:0];  assign p6i = p6i_f[15:0];
	assign p7r = p7r_f[15:0];  assign p7i = p7i_f[15:0];

	// Estágio 2
	butterflyW0 s2a(.ar(p0r),.ai(p0i),.br(p2r),.bi(p2i),
	                .xr(E0r_f),.xi(E0i_f),.yr(E2r_f),.yi(E2i_f));
	butterflyW2 s2b(.ar(p1r),.ai(p1i),.br(p3r),.bi(p3i),
	                .xr(E1r_f),.xi(E1i_f),.yr(E3r_f),.yi(E3i_f));
	butterflyW0 s2c(.ar(p4r),.ai(p4i),.br(p6r),.bi(p6i),
	                .xr(O0r_f),.xi(O0i_f),.yr(O2r_f),.yi(O2i_f));
	butterflyW2 s2d(.ar(p5r),.ai(p5i),.br(p7r),.bi(p7i),
	                .xr(O1r_f),.xi(O1i_f),.yr(O3r_f),.yi(O3i_f));

	assign E0r = E0r_f[15:0];  assign E0i = E0i_f[15:0];
	assign E1r = E1r_f[15:0];  assign E1i = E1i_f[15:0];
	assign E2r = E2r_f[15:0];  assign E2i = E2i_f[15:0];
	assign E3r = E3r_f[15:0];  assign E3i = E3i_f[15:0];
	assign O0r = O0r_f[15:0];  assign O0i = O0i_f[15:0];
	assign O1r = O1r_f[15:0];  assign O1i = O1i_f[15:0];
	assign O2r = O2r_f[15:0];  assign O2i = O2i_f[15:0];
	assign O3r = O3r_f[15:0];  assign O3i = O3i_f[15:0];

	// Estágio 3
	butterflyW0 s3a(.ar(E0r),.ai(E0i),.br(O0r),.bi(O0i),
	                .xr(X0r_f),.xi(X0i_f),.yr(X4r_f),.yi(X4i_f));
	butterflyW1 s3b(.ar(E1r),.ai(E1i),.br(O1r),.bi(O1i),
	                .xr(X1r_f),.xi(X1i_f),.yr(X5r_f),.yi(X5i_f));
	butterflyW2 s3c(.ar(E2r),.ai(E2i),.br(O2r),.bi(O2i),
	                .xr(X2r_f),.xi(X2i_f),.yr(X6r_f),.yi(X6i_f));
	butterflyW3 s3d(.ar(E3r),.ai(E3i),.br(O3r),.bi(O3i),
	                .xr(X3r_f),.xi(X3i_f),.yr(X7r_f),.yi(X7i_f));

	assign X0r = X0r_f[15:0];  assign X0i = X0i_f[15:0];
	assign X1r = X1r_f[15:0];  assign X1i = X1i_f[15:0];
	assign X2r = X2r_f[15:0];  assign X2i = X2i_f[15:0];
	assign X3r = X3r_f[15:0];  assign X3i = X3i_f[15:0];
	assign X4r = X4r_f[15:0];  assign X4i = X4i_f[15:0];
	assign X5r = X5r_f[15:0];  assign X5i = X5i_f[15:0];
	assign X6r = X6r_f[15:0];  assign X6i = X6i_f[15:0];
	assign X7r = X7r_f[15:0];  assign X7i = X7i_f[15:0];

endmodule
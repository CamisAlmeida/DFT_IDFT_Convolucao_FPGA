/**
Testbench dos multiplicadores com constantes (W1 e W3)
Compara com o cmul_Gauss genérico (c e d como entrada)
e com os valores esperados calculados à mão.
**/
`timescale 1ns/1ps

module tb_cmulConst;
	reg signed [15:0] a,b;
	wire signed [16:0] re1,im1;      // cmulW1
	wire signed [16:0] re3,im3;      // cmulW3
	wire signed [16:0] reg1,img1;    // referência W1
	wire signed [16:0] reg3,img3;    // referência W3

	integer i, erros;

	// módulos com constantes
	cmulW1 u1 (a,b,re1,im1);
	cmulW3 u3 (a,b,re3,im3);

	// referência: módulo genérico com os mesmos c e d
	cmul_Gauss r1 (a,b, 16'sd11585,-16'sd11585,reg1,img1);
	cmul_Gauss r3 (a,b,-16'sd11585,-16'sd11585,reg3,img3);

	// confere constante x referência
	task confere;
		begin
			if (re1 !== reg1 || im1 !== img1) begin
				erros = erros + 1;
				$display("ERRO W1: a=%0d b=%0d -> %0d,%0d (ref %0d,%0d)", a, b, re1, im1, reg1, img1);
			end
			if (re3 !== reg3 || im3 !== img3) begin
				erros = erros + 1;
				$display("ERRO W3: a=%0d b=%0d -> %0d,%0d (ref %0d,%0d)", a, b, re3, im3, reg3, img3);
			end
		end
	endtask

	initial begin
		erros = 0;

		// (100+50j)
		a = 100; b = 50; #10;
		$display("W1: re=%0d im=%0d (esperado 106, -36)", re1, im1);
		$display("W3: re=%0d im=%0d (esperado -36, -107)", re3, im3);
		confere;

		// (-80+60j)
		a = -80; b = 60; #10;
		$display("W1: re=%0d im=%0d (esperado -15, 98)", re1, im1);
		$display("W3: re=%0d im=%0d (esperado 98, 14)", re3, im3);
		confere;

		// zero
		a = 0; b = 0; #10;
		$display("zero W1: %0d,%0d | W3: %0d,%0d (esperado 0, 0)", re1, im1, re3, im3);
		confere;

		// 200 valores aleatórios (faixa de 8 bits com sinal, como as amostras de x[n])
		for (i = 0; i < 200; i = i + 1) begin
			a = $random % 128;
			b = $random % 128;
			#10;
			confere;
		end

		if (erros == 0) $display("PASSOU: constantes iguais ao Gauss generico.");
		else            $display("FALHOU: %0d erros.", erros);

		$stop;
	end
endmodule
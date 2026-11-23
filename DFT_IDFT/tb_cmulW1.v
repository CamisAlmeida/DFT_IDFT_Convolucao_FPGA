/**
Testbench do cmulW1 (twiddle W1 = 0.7071 - 0.7071j)
Valores esperados calculados à mão:
Real = 11585*(a+b) >>> 14     Imag = 11585*(b-a) >>> 14
**/
`timescale 1ns/1ps

module tb_cmulW1;
	reg signed [15:0] a,b;
	wire signed [16:0] re,im;
	integer erros;

	// instância do módulo
	cmulW1 dut (a,b,re,im);

	// aplica a entrada e confere a saída
	task testa;
		input signed [15:0] ta,tb;
		input signed [16:0] re_esp,im_esp;
		begin
			a = ta; b = tb; #10;
			if (re !== re_esp || im !== im_esp) begin
				erros = erros + 1;
				$display("ERRO: a=%0d b=%0d -> re=%0d im=%0d (esperado %0d, %0d)", ta, tb, re, im, re_esp, im_esp);
			end
			else
				$display("OK:   a=%0d b=%0d -> re=%0d im=%0d", ta, tb, re, im);
		end
	endtask

	initial begin
		erros = 0;

		//    a     b    re    im
		testa(100,   50,  106,  -36);
		testa(-80,   60,  -15,   98);
		testa(0,      0,    0,    0);
		testa(1,      0,    0,   -1);
		testa(0,      1,    0,    0);
		testa(127,  127,  179,    0);
		testa(-128,-128, -182,    0);
		testa(127, -128,   -1, -181);

		if (erros == 0) $display("W1 PASSOU");
		else            $display("W1 FALHOU: %0d erros", erros);

		$stop;
	end
endmodule
`timescale 1ns/1ps

module tb_butterflyW0;

	reg signed [15:0] ar, ai, br, bi;
	wire signed [16:0] xr, xi, yr, yi;

	// valores esperados
	reg signed [16:0] exp_xr, exp_xi, exp_yr, exp_yi;

	integer erros;
	integer total;
	integer i;

	// instância do módulo sob teste
	butterflyW0 dut(.ar(ar), .ai(ai), .br(br), .bi(bi),
	                .xr(xr), .xi(xi), .yr(yr), .yi(yi));

	// aplica uma entrada, espera e compara com o esperado
	task testa;
		input signed [15:0] t_ar, t_ai, t_br, t_bi;
		begin
			ar = t_ar;  ai = t_ai;
			br = t_br;  bi = t_bi;
			#1;

			// esperado: X = A + B  e  Y = A - B
			exp_xr = ar + br;
			exp_xi = ai + bi;
			exp_yr = ar - br;
			exp_yi = ai - bi;

			total = total + 1;
			if (xr !== exp_xr || xi !== exp_xi ||
			    yr !== exp_yr || yi !== exp_yi) begin
				erros = erros + 1;
				$display("ERRO: A=(%0d,%0d) B=(%0d,%0d) | X=(%0d,%0d) esp=(%0d,%0d) | Y=(%0d,%0d) esp=(%0d,%0d)",
				         ar, ai, br, bi, xr, xi, exp_xr, exp_xi, yr, yi, exp_yr, exp_yi);
			end
		end
	endtask

	initial begin
		erros = 0;
		total = 0;

		// zeros
		testa(0, 0, 0, 0);

		// só parte real
		testa(10, 0, 3, 0);
		testa(100, 0, 100, 0);

		// só parte imaginária
		testa(0, 10, 0, 3);
		testa(0, -7, 0, 20);

		// positivos e negativos
		testa(5, 6, 7, 8);
		testa(-5, -6, -7, -8);
		testa(50, -50, -30, 30);
		testa(-100, 100, 100, -100);

		// A = B  (Y deve dar zero)
		testa(37, -12, 37, -12);

		// extremos da faixa de 8 bits (amostras x[n])
		testa(127, 127, 127, 127);
		testa(-128, -128, -128, -128);
		testa(127, -128, -128, 127);

		// extremos de 16 bits (confirma que 17 bits de saída não estouram)
		testa(16'sd32767, 16'sd32767, 16'sd32767, 16'sd32767);
		testa(-16'sd32768, -16'sd32768, -16'sd32768, -16'sd32768);
		testa(16'sd32767, -16'sd32768, -16'sd32768, 16'sd32767);
		testa(-16'sd32768, 16'sd32767, 16'sd32767, -16'sd32768);

		// aleatórios (faixa completa de 16 bits)
		for (i = 0; i < 1000; i = i + 1) begin
			testa($random, $random, $random, $random);
		end

		$display("tb_butterflyW0: %0d casos, %0d erros", total, erros);
		if (erros == 0) $display("PASSOU");
		else            $display("FALHOU");

		$finish;
	end

endmodule
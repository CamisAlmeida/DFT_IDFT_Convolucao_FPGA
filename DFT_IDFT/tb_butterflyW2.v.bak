/**
Testbench da borboleta W2 (twiddle -j)
**/
`timescale 1ns/1ps

module tb_butterflyW2;
	reg signed [15:0] ar,ai,br,bi;
	wire signed [16:0] xr,xi,yr,yi;
	integer erros;

	// instância do módulo
	butterflyW2 dut (ar,ai,br,bi,xr,xi,yr,yi);

	// aplica a entrada e confere a saída
	task testa;
		input signed [15:0] tar,tai,tbr,tbi;
		input signed [16:0] exr,exi,eyr,eyi;
		begin
			ar = tar; ai = tai; br = tbr; bi = tbi; #10;
			if (xr !== exr || xi !== exi || yr !== eyr || yi !== eyi) begin
				erros = erros + 1;
				$display("ERRO: A=%0d+j%0d B=%0d+j%0d -> X=%0d+j%0d Y=%0d+j%0d (esperado X=%0d+j%0d Y=%0d+j%0d)",
					tar,tai,tbr,tbi, xr,xi,yr,yi, exr,exi,eyr,eyi);
			end
			else
				$display("OK:   X=%0d+j%0d Y=%0d+j%0d", xr,xi,yr,yi);
		end
	endtask

	initial begin
		erros = 0;

		//    ar   ai   br   bi    xr   xi    yr   yi
		testa( 10,  20,   3,   5,   15,  17,    5,  23);
		testa(-10,   4,   6,  -8,  -18,  -2,   -2,  10);
		testa(  0,   0,   0,   0,    0,   0,    0,   0);
		testa(  0,   0,   1,   0,    0,  -1,    0,   1);
		testa(  0,   0,   0,   1,    1,   0,   -1,   0);

		if (erros == 0) $display("BUTTERFLY W2 PASSOU");
		else            $display("BUTTERFLY W2 FALHOU: %0d erros", erros);

		$stop;
	end
endmodule
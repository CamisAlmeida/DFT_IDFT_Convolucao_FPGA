`timescale 1ns/1ps

module tb_fft8;

	parameter N = 217;   //casos impresso pelo Python

	reg signed [15:0] x0,x1,x2,x3,x4,x5,x6,x7;
	wire signed [15:0] X0r,X0i,X1r,X1i,X2r,X2i,X3r,X3i,
	                   X4r,X4i,X5r,X5i,X6r,X6i,X7r,X7i;

	reg [15:0] mem [0:N*24-1];
	integer erros, i, c, base;
	reg signed [15:0] e [0:15];

	fft8 dut(x0,x1,x2,x3,x4,x5,x6,x7,
	         X0r,X0i,X1r,X1i,X2r,X2i,X3r,X3i,
	         X4r,X4i,X5r,X5i,X6r,X6i,X7r,X7i);

	initial begin
		$readmemh("vetores_fft8.hex", mem);
		erros = 0;

		for (c = 0; c < N; c = c + 1) begin
			base = c*24;
			x0 = mem[base+0]; x1 = mem[base+1]; x2 = mem[base+2]; x3 = mem[base+3];
			x4 = mem[base+4]; x5 = mem[base+5]; x6 = mem[base+6]; x7 = mem[base+7];
			#1;

			for (i = 0; i < 16; i = i + 1) e[i] = mem[base+8+i];

			if (X0r!==e[0]  || X0i!==e[1]  || X1r!==e[2]  || X1i!==e[3]  ||
			    X2r!==e[4]  || X2i!==e[5]  || X3r!==e[6]  || X3i!==e[7]  ||
			    X4r!==e[8]  || X4i!==e[9]  || X5r!==e[10] || X5i!==e[11] ||
			    X6r!==e[12] || X6i!==e[13] || X7r!==e[14] || X7i!==e[15]) begin
				erros = erros + 1;
				$display("ERRO caso %0d: x=(%0d %0d %0d %0d %0d %0d %0d %0d)",
				         c, x0,x1,x2,x3,x4,x5,x6,x7);
				$display("  X1 hw=(%0d,%0d) esp=(%0d,%0d)", X1r,X1i,e[2],e[3]);
				$display("  X3 hw=(%0d,%0d) esp=(%0d,%0d)", X3r,X3i,e[6],e[7]);
			end
		end

		$display("tb_fft8: %0d casos, %0d erros", N, erros);
		if (erros == 0) $display("PASSOU");
		else            $display("FALHOU");
		$finish;
	end

endmodule
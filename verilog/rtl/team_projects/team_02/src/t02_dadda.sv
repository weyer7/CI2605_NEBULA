

module t02_dadda(
	input logic [7:0] a,
	input logic [7:0] b,
	output logic[16:0] out
);

	logic [63:0] P; // partial products (flattened)
	logic [31:0] PRE; // results to be added
// partial product
	t02_partial_products pp(.A(a),.B(b),.P(P));
// reduction tree
	t02_reduce r(.P(P), .PRE(PRE));
// final addition
	t02_adder16 add(.A(PRE[15:0]),.B(PRE[31:16]),.S(out));
endmodule

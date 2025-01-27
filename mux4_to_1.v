module mux4_to_1(
	input a,b,c,d,
	input s1,s2,
	output f
);
	assign f = ~s1 & ~s2 & a | s1 & ~s2 & b | ~s1 & s2 &c | s1 & s2 & d;


endmodule	
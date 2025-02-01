module counter_test (
	input 			CLOCK_50,
	input  [3:0]	SW,
	input  [3:0] 	KEY,
	output [6:0]	HEX0
);

	wire [3:0]		im1;


counter small_count (
	.clk(KEY[0]),
	.reset(KEY[1]),
	.count(im1)
);

seven_seg_decoder decoder (
	.x(im1),
	.hex_LEDs(HEX0)
);

endmodule

module d_flip_flop(
	input clk, 
	input d, 
	output reg q
);

	always @(posedge clk) begin
		q <= d;
	end 

endmodule


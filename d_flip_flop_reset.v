 module d_flip_flop_reset(
	input clk,
	input reset_n,
	input d,
	output reg q
);


	always @(posedge clk) begin
		if(!reset_n) q <= 0;
		else q <= d;
		
	end 
	
endmodule 
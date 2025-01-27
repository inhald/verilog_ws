module d_latch_enable(
		input d,
		input clk,
		input enable,
		output reg q
);
		
		always @(posedge clk) begin
			if(enable) q <= d;
		end
		
endmodule
		
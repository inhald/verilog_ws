module counter (
	input 		clk,
	input			reset,
	output reg [3:0]	count

);

	always @(posedge clk or negedge reset) begin
		if (!reset)
			count <= 4'b0;		
		else 
		count <= count + 4'd1;
	
	end

endmodule 
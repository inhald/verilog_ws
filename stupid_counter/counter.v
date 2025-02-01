module counter (
	input clk,
	input	reset,
	output reg [3:0] count

);

	always @(posedge clk or negedge reset) begin
		if (!reset) begin
			count <= 4'b0;
		end
		else if (count == 4'd9) begin
			count <= 4'b0;
		end
		else begin 
			count <= count + 4'd1;
		end
	
	end

endmodule 
/* Clock division module: limits rate of given clock signal (CLOCK_50) to 1 Khz */

module clock_divider (
	input clk, 
	input rst_n,
  
  output reg clk_ms
  
);

  reg tq = 1'b0; 
  parameter countQ = 20;
  reg [15:0] count = 0;

  always @(posedge clk or negedge rst_n) begin
    
    if(!rst_n) begin
      count <= 0;
      clk_ms <= 1'b1;
    end    
    else if (count <= countQ/2) begin
      clk_ms <= 1'b1;
      count <= count + 1;
    end
    else if (count <= countQ) begin
      clk_ms <= 1'b0;
      count <= count + 1;
    end
    else begin
      count <= 0;
    end
  
  
  end

endmodule

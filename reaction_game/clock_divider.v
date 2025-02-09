/* Clock division module: limits rate of given clock signal (CLOCK_50) to 1 Khz */

module clock_divider (clk, rst_n, clk_ms);
	input clk;
	input rst_n;
  
  output reg clk_ms;
  parameter countQ = 50000; //use 20 for sim, 50000 for physical
  reg [31:0] count = 0;

  always @(posedge clk or negedge rst_n) begin
    
    if(!rst_n) begin
      count <= 0;
      clk_ms <= 1'b0;
    end else begin    
      if (count <= countQ/2) begin
        clk_ms <= 1'b0;
        count <= count + 1;
      end
      else if (count < countQ) begin
        clk_ms <= 1'b1;
        count <= count + 1;
      end
      else begin
        count <= 0;
        clk_ms <= 1'b0;
      end
    end
  
  
  end

endmodule

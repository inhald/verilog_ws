/* Clock division module: limits rate of given clock signal (CLOCK_50) to 1 Khz */

module clock_divider (
	input clk, 
	input rst_n,
  
  output reg clk_ms
  
);

  reg [15:0] countQ = 16'd49999;
  reg tq = 1'b0; 

  always @(posedge clk or negedge rst_n) begin
    
    if(!rst_n) begin
      countQ <= 16'd49999;
      clk_ms <= 1'b0;
    end
    
    else if (countQ == 16'd0) begin
      clk_ms <= 1'b1;
      tq = 1'b1;
      countQ <= 16'd49999;
    end
      
    else if (tq == 1'b1) begin
      clk_ms <= 1'b0;
      tq <= 1'b0;
    end
    
    else begin
      countQ <= countQ - 16'd1;
    end 
  
  
  end

endmodule

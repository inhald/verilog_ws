module blinking (clk,enable,led);
  input clk, enable;
  output reg led;
  
  
  always @(posedge clk) begin
    if(enable) begin
      led = ~led;
    end
  end


endmodule

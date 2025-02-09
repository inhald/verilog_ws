module counter (clk, reset_n, start_n, ms_count);
  input clk, reset_n, start_n;
  output reg [19:0] ms_count;
 
  reg tq = 1'b1;
  
  initial begin
    ms_count <= 19'd0;
  end
  
  always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) begin
      ms_count <= 19'd0;
    end
    else if (tq == 1'b1) begin
      ms_count <= ms_count + 19'd1;
    end
    else begin
      ms_count <= ms_count;
    end
  end
  
  always @ (negedge start_n) begin
    tq = ~tq;
  end
  
endmodule

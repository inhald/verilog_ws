/* Binary to BCD converter 
   Max binary 2^20 - 1 = 1 048 575 > 999 999
   Thus 6 tetrads or 24 bit register is required.
*/

module hex_to_bcd_converter(
  input wire clk, reset,
  input wire [19:0] hex_number,
  output [3:0] bcd_digit_0, bcd_digit_1, bcd_digit_2, bcd_digit_3, bcd_digit_4, bcd_digit_5
);

  reg [3:0] bcd_digits [5:0];
  
  integer i,k;
  
//  assign {bcd_digit_0, bcd_digit_1, bcd_digit_2, bcd_digit_3, bcd_digit_4, bcd_digit_5} 
//  = {bcd_digits[0], bcd_digits[1], bcd_digits[2], bcd_digits[3], bcd_digits[4], bcd_digits[5]};

   assign bcd_digit_0 = bcd_digits[0];
   assign bcd_digit_1 = bcd_digits[1];
   assign bcd_digit_2 = bcd_digits[2];
   assign bcd_digit_3 = bcd_digits[3];
   assign bcd_digit_4 = bcd_digits[4];
   assign bcd_digit_5 = bcd_digits[5];
  
      
  
  always @(*) begin
  
    for (i = 0; i <= 5; i = i + 1) begin
      bcd_digits[i] = 4'd0;
    end
  
    
  
    for (i = 19; i >= 0; i = i - 1) begin
      
      for (k = 5; k >= 0; k = k - 1) begin
        
        if(bcd_digits[k] >= 4'd5) begin
          bcd_digits[k] = bcd_digits[k] + 4'd3;
        end
        
      end
      
      for (k = 5; k >= 1; k = k - 1) begin
        bcd_digits[k] = bcd_digits[k] << 1;
        bcd_digits[k][0] = bcd_digits[k-1][3];
      end
      
      bcd_digits[0] = bcd_digits[0] << 1 | hex_number[i];
      
    
    end

  
   end
   
//  initial begin
//    $monitor("hex_number=%d, BCD: %d %d %d %d %d %d", 
//         hex_number, 
//         bcd_digits[5], bcd_digits[4], bcd_digits[3], 
//         bcd_digits[2], bcd_digits[1], bcd_digits[0]);
//  end
// 

endmodule

  
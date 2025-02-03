module reaction_time_tester(
  input CLOCK_50,
  input [2:0] KEY,
  output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);

  wire clk_en;
  wire [19:0] ms;
  wire [3:0] digit0, digit1, digit2, digit3, digit4, digit5;
  
clock_divider clk_div (
  .clk(CLOCK_50),
  .rst_n(KEY[0]),
  .clk_ms(clk_en)
);
   
counter count (
  .clk(clk_en),
  .reset_n(KEY[0]),
  .start_n(KEY[1]),
  .stop_n(KEY[2]),
  .ms_count(ms)
);

hex_to_bcd_converter convert (
  .clk(clk_en),
  .reset(KEY[0]),
  .hex_number(ms),
  
  .bcd_digit_0(digit0),
  .bcd_digit_1(digit1),
  .bcd_digit_2(digit2),
  .bcd_digit_3(digit3),
  .bcd_digit_4(digit4),
  .bcd_digit_5(digit5)
);

seven_seg_decoder decoder0 (
  .x(digit0),
  .hex_LEDs(HEX0)
);

seven_seg_decoder decoder1 (
  .x(digit1),
  .hex_LEDs(HEX1)
);

seven_seg_decoder decoder2 (
  .x(digit2),
  .hex_LEDs(HEX2)
);

seven_seg_decoder decoder3 (
  .x(digit3),
  .hex_LEDs(HEX3)
);

seven_seg_decoder decoder4 (
  .x(digit4),
  .hex_LEDs(HEX4)
);

seven_seg_decoder decoder5 (
  .x(digit5),
  .hex_LEDs(HEX5)
);

endmodule   
   
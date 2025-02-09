module reaction_game (CLOCK_50, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, 
LEDR);
  input CLOCK_50;
  input [3:0] KEY; 
  output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  output [9:0] LEDR;
  
  wire clk_en;
  
  reg [3:0] digits [5:0]; //diplayed on SEG
  wire [3:0] w_blink [5:0]; //Blinking
  wire [3:0] t_digits [5:0]; //Timer
  
  
  //states
  parameter BLINKING = 3'b000; 
  parameter CHEATING_1 = 3'b001;
  parameter CHEATING_2 = 3'b011;
  parameter RAND_TIMER = 3'b010;
  parameter RESET = 3'b110;
  parameter TIME_DISPLAY = 3'b100;
  parameter WINNER_DISPLAY_TIME = 3'b101;
  
  reg [2:0] ps = RESET;
  reg [2:0] ns = RESET;
  
  //Game Logic
  reg player1_win, player2_win;
  reg [4:0] win1 = 5'b00000, win2 = 5'b00000;
  reg [19:0] winner_ms; 
  
  //Timers
  wire [19:0] ms;
  wire [19:0] display_ms;
  reg pause_n;
  reg rst_ms_n;
  
  reg t_pause_n = 1;
  
  //Random
  wire [13:0] rand_time; 
  wire rnd_ready;
  reg [13:0] sampled_rand;
  
  //HEX Leds
  reg [1:0] hex_sel = 2'b00;
  reg display_counter_start;
  wire w_display_counter_start = display_counter_start;
  
  wire [19:0] ms_for_bcd;
  assign ms_for_bcd = (ps == WINNER_DISPLAY_TIME) ? winner_ms : display_ms;
  
  
  //clock divider
  
  clock_divider clk_div ( .clk(CLOCK_50), .rst_n(KEY[1]), .clk_ms(clk_en) );
  
  
  //Blinking
  
  blinkHEX #(.factor(200) ) (.ms_clk(clk_en), .Reset_n(KEY[1]), .d0(w_blink[0]), 
  .d1(w_blink[1]), .d2(w_blink[2]), .d3(w_blink[3]), .d4(w_blink[4]),.d5(w_blink[5]));
  
  
  //Blinking will take place for 1 s => require counter
  counter t_count ( .clk(clk_en), .reset_n(rst_ms_n), .start_n(t_pause_n), .ms_count(ms) );
 
  //Random values
  random rng ( .clk(clk_en), .reset_n(KEY[1]), .random(rand_time), .rnd_ready(rnd_ready) );
  
  //Timer 
  counter d_count ( .clk(clk_en), .reset_n(display_counter_start), .start_n(pause_n), .ms_count(display_ms) );
  
  hex_to_bcd_converter h2b( .clk(clk_en), .reset(KEY[1]), .hex_number(ms_for_bcd), .bcd_digit_0(t_digits[0]), 
  .bcd_digit_1(t_digits[1]), .bcd_digit_2(t_digits[2]), .bcd_digit_3(t_digits[3]),
  .bcd_digit_4(t_digits[4]), .bcd_digit_5(t_digits[5]) );
  
  
  //decoding digits
  seven_seg_decoder dec0(.x(digits[0]), .hex_LEDs(HEX0));
  seven_seg_decoder dec1(.x(digits[1]), .hex_LEDs(HEX1));
  seven_seg_decoder dec2(.x(digits[2]), .hex_LEDs(HEX2));
  seven_seg_decoder dec3(.x(digits[3]), .hex_LEDs(HEX3));
  seven_seg_decoder dec4(.x(digits[4]), .hex_LEDs(HEX4));
  seven_seg_decoder dec5(.x(digits[5]), .hex_LEDs(HEX5));
  
  
  //LEDRs
  assign LEDR[4:0] = win1;
  assign LEDR[9:5] = {win2[0], win2[1], win2[2], win2[3], win2[4]}; 
  
  
  always @ (posedge clk_en, negedge KEY[1]) begin
    if(!KEY[1]) begin
      sampled_rand <= 14'd0;
    end else if (rnd_ready) begin
      sampled_rand <= rand_time;
    end
  end
  
   
  always @ (posedge clk_en, negedge KEY[1]) begin 
    if(!KEY[1]) begin
      ps <= RESET;
    end else begin
      ps <= ns;
    end
  end
  
  always @(posedge clk_en, negedge KEY[1]) begin
    if(!KEY[1]) begin
      win1 <= 5'b00000;
      win2 <= 5'b00000;
    end
    else if (player1_win == 1) begin
      win1 <= (win1 << 1) | 5'b00001;
    end else if (player2_win == 1) begin
      win2 <= (win2 << 1) | 5'b00001;
    end
  
  
  end
  

  always @ (*) begin
    player1_win = 0;
    player2_win = 0;
    display_counter_start = 1;
    rst_ms_n = 1;
    
    case(ps)
      BLINKING:begin
                if (ms >= 2000) begin
                  ns = RAND_TIMER;
                end
                else begin
                  ns = BLINKING;
                end
              end
      RAND_TIMER: begin
                    if( !KEY[0] && ms < (2000+ sampled_rand) ) begin
                      ns = CHEATING_1;
                    end else if ( !KEY[3] && ms < (2000+sampled_rand) ) begin
                      ns = CHEATING_2;
                    end else if(ms > (2000 + sampled_rand)) begin
                      ns = TIME_DISPLAY;
                      display_counter_start = 0;
                    end
                    else begin
                      ns = RAND_TIMER;
                    end
                    
                  end
      TIME_DISPLAY: begin
                      display_counter_start = 1;
                      
                      if(!KEY[0]) begin
                        ns = WINNER_DISPLAY_TIME;
                        player1_win = 1;
                        winner_ms = display_ms;
                      end else if(!KEY[3]) begin
                        ns = WINNER_DISPLAY_TIME;
                        player2_win = 1;
                        winner_ms = display_ms;
                      end else begin
                        ns = TIME_DISPLAY;
                      end
                      
                      
                    end
        WINNER_DISPLAY_TIME: begin
                               display_counter_start=1;
                               player1_win = 0;
                               player2_win = 0;
                               
                               if (!KEY[2]) begin
                                ns = BLINKING;
                                rst_ms_n = 0;
                                display_counter_start = 0;
                               end else begin
                                ns = WINNER_DISPLAY_TIME;
                               end
                             end
      CHEATING_1: begin
                    if(!KEY[2]) begin
                      ns = BLINKING;
                      rst_ms_n = 0;
                      display_counter_start = 0;
                    end else begin
                      ns = CHEATING_1;
                    end
                  end
      CHEATING_2: begin
                    if(!KEY[2]) begin
                      ns = BLINKING;
                      rst_ms_n = 0;
                      display_counter_start = 0;
                    end else begin
                      ns = CHEATING_2;
                    end
                  end
      RESET: begin
              rst_ms_n = 0;
              ns = BLINKING;
              display_counter_start = 0;
              
              
              player1_win = 0;
              player2_win = 0;
             end
      default: ns = RESET;
    endcase   
  end
  
  integer i;
  
  always @ (*) begin
    
    case (ps)
      BLINKING: begin
                  for(i=0; i <=5; i = i + 1) begin
                    digits[i] = w_blink[i];
                  end
                end
      CHEATING_1: begin
                    for(i = 0; i <= 5; i = i + 1) begin
                      digits[i] = 4'd1;                
                    end
                  end
      CHEATING_2: begin
                    for(i = 0; i <= 5; i = i + 1) begin
                      digits[i] = 4'd2;
                    end
                  end
      RAND_TIMER: begin
                    for(i = 0; i <= 5; i = i + 1) begin
                      digits[i] = 4'd15;
                    end
                  end
      TIME_DISPLAY: begin
                      for(i = 0; i <= 5; i = i + 1) begin
                        digits[i] = t_digits[i];
                      end
                    end
      WINNER_DISPLAY_TIME: begin
                              for(i = 0; i <=5; i = i + 1) begin
                                digits[i] = t_digits[i];
                              end
                           end
      default: begin
                  for(i = 0; i <= 5; i = i + 1) begin
                    digits[i] = 4'd15;
                  end
               end
    endcase
  
  end
    
  
  
  
 
  
  
  
  
endmodule 
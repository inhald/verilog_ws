module seven_seg_decoder(x, hex_LEDs);
	input [3:0] x;
	output reg [6:0] hex_LEDs;

	always @(*) begin
		case(x)
			4'd0: hex_LEDs[6:0] = 7'b1000000;
			4'd1: hex_LEDs[6:0] = 7'b1111001;
			4'd2: hex_LEDs[6:0] = 7'b0100100;
			4'd3: hex_LEDs[6:0] = 7'b0110000;
			4'd4: hex_LEDs[6:0] = 7'b0011001;
			4'd5: hex_LEDs[6:0] = 7'b0010010;
			4'd6: hex_LEDs[6:0] = 7'b0000010;
			4'd7: hex_LEDs[6:0] = 7'b1111000;
			4'd8: hex_LEDs[6:0] = 7'b0000000;
			4'd9: hex_LEDs[6:0] = 7'b0010000;
			default: hex_LEDs[6:0] = 7'b1111111;		
		endcase
	end
endmodule

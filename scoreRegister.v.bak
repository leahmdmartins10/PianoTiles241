// this module will display the score of the user on the seven segment HEX displays
// by doing this it will require less VGA display work and more space for the actual game

module score(clock, resetn, startn, current_state, increment, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, Q);
	input clock, resetn, startn, increment;
	input [6:0] currentState;
	output reg[23:0] Q;
	
	reg incrementdigits
	
	reg[3:0] digit_0, digit_1, digit_2, digit_3, digit_4, digit_5;
	output[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	// assigning each 4 bit digit to register Q in increments of 4, will display the digits
	// onto hex display
	
	always @(*) begin
		digit_0 = Q[3:0];
		digit_1 = Q[7:4];
		digit_2 = Q[11:8];
		digit_3 = Q[15:12];
		digit_4 = Q[19:16];
		digit_5 = Q[23:20];
		
		if(digit_0 > 4'b1001) begin
			digit_1 = digit_1 + 4'b0001; // carry over the one
			digit_0 = digit_0 - 4'1010; // remove the 10th carry over
		end
		if(digit_1 > 4'b1001) begin
			digit_2 = digit_2 + 4'b0001; // carry over the one
			digit_1 = digit_1 - 4'1010; // remove the 10th carry over
		end
		if(digit_2 > 4'b1001) begin
			digit_3 = digit_3 + 4'b0001; // carry over the one
			digit_2 = digit_2 - 4'1010; // remove the 10th carry over
		end
		if(digit_3 > 4'b1001) begin
			digit_4 = digit_4 + 4'b0001; // carry over the one
			digit_3 = digit_3 - 4'1010; // remove the 10th carry over
		end
		if(digit_4 > 4'b1001) begin
			digit_5 = digit_4 + 4'b0001; // carry over the one
			digit_4 = digit_5 - 4'1010; // remove the 10th carry over
		end
		if(digit_5 > 4'b1001) begin
			digit_0 = 4'b1001;
			digit_1 = 4'b1001;
			digit_2 = 4'b1001;
			digit_3 = 4'b1001;
			digit_4 = 4'b1001;
			digit_5 = 4'b1001;
		end
	end
	
	hexDecoder h0(.c3(digit_0[3]), .c2(digit_0[2]), .c3(digit_0[1]), .c4(digit_0[0]), .s(HEX0));
	hexDecoder h1(.c3(digit_1[3]), .c2(digit_1[2]), .c3(digit_1[1]), .c4(digit_1[0]), .s(HEX1));
	hexDecoder h2(.c3(digit_2[3]), .c2(digit_2[2]), .c3(digit_2[1]), .c4(digit_2[0]), .s(HEX2));
	hexDecoder h3(.c3(digit_3[3]), .c2(digit_3[2]), .c3(digit_3[1]), .c4(digit_3[0]), .s(HEX3));
	hexDecoder h4(.c3(digit_4[3]), .c2(digit_4[2]), .c3(digit_4[1]), .c4(digit_4[0]), .s(HEX4));
	hexDecoder h5(.c3(digit_5[3]), .c2(digit_5[2]), .c3(digit_5[1]), .c4(digit_5[0]), .s(HEX5));
	
	always@(posedge clock) begin
		if(!resetn | (!startn & current_state == 5'd0)) begin
			incrementdigits <= 1'b0;
			Q <= 24'b000000000000000000000000;
		end
		else if(increment) begin
			if(incrementdigits) begin
				Q <= Q + 1'b1;
				incrementdigits <= 1'b0;
			end
			else
				incrementdigits <= incrementdigits + 1'b1;
		end
	end
	
endmodule

module hexDecoder(c3, c2, c1, c0, s);
	input c3, c2, c1, c0;
	output [6:0] s //segments
	
	//assignments for each segments
	assign s[0] = ((~c3&~c2&~c1&c0)|(~c3&c2&~c1&~c0)|(c3&~c2&c1&c0)|(c3&c2&~c1&c0));
	assign s[1] = ((~c3&c2&~c1&c0)|(~c3&c2&c1&~c0)|(c3&~c2&c1&c0)|(c3&c2&~c1&~c0)|(c3&c2&c1&~c0)|(c3&c2&c1&c0));
	assign s[2] = ((~c3&~c2&c1&~c0)|(c3&c2&~c1&~c0)|(c3&c2&c1&~c0)|(c3&c2&c1&c0));
	assign s[3] = ((~c3&~c2&~c1&c0)|(~c3&c2&~c1&~c0)|(~c3&c2&c1&c0)|(c3&~c2&c1&~c0)|(c3&c2&c1&c0));
	assign s[4] = ((~c3&~c2&~c1&c0)|(~c3&~c2&c1&c0)|(~c3&c2&~c1&~c0)|(~c3&c2&~c1&c0)|(~c3&c2&c1&c0)|(c3&~c2&~c1&c0));
	assign s[5] = ((~c3&~c2&~c1&c0)|(~c3&~c2&c1&~c0)|(~c3&~c2&c1&c0)|(~c3&c2&c1&c0)|(c3&c2&~c1&c0));
	assign s[6] = ((~c3&~c2&~c1&~c0)|(~c3&~c2&~c1&c0)|(~c3&c2&c1&c0)|(c3&c2&~c1&~c0));
	
endmodule

// this module will display the score of the user on the seven segment HEX displays
// by doing this it will require less VGA display work and more space for the actual game

module score(clock, resetn, startn, current_state, increment, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, Q);
	input clock, resetn, startn, increment;
	input [6:0] current_state;
	output reg[23:0] Q;
	
	reg incrementdigits;
	
	reg[3:0] d0, d1, d2, d3, d4, d5;
	output[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	// assigning each 4 bit digit to register Q in increments of 4, will display the digits
	// onto hex display
	
	always @(*) begin
		d0 = Q[3:0];
		d1 = Q[7:4];
		d2 = Q[11:8];
		d3 = Q[15:12];
		d4 = Q[19:16];
		d5 = Q[23:20];
		
		if(d0 > 9) begin
			d1 = d1 + 1; // carry over the one
			d0 = d0 - 10; // remove the 10th carry over
		end
		if(d1 > 9) begin
			d2 = d2 + 1; // carry over the one
			d1 = d1 - 10; // remove the 10th carry over
		end
		if(d2 > 9) begin
			d3 = d3 + 1; // carry over the one
			d2 = d2 - 10; // remove the 10th carry over
		end
		if(d3 > 9) begin
			d4 = d4 + 1; // carry over the one
			d3 = d3 - 10; // remove the 10th carry over
		end
		if(d4 > 9) begin
			d5 = d4 + 1; // carry over the one
			d4 = d5 - 10; // remove the 10th carry over
		end
		if(d5 > 4'b1001) begin
			d0 = 4'b1001;
			d1 = 4'b1001;
			d2 = 4'b1001;
			d3 = 4'b1001;
			d4 = 4'b1001;
			d5 = 4'b1001;
		end
	end
	
	hexDecoder h0(.c3(d0[3]), .c2(d0[2]), .c1(d0[1]), .c0(d0[0]), .s(HEX0));
	hexDecoder h1(.c3(d1[3]), .c2(d1[2]), .c1(d1[1]), .c0(d1[0]), .s(HEX1));
	hexDecoder h2(.c3(d2[3]), .c2(d2[2]), .c1(d2[1]), .c0(d2[0]), .s(HEX2));
	hexDecoder h3(.c3(d3[3]), .c2(d3[2]), .c1(d3[1]), .c0(d3[0]), .s(HEX3));
	hexDecoder h4(.c3(d4[3]), .c2(d4[2]), .c1(d4[1]), .c0(d4[0]), .s(HEX4));
	hexDecoder h5(.c3(d5[3]), .c2(d5[2]), .c1(d5[1]), .c0(d5[0]), .s(HEX5));
	
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
	output [6:0] s; //segments
	
	//assignments for each segments
	assign s[0] = ((~c3&~c2&~c1&c0)|(~c3&c2&~c1&~c0)|(c3&~c2&c1&c0)|(c3&c2&~c1&c0));
	assign s[1] = ((~c3&c2&~c1&c0)|(~c3&c2&c1&~c0)|(c3&~c2&c1&c0)|(c3&c2&~c1&~c0)|(c3&c2&c1&~c0)|(c3&c2&c1&c0));
	assign s[2] = ((~c3&~c2&c1&~c0)|(c3&c2&~c1&~c0)|(c3&c2&c1&~c0)|(c3&c2&c1&c0));
	assign s[3] = ((~c3&~c2&~c1&c0)|(~c3&c2&~c1&~c0)|(~c3&c2&c1&c0)|(c3&~c2&c1&~c0)|(c3&c2&c1&c0));
	assign s[4] = ((~c3&~c2&~c1&c0)|(~c3&~c2&c1&c0)|(~c3&c2&~c1&~c0)|(~c3&c2&~c1&c0)|(~c3&c2&c1&c0)|(c3&~c2&~c1&c0));
	assign s[5] = ((~c3&~c2&~c1&c0)|(~c3&~c2&c1&~c0)|(~c3&~c2&c1&c0)|(~c3&c2&c1&c0)|(c3&c2&~c1&c0));
	assign s[6] = ((~c3&~c2&~c1&~c0)|(~c3&~c2&~c1&c0)|(~c3&c2&c1&c0)|(c3&c2&~c1&~c0));
	
endmodule

module shift(input shift, clk, resetn, startn, correct_in,
				input [5:0] current_st,
				output reg [2:0] line_0,
				output reg [2:0] line_1,
				output reg [2:0] line_2,
				output reg [2:0] line_3,
				output reg [2:0] line_4,
				output reg [2:0] line_5,
				output reg [2:0] line_6);
				
				reg [4:0] d;
				initial d = 5'd21; // decimal value of 21 in a 5 bit signal
				
				always @(posedge clk) begin
					if(d == 5'b00000)
						d <= 5'b00001;
					else
						d <= {d[3:0], d[4] ^ d[3]};
				end
				
				always @(posedge clk) begin
					if(!resetn | (!startn & current_st == 5'd0)) begin
						// reset or it's the start of the game
						line_0 <= 3'b000;
						line_1 <= 3'b000;
						line_2 <= 3'b000;
						line_3 <= 3'b000;
						line_4 <= 3'b000;
						line_5 <= 3'b000;
						line_6 <= 3'b000;
						end
					else if(correct_in)
						// if it's the correct input the bottom line should be reset
						line_6 <= 3'b000;
					else if(shift) begin
						line_0 <= {d[3], d[1]} + 1'b1;
						line_1 <= line_0;
						line_2 <= line_1;
						line_3 <= line_2;
						line_4 <= line_3;
						line_5 <= line_4;
						line_6 <= line_5;
					end
				end
endmodule

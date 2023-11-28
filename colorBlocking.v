module colorBlock(input clock, color_block_go, resetn, startn,
							input [2:0] line_id,
							input [5:0] offset,
							input [5:0] current_St,
							output reg colour_block_done,
							output reg [8:0] x,
							output reg [7:0] y);
							
							reg [8:0] start_x, end_x;
							reg [7:0] start_y;
							
							always @(*) begin
								start_y = 200 + offset;
								case(line_id)
									3'b001: begin
										start_x = 120;
										end_x = 139;
									end
									3'b010: begin
										start_x = 140;
										end_x = 159;
									end
									3'b011: begin
										start_x = 160;
										end_x = 179;
									end
									3'b100: begin
										start_x = 180;
										end_x = 199;
									end
									default: begin
										start_x = 140;
										end_x = 159;
									end
								endcase
							end
							
							always @(posedge clock) begin
								if(!resetn | (!startn & current_St == 5'd0) | !color_block_go) begin
									colour_block_done <= 1'b0;
									y <= start_y;
									x <= start_x;
								end
								else begin
									if(x == end_x) begin
										if(y == 239)
											colour_block_done <= 1'b1; // the max coordinates have been reached, updating the register
										else begin
											x <= start_x;
											y <= y + 1'b1; // slowly incrementing the y values
										end
									end
									else begin
										x <= x + 1'b1;
									end
								end
							end
endmodule

module colorLine(input clock, color_line_go,
					  input [2:0] line_6,
					  output reg color_line_done,
					  output reg [8:0] x,
					  output reg [7:0] y);
					  
					  reg [8:0] start_x, end_x;
					  
					  always @(*) begin
							case(line_6)
								3'b001: begin
									start_x = 120;
									end_x = 139;
								end
								3'b010: begin
									start_x = 140;
									end_x = 159;
								end
								3'b011: begin
									start_x = 160;
									end_x = 179;
								end
								3'b100: begin
									start_x = 180;
									end_x = 199;
								end
								default: begin
									start_x = 140;
									end_x = 159;
								end
							endcase
					end
					
					always @(posedge clock) begin
						if(!color_line_go) begin
							color_line_done <= 1'b0;
							x <= start_x;
							y <= 0;
						end
						else begin
							if(x == end_x) begin
								if(y == 239)
									color_line_done <= 1'b1;
								else begin
									x <= start_x;
									y <= y + 1'b1;
								end
							end
							else begin
								x <= x + 1'b1;
							end
						end
				   end
endmodule

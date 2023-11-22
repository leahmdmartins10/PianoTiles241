// drawing the columns

// resolution of the screen is 320x240 via the vga controller resolution

module draw_cont(input cock, resetn, startn, draw_go,
						input [5:0] draw_done, // we need a draw done for each draw
						erase_done, draw_color,
						erase_color,
						
						input [8:0] draw_0x, // the max x dimension is 320 therefore, 9'b101000000
						draw_1x,
						draw_2x,
						draw_3x,
						draw_4x,
						draw_5x,
						
						// need an erase for each xdraw
						erase_0x,
						erase_1x,
						erase_2x,
						erase_3x,
						erase_4x,
						erase_5x,
						
						input [7:0] draw_0y, // the max y dimension is 240 therefore, 8'b11110000
						draw_1y,
						draw_2y,
						draw_3x,
						draw_4x,
						draw_5x,
						
						// need an erase for each ydraw
						erase_0y,
						erase_1y,
						erase_2y,
						erase_3y,
						erase_4y,
						erase_5y,
						
						input [5:0] main_St
						output reg isDrawingDone, vga_en,
						output reg [5:0] draw_en, erase_en,
						
						output reg [8:0] xOutput,
						output reg [7:0] yOutput,
						output reg [2:0] color_output,
						output reg [4:0] current_St);
						
						reg [4:0] next_st;
						
						// initialize all of the states
						
						localparam  WAIT = 4'd0;
										ERASE_0 = 4'd1;
										DRAW_0 = 4'd2;
										ERASE_1 = 4'd3;
										DRAW_1 = 4'd4;
										ERASE_2 = 4'd5;
										DRAW_2 = 4'd6;
										ERASE_3 = 4'd7;
										DRAW_3 = 4'd8;
										ERASE_4 = 4'd9;
										DRAW_4 = 4'd10;
										ERASE_5 = 4'd11;
										DRAW_5 = 4'd12;
										DONE = 4'd13;

						// initializing the beginning state as "WAIT"
						initial current_st = WAIT;
						
						always @(*)
						begin: // start of state_table
							case (current_state)
								WAIT: next_st = draw_go ? ERASE_0 : WAIT;
								
								ERASE_0: next_st = erase_done[0] ? DRAW_0 : ERASE_0;
								DRAW_0: next_st = draw_done[0] ? ERASE_1 : DRAW_0;
								
								ERASE_1: next_st = erase[1] ? DRAW_1: ERASE_1
								DRAW_1: next_st = draw_done[1] ? ERASE_2 : DRAW_1;
								
								ERASE_2: next_st = erase_done[2] ? DRAW_2: ERASE_2;								
								DRAW_2: next_st = draw_done[2] ? ERASE_3 : DRAW_2;
								
								ERASE_3: next_st = erase_done[3] ? DRAW_3 : ERASE_3;
								DRAW_3: next_st = draw_done[3] ? ERASE_4: DRAW_3;
								
								ERASE_4: next_st = erase_done[4] ? DRAW_4 : ERASE_4;
								DRAW_4: next_st = draw_done[4] ? ERASE_5 : DRAW_4;
								
								ERASE_5: next_st = erase_done[5] ? DRAW_5: ERASE_5;
								DRAW_5: next_st = draw_done[5] ? DONE : DRAW_5;
								
								DONE: next_st = draw_go ? DONE : WAIT;
								
								default: next_st = WAIT;
							endcase
					end // end of state table
					
					always @(*) begin: // enabling all signals
						isDrawingDone = 1'b0;
						vga_en = 1'b0;
						draw_en = 6'b000000;
						erase_en = 6'b000000;
						
						case (current_state)
							ERASE_0 : begin
								erase_en[0] = 1'b1;
								x_out = erase_0x;
								y_out = erase_0y;
								color_out = {erase_color[0], erase_color[0], erase_color[0]};
								vga_en = 1'b1;
								
							end
							DRAW_0 : begin
								draw_en[0] = 1'b1;
								x_out = draw_0x;
								y_out = draw_0y;
								color_out = {draw_color[0], draw_color[0], draw_color[0]};
								vga_en = 1'b1;
						   end
							
							ERASE_1 : begin
								erase_en[1] = 1'b1;
								x_out = erase_1x;
								y_out = erase_1y;
								color_out = {erase_color[1], erase_color[1], erase_color[1]};
								vga_en = 1'b1;
							end
							DRAW_1 : begin
								draw_en[1] = 1'b1;
								x_out = draw_1x;
								y_out = draw_1y;
								color_out = {draw_color[1], draw_color[1], draw_color[1]};
								vga_en = 1'b1
						   end
							
							ERASE_2 : begin
								erase_en[2] = 1'b1;
								x_out = erase_2x;
								y_out = erase_2y;
								color_out = {erase_color[2], erase_color[2], erase_color[2]};
								vga_en = 1'b1;
							end
							DRAW_2 : begin
								draw_en[2] = 1'b1;
								x_out = draw_2x;
								y_out = draw_2y;
								color_out = {draw_color[2], draw_color[2], draw_color[2]};
								vga_en = 1'b1;
							end
							
							ERASE_3 : begin
								erase_en[3] = 1'b1;
								x_out = erase_3x;
								y_out = erase_1y;
								color_out = {erase_color[3], erase_color[3], erase_color[3]};
								vga_en = 1'b1;
							end							
							DRAW_3 : begin
								draw_en[3] = 1'b1;
								x_out = draw_3x;
								y_out = draw_3y;
								color_out = {draw_color[3], draw_color[3], draw_color[3]};
								vga_en = 1'b1;
						   end
							
							ERASE_4 : begin
								erase_en[4] = 1'b1;
								x_out = erase_4x;
								y_out = erase_4y;
								color_out = {erase_color[4], erase_color[4], erase_color[4]};
								vga_en = 1'b1;
							end
							DRAW_4 : begin
								draw_en[4] = 1'b1;
								x_out = draw_4x;
								y_out = draw_4y;
								color_out = {draw_color[4], draw_color[4], draw_color[4]};
								vga_en = 1'b1;
							end
							
							ERASE_5 : begin
								erase_en[5] = 1'b1;
								x_out = erase_5x;
								y_out = erase_5y;
								color_out = {erase_color[5], erase_color[5], erase_color[5]};
								vga_en = 1'b1;
							end
							DRAW_5 : begin
								draw_en[5] = 1'b1;
								x_out = draw_5x;
								y_out = draw_5y;
								color_out = {draw_color[5], draw_color[5], draw_color[5]};
								vga_en = 1'b1;		
							end
							
							DONE : begin
								isDrawingDone = 1'b1;
								x_out = 9'b0;
								y_out = 8'b0;
								color_out = 3'b111;
							end
							default: begin
								x_out = 9'b0;
								y_out - 8'b0;
								color_out = 3'b111;
							end
						endcase
				end // end enabling signals
				
				// setting the current state
				always @(posedge clock) begin: //state FF
					if(!resetn | (!startn & main_state == 5'd0))
						current_state <= WAIT;
					else
						current_state <= next_st;
				end // end of the flip flop
endmodule

module drawProg(input clock, draw_en,
					input [3:0] line_id,
					input [2:0] line_above,
					input [5:0] offset,
					
					output reg [8:0] x,
					output reg [7:0] y,
					output reg color, drawdone);
					
					reg [7:0] line_id_offset;
					
					localparam black = 1'b0,
									while = 1'b1;
					
					always @(*)
						line_id_ofset = line_id * 40;
					
					always @(*)
						y = line_id_offset + offset;
						
					always @(posedge clock) begin
						if(!draw_en)
							case(line_above)
								3'b000: begin
									x <= 140;
									draw_done <= 1'b0;
									color <= white;
								end
								3'b001: begin
									x <= 120;
									draw_done <= 1'b0;
									color <= black;
								end
								3'b010: begin
									x <= 140:
									draw_done <= 1'b0;
									color <= black;
								end
								3'b011: begin
									x <= 160;
									draw_done <= 1'b0;
									color <= black;
								end
								3'b100: begin
									x <= 180;
									draw_done = <1'b0;
									color <= black;
								end
								default: begin
									x <= 140;
									draw_done <= 1'b0;
									color <= white;
								end
						endcase
					else
						// start incrementing x values
						
						case(line_above)
							3'b000:
								draw_done <= 1'b1;
							3'b001: begin
								if(x == 139)
									draw_done <= 1'b1;
								else
									x += 1;
							end
							3'b010: begin
								if(x == 159)
									draw_done <= 1'b1;
								else
									x += 1;
							end
							3'b011: begin
								if(x == 179)
									draw_done <= 1'b1;
								else
									x += 1;
							end
							3'b100: begin
								if(x == 199)
									draw_done <= 1'b1;
								else
									x += 1;
							end
							default:
								draw_done <= 1'b1;
					 endcase
				end
endmodule

module eraseProg(input clock, erase_en,
						input[3:0] line_id,
						input [2:0] line_below,
						input [5:0] offset,
						
						output reg [8:0] x,
						output reg [7:0] y,
						output color,
						output reg erase_done);
						
						reg [7:0] line_id_offset;
						
						assign color = 1'b1; // it'll "erase" by drawing white
						
						always @(*)
							line_id_offset = line_id * 40;
						
						always @(*)
							y = line_id_offset + offset;
						
						always @(posedge clock) begin
							if(!erase_en)
								case(line_below)
									3'b000 : begin
										x <= 140;
										erase_done <= 1'b0;
									end
									3'b001 : begin
										x <= 120;
										erase_done <= 1'b0;
									end
									3'b010 : begin
										x <= 140;
										erase_done <= 1'b0;
									end
									3'b011 : begin
										x <= 160;
										erase_done <= 1'b0;
									end
									3'b100 : begin
										x <= 180
										erase_done <= 1'b0;
									end
									default : begin
										x <= 140;
										erase_done <= 1'b0;
									end
							 endcase
						  else
							// start incrementing the x values
							
							case(line_below)
								3'b000:
									erase_done <= 1'b1; // x == 139 after 
								3'b001 : begin
									if(x == 139)
										erase_done <= 1'b1;
									else
										x += 1; // shifting over until x == 139
								end
								3'b010 : begin
									if(x == 159)
										erase_done <= 1'b1;
									else
										x += 1;
								end
								3'b011 : begin
									if(x == 179)
										erase_done <= 1'b1;
									else
										x += 1;
								end
								3'b100 : begin
									if(x == 199)
										erase_done <= 1'b1;
									else
										x += 1;
								end
								default:
									erase_done <= 1'b1;
						endcase
					end
endmodule

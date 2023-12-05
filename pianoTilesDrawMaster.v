module pianoTilesDrawMaster(CLOCK_50, KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
								VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, //for the VGA adapter
								VGA_R, VGA_G, VGA_B); //for the VGA adapter
								
								input CLOCK_50;
								
								input [8:0] KEY;
								input [9:0] SW;
								output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
								
								output VGA_CLK;
								output VGA_HS;
								output VGA_VS;
								output VGA_BLANK_N;
								output VGA_SYNC_N;
								output [7:0] VGA_R;
								output [7:0] VGA_G;
								output [7:0] VGA_B;
								
								wire resetn;
								wire startn;
								
								assign resetn = SW[0]; // this will need to be changed for when the inputs are sent
								assign startn = KEY[0] | KEY [1] | KEY[2] | KEY[3]; // this will need to be changed for when the inputs are sent
								
								wire  reset_screen_done, drawdone, wait_done,
										reset_screen_go, draw_go, wait_go, edge_go, offset_inc,
										check_input_done,
										correct,
										incorrect,
										correct_done,
										incorrect_input_done,
										color_line_done, check_in_go,
										correct_go,
										incorrect_input_go,
										color_line_go;
							
							wire [5:0] offset;
							
							wire [2:0] line_0, line_1, line_2, line_3, line_4, line_5, line_6;
							
							// vga adpater inputs
							
							wire vga_en;
							wire draw_vga_en, reset_vga_en;
							assign vga_en = draw_vga_en | reset_vga_en | color_line_go | correct_go | incorrect_input_go;
							
							reg [8:0] x;
							wire [8:0] x_draw, x_reset, x_line, x_correct, x_incorrect;
							reg [7:0] y;
							wire [7:0] y_draw, y_reset, y_line, y_correct, y_incorrect;
							
							reg [2:0] color;
							wire [2:0] color_draw, color_reset;
							
							always @(posedge CLOCK_50) begin // originally was *, and block statements
								if(reset_screen_go) begin
									x <= x_reset;
									y <= y_reset;
									color <= color_reset;
								end
								else if(draw_go) begin
									x <= x_draw;
									y <= y_draw;
									color = color_draw;
								end
								else if(color_line_go) begin
									x <= x_line;
									y <= y_line;
									color = 3'b100;
								end
								else if(correct_go) begin
									x <= x_correct;
									y <= y_correct;
									color = 3'b111;
								end
								else if(incorrect_input_go) begin
									x <= x_incorrect;
									y <= y_incorrect;
									color = 3'b100;
								end
								else begin
									x <= 1;
									y <= 0;
									color = 3'b111;
								end
							end
							
							vga_adapter VGA(.resetn(resetn),
												 .clock(CLOCK_50),
												 .colour(color),
												 .x(x),
												 .y(y),
												 .plot(vga_en),
												 .VGA_R(VGA_R),
												 .VGA_G(VGA_G),
												 .VGA_B(VGA_B),
												 .VGA_HS(VGA_HS),
												 .VGA_VS(VGA_VS),
												 .VGA_BLANK(VGA_BLANK_N),
												 .VGA_SYNC(VGA_SYNC_N),
												 .VGA_CLK(VGA_CLK));
							defparam VGA.RESOLUTION = "320x240";
							defparam VGA.MONOCHROME = "FALSE";
							defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
							defparam VGA.BACKGROUND_IMAGE = "background.mif";
							
							
							wire [5:0] current_state;
							wire [23:0] Q;
							
							all_draw d0(.clock(CLOCK_50),
											.resetn(resetn),
											.startn(startn),
											.draw_go(draw_go),
											.offset(offset[5:0]),
											.line_0(line_0[2:0]),
											.line_1(line_1[2:0]),
											.line_2(line_2[2:0]),
											.line_3(line_3[2:0]),
											.line_4(line_4[2:0]),
											.line_5(line_5[2:0]),
											.line_6(line_6[2:0]),
											.main_st(current_state[5:0]),
											.isDrawingDone(drawdone),
											.vga_en(draw_vga_en),
											.xOutput(x_draw[8:0]),
											.yOutput(y_draw[7:0]),
											.colorOutput(color_draw[2:0]));
endmodule


// REFERENCES:
// <vga_adapter.v> from <lab 7 files>
// <vga_control.v> from <lab 7 files>
// <vga_address_translator> from <lab 7 files>
// <vga_pll.v> from <lab 7 files
// <PianoTiles> github from <https://github.com/caeliin/Piano-Tiles>
// <PS/2 Controller> from <https://www.eecg.toronto.edu/~jayar/ece241_08F//AudioVideoCores/ps2/ps2.html>
// <Audio Controller> from < https://www.eecg.toronto.edu/~jayar/ece241_08F//AudioVideoCores/audio/audio.html>

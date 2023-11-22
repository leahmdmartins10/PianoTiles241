module resetScreen(input clock, reset_screen_go,
							output reg [8:0] x,
							output reg [7:0] y,
							output reg [2:0] color,
							output reg vga_en, resetDone);
							
							localparam MAX_X = 9'd199;
							localparam MAX_Y = 8'd239;
							localparam init_x = 9'd120;
							localparam init_y = 8'd0;
							localparam initialCol = 3'b111; // sets the initial color to white
							
							reg counterEn;
							
							always @(posedge clock) begin
							if(!reset_screen_go) begin
								x = init_x - 1'b1;
								y = init_y;
								color = initial_c;
								resetdone = 1'b0;
								vga_en = 1'b0;
								end
							else begin
								vga_en = 1'b1;
								if(x == MAX_X) begin
									if(y == MAX_Y)
										resetDone = 1'b1; // it's reset the whole screen
									else
										x = init_x;
										y += 1'b1; // incrementing y, traversing pixel by pixel
									end
								else
									x += 1'b1; // incrementing x, traversing pixel by pixel
								end
							end
endmodule
				
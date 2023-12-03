
`timescale 1ns / 1ps

module PS2_Controller( 
	PS2_C, 
	PS2_D, 
	dataOut,
	NEW_Data); 
	
	input PS2_C; 
	input PS2_D; 
	output reg [7:0] dataOut; 
	output reg NEW_Data; 

	reg New_data_flag = 1'b0; 

	reg[7:0] Data_int_current = 8'd0; //internal data reg, current data 
	reg[7:0] Data_int_previous = 8'd0; //previous data 
	reg[3:0] Index = 4'd1; 

	reg CLK_int = 1'd0; //new data clock 
	
	assign NEW_Data = New_data_flag; 
	
	always @ (negedge PS2_C)
	begin 
	
	   case (Index)
		//process each bit of data of the PS2 data
		1: New_data_flag <= 1'b1
		2: Data_int_current[0] <= PS2_D; 
		3: Data_int_current[1] <= PS2_D;
		4: Data_int_current[2] <= PS2_D;
		5: Data_int_current[3] <= PS2_D;
		6: Data_int_current[4] <= PS2_D;
		7: Data_int_current[5] <= PS2_D;
		8: Data_int_current[6] <= PS2_D;
		9: Data_int_current[1] <= PS2_D;
		10: Data_int_current[2] <= PS2_D;
		11: 
		   begin 
			CLK_int <= 1'b0;
			New_data_flag <= 1'b0; 
		   end 
		default:; 
	endcase 
	
	//Increment index_it or if it reaches 10
	
	if(Index <= 4'd10)
	begin 
	   Index <= Index + 1'd1; 
	end 
	else 
	begin 
	   Index <= 4'd1;
	end 
	end 
	
	begin 
	   Index <= 4'd1; 
	end 
   end 
	

  assign dataOut = Data_int_previous; 

	//kew press signals as internal signals 

	reg key_esc,
	    key_s, 
	    key_r, 
            key_up, 
            key_down,
	    key_right, 
	    key_left;

	//check for specific keys based on previous data 
	
	always @ (*)
	begin 
	    key_esc = (Data_int_previous == 8'h76);
	    key_s = (Data_int_previous == 8'h1B) ;
	    key_r = (Data_int_previous == 8'h2D); 
            key_up = (Data_int_previous == 8'h75);
            key_down = (Data_int_previous == 8'h72);
	    key_right = (Data_int_previous == 8'h6B); 
	    key_left = (Data_int_previous == 8'h74);
	end 

	//for updating previous data
	always @ (posedge CLK_int)
	begin
	//check if the current data is zero and update the previous data
		if(Data_int_current == 8'd0)
		begin 
		   dataOut = Data_int_previous; 
		   dataOut = 8'hFF; 
		end
		else 
\	begin 
		   Data_int_previous = Data_int_current; 
		end 
	  end 
endmodule 







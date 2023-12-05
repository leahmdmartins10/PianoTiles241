
module DE1_SoC_Audio_Example (
	// Inputs
	CLOCK_50,
	KEY,
	SW, 
	PS_output,

	AUD_ADCDAT,

	// Bidirectionals
	AUD_BCLK,
	AUD_ADCLRCK,
	AUD_DACLRCK,

	FPGA_I2C_SDAT,

	// Outputs
	AUD_XCK,
	AUD_DACDAT,

	FPGA_I2C_SCLK,
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input				CLOCK_50;
input		[3:0]	KEY;

input				AUD_ADCDAT;

// Bidirectionals
inout				AUD_BCLK;
inout				AUD_ADCLRCK;
inout				AUD_DACLRCK;
inout 			[7:0] PS_output;
inout				FPGA_I2C_SDAT;
input 				[1:0]SW;
// Outputs
output				AUD_XCK;
output				AUD_DACDAT;

output				FPGA_I2C_SCLK;


/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires
wire				audio_in_available;
wire		[31:0]	left_channel_audio_in;
wire		[31:0]	right_channel_audio_in;
wire				read_audio_in;

wire				audio_out_allowed;
wire		[31:0]	left_channel_audio_out;
wire		[31:0]	right_channel_audio_out;
wire				write_audio_out;

// Internal Registers

reg [18:0] delay_cnt;
wire [18:0] delay;
wire[7:0] the_command; 
wire send_command; 
reg snd;
wire [1:0] speak;
wire rec_en; 
reg [3:0] W;
// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

//always @(posedge CLOCK_50)
	//if(delay_cnt == delay) begin
		//delay_cnt <= 0;
		//snd <= !snd;
	//end else delay_cnt <= delay_cnt + 1; 

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
/*PS2_Controller ps(
	.CLOCK_50(CLOCK_50),
	.the_command(the_command), 
	.send_command(send_command), 
	.PS2_CLK(PS2_CLK),
	.PS2_DAT(PS2_DAT),
	.command_was_sent(),
	.error_communication_timed_out(),
	.received_data(PS_output),
	.received_data_en(rec_en)
); 
*/

assign delay = {KEY[3:0], 15'd3000};

wire [31:0] sound = (KEY == 0)?0:snd?32'b10000000:-32'b10000000;


assign read_audio_in			= audio_in_available & audio_out_allowed;

assign left_channel_audio_out	= left_channel_audio_in+sound;
assign right_channel_audio_out	= right_channel_audio_in+sound;
assign write_audio_out			= audio_in_available & audio_out_allowed;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

Audio_Controller Audio_Controller (
	// Inputs
	.CLOCK_50						(CLOCK_50),
	.reset						(~SW[0]),

	.clear_audio_in_memory		(),
	.read_audio_in				(read_audio_in),
	
	.clear_audio_out_memory		(),
	.left_channel_audio_out		(left_channel_audio_out),
	.right_channel_audio_out	(right_channel_audio_out),
	.write_audio_out			(write_audio_out),

	.AUD_ADCDAT					(AUD_ADCDAT),

	// Bidirectionals
	.AUD_BCLK					(AUD_BCLK),
	.AUD_ADCLRCK				(AUD_ADCLRCK),
	.AUD_DACLRCK				(AUD_DACLRCK),


	// Outputs
	.audio_in_available			(audio_in_available),
	.left_channel_audio_in		(left_channel_audio_in),
	.right_channel_audio_in		(right_channel_audio_in),

	.audio_out_allowed			(audio_out_allowed),

	.AUD_XCK					(AUD_XCK),
	.AUD_DACDAT					(AUD_DACDAT)

);

avconf #(.USE_MIC_INPUT(1)) avc (
	.FPGA_I2C_SCLK					(FPGA_I2C_SCLK),
	.FPGA_I2C_SDAT					(FPGA_I2C_SDAT),
	.CLOCK_50					(CLOCK_50),
	.reset						(~SW[0])
);

endmodule


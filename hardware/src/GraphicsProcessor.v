
/*
 Command procesor module that handles the logic for parsing the graphics commands
 Three graphics commands for line engine:
 1. Write start point
 2. Write end-point
 3. Write line color
 If trigger bit set in command, command will also fire on start or end point
 Frame buffer fill will trigger automatically
 
 */
`include "gpcommands.vh"

module GraphicsProcessor(
    input clk,
    input rst,

    //line engine processor interface
    input LE_ready,
    output [31:0] LE_color,
    output [9:0] LE_point,
    output LE_color_valid,
    output LE_x0_valid,
    output LE_y0_valid,
    output LE_x1_valid,
    output LE_y1_valid,

    output LE_trigger,
    output [31:0] LE_frame,
		       
    //frame filler processor interface
    input FF_ready,
    output FF_valid,
    output [23:0] FF_color,
    output [31:0] FF_frame,
		       
    //DRAM request controller interface
    input rdf_valid,
    input af_full,
    input [127:0] rdf_dout,
    output rdf_rd_en,
    output af_wr_en,
    output [30:0] af_addr_din,
		       
    //processor interface
    input [31:0] GP_CODE,
    input [31:0] GP_FRAME,
    input GP_valid);
     
   
   //Your code goes here. GL HF.

	//assign FF_color = 24'hff0ff;
	//assign FF_frame = 32'h10400000;
	//assign FF_valid = 1'b1;
	
	reg LE_x0_validr, LE_x1_validr, LE_y0_validr, LE_y1_validr, LE_color_validr, LE_triggerr;
	reg [9:0] LE_pointr;
	reg [31:0] LE_colorr;

	/*
	assign LE_x0_valid = LE_x0_validr;
	assign LE_y0_valid = LE_y0_validr;
	assign LE_x1_valid = LE_x1_validr;
	assign LE_y1_valid = LE_y1_validr;
	assign LE_color_valid = LE_color_validr;
	assign LE_trigger = LE_triggerr;
	assign LE_point = LE_pointr;
	assign LE_color = LE_colorr;

   //output assignment placeholders - delete these later
	localparam S0 = 3'b00; 
	localparam S1 = 3'b01; 
	localparam S2 = 3'b10; 
	localparam S3 = 3'b11; 
	localparam S4 = 3'b100; 
	localparam S5 = 3'b101; 
	localparam S6 = 3'b110; 
   
	reg [2:0] CS, NS;

	always @(*) begin
		if (CS == S0) NS = S1;
		else if (CS == S1) NS = S2;
		else if (CS == S2) NS = S3;
		else if (CS == S3) NS = S4;
		else if (CS == S4) NS = S5;
		else if (CS == S5) NS = S6;
		else  NS = S6;
	end
	
	always@(posedge clk) begin
		if (rst) begin
			CS <= S0;	
		end else begin
			CS <= NS;
			if (CS == S0) begin
				LE_x0_validr <= 1'b1;	
				LE_pointr <= 10'd0;

				LE_y0_validr <= 1'b0;	
				LE_x1_validr <= 1'b0;	
				LE_y1_validr <= 1'b0;	
			end else if (CS == S1) begin
				LE_y0_validr <= 1'b1;	
				LE_pointr <= 10'd0;

				LE_x0_validr <= 1'b0;	
				LE_x1_validr <= 1'b0;	
				LE_y1_validr <= 1'b0;	
			end else if (CS == S2) begin
				LE_x1_validr <= 1'b1;	
				LE_pointr <= 10'd300;

				LE_y0_validr <= 1'b0;	
				LE_x0_validr <= 1'b0;	
				LE_y1_validr <= 1'b0;	
			end else if (CS == S3) begin
				LE_y1_validr <= 1'b1;	
				LE_pointr <= 10'd500;

				LE_y0_validr <= 1'b0;	
				LE_x1_validr <= 1'b0;	
				LE_x0_validr <= 1'b0;	
			end else if (CS == S4) begin
				LE_color_validr <= 1'b1;	
				LE_colorr <= 32'h00ff00ff;

				LE_y0_validr <= 1'b0;	
				LE_y1_validr <= 1'b0;	
				LE_x1_validr <= 1'b0;	
				LE_x0_validr <= 1'b0;	
			end else if (CS == S5) begin
				LE_x0_validr <= 1'b0;	
				LE_y0_validr <= 1'b0;	
				LE_x1_validr <= 1'b0;	
				LE_y1_validr <= 1'b0;	
				LE_color_validr <= 1'b0;	

				LE_triggerr = 1'b1;	
			end else if (CS == S6) begin
				LE_x0_validr <= 1'b0;	
				LE_y0_validr <= 1'b0;	
				LE_x1_validr <= 1'b0;	
				LE_y1_validr <= 1'b0;	
				LE_color_validr <= 1'b0;	

				LE_triggerr = 1'b0;	
			end
		end
	end
*/
   assign LE_color = 32'h00ff00ff;
   assign LE_point = 10'd0;
   
   assign LE_color_valid = 1'b1;
   assign LE_x0_valid = 1'b1;
   assign LE_y0_valid = 0;
   assign LE_x1_valid = 0;
   assign LE_y1_valid = 0;

 //  assign LE_trigger = 0;
   assign LE_frame = 32'h10400000;
		       
   //frame filler processor interface
   assign FF_valid  = 1'b1;
   assign FF_color = 24'hff00ff ;
   assign FF_frame = 32'h1040000;
		       
   //DRAM request controller interface
   assign rdf_rd_en = 0;
   
   assign af_wr_en = 0;
   assign af_addr_din = 0;
		       
endmodule

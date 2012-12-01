
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

	
   //output assignment placeholders - delete these later
	localparam IDLE = 3'b00; 
	localparam FETCH = 3'b01; 
	localparam READ1 = 3'b10; 
	localparam READ2 = 3'b11; 
	localparam PROCESS = 3'b100; 
	localparam FF = 3'b101; 
   
	reg [2:0] CS, NS;
	
	reg [351:0] fifo_inst_buf; //first inst in [351:320]
	reg [31:0] cur_word;

	reg need_to_go_to_FF;
	reg neet_to_go_to_done;
	reg [3:0] fifo_count; 

/*

	always @(*) begin
		if ((CS == IDLE) && GP_valid) NS = FETCH;
		else if (CS == FETCH && ~af_full) NS = READ1;
		else if (CS == READ1  && rdf_valid) NS = READ2;
		else if (CS == READ2 && rdf_valid) NS = PROCESS;
		else if (CS == FF && FF_ready) NS = PROCESS;
		else if (CS == PROCESS && (cur_word == 32'd0)) NS = IDLE; 
		else if (CS == PROCESS && (cur_word[31:24] == 8'h01)) NS = FF; 
		else if (CS == PROCESS && (fifo_count <= 0)) NS = IDLE;
		else  NS = CS; //may need more transitions
	end
	
	always@(posedge clk) begin
		if (rst) begin
			CS <= IDLE;
			fifo_inst_buf <= 352'd0;
			fifo_count <= 0;
			need_to_go_to_FF <= 0;
		end	
		else begin
			CS <= NS;
			if (CS == IDLE) begin
				fifo_inst_buf <= 352'd0;
				fifo_count <= 0;
				need_to_go_to_FF <= 0;
			end else if (CS == FETCH) begin

			end else if (CS == READ1) begin
				if (rdf_valid) begin
					fifo_inst_buf <= {rdf_dout, fifo_inst_buf[351:128]};	
					fifo_count <= fifo_count +4;	
				end
			end else if (CS == READ2) begin
				if (rdf_valid) begin
					fifo_inst_buf <= {rdf_dout, fifo_inst_buf[351:128]};	
					fifo_count <= fifo_count +4;	
				end
			end else if (CS == PROCESS) begin
				cur_word <= (fifo_inst_buf >> (32*(fifo_count - 1))) & 32'hffffffff;
				//cur_word <= fifo_inst_buf[351-32*(fifo_count-1):351-32*fifo_count];
				fifo_inst_buf <= (fifo_inst_buf >> 32);	
				fifo_count <= fifo_count - 1;
			end else if (CS == FF) begin
			
			end
		end
	end

   assign LE_color = 32'h00ff00ff;
   assign LE_point = 10'd0;
   
   assign LE_color_valid = 1'b1;
   assign LE_x0_valid = 1'b1;
   assign LE_y0_valid = 0;
   assign LE_x1_valid = 0;
   assign LE_y1_valid = 0;

 //  assign LE_trigger = 0;
   assign LE_frame = GP_FRAME;
		       
   //frame filler processor interface
   assign FF_valid  = (CS == FF);
   assign FF_color =  cur_word[23:0];
   assign FF_frame = GP_FRAME;
   //DRAM request controller interface
   assign rdf_rd_en = (CS == READ1);
   
   assign af_wr_en = (CS == FETCH);
   assign af_addr_din = {10'b0000000000, GP_CODE[23:22], GP_CODE[21:12], GP_CODE[11:3]};
*/		       
	assign LE_color = 32'd0;
	assign LE_point = 10'd0;
   assign LE_color_valid = 1'b0;
   assign LE_x0_valid = 1'b0;
   assign LE_y0_valid = 0;
   assign LE_x1_valid = 0;
   assign LE_y1_valid = 0;
   assign LE_trigger = 0;
   assign LE_frame = 32'd0;
   assign FF_frame = 32'd0;
   assign FF_color = 24'd0;
   assign rdf_rd_en = 0;
   assign af_wr_en = 0;
   assign af_addr_din = 31'd0;
endmodule

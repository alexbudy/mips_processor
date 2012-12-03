
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

	reg[2:0] State, nextState, prevState;

	localparam IDLE = 3'b000;
	localparam FETCH = 3'b001;
	localparam READ1 = 3'b010;
	localparam READ2 = 3'b011;
	localparam PROCESS = 3'b100;    
	localparam FF = 3'b101;
	localparam LE = 3'b110;

	reg [255:0] inst_fifo; //[31:0] is the first to be executed
	reg [3:0] inst_count;
	
	wire [31:0] current_inst; 

	assign current_inst = inst_fifo[31:0];

	reg [2:0] LE_inst_count_state; //0=sending color, 1=sending x0, 2=sending y0, 3=send x1, 4=send y1 (move inst on 0,1,3, trigger on 4)
	reg [23:0] color; //useless!

	wire [7:0] top_byte_inst;
	assign top_byte_inst = current_inst[31:24];

	assign af_wr_en = (State == FETCH);
	assign rdf_rd_en = ((State == READ1) || (State == READ2));


	reg [30:0] addr_start; 
// ChipScope components:
 wire [35:0] chipscope_control;
 chipscope_icon icon(
 .CONTROL0(chipscope_control)
 ) /* synthesis syn_noprune=1 */;
 chipscope_ila ila(
 .CONTROL(chipscope_control),
 .CLK(clk),
 .DATA({clk,rst,LE_ready,LE_color,LE_point,LE_color_valid,LE_x0_valid,LE_y0_valid,LE_x1_valid,LE_y1_valid,LE_trigger,LE_frame,FF_ready,FF_valid,FF_color,FF_frame,rdf_valid,af_full,rdf_dout,rdf_rd_en,af_wr_en,af_addr_din,GP_CODE,GP_FRAME,GP_valid,State,nextState,prevState,inst_count,current_inst,LE_inst_count_state,color,top_byte_inst,addr_start}),
 .TRIG0(GP_valid)
) /* synthesis syn_noprune=1 */;

	assign af_addr_din = addr_start;

	//FF assigns
	assign FF_color = current_inst[23:0];
	assign FF_frame = GP_FRAME;
	assign FF_valid = (State == FF);

	//LE assigns	
	assign LE_color = {8'h00,current_inst[23:0]};
	assign LE_frame = GP_FRAME;
	assign LE_color_valid = ((State == LE) && LE_inst_count_state == 0);
	assign LE_x0_valid = ((State == LE) && LE_inst_count_state == 1);
	assign LE_y0_valid = ((State == LE) && LE_inst_count_state == 2);
	assign LE_x1_valid = ((State == LE) && LE_inst_count_state == 3);
	assign LE_y1_valid = ((State == LE) && LE_inst_count_state == 4);
	assign LE_trigger  = ((State == LE) && LE_inst_count_state == 4);
	assign LE_point    = ((LE_inst_count_state == 1) || (LE_inst_count_state == 3)) ? current_inst[25:16] : current_inst[9:0];
	

	always@(*)begin
		case(State)
			IDLE:begin
				if (GP_valid)  nextState = FETCH;
				else nextState = IDLE;
			end
			FETCH:begin
				if (af_full) nextState = FETCH;
				else nextState = READ1;
			end
			READ1:begin
				if (!rdf_valid) nextState = READ1;
				else nextState = READ2;
			end
			READ2:begin 
				if (!rdf_valid) nextState = READ2;
				else nextState = PROCESS;
			end
			PROCESS:begin
				if ((inst_count == 1 && (prevState == LE)) || inst_count == 0) nextState = FETCH;
				else if ((LE_inst_count_state > 0) && (LE_inst_count_state < 4)) nextState = LE;
				else if ((top_byte_inst == 8'd00) && (LE_inst_count_state == 0))  nextState = IDLE; //stop
				else if ((top_byte_inst == 8'd01) && (FF_ready == 1) && (LE_ready == 1)) nextState = FF;
				else if ((top_byte_inst == 8'd02) && (FF_ready == 1) && (LE_ready == 1)) nextState = LE;
				else nextState = PROCESS;
			end	
			LE:begin
				if ((LE_inst_count_state == 4) || (LE_inst_count_state == 2) || (LE_inst_count_state == 0)) nextState = PROCESS;	
				else nextState = LE;
			end
			FF: begin
				nextState = PROCESS;
			end
		endcase
	end

	always @ (posedge clk) begin
		if (State == FETCH) begin
			prevState <= FETCH;
			if (nextState == READ1) addr_start <= addr_start + 4;
		end	else if (State == READ1) begin
			prevState <= READ1;
			inst_fifo <= {rdf_dout, 128'd0};
		end else if (State == READ2) begin
			prevState <= READ2;
			inst_fifo <= {inst_fifo[255:128] ,rdf_dout};
			inst_count <= 4'd8; //? semi resolved
		end	else if (State == PROCESS) begin
			prevState <= PROCESS;

			if ((prevState == LE)||(prevState ==FF))begin
				inst_fifo <= (inst_fifo >> 32);
				inst_count <= inst_count - 1;
			end

			if (LE_inst_count_state == 5) LE_inst_count_state <= 0;
			else LE_inst_count_state <= LE_inst_count_state;
				
		end	else if (State == FF) begin
			prevState <= FF;
		end	else if (State == LE) begin
			prevState <= LE;
			LE_inst_count_state <= LE_inst_count_state + 1;
		end else if (State == IDLE) begin
			inst_count <= 0;
			LE_inst_count_state <= 0;
			addr_start <= {6'b000000, GP_CODE[27:5],{2'b00}};
		end
	end

	always@(posedge clk)begin
		if(rst)
			State <= IDLE;
		else
			State <= nextState;
	end

endmodule

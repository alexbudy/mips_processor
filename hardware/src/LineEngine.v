
module LineEngine(
  input                 clk,
  input                 rst,
  output                LE_ready,
  // 8-bit each for RGB, and 8 bits zeros at the top
  input [31:0]          LE_color,
  input [9:0]           LE_point,
  // Valid signals for the inputs
  input                 LE_color_valid,
  input                 LE_x0_valid,
  input                 LE_y0_valid,
  input                 LE_x1_valid,
  input                 LE_y1_valid,
  // Trigger signal - line engine should
  // Start drawing the line
  input                 LE_trigger,
  // FIFO connections
  input                 af_full,
  input                 wdf_full,
  
  output [30:0]         af_addr_din,
  output                af_wr_en,
  output [127:0]        wdf_din,
  output [15:0]         wdf_mask_din,
  output                wdf_wr_en,

  input [31:0] 			LE_frame_base
);

	localparam IDLE = 2'b00;
	localparam SEND1 = 2'b01;
	localparam SEND2 = 2'b10;  
	localparam UPDATE = 2'b11;  

	reg [1:0] State, nextState;

    	// Implement Bresenham's line drawing algorithm here!
	reg [9:0] x, y;
	reg [31:0] color;
	
	//reg[9:0] x0,x1,y0,y1,newx0, newx1, newy0, newy1, deltax, deltay, error, ystep;
	reg[9:0] x0, x1, y0, y1, error, ystep;
	wire[9:0] newx0, newx1, newy0, newy1, deltax, deltay;
	//wire[9:0] newx0, newx1, newy0, newy1, deltax ;
	wire steep;


	wire [9:0] error_init;

	bres_helper helper (
		.x0(x0),
		.y0(y0),
		.x1(x1),
		.y1(y1),
		.newx0(newx0),
		.newy0(newy0),
		.newx1(newx1),
		.newy1(newy1),
		.steep(steep),
		.deltax(deltax),	
		.deltay(deltay)	
	);
	
	always@(*) begin
		if (LE_x0_valid) x0 = LE_point;
		if (LE_x1_valid) x1 = LE_point;
		if (LE_y0_valid) y0 = LE_point;
		if (LE_y1_valid) y1 = LE_point;
		if (LE_color_valid) color = LE_color;
		

		if ((State == IDLE) && LE_trigger) nextState = SEND1; //add LE_trigger here later
		else if ((State == SEND1) && ~af_full && ~wdf_full) nextState = SEND2;
		else if ((State == SEND2) && ~wdf_full) nextState = UPDATE;
		else if ((State == UPDATE) && (x >= newx1)) nextState = IDLE;
		else if (State == UPDATE) nextState = SEND1;
		else nextState = State;
	end

	assign wdf_din = {color,color,color,color};
	assign error_init = (deltax >> 1);
	

	always@(posedge clk) begin
		if (rst) begin 
			State <= IDLE;		
			error <= error_init;
			x <= newx0;
			y <= newy0;
			
			//TEMP=remove later
		//	x0 <= 10'd0;
		//	y0 <= 10'd0;
		//	y1 <= 10'd200;
		//	x1 <= 10'd300;
		end	
		else 
			State <= nextState;
			if (State == SEND1) begin	

			end else if (State == SEND2) begin

			end
			else if (State == UPDATE) begin
				if (error < deltay) begin
					y <= y + ystep;
					error <= error + deltax - deltay;
				end else begin
					error <= error - deltay;
				end

				x <= x + 1;
			end else begin //IDLE
				error <= error_init;
				x <= newx0;
				y <= newy0;
				ystep <= (newy0 < newy1)? 10'b1: 10'b1111111111;
			end
	end
	
//	wire [31:0] frame;
	//assign frame = 32'h10400000;
	assign af_addr_din = (steep) ? {6'b0,LE_frame_base[27:22],x,y[9:3],2'b0} : {6'b0, LE_frame_base[27:22],y,x[9:3],2'b0};
	
	
	wire [31:0] mask;
	assign mask = (steep) ?  (32'hf0000000 >> {y[2:0], 2'b00}) : (32'hf0000000 >> {x[2:0], 2'b00});
	assign wdf_mask_din = (State == SEND1) ? ~mask[31:16] : ((State == SEND2) ? ~mask[15:0] : 16'hffff);	
	assign af_wr_en = (State == SEND1);
	assign wdf_wr_en = ((State == SEND1) || (State == SEND2));

    assign LE_ready = (State == IDLE);

endmodule

module bres_helper(
	input [9:0]  	x0,
	input [9:0] 	x1,
	input [9:0] 	y0,
	input [9:0] 	y1,
	output [9:0] newx0,
	output [9:0] newx1,
	output [9:0] newy0,
	output [9:0] newy1,
	output 		 steep,
	output [9:0] deltax,
	output [9:0] deltay
);

	assign steep = ((y1>y0) ? (y1 - y0) : (y0 - y1)) > ((x1>x0)?(x1-x0):(x0-x1));
	
	assign newx0 = steep ? ((y0 > y1) ? y1 : y0) : ((x0 > x1) ? x1 : x0);	
	assign newx1 = steep ? ((y0 > y1) ? y0 : y1) : ((x0 > x1) ? x0 : x1);	
	assign newy0 = steep ? ((y0 > y1) ? x1 : x0) : ((x0 > x1) ? y1 : y0);	
	assign newy1 = steep ? ((y0 > y1) ? x0 : x1) : ((x0 > x1) ? y0 : y1);	

	assign deltax = newx1 - newx0; 
	assign deltay = (newy1>newy0) ? (newy1-newy0) : (newy0-newy1);
	
endmodule

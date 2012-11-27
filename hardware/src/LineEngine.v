
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

  input [31:0] 		LE_frame_base
);

	localparam IDLE = 2'b00;
	localparam SEND1 = 2'b01;
	localparam SEND2 = 2'b10;  

	reg [1:0] = State, nextState;

    // Implement Bresenham's line drawing algorithm here!
    reg [9:0] x, y;
    reg [31:0] color;
	
	reg[9:0] x0,x1,y0,y1,newx0, newx1, newy0, newy1, deltax, deltay, error, ystep;
	reg steep;

	wire [9:0] error_init;
	
	always@(*) begin
		if (LE_x0_valid) x0 <= LE_point;
		if (LE_x1_valid) x1 <= LE_point;
		if (LE_y0_valid) y0 <= LE_point;
		if (LE_y1_valid) y1 <= LE_point;
		if (LE_color_valid) color <= LE_color;

		if (LE_trigger & State == IDLE) nextState <= SEND1; 
		else if (State == SEND1 && ~af_full && ~wdf_full) nextState <= SEND2;
		else if (State == SEND2 && x > x1) nextState <= IDLE;
		else if (State == SEND2 && ~af_full && ~wdf_full) nextState <= SEND1;
		default nextState <= State;
		
	end

	assign wdf_din = {color,color,color,color};

	always@(posedge clk) begin
		State <= nextState;
		if (rst) begin 
			State <= IDLE;		
			error <= error_init;
		end	
		else if (State == SEND1) begin	
			if (steep) begin
				af_addr_din <= {6'b0,LE_frame_base[27:22],x,y[9:3],2'b0};
				wdf_mask_din <= y[5] ? 16{1'b1} : ({4{1'b0}, 12{1'b1}} >> y[4:3]);
			else
				af_addr_din <= {6'b0, LE_frame_base[27:22],y,x[9:3],2'b0};
				wdf_mask_din <= x[5] ? 16{1'b1} : ({4{1'b0}, 12{1'b1}} >> x[4:3]);
			end
			wdf_wr_en <= 1'b1;			
			af_wr_en <= 1'b1;
				
		end else if (State == SEND2) begin
			if (steep) begin
				af_addr_din <= {6'b0,LE_frame_base[27:22],x,y[9:3],2'b0};
				wdf_mask_din <= (~y[5]) ? 16{1'b1} : ({4{1'b0}, 12{1'b1}} >> y[4:3]);
			else
				af_addr_din <= {6'b0,LE_frame_base[27:22],y,x[9:3],2'b0};
				wdf_mask_din <= (~x[5]) ? 16{1'b1} : ({4{1'b0}, 12{1'b1}} >> x[4:3]);
			end
			wdf_wr_en <= 1'b1;			
			af_wr_en <= 1'b1;
				
			
			if (error < deltay) begin
				y <= y + ystep;
				error <= error + deltax;
			end

			error <= error - deltay;
			x <= x + 1;
			//	nextState <= (x <= newx1) ? SEND1 : IDLE;
		end else //IDLE
			error_init <= deltax >> 1;
			wdf_wr_en <= 1'b0;
			af_wr_en <= 1'b0;
			wdf_mask_din <= 16{1'b1};
			x <= newx0;
			y <= newy0;
			ystep <= (newy0 < newy1)? 10'b1: 10'b1111111111;

		begin
	end

    // Remove these when you implement this module:
    assign LE_ready = (State == IDLE);

endmodule

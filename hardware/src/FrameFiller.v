module FrameFiller(//system:
  input             clk,
  input             rst,
  // fill control:
  input             valid,
  input [23:0]      color,
  // ddr2 fifo control:
  input             af_full,
  input             wdf_full,
  // ddr2 fifo outputs:
  output [127:0]    wdf_din,
  output            wdf_wr_en,
  output [30:0]     af_addr_din,
  output            af_wr_en,
  output [15:0]     wdf_mask_din,
  // handshaking:
  output            ready,
  
  input [31:0] FF_frame_base
  );

   //Your code goes here. GL HF DD DS
	localparam IDLE = 2'b00;
	localparam PUSH = 2'b01;
	localparam START = 2'b10; //default state

	reg[9:0] x, y;

	reg [1:0] State, nextState;
	wire overflow;
	reg [23:0] color_reg;

// ChipScope components:
// wire [35:0] chipscope_control;
// chipscope_icon icon(
// .CONTROL0(chipscope_control)
// ) /* synthesis syn_noprune=1 */;
// chipscope_ila ila(
// .CONTROL(chipscope_control),
// .CLK(clk),
// .DATA({rst, af_full, wdf_full, wdf_wr_en, af_wr_en, ready, x,y,State,nextState,overflow} ),
// .TRIG0( rst)
//) /* synthesis syn_noprune=1 */;
	
	always @(*) begin
		if (valid && (State == START)) nextState = PUSH; 
		else if (State == PUSH && ~af_full && ~wdf_full) nextState = IDLE;
		else if (State == IDLE && ~wdf_full) nextState = (overflow) ? START : PUSH;
		else  nextState = State;
	end	
	
	assign overflow = (x >= 64 && y >= 2);

	always @(posedge clk) begin
		if (rst) begin
			x <= 10'b0;			
			y <= 10'b0;			
			State <= START;
	//		overflow <= 0;
		end
		else begin
			State <= nextState;
			if (State == IDLE) begin
				if (!wdf_full) begin
					//if (x < 792) begin
					if (x < 64) begin
						x <= x + 10'd8;
	//					overflow <= 0;
					end
					//else if (y < 599) begin
					else if (y < 2) begin
						x <= 10'd0;
						y <= y + 10'd1;
	//					overflow <= 0;
					end else begin
						x <= 10'b0;
						y <= 10'b0;
	//					overflow <= 1;
					end
				end
			end else if (State == PUSH) begin //PUSH = first state, IDLE 2nd state
				x <= x;
				y <= y;
				//overflow <= 0;
	//			overflow <= overflow;
			end else  begin //START
				if (valid) color_reg <= color;
				x <= 10'b0;
				y <= 10'b0;
	//			overflow <= 0;
			end
		end
	end

  	// Remove these when you implement the frame filler:

  	assign wdf_wr_en = (State == PUSH || State == IDLE);
  	assign af_wr_en  = (State == PUSH);
  	assign ready     = (State == START);
	assign wdf_din   = {8'd0, color_reg, 8'd0, color_reg, 8'd0, color_reg, 8'd0, color_reg};
	assign wdf_mask_din = 16'd0;
	assign af_addr_din = {6'b000000, FF_frame_base[27:22], y, x[9:3], 2'b00};
endmodule

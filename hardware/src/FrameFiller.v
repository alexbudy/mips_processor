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
	localparam START = 2'b10;

	reg[9:0] x, y;

	reg [1:0] State, nextState;
	reg overflow;
	
	always @(*) begin
		if (valid & !af_full & !wdf_full) nextState = PUSH; 
		else if (af_full | wdf_full) nextState = (State == START) ? START : IDLE;
		else if (!af_full & !wdf_full) nextState = (State == IDLE) ? PUSH : State; 
		else nextState = State;
	end	

	always @(posedge clk) begin
		if (rst) begin
			x <= 10'b0;			
			y <= 10'b0;			
			State <= START;
			overflow <= 0;
		end
		else begin
			State <= overflow? START:nextState;
			if (State == PUSH) begin
				if (x < 792) begin
					 x <= x + 10'd8;
					overflow <= 0;
				end
				else if (y < 599) begin
					x <= 10'd0;
					y <= y + 10'd1;
					overflow <= 0;
				end else begin
					x <= 10'b0;
					y <= 10'b0;
					overflow <= 1;
				end
			end else if (State == IDLE) begin
				x <= x;
				y <= y;
				overflow <= 0;
			end else  begin //START
				x <= 10'b0;
				y <= 10'b0;
				overflow <= 0;
			end 
		end
	end

  	// Remove these when you implement the frame filler:

  	assign wdf_wr_en = (State == PUSH);
  	assign af_wr_en  = (State == PUSH);
  	assign ready     = (State == START);
	assign wdf_din   = {8'd0, color, 8'd0, color, 8'd0, color, 8'd0, color};
	assign wdf_mask_din = 16'd0;
	reg [18:0] offset;
	assign af_addr_din = {6'b000000, FF_frame_base[27:22], y, x[9:3], 2'b00};
endmodule

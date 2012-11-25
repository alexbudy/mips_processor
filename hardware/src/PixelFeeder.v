/* This module keeps a FIFO filled that then outputs to the DVI module. */

module PixelFeeder( //System:
                    input          cpu_clk_g,
                    input          clk50_g, // DVI Clock
                    input          rst,
                    //DDR2 FIFOS:
                    input          rdf_valid,
                    input          af_full,
                    input  [127:0] rdf_dout,
                    output         rdf_rd_en,
                    output         af_wr_en,
                    output [30:0]  af_addr_din,
                    // DVI module:
                    output [23:0]  video,
                    output         video_valid,
                    input          video_ready,

		    output frame_interrupt);

    // Hint: States
    localparam IDLE = 1'b0;
    localparam FETCH = 1'b1;

    reg  [31:0] ignore_count;
    
    /**************************************************************************
    * YOUR CODE HERE: Write logic to keep the FIFO as full as possible.
    **************************************************************************/
reg[9:0] x, y;
reg[1:0] frame;
reg State, nextState;
reg[31:0] fifocount;
	always @(*) begin
		if (fifocount < 7000)
			nextState = FETCH;
		else
			nextState = IDLE;
	end
	
	always @(posedge cpu_clk_g) begin
		if(rst)begin
			x <= 10'b0;
			y <= 10'b0;
			frame <= 2'b01;
			fifocount <= 32'b0
			State <= IDLE;
		end
		else begin
			State <= nextState;
			if (State == FETCH)begin
				fifocount <= fifocount + 8 -(video_ready & ignore_count == 0);
				rdf_rd_en <= 1'b1;
			
				if (x < 792)
					x <= x + 8;
				else if (y < 599) begin
					x <= 10'd0;
					y <= y + 1;
				end else begin
					x <= 10'b0; //Want to change frame at this point
					y <= 10'b0;
				end
			end else //IDLE state 
			fifocount <= fifocount - (video_ready & ignore_count == 0);
	end

	assign af_addr_din = {8'b00010000, frame,y,x[9:1]};
    /* We drop the first frame to allow the buffer to fill with data from
    * DDR2. This gives alignment of the frame. */
    always @(posedge cpu_clk_g) begin
       if(rst)
            ignore_count <= 32'd480000; // 600*800 
       else if(ignore_count != 0 & video_ready)
            ignore_count <= ignore_count - 32'b1;
       else
            ignore_count <= ignore_count;
    end
	

    // FIFO to buffer the reads with a write width of 128 and read width of 32. We try to fetch blocks
    // until the FIFO is full.
    wire [31:0] feeder_dout;

    pixel_fifo feeder_fifo(
    	.rst(rst),
    	.wr_clk(cpu_clk_g),
    	.rd_clk(clk50_g),
    	.din(rdf_dout),
    	.wr_en(rdf_valid),
    	.rd_en(video_ready & ignore_count == 0),
    	.dout(feeder_dout),
    	.full(feeder_full),
    	.empty(feeder_empty));

    assign video = feeder_dout[23:0];
    assign video_valid = 1'b1;

endmodule

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


    // Implement Bresenham's line drawing algorithm here!

	bres_helper helper(
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
	
	

   
    // Remove these when you implement this module:
    assign af_wr_en = 1'b0;
    assign wdf_wr_en = 1'b0;
    assign LE_ready = 1'b1;

endmodule

module bres_helper(
	input [9:0] 	x0,
	input [9:0] 	x1,
	input [9:0] 	y0,
	input [9:0] 	y1,
	output [9:0]	newx0,
	output [9:0]	newx1,
	output [9:0]	newy0,
	output [9:0]	newy1,
	output 			steep,
	output [9:0]	deltax,
	output [9:0]	deltay
);

	assign steep = ((y1>y0) ? (y1 - y0) : (y0 - y1)) > ((x1>x0)?(x1-x0):(x0-x1));
	
	assign newx0 = steep ? ((y0 > y1) ? y1 : y0) : ((x0 > x1) ? x1 : x0);	
	assign newx1 = steep ? ((y0 > y1) ? y0 : y1) : ((x0 > x1) ? x0 : x1);	
	assign newy0 = steep ? ((y0 > y1) ? x1 : x0) : ((x0 > x1) ? y1 : y0);	
	assign newy1 = steep ? ((y0 > y1) ? x0 : x1) : ((x0 > x1) ? y0 : y1);	
	
	assign deltax = newx1 - newx0; 
	assign deltay = (newy1>newy0) ? (newy1-newy0) : (newy0-newy1);
	
endmodule

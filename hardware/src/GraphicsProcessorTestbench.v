`timescale 1ns/1ps

module GraphicsProcessorTestbench();

    reg Clock, Reset;

    parameter HalfCycle = 5;
    parameter Cycle = 2*HalfCycle;
    parameter ClockFreq = 50_000_000;

    initial Clock = 0;
    always #(HalfCycle) Clock <= ~Clock;
    

    reg rdf_valid;
    reg af_full;
    reg [127:0] rdf_dout;
    wire rdf_rd_en;
    wire af_wr_en;
    wire [30:0] af_addr_din;

    wire le_af_wr_en;
    wire [30:0] le_af_addr_din;
    wire ready;
    
    wire FF_ready;
    wire FF_valid;
    wire [23:0] FF_color;
    
    wire LE_ready;
    wire [31:0] LE_color;
    wire [9:0] LE_point;
    wire LE_color_valid;
    wire LE_x0_valid;
    wire LE_y0_valid;
    wire LE_x1_valid;
    wire LE_y1_valid;
    wire LE_trigger;
    
    wire [31:0] LE_frame;
    wire [31:0] FF_frame;
   wire gp_interrupt;
   
    reg [31:0] gp_code;
    reg [31:0] gp_frame;
    reg gp_valid;
    
    wire [9:0]          x;
    wire [9:0]          y;
    reg [2:0]          mask;

  
    wire [9:0]          x1;
    wire [9:0]          y1;
    reg [2:0]          mask1;
   
	  reg                 wdf_full;
	  
	  wire [30:0]         ff_af_addr_din;
	  wire                ff_af_wr_en;
	  wire [127:0]        wdf_din;
	  wire [15:0]         wdf_mask_din;
	  wire                wdf_wr_en;
   	  wire [127:0]        le_wdf_din;
	  wire [15:0]         le_wdf_mask_din;
	  wire                le_wdf_wr_en;
    always@(*) begin
      if(ff_af_wr_en) begin
        if(wdf_mask_din[15:12] == 4'h0) mask = 3'h0;
        else if(wdf_mask_din[11:8] == 4'h0) mask = 3'h1;
        else if(wdf_mask_din[7:4] == 4'h0) mask = 3'h2;
        else if(wdf_mask_din[3:0] == 4'h0) mask = 3'h3;
        else mask = 3'h0;
      end
      else begin
        if(wdf_mask_din[15:12] == 4'h0) mask = 3'h4;
        else if(wdf_mask_din[11:8] == 4'h0) mask = 3'h5;
        else if(wdf_mask_din[7:4] == 4'h0) mask = 3'h6;
        else if(wdf_mask_din[3:0] == 4'h0) mask = 3'h7;
        else mask = 3'h0;
      end
    end

    assign x = {ff_af_addr_din[8:2], 3'h0};
    assign y = ff_af_addr_din[18:9];

 always@(*) begin
      if(le_af_wr_en) begin
        if(le_wdf_mask_din[15:12] == 4'h0) mask1 = 3'h0;
        else if(le_wdf_mask_din[11:8] == 4'h0) mask1 = 3'h1;
        else if(le_wdf_mask_din[7:4] == 4'h0) mask1 = 3'h2;
        else if(le_wdf_mask_din[3:0] == 4'h0) mask1 = 3'h3;
        else mask = 3'h0;
      end
      else begin
        if(le_wdf_mask_din[15:12] == 4'h0) mask1 = 3'h4;
        else if(le_wdf_mask_din[11:8] == 4'h0) mask1 = 3'h5;
        else if(le_wdf_mask_din[7:4] == 4'h0) mask1 = 3'h6;
        else if(le_wdf_mask_din[3:0] == 4'h0) mask1 = 3'h7;
        else mask1 = 3'h0;
      end
    end

    assign x1 = {le_af_addr_din[8:2], mask1};
    assign y1 = le_af_addr_din[18:9];
   
    GraphicsProcessor DUT(	.clk(Clock),
    						.rst(Reset),
    			//			.bsel(bsel),
    						.rdf_valid(rdf_valid),
    						.af_full(af_full),
    						.rdf_dout(rdf_dout),
    						.rdf_rd_en(rdf_rd_en),
    						.af_wr_en(af_wr_en),
    						.af_addr_din(af_addr_din),
    						//line engine control signals
    						.LE_ready(LE_ready),
    						.LE_color(LE_color),
    						.LE_point(LE_point),
    						.LE_color_valid(LE_color_valid),
    						.LE_x0_valid(LE_x0_valid),
    						.LE_y0_valid(LE_y0_valid),
    						.LE_x1_valid(LE_x1_valid),
    						.LE_y1_valid(LE_y1_valid),
    						.LE_trigger(LE_trigger),
    						.LE_frame(LE_frame),
    						//frame filler control signals
    						.FF_ready(FF_ready),
    						.FF_valid(FF_valid),
    						.FF_color(FF_color),
    						.FF_frame(FF_frame),
    						
    						.GP_CODE(gp_code),
    						.GP_FRAME(gp_frame),
    						.GP_valid(gp_valid)
//    						.gp_interrupt(gp_interrupt)
						);



FrameFiller FF(
  .clk(Clock),
  .rst(Reset),
  .valid(FF_valid),
  .color(FF_color),
  .af_full(af_full),
  .wdf_full(wdf_full),
  .wdf_din(wdf_din),
  .wdf_wr_en(wdf_wr_en),
  .af_addr_din(ff_af_addr_din),
  .af_wr_en(ff_af_wr_en),
  .wdf_mask_din(wdf_mask_din),
  .ready(FF_ready),
  .FF_frame_base(FF_frame)
);

LineEngine LE(
          .clk(Clock),
          .rst(Reset),
          .LE_ready(LE_ready),
          .LE_color(LE_color),
          .LE_point(LE_point),
          .LE_color_valid(LE_color_valid),
          .LE_x0_valid(LE_x0_valid),
          .LE_y0_valid(LE_y0_valid),
          .LE_x1_valid(LE_x1_valid),
          .LE_y1_valid(LE_y1_valid),
          .LE_trigger(LE_trigger),
          .af_full(af_full),
          .wdf_full(wdf_full),
          .af_addr_din(le_af_addr_din),
          .af_wr_en(le_af_wr_en),
              .wdf_din(le_wdf_din),
          .wdf_mask_din(le_wdf_mask_din),
          .wdf_wr_en(le_wdf_wr_en),
          .LE_frame_base(LE_frame)
        );




   
    initial begin
    	   @(posedge Clock);


    //   bsel = 1'b0;
       rdf_valid = 1'b0;
       af_full = 1'b0;
//       LE_ready = 1'b1;
       gp_valid = 1'b0;
       wdf_full = 1'b0;
       
       gp_frame = 32'h10400000;
        gp_code = 32'h10c00000;
       Reset = 1'b1;
       
      #(10*Cycle);
      Reset = 1'b0;
       #(Cycle);
           gp_valid = 1'b1;
       #(10*Cycle);    
   //    rdf_rd_en = 1'b1;
       rdf_valid = 1'b1;
         rdf_dout = 128'h0200ff0000AA00BB0123012402FF0000;
   //   rdf_dout = 128'h001A002B00100020020000FF01000000;
    //  rdf_dout = 128'h00AA00BB0123012402FF000000000000;  
// rdf_dout = 128'h02ff00000123012400aa00bb00000000;
      
       #(Cycle);
   //    rdf_valid = 1'b0;
      
     
       //  rdf_valid = 1'b1;
     //  rdf_dout = 128'h0000000000AA00BB0123012402FF0000;
         rdf_dout = 128'h001A002B001000200200ff00010000ff;

       
       
 // rdf_dout = 128'h01000000020000ff00100020001a002b;
       
        #(Cycle);
        rdf_valid = 1'b0;
        gp_valid = 1'b0;
       
        rdf_dout = 128'h000000000000000000100020001A002B;
 

       while(FF_ready) begin
	  #(Cycle);
       end

       rdf_valid = 1'b1;
      
       
       while(!FF_ready) begin
          if(wdf_wr_en && wdf_mask_din != 16'hFFFF) begin
            $display("ff: %4d %4d", x, y);
         end
        #(Cycle);
        end

       while(LE_ready) begin
	  #(Cycle);
       end

        while(!LE_ready) begin
          if(le_wdf_wr_en && le_wdf_mask_din != 16'hFFFF) begin
            $display("le0: %4d %4d", x1, y1);
         end
        #(Cycle);
        end

      while(LE_ready) begin
	  #(Cycle);
       end

        while(!LE_ready) begin
          if(le_wdf_wr_en && le_wdf_mask_din != 16'hFFFF) begin
            $display("le1: %4d %4d", x1, y1);
         end
        #(Cycle);
        end


       
      while(LE_ready) begin
	  #(Cycle);
       end

        while(!LE_ready) begin
          if(le_wdf_wr_en && le_wdf_mask_din != 16'hFFFF) begin
            $display("le2: %4d %4d", x1, y1);
         end
        #(Cycle);
        end

       #(100*Cycle);
    	$finish();
    end

    
endmodule

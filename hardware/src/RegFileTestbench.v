// If #1 is in the initial block of your testbench, time advances by
// 1ns rather than 1ps
`timescale 1ns / 1ps

module RegFileTestbench();

  parameter Halfcycle = 5; //half period is 5ns

  localparam Cycle = 2*Halfcycle;

  reg Clock;

  // Clock Sinal generation:
  initial Clock = 0; 
  always #(Halfcycle) Clock = ~Clock;

  // Register and wires to test the RegFile
  reg [4:0] ra1;
  reg [4:0] ra2;
  reg [4:0] wa;
  reg we;
  reg  [31:0] wd;
  wire [31:0] rd1;
  wire [31:0] rd2;
  reg  [31:0] REFout1;
  reg  [31:0] REFout2;

  RegFile DUT(.clk(Clock),
              .we(we),
              .ra1(ra1),
              .ra2(ra2),
              .wa(wa),
              .wd(wd),
              .rd1(rd1),
              .rd2(rd2));
    
task checkOutput;
        if ( REFout1 !== rd1 | REFout2 !== rd2 ) begin
            $display("FAIL: Incorrect result for reg1 or reg2 out");
            $display("\tra1: 0x%b, ra2: 0x%b, wd: 0x%h, rd1: 0x%h, rd2: 0x%h, REFout1: 0x%h REFout2: 0x%h", ra1, ra2, wd, rd1, rd2, REFout1, REFout2);
        end
		else begin 
            $display("PASS: reg and REFout match");
            $display("\tra1: 0x%b, ra2: 0x%b, wd: 0x%h, rd1: 0x%h, rd2: 0x%h, REFout1: 0x%h REFout2: 0x%h", ra1, ra2, wd, rd1, rd2, REFout1, REFout2);
		end
    endtask
  

  // Testing logic:
  initial begin
	/*
    #1;
	assign ra1 = 5'b00001;
	assign ra2 = 5'b00010;
	assign wa = 5'b00011; //write to address 3
	assign we = 0; //no write yet
	assign wd = 32'd13; 
	REFout1 = 32'd0;
	REFout2 = 32'd0;
	
	#Cycle;
	
	checkOutput();
	*/

    // Verify that writing to reg 0 is a nop
	assign wa = 5'd0; 
	assign we = 1;
	assign wd = 32'd69;
	assign ra1 = 5'd0;
	assign ra2 = 5'd0;
	#Cycle;
	REFout1 = 32'd0;
	REFout2 = 32'd0;	
	 
	checkOutput();

    // Verify that data written to any other register is returned the same
    // cycle
    assign wa = 5'd1; //reg 1
	assign ra1 = 5'd1;
	checkOutput();
	#Cycle;
	REFout1 = 32'd69;
	
	checkOutput();
    
    // Verify that the we pin prevents data from being written
    assign we = 0;
	assign wd = 32'd55;
	#Cycle;
	
	checkOutput();	

    // Verify the reads are asynchronous
    // write to reg 2 first

	assign ra1 = 5'd5;
	REFout1 = 32'd0;
	#1;
	checkOutput();

	
    assign we = 1;
	assign ra2 = 5'd2;
	assign wa = 5'd2;
	checkOutput();
	#Cycle; //now 55 is written to reg 2
	assign	ra1 = 5'd0;
	REFout1 = 32'd0;
	REFout2 = 32'd55;
	#1;
	checkOutput();
	

	assign ra1 = 5'd1;
	REFout1 = 32'd69;
	assign ra2 = 5'd0;
	REFout2 = 32'd0;
	
	#1;
	checkOutput();
   
    $display("All tests passed!");
    $finish();
  end
endmodule

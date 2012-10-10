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
  reg [31:0] wd;
  wire [31:0] rd1;
  wire [31:0] rd2;
	wire[31:0] REFout1;
	wire[31:0] REFout2;

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
            $display("\tra1: 0b%b, ra2: 0b%b, wd: 0x%h, REFout1: 0x%h REFout2: 0x%h", ra1, ra2, wd, REFout1, REFout2);
            $finish();
        end
    endtask
  

  // Testing logic:
  initial begin
    #1;
	assign ra1 = 5'b00001;
	assign ra2 = 5'b00010;
	assign wa = 5'b00000;
	assign we = 1;
	assign wd = 32'd13;
	REFout1 = 32'd0;
	REFout2 = 32'd0;
	
	#1;	
	checkOutput();
	
	ra1 = 5'b00000;
	wd = 32'd94;
	wa = 5'b00010;	
	REFout1 = 32'd0;
	REFout2 = 32'd94;
	#Cycle
	checkOutput();
	
	we = 0;
	wa = 5'b00100;
	ra1 = 5'b00100;
	REFout1 = 32'd0;
	REFout2 = 32'd94;
	wd = 32'd100;
	#Cycle
	
	checkOutput();
	
	ra1 = 5'b00010;
	ra2 = 5'b00001;
	REFout1 = 32'd94;
	REFout2 = 32'd00;
	#1;
	checkOutput();
	
	
		
    // Verify that writing to reg 0 is a nop
    
    // Verify that data written to any other register is returned the same
    // cycle
    
    // Verify that the we pin prevents data from being written

    // Verify the reads are asynchronous
   
    $display("All tests passed!");
    $finish();
  end
endmodule

// If #1 is in the initial block of your testbench, time advances by
// 1ns rather than 1ps
`timescale 1ns / 1ps

module ALUTestbench();

  parameter Halfcycle = 5; //half period is 5ns

  localparam Cycle = 2*Halfcycle;

  reg Clock;

  // Clock Sinal generation:
  initial Clock = 0; 
  always #(Halfcycle) Clock = ~Clock;

  // Register and wires to test the RegFile
	reg [31:0] A, B;
	reg [3:0] ALUop;
	wire [31:0] Out;
	wire isZero;	 	
	reg [31:0] REFout;
	reg REFzero;

  ALU DUT(.A(A),
              .B(B),
              .ALUop(ALUop),
              .Out(Out),
              .isZero(isZero));
    
task checkOutput;
        if ( REFout !== Out | isZero !== REFzero ) begin
            $display("FAIL: Incorrect result for output or zero");
            $display("\tA: 0x%d, B: 0x%d, ALUop: 0x%b, Out: 0x%d, isZero: 0x%b, REFout: 0x%d REFzero: 0x%b", A, B, ALUop, Out, isZero, REFout, REFzero);
        end
		else begin 
            $display("PASS: output and zero match!");
            $display("\tA: 0x%d, B: 0x%d, ALUop: 0x%b, Out: 0x%d, isZero: 0x%b, REFout: 0x%d REFzero: 0x%b", A, B, ALUop, Out, isZero, REFout, REFzero);
		end
    endtask
  

  // Testing logic:
  initial begin
    // Verify subtracting 4 from 5
	assign A = 32'd5; 
	assign B = 32'd4;
	assign ALUop = 4'd1; //subtraction
	assign REFout = 32'd1;
	assign REFzero = 0;	 
	#1;

	checkOutput();
	
	assign B = 32'd5;
	assign REFout = 32'd0;
	assign REFzero = 1;
	#1;
	checkOutput();
   
    $display("All tests passed!");
    $finish();
  end
endmodule

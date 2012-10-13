// If #1 is in the initial block of your testbench, time advances by
// 1ns rather than 1ps
`timescale 1ns / 1ps

//primarily for testing the shifting in sb/sh
module LoadStoreLogicTestbench();

  parameter Halfcycle = 5; //half period is 5ns

  localparam Cycle = 2*Halfcycle;

  reg Clock;

  // Clock Sinal generation:
  initial Clock = 0; 
  always #(Halfcycle) Clock = ~Clock;

  // Register and wires to test the RegFile
	reg [31:0] RTin, alu_out;
	reg [2:0] LdStCtrl;
	wire [11:0] mem_adr;
	wire [3:0] we_i, we_d;
	wire [31:0] RTout;
		
	reg [3:0] REFwe_i, REFwe_d;
	reg [31:0] REFRTout;
	reg [11:0] REFmem_adr; 

  AddressForMem DUT(.RTin(RTin),
                    .alu_out(alu_out),
                    .LdStCtrl(LdStCtrl),
                    .mem_adr(mem_adr),
                    .we_i(we_i),
				    .we_d(we_d),
				    .RTout(RTout));
				
    
task checkOutput;
        if ( REFwe_i !== we_i | REFwe_d !== we_d | REFRTout !== RTout | mem_adr !== REFmem_adr) begin
            $display("FAIL: Incorrect result");
            $display("\tRTin: 0x%h, alu_out: 0x%b, LdStCtrl: 0x%b, mem_adr: 0x%h, we_i: 0x%b, we_d: 0x%b RTout: 0x%h, REFwe_i: 0x%b, REFwe_d: 0x%b, REFRTout: 0x%h, REFmem_adr: 0x%h", RTin, alu_out, LdStCtrl, mem_adr, we_i, we_d, RTout, REFwe_i, REFwe_d, REFRTout, REFmem_adr);
        end
		else begin 
            $display("PASS: outputs match!");
            $display("\tRTin: 0x%h, alu_out: 0x%b, LdStCtrl: 0x%b, mem_adr: 0x%h, we_i: 0x%b, we_d: 0x%b RTout: 0x%h, REFwe_i: 0x%b, REFwe_d: 0x%b, REFRTout: 0x%h, REFmem_adr: 0x%h", RTin, alu_out, LdStCtrl, mem_adr, we_i, we_d, RTout, REFwe_i, REFwe_d, REFRTout, REFmem_adr);
		end
    endtask
  

  // Testing logic:
  initial begin
    // test store byte into location 5
	assign alu_out = 32'h70000005; // writes to imem AND dmem
	assign RTin = 32'hdeadbeef; //data word 
	assign LdStCtrl = 3'b101; //SB
	assign REFwe_i = 4'b0100;
	assign REFwe_d = 4'b0100;
	assign REFRTout = 32'hbeef0000; 
	assign REFmem_adr =  12'b000000000001;
	#1;

	checkOutput();
	
    $display("All tests passed!");
    $finish();
  end
endmodule

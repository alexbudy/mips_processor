//Module LoadStoreLogic
//Desc: Load/Store Logic for dealing with byte selection
//Inputs Interface:
//	word: word from ALU/regfile[31:0]
//	LdStCtrl: Control for different loads/stores[2:0]
//Outputs
//	res: correct byte(s) chosen [31:0]
//
//For reference:
//	LdStCtrl: 3'b000-LB, default, 001-LH, 010-LW, 011-LBU 100-LHU, 101-SB, 110-SH, 111-SW

//for generating address for dmem and imem, we mask bits, and data shift to
//align the bytes
module AddressForMem (
	input[31:0] RTin,
	input[31:0] alu_out,
	input[2:0] LdStCtrl, //tells us what kind of load/store it is
	output[11:0] mem_adr, //adress
	output reg [3:0] we_i,we_d, 
	output reg [31:0] RTout
);

	reg [3:0] we;	
	assign mem_adr = alu_out[13:2];
	
	//align byte/hw/w for mem write, set wire enable bits
	always@(*) begin
		case(LdStCtrl)
			3'b000,3'b001,3'b010,3'b011,3'b100: //LB,LH,LW,LBU,LHU
				begin
					RTout = RTin;
					we = 4'b0000;
				end
			3'b111://SW
				begin
					we = 4'b1111;
					RTout = RTin;
				end
			3'b110://SH
				begin
					we = 4'b1100 >> 2*alu_out[0];
					RTout = RTin << 16 - 16*alu_out[0];
				end
			3'b101://SB
				begin
					we = 4'b1000 >> alu_out[1:0];
					RTout = RTin << 24 - 8*alu_out[1:0];
				end
		endcase	
	end
	//for imem/dmem writing
	always@(*) begin
		if (!alu_out[31] & alu_out[29])
			we_i = we;
		else 
			we_i = 4'b0000;

		if (!alu_out[31] & alu_out[28])
			we_d = we;
		else 
			we_d = 4'b0000;
	end
endmodule


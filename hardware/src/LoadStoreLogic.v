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

//
module AddressForMem (
	input[31:0] RTin,
	input[31:0] word,
	input[2:0] LdStCtrl,
	output[11:0] res
	output reg we,
	output reg [31:0] RTout
);
/*
	always@(*) begin
		case(LdStCtrl)
			3'b010, 3'b111: //LW, SW
				res = word & 32'hfffffffc;
			3'b001, 3'b110: //LH, SH
				res = word & 32'hfffffffe;
			default:
				res = word;
	end
*/
				
	res = word[11:0]&12'b111111111100;
	always@(*) begin
		case(LdStCtrl)
			3'b000,3'b001,3'b010,3'b011,3'b100,: //LB,LH,LW,LBU,LHU
				RTout = RTin;
				we = 4'b0000;
			3'b111://SW
				we = 4'b1111;
				RTout = RTin;
			3'b110://SH
				we = 4'b1100 >> 2*word[0];
				RTout = RTin >>16*word[0];
			3'b101://SB
				we = 4'b1000 >> word[1:0];
				RTout = RTin >>8*word[1:0];
		endcase	
	end
endmodule


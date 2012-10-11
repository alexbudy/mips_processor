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
module AddressForMem (input[31:0] word,
	input[2:0] LdStCtrl,
	output[31:0] res
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
endmodule


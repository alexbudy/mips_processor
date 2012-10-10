module ControlUnit(input[4:0] rt, 
				   input[5:0] opcode,
				   input[5:0] funct,
				   output PCPlus8, RegDest, ALURegSel,JALCtrl, RegWrite,
						  MemWrite, MemToReg, 
 				   output [3:0] ALUCtrl, ALUSrcB, LdStCtrl,
				   output [1:0] JumpBranch	
					); 
	
	case	

endmodule

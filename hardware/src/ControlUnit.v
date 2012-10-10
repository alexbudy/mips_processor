//Module ControlUnit
//Desc: Control Unit
//Inputs Interface:
//	rt: Inst[20:16]
//	opcode: Inst[31:26]
//	funct: Inst[5:0]
//Outputs:
//	PCPlus8: Turns 1 for JAL instruction
//	RegDest: 1 for R-type, J-type and 0 for I-type
//	ALURegSel: 0 for I-type,J-type,R-type[2], 1 otherwise
//		(R-type[2] refers to: ADDU,SUBU,AND...)
//	ALUCtrl[3:0]: See aludec.v
//	JALCtrl: 1 for JAL
//	ALUSrcB: 0'b000-RT,001-RS,010-SEXT(IMM),011-ZEXT(IMM),100-32'd0,101-shamt
//	RegWrite: 1 except for stores, J,JR,and branches
//	MemWrite: 1 for stores
//	MemToReg: 1 for loads
//	LdStCtrl: 3'b000-LB, default, 001-LH, 010-LW, 011-LBU 100-LHU, 101-SB, 110-SH, 111-SW
//	JumpBranch[1:0]: 00-no jump, 01-J,JAL,10-JR,JALR,11-Branch

`include "Opcode.vh"
`include "ALUop.vh"
   
module ControlUnit(input[4:0] rt, 
	   input[5:0] opcode,
	   input[5:0] funct,
	   output PCPlus8, RegDest, ALURegSel,JALCtrl, RegWrite, MemWrite, MemToReg, 
 	   output [3:0] ALUCtrl,
	   output [2:0] ALUSrcB, LdStCtrl,
	   output [1:0] JumpBranch	
);

ALUdec aludec(.funct(funct),
		.opcode(opcode),
		.ALUop(ALUCtrl)
		); 
	
always@(*) begin
	case(opcode)
		`RTYPE:
			PCPlus8 = 1'b0;
			RegDest = 1'b1;
			JALCtrl = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			MemtoReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 2'b00;
			case(funct)
				`SLL, `SRL, `SRA: ALUSrcB = 3'b101;
						ALURegSel = 1'b1;
				`SLLV, `SRLV, `SRAV: ALUSrcB = 3'b001;
						ALURegSel = 1'b1;
				else ALUSrcB = 3'b000;
						ALURegSel = 1'b0;
			endcase
		`LB: 
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			MemtoReg = 1'b1;
			LdStCtrl = 3'b000;
			JumpBranch = 2'b00;
		`LH:
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			MemtoReg = 1'b1;
			LdStCtrl = 3'b001;
			JumpBranch = 2'b00;
		`LW:
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			MemtoReg = 1'b1;
			LdStCtrl = 3'b010;
			JumpBranch = 2'b00;
		`LBU:
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			MemtoReg = 1'b1;
			LdStCtrl = 3'b011;
			JumpBranch = 2'b00;
		`LHU:
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			MemtoReg = 1'b1;
			LdStCtrl = 3'b100;
			JumpBranch = 2'b00;
		`SB:
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b0;
			MemWrite = 1'b1;
			MemtoReg = 1'b0;
			LdStCtrl = 3'b101;
			JumpBranch = 2'b00;
			
		`SH, `SW, `ADDIU: 
		`SLTI: 
		`SLTIU: 
		`ANDI: 
		`ORI: 
		`XORI: 
		`LUI: 
	endcase	
end

endmodule

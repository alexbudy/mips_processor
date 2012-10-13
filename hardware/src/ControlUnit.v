//Module ControlUnit
//Desc: Control Unit
//Inputs Interface:
//	rt: Inst[20:16]
//	opcode: Inst[31:26]
//	funct: Inst[5:0]
//Outputs:
//	PCPlus8: Turns 1 for JAL,JALR instruction
//	RegDest: 1 for R-type, J-type and 0 for I-type
//	ALURegSel: 0 for I-type,J-type,R-type[2], 1 otherwise
//		(R-type[2] refers to: ADDU,SUBU,AND...)
//	ALUCtrl[3:0]: See aludec.v
//	JALCtrl: 1 for JAL
//	ALUSrcB: 3'b000-RT,001-RS,010-SEXT(IMM),011-ZEXT(IMM),100-32'd0,101-shamt
//	RegWrite: 1 except for stores, J,JR,and branches
//	MemToReg: 1 for loads
//	LdStCtrl: 3'b000-LB, default, 001-LH, 010-LW, 011-LBU 100-LHU, 101-SB, 110-SH, 111-SW
//	JumpBranch[3:0]: 0000-no jump, 0001-J,JAL,0010-JR,JALR,0011-BEQ,
//	0100-BNE, 0101-BLEZ, 0110-BGTZ, 0111-BLTZ, 1000-BGEZ

`include "Opcode.vh"
`include "ALUop.vh"
   
module ControlUnit(input[4:0] rt, 
	   input[5:0] opcode,
	   input[5:0] funct,
	   output reg PCPlus8, RegDest, ALURegSel,JALCtrl, RegWrite, MemToReg,
 	   output reg [3:0] ALUCtrl, 
	   output reg [2:0] ALUSrcB, LdStCtrl,
	   output reg [3:0] JumpBranch	
);

ALUdec aludec(.funct(funct),
		.opcode(opcode),
		.ALUop(ALUCtrl)
		); 
	
/*
always@(*) begin
	case(opcode)
		`RTYPE:
			case(funct)
				`SLL, `SRL, `SRA: ALUSrcB = 3'b101;
						ALURegSel = 1'b1;
						PCPlus8 = 1'b0;
						RegDest = 1'b1;
						JALCtrl = 1'b0;
						RegWrite = 1'b1;
						MemtoReg = 1'b0;
						LdStCtrl = 3'b000;
						JumpBranch = 4'b0000;
				`SLLV, `SRLV, `SRAV: ALUSrcB = 3'b001;
						ALURegSel = 1'b1;
						PCPlus8 = 1'b0;
						RegDest = 1'b1;
						JALCtrl = 1'b0;
						RegWrite = 1'b1;
						MemtoReg = 1'b0;
						LdStCtrl = 3'b000;
						JumpBranch = 4'b0000;
				`JR:    PCPlus8 = 1'b0;
					RegDest = 1'b1
					ALURegSel = 1'b0;
					JALCtrl = 1'b0;
					ALUSrcB = 3'b000;
					RegWrite = 1'b0;
					MemToReg = 1'b0;
					LdStCtrl = 3'b000;
					JumpBranch = 4'b0010;
				`JALR:  PCPlus8 = 1'b1;
					RegDest = 1'b1
					ALURegSel = 1'b0;
					JALCtrl = 1'b0;
					ALUSrcB = 3'b000;
					RegWrite = 1'b1;
					MemToReg = 1'b0;
					LdStCtrl = 3'b000;
					JumpBranch = 4'b0010;
				default: 
					PCPlus8 = 1'b0;
					RegDest = 1'b1;
					ALURegSel = 1'b0;
					JALCtrl = 1'b0;
					ALUSrcB = 3'b000;
					RegWrite = 1'b1;
					MemtoReg = 1'b0;
					LdStCtrl = 3'b000;
					JumpBranch = 4'b0000;
			endcase
		`LB: 
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b1;
			MemtoReg = 1'b1;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0000;
		`LH:
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b1;
			MemtoReg = 1'b1;
			LdStCtrl = 3'b001;
			JumpBranch = 4'b0000;
		`LW:
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b1;
			MemtoReg = 1'b1;
			LdStCtrl = 3'b010;
			JumpBranch = 4'b0000;
		`LBU:
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b1;
			MemtoReg = 1'b1;
			LdStCtrl = 3'b011;
			JumpBranch = 4'b0000;
		`LHU:
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b1;
			MemtoReg = 1'b1;
			LdStCtrl = 3'b100;
			JumpBranch = 4'b0000;
		`SB:
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b0;
			MemtoReg = 1'b0;
			LdStCtrl = 3'b101;
			JumpBranch = 4'b0000;
			
		`SH:
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b0;
			MemtoReg = 1'b0;
			LdStCtrl = 3'b110;
			JumpBranch = 4'b0000;

		`SW:
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b0;
			MemtoReg = 1'b0;
			LdStCtrl = 3'b111;
			JumpBranch = 4'b0000;
		`ADDIU: 
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b1;
			MemtoReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0000;
		`SLTI: 
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b1;
			MemtoReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0000;
		`SLTIU: 
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b1;
			MemtoReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0000;
		`ANDI: 
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b011;
			RegWrite = 1'b1;
			MemtoReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0000;
		`ORI: 
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b011;
			RegWrite = 1'b1;
			MemtoReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0000;
		`XORI: 
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b011;
			RegWrite = 1'b1;
			MemtoReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0000;
		`LUI: 
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b011;
			RegWrite = 1'b1;
			MemtoReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0000;
		`J:
			PCPlus8 = 1'b0;
			RegDest = 1'b1;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b011;
			RegWrite = 1'b0;
			MemtoReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0001;
		`JAL:
			PCPlus8 = 1'b1;
			RegDest = 1'b1;
			ALURegSel = 1'b0;
			JALCtrl = 1'b1;
			ALUSrcB = 3'b011;
			RegWrite = 1'b1;
			MemtoReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0001;
		`BEQ:
			PCPlus8 = 1'b0;
			RegDest = 1'b1;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b000;
			RegWrite = 1'b0;
			MemtoReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0011;
		`BNE:
			PCPlus8 = 1'b0;
			RegDest = 1'b1;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b000;
			RegWrite = 1'b0;
			MemtoReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0100;
		`BLEZ:
			PCPlus8 = 1'b0;
			RegDest = 1'b1;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b100;
			RegWrite = 1'b0;
			MemtoReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0101;
		`BGTZ:
			PCPlus8 = 1'b0;
			RegDest = 1'b1;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b100;
			RegWrite = 1'b0;
			MemtoReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0110;
		`BLTZ_BGEZ:
			PCPlus8 = 1'b0;
			RegDest = 1'b1;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b100;
			RegWrite = 1'b0;
			MemtoReg = 1'b0;
			LdStCtrl = 3'b000;
			if (rt=5'b00000)begin
			JumpBranch = 4'b0111;
			end
			else Jumpbranch = 4'b1000;
		
	endcase	
end
*/
endmodule

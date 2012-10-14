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

wire [3:0] ALUCtrlwire;

ALUdec aludec(.funct(funct),
		.opcode(opcode),
		.ALUop(ALUCtrlwire)
		); 

	
always@(*) begin
	ALUCtrl = ALUCtrlwire;
	case(opcode)
		`RTYPE:
			case(funct)
				`SLL, `SRL, `SRA:begin
						ALUSrcB = 3'b101;
						ALURegSel = 1'b1;
						PCPlus8 = 1'b0;
						RegDest = 1'b1;
						JALCtrl = 1'b0;
						RegWrite = 1'b1;
						MemToReg = 1'b0;
						LdStCtrl = 3'b000;
						JumpBranch = 4'b0000;
						end
				`SLLV, `SRLV, `SRAV:begin
						ALUSrcB = 3'b001;
						ALURegSel = 1'b1;
						PCPlus8 = 1'b0;
						RegDest = 1'b1;
						JALCtrl = 1'b0;
						RegWrite = 1'b1;
						MemToReg = 1'b0;
						LdStCtrl = 3'b000;
						JumpBranch = 4'b0000;
						end
				`JR:    begin
					PCPlus8 = 1'b0;
					RegDest = 1'b1;
					ALURegSel = 1'b0;
					JALCtrl = 1'b0;
					ALUSrcB = 3'b000;
					RegWrite = 1'b0;
					MemToReg = 1'b0;
					LdStCtrl = 3'b000;
					JumpBranch = 4'b0010;
					end
				`JALR:  begin
					PCPlus8 = 1'b1;
					RegDest = 1'b1;
					ALURegSel = 1'b0;
					JALCtrl = 1'b0;
					ALUSrcB = 3'b000;
					RegWrite = 1'b1;
					MemToReg = 1'b0;
					LdStCtrl = 3'b000;
					JumpBranch = 4'b0010;
					end
				default:begin 
					PCPlus8 = 1'b0;
					RegDest = 1'b1;
					ALURegSel = 1'b0;
					JALCtrl = 1'b0;
					ALUSrcB = 3'b000;
					RegWrite = 1'b1;
					MemToReg = 1'b0;
					LdStCtrl = 3'b000;
					JumpBranch = 4'b0000;
					end
			endcase
		`LB: 	begin
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b1;
			MemToReg = 1'b1;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0000;
			end
		`LH:	begin
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b1;
			MemToReg = 1'b1;
			LdStCtrl = 3'b001;
			JumpBranch = 4'b0000;
			end
		`LW:	begin
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b1;
			MemToReg = 1'b1;
			LdStCtrl = 3'b010;
			JumpBranch = 4'b0000;
			end
		`LBU:	begin
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b1;
			MemToReg = 1'b1;
			LdStCtrl = 3'b011;
			JumpBranch = 4'b0000;
			end
		`LHU:	begin
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b1;
			MemToReg = 1'b1;
			LdStCtrl = 3'b100;
			JumpBranch = 4'b0000;
			end
		`SB:	begin
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b0;
			MemToReg = 1'b0;
			LdStCtrl = 3'b101;
			JumpBranch = 4'b0000;
			end
			
		`SH:	begin
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b0;
			MemToReg = 1'b0;
			LdStCtrl = 3'b110;
			JumpBranch = 4'b0000;
			end

		`SW:	begin
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b0;
			MemToReg = 1'b0;
			LdStCtrl = 3'b111;
			JumpBranch = 4'b0000;
			end
		`ADDIU: begin
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b1;
			MemToReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0000;
			end
		`SLTI: 	begin
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b1;
			MemToReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0000;
			end
		`SLTIU: begin
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b010;
			RegWrite = 1'b1;
			MemToReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0000;
			end
		`ANDI: 	begin
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b011;
			RegWrite = 1'b1;
			MemToReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0000;
			end
		`ORI: 	begin
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b011;
			RegWrite = 1'b1;
			MemToReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0000;
			end
		`XORI: 	begin
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b011;
			RegWrite = 1'b1;
			MemToReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0000;
			end
		`LUI: 	begin
			PCPlus8 = 1'b0;
			RegDest = 1'b0;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b011;
			RegWrite = 1'b1;
			MemToReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0000;
			end
		`J:	begin
			PCPlus8 = 1'b0;
			RegDest = 1'b1;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b011;
			RegWrite = 1'b0;
			MemToReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0001;
			end
		`JAL:	begin
			PCPlus8 = 1'b1;
			RegDest = 1'b1;
			ALURegSel = 1'b0;
			JALCtrl = 1'b1;
			ALUSrcB = 3'b011;
			RegWrite = 1'b1;
			MemToReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0001;
			end
		`BEQ:	begin
			PCPlus8 = 1'b0;
			RegDest = 1'b1;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b000;
			RegWrite = 1'b0;
			MemToReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0011;
			end
		`BNE:	begin
			PCPlus8 = 1'b0;
			RegDest = 1'b1;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b000;
			RegWrite = 1'b0;
			MemToReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0100;
			end
		`BLEZ:	begin
			PCPlus8 = 1'b0;
			RegDest = 1'b1;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b100;
			RegWrite = 1'b0;
			MemToReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0101;
			end
		`BGTZ:	begin
			PCPlus8 = 1'b0;
			RegDest = 1'b1;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b100;
			RegWrite = 1'b0;
			MemToReg = 1'b0;
			LdStCtrl = 3'b000;
			JumpBranch = 4'b0110;
			end
		`BLTZ_BGEZ:
			begin
			PCPlus8 = 1'b0;
			RegDest = 1'b1;
			ALURegSel = 1'b0;
			JALCtrl = 1'b0;
			ALUSrcB = 3'b100;
			RegWrite = 1'b0;
			MemToReg = 1'b0;
			LdStCtrl = 3'b000;
			if (rt==5'b00000) JumpBranch = 4'b0111;
			else JumpBranch = 4'b1000;
			end	
	endcase	
end
endmodule

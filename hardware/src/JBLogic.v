//Module JBLogic 
//Desc:Jump Branch Logic
//Inputs Interface:
//	JumpBranch[3:0]: 0000-no jump, 0001-J,JAL,0010-JR,JALR,0011-BEQ,
//	0100-BNE, 0101-BLEZ, 0110-BGTZ, 0111-BLTZ, 1000-BGEZ
//	ALU_out[31:0]:slt
//	ALU_zero: A-B==0
//Outputs:
//	Jump_sel[1:0]: 2'b00-> PC+4, 2'b01-> PC+4+SEXT(imm), 2'b10->
//	{PC[31:28],target,2'b0}, 11-> RS

module JBLogic(
	input[3:0]	JumpBranch,
	input[31:0]	ALU_out,
	input		ALU_zero,
	output[1:0] Jump_sel
);

always@(*)begin
	case(JumpBranch)
		0000://no jump
			Jump_sel = 2'b00;
		0001://J,JAL
			Jump_sel = 2'b10;
		0010://JR,JALR
			Jump_sel = 2'b11;
		0011://BEQ
			if(ALU_zero) Jump_sel = 2'b01;
			else Jump_sel = 2'b00;
		0100://BNE
			if(!ALU_zero) Jump_sel = 2'b01;
			else Jump_sel = 2'b00;
		0101://BLEZ
			if(ALU_out == 32'd1 | ALU_zero) Jump_sel = 2'b01;
			else Jump_sel = 2'b00;
		0110://BGTZ
			if(ALU_out != 32'd1 & !ALU_zero) Jump_sel = 2'b01;
			else Jump_sel = 2'b00;
		0111://BLTZ
			if(ALU_out == 32'd1) Jump_sel = 2'b01;
			else Jump_sel = 2'b00;
		1000://BGEZ
			if(ALU_out != 32'd1) Jump_sel = 2'b01;
			else Jump_sel = 2'b00;
	endcase
end

endmodule


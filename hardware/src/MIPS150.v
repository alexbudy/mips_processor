
module MIPS150(
        input clk, rst, stall,
        input FPGA_SERIAL_RX,
        output FPGA_SERIAL_TX
);
 
// Use this as the top-level module for your CPU. You
// will likely want to break control and datapath out
// into separate modules that you instantiate here. 
wire we_reg, AequalsB;    
                         


//Instantiate all wires first
//

reg RegDest_XY, ALURegSel_XY, RegWrite_XY, RegWrite_YZ, MemToReg_XY, MemToReg_YZ, inst_XY, PCPlus8_XY, PCPlus8_YZ, JALCtrl_XY;
reg [2:0] ALUSrcB_XY, LdStCtrl_XY, LdStCtrl_YZ;
reg [3:0] ALUCtrl_XY, JumpBranch_XY;
reg [31:0] PCout_XY, PCoutplus4_XY, PCoutplus4_YZ, ALU_out_YZ, wd_YZ;
reg [4:0] a3_YZ;

reg PCoutreg;


wire RegDest_X, RegDest_Y, ALURegSel_X,ALURegSel_Y,RegWrite_X, RegWrite_Y, RegWrite_Z, MemToReg_X,MemToReg_Y,MemToReg_Z,  DataOutValid, DataInReady, DataInValid, DataOutReady, PCPlus8_X, PCPlus8_Y, PCPlus8_Z, JALCtrl_X, JALCtrl_Y;
wire [1:0] JBout;                                     
wire [2:0] ALUSrcB_X, ALUSrcB_Y,LdStCtrl_X,LdStCtrl_Y,LdStCtrl_Z;
wire [3:0] ALUCtrl_X, ALUCtrl_Y, JumpBranch_X, JumpBranch_Y, we_i, we_d;
wire [31:0] A, B, PC_X, PCout_X, PCout_Y, PCoutplus4_X, PCoutplus4_Y, PCoutplus4_Z, PC_shifted_Y, RS, RT, rd1,rd2,wd,ALU_out_Y,ALU_out_Z, wd_y, wd_z, RT_shifted, UARTout, MemUARTout, PC_in, inst_X, inst_Y, dmem_out;
wire [7:0] UARTwrite, UARTread;
wire [11:0] mem_adr;
wire [4:0] a3_Z, a3_Y;
wire [31:0] LLout; //Load logic out

wire PCout;

assign RegDest_Y = RegDest_XY;
assign ALURegSel_Y = ALURegSel_XY;
assign RegWrite_Y = RegWrite_XY;
assign RegWrite_Z = RegWrite_YZ;
assign MemToReg_Y = MemToReg_XY;
assign inst_Y = inst_XY;
assign PCPlus8_Y = PCPlus8_XY;
assign PCPlus8_Z = PCPlus8_YZ;

assign JALCtrl_Y = JALCtrl_XY;
assign ALUSrcB_Y = ALUSrcB_XY;
assign LdStCtrl_Y = LdStCtrl_XY;
assign LdStCtrl_Z = LdStCtrl_YZ;
assign ALUCtrl_Y = ALUCtrl_XY;
assign JumpBranch_Y = JumpBranch_XY;
assign PCout_Y = PCout_XY;
assign PCoutplus4_Y = PCoutplus4_XY;
assign PCoutplus4_Z = PCoutplus4_YZ;
assign ALU_out_Z = ALU_out_YZ;
assign wd_Z = wd_YZ;
assign a3_Z = a3_Y;

assign PCout = PCoutreg;

RegFile RegFile(                            
            .clk(clk),                       
            .we(we_reg),
            .ra1(inst_Y[25:21]),   
            .ra2(inst_Y[20:16]),  
            .wa(a3_Z),
            .wd(wd),  
            .rd1(rd1),
            .rd2(rd2)
);                  
                   
ALU ALU(          
            .A(A),
            .B(B),
            .ALUop(ALUCtrl_Y),
            .Out(ALU_out_Y),   
            .AequalsB(AequalsB)
);                            

JBLogic JBLogic(
			.JumpBranch(JumpBranch_Y),
			.ALU_out(ALU_out_Y),
			.ALU_zero(AequalsB),
			.Jump_sel(JBout)
);

AddressForMem AddressForMem(
            .RTin(RT),  
            .alu_out(ALU_out_Y),
            .LdStCtrl(LdStCtrl_Y), 
            .mem_adr(mem_adr),    
            .we_i(we_i),         
            .we_d(we_d),        
            .RTout(RT_shifted)
);                            

LoadLogic LoadLogic(
			.word(dmem_out),
			.LdStCtrl(LdStCtrl_Z),
			.byte_sel(ALU_out_Z[1:0]),
			.word_out(LLout)
);
                  
UART UART(        
        .Clock(clk),
	.Reset(rst),
	.DataIn(UARTwrite),    
	.DataInValid(DataInValid),
	.DataInReady(DataInReady),
	.DataOut(UARTread),
	.DataOutValid(DataOutValid),
	.DataOutReady(DataOutReady),
	.SIn(FPGA_SERIAL_RX),
	.SOut(FPGA_SERIAL_TX)     
);              
               
UARTdec UARTdec(
	.WD(RT),
	.A(ALU_out_Y),
	.Read(UARTread),
	.LdStCtrl(LdStCtrl_Y),
	.DataInReady(DataInReady),
	.DataOutValid(DataOutValid),
	.Write(UARTwrite),
	.Out(UARTout),
	.DataInValid(DataInValid),
	.DataOutReady(DataOutReady)
);

ControlUnit ControlUnit(
	.rt(inst_X[20:16]),
	.opcode(inst_X[31:26]),
	.funct(inst_X[5:0]),
	.PCPlus8(PCPlus8_X),
	.RegDest(RegDest_X),
	.ALURegSel(ALURegSel_X),
	.JALCtrl(JALCtrl_X),
	.RegWrite(RegWrite_X),
	.MemToReg(MemToReg_X),
	.ALUCtrl(ALUCtrl_X),
	.ALUSrcB(ALUSrcB_X),
	.LdStCtrl(LdStCtrl_X),
	.JumpBranch(JumpBranch_X)
);

always @(posedge clk)begin
	RegDest_XY <= RegDest_X;
	ALURegSel_XY <= ALURegSel_X;
	RegWrite_XY <= RegWrite_X;
	RegWrite_YZ <= RegWrite_Y;
	MemToReg_XY <= MemToReg_X;
	MemToReg_YZ <= MemToReg_Y;
	inst_XY <= inst_X;
	PCPlus8_XY <= PCPlus8_X;
	PCPlus8_YZ <= PCPlus8_Y;
	
	JALCtrl_XY <= JALCtrl_X;
	ALUSrcB_XY <= ALUSrcB_X;
	LdStCtrl_XY <= LdStCtrl_X;
	LdStCtrl_YZ <= LdStCtrl_Y;
	ALUCtrl_XY <= ALUCtrl_X;
	JumpBranch_XY <= JumpBranch_X;
	PCout_XY <= PCout_X;
	PCoutplus4_XY <= PCoutplus4_X;
	PCoutplus4_YZ <= PCoutplus4_Y;
	ALU_out_YZ <= ALU_out_Y;
	a3_YZ <= a3_Y;

	PCoutreg <= PC_X;

end
  
//memory instantiations
imem_blk_ram imem_blk_ram(
	.clka(clk),	
	.ena(1'b1),
	.wea(we_i),
	.addra(mem_adr),
	.dina(RT_shifted),
	.clkb(clk),
	.addrb(PC_X[13:2]),
	.doutb(inst_X)
);

dmem_blk_ram dmem_blk_ram(
	.clka(clk),
	.ena(1'b1),
	.wea(we_d),
	.addra(mem_adr),
	.dina(RT_shifted),
	.douta(dmem_out)
);

//stage one

reg [31:0] tempPC;
always@(*) begin
	case(JBout)
		2'b00: tempPC = PCoutplus4_X;	
		2'b01: tempPC = PC_shifted_Y;	
		2'b10: tempPC = {PCout_Y[31:28],inst_Y[25:0] ,2'b00 };	
		2'b11: tempPC = RS;	
	endcase
end

assign PC_in = tempPC;
assign PC_X = rst ? 32'd0:PC_in; 
assign PCoutplus4_X = PCout_X + 4;

//stage two

reg[31:0] tempB;
always@(*) begin
	case(ALUSrcB_Y) 
		3'b000: tempB = RT;
		3'b001: tempB = RS;
		3'b010: tempB = {{16{inst_Y[15]}}, inst_Y[15:0]};
		3'b011: tempB = {16'd0, inst_Y[15:0]};
		3'b100: tempB = 32'd0;
		3'b101: tempB = {27'd0, inst_Y[10:6]};
	endcase	
end
assign B = tempB;

assign wd = (PCPlus8_Z ? PCoutplus4_Z+4:wd_Z);  
assign a3_Y = (JALCtrl_Y ? 5'd31: (RegDest_Y ? inst_Y[15:11]:inst_Y[20:16]));
assign PC_shifted_Y = PCoutplus4_Y + ({{16{inst_Y[15]}}, inst_Y[15:0]} << 2); 
assign RS = ((a3_Z == inst_Y[25:21] & RegWrite_Z) ? wd : rd1); 
assign RT = ((a3_Z == inst_Y[20:16] & RegWrite_Z) ? wd : rd2); 
assign A = (ALURegSel_Y ? RT : RS);

//stage three
assign wd_z = (MemToReg_Z ? (ALU_out_Z[31:28] == 4'd0 ? UARTout : LLout) : ALU_out_Z);

endmodule

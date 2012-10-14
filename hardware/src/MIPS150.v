
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
reg RegDest_X, RegDest_Y, ALURegSel_X,ALURegSel_Y,RegWrite_X, RegWrite_Y, RegWrite_Z, MemToReg_X,MemToReg_Y,MemToReg_Z, inst_X, inst_Y, DataOutValid, DataInReady, DataInValid, DataOutReady, PCPlus8_X, PCPlus8_Y, dmem_out;
reg [1:0] JBout, JALCtrl_X, JALCtrl_Y;                                              
reg [2:0] ALUSrcB_X, ALUSrcB_Y,LdStCtrl_X,LdStCtrl_Y,LdStCtrl_Z;
reg [3:0] ALUCtrl_X, ALUCtrl_Y, JumpBranch_X, JumpBranch_Y, we_i, we_d;
reg [31:0] PC_X, PCout_X, PCout_Y, PCoutplus4_X, PCoutplus4_Y, PCoutplus4_Z, PC_shifted_Y, RS, RT, rd1,rd2,wd,RT,ALU_out_Y,ALU_out_Z, wd_y, wd_z, RT_shifted, UARTout, MemUARTout, PC_in;
reg [7:0] UARTwrite, UARTread;
reg [11:0] mem_adr;
reg [4:0] a3_Z, a3_Y;

RegFile RegFile(                            
            .clk(clk),                       
            .we(we_reg),
            .ra1(inst_2[25:21]),   
            .ra2(inst_2[20:16]),  
            .ra3(a3_Z),
            .wd(wd),  
            .rd1(rd1),
            .rd2(rd2)
);                  
                   
ALU ALU(          
            .A(A),
            .B(B),
            .ALUop(ALUCtrl_Y),
            .Out(ALU_Out),   
            .AequalsB(AequalsB)
);                            

AddressForMem AddressForMem(
            .RTin(RT)      
            .alu_out(ALU_out),
            .LdStCtrl(LdStCtrl_Y), 
            .mem_adr(mem_adr),    
            .we_i(we_i),         
            .we_d(we_d),        
            .RTout(RT_shifted),
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
	RegDest_Y <= RegDest_X;
	ALURegSel_Y <= ALURegSel_X;
	RegWrite_Y <= RegWrite_X;
	RegWrite_Z <= RegWrite_Y;
	MemToReg_Y <= MemToReg_X;
	MemToReg_Z <= MemToReg_Y;
	inst_Y <= inst_X;
	JALCtrl_Y <= JALCtrl_X;
	ALUSrcB_Y <= ALUSrcB_X;
	ALUCtrl_X <= ALUCtrl_Y;
	JumpBranch_Y <= JumpBranch_X;
	ALU_out_Z <= ALU_out_Y;
	a3_Z <= a3_Y;

	ALU_SrcB_Y <= ALU_SrcB_X;
	LdStCtrl_Y <= LdStCtrl_X;
	LdStCtrl_Z <= LdStCtrl_Y;
	ALUCtrl_Y <= ALUCtrl_X;
	JumpBranch_Y <= JumpBranch_X;
	PCout_Y <= PCout_X;
	PCoutplus4_Y <= PCoutplus4_X;
	PCoutplus4_Z <= PCoutplus4_Y;
	
	PCout <= PC_X;

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
	.doutb(inst_x)
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
always@(*) begin
	case(JBout) begin
		2'b00: PC_in = PCout4_X;	
		2'b01: PC_in = PC_shifted_Y;	
		2'b10: PC_in = {PCout_Y[31:28],inst_Y[25:0] ,2'b00 };	
		2'b11: PC_in = RS;	
	endcase

	PC_X = rst ? PC_in:32'd0; 
	PCout4_X = PCout_X + 4;
end

//stage two
always@(*) begin
	case(ALUSrcB_Y) begin
		3'b000: B = RT;
		3'b001: B = RS;
		3'b010: B = {16{inst_Y[15]}, inst_Y[15:0]};
		3'b011: B = {16'd0, inst_Y[15:0]};
		3'b100: B = 32'd0;
		3'b101: B = {27'd0, inst_Y[10:6]};
	endcase	
end

wd = (inst_Y ? PCout4_Y+4:wd_Z);  
a3_Y = (JALCtrl_Y ? 5'd31: (RegDest_Y ? inst_Y[15:11]:inst_Y[20:16]));

endmodule

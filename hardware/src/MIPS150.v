module MIPS150(
    input clk,
    input rst,

    // Serial
    input FPGA_SERIAL_RX,
    output FPGA_SERIAL_TX,

    // Memory system connections
    output [31:0] dcache_addr,
    output [31:0] icache_addr,
    output [3:0] dcache_we,
    output [3:0] icache_we,
    output dcache_re,
    output icache_re,
    output [31:0] dcache_din,
    output [31:0] icache_din,
    input [31:0] dcache_dout,
    input [31:0] instruction,
    input stall
);
 
// Use this as the top-level module for your CPU. You
// will likely want to break control and datapath out
// into separate modules that you instantiate here. 
wire AequalsB;    
                         
//Instantiate all registers first

reg RegWrite_YZ, MemToReg_YZ, PCPlus8_YZ;
reg [31:0] inst_XY;
reg [2:0] LdStCtrl_YZ;
reg [31:0] PCoutplus4_XY, PCoutplus4_YZ, ALU_out_YZ, UARTout_YZ, RT_shifted_YZ;
reg [4:0] a3_YZ;
reg [31:0] PCoutreg;
reg [31:0] PCout_XY, PCout_YZ;
reg is_bios;

wire RegDest_Y, ALURegSel_Y, RegWrite_Y, RegWrite_Z, MemToReg_Y,MemToReg_Z,  DataOutValid, DataInReady, DataInValid, DataOutReady, PCPlus8_Y, PCPlus8_Z, JALCtrl_Y;
wire [1:0] JBout;                                     
wire [2:0] ALUSrcB_Y, LdStCtrl_Y,LdStCtrl_Z;
wire [3:0] ALUCtrl_Y, JumpBranch_Y, we_i, we_d;
wire [31:0] PCout_Y, PCout_Z;
wire [31:0] A, B, PC_X, PCout_X, PCoutplus4_X, PCoutplus4_Y, PCoutplus4_Z, PC_shifted_Y, RS, RT, rd1,rd2,wd,ALU_out_Y,ALU_out_Z, wd_Z, RT_shifted_Y, RT_shifted_Z, UARTout_Y, UARTout_Z, inst_X, inst_imem_X, inst_bios_X, inst_Y, dmem_out, biosmem_out;
wire [7:0] UARTwrite, UARTread;
wire [11:0] mem_adr;
wire [4:0] a3_Z, a3_Y;
wire [31:0] LLout; //Load logic out

assign RegWrite_Z = RegWrite_YZ;
assign MemToReg_Z = MemToReg_YZ;
assign inst_Y = inst_XY;
assign PCPlus8_Z = PCPlus8_YZ;

assign LdStCtrl_Z = LdStCtrl_YZ;
assign PCout_Y = PCout_XY;
assign PCout_Z = PCout_YZ;
assign PCoutplus4_Y = PCoutplus4_XY;
assign PCoutplus4_Z = PCoutplus4_YZ;
assign ALU_out_Z = ALU_out_YZ;
assign a3_Z = a3_YZ;
assign UARTout_Z = UARTout_YZ;
assign RT_shifted_Z = RT_shifted_YZ;

RegFile RegFile(                            
            .clk(clk),                       
            .we(RegWrite_Z & ~stall),
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
			.PCout_Y(PCout_Y),
            .mem_adr(mem_adr),    
            .we_i(we_i),         
            .we_d(we_d),        
            .RTout(RT_shifted_Y)
);                            

LoadLogic LoadLogic(
			.word((ALU_out_Z[31:28] == 4'd4)?biosmem_out:dmem_out),
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
	.WD(RT[7:0]),
	.A_Y(ALU_out_Y & {32{~stall}}),
//	.A_Z(ALU_out_Z),
	.Read(UARTread),
	.LdStCtrl(LdStCtrl_Y),
	.DataInReady(DataInReady),
	.DataOutValid(DataOutValid),
	.stall(stall),
	.MemToReg(MemToReg_Y),
	.Write(UARTwrite),
	.Out(UARTout_Y),
	.DataInValid(DataInValid),
	.DataOutReady(DataOutReady)
);

ControlUnit ControlUnit(
	.rt(inst_Y[20:16]),
	.opcode(inst_Y[31:26]),
	.funct(inst_Y[5:0]),
.PCPlus8(PCPlus8_Y),
	.RegDest(RegDest_Y),
	.ALURegSel(ALURegSel_Y),
	.JALCtrl(JALCtrl_Y),
	.RegWrite(RegWrite_Y),
	.MemToReg(MemToReg_Y),
	.ALUCtrl(ALUCtrl_Y),
	.ALUSrcB(ALUSrcB_Y),
	.LdStCtrl(LdStCtrl_Y),
	.JumpBranch(JumpBranch_Y)
);

always @(posedge clk)begin
	is_bios <= ((stall? PCout_X[31:28] : PC_X[31:28]) == 4'b0100);

	if (rst) begin
			RegWrite_YZ <= 1'b0 ;
			MemToReg_YZ <= 1'b0;
			inst_XY <= 32'd0;
			PCPlus8_YZ <= 1'b0;
			
			LdStCtrl_YZ <= 3'd0;
			PCout_XY <= 32'd0;
			PCout_YZ <= 32'd0;
			PCoutplus4_XY <= 32'd0;
			PCoutplus4_YZ <= 32'd0;
			ALU_out_YZ <= 32'd0;
			a3_YZ <= 5'd0;
			UARTout_YZ <= 32'd0;
			RT_shifted_YZ <= 32'd0;
			
			PCoutreg <= 32'd0;
	end
	else begin
		if (!stall) begin
			RegWrite_YZ <= RegWrite_Y;
			MemToReg_YZ <= MemToReg_Y;
			inst_XY <= inst_X;
			PCPlus8_YZ <= PCPlus8_Y;
			
			LdStCtrl_YZ <= LdStCtrl_Y;
			PCout_XY <= PCout_X;
			PCout_YZ <= PCout_Y;
			PCoutplus4_XY <= PCoutplus4_X;
			PCoutplus4_YZ <= PCoutplus4_Y;
			ALU_out_YZ <= ALU_out_Y;
			a3_YZ <= a3_Y;
			UARTout_YZ <= UARTout_Y;
			RT_shifted_YZ <= RT_shifted_Y;

			PCoutreg <= PC_X;
		end
	end
end
  
/*
//memory instantiations
imem_blk_ram imem_blk_ram(
	.clka(clk),	
	.ena(~stall),
	.wea(we_i & {4{~stall}}),
	.addra(mem_adr),
	.dina(RT_shifted),
	.clkb(clk),
	.addrb(stall? PCout_X[13:2] : PC_X[13:2]),
	.doutb(inst_imem_X)
);

//b port - read port, a port - write port
cache_data_blk_ram cache_data_blk_ram(
	.clka(clk),
	.ena(~stall),
	.wea(we_d & {4{~stall}}),
	.addra(mem_adr),
	.dina(RT_shifted),
	.clkb(clk),
	.rstb(rst),
	.enb(~stall & MemToReg & ALU_out_Y[31:30] == 2'd0 & ALU_out_Y[28] = 1'd1  ),
	.addrb(mem_adr),
	.doutb(dmem_out)
);
*/

//dcache
assign dcache_addr = stall? ALU_out_Z : ALU_out_Y;	
assign dcache_we = we_d;
assign dcache_re = (stall ? (ALU_out_Z[31:30] == 2'd0 & ALU_out_Z[28]):(ALU_out_Y[31:30] == 2'd0 & ALU_out_Y[28])) & (stall? MemToReg_Z : MemToReg_Y); 
assign dcache_din = stall ? RT_shifted_Z : RT_shifted_Y;
assign dmem_out = dcache_dout;

//icache
assign icache_addr = ((stall? PCout_X[31:28] : PC_X[31:28]) == 4'b0001)? (stall? PCout_X : PC_X): (stall?ALU_out_Z:ALU_out_Y);
assign icache_we = we_i;
//assign icache_re = ~stall & (PC_out_Z[31:28] == 4'b0001); 
assign icache_re = stall? (PCout_X[31:28] == 4'b0001):(PC_X[31:28] == 4'b0001);
assign icache_din = stall ? RT_shifted_Z : RT_shifted_Y;

assign inst_imem_X = instruction;

bios_mem bios_mem(
	.clka(clk),
	.ena(~stall),
	.addra(stall?PCout_X[13:2] : PC_X[13:2]), //PC
	.douta(inst_bios_X),
	.clkb(clk),
	.enb(~stall),
	.addrb(mem_adr),  //DATA
	.doutb(biosmem_out)
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

assign PC_X = rst ? 32'd0: tempPC; 
assign PCout_X = PCoutreg; 
assign PCoutplus4_X = PCout_X + 4;

assign inst_X = is_bios ? inst_bios_X:inst_imem_X;

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
		default: tempB = RT;
	endcase	
end
assign B = tempB;

assign wd = (PCPlus8_Z ? PCoutplus4_Z+4:wd_Z);  
assign a3_Y = (JALCtrl_Y ? 5'd31: (RegDest_Y ? inst_Y[15:11]:inst_Y[20:16]));
assign PC_shifted_Y = PCoutplus4_Y + ({{16{inst_Y[15]}}, inst_Y[15:0]} << 2); 
assign RS = (PCPlus8_Z? rd1:((a3_Z == inst_Y[25:21] & RegWrite_Z & ~stall) ? wd : rd1)); 
assign RT = (PCPlus8_Z? rd2:((a3_Z == inst_Y[20:16] & RegWrite_Z & ~stall) ? wd : rd2)); 
assign A = (ALURegSel_Y ? RT : RS);

//stage three
assign wd_Z = (MemToReg_Z ? (ALU_out_Z[31:28] == 4'b1000 ? UARTout_Z : LLout) : ALU_out_Z);

endmodule

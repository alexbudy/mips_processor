//Module UARTdec
//Desc: UART decoder
//Inputs Interface:
//	WD[31:0]: RT
//	A[31:0]: ALU_out
//	Read[7:0]: from UART
//	DataInReady
//	DataOutValid
//	LdStCtrl: 3'b000-LB, default, 001-LH, 010-LW, 011-LBU 100-LHU, 101-SB, 110-SH, 111-SW
//Outputs:
//	Write[7:0]: to UART
//	Out[31:0]: Output for read

module UARTdec(
	input[7:0] WD,
	input[31:0] A_Y,
//	input[31:0] A_Z,
	input[7:0] Read,
	input[2:0] LdStCtrl,
	input DataInReady, DataOutValid,
	input stall,
	input MemToReg,
	output reg [7:0] Write,
	output reg [31:0] Out,
	output reg DataInValid,
	output reg DataOutReady
);

	always@(*) begin
		case(A_Y)
			32'h80000000:begin	//read DataInReady 
				Out= {31'd0, DataInReady};
				Write = 8'd0;
				DataInValid = 1'b0;
				DataOutReady = 1'b0;
				end
			32'h80000004:begin  //read DataOutValid
				Out = {31'd0, DataOutValid};
				Write = 8'd0;
				DataInValid = 1'b0;
				DataOutReady = 1'b0;
				end
			32'h80000008:begin  //write to DataIn
				Write = WD[7:0];
				Out = 32'd0;
				case(LdStCtrl)
					3'b101,3'b110,3'b111: DataInValid = 1'b1; //all the stores
					default: DataInValid = 1'b0;
				endcase
				DataOutReady = 1'b0;
				end
			32'h8000000c:begin  //read DataOut
				Out = {24'd0, Read};
				Write = 8'd0;
				DataInValid = 1'b0;
				if (MemToReg)
				DataOutReady = 1'b1;
				else
				DataOutReady = 1'b0;
				end
			default:begin
				Out = 32'd0;
				Write = 8'd0;
				DataInValid = 1'b0;
				DataOutReady = 1'b0;
				end
		endcase
	end

/**
	always@(*) begin
		case(A_Y)
			32'h80000000:begin	//read DataInReady 
				Write = 8'd0;
				DataInValid = 1'b0;
				end
			32'h80000004:begin  //read DataOutValid
				Write = 8'd0;
				DataInValid = 1'b0;
				end
			32'h80000008:begin  //write to DataIn
				Write = WD[7:0];
				case(LdStCtrl)
					3'b101,3'b110,3'b111: DataInValid = 1'b1 & !stall; //all the stores
					default: DataInValid = 1'b0;
				endcase
				end
			32'h8000000c:begin  //read DataOut
				Write = 8'd0;
				DataInValid = 1'b0;
				end
			default:begin
				Write = 8'd0;
				DataInValid = 1'b0;
				end
		endcase
	end

	always @(*) begin
		case(A_Z)
			32'h80000000:begin	//read DataInReady 
				Out= {31'd0, DataInReady};
				DataOutReady = 1'b0;
				end
			32'h80000004:begin  //read DataOutValid
				Out = {31'd0, DataOutValid};
				DataOutReady = 1'b0;
				end
			32'h80000008:begin  //write to DataIn
				Out = 32'd0;
				DataOutReady = 1'b0;
				end
			32'h8000000c:begin  //read DataOut
				if(MemToReg) begin	
					Out = {24'd0, Read};
					DataOutReady = 1'b1 & !stall;
				end else begin
					Out = 32'd0;
					DataOutReady = 1'b0;
				end
				end
			default:begin
				Out = 32'd0;
				DataOutReady = 1'b0;
				end
			
		endcase
	end	
	**/

endmodule

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
	input[31:0] WD,
	input[31:0] A,
	input[7:0] Read,
	input[2:0] LdStCtrl,
	input DataInReady, DataOutValid,
	output reg [7:0] Write,
	output reg [31:0] Out,
	output reg DataInValid
);

	always@(*) begin
		case(A)
			32'h80000000:begin	 
				Out=32'd1 & DataInReady;
				Write = 8'd0;
				DataInValid = 1'b0;
				end
			32'h80000004:begin
				Out = 32'd1 & DataOutValid;
				Write = 8'd0;
				DataInValid = 1'b0;
				end
			32'h80000008:begin
				Write = WD[7:0];
				Out = 32'd0;
				case(LdStCtrl)
					3'b101,3'b110,3'b111: DataInValid = 1'b1;
					default: DataInValid = 1'b0;
				endcase
				end
			32'h8000000c:begin
				Out = 32'h000000FF & Read[7:0];
				Write = 8'd0;
				DataInValid = 1'b0;
				end
			default:begin
				Out = 32'd0;
				Write = 8'd0;
				DataInValid = 1'b0;
				end
		endcase
	end

endmodule

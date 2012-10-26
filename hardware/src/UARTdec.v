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
	input clk,
	output reg [7:0] Write,
	output reg [31:0] Out,
	output reg DataInValid,
	output reg DataOutReady
);

	reg [31:0] cycle_counter;
	reg [31:0] instruction_counter;
	reg temp_rst;
	
	initial temp_rst <=0;
	
	initial cycle_counter <= 32'd0;
	initial instruction_counter <= 32'd0;
	
	always @ (posedge clk) begin
		if (temp_rst) begin
			cycle_counter <= 32'd0;
			instruction_counter <= 32'd0;
		end else begin
			cycle_counter <= cycle_counter + 1;
			if (stall) instruction_counter <= instruction_counter+1;
		end
	end
	
	always@(*) begin
		case(A_Y)
			32'h80000000:begin	//read DataInReady 
				Out= {31'd0, DataInReady&(!stall)};
				Write = 8'd0;
				DataInValid = 1'b0;
				DataOutReady = 1'b0;
				temp_rst <= 1'b0;
				end
			32'h80000004:begin  //read DataOutValid
				Out = {31'd0, DataOutValid&(!stall)};
				Write = 8'd0;
				DataInValid = 1'b0;
				DataOutReady = 1'b0;
				temp_rst <= 1'b0;
				end
			32'h80000008:begin  //write to DataIn
				Write = {8{!stall}}&WD[7:0];
				Out = 32'd0;
				case(LdStCtrl)
					3'b101,3'b110,3'b111: DataInValid = !stall; //all the stores
					default: DataInValid = 1'b0;
				endcase
				DataOutReady = 1'b0;
				temp_rst <= 1'b0;
				end
			32'h8000000c:begin  //read DataOut
				Out = {24'd0, {8{!stall}} & Read};
				Write = 8'd0;
				DataInValid = 1'b0;
				if (MemToReg)
				DataOutReady = !stall;
				else
				DataOutReady = 1'b0;

				temp_rst <= 1'b0;
				end
			32'h80000010:begin //Cycle Counter
				Out = cycle_counter & {32{!stall}};
				Write = 8'd0;
				DataInValid = 1'b0;
				DataOutReady = 1'b0;
				temp_rst <= 1'b0;
				end
			32'h80000014:begin //instruction counter
				Out = instruction_counter & {32{!stall}};
				Write = 8'd0;
				DataInValid = 1'b0;
				DataOutReady = 1'b0;
				temp_rst <= 1'b0;
				end
			32'h80000018:begin //reset counters to 0
				Out = 32'd0;
				Write = 8'd0;
				DataInValid = 1'b0;
				DataOutReady = 1'b0;
				temp_rst <= 1'b1;
				//reset counters
				//instruction_counter = 32'd0;
				//cycle_counter = 32'd0;
				end
			default:begin
				Out = 32'd0;
				Write = 8'd0;
				DataInValid = 1'b0;
				DataOutReady = 1'b0;
				temp_rst <= 1'b0;
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

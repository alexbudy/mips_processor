module app(input clk, input rst, input [29:0] addr, output reg [31:0] inst);
reg [29:0] addr_r;
always @(posedge clk)
begin
addr_r <= (rst) ? (30'b0) : (addr);
end
always @(*)
begin
case(addr_r)
30'h00000000: inst = 32'h3c1d1000;
30'h00000001: inst = 32'h37bd9000;
30'h00000002: inst = 32'h3c091040;
30'h00000003: inst = 32'h240a0030;
30'h00000004: inst = 32'h240b0050;
30'h00000005: inst = 32'h240c0041;
30'h00000006: inst = 32'h240d0082;
30'h00000007: inst = 32'h3c1900ff;
30'h00000008: inst = 32'h116d000d;
30'h00000009: inst = 32'h00000000;
30'h0000000a: inst = 32'h114c0008;
30'h0000000b: inst = 32'h00000000;
30'h0000000c: inst = 32'h000b7300;
30'h0000000d: inst = 32'h000a7880;
30'h0000000e: inst = 32'h01cf7020;
30'h0000000f: inst = 32'h012ec020;
30'h00000010: inst = 32'haf190000;
30'h00000011: inst = 32'h0800140a;
30'h00000012: inst = 32'h254a0001;
30'h00000013: inst = 32'h240a0000;
30'h00000014: inst = 32'h08001408;
30'h00000015: inst = 32'h256b0001;
default:      inst = 32'h00000000;
endcase
end
endmodule

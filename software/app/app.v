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
30'h00000001: inst = 32'h0c000403;
30'h00000002: inst = 32'h37bd1000;
30'h00000003: inst = 32'h27bdffe8;
30'h00000004: inst = 32'hafa00010;
30'h00000005: inst = 32'h241a0050;
30'h00000006: inst = 32'h3c1b8000;
30'h00000007: inst = 32'h377b0008;
30'h00000008: inst = 32'haf7a0000;
30'h00000009: inst = 32'h08000409;
30'h0000000a: inst = 32'h00000000;
default:      inst = 32'h00000000;
endcase
end
endmodule

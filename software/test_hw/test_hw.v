module test_hw(input clk, input rst, input [29:0] addr, output reg [31:0] inst);
reg [29:0] addr_r;
always @(posedge clk)
begin
addr_r <= (rst) ? (30'b0) : (addr);
end
always @(*)
begin
case(addr_r)
30'h00000000: inst = 32'h2409ffff;
30'h00000001: inst = 32'h40896000;
30'h00000002: inst = 32'h24170000;
30'h00000003: inst = 32'h24100020;
30'h00000004: inst = 32'h24080020;
30'h00000005: inst = 32'h15100003;
30'h00000006: inst = 32'h24170001;
30'h00000007: inst = 32'h0800000c;
30'h00000008: inst = 32'h26f70001;
30'h00000009: inst = 32'h3c108000;
30'h0000000a: inst = 32'h36100008;
30'h0000000b: inst = 32'hae170000;
30'h0000000c: inst = 32'h241100fd;
30'h0000000d: inst = 32'h3c108000;
30'h0000000e: inst = 32'h36100008;
30'h0000000f: inst = 32'hae110000;
default:      inst = 32'h00000000;
endcase
end
endmodule

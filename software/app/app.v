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
30'h00000001: inst = 32'h0c000343;
30'h00000002: inst = 32'h37bd0d00;
30'h00000003: inst = 32'h27bdffe8;
30'h00000004: inst = 32'hafa00010;
30'h00000005: inst = 32'h3c081000;
30'h00000006: inst = 32'h350800b0;
30'h00000007: inst = 32'h3c091000;
30'h00000008: inst = 32'h352900b4;
30'h00000009: inst = 32'h3c0a1000;
30'h0000000a: inst = 32'h354a00c4;
30'h0000000b: inst = 32'h3c0c1000;
30'h0000000c: inst = 32'h358c00d0;
30'h0000000d: inst = 32'h3c0d1000;
30'h0000000e: inst = 32'h35ad00d4;
30'h0000000f: inst = 32'had000000;
30'h00000010: inst = 32'had200000;
30'h00000011: inst = 32'had400000;
30'h00000012: inst = 32'had6e0000;
30'h00000013: inst = 32'had800000;
30'h00000014: inst = 32'hada00000;
30'h00000015: inst = 32'h240dffff;
30'h00000016: inst = 32'h408d5800;
30'h00000017: inst = 32'h341af80f;
30'h00000018: inst = 32'h409a6000;
30'h00000019: inst = 32'h08000359;
30'h0000001a: inst = 32'h00000000;
default:      inst = 32'h00000000;
endcase
end
endmodule

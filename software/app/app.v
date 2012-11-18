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
30'h00000001: inst = 32'h0c000c03;
30'h00000002: inst = 32'h37bd5000;
30'h00000003: inst = 32'h27bdffe0;
30'h00000004: inst = 32'hafa00010;
30'h00000005: inst = 32'h3c081f00;
30'h00000006: inst = 32'h350800b0;
30'h00000007: inst = 32'h3c091f00;
30'h00000008: inst = 32'h352900b4;
30'h00000009: inst = 32'h3c0a1f00;
30'h0000000a: inst = 32'h354a00c4;
30'h0000000b: inst = 32'h3c0c1f00;
30'h0000000c: inst = 32'h358c00d0;
30'h0000000d: inst = 32'h3c0d1f00;
30'h0000000e: inst = 32'h35ad00d4;
30'h0000000f: inst = 32'h240e0001;
30'h00000010: inst = 32'h3c0b1f00;
30'h00000011: inst = 32'h356b00c8;
30'h00000012: inst = 32'had000000;
30'h00000013: inst = 32'had200000;
30'h00000014: inst = 32'had400000;
30'h00000015: inst = 32'had6e0000;
30'h00000016: inst = 32'had800000;
30'h00000017: inst = 32'hada00000;
30'h00000018: inst = 32'h40094800;
30'h00000019: inst = 32'h3c0102fa;
30'h0000001a: inst = 32'h3421f080;
30'h0000001b: inst = 32'h01214821;
30'h0000001c: inst = 32'h40895800;
30'h0000001d: inst = 32'h34088c01;
30'h0000001e: inst = 32'h40886000;
30'h0000001f: inst = 32'h24030072;
30'h00000020: inst = 32'h3c021f00;
30'h00000021: inst = 32'h344200c0;
30'h00000022: inst = 32'h90420000;
30'h00000023: inst = 32'h00000000;
30'h00000024: inst = 32'h1443fffb;
30'h00000025: inst = 32'h00000000;
30'h00000026: inst = 32'h0c000800;
30'h00000027: inst = 32'h08000c20;
30'h00000028: inst = 32'h00000000;
30'h00000029: inst = 32'h3c0c1f00;
30'h0000002a: inst = 32'h358c00b0;
30'h0000002b: inst = 32'h8d8d0000;
30'h0000002c: inst = 32'h8d8e0004;
30'h0000002d: inst = 32'h00004020;
30'h0000002e: inst = 32'h3c0905f5;
30'h0000002f: inst = 32'h3529e100;
30'h00000030: inst = 32'h21080001;
30'h00000031: inst = 32'h1509fffe;
30'h00000032: inst = 32'h00000000;
30'h00000033: inst = 32'h8d8f0000;
30'h00000034: inst = 32'h8d980004;
30'h00000035: inst = 32'h00000000;
30'h00000036: inst = 32'h030e5022;
30'h00000037: inst = 32'h01ed5822;
30'h00000038: inst = 32'h00006020;
30'h00000039: inst = 32'h01606820;
30'h0000003a: inst = 32'h25adfff6;
30'h0000003b: inst = 32'h05a00003;
30'h0000003c: inst = 32'h00000000;
30'h0000003d: inst = 32'h08000c3a;
30'h0000003e: inst = 32'h258c0001;
30'h0000003f: inst = 32'h25ad000a;
30'h00000040: inst = 32'h258c0030;
30'h00000041: inst = 32'h0c000c4f;
30'h00000042: inst = 32'h25ad0030;
30'h00000043: inst = 32'h0c000c4f;
30'h00000044: inst = 32'h240a003a;
30'h00000045: inst = 32'h0c000c4f;
30'h00000046: inst = 32'h000c5020;
30'h00000047: inst = 32'h0c000c4f;
30'h00000048: inst = 32'h000d5020;
30'h00000049: inst = 32'h0c000c4f;
30'h0000004a: inst = 32'h240a003d;
30'h0000004b: inst = 32'h0c000c4f;
30'h0000004c: inst = 32'h240a003a;
30'h0000004d: inst = 32'h03e00008;
30'h0000004e: inst = 32'h00000000;
30'h0000004f: inst = 32'h3c081f00;
30'h00000050: inst = 32'h350800d0;
30'h00000051: inst = 32'h8d090000;
30'h00000052: inst = 32'h3c081f00;
30'h00000053: inst = 32'h350800d8;
30'h00000054: inst = 32'h01284021;
30'h00000055: inst = 32'ha10a0000;
30'h00000056: inst = 32'h3c081f00;
30'h00000057: inst = 32'h350800d0;
30'h00000058: inst = 32'h8d090000;
30'h00000059: inst = 32'h00000000;
30'h0000005a: inst = 32'h25290001;
30'h0000005b: inst = 32'had090000;
30'h0000005c: inst = 32'h24080014;
30'h0000005d: inst = 32'h15090004;
30'h0000005e: inst = 32'h00000000;
30'h0000005f: inst = 32'h3c081f00;
30'h00000060: inst = 32'h350800d0;
30'h00000061: inst = 32'had000000;
30'h00000062: inst = 32'h03e00008;
30'h00000063: inst = 32'h00000000;
default:      inst = 32'h00000000;
endcase
end
endmodule

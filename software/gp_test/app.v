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
30'h00000001: inst = 32'h0c001446;
30'h00000002: inst = 32'h37bdf000;
30'h00000003: inst = 32'h3c090100;
30'h00000004: inst = 32'h3c0a1000;
30'h00000005: inst = 32'h3c111000;
30'h00000006: inst = 32'h3c128000;
30'h00000007: inst = 32'h36520030;
30'h00000008: inst = 32'h3c138000;
30'h00000009: inst = 32'h36730040;
30'h0000000a: inst = 32'h3c0b1040;
30'h0000000b: inst = 32'h3c0b1080;
30'h0000000c: inst = 32'hae6b0000;
30'h0000000d: inst = 32'hae290000;
30'h0000000e: inst = 32'hae200004;
30'h0000000f: inst = 32'hae510000;
30'h00000010: inst = 32'h3c0f0100;
30'h00000011: inst = 32'h3c118000;
30'h00000012: inst = 32'h36310040;
30'h00000013: inst = 32'h3c128000;
30'h00000014: inst = 32'h36520030;
30'h00000015: inst = 32'h3c091040;
30'h00000016: inst = 32'hae290000;
30'h00000017: inst = 32'h3c0a1000;
30'h00000018: inst = 32'h3c0b1000;
30'h00000019: inst = 32'had4f0000;
30'h0000001a: inst = 32'h254a0004;
30'h0000001b: inst = 32'h3c0c0200;
30'h0000001c: inst = 32'h358cff00;
30'h0000001d: inst = 32'h3c0d00ff;
30'h0000001e: inst = 32'h35ad00ff;
30'h0000001f: inst = 32'h3c0e00ff;
30'h00000020: inst = 32'h35ce0150;
30'h00000021: inst = 32'had4c0000;
30'h00000022: inst = 32'had4d0004;
30'h00000023: inst = 32'had4e0008;
30'h00000024: inst = 32'h00000000;
30'h00000025: inst = 32'h3c0c0200;
30'h00000026: inst = 32'h358cff00;
30'h00000027: inst = 32'h3c0d0001;
30'h00000028: inst = 32'h35ad0001;
30'h00000029: inst = 32'h3c0e0001;
30'h0000002a: inst = 32'h35ce0150;
30'h0000002b: inst = 32'had4c000c;
30'h0000002c: inst = 32'had4d0010;
30'h0000002d: inst = 32'had4e0014;
30'h0000002e: inst = 32'h00000000;
30'h0000002f: inst = 32'h3c0c0200;
30'h00000030: inst = 32'h358cff00;
30'h00000031: inst = 32'h3c0d0150;
30'h00000032: inst = 32'h35ad0150;
30'h00000033: inst = 32'h3c0e0150;
30'h00000034: inst = 32'h35ce00ff;
30'h00000035: inst = 32'had4c0018;
30'h00000036: inst = 32'had4d001c;
30'h00000037: inst = 32'had4e0020;
30'h00000038: inst = 32'h00000000;
30'h00000039: inst = 32'h3c0c0200;
30'h0000003a: inst = 32'h358cff00;
30'h0000003b: inst = 32'h3c0d0150;
30'h0000003c: inst = 32'h35ad00ff;
30'h0000003d: inst = 32'h3c0e00ff;
30'h0000003e: inst = 32'h35ce00ff;
30'h0000003f: inst = 32'had4c0024;
30'h00000040: inst = 32'had4d0028;
30'h00000041: inst = 32'had4e002c;
30'h00000042: inst = 32'h00000000;
30'h00000043: inst = 32'had400030;
30'h00000044: inst = 32'h00000000;
30'h00000045: inst = 32'hae4b0000;
30'h00000046: inst = 32'h27bdffb8;
30'h00000047: inst = 32'hafbf0040;
30'h00000048: inst = 32'hafb00030;
30'h00000049: inst = 32'hafb10034;
30'h0000004a: inst = 32'hafb20038;
30'h0000004b: inst = 32'hafa00024;
30'h0000004c: inst = 32'h3c028000;
30'h0000004d: inst = 32'h34420050;
30'h0000004e: inst = 32'h8c420000;
30'h0000004f: inst = 32'h00000000;
30'h00000050: inst = 32'h30420001;
30'h00000051: inst = 32'h14400005;
30'h00000052: inst = 32'h00000000;
30'h00000053: inst = 32'h00000000;
30'h00000054: inst = 32'h00000000;
30'h00000055: inst = 32'h0800144c;
30'h00000056: inst = 32'h00000000;
30'h00000057: inst = 32'h3c028000;
30'h00000058: inst = 32'h34420050;
30'h00000059: inst = 32'h8c420000;
30'h0000005a: inst = 32'h00000000;
30'h0000005b: inst = 32'h30420001;
30'h0000005c: inst = 32'h10400005;
30'h0000005d: inst = 32'h00000000;
30'h0000005e: inst = 32'h00000000;
30'h0000005f: inst = 32'h00000000;
30'h00000060: inst = 32'h08001457;
30'h00000061: inst = 32'h00000000;
30'h00000062: inst = 32'h3c028000;
30'h00000063: inst = 32'h34420050;
30'h00000064: inst = 32'hafa00028;
30'h00000065: inst = 32'h8c420000;
30'h00000066: inst = 32'h00000000;
30'h00000067: inst = 32'h30420001;
30'h00000068: inst = 32'hafa2002c;
30'h00000069: inst = 32'h3c028000;
30'h0000006a: inst = 32'h34420050;
30'h0000006b: inst = 32'h8c420000;
30'h0000006c: inst = 32'h00000000;
30'h0000006d: inst = 32'h30420001;
30'h0000006e: inst = 32'h14400021;
30'h0000006f: inst = 32'h00000000;
30'h00000070: inst = 32'h3c021001;
30'h00000071: inst = 32'h3c031000;
30'h00000072: inst = 32'h34500000;
30'h00000073: inst = 32'h2471552c;
30'h00000074: inst = 32'h3c1200ff;
30'h00000075: inst = 32'hae300000;
30'h00000076: inst = 32'h3644ffff;
30'h00000077: inst = 32'h0c0014c1;
30'h00000078: inst = 32'h00000000;
30'h00000079: inst = 32'h8fa40028;
30'h0000007a: inst = 32'h00000000;
30'h0000007b: inst = 32'h24820001;
30'h0000007c: inst = 32'hafa20028;
30'h0000007d: inst = 32'h36420000;
30'h0000007e: inst = 32'hafa20010;
30'h0000007f: inst = 32'h24050140;
30'h00000080: inst = 32'h24060042;
30'h00000081: inst = 32'h240700b4;
30'h00000082: inst = 32'h0c0014d5;
30'h00000083: inst = 32'h00000000;
30'h00000084: inst = 32'h24040000;
30'h00000085: inst = 32'h00042821;
30'h00000086: inst = 32'h00043021;
30'h00000087: inst = 32'h00043821;
30'h00000088: inst = 32'h0c001505;
30'h00000089: inst = 32'h00000000;
30'h0000008a: inst = 32'h3c028000;
30'h0000008b: inst = 32'h8e230000;
30'h0000008c: inst = 32'h00000000;
30'h0000008d: inst = 32'h3c041040;
30'h0000008e: inst = 32'h080014ae;
30'h0000008f: inst = 32'h00000000;
30'h00000090: inst = 32'h3c021001;
30'h00000091: inst = 32'h3c031000;
30'h00000092: inst = 32'h34500000;
30'h00000093: inst = 32'h2471552c;
30'h00000094: inst = 32'h3c1200ff;
30'h00000095: inst = 32'hae300000;
30'h00000096: inst = 32'h3644ffff;
30'h00000097: inst = 32'h0c0014c1;
30'h00000098: inst = 32'h00000000;
30'h00000099: inst = 32'h8fa40028;
30'h0000009a: inst = 32'h00000000;
30'h0000009b: inst = 32'h24820001;
30'h0000009c: inst = 32'hafa20028;
30'h0000009d: inst = 32'h36420000;
30'h0000009e: inst = 32'hafa20010;
30'h0000009f: inst = 32'h24050140;
30'h000000a0: inst = 32'h24060042;
30'h000000a1: inst = 32'h240700b4;
30'h000000a2: inst = 32'h0c0014d5;
30'h000000a3: inst = 32'h00000000;
30'h000000a4: inst = 32'h24040000;
30'h000000a5: inst = 32'h00042821;
30'h000000a6: inst = 32'h00043021;
30'h000000a7: inst = 32'h00043821;
30'h000000a8: inst = 32'h0c001505;
30'h000000a9: inst = 32'h00000000;
30'h000000aa: inst = 32'h3c028000;
30'h000000ab: inst = 32'h8e230000;
30'h000000ac: inst = 32'h00000000;
30'h000000ad: inst = 32'h3c041080;
30'h000000ae: inst = 32'h34840000;
30'h000000af: inst = 32'h34450040;
30'h000000b0: inst = 32'hac600000;
30'h000000b1: inst = 32'h34420030;
30'h000000b2: inst = 32'haca40000;
30'h000000b3: inst = 32'hac500000;
30'h000000b4: inst = 32'h3c028000;
30'h000000b5: inst = 32'h8fa3002c;
30'h000000b6: inst = 32'h00000000;
30'h000000b7: inst = 32'h34420050;
30'h000000b8: inst = 32'h8c420000;
30'h000000b9: inst = 32'h00000000;
30'h000000ba: inst = 32'h30420001;
30'h000000bb: inst = 32'h1062fff8;
30'h000000bc: inst = 32'h00000000;
30'h000000bd: inst = 32'h3c028000;
30'h000000be: inst = 32'h34420050;
30'h000000bf: inst = 32'h08001465;
30'h000000c0: inst = 32'h00000000;
30'h000000c1: inst = 32'h27bdffe8;
30'h000000c2: inst = 32'h3c0200ff;
30'h000000c3: inst = 32'h3c031000;
30'h000000c4: inst = 32'h3c050100;
30'h000000c5: inst = 32'h3442ffff;
30'h000000c6: inst = 32'h2463552c;
30'h000000c7: inst = 32'hafa40010;
30'h000000c8: inst = 32'h00821024;
30'h000000c9: inst = 32'h34a40000;
30'h000000ca: inst = 32'h00441025;
30'h000000cb: inst = 32'h8c640000;
30'h000000cc: inst = 32'h00000000;
30'h000000cd: inst = 32'hac820000;
30'h000000ce: inst = 32'h8c620000;
30'h000000cf: inst = 32'h00000000;
30'h000000d0: inst = 32'h24420004;
30'h000000d1: inst = 32'hac620000;
30'h000000d2: inst = 32'h27bd0018;
30'h000000d3: inst = 32'h03e00008;
30'h000000d4: inst = 32'h00000000;
30'h000000d5: inst = 32'h27bdffd8;
30'h000000d6: inst = 32'hafa40014;
30'h000000d7: inst = 32'hafa50018;
30'h000000d8: inst = 32'h3c0200ff;
30'h000000d9: inst = 32'hafa6001c;
30'h000000da: inst = 32'h3c031000;
30'h000000db: inst = 32'h3c040200;
30'h000000dc: inst = 32'h3442ffff;
30'h000000dd: inst = 32'h8fa50038;
30'h000000de: inst = 32'h00000000;
30'h000000df: inst = 32'hafa70020;
30'h000000e0: inst = 32'h2463552c;
30'h000000e1: inst = 32'hafa50024;
30'h000000e2: inst = 32'h00a21024;
30'h000000e3: inst = 32'h34840000;
30'h000000e4: inst = 32'h00441025;
30'h000000e5: inst = 32'h8c640000;
30'h000000e6: inst = 32'h00000000;
30'h000000e7: inst = 32'hac820000;
30'h000000e8: inst = 32'h8c620000;
30'h000000e9: inst = 32'h00000000;
30'h000000ea: inst = 32'h24440004;
30'h000000eb: inst = 32'hac640000;
30'h000000ec: inst = 32'h8fa40014;
30'h000000ed: inst = 32'h00000000;
30'h000000ee: inst = 32'h8fa50018;
30'h000000ef: inst = 32'h00000000;
30'h000000f0: inst = 32'h00042400;
30'h000000f1: inst = 32'h00852021;
30'h000000f2: inst = 32'hac440004;
30'h000000f3: inst = 32'h8c620000;
30'h000000f4: inst = 32'h00000000;
30'h000000f5: inst = 32'h24440004;
30'h000000f6: inst = 32'hac640000;
30'h000000f7: inst = 32'h8fa4001c;
30'h000000f8: inst = 32'h00000000;
30'h000000f9: inst = 32'h8fa50020;
30'h000000fa: inst = 32'h00000000;
30'h000000fb: inst = 32'h00042400;
30'h000000fc: inst = 32'h00852021;
30'h000000fd: inst = 32'hac440004;
30'h000000fe: inst = 32'h8c620000;
30'h000000ff: inst = 32'h00000000;
30'h00000100: inst = 32'h24420004;
30'h00000101: inst = 32'hac620000;
30'h00000102: inst = 32'h27bd0028;
30'h00000103: inst = 32'h03e00008;
30'h00000104: inst = 32'h00000000;
30'h00000105: inst = 32'h27bdffc0;
30'h00000106: inst = 32'hafbf003c;
30'h00000107: inst = 32'hafa40024;
30'h00000108: inst = 32'hafa50028;
30'h00000109: inst = 32'hafa6002c;
30'h0000010a: inst = 32'hafa70030;
30'h0000010b: inst = 32'h240200ff;
30'h0000010c: inst = 32'hafa20010;
30'h0000010d: inst = 32'h24040000;
30'h0000010e: inst = 32'h24070005;
30'h0000010f: inst = 32'h00042821;
30'h00000110: inst = 32'h00043021;
30'h00000111: inst = 32'h0c0014d5;
30'h00000112: inst = 32'h00000000;
30'h00000113: inst = 32'h8fbf003c;
30'h00000114: inst = 32'h00000000;
30'h00000115: inst = 32'h27bd0040;
30'h00000116: inst = 32'h03e00008;
30'h00000117: inst = 32'h00000000;
30'h00000118: inst = 32'h27bdffe0;
30'h00000119: inst = 32'hafa40010;
30'h0000011a: inst = 32'hafa50014;
30'h0000011b: inst = 32'hafa00018;
30'h0000011c: inst = 32'h8fa20014;
30'h0000011d: inst = 32'h00000000;
30'h0000011e: inst = 32'h8fa30010;
30'h0000011f: inst = 32'h00000000;
30'h00000120: inst = 32'h0043102a;
30'h00000121: inst = 32'h1040000d;
30'h00000122: inst = 32'h00000000;
30'h00000123: inst = 32'h8fa20018;
30'h00000124: inst = 32'h00000000;
30'h00000125: inst = 32'h24420001;
30'h00000126: inst = 32'hafa20018;
30'h00000127: inst = 32'h8fa20010;
30'h00000128: inst = 32'h00000000;
30'h00000129: inst = 32'h8fa30014;
30'h0000012a: inst = 32'h00000000;
30'h0000012b: inst = 32'h00431023;
30'h0000012c: inst = 32'hafa20010;
30'h0000012d: inst = 32'h0800151c;
30'h0000012e: inst = 32'h00000000;
30'h0000012f: inst = 32'h8fa20018;
30'h00000130: inst = 32'h00000000;
30'h00000131: inst = 32'h27bd0020;
30'h00000132: inst = 32'h03e00008;
30'h00000133: inst = 32'h00000000;
30'h00000134: inst = 32'h27bdffe8;
30'h00000135: inst = 32'hafa40010;
30'h00000136: inst = 32'hafa50014;
30'h00000137: inst = 32'h8fa20010;
30'h00000138: inst = 32'h00000000;
30'h00000139: inst = 32'h8fa30014;
30'h0000013a: inst = 32'h00000000;
30'h0000013b: inst = 32'h0043102a;
30'h0000013c: inst = 32'h14400009;
30'h0000013d: inst = 32'h00000000;
30'h0000013e: inst = 32'h8fa20010;
30'h0000013f: inst = 32'h00000000;
30'h00000140: inst = 32'h8fa30014;
30'h00000141: inst = 32'h00000000;
30'h00000142: inst = 32'h00431023;
30'h00000143: inst = 32'hafa20010;
30'h00000144: inst = 32'h08001537;
30'h00000145: inst = 32'h00000000;
30'h00000146: inst = 32'h8fa20010;
30'h00000147: inst = 32'h00000000;
30'h00000148: inst = 32'h27bd0018;
30'h00000149: inst = 32'h03e00008;
30'h0000014a: inst = 32'h00000000;
default:      inst = 32'h00000000;
endcase
end
endmodule

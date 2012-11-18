#define COUNT     0x1f000010
#define STATE     (*((volatile unsigned int*)0x1f0000c0) & 0xff)

int main(){

asm("li $t0, 0x1f0000b0");  //seconds
asm("li $t1, 0x1f0000b4");  //minutes
asm("li $t2, 0x1f0000c4");  //rtc
asm("li $t4, 0x1f0000d0");  //inIdx
asm("li $t5, 0x1f0000d4");  //outIdx
asm("li $t6, 1"); //timer enable 
asm("li $t3, 0x1f0000c8");  //time bit

asm("sw $0, 0($t0)");
asm("sw $0, 0($t1)");
asm("sw $0, 0($t2)");
asm("sw $t6, 0($t3)");
asm("sw $0, 0($t4)");
asm("sw $0, 0($t5)");

//set seconds and minutes to ZERO
asm("mfc0 $t1, $9");
asm("addu $t1, $t1, 0x02faf080");
asm("mtc0 $t1, $11");

asm("li $t0, 0x8c01"); //timer, tx, rx and global
asm("mtc0 $t0, $12");

int tstart, tend;
//register int a;
//static volatile int b, *address;
//char s[100];
	
//address = COUNT;

return 0;

while(1)  {
	switch (STATE) {
		case 0x72:
			return 0; 
			asm("li $t0, 0x10002000");
			asm("jalr $t0");	
		break;
	}
};
	return 0;
}

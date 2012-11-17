//#define COUNT 0x1f000010
//#define STATE (*((volatile unsigned int*)0x1f0000c0))
#define RECV_CTRL (*((volatile unsigned int*)0x80000004) & 0x01)
#define RECV_DATA (*((volatile unsigned int*)0x8000000C) & 0xFF)

#define TRAN_CTRL (*((volatile unsigned int*)0x80000000) & 0x01)
#define TRAN_DATA (*((volatile unsigned int*)0x80000008))

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


//asm("addiu $t5, $0, 0xffff");
//asm("mtc0 $t5, $11");

asm("li $t0, 0x8801"); //timer, tx, and global
asm("mtc0 $t0, $12");

//asm("li $k0, 0x50");
//asm("li $k1, 0x80000008");
//asm("sw $k0, 0($k1)");
//int tstart, tend;
//register int a;
//static volatile int b, *address;
//char s[100];
	
//address = COUNT;

int i = 0;
while(1)  {
i = i+1;
};
 //switch(STATE){
	/*
	case 'r':
		tstart = *address;
		r100M();
		tend = *address;
		sprint(s,"r:%d",tstart-tend);
		out(*s);
		break;	
	case 'v':
		tstart =*address;
		v100M();
		tend = *address;
		sprint(s,"v:%d",tstart-tend);
		out(*s);
		break;	
	case 'R':
		tstart = *address;
		R100M();
		tend = *address;
		sprint(s,"R:%d",tstart-tend);
		out(*s);
		break;	
	case 'V':
		tstart = *address;
		V100M();
		tend = *address;
		sprint(s,"V:%d",tstart-tend);
		out(*s);
		break;	
*/			
			
//}
	return 0;
}

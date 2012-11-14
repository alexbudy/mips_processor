#define COUNT 0x10000010
#define STATE (*((volatile unsigned int*)0x100000c0))

int main(){
asm("li $t0, 0x100000b0");  //seconds
asm("li $t1, 0x100000b4");  //minutes
asm("li $t2, 0x100000c4");  //rtc
asm("li $t4, 0x100000d0");  //inIdx
asm("li $t5, 0x100000d4");  //outIdx

asm("sw $0, 0($t0)");
asm("sw $0, 0($t1)");
asm("sw $0, 0($t2)");
asm("sw $t6, 0($t3)");
asm("sw $0, 0($t4)");
asm("sw $0, 0($t5)");

//set seconds and minutes to ZERO
asm("addiu $t5, $0, 0xffff");
asm("mtc0 $t5, $11");

asm("li $k0, 0xf80f");
asm("mtc0 $k0, $12");

//int tstart, tend;
//register int a;
//static volatile int b, *address;
//char s[100];
	
//address = COUNT;

while(1);
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

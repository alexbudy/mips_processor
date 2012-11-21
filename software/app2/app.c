#define COUNT     0x1f000010
#define STATE     (*((volatile unsigned int*)0x1f0000c0))
#define SECONDS   (*((volatile unsigned int*)0x1f0000bc) & 0xff)

void send_time(char c);
void send_byte(char b);
void r100M();
int div(int a, int b);
int mod(int a, int b);


int diff;

int main(){

asm("li $t0, 0x1f0000b0");  //seconds
asm("li $t1, 0x1f0000b4");  //minutes
asm("li $t2, 0x1f0000c4");  //rtc
asm("li $t4, 0x1f0000d0");  //inIdx
asm("li $t5, 0x1f0000d4");  //outIdx
asm("li $t6, 1"); //timer enable 
asm("li $t3, 0x1f0000c8");  //time bit
asm("li $t7, 0x1f0000bc");  //total seconds

asm("sw $0, 0($t0)");
asm("sw $0, 0($t1)");
asm("sw $0, 0($t2)");
asm("sw $t6, 0($t3)");
asm("sw $0, 0($t4)");
asm("sw $0, 0($t5)");
asm("sw $0, 0($t7)");

// initializes state to 0
asm("li $t3, 0x1f0000c0");  //time bit
asm("sw $0, 0($t3)");

//set seconds and minutes to ZERO
asm("mfc0 $t1, $9");
asm("addu $t1, $t1, 0x02faf080");
asm("mtc0 $t1, $11");

asm("li $t0, 0x8c01"); //timer, tx, rx and global
asm("mtc0 $t0, $12");

int tstart, tend;


while(1)  {
	if (STATE == 0x72) {
			//initial time
			//asm("li $t4, 0x1f0000bc");
			//asm("lw $t5, 0($t4)"); //total seconds start
			
			tstart = SECONDS;
			r100M();
			tend = SECONDS;
			diff = tend - tstart;
			send_time('r');
			
		
			//clears the STATE var
			asm("li $t0, 0x1f0000c0");
			asm("sw $0, 0($t0)");
			STATE = 0x00;
	}
	asm("add $t4, $t4, $t4");
};
	return 0;
}

//a/b, floored
int div(int a, int b) {
	int s = 0;
	while (a > b) {
		s++;
		a = a-b;
	}
	return s;
}

//a%b
int mod(int a, int b) {
	while (a >= b) {
		a = a - b;
	}
	return a;
}

void r100M() {
		asm("add $t7, $0, $0");
		//asm("lui  $t8, 0x05f5"); //100M
		//asm("ori $t8, $t8, 0xe100");
		asm("li $t8, 0x05f5e100");
		asm("loop:");
		asm("addiu $t7, $t7, 0x1");
		asm("bne $t7, $t8, loop");
		asm("nop");
}

// ss = t4 t5
void send_time(char c) {
		asm("li $t5, 0x0"); //timer, tx, rx and global
		asm("mtc0 $t5, $12");
		asm("nop");
		send_byte(c);
		send_byte(':');
		send_byte(' ');
		
		unsigned char dn = 48 + mod(diff, 10);	
		unsigned char up = 48 + div(diff, 10);
		send_byte(up);
		send_byte(dn);
		send_byte(' ');
		send_byte('s');
		send_byte(0xd);
		send_byte(0xa);

		asm("li $t5, 0x8c01"); //timer, tx, rx and global
		asm("mtc0 $t5, $12");
		asm("nop");
} 

void send_byte(char b) {
		asm("li $t0, 0x1f0000d0");  //inIdx adr
		asm("lw $t1, 0($t0)");     //load inIdx to k1
		asm("andi $t1, $t1, 0xff");
		asm("nop");
		asm("li $t0, 0x1f0000d8"); //buffer adr
		asm("addu $t0, $t1, $t0");  //add inIdx to buffer addr
		asm("sb $a0, 0($t0)"); 
		asm("nop");
		asm("li $t0, 0x1f0000d0 "); //inIdx adr
		asm("lw $t1, 0($t0)");      //load inIdx to k1
		asm("andi $t1, $t1, 0xff");
		asm("nop");
		asm("addiu $t1, $t1, 1");//incremenent inIdx
		asm("sw $t1, 0($t0)");  //store back
		asm("nop");
		asm("li $t0, 0xff "); //20
		asm("slt $t1, $t0, $t1"); //k1 = (inIdx < 255)
		asm("beq $t1, $0, xyz");
		asm("nop");
		asm("li $t0, 0x1f0000d0");
		asm("sw $0, 0($t0)");
		asm("nop");
		asm("xyz:");
		asm("nop");
		//asm("jr $ra");
}


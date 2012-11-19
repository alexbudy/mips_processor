#define COUNT     0x1f000010
#define STATE     (*((volatile unsigned int*)0x1f0000c0) & 0xff)

void send_time(char c);
void send_byte(char b);
void r100M();

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
//register int a;
//static volatile int b, *address;
//char s[100];
	
//address = COUNT;


while(1)  {
	if (STATE == 0x72) {
			//initial time
			//asm("li $t4, 0x1f0000bc");
			//asm("lw $t5, 0($t4)"); //total seconds start
			asm("li $t0, 0x1f0000c8"); //timer, tx, rx and global
			asm("sw $0, 0($t0)");
			r100M();
			asm("li $t0, 0x1f0000c8"); //timer, tx, rx and global
			asm("li $t1, 0x1"); //timer, tx, rx and global
			asm("sw $t1, 0($t0)");
			//asm("li $t0, 0x8c01"); //timer, tx, rx and global
			//asm("mtc0 $t0, $12");
			asm("nop");
			asm("nop");
			asm("nop");
//			asm("add $t5, $0, $0");
//			asm("addi  $t6,$0, 0x600"); //100M
			//asm("loop:");
			//asm("addi $t5, $t5, 0x1");
			//asm("slt $t7, $t6, $t5");
			//asm("beq $t7, $0, loop");
			//asm("bne $0, $0, loop");
			//ending time
			//asm("lw $t6, 0($t4)"); //total seconds end 
			//asm("subu $t6, $t6, $t5");
			//asm("li $t5, 0x1f0000a8");
			//asm("sw $t6, 0($t5)"); 
			send_time('r');
			//clears the STATE var
			asm("li $t0, 0x1f0000c0");
			asm("sw $0, 0($t0)");
	}
	/*
	switch (STATE) {
		case 0x72: //r
			//initial time
			//asm("li $t4, 0x1f0000bc");
			//asm("lw $t5, 0($t4)"); //total seconds start
			//r100M();
			asm("add $t5, $0, $0");
			asm("addi  $t6,$0, 0x600"); //100M
			asm("loop:");
			asm("addi $t5, $t5, 0x1");
			asm("slt $t7, $t6, $t5");
			asm("beq $t7, $0, loop");
			//ending time
			//asm("lw $t6, 0($t4)"); //total seconds end 
			//asm("subu $t6, $t6, $t5");
			//asm("li $t5, 0x1f0000a8");
			//asm("sw $t6, 0($t5)"); 
			send_time('r');
			//clears the STATE var
			asm("li $t0, 0x1f0000c0");
			asm("sw $0, 0($t0)");
		break;
	}
	*/
};
	return 0;
}

void r100M() {
		asm("add $t7, $0, $0");
		asm("lui  $t8, 0x05f5"); //100M
		asm("ori $t8, $t8, 0xe100");
		//asm("li $t8, 0x05f5e100");
		asm("loop:");
		//send_time('a');
		asm("addiu $t7, $t7, 0x1");
		asm("bne $t7, $t8, loop");
		asm("nop");
		//asm("addiu $t6, $t6, 0x1");
}

// m:ss = t2:t4 t5
void send_time(char c) {
		asm("li $t5, 0x0"); //timer, tx, rx and global
		asm("mtc0 $t5, $12");
		asm("nop");
		send_byte(c);
		asm("li $t5, 0x8c01"); //timer, tx, rx and global
		asm("mtc0 $t5, $12");
		asm("nop");
}

void send_byte(char b) {
		asm("li $t0, 0x1f0000d0");  //inIdx adr
		asm("lw $t1, 0($t0)");     //load inIdx to k1
		asm("nop");
		asm("li $t0, 0x1f0000d8"); //buffer adr
		asm("addu $t0, $t1, $t0");  //add inIdx to buffer addr
		asm("sb $a0, 0($t0)"); 
		asm("nop");
		asm("li $t0, 0x1f0000d0 "); //inIdx adr
		asm("lw $t1, 0($t0)");      //load inIdx to k1
		asm("nop");
		asm("addiu $t1, $t1, 1");//incremenent inIdx
		asm("sw $t1, 0($t0)");  //store back
		asm("nop");
		asm("li $t0, 0x14 "); //20
		asm("bne $t0, $t1, xyz");
		asm("nop");
		asm("li $t0, 0x1f0000d0");
		asm("sw $0, 0($t0)");
		asm("nop");
		asm("xyz:");
		asm("nop");
		//asm("jr $ra");
}


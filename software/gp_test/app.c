#define SECONDS   (*((volatile unsigned int*)0x1f0000bc))
#define frame1	0x10400000
#define frame2	0x10800000
#define STATE     (*((volatile unsigned int*)0x1f0000c0))
#define CMD  (*((volatile unsigned int*)0x10010000)) //needs to be an array
#define FRAME_ODD (*((volatile unsigned int*)0x80000050) & 0x1) 
#define GP_CODE_REG (*((volatile unsigned int*)0x80000030)) 
#define GP_FRAME_REG (*((volatile unsigned int*)0x80000040)) 

#define cmd ((unsigned int*)0x10010000) 

#define STATE     (*((volatile unsigned int*)0x1f0000c0))


int div(int a, int b);
int mod(int a, int b);
int mult(int a, int b);
void send_time(char c);
void send_byte(char b);
void draw_line(unsigned int x0,unsigned int y0,unsigned int x1, unsigned int y1, unsigned int color);
void fill_frame(unsigned int color);
void check_state();
void game();
void r100M();
void R100M();
void v100M();
void V100M();
void addone();
void init_isr();
void draw_number(int x0, int y0, int num, unsigned int color);

unsigned int* cmd_start;
int pause;
int diff;
int tstart, tend;

int x0, y0, x1, y1;
int pend_state;

void print_time();

int main(){

	pause = 0;

	x0 = 400;	
	y0 = 230;	
	x1 = 400;	
	y1 = 180;	

	int pend_state = 0; //0 = inc x0, 1 = dec y0, 2 = dec x0, 3 = inc y0
	
	int sec = 0;
	
	init_isr();
	
	while (FRAME_ODD != 1) {
		asm("nop");
		asm("nop");
	}
	while (FRAME_ODD != 0) {
		asm("nop");
		asm("nop");
	}

	
	//now we know we are at top of buffer 0
	
	int cur_frame = FRAME_ODD;
	while(1)  {
		if (FRAME_ODD == 1) {
			cmd_start = cmd;
			check_state();			
			
			if (!pause) game();			

			*cmd_start = 0x00000000; //store the end command
			GP_FRAME_REG = frame1;
			GP_CODE_REG = 0x10010000;
		} else {
			cmd_start = cmd;
			check_state();			
			
			if (!pause) game();			

			*cmd_start = 0x00000000; //store the end command
			GP_FRAME_REG = frame2;
			GP_CODE_REG = 0x10010000;
		}

		while (cur_frame == FRAME_ODD) ; //spin until we are cleared
		cur_frame = FRAME_ODD;
	}
	return 0;
}

void fill_frame(unsigned int color) {
	*cmd_start = (0x01000000 + (color & 0x00ffffff));
	cmd_start++;
}

void draw_line(unsigned int x0,unsigned int y0,unsigned int x1,unsigned int y1, unsigned int color) {
	*cmd_start = (0x02000000 + (color & 0x00ffffff));
	cmd_start++;
	*cmd_start = (0x00000000 + (x0 << 16) + y0);
	cmd_start++;
	*cmd_start = (0x00000000 + (x1 << 16) + y1);
	cmd_start++;
}

void game() {
	fill_frame(0x00ffffff);

	if (pend_state == 0) x0++;   
	else if (pend_state == 1) y0--;   
	else if (pend_state == 2) x0--;   
	else if (pend_state == 3) y0++;   

	if ((x0 >= 450) & (pend_state == 0)) pend_state = 1;
	else if ((y0 <= 130) & (pend_state == 1)) pend_state = 2;
	else if ((x0 <= 350) & (pend_state == 2)) pend_state = 3;
	else if ((y0 >= 230) & (pend_state == 0)) pend_state = 0;
		
	draw_line(x0, y0, x1, y1, 0x00ff0000);					
	print_time();
}

void print_time() {
	if (SECONDS > 999) SECONDS = 0;

	int seconds = SECONDS;
	
	int top = div(SECONDS, 100);
	int lol = mult(100, top);
	int lol2 = SECONDS - lol;
	int mid = div(lol2, 10);
	int bot = mod(SECONDS, 10);

	draw_number(325, 450, top, 0xff);
	draw_number(375, 450, mid, 0xff);
	draw_number(425, 450, bot, 0xff);
}

//each number starts at x0, y0, top corner. numbers should be centered in box
//50 width, 80 height for now
void draw_number(int x0, int y0, int num, unsigned int color) {
	if (num == 0) {
		//left vert line
		draw_line(x0+4, y0+6, x0+4, y0+74, color);
		draw_line(x0+5, y0+5, x0+5, y0+75, color);
		draw_line(x0+6, y0+6, x0+6, y0+74, color);

		//right vert line
		draw_line(x0+44, y0+6, x0+44, y0+74, color);
		draw_line(x0+45, y0+5, x0+45, y0+75, color);
		draw_line(x0+46, y0+6, x0+46, y0+74, color);

		//top horizontal line
		draw_line(x0+5, y0+6, x0+45, y0+6, color);
		draw_line(x0+5, y0+5, x0+45, y0+5, color);
		draw_line(x0+5, y0+4, x0+45, y0+4, color);

		//bottom horizontal line
		draw_line(x0+5, y0+74, x0+45, y0+74, color);
		draw_line(x0+5, y0+75, x0+45, y0+75, color);
		draw_line(x0+5, y0+76, x0+45, y0+76, color);
	} else if (num == 1) {
		draw_line(x0+24, y0+5, x0+24, y0+75, color);
		draw_line(x0+23, y0+6, x0+23, y0+74, color);
		draw_line(x0+25, y0+6, x0+25, y0+74, color);
	} else if (num == 2) {
		//top horizontal line
		draw_line(x0+5, y0+6, x0+45, y0+6, color);
		draw_line(x0+5, y0+5, x0+45, y0+5, color);
		draw_line(x0+5, y0+4, x0+45, y0+4, color);

		//middle horizontal line
		draw_line(x0+5, y0+39, x0+45, y0+39, color);
		draw_line(x0+5, y0+40, x0+45, y0+40, color);
		draw_line(x0+6, y0+41, x0+45, y0+41, color);

		//bottom horizontal line
		draw_line(x0+5, y0+74, x0+45, y0+74, color);
		draw_line(x0+5, y0+75, x0+45, y0+75, color);
		draw_line(x0+5, y0+76, x0+45, y0+76, color);

		//right vert top-line
		draw_line(x0+44, y0+6, x0+44, y0+40, color);
		draw_line(x0+45, y0+5, x0+45, y0+41, color);
		draw_line(x0+46, y0+6, x0+46, y0+40, color);

		//left vert bot-line
		draw_line(x0+4, y0+40, x0+4, y0+74, color);
		draw_line(x0+5, y0+41, x0+5, y0+75, color);
		draw_line(x0+6, y0+40, x0+6, y0+74, color);
	} else if (num == 3) {
		//right vert line
		draw_line(x0+44, y0+6, x0+44, y0+74, color);
		draw_line(x0+45, y0+5, x0+45, y0+75, color);
		draw_line(x0+46, y0+6, x0+46, y0+74, color);

		//top horizontal line
		draw_line(x0+5, y0+6, x0+45, y0+6, color);
		draw_line(x0+5, y0+5, x0+45, y0+5, color);
		draw_line(x0+5, y0+4, x0+45, y0+4, color);

		//bottom horizontal line
		draw_line(x0+5, y0+74, x0+45, y0+74, color);
		draw_line(x0+5, y0+75, x0+45, y0+75, color);
		draw_line(x0+5, y0+76, x0+45, y0+76, color);

		//middle horizontal line
		draw_line(x0+10, y0+39, x0+45, y0+39, color);
		draw_line(x0+10, y0+40, x0+45, y0+40, color);
		draw_line(x0+10, y0+41, x0+45, y0+41, color);
	} else if (num == 4) {
		//right vert line
		draw_line(x0+44, y0+6, x0+44, y0+74, color);
		draw_line(x0+45, y0+5, x0+45, y0+75, color);
		draw_line(x0+46, y0+6, x0+46, y0+74, color);

		//middle horizontal line
		draw_line(x0+5, y0+39, x0+45, y0+39, color);
		draw_line(x0+5, y0+40, x0+45, y0+40, color);
		draw_line(x0+6, y0+41, x0+45, y0+41, color);

		//left vert top-line
		draw_line(x0+4, y0+40, x0+4, y0+6, color);
		draw_line(x0+5, y0+41, x0+5, y0+5, color);
		draw_line(x0+6, y0+40, x0+6, y0+6, color);
	} else if (num == 5) {
		//top horizontal line
		draw_line(x0+5, y0+6, x0+45, y0+6, color);
		draw_line(x0+5, y0+5, x0+45, y0+5, color);
		draw_line(x0+5, y0+4, x0+45, y0+4, color);

		//middle horizontal line
		draw_line(x0+5, y0+39, x0+45, y0+39, color);
		draw_line(x0+5, y0+40, x0+45, y0+40, color);
		draw_line(x0+5, y0+41, x0+45, y0+41, color);

		//bottom horizontal line
		draw_line(x0+5, y0+74, x0+45, y0+74, color);
		draw_line(x0+5, y0+75, x0+45, y0+75, color);
		draw_line(x0+5, y0+76, x0+45, y0+76, color);

		//right vert bot-line
		draw_line(x0+44, y0+40, x0+44, y0+74, color);
		draw_line(x0+45, y0+39, x0+45, y0+75, color);
		draw_line(x0+46, y0+40, x0+46, y0+74, color);

		//left vert top-line
		draw_line(x0+4, y0+40, x0+4, y0+6, color);
		draw_line(x0+5, y0+41, x0+5, y0+5, color);
		draw_line(x0+6, y0+40, x0+6, y0+6, color);
	} else if (num == 6) {
		//left vert line
		draw_line(x0+4, y0+6, x0+4, y0+74, color);
		draw_line(x0+5, y0+5, x0+5, y0+75, color);
		draw_line(x0+6, y0+6, x0+6, y0+74, color);

		//right vert bot-line
		draw_line(x0+44, y0+40, x0+44, y0+74, color);
		draw_line(x0+45, y0+39, x0+45, y0+75, color);
		draw_line(x0+46, y0+40, x0+46, y0+74, color);

		//bottom horizontal line
		draw_line(x0+5, y0+74, x0+45, y0+74, color);
		draw_line(x0+5, y0+75, x0+45, y0+75, color);
		draw_line(x0+5, y0+76, x0+45, y0+76, color);

		//middle horizontal line
		draw_line(x0+5, y0+39, x0+45, y0+39, color);
		draw_line(x0+5, y0+40, x0+45, y0+40, color);
		draw_line(x0+5, y0+41, x0+45, y0+41, color);
	} else if (num == 7) {
		//right vert line
		draw_line(x0+44, y0+6, x0+44, y0+74, color);
		draw_line(x0+45, y0+5, x0+45, y0+75, color);
		draw_line(x0+46, y0+6, x0+46, y0+74, color);

		//top horizontal line
		draw_line(x0+5, y0+6, x0+45, y0+6, color);
		draw_line(x0+5, y0+5, x0+45, y0+5, color);
		draw_line(x0+5, y0+4, x0+45, y0+4, color);
	} else if (num == 8) {
		//left vert line
		draw_line(x0+4, y0+6, x0+4, y0+74, color);
		draw_line(x0+5, y0+5, x0+5, y0+75, color);
		draw_line(x0+6, y0+6, x0+6, y0+74, color);

		//right vert line
		draw_line(x0+44, y0+6, x0+44, y0+74, color);
		draw_line(x0+45, y0+5, x0+45, y0+75, color);
		draw_line(x0+46, y0+6, x0+46, y0+74, color);

		//top horizontal line
		draw_line(x0+5, y0+6, x0+45, y0+6, color);
		draw_line(x0+5, y0+5, x0+45, y0+5, color);
		draw_line(x0+5, y0+4, x0+45, y0+4, color);

		//bottom horizontal line
		draw_line(x0+5, y0+74, x0+45, y0+74, color);
		draw_line(x0+5, y0+75, x0+45, y0+75, color);
		draw_line(x0+5, y0+76, x0+45, y0+76, color);

		//middle horizontal line
		draw_line(x0+5, y0+39, x0+45, y0+39, color);
		draw_line(x0+5, y0+40, x0+45, y0+40, color);
		draw_line(x0+5, y0+41, x0+45, y0+41, color);
	} else if (num == 9) {
		//top horizontal line
		draw_line(x0+5, y0+6, x0+45, y0+6, color);
		draw_line(x0+5, y0+5, x0+45, y0+5, color);
		draw_line(x0+5, y0+4, x0+45, y0+4, color);

		//right vert line
		draw_line(x0+44, y0+6, x0+44, y0+74, color);
		draw_line(x0+45, y0+5, x0+45, y0+75, color);
		draw_line(x0+46, y0+6, x0+46, y0+74, color);

		//middle horizontal line
		draw_line(x0+5, y0+39, x0+45, y0+39, color);
		draw_line(x0+5, y0+40, x0+45, y0+40, color);
		draw_line(x0+6, y0+41, x0+45, y0+41, color);

		//left vert top-line
		draw_line(x0+4, y0+40, x0+4, y0+6, color);
		draw_line(x0+5, y0+41, x0+5, y0+5, color);
		draw_line(x0+6, y0+40, x0+6, y0+6, color);

	}

}


void check_state(){ //up left down right
	if (STATE == 0x72) {
		send_byte('r');
		send_byte(0xd);
		send_byte(0xa);
		tstart = SECONDS;
		r100M();
		tend = SECONDS;
		diff = tend - tstart;

		r100M();
		send_time('r');

		STATE = 0x00;
	}
	else if (STATE == 0x52){
		send_byte('R');
		send_byte(0xd);
		send_byte(0xa);

		tstart = SECONDS;
		R100M();
		tend = SECONDS;
		diff = tend - tstart;

		send_time('R');

		STATE = 0x00;
		
	}
	else if (STATE == 0x76){
		send_byte('v');
		send_byte(0xd);
		send_byte(0xa);

		tstart = SECONDS;
		v100M();
		tend = SECONDS;
		diff = tend - tstart;

		send_time('v');

		STATE = 0x00;
		
	}
		else if (STATE == 0x56){
		send_byte('V');
		send_byte(0xd);
		send_byte(0xa);

		tstart = SECONDS;
		V100M();
		tend = SECONDS;
		diff = tend - tstart;
		send_time('V');

		STATE = 0x00;
	} else if (STATE == ' ') {
		pause = !pause;
		STATE = 0x00;
	}
}

void init_isr() {

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
}

// a/b, floored
int div(int a, int b) {
	int s = 0;
	while (a >= b) {
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

//better to have b < a
int mult(int a, int b) {
	int ret = 0;
	while (b>=1) {
		ret = ret + a;
		b = b - 1;
	}
	return ret;
}

void r100M() {
		asm("add $t7, $0, $0");
		asm("li $t8, 0x05f5e100");
		asm("loop:");
		asm("addiu $t7, $t7, 0x1");
		asm("bne $t7, $t8, loop");
		asm("nop");
}
void R100M() {
		asm("add $t7, $0, $0");
		asm("lui  $t8, 0x05f5"); //100M
		asm("ori $t8, $t8, 0xe100");
		//asm("li $t8, 0x05f5e100");
		asm("loopR:");
		//send_time('a');
		addone();
		asm("bne $t7, $t8, loopR");
		asm("nop");
		//asm("addiu $t6, $t6, 0x1");
}
void addone(){
		asm("addiu $t7, $t7, 0x1");
}
void v100M() {
		asm("add $t7, $0, $0");
		asm("li $t8, 0x05f5e100");
		asm("li $t6, 0x1f0000ac");
		asm("sw $0, 0($t6)");
		asm("loopv:");
		asm("lw $t7, 0($t6)");
		asm("nop");
		asm("addiu $t7, $t7, 0x1");
		asm("sw $t7, 0($t6)");
		asm("bne $t7, $t8, loopv");
		asm("nop");
}
void V100M() {
		asm("li $t8, 0x05f5e100");
		asm("li $t6, 0x1f0000ac");
		asm("sw $0, 0($t6)");
		asm("nop");
		asm("loopV:");
		asm("lw $t7, 0($t6)");
		asm("nop");
		addone();
		asm("sw $t7, 0($t6)");
		asm("nop");
		asm("bne $t7, $t8, loopV");
		asm("nop");
}

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


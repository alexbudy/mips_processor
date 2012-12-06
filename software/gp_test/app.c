#define COUNT     0x1f000010
#define frame1	0x10400000
#define frame2	0x10800000
#define cmd1_location 0x10010000
#define STATE     (*((volatile unsigned int*)0x1f0000c0))
#define CMD  (*((volatile unsigned int*)0x10010000)) //needs to be an array
#define FRAME_ODD (*((volatile unsigned int*)0x80000050) & 0x1) 
#define GP_CODE_REG (*((volatile unsigned int*)0x80000030)) 
#define GP_FRAME_REG (*((volatile unsigned int*)0x80000040)) 

#define cmd ((unsigned int*)0x10010000) 

int div(int a, int b);
int mod(int a, int b);
void draw_line(unsigned int x0,unsigned int y0,unsigned int x1, unsigned int y1, unsigned int color);
void fill_frame(unsigned int color);
void game(int w,int a,int s,int d);

unsigned int* cmd_start;


int main(){

	while (FRAME_ODD != 1) {
		asm("nop");
		asm("nop");
	}
	while (FRAME_ODD != 0) {
		asm("nop");
		asm("nop");
	}
	
		
	//now we know we are at top of buffer 0
	

	int x = 0;	

	int cur_frame = FRAME_ODD;
	while(1)  {
		if (FRAME_ODD == 0) {
			cmd_start = cmd;

			fill_frame(0x00ffffff);
			draw_line(x++, 320, 66, 180, 0x00ff0000);					
			game(0,0,0,0);

			*cmd_start = 0x00000000; //store the end command
			GP_FRAME_REG = frame1;
			GP_CODE_REG = 0x10010000;
		} else {
			cmd_start = cmd;

			fill_frame(0x00ffffff);
			draw_line(x++, 320, 66, 180, 0x00ff0000);					
			game(0,0,0,0);

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
	*cmd_start = (0x02000000 + (x0 << 16) + y0);
	cmd_start++;

	*cmd_start = (0x02000000 + (x1 << 16) + y1);
	cmd_start++;
}

void game(w,a,s,d){ //up left down right
	//border
	draw_line(0,0,0,5,0xff);
	//draw_line(0,0,0,590,0x0);

	//draw_line(0,590,790,590,0x0);
	//draw_line(0x10,0x589,0x790,0x589,0x0);

	//draw_line(790,590,790,0,0x0);
	//draw_line(0x789,0x10,0x789,0x590,0x0);

	//draw_line(790,0,0,0,0x0);
	//draw_line(0x11,0x10,0x790,0x11,0x0);
}

// a/b, floored
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


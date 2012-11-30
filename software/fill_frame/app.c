#define FRAME1     ((volatile unsigned int*)0x10400000)
#define SECONDS   (*((volatile unsigned int*)0x1f0000bc) & 0xff)



int main(){



int x = 0;
int y = 0;
//int f1 = 0x10400000;
//int f1 = ((volatile unsigned int*)0x10400000);
/*
for (int y = 0; y < 600; y++) {
	for (int x = 0; x < 800; x++) {
		unsigned int temp = y<<12 + x<<2;
		FRAME1[temp] = 0x00ffffff;

	}
}
*/	

unsigned int i = 0;
unsigned int color = 0x00ffffff;

//while (1) {
		for (int i = 0; i < 614000; i++) {
			FRAME1[i] = color; 
		}
	//	color += 0x0f0f0f;
//};
/*
		while (y < 599) {
			while (x < 799) {
				//(*((volatile unsigned int*)(f1+(y<<12) + (x<<2)))) = 0x003f0f00; 
				//(*(FRAME1 + (y<<12) + (x<<2))) = 0x003f0f00;
				(*(FRAME1 + i)) = 0x003fff00;				
				x++;
				i = i + 4;
			}
			x = 0;
			y++;
		}
*/
	return 0;
}


#define IN_IDX    (*((volatile unsigned int*)0x1f0000d0))

#define BUF       (*((volatile char*)        0x1f0000d8))
#define SECONDS   (*((volatile unsigned int*)0x1f0000b0))
#define MINUTES   (*((volatile unsigned int*)0x1f0000b4))


void send_time(void)
{
	volatile char * buf_ptr = (volatile char*) 0x1f0000d8;

	//send the upper minute
	char up_min = ((MINUTES >> 4) & 0xf);	
	char bot_min = (MINUTES & 0xff);	

	char up_sec = ((SECONDS >> 4) & 0xf);	
	char bot_sec = (SECONDS & 0xf);	
	
	send_char(up_min);
	send_char(bot_min);
	send_char(0x3A); //':'
	send_char(up_sec);
	send_char(bot_sec);
	send_char(0xA); //newline
}

void send_char(char c) {
	volatile char * buf_ptr = (volatile char*) 0x1f0000d8;
	unsigned char temp;	

	if (c == 0x0) {
		temp = 0x30; 	
	} else if (c == 0x1) {
		temp = 0x31;
	}
	} else if (c == 0x2) {
		temp = 0x32;
	}
	} else if (c == 0x3) {
		temp = 0x33;
	}
	} else if (c == 0x3) {
		temp = 0x33;
	}
	} else if (c == 0x4) {
		temp = 0x34;
	}
	} else if (c == 0x5) {
		temp = 0x35;
	}
	} else if (c == 0x6) {
		temp = 0x36;
	}
	} else if (c == 0x7) {
		temp = 0x37;
	}
	} else if (c == 0x8) {
		temp = 0x38;
	}
	} else if (c == 0x9) {
		temp = 0x39;
	}
	} else if (c == 0xa) {
		temp = 0x41;
	}
	} else if (c == 0xb) {
		temp = 0x42;
	}
	} else if (c == 0xc) {
		temp = 0x43;
	}
	} else if (c == 0xd) {
		temp = 0x44;
	}
	} else if (c == 0xe) {
		temp = 0x45;
	}
	} else if (c == 0xf) {
		temp = 0x46;
	}
	else temp = c; //the default, ':' or \n
	buf_ptr[IN_IDX] = temp;
	IN_IDX = (IN_IDX+1)% 20;
}

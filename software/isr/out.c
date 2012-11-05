#define UTRAN_CTRL (*((volatile unsigned int*)0x80000000) & 0x01) //DataInReady
#define UTRAN_DATA (*((volatile unsigned int*)0x80000008))

#define IN_IDX (*((volatile int*)0x100000d0))
#define OUT_IDX (*((volatile int*)0x100000d4))
#define BUFFER ((volatile char*)0x1000000d8)
#define BUF_LEN 20

#define SW_RTC (*((volatile int*)0x100000c4))

//copies s to FIFO buffer
void out(char * s) {
	int strIdx = 0;
	//if (UTRAN_CTRL) {
	//	UTRAN_DATA = s[strIdx];
	//	strIdx++;
	//}
	if (s[strIdx]) {
		while ((BUFFER[IN_IDX] = s[strIdx])) {
			IN_IDX = (IN_IDX + 1) % BUF_LEN;
		}
	}
}

//called by UARTTX_ISR
void write_UART () {
	//char * buffer = BUFFER;
	//int *inIdx, *outIdx;
	
	if (IN_IDX != OUT_IDX) { //FIFO not empty
		if (UTRAN_CTRL) {
			UTRAN_DATA = BUFFER[OUT_IDX];
			OUT_IDX = (OUT_IDX + 1) % BUF_LEN;
		}
	} else { //if FIFO empty, send null
		if (UTRAN_CTRL) {
			UTRAN_DATA = 0x00;
		}
	}
}

//gets minutes and seconds, prints the time
void send_time () {
	int minutes = SW_RTC % 100;
	char tens = (char)(((int)'0')+(minutes/10));	
	char ones = (char)(((int)'0')+(minutes%10));	
	char *str;

	str[0] = tens;
	str[1] = ones;
	str[2] = ':';
	str[3] = '0'; //temp
	str[4] = '0'; //temp
	str[5] = 0x0d;
	str[6] = 0x00;

	out(*str);
}

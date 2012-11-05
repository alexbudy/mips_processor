#define UTRAN_CTRL (*((volatile unsigned int*)0x80000000) & 0x01) //DataInReady
#define UTRAN_DATA (*((volatile unsigned int*)0x80000008))

#define IN_IDX (*((volatile unsigned int*)0x100000d0))
#define OUT_IDX (*((volatile unsigned int*)0x100000d4))
#define BUFFER (*((volatile unsigned int*)0x1000000d8))
#define BUF_LEN 20

//copies s to FIFO buffer
void out(char * s) {
	int strIdx = 0;
	//if (UTRAN_CTRL) {
	//	UTRAN_DATA = s[strIdx];
	//	strIdx++;
	//}
	if (s[strIdx]) {
		while (BUFFER[*IN_IDX] = s[strIdx]) {
			*IN_IDX = (*IN_IDX + 1) % BUF_SIZE;
		}
	}
}

//called by UARTTX_ISR
void write_UART () {
	if (*IN_IDX != *OUT_IDX) { //FIFO not empty
		if (UTRAN_CTRL) {
			UTRAN_DATA = BUFFER[*OUT_IDX];
			*OUT_IDX = (*OUT_IDX + 1) % BUF_SIZE;
		}
	} else { //if FIFO empty, send null
		if (UTRAN_CTRL) {
			UTRAN_DATA = 0x00;
		}
	}
}

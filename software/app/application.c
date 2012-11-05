#define COUNT 0x10000010
#define STATE (*((volatile unsigned int*)0x100000c0))

int main(){
int tstart, tend;
register int a;
static volatile int b, *address;
char s[100];
	
address = COUNT;

while(1) switch(STATE){
	case 'r':
		tstart = *address;
		r100M();
		tend = *address;
		sprint(s,"r:%d",tstart-tend);
		out(s);
		break;	
	case 'v':
		tstart =*address;
		v100M();
		tend = *address;
		sprint(s,"v:%d",tstart-tend);
		out(s);
		break;	
	case 'R':
		tstart = *address;
		R100M();
		tend = *address;
		sprint(s,"R:%d",tstart-tend);
		out(s);
		break;	
	case 'V':
		tstart = *address;
		V100M();
		tend = *address;
		sprint(s,"V:%d",tstart-tend);
		out(s);
		break;	
			
			
}
	return 0;
}

#define COUNT 0x10000010
int main(){
int tstart, tend;
register int a;
static volatile int b, state = 'r', *address;
char s[100];
	
address = COUNT;

while(1) switch(state){
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
	case 'd':
		asm("mfc0 $k0, $12");
		asm("andi $k0, 0x7FFF");
		asm("mtc0 $k0, $12");
		break;
	case 'e':
		asm("mfc0 $k0, $12");
		asm("ori $k1, $k1, 0x8000");
		asm("mtc0 $k0, $12");
		break;
	default:
		sprint("ERROR: hit default of switch case");
			
			
}
	return 0;
}

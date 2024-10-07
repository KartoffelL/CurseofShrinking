
data errMes {Schwerwiegender Fehler!}
data err_Nullptr {Nullpointer!}
data text {Ein Wiki (hawaiisch für „schnell“)[1] ist eine Website, deren Inhalte von den Besuchern nicht nur gelesen, sondern auch direkt im Webbrowser bearbeitet und geändert werden können (Web-2.0-Anwendung). Das Ziel ist häufig, Erfahrung und Wissen gemeinschaftlich zu sammeln (kollektive Intelligenz) und in für die Zielgruppe verständlicher Form zu dokumentieren. Die Autoren erarbeiten hierzu gemeinschaftlich Texte, die ggf. durch Fotos oder andere Medien ergänzt werden (kollaboratives Schreiben, E-Collaboration). Ermöglicht wird dies durch ein vereinfachtes Content-Management-System, die sogenannte Wiki-Software oder Wiki-Engine.}
data yay {This is a happy Memory Section that might or might not be cut off because of size restrains but who knows, right???? hihi!~~~~~~~~~~}
data finMain {Finished Main!}


function import env void printMem(int addr, int len, int t);
function import env float time();
function import env void suspend();
function import env void throwExcep(int cause);
function import console void log(int v);
function import console void error(int v);

#Misc-----------------------------------------------------------------------
function void exception(int a) {
	print(errMes, 2);
	suspend();
	.ass UNREACHABLE;
}

function void print(int addr, int t) {
	printMem(addr, -8-loadI(addr-8), t);
}

function void storeI(int offset, int value) {
	.ass LOCAL_GET offset;
	.ass LOCAL_GET value;
	.ass I32_STORE 2 0;
}
function raw int loadI(int offset) {
	.ass LOCAL_GET offset;
	.ass I32_LOAD 2 0;
}
function raw int remS(int a, int b) {
	.ass LOCAL_GET a;
	.ass LOCAL_GET b;
	.ass I32_REM_S;
}
function raw int remU(int a, int b) {
	.ass LOCAL_GET a;
	.ass LOCAL_GET b;
	.ass I32_REM_U;
}
function int rmSng(int a) {
	.return ((a<0)*-2+1)*a;
}
function raw double copySign(double s, double d) {
	.ass LOCAL_GET s;
	.ass LOCAL_GET d;
	.ass F64_COPYSIGN;
}
function raw int align(int a) {
	.ass I32_CONST 3;
	.ass LOCAL_GET a;
	.ass I32_CONST 1;
	.ass I32_SUB;
	.ass I32_CONST 4;
	.ass I32_REM_S;
	.ass I32_SUB;
	.ass LOCAL_GET a;
	.ass I32_ADD;
}
function raw int min(int a, int b) {
	.ass LOCAL_GET a;
	.ass F32_CONVERT_I32_S;
	.ass LOCAL_GET b;
	.ass F32_CONVERT_I32_S;
	.ass F32_MIN;
	.ass I32_TRUNC_F32_S;
}
#Memory Related stuff--------------------------------------------------------
function int copySeg(int src, int dst, int length) {
	int mlength = min(length, min(0-loadI(src-8), 0-loadI(dst-8))-8);
	.ass LOCAL_GET dst;
	.ass LOCAL_GET src;
	.ass LOCAL_GET mlength;
	.ass MEMORY_COPY 0 0;
	.return mlength;
}
function void fill(int addr, int length, int val) {
	.ass LOCAL_GET addr;
	.ass LOCAL_GET length;
	.ass LOCAL_GET val;
	.ass MEMORY_FILL 0;
}
function void copy(int src, int dst, int length) {
	.ass LOCAL_GET dst;
	.ass LOCAL_GET src;
	.ass LOCAL_GET length;
	.ass MEMORY_COPY 0 0;
}
#Allocates new memory of size that is guaranteed to be unused by anything .else.
function raw int allocate(int size) {
	int hpointer = 0;
	int ppointer = 0;
	int pp = 0;
	size = align(size+8);
	.while(1) {
		pp = pp+1;
	#	.if(pp > 1888888) {exception(0);}
		int a = loadI(hpointer);
		.if(a > size | a = size) {
			.if(a-size > 31) {#Splitting
				storeI(hpointer+size, a-size);
				storeI(hpointer+size+4, hpointer+8); #Reverse
				storeI(hpointer+a+4, hpointer+size+8); #Reverse
				storeI(hpointer+4, ppointer+8); #Reverse
				storeI(hpointer, 0-size);
			} .else { #Taking over
				storeI(hpointer, 0-a);
				storeI(hpointer+4, ppointer+8); #Reverse
			}
			.break;
		}
		.else {
			.if(a = 0) { #Adding new segment
				storeI(hpointer+size, 0);
				storeI(hpointer+size+4, hpointer+8);
				storeI(hpointer, 0-size);
				storeI(hpointer+4, ppointer+8); #Reverse
				.break 3;
			}
			.else {
				ppointer = hpointer;
				hpointer = hpointer+rmSng(a);
			}
		}
	}
	.return hpointer+8;
}
#marks the address as free and collapses
function void free(int addr) {
	.if(addr = 0) {
		exception(err_Nullptr);
	}
	int s = rmSng(loadI(addr-8)); #Get size of segment
	int paddr = loadI(addr-4); #Get prev segment address
	storeI(addr-8, s); #Free this
	
	int p_s = loadI(paddr-8);
	int n_s = loadI(addr+s-8);
	.if(addr > 1024) {
		.if(p_s > 0) {
			storeI(addr+s-4, paddr);
			s = s+p_s;
			storeI(paddr-8, s);
			addr = paddr;
		}
		.if(n_s > 0) {
			storeI(addr-8, s+n_s);
			storeI(addr+s+n_s-4, addr);
		}
	}
}
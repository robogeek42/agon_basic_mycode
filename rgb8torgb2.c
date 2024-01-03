#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include <assert.h>

int BBCToInd[] = {
	0x00, 0x20, 0x08, 0x28, 0x02, 0x22, 0x0A, 0x2A, 
	0x15, 0x30, 0x0C, 0x3C, 0x03, 0x33, 0x0F, 0x3F, 
	0x01, 0x04, 0x05, 0x06, 0x07, 0x09, 0x0B, 0x0D,
	0x0E, 0x10, 0x11, 0x12, 0x13, 0x14, 0x16, 0x17,
	0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F,
	0x21, 0x23, 0x24, 0x25, 0x26, 0x27, 0x29, 0x2B,
	0x2C, 0x2D, 0x2E, 0x2F, 0x31, 0x32, 0x34, 0x35,
	0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3D, 0x3E};

int IndToBBC[] = {
	0, 16,  4, 12, 17, 18, 19, 20,  2, 21,  6, 22, 10, 23, 24, 14,
	25, 26, 27, 28, 29,  8, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
	1, 40,  5, 41, 42, 43, 44, 45,  3, 46,  7, 47, 48, 49, 50, 51,
	9, 52, 53, 13, 54, 55, 56, 57, 58, 59, 60, 61, 11, 62, 63, 15};

void usage(char *name) {
	printf("%s [RGB|RGBA] <fInile> <fOutile> [REV]\n",name);
}

int main(int argc, char **argv)
{
	FILE *fIn,*fOut;

	char *fInile;
	char *fOutile;
	bool bAlpha=false, bReverse=false;
	int comps=3;

	if (argc<4) {
		usage(argv[0]);
		return -1;
	}
	if (strcmp(argv[1],"RGBA")==0) {
		bAlpha=true;
		comps=4;
		printf("4 componenet RGBA input\n");
	} else {
		printf("3 componenet RGB input\n");
	}
	fInile=argv[2];
	fOutile=argv[3];
	
	fIn=fopen(fInile, "r");
	if (!fIn) { 
		printf("Error opening %s\n",fInile);
		return -1;
	}
	fOut=fopen(fOutile, "w");
	if (!fOut) { 
		printf("Error opening %s\n",fOutile);
		return -1;
	}

	if (argc==5) {
		if (strcmp(argv[4],"REV")==0) {
			bReverse=true;
		}
	}
	if (bReverse)
	{
		printf("Output BGRA\n");
	} else {
		printf("Output RGBA\n");
	}
	
	while (!feof(fIn))
	{
		uint8_t comps[4];
		if (fread(comps, 1, bAlpha?4:3, fIn)>0) {
			uint8_t colindex;
			if (bReverse) {
				colindex = 0xC0 | ((comps[0]/85) << 4) | ((comps[1]/85) << 2) | (comps[2]/85);
			}
			else {
				colindex = 0xC0 | ((comps[2]/85) << 4) | ((comps[1]/85) << 2) | (comps[0]/85);
			}

			//printf("0x%02X 0x%02X 0x%02X  --> 0x%02X\n",comps[0], comps[1],comps[2], colindex);
			fputc(colindex,fOut);
		}
	}
	fclose(fIn);
	fclose(fOut);

	return 0;
}


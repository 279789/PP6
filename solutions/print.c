#include <stdio.h>

int main(void) {
	printf("Hello there this is C.\n\n");
	printf("Integer: %i\tFloat: %f\t String:%s\n\n",1,2.1,"Mulm");
	puts("I didn't know puts before.\n");
	
	//Test section for Reflection Question 3
	FILE *test;
	test = fopen("test.txt","w");
	fprintf(test,"Super hat geklappt\n");
	fclose(test);
	fprintf(stdout,"Super hat geklappt\n");

	
	
	
	
	
	return 0;



}

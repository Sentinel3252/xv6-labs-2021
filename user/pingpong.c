#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"



#define READ 0
#define WRITE 1


int main(int argc, char *argv[])
{
    if(argc != 1) printf("don't input arguments\n");

    int pipePToC[2];
    int pipeCToP[2];
    char buf[8];

    pipe(pipePToC);
    pipe(pipeCToP);

    int pid = fork();
    if( pid == 0 ) // 子进程
    {
        close(pipePToC[WRITE]);
        read(pipePToC[READ] , buf , sizeof(buf));//把管道的内容读到buf
        close(pipePToC[READ]);

        close(pipeCToP[READ]);
        write(pipeCToP[WRITE],"pong\n",5);//写到管道里
        close(pipeCToP[WRITE]);

        printf("%d: received %s",getpid(),buf);
        exit(0);

    }else  // 父进程
    {
        close(pipePToC[READ]);
        write(pipePToC[WRITE] , "ping\n" , 5);
        close(pipePToC[WRITE]);

        close(pipeCToP[WRITE]);
        read(pipeCToP[READ],buf,sizeof(buf));
        close(pipeCToP[READ]);
        wait((int*)0);
        printf("%d: received %s",getpid(),buf);
        exit(0);
    }
}

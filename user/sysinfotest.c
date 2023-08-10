#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[]){
    struct sysinfo info;
    if (sysinfo(&info) < 0) {
        printf("Usage:\n");
        exit(1);
    } else {
        // 使用获取到的系统信息
        //printf("%d\n%d\n",info.freemem,info.nproc);
        printf("sysinfotest: start\nsysinfotest: OK\n");
    }
    exit(0);
}
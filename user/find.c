#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void find(char *path , char *target)
{
    char buf[512], *p;
    int fd;
    struct dirent de;//表示目录项结构的结构体
    struct stat st;

    if((fd = open(path, 0)) < 0){
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }

    if(fstat(fd, &st) < 0){
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return;
    }

    switch(st.type)
    {
        case T_FILE:
            if(strcmp( path + strlen(path) - strlen(target) , target ) ==0)
            {
                 printf("%s\n", path);
            }
            break;

        case T_DIR:
            if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
                printf("find: path too long\n");
                break;
            }
            strcpy(buf, path);
            p = buf+strlen(buf);
            *p++ = '/';

            while(read(fd, &de, sizeof(de)) == sizeof(de))//de存储了通过read读取到的文件信息，fd是已经打开的文件的文件描述符
            {//只有当读取的数据大小等于 de 结构体的大小时，循环才会继续执行,如果读取的数据大小不等于 sizeof(de)，可能是读到了文件
            //末尾或者发生了其他错误，循环条件就不成立，终止循环。
                if(de.inum == 0)
                    continue;
                memmove(p, de.name, DIRSIZ);//将 de.name 中存储的目录项名称数据复制到指定的内存块 p 中，长度为 DIRSIZ。
                p[DIRSIZ] = 0;              //将目录项的名称复制到路径缓冲区中的末尾，以便后续使用该路径进行递归查找。
                if(stat(buf, &st) < 0)
                {
                    printf("find: cannot stat %s\n", buf);
                    continue;
                }

                if(strcmp(".", de.name) != 0 && strcmp("..", de.name) != 0)
                {
                    find(buf, target);
                }
            }
            break;
  }
  close(fd);

}


int main(int argc, char *argv[])
{
    if(argc != 3)
    {
        printf("input arguments : find <path> <file name>\n");
        exit(1);
    }
   
    find(argv[1], argv[2]);
    exit(0);
}

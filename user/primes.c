#include "kernel/types.h"
#include "user/user.h"
#include "kernel/stat.h"

#define LENGTH 35

int point=2;
int array[LENGTH+1];

void
reverse(){
    int p[2];
    pipe(p);
    if(fork()==0){
        close(p[1]);
        read(p[0],&point,sizeof(point));
        read(p[0],array,sizeof(array));
        close(p[0]);
        if(point>=LENGTH){
            exit(0);
        }else{
            reverse();
        }
    }else{
        fprintf(1,"prime %d\n",point);
        int temp=point;
        for(int i=LENGTH;i>point;i--){
            if(array[i]!=-1){
                if(array[i]%point==0){
                array[i]=-1;
                }else{
                temp=i;
                }
            }
        }
        if(point == temp){
            point=LENGTH;
        }else{
            point = temp;
        } 
        close(p[0]);
        write(p[1],&point,sizeof(point));
        write(p[1],array,sizeof(array));
        close(p[1]);
        wait((int*)0);
    }
   
}

int 
main(int argc,char *argv[]){
    for(int i=0;i<LENGTH+1;i++){
        if(i==0||i==1){
            array[i]=-1;
        }else{
            array[i]=i;
        }
    }
    reverse();
    exit(0);
}
* 일정 : 2019/03/19 - 2019/03/22 (4일)
* 장소 : 한국과학기술정보연구원(대전 카이스트)

# MPI Training Course




### hello

```
[sedu14@node8298 C]$ module add craype-mic-knl gcc/7.2.0 openmpi/3.1.0
[sedu14@node8298 C]$ mpicc hello.c -o hello.x
[sedu14@node8298 C]$ ./hello.x
Hello world

[sedu14@node8298 C]$ cat hello.c
#include <stdio.h>
#include "mpi.h"

int main(int argc, char* argv[])
{
   /* Initialize the library */
   MPI_Init(&argc, &argv);

   /* Parallel Code */
   printf("Hello world\n");

   /* Warp it up. */
   MPI_Finalize();
   return 0;
}

[sedu14@node8298 C]$ mpirun -np 4 ./hello.x
Hello world
Hello world
Hello world
Hello world

[sedu14@node8298 C]$ mpicc hello_host.c -o hello_host.x

[sedu14@node8298 C]$ ./hello_host.x
MPI Version 3.1
Hello World.(Process name=node8298, nRank=0, nProcs=1)

[sedu14@node8298 C]$ mpirun -np 4 ./hello_host.x
Hello World.(Process name=node8298, nRank=1, nProcs=4)
Hello World.(Process name=node8298, nRank=2, nProcs=4)
MPI Version 3.1
Hello World.(Process name=node8298, nRank=0, nProcs=4)
Hello World.(Process name=node8298, nRank=3, nProcs=4)


```

### Basic Communication

```
[sedu14@node8298 C]$ mpicc send_recv.c -o send_recv.x
[sedu14@node8298 C]$ mpirun -np 2 ./send_recv.x
P:0 Got data from processor 1
P:0 Got 100 elements
P:0 value[5]=5.000000
[sedu14@node8298 C]$ ./send_recv.x
^Z
[1]+  Stopped                 ./send_recv.x
[sedu14@node8298 C]$


```


* 일정 : 2019/03/19 - 2019/03/22 (4일)
* 장소 : 한국과학기술정보연구원(대전 카이스트)

# MPI Training Course






* https://www.mpi-forum.org/docs/mpi-3.1/mpi31-report.pdf



109 

반복통신할 때.



114


실제통신을 할 때 START 를 가지고 시작하자.  STARTALL, 

부하 많이 걸리니까 밖으로 빼서 통신초기화 하고 실제 통신은 MPI START가지고 데이터를 주고 받자.


119

샌ㄴ드리시브 하나로 합쳐서 한꺼번에 처리, 내용은 동일, 통신효율 높다
122

0-1에게 1-2 2-3 3-0 에게 보내는 통신


126

버퍼통일 알규멘트 줄이고 메모리효율 높아지는 것.



----
```
[sedu14@node8298 C]$ cat contiguous.c
#include <stdio.h>
#include "mpi.h"
int main()
{
  int i, myrank, ibuf[20]={0,};
  MPI_Datatype inewtype;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  if(myrank==0) for(i=0;i<20;i++) ibuf[i]=i+1;
  MPI_Type_contiguous(3,MPI_INT,&inewtype);
  MPI_Type_commit(&inewtype);
  MPI_Bcast(ibuf,3,inewtype,0,MPI_COMM_WORLD);
  printf("%d: ibuf=",myrank);
  for(i=0;i<20;i++) printf(" %d",ibuf[i]);
  MPI_Type_free(&inewtype);
  printf("\n");
  MPI_Finalize();
  return 0;
}
[sedu14@node8298 C]$ mpicc contiguous.c -o contiguous.x
[sedu14@node8298 C]$ mpirun -np 3 ./contiguous.x
0: ibuf= 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
2: ibuf= 1 2 3 4 5 6 7 8 9 0 0 0 0 0 0 0 0 0 0 0
1: ibuf= 1 2 3 4 5 6 7 8 9 0 0 0 0 0 0 0 0 0 0 0
```

```
[sedu14@node8298 C]$ cat vector.c
#include <stdio.h>
#include <mpi.h>
int main()
{
  int ibuf[20]={0,}, myrank, i;
  MPI_Datatype inewtype;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  if(myrank==0)
    for(i=0;i<20;i++) ibuf[i]=i+1;
  MPI_Type_vector(4,2,3,MPI_INT,&inewtype);
  MPI_Type_commit(&inewtype);
  MPI_Bcast(ibuf,1,inewtype,0,MPI_COMM_WORLD);
  printf("%d,  ibuf=",myrank);
  for(i=0;i<20;i++) printf(" %d",ibuf[i]);
  printf("\n");
  MPI_Type_free(&inewtype);
  MPI_Finalize();
  return 0;
}
[sedu14@node8298 C]$ mpicc vector.c -o vector.x
[sedu14@node8298 C]$ mpirun -np 3 ./vector.x
0,  ibuf= 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
1,  ibuf= 1 2 0 4 5 0 7 8 0 10 11 0 0 0 0 0 0 0 0 0
2,  ibuf= 1 2 0 4 5 0 7 8 0 10 11 0 0 0 0 0 0 0 0 0
[sedu14@node8298 C]$


[sedu14@node8298 C]$ mpicc vector.c -o vector.x
[sedu14@node8298 C]$ mpirun -np 3 ./vector.x
0,  ibuf= 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
1,  ibuf= 1 2 0 4 5 0 7 8 0 10 11 0 0 0 0 0 0 0 0 0
2,  ibuf= 1 2 0 4 5 0 7 8 0 10 11 0 0 0 0 0 0 0 0 0
[sedu14@node8298 C]$ ^C
[sedu14@node8298 C]$ cat type_indexed.c -o type_indexed.x
cat: invalid option -- 'o'
Try 'cat --help' for more information.
[sedu14@node8298 C]$ cat type_indexed.c -o type_indexed.x
cat: invalid option -- 'o'
Try 'cat --help' for more information.
[sedu14@node8298 C]$ mpicc type_indexed.c -o type_indexed.x
[sedu14@node8298 C]$ mpirun -np 4 ./type_indexed.x
0   ibuf=1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
2   ibuf=1 2 0 0 5 6 7 8 9 0 0 12 13 14 0 0 0 0 0 0
1   ibuf=1 2 0 0 5 6 7 8 9 0 0 12 13 14 0 0 0 0 0 0
3   ibuf=1 2 0 0 5 6 7 8 9 0 0 12 13 14 0 0 0 0 0 0
dddd[sedu14@node8298 C]$


[sedu14@node8298 C]$ cat type_indexed.c
#include <stdio.h>
#include <mpi.h>
int main()
{
  int blengths[2]={2,3}, displacements[2]={0,4}, ibuf[20]={0,},myrank,i;
  MPI_Datatype new_type;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  MPI_Type_indexed(2,blengths,displacements,MPI_INT,&new_type);
  MPI_Type_commit(&new_type);
  if(myrank==0)
    for(i=0;i<20;i++) ibuf[i]=i+1;
  MPI_Bcast(ibuf,2,new_type,0,MPI_COMM_WORLD);
  printf("%d   ibuf=",myrank);
  for(i=0;i<20;i++) printf("%d ",ibuf[i]);
  printf("\nd");
  MPI_Type_free(&new_type);
  MPI_Finalize();
  return 0;
}
[sedu14@node8298 C]$ mpicc type_indexed.c -o type_indexed.x
[sedu14@node8298 C]$ mpirun type_indexed.x
0   ibuf=1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
2   ibuf=1 2 0 0 5 6 7 8 9 0 0 12 13 14 0 0 0 0 0 0
1   ibuf=1 2 0 0 5 6 7 8 9 0 0 12 13 14 0 0 0 0 0 0
3   ibuf=1 2 0 0 5 6 7 8 9 0 0 12 13 14 0 0 0 0 0 0
4   ibuf=1 2 0 0 5 6 7 8 9 0 0 12 13 14 0 0 0 0 0 0
6   ibuf=1 2 0 0 5 6 7 8 9 0 0 12 13 14 0 0 0 0 0 0
5   ibuf=1 2 0 0 5 6 7 8 9 0 0 12 13 14 0 0 0 0 0 0
7   ibuf=1 2 0 0 5 6 7 8 9 0 0 12 13 14 0 0 0 0 0 0
dddddddd[sedu14@node8298 C]$

```

160p

구조체 묶어 보낼 때

MPI_TYPE_CREATE_STRUCT


```
[sedu14@node8298 C]$ cat struct.c
#include <stdio.h>
#include "mpi.h"
int main()
{
  int rank,i;
  struct{ int num;  float x; double data[4];} a;
  int blocklengths[3]={1,1,4};
  MPI_Datatype types[3]={MPI_INT, MPI_FLOAT, MPI_DOUBLE};
  MPI_Aint disps[3];
  MPI_Datatype restype;

  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&rank);
  MPI_Get_address(&a.num,&disps[0]);
  MPI_Get_address(&a.x,&disps[1]);
  MPI_Get_address(&a.data,&disps[2]);
  disps[2]-=disps[0];   disps[1]-=disps[0];   disps[0] = (MPI_Aint)MPI_BOTTOM;
  MPI_Type_create_struct(3,blocklengths,disps,types,&restype);
  MPI_Type_commit(&restype);
  if(rank==0){
    a.num=6,   a.x=3.14;
    for(i=0;i<4;i++) a.data[i]=(double)i;
    MPI_Send(&a,1,restype,1,30,MPI_COMM_WORLD);
  }else if(rank==1){
    MPI_Recv(&a,1,restype,0,30,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
    printf("P: %d my a is %d %f %lf %lf %lf %lf\n", rank,a.num, a.x,\
           a.data[0],a.data[1], a.data[2], a.data[3]);
  }
  MPI_Type_free(&restype);
  MPI_Finalize();
  return 0;
}
[sedu14@node8298 C]$ mpicc struct.c -o struct.x
[sedu14@node8298 C]$ mpirun -np 2 ./struct.x
P: 1 my a is 6 3.140000 0.000000 1.000000 2.000000 3.000000
[sedu14@node8298 C]$ ^C

[sedu14@node8298 C]$ mpicc subarray.c -o subarray.x
[sedu14@node8298 C]$ mpirun -np 2 ./subarray.x
 0 0 0 0 0 0 0
 0 3 3 3 3 3 0
 0 4 4 4 4 4 0
 0 0 0 0 0 0 0
 0 0 0 0 0 0 0
 0 0 0 0 0 0 0
[sedu14@node8298 C]$ cat subarray.c]
cat: subarray.c]: No such file or directory
[sedu14@node8298 C]$ cat subarray.c
#include <stdio.h>
#include "mpi.h"
#define ndims 2
int main()
{
  int ibuf[6][7];
  int arr_sizes[ndims]={6,7}, arr_subsizes[ndims]={2,5}, arr_starts[ndims]={1,1};
  int i,j, myrank;
  MPI_Datatype newtype;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  if(myrank==0) {
    for(i=0;i<6;i++)
      for(j=0;j<7;j++) ibuf[i][j]=i+2;
  }else{
    for(i=0;i<6;i++)
      for(j=0;j<7;j++) ibuf[i][j]=0;
  }
  MPI_Type_create_subarray(ndims,arr_sizes,arr_subsizes,arr_starts,MPI_ORDER_C, \
                           MPI_INT,&newtype);
  MPI_Type_commit(&newtype);
  MPI_Bcast(ibuf,1,newtype,0,MPI_COMM_WORLD);
  if(myrank==1){
    for(i=0;i<6;i++){
      for(j=0;j<7;j++) printf(" %d",ibuf[i][j]);
      printf("\n");
   }
  }
  MPI_Type_free(&newtype);
  MPI_Finalize();
  return 0;
}
[sedu14@node8298 C]$


```




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

```

[sedu14@node8298 C]$ cat waitall.c
#include <stdio.h>
#include "mpi.h"
int main()
{
   int rank,size,count,i;
   float data[100], value[100];
   MPI_Request ireq[100];
   MPI_Init(NULL,NULL);
   MPI_Comm_rank(MPI_COMM_WORLD,&rank);
   if(rank==0){
     for(i=0;i<100;i++){
       data[i]=1.0*(i+1);
       MPI_Isend(&data[i],1,MPI_FLOAT,1,i,MPI_COMM_WORLD, &ireq[i]);
     }
   }else if(rank==1){
     for(i=0;i<100;i++)
       MPI_Irecv(&value[i],1,MPI_FLOAT,0,i,MPI_COMM_WORLD,&ireq[i]);
   }
   MPI_Waitall(100,ireq,MPI_STATUSES_IGNORE);
   if(rank==1)printf("value[99]:%f\n",value[99]);
   MPI_Finalize();
   return 0;
}
[sedu14@node8298 C]$ mpicc waitall.c -o waitall.x
[sedu14@node8298 C]$ mpirun -np 1 ./waitall.x
[node8298:55437] *** An error occurred in MPI_Isend
[node8298:55437] *** reported by process [3912761345,0]
[node8298:55437] *** on communicator MPI_COMM_WORLD
[node8298:55437] *** MPI_ERR_RANK: invalid rank
[node8298:55437] *** MPI_ERRORS_ARE_FATAL (processes in this communicator will now abort,
[node8298:55437] ***    and potentially your MPI job)
[sedu14@node8298 C]$ mpirun -np 2 ./waitall.x
value[99]:100.000000
[sedu14@node8298 C]$ mpirun -np 3 ./waitall.x
value[99]:100.000000
[node8298:55498] *** An error occurred in MPI_Waitall
[node8298:55498] *** reported by process [3917414401,2]
[node8298:55498] *** on communicator MPI_COMM_WORLD
[node8298:55498] *** MPI_ERR_REQUEST: invalid request
[node8298:55498] *** MPI_ERRORS_ARE_FATAL (processes in this communicator will now abort,
[node8298:55498] ***    and potentially your MPI job)
[sedu14@node8298 C]$ mpirun -np 4 ./waitall.x
value[99]:100.000000
[node8298:55566] *** An error occurred in MPI_Waitall
[node8298:55566] *** reported by process [3904569345,2]
[node8298:55566] *** on communicator MPI_COMM_WORLD
[node8298:55566] *** MPI_ERR_REQUEST: invalid request
[node8298:55566] *** MPI_ERRORS_ARE_FATAL (processes in this communicator will now abort,
[node8298:55566] ***    and potentially your MPI job)
[node8298:55557] 1 more process has sent help message help-mpi-errors.txt / mpi_errors_are_fatal
[node8298:55557] Set MCA parameter "orte_base_help_aggregate" to 0 to see all help / error messages
[sedu14@node8298 C]$

```

---




# 0320

### 176

여기 집합통신은 없다. 종류는 많이 없다. 

* bcast 전체다 뿌려주는
* gather 긁어 모으는거, 랭크1개 노드1개로 모으는
* scatter 한노드에 데이터가 있다면 부분부분 뿌려주는
* allgather gather의 bcast버전. 전체뿌리기 떄문에 통신량이 많다. 뿌려야하는 양이 많다면 통신효율도 따져봐야한다.
* alltoall p0에 각 랭크에 첫번째부분, FFT하시는 분들, 3차원으로 FFT해야한다 x방향, y방향 등 방향처리 쪽에서 많이 쓴다. 이것도 통신량 많다.
* reduce gather는 데이터를 모으기만 하는데 이건 모으면서 계산을 해준다. 
* allreduce는 redue의 bcast 버전.
* scan 취합하면서 연산
* reduce_scatter 긁어모으면서 연산을 하는데 이렇게 연산을 하면서 각각처리?
  * 이것 외에 더 많은 것이 있을 수 있는데 표준문서 참고해라.

### 178-179
All-To-All 모든 프로세서가 결과에 관여 `MPI_ALL_*`

|  ㅁ | ㄹ  | ㅋ  |   |   |
|---|---|---|---|---|
| ㅁ  | ㄹ  |  ㅋ |   |   |
|   ㅁ|   ㄹ|   ㅋ|   |   |
| ㅁ  |  ㄹ | ㅋ  |   |   |

buffer가 2개? 메모리 문제, MPI이 부담, 

예를 든다면 순차코드에서 input파일 읽어서 output 내는 작업을 하면 
1. A(100)
이건 배열의개수가 100개

1. A(100)
2. 4 process
3. 리시브버퍼, b(100), 부분계산 결과 받아서 사용
4. 얘는 데이터가 800

1. A(100), a(25)*3, B(100)
2. 4 process
3. 275

1. a(25)*4, B(100)
2. 4 process
3. 100

* 메모리사용량 자체가 8개정도 늘게 된다. 각가 필요한 데이터 각자 불러오게 하기. 
* 그래서 이런 하이브리드형태, 속도문제, 메모리부족 방지 위해 사용
* buffer 공통사용할 수 있게 제공. buffer 하나만 있으면 된다는 의미
* send recive 버퍼 같이 쓸 수 있다. 3.0대 오면서. 
* 블럭킹 통신, 넌블로킹통신 다 제공


### 180

Barrier 베리어.

mpi 프로세서, openMP thread 동기화할 때 필요한 기능, 모든 프로세서들이 이 MPI가 호출한 지역까지 도달할 떄까지 다른 것들을 블로킹. 별다른 기능이 있는게 아니라 앞에 계산이 다 끝나도 다른 프로세서가 끝나지 않았다면 대기.

### 181

Broadcast bcast

루트는 자신을 포함한 모든 프로세스에 메시지를 전송, 사용법 자체도 어렵지 않다.

뒤에 루트가 있는데 투르가 0라면 전체, 1이라면 1번랭크에 있는 데이터를 전체노드에 뿌리곘다.

IBCAST 기본기능은 안바뀌는데 뒤에 request만 하나 붙는데 이건 넌블록킹 통신만 초기화 다음 단계로 진행, 데이터는 날아가고 있을 것이고, 

### 185 실습
* 오늘은 실습 많다.

```C
#include "stdio.h"
#include <mpi.h>
int main()
{
  int i, nrank,nprocs, ROOT=0;
  int buf[4]={0,}, buf2[4]={0,};
  MPI_Request req;

  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&nrank);
  MPI_Comm_size(MPI_COMM_WORLD,&nprocs);
  if(nrank==ROOT) buf[0]=5, buf[1]=6, buf[2]=7, buf[3]=8;
  if(nrank==nprocs-1) buf2[0]=50, buf2[1]=60, buf2[2]=70, buf2[3]=80;
  printf("rank=%d, Before(buf): %d  %d  %d  %d\n",nrank,buf[0],buf[1],buf[2],buf[3]);
  
  // 제일 마지막 버퍼 전체에 뿌리겠다. 위는 넌블록킹 아래는 블록킹 통신
  MPI_Ibcast(buf2,4,MPI_INT,nprocs-1,MPI_COMM_WORLD,&req);
  MPI_Bcast(buf,4,MPI_INT, ROOT,MPI_COMM_WORLD);
  printf("rank=%d, After(buf): %d  %d  %d  %d\n",nrank,buf[0],buf[1],buf[2],buf[3]);

  // 버퍼 대기
  MPI_Wait(&req,MPI_STATUS_IGNORE);
  // 버퍼 확인해보면 50 60 70 80 이렇게 다 전달
  printf("rank=%d, AFTER(BUF2): %d  %d  %d  %d\n",nrank,buf2[0],buf2[1],buf2[2],buf2[3]);
  MPI_Finalize();
  return 0;
}

```

결과출력
```
[sedu14@node8285 ~]$ module add gcc/7.2.0 craype-mic-knl openmpi/3.1.0
[sedu14@node8285 C]$ mpicc bcast.c -o bcast.x
[sedu14@node8285 C]$ mpirun -np 4 ./bcast.x
rank=0, Before(buf): 5  6  7  8
rank=1, Before(buf): 0  0  0  0
rank=2, Before(buf): 0  0  0  0
rank=3, Before(buf): 0  0  0  0
rank=0, After(buf): 5  6  7  8
rank=0, AFTER(BUF2): 50  60  70  80
rank=2, After(buf): 5  6  7  8
rank=1, After(buf): 5  6  7  8
rank=1, AFTER(BUF2): 50  60  70  80
rank=2, AFTER(BUF2): 50  60  70  80
rank=3, After(buf): 5  6  7  8
rank=3, AFTER(BUF2): 50  60  70  80
[sedu14@node8285 C]$


```

* 전반적으로 통신량 신경써야한다.


### 189 

* MPI_GATHER, MPI_GATHERV(일반적)
차이는 하는 역할을 똑같은데 전체 양이 일정할테, 흩어져있는 데이터의 크기가 랭크마다 다를 때 사용하는게 V, vector 사용
* 동일한 크기의 송신버퍼 모으는 것. 
* 모으는데 어떻게 모으느냐? 순서대로
* 랭크의 순서대로
* 예전같으면 센드리시브 지정해줘야하는데 `MPI_IN_PLACE` 를 사용하면 하나 가지고 사용할 있다.
* `MPI_IN_PLACE`는 어디에 지정하느냐? 센드버퍼에.
* 다른 기능은 동일

### 190
* sendcount 각 랭크로 몇개를?
* recvbuf 루트에서 몇개씩 받을 것이냐?

### 191

포트란은 차이는 몇개 파라메터 다른것뿐

### 192

센드버퍼는 스칼라 1나, 리시브버퍼는 날아오는 데이터를 1군대 저장, 프로세서 갯수만큼 크기 가져야한다. 스칼라버터 크기 상관없는데 

300이라는 버퍼사이즈를 준비해야한다.

### 194 실습

```

```

### 198 MPI_GATHERV

MPI_GATHERV

디스플레이스먼트 지정, 앞으 게덜하고 차이가 sendcont값, 배열로 잡아야하고 디스플레이스먼트 알규먼트 지정, 앞은 이거 없고 자동으로 알아서 지정

### 199

sendcount 스칼라, 루트로 보낼, sendtype 있고 

### 200

넌블록킹 통신 마지막에 request 쓰는거.

여기서도 in place 옵션 가용가능 sendbuf 쪽에 MPI_  지정.


### 202

배열크기 프로세서 크기만큼

```c
#include <stdio.h>
#include <stdlib.h>
#include "mpi.h"
int main()
{
  int i,myrank;
  int isend[3],*irecv;
  int iscnt, ircnt[3]={1,2,3}, idisp[3]={0,1,3};
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  if(myrank==0) irecv=(int*)malloc(6*sizeof(int));
  for(i=0;i<myrank+1;i++) isend[i]=myrank+1;
  iscnt=myrank+1;
  MPI_Gatherv(isend, iscnt,MPI_INT, irecv, ircnt,idisp,MPI_INT, 0, MPI_COMM_WORLD);
  if(myrank==0){
    printf("irecv="); for(i=0;i<6;i++) printf("   %d", irecv[i]);
    printf("\n");
  }

  for(i=0;i<myrank+1;i++) isend[i]=(myrank+1)*10;
  if(myrank==0){
    irecv[0]=isend[0];
    MPI_Gatherv(MPI_IN_PLACE,iscnt,MPI_INT,irecv,ircnt,idisp,MPI_INT,0,MPI_COMM_WORLD);
    printf("irecv="); for(i=0;i<6;i++) printf("   %d", irecv[i]);
    printf("\n");
    free(irecv);
  }
  else{
    MPI_Gatherv(isend,iscnt,MPI_INT, irecv,ircnt,idisp,MPI_INT,0,MPI_COMM_WORLD);
  }
  MPI_Finalize();
  return 0;
}

```



###

```
[sedu14@node8285 C]$ mpicc gatherv.c -o gatherv.x
[sedu14@node8285 C]$ mpirun -np 3 ./gatherv.x
irecv=   1   2   2   3   3   3
irecv=   10   20   20   30   30   30

[sedu14@node8285 C]$ mpicc gatherv2.c -o gatherv2.x
[sedu14@node8285 C]$ mpirun -np 3 ./gatherv2.x
myrank: 0   isend=  1  0  0  0  0  0
myrank: 1   isend=  2  2  0  0  0  0
myrank: 2   isend=  3  3  3  0  0  0

MYRANK: 0   ISEND=  1  2  2  3  3  3

```


### 211

MPI_ALLGATHER
뿌려주는, 앞으로는 화살표가 많아지는데 이건 통신량이 많아지는 거


### 212 

전체노드가 자기자신한테는 통신을 하지 않는다. 이건 수신버퍼에 지정되어있어야 한다는 말

```c
#include <stdio.h>
#include <mpi.h>
int main()
{
  int isend,irecv[3]={0,},nrank;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&nrank);
  isend=nrank+1;
  printf("rank: %d, isend: %d\n",nrank,isend);
  MPI_Allgather(&isend,1,MPI_INT,irecv,1,MPI_INT,MPI_COMM_WORLD);
  printf("rank: %d, irecv= %d  %d  %d\n",nrank,irecv[0],irecv[1],irecv[2]);
  printf("\n");
  
  isend=(nrank+1)*10;
  irecv[nrank]=isend;
  MPI_Allgather(MPI_IN_PLACE,1,MPI_INT,irecv, 1,MPI_INT,MPI_COMM_WORLD);
  printf("rank: %d, irecv= %d  %d  %d\n",nrank,irecv[0],irecv[1],irecv[2]);
   MPI_Finalize() ;
  return 0;
}

```

```c
#include <stdio.h>
#include <mpi.h>
int main()
{
  int i,myrank,tmp;
  int isend[3],irecv[6];
  int iscnt,ircnt[3]={1,2,3}, idisp[3]={0,1,3};
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  for(i=0;i<myrank+1;i++) isend[i]=myrank+1;
  iscnt=myrank+1;
  MPI_Allgatherv(isend,iscnt,MPI_INT,irecv,ircnt,idisp,MPI_INT,MPI_COMM_WORLD);
  printf("myrank: %d    irecv=",myrank); 
  for(i=0;i<6;i++) printf("   %d",irecv[i]);
  printf("\n");

  tmp=(myrank+1)*10;
  if(myrank==0) irecv[0]=tmp;
  if(myrank==1) irecv[1]=irecv[2]=tmp;
  if(myrank==2) irecv[3]=irecv[4]=irecv[5]=tmp; // 입력데이터 할당
  MPI_Allgatherv(MPI_IN_PLACE,iscnt,MPI_INT,irecv,ircnt,idisp,MPI_INT,MPI_COMM_WORLD);
  printf("MYRANK: %d    IRECV=",myrank);
  for(i=0;i<6;i++) printf("   %d",irecv[i]);
  printf("\n");


  MPI_Finalize();
  return 0;
}

```


### 219
gaherv의 전체 bcast. 통신량도 많고

```
[sedu14@node8285 C]$ mpicc allgather.c -o allgather.x
[sedu14@node8285 C]$ mpirun -np 3 ./allgather.x
rank: 0, isend: 1
rank: 1, isend: 2
rank: 2, isend: 3
rank: 0, irecv= 1  2  3
rank: 1, irecv= 1  2  3
rank: 2, irecv= 1  2  3
rank: 0, irecv= 10  20  30
rank: 2, irecv= 10  20  30
rank: 1, irecv= 10  20  30

[sedu14@node8285 C]$ mpicc allgatherv.c -o allgatherv.x
[sedu14@node8285 C]$ mpirun -np 3 ./allgatherv.x
myrank: 0    irecv=   1   2   2   3   3   3
myrank: 1    irecv=   1   2   2   3   3   3
myrank: 2    irecv=   1   2   2   3   3   3
MYRANK: 1    IRECV=   10   20   20   30   30   30
MYRANK: 0    IRECV=   10   20   20   30   30   30
MYRANK: 2    IRECV=   10   20   20   30   30   30

```

* c는 제로인덱스 0
* 포트란은 제로인덱스 1부터.
* 그래서 가급적 취지에 맞게 포트란 인덱스 조정해서 랭크가 보내는 개수 0부터로.
* 인덱스를 바꿀 수 있다는 말은 유리한 장점. 
* 나중에 인덱스 연산이 필요하다. 포트란은 필요없으니 장점
* 그러니까 맵핑시켜줘야한다는 말.


### 227 scatter

MPI_SCATTER
게더반대 모아져있는 데이터 뿌려주는, 비케스트는 전체, 스켓터는 일부만


```c
#include <stdio.h>
#include <mpi.h>
int main()
{
  int i, myrank;
  int isend[3]={0,}, irecv=0;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  if(myrank==0) for(i=0;i<3;i++) isend[i]=i+1;
  // 루트가 0, 1번2번은 0번 아니어도 된다.
  // 한개싞 타입은 리시브
  MPI_Scatter(isend,1,MPI_INT,&irecv,1,MPI_INT,0,MPI_COMM_WORLD);
  printf("myrank: %d  irecv=%d\n",myrank,irecv);

  if(myrank==0){
    for(i=0;i<3;i++) isend[i]=(i+1)*10;
  }
  else{
    for(i=0;i<3;i++) isend[i]=0;
  }
  irecv=0; // 쓰기 위해서 다시 0으로 초기화
  
  // 루트 아닐때는 그대로
  // 루트일 때만 안에 in place 옵션 써주고
  if(myrank==0){
    irecv=isend[0];
    MPI_Scatter(isend,1,MPI_INT, MPI_IN_PLACE, 1, MPI_INT, 0, MPI_COMM_WORLD);
  }
  else{
    MPI_Scatter(isend,1,MPI_INT, &irecv,1, MPI_INT, 0, MPI_COMM_WORLD);
  }
  printf("RANK: %d,  IRECV=%d\n",myrank,irecv);
  MPI_Finalize();
  return 0;
}

```

if문으로 동적으로 할당하면 메모리 이득
```c
#include <stdio.h>
#include <mpi.h>
int main()
{
  int i, myrank;
  int isend[6]={1,2,2,3,3,3}, irecv[3]={0,};
  int isndcnt[3]={1,2,3}, idisp[3]={0,1,3}; // isend에 1번이 idisp 0번
  int rcvcnt;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  rcvcnt=myrank+1;
  MPI_Scatterv(isend,isndcnt,idisp, MPI_INT, irecv, rcvcnt,MPI_INT, 0, MPI_COMM_WORLD);
  printf("rank : %d    irecv=",myrank);
  for(i=0;i<3;i++) printf("%d ",irecv[i]);
  printf("\n");

  for(i=0;i<3;i++) irecv[i]=0;
  if(myrank==0){
    isend[0]=10, isend[1]=20, isend[2]=20;
    isend[3]=30, isend[4]=30, isend[5]=30;
    irecv[0]=isend[0];
    MPI_Scatterv(isend,isndcnt,idisp,MPI_INT,MPI_IN_PLACE,rcvcnt,MPI_INT,0,MPI_COMM_WORLD);
  }
  else{
    MPI_Scatterv(isend,isndcnt,idisp, MPI_INT, irecv, rcvcnt,MPI_INT, 0, MPI_COMM_WORLD);
  }
  printf("RANK : %d    IRECV=",myrank);
  for(i=0;i<3;i++) printf("%d ",irecv[i]);
  printf("\n");

  MPI_Finalize();
  return 0;
}

```


```C
#include <stdio.h>
#include <mpi.h>
int main()
{
  int isend[6]={0,}, isndcnt[3]={1,2,3}, idisp[3]={0,1,3};
  int rcvcnt,myrank,i;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  rcvcnt=myrank+1;
  if(myrank==0){
    isend[0]=1,  isend[1]=2,  isend[2]=2;
    isend[3]=3,  isend[4]=3,  isend[5]=3;
  }
  printf("rank: %d  isend=",myrank);
  for(i=0;i<6;i++) printf("  %d",isend[i]);
  printf("\n");
  if(myrank==0){
    MPI_Scatterv(isend,isndcnt,idisp,MPI_INT,MPI_IN_PLACE,rcvcnt,MPI_INT,0,MPI_COMM_WORLD);
  }
  else{
    MPI_Scatterv(isend,isndcnt,idisp,MPI_INT,&isend[idisp[myrank]],rcvcnt,MPI_INT,0,MPI_COMM_WORLD);
  }
  printf("RANK: %d  ISEND=",myrank);
  for(i=0;i<6;i++) printf("  %d",isend[i]);
  printf("\n");

  MPI_Finalize();
  return 0;
}
// 리시브버퍼를 isend로 이건 많이 쓰니까 따로 추가.ㅏ rebuf 따로 선언할 필요가 없다는거
// 포트란할때는 idisp에 myrank +1 은 인덱스 차이 때문에 1추가.
```


```

[sedu14@node8285 C]$ mpicc scatter.c -o scatter.x
[sedu14@node8285 C]$ mpicc scatterv.c -o scatterv.x
[sedu14@node8285 C]$ mpicc scatterv2.c -o scatterv2.x

[sedu14@node8285 C]$ mpirun -np 3 ./scatter.x
myrank: 0  irecv=1
myrank: 1  irecv=2
myrank: 2  irecv=3
RANK: 0,  IRECV=10
RANK: 1,  IRECV=20
RANK: 2,  IRECV=30

[sedu14@node8285 C]$ mpirun -np 4 ./scatter.x
myrank: 1  irecv=2
myrank: 0  irecv=1
myrank: 2  irecv=3
RANK: 1,  IRECV=20
RANK: 0,  IRECV=10
myrank: 3  irecv=0
RANK: 3,  IRECV=0
RANK: 2,  IRECV=30

[sedu14@node8285 C]$ mpirun -np 3 ./scatterv.x
rank : 0    irecv=1 0 0
rank : 1    irecv=2 2 0
rank : 2    irecv=3 3 3
RANK : 0    IRECV=10 0 0
RANK : 1    IRECV=20 20 0
RANK : 2    IRECV=30 30 30

[sedu14@node8285 C]$ mpirun -np 3 ./scatterv2.x
rank: 0  isend=  1  2  2  3  3  3
rank: 1  isend=  0  0  0  0  0  0
RANK: 1  ISEND=  0  2  2  0  0  0
RANK: 0  ISEND=  1  2  2  3  3  3
rank: 2  isend=  0  0  0  0  0  0
RANK: 2  ISEND=  0  0  0  3  3  3

```

### scatterv

전달하는 데이터개수 다르다. 리시브버터 위치 다르다? 

게더 리시브파트에서 지정

얘는 어떤 위치에 있는 데이터 지정.

단지 차이는 sendcounts 복수형, 리시브? 단수형. 다 똑같은데 앞의 차이는 게더브이는 리시브파트에 있었다 얘는 센딩 배열. 


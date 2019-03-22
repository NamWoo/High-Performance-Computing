* 일정 : 2019/03/19 - 2019/03/22 (4일)
* 장소 : 한국과학기술정보연구원(대전 카이스트)

# Hybrid Programming Training Course (MPI + OpenMP)




## OpenMP, MPI 리뷰

그 안에서 threads가 여러개 발생

---

### 12

하나의 CPU에 프로세스 하나 발생시키고 그 안에 쓰래드를 4개 만들자.

### 메모리 문제 해결하기 위해

프로세스 4개 만들고 각자의 변수를 각 메모리에 올리는

한 노드에 쓰레드4개 만들고 쓰는게 더 유리하지 않겠냐? MPI 성능을 더 올리기 위해 hybrid.

혼합해서 쓰면 코딩은 복잡

### 14 접속

작업제출
```
[sedu14@login02 sedu14]$ qsub -I -V -l select=1:ncpus=32:mpiprocs=4:ompthreads= -l walltime=04:00:00 -q debug
qsub: waiting for job 2014823.pbs to start
qsub: job 2014823.pbs ready

```




### Checking Environment


```c

#include <stdio.h>
#include <mpi.h>
#include <omp.h>

int main(int argc, char *argv[])
{
        int rank, nprocs, tid;
        MPI_Init(&argc, &argv);
        MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
        MPI_Comm_rank(MPI_COMM_WORLD, &rank);

#pragma omp parallel private(tid)
{
tid = omp_get_thread_num(); // tid 이름 할당하고 확인
printf("Hello World tid = %d rank = %d nprocs = %d \n", tid, rank, nprocs);




}

MPI_Finalize();

}

```

지금까지는 그냥 `mpirun -np 2` 이런 식으로 했는데 gcc 컴파일에서는 추가 옵션이 필요하다.
32개 코어에 프로세스 4개 할당, 나머지 cpu에 threads가 하나씩 붙기를, 그럼 32개 코어 다 쓰게, 그런데 opnemp같은 경우 하나의 코어에 하나의 프로세스 달라붙어서 발행하는 thread가 찾아가야하는데 procs에 2개가 달라붙어서 방지하기 위해 그런 옵션 쓰는 것이다.
openMPI 쓸때는 이 옵션이 필요하다.


```
[sedu14@node8283 to1]$ mpicc -fopenmp check_env.c -o check_env.x


[sedu14@node8283 to1]$ time mpirun -np 2 -hostfile hosts -x OMP_NUM_THREADS=2 ./check_env.x
--------------------------------------------------------------------------
Open RTE was unable to open the hostfile:
    hosts
Check to make sure the path and filename are correct.
--------------------------------------------------------------------------

real    0m0.509s
user    0m0.089s
sys     0m0.205s

[sedu14@node8283 to1]$ mpirun -np 2 --map-by NUMA:PE=2 -x OMP_NUM_THREADS=2 ./check_env.x
Hello World tid = 0 rank = 1 nprocs = 2
Hello World tid = 1 rank = 1 nprocs = 2
Hello World tid = 0 rank = 0 nprocs = 2
Hello World tid = 1 rank = 0 nprocs = 2


```

### 제출?

`qsub -I -V -l select=2:ncpus=16:mpiprocs=4:ompthreads=4 -l walltime=04:00:00 -q debug`

섹션 복사해서 접속 작업은 홈 디렉토리에서,  다시 해서 vi 깨지는거 방지
* 컴파일 실행은 계산노드.
* 로긴에서는 편집만.


PBS_NODEFILE 할당받은 자원 확인 가능

```
[sedu14@node8283 to1]$ cat /var/spool/pbs/aux/2014823.pbs
node8283
node8283
node8283
node8283

```


### OpenMP and MPI Exercise

```c
#include <stdio.h>
#include <math.h>
#define ITER 8

int main()
{
    int loop;
    long i, sum, max;
    for(loop=1, loop<=ITER; loop++){
        max = pow(10, loop);
        sum = 0;
        for(i=1; i<=max; i++){
            sum += i;
        }
        printf("sum = %ld\n", sum);
    }
}
```


qopenmp 이건 인텔로
gcc니까 fopenmp 나머지는 일반적인 코딩


### 세션 하나 다시 만들고
```
[sedu14@login02 to1]$ pwd
/scratch/sedu14/to1
[sedu14@login02 to1]$ module add craype-mic-knl gcc/7.2.0 openmpi/3.1.0
[sedu14@login02 to1]$ mpirun -np 8 --map-by NUMA:PE=2 -x OMP_NUM_THREADS=2 ./check_env.x
--------------------------------------------------------------------------
WARNING: No preset parameters were found for the device that Open MPI
detected:

  Local host:            login02
  Device name:           i40iw0
  Device vendor ID:      0x8086
  Device vendor part ID: 14291

Default device parameters will be used, which may result in lower
performance.  You can edit any of the files specified by the
btl_openib_device_param_files MCA parameter to set values for your
device.

NOTE: You can turn off this warning by setting the MCA parameter
      btl_openib_warn_no_device_params_found to 0.
--------------------------------------------------------------------------
--------------------------------------------------------------------------
No OpenFabrics connection schemes reported that they were able to be
used on a specific port.  As such, the openib BTL (OpenFabrics
support) will be disabled for this port.

  Local host:           login02
  Local device:         i40iw0
  Local port:           1
  CPCs attempted:       rdmacm, udcm
--------------------------------------------------------------------------
Hello World tid = 0 rank = 0 nprocs = 8
Hello World tid = 1 rank = 0 nprocs = 8
Hello World tid = 0 rank = 1 nprocs = 8
Hello World tid = 1 rank = 1 nprocs = 8
Hello World tid = 0 rank = 2 nprocs = 8
Hello World tid = 1 rank = 2 nprocs = 8
Hello World tid = 0 rank = 4 nprocs = 8
Hello World tid = 1 rank = 4 nprocs = 8
Hello World tid = 0 rank = 6 nprocs = 8
Hello World tid = 1 rank = 6 nprocs = 8
Hello World tid = 0 rank = 7 nprocs = 8
Hello World tid = 1 rank = 7 nprocs = 8
Hello World tid = 0 rank = 5 nprocs = 8
Hello World tid = 1 rank = 5 nprocs = 8
Hello World tid = 1 rank = 3 nprocs = 8
Hello World tid = 0 rank = 3 nprocs = 8
[login02:224371] 23 more processes have sent help message help-mpi-btl-openib.txt / no device params found
[login02:224371] Set MCA parameter "orte_base_help_aggregate" to 0 to see all help / error messages
[login02:224371] 23 more processes have sent help message help-mpi-btl-openib-cpc-base.txt / no cpcs for port


```

###

#### 순차코드

```c


#include <stdio.h>
#include <math.h>
#define ITER 8

int main()
{
    int loop;
    long i, sum, max;
    for(loop=1; loop<=ITER; loop++){
        max = pow(10, loop);
        sum = 0;
        for(i=1; i<=max; i++) sum += i;

        printf("sum = %ld\n", sum);
    }
}

```

```
[sedu14@login02 to1]$ gcc sum_serial.c -o sum_serial_s_x -lm
[sedu14@login02 to1]$ time ./sum_serial_s_x
sum = 55
sum = 5050
sum = 500500
sum = 50005000
sum = 5000050000
sum = 500000500000
sum = 50000005000000
sum = 5000000050000000

real    0m0.329s
user    0m0.316s
sys     0m0.011s


```

#### 병렬코드 openMP

```c

#include <stdio.h>
#include <math.h>
#define ITER 8

int main()
{
    int loop;
    long i, sum, max;
    for(loop=1; loop<=ITER; loop++){
        max = pow(10, loop);
        sum = 0;

#pragma omp parallel private(+:sum)

        for(i=1; i<=max; i++) sum += i;

        printf("sum = %ld\n", sum);
    }
}
```

```
[sedu14@login02 to1]$ gcc -fopenmp sum_omp_reduction.c -o sum_omp_reduction.x -lm
[sedu14@login02 to1]$ time ./sum_omp_reduction.x
sum = 55
sum = 5050
sum = 500500
sum = 50005000
sum = 5000050000
sum = 500000500000
sum = 50000005000000
sum = 5000000050000000

real    0m0.079s
user    0m1.189s
sys     0m0.017s

```

### OpenMP using task


```c
#include <stdio.h>
#include <math.h>
#define ITER 8

int main(int argc, char *argv[])
{
    int loop;
    long i, sum, max;
    omp_set_nested(1);

#pragma omp parallel private(max, sum)
{
    #pragma omp single
    {
        for(loop=1; loop<=ITER;loop++)
        {
            max = pow(10, loop);
            #pragma omp task
            {
                sum = 0;
                #pragma omp parallel for reduction(+:sum)
                for(i=1; i<=max; i++) sum += i;
                printf("sum = %d\n", sum);
            } // end omp task
        }
    }   // end omp single
}   // end omp parallel
}
```

```
[sedu14@login02 to1]$ vi sum_omp_tast.c
[sedu14@login02 to1]$ gcc -fopenmp sum_omp_tast.c -o sum_omp_tast.x -lm
sum_omp_tast.c: In function ‘main’:
sum_omp_tast.c:9:5: warning: implicit declaration of function ‘omp_set_nested’ [-Wimplicit-function-declaration]
     omp_set_nested(1);
     ^~~~~~~~~~~~~~
[sedu14@login02 to1]$ vi sum_omp_tast.c
[sedu14@login02 to1]$ ls
check_env.c  sum_omp_reduction.c  sum_omp_tast.c  sum_serial.c
check_env.x  sum_omp_reduction.x  sum_omp_tast.x  sum_serial_s_x
[sedu14@login02 to1]$ time ./sum_omp_tast.x
sum = 5050
sum = 50005000
sum = 55
sum = 500500
sum = 1784293664
sum = -2004260032
sum = 705082704
sum = 987459712

real    0m0.082s
user    0m0.984s
sys     0m0.035s

```

여기까지 OPENMP
10개의 쓰레드가 자동으로 분할

### Decomposition Function for MPI

여기는 MPI
여기는 직접 분할해줘야 한다. 루프를 분할해주는 함수가 `get_start_end`
n 전체 루프의 반복횟수 rank 할당할 가져갈, nprocs 전체 프로세서 갯수, 시작할 인덱스 끝 인덱스

n값이 10이고 12두번 반복하는데 프로세스개수가 3개다? 3번 반복
n값이 14, 프로세스 개수가 3라면 나누어떨어지지 않기 때문에 누군가 더 일을 해야한다 그래서 앞에서 부터 하나씩 더 추가하겠다. 그 내용을 코드로 만들어 놓은 것.

MPI는 자동으로 루프분할을 해주지 않기 때문.

```c
void get_start_end(int n, int rank, int nprocs, long *istart long *iend)
{
    int q, r;
    q=n/nprocs;
    r=n%nprocs;
    if(rank < r){   
        *istart = rank*q + rank +1;
        *iend = *istart + q;
    }
    else{
        *istart = rank*q + r +1;
        *iend = *istart + q -1;
    }
}
```

```

```

### MPI with collective Communication

```c
#include <stdio.h>
#include <mpi.h>
#include <math.h>
#define ITER 8

void get_start_end(int n, int rank, int nprocs, long *istart, long *iend)
{
    int q, r;
    q=n/nprocs;
    r=n%nprocs;
    if(rank < r){   
        *istart = rank*q + rank +1;
        *iend = *istart + q;
    }
    else{
        *istart = rank*q + r +1;
        *iend = *istart + q -1;
    }
}

int main(int argc, char *argv[])
{
    int loop;
    long i, sum, max, istart, iend, local_sum;
    MPI_
    int rank, nprocs;
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    for(loop=1; loop<=ITER;loop++){
        max = pow(10, loop);
        sum = 0;
        local_sum = 0;
        get_start_end(max, rank, nprocs, &istart, &iend);        
            for(i=1; i<=max; i++) local_sum += i;

        MPI_Reduce(&local_sum, &sum, 1, MPI_LONG, MPI_SUM, 0, MPI_COMM_WORLD);
        if(rank==0){
            printf("sum = %d\n", sum);
        }
            
    } 
}

```

```

```

### MPI with p2p Communication

```c
#include <stdio.h>
#include <mpi.h>
#include <math.h>
#define ITER 8

void get_start_end(int n, int rank, int nprocs, long *istart, long *iend)
{
    int q, r;
    q=n/nprocs;
    r=n%nprocs;
    if(rank < r){   
        *istart = rank*q + rank +1;
        *iend = *istart + q;
    }
    else{
        *istart = rank*q + r +1;
        *iend = *istart + q -1;
    }
}

int main(int argc, char *argv[])
{
    int loop rank, nprocs; 
    long i, sum, max, istart, iend, local_sum;
    MPI_Status status;
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    for(loop=1; loop<=ITER;loop++){
        max = pow(10, loop);
        sum = 0;
        local_sum = 0;
        get_start_end(max, rank, nprocs, &istart, &iend);        
            for(i=1; i<=max; i++) local_sum += i;

        MPI_Reduce(&local_sum, &sum, 1, MPI_LONG, MPI_SUM, 0, MPI_COMM_WORLD);
        if(rank==0){
            printf("sum = %d\n", sum);
        }
            
    } 
}
```

```

```

### MPI with One-time collective communication

```c

```

```

```

### MPI with p2p using MPI_ANY_Source/tag

```c

```

```

```

## Hybrid 

### MPI_INIT_THREAD

여러가지 값이 올 수 있다

### MPI_TEMPLATE 실습

```c
#include <stdio.h>
#include <mpi.h>
#include <math.h>
#define ITER 8

void get_start_end(int n, int rank, int nprocs, long *istart, long *iend)
{
    int q, r;
    q=n/nprocs;
    r=n%nprocs;
    if(rank < r){   
        *istart = rank*q + rank +1;
        *iend = *istart + q;
    }
    else{
        *istart = rank*q + r +1;
        *iend = *istart + q -1;
    }
}

int main(int argc, char *argv[])
{
    int rank, nprocs, provide, tid, nthreads;
    long i, max_val, istart iend, total_sum=0, tmp_sum;
    long local_istart, local_iend, local_sum;
    MPI_Status status;
    MPI_Request req;
    MPI_Init_thread(&argc, &argv, MPI_THREAD_XXX,&provide);
    MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    max_val = pow(10, ITER);
    get_start_end(max_val, rank, nprocs, &istart, &iend);
    // .....
    if(rank==0) printf("sum = %ld\n", total_sum);
    MPI_Finalize()           
} 

```

```

```

### Single Mode

```c
#include <stdio.h>
#include <mpi.h>
#include <math.h>
#include <omp.h>
#define ITER 8

void get_start_end(int n, int rank, int nprocs, long *istart, long *iend)
{
    int q, r;
    q=n/nprocs;
    r=n%nprocs;
    if(rank < r){   
        *istart = rank*q + rank +1;
        *iend = *istart + q;
    }
    else{
        *istart = rank*q + r +1;
        *iend = *istart + q -1;
    }
}

int main(int argc, char *argv[])
{
    int rank, nprocs, provide, tid, nthreads;
    long i, max_val, istart, iend, total_sum=0, tmp_sum;
    long local_istart, local_iend, local_sum;
    MPI_Status status;
    MPI_Request req;
    MPI_Init_thread(&argc, &argv, MPI_THREAD_SINGLE, &provide); //MPI_THREAD_SINGLE
    MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    max_val = pow(10, ITER);
    get_start_end(max_val, rank, nprocs, &istart, &iend);
    
    //
    local_sum = 0;
#pragma omp parallel for reduction(+:local_sum)
    for(i=istart; i<=iend; i++){
        local_sum += i;
    } 
    MPI_Reduce(&local_sum, &total_sum, 1, MPI_LONG, MPI_SUM, 0, MPI_COMM_WORLD);

    if(rank==0){
        printf("sum = %ld\n", total_sum);
    } 
MPI_Finalize();           
} 
```

```
[sedu14@node8284 to1]$ mpicc -fopenmp single.c -o single.x -lm

[sedu14@node8284 to1]$ mpirun -np 4 --map-by:PE=8 -x OMP_NUM_THREADS=8 ./single.x
mpirun: Error: unknown option "--map-by:PE=8"
Type 'mpirun --help' for usage.

[sedu14@node8284 to1]$ time mpirun -np 4 --map-by NUMA:PE=8 -x OMP_NUM_THREADS=8 ./single.x
sum = 5000000050000000

real    0m1.125s
user    0m2.020s
sys     0m0.796s

```


### Funneled Mode With p2p


```c
local_sum = 0;
#pragma omp parallel
{
    #pragma omp parallel for reduction(+:local_sum)
    for(i=istart; i<=iend; i++)
        local_sum += i;

    if(omp_get_thread_num()==0){
        MPI_Send(&local_sum, 1, MPI_LONG,0,10,MPI_COMM_WORLD);
    else

    }
    MPI_Reduce(&local_sum, &total_sum, 1, MPI_LONG, MPI_SUM, 0, MPI_COMM_WORLD);

    if(rank==0){
        printf("sum = %ld\n", total_sum);
    } 
MPI_Finalize();           
} 


```


### 다시

싱글 mpi th가 통신을하는게 쉽다. 저것만 뺴면 mpi

funneled

쓰레드에서 통신허용, 퍼넬드는 모든 쓰레드가 아니라 0번 


### 몬테카를로 pi

#### 순차
* http://www.dartmouth.edu/~rc/classes/soft_dev/C_simple_ex.html

```c
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

int main()
{
   const long num_step=100000000;
   long i, cnt=0, seed;
   double pi,x,y;

   for(i=0; i<=num_step;i++){
    seed = (125*seed + 5) %2796203;
    x=(double)seed/2796203.0;
    seed=(125*seed+5)%2796203;
    y=(double)seed/2796203.0;
    if(sqrt(x*x+y*y)<=1.0) cnt+=1;
   }
   pi=4.0*(double)(cnt)/(double)(num_step);
   printf("pi =%17.15lf(Error=%e)\n",pi,fabs(acos(-1.0)-pi));

}
```

```
[sedu14@node8284 to1]$ mpicc pi_s.c -o pi_s.x -lm

[sedu14@node8284 to1]$ time ./pi_s.x
pi =3.140501680000000(Error=1.090974e-03)

real    0m18.873s
user    0m18.647s
sys     0m0.028s

```
#### 병렬

```c
#include <stdio.h>
#include <math.h>
#include <mpi.h>
#include <omp.h>

int main()
{
    const long num_step=100000000;
    long i, cnt=0, seed, local_step, q, remainder;
    double total_pi=0.0, pi=0.0, x, y;
    int rank, nprocs;

    MPI_Init(NULL,NULL);
    MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    q = num_step/nprocs;
    remainder=num_step%nprocs;
    local_step=(rank<remainder)?(q+1):(q);
#pragma omp parallel private(x,y,seed)
{
    seed = rank+omp_get_thread_num()+123456789;
    #pragma omp for reduction(+:cnt)
    for(i=0; i<local_step;i++){
        seed = (125*seed + 5) %2796203;
        x=(double)seed/2796203.0;
        seed=(125*seed+5)%2796203;
        y=(double)seed/2796203.0;
        if(sqrt(x*x+y*y)<=1.0) cnt++;
    }
}
    pi=4.0*(double)(cnt)/(double)(local_step);
    MPI_Reduce(&pi,&total_pi,1,MPI_DOUBLE,MPI_SUM,0,MPI_COMM_WORLD);
    if(rank==0){
        total_pi/=nprocs;
        printf("pi =%17.15lf(Error=%e)\n",total_pi,fabs(acos(-1.0)-total_pi));
    }
    MPI_Finalize();
}
```


```
[sedu14@node8284 to1]$ mpicc -fopenmp pi_p.c -o pi_p.x -lm

[sedu14@node8284 to1]$ time mpirun -np 4 --map-by NUMA:PE=8 -x OMP_NUM_THREADS=8 ./pi_p.x
pi =3.141049240000000(Error=5.434136e-04)

real    0m1.664s
user    0m19.612s
sys     0m0.735s

```


### 내 응용

`00` 2개 추가
```
[sedu14@node8284 to1]$ mpicc -fopenmp pi_p.c -o pi_p2.x -lm                     [sedu14@node8284 to1]$ time mpirun -np 4 --map-by NUMA:PE=8 -x OMP_NUM_THREADS=8 ./pi_p2.x
pi =3.140937593600000(Error=6.550600e-04)

real    1m0.326s
user    31m10.161s
sys     0m0.826s
```

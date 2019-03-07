# 
## 왜 병렬 계산인가?

**OpenMP (Open Multi-Processing, 오픈MP)는 공유 메모리 다중 처리 프로그래밍 API**

**MPI (Message Passing Interface, 메시지 전달 인터페이스)는 분산 및 병렬 처리에서 정보의 교환에 대해 기술하는 표준**

* 나이트렌딩 4등분. 그래서 사실상 NUMA system.
* 공유메모리에서는 openMP 분산메모리, 클러스터는 MPI
* 공유메모리는 전역메모리공간 공유
* 분산메모리는 다른 공간의 메모리를 읽기 위해 불러오고 보내고 받고.
* MPI 각각의 프로세스가 각각의 지역변수를 갖는다.



### fortran으로 
`[sedu14@login03 test01]$ cat hello.f90`
```fortran
program hello_world
!$OMP PARALLEL
print *, 'hello World'
!$OMP END PARALLEL
end
```

실행결과

```
[sedu14@login03 test01]$ gfortran -fopenmp hello.f90 -o ./hello_f.x
[sedu14@login03 test01]$ ./hello_f.x
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
```

`print *, 'hello World'` 단 1번만 출력했지만 24번 출력됐다. 병렬 threads 기본설정이 24번이라 24번 threads가 모두 읽고 출력했기에 24번이 나오게 됐다.




### c 로


`[sedu14@login03 test01]$ cat hello.c`
```c
#include <stdio.h>
int main()
{
#pragma omp parallel
{
        printf("Hello World!\n");

}
}
```


실행 


```
[sedu14@login03 test01]$ gcc -fopenmp hello.c -o ./hello_c.x
[sedu14@login03 test01]$ ./hello_c.x
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
```

둘다 단 1번 실행했지만 24번씩 출력되는 것을 확인할 수 있다. 그건 아직 쓰레드를 지정하지 않았기 때문에, 이건 컴파일러 지시어로 작업할 수 있다.

```
[sedu14@login03 test01]$ export OMP_NUM_THREADS=8
[sedu14@login03 test01]$ ./hello_c.x
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!

[sedu14@login03 test01]$ ./hello_f.x
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
 hello World
```

`[sedu14@login03 test01]$ export OMP_NUM_THREADS=8`

환경변수 설정을 헀기 때문에 출력이 8개!


## 환경변수 추가


### fortran

```fortran
program hello_world

integer omp_get_thread_num
!$OMP PARALLEL
print *, 'hello World',omp_get_thread_num()
!$OMP END PARALLEL

end
```

결과

```
[sedu14@login03 test01]$ gfortran -fopenmp hello.f90 -o ./hello_f.x
[sedu14@login03 test01]$ ./hello_f.x
 hello World           0
 hello World           3
 hello World           1
 hello World           5
 hello World           6
 hello World           4
 hello World           7
 hello World           2


```



### c

```c
#include <stdio.h>
#include <omp.h>

int main()
{
#pragma omp parallel
{
        printf("Hello World!, Thread ID:%d\n",omp_get_thread_num());

}
}
```

결과

```
[sedu14@login03 test01]$ ./hello_c.x
Hello World!, Thread ID:1
Hello World!, Thread ID:0
Hello World!, Thread ID:5
Hello World!, Thread ID:3
Hello World!, Thread ID:6
Hello World!, Thread ID:4
Hello World!, Thread ID:7
Hello World!, Thread ID:2

```


포트란에서는 

* integer omp_get_thread_num
* include 'omp_lib.h'
* use omp_lib

이렇게 추가하면 된다. 모두 같은 문법. 하지만 마지막 `use omp_lib` 이게 최신 문법


##

`[sedu14@login03 test01]$ export OMP_NUM_THREADS=4`
코드 안에 실제 쓰레드의 개수가 지정되어 있지 않기 때문에 외부환경변수에서 지정된 값을 불러와서 출력하게 되는 것.


#


##

```fortran
program hello_world
    integer omp_get_thread_num

!$omp parallel
    print *, 'Hello World', omp_get_thread_num()
!$omp end parallel
    print *, '' 
    call omp_set_num_threads(4)
!$omp parallel
    print *, 'Hello World', omp_get_thread_num()
!$omp end parallel
    print *, ''
!$omp parallel num_threads(2)
    print *, 'Hello World', omp_get_thread_num()
!$omp end parallel
end

```


```
[sedu14@login03 fortran]$ export OMP_NUM_THREADS=8
[sedu14@login03 fortran]$ gfortran -fopenmp 03_create_thread.f90 -o ./03_create_thread.x
[sedu14@login03 fortran]$ ./03_create_thread.x
 Hello World           0
 Hello World           4
 Hello World           7
 Hello World           5
 Hello World           1
 Hello World           3
 Hello World           6
 Hello World           2

 Hello World           2
 Hello World           3
 Hello World           0
 Hello World           1

 Hello World           1
 Hello World           0

```



로그인 노드가 4개있고 또 계산노드 중에 디버그노드 에서 해야한다.


##

`04_create_thread_exercise.f90`

```fortran
program hello_world
    integer omp_get_thread_num, omp_get_num_threads

    print *, 'threads = ', omp_get_num_threads()

!$omp parallel num_threads(3)
    print *, 'tid = ', omp_get_thread_num(), ' threads = ', omp_get_num_threads()
!$omp end parallel

    print *, 'threads = ', omp_get_num_threads()

!$omp parallel
    print *, 'tid = ', omp_get_thread_num(), ' threads = ', omp_get_num_threads()
!$omp end parallel

    print *, 'threads = ', omp_get_num_threads()
end
```


```
[sedu14@login03 fortran]$ gfortran -fopenmp 05_create_thread_solution.f90 -o 05_create_thread_solution_f.x
[sedu14@login03 fortran]$ ./05_create_thread_solution_f.x
 threads =            1
 tid =            0  threads =            3
 tid =            1  threads =            3
 tid =            2  threads =            3
 threads =            1
 tid =            2  threads =            8
 tid =            5  threads =            8
 tid =            7  threads =            8
 tid =            6  threads =            8
 tid =            0  threads =            8
 tid =            1  threads =            8
 tid =            4  threads =            8
 tid =            3  threads =            8
 threads =            1
```




```
[sedu14@login03 ~]$ qsub -I -V -l select=1:ncpus=8:ompthreads=8 -l walltime=04:00:00 -q debug
qsub: ERROR: You can't submit job in home01 directory, please try in scratch directory
[sedu14@login03 ~]$ cds
[sedu14@login03 sedu14]$ pwd
/scratch/sedu14
[sedu14@login03 sedu14]$ qsub -I -V -l select=1:ncpus=8:ompthreads=8 -l walltime=04:00:00 -q debug
qsub: waiting for job 1964138.pbs to start
qsub: job 1964138.pbs ready

[sedu14@node8287 ~]$
```

47p 06_
```fortran
program hello_wrong
    integer tid, omp_get_thread_num

    call omp_set_num_threads(4)
!$omp parallel private(tid)
    tid = omp_get_thread_num()
    print *, 'I am ', omp_get_thread_num(), ' tid = ', tid
!$omp end parallel
end
```

```
[sedu14@node8287 fortran]$ gfortran -fopenmp 06_data_scope_wrong.f90 -o ./06_data_scope_wrong.x
[sedu14@node8287 fortran]$ ./06_data_scope_wrong.x
      140737488343748
 I am            0  tid =            0
      140737488343748
 I am            3  tid =            3
      140737488343748
 I am            2  tid =            2
      140737488343748
 I am            1  tid =            1

```









이때는 메모리 주소가 다 다르다.

i값 j값 메모리 공간이 다르다는 의미

디폴트는 쉐어드의 속성을 가진다.

오픈mp 쓰는 이유 메모리의 이득을 위해.



06
```fortran
program hello_wrong
    integer tid, omp_get_thread_num

    call omp_set_num_threads(4)
!$omp parallel
print*, loc(tid)
    tid = omp_get_thread_num()
    print *, 'I am ', omp_get_thread_num(), ' tid = ', tid
!$omp end parallel
end
```

07
```fortran

program hello_wrong
    integer tid, omp_get_thread_num

    call omp_set_num_threads(4)
!$omp parallel private(tid)
    tid = omp_get_thread_num()
    print *, 'I am ', omp_get_thread_num(), ' tid = ', tid
!$omp end parallel
end

```


```c
#include <stdio.h>
#include <omp.h>

int main()
{
	int tid;
	printf("%x\n", &tid);
	omp_set_num_threads(4);
#pragma omp parallel private(tid)
{
	printf("%x\n",&tid);
	tid = omp_get_thread_num();
	printf("I am %d tid = %d\n", omp_get_thread_num(), tid);
} // end #pragma omp parallel
}

```



```c
#include <stdio.h>

int main()
{
	int i=1, j=2;
	
	#pragma omp parallel default(none) shared(i) private(j)
	{
		
		printf("%x, %x\n", &i, &j);


	}

}
```





### 12
```
[sedu14@node8287 fortran]$ cat ./12_data_scope_solution.f90
program data_scope_solution
    integer :: a(0:11), i=10, tid, omp_get_thread_num

    call omp_set_num_threads(4)
!$omp parallel shared(a) private(tid) firstprivate(i)
    tid = omp_get_thread_num()
    i = i + tid
    a(tid+0) = i + 0
    a(tid+4) = i + 4
    a(tid+8) = i + 8
!$omp end parallel

!! or

!$omp parallel shared(a) private(tid) firstprivate(i)
    tid = omp_get_thread_num() * 3
    i = i + tid
    a(tid+0) = i + 0
    a(tid+1) = i + 1
    a(tid+2) = i + 2
!$omp end parallel

    do i=0, 11
        print *, 'a(', i, ') = ', a(i)
    end do
end

[sedu14@node8287 fortran]$ export OMP_NUM_THREADS=8
[sedu14@node8287 fortran]$ ./12_data_scope_solution.x
 a(           0 ) =           10
 a(           1 ) =           11
 a(           2 ) =           12
 a(           3 ) =           13
 a(           4 ) =           14
 a(           5 ) =           15
 a(           6 ) =           16
 a(           7 ) =           17
 a(           8 ) =           18
 a(           9 ) =           19
 a(          10 ) =           20
 a(          11 ) =           21
```


### 13


[sedu14@node8287 fortran]$ ./13_serial_loop.x
 Hello World           0           0
 Hello World           0           1
 Hello World           0           2
 Hello World           0           3
 Hello World           0           4
 Hello World           0           5
 Hello World           0           6
 Hello World           0           7
 Hello World           0           8
 Hello World           0           9
 Hello World           0          10
 Hello World           0          11
 Hello World           0          12
 Hello World           0          13
 Hello World           0          14
 Hello World           0          15
 Hello World           0          16
 Hello World           0          17
 Hello World           0          18
 Hello World           0          19



### 14
```
[sedu14@node8287 fortran]$ ./14_parallel_loop.x
 Hello World           0           0
 Hello World           0           1
 Hello World           0           2
 Hello World           0           3
 Hello World           0           4
 Hello World           2          10
 Hello World           2          11
 Hello World           2          12
 Hello World           2          13
 Hello World           2          14
 Hello World           3          15
 Hello World           3          16
 Hello World           3          17
 Hello World           3          18
 Hello World           3          19
 Hello World           1           5
 Hello World           1           6
 Hello World           1           7
 Hello World           1           8
 Hello World           1           9
[sedu14@node8287 fortran]$
```



### 15


```

[sedu14@node8287 fortran]$ ./15_parallel_for.x
 Hello World           1           5
 Hello World           1           6
 Hello World           1           7
 Hello World           1           8
 Hello World           1           9
 Hello World           3          15
 Hello World           3          16
 Hello World           3          17
 Hello World           3          18
 Hello World           3          19
 Hello World           0           0
 Hello World           0           1
 Hello World           0           2
 Hello World           0           3
 Hello World           0           4
 Hello World           2          10
 Hello World           2          11
 Hello World           2          12
 Hello World           2          13
 Hello World           2          14

```



### 16


```
[sedu14@node8287 fortran]$ ./16_serial_dot_product.x
 sum =       14002

```

### 17


```
[sedu14@node8287 fortran]$ gfortran -fopenmp 17_parallel_dot_product.f90 -o 17_parallel_dot_product.x
[sedu14@node8287 fortran]$ ./17_parallel_dot_product.x
 sum =        3080

```


### 18


```
[sedu14@node8287 fortran]$ ./18_wrong_dot_product.x
 sum =        1830
[sedu14@node8287 fortran]$ ./18_wrong_dot_product.x
 sum =        3080
[sedu14@node8287 fortran]$ ./18_wrong_dot_product.x
 sum =        2820
[sedu14@node8287 fortran]$ ./18_wrong_dot_product.x
 sum =        3080
[sedu14@node8287 fortran]$ ./18_wrong_dot_product.x
 sum =        3080

```


### 19


```
[sedu14@node8287 fortran]$ ./19_sync_critical.x
 sum =        3080
[sedu14@node8287 fortran]$ ./19_sync_critical.x
 sum =        3080
[sedu14@node8287 fortran]$ ./19_sync_critical.x
 sum =        3080
[sedu14@node8287 fortran]$ ./19_sync_critical.x
 sum =        3080
[sedu14@node8287 fortran]$ ./19_sync_critical.x
 sum =        3080
[sedu14@node8287 fortran]$ ./19_sync_critical.x
 sum =        3080

```

### 21


```
[sedu14@node8287 fortran]$ ./21_no_barrier.x
 x =           4
 x =           4
 x =           4
 x =           4
[sedu14@node8287 fortran]$ ./21_no_barrier.x
 x =           3
 x =           3
 x =           3
 x =           3
[sedu14@node8287 fortran]$ ./21_no_barrier.x
 x =           5
 x =           5
 x =           5
 x =           5

```


### 22


```
[sedu14@node8287 fortran]$ gfortran -fopenmp 22_barrier.f90 -o 22_barrier.x
[sedu14@node8287 fortran]$ ./22_barrier.x
 x =           5
 x =           5
 x =           5
 x =           5

```







### 29

```
[sedu14@node8287 fortran]$ ./29_fork_join.x
 a(           1 ) =            1  in            1 -th thread
         100
 a(           2 ) =            2  in            2 -th thread
         100
 a(           0 ) =            0  in            0 -th thread
         100
 a(           3 ) =            3  in            3 -th thread
         100

Program received signal SIGSEGV: Segmentation fault - invalid memory reference.

Backtrace for this error:
#0  0x2aaaabc7624f in ???
#1  0x400980 in ???
Segmentation fault

```


### 30


```
[sedu14@node8287 fortran]$ ./30_skip_for.x
 Hello World           0           0
 Hello World           0           1
 Hello World           0           2
 Hello World           0           3
 Hello World           0           4
 Hello World           0           5
 Hello World           0           6
 Hello World           0           7
 Hello World           0           8
 Hello World           0           9
 Hello World           0          10
 Hello World           0          11
 Hello World           0          12
 Hello World           0          13
 Hello World           0          14
 Hello World           0          15
 Hello World           0          16
 Hello World           0          17
 Hello World           0          18
 Hello World           0          19
 Hello World           1           0
 Hello World           1           1
 Hello World           1           2
 Hello World           1           3
 Hello World           1           4
 Hello World           1           5
 Hello World           1           6
 Hello World           1           7
 Hello World           1           8
 Hello World           1           9
 Hello World           1          10
 Hello World           1          11
 Hello World           1          12
 Hello World           1          13
 Hello World           1          14
 Hello World           1          15
 Hello World           1          16
 Hello World           1          17
 Hello World           1          18
 Hello World           1          19
 Hello World           3           0
 Hello World           3           1
 Hello World           3           2
 Hello World           3           3
 Hello World           3           4
 Hello World           3           5
 Hello World           3           6
 Hello World           3           7
 Hello World           3           8
 Hello World           3           9
 Hello World           3          10
 Hello World           3          11
 Hello World           3          12
 Hello World           3          13
 Hello World           3          14
 Hello World           3          15
 Hello World           3          16
 Hello World           3          17
 Hello World           3          18
 Hello World           3          19
 Hello World           2           0
 Hello World           2           1
 Hello World           2           2
 Hello World           2           3
 Hello World           2           4
 Hello World           2           5
 Hello World           2           6
 Hello World           2           7
 Hello World           2           8
 Hello World           2           9
 Hello World           2          10
 Hello World           2          11
 Hello World           2          12
 Hello World           2          13
 Hello World           2          14
 Hello World           2          15
 Hello World           2          16
 Hello World           2          17
 Hello World           2          18
 Hello World           2          19

```




### 31


```
[sedu14@node8287 fortran]$ ./31_nested_parallel_for.x
 Hello World           0           0
 Hello World           0           1
 Hello World           0           2
 Hello World           0           3
 Hello World           0           4
 Hello World           0           5
 Hello World           0           6
 Hello World           0           7
 Hello World           0           8
 Hello World           0           9
 Hello World           0          10
 Hello World           0          11
 Hello World           0          12
 Hello World           0          13
 Hello World           0          14
 Hello World           0          15
 Hello World           0          16
 Hello World           0          17
 Hello World           0          18
 Hello World           0          19
 Hello World           2           0
 Hello World           2           1
 Hello World           2           2
 Hello World           2           3
 Hello World           2           4
 Hello World           2           5
 Hello World           2           6
 Hello World           2           7
 Hello World           2           8
 Hello World           2           9
 Hello World           2          10
 Hello World           2          11
 Hello World           2          12
 Hello World           2          13
 Hello World           2          14
 Hello World           2          15
 Hello World           2          16
 Hello World           2          17
 Hello World           2          18
 Hello World           2          19
 Hello World           3           0
 Hello World           3           1
 Hello World           3           2
 Hello World           3           3
 Hello World           3           4
 Hello World           3           5
 Hello World           3           6
 Hello World           3           7
 Hello World           3           8
 Hello World           3           9
 Hello World           3          10
 Hello World           3          11
 Hello World           3          12
 Hello World           3          13
 Hello World           3          14
 Hello World           3          15
 Hello World           3          16
 Hello World           3          17
 Hello World           3          18
 Hello World           3          19
 Hello World           1           0
 Hello World           1           1
 Hello World           1           2
 Hello World           1           3
 Hello World           1           4
 Hello World           1           5
 Hello World           1           6
 Hello World           1           7
 Hello World           1           8
 Hello World           1           9
 Hello World           1          10
 Hello World           1          11
 Hello World           1          12
 Hello World           1          13
 Hello World           1          14
 Hello World           1          15
 Hello World           1          16
 Hello World           1          17
 Hello World           1          18
 Hello World           1          19

```





## 

```
[sedu14@node8289 c]$ cat 01_hello.c
#include <stdio.h>

int main()
{
#pragma omp parallel
{
        printf("Hello World\n");
} // end #pragma omp parallel
}
[sedu14@node8289 c]$ cat 03_data_scope_review.c
#include <stdio.h>
#include <omp.h>

int main()
{
        int tid, i=10;

        omp_set_num_threads(4);
#pragma omp parallel private(tid) firstprivate(i)
{
        tid = omp_get_thread_num();
        printf("Hello World %d i = %d\n", tid, i);
} // end #pragma omp parallel
}
[sedu14@node8289 c]$ gcc -fopenmp 03_data_scope_review.c -o 03_data_scope_review.x
[sedu14@node8289 c]$ ./03_data_scope_review.x
Hello World 0 i = 10
Hello World 2 i = 10
Hello World 1 i = 10
Hello World 3 i = 10

[sedu14@node8289 c]$ cat 04_sync_atomic_review.c
#include <stdio.h>
#include <omp.h>
#define N 2000000

int main()
{
        long i, sum=0;
        int a[N], b[N];

        for(i=0; i<N; i++) {
                a[i] = i+1;
                b[i] = i+2;
        }

        omp_set_num_threads(4);
#pragma omp parallel
{
        #pragma omp for
        for(i=0; i<N; i++)
                #pragma omp atomic
                sum += a[i] * b[i];
}

        printf("sum = %ld\n", sum);
}
[sedu14@node8289 c]$ gcc -fopenmp 04_sync_atomic_review.c -o 04_sync_atomic_review.x
[sedu14@node8289 c]$ ./04_sync_atomic_review.x
sum = 17157248467712

[sedu14@node8289 c]$ cat 06_nested_parallel.c
#include <stdio.h>
#include <omp.h>

int main()
{
        int tid;

        omp_set_nested(1);
        omp_set_num_threads(2);
#pragma omp parallel private(tid)
{
        tid = omp_get_thread_num();
        printf("thread id = %d\n", tid );
        if( tid == 1) {
                #pragma omp parallel private(tid)
                {
                        tid = omp_get_thread_num();
                        printf("\t thread id = %d\n", tid );
                }
        }
} // end #pragma omp parallel
}
[sedu14@node8289 c]$ gcc -fopenmp 06_nested_parallel.c -o 06_nested_parallel.x
[sedu14@node8289 c]$ ./06_nested_parallel.x
thread id = 1
thread id = 0
         thread id = 0
         thread id = 1
[sedu14@node8289 c]$ ./06_nested_parallel.x
thread id = 0
thread id = 1
         thread id = 0
         thread id = 1
[sedu14@node8289 c]$ cat 07_more_nested_parallel.c
#include <stdio.h>
#include <omp.h>

int main()
{
        int tid, level;

        omp_set_nested(1);
        omp_set_num_threads(4);
#pragma omp parallel private(tid, level)
{
        tid = omp_get_thread_num();
        level = omp_get_level();
        printf("tid = %d level = %d\n", tid, level);
        if( tid == 1) {
                #pragma omp parallel private(tid) num_threads(tid+2)
                {
                        tid = omp_get_thread_num();
                        printf("\ttid = %d ancestor_thread_num(%d)=%d\n", tid, level, omp_get_ancestor_thread_num(level) );
                }
        }
} // end #pragma omp parallel
}
[sedu14@node8289 c]$ !gcc
gcc -fopenmp 06_nested_parallel.c -o 06_nested_parallel.x
[sedu14@node8289 c]$ gcc -fopenmp 07_more_nested_parallel.c -o 07_more_nested_parallel.c
gcc: fatal error: input file ‘07_more_nested_parallel.c’ is the same as output file
compilation terminated.
[sedu14@node8289 c]$ gcc -fopenmp 07_more_nested_parallel.c -o 07_more_nested_parallel.x
[sedu14@node8289 c]$ ./07_more_nested_parallel.x
tid = 0 level = 1
tid = 3 level = 1
tid = 2 level = 1
tid = 1 level = 1
        tid = 0 ancestor_thread_num(1)=1
        tid = 1 ancestor_thread_num(1)=1
        tid = 2 ancestor_thread_num(1)=1
[sedu14@node8289 c]$ cat 08_nested_data_scope.c
#include <stdio.h>
#include <omp.h>

int main()
{
        int x=1, y=10, z=20, tid;

        omp_set_nested(1);
        omp_set_num_threads(4);
#pragma omp parallel private(y, tid)
{
        tid = omp_get_thread_num();
        x++;
        y = 12;
        z = 22;
        #pragma omp parallel num_threads(2) private(x,tid)
        {
                tid = omp_get_thread_num();
                x = 10;
                y++;
                z++;
                printf("\t tid=%d x=%d y=%d z=%d\n", tid, x, y, z);
        }
        printf("tid=%d x=%d y=%d z=%d\n", tid, x, y, z);
} // end #pragma omp parallel

        printf("x=%d y=%d z=%d\n", x, y, z);
}
[sedu14@node8289 c]$ gcc -fopenmp 08_nested_data_scope.c -o 08_nested_data_scope.x
[sedu14@node8289 c]$ ./08_nested_data_scope.x
         tid=0 x=10 y=13 z=25
         tid=1 x=10 y=14 z=26
         tid=1 x=10 y=14 z=28
         tid=0 x=10 y=13 z=27
tid=0 x=5 y=14 z=30
         tid=0 x=10 y=13 z=23
         tid=1 x=10 y=14 z=30
         tid=1 x=10 y=14 z=24
tid=2 x=5 y=14 z=30
         tid=0 x=10 y=13 z=29
tid=1 x=5 y=14 z=30
tid=3 x=5 y=14 z=30
x=5 y=10 z=30
[sedu14@node8289 c]$ cat 09_sections.c
#include <stdio.h>
#include <omp.h>

int main()
{
        int i, a[10], b[20];

        omp_set_num_threads(2);
#pragma omp parallel private(i)
{
        #pragma omp sections
        {
                #pragma omp section
                for(i=0; i<10; i++)
                        a[i] = i*10+5;
                #pragma omp section
                for(i=0; i<20; i++)
                        b[i] = i*5+10;
        }
} // pragma omp parallel private(i)

        for(i=0; i<10; i++)
                printf("%d ", a[i]);
        printf("\n");
        for(i=0; i<20; i++)
                printf("%d ", b[i]);
        printf("\n");
}
[sedu14@node8289 c]$ cat 10_single.c
#include <stdio.h>
#include <omp.h>

int main()
{
        omp_set_num_threads(4);
#pragma omp parallel
{
        #pragma omp single
        {
                printf("hello world\n");
        }
} // pragma omp parallel
}
[sedu14@node8289 c]$ cat 11
cat: 11: No such file or directory
[sedu14@node8289 c]$ cat 11_master.c
#include <stdio.h>
#include <omp.h>

int main()
{
        omp_set_num_threads(4);
#pragma omp parallel
{
        #pragma omp master
        {
                sleep(1);
                printf("hello world\n");
        }
        printf("tid = %d\n", omp_get_thread_num());
} // pragma omp parallel
}
[sedu14@node8289 c]$ cat 12_nowait.c
#include <stdio.h>
#include <omp.h>

int main()
{
        int x = 1;

        omp_set_num_threads(16);
#pragma omp parallel
{
        #pragma omp single nowait
        {
                x++;
                printf("x = %d\n", x);
        }
        #pragma omp single
        {
                x++;
                printf("x = %d\n", x);
        }
} // pragma omp parallel
}
[sedu14@node8289 c]$ ls
01_hello.c                 13_for_nowait.c           30_flush1.c
02_create_thread_review.c  14_simple_test1.c         31_flush2.c
03_data_scope_review.c     15_simple_test2.c         32_false_sharing.c
03_data_scope_review.x     16_simple_test3.c         33_false_sharing_solved.c
04_sync_atomic_review.c    17_simple_test4.c         34_fibonacci1.c
04_sync_atomic_review.x    18_simple_test5.c         35_fibonacci2.c
05_reduction_review.c      19_ordered.c              36_fibonacci3.c
06_nested_parallel.c       20_lock.c                 37_matrix_multiplication.c
06_nested_parallel.x       21_task1.c                38_mat_mul.c
07_more_nested_parallel.c  22_task2.c                39_mat_mul_static.c
07_more_nested_parallel.x  23_task3.c                40_mat_mul_solution.c
08_nested_data_scope.c     24_task4.c                41_lu_decomp.c
08_nested_data_scope.x     25_task_data_scope.c      42_lu_decomp_problem.c
09_sections.c              26_mandelbrot_exercise.c  43_lu_decomp_for.c
10_single.c                27_mandelbrot_static.c    44_fibonacci_exercise.c
11_master.c                28_mandelbrot_dynamic.c   45_fibonacci_solution1.c
12_nowait.c                29_collapse.c             46_fibonacci_solution2.c
[sedu14@node8289 c]$ cat 11_master.c
#include <stdio.h>
#include <omp.h>

int main()
{
        omp_set_num_threads(4);
#pragma omp parallel
{
        #pragma omp master
        {
                sleep(1);
                printf("hello world\n");
        }
        printf("tid = %d\n", omp_get_thread_num());
} // pragma omp parallel
}
[sedu14@node8289 c]$ cat 10_single.c
#include <stdio.h>
#include <omp.h>

int main()
{
        omp_set_num_threads(4);
#pragma omp parallel
{
        #pragma omp single
        {
                printf("hello world\n");
        }
} // pragma omp parallel
}
[sedu14@node8289 c]$ gcc -fopenmp 09_sections.c -o 09_sections.x
[sedu14@node8289 c]$ gcc -fopenmp 10_single.c -o 10_single.x
[sedu14@node8289 c]$ ./09_sections.x
5 15 25 35 45 55 65 75 85 95
10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 105
[sedu14@node8289 c]$ ./10_single.x
hello world
[sedu14@node8289 c]$ ./10_single.x
hello world
[sedu14@node8289 c]$ gcc -fopenmp 11_master.c -o 11_master.x
11_master.c: In function ‘main’:
11_master.c:11:3: warning: implicit declaration of function ‘sleep’ [-Wimplicit-function-declaration]
   sleep(1);
   ^~~~~
[sedu14@node8289 c]$ ./11_master.x
tid = 3
tid = 1
tid = 2
hello world
tid = 0
[sedu14@node8289 c]$ gcc -fopenmp 12_nowait.c
[sedu14@node8289 c]$ ./a.out
x = 2
x = 3
[sedu14@node8289 c]$ gcc -fopenmp 12_nowait.c -o 12_nowait.x
[sedu14@node8289 c]$ ./12_nowait.x
x = 2
x = 3
[sedu14@node8289 c]$ ./12_nowait.x
x = 3
x = 2
[sedu14@node8289 c]$ ./12_nowait.x
x = 2
x = 3
[sedu14@node8289 c]$ ./12_nowait.x
x = 3
x = 2
[sedu14@node8289 c]$ ./12_nowait.x
x = 2
x = 3
[sedu14@node8289 c]$ gcc -fopenmp 13_for_nowait.c -o 13_for_nowait.x
[sedu14@node8289 c]$ ./13_for_nowait.x
[sedu14@node8289 c]$ gcc -fopenmp 14_simple_test1.c -o 14_simple_test1.x
14_simple_test1.c: In function ‘main’:
14_simple_test1.c:13:3: warning: implicit declaration of function ‘sleep’ [-Wimplicit-function-declaration]
   sleep(5);
   ^~~~~
[sedu14@node8289 c]$ ./14_simple_test1.x
a[10]=10 tid=2
a[11]=11 tid=2
a[12]=12 tid=2
a[13]=13 tid=2
a[14]=14 tid=2
a[0]=0 tid=0
a[1]=1 tid=0
a[2]=2 tid=0
a[3]=3 tid=0
a[4]=4 tid=0
a[15]=15 tid=3
a[16]=16 tid=3
a[17]=17 tid=3
a[18]=18 tid=3
a[19]=19 tid=3
a[5]=5 tid=1
a[6]=6 tid=1
a[7]=7 tid=1
a[8]=8 tid=1
a[9]=9 tid=1
end 3 thread
end 0 thread
end 1 thread
end 2 thread
[sedu14@node8289 c]$ ^C
[sedu14@node8289 c]$

```

`[sedu14@node8289 c]$ vi 13_for_nowait.c`
```c
#include <stdio.h>
#define N 10000

int main()
{
        int i, j, a[N][N];

#pragma omp parallel private(i,j)
{
        #pragma omp for nowait
        for(i=0; i<N; i++)
                for(j=i; j<N; j++)
                        a[i][j] = i+j;

        #pragma omp for
        for(i=0; i<N; i++)
                for(j=0; j<i; j++)
                        a[i][j] = i-j;
} // pragma omp parallel
}

```



```
[sedu14@node8289 c]$ ./15_simple_test2.x
a[10]=10 tid=2
a[11]=11 tid=2
a[12]=12 tid=2
a[13]=13 tid=2
a[14]=14 tid=2
end 2 thread
a[5]=5 tid=1
a[6]=6 tid=1
a[7]=7 tid=1
a[8]=8 tid=1
a[9]=9 tid=1
end 1 thread
a[0]=0 tid=0
a[1]=1 tid=0
a[2]=2 tid=0
a[3]=3 tid=0
a[4]=4 tid=0
end 0 thread
a[15]=15 tid=3
a[16]=16 tid=3
a[17]=17 tid=3
a[18]=18 tid=3
a[19]=19 tid=3
end 3 thread
[sedu14@node8289 c]$ ./16_simple_test3.x
L1 tid=2
L1 tid=2
L1 tid=2
L1 tid=2
L2 tid=2
L2 tid=2
L2 tid=2
L2 tid=2
^[[[sedu14@node8289 c]$
[sedu14@node8289 c]$
[sedu14@node8289 c]$ ./16_simple_test3.x
L1 tid=2
L1 tid=2
L1 tid=2
L1 tid=2
L2 tid=2
L2 tid=2
L2 tid=2
L2 tid=2
[sedu14@node8289 c]$ ./17_simple_test4.x
L2 tid=0
L2 tid=0
L2 tid=0
L2 tid=0
L1 tid=1
L1 tid=1
L1 tid=1
L1 tid=1
end tid=0
end tid=2
end tid=1
end tid=3
[sedu14@node8289 c]$ /18
-bash: /18: No such file or directory
[sedu14@node8289 c]$ ./18_simple_test5.x
L2 tid=1
L2 tid=1
L2 tid=1
L2 tid=1
L1 tid=0
L1 tid=0
L1 tid=0
L1 tid=0
end tid=0
end tid=2
end tid=3
end tid=1
[sedu14@node8289 c]$ ./19_ordered.x
a[0] = 0
a[1] = 2
a[2] = 4
a[3] = 6
a[4] = 8
a[5] = 10
a[6] = 12
a[7] = 14
a[8] = 16
a[9] = 18
[sedu14@node8289 c]$ ./20_lock.x
x = 2
x = 3
x = 4
x = 5
[sedu14@node8289 c]$ time ./28_mandelbrot_dynamic.x

real    0m6.407s
user    0m50.253s
sys     0m0.042s
[sedu14@node8289 c]$ time ./27_mandelbrot_static.x

real    0m19.075s
user    0m47.963s
sys     0m0.017s
[sedu14@node8289 c]$ time ./26_mandelbrot_exercise.x

real    0m47.931s
user    0m47.911s
sys     0m0.020s


```

* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* https://docs.python.org/2/library/multiprocessing.html#examples
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 


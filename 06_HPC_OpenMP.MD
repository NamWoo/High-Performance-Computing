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

실행

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


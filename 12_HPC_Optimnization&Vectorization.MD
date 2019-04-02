
* 일정 : 2019/04/01 - 2019/04/04 (4일 중 2일차)
* 장소 : 한국과학기술정보연구원(대전 카이스트)


# 최적화와 벡터화
## 인트로
코딩을 병렬코드 처리해서 속도가 10배 빨라졌다면, 그 전에 순차코드를 최적화 한뒤 진행하게 되면 속도가 20배 빨라질 것이다.

설계단계부터, 알고리즘단계, 데이터구조, 부터 최적화.

AoS, SoA 구조체의 배열, 배열의 구조체, 어레이오브구조체, 

예전에는 그냥 바이너리로 바꿔주는 정도였는데 요즘엔 최적회 레벨을 지정해서 컴파일 하면 알아서 최적화를 해준다.

종속/독립 최적화 
플렛폼 종속, 
플랫폼 독립
루프

## 먼저 작성한 코드가 있다고 할 때, 코드분석, 코드성능테스트
분석방법
* 병목지점 찾기
* 케시히트 케시에 내가 원하는 데이터가 있을때
* 케시미스 메모리에 가서 직접 가져와야할 때 케시올리고 cpu가 활용. 메모리에 가져오는게 시간 오래 걸림


## 실습


wallclock 체킹


```fortran
program name
implicit none
integer, parameter::n=10000
integer::i,j
integer(kind=8)::stime, etime, c_rate
real::stime1, etime1
call system_clock(stime,c_rate)
call sleep(1)
call system_clock(etime)
print*, 'system_clock:',(etime-stime)/dble(c_rate)

call cpu_time(stime1)
call sleep(1)
call cpu_time(etime1)
print*, 'cpu_time:',(etime1-stime1)
end program name

```


```
[sedu27@login01 Exercise]$ gfortran wc.f90 -o wc.x
[sedu27@login01 Exercise]$ ./wc.x
 system_clock:   1.0000812250000000
 cpu_time:   3.90000641E-05

[sedu27@login01 Exercise]$ time ./wc.x
 system_clock:   1.0000858580000000
 cpu_time:   3.50009650E-05

real    0m2.027s
user    0m0.015s
sys     0m0.011s

```






```c

#include <stdio.h>
#include <unistd.h>
#include <time.h>
double WallTime()
{
    struct timespec tp;
    clock_gettime(CLOCK_REALTIME, &tp);
    return ((double)tp.tv_sec + (double)tp.tv_nsec * 1.e-9);
}

int main(void){
    int i, j;
    clock_t start, end;
    double stime, etime;
    double cpu_time, wallclock;
    stime=WallTime();
    sleep(1);
    etime=WallTime();
    wallclock=etime-stime;
    printf("Wallclock time : %f\n", wallclock);

    start=clock();
    sleep(1);
    end=clock();
    cpu_time=((double)(end-start))/CLOCKS_PER_SEC;
    printf("cpu time : %f\n", cpu_time);
    return 0;

}
```


```
[sedu27@login01 Exercise]$ gcc wc_c.c -o wc_c.x
[sedu27@login01 Exercise]$ ./wc_c.x
Wallclock time : 1.000077
cpu time : 0.000000
[sedu27@login01 Exercise]$ time ./wc_c.x
Wallclock time : 1.000085
cpu time : 0.000000

real    0m2.027s
user    0m0.012s
sys     0m0.013s
[sedu27@login01 Exercise]$

```



## 오후

```
[sedu27@node8283 C]$ scp 150.183.150.13:/tmp/Solution.tgz
usage: scp [-12346BCpqrv] [-c cipher] [-F ssh_config] [-i identity_file]
           [-l limit] [-o ssh_option] [-P port] [-S program]
           [[user@]host1:]file1 ... [[user@]host2:]file2
```




```python
import numpy as np
N = 100


a = np.random.normal(size=(2,2))
b = np.random.normal(size=(2,2))
c = np.random.normal(size=(2,2))

for i in range(N):
    for j in range(N):
        for k in range(N):
            c[i][j] = c[i][j] + a[i][k] * b[k][j]


print(c[1][1])




```


```
[sedu27@node8283 Exercise]$ python t01.py
Traceback (most recent call last):
  File "t01.py", line 12, in <module>
    c[i][j] = c[i][j] + a[i][k] * b[k][j]
IndexError: index 2 is out of bounds for axis 0 with size 2

```

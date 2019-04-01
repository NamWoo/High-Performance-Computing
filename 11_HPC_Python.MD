* 일정 : 2019/04/01 - 2019/04/04 (4일 중 1일차)
* 장소 : 한국과학기술정보연구원(대전 카이스트)

# HPC에서의 Python
* 2019/04/01


오늘도 서울에서 새벽같이 일어나 출봘. 카이스트 정문에 핀 벚꽃들이 참... ㅎㅎ

전반적으로 오늘 수업은 파이썬 기초였다. 오늘껄 들을까 말까 해서 그래도 슈퍼컴퓨터에서의 파이썬은 어떻게 할까? 라는 의문, 그리고 작년 자료 강사님께 받아서 쭉 훑어봤는데 병렬처리에 대한 여러 예제가 있어서 딱 오늘 하루 중에 딱 그 부분이라도 듣기 위해 출발했지만 ... 오늘 수업은 괜히 들었나? 오늘 숙박비, 내 돈이 살짝 아깝기는 하지만... 그래도 여기서 얻은 파이썬 지식을 정리해보면..

* scipy 내장함수로 singnal processing 관련이 있었다는 것.
* 그래프를 말할때 UI가 3D로 제어가능해야만 3D plotting, 그게 아니고 그냥 3D 그림이 출력만 되어있는 것은 2D plotting.
* 전세계 13위 슈퍼컴퓨터 누리온 HPC를 사용하는 사람들의 코드 통계를 봤을 때 병렬코드 함수 사용은
    * pypar (대부분)
    * mp4py
    
mutiprocessing, threading 같은 라이브러리가 아니라 처음 들어보는 pypar를 쓴다니... 여쭤보니 강사님도 쉬워서 이걸 쓴다고 하신다. mp4py는 지나가다 몇번 보긴 했었는데.. 음.. 그렇군..

계속 실습했던 multiprocessing
* https://docs.python.org/2/library/multiprocessing.html#module-multiprocessing.pool

이제 새로 알아가야 할.. 이제 이걸로 다시 학습해야 할..
* https://code.google.com/archive/p/pypar/
* https://shocksolution.com/2010/04/17/managing-a-pool-of-mpi-processes-with-python-and-pypar/



리눋스 그래프 자동으로 해쥬는 기능. 


나이츠렌딩 1.4 코어, 상업용 판매하는거 3코어 이상 더 느릴 수 있다.

## 병렬
쓰레드, 프로세싱 크게는 두가지다

쓰레드 메모리자원따로 같지 않는다
메모리 여러쓰레드 공유

프로세스 메모리자원 따로따로 같는다

가장 큰 차이


프로세스 각각 메모리 따로따로 2컴퓨터 같은
더 많은 메모리, 대신 다른 노드에서도 돌릴 수 있다. 

따로 가지고 있는데 어떻게 작업 나누냐? 통신.
어렵다. 


오픈mp 컴파일러가 제공 오픈엠피 옵션 주고 중간중간 지시어 적어주면 자동 스레드 발동

파이썬 opnemp 안됨. 그래서 일반적인 스레딩 방식 슨다.

리눅스 피쓰레드, 오픈앰피 내부는 마찬가지 파이썬도 그거랑 같이 발생시킬 수 있는 모듈


mpi는 라이브러리 형태 함수. 그래서 파이썬에서도 mpi가 된다.

파이썬 openmp 안되기 때문에 굳이 해야하나? 계산과학? 피쓰래드? 

### 쓰레드 만드는 예제. 

클래스 정의해서 함수 안에 클래스에 종속된 함수 하나 만들어서, 단지 정의할때 알규먼트를 threading.Thread로.

* t = ThreadClass() 쓰레드가 발생되면서 함수가 생성, 
* t.start() 객체함수실행

이렇게 하면 다른 쓰레드가 각각 실행.


















## 수업시간 실습


### 선형대수 실습

```python 
import numpy as np
from scipy import linalg
A= np.array([[1,3,5],[2,5,1],[2,3,8]])

print(A)

print(linalg.inv(A))

print(A.dot(linalg.inv(A)))
```

```
[sedu07@node8282 tpy]$ python scnp.py
[[1 3 5]
 [2 5 1]
 [2 3 8]]
[[-1.48  0.36  0.88]
 [ 0.56  0.08 -0.36]
 [ 0.16 -0.12  0.04]]
[[ 1.00000000e+00 -1.11022302e-16 -5.55111512e-17]
 [ 3.05311332e-16  1.00000000e+00  1.87350135e-16]
 [ 2.22044605e-16 -1.11022302e-16  1.00000000e+00]]
```

### 실습2

```python

```

```

```










## 내가 따로 해본 실습







```python
import multiprocessing
from multiprocessing import Process

def f(id):
    return


if __name__ == '__main__':

    np = multiprocessing.cpu_count()
    print('you have {0:1d} CPUs'.format(np))

    p_list=[]

    for i in range(1, np+1):
        p = Process(target =f, name='Process'+str(i), args=(i,))
        p_list.append(p)
        print('Process:: ', p.name)
        p.start()
        print('Was assigned PID:: ', p.pid)

    for p in p_list:
        p.join()
~

```


```
[sedu07@node8281 tpy]$ python t06.py
you have 68 CPUs
Process::  Process1
Was assigned PID::  58392
Process::  Process2
Was assigned PID::  58393
Process::  Process3
Was assigned PID::  58394
Process::  Process4
Was assigned PID::  58395
Process::  Process5
Was assigned PID::  58396
Process::  Process6
Was assigned PID::  58397
Process::  Process7
Was assigned PID::  58398
Process::  Process8
Was assigned PID::  58399
Process::  Process9
Was assigned PID::  58400
Process::  Process10
Was assigned PID::  58401
Process::  Process11
Was assigned PID::  58402
Process::  Process12
Was assigned PID::  58403
Process::  Process13
Was assigned PID::  58404
Process::  Process14
Was assigned PID::  58405
Process::  Process15
Was assigned PID::  58406
Process::  Process16
Was assigned PID::  58407
Process::  Process17
Was assigned PID::  58408
Process::  Process18
Was assigned PID::  58409
Process::  Process19
Was assigned PID::  58410
Process::  Process20
Was assigned PID::  58411
Process::  Process21
Was assigned PID::  58412
Process::  Process22
Was assigned PID::  58413
Process::  Process23
Was assigned PID::  58414
Process::  Process24
Was assigned PID::  58415
Process::  Process25
Was assigned PID::  58416
Process::  Process26
Was assigned PID::  58417
Process::  Process27
Was assigned PID::  58418
Process::  Process28
Was assigned PID::  58419
Process::  Process29
Was assigned PID::  58420
Process::  Process30
Was assigned PID::  58421
Process::  Process31
Was assigned PID::  58422
Process::  Process32
Was assigned PID::  58423
Process::  Process33
Was assigned PID::  58424
Process::  Process34
Was assigned PID::  58425
Process::  Process35
Was assigned PID::  58426
Process::  Process36
Was assigned PID::  58427
Process::  Process37
Was assigned PID::  58428
Process::  Process38
Was assigned PID::  58429
Process::  Process39
Was assigned PID::  58430
Process::  Process40
Was assigned PID::  58431
Process::  Process41
Was assigned PID::  58432
Process::  Process42
Was assigned PID::  58433
Process::  Process43
Was assigned PID::  58434
Process::  Process44
Was assigned PID::  58435
Process::  Process45
Was assigned PID::  58436
Process::  Process46
Was assigned PID::  58437
Process::  Process47
Was assigned PID::  58438
Process::  Process48
Was assigned PID::  58439
Process::  Process49
Was assigned PID::  58440
Process::  Process50
Was assigned PID::  58441
Process::  Process51
Was assigned PID::  58442
Process::  Process52
Was assigned PID::  58443
Process::  Process53
Was assigned PID::  58444
Process::  Process54
Was assigned PID::  58445
Process::  Process55
Was assigned PID::  58446
Process::  Process56
Was assigned PID::  58447
Process::  Process57
Was assigned PID::  58448
Process::  Process58
Was assigned PID::  58449
Process::  Process59
Was assigned PID::  58450
Process::  Process60
Was assigned PID::  58451
Process::  Process61
Was assigned PID::  58452
Process::  Process62
Was assigned PID::  58453
Process::  Process63
Was assigned PID::  58454
Process::  Process64
Was assigned PID::  58455
Process::  Process65
Was assigned PID::  58456
Process::  Process66
Was assigned PID::  58457
Process::  Process67
Was assigned PID::  58458
Process::  Process68
Was assigned PID::  58459

```



##


```python
from multiprocessing import Pool, TimeoutError
import time
import os

def f(x):
    return x*x

if __name__ == '__main__':
    pool = Pool(processes=4)              # start 4 worker processes

    # print "[0, 1, 4,..., 81]"
    print pool.map(f, range(10))

    # print same numbers in arbitrary order
    for i in pool.imap_unordered(f, range(10)):
        print i

    # evaluate "f(20)" asynchronously
    res = pool.apply_async(f, (20,))      # runs in *only* one process
    print res.get(timeout=1)              # prints "400"

    # evaluate "os.getpid()" asynchronously
    res = pool.apply_async(os.getpid, ()) # runs in *only* one process
    print res.get(timeout=1)              # prints the PID of that process

    # launching multiple evaluations asynchronously *may* use more processes
    multiple_results = [pool.apply_async(os.getpid, ()) for i in range(4)]
    print [res.get(timeout=1) for res in multiple_results]

    # make a single worker sleep for 10 secs
    res = pool.apply_async(time.sleep, (10,))
    try:
        print res.get(timeout=1)
    except TimeoutError:
        print "We lacked patience and got a multiprocessing.TimeoutError"
```


```
[sedu07@node8281 tpy]$ python t07.py
[0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
0
4
1
16
9
25
36
64
49
81
400
68918
[68919, 68920, 68921, 68922]
We lacked patience and got a multiprocessing.TimeoutError

```



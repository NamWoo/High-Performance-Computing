* 일정 : 2019/04/01 - 2019/04/04 (4일 중 1일차)
* 장소 : 한국과학기술정보연구원(대전 카이스트)

# HPC에서의 Python
* 2019/04/01


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



* 일정 : 2019/03/05 - 2019/03/05 (하루)
* 장소 : 한국과학기술정보연구원(대전 카이스트)
* https://helpdesk.ksc.re.kr/
  * 관련 정보 확인

# Multiprocessing Training Course


```
[sedu10@login02 ~]$ module av

--------------------- /opt/cray/craype/default/modulefiles ------------------
craype-mic-knl     craype-network-opa craype-x86-skylake

---------------------------- /opt/cray/modulefiles --------------------------
cdt/17.10
cray-ccdb/3.0.3(default)
cray-cti/1.0.6(default)
cray-fftw/3.3.6.2(default)
cray-fftw_impi/3.3.6.2(default)
cray-impi/1.1.4(default)
cray-lgdb/3.0.7(default)
cray-libsci/17.09.1(default)
craype/2.5.13(default)
craypkg-gen/1.3.5
mvapich2_cce/2.2rc1.0.3_noslurm(default)
mvapich2_gnu/2.2rc1.0.3_noslurm
papi/5.5.1.3(default)
perftools/6.5.2(default)
perftools-base/6.5.2(default)
perftools-lite/6.5.2(default)
PrgEnv-cray/1.0.2(default)

--------------------- /apps/Modules/modulefiles/compilers -------------------
cce/8.6.3(default)    intel/17.0.5(default) intel/19.0.1
gcc/6.1.0             intel/18.0.1          pgi/18.10
gcc/7.2.0             intel/18.0.3

------------------------ /apps/Modules/modulefiles/mpi ----------------------
ime/mvapich-verbs/2.2.ddn1.4 impi/18.0.3
ime/openmpi/1.10.ddn1.0      impi/19.0.1
impi/17.0.5(default)         mvapich2/2.3
impi/18.0.1                  openmpi/3.1.0

---------------- /apps/Modules/modulefiles/libraries_using_mpi --------------
fftw_mpi/2.1.5             netcdf-hdf5-parallel/4.6.1
fftw_mpi/3.3.7             parallel-netcdf/1.10.0
hdf5-parallel/1.10.2       pio/2.3.1

--------------------- /apps/Modules/modulefiles/libraries -------------------
CDO/1.8.2    hdf5/1.10.2  ncl/6.5.0    ncview/2.1.7
hdf4/4.2.13  lapack/3.7.0 NCO/4.7.4    netcdf/4.6.1

--------------------- /apps/Modules/modulefiles/commercial ------------------
cfx/v145               fluent/v145            gaussian/g16.a03
cfx/v170               fluent/v170            gaussian/g16.a03.linda
cfx/v181               fluent/v181            lsdyna/mpp
cfx/v191               fluent/v191            lsdyna/smp

-------------------- /apps/Modules/modulefiles/applications -----------------
advisor/17.0.5       lammps/8Mar18        singularity/2.4.2
advisor/18.0.1       namd/2.12            singularity/2.5.1
advisor/18.0.3       PETSc/3.8.4          singularity/2.5.2
cmake/3.12.3         python/2.7.15        singularity/3.0.1
ferret/7.4.3         python/3.7           subversion/1.7.19
forge/18.1.2         qe/6.1               tensorflow/1.12.0
grads/2.2.0          qt/4.8.7             vtune/17.0.5
gromacs/2016.4       qt/5.9.6             vtune/18.0.1
gromacs/5.0.6        R/3.5.0              vtune/18.0.3
IGPROF/5.9.16        siesta/4.0.2
ImageMagick/7.0.8-20 siesta/4.1-b3

------------------------ /apps/Modules/modulefiles/test ---------------------
pgi/19.1

---------------------- /apps/Modules/modulefiles/crayadm --------------------
chklimit/1.0 htop/2.2.0

```

## OpenMP 컴파일 옵션

* intel: -qopenmp
* GNU: -fopenmp
* Cray: -h omp(default)


## 병렬처리

* wall-clock time 를 줄이기 위해 병렬프로세싱을! 
* 단일노드에서 못 풀던 것들을 해결하기 위한!
* GPU, CPU 자원을 최대한 활용해서 네트워크로 연결된 클라우드 컴퓨팅!
* GPU 클러스터 머신 켓을 활용한 교육이 있었는데 작년엔, 근데 올해는?
* 하이브리드2 프로그래밍에 할 것이다. OpenNCC, MPI 같이 하는 교육
* 무어의 법칙, 요즘엔 클럭 낮추고 코어 수 늘리는, 이제 더이상 클럭은 늘어나지 못한다. 물리적 한계.

## 프로세스와 쓰레드

* 프로세스는 실제 실행되고 있는 프로그램을 뜻한다.
* 코어가 10개면 프로세스10, 쓰레드10개 이렇게 사용한다.
* 문맥교환. 현재 프로세스 저장하고 다른 프로세서 올리고


```
[sedu10@login02 ~]$ top
top - 10:04:00 up 63 days, 16:37, 90 users,  load average: 0.22, 0.27, 0.25
Tasks: 872 total,   1 running, 812 sleeping,  59 stopped,   0 zombie
%Cpu(s):  0.2 us,  0.2 sy,  0.0 ni, 99.5 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0
KiB Mem : 39487516+total, 32082588+free, 16001284 used, 58048012 buff/cache
KiB Swap: 16777212 total, 16491668 free,   285544 used. 36076102+avail Mem

   PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
275636 root      20   0 1377860 163108   1796 S   2.6  0.0 218:39.87 spagen+
120195 root      20   0  120160   4592   1972 S   1.3  0.0   0:00.54 ScvTra+
120774 sedu10    20   0  175128   3428   1900 R   1.3  0.0   0:00.15 top
 66993 root      20   0 1559648 261012  23748 S   0.7  0.1 409:20.14 klnage+
111430 root      20   0  120160   4196   1972 S   0.7  0.0   0:00.17 ScvTra+
120770 sedu50    20   0  175136   3372   1900 S   0.7  0.0   0:00.17 top
120773 q487lsh   20   0  165856   5224   2700 S   0.7  0.0   0:00.09 vim
    10 root      20   0       0      0      0 S   0.3  0.0 131:18.95 rcu_sc+
  2195 root      20   0 2921044 2.455g  11208 S   0.3  0.7 151:03.78 sssd_n+
 42988 root      20   0 3101588 506944  66980 S   0.3  0.1  11:11.47 cmd
120183 root      20   0  168400   6764   4704 S   0.3  0.0   0:00.14 sshd
122425 root      20   0  273840  21276   3700 S   0.3  0.0  12:39.90 ScvAge+
296910 x1680a02  20   0  148600   6708   2412 S   0.3  0.0   0:00.69 bash
309633 root      20   0       0      0      0 S   0.3  0.0   0:08.03 kworke+
     1 root      20   0  192528   5696   2524 S   0.0  0.0  23:38.06 systemd
     2 root      20   0       0      0      0 S   0.0  0.0   2:06.68 kthrea+
     3 root      20   0       0      0      0 S   0.0  0.0   0:26.77 ksofti+
     8 root      rt   0       0      0      0 S   0.0  0.0  14:44.60 migrat+
     9 root      20   0       0      0      0 S   0.0  0.0   0:00.00 rcu_bh
    11 root      rt   0       0      0      0 S   0.0  0.0   0:11.67 watchd+
    12 root      rt   0       0      0      0 S   0.0  0.0   0:35.30 watchd+
    13 root      rt   0       0      0      0 S   0.0  0.0   2:57.80 migrat+
    14 root      20   0       0      0      0 S   0.0  0.0   2:37.34 ksofti+
    16 root       0 -20       0      0      0 S   0.0  0.0   0:00.00 kworke+
    17 root      rt   0       0      0      0 S   0.0  0.0   0:29.11 watchd+
    18 root      rt   0       0      0      0 S   0.0  0.0   2:02.88 migrat+
    19 root      20   0       0      0      0 S   0.0  0.0   1:34.26 ksofti+
    21 root       0 -20       0      0      0 S   0.0  0.0   0:00.00 kworke+
    22 root      rt   0       0      0      0 S   0.0  0.0   0:28.69 watchd+
    23 root      rt   0       0      0      0 S   0.0  0.0   1:32.73 migrat+
    24 root      20   0       0      0      0 S   0.0  0.0   1:24.18 ksofti+
    26 root       0 -20       0      0      0 S   0.0  0.0   0:00.00 kworke+
    27 root      rt   0       0      0      0 S   0.0  0.0   0:31.49 watchd+
    28 root      rt   0       0      0      0 S   0.0  0.0   1:29.87 migrat+
    29 root      20   0       0      0      0 S   0.0  0.0   1:16.37 ksofti+

```

* 쓰레드
* 프로세스에서 실행의 개념만 분리
* 파워포인트로 예를 들면 실행하면 파워포인트 열리고 문서파일 열리고, 또 파워포인트를 실행하면 파워포인트가 열리고 다른 문서파일 열리고, 이 때 파워포인트를 프로세서, 각각의 문서가 쓰레드.


* 하나의 쓰레드를 갖는 3개의 프로세스

## 병렬성 유형

* 데이터 병렬성
* 각각의 테스크 또는 openmp 코드를 각각 분할해서 하는, 행렬곱, 덧셈 등. 

* 테스크 병렬성
* 서로 다른 테스크를 하는, 하나는 날짜, 하나는 뭐 다른 거.. 등등

**openMP가 훨씬 편하다. MPI는 코드 자체가 다 수정해야한다.**

```
!$OMP PARALLEL DO
...
!$OMP END PARALLEL DO
```


인풋파일 많을 때 쓰레드 요즘에 자원 좋으면 40개까지 있으니까 동시에 input 파일 읽게.
```fortran
PROGRAM main
...
CALL interpolate()
CALL compute_states()
CALL gen_random_params()
...
END PROGRAM main
```

```fortran
PROGRAM main
...
CALL interpolate()
CALL compute_states()
CALL gen_random_params()
...
END PROGRAM main
```

공유메모리에서는 openMP 를 많이 쓴다.

분산메모리에서는 MPI 

공유분산은 openMP와 MPI 혼합. 여기서는 openMP 만 가지고는 못한다. openMP는 하나의 컴퓨터, 노드라고 보면 된다. openMP는 하나의 노드에서만 사용할 수 있다. 확장성 제한. 누리온에 많은 자원을 사용하려면 openMP를 사용해야한다. 내 코드는 68개 노드만 쓸꺼면 openMP 코어밖에 못쓴다. 1000개의 코어는 사용할 수 없다. 보통 슈퍼컴퓨터 쓰려면 MPI 코딩은 필수. MPI 코딩은 복잡, 할일도 많다. !!?


* NUMA
보드하나에 cpu 여러개 있을 때, 각 cpu와 메모리와 달리 또 다른 cpu와 메모리에 접근하는 속도는 차이가 있다. 
넌유니폼

* UMA 시스템
cpu1개 코어 4개, 메모리.
각 코어에서 메모리에 접근하는 속도가 똑같다.
유티폼

스카이 레이크 20개짜리 코어 1개.
나이츠렌딩 코어 68개 1개. 코드런트 모드 논리적 4등분, 누마시스템.

나중에 최적화 할 때는 누마든 우마든 어떻게 사용할지, 어떤 식으로 시스템을 활용할 지. 





## 성능측정

### 병목지점 분석
병목지점을 찾고 그 부분을 병렬처리하는 것이 중요하다. 다른 곳 해봤자 성능이 그닥?

컴파일러 상용, 인텔 같은 컴파일러가 많이 빠르다. 

인텔 라이브러리, 인텔 수치, 인텔 컴파일러 이렇게 사용하면 훨씩 성능이득이 좋다.

여러가지 컴파일러로 확인

순차코드는 cpu time 하고 wallcolck time 시간이 거의 같다.

근데 병렬처리는 코어 10개 가지고 처리했다면 1시간 짜리가 6분만에 산술적으로 끝난다. 월클락이 6분.

씨피유는 10개썼으니까 토탈 10개. 그래서 월클락으로 봐야한다. 실제 돌은 시간을 봐야하니까.


## time 명령어
코드시간 측정 도구
time ./PI_sq.o

## 통신부하

작은 것을 여러 번 보내는 것 보다 큰 것 한 번에 보내는 것이 빠르다

* 일정 : 2019/02/21 - 2019/02/22 (총 이틀간)
* 장소 : 한국과학기술정보연구원(대전 카이스트)
* https://helpdesk.ksc.re.kr/
  * 관련 정보 확인

# Fortran Training Course

## 접속 직후

```
login as: sedu20
Using keyboard-interactive authentication.
Password(OTP):
Using keyboard-interactive authentication.
Password:
Last login: Thu Feb 14 13:44:15 2019 from 147.47.212.40
================ KISTI 5th NURION System ====================
 * Any unauthorized attempts to use/access the system can be
   investigated and prosecuted by the related Act

 * Compute Nodes(node[0001-8305],cpu[0001-0132)
  - KNL(XeonPhi 7250 1.40GHz 68C)/16GB(MCDRAM),96GB(DDR4)
  - CPU-only(XeonSKL6148 2.40GHz 20Cx2)/192GB(DDR4)

 * Software
  - OS: CentOS 7.4(3.10.0-693.21.1.el7.x86_64)
  - System S/W: BCM v8.1,PBS v14.2,Lustre v2.10

 * Current Configurations
  - All KNL Cluster modes - Quadrant
  - Memory modes
   : Cache-node[0001-7980,8281-8300]/Flat-node[7981-8280]
   : PBS job sharing mode-Exclusive(running 1 job per node)
     (Except just the commercial queue)

 * Policy on User Job
        Queue    |Wall-Clock |Max Running| Max Active Jobs |
                 |   Limit   |   Jobs    |(running+waiting)|
    - - - - - - -|- - - - - -| - - - - - - - -  - - - - - -|
  - exclusive    | unlimited |    30     |       40        |
  - khoa         | unlimited |    30     |       40        |
  - normal       |    48h    |    30     |       60        |
  - burst_buffer |    48h    |    10     |       20        |
  - long         |   120h    |    10     |       20        |
  - flat         |    48h    |    10     |       20        |
  - debug        |    48h    |     2     |        2        |
  - commercial   |    48h    |     5     |       10        |
  - norm_SKL     |    48h    |    10     |       20        |
  (Use the #showq & #pbs_status commands for more queue info.)

 * Preventive Maintenance
  - 2019-02-13 09:00 ~ 2019-02-13 23:59

 * SWAP off for performance consistency (CPU-only nodes)

 * Available Environment Modules
  - 'module [command] [modulefile]' (use --help option)

 * More details can be found on https://helpdesk.ksc.re.kr

=================== Account Information ====================
 * Account  :              in0163
 * Due Date :          2020/01/18
 * Allocated  SRU Time :          360,000 [sec]
  >     Used  SRU Time :              743 [sec]
 -----------------------------------------------------------
 *  Available SRU Time :          359,257 [sec] [99.79%]
  @ Available KNL CORE Time = Available SRU Time x  4,352
  @ Available SKL CORE Time = Available SRU Time x  1,280
 -----------------------------------------------------------
  ** more information :  http://helpdesk.ksc.re.kr
 -----------------------------------------------------------
  Account manager
  - E-mail : account@ksc.re.kr        Tel : 080-041-1991
============================================================
* sedu20 Lustre Filesystem Quota Status ("*" exceeded quota)
============================================================
Filesystem       KBytes        Quota      Files      Quota
------------------------------------------------------------
   /home01         104k          64G         23     200000
  /scratch          12k         100T          3    1000000
============================================================
*If the quota is exceeded,creation or writing is not possible!!

[sedu20@login03 ~]$

```


## 모듈 관련

### 모듈 확인 module li
module li / module list
```
[sedu20@login03 sedu20]$ module list
Currently Loaded Modulefiles:
  1) craype-network-opa
[sedu20@login03 sedu20]$

```
### 모듈 가능한거 확인 module av
```
[sedu20@login03 sedu20]$ module av

----------------- /opt/cray/craype/default/modulefiles ------------------
craype-mic-knl     craype-network-opa craype-x86-skylake

------------------------- /opt/cray/modulefiles -------------------------
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

------------------ /apps/Modules/modulefiles/compilers ------------------
cce/8.6.3(default)    gcc/7.2.0             intel/18.0.1
gcc/6.1.0             intel/17.0.5(default) intel/18.0.3

--------------------- /apps/Modules/modulefiles/mpi ---------------------
ime/mvapich-verbs/2.2.ddn1.4 impi/18.0.3
ime/openmpi/1.10.ddn1.0      mvapich2/2.3
impi/17.0.5(default)         openmpi/3.1.0
impi/18.0.1

------------- /apps/Modules/modulefiles/libraries_using_mpi -------------
fftw_mpi/2.1.5             netcdf-hdf5-parallel/4.6.1
fftw_mpi/3.3.7             parallel-netcdf/1.10.0
hdf5-parallel/1.10.2       pio/2.3.1

------------------ /apps/Modules/modulefiles/libraries ------------------
CDO/1.8.2    hdf5/1.10.2  ncl/6.5.0    ncview/2.1.7
hdf4/4.2.13  lapack/3.7.0 NCO/4.7.4    netcdf/4.6.1

----------------- /apps/Modules/modulefiles/commercial ------------------
cfx/v145               fluent/v145            gaussian/g16.a03
cfx/v170               fluent/v170            gaussian/g16.a03.linda
cfx/v181               fluent/v181            lsdyna/mpp
cfx/v191               fluent/v191            lsdyna/smp

---------------- /apps/Modules/modulefiles/applications -----------------
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

-------------------- /apps/Modules/modulefiles/test ---------------------
impi/19.0.1  intel/19.0.1 pgi/18.10

------------------- /apps/Modules/modulefiles/crayadm -------------------
chklimit/1.0 htop/2.2.0
[sedu20@login03 sedu20]$

```



### 모듈 추가
오늘 실습은 나이츠렌딩하고 gcc 7.2.0, 두개를 추가하면 g포트란 사용 가능
```
[sedu20@login03 sedu20]$ module add craype-mic-knl gcc/7.2.0
[sedu20@login03 sedu20]$ module li
Currently Loaded Modulefiles:
  1) craype-network-opa   2) craype-mic-knl       3) gcc/7.2.0
[sedu20@login03 sedu20]$
```

## 작업제출 
로그인 노드03에서 계산노드8286으로 이동, 여기서만 작업제출 가능.
```
[sedu20@login03 sedu20]$ qsub -I -V -l select=1 -l walltime=02:00:00 -q debug
qsub: waiting for job 1920919.pbs to start
qsub: job 1920919.pbs ready

[sedu20@node8286 ~]$

```



## 포트란

* FORmula TRANslation
IBM에서 1950 년대 개발. 가장 오래된 최초의 고급언어(C 보다도 빠르다)

포트란 96로 객체지향 가능, 오늘은 90 95

### 우선순위 보드마스

BODMAS
B: Brackets first
O: Orders (power, square roots, etc.)
DM: Division and Multiplication
AS: 


### 자료 복사해오기
```
[sedu20@node8286 test0221]$ scp 150.183.150.14:/tmp/Fortran.tgz .
Password(OTP):
Password:
```
### 자료 압축 풀기

```
[sedu20@node8286 test0221]$ tar -xzvf Fortran.tgz
Fortran/
Fortran/DerivedType.f90
Fortran/positioning.f90
Fortran/Parameter.f90
Fortran/output001.txt
Fortran/Allocate.f90
Fortran/WithoutIndex.f90
Fortran/InternalFile.f90
Fortran/output.txt
Fortran/ImplicitIniterface.f90
Fortran/point_sum.f90
Fortran/value.f90
Fortran/norm.f90
Fortran/procedure_pointer.f90
Fortran/mean2.f90
Fortran/output005.txt
Fortran/namelist.f90
Fortran/keyword.f90
Fortran/overloading.f90
Fortran/Merge.f90
Fortran/slash.f90
Fortran/ArrayConstructor.f90
Fortran/module2.f90
Fortran/output009.txt
Fortran/m1.f90
Fortran/Normalize.f90
Fortran/private.f90
Fortran/Pi.f90
Fortran/en_ex.f90
Fortran/output006.txt
Fortran/PointerValuedFunction.f90
Fortran/pointer2.f90
Fortran/DerivedPointerArray.f90
Fortran/format_ex.f90
Fortran/kind_parameter.f90
Fortran/output004.txt
Fortran/integer_ex.f90
Fortran/functionoverloading.f90
Fortran/real_es.f90
Fortran/input.txt
Fortran/const.f90
Fortran/env_ex.f90
Fortran/DerivedPointerArray2.f90
Fortran/ExplicitShape.f90
Fortran/test.f90
Fortran/inc/
Fortran/inc/m1.mod
Fortran/inc/m2.mod
Fortran/intent.f90
Fortran/DynamicAllocation.f90
Fortran/output007.txt
Fortran/Save.f90
Fortran/allocatable_dummy_argument.f90
Fortran/module3.f90
Fortran/allocatable_return_fn.f90
Fortran/DotProduct.f90
Fortran/score.dat
Fortran/output008.txt
Fortran/Internal.f90
Fortran/character_ex.f90
Fortran/output002.txt
Fortran/LinkedList.f90
Fortran/Goto.f90
Fortran/Forall.f90
Fortran/Module.f90
Fortran/MC_PI.f90
Fortran/danglingpointer.f90
Fortran/stream_ex.dat
Fortran/pure.f90
Fortran/int_kind.f90
Fortran/elementalIntrinsic.f90
Fortran/userdefinedoperator.f90
Fortran/output003.txt
Fortran/m2.f90
Fortran/HelloWorld.f90
Fortran/arguments.f90
Fortran/If.f90
Fortran/Arrayinitializer.f90
Fortran/stream.f90
Fortran/Interoperation_with_C.f90
Fortran/core.52873
Fortran/Array.f90
Fortran/pointer3.f90
Fortran/core.6770
Fortran/recursive.f90
Fortran/mean1.f90
Fortran/AssumedShape.f90
Fortran/statement.f90
Fortran/ExplicitInterface.f90
Fortran/operatoroverloading.f90
Fortran/assignoverloading.f90
Fortran/real_e.f90
Fortran/SelectCase.f90
Fortran/output010.txt
Fortran/core.52858
Fortran/Reshape.f90
Fortran/real_ex.f90
Fortran/C_func.c
Fortran/pointer.f90
Fortran/optional.f90
Fortran/elementalfunction.f90
Fortran/module.f90
Fortran/Do.f90

```

### 하나씩 해보기

```fortran
PROGRAM DerivedType
IMPLICIT NONE
TYPE coord_3d
    REAL::x,y,z
END TYPE coord_3d
TYPE(coord_3d)::pt1, pt2=coord_3d(2.0, 2.0, 2.0), pt3
pt1%x=1.0;     pt1%y=1.0;    pt1%z=1.0
pt3=coord_3d(3.0, 3.0, 3.0)
PRINT*,pt1%x, pt1%y, pt1%z;   PRINT*,pt2%x, pt2%y, pt2%z
PRINT*,pt3%x, pt3%y, pt3%z
END PROGRAM DerivedType

```


```

[sedu20@node8286 Fortran]$ cat DotProduct.f90
PROGRAM array_func_dot

IMPLICIT NONE
INTEGER, PARAMETER :: NumItems = 5
REAL, DIMENSION(NumItems) :: A, B

A = (/1,2,3,4,5/)
B = (/1,2,3,4,5/)

PRINT '(1X, "Dot Product define function : ", F6.2)',  dot(a,b,NumItems)
PRINT '(1X, "Dot Product array function : ", F6.2)',  DOT_PRODUCT(A,B)

CONTAINS
        REAL FUNCTION dot(a,b,n)
                INTEGER i
                INTEGER, INTENT(IN) :: n
                REAL, DIMENSION(N), INTENT(IN) :: a, b

                dot=0.0
                DO i = 1, n
                        dot = dot + a(i) * b(i)
                END DO
        END FUNCTION dot
END PROGRAM array_func_dot


```

```
[sedu20@node8286 Fortran]$ cat MC_PI.f90
PROGRAM mc_pi
IMPLICIT NONE
INTEGER(KIND=8)::i,scope=100000000
REAL(kind=8)::x,y,z, pi, z1, in_count=0.0, out_count=0.0
INTEGER::seed=1234

CALL srand(seed)
DO i=0,scope-1
    x=rand();   y=rand()
    z=x*x+y*y
!    z1=SQRT(z)

!    IF(z1<=1)THEN
    IF(Z<=1)THEN
        in_count=in_count+1
    ELSE
        out_count=out_count+1
    END IF
END DO
pi=(4*in_count)/(in_count+out_count)
WRITE(*,'(A,F15.10,2X,A,E15.10)')'pi=',pi,&
'Error=',DABS(pi-ACOS(-1.0d0))

END PROGRAM mc_pi

```




```

[sedu20@node8286 Fortran]$ cat recursive.f90
PROGRAM recursive_ex
IMPLICIT NONE
INTEGER::n, res
PRINT*,'ENTER THE POSITIVE INTEGER '
READ*,n
res=factorial(n)
PRINT*,'RES( in function)=',res

CALL fact_routine(n,res)
PRINT*,'RES( in subroutine)=',res
CONTAINS
RECURSIVE INTEGER FUNCTION factorial(n) RESULT(fact)
IMPLICIT NONE
INTEGER,INTENT(IN)::n
IF(n==0) THEN
    fact=1
ELSE
    fact=n*factorial(n-1)
END IF
END FUNCTION factorial

RECURSIVE SUBROUTINE fact_routine(n,fact)
IMPLICIT NONE
INTEGER,INTENT(IN)::n
INTEGER,INTENT(OUT)::fact
IF(n==0) THEN
    fact=1
ELSE
    CALL fact_routine(n-1,fact)
    fact=n*fact
END IF
END SUBROUTINE fact_routine
END PROGRAM recursive_ex

```

```
[sedu20@node8286 Fortran]$ cat  Reshape.f90
PROGRAM reshape_ex
IMPLICIT NONE
INTEGER,DIMENSION(2,2)::a
INTEGER,DIMENSION(2,3)::b

a=RESHAPE((/1,2,3,4/),(/2,2/))
PRINT*,a(1,:)
PRINT*,a(2,:)
PRINT*,''
a=RESHAPE((/1,2,3,4/),(/2,2/),ORDER=(/1,2/))
PRINT*,a(1,:)
PRINT*,a(2,:)
PRINT*,''
a=RESHAPE((/1,2,3,4/),(/2,2/),ORDER=(/2,1/))
PRINT*,a(1,:)
PRINT*,a(2,:)
PRINT*,''
b=RESHAPE((/1,2,3,4/),(/2,3/),(/0/),(/2,1/))
PRINT*,b(1,:)
PRINT*,b(2,:)

END PROGRAM reshape_ex

```


```
[sedu20@node8286 Fortran]$ cat Normalize.f90
PROGRAM normalize
IMPLICIT NONE
REAL,DIMENSION(5)::g
INTEGER, DIMENSION(1)::maxij
INTEGER::i,j
g=(/5.0, 5.0,10.0, 5.0, 5.0/)
maxij=MAXLOC(g)
DO i=1,5
    g(i)=g(i)/g(maxij(1))
END DO
PRINT*,g
PRINT*,'------------------'
g=(/5.0, 5.0,10.0, 5.0, 5.0/)
g=g/g(maxij(1))
PRINT*,g
END PROGRAM normalize

```



```
[sedu20@node8286 Fortran]$ cat DerivedPointerArray.f90
PROGRAM derived_pointer_array
IMPLICIT NONE
TYPE varray
    INTEGER, DIMENSION(:), POINTER::vdat
    INTEGER,DIMENSION(:),ALLOCATABLE::a
END TYPE varray
TYPE(varray)::p1
INTEGER::i
ALLOCATE(p1%a(5))
p1%a=(/(i,i=1,5)/)
PRINT*,p1%a
DEALLOCATE(p1%a)

ALLOCATE(p1%a(10))
p1%a=(/(i,i=1,10)/)
PRINT*,p1%a
DEALLOCATE(p1%a)
END PROGRAM derived_pointer_array

```

![t01](https://user-images.githubusercontent.com/8021479/53143954-a0016000-35dd-11e9-8269-054a2dd4a85f.PNG)

filezilla
sftp
포트22


```
[sedu20@node8281 Fortran]$ vi Do.f90
[sedu20@node8281 Fortran]$ gfortran Do.f90
[sedu20@node8281 Fortran]$ ./a.out
 SUM=          55
[sedu20@node8281 Fortran]$

```






This is some shared instructions.

```if:javascript,ruby
This is only shown to JavaScript and Ruby users
- markdown is supported inside of here
- you can even include code blocks by using the alternate ~~~ format instead of ```
```
```if:csharp
this is only shown to C# users
```




```fortran
PROGRAM
```

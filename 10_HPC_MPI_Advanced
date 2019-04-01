* 일정 : 2019/03/19 - 2019/03/22 (4일)
* 장소 : 한국과학기술정보연구원(대전 카이스트)

# MPI 고급



# 21일

* 커뮤니케이터를 쪼개서 만들 수도 있다.
* 커뮤니케이터가 2개일때 자기내들끼리 통신은 어제처럼
* 커뮤니케이터끼리 서로 접속해서 메모리접속할 때? 이건 오늘.
* 오늘할 토플로지

### 

`select=2:ncpus=4:mpiprocs=4:ompthreads=1 -l walltime=04:00:00 -q debug`

* `select=2` 노드2개 할당
* `ncpus=4` 각 노드당 CPU 4개 확보
* `mpiprocs=4` mpi process 4개 할당
* `ompthreads=1` openmp 안쓰니까 1개만
* `-l` 자원요청
* `exit` 다 쓰고 꼭 빠져나오기
```
[sedu14@login04 C]$ qsub -V -I -l select=2:ncpus=4:mpiprocs=4:ompthreads=1 -l walltime=04:00:00 -q debug
qsub: waiting for job 2010096.pbs to start
qsub: job 2010096.pbs ready
```

### 14 토폴로지

좌표형태지만 링타입도 만들 수 있고 그래프타입 등 다양하게 만들 수 있다. 가장 만힝 쓰는게 직교좌표. 그래서 그림을 가져왔다.
* 토폴로지 만들면서 랭크를 재정리
* 좌표형태는 코드가 쉬워질 수있다.
* 주기성을 줘서 반복? 3번 옆에 1번 있다고 가정, 할 수 있다. 
* 없다면 MPIPROCNULL 통신시도 하지 않는다

카티션좌표개

카티시프트 6번의 0방향(위쪽)에 있는 값이 뭐냐? 이웃한 랭크값

MPI CART SHIFT

### 16 
MPI_DIMS_CREATE

포트란 서브루틴 호출 때는 CALL

### 18

직교좌표만들때 쓰는거 CART_CREATE
새로운 커뮤니케이터, 몇차원만들꺼냐?

### 20

2차원, MPI_DIMS에서 정의한걸 사용, 리오더는 TRUE, comm_cart


```fortran
program cart_create
use mpi_f08
implicit none
integer, parameter::ndim=2
integer::myrank,nprocs, dims(ndim)=0, newprocs, newrank
logical::reorder=.true.,periods(ndim)=.false.
type(mpi_comm)::COMM_CART
call MPI_init
call MPI_Comm_rank(MPI_COMM_WORLD, myrank)
CALL MPI_COMM_SIZE(MPI_COMM_WORLD,nprocs)
call MPI_DIMS_CREATE(NPROCS, NDIM,DIMS)
IF(MYRANK==0) PRINT*, 'DIMS=',DIMS
CALL MPI_CART_CREATE(MPI_COMM_WORLD,NDIM,DIMS,PERIODS,REORDER,COMM_CART)
CALL MPI_COMM_SIZE(COMM_CART, NEWPROCS)
CALL MPI_COMM_RANK(COMM_CART, NEWRANK);
PRINT*, 'MYRANK:', MYRANK,'NEWRANK:',NEWRANK
CALL MPI_FINALIZE
end program cart_create
```

```
[sedu14@node8289 to]$ vi 01.f90
[sedu14@node8289 to]$ mpif90 01.f90 -o 01.x
[sedu14@node8289 to]$ mpirun -np 12 ./01.x
 DIMS=           4           3
 MYRANK:           0 NEWRANK:           0
 MYRANK:           2 NEWRANK:           2
 MYRANK:           3 NEWRANK:           3
 MYRANK:           4 NEWRANK:           4
 MYRANK:           5 NEWRANK:           5
 MYRANK:           6 NEWRANK:           6
 MYRANK:           7 NEWRANK:           7
 MYRANK:           1 NEWRANK:           1
 MYRANK:           8 NEWRANK:           8
 MYRANK:           9 NEWRANK:           9
 MYRANK:          10 NEWRANK:          10
 MYRANK:          11 NEWRANK:          11
```

새로만들어진 커뮤니케이터, 

### 26

```


```

### 28

### 33 cart shift

```fortran

PROGRAM CART_SHIFT
use mpi_f08
implicit none
type(mpi_comm)::OLDCOMM, NEWCOMM
integer::ndims=2, DIMSIZE(0:1)
LOGICAL::PERIODS(0:1),REORDER
integer::myrank,nprocs,I,J,RANK
INTEGER::COORDS(0:1)
INTEGER::DIRECTION, DISP,SRC,DEST

call MPI_init
call MPI_Comm_rank(MPI_COMM_WORLD, myrank)
CALL MPI_COMM_SIZE(MPI_COMM_WORLD,nprocs)

OLDCOMM=MPI_COMM_WORLD
DIMSIZE=(/3,2/)
PERIODS=(/.TRUE.,.FALSE./)
REORDER=.TRUE.

CALL MPI_CART_CREATE(OLDCOMM, NDIMS, DIMSIZE,PERIODS, REORDER, NEWCOMM)
DIRECTION=0; DISP=1
CALL MPI_CART_SHIFT(NEWCOMM, DIRECTION, DISP,SRC, DEST)
PRINT*, 'RANK:', MYRANK,'SOURCE:',SRC, 'DESTINATION=',DEST
CALL MPI_FINALIZE
end program CART_SHIFT

```


```
[sedu14@node8289 to]$ mpif90 cart_shift.f90 -o cart_shift.x

[sedu14@node8289 to]$ mpirun -np 6 ./cart_shift.x
 RANK:           0 SOURCE:           4 DESTINATION=           2
 RANK:           1 SOURCE:           5 DESTINATION=           3
 RANK:           2 SOURCE:           0 DESTINATION=           4
 RANK:           3 SOURCE:           1 DESTINATION=           5
 RANK:           4 SOURCE:           2 DESTINATION=           0
 RANK:           5 SOURCE:           3 DESTINATION=           1

```

### 39 neighborhood_allgather

```fortran

PROGRAM neighborhood_allgather
use mpi_f08
implicit none
integer::myrank, procs
type(mpi_comm)::COMM_CART
integer::ndim=2, DIMS(2), COORDS(2), RECVBUF(4)=-10
LOGICAL::PERIODS(2)=.FALSE., REORDER=.FALSE.

call MPI_init
call MPI_Comm_rank(MPI_COMM_WORLD, myrank)
CALL MPI_COMM_SIZE(MPI_COMM_WORLD,procs)

DIMS=(/4,4/)

CALL MPI_CART_CREATE(MPI_COMM_WORLD, NDIM, DIMS, PERIODS,REORDER,COMM_CART)
CALL mpi_CART_COORDS(COMM_CART, MYRANK, NDIM, COORDS)
CALL MPI_NEIGHBORHOOD_ALLGATHER(MYRANK,1,MPI_INTEGER,RECVBUF,1,MPI_INTEGER,COMM_CART)
PRINT*,'MYRANK:', MYRANK,'RECVBUF:',RECVBUF
CALL MPI_FINALIZE
end program neighborhood_allgather


```

### 43 

### 50 win fence 

동기화, 메모리 펜스와 비슷한 개념

mpi foot 비동기함수

winfence 지정하면 다른 프로세서가 접근 가능,

### 62 accumulate

다 있는데 op, win. 연산취하는, 어제 배우는 reduce 연산 그대로 사용 가능.


###

* https://twitter.com/cvpr2019
* https://s2019.siggraph.org/conference/programs-events/computer-animation-festival/electronic-theater/electronic-theater-submissions/
* https://iclr.cc/
* http://iccv2019.thecvf.com/
* https://aideadlin.es/?sub=ML,CV,NLP,RO,SP,DM
* https://brunch.co.kr/@needleworm/61


### 70 get_accumulate

```fortan
PROGRAM get_accumulate
use mpi_f08
implicit none
integer::a,b=0, myrank
integer(kind=MPI_ADDRESS_KIND)::size, disp
type(MPI_Win)::win

CALL MPI_Init
CALL MPI_Comm_rank(MPI_COMM_WORLD, myrank)
if(myrank==0) a=1
if(myrank==1) a=10
if(myrank==2) a=100
print*,'myrank:',myrank,'a=', a
size=storage_size(a)/8
CALL MPI_Win_create(a,size,1,MPI_INFO_NULL,MPI_COMM_WORLD,win)
CALL MPI_Win_fence(0,win)
disp =0
if(myrank==0) then
    CALL
MPI_Get_accumulate(a,1,MPI_Integer,b,1,MPI_Integer,2,disp,1,&MPI_Integer,MPI_Sum,win)
endif

CALL MPI_Win_fence(0,win)
print*,'myrank:',myrank, 'A=', a
print*,'myrank:',myrank, 'A=', b
CALL MPI_Win_free(win)
CALL MPI_FINALIZE
end program get_accumulate

```


```

[sedu14@node8289 to]$ mpif90 get_accumulate.f90 -o get_accumulate.x
get_accumulate.f90:19:69:

     call MPI_Get_accumulate(a,1,MPI_Integer,b,1,MPI_Integer,2,disp,1,&MPI_Integer,MPI_SUM,win)
                                                                     1
Error: Syntax error in argument list at (1)
[sedu14@node8289 to]$

```




```


[sedu14@login03 Codes]$ time mpirun -np 8 ./pi1.x
--------------------------------------------------------------------------
WARNING: No preset parameters were found for the device that Open MPI
detected:

  Local host:            login03
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

  Local host:           login03
  Local device:         i40iw0
  Local port:           1
  CPCs attempted:       rdmacm, udcm
--------------------------------------------------------------------------
ista=250000001, iend =375000000
ista=875000001, iend =1000000000
ista=1, iend =125000000
ista=375000001, iend =500000000
ista=625000001, iend =750000000
ista=750000001, iend =875000000
ista=125000001, iend =250000000
ista=500000001, iend =625000000
numerical pi = 3.141592653589769
analytical pi = 3.141592653589793
Error = 2.442491E-14
[login03:118329] 23 more processes have sent help message help-mpi-btl-openib.txt / no device params found
[login03:118329] Set MCA parameter "orte_base_help_aggregate" to 0 to see all help / error messages
[login03:118329] 15 more processes have sent help message help-mpi-btl-openib-cpc-base.txt / no cpcs for port

real    0m2.557s
user    0m13.425s
sys     0m1.367s
[sedu14@login03 Codes]$


```



```
[sedu14@login03 Codes]$ time mpirun -np 12 ./pi1.x
--------------------------------------------------------------------------
WARNING: No preset parameters were found for the device that Open MPI
detected:

  Local host:            login03
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

  Local host:           login03
  Local device:         i40iw0
  Local port:           1
  CPCs attempted:       rdmacm, udcm
--------------------------------------------------------------------------
ista=500000003, iend =583333335
ista=1, iend =83333334
ista=166666669, iend =250000002
ista=666666669, iend =750000001
ista=250000003, iend =333333336
ista=333333337, iend =416666669
ista=750000002, iend =833333334
ista=833333335, iend =916666667
ista=916666668, iend =1000000000
ista=583333336, iend =666666668
ista=83333335, iend =166666668
ista=416666670, iend =500000002
numerical pi = 3.141592653589860
analytical pi = 3.141592653589793
Error = 6.661338E-14
[login03:139380] 35 more processes have sent help message help-mpi-btl-openib.txt / no device params found
[login03:139380] Set MCA parameter "orte_base_help_aggregate" to 0 to see all help / error messages
[login03:139380] 23 more processes have sent help message help-mpi-btl-openib-cpc-base.txt / no cpcs for port

real    0m2.080s
user    0m13.668s
sys     0m2.119s


```


```

[sedu14@login03 Codes]$ time mpirun -np 2 ./pi1.x
--------------------------------------------------------------------------
WARNING: No preset parameters were found for the device that Open MPI
detected:

  Local host:            login03
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
[login03:145540] [[15059,0],0] ORTE_ERROR_LOG: Out of resource in file util/show_help.c at line 501
--------------------------------------------------------------------------
No OpenFabrics connection schemes reported that they were able to be
used on a specific port.  As such, the openib BTL (OpenFabrics
support) will be disabled for this port.

  Local host:           login03
  Local device:         i40iw0
  Local port:           1
  CPCs attempted:       rdmacm, udcm
--------------------------------------------------------------------------
ista=1, iend =500000000
ista=500000001, iend =1000000000
[login03:145540] 4 more processes have sent help message help-mpi-btl-openib.txt / no device params found
[login03:145540] Set MCA parameter "orte_base_help_aggregate" to 0 to see all help / error messages
[login03:145540] 3 more processes have sent help message help-mpi-btl-openib-cpc-base.txt / no cpcs for port
numerical pi = 3.141592653589901
analytical pi = 3.141592653589793
Error = 1.079137E-13

real    0m7.653s
user    0m13.198s
sys     0m0.308s
```


```c

#include <stdio.h>
#include <mpi.h>
#include <math.h>
#define num_steps 1000000000

int min(int x, int y){

    int v;
    if (x>=y) v=y;
    else v=x;
    return v;
}
void para_range(int n1, int n2, int nprocs, int myrank, int *ista, int *iend){

    int iwork1, iwork2;
    iwork1 = (n2-n1+1)/nprocs;
    iwork2 = (n2-n1+1)%nprocs;
    *ista = myrank*iwork1 + n1 + min(myrank,iwork2);
    *iend = *ista + iwork1 - 1;
    if(iwork2> myrank) *iend = *iend + 1;
}

void main(int argc, char *argv[]){
    double sum, step, x, pi;
    double tsum;
    int i, nprocs, myrank;
    int ista, iend;
    MPI_Status status;
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
    MPI_Comm_rank(MPI_COMM_WORLD, &myrank);

    sum=0.0;
    step=1./(double)num_steps;

    para_range(1,num_steps, nprocs, myrank, &ista, &iend);
    printf("ista=%d, iend =%d \n", ista, iend);

    for(i=ista; i<=iend; i++){

        x=(i-0.5)*step;
        sum = sum+4.0/(1.0+x*x);
    }

    MPI_Reduce(&sum, &tsum, 1, MPI_DOUBLE,MPI_SUM,0,MPI_COMM_WORLD);

    if(myrank==0){
        pi=step*tsum;
        printf("numerical pi = %.15lf \n", pi);
        printf("analytical pi = %.15f \n", acos(-1.0));
        printf("Error = %E \n", fabs(acos(-1.0)-pi));

    }

    MPI_Finalize();

}


```



```c

#include <stdio.h>
#include <mpi.h>
#define n 11





int min(int x, int y){

    int v;
    if (x>=y) v=y;
    else v=x;
    return v;
}
void para_range(int n1, int n2, int nprocs, int myrank, int *ista, int *iend){


    int iwork1, iwork2;
    iwork1 = (n2-n1+1)/nprocs;
    iwork2 = (n2-n1+1)%nprocs;
    *ista = myrank*iwork1 + n1 + min(myrank,iwork2);
    *iend = *ista + iwork1 - 1;
    if(iwork2> myrank) *iend = *iend + 1;
}

int main(int argc, char *argv[]){
    void para_range(int,int,int,int,int*,int*);
    int min(int, int);
    int i, nprocs, myrank;
    double a[n], b[n];
    int ista, iend, ista2, iend1, inext, iprev;
    MPI_Request isend1, isend2, irecv1, irecv2;
    MPI_Status istatus;
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
    MPI_Comm_rank(MPI_COMM_WORLD, &myrank);
    para_range(0, n-1, nprocs, myrank, &ista, &iend);
    ista2 = ista; iend1 = iend;
    if(myrank==0) ista2=1;
    if(myrank==nprocs-1) iend1=n-2;
    inext=myrank+1; iprev=myrank-1;

    if(myrank==nprocs-1) inext=MPI_PROC_NULL;
    if(myrank==0) iprev=MPI_PROC_NULL;
    MPI_Isend(&b[iend], 1, MPI_DOUBLE, inext, 1, MPI_COMM_WORLD, &isend1);
    MPI_Isend(&b[ista], 1, MPI_DOUBLE, iprev, 1, MPI_COMM_WORLD, &isend2);
    MPI_Irecv(&b[ista-1], 1, MPI_DOUBLE, iprev, 1, MPI_COMM_WORLD, &irecv1);
    MPI_Irecv(&b[iend+1], 1, MPI_DOUBLE, inext, 1, MPI_COMM_WORLD, &irecv1);
    MPI_Wait(&isend1, &istatus);
    MPI_Wait(&isend2, &istatus);
    MPI_Wait(&irecv1, &istatus);
    MPI_Wait(&irecv2, &istatus);

    for(i=ista2; i<=iend1; i++) a[i] = b[i-1] + b[i+1];
    MPI_Finalize();

}



```



```

```
        /apps/Modules/modulefiles/compilers:/apps/Modules/modulefiles/mpi:/apps
        /Modules/modulefiles/libraries_using_mpi:/apps/Modules/modulefiles/libr
        aries:/apps/Modules/modulefiles/commercial:/apps/Modules/modulefiles/ap
        plications:/apps/Modules/modulefiles/test:/apps/Modules/modulefiles/cra
        y:/apps/Modules/modulefiles/crayadm:,KDEDIRS=/usr,PBS_O_SHELL=/bin/bash,
        SSH_TTY=/dev/pts/66,
        OLDPWD=/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_12,
        LOADEDMODULES=craype-network-opa,
        LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=4
        0;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;
        41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01
        ;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=
        01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=0
        1;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31
        :*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:
        *.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31
        :*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;3
        1:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;
        35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01
        ;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng
        =01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.m
        kv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:
        *.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*
        .rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:
        *.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:
        *.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:
        *.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;
        36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;
        36:*.xspf=01;36:,
        SSH_CONNECTION=203.237.172.100 53316 150.183.150.11 22,
        CRAYPE_NETWORK_TARGET=opa,HISTCONTROL=ignoredups,SHLVL=2,
        PWD=/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_12_b,HOSTNAME=login01,
        LOGNAME=x1750a01,
        _LMFILES_=/opt/cray/craype/default/modulefiles/craype-network-opa,
        BASH_FUNC_module()=() {  eval `/cm/local/apps/environment-modules/3.2.
        10/Modules/$MODULE_VERSION/bin/modulecmd bash $*`; },
        PBS_O_QUEUE=normal,PBS_O_HOST=login01
    comment = Not Running: User has reached queue normal running job limit.
    etime = Thu Mar 21 13:26:54 2019
    run_count = 19
    Submit_arguments = g16.sh
    project = _pbs_project_default

Job Id: 2010596.pbs
    Job_Name = DNPNPND_T_12_s
    Job_Owner = x1750a01@login01
    job_state = Q
    queue = normal
    server = pbs1
    Checkpoint = u
    ctime = Thu Mar 21 13:26:57 2019
    Error_Path = login01:/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_12_s/DNPNPND
        _T_12_s.e2010596
    Hold_Types = n
    Join_Path = n
    Keep_Files = n
    Mail_Points = a
    mtime = Thu Mar 21 13:26:57 2019
    Output_Path = login01:/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_12_s/DNPNPN
        D_T_12_s.o2010596
    Priority = 100
    qtime = Thu Mar 21 13:26:58 2019
    Rerunable = True
    Resource_List.knl_cluster_mode = quadrant
    Resource_List.knl_memory_mode = cache
    Resource_List.mpiprocs = 1
    Resource_List.ncpus = 32
    Resource_List.nodect = 1
    Resource_List.place = scatter:excl
    Resource_List.qlist = normal
    Resource_List.select = 1:ncpus=32:mpiprocs=1:ompthreads=32
    Resource_List.walltime = 48:00:00
    substate = 10
    Variable_List = HISTTIMEFORMAT=%y-%m-%d %H:%M:%S,MODULE_VERSION=3.2.10,
        PBS_O_HOME=/home01/x1750a01,LESSOPEN=||/usr/bin/lesspipe.sh %s,
        PBS_O_LOGNAME=x1750a01,SSH_CLIENT=203.237.172.100 53316 22,
        PBS_O_LANG=en_US.UTF-8,USER=x1750a01,PROMPT_COMMAND=history -a,
        QTDIR=/usr/lib64/qt-3.3,
        PATH=/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/us
        r/sbin:/opt/ddn/ime/bin:/cm/local/apps/environment-modules/3.2.10/bin:/
        opt/pbs/bin:/home01/x1750a01/.local/bin:/home01/x1750a01/bin,
        LD_LIBRARY_PATH=/opt/cray/lib64:,XDG_RUNTIME_DIR=/run/user/6040112,
        LANG=en_US.UTF-8,QTLIB=/usr/lib64/qt-3.3/lib,TERM=vt100,ENABLE_LMOD=0,
        QTINC=/usr/lib64/qt-3.3/include,HISTSIZE=20000,
        PBS_O_WORKDIR=/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_12_s,
        PBS_O_PATH=/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/usr/local/sb
        in:/usr/sbin:/opt/ddn/ime/bin:/cm/local/apps/environment-modules/3.2.10
        /bin:/opt/pbs/bin:/home01/x1750a01/.local/bin:/home01/x1750a01/bin,
        MANPATH=/usr/local/share/man:/usr/share/man/overrides:/usr/share/man:/
        opt/ddn/ime/share/man:/opt/ddn/ime/share/man:/cm/local/apps/environment
        -modules/current/share/man:/opt/pbs/share/man,HOME=/home01/x1750a01,
        MODULESHOME=/cm/local/apps/environment-modules/3.2.10/Modules/3.2.10,
        PBS_O_SYSTEM=Linux,MODULE_VERSION_STACK=3.2.10,
        QT_PLUGIN_PATH=/usr/lib64/kde4/plugins:/usr/lib/kde4/plugins,
        SHELL=/bin/bash,MAIL=/var/spool/mail/x1750a01,
        QT_GRAPHICSSYSTEM_CHECKED=1,XDG_SESSION_ID=4611,
        PBS_O_MAIL=/var/spool/mail/x1750a01,_=/opt/pbs/bin/qsub,
        MODULEPATH=/opt/cray/craype/default/modulefiles:/opt/cray/modulefiles:
        /apps/Modules/modulefiles/compilers:/apps/Modules/modulefiles/mpi:/apps
        /Modules/modulefiles/libraries_using_mpi:/apps/Modules/modulefiles/libr
        aries:/apps/Modules/modulefiles/commercial:/apps/Modules/modulefiles/ap
        plications:/apps/Modules/modulefiles/test:/apps/Modules/modulefiles/cra
        y:/apps/Modules/modulefiles/crayadm:,KDEDIRS=/usr,PBS_O_SHELL=/bin/bash,
        SSH_TTY=/dev/pts/66,
        OLDPWD=/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_12_b,
        LOADEDMODULES=craype-network-opa,
        LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=4
        0;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;
        41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01
        ;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=
        01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=0
        1;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31
        :*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:
        *.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31
        :*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;3
        1:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;
        35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01
        ;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng
        =01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.m
        kv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:
        *.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*
        .rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:
        *.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:
        *.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:
        *.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;
        36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;
        36:*.xspf=01;36:,
        SSH_CONNECTION=203.237.172.100 53316 150.183.150.11 22,
        CRAYPE_NETWORK_TARGET=opa,HISTCONTROL=ignoredups,SHLVL=2,
        PWD=/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_12_s,HOSTNAME=login01,
        LOGNAME=x1750a01,
        _LMFILES_=/opt/cray/craype/default/modulefiles/craype-network-opa,
        BASH_FUNC_module()=() {  eval `/cm/local/apps/environment-modules/3.2.
        10/Modules/$MODULE_VERSION/bin/modulecmd bash $*`; },
        PBS_O_QUEUE=normal,PBS_O_HOST=login01
    comment = Not Running: User has reached queue normal running job limit.
    etime = Thu Mar 21 13:26:58 2019
    run_count = 19
    Submit_arguments = g16.sh
    project = _pbs_project_default

Job Id: 2010597.pbs
    Job_Name = DNPNPND_T_23
    Job_Owner = x1750a01@login01
    job_state = Q
    queue = normal
    server = pbs1
    Checkpoint = u
    ctime = Thu Mar 21 13:27:03 2019
    Error_Path = login01:/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_23/DNPNPND_T
        _23.e2010597
    Hold_Types = n
    Join_Path = n
    Keep_Files = n
    Mail_Points = a
    mtime = Thu Mar 21 13:27:03 2019
    Output_Path = login01:/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_23/DNPNPND_
        T_23.o2010597
    Priority = 100
    qtime = Thu Mar 21 13:27:03 2019
    Rerunable = True
    Resource_List.knl_cluster_mode = quadrant
    Resource_List.knl_memory_mode = cache
    Resource_List.mpiprocs = 1
    Resource_List.ncpus = 32
    Resource_List.nodect = 1
    Resource_List.place = scatter:excl
    Resource_List.qlist = normal
    Resource_List.select = 1:ncpus=32:mpiprocs=1:ompthreads=32
    Resource_List.walltime = 48:00:00
    substate = 10
    Variable_List = HISTTIMEFORMAT=%y-%m-%d %H:%M:%S,MODULE_VERSION=3.2.10,
        PBS_O_HOME=/home01/x1750a01,LESSOPEN=||/usr/bin/lesspipe.sh %s,
        PBS_O_LOGNAME=x1750a01,SSH_CLIENT=203.237.172.100 53316 22,
        PBS_O_LANG=en_US.UTF-8,USER=x1750a01,PROMPT_COMMAND=history -a,
        QTDIR=/usr/lib64/qt-3.3,
        PATH=/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/us
        r/sbin:/opt/ddn/ime/bin:/cm/local/apps/environment-modules/3.2.10/bin:/
        opt/pbs/bin:/home01/x1750a01/.local/bin:/home01/x1750a01/bin,
        LD_LIBRARY_PATH=/opt/cray/lib64:,XDG_RUNTIME_DIR=/run/user/6040112,
        LANG=en_US.UTF-8,QTLIB=/usr/lib64/qt-3.3/lib,TERM=vt100,ENABLE_LMOD=0,
        QTINC=/usr/lib64/qt-3.3/include,HISTSIZE=20000,
        PBS_O_WORKDIR=/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_23,
        PBS_O_PATH=/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/usr/local/sb
        in:/usr/sbin:/opt/ddn/ime/bin:/cm/local/apps/environment-modules/3.2.10
        /bin:/opt/pbs/bin:/home01/x1750a01/.local/bin:/home01/x1750a01/bin,
        MANPATH=/usr/local/share/man:/usr/share/man/overrides:/usr/share/man:/
        opt/ddn/ime/share/man:/opt/ddn/ime/share/man:/cm/local/apps/environment
        -modules/current/share/man:/opt/pbs/share/man,HOME=/home01/x1750a01,
        MODULESHOME=/cm/local/apps/environment-modules/3.2.10/Modules/3.2.10,
        PBS_O_SYSTEM=Linux,MODULE_VERSION_STACK=3.2.10,
        QT_PLUGIN_PATH=/usr/lib64/kde4/plugins:/usr/lib/kde4/plugins,
        SHELL=/bin/bash,MAIL=/var/spool/mail/x1750a01,
        QT_GRAPHICSSYSTEM_CHECKED=1,XDG_SESSION_ID=4611,
        PBS_O_MAIL=/var/spool/mail/x1750a01,_=/opt/pbs/bin/qsub,
        MODULEPATH=/opt/cray/craype/default/modulefiles:/opt/cray/modulefiles:
        /apps/Modules/modulefiles/compilers:/apps/Modules/modulefiles/mpi:/apps
        /Modules/modulefiles/libraries_using_mpi:/apps/Modules/modulefiles/libr
        aries:/apps/Modules/modulefiles/commercial:/apps/Modules/modulefiles/ap
        plications:/apps/Modules/modulefiles/test:/apps/Modules/modulefiles/cra
        y:/apps/Modules/modulefiles/crayadm:,KDEDIRS=/usr,PBS_O_SHELL=/bin/bash,
        SSH_TTY=/dev/pts/66,
        OLDPWD=/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_12_s,
        LOADEDMODULES=craype-network-opa,
        LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=4
        0;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;
        41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01
        ;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=
        01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=0
        1;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31
        :*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:
        *.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31
        :*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;3
        1:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;
        35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01
        ;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng
        =01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.m
        kv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:
        *.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*
        .rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:
        *.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:
        *.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:
        *.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;
        36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;
        36:*.xspf=01;36:,
        SSH_CONNECTION=203.237.172.100 53316 150.183.150.11 22,
        CRAYPE_NETWORK_TARGET=opa,HISTCONTROL=ignoredups,SHLVL=2,
        PWD=/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_23,HOSTNAME=login01,
        LOGNAME=x1750a01,
        _LMFILES_=/opt/cray/craype/default/modulefiles/craype-network-opa,
        BASH_FUNC_module()=() {  eval `/cm/local/apps/environment-modules/3.2.
        10/Modules/$MODULE_VERSION/bin/modulecmd bash $*`; },
        PBS_O_QUEUE=normal,PBS_O_HOST=login01
    comment = Not Running: User has reached queue normal running job limit.
    etime = Thu Mar 21 13:27:03 2019
    run_count = 19
    Submit_arguments = g16.sh
    project = _pbs_project_default

Job Id: 2010600.pbs
    Job_Name = DNPNPND_T_23_b
    Job_Owner = x1750a01@login01
    job_state = Q
    queue = normal
    server = pbs1
    Checkpoint = u
    ctime = Thu Mar 21 13:27:07 2019
    Error_Path = login01:/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_23_b/DNPNPND
        _T_23_b.e2010600
    Hold_Types = n
    Join_Path = n
    Keep_Files = n
    Mail_Points = a
    mtime = Thu Mar 21 13:27:07 2019
    Output_Path = login01:/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_23_b/DNPNPN
        D_T_23_b.o2010600
    Priority = 100
    qtime = Thu Mar 21 13:27:07 2019
    Rerunable = True
    Resource_List.knl_cluster_mode = quadrant
    Resource_List.knl_memory_mode = cache
    Resource_List.mpiprocs = 1
    Resource_List.ncpus = 32
    Resource_List.nodect = 1
    Resource_List.place = scatter:excl
    Resource_List.qlist = normal
    Resource_List.select = 1:ncpus=32:mpiprocs=1:ompthreads=32
    Resource_List.walltime = 48:00:00
    substate = 10
    Variable_List = HISTTIMEFORMAT=%y-%m-%d %H:%M:%S,MODULE_VERSION=3.2.10,
        PBS_O_HOME=/home01/x1750a01,LESSOPEN=||/usr/bin/lesspipe.sh %s,
        PBS_O_LOGNAME=x1750a01,SSH_CLIENT=203.237.172.100 53316 22,
        PBS_O_LANG=en_US.UTF-8,USER=x1750a01,PROMPT_COMMAND=history -a,
        QTDIR=/usr/lib64/qt-3.3,
        PATH=/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/us
        r/sbin:/opt/ddn/ime/bin:/cm/local/apps/environment-modules/3.2.10/bin:/
        opt/pbs/bin:/home01/x1750a01/.local/bin:/home01/x1750a01/bin,
        LD_LIBRARY_PATH=/opt/cray/lib64:,XDG_RUNTIME_DIR=/run/user/6040112,
        LANG=en_US.UTF-8,QTLIB=/usr/lib64/qt-3.3/lib,TERM=vt100,ENABLE_LMOD=0,
        QTINC=/usr/lib64/qt-3.3/include,HISTSIZE=20000,
        PBS_O_WORKDIR=/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_23_b,
        PBS_O_PATH=/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/usr/local/sb
        in:/usr/sbin:/opt/ddn/ime/bin:/cm/local/apps/environment-modules/3.2.10
        /bin:/opt/pbs/bin:/home01/x1750a01/.local/bin:/home01/x1750a01/bin,
        MANPATH=/usr/local/share/man:/usr/share/man/overrides:/usr/share/man:/
        opt/ddn/ime/share/man:/opt/ddn/ime/share/man:/cm/local/apps/environment
        -modules/current/share/man:/opt/pbs/share/man,HOME=/home01/x1750a01,
        MODULESHOME=/cm/local/apps/environment-modules/3.2.10/Modules/3.2.10,
        PBS_O_SYSTEM=Linux,MODULE_VERSION_STACK=3.2.10,
        QT_PLUGIN_PATH=/usr/lib64/kde4/plugins:/usr/lib/kde4/plugins,
        SHELL=/bin/bash,MAIL=/var/spool/mail/x1750a01,
        QT_GRAPHICSSYSTEM_CHECKED=1,XDG_SESSION_ID=4611,
        PBS_O_MAIL=/var/spool/mail/x1750a01,_=/opt/pbs/bin/qsub,
        MODULEPATH=/opt/cray/craype/default/modulefiles:/opt/cray/modulefiles:
        /apps/Modules/modulefiles/compilers:/apps/Modules/modulefiles/mpi:/apps
        /Modules/modulefiles/libraries_using_mpi:/apps/Modules/modulefiles/libr
        aries:/apps/Modules/modulefiles/commercial:/apps/Modules/modulefiles/ap
        plications:/apps/Modules/modulefiles/test:/apps/Modules/modulefiles/cra
        y:/apps/Modules/modulefiles/crayadm:,KDEDIRS=/usr,PBS_O_SHELL=/bin/bash,
        SSH_TTY=/dev/pts/66,
        OLDPWD=/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_23,
        LOADEDMODULES=craype-network-opa,
        LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=4
        0;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;
        41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01
        ;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=
        01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=0
        1;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31
        :*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:
        *.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31
        :*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;3
        1:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;
        35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01
        ;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng
        =01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.m
        kv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:
        *.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*
        .rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:
        *.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:
        *.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:
        *.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;
        36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;
        36:*.xspf=01;36:,
        SSH_CONNECTION=203.237.172.100 53316 150.183.150.11 22,
        CRAYPE_NETWORK_TARGET=opa,HISTCONTROL=ignoredups,SHLVL=2,
        PWD=/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_23_b,HOSTNAME=login01,
        LOGNAME=x1750a01,
        _LMFILES_=/opt/cray/craype/default/modulefiles/craype-network-opa,
        BASH_FUNC_module()=() {  eval `/cm/local/apps/environment-modules/3.2.
        10/Modules/$MODULE_VERSION/bin/modulecmd bash $*`; },
        PBS_O_QUEUE=normal,PBS_O_HOST=login01
    comment = Not Running: User has reached queue normal running job limit.
    etime = Thu Mar 21 13:27:07 2019
    run_count = 19
    Submit_arguments = g16.sh
    project = _pbs_project_default

Job Id: 2010602.pbs
    Job_Name = DNPNPND_T_23_s
    Job_Owner = x1750a01@login01
    job_state = Q
    queue = normal
    server = pbs1
    Checkpoint = u
    ctime = Thu Mar 21 13:27:11 2019
    Error_Path = login01:/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_23_s/DNPNPND
        _T_23_s.e2010602
    Hold_Types = n
    Join_Path = n
    Keep_Files = n
    Mail_Points = a
    mtime = Thu Mar 21 13:27:11 2019
    Output_Path = login01:/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_23_s/DNPNPN
        D_T_23_s.o2010602
    Priority = 100
    qtime = Thu Mar 21 13:27:11 2019
    Rerunable = True
    Resource_List.knl_cluster_mode = quadrant
    Resource_List.knl_memory_mode = cache
    Resource_List.mpiprocs = 1
    Resource_List.ncpus = 32
    Resource_List.nodect = 1
    Resource_List.place = scatter:excl
    Resource_List.qlist = normal
    Resource_List.select = 1:ncpus=32:mpiprocs=1:ompthreads=32
    Resource_List.walltime = 48:00:00
    substate = 10
    Variable_List = HISTTIMEFORMAT=%y-%m-%d %H:%M:%S,MODULE_VERSION=3.2.10,
        PBS_O_HOME=/home01/x1750a01,LESSOPEN=||/usr/bin/lesspipe.sh %s,
        PBS_O_LOGNAME=x1750a01,SSH_CLIENT=203.237.172.100 53316 22,
        PBS_O_LANG=en_US.UTF-8,USER=x1750a01,PROMPT_COMMAND=history -a,
        QTDIR=/usr/lib64/qt-3.3,
        PATH=/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/us
        r/sbin:/opt/ddn/ime/bin:/cm/local/apps/environment-modules/3.2.10/bin:/
        opt/pbs/bin:/home01/x1750a01/.local/bin:/home01/x1750a01/bin,
        LD_LIBRARY_PATH=/opt/cray/lib64:,XDG_RUNTIME_DIR=/run/user/6040112,
        LANG=en_US.UTF-8,QTLIB=/usr/lib64/qt-3.3/lib,TERM=vt100,ENABLE_LMOD=0,
        QTINC=/usr/lib64/qt-3.3/include,HISTSIZE=20000,
        PBS_O_WORKDIR=/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_23_s,
        PBS_O_PATH=/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/usr/local/sb
        in:/usr/sbin:/opt/ddn/ime/bin:/cm/local/apps/environment-modules/3.2.10
        /bin:/opt/pbs/bin:/home01/x1750a01/.local/bin:/home01/x1750a01/bin,
        MANPATH=/usr/local/share/man:/usr/share/man/overrides:/usr/share/man:/
        opt/ddn/ime/share/man:/opt/ddn/ime/share/man:/cm/local/apps/environment
        -modules/current/share/man:/opt/pbs/share/man,HOME=/home01/x1750a01,
        MODULESHOME=/cm/local/apps/environment-modules/3.2.10/Modules/3.2.10,
        PBS_O_SYSTEM=Linux,MODULE_VERSION_STACK=3.2.10,
        QT_PLUGIN_PATH=/usr/lib64/kde4/plugins:/usr/lib/kde4/plugins,
        SHELL=/bin/bash,MAIL=/var/spool/mail/x1750a01,
        QT_GRAPHICSSYSTEM_CHECKED=1,XDG_SESSION_ID=4611,
        PBS_O_MAIL=/var/spool/mail/x1750a01,_=/opt/pbs/bin/qsub,
        MODULEPATH=/opt/cray/craype/default/modulefiles:/opt/cray/modulefiles:
        /apps/Modules/modulefiles/compilers:/apps/Modules/modulefiles/mpi:/apps
        /Modules/modulefiles/libraries_using_mpi:/apps/Modules/modulefiles/libr
        aries:/apps/Modules/modulefiles/commercial:/apps/Modules/modulefiles/ap
        plications:/apps/Modules/modulefiles/test:/apps/Modules/modulefiles/cra
        y:/apps/Modules/modulefiles/crayadm:,KDEDIRS=/usr,PBS_O_SHELL=/bin/bash,
        SSH_TTY=/dev/pts/66,
        OLDPWD=/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_23_b,
        LOADEDMODULES=craype-network-opa,
        LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=4
        0;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;
        41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01
        ;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=
        01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=0
        1;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31
        :*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:
        *.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31
        :*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;3
        1:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;
        35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01
        ;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng
        =01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.m
        kv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:
        *.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*
        .rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:
        *.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:
        *.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:
        *.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;
        36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;
        36:*.xspf=01;36:,
        SSH_CONNECTION=203.237.172.100 53316 150.183.150.11 22,
        CRAYPE_NETWORK_TARGET=opa,HISTCONTROL=ignoredups,SHLVL=2,
        PWD=/scratch/x1750a01/Stack/DNPNPND/DNPNPND_T_23_s,HOSTNAME=login01,
        LOGNAME=x1750a01,
        _LMFILES_=/opt/cray/craype/default/modulefiles/craype-network-opa,
        BASH_FUNC_module()=() {  eval `/cm/local/apps/environment-modules/3.2.
        10/Modules/$MODULE_VERSION/bin/modulecmd bash $*`; },
        PBS_O_QUEUE=normal,PBS_O_HOST=login01
    comment = Not Running: User has reached queue normal running job limit.
    etime = Thu Mar 21 13:27:11 2019
    run_count = 19
    Submit_arguments = g16.sh
    project = _pbs_project_default

Job Id: 2010604.pbs
    Job_Name = TC_pit_HLLC
    Job_Owner = x1696a07@login03
    job_state = Q
    queue = norm_skl
    server = pbs1
    Checkpoint = u
    ctime = Thu Mar 21 13:27:50 2019
    Error_Path = login03:/scratch/x1696a07/TC12_HLLC/TC_pit_HLLC.e2010604
    Hold_Types = n
    Join_Path = n
    Keep_Files = n
    Mail_Points = a
    mtime = Thu Mar 21 13:27:50 2019
    Output_Path = login03:/scratch/x1696a07/TC12_HLLC/TC_pit_HLLC.o2010604
    Priority = 100
    qtime = Thu Mar 21 13:27:50 2019
    Rerunable = True
    Resource_List.mpiprocs = 160
    Resource_List.ncpus = 160
    Resource_List.nodect = 4
    Resource_List.place = scatter:excl
    Resource_List.qlist = norm_skl
    Resource_List.select = 4:ncpus=40:mpiprocs=40
    Resource_List.walltime = 48:00:00
    substate = 10
    Variable_List = HISTTIMEFORMAT=%y-%m-%d %H:%M:%S,
        MKL_HOME=/apps/compiler/intel/17.0.5/mkl,MODULE_VERSION=3.2.10,
        INTEL_LICENSE_FILE=/cm/shared/licenses/intel,
        KISTI_COMPILER_VER=17.0.5,
        KISTI_APPLIB1=/apps/compiler/intel/17.0.5/applib1,
        KISTI_APPLIB2=/apps/compiler/intel/17.0.5/openmpi/3.1.0/applib2,
        FC=ifort,PBS_O_LANG=en_US.UTF-8,
        BASH_FUNC_module()=() {  eval `/cm/local/apps/environment-modules/3.2.
        10/Modules/$MODULE_VERSION/bin/modulecmd bash $*`; },
        QTDIR=/usr/lib64/qt-3.3,
        LD_LIBRARY_PATH=/apps/compiler/intel/17.0.5/openmpi/3.1.0/lib:/apps/co
        mpiler/intel/17.0.5/debugger/lib/intel64:/apps/compiler/intel/17.0.5/tb
        b/lib/intel64/gcc4.4:/apps/compiler/intel/17.0.5/ipp/lib/intel64:/apps/
        compiler/intel/17.0.5/mkl/lib/intel64:/apps/compiler/intel/17.0.5/lib/i
        ntel64:/opt/cray/lib64:,
        MPICH_HOME=/apps/compiler/intel/17.0.5/openmpi/3.1.0,LANG=en_US.UTF-8,
        QTLIB=/usr/lib64/qt-3.3/lib,SHELL=/bin/bash,
        MPIHOME=/apps/compiler/intel/17.0.5/openmpi/3.1.0,
        SU2_RUN=/home01/x1696a07/SU2/bin,QTINC=/usr/lib64/qt-3.3/include,
        NLSPATH=/apps/compiler/intel/17.0.5/lib/intel64/locale/en_US:/apps/com
        piler/intel/17.0.5/mkl/lib/intel64/locale/en_US,HISTSIZE=20000,
        F90=ifort,PBS_O_WORKDIR=/scratch/x1696a07/TC12_HLLC,
        CRAY_CPU_TARGET=x86-skylake,
        MANPATH=/apps/compiler/intel/17.0.5/man/common:/usr/local/share/man:/u
        sr/share/man/overrides:/usr/share/man:/opt/ddn/ime/share/man:/opt/ddn/i
        me/share/man:/cm/local/apps/environment-modules/current/share/man:/opt/
        pbs/share/man:/apps/compiler/intel/17.0.5/openmpi/3.1.0/share/man,
        COMPILER_PREFIX=/apps/compiler/intel,
        KISTI_COMPILER_HOME=/apps/compiler/intel/17.0.5,PBS_O_SYSTEM=Linux,
        XDG_RUNTIME_DIR=/run/user/604005806,CC=icc,
        PYTHONPATH=:/home01/x1696a07/SU2/bin,PE_PRODUCT_LIST=CRAYPE_BROADWELL,
        QT_GRAPHICSSYSTEM_CHECKED=1,F77=ifort,XDG_SESSION_ID=1145,KDEDIRS=/usr,
        SSH_CONNECTION=210.107.186.171 46990 150.183.150.13 22,
        MKLROOT=/apps/compiler/intel/17.0.5/mkl,CXX=icpc,SSH_TTY=/dev/pts/121,
        HOSTNAME=login03,CRAYPE_NETWORK_TARGET=opa,COMPILER_VER=17.0.5,
        LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=4
        0;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;
        41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01
        ;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=
        01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=0
        1;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31
        :*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:
        *.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31
        :*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;3
        1:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;
        35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01
        ;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng
        =01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.m
        kv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:
        *.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*
        .rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:
        *.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:
        *.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:
        *.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;
        36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;
        36:*.xspf=01;36:,KISTI_MPI_VER=3.1.0,PBS_O_HOME=/home01/x1696a07,
        LESSOPEN=||/usr/bin/lesspipe.sh %s,PBS_O_LOGNAME=x1696a07,
        SSH_CLIENT=210.107.186.171 46990 22,LOGNAME=x1696a07,USER=x1696a07,
        PROMPT_COMMAND=history -a,HOME=/home01/x1696a07,
        PATH=/apps/compiler/intel/17.0.5/openmpi/3.1.0/bin:/apps/compiler/inte
        l/17.0.5/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/usr/local/s
        bin:/usr/sbin:/opt/ddn/ime/bin:/cm/local/apps/environment-modules/3.2.1
        0/bin:/opt/pbs/bin:/home01/x1696a07/SU2/bin:/home01/x1696a07/.local/bin
        :/home01/x1696a07/bin,SU2_HOME=/home01/x1696a07/SU2-6.1.0,
        COMPILER=intel,
        KISTI_MPI_HOME=/apps/compiler/intel/17.0.5/openmpi/3.1.0,TERM=xterm,
        ENABLE_LMOD=0,MPI_VER=3.1.0,SHLVL=2,DISPLAY=localhost:27.0,
        PBS_O_PATH=/apps/compiler/intel/17.0.5/openmpi/3.1.0/bin:/apps/compile
        r/intel/17.0.5/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/usr/l
        ocal/sbin:/usr/sbin:/opt/ddn/ime/bin:/cm/local/apps/environment-modules
        /3.2.10/bin:/opt/pbs/bin:/home01/x1696a07/SU2/bin:/home01/x1696a07/.loc
        al/bin:/home01/x1696a07/bin,
        MODULESHOME=/cm/local/apps/environment-modules/3.2.10/Modules/3.2.10,
        MODULE_VERSION_STACK=3.2.10,
        QT_PLUGIN_PATH=/usr/lib64/kde4/plugins:/usr/lib/kde4/plugins,
        MPI_ROOT=/apps/compiler/intel/17.0.5/openmpi/3.1.0,
        MPI_HOME=/apps/compiler/intel/17.0.5/openmpi/3.1.0,
        MAIL=/var/spool/mail/x1696a07,PBS_O_MAIL=/var/spool/mail/x1696a07,
        _=/opt/pbs/bin/qsub,
        MODULEPATH=/opt/cray/craype/default/modulefiles:/opt/cray/modulefiles:
        /apps/Modules/modulefiles/compilers:/apps/Modules/modulefiles/mpi:/apps
        /Modules/modulefiles/libraries_using_mpi:/apps/Modules/modulefiles/libr
        aries:/apps/Modules/modulefiles/commercial:/apps/Modules/modulefiles/ap
        plications:/apps/Modules/modulefiles/test:/apps/Modules/modulefiles/cra
        y:/apps/Modules/modulefiles/crayadm:,PBS_O_SHELL=/bin/bash,
        FORTRAN_TYPE=ifort,OLDPWD=/scratch/x1696a07/TC12_HLLC_v2,
        LOADEDMODULES=craype-network-opa:craype-x86-skylake:intel/17.0.5:openm
        pi/3.1.0,MPI=openmpi,HISTCONTROL=ignoredups,
        PWD=/scratch/x1696a07/TC12_HLLC,
        _LMFILES_=/opt/cray/craype/default/modulefiles/craype-network-opa:/opt
        /cray/craype/default/modulefiles/craype-x86-skylake:/apps/Modules/modul
        efiles/compilers/intel/17.0.5:/apps/Modules/modulefiles/mpi/openmpi/3.1
        .0,PBS_O_QUEUE=norm_skl,PBS_O_HOST=login03
    comment = Not Running: No available resources on nodes
    etime = Thu Mar 21 13:27:50 2019
    run_count = 19
    Submit_arguments = mpi.sh
    project = _pbs_project_default

Job Id: 2010608.pbs
    Job_Name = MAPI_TETRA
    Job_Owner = x1681a05@login01
    resources_used.cpupercent = 953
    resources_used.cput = 01:04:54
    resources_used.mem = 5124872kb
    resources_used.ncpus = 2176
    resources_used.vmem = 15727156kb
    resources_used.walltime = 00:04:15
    job_state = R
    queue = normal
    server = pbs1
    Checkpoint = u
    ctime = Thu Mar 21 13:29:37 2019
    Error_Path = login01:/scratch/x1681a05/perov/02.MAPI_tetra/exp/soi/MAPI_TET
        RA.e2010608
    exec_host = node3061/0*68+node3252/0*68+node3333/0*68+node3412/0*68+node341
        9/0*68+node4169/0*68+node4170/0*68+node4174/0*68+node4177/0*68+node4321
        /0*68+node4322/0*68+node4324/0*68+node4325/0*68+node4326/0*68+node4327/
        0*68+node4328/0*68+node4329/0*68+node4330/0*68+node4331/0*68+node4332/0
        *68+node4333/0*68+node4334/0*68+node4335/0*68+node4336/0*68+node4337/0*
        68+node4338/0*68+node4339/0*68+node4340/0*68+node4341/0*68+node4342/0*6
        8+node4343/0*68+node4344/0*68
    exec_vnode = (node3061:ncpus=68)+(node3252:ncpus=68)+(node3333:ncpus=68)+(n
        ode3412:ncpus=68)+(node3419:ncpus=68)+(node4169:ncpus=68)+(node4170:ncp
        us=68)+(node4174:ncpus=68)+(node4177:ncpus=68)+(node4321:ncpus=68)+(nod
        e4322:ncpus=68)+(node4324:ncpus=68)+(node4325:ncpus=68)+(node4326:ncpus
        =68)+(node4327:ncpus=68)+(node4328:ncpus=68)+(node4329:ncpus=68)+(node4
        330:ncpus=68)+(node4331:ncpus=68)+(node4332:ncpus=68)+(node4333:ncpus=6
        8)+(node4334:ncpus=68)+(node4335:ncpus=68)+(node4336:ncpus=68)+(node433
        7:ncpus=68)+(node4338:ncpus=68)+(node4339:ncpus=68)+(node4340:ncpus=68)
        +(node4341:ncpus=68)+(node4342:ncpus=68)+(node4343:ncpus=68)+(node4344:
        ncpus=68)
    Hold_Types = n
    Join_Path = n
    Keep_Files = n
    Mail_Points = a
    mtime = Thu Mar 21 13:29:46 2019
    Output_Path = login01:/scratch/x1681a05/perov/02.MAPI_tetra/exp/soi/MAPI_TE
        TRA.o2010608
    Priority = 100
    qtime = Thu Mar 21 13:29:38 2019
    Rerunable = True
    Resource_List.knl_cluster_mode = quadrant
    Resource_List.knl_memory_mode = cache
    Resource_List.mpiprocs = 512
    Resource_List.ncpus = 2176
    Resource_List.nodect = 32
    Resource_List.place = scatter:excl
    Resource_List.qlist = normal
    Resource_List.select = 32:ncpus=68:mpiprocs=16:ompthreads=4
    Resource_List.walltime = 24:00:00
    stime = Thu Mar 21 13:29:42 2019
    session_id = 6615
    jobdir = /home01/x1681a05
    substate = 42
    Variable_List = HISTTIMEFORMAT=%y-%m-%d %H:%M:%S,
        _fzf_orig_completion_ld=complete -F %s ld #_longopt,
        LS_COLORS=rs=0:di=38;5;27:ln=38;5;51:mh=44;38;5;15:pi=40;38;5;11:so=38
        ;5;13:do=38;5;5:bd=48;5;232;38;5;11:cd=48;5;232;38;5;3:or=48;5;232;38;5
        ;9:mi=05;48;5;232;38;5;15:su=48;5;196;38;5;15:sg=48;5;11;38;5;16:ca=48;
        5;196;38;5;226:tw=48;5;10;38;5;16:ow=48;5;10;38;5;21:st=48;5;21;38;5;15
        :ex=38;5;34:*.tar=38;5;9:*.tgz=38;5;9:*.arc=38;5;9:*.arj=38;5;9:*.taz=3
        8;5;9:*.lha=38;5;9:*.lz4=38;5;9:*.lzh=38;5;9:*.lzma=38;5;9:*.tlz=38;5;9
        :*.txz=38;5;9:*.tzo=38;5;9:*.t7z=38;5;9:*.zip=38;5;9:*.z=38;5;9:*.Z=38;
        5;9:*.dz=38;5;9:*.gz=38;5;9:*.lrz=38;5;9:*.lz=38;5;9:*.lzo=38;5;9:*.xz=
        38;5;9:*.bz2=38;5;9:*.bz=38;5;9:*.tbz=38;5;9:*.tbz2=38;5;9:*.tz=38;5;9:
        *.deb=38;5;9:*.rpm=38;5;9:*.jar=38;5;9:*.war=38;5;9:*.ear=38;5;9:*.sar=
        38;5;9:*.rar=38;5;9:*.alz=38;5;9:*.ace=38;5;9:*.zoo=38;5;9:*.cpio=38;5;
        9:*.7z=38;5;9:*.rz=38;5;9:*.cab=38;5;9:*.jpg=38;5;13:*.jpeg=38;5;13:*.g
        if=38;5;13:*.bmp=38;5;13:*.pbm=38;5;13:*.pgm=38;5;13:*.ppm=38;5;13:*.tg
        a=38;5;13:*.xbm=38;5;13:*.xpm=38;5;13:*.tif=38;5;13:*.tiff=38;5;13:*.pn
        g=38;5;13:*.svg=38;5;13:*.svgz=38;5;13:*.mng=38;5;13:*.pcx=38;5;13:*.mo
        v=38;5;13:*.mpg=38;5;13:*.mpeg=38;5;13:*.m2v=38;5;13:*.mkv=38;5;13:*.we
        bm=38;5;13:*.ogm=38;5;13:*.mp4=38;5;13:*.m4v=38;5;13:*.mp4v=38;5;13:*.v
        ob=38;5;13:*.qt=38;5;13:*.nuv=38;5;13:*.wmv=38;5;13:*.asf=38;5;13:*.rm=
        38;5;13:*.rmvb=38;5;13:*.flc=38;5;13:*.avi=38;5;13:*.fli=38;5;13:*.flv=
        38;5;13:*.gl=38;5;13:*.dl=38;5;13:*.xcf=38;5;13:*.xwd=38;5;13:*.yuv=38;
        5;13:*.cgm=38;5;13:*.emf=38;5;13:*.axv=38;5;13:*.anx=38;5;13:*.ogv=38;5
        ;13:*.ogx=38;5;13:*.aac=38;5;45:*.au=38;5;45:*.flac=38;5;45:*.mid=38;5;
        45:*.midi=38;5;45:*.mka=38;5;45:*.mp3=38;5;45:*.mpc=38;5;45:*.ogg=38;5;
        45:*.ra=38;5;45:*.wav=38;5;45:*.axa=38;5;45:*.oga=38;5;45:*.spx=38;5;45
        :*.xspf=38;5;45:,_fzf_orig_completion_ln=complete -F %s ln #_longopt,
        KISTI_APPLIB1=/apps/compiler/intel/17.0.5/applib1,
        KISTI_APPLIB2=/apps/compiler/intel/17.0.5/impi/2017.4.239/applib2,
        _fzf_orig_completion_emacs=complete -F %s emacs #_filedir_xspec,
        PBS_O_LANG=ko_KR.UTF-8,
        _fzf_orig_completion_ls=complete -F %s ls #_longopt,
        QT_GRAPHICSSYSTEM_CHECKED=1,
        _fzf_orig_completion_diff=complete -F %s diff #_longopt,
        SHELL=/bin/bash,
        _fzf_orig_completion_tail=complete -F %s tail #_longopt,
        _fzf_orig_completion_sed=complete -F %s sed #_longopt,F77=ifort,
        HISTSIZE=20000,CRAY_CPU_TARGET=mic-knl,
        MANPATH=/apps/compiler/intel/17.0.5/impi/2017.4.239/applib2/mic-knl/ne
        tcdf-hdf5-parallel/4.6.1/share/man:/apps/compiler/intel/17.0.5/impi/201
        7.4.239/applib2/mic-knl/hdf5-parallel/1.10.2/share/man:/apps/compiler/i
        ntel/17.0.5/impi/2017.4.239/applib2/mic-knl/fftw_mpi/3.3.7/share/man:/c
        m/shared/apps/intel/compilers_and_libraries/2017.5.239/linux/mpi/man:/a
        pps/compiler/intel/17.0.5/man/common:/usr/local/share/man:/usr/share/ma
        n/overrides:/usr/share/man:/opt/ddn/ime/share/man:/opt/ddn/ime/share/ma
        n:/cm/local/apps/environment-modules/current/share/man:/opt/pbs/share/m
        an:/apps/compiler/intel/17.0.5/impi/2017.4.239/man,
        SIESTA=/home01/x1681a05/siesta/4.1-b3/Obj/siesta,
        COMPILER_PREFIX=/apps/compiler/intel,
        _fzf_orig_completion_du=complete -F %s du #_longopt,
        XDG_RUNTIME_DIR=/run/user/604004304,
        _fzf_orig_completion_git=complete -o bashdefault -o default -o nospace
         -F %s git #__git_wrap__git_main,PYTHONPATH=/home01/x1681a05/scripts:,
        _fzf_orig_completion_mv=complete -F %s mv #_longopt,
        _fzf_orig_completion_bunzip2=complete -F %s bunzip2 #_filedir_xspec,
        PE_PRODUCT_LIST=CRAYPE_MIC-KNL,
        _fzf_orig_completion_cat=complete -F %s cat #_longopt,
        XDG_SESSION_ID=4712,
        _fzf_orig_completion_telnet=complete -F %s telnet #_known_hosts,
        MKLROOT=/cm/shared/apps/intel/compilers_and_libraries/2017.5.239/linux
        /mkl,CXX=icpc,HOSTNAME=login01,
        PMG_VASP_PSP_DIR=/home01/x1681a05/vasp/pmg_pot,
        CRAYPE_NETWORK_TARGET=opa,
        SSH_CONNECTION=165.132.197.238 53465 150.183.150.11 22,
        CONDA_PYTHON_EXE=/apps/applications/PYTHON/3.7/bin/python,
        LESSOPEN=||/usr/bin/lesspipe.sh %s,PBS_O_LOGNAME=x1681a05,
        CPATH=/cm/shared/apps/intel/compilers_and_libraries/2017.5.239/linux/m
        kl/include,USER=x1681a05,PROMPT_COMMAND=history -a,HOME=/home01/x1681a05,
        _fzf_orig_completion_sort=complete -F %s sort #_longopt,
        COMPILER=intel,
        _fzf_orig_completion_gvim=complete -F %s gvim #_filedir_xspec,SHLVL=2,
        _fzf_orig_completion_unzip=complete -F %s unzip #_filedir_xspec,
        MIC_LD_LIBRARY_PATH=/cm/shared/apps/intel/compilers_and_libraries/2017
        .5.239/linux/tbb/lib/intel64_lin_mic:/cm/shared/apps/intel/compilers_an
        d_libraries/2017.5.239/linux/compiler/lib/intel64_lin_mic:/cm/shared/ap
        ps/intel/compilers_and_libraries/2017.5.239/linux/mkl/lib/intel64_lin_m
        ic,
        PBS_O_PATH=/home01/x1681a05/bin:/home01/x1681a05/.conda/envs/default/b
        in:/apps/applications/SIESTA/4.1-b3/intel/17.0.5/impi/17.0.5/mic-knl:/a
        pps/compiler/intel/17.0.5/impi/2017.4.239/applib2/mic-knl/netcdf-hdf5-p
        arallel/4.6.1/bin:/apps/compiler/intel/17.0.5/impi/2017.4.239/applib2/m
        ic-knl/hdf5-parallel/1.10.2/bin:/apps/compiler/intel/17.0.5/impi/2017.4
        .239/applib2/mic-knl/fftw_mpi/3.3.7/bin:/cm/shared/apps/intel/compilers
        _and_libraries/2017.5.239/linux/mpi/intel64/bin:/apps/applications/PYTH
        ON/3.7/bin:/apps/compiler/intel/17.0.5/impi/2017.4.239/bin64:/apps/comp
        iler/intel/17.0.5/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/us
        r/local/sbin:/usr/sbin:/opt/ddn/ime/bin:/cm/local/apps/environment-modu
        les/3.2.10/bin:/opt/pbs/bin:/home01/x1681a05/.fzf/bin:/home01/x1681a05/
        .local/bin:/home01/x1681a05/bin,
        PHDF5=/apps/compiler/intel/17.0.5/impi/2017.4.239/applib2/mic-knl/hdf5
        -parallel/1.10.2,
        MODULESHOME=/cm/local/apps/environment-modules/3.2.10/Modules/3.2.10,
        SSH_AUTH_SOCK=/tmp/ssh-2aUfgOjd35/agent.250835,
        QT_PLUGIN_PATH=/usr/lib64/kde4/plugins:/usr/lib/kde4/plugins,
        CLASSPATH=/cm/shared/apps/intel/compilers_and_libraries/2017.5.239/lin
        ux/mpi/intel64/lib/mpi.jar,
        _fzf_orig_completion_rm=complete -F %s rm #_longopt,
        MAIL=/var/spool/mail/x1681a05,PBS_O_MAIL=/var/spool/mail/x1681a05,
        _=/opt/pbs/bin/qsub,
        MIC_LIBRARY_PATH=/cm/shared/apps/intel/compilers_and_libraries/2017.5.
        239/linux/tbb/lib/intel64_lin_mic:/cm/shared/apps/intel/compilers_and_l
        ibraries/2017.5.239/linux/compiler/lib/intel64_lin_mic:/cm/shared/apps/
        intel/compilers_and_libraries/2017.5.239/linux/mkl/lib/intel64_lin_mic,
        PBS_O_SHELL=/bin/bash,I_MPI_EXTRA_FILESYSTEM_LIST=lustre,
        FORTRAN_TYPE=ifort,MPI=impi,
        _fzf_orig_completion_cp=complete -F %s cp #_longopt,
        MKL_HOME=/apps/compiler/intel/17.0.5/mkl,MODULE_VERSION=3.2.10,
        INTEL_LICENSE_FILE=/cm/shared/licenses/intel,
        KISTI_COMPILER_VER=17.0.5,FC=ifort,
        _fzf_orig_completion_wc=complete -F %s wc #_longopt,
        QTDIR=/usr/lib64/qt-3.3,
        LD_LIBRARY_PATH=/apps/compiler/intel/17.0.5/impi/2017.4.239/applib2/mi
        c-knl/netcdf-hdf5-parallel/4.6.1/lib:/apps/compiler/intel/17.0.5/impi/2
        017.4.239/applib2/mic-knl/hdf5-parallel/1.10.2/lib:/apps/compiler/intel
        /17.0.5/impi/2017.4.239/applib2/mic-knl/fftw_mpi/3.3.7/lib:/cm/shared/a
        pps/intel/compilers_and_libraries/2017.5.239/linux/tbb/lib/intel64_lin/
        gcc4.7:/cm/shared/apps/intel/compilers_and_libraries/2017.5.239/linux/c
        ompiler/lib/intel64_lin_mic:/cm/shared/apps/intel/compilers_and_librari
        es/2017.5.239/linux/mkl/lib/intel64_lin_mic:/cm/shared/apps/intel/compi
        lers_and_libraries/2017.5.239/linux/tbb/lib/intel64_lin_mic:/cm/shared/
        apps/intel/compilers_and_libraries/2017.5.239/linux/compiler/lib/intel6
        4_lin:/cm/shared/apps/intel/compilers_and_libraries/2017.5.239/linux/mk
        l/lib/intel64_lin:/cm/shared/apps/intel/compilers_and_libraries/2017.5.
        239/linux/mpi/intel64/lib:/cm/shared/apps/intel/compilers_and_libraries
        /2017.5.239/linux/mpi/mic/lib:/apps/compiler/intel/17.0.5/impi/2017.4.2
        39/lib64:/apps/compiler/intel/17.0.5/debugger/lib/intel64:/apps/compile
        r/intel/17.0.5/tbb/lib/intel64/gcc4.4:/apps/compiler/intel/17.0.5/ipp/l
        ib/intel64:/apps/compiler/intel/17.0.5/mkl/lib/intel64:/apps/compiler/i
        ntel/17.0.5/lib/intel64:/opt/cray/lib64:/usr/lib64:/apps/applications/P
        YTHON/3.7/lib,MPICH_HOME=/apps/compiler/intel/17.0.5/impi/2017.4.239,
        LANG=ko_KR.UTF-8,QTLIB=/usr/lib64/qt-3.3/lib,CONDA_SHLVL=1,
        LIBRARY_PATH=/cm/shared/apps/intel/compilers_and_libraries/2017.5.239/
        linux/tbb/lib/intel64_lin/gcc4.7:/cm/shared/apps/intel/compilers_and_li
        braries/2017.5.239/linux/compiler/lib/intel64_lin:/cm/shared/apps/intel
        /compilers_and_libraries/2017.5.239/linux/mkl/lib/intel64_lin,
        MPIHOME=/apps/compiler/intel/17.0.5/impi/2017.4.239,
        QTINC=/usr/lib64/qt-3.3/include,
        CONDA_PREFIX=/home01/x1681a05/.conda/envs/default,
        _fzf_orig_completion_ftp=complete -F %s ftp #_known_hosts,F90=ifort,
        PBS_O_WORKDIR=/scratch/x1681a05/perov/02.MAPI_tetra/exp/soi,
        CONDA_DEFAULT_ENV=default,
        MODULEPATH=/opt/cray/craype/default/modulefiles:/opt/cray/modulefiles:
        /apps/Modules/modulefiles/compilers:/apps/Modules/modulefiles/mpi:/apps
        /Modules/modulefiles/libraries_using_mpi:/apps/Modules/modulefiles/libr
        aries:/apps/Modules/modulefiles/commercial:/apps/Modules/modulefiles/ap
        plications:/apps/Modules/modulefiles/test:/apps/Modules/modulefiles/cra
        y:/apps/Modules/modulefiles/crayadm:,
        KISTI_COMPILER_HOME=/apps/compiler/intel/17.0.5,PBS_O_SYSTEM=Linux,
        CC=icc,_fzf_orig_completion_awk=complete -F %s awk #_longopt,
        BASH_FUNC_module()=() {  eval `/cm/local/apps/environment-modules/3.2.
        10/Modules/$MODULE_VERSION/bin/modulecmd bash $*`; },
        NLSPATH=/cm/shared/apps/intel/compilers_and_libraries/2017.5.239/linux
        /mkl/lib/intel64_lin_mic/locale/%l_%t/%N:/cm/shared/apps/intel/compiler
        s_and_libraries/2017.5.239/linux/mkl/lib/intel64_lin/locale/%l_%t/%N:/a
        pps/compiler/intel/17.0.5/lib/intel64/locale/en_US:/apps/compiler/intel
        /17.0.5/mkl/lib/intel64/locale/en_US,KDEDIRS=/usr,SSH_TTY=/dev/pts/89,
        COMPILER_VER=17.0.5,
        _fzf_orig_completion_uniq=complete -F %s uniq #_longopt,
        KISTI_MPI_VER=17.0.5,
        _fzf_orig_completion_rmdir=complete -F %s rmdir #_longopt,
        PBS_O_HOME=/home01/x1681a05,SSH_CLIENT=165.132.197.238 53465 22,
        LOGNAME=x1681a05,
        _fzf_orig_completion_tee=complete -F %s tee #_longopt,
        PATH=/home01/x1681a05/bin:/home01/x1681a05/.conda/envs/default/bin:/ap
        ps/applications/SIESTA/4.1-b3/intel/17.0.5/impi/17.0.5/mic-knl:/apps/co
        mpiler/intel/17.0.5/impi/2017.4.239/applib2/mic-knl/netcdf-hdf5-paralle
        l/4.6.1/bin:/apps/compiler/intel/17.0.5/impi/2017.4.239/applib2/mic-knl
        /hdf5-parallel/1.10.2/bin:/apps/compiler/intel/17.0.5/impi/2017.4.239/a
        pplib2/mic-knl/fftw_mpi/3.3.7/bin:/cm/shared/apps/intel/compilers_and_l
        ibraries/2017.5.239/linux/mpi/intel64/bin:/apps/applications/PYTHON/3.7
        /bin:/apps/compiler/intel/17.0.5/impi/2017.4.239/bin64:/apps/compiler/i
        ntel/17.0.5/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/usr/loca
        l/sbin:/usr/sbin:/opt/ddn/ime/bin:/cm/local/apps/environment-modules/3.
        2.10/bin:/opt/pbs/bin:/home01/x1681a05/.fzf/bin:/home01/x1681a05/.local
        /bin:/home01/x1681a05/bin,
        _fzf_orig_completion_cd=complete -o nospace -F %s cd #_cd,
        _fzf_orig_completion_view=complete -F %s view #_filedir_xspec,
        KISTI_MPI_HOME=/apps/compiler/intel/17.0.5/impi/2017.4.239,
        TERM=xterm-256color,ENABLE_LMOD=0,MPI_VER=2017.4.239,
        _fzf_orig_completion_vim=complete -F %s vim #_filedir_xspec,
        PWD=/scratch/x1681a05/perov/02.MAPI_tetra/exp/soi,
        PNETCDF4=/apps/compiler/intel/17.0.5/impi/2017.4.239/applib2/mic-knl/n
        etcdf-hdf5-parallel/4.6.1,MODULE_VERSION_STACK=3.2.10,
        _fzf_orig_completion_head=complete -F %s head #_longopt,
        _fzf_orig_completion_less=complete -F %s less #_longopt,
        MPI_ROOT=/apps/compiler/intel/17.0.5/impi/2017.4.239,
        MPI_HOME=/apps/compiler/intel/17.0.5/impi/2017.4.239,
        I_MPI_ROOT=/cm/shared/apps/intel/compilers_and_libraries/2017.5.239/li
        nux/mpi,CONDA_PROMPT_MODIFIER=(default),
        _fzf_orig_completion_vi=complete -F %s vi #_filedir_xspec,
        _fzf_orig_completion_grep=complete -F %s grep #_longopt,
        _LMFILES_=/opt/cray/craype/default/modulefiles/craype-network-opa:/app
        s/Modules/modulefiles/compilers/intel/17.0.5:/apps/Modules/modulefiles/
        mpi/impi/17.0.5:/opt/cray/craype/default/modulefiles/craype-mic-knl:/ap
        ps/Modules/modulefiles/applications/python/3.7:/apps/Modules/modulefile
        s/libraries_using_mpi/fftw_mpi/3.3.7:/apps/Modules/modulefiles/librarie
        s_using_mpi/hdf5-parallel/1.10.2:/apps/Modules/modulefiles/libraries_us
        ing_mpi/netcdf-hdf5-parallel/4.6.1:/apps/Modules/modulefiles/applicatio
        ns/siesta/4.1-b3,DISPLAY=localhost:25.0,
        OLDPWD=/scratch/x1681a05/perov/02.MAPI_tetra/exp,
        LOADEDMODULES=craype-network-opa:intel/17.0.5:impi/17.0.5:craype-mic-k
        nl:python/3.7:fftw_mpi/3.3.7:hdf5-parallel/1.10.2:netcdf-hdf5-parallel/
        4.6.1:siesta/4.1-b3,
        _fzf_orig_completion_gunzip=complete -F %s gunzip #_filedir_xspec,
        HISTCONTROL=ignoredups,I_MPI_EXTRA_FILESYSTEM=on,
        IMPI_VERSION=2017.4.239,
        CONDA_EXE=/apps/applications/PYTHON/3.7/bin/conda,PBS_O_QUEUE=normal,
        PBS_O_HOST=login01
    comment = Job run at Thu Mar 21 at 13:29 on (node3061:ncpus=68)+(node3252:n
        cpus=68)+(node3333:ncpus=68)+(node3412:ncpus=68)+(node3419:ncpus=68)+(n
        ode4169:ncpus=68)+(node4170:ncpus=68)+(node4174:ncpus=68)+(node4177:ncp
        us=68)+(node4321:ncpus=68)+(node4322:ncpus=68...
    etime = Thu Mar 21 13:29:38 2019
    run_count = 20
    Submit_arguments = qjob
    project = _pbs_project_default

Job Id: 2010610.pbs
    Job_Name = intel_mic
    Job_Owner = g121a02@login03
    resources_used.cpupercent = 15283
    resources_used.cput = 13:06:20
    resources_used.mem = 171892280kb
    resources_used.ncpus = 576
    resources_used.vmem = 81114280kb
    resources_used.walltime = 00:03:21
    job_state = R
    queue = normal
    server = pbs1
    Checkpoint = u
    ctime = Thu Mar 21 13:30:43 2019
    Error_Path = login03:/scratch/g121a02/cesm_exp/intel_mic/intel_mic.e2010610

    exec_host = node2878/0*64+node2968/0*64+node3044/0*64+node3050/0*64+node310
        6/0*64+node3120/0*64+node3121/0*64+node3123/0*64+node3162/0*64
    exec_vnode = (node2878:ncpus=64)+(node2968:ncpus=64)+(node3044:ncpus=64)+(n
        ode3050:ncpus=64)+(node3106:ncpus=64)+(node3120:ncpus=64)+(node3121:ncp
        us=64)+(node3123:ncpus=64)+(node3162:ncpus=64)
    Hold_Types = n
    Join_Path = oe
    Keep_Files = n
    Mail_Points = abe
    Mail_Users = js-shin@yonsei.ac.kr
    mtime = Thu Mar 21 13:30:48 2019
    Output_Path = login03:/scratch/g121a02/cesm_exp/intel_mic/intel_mic.o201061
        0
    Priority = 100
    qtime = Thu Mar 21 13:30:43 2019
    Rerunable = True
    Resource_List.knl_cluster_mode = quadrant
    Resource_List.knl_memory_mode = cache
    Resource_List.mpiprocs = 576
    Resource_List.ncpus = 576
    Resource_List.nodect = 9
    Resource_List.place = scatter:excl
    Resource_List.qlist = normal
    Resource_List.select = 9:ncpus=64:mpiprocs=64:ompthreads=1
    Resource_List.walltime = 40:00:00
    stime = Thu Mar 21 13:30:46 2019
    session_id = 4184
    Shell_Path_List = /usr/bin/csh
    jobdir = /home01/g121a02
    substate = 42
    Variable_List = PIO_NUMTASKS=-1,TIMER_LEVEL=12,PSTRID_OCN=1,
        ATM_PIO_TYPENAME=nothing,
        KISTI_APPLIB1=/apps/compiler/intel/18.0.3/applib1,
        KISTI_APPLIB2=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2,
        GLC_NX=288,
        ROF2LND_FMAPNAME=lnd/clm2/mappingdata/maps/0.9x1.25/map_0.5x0.5_nomask
        _to_0.9x1.25_nomask_aave_da_c121019.nc,PBS_O_LANG=en_US.UTF-8,
        CLM_NML_USE_CASE=1850_control,PIO_BLOCKSIZE=-1,
        ATM_DOMAIN_PATH=/scratch/g121a02/inputdata/share/domains,
        DOUT_S_SAVE_ALL_ON_DISK=FALSE,OCN_GRID=gx1v6,BUILD_COMPLETE=TRUE,
        CCSM_GCOST=0,F77=ifort,PSTRID_ICE=1,HISTSIZE=20000,
        OCN_CHL_TYPE=diagnostic,VECT_MAP=cart3d,
        MANPATH=/apps/compiler/intel/18.0.3/applib1/mic-knl/CDO/1.8.2/share/ma
        n:/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl/netcdf-hdf5
        -parallel/4.6.1/share/man:/apps/compiler/intel/18.0.3/openmpi/3.1.0/app
        lib2/mic-knl/hdf5-parallel/1.10.2/share/man:/apps/compiler/intel/18.0.3
        /man/common:/usr/local/share/man:/usr/share/man/overrides:/usr/share/ma
        n:/opt/ddn/ime/share/man:/opt/ddn/ime/share/man:/cm/local/apps/environm
        ent-modules/current/share/man:/opt/pbs/share/man:/apps/compiler/intel/1
        8.0.3/openmpi/3.1.0/share/man:/opt/ddn/ime/share/man:/cm/local/apps/env
        ironment-modules/current/share/man:/opt/pbs/share/man,
        OCN_TAVG_HIFREQ=FALSE,PSTRID_WAV=1,CICE_AUTO_DECOMP=true,
        LND2ATM_SMAPNAME=idmap,CCSM_CO2_PPMV=284.7,
        ROF2OCN_RMAPNAME=cpl/cpl6/map_r05_to_gx1v6_e1000r300_090226.nc,
        ROF_GRID=r05,PIO_CONFIG_OPTS=,GLC_NY=192,ATM_NX=288,XDG_SESSION_ID=4976,
        RUN_REFCASE=b40_1850_1d_b08c5cn_138j,
        NETCDF_LDFLAGS=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-k
        nl/netcdf-hdf5-parallel/4.6.1/lib,BUILD_STATUS=0,
        SMP_VALUE=a0l0r0i0o0g0w0c0,MKLROOT=/apps/compiler/intel/18.0.3/mkl,
        HOSTNAME=login03,DOUT_S_SAVE_INT_REST_FILES=FALSE,CCSM_TCOST=0,
        RESUBMIT=0,GLC_NCPL=1,OCN_NY=384,MACHTYPE=x86_64,GLC_PIO_NUMTASKS=-99,
        CPL_PIO_NUMTASKS=-99,
        ATM2OCN_FMAPNAME=cpl/gridmaps/fv0.9x1.25/map_fv0.9x1.25_TO_gx1v6_aave.
        130322.nc,POP_NY_BLOCKS=8,CESMSCRATCHROOT=UNSET,GROUP=rc0003,COST_PES=0,
        LND_PIO_STRIDE=-99,LND_NY=192,LND_NX=288,REST_N=1,
        PIO_ASYNC_INTERFACE=FALSE,LESSOPEN=||/usr/bin/lesspipe.sh %s,
        USER=g121a02,NINST_OCN=1,ICE2WAV_SMAPNAME=idmap,COMPILER=intel21,
        COMP_OCN=pop2,WAV_PIO_ROOT=-99,SMP_BUILD=a0l0r0i0o0g0w0c0,
        POP_NX_BLOCKS=8,NINST_GLC=1,PSTRID_GLC=1,INFO_DBUG=1,
        OCN_CO2_TYPE=constant,
        PHDF5=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl/hdf5-p
        arallel/1.10.2,NINST_ICE=1,MAX_TASKS_PER_NODE=64,
        CODEROOT=/home01/g121a02/cesm1_2_2/models,
        MODULESHOME=/cm/local/apps/environment-modules/3.2.10/Modules/3.2.10,
        ICE_PIO_NUMTASKS=-99,HIST_N=-999,CCSM_SCOMPSET=UNSET,AVGHIST_DATE=-999,
        QT_PLUGIN_PATH=/usr/lib64/kde4/plugins:/usr/lib/kde4/plugins,
        CAM_DYCORE=fv,ROF_NX=720,BATCHQUERY=qstat -a,OCN_TRACER_MODULES= iage,
        ROF_NY=360,OBJROOT=/scratch/g121a02/cesm_exp/intel_mic/bld,
        CICE_NAMELIST_OPTS=cam5=.true.,CCSM_MCOST=0,NINST_WAV=1,
        CONTINUE_RUN=FALSE,DEBUG=FALSE,EPS_OAREA=1.0e-01,
        CLM_FORCE_COLDSTART=off,PBS_O_SHELL=/bin/bash,CPL_PIO_TYPENAME=nothing,
        ROF_PIO_STRIDE=-99,SUPPORTED_BY=js-shin@yonsei.ac.kr,PIO_ROOT=1,
        ROF_PIO_TYPENAME=nothing,MPILIB=openmpi,
        _LMFILES_=/opt/cray/craype/default/modulefiles/craype-network-opa:/opt
        /cray/craype/default/modulefiles/craype-mic-knl:/apps/Modules/modulefil
        es/applications/cmake/3.12.3:/apps/Modules/modulefiles/compilers/intel/
        18.0.3:/apps/Modules/modulefiles/mpi/openmpi/3.1.0:/apps/Modules/module
        files/libraries_using_mpi/hdf5-parallel/1.10.2:/apps/Modules/modulefile
        s/libraries_using_mpi/netcdf-hdf5-parallel/4.6.1:/apps/Modules/modulefi
        les/applications/subversion/1.7.19:/apps/Modules/modulefiles/libraries/
        lapack/3.7.0:/apps/Modules/modulefiles/libraries/CDO/1.8.2,
        MPICH_MAX_SHORT_MSG_SIZE=8000,
        LND2ROF_FMAPNAME=lnd/clm2/mappingdata/maps/0.9x1.25/map_0.9x1.25_nomas
        k_to_0.5x0.5_nomask_aave_da_c120522.nc,MODULE_VERSION=3.2.10,
        NINST_LND_LAYOUT=concurrent,DOUT_S_SAVE_ROOT=UNSET,
        CASEROOT=/scratch/g121a02/cesm_exp/intel_mic,
        DOUT_L_HPSS_ACCNT=00000000,ICE_NCPL=48,NTHRDS_WAV=1,NTASKS_WAV=1,
        OCN_PIO_ROOT=0,RUN_REFDATE=0320-01-01,FC=ifort,CICE_BLCKY=6,
        QTDIR=/usr/lib64/qt-3.3,GLC_DOMAIN_FILE=UNSET,
        LD_LIBRARY_PATH=/apps/compiler/intel/18.0.3/applib1/mic-knl/CDO/1.8.2/
        lib:/apps/compiler/intel/18.0.3/applib1/mic-knl/lapack/3.7.0:/apps/comp
        iler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl/netcdf-hdf5-parallel/4.
        6.1/lib:/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl/hdf5-
        parallel/1.10.2/lib:/apps/compiler/intel/18.0.3/openmpi/3.1.0/lib:/apps
        /compiler/intel/18.0.3/debugger/lib/intel64:/apps/compiler/intel/18.0.3
        /tbb/lib/intel64/gcc4.4:/apps/compiler/intel/18.0.3/ipp/lib/intel64:/ap
        ps/compiler/intel/18.0.3/mkl/lib/intel64:/apps/compiler/intel/18.0.3/li
        b/intel64:/opt/cray/lib64:,
        MPICH_HOME=/apps/compiler/intel/18.0.3/openmpi/3.1.0,CASE=intel_mic,
        QTLIB=/usr/lib64/qt-3.3/lib,PES_PER_NODE=64,
        LND_DOMAIN_FILE=domain.lnd.fv0.9x1.25_gx1v6.090309.nc,
        QTINC=/usr/lib64/qt-3.3/include,GLC_PIO_ROOT=-99,ROF_NCPL=8,F90=ifort,
        DIN_LOC_ROOT=/scratch/g121a02/inputdata,OCN_PIO_NUMTASKS=-99,
        MODULEPATH=/opt/cray/craype/default/modulefiles:/opt/cray/modulefiles:
        /apps/Modules/modulefiles/compilers:/apps/Modules/modulefiles/mpi:/apps
        /Modules/modulefiles/libraries_using_mpi:/apps/Modules/modulefiles/libr
        aries:/apps/Modules/modulefiles/commercial:/apps/Modules/modulefiles/ap
        plications:/apps/Modules/modulefiles/test:/apps/Modules/modulefiles/cra
        y:/apps/Modules/modulefiles/crayadm:,LND2ATM_FMAPNAME=idmap,
        CRAY_CPU_TARGET=mic-knl,PBS_O_SYSTEM=Linux,CCSMUSER=g121a02,
        CICE_CONFIG_OPTS=,MPILIBS=openmpi\,mpich,CC=icc,PES_LEVEL=1r,GMAKE_J=16,
        NINST_ATM_LAYOUT=concurrent,HOST=login03,HIST_OPTION=never,
        XTERM_SHELL=/bin/bash,AVGHIST_N=-999,SSTICE_STREAM=UNSET,
        BASH_FUNC_module()=() {  eval `/cm/local/apps/environment-modules/3.2.
        10/Modules/$MODULE_VERSION/bin/modulecmd bash $*`; },CALENDAR=NO_LEAP,
        KDEDIRS=/usr,OCN_NCPL=1,ATM_GRID=0.9x1.25,OCN_ICE_FORCING=active,
        STOP_OPTION=nmonths,GLC_NEC=0,RUN_REFTOD=00000,
        INCROOT=/scratch/g121a02/cesm_exp/intel_mic/bld/lib/include,
        OCN2ATM_FMAPNAME=cpl/gridmaps/gx1v6/map_gx1v6_TO_fv0.9x1.25_aave.13032
        2.nc,LND_DOMAIN_PATH=/scratch/g121a02/inputdata/share/domains,
        BUILD_THREADED=FALSE,CLM_USRDAT_NAME=UNSET,ROOTPE_OCN=512,ROOTPE_LND=0,
        PBS_O_HOME=/home01/g121a02,HOSTTYPE=x86_64-linux,MPI_RUN_COMMAND=UNSET,
        ROOTPE_CPL=0,RUNDIR=/scratch/g121a02/cesm_exp/intel_mic/run,
        CCSM_LCOMPSET=1850_CAM5_CLM40%CN_CICE_POP2_RTM_SGLC_SWAV,
        GLC_PIO_STRIDE=-99,TERM=xterm-256color,ENABLE_LMOD=0,XMLMODE=normal,
        NTHRDS_ATM=1,COMP_LND=clm,ROF_PIO_ROOT=-99,
        ATM2OCN_VMAPNAME=cpl/gridmaps/fv0.9x1.25/map_fv0.9x1.25_TO_gx1v6_patc.
        130322.nc,REST_OPTION=nmonths,RUN_STARTDATE=0001-01-01,
        SHAREDLIBROOTDIR=/scratch/g121a02/cesm_exp/intel_mic/bld,
        PNETCDF4=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl/net
        cdf-hdf5-parallel/4.6.1,SCIENCE_SUPPORT=NO,MODULE_VERSION_STACK=3.2.10,
        PIO_STRIDE=-1,ATM_PIO_ROOT=-99,FORTRAN_TYPE=ifort,RUN_TYPE=hybrid,
        MPI_HOME=/apps/compiler/intel/18.0.3/openmpi/3.1.0,EPS_OMASK=1.0e-06,
        GRID=a%0.9x1.25_l%0.9x1.25_oi%gx1v6_r%r05_m%gx1v6_g%null_w%null,
        CICE_DECOMPTYPE=blkrobin,CAM_NML_USE_CASE=1850_cam5,STOP_N=1,
        COMPILERS=intel21,NINST_OCN_LAYOUT=concurrent,WAV_PIO_TYPENAME=nothing,
        OCN_TIGHT_COUPLING=FALSE,WAV_PIO_STRIDE=-99,NTHRDS_ROF=1,
        OLDPWD=/scratch/g121a02/cesm_exp/intel_mic/timing,
        LOADEDMODULES=craype-network-opa:craype-mic-knl:cmake/3.12.3:intel/18.
        0.3:openmpi/3.1.0:hdf5-parallel/1.10.2:netcdf-hdf5-parallel/4.6.1:subve
        rsion/1.7.19:lapack/3.7.0:CDO/1.8.2,MPICH_VERSION_DISPLAY=1,
        HISTCONTROL=ignoredups,PWD=/scratch/g121a02/cesm_exp/intel_mic,
        CPL_DECOMP=0,RTM_BLDNML_OPTS=-simyr 1850,HIST_DATE=-999,
        HISTTIMEFORMAT=%y-%m-%d %H:%M:%S,GLC_PIO_TYPENAME=nothing,
        LS_COLORS=rs=0:di=38;5;27:ln=38;5;51:mh=44;38;5;15:pi=40;38;5;11:so=38
        ;5;13:do=38;5;5:bd=48;5;232;38;5;11:cd=48;5;232;38;5;3:or=48;5;232;38;5
        ;9:mi=05;48;5;232;38;5;15:su=48;5;196;38;5;15:sg=48;5;11;38;5;16:ca=48;
        5;196;38;5;226:tw=48;5;10;38;5;16:ow=48;5;10;38;5;21:st=48;5;21;38;5;15
        :ex=38;5;34:*.tar=38;5;9:*.tgz=38;5;9:*.arc=38;5;9:*.arj=38;5;9:*.taz=3
        8;5;9:*.lha=38;5;9:*.lz4=38;5;9:*.lzh=38;5;9:*.lzma=38;5;9:*.tlz=38;5;9
        :*.txz=38;5;9:*.tzo=38;5;9:*.t7z=38;5;9:*.zip=38;5;9:*.z=38;5;9:*.Z=38;
        5;9:*.dz=38;5;9:*.gz=38;5;9:*.lrz=38;5;9:*.lz=38;5;9:*.lzo=38;5;9:*.xz=
        38;5;9:*.bz2=38;5;9:*.bz=38;5;9:*.tbz=38;5;9:*.tbz2=38;5;9:*.tz=38;5;9:
        *.deb=38;5;9:*.rpm=38;5;9:*.jar=38;5;9:*.war=38;5;9:*.ear=38;5;9:*.sar=
        38;5;9:*.rar=38;5;9:*.alz=38;5;9:*.ace=38;5;9:*.zoo=38;5;9:*.cpio=38;5;
        9:*.7z=38;5;9:*.rz=38;5;9:*.cab=38;5;9:*.jpg=38;5;13:*.jpeg=38;5;13:*.g
        if=38;5;13:*.bmp=38;5;13:*.pbm=38;5;13:*.pgm=38;5;13:*.ppm=38;5;13:*.tg
        a=38;5;13:*.xbm=38;5;13:*.xpm=38;5;13:*.tif=38;5;13:*.tiff=38;5;13:*.pn
        g=38;5;13:*.svg=38;5;13:*.svgz=38;5;13:*.mng=38;5;13:*.pcx=38;5;13:*.mo
        v=38;5;13:*.mpg=38;5;13:*.mpeg=38;5;13:*.m2v=38;5;13:*.mkv=38;5;13:*.we
        bm=38;5;13:*.ogm=38;5;13:*.mp4=38;5;13:*.m4v=38;5;13:*.mp4v=38;5;13:*.v
        ob=38;5;13:*.qt=38;5;13:*.nuv=38;5;13:*.wmv=38;5;13:*.asf=38;5;13:*.rm=
        38;5;13:*.rmvb=38;5;13:*.flc=38;5;13:*.avi=38;5;13:*.fli=38;5;13:*.flv=
        38;5;13:*.gl=38;5;13:*.dl=38;5;13:*.xcf=38;5;13:*.xwd=38;5;13:*.yuv=38;
        5;13:*.cgm=38;5;13:*.emf=38;5;13:*.axv=38;5;13:*.anx=38;5;13:*.ogv=38;5
        ;13:*.ogx=38;5;13:*.aac=38;5;45:*.au=38;5;45:*.flac=38;5;45:*.mid=38;5;
        45:*.midi=38;5;45:*.mka=38;5;45:*.mp3=38;5;45:*.mpc=38;5;45:*.ogg=38;5;
        45:*.ra=38;5;45:*.wav=38;5;45:*.axa=38;5;45:*.oga=38;5;45:*.spx=38;5;45
        :*.xspf=38;5;45:,COMP_GLC=sglc,USE_ESMF_LIB=FALSE,ATM_NY=192,
        ICE_PIO_ROOT=-99,CRAYPE_NETWORK_TARGET=opa,COMP_RUN_BARRIERS=FALSE,
        CLM_CO2_TYPE=diagnostic,OCN_COUPLING=full,BATCHSUBMIT=qsub,
        GLC_DOMAIN_PATH=/scratch/g121a02/inputdata/share/domains,
        RTM_NAMELIST_OPTS=,ATM2LND_SMAPNAME=idmap,PIO_TYPENAME=netcdf,
        SHELL=/bin/bash,NTASKS_ICE=448,
        INTEL_LICENSE_FILE=/cm/shared/licenses/intel,PSTRID_ROF=1,COMP_ROF=rtm,
        CCSM_PCOST=-3,CICE_BLCKX=8,WAV_PIO_NUMTASKS=-99,
        OCN_PIO_TYPENAME=nothing,NTASKS_ROF=64,POP_DECOMPTYPE=cartesian,
        COMPILER_PREFIX=/apps/compiler/intel,
        MKL_HOME=/apps/compiler/intel/18.0.3/mkl,OCN_TAVG_TRACER_BUDGET=FALSE,
        NETCDF_PATH=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl/
        netcdf-hdf5-parallel/4.6.1,CPL_EPBAL=off,VENDOR=unknown,
        XDG_RUNTIME_DIR=/run/user/603000301,
        LIBROOT=/scratch/g121a02/cesm_exp/intel_mic/bld/lib,EPS_OGRID=1.0e-02,
        ICE_PIO_STRIDE=-99,OCN_CO2_FLUX_OCMIP_BUG_FIX=TRUE,
        HDF5_PATH=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl/hd
        f5-parallel/1.10.2,OCN_NX=320,PE_PRODUCT_LIST=CRAYPE_MIC-KNL,
        CHECK_TIMING=TRUE,GLC_GRID=0.9x1.25,NINST_VALUE=a1l1r1i1o1g1w1,CXX=icpc,
        WAV_NX=0,DOUT_L_HTAR=FALSE,POP_BLCKY=48,POP_BLCKX=40,WAV_NY=0,ATM_NCPL=48,
        NINST_ICE_LAYOUT=concurrent,MAIL=/var/spool/mail/g121a02,
        SSH_CONNECTION=165.132.115.204 51533 150.183.150.13 22,OS=LINUX,
        ATM_PIO_NUMTASKS=-99,
        ROF_DOMAIN_PATH=/scratch/g121a02/inputdata/share/domains,
        RTM_MODE=ACTIVE,MPI_VER=3.1.0,NTASKS_CPL=512,WAV2OCN_SMAPNAME=idmap,
        NTASKS_LND=64,PBS_O_LOGNAME=g121a02,CICE_MODE=prognostic,
        NCPL_BASE_PERIOD=day,
        MPI_INC=/apps/compiler/intel/18.0.3/openmpi/3.1.0/include,
        POP_AUTO_DECOMP=true,
        CASEBUILD=/scratch/g121a02/cesm_exp/intel_mic/Buildconf,
        ICE_DOMAIN_FILE=domain.ocn.gx1v6.090206.nc,OCN_SUBMODEL=,SHLVL=4,
        START_TOD=0,PTS_LAT=-999.99,GMAKE=gmake,WINDOWID=4194338,CCSM_ESTCOST=6,
        PBS_O_PATH=/apps/compiler/intel/18.0.3/applib1/mic-knl/CDO/1.8.2/bin:/
        apps/applications/subversion/1.7.19/bin:/apps/compiler/intel/18.0.3/ope
        nmpi/3.1.0/applib2/mic-knl/netcdf-hdf5-parallel/4.6.1/bin:/apps/compile
        r/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl/hdf5-parallel/1.10.2/bin:/
        apps/compiler/intel/18.0.3/openmpi/3.1.0/bin:/apps/compiler/intel/18.0.
        3/bin:/apps/applications/cmake/3.12.3/bin:/usr/lib64/qt-3.3/bin:/usr/lo
        cal/bin:/usr/bin:/opt/ddn/ime/bin:/cm/local/apps/environment-modules/3.
        2.10/bin:/opt/pbs/bin:/usr/local/sbin:/usr/sbin:/opt/ddn/ime/bin:/opt/p
        bs/bin:/home01/g121a02/.local/bin:/home01/g121a02/bin,
        CLM_NAMELIST_OPTS=,NINST_ROF_LAYOUT=concurrent,
        DOUT_L_MSROOT=/scratch/g121a02/outputdata/intel_mic,EPS_FRAC=1.0e-02,
        NTHRDS_GLC=1,MPI_ROOT=/apps/compiler/intel/18.0.3/openmpi/3.1.0,
        WAV_DOMAIN_FILE=UNSET,XTERM_VERSION=X.Org 7.6.0(295),COMP_ATM=cam,
        LND_PIO_ROOT=-99,NTHRDS_CPL=1,SSTICE_DATA_FILENAME=UNSET,NTASKS_OCN=64,
        NTASKS_GLC=1,CCSM_COMPSET=1850_CAM5_CLM40%CN_CICE_POP2_RTM_SGLC_SWAV,
        PBS_O_MAIL=/var/spool/mail/g121a02,_=./intel_mic.submit,NINST_ROF=1,
        PERL5LIB=/home01/g121a02/perl/share/perl5:/home01/g121a02/perl/share/p
        erl5:,SAVE_TIMING=FALSE,
        HDF_LDFLAGS=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl/
        hdf5-parallel/1.10.2/lib,CPL_PIO_STRIDE=-99,CPL_ALBAV=false,TOTALPES=576,
        KISTI_COMPILER_VER=18.0.3,EPS_AAREA=9.0e-07,COMP_ICE=cice,CASESTR=UNSET,
        MPI=openmpi,MPI_LIB=/apps/compiler/intel/18.0.3/openmpi/3.1.0/lib,
        DOUT_S_ROOT=/scratch/g121a02/outputdata/intel_mic,
        CASETOOLS=/scratch/g121a02/cesm_exp/intel_mic/Tools,CCSM_CCOST=1,
        ATM2LND_FMAPNAME=idmap,NINST_LND=1,ROF_DOMAIN_FILE=UNSET,
        SSTICE_GRID_FILENAME=UNSET,PTS_MODE=FALSE,CLM_BLDNML_OPTS=,
        REMOTEHOST=localhost.localdomain,ROOTPE_ROF=0,
        MPICH_PTL_SEND_CREDITS=-1,NTASKS_ATM=512,
        CCSMROOT=/home01/g121a02/cesm1_2_2,ROOTPE_GLC=0,PTS_LON=-999.99,
        ATM_DOMAIN_FILE=domain.lnd.fv0.9x1.25_gx1v6.090309.nc,
        DISPLAY=localhost:51.0,CICE_MXBLCKS=6,LANG=en_US.UTF-8,
        HDF_CPPFLAGS=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl
        /hdf5-parallel/1.10.2/include,
        MPIHOME=/apps/compiler/intel/18.0.3/openmpi/3.1.0,CCSM_BGC=CO2A,
        PIO_DEBUG_LEVEL=0,ROOTPE_ATM=0,
        ATM2OCN_SMAPNAME=cpl/gridmaps/fv0.9x1.25/map_fv0.9x1.25_TO_gx1v6_blin.
        130322.nc,ICE_NX=320,ICE_NY=384,ICE_GRID=gx1v6,DOUT_S=TRUE,
        PBS_O_WORKDIR=/scratch/g121a02/cesm_exp/intel_mic,
        ROF_PIO_NUMTASKS=-99,COMP_CPL=cpl,OSTYPE=linux,
        CLM_CONFIG_OPTS=-phys clm4_0 -bgc cn,CAM_NAMELIST_OPTS=,
        DOUT_L_MS=FALSE,CPL_PIO_ROOT=-99,NTHRDS_LND=1,OCN2WAV_SMAPNAME=idmap,
        RTM_FLOOD_MODE=NULL,
        OCN_DOMAIN_PATH=/scratch/g121a02/inputdata/share/domains,
        CICE_DECOMPSETTING=null,XTERM_LOCALE=en_US.UTF-8,
        QT_GRAPHICSSYSTEM_CHECKED=1,
        NLSPATH=/apps/compiler/intel/18.0.3/lib/intel64/locale/en_US:/apps/com
        piler/intel/18.0.3/mkl/lib/intel64/locale/en_US,
        BRNCH_RETAIN_CASENAME=FALSE,AVGHIST_OPTION=never,EPS_AGRID=1.0e-12,
        WAV_NCPL=48,POP_MXBLCKS=1,PSTRID_CPL=1,OCN_PIO_STRIDE=-99,
        OCN_DOMAIN_FILE=domain.ocn.gx1v6.090206.nc,ATM2WAV_SMAPNAME=idmap,
        BFBFLAG=FALSE,
        KISTI_MPI_HOME=/apps/compiler/intel/18.0.3/openmpi/3.1.0,
        USE_TRILINOS=FALSE,PSTRID_LND=1,REST_DATE=-999,
        LOGDIR=/scratch/g121a02/cesm_exp/intel_mic/logs,COMPILER_VER=18.0.3,
        KISTI_COMPILER_HOME=/apps/compiler/intel/18.0.3,
        SSTICE_YEAR_ALIGN=-999,CCSM_REPOTAG=cesm1_2_2,LND_NCPL=48,
        SHAREDLIBROOT=/scratch/g121a02/cesm_exp/intel_mic/bld,
        NINST_WAV_LAYOUT=concurrent,KISTI_MPI_VER=3.1.0,
        PROMPT_COMMAND=history -a,OCN_TRANSIENT=unset,NTHRDS_ICE=1,
        LND_PIO_NUMTASKS=-99,
        WAV_DOMAIN_PATH=/scratch/g121a02/inputdata/share/domains,
        SSH_CLIENT=165.132.115.204 51533 22,LOGNAME=g121a02,NINST_ATM=1,
        PATH=/apps/compiler/intel/18.0.3/applib1/mic-knl/CDO/1.8.2/bin:/apps/a
        pplications/subversion/1.7.19/bin:/apps/compiler/intel/18.0.3/openmpi/3
        .1.0/applib2/mic-knl/netcdf-hdf5-parallel/4.6.1/bin:/apps/compiler/inte
        l/18.0.3/openmpi/3.1.0/applib2/mic-knl/hdf5-parallel/1.10.2/bin:/apps/c
        ompiler/intel/18.0.3/openmpi/3.1.0/bin:/apps/compiler/intel/18.0.3/bin:
        /apps/applications/cmake/3.12.3/bin:/usr/lib64/qt-3.3/bin:/usr/local/bi
        n:/usr/bin:/opt/ddn/ime/bin:/cm/local/apps/environment-modules/3.2.10/b
        in:/opt/pbs/bin:/usr/local/sbin:/usr/sbin:/opt/ddn/ime/bin:/opt/pbs/bin
        :/home01/g121a02/.local/bin:/home01/g121a02/bin,
        MPICH_MSGS_PER_PROC=160000,
        ICE_DOMAIN_PATH=/scratch/g121a02/inputdata/share/domains,
        SCRIPTSROOT=/home01/g121a02/cesm1_2_2/scripts,WAV_GRID=null,
        NETCDF_CPPFLAGS=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-
        knl/netcdf-hdf5-parallel/4.6.1/include,OMP_STACKSIZE=64M,
        MPICH_PTL_UNEX_EVENTS=960000,NINST_GLC_LAYOUT=concurrent,
        CAM_CONFIG_OPTS=-phys cam5,EPS_AMASK=1.0e-13,HOME=/home01/g121a02,
        EXEROOT=/scratch/g121a02/cesm_exp/intel_mic/bld,MASK_GRID=gx1v6,
        NINST_BUILD=a1l1r1i1o1g1w1,LND_GRID=0.9x1.25,ROOTPE_WAV=0,
        CCSM_MACHDIR=/home01/g121a02/cesm1_2_2/scripts/ccsm_utils/Machines,
        SSTICE_YEAR_END=-999,
        ROF2LND_SMAPNAME=lnd/clm2/mappingdata/maps/0.9x1.25/map_0.5x0.5_nomask
        _to_0.9x1.25_nomask_aave_da_c121019.nc,ROOTPE_ICE=64,
        DRV_THREADING=FALSE,BUDGETS=TRUE,ICE_PIO_TYPENAME=nothing,
        STOP_DATE=-999,ATM_PIO_STRIDE=-99,
        UTILROOT=/home01/g121a02/cesm1_2_2/scripts/ccsm_utils,
        GET_REFCASE=TRUE,MACH=jsshin,NTHRDS_OCN=1,PSTRID_ATM=1,
        LND_PIO_TYPENAME=nothing,SSTICE_YEAR_START=-999,COMP_WAV=swav,
        ROF2OCN_FMAPNAME=cpl/cpl6/map_r05_TO_g16_aave.120920.nc,
        OCN_TRACER_MODULES_OPT=,PIO_BUFFER_SIZE_LIMIT=-1,COMP_INTERFACE=MCT,
        DIN_LOC_ROOT_CLMFORC=/scratch/g121a02/inputdata/atm/datm7,
        OCN2ATM_SMAPNAME=cpl/gridmaps/gx1v6/map_gx1v6_TO_fv0.9x1.25_aave.13032
        2.nc,PBS_O_QUEUE=normal,PBS_O_HOST=login03
    comment = Job run at Thu Mar 21 at 13:30 on (node2878:ncpus=64)+(node2968:n
        cpus=64)+(node3044:ncpus=64)+(node3050:ncpus=64)+(node3106:ncpus=64)+(n
        ode3120:ncpus=64)+(node3121:ncpus=64)+(node3123:ncpus=64)+(node3162:ncp
        us=64)
    etime = Thu Mar 21 13:30:43 2019
    run_count = 20
    Submit_arguments = ./intel_mic.run
    project = _pbs_project_default

Job Id: 2010611.pbs
    Job_Name = TC_HLLC_v2
    Job_Owner = x1696a07@login03
    job_state = Q
    queue = norm_skl
    server = pbs1
    Checkpoint = u
    ctime = Thu Mar 21 13:31:08 2019
    Error_Path = login03:/scratch/x1696a07/TC12_HLLC_v2/TC_HLLC_v2.e2010611
    Hold_Types = n
    Join_Path = n
    Keep_Files = n
    Mail_Points = a
    mtime = Thu Mar 21 13:31:08 2019
    Output_Path = login03:/scratch/x1696a07/TC12_HLLC_v2/TC_HLLC_v2.o2010611
    Priority = 100
    qtime = Thu Mar 21 13:31:08 2019
    Rerunable = True
    Resource_List.mpiprocs = 200
    Resource_List.ncpus = 200
    Resource_List.nodect = 5
    Resource_List.place = scatter:excl
    Resource_List.qlist = norm_skl
    Resource_List.select = 5:ncpus=40:mpiprocs=40
    Resource_List.walltime = 48:00:00
    substate = 10
    Variable_List = HISTTIMEFORMAT=%y-%m-%d %H:%M:%S,
        MKL_HOME=/apps/compiler/intel/17.0.5/mkl,MODULE_VERSION=3.2.10,
        INTEL_LICENSE_FILE=/cm/shared/licenses/intel,
        KISTI_COMPILER_VER=17.0.5,
        KISTI_APPLIB1=/apps/compiler/intel/17.0.5/applib1,
        KISTI_APPLIB2=/apps/compiler/intel/17.0.5/openmpi/3.1.0/applib2,
        FC=ifort,PBS_O_LANG=en_US.UTF-8,
        BASH_FUNC_module()=() {  eval `/cm/local/apps/environment-modules/3.2.
        10/Modules/$MODULE_VERSION/bin/modulecmd bash $*`; },
        QTDIR=/usr/lib64/qt-3.3,
        LD_LIBRARY_PATH=/apps/compiler/intel/17.0.5/openmpi/3.1.0/lib:/apps/co
        mpiler/intel/17.0.5/debugger/lib/intel64:/apps/compiler/intel/17.0.5/tb
        b/lib/intel64/gcc4.4:/apps/compiler/intel/17.0.5/ipp/lib/intel64:/apps/
        compiler/intel/17.0.5/mkl/lib/intel64:/apps/compiler/intel/17.0.5/lib/i
        ntel64:/opt/cray/lib64:,
        MPICH_HOME=/apps/compiler/intel/17.0.5/openmpi/3.1.0,LANG=en_US.UTF-8,
        QTLIB=/usr/lib64/qt-3.3/lib,SHELL=/bin/bash,
        MPIHOME=/apps/compiler/intel/17.0.5/openmpi/3.1.0,
        SU2_RUN=/home01/x1696a07/SU2/bin,QTINC=/usr/lib64/qt-3.3/include,
        NLSPATH=/apps/compiler/intel/17.0.5/lib/intel64/locale/en_US:/apps/com
        piler/intel/17.0.5/mkl/lib/intel64/locale/en_US,HISTSIZE=20000,
        F90=ifort,PBS_O_WORKDIR=/scratch/x1696a07/TC12_HLLC_v2,
        CRAY_CPU_TARGET=x86-skylake,
        MANPATH=/apps/compiler/intel/17.0.5/man/common:/usr/local/share/man:/u
        sr/share/man/overrides:/usr/share/man:/opt/ddn/ime/share/man:/opt/ddn/i
        me/share/man:/cm/local/apps/environment-modules/current/share/man:/opt/
        pbs/share/man:/apps/compiler/intel/17.0.5/openmpi/3.1.0/share/man,
        COMPILER_PREFIX=/apps/compiler/intel,
        KISTI_COMPILER_HOME=/apps/compiler/intel/17.0.5,PBS_O_SYSTEM=Linux,
        XDG_RUNTIME_DIR=/run/user/604005806,CC=icc,
        PYTHONPATH=:/home01/x1696a07/SU2/bin,PE_PRODUCT_LIST=CRAYPE_BROADWELL,
        QT_GRAPHICSSYSTEM_CHECKED=1,F77=ifort,XDG_SESSION_ID=1145,KDEDIRS=/usr,
        SSH_CONNECTION=210.107.186.171 46990 150.183.150.13 22,
        MKLROOT=/apps/compiler/intel/17.0.5/mkl,CXX=icpc,SSH_TTY=/dev/pts/121,
        HOSTNAME=login03,CRAYPE_NETWORK_TARGET=opa,COMPILER_VER=17.0.5,
        LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=4
        0;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;
        41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01
        ;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=
        01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=0
        1;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31
        :*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:
        *.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31
        :*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;3
        1:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;
        35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01
        ;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng
        =01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.m
        kv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:
        *.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*
        .rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:
        *.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:
        *.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:
        *.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;
        36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;
        36:*.xspf=01;36:,KISTI_MPI_VER=3.1.0,PBS_O_HOME=/home01/x1696a07,
        LESSOPEN=||/usr/bin/lesspipe.sh %s,PBS_O_LOGNAME=x1696a07,
        SSH_CLIENT=210.107.186.171 46990 22,LOGNAME=x1696a07,USER=x1696a07,
        PROMPT_COMMAND=history -a,HOME=/home01/x1696a07,
        PATH=/apps/compiler/intel/17.0.5/openmpi/3.1.0/bin:/apps/compiler/inte
        l/17.0.5/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/usr/local/s
        bin:/usr/sbin:/opt/ddn/ime/bin:/cm/local/apps/environment-modules/3.2.1
        0/bin:/opt/pbs/bin:/home01/x1696a07/SU2/bin:/home01/x1696a07/.local/bin
        :/home01/x1696a07/bin,SU2_HOME=/home01/x1696a07/SU2-6.1.0,
        COMPILER=intel,
        KISTI_MPI_HOME=/apps/compiler/intel/17.0.5/openmpi/3.1.0,TERM=xterm,
        ENABLE_LMOD=0,MPI_VER=3.1.0,SHLVL=2,DISPLAY=localhost:27.0,
        PBS_O_PATH=/apps/compiler/intel/17.0.5/openmpi/3.1.0/bin:/apps/compile
        r/intel/17.0.5/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/usr/l
        ocal/sbin:/usr/sbin:/opt/ddn/ime/bin:/cm/local/apps/environment-modules
        /3.2.10/bin:/opt/pbs/bin:/home01/x1696a07/SU2/bin:/home01/x1696a07/.loc
        al/bin:/home01/x1696a07/bin,
        MODULESHOME=/cm/local/apps/environment-modules/3.2.10/Modules/3.2.10,
        MODULE_VERSION_STACK=3.2.10,
        QT_PLUGIN_PATH=/usr/lib64/kde4/plugins:/usr/lib/kde4/plugins,
        MPI_ROOT=/apps/compiler/intel/17.0.5/openmpi/3.1.0,
        MPI_HOME=/apps/compiler/intel/17.0.5/openmpi/3.1.0,
        MAIL=/var/spool/mail/x1696a07,PBS_O_MAIL=/var/spool/mail/x1696a07,
        _=/opt/pbs/bin/qsub,
        MODULEPATH=/opt/cray/craype/default/modulefiles:/opt/cray/modulefiles:
        /apps/Modules/modulefiles/compilers:/apps/Modules/modulefiles/mpi:/apps
        /Modules/modulefiles/libraries_using_mpi:/apps/Modules/modulefiles/libr
        aries:/apps/Modules/modulefiles/commercial:/apps/Modules/modulefiles/ap
        plications:/apps/Modules/modulefiles/test:/apps/Modules/modulefiles/cra
        y:/apps/Modules/modulefiles/crayadm:,PBS_O_SHELL=/bin/bash,
        FORTRAN_TYPE=ifort,OLDPWD=/scratch/x1696a07/TC12_HLLC,
        LOADEDMODULES=craype-network-opa:craype-x86-skylake:intel/17.0.5:openm
        pi/3.1.0,MPI=openmpi,HISTCONTROL=ignoredups,
        PWD=/scratch/x1696a07/TC12_HLLC_v2,
        _LMFILES_=/opt/cray/craype/default/modulefiles/craype-network-opa:/opt
        /cray/craype/default/modulefiles/craype-x86-skylake:/apps/Modules/modul
        efiles/compilers/intel/17.0.5:/apps/Modules/modulefiles/mpi/openmpi/3.1
        .0,PBS_O_QUEUE=norm_skl,PBS_O_HOST=login03
    comment = Not Running: No available resources on nodes
    etime = Thu Mar 21 13:31:08 2019
    run_count = 19
    Submit_arguments = mpi.sh
    project = _pbs_project_default

Job Id: 2010612.pbs
    Job_Name = intel_pnet
    Job_Owner = g121a02@login03
    job_state = R
    queue = normal
    server = pbs1
    Checkpoint = u
    ctime = Thu Mar 21 13:31:52 2019
    Error_Path = login03:/scratch/g121a02/cesm_exp/intel_pnet/intel_pnet.e20106
        12
    exec_host = node3166/0*64+node3232/0*64+node3367/0*64+node3368/0*64+node336
        9/0*64+node3370/0*64+node3373/0*64+node4345/0*64+node4346/0*64+node4347
        /0*64+node4348/0*64+node4349/0*64+node4350/0*64+node4351/0*64+node4352/
        0*64+node4353/0*64+node4354/0*64+node4355/0*64+node4356/0*64+node4357/0
        *64+node4358/0*64+node4359/0*64+node4360/0*64+node4361/0*64+node4362/0*
        64+node4363/0*64+node4364/0*64+node4365/0*64+node4366/0*64+node4368/0*6
        4+node4369/0*64+node4370/0*64+node4371/0*64+node4372/0*64+node4373/0*64
        +node4374/0*64+node4375/0*64+node4376/0*64+node4380/0*64+node4381/0*64+
        node4382/0*64+node4384/0*64+node4385/0*64+node4386/0*64+node4387/0*64+n
        ode4390/0*64+node4391/0*64+node4392/0*64+node4394/0*64+node4395/0*64+no
        de4396/0*64+node4398/0*64+node4400/0*64+node4402/0*64+node4405/0*64+nod
        e4406/0*64+node4407/0*64+node4408/0*64+node4471/0*64+node4525/0*64+node
        4526/0*64+node4527/0*64+node4528/0*64+node4535/0*64
    exec_vnode = (node3166:ncpus=64)+(node3232:ncpus=64)+(node3367:ncpus=64)+(n
        ode3368:ncpus=64)+(node3369:ncpus=64)+(node3370:ncpus=64)+(node3373:ncp
        us=64)+(node4345:ncpus=64)+(node4346:ncpus=64)+(node4347:ncpus=64)+(nod
        e4348:ncpus=64)+(node4349:ncpus=64)+(node4350:ncpus=64)+(node4351:ncpus
        =64)+(node4352:ncpus=64)+(node4353:ncpus=64)+(node4354:ncpus=64)+(node4
        355:ncpus=64)+(node4356:ncpus=64)+(node4357:ncpus=64)+(node4358:ncpus=6
        4)+(node4359:ncpus=64)+(node4360:ncpus=64)+(node4361:ncpus=64)+(node436
        2:ncpus=64)+(node4363:ncpus=64)+(node4364:ncpus=64)+(node4365:ncpus=64)
        +(node4366:ncpus=64)+(node4368:ncpus=64)+(node4369:ncpus=64)+(node4370:
        ncpus=64)+(node4371:ncpus=64)+(node4372:ncpus=64)+(node4373:ncpus=64)+(
        node4374:ncpus=64)+(node4375:ncpus=64)+(node4376:ncpus=64)+(node4380:nc
        pus=64)+(node4381:ncpus=64)+(node4382:ncpus=64)+(node4384:ncpus=64)+(no
        de4385:ncpus=64)+(node4386:ncpus=64)+(node4387:ncpus=64)+(node4390:ncpu
        s=64)+(node4391:ncpus=64)+(node4392:ncpus=64)+(node4394:ncpus=64)+(node
        4395:ncpus=64)+(node4396:ncpus=64)+(node4398:ncpus=64)+(node4400:ncpus=
        64)+(node4402:ncpus=64)+(node4405:ncpus=64)+(node4406:ncpus=64)+(node44
        07:ncpus=64)+(node4408:ncpus=64)+(node4471:ncpus=64)+(node4525:ncpus=64
        )+(node4526:ncpus=64)+(node4527:ncpus=64)+(node4528:ncpus=64)+(node4535
        :ncpus=64)
    Hold_Types = n
    Join_Path = oe
    Keep_Files = n
    Mail_Points = abe
    Mail_Users = js-shin@yonsei.ac.kr
    mtime = Thu Mar 21 13:31:55 2019
    Output_Path = login03:/scratch/g121a02/cesm_exp/intel_pnet/intel_pnet.o2010
        612
    Priority = 100
    qtime = Thu Mar 21 13:31:53 2019
    Rerunable = True
    Resource_List.knl_cluster_mode = quadrant
    Resource_List.knl_memory_mode = cache
    Resource_List.mpiprocs = 1024
    Resource_List.ncpus = 4096
    Resource_List.nodect = 64
    Resource_List.place = scatter:excl
    Resource_List.qlist = normal
    Resource_List.select = 64:ncpus=64:mpiprocs=16:ompthreads=4
    Resource_List.walltime = 40:00:00
    stime = Thu Mar 21 13:31:58 2019
    Shell_Path_List = /usr/bin/csh
    substate = 41
    Variable_List = PIO_NUMTASKS=-1,TIMER_LEVEL=12,PSTRID_OCN=1,
        ATM_PIO_TYPENAME=nothing,
        KISTI_APPLIB1=/apps/compiler/intel/18.0.3/applib1,
        KISTI_APPLIB2=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2,
        GLC_NX=288,
        ROF2LND_FMAPNAME=lnd/clm2/mappingdata/maps/0.9x1.25/map_0.5x0.5_nomask
        _to_0.9x1.25_nomask_aave_da_c121019.nc,PBS_O_LANG=en_US.UTF-8,
        CLM_NML_USE_CASE=1850_control,PIO_BLOCKSIZE=-1,
        ATM_DOMAIN_PATH=/scratch/g121a02/inputdata/share/domains,
        DOUT_S_SAVE_ALL_ON_DISK=FALSE,OCN_GRID=gx1v6,BUILD_COMPLETE=TRUE,
        CCSM_GCOST=0,F77=ifort,PSTRID_ICE=1,
        PNETCDF_PATH=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl
        /parallel-netcdf/1.10.0,HISTSIZE=20000,OCN_CHL_TYPE=diagnostic,
        VECT_MAP=cart3d,
        MANPATH=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl/para
        llel-netcdf/1.10.0/share/man:/apps/compiler/intel/18.0.3/applib1/mic-kn
        l/CDO/1.8.2/share/man:/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2
        /mic-knl/netcdf-hdf5-parallel/4.6.1/share/man:/apps/compiler/intel/18.0
        .3/openmpi/3.1.0/applib2/mic-knl/hdf5-parallel/1.10.2/share/man:/apps/c
        ompiler/intel/18.0.3/man/common:/usr/local/share/man:/usr/share/man/ove
        rrides:/usr/share/man:/opt/ddn/ime/share/man:/opt/ddn/ime/share/man:/cm
        /local/apps/environment-modules/current/share/man:/opt/pbs/share/man:/a
        pps/compiler/intel/18.0.3/openmpi/3.1.0/share/man:/opt/ddn/ime/share/ma
        n:/cm/local/apps/environment-modules/current/share/man:/opt/pbs/share/m
        an,OCN_TAVG_HIFREQ=FALSE,PSTRID_WAV=1,CICE_AUTO_DECOMP=true,
        LND2ATM_SMAPNAME=idmap,CCSM_CO2_PPMV=284.7,
        ROF2OCN_RMAPNAME=cpl/cpl6/map_r05_to_gx1v6_e1000r300_090226.nc,
        ROF_GRID=r05,PIO_CONFIG_OPTS=,GLC_NY=192,ATM_NX=288,XDG_SESSION_ID=4980,
        RUN_REFCASE=b40_1850_1d_b08c5cn_138j,
        NETCDF_LDFLAGS=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-k
        nl/netcdf-hdf5-parallel/4.6.1/lib,BUILD_STATUS=0,
        SMP_VALUE=a1l1r1i0o1g0w0c1,MKLROOT=/apps/compiler/intel/18.0.3/mkl,
        HOSTNAME=login03,DOUT_S_SAVE_INT_REST_FILES=FALSE,CCSM_TCOST=0,
        RESUBMIT=0,GLC_NCPL=1,OCN_NY=384,MACHTYPE=x86_64,GLC_PIO_NUMTASKS=-99,
        CPL_PIO_NUMTASKS=-99,
        ATM2OCN_FMAPNAME=cpl/gridmaps/fv0.9x1.25/map_fv0.9x1.25_TO_gx1v6_aave.
        130322.nc,POP_NY_BLOCKS=16,CESMSCRATCHROOT=UNSET,GROUP=rc0003,COST_PES=0,
        LND_PIO_STRIDE=-99,LND_NY=192,LND_NX=288,REST_N=1,
        PIO_ASYNC_INTERFACE=FALSE,LESSOPEN=||/usr/bin/lesspipe.sh %s,
        USER=g121a02,NINST_OCN=1,ICE2WAV_SMAPNAME=idmap,COMPILER=intel21,
        COMP_OCN=pop2,WAV_PIO_ROOT=-99,SMP_BUILD=a1l1r1i0o1g0w0c1,
        POP_NX_BLOCKS=16,NINST_GLC=1,PSTRID_GLC=1,INFO_DBUG=1,
        OCN_CO2_TYPE=constant,
        PHDF5=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl/hdf5-p
        arallel/1.10.2,NINST_ICE=1,MAX_TASKS_PER_NODE=64,
        CODEROOT=/home01/g121a02/cesm1_2_2/models,
        MODULESHOME=/cm/local/apps/environment-modules/3.2.10/Modules/3.2.10,
        ICE_PIO_NUMTASKS=-99,HIST_N=-999,CCSM_SCOMPSET=UNSET,AVGHIST_DATE=-999,
        QT_PLUGIN_PATH=/usr/lib64/kde4/plugins:/usr/lib/kde4/plugins,
        CAM_DYCORE=fv,ROF_NX=720,BATCHQUERY=qstat -a,OCN_TRACER_MODULES= iage,
        ROF_NY=360,OBJROOT=/scratch/g121a02/cesm_exp/intel_pnet/bld,
        CICE_NAMELIST_OPTS=cam5=.true.,CCSM_MCOST=0,NINST_WAV=1,
        CONTINUE_RUN=FALSE,DEBUG=FALSE,EPS_OAREA=1.0e-01,
        CLM_FORCE_COLDSTART=off,PBS_O_SHELL=/bin/bash,CPL_PIO_TYPENAME=nothing,
        ROF_PIO_STRIDE=-99,SUPPORTED_BY=js-shin@yonsei.ac.kr,PIO_ROOT=1,
        ROF_PIO_TYPENAME=nothing,MPILIB=openmpi,
        _LMFILES_=/opt/cray/craype/default/modulefiles/craype-network-opa:/opt
        /cray/craype/default/modulefiles/craype-mic-knl:/apps/Modules/modulefil
        es/applications/cmake/3.12.3:/apps/Modules/modulefiles/compilers/intel/
        18.0.3:/apps/Modules/modulefiles/mpi/openmpi/3.1.0:/apps/Modules/module
        files/libraries_using_mpi/hdf5-parallel/1.10.2:/apps/Modules/modulefile
        s/libraries_using_mpi/netcdf-hdf5-parallel/4.6.1:/apps/Modules/modulefi
        les/applications/subversion/1.7.19:/apps/Modules/modulefiles/libraries/
        lapack/3.7.0:/apps/Modules/modulefiles/libraries/CDO/1.8.2:/apps/Module
        s/modulefiles/libraries_using_mpi/parallel-netcdf/1.10.0,
        MPICH_MAX_SHORT_MSG_SIZE=8000,
        LND2ROF_FMAPNAME=lnd/clm2/mappingdata/maps/0.9x1.25/map_0.9x1.25_nomas
        k_to_0.5x0.5_nomask_aave_da_c120522.nc,MODULE_VERSION=3.2.10,
        NINST_LND_LAYOUT=concurrent,DOUT_S_SAVE_ROOT=UNSET,
        CASEROOT=/scratch/g121a02/cesm_exp/intel_pnet,
        DOUT_L_HPSS_ACCNT=00000000,ICE_NCPL=48,NTHRDS_WAV=1,NTASKS_WAV=1,
        OCN_PIO_ROOT=0,RUN_REFDATE=0320-01-01,FC=ifort,CICE_BLCKY=6,
        QTDIR=/usr/lib64/qt-3.3,GLC_DOMAIN_FILE=UNSET,
        LD_LIBRARY_PATH=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-
        knl/parallel-netcdf/1.10.0/lib:/apps/compiler/intel/18.0.3/applib1/mic-
        knl/CDO/1.8.2/lib:/apps/compiler/intel/18.0.3/applib1/mic-knl/lapack/3.
        7.0:/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl/netcdf-hd
        f5-parallel/4.6.1/lib:/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2
        /mic-knl/hdf5-parallel/1.10.2/lib:/apps/compiler/intel/18.0.3/openmpi/3
        .1.0/lib:/apps/compiler/intel/18.0.3/debugger/lib/intel64:/apps/compile
        r/intel/18.0.3/tbb/lib/intel64/gcc4.4:/apps/compiler/intel/18.0.3/ipp/l
        ib/intel64:/apps/compiler/intel/18.0.3/mkl/lib/intel64:/apps/compiler/i
        ntel/18.0.3/lib/intel64:/opt/cray/lib64:,
        MPICH_HOME=/apps/compiler/intel/18.0.3/openmpi/3.1.0,CASE=intel_pnet,
        QTLIB=/usr/lib64/qt-3.3/lib,PES_PER_NODE=64,
        LND_DOMAIN_FILE=domain.lnd.fv0.9x1.25_gx1v6.090309.nc,
        QTINC=/usr/lib64/qt-3.3/include,GLC_PIO_ROOT=-99,ROF_NCPL=8,F90=ifort,
        DIN_LOC_ROOT=/scratch/g121a02/inputdata,OCN_PIO_NUMTASKS=-99,
        MODULEPATH=/opt/cray/craype/default/modulefiles:/opt/cray/modulefiles:
        /apps/Modules/modulefiles/compilers:/apps/Modules/modulefiles/mpi:/apps
        /Modules/modulefiles/libraries_using_mpi:/apps/Modules/modulefiles/libr
        aries:/apps/Modules/modulefiles/commercial:/apps/Modules/modulefiles/ap
        plications:/apps/Modules/modulefiles/test:/apps/Modules/modulefiles/cra
        y:/apps/Modules/modulefiles/crayadm:,LND2ATM_FMAPNAME=idmap,
        CRAY_CPU_TARGET=mic-knl,PBS_O_SYSTEM=Linux,CCSMUSER=g121a02,
        CICE_CONFIG_OPTS=,MPILIBS=openmpi\,mpich,CC=icc,PES_LEVEL=4rcmp,
        GMAKE_J=16,NINST_ATM_LAYOUT=concurrent,HOST=login03,HIST_OPTION=never,
        XTERM_SHELL=/bin/bash,AVGHIST_N=-999,SSTICE_STREAM=UNSET,
        BASH_FUNC_module()=() {  eval `/cm/local/apps/environment-modules/3.2.
        10/Modules/$MODULE_VERSION/bin/modulecmd bash $*`; },CALENDAR=NO_LEAP,
        KDEDIRS=/usr,OCN_NCPL=1,ATM_GRID=0.9x1.25,OCN_ICE_FORCING=active,
        STOP_OPTION=nmonths,GLC_NEC=0,RUN_REFTOD=00000,
        INCROOT=/scratch/g121a02/cesm_exp/intel_pnet/bld/lib/include,
        OCN2ATM_FMAPNAME=cpl/gridmaps/gx1v6/map_gx1v6_TO_fv0.9x1.25_aave.13032
        2.nc,LND_DOMAIN_PATH=/scratch/g121a02/inputdata/share/domains,
        BUILD_THREADED=FALSE,CLM_USRDAT_NAME=UNSET,ROOTPE_OCN=960,
        ROOTPE_LND=  0,PBS_O_HOME=/home01/g121a02,HOSTTYPE=x86_64-linux,
        MPI_RUN_COMMAND=UNSET,ROOTPE_CPL=  0,
        RUNDIR=/scratch/g121a02/cesm_exp/intel_pnet/run,
        CCSM_LCOMPSET=1850_CAM5_CLM40%CN_CICE_POP2_RTM_SGLC_SWAV,
        GLC_PIO_STRIDE=-99,TERM=xterm-256color,ENABLE_LMOD=0,XMLMODE=normal,
        NTHRDS_ATM=4,COMP_LND=clm,ROF_PIO_ROOT=-99,
        ATM2OCN_VMAPNAME=cpl/gridmaps/fv0.9x1.25/map_fv0.9x1.25_TO_gx1v6_patc.
        130322.nc,REST_OPTION=nmonths,RUN_STARTDATE=0001-01-01,
        SHAREDLIBROOTDIR=/scratch/g121a02/cesm_exp/intel_pnet/bld,
        PNETCDF4=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl/net
        cdf-hdf5-parallel/4.6.1,SCIENCE_SUPPORT=NO,MODULE_VERSION_STACK=3.2.10,
        PIO_STRIDE=-1,ATM_PIO_ROOT=-99,FORTRAN_TYPE=ifort,RUN_TYPE=hybrid,
        MPI_HOME=/apps/compiler/intel/18.0.3/openmpi/3.1.0,EPS_OMASK=1.0e-06,
        GRID=a%0.9x1.25_l%0.9x1.25_oi%gx1v6_r%r05_m%gx1v6_g%null_w%null,
        CICE_DECOMPTYPE=spacecurve,CAM_NML_USE_CASE=1850_cam5,STOP_N=1,
        COMPILERS=intel21,NINST_OCN_LAYOUT=concurrent,WAV_PIO_TYPENAME=nothing,
        OCN_TIGHT_COUPLING=FALSE,WAV_PIO_STRIDE=-99,NTHRDS_ROF=4,
        OLDPWD=/scratch/g121a02/cesm_exp,
        LOADEDMODULES=craype-network-opa:craype-mic-knl:cmake/3.12.3:intel/18.
        0.3:openmpi/3.1.0:hdf5-parallel/1.10.2:netcdf-hdf5-parallel/4.6.1:subve
        rsion/1.7.19:lapack/3.7.0:CDO/1.8.2:parallel-netcdf/1.10.0,
        MPICH_VERSION_DISPLAY=1,HISTCONTROL=ignoredups,
        PWD=/scratch/g121a02/cesm_exp/intel_pnet,CPL_DECOMP=0,
        RTM_BLDNML_OPTS=-simyr 1850,HIST_DATE=-999,
        HISTTIMEFORMAT=%y-%m-%d %H:%M:%S,GLC_PIO_TYPENAME=nothing,
        LS_COLORS=rs=0:di=38;5;27:ln=38;5;51:mh=44;38;5;15:pi=40;38;5;11:so=38
        ;5;13:do=38;5;5:bd=48;5;232;38;5;11:cd=48;5;232;38;5;3:or=48;5;232;38;5
        ;9:mi=05;48;5;232;38;5;15:su=48;5;196;38;5;15:sg=48;5;11;38;5;16:ca=48;
        5;196;38;5;226:tw=48;5;10;38;5;16:ow=48;5;10;38;5;21:st=48;5;21;38;5;15
        :ex=38;5;34:*.tar=38;5;9:*.tgz=38;5;9:*.arc=38;5;9:*.arj=38;5;9:*.taz=3
        8;5;9:*.lha=38;5;9:*.lz4=38;5;9:*.lzh=38;5;9:*.lzma=38;5;9:*.tlz=38;5;9
        :*.txz=38;5;9:*.tzo=38;5;9:*.t7z=38;5;9:*.zip=38;5;9:*.z=38;5;9:*.Z=38;
        5;9:*.dz=38;5;9:*.gz=38;5;9:*.lrz=38;5;9:*.lz=38;5;9:*.lzo=38;5;9:*.xz=
        38;5;9:*.bz2=38;5;9:*.bz=38;5;9:*.tbz=38;5;9:*.tbz2=38;5;9:*.tz=38;5;9:
        *.deb=38;5;9:*.rpm=38;5;9:*.jar=38;5;9:*.war=38;5;9:*.ear=38;5;9:*.sar=
        38;5;9:*.rar=38;5;9:*.alz=38;5;9:*.ace=38;5;9:*.zoo=38;5;9:*.cpio=38;5;
        9:*.7z=38;5;9:*.rz=38;5;9:*.cab=38;5;9:*.jpg=38;5;13:*.jpeg=38;5;13:*.g
        if=38;5;13:*.bmp=38;5;13:*.pbm=38;5;13:*.pgm=38;5;13:*.ppm=38;5;13:*.tg
        a=38;5;13:*.xbm=38;5;13:*.xpm=38;5;13:*.tif=38;5;13:*.tiff=38;5;13:*.pn
        g=38;5;13:*.svg=38;5;13:*.svgz=38;5;13:*.mng=38;5;13:*.pcx=38;5;13:*.mo
        v=38;5;13:*.mpg=38;5;13:*.mpeg=38;5;13:*.m2v=38;5;13:*.mkv=38;5;13:*.we
        bm=38;5;13:*.ogm=38;5;13:*.mp4=38;5;13:*.m4v=38;5;13:*.mp4v=38;5;13:*.v
        ob=38;5;13:*.qt=38;5;13:*.nuv=38;5;13:*.wmv=38;5;13:*.asf=38;5;13:*.rm=
        38;5;13:*.rmvb=38;5;13:*.flc=38;5;13:*.avi=38;5;13:*.fli=38;5;13:*.flv=
        38;5;13:*.gl=38;5;13:*.dl=38;5;13:*.xcf=38;5;13:*.xwd=38;5;13:*.yuv=38;
        5;13:*.cgm=38;5;13:*.emf=38;5;13:*.axv=38;5;13:*.anx=38;5;13:*.ogv=38;5
        ;13:*.ogx=38;5;13:*.aac=38;5;45:*.au=38;5;45:*.flac=38;5;45:*.mid=38;5;
        45:*.midi=38;5;45:*.mka=38;5;45:*.mp3=38;5;45:*.mpc=38;5;45:*.ogg=38;5;
        45:*.ra=38;5;45:*.wav=38;5;45:*.axa=38;5;45:*.oga=38;5;45:*.spx=38;5;45
        :*.xspf=38;5;45:,COMP_GLC=sglc,USE_ESMF_LIB=FALSE,ATM_NY=192,
        ICE_PIO_ROOT=-99,CRAYPE_NETWORK_TARGET=opa,COMP_RUN_BARRIERS=FALSE,
        CLM_CO2_TYPE=diagnostic,OCN_COUPLING=full,BATCHSUBMIT=qsub,
        GLC_DOMAIN_PATH=/scratch/g121a02/inputdata/share/domains,
        RTM_NAMELIST_OPTS=,ATM2LND_SMAPNAME=idmap,PIO_TYPENAME=netcdf,
        SHELL=/bin/bash,NTASKS_ICE=896,
        INTEL_LICENSE_FILE=/cm/shared/licenses/intel,PSTRID_ROF=1,COMP_ROF=rtm,
        CCSM_PCOST=-4,CICE_BLCKX=5,WAV_PIO_NUMTASKS=-99,
        OCN_PIO_TYPENAME=nothing,NTASKS_ROF=64,POP_DECOMPTYPE=cartesian,
        COMPILER_PREFIX=/apps/compiler/intel,
        MKL_HOME=/apps/compiler/intel/18.0.3/mkl,OCN_TAVG_TRACER_BUDGET=FALSE,
        NETCDF_PATH=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl/
        netcdf-hdf5-parallel/4.6.1,CPL_EPBAL=off,VENDOR=unknown,
        XDG_RUNTIME_DIR=/run/user/603000301,
        LIBROOT=/scratch/g121a02/cesm_exp/intel_pnet/bld/lib,
        EPS_OGRID=1.0e-02,ICE_PIO_STRIDE=-99,OCN_CO2_FLUX_OCMIP_BUG_FIX=TRUE,
        CCSM_MACHDIR=/home01/g121a02/cesm1_2_2/scripts/ccsm_utils/Machines,
        HDF5_PATH=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl/hd
        f5-parallel/1.10.2,OCN_NX=320,PE_PRODUCT_LIST=CRAYPE_MIC-KNL,
        CHECK_TIMING=TRUE,GLC_GRID=0.9x1.25,NINST_VALUE=a1l1r1i1o1g1w1,CXX=icpc,
        WAV_NX=0,DOUT_L_HTAR=FALSE,POP_BLCKY=24,POP_BLCKX=20,WAV_NY=0,ATM_NCPL=48,
        NINST_ICE_LAYOUT=concurrent,MAIL=/var/spool/mail/g121a02,
        SSH_CONNECTION=165.132.115.204 51552 150.183.150.13 22,OS=LINUX,
        ATM_PIO_NUMTASKS=-99,
        ROF_DOMAIN_PATH=/scratch/g121a02/inputdata/share/domains,
        RTM_MODE=ACTIVE,MPI_VER=3.1.0,NTASKS_CPL=960,WAV2OCN_SMAPNAME=idmap,
        NTASKS_LND=64,PBS_O_LOGNAME=g121a02,CICE_MODE=prognostic,
        NCPL_BASE_PERIOD=day,
        MPI_INC=/apps/compiler/intel/18.0.3/openmpi/3.1.0/include,
        POP_AUTO_DECOMP=true,
        CASEBUILD=/scratch/g121a02/cesm_exp/intel_pnet/Buildconf,
        ICE_DOMAIN_FILE=domain.ocn.gx1v6.090206.nc,OCN_SUBMODEL=,SHLVL=4,
        START_TOD=0,PTS_LAT=-999.99,GMAKE=gmake,WINDOWID=6291490,CCSM_ESTCOST=0,
        PBS_O_PATH=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl/p
        arallel-netcdf/1.10.0/bin:/apps/compiler/intel/18.0.3/applib1/mic-knl/C
        DO/1.8.2/bin:/apps/applications/subversion/1.7.19/bin:/apps/compiler/in
        tel/18.0.3/openmpi/3.1.0/applib2/mic-knl/netcdf-hdf5-parallel/4.6.1/bin
        :/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl/hdf5-paralle
        l/1.10.2/bin:/apps/compiler/intel/18.0.3/openmpi/3.1.0/bin:/apps/compil
        er/intel/18.0.3/bin:/apps/applications/cmake/3.12.3/bin:/usr/lib64/qt-3
        .3/bin:/usr/local/bin:/usr/bin:/opt/ddn/ime/bin:/cm/local/apps/environm
        ent-modules/3.2.10/bin:/opt/pbs/bin:/usr/local/sbin:/usr/sbin:/opt/ddn/
        ime/bin:/opt/pbs/bin:/home01/g121a02/.local/bin:/home01/g121a02/bin,
        CLM_NAMELIST_OPTS=,NINST_ROF_LAYOUT=concurrent,
        DOUT_L_MSROOT=/scratch/g121a02/outputdata/intel_pnet,EPS_FRAC=1.0e-02,
        NTHRDS_GLC=1,MPI_ROOT=/apps/compiler/intel/18.0.3/openmpi/3.1.0,
        WAV_DOMAIN_FILE=UNSET,XTERM_VERSION=X.Org 7.6.0(295),COMP_ATM=cam,
        LND_PIO_ROOT=-99,NTHRDS_CPL=4,SSTICE_DATA_FILENAME=UNSET,NTASKS_OCN=64,
        NTASKS_GLC=1,CCSM_COMPSET=1850_CAM5_CLM40%CN_CICE_POP2_RTM_SGLC_SWAV,
        PBS_O_MAIL=/var/spool/mail/g121a02,_=./intel_pnet.submit,NINST_ROF=1,
        PERL5LIB=/home01/g121a02/perl/share/perl5:/home01/g121a02/perl/share/p
        erl5:,SAVE_TIMING=FALSE,
        HDF_LDFLAGS=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl/
        hdf5-parallel/1.10.2/lib,
        PNETCDF_LDFLAGS=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-
        knl/parallel-netcdf/1.10.0/lib,CPL_PIO_STRIDE=-99,CPL_ALBAV=false,
        TOTALPES=4096,KISTI_COMPILER_VER=18.0.3,EPS_AAREA=9.0e-07,COMP_ICE=cice,
        CASESTR=UNSET,MPI=openmpi,
        MPI_LIB=/apps/compiler/intel/18.0.3/openmpi/3.1.0/lib,
        DOUT_S_ROOT=/scratch/g121a02/outputdata/intel_pnet,
        CASETOOLS=/scratch/g121a02/cesm_exp/intel_pnet/Tools,CCSM_CCOST=1,
        ATM2LND_FMAPNAME=idmap,NINST_LND=1,ROF_DOMAIN_FILE=UNSET,
        SSTICE_GRID_FILENAME=UNSET,PTS_MODE=FALSE,CLM_BLDNML_OPTS=,
        REMOTEHOST=localhost.localdomain,ROOTPE_ROF=  0,
        MPICH_PTL_SEND_CREDITS=-1,NTASKS_ATM=960,
        CCSMROOT=/home01/g121a02/cesm1_2_2,ROOTPE_GLC=  0,PTS_LON=-999.99,
        ATM_DOMAIN_FILE=domain.lnd.fv0.9x1.25_gx1v6.090309.nc,
        DISPLAY=localhost:64.0,CICE_MXBLCKS=5,LANG=en_US.UTF-8,
        HDF_CPPFLAGS=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl
        /hdf5-parallel/1.10.2/include,
        MPIHOME=/apps/compiler/intel/18.0.3/openmpi/3.1.0,CCSM_BGC=CO2A,
        PIO_DEBUG_LEVEL=0,ROOTPE_ATM=  0,
        ATM2OCN_SMAPNAME=cpl/gridmaps/fv0.9x1.25/map_fv0.9x1.25_TO_gx1v6_blin.
        130322.nc,ICE_NX=320,ICE_NY=384,ICE_GRID=gx1v6,DOUT_S=TRUE,
        PBS_O_WORKDIR=/scratch/g121a02/cesm_exp/intel_pnet,
        ROF_PIO_NUMTASKS=-99,COMP_CPL=cpl,OSTYPE=linux,
        CLM_CONFIG_OPTS=-phys clm4_0 -bgc cn,CAM_NAMELIST_OPTS=,
        DOUT_L_MS=FALSE,CPL_PIO_ROOT=-99,NTHRDS_LND=4,OCN2WAV_SMAPNAME=idmap,
        RTM_FLOOD_MODE=NULL,
        OCN_DOMAIN_PATH=/scratch/g121a02/inputdata/share/domains,
        CICE_DECOMPSETTING=null,XTERM_LOCALE=en_US.UTF-8,
        QT_GRAPHICSSYSTEM_CHECKED=1,
        NLSPATH=/apps/compiler/intel/18.0.3/lib/intel64/locale/en_US:/apps/com
        piler/intel/18.0.3/mkl/lib/intel64/locale/en_US,
        BRNCH_RETAIN_CASENAME=FALSE,AVGHIST_OPTION=never,EPS_AGRID=1.0e-12,
        WAV_NCPL=48,POP_MXBLCKS=4,PSTRID_CPL=1,OCN_PIO_STRIDE=-99,
        OCN_DOMAIN_FILE=domain.ocn.gx1v6.090206.nc,ATM2WAV_SMAPNAME=idmap,
        BFBFLAG=FALSE,
        KISTI_MPI_HOME=/apps/compiler/intel/18.0.3/openmpi/3.1.0,
        USE_TRILINOS=FALSE,PSTRID_LND=1,REST_DATE=-999,
        LOGDIR=/scratch/g121a02/cesm_exp/intel_pnet/logs,COMPILER_VER=18.0.3,
        KISTI_COMPILER_HOME=/apps/compiler/intel/18.0.3,
        SSTICE_YEAR_ALIGN=-999,CCSM_REPOTAG=cesm1_2_2,LND_NCPL=48,
        SHAREDLIBROOT=/scratch/g121a02/cesm_exp/intel_pnet/bld,
        NINST_WAV_LAYOUT=concurrent,KISTI_MPI_VER=3.1.0,
        PROMPT_COMMAND=history -a,OCN_TRANSIENT=unset,NTHRDS_ICE=1,
        LND_PIO_NUMTASKS=-99,
        WAV_DOMAIN_PATH=/scratch/g121a02/inputdata/share/domains,
        SSH_CLIENT=165.132.115.204 51552 22,LOGNAME=g121a02,NINST_ATM=1,
        PATH=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl/paralle
        l-netcdf/1.10.0/bin:/apps/compiler/intel/18.0.3/applib1/mic-knl/CDO/1.8
        .2/bin:/apps/applications/subversion/1.7.19/bin:/apps/compiler/intel/18
        .0.3/openmpi/3.1.0/applib2/mic-knl/netcdf-hdf5-parallel/4.6.1/bin:/apps
        /compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-knl/hdf5-parallel/1.10
        .2/bin:/apps/compiler/intel/18.0.3/openmpi/3.1.0/bin:/apps/compiler/int
        el/18.0.3/bin:/apps/applications/cmake/3.12.3/bin:/usr/lib64/qt-3.3/bin
        :/usr/local/bin:/usr/bin:/opt/ddn/ime/bin:/cm/local/apps/environment-mo
        dules/3.2.10/bin:/opt/pbs/bin:/usr/local/sbin:/usr/sbin:/opt/ddn/ime/bi
        n:/opt/pbs/bin:/home01/g121a02/.local/bin:/home01/g121a02/bin,
        MPICH_MSGS_PER_PROC=160000,
        ICE_DOMAIN_PATH=/scratch/g121a02/inputdata/share/domains,
        SCRIPTSROOT=/home01/g121a02/cesm1_2_2/scripts,WAV_GRID=null,
        NETCDF_CPPFLAGS=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic-
        knl/netcdf-hdf5-parallel/4.6.1/include,OMP_STACKSIZE=64M,
        MPICH_PTL_UNEX_EVENTS=960000,NINST_GLC_LAYOUT=concurrent,
        CAM_CONFIG_OPTS=-phys cam5,EPS_AMASK=1.0e-13,HOME=/home01/g121a02,
        EXEROOT=/scratch/g121a02/cesm_exp/intel_pnet/bld,MASK_GRID=gx1v6,
        NINST_BUILD=a1l1r1i1o1g1w1,LND_GRID=0.9x1.25,ROOTPE_WAV=  0,
        COMP_INTERFACE=MCT,SSTICE_YEAR_END=-999,
        ROF2LND_SMAPNAME=lnd/clm2/mappingdata/maps/0.9x1.25/map_0.5x0.5_nomask
        _to_0.9x1.25_nomask_aave_da_c121019.nc,ROOTPE_ICE=64,
        DRV_THREADING=FALSE,BUDGETS=TRUE,ICE_PIO_TYPENAME=nothing,
        STOP_DATE=-999,ATM_PIO_STRIDE=-99,
        UTILROOT=/home01/g121a02/cesm1_2_2/scripts/ccsm_utils,
        GET_REFCASE=TRUE,MACH=jsshin,NTHRDS_OCN=4,PSTRID_ATM=1,
        LND_PIO_TYPENAME=nothing,SSTICE_YEAR_START=-999,COMP_WAV=swav,
        ROF2OCN_FMAPNAME=cpl/cpl6/map_r05_TO_g16_aave.120920.nc,
        OCN_TRACER_MODULES_OPT=,PIO_BUFFER_SIZE_LIMIT=-1,
        PNETCDF_CPPFLAGS=/apps/compiler/intel/18.0.3/openmpi/3.1.0/applib2/mic
        -knl/parallel-netcdf/1.10.0/include,
        DIN_LOC_ROOT_CLMFORC=/scratch/g121a02/inputdata/atm/datm7,
        OCN2ATM_SMAPNAME=cpl/gridmaps/gx1v6/map_gx1v6_TO_fv0.9x1.25_aave.13032
        2.nc,PBS_O_QUEUE=normal,PBS_O_HOST=login03
    comment = Job run at Thu Mar 21 at 13:31 on (node3166:ncpus=64)+(node3232:n
        cpus=64)+(node3367:ncpus=64)+(node3368:ncpus=64)+(node3369:ncpus=64)+(n
        ode3370:ncpus=64)+(node3373:ncpus=64)+(node4345:ncpus=64)+(node4346:ncp
        us=64)+(node4347:ncpus=64)+(node4348:ncpus=64...
    etime = Thu Mar 21 13:31:53 2019
    run_count = 20
    Submit_arguments = ./intel_pnet.run
    project = _pbs_project_default

Job Id: 2010613.pbs
    Job_Name = grims_pre
    Job_Owner = r106kaf@node2711
    job_state = Q
    queue = rokaf_knl
    server = pbs1
    Checkpoint = u
    ctime = Thu Mar 21 13:31:59 2019
    Error_Path = node2711:/home01/r106kaf/GRIMs/GRIMs_OPR_SCRIPTS/run_v3.2.2/lo
        g/grims_prerun.out
    Hold_Types = n
    Join_Path = oe
    Keep_Files = n
    Mail_Points = a
    mtime = Thu Mar 21 13:31:59 2019
    Output_Path = node2711:/home01/r106kaf/GRIMs/GRIMs_OPR_SCRIPTS/run_v3.2.2/l
        og/grims_prerun.out
    Priority = 100
    qtime = Thu Mar 21 13:31:59 2019
    Rerunable = True
    Resource_List.knl_cluster_mode = quadrant
    Resource_List.knl_memory_mode = cache
    Resource_List.mpiprocs = 2448
    Resource_List.ncpus = 2448
    Resource_List.nodect = 36
    Resource_List.place = scatter:shared
    Resource_List.qlist = rokaf_knl
    Resource_List.select = 36:ncpus=68:mpiprocs=68
    Resource_List.walltime = 24:00:00
    substate = 10
    Variable_List = PBS_O_SYSTEM=Linux,PBS_O_SHELL=/bin/csh,PBS_O_TZ=Asia/Seoul,
        PBS_O_HOME=/home01/r106kaf,oprdir=/scratch/r106kaf/OPR/GRIMsv3.2.2,
        PBS_O_MAIL=/var/spool/mail/r106kaf,PBS_O_LOGNAME=r106kaf,
        PBS_O_WORKDIR=/scratch/r106kaf,PBS_O_LANG=en_US.UTF-8,
        PBS_O_PATH=/home01/r106kaf/test/Image/bin:/home01/r106kaf/UTIL:/home01
        /r106kaf/lib/rip-4.3:/home01/r106kaf/lib/gnu/7.2.0/x86-skylake/cairo-1.
        14.12/bin:/apps/common/freetype/2.6.5/bin:/apps/common/jpeg/9c/bin:/app
        s/common/libpng/1.2.56/bin:/apps/common/jasper/1.900.29/bin:/home01/r10
        6kaf/lib/ncarg-6.4.0/bin:/home01/r106kaf/lib/grads-2.0.2/bin:/apps/comp
        iler/intel/18.0.3/applib1/mic-knl/netcdf/4.6.1/bin:/apps/compiler/intel
        /18.0.3/applib1/mic-knl/hdf5/1.10.2/bin:/apps/compiler/intel/18.0.3/imp
        i/2018.3.222/bin64:/apps/compiler/intel/18.0.3/bin:/home01/r106kaf/test
        /Image/bin:/home01/r106kaf/UTIL:/home01/r106kaf/lib/grads-2.0.2/bin:/ho
        me01/r106kaf/test/Image/bin:/home01/r106kaf/UTIL:/home01/r106kaf/lib/gr
        ads-2.0.2/bin:/home01/r106kaf/bin:/usr/local/bin:/usr/bin/bin:/bin:/usr
        /local/sbin:/usr/sbin:/cm/local/apps/environment-modules/3.2.10/bin:/op
        t/pbs/bin:/opt/pbs/bin:/opt/pbs/bin,infile=grims_info.txt,
        PBS_O_QUEUE=rokaf_knl,PBS_O_HOST=node2711
    comment = Not Running: Insufficient amount of resource: qlist
    etime = Thu Mar 21 13:31:59 2019
    run_count = 19
    Submit_arguments = -q rokaf_knl -l select=36:ncpus=68:mpiprocs=68 -v oprdir
        =/scratch/r106kaf/OPR/GRIMsv3.2.2,
        infile=grims_info.txt -o /home01/r106kaf/GRIMs/GRIMs_OPR_SCRIPTS/run_v
        3.2.2/log/grims_prerun.out -e /home01/r106kaf/GRIMs/GRIMs_OPR_SCRIPTS/r
        un_v3.2.2/log/grims_prerun.out /home01/r106kaf/GRIMs/GRIMsv3.2.2/../GRI
        Ms_OPR_SCRIPTS/run_v3.2.2/grims_prerun_720h.csh
    project = _pbs_project_default

Job Id: 2010614.pbs
    Job_Name = STDIN
    Job_Owner = sedu10@login01
    resources_used.cpupercent = 0
    resources_used.cput = 00:00:00
    resources_used.mem = 10612kb
    resources_used.ncpus = 8
    resources_used.vmem = 433004kb
    resources_used.walltime = 00:01:20
    job_state = R
    queue = debug
    server = pbs1
    Checkpoint = u
    ctime = Thu Mar 21 13:32:52 2019
    Error_Path = /dev/pts/0
    exec_host = node8296/0*4+node8297/0*4
    exec_vnode = (node8296:ncpus=4)+(node8297:ncpus=4)
    Hold_Types = n
    interactive = True
    Join_Path = n
    Keep_Files = n
    Mail_Points = a
    mtime = Thu Mar 21 13:33:03 2019
    Output_Path = /dev/pts/0
    Priority = 100
    qtime = Thu Mar 21 13:32:52 2019
    Rerunable = False
    Resource_List.knl_cluster_mode = quadrant
    Resource_List.knl_memory_mode = cache
    Resource_List.mpiprocs = 8
    Resource_List.ncpus = 8
    Resource_List.nodect = 2
    Resource_List.place = scatter:shared
    Resource_List.qlist = debug
    Resource_List.select = 2:ncpus=4:mpiprocs=4:ompthreads=1
    Resource_List.walltime = 03:00:00
    stime = Thu Mar 21 13:33:01 2019
    session_id = 40009
    jobdir = /home01/sedu10
    substate = 42
    Variable_List = HISTTIMEFORMAT=%y-%m-%d %H:%M:%S,MODULE_VERSION=3.2.10,
        GCC_PATH=/apps/compiler/gcc/7.2.0,KISTI_COMPILER_VER=7.2.0,
        KISTI_APPLIB1=/apps/compiler/gcc/7.2.0/applib1,
        KISTI_APPLIB2=/apps/compiler/gcc/7.2.0/openmpi/3.1.0/applib2,
        FC=gfortran,PBS_O_LANG=en_US.UTF-8,
        BASH_FUNC_module()=() {  eval `/cm/local/apps/environment-modules/3.2.
        10/Modules/$MODULE_VERSION/bin/modulecmd bash $*`; },
        QTDIR=/usr/lib64/qt-3.3,
        LD_LIBRARY_PATH=/apps/compiler/gcc/7.2.0/openmpi/3.1.0/lib:/apps/compi
        ler/gcc/7.2.0/lib64:/apps/compiler/gcc/7.2.0/lib/gcc/x86_64-unknown-lin
        ux-gnu/7.2.0:/apps/common/gmp/6.1.2/lib:/apps/common/mpfr/4.0.1/lib:/ap
        ps/common/mpc/1.1.0/lib:/opt/cray/lib64:,
        MPICH_HOME=/apps/compiler/gcc/7.2.0/openmpi/3.1.0,LANG=en_US.UTF-8,
        QTLIB=/usr/lib64/qt-3.3/lib,GCC_VERSION=7.2.0,
        MPIHOME=/apps/compiler/gcc/7.2.0/openmpi/3.1.0,
        QTINC=/usr/lib64/qt-3.3/include,HISTSIZE=20000,F90=gfortran,
        PBS_O_WORKDIR=/scratch/sedu10,CRAY_CPU_TARGET=mic-knl,
        MANPATH=/apps/compiler/gcc/7.2.0/share/man:/usr/local/share/man:/usr/s
        hare/man/overrides:/usr/share/man:/opt/ddn/ime/share/man:/opt/ddn/ime/s
        hare/man:/cm/local/apps/environment-modules/current/share/man:/opt/pbs/
        share/man:/apps/compiler/gcc/7.2.0/openmpi/3.1.0/share/man,
        COMPILER_PREFIX=/apps/compiler/gcc/7.2.0,
        KISTI_COMPILER_HOME=/apps/compiler/gcc/7.2.0,PBS_O_SYSTEM=Linux,
        XDG_RUNTIME_DIR=/run/user/100016309,CC=gcc,PE_ENV=GNU,
        PE_PRODUCT_LIST=CRAYPE_MIC-KNL,QT_GRAPHICSSYSTEM_CHECKED=1,
        XDG_SESSION_ID=4716,KDEDIRS=/usr,
        SSH_CONNECTION=150.183.108.109 54163 150.183.150.11 22,CXX=g++,
        SSH_TTY=/dev/pts/91,HOSTNAME=login01,CRAYPE_NETWORK_TARGET=opa,
        COMPILER_VER=7.2.0,
        LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=4
        0;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;
        41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01
        ;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=
        01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=0
        1;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31
        :*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:
        *.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31
        :*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;3
        1:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;
        35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01
        ;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng
        =01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.m
        kv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:
        *.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*
        .rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:
        *.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:
        *.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:
        *.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;
        36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;
        36:*.xspf=01;36:,KISTI_MPI_VER=3.1.0,PBS_O_HOME=/home01/sedu10,
        GNU_VERSION=7.2.0,LESSOPEN=||/usr/bin/lesspipe.sh %s,
        PBS_O_LOGNAME=sedu10,SSH_CLIENT=150.183.108.109 54163 22,
        LOGNAME=sedu10,USER=sedu10,PROMPT_COMMAND=history -a,
        HOME=/home01/sedu10,
        PATH=/apps/compiler/gcc/7.2.0/openmpi/3.1.0/bin:/apps/compiler/gcc/7.2
        .0/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/u
        sr/sbin:/opt/ddn/ime/bin:/cm/local/apps/environment-modules/3.2.10/bin:
        /opt/pbs/bin:/home01/sedu10/.local/bin:/home01/sedu10/bin,COMPILER=gnu,
        KISTI_MPI_HOME=/apps/compiler/gcc/7.2.0/openmpi/3.1.0,TERM=xterm,
        ENABLE_LMOD=0,MPI_VER=3.1.0,SHLVL=2,DISPLAY=localhost:29.0,
        PBS_O_PATH=/apps/compiler/gcc/7.2.0/openmpi/3.1.0/bin:/apps/compiler/g
        cc/7.2.0/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/usr/local/s
        bin:/usr/sbin:/opt/ddn/ime/bin:/cm/local/apps/environment-modules/3.2.1
        0/bin:/opt/pbs/bin:/home01/sedu10/.local/bin:/home01/sedu10/bin,
        MODULESHOME=/cm/local/apps/environment-modules/3.2.10/Modules/3.2.10,
        MODULE_VERSION_STACK=3.2.10,
        QT_PLUGIN_PATH=/usr/lib64/kde4/plugins:/usr/lib/kde4/plugins,
        INFOPATH=/apps/compiler/gcc/7.2.0/share/info,
        MPI_ROOT=/apps/compiler/gcc/7.2.0/openmpi/3.1.0,
        MPI_HOME=/apps/compiler/gcc/7.2.0/openmpi/3.1.0,SHELL=/bin/bash,
        MAIL=/var/spool/mail/sedu10,PBS_O_MAIL=/var/spool/mail/sedu10,
        _=/opt/pbs/bin/qsub,
        MODULEPATH=/opt/cray/craype/default/modulefiles:/opt/cray/modulefiles:
        /apps/Modules/modulefiles/compilers:/apps/Modules/modulefiles/mpi:/apps
        /Modules/modulefiles/libraries_using_mpi:/apps/Modules/modulefiles/libr
        aries:/apps/Modules/modulefiles/commercial:/apps/Modules/modulefiles/ap
        plications:/apps/Modules/modulefiles/test:/apps/Modules/modulefiles/cra
        y:/apps/Modules/modulefiles/crayadm:,PBS_O_SHELL=/bin/bash,
        FORTRAN_TYPE=gfortran,OLDPWD=/home01/sedu10,
        LOADEDMODULES=craype-network-opa:craype-mic-knl:gcc/7.2.0:openmpi/3.1.
        0,MPI=openmpi,HISTCONTROL=ignoredups,PWD=/scratch/sedu10,
        _LMFILES_=/opt/cray/craype/default/modulefiles/craype-network-opa:/opt
        /cray/craype/default/modulefiles/craype-mic-knl:/apps/Modules/modulefil
        es/compilers/gcc/7.2.0:/apps/Modules/modulefiles/mpi/openmpi/3.1.0,
        PBS_O_QUEUE=debug,PBS_O_HOST=login01
    comment = Job run at Thu Mar 21 at 13:33 on (node8296:ncpus=4)+(node8297:nc
        pus=4)
    etime = Thu Mar 21 13:32:52 2019
    run_count = 20
    Submit_arguments = -I -V -l select=2:ncpus=4:mpiprocs=4:ompthreads=1 -l wal
        ltime=03:00:00 -q debug
    project = _pbs_project_default

Job Id: 2010615.pbs
    Job_Name = STDIN
    Job_Owner = sedu04@login01
    resources_used.cpupercent = 0
    resources_used.cput = 00:00:00
    resources_used.mem = 15828kb
    resources_used.ncpus = 16
    resources_used.vmem = 594376kb
    resources_used.walltime = 00:01:21
    job_state = R
    queue = debug
    server = pbs1
    Checkpoint = u
    ctime = Thu Mar 21 13:32:59 2019
    Error_Path = /dev/pts/0
    exec_host = node8298/0*8+node8299/0*8
    exec_vnode = (node8298:ncpus=8)+(node8299:ncpus=8)
    Hold_Types = n
    interactive = True
    Join_Path = n
    Keep_Files = n
    Mail_Points = a
    mtime = Thu Mar 21 13:33:03 2019
    Output_Path = /dev/pts/0
    Priority = 100
    qtime = Thu Mar 21 13:32:59 2019
    Rerunable = False
    Resource_List.knl_cluster_mode = quadrant
    Resource_List.knl_memory_mode = cache
    Resource_List.mpiprocs = 16
    Resource_List.ncpus = 16
    Resource_List.nodect = 2
    Resource_List.place = scatter:shared
    Resource_List.qlist = debug
    Resource_List.select = 2:ncpus=8:mpiprocs=8:ompthreads=1
    Resource_List.walltime = 03:00:00
    stime = Thu Mar 21 13:33:01 2019
    session_id = 43007
    jobdir = /home01/sedu04
    substate = 42
    Variable_List = HISTTIMEFORMAT=%y-%m-%d %H:%M:%S,MODULE_VERSION=3.2.10,
        GCC_PATH=/apps/compiler/gcc/7.2.0,KISTI_COMPILER_VER=7.2.0,
        KISTI_APPLIB1=/apps/compiler/gcc/7.2.0/applib1,
        KISTI_APPLIB2=/apps/compiler/gcc/7.2.0/openmpi/3.1.0/applib2,
        FC=gfortran,PBS_O_LANG=en_US.UTF-8,
        BASH_FUNC_module()=() {  eval `/cm/local/apps/environment-modules/3.2.
        10/Modules/$MODULE_VERSION/bin/modulecmd bash $*`; },
        QTDIR=/usr/lib64/qt-3.3,
        LD_LIBRARY_PATH=/apps/compiler/gcc/7.2.0/openmpi/3.1.0/lib:/apps/compi
        ler/gcc/7.2.0/lib64:/apps/compiler/gcc/7.2.0/lib/gcc/x86_64-unknown-lin
        ux-gnu/7.2.0:/apps/common/gmp/6.1.2/lib:/apps/common/mpfr/4.0.1/lib:/ap
        ps/common/mpc/1.1.0/lib:/opt/cray/lib64:,
        MPICH_HOME=/apps/compiler/gcc/7.2.0/openmpi/3.1.0,LANG=en_US.UTF-8,
        QTLIB=/usr/lib64/qt-3.3/lib,GCC_VERSION=7.2.0,
        MPIHOME=/apps/compiler/gcc/7.2.0/openmpi/3.1.0,
        QTINC=/usr/lib64/qt-3.3/include,HISTSIZE=20000,F90=gfortran,
        PBS_O_WORKDIR=/scratch/sedu04,CRAY_CPU_TARGET=mic-knl,
        MANPATH=/apps/compiler/gcc/7.2.0/share/man:/usr/local/share/man:/usr/s
        hare/man/overrides:/usr/share/man:/opt/ddn/ime/share/man:/opt/ddn/ime/s
        hare/man:/cm/local/apps/environment-modules/current/share/man:/opt/pbs/
        share/man:/apps/compiler/gcc/7.2.0/openmpi/3.1.0/share/man,
        COMPILER_PREFIX=/apps/compiler/gcc/7.2.0,
        KISTI_COMPILER_HOME=/apps/compiler/gcc/7.2.0,PBS_O_SYSTEM=Linux,
        XDG_RUNTIME_DIR=/run/user/100016303,CC=gcc,PE_ENV=GNU,
        PE_PRODUCT_LIST=CRAYPE_MIC-KNL,QT_GRAPHICSSYSTEM_CHECKED=1,
        XDG_SESSION_ID=4717,KDEDIRS=/usr,
        SSH_CONNECTION=150.183.108.105 53826 150.183.150.11 22,CXX=g++,
        SSH_TTY=/dev/pts/93,HOSTNAME=login01,CRAYPE_NETWORK_TARGET=opa,
        COMPILER_VER=7.2.0,
        LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=4
        0;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;
        41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01
        ;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=
        01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=0
        1;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31
        :*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:
        *.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31
        :*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;3
        1:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;
        35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01
        ;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng
        =01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.m
        kv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:
        *.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*
        .rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:
        *.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:
        *.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:
        *.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;
        36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;
        36:*.xspf=01;36:,KISTI_MPI_VER=3.1.0,PBS_O_HOME=/home01/sedu04,
        GNU_VERSION=7.2.0,LESSOPEN=||/usr/bin/lesspipe.sh %s,
        PBS_O_LOGNAME=sedu04,SSH_CLIENT=150.183.108.105 53826 22,
        LOGNAME=sedu04,USER=sedu04,PROMPT_COMMAND=history -a,
        HOME=/home01/sedu04,
        PATH=/apps/compiler/gcc/7.2.0/openmpi/3.1.0/bin:/apps/compiler/gcc/7.2
        .0/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/u
        sr/sbin:/opt/ddn/ime/bin:/cm/local/apps/environment-modules/3.2.10/bin:
        /opt/pbs/bin:/home01/sedu04/.local/bin:/home01/sedu04/bin,COMPILER=gnu,
        KISTI_MPI_HOME=/apps/compiler/gcc/7.2.0/openmpi/3.1.0,TERM=xterm,
        ENABLE_LMOD=0,MPI_VER=3.1.0,SHLVL=2,DISPLAY=localhost:38.0,
        PBS_O_PATH=/apps/compiler/gcc/7.2.0/openmpi/3.1.0/bin:/apps/compiler/g
        cc/7.2.0/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/usr/local/s
        bin:/usr/sbin:/opt/ddn/ime/bin:/cm/local/apps/environment-modules/3.2.1
        0/bin:/opt/pbs/bin:/home01/sedu04/.local/bin:/home01/sedu04/bin,
        MODULESHOME=/cm/local/apps/environment-modules/3.2.10/Modules/3.2.10,
        MODULE_VERSION_STACK=3.2.10,
        QT_PLUGIN_PATH=/usr/lib64/kde4/plugins:/usr/lib/kde4/plugins,
        INFOPATH=/apps/compiler/gcc/7.2.0/share/info,
        MPI_ROOT=/apps/compiler/gcc/7.2.0/openmpi/3.1.0,
        MPI_HOME=/apps/compiler/gcc/7.2.0/openmpi/3.1.0,SHELL=/bin/bash,
        MAIL=/var/spool/mail/sedu04,PBS_O_MAIL=/var/spool/mail/sedu04,
        _=/opt/pbs/bin/qsub,
        MODULEPATH=/opt/cray/craype/default/modulefiles:/opt/cray/modulefiles:
        /apps/Modules/modulefiles/compilers:/apps/Modules/modulefiles/mpi:/apps
        /Modules/modulefiles/libraries_using_mpi:/apps/Modules/modulefiles/libr
        aries:/apps/Modules/modulefiles/commercial:/apps/Modules/modulefiles/ap
        plications:/apps/Modules/modulefiles/test:/apps/Modules/modulefiles/cra
        y:/apps/Modules/modulefiles/crayadm:,PBS_O_SHELL=/bin/bash,
        FORTRAN_TYPE=gfortran,OLDPWD=/home01/sedu04,
        LOADEDMODULES=craype-network-opa:craype-mic-knl:gcc/7.2.0:openmpi/3.1.
        0,MPI=openmpi,HISTCONTROL=ignoredups,PWD=/scratch/sedu04,
        _LMFILES_=/opt/cray/craype/default/modulefiles/craype-network-opa:/opt
        /cray/craype/default/modulefiles/craype-mic-knl:/apps/Modules/modulefil
        es/compilers/gcc/7.2.0:/apps/Modules/modulefiles/mpi/openmpi/3.1.0,
        PBS_O_QUEUE=debug,PBS_O_HOST=login01
    comment = Job run at Thu Mar 21 at 13:33 on (node8298:ncpus=8)+(node8299:nc
        pus=8)
    etime = Thu Mar 21 13:32:59 2019
    run_count = 20
    Submit_arguments = -I -V -l select=2:ncpus=8:mpiprocs=8:ompthreads=1 -l wal
        ltime=03:00:00 -q debug
    project = _pbs_project_default

Job Id: 2010616.pbs
    Job_Name = IOR_ime
    Job_Owner = jwyoon@login04
    resources_used.cpupercent = 35
    resources_used.cput = 00:00:06
    resources_used.mem = 653048kb
    resources_used.ncpus = 32
    resources_used.vmem = 6143792kb
    resources_used.walltime = 00:00:29
    job_state = R
    queue = burst_buffer
    server = pbs1
    Checkpoint = u
    ctime = Thu Mar 21 13:33:33 2019
    Error_Path = login04:/scratch/jwyoon/IME/IOR_ime.e2010616
    exec_host = node6801/0*16+node6802/0*16
    exec_vnode = (node6801:ncpus=16)+(node6802:ncpus=16)
    Hold_Types = n
    Join_Path = n
    Keep_Files = n
    Mail_Points = a
    mtime = Thu Mar 21 13:33:37 2019
    Output_Path = login04:/scratch/jwyoon/IME/IOR_ime.o2010616
    Priority = 100
    qtime = Thu Mar 21 13:33:33 2019
    Rerunable = True
    Resource_List.knl_cluster_mode = quadrant
    Resource_List.knl_memory_mode = cache
    Resource_List.mpiprocs = 32
    Resource_List.ncpus = 32
    Resource_List.nodect = 2
    Resource_List.place = scatter:excl
    Resource_List.qlist = burst_buffer
    Resource_List.select = 2:ncpus=16:mpiprocs=16
    Resource_List.walltime = 04:00:00
    stime = Thu Mar 21 13:33:36 2019
    session_id = 26645
    jobdir = /home01/jwyoon
    substate = 42
    Variable_List = PBS_O_SYSTEM=Linux,PBS_O_SHELL=/bin/bash,
        PBS_O_HOME=/home01/jwyoon,PBS_O_LOGNAME=jwyoon,
        PBS_O_WORKDIR=/scratch/jwyoon/IME,PBS_O_LANG=ko_KR.UTF-8,
        PBS_O_PATH=/apps/compiler/intel/17.0.5/impi/2017.4.239/bin64:/apps/com
        piler/intel/17.0.5/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/u
        sr/local/sbin:/usr/sbin:/opt/ddn/ime/bin:/cm/local/apps/environment-mod
        ules/3.2.10/bin:/opt/pbs/bin:/home01/jwyoon/.local/bin:/home01/jwyoon/b
        in::/cm/local/apps/cmd/bin,PBS_O_MAIL=/var/spool/mail/jwyoon,
        PBS_O_QUEUE=burst_buffer,PBS_O_HOST=login04
    comment = Job run at Thu Mar 21 at 13:33 on (node6801:ncpus=16)+(node6802:n
        cpus=16)
    etime = Thu Mar 21 13:33:33 2019
    run_count = 20
    Submit_arguments = IOR_ime.script
    project = _pbs_project_default


```

### 82 file_open

### 85 file_seek

c 관계 없고
fortran, 레코드 길이 따라 읽는다


### 86 file_read

읽어서 어디에 저장할 것이냐? 저장하는 변수, 보통 배열이면 배열값



```
[sedu14@node8292 to]$ scp 150.183.150.12:/tmp/Codes.tgz .
Warning: Permanently added '150.183.150.12' (ECDSA) to the list of known hosts.
Password(OTP):
Password:
Codes.tgz  

[sedu14@node8292 Codes]$ ls -lrth
total 56K
-rw-r--r-- 1 sedu14 in0163 613 Mar 21 02:41 cart_create.f90
-rw-r--r-- 1 sedu14 in0163 847 Mar 21 02:42 cart_rank_coords.f90
-rw-r--r-- 1 sedu14 in0163 650 Mar 21 02:42 cart_shfit.f90
-rw-r--r-- 1 sedu14 in0163 613 Mar 21 02:42 neighborhood_allgather.f90
-rw-r--r-- 1 sedu14 in0163 380 Mar 21 02:43 win_create.c
-rw-r--r-- 1 sedu14 in0163 486 Mar 21 02:43 win_create.f90
-rw-r--r-- 1 sedu14 in0163 642 Mar 21 02:44 put.f90
-rw-r--r-- 1 sedu14 in0163 947 Mar 21 02:44 win_create2.f90
-rw-r--r-- 1 sedu14 in0163 597 Mar 21 02:45 accumulate.f90
-rw-r--r-- 1 sedu14 in0163 672 Mar 21 02:45 get_accumulate.f90
-rw-r--r-- 1 sedu14 in0163 551 Mar 21 02:46 file_write2.c
-rw-r--r-- 1 sedu14 in0163 657 Mar 21 02:46 file_read.c
-rw-r--r-- 1 sedu14 in0163 517 Mar 21 02:46 file_write3.c
-rw-r--r-- 1 sedu14 in0163 632 Mar 21 02:47 file_read2.c

```


```c
#include <stdio.h>
#include <mpi.h>
int main()
{
  int rank,nprocs,bufsize,nints;
  int buf[20]={0,},i;
  MPI_File fh;
  MPI_Offset FILESIZE;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&rank);
  MPI_Comm_size(MPI_COMM_WORLD,&nprocs);
  MPI_File_open(MPI_COMM_WORLD,"./test2.out",MPI_MODE_RDONLY,MPI_INFO_NULL,&fh);
  MPI_File_get_size(fh,&FILESIZE);
  bufsize=FILESIZE/nprocs;
  nints=bufsize/sizeof(int);
  MPI_File_seek(fh,rank*bufsize,MPI_SEEK_SET);
  MPI_File_read(fh,&buf[rank*nints],nints,MPI_INT,MPI_STATUS_IGNORE);
  printf("rank:%d  buf=",rank);
  for(i=0;i<20;i++) printf("%d  ",buf[i]);
  printf("\n");
  MPI_Finalize();
  return 0;
}

```


## loop

통신만 하니까 수동으로 전부

1. 등분하는 방식
   1. 반복 12번 할 때 랭크4개니까 

p 프로세스 개수
q 청크 덩어리 크기
r 나머지

나머지2개 있을 때 
2개의 랭크는 한번더(q+1) 작업하고 나머지는 원래 q만큼만
   

para_range 다 돌려쓰는 코드ㅡ 시작, 1부터 14까지 반복.
```

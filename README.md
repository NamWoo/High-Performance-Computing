# Memo
* 총 1+2, 3일차 교육
* 첫날 교육은 HPC 관련 리눅스
* 둘째, 셋째 교육은 HPC 관련 Fortran
* 장소: 대전 카이스트 옆, 한국과학기술정보연구원(KISTI)
* 
## HPC 교육 1일차, 2019년 02월 20일 수요일
###  Linux Training Course
관리자 시스템과 사용자 시스템이 있다. 누리온 시스템 관련 사용관련해서 있다. 다음달엔 리눅스 관리자 교육이다. 루트 관련 교육이다. 

## 접속

* Putty 
* Host name : nurion.ksc.re.kr (port : 22)


```
login as: sedu07
Using keyboard-interactive authentication.
Password(OTP):
Using keyboard-interactive authentication.
Password:
Last login: Thu Feb 14 13:18:36 2019 from 211.48.46.139

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
  >     Used  SRU Time :              687 [sec]
 -----------------------------------------------------------
 *  Available SRU Time :          359,313 [sec] [99.81%]
  @ Available KNL CORE Time = Available SRU Time x  4,352
  @ Available SKL CORE Time = Available SRU Time x  1,280
 -----------------------------------------------------------
  ** more information :  http://helpdesk.ksc.re.kr
 -----------------------------------------------------------
  Account manager
  - E-mail : account@ksc.re.kr        Tel : 080-041-1991
============================================================
* sedu07 Lustre Filesystem Quota Status ("*" exceeded quota)
============================================================
Filesystem       KBytes        Quota      Files      Quota
------------------------------------------------------------
   /home01         120k          64G         24     200000
  /scratch           4k         100T          1    1000000
============================================================
*If the quota is exceeded,creation or writing is not possible!!

[sedu07@login01 ~]$ 
```

## scratch

scratch 로 이동해야지만 job을 제출할 수 있다.
```
[sedu07@login01 ~]$ pwd
/home01/sedu07
[sedu07@login01 ~]$ cd /scratch/sedu07/
[sedu07@login01 sedu07]$ pwd
/scratch/sedu07
```

## job 제출
```
[sedu07@login01 sedu07]$ qsub -I -V -l select=1 -l walltime=04:00:00 -q debug
qsub: waiting for job 1914665.pbs to start
qsub: job 1914665.pbs ready

[sedu07@node8291 ~]$

```
로그인 노드는 노드가 4개 밖에 없다. 계산 돌릴 수 없다. 잡 제출해야한다.
KNL은 계산노드. 직접 접속할 수는 없다.

-I 인터렉트티브하게
-V 로인 정보 가져오겟다

select 청크
q는 디버그 가져오겠다

qsub -I -V -l select=1 -l walltime=04:00:00 -q debug
4시간동인 인터렉티브하게 작업하겠다.

`[sedu07@node8291 ~]$` 뒤에 숫자가 붙어서 8291 , 이건 계산노드라는 말.


## PBS_O_WORKDIR 작업공간으로 이동
$PBS_O_WORKDIR
```
[sedu07@node8291 ~]$ cd $PBS_O_WORKDIR
[sedu07@node8291 sedu07]$ 
```
## exit
열심히 작업하고 더이상 안 할꺼면 exit 해야함. 계속 cpu를 먹고 있다는 말이고 과금되고 있다는 말. exit 하면 노드가 바뀐다. 뒤 숫자 바뀜
```
[sedu07@node8291 sedu07]$ exit
logout

qsub: job 1914665.pbs completed
[sedu07@login01 sedu07]$
```

## 반복
```
[sedu07@login01 sedu07]$ qsub -I -V -l select=1 -l walltime=04:00:00 -q debug
qsub: waiting for job 1914731.pbs to start
qsub: job 1914731.pbs ready

[sedu07@node8289 ~]$ cd $PBS_O_WORKDIR
[sedu07@node8289 sedu07]$
```
다시 로그인해서 기억하고 있는 WORKDIR로 이동.



## 계층구조

```
[sedu07@node8289 sedu07]$ ls /
applic    bin   dev     home      lib    media  proc  run      scratch_ime  tftpboot  var
apps      boot  etc     home01    lib64  mnt    root  sbin     srv          tmp
apps_ime  cm    global  home_ime  local  opt    rpms  scratch  sys          usr
[sedu07@node8289 sedu07]$

```

root의 계념은 / , 윈도우로따지면 c:// 같은거.

## 명령어 구조

* command + options + arguments

```rinux
[sedu07@node8289 sedu07]$ ls /home01/sedu07
job_examples
[sedu07@node8289 sedu07]$ ls -a /home01/sedu07
.   .bash_history  .bash_profile  .cache   .emacs        .kshrc    .openstackrc  .vim      .Xauthority
..  .bash_logout   .bashrc        .config  job_examples  .mozilla  .ssh          .viminfo
[sedu07@node8289 sedu07]$
```

/루트 밑 home01 밑에 / 또 뭐 밑에 있는 경로에 파일들을 보고 싶다









## HPC 교육 2일차, 2019년 2월 21일 목요일
## HPC 교육 3일차, 2019년 2월 22일 금요일

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
[sedu07@node8289 sedu07]$ ls -al
total 84
drwx------    2 sedu07 in0163  4096 Feb 18 13:30 .
drwxr-xr-x 1331 root   root   77824 Feb 18 17:33 ..
[sedu07@node8289 sedu07]$
```

* /루트 밑 home01 밑에 / 또 뭐 밑에 있는 경로에 파일들을 보고 싶다 /home01/sedu07 이게 arg

## man page 제공. 도움말

```
[sedu07@node8289 sedu07]$ man ls
LS(1)                                          User Commands                                         LS(1)

NAME
       ls - list directory contents

SYNOPSIS
       ls [OPTION]... [FILE]...

DESCRIPTION
       List  information  about the FILEs (the current directory by default).  Sort entries alphabetically
       if none of -cftuvSUX nor --sort is specified.

       Mandatory arguments to long options are mandatory for short options too.

       -a, --all
              do not ignore entries starting with .

       -A, --almost-all
              do not list implied . and ..

       --author
              with -l, print the author of each file

       -b, --escape
              print C-style escapes for nongraphic characters

       --block-size=SIZE
              scale sizes by SIZE before printing them; e.g., '--block-size=M' prints sizes  in  units  of
              1,048,576 bytes; see SIZE format below

       -B, --ignore-backups
              do not list implied entries ending with ~

       -c     with  -lt:  sort by, and show, ctime (time of last modification of file status information);
              with -l: show ctime and sort by name; otherwise: sort by ctime, newest first

       -C     list entries by columns

       --color[=WHEN]
              colorize the output; WHEN can be 'never', 'auto', or 'always' (the default); more info below

       -d, --directory
              list directories themselves, not their contents

       -D, --dired
              generate output designed for Emacs' dired mode

       -f     do not sort, enable -aU, disable -ls --color

       -F, --classify
              append indicator (one of */=>@|) to entries

       --file-type
              likewise, except do not append '*'

       --format=WORD
              across -x, commas -m, horizontal -x, long -l, single-column -1, verbose -l, vertical -C

       --full-time
              like -l --time-style=full-iso


```
등등 이런 식으로 확인이 가능하다.


## 명령어 모음
### du
```
[sedu07@node8289 sedu07]$ du
4       .
[sedu07@node8289 sedu07]$ du -h
4.0K    .
[sedu07@node8289 sedu07]$ pwd /scratch/sedu07/
/scratch/sedu07
[sedu07@node8289 sedu07]$ du -h /scratch/sedu07
4.0K    /scratch/sedu07

```

### df
```
[sedu07@node8289 sedu07]$ df
Filesystem                                          1K-blocks          Used      Available Use% Mounted on
tmpfs                                                88858092       5331212       83526880   6% /
devtmpfs                                             49350608             0       49350608   0% /dev
tmpfs                                                49365604         25812       49339792   1% /run
tmpfs                                                49365604             0       49365604   0% /dev/shm
tmpfs                                                49365604             0       49365604   0% /sys/fs/cgroup
10.149.200.153@o2ib:10.149.200.154@o2ib:/apps    494150260288  186347547256   282891567740  40% /apps
10.149.200.153@o2ib:10.149.200.154@o2ib:/home    741225390432  113840918356   590017792680  17% /home01
10.149.200.33@o2ib:10.149.200.34@o2ib:/scratch 20056546192752 3302149479024 15743130879692  18% /scratch
[sedu07@node8289 sedu07]$ df -h
Filesystem                                      Size  Used Avail Use% Mounted on
tmpfs                                            85G  5.1G   80G   6% /
devtmpfs                                         48G     0   48G   0% /dev
tmpfs                                            48G   26M   48G   1% /run
tmpfs                                            48G     0   48G   0% /dev/shm
tmpfs                                            48G     0   48G   0% /sys/fs/cgroup
10.149.200.153@o2ib:10.149.200.154@o2ib:/apps   461T  174T  264T  40% /apps
10.149.200.153@o2ib:10.149.200.154@o2ib:/home   691T  107T  550T  17% /home01
10.149.200.33@o2ib:10.149.200.34@o2ib:/scratch   19P  3.1P   15P  18% /scratch
[sedu07@node8289 sedu07]$

```
### date
```
[sedu07@node8289 sedu07]$ cal 3 1986
     March 1986
Su Mo Tu We Th Fr Sa
                   1
 2  3  4  5  6  7  8
 9 10 11 12 13 14 15
16 17 18 19 20 21 22
23 24 25 26 27 28 29
30 31

```
### bc 계산기
* bc -1 초월함수 사용가능
* quit로 종료해야 나감

### who
로그인 노드로 가서 해야함.

### which 명령어 찾기
```
[sedu07@node8289 sedu07]$ ifort
-bash: ifort: command not found
[sedu07@node8289 sedu07]$ which ifort
/usr/bin/which: no ifort in (/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/opt/ddn/ime/bin:/cm/local/apps/environment-modules/3.2.10/bin:/opt/pbs/bin:/home01/sedu07/.local/bin:/home01/sedu07/bin:/opt/ddn/ime/bin:/opt/pbs/bin:/home01/sedu07/.local/bin:/home01/sedu07/bin)
```
* ifort 라는 명령어를 실행했는데 없다.
* which로 찾았는데도 없다.

```
[sedu07@node8289 sedu07]$ which ls
alias ls='ls --color=auto'
        /usr/bin/ls
```
### whereis, whatis 어디에 무엇을 하는지
```
[sedu07@node8289 sedu07]$ whereis ls
ls: /usr/bin/ls /usr/share/man/man1p/ls.1p.gz /usr/share/man/man1/ls.1.gz
[sedu07@node8289 sedu07]$ whatis ls
ls (1)               - list directory contents
ls (1p)              - list directory contents
[sedu07@node8289 sedu07]$
```

명령어가 어디에 어떻게 위치해있는지 무슨 일을 하는지 찾는.

### id 정보

```
[sedu07@node8289 sedu07]$ id
uid=100016306(sedu07) gid=1000163(in0163) groups=1000163(in0163)
[sedu07@node8289 sedu07]$ id sedu07
uid=100016306(sedu07) gid=1000163(in0163) groups=1000163(in0163)
[sedu07@node8289 sedu07]$
```

유저 id와 그룹 id,  그룹 관리해야할 때 그룹도 필요, 또 누리온엔 가우시안 프로그램이 있는데 그건 가우시안 등록된 그룹만 사용가능하게


### free 메모리 사용현황

```
[sedu07@node8289 sedu07]$ free  -s
free: option requires an argument -- 's'

Usage:
 free [options]

Options:
 -b, --bytes         show output in bytes
 -k, --kilo          show output in kilobytes
 -m, --mega          show output in megabytes
 -g, --giga          show output in gigabytes
     --tera          show output in terabytes
 -h, --human         show human-readable output
     --si            use powers of 1000 not 1024
 -l, --lohi          show detailed low and high memory statistics
 -t, --total         show total for RAM + swap
 -s N, --seconds N   repeat printing every N seconds
 -c N, --count N     repeat printing N times, then exit
 -w, --wide          wide output

     --help     display this help and exit
 -V, --version  output version information and exit

For more details see free(1).
[sedu07@node8289 sedu07]$ free
              total        used        free      shared  buff/cache   available
Mem:       98731212     1931976    90599660     5429868     6199576    89886340
Swap:             0           0           0
[sedu07@node8289 sedu07]$ free -h
              total        used        free      shared  buff/cache   available
Mem:            94G        1.8G         86G        5.2G        5.9G         85G
Swap:            0B          0B          0B
[sedu07@node8289 sedu07]$ free -hs 1
              total        used        free      shared  buff/cache   available
Mem:            94G        1.8G         86G        5.2G        5.9G         85G
Swap:            0B          0B          0B

              total        used        free      shared  buff/cache   available
Mem:            94G        1.8G         86G        5.2G        5.9G         85G
Swap:            0B          0B          0B

              total        used        free      shared  buff/cache   available
Mem:            94G        1.8G         86G        5.2G        5.9G         85G
Swap:            0B          0B          0B

```

* `[sedu07@node8289 sedu07]$ free -hs 1`
지정한 시간(초)초당 메모리 사용 확인

누리온도 코어가 68개인데 메모리가 376GB인데 부족한 편이다.

### History 명령어.

#### !482 
482번째 실행한 명령어 수행
#### !!
가장 최근 사용한 명령어 수행
#### history 5 
가장 최근에 사용한 명령어 5개 수행
#### !da 
da로 시작하는 가장 최근 명령어 수행


### ls 명령어 

* ls -a 
숨김파일도 보여줌
* ls -F 
구분자 표현


### alias 별칭? 단축키

```
[sedu07@node8289 sedu07]$ aliar
-bash: aliar: command not found
[sedu07@node8289 sedu07]$ alias
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias vi='vim'
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
[sedu07@node8289 sedu07]$ alias editor='vim'
[sedu07@node8289 sedu07]$ alias
alias editor='vim'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias vi='vim'
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
[sedu07@node8289 sedu07]$ editor

```
#### 등록
alias editor='vim'

#### 해체 
unalias editor

#### 사용
editor
* 원래 없던 명령어를 만들어서, 등록해서 사용가능함.



### 자동완성기능 탭.


### 디렉토리 관련

* cd
   * 이동
* pwd
   * 현재 워킹 디렉토리
* mkdir
   * 생성
* rmdir
   * 삭제
* touch
   * `touch aaa.txt` 
      * 없는 파일이면 생성
      * 있는 파일이면 수정날짜 지금으로 변경
* cp
   * cp aaa.txt bbb.txt
      * 복사할 것과 복사될 파일의 파일명

### cd ../..
한번에 몇단계로 넘어갈때
* cd ..     # 한 단계
* cd ../..  # 두 단계

### 복사 방법
드레그 하면 복사.

### 붙여넣는 방법
우클릭하면 붙여넣기


```
[sedu07@node8289 sedu07]$ mkdir white
[sedu07@node8289 sedu07]$ mkdir red
[sedu07@node8289 sedu07]$ cd red
[sedu07@node8289 red]$ ls
[sedu07@node8289 red]$ mkdir black
[sedu07@node8289 red]$ cd black
[sedu07@node8289 black]$ touch my.txt
[sedu07@node8289 black]$ pwd
/scratch/sedu07/red/black
[sedu07@node8289 black]$ ls -l
total 0
-rw-r--r-- 1 sedu07 in0163 0 Feb 20 11:28 my.txt
[sedu07@node8289 black]$ !to
touch my.txt
[sedu07@node8289 black]$ ls -l
total 0
-rw-r--r-- 1 sedu07 in0163 0 Feb 20 11:29 my.txt
[sedu07@node8289 black]$ ls
my.txt
[sedu07@node8289 black]$ pwd
/scratch/sedu07/red/black
[sedu07@node8289 black]$ cd..
-bash: cd..: command not found
[sedu07@node8289 black]$ cd ..
[sedu07@node8289 red]$ cd ..
[sedu07@node8289 sedu07]$ pwd
/scratch/sedu07
[sedu07@node8289 sedu07]$ ls
blue  green  red  white
[sedu07@node8289 sedu07]$ mkdir -p cyan/aaa/bbb
[sedu07@node8289 sedu07]$ pwe
-bash: pwe: command not found
[sedu07@node8289 sedu07]$ pwd
/scratch/sedu07
[sedu07@node8289 sedu07]$ ls
blue  cyan  green  red  white
[sedu07@node8289 sedu07]$ cd cyan
[sedu07@node8289 cyan]$ ;s
-bash: syntax error near unexpected token `;'
[sedu07@node8289 cyan]$ ls
aaa
[sedu07@node8289 cyan]$ pwd
/scratch/sedu07/cyan
[sedu07@node8289 cyan]$ cd aaa
[sedu07@node8289 aaa]$ cd bbb
[sedu07@node8289 bbb]$ cd ..
[sedu07@node8289 aaa]$ cd ..
[sedu07@node8289 cyan]$ dir
aaa
[sedu07@node8289 cyan]$ pwd
/scratch/sedu07/cyan
[sedu07@node8289 cyan]$ cd ..
[sedu07@node8289 sedu07]$

```


### mkdir -p cyan/aaa/bbb

하위 디렉토리까지 이어서 한번에 만들기

### cp 복사

* cp my.txt ../../(tap)
복사를 해서 원하는 폴더에 만드려고 할 때 윗단계, 윗단계, 그리고 탭을 누르면 저 위에 무슨 폴더가 있는지 확인 가능. 그리고 복사 실행.


### rm

* rmdir green 
빈 폴더만 삭제 가능

* rm *.txt 
와일드카드 사용가능.

* rm -r red
-r 리컬시브. 재귀적으로 지우겠다. 
-f 강제로 지우겠다
-i 지울때마다 물어보겠다.
-rf


* rm -ri blue
하나씩 물어가면서 지우는.


### mv 이동 또는 파일명 변경


```
[sedu07@node8289 sedu07]$ mkdir red
[sedu07@node8289 sedu07]$ cd red
[sedu07@node8289 red]$ touch 1.txt
[sedu07@node8289 red]$ mv 1.txt ../
[sedu07@node8289 red]$ ls
[sedu07@node8289 red]$ cd ..
[sedu07@node8289 sedu07]$ ls
1.txt  blue  red
[sedu07@node8289 sedu07]$

```

복사는 그대로 복사지만 이동은 복사해놓고 기존파일 삭제이다. 그래서

* mv 1.txt 2.txt 하면 1파일이 2파일로 파일명이 바뀐다.


* mv -b 1.txt ../2.txt
이동하면서 백업파일 생성

### editor 나오기
콜론 누르고 q 인서트도 있음
### cat 실행.
간단한 파일일때 사용가능
### echo 화면 출력
환경변수에 있는 변수 값 출력

```
[sedu07@node8289 sedu07]$ echo $HOME
/home01/sedu07
```

## 다시 시작

### cat
### diff



```
[sedu07@login01 ~]$ cd /scratch/sedu07
[sedu07@login01 sedu07]$ qsub -I -V -l select=1 -l walltime=04:00:00 -q debug
qsub: waiting for job 1916494.pbs to start
qsub: job 1916494.pbs ready

[sedu07@node8282 ~]$ ls
job_examples
[sedu07@node8282 ~]$ mkdir aaa
[sedu07@node8282 ~]$ cd aa
-bash: cd: aa: No such file or directory
[sedu07@node8282 ~]$ cd aaa
[sedu07@node8282 aaa]$ cat > my1.txt
i wanna go home.
No way.^C
[sedu07@node8282 aaa]$ cat > my2.txt
i used to think that i could not go on.
No way.^C
[sedu07@node8282 aaa]$ cat my1.txt
i wanna go home.
[sedu07@node8282 aaa]$ cat my2.txt
i used to think that i could not go on.
[sedu07@node8282 aaa]$ cat my1.txt
i wanna go home.
[sedu07@node8282 aaa]$ cat > my1.txt
aaa
bbb
^C
[sedu07@node8282 aaa]$ cat > my2.txt
ccc
bbb
^C
[sedu07@node8282 aaa]$ cat my1.txt
aaa
bbb
[sedu07@node8282 aaa]$ diff my1.txt my2.txt
1c1
< aaa
---
> ccc
[sedu07@node8282 aaa]$ ^C


```


### vimdiff my1.txt my2.txt

vim 에서 두창 모두 불러올 때
* qa 하면 나갈 수 있다 q는 나가는거 a는 모두 닫는거 
혹시 수정했을 때 안될 때는 w하고 qa

### head and tail

#### head
```
[sedu07@node8282 aaa]$ head /etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
```
#### tail
```
[sedu07@node8282 aaa]$ tail /etc/passwd
jaltorf:x:1025:1025:jaltorf:/home/jaltorf:/bin/bash
crayadm:x:1001:1001:crayadm:/home/crayadm:/bin/bash
ddnadm:x:1029:1029:ddnadm:/home/ddnadm:/bin/bash
brightadm:x:1030:1030:brightadm:/home/brightadm:/bin/bash
bskim:x:1026:1002:bskim:/home/bskim:/bin/bash
craybmt:x:1027:1002:craybmt:/home/craybmt:/bin/bash

```

#### `$ head -3 /etc/passwd`
3줄만 보고 싶을 때
```
[sedu07@node8282 aaa]$ head -3 /etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin

```
### tail 실제 사용시에는 
반복돌릴 때 append로 쌓이는 가장 밑에 쌓이는 내용을 바뀔 때마다 출력할 수 있는 방법
#### `$ tail -f my1.txt`





### more 
페이지 단위로 한 화면씩 출력하려고 할 때

### wc
줄 또는 단어 개수 출력

#### -l 라인 수
#### -w 단어 수
#### -c 문자 수

```
[sedu07@node8282 aaa]$ ls -l
total 8
-rw-r--r-- 1 sedu07 in0163 8 Feb 20 13:45 my1.txt
-rw-r--r-- 1 sedu07 in0163 8 Feb 20 13:42 my2.txt
[sedu07@node8282 aaa]$ ls -l | wc -c
108
[sedu07@node8282 aaa]$ ls -l | wc -l
3
[sedu07@node8282 aaa]$ ls -l | wc -c
108

```

### tar 압축과 묶어주는거
$ tar -czvf test2.tgz test2
```
[sedu07@node8282 aaa]$ mkdir test2
[sedu07@node8282 aaa]$ cp *.txt test2/
[sedu07@node8282 aaa]$ cd test2
[sedu07@node8282 test2]$ ls
my1.txt  my2.txt
[sedu07@node8282 test2]$ cd ..
[sedu07@node8282 aaa]$ ls
my1.txt  my2.txt  test2
[sedu07@node8282 aaa]$ tar -czvf test2.tgz test2
test2/
test2/my1.txt
test2/my2.txt
[sedu07@node8282 aaa]$ ls
my1.txt  my2.txt  test2  test2.tgz

```

### tar 압축해제
-C 대문자 로 해체하는 폴더위치 지정가능

```
[sedu07@node8282 aaa]$ mkdir test3
[sedu07@node8282 aaa]$ tar -xzvf test2.tgz -C test3/
test2/
test2/my1.txt
test2/my2.txt
[sedu07@node8282 aaa]$ ls
my1.txt  my2.txt  test2  test2.tgz  test3

```

### gzip 은 압축




## 절대와 상대 경로


### chmod 권한 속성 변경

```
[sedu07@node8282 aaa]$ ls -l
total 20
-rw-r--r-- 1 sedu07 in0163    8 Feb 20 13:45 my1.txt
-rw-r--r-- 1 sedu07 in0163    8 Feb 20 13:42 my2.txt
drwxr-xr-x 2 sedu07 in0163 4096 Feb 20 13:59 test2
-rw-r--r-- 1 sedu07 in0163  190 Feb 20 14:00 test2.tgz
drwxr-xr-x 3 sedu07 in0163 4096 Feb 20 14:01 test3
[sedu07@node8282 aaa]$ ls -l my1.txt
-rw-r--r-- 1 sedu07 in0163 8 Feb 20 13:45 my1.txt
[sedu07@node8282 aaa]$ chmod +x my1.txt
[sedu07@node8282 aaa]$ ls -l my1.txt
-rwxr-xr-x 1 sedu07 in0163 8 Feb 20 13:45 my1.txt

```


```
[sedu07@node8282 aaa]$ ls -l my1.txt
-rwxr-xr-x 1 sedu07 in0163 8 Feb 20 13:45 my1.txt
[sedu07@node8282 aaa]$ chmod o+x my1.txt
[sedu07@node8282 aaa]$ ls -l my1.txt
-rwxr-xr-x 1 sedu07 in0163 8 Feb 20 13:45 my1.txt
[sedu07@node8282 aaa]$

```



### 리다이렉팅 >
#### >
* ls > my3.txt

my3.txt 파일에 ls 로 나오는 값들이 들어가게 되는.

#### < >

* text.x < input.dat > output.dat
input dat를 불러와서 test.x를 실행하고 결과를 output.dat로 저장

### find 찾기

* $ find ./ -name my.txt
find는 로그인노드에 루트 디렉토리에서 찾아버리면 부하가 상당히 걸리니 현재 디렉토리로 지정해줘야 한다.


### ln 링크 명령어

```
[sedu07@node8282 aaa]$ cat >ori.txt
ls
Original file
^C
[sedu07@node8282 aaa]$ ls
my1.txt  my2.txt  ori.txt  test2  test2.tgz  test3
[sedu07@node8282 aaa]$ in -s ori.txt sym.txt
-bash: syntax error near unexpected token `in'
[sedu07@node8282 aaa]$ ln -s ori.txt sym.txt
[sedu07@node8282 aaa]$ ls -l
total 24
-rwxr-xr-x 1 sedu07 in0163    8 Feb 20 13:45 my1.txt
-rw-r--r-- 1 sedu07 in0163    8 Feb 20 13:42 my2.txt
-rw-r--r-- 1 sedu07 in0163   17 Feb 20 14:34 ori.txt
lrwxrwxrwx 1 sedu07 in0163    7 Feb 20 14:35 sym.txt -> ori.txt
drwxr-xr-x 2 sedu07 in0163 4096 Feb 20 13:59 test2
-rw-r--r-- 1 sedu07 in0163  190 Feb 20 14:00 test2.tgz
drwxr-xr-x 3 sedu07 in0163 4096 Feb 20 14:01 test3
[sedu07@node8282 aaa]$ cat ori.txt
ls
Original file
[sedu07@node8282 aaa]$ cat sym.txt
ls
Original file

```
### 하드와 소프트링크

소프트는 다순한 링크고
하드링크는 연결에 업뎃되면 같이 업뎃



### 프로세스
#### 포그라운드
일반적으로 쓰는 작업 `./pi.x `
대기상태 다 끝날때까지 기다려야하는.
#### 백그라운드

백그라운드에서 실행 다른 작업 가능함.
`./pi.x &`

#### bg fg 
중간에 멈춘 실행파일은 이어서 할 수 있게 
* bg는 background
* fg는 foreground


jobs

## Vi Editor (vim vi)

* vi test.c
* i, I, a, A, o, O, R
* ESC


###
: 2,4 d

2번째부터 4번째줄까지 지워라.

### 명령취소


### 줄 번호 

:set nu

### 검색 /

### 치환
* :%s/old/new/g
% 있으면 전체 문서에서, 없으면 한 줄에서.

###  문자열 탐색 대소문자 구분 안 할때

* \c
   * :/\cabc
   
### 윈도우에서 작성된 파일을 vi로 열면 생기는 문제

^M

:%s/\^M//g


## 쉘
```
[sedu07@node8282 test2]$ echo $SHELL
/bin/bash
[sedu07@node8282 test2]$ cat /etc/shells
/bin/sh
/bin/bash
/sbin/nologin
/usr/bin/sh
/usr/bin/bash
/usr/sbin/nologin
/usr/bin/tmux
/bin/ksh
/bin/rksh
/bin/tcsh
/bin/csh
```
`$ echo $SHELL`
환경변수에서 지금 사용중인 쉘 확인

`$ cat /etc/shells`

사용가능 쉘 확인

### 쉘 스크립트 만들어서 모듈 추가 항상 해놓기.
vi ~/.bashrc 에서 

module add intel/18.0.3


!/bin/bash # 아래 오는 명령어들을 bash셀 명령으로 인식해라.

보통 스크립트할 때 이런 지정해주고 시장한다.

echo 'hello'
exit 0

sh ./test.sh

chmod +x test.sh.  색이 바뀔 것이다. 실행권한있는

chmod -r test.sh

```
!/bin/bash
 a="world"
  
 echo "Hello"
 echo $a
```

a='world' 여기서 띄어쓰기 하면 안됨. a = 'world' 이렇게 하면 실행 불가.

$? 이전 명령이 성공 했느냐? 성공했으면 0, 아니면 다른 숫자깞 에러코드가 나올것이ㅏㄷ.

" ' 차이가 크다.
" 이게 실제 "Hello"
' 이건 그냥 안의 내용 그냥 불러오기



``` '`'`'`'`'`'`'`'`''``'```'``'`'`'`'`'``'`''''````'''''''''''''''
$0
$1
$2
$@
$*"
$#"
```


## MAKE 컴파일

### 

## HPC 교육 2일차, 2019년 2월 21일 목요일
## HPC 교육 3일차, 2019년 2월 22일 금요일

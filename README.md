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

## 






## HPC 교육 2일차, 2019년 2월 21일 목요일



### 
## HPC 교육 3일차, 2019년 2월 22일 금요일

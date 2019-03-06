* 일정 : 2019/01/28 (1일)
* 장소 : 한국과학기술정보연구원(대전 카이스트)

# HPC 활용

## 성능결정요인

* Hertz(Machine cycle)
	* 높을 수록 좋다.
	* 프로세서의 동작주기

* CPI(Cycles Per Instruction)
	* 낮을 수록 좋다.
	* 명령어 당 소요 사이클 수
	* 진보된 스칼라 프로세서들의 CPI값 감소 목표
		* 파이프라이닝 Pipelined
		* 슈퍼스칼라 superscalar

* 파이프라이닝 기법

세탁기1대, 건조기1대가 있다고 할 때, 1번 사람이 빨래감을 세탁하고 건조하고, 다 끝나면 다음 2번 사람이 빨래감을 세탁기 쓰고 건조기 쓰고.. 이런 식으로 하면 한 세탁기와 건조기가 한 묶음으로 돌아가면서 한 사람이 다 끝날 때 까지 쓸 수가 없다. 그래서 나온 대안이 파이프라이닝 기법으로 1번 사람이 세탁기를 다 쓰고 건조기로 넘어가면 다음 사람이 놀고 있는 세탁기를 쓰면서 시간을 절약하는 방법이다. 

[Source](https://cs.stanford.edu/people/eroberts/courses/soco/projects/risc/pipelining/index.html)

이렇게 기다려야 했던 세탁기와 건조기가

![](https://cs.stanford.edu/people/eroberts/courses/soco/projects/risc/pipelining/laundry1.gif)

이런 식으로 하면서 시간이 절약! 참 그림 예제가 기가 막히다.

![](https://cs.stanford.edu/people/eroberts/courses/soco/projects/risc/pipelining/laundry2.gif)


* superscalar

한 프로세서 사이클 동안에 하나 이상의 명령어를 실행시쿨 수 있는 프로세서 아키텍쳐. 프로세서 아키텍쳐가 3개 있다면 명령량, 실행량도 3배. 동시에 가져와서 처리. 

Vectorization

* Flops
* 초당 수행할 수 있는 부동소수점(floating-point) 연산 횟수
* 단일 프로세서에 대한 일노 성능 Flops 계산
(프로세서의 clock 속도) * (cycle 당 명령처리 수 ) * (FPU 개수) * (FPU당 연산처리방식에 따른 변수)
* ex) (1.3GHz) * (1/inst./cycle) * (2FPU) = 2.6GFlops
* FPU는 부동소수점 연산장치
* 누리온은 15.7패타플롭 기가G 위에 테라T 위에 페타P, 10^15





## 큐 정책

* showq
* pbs_status
* qstats -Q 목록조회
* qstats -f 상세조회
* pbs_queue_check 현재 계정으로 사용 가능한 큐 리스트 조회
* pbs_queue_check -a 등록된 계산 노드 목록 조회
* pbs_queue_check -aSj 노드 사용 내역 조회
* qsub 작업제출 /scratch 에서만 가능
* qdel 제출작업삭제
* qstat 실행및대기중인 작업조회
* qstat -u 지정 계정 작업목록출력
* qstat -n 작업수행계산노드정보출력
* qstat -x 끝난작업
* qstat -xf 끝난작업 상세정보 
* qstat -u 지정계정 종료작업목록 출력
* qstat -xu sedu14 끝난작업 지정계정 sedu14 작업조회



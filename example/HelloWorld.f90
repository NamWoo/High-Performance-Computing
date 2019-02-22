PROGRAM helloworld      
IMPLICIT NONE           ! fortran 77에서 컴파일러가 지원, 90에서 표준
REAL::tx, ty, tz                ! 코드 중간에 주석 가능
INTEGER, PARAMETER::n=100, m=1000       ! 파라미터 선언과 동시에 설정
REAL::a=2.61828         ! 변수 선언과 동시에 초기화
REAL(KIND=8)::b=3.141592                        ! kind
CHARACTER(LEN=8)::ch                    ! len
INTEGER,DIMENSION(-3:5,7)::iaa          ! array

tx = 1.0;    ty = 2.0;    tz=tx*ty      ! 여러 개의 문 사용 가능
PRINT *, &              ! 라인 상에서 연속 기호 사용 가능
    tx, ty, tz
PRINT*,'n=',n, 'm=',m
PRINT*,'a=',a, 'b=',b
PRINT *, 'hello world'

END PROGRAM helloworld


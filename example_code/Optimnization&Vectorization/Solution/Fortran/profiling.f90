PROGRAM PROFILING
IMPLICIT NONE
INTEGER,PARAMETER::N=1000,ITERMAX=100
INTEGER::IT,I,J
REAL,DIMENSION(N,N)::B,C,D
REAL,DIMENSION(N)::A
INTEGER(KIND=8)::ST,ET,C_RATE
REAL(KIND=8)::DTIME, FLOPS

CALL RANDOM_NUMBER(B)
CALL RANDOM_NUMBER(C)
CALL RANDOM_NUMBER(D)

CALL SYSTEM_CLOCK(ST,C_RATE)
DO IT=1,ITERMAX
  DO J=1,N
    A(J)=VECSUM(B,J)+VECPROD(C,J)*VECSUM(D,J)
  END DO
  IF(MOD(IT,100)==0) WRITE(*,*) A(1),B(1,1),C(1,1),D(1,1)
END DO
CALL SYSTEM_CLOCK(ET)
DTIME=(ET-ST)/DBLE(C_RATE)
FLOPS=(1.0E-6*ITERMAX*N*(3*N+2))/DTIME
WRITE(*,100) DTIME
WRITE(*,200) FLOPS

100 FORMAT("loop time = ",f12.5," seconds")
200 FORMAT("loop runs at ",f15.5," MFLOPS")

CONTAINS
REAL FUNCTION VECSUM(X,J)
IMPLICIT NONE
REAL,DIMENSION(N,N),INTENT(IN)::X
INTEGER,INTENT(IN)::J
INTEGER::I
VECSUM=X(1,J)
DO I=2,N
  VECSUM=VECSUM+X(I,J)
END DO
END FUNCTION VECSUM

REAL FUNCTION VECPROD(X,J)
IMPLICIT NONE
REAL,DIMENSION(N,N),INTENT(IN)::X
INTEGER,INTENT(IN)::J
INTEGER::I
VECPROD=X(1,J)
DO I=2,N
  VECPROD=VECPROD*X(I,J)
END DO
END FUNCTION VECPROD

END PROGRAM PROFILING
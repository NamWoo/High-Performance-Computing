PROGRAM MATMUL_LIB
IMPLICIT NONE
!INTEGER,PARAMETER::N=2048*2
INTEGER,PARAMETER::N=512
INTEGER::I,J,K
INTEGER(KIND=8)::ST,ET,C_RATE
REAL(KIND=8)::DTIME
REAL(KIND=8),DIMENSION(N,N)::A,B,C
REAL(KIND=8)::C0,C1,C2,C3,TMP
REAL(KIND=8)::ALPHA=1.0D0, BETA=0.0D0

CALL RANDOM_NUMBER(A)
CALL RANDOM_NUMBER(B)
C=0.0

CALL SYSTEM_CLOCK(ST,C_RATE)
DO J=1,N
  DO I=1,N
    DO K=1,N
      C(I,J)=C(I,J)+A(I,K)*B(K,J)
    END DO
  END DO
END DO
CALL SYSTEM_CLOCK(ET)
DTIME=(ET-ST)/DBLE(C_RATE)
PRINT*,C(1,1)
PRINT*,'Original code(No Opt):',DTIME

C=0.0D0
CALL SYSTEM_CLOCK(ST,C_RATE)
CALL DGEMM('N','N',N,N,N,ALPHA,A,N,B,N,BETA,C,N)
CALL SYSTEM_CLOCK(ET)
DTIME=(ET-ST)/DBLE(C_RATE)
PRINT*,C(1,1)
PRINT*,'MKL(Opt):',DTIME
END PROGRAM MATMUL_LIB


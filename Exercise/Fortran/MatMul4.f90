PROGRAM MATMUL4
IMPLICIT NONE
INTEGER,PARAMETER::N=1024
INTEGER,PARAMETER::ND=N+1
!INTEGER,PARAMETER::ND=N
INTEGER::I,J,K
INTEGER(KIND=8)::ST,ET,C_RATE
REAL(KIND=8)::DTIME
REAL(KIND=8),DIMENSION(ND,ND)::A,B,C
REAL(KIND=8)::C0,C1,C2,C3,TMP

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
PRINT*,'Padding code(Opt):',DTIME

END PROGRAM MATMUL4

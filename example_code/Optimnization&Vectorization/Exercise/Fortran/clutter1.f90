PROGRAM CLUTER1
IMPLICIT NONE
INTEGER,PARAMETER:: N=10000
REAL(KIND=8),DIMENSION(N,N)::A,B
REAL(KIND=8):: C=12.5
INTEGER(KIND=8)::ST,ET,C_RATE
REAL(KIND=8)::DTIME
INTEGER::I,J

CALL RANDOM_NUMBER(A)
CALL RANDOM_NUMBER(B)

CALL SYSTEM_CLOCK(ST,C_RATE)
!!TODO
CALL SYSTEM_CLOCK(ET)
DTIME=(ET-ST)/DBLE(C_RATE)
WRITE(*,*)'No Inline : DTIME=',DTIME

CALL SYSTEM_CLOCK(ST,C_RATE)
!! TODO
CALL SYSTEM_CLOCK(ET)
DTIME=(ET-ST)/DBLE(C_RATE)
WRITE(*,*)'Inline : DTIME=',DTIME

END PROGRAM CLUTER1

SUBROUTINE MADD(A,B,C)
IMPLICIT NONE
REAL(KIND=8),INTENT(INOUT)::A
REAL(KIND=8),INTENT(IN)::B,C
  A=A+B*C
END SUBROUTINE MADD

PROGRAM MATMUL1
IMPLICIT NONE
INTEGER,PARAMETER::N=1024,NB=128
INTEGER,PARAMETER::ND=N+1
INTEGER::I,J,K,JB,IB,KB,IT
INTEGER(KIND=8)::ST,ET,C_RATE
REAL(KIND=8)::DTIME
REAL(KIND=8),DIMENSION(ND,ND)::A,B,C
REAL(KIND=8)::C0,C1,C2,C3,TEMP

CALL RANDOM_NUMBER(A)
CALL RANDOM_NUMBER(B)
C=0.0

C=0.0
CALL SYSTEM_CLOCK(ST,C_RATE)
DO KB=1,N,NB
    DO JB=1,N,NB
       DO IB=1,N,NB
          DO J=JB,MIN(N,JB+NB-1)
             DO I=IB,MIN(N-3,IB+NB-4),4
                C0=0.D0; C1=0.D0; C2=0.D0; C3=0.D0
                DO K=KB,MIN(N,KB+NB-1)
                   TEMP=B(K,J)
                   C0=C0+A(I,K)*TEMP
                   C1=C1+A(I+1,K)*TEMP
                   C2=C2+A(I+2,K)*TEMP
                   C3=C3+A(I+3,K)*TEMP
                END DO
                C(I,J)=C(I,J)+C0
                C(I+1,J)=C(I+1,J)+C1
                C(I+2,J)=C(I+2,J)+C2
                C(I+3,J)=C(I+3,J)+C3
             END DO
          END DO
       END DO
    END DO
 END DO
CALL SYSTEM_CLOCK(ET)
DTIME=(ET-ST)/DBLE(C_RATE)
PRINT*,C(1,1)
PRINT*,'Blocking+Unrolling+Padding(Opt):',DTIME

END PROGRAM MATMUL1

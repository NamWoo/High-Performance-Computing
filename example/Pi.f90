PROGRAM pi_cal
IMPLICIT NONE
REAL(KIND=4)::iStart, iEnd, ElapsedTime;
INTEGER(KIND=8)::num_step = 500000000
INTEGER(KIND=8)::i
REAL(KIND=8)::sum, step, pi,x
step=(1.0D0/DBLE(num_step))
sum=0.0D0
CALL CPU_TIME(iStart)

PRINT*,'------------------------------'
DO i=1,num_step
    x=(DBLE(i)-0.5)*step
    sum = sum + 4.0d0/(1.0d0+x*x)
END DO
pi = step*sum
CALL CPU_TIME(iEnd)
ElapsedTime = iEnd-iStart
PRINT*,'PI =',pi,'(ERROR = ',DABS(pi-ACOS(-1.0D0)),')'
PRINT*,'Elapsed Time[sec.]=',ElapsedTime
PRINT*,'------------------------------'
END PROGRAM pi_cal


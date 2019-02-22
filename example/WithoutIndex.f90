PROGRAM WithoutIndex
IMPLICIT NONE
INTEGER:: i=0,j=0
DO
    i=i+1
    IF(MOD(I,2)==0) CYCLE
    IF(i>10) EXIT
    PRINT*,'i=',i
END DO

PRINT*,''
DO WHILE(j<=10)
   j=j+1
   IF(MOD(j,2)==1)CYCLE
   PRINT*,'j=',j
END DO

END PROGRAM WithoutIndex


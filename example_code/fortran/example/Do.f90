PROGRAM do_ex
IMPLICIT NONE
INTEGER::i, total=0

EX1: DO i=1,10
         total = total +i
     END DO EX1

PRINT*,'SUM=',total
END PROGRAM do_ex


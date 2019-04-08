PROGRAM assumedshape
IMPLICIT NONE
INTERFACE
SUBROUTINE sub(ra, rb, rc)
INTEGER, DIMENSION(:,:),INTENT(IN)::ra, rb
INTEGER, DIMENSION(0:,2:),INTENT(IN)::rc
END SUBROUTINE sub
END INTERFACE
INTEGER::ra(3,3), rb(2,2)
INTEGER::rc1(0:2,2:2), rc2(0:3,2:3)
INTEGER::i
ra=RESHAPE((/(i,i=1,9)/),(/3,3/))
rb=RESHAPE((/(i,i=1,4)/),(/2,2/))
rc1=RESHAPE((/(i,i=1,3)/),(/3,1/))
rc2=RESHAPE((/(i,i=1,8)/),(/4,2/))
CALL sub(ra,rb,rc1)
CALL sub(rb,ra,rc2)

END PROGRAM assumedshape

SUBROUTINE sub(ra, rb, rc)
INTEGER, DIMENSION(:,:),INTENT(IN)::ra, rb
INTEGER, DIMENSION(0:,2:),INTENT(IN)::rc
PRINT*,'ra=',ra
PRINT*,'rb=',rb
PRINT*,'rc=',rc
END SUBROUTINE sub


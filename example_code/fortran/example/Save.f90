PROGRAM save_ex
IMPLICIT NONE
CALL save_routine
CALL save_routine
END PROGRAM save_ex

SUBROUTINE save_routine
IMPLICIT NONE
INTEGER, SAVE::i
i=10
I=I+1
PRINT*,'I=',i
END SUBROUTINE save_routine


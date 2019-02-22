MODULE test_module
IMPLICIT NONE
PRIVATE
INTEGER,PUBLIC::i=1,j=2

INTEGER::a=10,b=20
END MODULE test_module

PROGRAM module_test
USE test_module
IMPLICIT NONE
PRINT*,'i=',i,'j=',j
PRINT*,'a=',a,'b=',b
END PROGRAM module_test


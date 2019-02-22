MODULE module_swap
IMPLICIT NONE
INTERFACE swap
    MODULE PROCEDURE swapreal, swapint
END INTERFACE swap

CONTAINS
    SUBROUTINE swapreal(a,b)
    IMPLICIT NONE
    REAL, INTENT(INOUT)::a,b
    REAL::tmp
    tmp=a;     a=b;     b=tmp
    END SUBROUTINE swapreal

    SUBROUTINE swapint(a,b)
    IMPLICIT NONE
    INTEGER,INTENT(INOUT)::a,b
    INTEGER::tmp
    tmp=a;    a=b;     b=tmp
    END SUBROUTINE swapint
END MODULE module_swap

PROGRAM main
USE module_swap
IMPLICIT NONE
INTEGER::i=1, j=2
REAL::x=1.0,y=2.0
PRINT*,'i=',i,'j=',j
CALL swap(i,j)
PRINT*,'  ==>i=',i,'j=',j
PRINT*,'x=',x,'y=',y
CALL swap(x,y)
PRINT*,'  ==>x=',x,'y=',y
END PROGRAM main


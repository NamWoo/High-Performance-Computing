PROGRAM keyword
IMPLICIT NONE
INTERFACE
    SUBROUTINE axis(x0, y0, l,min,max,i)
    IMPLICIT NONE
    REAL,INTENT(IN)::x0, y0, l, min, max
    INTEGER,INTENT(IN)::i
    END SUBROUTINE axis
END INTERFACE

CALL axis(0.0, 0.0, 100.0, 0.1, 1.0, 10)
PRINT*,'-------------------'
CALL axis(0.0, 0.0, max=1.0, min=0.1, l=100.0, i=10)
END PROGRAM keyword

SUBROUTINE axis(x0, y0, l,min,max,i)
IMPLICIT NONE
REAL,INTENT(IN)::x0, y0, l, min, max
INTEGER,INTENT(IN)::i
PRINT*,'X0=',x0
PRINT*,'Y0=',y0
PRINT*,'L=',l
PRINT*,'MIN=',min
PRINT*,'MAX=',max
PRINT*,'I=',i
END SUBROUTINE axis


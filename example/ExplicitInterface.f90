PROGRAM Internal
IMPLICIT NONE
INTEGER::i=3,j=25
REAL::x=3.0, y=25.0
PRINT*,'The ratio is ', ratio(i,j)
PRINT*,'The ratio is ', ratio(x)

CONTAINS
    REAL FUNCTION ratio(x,y)
    REAL::x,y
    ratio = x/y
    END FUNCTION ratio
END PROGRAM Internal


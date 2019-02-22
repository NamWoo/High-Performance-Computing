PROGRAM test
IMPLICIT NONE
INTEGER::i=3,j=25
REAL::ratio
PRINT*,'The ratio is ', ratio(i,j)
PRINT*,'The ratio is ', ratio(i)
END PROGRAM test

REAL FUNCTION ratio(x,y)
REAL::x,y
ratio = x/y
END FUNCTION ratio


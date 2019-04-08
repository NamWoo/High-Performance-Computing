PROGRAM pointervaluedfunction
IMPLICIT NONE
INTERFACE
  FUNCTION gtzero(a)
  REAL,DIMENSION(:), POINTER::gtzero
  REAL,DIMENSION(:)::a
  INTEGER::n, k
  END FUNCTION gtzero
END INTERFACE
INTEGER::s, i
REAL,DIMENSION(100)::x
REAL,DIMENSION(:),POINTER::p
PRINT*,'seed=';
READ*, s
CALL SRAND(s)
DO I=1,100
    x(I)=RAND()-0.5
END DO
p=>gtzero(x)
DO i=1, SIZE(p)
    PRINT*,i,p(i)
END DO
END PROGRAM pointervaluedfunction

FUNCTION gtzero(a)
REAL,DIMENSION(:), POINTER::gtzero
REAL,DIMENSION(:)::a
INTEGER::n=0, k=0
DO i=1,100
    IF(a(i)>0.0)n=n+1
END DO
PRINT*,n
ALLOCATE(gtzero(n))
DO i=1,100
    IF(a(i)>0.0)THEN
        k=k+1
        gtzero(k)=a(i)
    END IF
END DO
END FUNCTION gtzero


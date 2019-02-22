PROGRAM pure_ex
IMPLICIT NONE
INTEGER::a=1,b=1

CALL pure_test(a,b)
PRINT*,'B=',b
PRINT*,'B=',pure_func(a,b)

CONTAINS
PURE SUBROUTINE pure_test(a,b)
    IMPLICIT NONE
    INTEGER,INTENT(IN)::a
    INTEGER,INTENT(OUT)::b
    b=a+1
END SUBROUTINE pure_test
PURE INTEGER FUNCTION pure_func(a,b)
    IMPLICIT NONE
    INTEGER,INTENT(IN)::a,b
    pure_func=a+b
END FUNCTION pure_func
END PROGRAM pure_ex


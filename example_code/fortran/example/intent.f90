PROGRAM intent_ex
IMPLICIT NONE
REAL::x,y
y=5.0
CALL mistaken(x,y)
PRINT*, x
CONTAINS
    SUBROUTINE mistaken(a,b)
        IMPLICIT NONE
        REAL,INTENT(IN)::a
        REAL,INTENT(OUT)::b
!        REAL::a,b
        a=2*b
    END SUBROUTINE mistaken
END PROGRAM intent_ex


MODULE overloading
IMPLICIT NONE
TYPE rational
    REAL::num, denom
END TYPE rational
INTERFACE COS
    MODULE PROCEDURE rational_cos
END INTERFACE
CONTAINS
FUNCTION rational_cos(x)
IMPLICIT NONE
TYPE(rational),INTENT(IN)::x
REAL::rational_cos,q
q=x%num/x%denom
rational_cos=COS(q)
END FUNCTION
END MODULE overloading

PROGRAM main
USE overloading
IMPLICIT NONE
REAL::x=0.5
TYPE(rational)::y=rational(1.0, 2.0)
PRINT*,'cos(x)=',COS(x)
PRINT*,'cos(y)=',COS(y)

END PROGRAM main


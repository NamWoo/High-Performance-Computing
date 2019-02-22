MODULE point_def
IMPLICIT NONE
TYPE point
    REAL::x,y
END TYPE point
INTERFACE OPERATOR(.dist.)
    MODULE PROCEDURE caldist
END INTERFACE
CONTAINS
REAL FUNCTION caldist(p1,p2)
IMPLICIT NONE
TYPE(point),INTENT(IN)::p1,p2
caldist=SQRT((p1%x-p2%x)**2+(p1%y-p2%y)**2)
END FUNCTION caldist
END MODULE point_def

PROGRAM main
USE point_def
TYPE(point)::p1, p2
REAL::distance
p1%x=1.0;   p1%y=1.0
p2%x=2.0;   p2%y=2.0
distance=p1.dist.p2
PRINT*,'distance between p1 and p2: ', distance
END PROGRAM main


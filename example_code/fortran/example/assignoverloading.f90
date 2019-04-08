MODULE point_def
IMPLICIT NONE
TYPE point
    REAL::x,y
END TYPE point
INTERFACE ASSIGNMENT(=)
    MODULE PROCEDURE assign_point
END INTERFACE
CONTAINS
SUBROUTINE assign_point(p1, p2)
IMPLICIT NONE
TYPE(point),INTENT(OUT)::p1
TYPE(point),INTENT(IN)::p2
p1%x=p2%x;   p1%y=p2%y
END SUBROUTINE assign_point
END MODULE point_def

PROGRAM main
USE point_def
TYPE(point)::p1=point(0.0, 0.0), p2=point(1.0, 1.0)
PRINT*,'before : (',p1%x,',',p1%y,')'
p1=p2
PRINT*,'after : (',p1%x,',',p1%y,')'
END PROGRAM main


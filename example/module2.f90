MODULE coord
IMPLICIT NONE
PRIVATE
TYPE,PUBLIC::coord_3d
  REAL,PRIVATE::x,y,z
END TYPE coord_3d
PUBLIC::set_coord, get_coord
CONTAINS
SUBROUTINE set_coord(pa,x,y,z)
IMPLICIT NONE
REAL, INTENT(IN)::x,y,z
TYPE(coord_3d),INTENT(INOUT)::pa
pa%x=x;  pa%y=y;   pa%z=z
END SUBROUTINE set_coord
SUBROUTINE get_coord(pa,x,y,z)
IMPLICIT NONE
REAL,INTENT(OUT)::x,y,z
TYPE(coord_3d),INTENT(IN)::pa
x=pa%x; y=pa%y;  z=pa%z
END SUBROUTINE get_coord
END MODULE coord

PROGRAM DerivedType
USE coord
IMPLICIT NONE

TYPE(coord_3d)::pt1, pt2, pt3
REAL::x,y,z
CALL set_coord(pt1,1.0,1.0,1.0) !pt1 값 설정
CALL get_coord(pt1,x,y,z) !값을 얻어옴
!pt1%x=1.0;     pt1%y=1.0;    pt1%z=1.0  ! error
! pt3=coord_3d(3.0, 3.0, 3.0)  ! error
PRINT*,x,y,z
END PROGRAM DerivedType


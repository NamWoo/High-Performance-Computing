PROGRAM DerivedType
IMPLICIT NONE
TYPE coord_3d
    REAL::x,y,z
END TYPE coord_3d
TYPE(coord_3d)::pt1, pt2=coord_3d(2.0, 2.0, 2.0), pt3
pt1%x=1.0;     pt1%y=1.0;    pt1%z=1.0
pt3=coord_3d(3.0, 3.0, 3.0)
PRINT*,pt1%x, pt1%y, pt1%z;   PRINT*,pt2%x, pt2%y, pt2%z
PRINT*,pt3%x, pt3%y, pt3%z
END PROGRAM DerivedType


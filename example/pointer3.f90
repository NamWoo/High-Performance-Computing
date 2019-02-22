PROGRAM main
REAL,DIMENSION(:),POINTER::pv1
REAL,DIMENSION(:,:),POINTER::pv2
REAL,DIMENSION(-3:5),TARGET::tv1=0
REAL,DIMENSION(4,8),TARGET::tv=0

pv1=>tv1
PRINT*,LBOUND(pv1), UBOUND(pv1)

pv1=>tv1(:)
PRINT*,LBOUND(pv1), UBOUND(pv1)

pv1(10:)=>tv1(:)
PRINT*,LBOUND(pv1), UBOUND(pv1)

pv1=>tv1(1:5:2)
PRINT*,LBOUND(pv1), UBOUND(pv1)

pv1(-10:)=>tv1(1:5:2)
PRINT*,LBOUND(pv1), UBOUND(pv1)
!=========================
pv1=>tv(4,:)
PRINT*,LBOUND(pv1), UBOUND(pv1)

pv1(10:)=>tv(4,:)
PRINT*,LBOUND(pv1), UBOUND(pv1)


pv2=>tv(2:4,4:8)
PRINT*,LBOUND(pv2), UBOUND(pv2)
END PROGRAM main


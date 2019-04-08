PROGRAM ptr
IMPLICIT NONE
REAL,POINTER::ptor
REAL,DIMENSION(:,:),POINTER::ptoa
REAL,TARGET::x,y
REAL,TARGET::a(2,2), b(10), c(3,3)
a=RESHAPE((/1.,2.,3.,4./),(/2,2/))
c=RESHAPE((/1.,2.,3.,4.,5.,6.,7.,8.,9./),(/3,3/))
x=10.0;   y=20.0
ptor=>x
PRINT*,'ptor=',ptor
ptor=>y
PRINT*,'ptor=',ptor
y=1.0
PRINT*,'ptor=',ptor
ptor=100.0
PRINT*,'ptor=',ptor
ptoa=>a
PRINT*,'ptoa=',ptoa
ptoa=>c
PRINT*,'ptoa=',ptoa
ptoa(1,1)=100.0
PRINT*,'ptoa=',ptoa
!ptoa=>b       ! 
END PROGRAM ptr


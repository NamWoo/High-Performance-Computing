PROGRAM reshape_ex
IMPLICIT NONE
INTEGER,DIMENSION(2,2)::a
INTEGER,DIMENSION(2,3)::b

a=RESHAPE((/1,2,3,4/),(/2,2/))
PRINT*,a(1,:)
PRINT*,a(2,:)
PRINT*,''
a=RESHAPE((/1,2,3,4/),(/2,2/),ORDER=(/1,2/))
PRINT*,a(1,:)
PRINT*,a(2,:)
PRINT*,''
a=RESHAPE((/1,2,3,4/),(/2,2/),ORDER=(/2,1/))
PRINT*,a(1,:)
PRINT*,a(2,:)
PRINT*,''
b=RESHAPE((/1,2,3,4/),(/2,3/),(/0/),(/2,1/))
PRINT*,b(1,:)
PRINT*,b(2,:)

END PROGRAM reshape_ex


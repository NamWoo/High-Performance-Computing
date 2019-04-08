PROGRAM parameter_ex
IMPLICIT NONE
INTEGER(KIND=4),PARAMETER::a=10
REAL(KIND=8),PARAMETER::PI=ACOS(-1d0)

!a=11           ! Error – Not allowed

PRINT*,'a=',a
PRINT*,'PI=',PI
END PROGRAM parameter_ex


PROGRAM statefunction
IMPLICIT NONE
INTEGER::a,b
INTEGER::plus_one
REAL(KIND=8)::e,m
REAL(KIND=8),PARAMETER::C=299792458D0
plus_one(a) = a+1
e(m) = m*c**2

a=10
b=plus_one(a)
PRINT*,'a=',a,'   b=',b

m=1d-3
PRINT*,'energy=',e(m)

END PROGRAM statefunction


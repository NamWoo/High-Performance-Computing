PROGRAM mc_pi
IMPLICIT NONE
INTEGER(KIND=8)::i,scope=100000000
REAL(kind=8)::x,y,z, pi, z1, in_count=0.0, out_count=0.0
INTEGER::seed=1234

CALL srand(seed)
DO i=0,scope-1
    x=rand();   y=rand()
    z=x*x+y*y
!    z1=SQRT(z)

!    IF(z1<=1)THEN
    IF(Z<=1)THEN
        in_count=in_count+1
    ELSE
        out_count=out_count+1
    END IF
END DO
pi=(4*in_count)/(in_count+out_count)
WRITE(*,'(A,F15.10,2X,A,E15.10)')'pi=',pi,&
'Error=',DABS(pi-ACOS(-1.0d0))

END PROGRAM mc_pi


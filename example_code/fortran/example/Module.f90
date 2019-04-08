PROGRAM test
USE m1, m1_a=>a, m1_r=>routine
USE m2,m2_a=>a, m2_r=>routine
IMPLICIT NONE
INTEGER::a=10
PRINT*,'m1(a)',m1_a
PRINT*,'m2(a)',m2_a
CALL m1_r
CALL m2_r
END PROGRAM test


PROGRAM const
IMPLICIT NONE
INTEGER,PARAMETER::MY_KIND=16
REAL(KIND=8)::dp
REAL(KIND=4)::sp
REAL(KIND=MY_KIND)::mk_p
sp = 3.1_4
dp = 3.1_8
mk_p = 3.1_MY_KIND
PRINT*,'sp=3.3 : ', sp
PRINT*,'dp=3.3 : ', dp
PRINT*,'mk_p=3.3: ', mk_p
END PROGRAM const


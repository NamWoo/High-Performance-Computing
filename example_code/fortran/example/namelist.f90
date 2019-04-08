PROGRAM namelist_ex
IMPLICIT NONE
INTEGER::i,j
REAL::a,b
CHARACTER(LEN=10)::lan,string
NAMELIST /inputs/ i,a,lan
NAMELIST /arguments/ j, b, string
READ(*,NML=arguments)
WRITE(*,NML=arguments)

OPEN(UNIT=10,FILE='input.txt',STATUS='OLD')
OPEN(UNIT=20,FILE='output.txt',STATUS='REPLACE')
READ(10,NML=inputs)
PRINT*,i,a,lan
WRITE(20,NML=inputs)
CLOSE(10)
CLOSE(20)
END PROGRAM namelist_ex



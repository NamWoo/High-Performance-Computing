PROGRAM optional_ex
IMPLICIT NONE
INTEGER::ierr
CALL see_routine()
CALL see_routine(a=2.0)
CALL see_routine(b=3)
CALL see_routine(b=3,a=2.0)
PRINT*,'-------------'
ierr=see_func()
ierr=see_func(a=2.0)
ierr=see_func(b=3)
ierr=see_func(b=3,a=2.0)

CONTAINS
SUBROUTINE see_routine(a,b)
IMPLICIT NONE
REAL,INTENT(IN),OPTIONAL::a
INTEGER,INTENT(IN),OPTIONAL::b
REAL::ay
INTEGER::bee
ay=1.0;   bee=1
IF(PRESENT(a)) ay=a
IF(PRESENT(b)) bee=b
PRINT*,'ay=',ay,'bee=',bee
END SUBROUTINE see_routine

INTEGER FUNCTION see_func(a,b)
IMPLICIT NONE
REAL,INTENT(IN),OPTIONAL::a
INTEGER,INTENT(IN),OPTIONAL::b
REAL::ay
INTEGER::bee
ay=1.0;   bee=1

IF(PRESENT(a)) ay=a
IF(PRESENT(b)) bee=b
PRINT*,'ay=',ay,'bee=',bee
see_func=1
END FUNCTION see_func
END PROGRAM optional_ex


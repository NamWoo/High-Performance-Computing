PROGRAM allocate_ex
IMPLICIT NONE
INTEGER,ALLOCATABLE::a(:),b(:)
INTEGER::istat
CHARACTER(len=80)::string="Success"
ALLOCATE(a(5),SOURCE=1, STAT=istat,ERRMSG=string)
ALLOCATE(b,SOURCE=a*10)
PRINT*,'STAT : ',istat, 'ERRMSG : ',TRIM(string)
PRINT*,a
PRINT*,b
END PROGRAM allocate_ex


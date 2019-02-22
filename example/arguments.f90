PROGRAM arguments
IMPLICIT NONE
INTEGER::i,num_args, num_pt
CHARACTER(LEN=10),ALLOCATABLE::cmd(:)
CHARACTER(LEN=80)::p_name
CALL GET_COMMAND_ARGUMENT(0,p_name)
PRINT*,'program name :', p_name
num_args=COMMAND_ARGUMENT_COUNT()
IF(num_args /= 2)THEN
  PRINT*,'# of arguments must be euqal to 2.'
ENDIF
PRINT*,'# of arguments:',num_args

ALLOCATE(cmd(num_args))

IF(num_args /= 0)THEN
  DO i=1,num_args
    CALL GET_COMMAND_ARGUMENT(i, cmd(i))
!    PRINT*,TRIM(cmd(i))
  END DO
ENDIF
IF(cmd(1)=='-n')THEN
  PRINT *,'# of points is '//TRIM(cmd(2))//'.'
  READ(cmd(2),'(I3)') num_pt
  PRINT*,'num_pt+100:',num_pt+100
ELSE
  PRINT *, '[Usage] : ./arguments -n [# of points]'
ENDIF
DEALLOCATE(cmd)
END PROGRAM arguments


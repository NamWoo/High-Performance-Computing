PROGRAM env_ex
IMPLICIT NONE
CHARACTER(LEN=255)::pwd, home
CALL GET_ENVIRONMENT_VARIABLE("PWD",pwd)
CALL GET_ENVIRONMENT_VARIABLE("HOME",home)
IF(pwd /= home)THEN
   PRINT*,'Current directory is '//TRIM(pwd)
   PRINT*,'Your home directory is '//TRIM(home)
   PRINT*,'Program must be run in home directory.!!!'
   RETURN
else
   PRINT*,'Good!!!!'
ENDIF
END PROGRAM env_ex


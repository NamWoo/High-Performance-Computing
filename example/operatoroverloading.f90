MODULE string
INTERFACE OPERATOR(+)
    MODULE PROCEDURE concat
END INTERFACE
CONTAINS
FUNCTION concat(cha, chb)
    CHARACTER(LEN=*),INTENT(IN)::cha, chb
    CHARACTER(LEN=LEN_TRIM(cha)+LEN_TRIM(chb)+1)::concat
    concat=TRIM(cha)//' '//TRIM(chb)
END FUNCTION concat
END MODULE string

PROGRAM main
USE string
IMPLICIT NONE
CHARACTER(LEN=30)::First_name, Last_Name
First_name='GilDong'
Last_name = 'Hong'
PRINT*,TRIM(First_name)//' '//TRIM(Last_name)
PRINT*,concat(First_name, Last_Name)
PRINT*,First_name+Last_Name
END PROGRAM main



PROGRAM stream
IMPLICIT NONE
INTEGER,PARAMETER::SEEK_SET=0, SEEK_CUR=1, SEEK_END=2
INTEGER::i

INTEGER::array(10)=0
OPEN(10,FILE='stream_ex.dat',ACCESS='STREAM')
DO i=1,200
    WRITE(10)i
END DO
CLOSE(10)

OPEN(10,FILE='stream_ex.dat',ACCESS='STREAM')
PRINT*,'Size of Integer:',STORAGE_SIZE(I)/8
WRITE(*,*)'1:',FTELL(10)
CALL FSEEK(10,40,SEEK_SET)
WRITE(*,*)'2:',FTELL(10)
READ(10)array(1:10)
WRITE(*,*)ARRAY
CALL FSEEK(10,40,SEEK_CUR)
READ(10)array(1:10)
WRITE(*,*)array
WRITE(*,*)'3:',FTELL(10)
READ(10)array(1:10)
WRITE(*,*)array

CLOSE(10)
END PROGRAM stream
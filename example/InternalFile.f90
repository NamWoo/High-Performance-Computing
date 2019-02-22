PROGRAM InternalFile
IMPLICIT NONE
INTEGER::i,j
CHARACTER(LEN=3)::ch
CHARACTER(LEN=13)::outputfile(10)

DO I=1,10
  WRITE(ch,'(I3.3)') i
  outputfile(i)='output'//ch//'.txt'
  OPEN(UNIT=10,FILE=outputfile(i))
    WRITE(10,'(I3.3)')i
  CLOSE(10)
END DO
END PROGRAM InternalFile

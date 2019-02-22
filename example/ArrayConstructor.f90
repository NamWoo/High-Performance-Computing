PROGRAM ArrayConstructor
IMPLICIT NONE
INTEGER::i,j,idx=1
INTEGER::a(6),b(6)

DO J=1,2
  DO I=1,3
    a(idx)=i+j
    idx=idx+1
  END DO
END DO
b=(/((i+j,i=1,3),j=1,2)/)
PRINT *, a-b
END PROGRAM ArrayConstructor

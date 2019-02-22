PROGRAM arrayinitializer
IMPLICIT NONE
REAL,DIMENSION(3,3)::a,b
REAL,DIMENSION(9)::c
INTEGER::i,j,k
a=RESHAPE((/(k,k=1,9)/),(/3,3/))
c=(/a+1.3/)
b=RESHAPE(c,(/3,3/))
PRINT*,'----------------'
DO i=1,3
    PRINT*,b(i,:)
END DO
!--------------
c=(/ ((a(j,k)+1.3, j=1,3),k=1,3) /)
b=RESHAPE(c,(/3,3/))
PRINT*,'----------------'
DO i=1,3
    PRINT*,b(i,:)
END DO
!-----------------
c=(/ ((a(j,k)+1.3, k=1,3),j=1,3) /)
b=RESHAPE(c,(/3,3/))
PRINT*,'----------------'
DO i=1,3
    PRINT*,b(i,:)
END DO
END PROGRAM arrayinitializer


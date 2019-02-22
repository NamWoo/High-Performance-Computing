PROGRAM forall_ex
IMPLICIT NONE
REAL,DIMENSION(3,3)::a=RESHAPE((/1,2,3,4,5,6,7,8,9/),(/3,3/))
INTEGER::i,j
PRINT*,'a=(BEFORE)',a
FORALL(i=1:3,j=1:3,j>i)a(i,j)=a(j,i)
PRINT*,'------------------'
PRINT*,'a=(AFTER)',a
END PROGRAM forall_ex


PROGRAM array_func_norm

IMPLICIT NONE
INTEGER, PARAMETER :: NumItems = 5
REAL, DIMENSION(NumItems) :: A

A = (/1,2,3,4,5/)
!A = (/I,I=1,5/)

PRINT '(1X, "Array A = (", 5F6.2 ,")")' , A(:)
PRINT '(1X, "Norm of the array A is", F6.2)', Norm(A)

CONTAINS
        FUNCTION Norm(A)
                REAL, INTENT(IN) :: A(:)
                REAL :: Norm
                Norm = SQRT(SUM(A*A))
        END FUNCTION Norm
END PROGRAM array_func_norm


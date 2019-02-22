PROGRAM array_func_mean1

IMPLICIT NONE
INTEGER, PARAMETER :: NumItems = 5
REAL, DIMENSION(NumItems) :: a

a = (/1,2,3,4,5/)
!A = (/I,I=1,5/)

PRINT '(1X, "Array A = (", 5F6.2 ,")")' , a(:)
PRINT '(1X, "Mean of the array A is", F6.2)',mean(a)

CONTAINS
        FUNCTION mean(x)
        
                INTEGER, PARAMETER :: NumElements = 5
                REAL, DIMENSION(NumElements), INTENT(IN) :: x
                REAL :: mean
                
                mean = SUM(X) / REAL(NumElements)
        
        END FUNCTION mean
        
END PROGRAM array_func_mean1


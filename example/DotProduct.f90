PROGRAM array_func_dot

IMPLICIT NONE
INTEGER, PARAMETER :: NumItems = 5
REAL, DIMENSION(NumItems) :: A, B

A = (/1,2,3,4,5/)
B = (/1,2,3,4,5/)

PRINT '(1X, "Dot Product define function : ", F6.2)',  dot(a,b,NumItems)
PRINT '(1X, "Dot Product array function : ", F6.2)',  DOT_PRODUCT(A,B)

CONTAINS
        REAL FUNCTION dot(a,b,n)
                INTEGER i
                INTEGER, INTENT(IN) :: n
                REAL, DIMENSION(N), INTENT(IN) :: a, b
           
                dot=0.0
                DO i = 1, n
                        dot = dot + a(i) * b(i)
                END DO
        END FUNCTION dot
END PROGRAM array_func_dot


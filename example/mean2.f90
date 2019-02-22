PROGRAM array_func_mean2

IMPLICIT NONE
        REAL, DIMENSION(:), ALLOCATABLE :: Item
        INTEGER :: NumItems

        WRITE (*, '(1X, A)', ADVANCE = 'NO')  "How many numbers are in the data set?"
        READ *, NumItems

        ALLOCATE(Item(NumItems))

        PRINT *, "Enter the", NumItems, "real numbers:"
        READ *, Item

        PRINT '(1X, "Mean of the ", I3, " Numbers is ", F6.2)',NumItems, Mean(Item)
        DEALLOCATE(Item)

CONTAINS        
        FUNCTION Mean(X)
        
                REAL :: Mean
                REAL, DIMENSION(:), INTENT(IN) :: x
                
                Mean = SUM(x) / REAL(SIZE(x))

        END FUNCTION Mean
        
END PROGRAM array_func_mean2


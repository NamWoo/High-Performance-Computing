PROGRAM allocate_fun
PRINT*,test_alloc_fun(5)
CONTAINS
    FUNCTION test_alloc_fun(N)
    IMPLICIT NONE
    INTEGER, INTENT(IN)::N
    REAL, ALLOCATABLE, DIMENSION(:)::test_alloc_fun
    INTEGER::i
    ALLOCATE(test_alloc_fun(N))
    DO i=1,N
        test_alloc_fun(i)=i
    END DO
    END FUNCTION test_alloc_fun
END PROGRAM allocate_fun


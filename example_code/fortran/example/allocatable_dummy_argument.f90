PROGRAM allocate_ex
IMPLICIT NONE
REAL,DIMENSION(:),ALLOCATABLE::arr
CALL test_alloc(arr)
PRINT*,arr*10
IF(ALLOCATED(arr)) DEALLOCATE(arr)

CONTAINS
    SUBROUTINE test_alloc(array)
    IMPLICIT NONE
    REAL, DIMENSION(:),ALLOCATABLE,INTENT(INOUT)::array
    IF(ALLOCATED(array)) DEALLOCATE(array)
    ALLOCATE(array(5),SOURCE=1.0)
    PRINT*,array
    END SUBROUTINE test_alloc
END PROGRAM allocate_ex

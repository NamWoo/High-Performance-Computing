PROGRAM derived_pointer_array
IMPLICIT NONE
TYPE varray
    INTEGER, DIMENSION(:), POINTER::vdat
    INTEGER,DIMENSION(:),ALLOCATABLE::a
END TYPE varray
TYPE(varray)::p1
INTEGER::i
ALLOCATE(p1%a(5))
p1%a=(/(i,i=1,5)/)
PRINT*,p1%a
DEALLOCATE(p1%a)

ALLOCATE(p1%a(10))
p1%a=(/(i,i=1,10)/)
PRINT*,p1%a
DEALLOCATE(p1%a)
END PROGRAM derived_pointer_array


PROGRAM derived_pointer_array
IMPLICIT NONE
TYPE varray
    INTEGER, DIMENSION(:), POINTER::vdat
    INTEGER,DIMENSION(:),ALLOCATABLE::a
END TYPE varray
TYPE(varray)::p1
INTEGER::i
ALLOCATE(p1%vdat(5))
p1%vdat=(/(i,i=1,5)/)
PRINT*,p1%vdat
DEALLOCATE(p1%vdat)

ALLOCATE(p1%vdat(10))
p1%vdat=(/(i,i=1,10)/)
PRINT*,p1%vdat
DEALLOCATE(p1%vdat)
END PROGRAM derived_pointer_array


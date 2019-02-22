PROGRAM main
IMPLICIT NONE
TYPE node
  INTEGER::value
  TYPE(node),POINTER::next
END TYPE node

INTEGER::num
TYPE(node),POINTER::list, current
NULLIFY(list)
DO
  READ*,num
  IF(num==0)EXIT
  ALLOCATE(current)
  current%value=num
  current%next => list
  list=>current
END DO

DO
  IF(.NOT. ASSOCIATED(list%next))THEN
    PRINT*,list%value
    EXIT
  END IF
  PRINT*,current%value
  current=>list%next
  list=>current
END DO
END PROGRAM main


PROGRAM value_test
IMPLICIT NONE
REAL:: x=1.1
CALL call_by_value(x)
PRINT*,'in Main', x  ! produce 1.1
CALL call_by_reference(x)
PRINT*,'in Main', x  ! produce 2.2
CONTAINS

SUBROUTINE call_by_value(d)
  REAL, VALUE::d
  d = 2*d
  print*,'in CALL_BY_VALUE', d  ! produce 2.2
END SUBROUTINE call_by_value
SUBROUTINE call_by_reference(d)
  REAL::d
  d = 2*d
  print*,'in CALL_BY_REFERENCE',d
END SUBROUTINE call_by_reference
END PROGRAM value_test


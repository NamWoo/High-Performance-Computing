MODULE type_def
USE, INTRINSIC::ISO_C_BINDING
IMPLICIT NONE
PRIVATE
TYPE, PUBLIC, BIND(C)::t_type
    INTEGER(KIND=C_INT)::count
    REAL(KIND=C_FLOAT)::data
END TYPE t_type
END MODULE type_def

PROGRAM fortran_calls_c
USE type_def
USE, INTRINSIC::ISO_C_BINDING
IMPLICIT NONE
TYPE(t_type)::t
REAL(KIND=C_FLOAT)::x, y
INTEGER(KIND=C_INT), DIMENSION(0:1,0:2)::a
INTERFACE
  SUBROUTINE C(tp, arr, a, b, m) BIND(C)
    IMPORT::C_FLOAT, C_INT, C_CHAR, t_type
    type(t_type)::tp
    INTEGER(KIND=C_INT), DIMENSION(0:1, 0:2)::arr
    REAL(KIND=C_FLOAT)::a,b
    CHARACTER(KIND=C_CHAR), DIMENSION(*)::m
  END SUBROUTINE C
END INTERFACE
t = t_type(count=99, data=9.9)
x = 1.1
a = reshape([1,2,3,4,5,6], shape(a))
CALL C(t, a, x, y, "doubling x" // c_null_char)
print*,x, y
print*,t
print*, a
END PROGRAM fortran_calls_c


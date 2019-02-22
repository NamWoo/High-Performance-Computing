PROGRAM recursive_ex
IMPLICIT NONE
INTEGER::n, res
PRINT*,'ENTER THE POSITIVE INTEGER '
READ*,n
res=factorial(n)
PRINT*,'RES( in function)=',res

CALL fact_routine(n,res)
PRINT*,'RES( in subroutine)=',res
CONTAINS
RECURSIVE INTEGER FUNCTION factorial(n) RESULT(fact)
IMPLICIT NONE
INTEGER,INTENT(IN)::n
IF(n==0) THEN
    fact=1
ELSE
    fact=n*factorial(n-1)
END IF
END FUNCTION factorial

RECURSIVE SUBROUTINE fact_routine(n,fact)
IMPLICIT NONE
INTEGER,INTENT(IN)::n
INTEGER,INTENT(OUT)::fact
IF(n==0) THEN
    fact=1
ELSE
    CALL fact_routine(n-1,fact)
    fact=n*fact
END IF
END SUBROUTINE fact_routine
END PROGRAM recursive_ex


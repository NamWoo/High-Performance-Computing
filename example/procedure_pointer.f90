PROGRAM procedure_pointer
IMPLICIT NONE
PROCEDURE(add), POINTER::p=>NULL()
PROCEDURE(fun_add),POINTER::p1=>NULL()
REAL::a=10,b=5,c1,c2
p=>add;   p1=>fun_add
CALL p(a,b,c1)
c2=p1(a,b)
PRINT*, 'ADD:',c1, c2

p=>sub;  p1=>fun_sub
CALL p(a,b,c1)
c2=p1(a,b)
PRINT*,'SUB:', c1, c2

p=>mul;  p1=>fun_mul
CALL p(a,b, c1)
c2=p1(a,b)
PRINT*,'MUL:',c1, c2

p=>div;  p1=>fun_div
CALL p(a,b,c1)
c2=p1(a,b)
PRINT*,'DIV:',c1,c2

CONTAINS
SUBROUTINE add(a,b,c)
IMPLICIT NONE
REAL,INTENT(IN)::a,b
REAL,INTENT(OUT)::c
c=a+b
END SUBROUTINE add

SUBROUTINE sub(a,b,c)
IMPLICIT NONE
REAL,INTENT(IN)::a,b
REAL,INTENT(OUT)::c
c=a-b
END SUBROUTINE sub

SUBROUTINE mul(a,b,c)
IMPLICIT NONE
REAL,INTENT(IN)::a,b
REAL,INTENT(OUT)::c
c=a*b
END SUBROUTINE mul

SUBROUTINE div(a,b,c)
IMPLICIT NONE
REAL,INTENT(IN)::a,b
REAL,INTENT(OUT)::c
c=a/b
END SUBROUTINE div

REAL FUNCTION fun_add(a,b)
IMPLICIT NONE
REAL,INTENT(IN)::a,b
fun_add=a+b
END FUNCTION fun_add

REAL FUNCTION fun_sub(a,b)
IMPLICIT NONE
REAL,INTENT(IN)::a,b
fun_sub=a-b
END FUNCTION fun_sub

REAL FUNCTION fun_mul(a,b)
IMPLICIT NONE
REAL,INTENT(IN)::a,b
fun_mul=a*b
END FUNCTION fun_mul

REAL FUNCTION fun_div(a,b)
IMPLICIT NONE
REAL,INTENT(IN)::a,b
fun_div=a/b
END FUNCTION fun_div
END PROGRAM procedure_pointer


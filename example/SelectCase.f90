PROGRAM select_case
IMPLICIT NONE
INTEGER::n,k
WRITE(*,*)'Enter the value n='
READ*,n

SELECT CASE(n)
    CASE(:0)
        k=-n
    CASE(10:20)
        k=n+10
    CASE DEFAULT
        k=n
END SELECT
WRITE(*,*) 'k=',k
END PROGRAM select_case


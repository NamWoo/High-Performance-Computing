PROGRAM normalize
IMPLICIT NONE
REAL,DIMENSION(5)::g
INTEGER, DIMENSION(1)::maxij
INTEGER::i,j
g=(/5.0, 5.0,10.0, 5.0, 5.0/)
maxij=MAXLOC(g)
DO i=1,5
    g(i)=g(i)/g(maxij(1))
END DO
PRINT*,g
PRINT*,'------------------'
g=(/5.0, 5.0,10.0, 5.0, 5.0/)
g=g/g(maxij(1))
PRINT*,g
END PROGRAM normalize


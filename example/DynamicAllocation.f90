PROGRAM score
IMPLICIT NONE
INTERFACE
  INTEGER FUNCTION gettotal(k, e, m)
    INTEGER,INTENT(IN)::k, e, m
    END FUNCTION gettotal

  SUBROUTINE bubblesort(t, r, ns)
    INTEGER,INTENT(INOUT)::t(*), r(*)
    INTEGER,INTENT(IN)::ns
    INTEGER::i,j,c
  END SUBROUTINE bubblesort
END INTERFACE

INTEGER,ALLOCATABLE,DIMENSION(:)::kor, eng, math, total,rank, trank
CHARACTER,ALLOCATABLE,DIMENSION(:)::grade
REAL, ALLOCATABLE,DIMENSION(:)::ave
INTEGER::i,j,ntotal

OPEN(20,FILE='score.dat', STATUS='OLD')
READ(20,*)ntotal
ALLOCATE(kor(ntotal), eng(ntotal), math(ntotal), &
total(ntotal),rank(ntotal))
ALLOCATE(trank(ntotal), ave(ntotal), grade(ntotal))

DO i=1,ntotal
    READ(20,*)kor(i), eng(i), math(i)
    total(i)=gettotal(kor(i), eng(i),math(i))
    ave(i)=total(i)/3.0
    rank(i)=i
END DO
CALL bubblesort(total, rank, ntotal)

DO i=1,ntotal
  DO j=1,ntotal
    IF(total(i)==total(rank(j)))THEN
      trank(i)=j
    END IF
  END DO

  IF(ave(i)>=90)THEN
    grade(i)='A'
  ELSE IF(AVE(I)>=80)THEN
    grade(i)='B'
  ELSE IF(ave(i)>=70)THEN
    grade(i)='C'
  ELSE
    grade(i)='F'
  END IF
END DO

WRITE(*,*)'KOR ENG MAT TOTAL AVE RANK GRADE'
WRITE(*,*)'---------------------------------'
DO i=1,ntotal
  WRITE(*,100)kor(i), eng(i), math(i),total(i),ave(i),trank(i),grade(i)
END DO
WRITE(*,*)'---------------------------------'
100 FORMAT(4I5,F6.1, I5, A4);
DEALLOCATE(kor, eng, math,rank, trank, ave, grade,total)
END PROGRAM score

INTEGER FUNCTION gettotal(k, e, m)
INTEGER,INTENT(IN)::k, e, m
gettotal=k+e+m
END FUNCTION gettotal

SUBROUTINE bubblesort(t, r, ns)
INTEGER,INTENT(INOUT)::t(*), r(*)
INTEGER,INTENT(IN)::ns
INTEGER::i,j,c
DO i=1,ns-1
  DO j=1,ns-i
    IF(t(r(j))<t(r(j+1)))THEN
      c=r(j)
      r(j)=r(j+1)
      r(j+1)=c
    END IF
  END DO
END DO
END SUBROUTINE bubblesort


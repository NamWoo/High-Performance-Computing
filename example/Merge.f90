PROGRAM merge_ex
IMPLICIT NONE
INTEGER::i=1,j=2
INTEGER::larger_val
larger_val=MERGE(i, j, i>j)
PRINT*,'Larger value is ',larger_val
END PROGRAM merge_ex


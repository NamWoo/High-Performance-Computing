PROGRAM reduce
USE mpi_f08
IMPLICIT NONE
INTEGER::nrank,ista,iend,i
REAL::A(9)=0, sum=0.0, tsum=0.0
CALL MPI_Init
CALL MPI_Comm_rank(MPI_COMM_WORLD,nrank)
ista=nrank*3+1;   iend=ista+2
DO i=ista,iend
  A(i)=i
END DO
DO i=ista,iend
  sum = sum + A(i)
END DO
CALL MPI_Reduce(sum,tsum,1,MPI_REAL,MPI_SUM, 0, MPI_COMM_WORLD)
IF(nrank==0)THEN
  PRINT*,'sum=',tsum
ENDIF
tsum=0.0
IF(nrank==0)THEN
  tsum=sum
  CALL MPI_Reduce(MPI_IN_PLACE,tsum,1,MPI_REAL,MPI_SUM, 0, MPI_COMM_WORLD)
  PRINT*,'sum=',tsum
ELSE
  CALL MPI_Reduce(sum,tsum,1,MPI_REAL,MPI_SUM, 0, MPI_COMM_WORLD)
ENDIF

CALL MPI_Finalize
END PROGRAM reduce

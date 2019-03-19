PROGRAM sendrecv_rep
USE mpi_f08
IMPLICIT NONE
INTEGER::myrank
INTEGER::a, inext,iprev,i
CALL MPI_Init
CALL MPI_Comm_rank(MPI_COMM_WORLD,myrank)
a=myrank+1
inext=myrank+1; iprev=myrank-1
IF(myrank==0)  iprev=3
IF(myrank==3)  inext=0
DO i=0,3
  IF(myrank==i) PRINT*,'Before myrank:',myrank, 'a=',a
END DO
CALL MPI_SENDRECV_REPLACE(a,1,MPI_INTEGER,inext,0,iprev,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE)
IF(myrank==0) PRINT*,''
DO i=0,3
  IF(myrank==i) PRINT*,'After myrank:',myrank,'a=',a
END DO
CALL MPI_Finalize
END PROGRAM sendrecv_rep

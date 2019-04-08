PROGRAM scatter
USE mpi_f08
IMPLICIT NONE
INTEGER::i, isend(3),nprocs,myrank,irecv
CALL MPI_Init
CALL MPI_Comm_rank(MPI_COMM_WORLD,myrank)
CALL MPI_Comm_size(MPI_COMM_WORLD,nprocs)
IF(myrank==0)THEN
  DO i=1,nprocs
    isend(i)=i
  END DO
END IF
CALL MPI_Scatter(isend,1,MPI_INTEGER,irecv,1,MPI_INTEGER,0,MPI_COMM_WORLD)
PRINT*,'rank:',myrank,'   irecv=',irecv

isend=0
IF(myrank==0)THEN
  DO i=1,nprocs
    isend(i)=i*10
  END DO
END IF
irecv=0
IF(myrank==0)THEN
  irecv=isend(1)
  CALL MPI_Scatter(isend,1,MPI_INTEGER,MPI_IN_PLACE,1,MPI_INTEGER,0,MPI_COMM_WORLD)
ELSE
  CALL MPI_Scatter(isend,1,MPI_INTEGER,irecv,1,MPI_INTEGER,0,MPI_COMM_WORLD)
END IF
PRINT*,'RANK:',myrank,'   IRECV=',irecv

CALL MPI_Finalize
END PROGRAM scatter

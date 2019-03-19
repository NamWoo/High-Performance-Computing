PROGRAM allgather
USE mpi_f08
IMPLICIT NONE
INTEGER::isend,irecv(3),nrank
CALL MPI_Init
CALL MPI_Comm_rank(MPI_COMM_WORLD,nrank)
isend=nrank+1; irecv=0
PRINT*,'rank:',nrank,'isend:',isend
CALL MPI_Allgather(isend,1,MPI_INTEGER,irecv,1,MPI_INTEGER,MPI_COMM_WORLD)
PRINT*,'rank:',nrank,'irecv=',irecv
PRINT*,''
isend=(nrank+1)*10;   irecv=0
irecv(nrank+1)=isend
CALL MPI_Allgather(MPI_IN_PLACE,1,MPI_INTEGER,irecv,1,MPI_INTEGER,MPI_COMM_WORLD)
PRINT*,'RANK:',nrank,'IRECV=',irecv
CALL MPI_Finalize
END PROGRAM allgather

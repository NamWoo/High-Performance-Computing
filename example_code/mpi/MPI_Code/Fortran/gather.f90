PROGRAM gather
USE mpi_f08
IMPLICIT NONE
INTEGER::isend,irecv(4),recvdata(4),nprocs,nrank
CALL MPI_Init
CALL MPI_Comm_rank(MPI_COMM_WORLD,nrank)
CALL MPI_Comm_size(MPI_COMM_WORLD,nprocs)
isend=nrank+1;    recvdata=0
PRINT*,'rank:',nrank,'isend:',isend
CALL MPI_Gather(isend,1,MPI_INTEGER,irecv,1,MPI_INTEGER,0,MPI_COMM_WORLD)
IF(nrank==0) PRINT*,'rank:',nrank,'irecv=',irecv
isend=isend*10
IF(nrank==nprocs-1)THEN
  recvdata(nprocs)=isend
  CALL MPI_Gather(MPI_IN_PLACE,1,MPI_INTEGER,recvdata,1,MPI_INTEGER,nprocs-1,MPI_COMM_WORLD)
ELSE
  CALL MPI_Gather(isend,1,MPI_INTEGER,recvdata,1,MPI_INTEGER,nprocs-1,MPI_COMM_WORLD)
ENDIF
IF(nrank==nprocs-1) PRINT*,'RECVDATA:',recvdata

CALL MPI_Finalize
END PROGRAM gather

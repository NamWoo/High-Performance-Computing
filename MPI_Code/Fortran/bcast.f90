PROGRAM bcast
USE mpi_f08
IMPLICIT NONE
INTEGER::buf(4),buf2(4), nprocs,nrank
INTEGER::ROOT=0
TYPE(MPI_Request)::req
buf=0;   buf2=0
CALL MPI_INIT
CALL MPI_Comm_size(MPI_COMM_WORLD, nprocs)
CALL MPI_Comm_rank(MPI_COMM_WORLD, nrank)
IF(nrank==ROOT) buf=(/5,6,7,8/)
IF(nrank==nprocs-1) buf2=(/50,60,70,80/)
PRINT*,'rank=',nrank,' Before(buf):',buf
CALL MPI_Ibcast(buf2,4,MPI_INTEGER,nprocs-1,MPI_COMM_WORLD,req)
CALL MPI_Bcast(buf,4,MPI_INTEGER, ROOT, MPI_COMM_WORLD)
print*,'rank=',nrank,' After(buf) :',buf
CALL MPI_Wait(req,MPI_STATUS_IGNORE)
PRINT*,'RANK=',nrank,' AFTER(BUF2):',buf2
CALL MPI_FINALIZE()
END PROGRAM bcast

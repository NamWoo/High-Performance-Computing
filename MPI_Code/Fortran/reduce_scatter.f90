PROGRAM reduce_scatter
USE mpi_f08
IMPLICIT NONE
INTEGER::sendbuf(6), recvbuf(3)=0,recvcnt(3)=0
INTEGER::myrank
sendbuf=(/1,2,2,3,3,3/);  recvcnt=(/1,2,3/)
CALL MPI_Init
CALL MPI_Comm_rank(MPI_COMM_WORLD,myrank)
CALL MPI_Reduce_scatter(sendbuf,recvbuf,recvcnt,MPI_INTEGER,MPI_SUM,MPI_COMM_WORLD)
PRINT*,'myrank:',myrank, 'irecv=',recvbuf
CALL MPI_Finalize
END PROGRAM reduce_scatter

PROGRAM reduce_scatter_block
USE mpi_f08
IMPLICIT NONE
INTEGER::sendbuf(3),recvbuf,myrank
CALL MPI_init
CALL MPI_Comm_rank(MPI_COMM_WORLD,myrank)
sendbuf=(/1,2,3/)
CALL MPI_REDUCE_SCATTER_BLOCK(sendbuf,recvbuf,1,MPI_INTEGER,MPI_SUM,MPI_COMM_WORLD);
PRINT*,'myrank:',myrank,'result:',recvbuf
CALL MPI_Finalize()
END PROGRAM reduce_scatter_block

PROGRAM alltoall
USE mpi_f08
IMPLICIT NONE
INTEGER::nprocs,myrank,i
INTEGER::isend(3), irecv(3)
CALL MPI_Init
CALL MPI_Comm_size(MPI_COMM_WORLD,nprocs)
CALL MPI_Comm_rank(MPI_COMM_WORLD,myrank)
DO i=1,nprocs
  isend(i)=i+nprocs*myrank
END DO
PRINT*,'myrank:',myrank,'isend=',isend
CALL MPI_Alltoall(isend,1,MPI_INTEGER,irecv,1,MPI_INTEGER,MPI_COMM_WORLD)
PRINT*,'myrank:',myrank,'irecv=',irecv

irecv=isend
CALL MPI_Alltoall(MPI_IN_PLACE,1,MPI_INTEGER,irecv,1,MPI_INTEGER,MPI_COMM_WORLD)
PRINT*,'MYRANK:',myrank,'IRECV=',irecv
CALL MPI_Finalize
END PROGRAM alltoall

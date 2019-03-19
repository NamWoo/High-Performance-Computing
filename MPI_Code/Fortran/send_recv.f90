PROGRAM send_recv
USE mpi_f08
IMPLICIT NONE
INTEGER::rank,size,count
REAL:: data(100), value(200)
TYPE(MPI_STATUS)::status
CALL MPI_Init
CALL MPI_Comm_rank(MPI_COMM_WORLD,rank)
IF(rank==0) THEN
   data = 3.0
   CALL MPI_SEND(data,100,MPI_REAL,1,55,MPI_COMM_WORLD)
ELSEIF(rank==1)THEN
   CALL MPI_RECV(value,50,MPI_REAL,MPI_ANY_SOURCE,55,MPI_COMM_WORLD,status)
   PRINT*,"p:",rank," got data from processor ",status%MPI_SOURCE
   CALL MPI_GET_COUNT(status,MPI_REAL,count)
   PRINT*,"P:",rank," got ",count," elements"
   PRINT*,"P:",rank," value(5)=",value(5)
ENDIF
CALL MPI_Finalize
END PROGRAM send_recv

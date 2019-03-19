PROGRAM PERSISTENT_COMM
USE mpi_f08
IMPLICIT NONE
INTEGER::myrank
TYPE(MPI_Request)::ireq(2)
INTEGER::A(5), B(5)
INTEGER::i,j
CALL MPI_Init
CALL MPI_Comm_rank(MPI_COMM_WORLD,myrank)
CALL MPI_Send_init(A,5,MPI_INTEGER,1,1,MPI_COMM_WORLD, ireq(1))
CALL MPI_Recv_init(B,5,MPI_INTEGER,0,1,MPI_COMM_WORLD, ireq(2))
A=0;   B=0
DO i=1,10
  IF(myrank==0)THEN
    DO j=1,5
      A(j)=A(j)+1
    END DO
  ENDIF
  IF(myrank==0 .OR. myrank==1) CALL MPI_Start(ireq(myrank+1))
  ! COMPUTING....
  CALL MPI_Waitall(2,ireq,MPI_STATUSES_IGNORE)
  IF(myrank==1) PRINT*,'i=',i,'B=',B
END DO
CALL MPI_Finalize
END PROGRAM PERSISTENT_COMM

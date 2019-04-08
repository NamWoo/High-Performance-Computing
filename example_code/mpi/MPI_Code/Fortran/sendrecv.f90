PROGRAM sendrecv
USE mpi_f08
IMPLICIT NONE
INTEGER::myrank
INTEGER::A(0:3),B(0:3), inext, iprev, i
CALL MPI_Init
CALL MPI_Comm_rank(MPI_COMM_WORLD,myrank)
A=0;   B=0
A(myrank)=myrank+1
inext=myrank+1;   iprev=myrank-1
IF(Myrank==0) iprev=3
IF(Myrank==3) INEXT=0
IF(myrank==0) print*,'BEFORE'
DO i=0,3
  if(myrank==i) print*,'Myrank:',myrank, 'A=',A
END DO
CALL MPI_Sendrecv(A(myrank),1,MPI_INTEGER,INEXT,0,B(myrank),1,MPI_INTEGER,iprev,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE)
IF(myrank==0)THEN
  PRINT*,''
  PRINT*,'AFTER'
END IF
DO I=0,3
  IF(Myrank==i) PRINT*,'Myrank:',myrank,'B=',B
END DO
CALL MPI_Finalize
END PROGRAM sendrecv

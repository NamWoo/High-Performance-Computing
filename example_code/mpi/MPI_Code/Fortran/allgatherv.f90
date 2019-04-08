PROGRAM allgatherv
USE mpi_f08
IMPLICIT NONE
INTEGER::isend(3),irecv(6)
INTEGER::ircnt(0:2), idisp(0:2)
INTEGER::i,iscnt,myrank
ircnt=(/1,2,3/);   idisp=(/0,1,3/)
CALL MPI_Init
CALL MPI_Comm_rank(MPI_COMM_WORLD,myrank)
DO i=1,myrank+1
  isend(i)=myrank+1
END DO
iscnt=myrank+1
CALL MPI_Allgatherv(isend,iscnt,MPI_INTEGER,irecv,ircnt,idisp,MPI_INTEGER,MPI_COMM_WORLD)
PRINT*,'myrank:',myrank,'irecv=',irecv

irecv=0
IF(myrank==0) irecv(1)=(myrank+1)*10
IF(myrank==1) irecv(2:3)=(myrank+1)*10
IF(myrank==2) irecv(4:6)=(myrank+1)*10
CALL MPI_Allgatherv(MPI_IN_PLACE,iscnt,MPI_INTEGER,irecv,ircnt,idisp,MPI_INTEGER,MPI_COMM_WORLD)
PRINT*,'MYRANK:',myrank,'IRECV=',irecv
CALL MPI_Finalize
END PROGRAM allgatherv

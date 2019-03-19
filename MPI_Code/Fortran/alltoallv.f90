PROGRAM alltoallv
USE mpi_f08
IMPLICIT NONE
INTEGER::isend(6)=0, irecv(9)=0, isend2(9)=0
INTEGER::iscnt(0:2), isdsp(0:2), ircnt(0:2), irdsp(0:2)
INTEGER::nprocs,myrank,i
isend=(/1,2,2,3,3,3/)
iscnt=(/1,2,3/);   isdsp=(/0,1,3/)
CALL MPI_Init
CALL MPI_Comm_size(MPI_COMM_WORLD,nprocs)
CALL MPI_Comm_rank(MPI_COMM_WORLD,myrank)
DO i=1,6
  isend(i)=isend(i)+nprocs*myrank
END DO
if(myrank==0)THEN
  ircnt=(/1,1,1/);   irdsp=(/0,1,2/)
ELSEIF(myrank==1)THEN
  ircnt=(/2,2,2/);   irdsp=(/0,2,4/)
ELSEIF(myrank==2)THEN
  ircnt=(/3,3,3/);   irdsp=(/0,3,6/)
ENDIF
CALL MPI_Alltoallv(isend, iscnt,isdsp,MPI_INTEGER,irecv,ircnt,irdsp,MPI_INTEGER,MPI_COMM_WORLD)
PRINT*,'myrank:',myrank,'irecv=',irecv
CALL MPI_Finalize
END PROGRAM alltoallv

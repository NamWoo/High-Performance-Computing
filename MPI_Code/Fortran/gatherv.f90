PROGRAM gatherv
USE mpi_f08
IMPLICIT NONE
INTEGER::isend(3)
INTEGER::ircnt(0:2), idisp(0:2)
INTEGER::i,iscnt,myrank
INTEGER,ALLOCATABLE::irecv(:)
ircnt=(/1,2,3/);  idisp=(/0,1,3/)
CALL MPI_Init
CALL MPI_Comm_rank(MPI_COMM_WORLD, myrank)
IF(myrank==0)THEN
  ALLOCATE(irecv(6))
ENDIF
DO i=1,myrank+1
  isend(i)=myrank+1
END DO
iscnt=myrank+1
CALL MPI_Gatherv(isend,iscnt, MPI_INTEGER,irecv,ircnt, idisp,MPI_INTEGER,0,MPI_COMM_WORLD)
IF(myrank==0)THEN
  PRINT*,'irecv=',irecv
ENDIF


irecv=0
DO i=1,myrank+1
  isend(i)=(myrank+1)*10
END DO
IF(myrank==0)THEN
  irecv(1)=isend(1)
  CALL MPI_Gatherv(MPI_IN_PLACE,iscnt,MPI_INTEGER,irecv,ircnt,idisp,MPI_INTEGER,0,MPI_COMM_WORLD)
  PRINT*,'irecv=',irecv
ELSE
  CALL MPI_Gatherv(isend,iscnt,MPI_INTEGER,irecv,ircnt,idisp,MPI_INTEGER,0,MPI_COMM_WORLD)
ENDIF
IF(ALLOCATED(irecv))DEALLOCATE(irecv)
CALL MPI_Finalize
END PROGRAM gatherv

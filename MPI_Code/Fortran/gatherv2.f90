PROGRAM gatherv2
USE mpi_f08
IMPLICIT NONE
INTEGER::isend(6)=0
INTEGER::ircnt(0:2), idisp(0:2)
INTEGER::i,iscnt,myrank
ircnt=(/1,2,3/);  idisp=(/0,1,3/)
CALL MPI_Init
CALL MPI_Comm_rank(MPI_COMM_WORLD,myrank)
DO i=1,myrank+1
 isend(i)=myrank+1
END DO
PRINT*,'myrank:',myrank,'isend=',isend

iscnt=myrank+1

IF(myrank==0)THEN
  CALL MPI_Gatherv(MPI_IN_PLACE,iscnt,MPI_INTEGER,isend,ircnt,idisp,MPI_INTEGER,0,MPI_COMM_WORLD)
ELSE
  CALL MPI_Gatherv(isend,iscnt,MPI_INTEGER,isend,ircnt,idisp,MPI_INTEGER,0,MPI_COMM_WORLD)
ENDIF
IF(myrank==0) PRINT*,'MYRANK:',myrank, 'ISEND=',isend
CALL MPI_Finalize
END PROGRAM gatherv2

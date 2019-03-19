PROGRAM scatterv2
USE mpi_f08
IMPLICIT NONE
INTEGER::isend(6)=0, isndcnt(0:2), idisp(0:2)
INTEGER::rcvcnt,myrank
isndcnt=(/1,2,3/)
idisp=(/0,1,3/)
CALL MPI_Init
CALL MPI_Comm_rank(MPI_COMM_WORLD,myrank)
rcvcnt=myrank+1
IF(myrank==0) isend=(/1,2,2,3,3,3/)
PRINT*,'rank:',myrank,'isend=',isend
IF(myrank==0)THEN
  CALL MPI_Scatterv(isend,isndcnt,idisp,MPI_INTEGER,MPI_IN_PLACE,rcvcnt,MPI_INTEGER,0,MPI_COMM_WORLD)
ELSE
  CALL MPI_Scatterv(isend,isndcnt,idisp,MPI_INTEGER,isend(idisp(myrank)+1),rcvcnt,MPI_INTEGER,0,MPI_COMM_WORLD)
ENDIF
PRINT*,'RANK:',myrank,'ISEND=',isend
CALL MPI_Finalize
END PROGRAM scatterv2

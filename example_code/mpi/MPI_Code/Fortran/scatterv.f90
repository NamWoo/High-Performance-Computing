PROGRAM scatterv
USE mpi_f08
IMPLICIT NONE
INTEGER::isend(6), irecv(3)=0, isndcnt(0:2), idisp(0:2)
INTEGER::rcvcnt,myrank
isend=(/1,2,2,3,3,3/)
isndcnt=(/1,2,3/)
idisp=(/0,1,3/)
CALL MPI_Init
CALL MPI_Comm_rank(MPI_COMM_WORLD, myrank)
rcvcnt=myrank+1
CALL MPI_Scatterv(isend,isndcnt,idisp,MPI_INTEGER,irecv,rcvcnt,MPI_INTEGER,0,MPI_COMM_WORLD)
PRINT*,'rank: ',myrank, 'irecv=',irecv

irecv=0
isend=(/10,20,20,30,30,30/)
IF(myrank==0)THEN
  irecv(1)=isend(1)
  CALL MPI_Scatterv(isend,isndcnt,idisp,MPI_INTEGER,MPI_IN_PLACE,rcvcnt,MPI_INTEGER,0,MPI_COMM_WORLD)
ELSE
  CALL MPI_Scatterv(isend,isndcnt,idisp,MPI_INTEGER,irecv,rcvcnt,MPI_INTEGER,0,MPI_COMM_WORLD)
ENDIF
PRINT*,'RANK: ',myrank, 'IRECV=',irecv
CALL MPI_Finalize
END PROGRAM scatterv

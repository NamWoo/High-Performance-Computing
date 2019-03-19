PROGRAM contiguous
USE mpi_f08
IMPLICIT NONE
INTEGER::i, myrank, ibuf(20)=0
TYPE(MPI_Datatype)::inewtype;
CALL MPI_Init
CALL MPI_Comm_rank(MPI_COMM_WORLD,myrank)
IF(myrank==0)THEN
  DO i=1,20
   ibuf(i)=i
  END DO
ENDIF
CALL MPI_Type_contiguous(3,MPI_INTEGER,inewtype);
CALL MPI_Type_commit(inewtype)
CALL MPI_Bcast(ibuf,3,inewtype,0,MPI_COMM_WORLD)
PRINT '(I3,"  ibuf=",20I3)',myrank,ibuf

CALL MPI_Type_free(inewtype)
CALL MPI_Finalize
END PROGRAM contiguous

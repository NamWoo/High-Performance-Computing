PROGRAM type_vector
USE mpi_f08
IMPLICIT NONE
INTEGER::ibuf(20)=0,myrank,i
TYPE(MPI_Datatype)::inewtype
CALL MPI_Init
CALL MPI_Comm_rank(MPI_COMM_WORLD,myrank)
IF(myrank==0) THEN
  DO I=1,20
    ibuf(i)=i
  END DO
END IF
CALL MPI_TYPE_VECTOR(4,2,3,MPI_INTEGER,inewtype)
CALL MPI_Type_commit(inewtype)
CALL MPI_Bcast(ibuf,1,inewtype,0,MPI_COMM_WORLD)
PRINT '(I3,"  ibuf=",20I3)',myrank,ibuf
CALL MPI_Type_free(inewtype)
CALL MPI_Finalize
END PROGRAM type_vector

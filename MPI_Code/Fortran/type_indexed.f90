PROGRAM type_indexed
USE mpi_f08
IMPLICIT NONE
INTEGER::blengths(2), DISPLACEMENTS(2)
INTEGER::ibuf(20)=0, myrank,i
TYPE(MPI_Datatype)::new_type
CALL MPI_Init
CALL MPI_Comm_rank(MPI_COMM_WORLD,myrank)
blengths=(/2,3/);   displacements=(/0,4/)
CALL MPI_Type_indexed(2,blengths, displacements, MPI_INTEGER,new_type)
CALL MPI_Type_commit(new_type)
IF(myrank==0)THEN
  DO i=1,20
    ibuf(i)=i
  END DO
ENDIF
CALL MPI_Bcast(ibuf,2,new_type,0,MPI_COMM_WORLD)
PRINT '(I3,"   ibuf=",20I3)',myrank,ibuf
CALL MPI_Type_free(new_type)
CALL MPI_Finalize
END PROGRAM type_indexed

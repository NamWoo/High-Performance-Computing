PROGRAM subarray
USE mpi_f08
IMPLICIT NONE
INTEGER,PARAMETER::ndims=2
INTEGER::myrank,i,j
INTEGER::ibuf(2:7, 0:6)
INTEGER::arr_sizes(ndims), arr_subsizes(ndims), arr_starts(ndims)
TYPE(MPI_Datatype)::newtype
CALL MPI_Init
CALL MPI_Comm_rank(MPI_COMM_WORLD,myrank)
ibuf=0
IF(myrank==0)THEN
  DO j=0,6
    DO i=2,7
      ibuf(i,j)=i    
    END DO
  END DO
ENDIF
arr_sizes=(/6,7/);   arr_subsizes=(/2,5/);  arr_starts=(/1,1/)
CALL MPI_Type_create_subarray(ndims,arr_sizes,arr_subsizes,arr_starts,MPI_ORDER_FORTRAN,MPI_INTEGER,newtype)
CALL MPI_Type_commit(newtype)
CALL MPI_Bcast(ibuf,1,newtype,0,MPI_COMM_WORLD)
IF(MYRANK==1)THEN
  DO i=2,7
    PRINT*,ibuf(i,:)
  END DO
ENDIF
CALL MPI_Type_free(newtype)
CALL MPI_Finalize
END PROGRAM subarray

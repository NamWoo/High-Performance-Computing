PROGRAM type_struct
USE mpi_f08
IMPLICIT NONE
INTEGER::rank
TYPE ddt
  INTEGER::num
  real::x
  COMPLEX::data(4)
END TYPE ddt
INTEGER::blocklengths(3)
INTEGER(KIND=MPI_ADDRESS_KIND)::disps(3)
TYPE(MPI_Datatype)::arr_types(3),restype
TYPE(ddt)::a
INTEGER::i,size
blocklengths=(/1,1,4/)
arr_types=(/MPI_INTEGER,MPI_REAL,MPI_COMPLEX/)
CALL MPI_Init
CALL MPI_Comm_rank(MPI_COMM_WORLD,rank)
CALL MPI_Get_address(a%num,disps(1))
CALL MPI_Get_address(a%x,disps(2))
CALL MPI_Get_address(a%data,disps(3))
disps(3)=disps(3)-disps(1);   disps(2)=disps(2)-disps(1);  disps(1)=MPI_BOTTOM
CALL MPI_Type_create_struct(3,blocklengths,disps,arr_types,restype)
CALL MPI_Type_commit(restype)
IF(rank==0)THEN
  a%num=6;  a%x=3.14
  DO i=1,4
    a%data(i)=cmplx(i,i)
  END DO
  CALL MPI_Send(a,1,restype, 1, 30, MPI_COMM_WORLD)
ELSEIF(rank==1)THEN
  CALL MPI_Recv(a,1,restype, 0, 30, MPI_COMM_WORLD,MPI_STATUS_IGNORE)
  PRINT*,'P:',rank,' I got'
  PRINT*,a%num
  PRINT*,a%x
  PRINT*,a%data
ENDIF
CALL MPI_Type_free(restype)
CALL MPI_Finalize
END PROGRAM type_struct

PROGRAM hello
USE mpi_f08
IMPLICIT NONE
INTEGER::nRank, nProcs, nNameLen
CHARACTER(LEN=MPI_MAX_PROCESSOR_NAME)::procName
INTEGER::ver, subver

CALL MPI_Init
CALL MPI_Comm_size(MPI_COMM_WORLD, nProcs)
CALL MPI_Comm_rank(MPI_COMM_WORLD, nRank)

CALL MPI_Get_version(ver,subver)
IF(nRank==0) PRINT*,'MPI Version',ver,'.',subver
CALL MPI_Get_processor_name(procName,nNameLen)
PRINT*,'Hello World.(Process name=',TRIM(procName),', nRank=',nRank,',nProcs=',nProcs
CALL MPI_Finalize
END PROGRAM hello

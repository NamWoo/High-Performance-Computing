PROGRAM hello
!USE mpi_f08
!USE mpi
INCLUDE 'mpif.h'
INTEGER::IERR
! Initialize the library
CALL MPI_Init(IERR)

PRINT*,'Hello World'

! Warp it up.
CALL MPI_Finalize(IERR)
END PROGRAM hello

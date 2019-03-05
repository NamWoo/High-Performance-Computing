PROGRAM pi_cal
IMPLICIT NONE
INCLUDE 'mpif.h'
INTEGER ierr, nprocs, myrank,tag,j
INTEGER status(MPI_STATUS_SIZE) 
INTEGER seed, tpoints, in_circle
DOUBLE PRECISION pi, x, y, r, recv, RAND

tpoints = 10000000

CALL MPI_INIT(ierr) 
CALL MPI_COMM_SIZE(MPI_COMM_WORLD,nprocs,ierr)
CALL MPI_COMM_RANK(MPI_COMM_WORLD,myrank,ierr)
in_circle = 0
!seed=5
!CALL SRAND(seed*myrank)

DO j = myrank+1,tpoints,nprocs  
   call random_number(x)
   call random_number(y)
   x=x-0.5
   y=y-0.5
   r = SQRT(x*x + y*y) 
   IF (r<0.5d0) THEN   
      in_circle = in_circle + 1 
   ENDIF
ENDDO 
pi = 4.0*in_circle/tpoints
IF(myrank /= 0) THEN
   CALL MPI_SEND(pi, 1, MPI_DOUBLE_PRECISION, 0, 1, & 
        MPI_COMM_WORLD, ierr)
ENDIF

IF(myrank==0) THEN
   DO j = 1, nprocs-1
      CALL MPI_RECV(recv, 1, MPI_DOUBLE_PRECISION, j, 1, & 
                    MPI_COMM_WORLD, status, ierr)
      pi = pi + recv
   ENDDO
   PRINT *, ' pi = ', pi
ENDIF
CALL MPI_FINALIZE(ierr)
END


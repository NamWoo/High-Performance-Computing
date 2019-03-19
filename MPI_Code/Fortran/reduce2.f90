PROGRAM reduce2
USE mpi_f08
IMPLICIT NONE
INTEGER::nrank,ista,iend,i,cnt=0
REAL::A(3)=0
TYPE DDT
  REAL::val,rank
END TYPE DDT
TYPE(DDT)::in(3),out(3)

CALL MPI_Init
CALL MPI_Comm_rank(MPI_COMM_WORLD,nrank)
IF(nrank==0) THEN
  A(1)=9;   A(2)=5;   A(3)=2
ELSEIF(nrank==1)THEN
  A(1)=8;   A(2)=6;   A(3)=1
ELSEIF(nrank==2)THEN
  A(1)=7;   A(2)=4;   A(3)=3
ENDIF
  
DO i=1,3
  in(i)%val=a(i)
  in(i)%rank=nrank
END DO
CALL MPI_Reduce(in,out,3,MPI_2REAL,MPI_MAXLOC, 0, MPI_COMM_WORLD)
IF(nrank==0)THEN
  PRINT*,'max val',out%val 
  PRINT*,'max rank',out%rank
ENDIF

CALL MPI_Finalize
END PROGRAM reduce2

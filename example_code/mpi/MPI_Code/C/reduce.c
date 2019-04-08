#include <stdio.h>
#include <mpi.h>
int main()
{ 
  int nrank,ista,iend,i;
  double A[9]={0.0,}, sum=0.0, tsum=0.0;
  MPI_Init(NULL,NULL);
  MPI_Comm_rank(MPI_COMM_WORLD,&nrank);
  ista=nrank*3;  iend=ista+2;
  for(i=ista;i<iend+1;i++) A[i]=i+1;
  sum=0.0;
  for(i=ista;i<iend+1;i++) sum += A[i];
  MPI_Reduce(&sum,&tsum,1,MPI_DOUBLE,MPI_SUM, 0, MPI_COMM_WORLD);
  if(nrank==0) printf("rank(%d):sum=%.2f\n",nrank,tsum);

  tsum=0;
  if(nrank==0){
    //tsum=sum;
    MPI_Reduce(MPI_IN_PLACE,&tsum,1,MPI_DOUBLE,MPI_SUM,0,MPI_COMM_WORLD);
    printf("RANK(%d):SUM=%.2f\n",nrank,tsum);
  } 
  else{
    MPI_Reduce(&sum, &tsum,1,MPI_DOUBLE,MPI_SUM, 0, MPI_COMM_WORLD);
  }  
  MPI_Finalize();
  return 0;
}

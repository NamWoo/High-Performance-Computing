#include <stdio.h>
#include <stdlib.h>
#include "mpi.h"
#include <math.h>
void main(int argc, char *argv[]){ 
  int j, nprocs, myrank,tag;
  MPI_Status status; 
  int tpoints, in_circle;
  double pi, seed, x, y, r, recv;

  tpoints = 1000000;

  MPI_Init(&argc, &argv); 
  MPI_Comm_size(MPI_COMM_WORLD,&nprocs);
  MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
  in_circle = 0;  seed=0.5;
  srand(seed*myrank);

  for(j=myrank; j<tpoints; j+=nprocs){  
     x = (double)rand()/RAND_MAX - 0.5;  
     y = (double)rand()/RAND_MAX - 0.5;
     r = sqrt(x*x + y*y); 
     if (r<=0.5) in_circle = in_circle + 1; 
  }
  pi = 4.0*in_circle/tpoints;
  
  if(myrank != 0) 
     MPI_Send(&pi,1,MPI_DOUBLE,0,1,MPI_COMM_WORLD);

  if(myrank==0){ 
     for(j=1; j<=nprocs-1; j++){
         MPI_Recv(&recv, 1, MPI_DOUBLE, j, 1,  
                    MPI_COMM_WORLD, &status);
         pi = pi + recv;
     }
     printf(" pi = %f\n", pi); 
  }
  MPI_Finalize();
}


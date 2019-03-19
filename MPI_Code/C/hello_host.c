#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[])
{
   int ver,subver;
   int nRank, nProcs;
   char procName[MPI_MAX_PROCESSOR_NAME];
   int nNameLen;
   

   MPI_Init(NULL,NULL);
   MPI_Comm_rank(MPI_COMM_WORLD,&nRank);
   MPI_Comm_size(MPI_COMM_WORLD,&nProcs);

   MPI_Get_version(&ver,&subver);
   if(nRank==0)printf("MPI Version %d.%d\n",ver,subver);
   MPI_Get_processor_name(procName, &nNameLen);
    
   printf("Hello World.(Process name=%s, nRank=%d, nProcs=%d)\n",procName, nRank, nProcs);
   MPI_Finalize();
   return 0;
}

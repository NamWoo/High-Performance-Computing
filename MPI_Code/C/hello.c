#include <stdio.h>
#include "mpi.h"

int main(int argc, char* argv[])
{
   /* Initialize the library */
   MPI_Init(&argc, &argv);

   /* Parallel Code */
   printf("Hello world\n");

   /* Warp it up. */
   MPI_Finalize();
   return 0;
}

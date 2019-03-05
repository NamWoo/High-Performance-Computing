#!/bin/sh
#PBS -V
#PBS -N mpi_job
#PBS -q normal
#PBS -l select=4:ncpus=64:mpiprocs=64:ompthreads=1
#PBS -l walltime=04:00:00

cd $PBS_O_WORKDIR

mpirun ./a.out


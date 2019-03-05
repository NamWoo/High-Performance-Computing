#!/bin/sh
#PBS -V
#PBS -N hybrid_job
#PBS -q normal
#PBS -l select=4:ncpus=64:mpiprocs=2:ompthreads=32
#PBS -l walltime=04:00:00

cd $PBS_O_WORKDIR

mpirun ./a.out  


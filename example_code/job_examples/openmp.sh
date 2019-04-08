#!/bin/sh
#PBS -V
#PBS -N openmp_job
#PBS -q normal
#PBS -l select=1:ncpus=64:ompthreads=64
#PBS -l walltime=04:00:00

cd $PBS_O_WORKDIR

./a.out


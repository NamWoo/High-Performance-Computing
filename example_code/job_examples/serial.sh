#!/bin/sh
#PBS -V
#PBS -N serial_job
#PBS -q normal
#PBS -l select=1
#PBS -l walltime=04:00:00

cd $PBS_O_WORKDIR

./a.out


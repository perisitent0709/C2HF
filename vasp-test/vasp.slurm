#!/bin/bash
#SBATCH -J vasp
#SBATCH -p normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=48
#SBATCH --error=%J.err
#SBATCH --output=%J.out

module load mpi/2021.6.0
module load mkl/2022.1.0
module load vasp/6.4.2

cd $SLURM_SUBMIT_DIR

mpirun -n $SLURM_NTASKS vasp_std > log

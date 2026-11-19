#!/bin/bash
#SBATCH --job-name=zhj
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=64
#SBATCH --cpus-per-task=1
#SBATCH --partition=wzhcnormal

# load the environment
module purge
module load compiler/intel/2017.5.239 mpi/intelmpi/2017.4.239
export MKL_DEBUG_CPU_TYPE=5 #加速代码

export MKL_CBWR=AVX2 #使cpu默认支持avx2

export I_MPI_PIN_DOMAIN=numa #内存位置与cpu位置绑定，加速内存读取。对于内存带宽要求高的计算提速明显

#srun --mpi=pmi2 /path/to/vasp_std #vasp程径
mpirun -np 4 /work/home/acp6yn9j4t/users/zhj/software/run_nlo_v0.095.1 &> shg.out
#核数设置要求小于k点数
#srun --mpi=pmi2 /work/home/acp6yn9j4t/software/vasp.6.3.0/bin/vasp_std > vasp.out

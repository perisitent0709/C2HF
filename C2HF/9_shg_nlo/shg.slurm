#!/bin/bash
#SBATCH --job-name=C2HF_SHG
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --partition=normal
#SBATCH -o %j.out
#SBATCH -e %j.err

# ⭐ 核心：切换到提交作业时所在的目录（9_shg_nlo）
cd $SLURM_SUBMIT_DIR

# 加载运行环境
module purge
module load compiler/intel/2017.5.239 mpi/intelmpi/2017.4.239 2>/dev/null || \
module load mpi/2021.6.0 mkl/2022.1.0 2>/dev/null || true

export MKL_DEBUG_CPU_TYPE=5
export MKL_CBWR=AVX2
export I_MPI_PIN_DOMAIN=numa

# 确保程序有可执行权限并运行
chmod +x $HOME/nlo/run_nlo_v0.095.1
mpirun -np 4 $HOME/nlo/run_nlo_v0.095.1 &> shg.out

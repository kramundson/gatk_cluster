#!/bin/bash
#
#SBATCH --job-name=haplo
#SBATCH -c 1 # Number of cores
#SBATCH -N 1 # Ensure that all cores are on one machine
#SBATCH --mem=2G # Memory pool for all cores in MB (see also --mem-per-cpu)
#SBATCH --time 5-00:00:00 # 5 day runtime
#SBATCH -p gc # Partition to submit to
#SBATCH -o 2018_0716_snake.out # File to which STDOUT will be written
#SBATCH -e 2018_0716_snake.err # File to which STDERR will be written
#SBATCH --mail-type=ALL # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=<youremail> # Email to which notifications will be sent

date
hostname

WORKDIR="/share/comailab/kramundson/LOP_fix_adapter_pear"
CONDA="gatk4_snek"
cd $WORKDIR
source activate $CONDA

snakemake -j 7 -s init_ref.snakes --cluster-config cluster.yaml --cluster "sbatch -p {cluster.partition} -n {cluster.n} -t {cluster.time} -c {cluster.c} --mem-per-cpu {cluster.mempercpu}" -k -w 120
snakemake -j 999 --rerun-incomplete --cluster-config cluster.yaml --cluster "sbatch -p {cluster.partition} -n {cluster.n} -t {cluster.time} -c {cluster.c} --mem-per-cpu {cluster.mempercpu}" -k -w 120

source deactivate $CONDA

date

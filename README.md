Workflow jointly calls and genotypes SNPs and short indels using GATK HaplotypeCaller
from user-provided analysis-ready bam files.

Snakemake workflow for scattering GATK HaplotypeCaller across a cluster, does the following:

* HaplotypeCaller jobs are scattered across a cluster by genomic interval. Interval 
  boundaries are created at gaps considered here to be 1,000 or more consecutive "N" bases.
  An intermediate gVCF is created for each unique combination of sample and region.
* Region gVCFs for each sample are merged and jointly genotyped with GenotypeGVCFs
* All regions are then merged to get raw variants in file ```calls/all-calls.vcf```

I. Software installation

1. Download and install miniconda for Python3

```
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

# install
sh Miniconda3-latest-Linux-x86_64.sh

# review license
# accept license
# accept or change home location
# yes to placing it in your path

source  $HOME/.bashrc
```

2. Clone this repo

```
git clone https://github.com/kramundson/gatk4_snek
cd gatk4_snek
```

3. Build environment using gatk4_snek.yaml

```
conda env create --name gatk4_snek -f gatk4_snek.yaml
```

II. Run workflow

1. Copy or symlink your reference genome to ```./ref```

Note, I symlinked ```/share/comailab/ajfirl/ref/sec-mint-12big_apple_mint_dec.fasta```
I then preemptively changed the fasta headers of the reference for compatibility, as
I'm guessing the semicolons in the headers would've crashed HaplotypeCaller.

I did this with the following sed one-liner:

```cat sec-mint-12big_apple_mint_dec.fasta | sed 's/;.\+//g' > header-sec-mint-12big_apple_mint_dec.fasta```

2. Copy or symlink your analysis-ready bam files to ```./bam```

For testing, I symlinked these 3 bams from ```/share/comailab/ajfirl/haplotyping/```:

* bamaddrg_NK2all.sorted.bam
* bamaddrg_NK54.sorted.bam
* bamaddrg_S12.sorted.bam

3. Edit ```config.yaml``` to suit your needs. At a minimum, you will need to specify the
path to the .jar for running GATK as the jarpath parameter

4. Edit ```cluster.yaml``` to suit your cluster resource allocation needs for each type of
job. The current allocation works as-is but has not been optimized for performance.

5. Submit workflow to cluster: ```sbatch snek.slurm```

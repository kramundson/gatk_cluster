import os, re
shell.executable("bash")

configfile: "config.yaml"

def get_vcfs(wildcards):
    intervals = [line.rstrip('\n') for line in open("ref/gatk-haplocaller.intervals", 'r')]
    vcfs = ["calls/3_vcf_by_region/all-samples-{}.vcf".format(x) for x in intervals]
    return vcfs

rule all:
    input:
        "calls/all-calls.vcf"

include: "rules/gatk4_merge_vcfs.rules"
include: "rules/gatk4_genotype_region_gvcfs.rules"
include: "rules/gatk4_merge_gvcfs_by_region.rules"
include: "rules/gatk4_haplotypecaller_diploid_cluster.rules"
include: "rules/samtools_index.rules"

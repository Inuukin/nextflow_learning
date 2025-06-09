#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { RUN_FASTQC as RUN_FASTQC_pretrim } from './modules/tools/fastqc.nf'
include { RUN_TRIMMOMATIC } from './modules/tools/trimmomatic.nf'
include { RUN_FASTQC as RUN_FASTQC_posttrim } from './modules/tools/fastqc.nf'


params.input_folder = './fastqs_raw'

/* input_separate_ch = Channel
        .fromPath("${params.input_folder}/*.fastq")
        .view() */

input_paired_ch = Channel
        .fromFilePairs("${params.input_folder}/*_{1,2}.fastq", flat: true)
        .set { paired_reads }      

workflow {
        
        RUN_FASTQC_pretrim(paired_reads.flatMap { sample_id, read1, read2 -> [read1, read2] })
        
        trimmed_out_ch = RUN_TRIMMOMATIC(paired_reads)

        RUN_FASTQC_posttrim(trimmed_out_ch
                .flatMap {sample_id, r1_paired, r1_unpaired, r2_paired, r2_unpaired -> [r1_paired, r1_unpaired, r2_paired, r2_unpaired]})
}



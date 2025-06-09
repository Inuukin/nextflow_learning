#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { RUN_FASTQC } from './modules/tools/fastqc.nf'
include { RUN_TRIMMOMATIC } from './modules/tools/trimmomatic.nf'


params.input_folder = './fastqs_raw'

input_separate_ch = Channel
        .fromPath("${params.input_folder}/*.fastq")
        .view()

input_paired_ch = Channel
        .fromFilePairs("${params.input_folder}/*_{1,2}.fastq", flat: true)
        .set { paired_reads }

workflow {

    RUN_FASTQC(input_separate_ch)
    /* paired_reads | DEBUG_CHANNEL | view() */
    paired_reads | RUN_TRIMMOMATIC
    /* RUN_TRIMMOMATIC(paired_reads) */

}



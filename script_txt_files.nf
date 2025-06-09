#!/usr/bin/env nextflow

nextflow.enable.dsl=2

input_ch = Channel
    .fromPath('input.txt')
    .splitText()
    .toList()
    .map { lines -> 
        (0..<lines.size()).collect { idx -> 
            def line = lines[idx]
            "Line ${idx + 1}: ${line.split(/\s+/).size()}"
        }.join('\n')
    }
/*     .flatMap { it }
    .view()
    .collect()
    .join('\n') */

process WRITE_TO_FILE {

    publishDir "results", mode: 'copy'

    input:
    val input

    output:
    path "output_file.txt"

    script:
    """
    echo "$input" > output_file.txt
    """   

}

workflow {

    WRITE_TO_FILE(input_ch)

}



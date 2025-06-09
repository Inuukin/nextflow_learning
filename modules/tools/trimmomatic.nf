process RUN_TRIMMOMATIC {

    publishDir "trimmed_results", mode: 'copy'
    container 'biocontainers/trimmomatic:v0.38dfsg-1-deb_cv1'

    input:
    tuple val(sample_id), path(read1), path(read2)

    output:
    tuple val(sample_id), path("${sample_id}_1_paired.fastq"), path("${sample_id}_1_unpaired.fastq"), path("${sample_id}_2_paired.fastq"), path("${sample_id}_2_unpaired.fastq")

    script:
    """
    java -jar /usr/share/java/trimmomatic.jar PE \
        $read1 \
        $read2 \
        ${sample_id}_1_paired.fastq \
        ${sample_id}_1_unpaired.fastq \
        ${sample_id}_2_paired.fastq \
        ${sample_id}_2_unpaired.fastq \
        LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
    """
}

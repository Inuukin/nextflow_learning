process RUN_FASTQC {

    publishDir "fastqc_results", mode: 'copy'

    input:
    path input

    output:
    path "*.zip"
    path "*.html"

    script:
    """
    fastqc $input
    """
}

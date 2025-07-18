#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

/*

 * Default pipeline parameters. They can be overriden on the command line eg.

 * given `params.foo` specify on the run command line `--foo some_value`.

 */

container_pipeline_path = "${params.container_pipeline_path}"

params.file = file("analysis/GIAB/pipeline_config.json")

 

// Sanity check

params.genome_build = params.genome_build

if (params.genome_build != "GRCh37" && params.genome_build != "GRCh38") {

  log.info 'We need the genome build of the input VCF'

  exit 0

}

 

params.help = null

if (params.help) {

    log.info 'This pipeline annotates and filters a VCF file'

    log.info 'Example \n'

    log.info 'nextflow run main.nf -params-file analysis/{project_name}/pipeline_config.json'

    log.info '\n'

    exit 1

}

 

log.info """\

 =====================================

 VARIANT VEP ANNOTATION NF PIPELINE

 =====================================

 version                          : ${params.annotate_config.version}
 container_pipeline_path          : ${params.container_pipeline_path}
 params.run_folder                : ${params.run_folder}
 genome_build                     : ${params.genome_build}
 vep_cache                        : ${file(params.annotate_config.vep.cache)}
 plugins                          : ${file(params.annotate_config.vep.plugins_scripts)}
 params.giab_vcf                    : ${params.giab_vcf}

 """


// Load input vcf file as a channel

vcf_channel = Channel.fromPath("${params.giab_vcf}")

// Anotation workflow

include { FILTER_SVS } from './nextflow/modules/variant_annotation'




/*

 * Top level variant annotation workflow

 */

workflow PROCESS_DATA {

  main:

    FILTER_VARIANT(vcf_channel)

  emit:

    filtered_variants = FILTER_VARIANT.out

}

 

/*

 * Main workflow starts here. Filters variant datasets

 */

workflow {

  main:

    PROCESS_DATA()

}

 

/*

 * Completion handlers

 */

workflow.onComplete {

    log.info "Pipeline completed at: $workflow.complete"

    log.info "Execution status: ${ workflow.success ? 'OK' : 'failed' }"

}

workflow.onError = {

    log.info "Something went wrong"

}

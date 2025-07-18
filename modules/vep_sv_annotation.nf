workflow SV_VEP {
  take:
    giab_vcf

  main:
  indexSV(giab_vcf)

  vepSV(indexSV.out.sv_vcf_and_index,
         file(params.annotate_config.vep.cache),
         file(params.annotate_config.vep.fasta),
         params.annotate_config.vep.cache_version,
         params.genome_build,
         file(params.annotate_config.vep.clinvar_vep),
         file(params.annotate_config.vep.clinvar_vep_index),
         file(params.annotate_config.vep.plugins_scripts),
          file(params.annotate_config.vep.gnomad_sv),
         file(params.annotate_config.vep.gnomad_sv_index))

    emit:
      annotated_vcf = vepSV.out
}

process indexGIAB {
  tag "tabix GIAB vcf for VEP"

  input:
    path sv_vcf
  
  output:
  tuple path(sv_vcf), path ("${giab_vcf}.tbi"), emit: sv_vcf_and_index

  script:
  """
  tabix -f -p vcf ${giab_vcf}
  """

}

process vepSV {
  tag "VEP 110"
  beforeScript 'chmod o+rw .'
  publishDir "${params.run_folder}/vep/", mode: 'copy'

  input:
    tuple path (sv_vcf), path(sv_vcf_index)
    path vep_cache
    path vep_fasta
    val cache_version
    val genome_build
    path clinvar_vep
    path clinvar_vep_index
    path vep_plugins
    path gnomad_sv
    path gnomad_sv_index

  output:
    path output_vcf

  script:
  output_vcf = "${giab_vcf}_sv_vep${cache_version}.vcf.gz"
  
  """
  vep \
  -i ${sv_vcf} \
  --custom file=${clinvar_vep},short_name=ClinVar,format=vcf,type=exact,coords=0,fields=CLNSIG%CLNREVSTAT%CLNDN \
  --plugin StructuralVariantOverlap,file=${gnomad_sv} \
  --cache \
  --dir_cache ${vep_cache} \
  -o ${output_vcf} \
  --vcf \
  --format vcf \
  --force_overwrite \
  --buffer_size 5000 \
  --offline \
  --total_length \
  --no_stats \
  --fasta ${vep_fasta} \
  --merged \
  --cache_version ${cache_version} \
  --no_check_variants_order \
  --numbers \
  --exclude_predicted \
  --overlaps \
  --assembly ${genome_build} \
  --mane \
  --canonical \
  --max_sv_size 100000000 \
  --compress_output bgzip
  
  tabix -p vcf ${output_vcf}
  """

}

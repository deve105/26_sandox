#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  pixi run star-align-pe <genome_dir> <reads_1.fq.gz> <reads_2.fq.gz> <output_prefix> [threads]

Example:
  pixi run star-align-pe refs/star_index data/sample_R1.fastq.gz data/sample_R2.fastq.gz results/star/sample_ 16

Output:
  STAR writes a coordinate-sorted BAM as <output_prefix>Aligned.sortedByCoord.out.bam
  This script also creates a BAM index with samtools.
USAGE
}

if [[ $# -lt 4 || $# -gt 5 ]]; then
  usage
  exit 2
fi

genome_dir="$1"
reads_1="$2"
reads_2="$3"
output_prefix="$4"
threads="${5:-8}"

mkdir -p "$(dirname "$output_prefix")"

STAR \
  --runThreadN "$threads" \
  --genomeDir "$genome_dir" \
  --readFilesIn "$reads_1" "$reads_2" \
  --readFilesCommand zcat \
  --outFileNamePrefix "$output_prefix" \
  --outSAMtype BAM SortedByCoordinate \
  --quantMode GeneCounts

samtools index "${output_prefix}Aligned.sortedByCoord.out.bam"

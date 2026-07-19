#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  pixi run star-index <genome_fasta> <annotation_gtf> <genome_dir> [threads] [sjdb_overhang]

Example:
  pixi run star-index refs/genome.fa refs/genes.gtf refs/star_index 16 100

Notes:
  sjdb_overhang should usually be read_length - 1, e.g. 100 for 101 bp reads.
USAGE
}

if [[ $# -lt 3 || $# -gt 5 ]]; then
  usage
  exit 2
fi

genome_fasta="$1"
annotation_gtf="$2"
genome_dir="$3"
threads="${4:-8}"
sjdb_overhang="${5:-100}"

mkdir -p "$genome_dir"

STAR \
  --runThreadN "$threads" \
  --runMode genomeGenerate \
  --genomeDir "$genome_dir" \
  --genomeFastaFiles "$genome_fasta" \
  --sjdbGTFfile "$annotation_gtf" \
  --sjdbOverhang "$sjdb_overhang"

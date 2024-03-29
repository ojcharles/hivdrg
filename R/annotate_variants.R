#' Annotates variants
#'
#' Adds genome annotation to the intermediate resistance data.frame
#'
#' @param f.dat intermediate data.frame
#' @param global Package object for consistent runtime variables
#' @return intermediate data.frame with genome level annotation
#' 

annotate_variants <- function(f.dat,global){
  # cannot handle ambiguous bases
  f.dat = f.dat[f.dat$Var %in% c("A", "C", "G", "T"),]
  toannotate <- f.dat
  check <- IRanges::IRanges(start=toannotate$Position, end=toannotate$Position, width=1)
  gr <- GenomicRanges::GRanges(seqnames = global$genome ,ranges=check)
  S4Vectors::values(gr) <- S4Vectors::DataFrame(id = toannotate$Sample, freq = toannotate$VarFreq, RefCount= toannotate$Ref.count, VarCount= toannotate$Var.count, VarAllele=toannotate$Var)
  varallele <- Biostrings::DNAStringSet(toannotate$Var)
  txdb <- suppressMessages(GenomicFeatures::makeTxDbFromGFF(file=global$path_gff3_file, format="gff3")) # takes 1 sec, save and load.
  #txdb <- AnnotationDbi::loadDb(global$path_txdb)
  gn <- GenomicFeatures::genes(txdb)
  ##variant data
  vcf <- gr
  #seqlevels need to match with txdb
  GenomeInfoDb::seqlevels(txdb) <- global$genome
  GenomeInfoDb::seqlengths(vcf) <- GenomeInfoDb::seqlengths(txdb)[names(GenomeInfoDb::seqlengths(vcf))]
  GenomeInfoDb::isCircular(vcf) <- GenomeInfoDb::isCircular(txdb)[names(GenomeInfoDb::seqlengths(vcf))]
  #genome sequence from fasta file
  fa <- Rsamtools::FaFile(global$path_fasta_file)
  codvar <- suppressMessages(suppressWarnings(VariantAnnotation::locateVariants(vcf, txdb, VariantAnnotation::CodingVariants())))
  coding <- suppressWarnings(VariantAnnotation::predictCoding(vcf, varAllele = varallele, txdb, seqSource=fa , ignore.strand=FALSE))
  txids <- S4Vectors::values(GenomicFeatures::transcripts(txdb))$tx_name
  names(txids) <- S4Vectors::values(GenomicFeatures::transcripts(txdb))$tx_id
  coding_df <- as.data.frame(coding)
  #coding_df <- DataFrame(coding)
  coding_df$aachange <- paste(coding_df$REFAA,coding_df$PROTEINLOC,coding_df$VARAA,sep="")
  coding_df$change <- paste(coding_df$GENEID,coding_df$aachange,sep="_")
  return(coding_df)
}
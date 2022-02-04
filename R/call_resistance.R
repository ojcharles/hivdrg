#' HIV Resistance Genotyping from command line
#'
#' Command line version of the website application
#' Takes as input a VCF, varscan tab or fasta file.
#' The program assumes variant files are generated relative to Merlin strain.
#' Fasta files if not Whole Genome, or not aligned / assembled relative to Merlin 
#' are Processed using MAFFT & snp-sites.
#' In this case the output files are returned to your working directory.
#'
#' @param infile the input fasta, vcf or varscan.tab file
#' @param all_mutations when FALSE only recognised resistant variants present are returned.
#' @param outdir for fasta input files intermediate alignment fasta & vcf files are generated, this defines the directory they are saved to. "out.fasta" "out.vcf"
#' @param ref a choice of 5 HIV representative genomes, pass a number 1-5,  "AG_L39106.1","C_AF067155.1","G_U88826.1", "JX239390.1","K03455.1"
#' @return A data.frame containing resistance information for variants identified
#' @export


call_resistance = function(infile = system.file("testdata",  "example.vcf", package = "hivdrg"), all_mutations = TRUE, ref = 5,  outdir = ""){
  print("ref should be an integer between 1 and 5, used to identify the HIV reference genome below")
  print(c("AG_L39106.1","C_AF067155.1","G_U88826.1", "JX239390.1","K03455.1"))
  
  # checks
  if(ref < 1 | ref > 6){
    stop('ref not between 1 and r')
  }
  
  global = list()
  global$res_table = system.file("db", "resmuts.csv", package = "hivdrg")
  #create unique session folder
  global$date <- format(Sys.time(), "%Y-%m-%d")
  global$dir = outdir
  global$genome = c("AG_L39106.1","C_AF067155.1","G_U88826.1", "JX239390.1","K03455.1", "AF411967_steve")[ref]
  global$path_gff3_file=system.file("ref", paste0(global$genome,".gff3"), package = "hivdrg")
  global$path_fasta_file=system.file("ref", paste0(global$genome,".fasta"), package = "hivdrg")
  global$path_txdb=system.file("ref", paste0(global$genome,".sqlite"), package = "hivdrg")
  
  
  dat1 = read_input(infile, global = global)
  ### annotate variants
  dat2 <- annotate_variants(f.dat = dat1, global = global)
  
  ### add res info
  dat3 <- add_resistance_info(f.dat = dat2, resistance_table=global$res_table, all_muts = all_mutations)
  
  # clean data
  dat3$gene = NULL
  dat3$mutation = NULL
  dat3$CDSID = NULL
  return(dat3)
}

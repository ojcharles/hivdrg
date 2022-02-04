#' Handles varscan data
#'
#' reads varscan files & returns a formatted data.frame
#'
#' @param f.df data.frame of read varscan file
#' @return formatted data.frame
#' 

read_varscan_data <- function(f.df){
  #reads a single file of varscan data
  
  #dat <- read.table(file = inFile$datapath, header = T, as.is = T, sep = "\t")
  #dat <- read.table(file = inFile, header = T, as.is = T, sep = "\t")
  dat <- f.df
  dat$id = "single run"
  # change this to a set of grepl commands, 
  if( grepl(":", dat[,5])[1] ){
    df.het <- as.data.frame(matrix(unlist(strsplit(as.character(dat[,5]), split=":")), ncol=6, byrow="T"), stringsAsFactors=F)
    all <- cbind(dat[,1:4], df.het[,1:5], dat[,6],dat[,12]) # shifted from in-house 
    colnames(all)[5]<-"Var_touse"
    colnames(all)[6]<-"something"
    colnames(all)[7]<-"Ref.count"
    colnames(all)[8]<-"Var.count"
    colnames(all)[9]<-"VarFreq"
    colnames(all)[10]<-"StrandFilter"
    colnames(all)[11]<-"Sample"
    all$Var_touse <- NULL
    all$StrandFilter <- NULL
    all$something <- NULL
    all$Chrom <- NULL
  }else{
    all = data.frame(
      "Position" = dat[,2],
      "Ref" = dat[,3],
      "Var" = dat[,19],
      "Ref.count" = dat[,5],
      "Var.count" = dat[,6],
      "VarFreq" = dat[,7],
      "Sample" = dat[,1]
    )
  }
  
  return(all)
}
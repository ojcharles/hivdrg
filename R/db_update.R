# this takes the 4 hivdb files and spits out a format we can consume


# lists the hivdb files
files = list.files("inst/db","*.tsv",full.names = T)

# thing to append and build
resdb = data.frame(res)

# for each file, make the protein explicit and append the resdb
for(i in 1:length(files)){
  
  file = files[i]
  # what gene does the table correspond to?
  if( grepl("ScoresPI", file) ){
    gene = "protease"
  }else if( grepl("ScoresINSTI", file) ){
    gene = "integrase"
  }else{
    gene = "rt"
  }
  
  
  dat = read.delim(file , sep = "\t")
  
  # some col headers have /r, which is unnecessary , remove them
  cols = gsub(".r","",colnames(dat))
  cols = gsub("X3","3",cols)
  colnames(dat) = cols
  
  dat2 = data.frame(change = paste(gene, dat[,1], sep = "_"),
                    dat[4:ncol(dat)])#then all the drug data
  
  if(i == 1){
    resdb = dat2
  }else{
    resdb = merge(resdb, dat2, by = "change",all = T)
  }
  

  
}

# add interpretation column
resdb = data.frame(change = resdb[,1],
                   phenotype = "",
                   resdb[2:ncol(resdb)])

# for each entry identify the maximum resistance phenotype
ncol = ncol(resdb)
for(i in 1:nrow(resdb)){
  t = resdb[i,3:ncol]
  
  max_impact = max(t,na.rm = T)
  if(max_impact < 10){
    ph = "susceptible"
  }else if( max_impact < 14){
    ph = "potential low-level"
  }else if( max_impact < 29){
    ph = "low-level"
  }else if( max_impact < 59 ){
    ph = "intermediate"
  }else{
    ph = "high-level"
  }
  resdb[i,2] = ph
}

# split into singlevar and covar

which.covar = grepl("\\+", resdb$change)

# write SAVs
write.csv(resdb[!which.covar,], "inst/db/stanford_sav.csv",row.names = F)

# write covar
write.csv(resdb[which.covar,], "inst/db/stanford_covar.csv",row.names = F)

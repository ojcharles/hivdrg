#' Resistance Genotyping
#'
#' Calls resistance for variants provided, joins the variant and resistance tables by mutational change columns. <GENE_A123B>
#'
#' @param f.dat intermediate-annotated data.frame
#' @param resistance_table the current version of the resistance db in csv format
#' @param all_muts when TRUE all variants passed are returned even if they conferred no resistance
#' @param anecdotal include anectodat database entries in returned results?
#' @return data.frame of resistance variants
#' @keywords internal
#' @export
#'
add_resistance_info <-
  function(f.dat,
           resistance_table,
           all_muts = TRUE) {
    coding_df <- f.dat
    resistance = utils::read.csv(resistance_table, header = TRUE, as.is = TRUE)
    
    # filter status - records on-revision may be below the data quality we expect, and are flagged.
    resistance$change <- paste(resistance$gene, resistance$mutation, sep = "_")
    resistance$phenotype = "Resistant"
    
    
    # merge resistance & mutation data
    if (all_muts == F) {
      coding_df_res <- base::merge(x = coding_df, y = resistance,
                                   by = "change")
    } else{
      coding_df_res <- base::merge(
        x = coding_df,
        y = resistance,
        by = "change",
        all.x = T
      )
    }
    
    coding_df_res$PROTEINLOC = as.numeric(coding_df_res$PROTEINLOC)
    
    #coding_df_res <- cbind(resistance_site,coding_df)
    return(coding_df_res)
    
  }

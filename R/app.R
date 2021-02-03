#library(hivdrg)
library(shiny)
library(data.table)

ui <- fluidPage(
  titlePanel("Upload 1 or more VCF or fasta HIV sequences"),
  sidebarLayout(
    sidebarPanel(
      fileInput("infiles",
                label="Upload here",
                multiple = TRUE),
      downloadButton("download","Download files here when complete")
    ),
    mainPanel(
      #verbatimTextOutput("text")
    )
  )
)

server <- function(input, output, session) {
  
  #output$text = renderText(input$infiles[1])
    
    
  output$download <- downloadHandler(
    filename = function(){
      paste0("hivdrg_",Sys.Date(),".zip")

    },
    content = function(file){
      #go to a temp dir to avoid permission issues
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      outfiles <- NULL;

      #loop through the sheets
      df = data.frame()
      for (i in 1:length(input$infiles$datapath)){
        dpath = input$infiles$datapath[i]
        npath = input$infiles$name[i]
        #write each sheet to a csv file, save the name
        fileName <- paste(basename(npath),".csv",sep = "")
        a = hivdrg::call_resistance(dpath)
        a = cbind(filename = npath[i], a)
        write.csv(a, fileName)
        outfiles <- c(fileName,outfiles)
      }
      #create the zip file
      zip(file,outfiles)
    }
  )

  # for(i in 1:length(input$infiles[,1])){
  #   lst[[i]] <- read.csv(input$files[[i, 'datapath']])
  # }
  
}

shinyApp(ui = ui, server = server)






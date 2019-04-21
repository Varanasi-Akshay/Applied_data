VARANASI_TXPUC_SINGLE_HWK1 <- function(month,year){
  
  # load needed libraries 
  library(pdftools)
  library(xml2)
  library(rvest)
  
  ## read in links to electricity rate PDFs from TX PUC
  
  # This creates an empty matrix "x" with column names that the below loops will fill
  x <- matrix(vector(), 0, 7, dimnames=list(c(), c('Plan', 'kWh500', 'kWh1000', 'kWh1500', 'kWh2000', 'year','month')))
  
    
    # this creates the URL  
    location <- paste('https://www.puc.texas.gov/industry/electric/rates/RESrate/rate', year,'/',month,year,'Rates.pdf', sep = '')
    
    
    # this downloads the PDF, writes it to 'webtest.pdf'
    download.file(url = location, destfile = 'webtest.pdf', mode = 'wb')
    
    # this parses the PDF into text // again I Googled a bunch to figure out how to convert a PDF to text
    txt <- pdf_text("webtest.pdf")
    
    # this parses up the PDF into pages (high-level, [[]]) and lines [] by breaking on the '\n' carriage return  
    txt2 <- strsplit(txt, "\n")
    
    # this gets how many pages are in the PDF
    pages <- length(txt2)
    
    # this calls first loop over pages in the pdf
    for(i in 1:pages){
      
      # this creates another empty matrix that will be appended onto the x matrix created at the beginning of the code
      y <- matrix(vector(), 0, 5, dimnames=list(c(), c('Plan', 'kWh500', 'kWh1000', 'kWh1500', 'kWh2000')))
      
      # now we need to cycle over the lines on each page, but need to find out how many lines are in each one
      page_lines <- length(txt2[[i]])
      
      # this is the 2nd nested for loop that is now going through each line of each page of each PDF
      for(j in 1:page_lines){
        
        # this splits up line j on page i on the double space character "  "
        line <- strsplit(txt2[[i]][j], split = "  ")
        
        # this removes all parts of "line" that are the empty character ""
        line <- line[[1]][!line[[1]] == ""]
        
        # if the length of line is 5, i.e. it has a 'Plan', 'kWh500', 'kWh1000', 'kWh1500', 'kWh2000' entry, then append it to the y matrix
        if(length(line) == 5){
          
          y <- rbind(y, line)
          
        } #end if
        
      } # end j
      # make the matrix y a dataframe
      y <- as.data.frame(y) 
      
      # append the year to the end of the y dataframe
      y$year <- year 
      y$month<- month
      
      # this appends each y dataframe (an individual PDFs worth of lines) onto x
      x <- rbind(x, y)
      
    } # end i
    
 
  
  
  # make x a dataframe
  x <- as.data.frame(x)
  
  # cancel out rownames 
  rownames(x) <- NULL
  
  x = transform(x, kWh500 = as.numeric(as.character(kWh500)), kWh1000 = as.numeric(as.character(kWh1000)), kWh1500 = as.numeric(as.character(kWh1500)), kWh2000 = as.numeric(as.character(kWh2000)),year = as.numeric(as.character(year)),month = (as.character(month)))
  filename<-paste('VARANASI_TXPUC_HWK1_',month,'_',year,'.csv',sep='')
  write.csv(x,filename,row.names = FALSE)
  #return(x)
  
}
RHODES_TXPUC <- function(){
  
  # load needed libraries 
  library(pdftools)
  library(xml2)
  library(rvest)
  
  ## read in links to electricity rate PDFs from TX PUC
  
  # This is the page that has all of the linked PDF files
  pg <- read_html('http://www.puc.texas.gov/industry/electric/rates/RESrate/RESratearc.aspx')
  
  # this gets a list of all the links on the page, i.e. gets all the hyper-references in the HTML on the page itself // I just Googled until I found this
  pg2 <- html_attr(html_nodes(pg, "a"), "href")
  
  # this gets a list of the links from pg2 that have "Rates.pdf" in the reference, 2007 and newer
  pg3 <- pg2[grep(pattern = "Rates.pdf", x = pg2, ignore.case = FALSE)]
  
  
  # This creates an empty matrix "x" with column names that the below loops will fill 
  x <- matrix(vector(), 0, 6, dimnames=list(c(), c('Plan', 'kWh500', 'kWh1000', 'kWh1500', 'kWh2000', 'year')))
  
  # as of 2018-09-18, there are 132 linked PDFs ( length(pg3) ) to cycle over, this for loop is going over all except #62
  for(k in c(1:61, 63:length(pg3))){	##### number 62, or "https://www.puc.texas.gov/industry/electric/rates/RESrate/rate12/Nov12Rates.pdf" DOES NOT WORK, it is the only one... 
    
    # this was for me to find out which PDF is being accessed, for trouble shooting early on, but I left it in
    #print(k)
    
    # this creates the URL where the current "k" PDF is 
    location <- paste('https://www.puc.texas.gov/industry/electric/rates/RESrate/', pg3[k], sep = '')
    
    # this breaks up the URL to access the year assocaited with the PDF, save it for later
    year <- strsplit(location, split = '/')[[1]][8]
    print(location)
    
    # this downloads the PDF, writes it to 'webtest.pdf'
    download.file(url = location, destfile = 'webtest.pdf', mode = 'wb')
    
    # this parses the PDF into text // again I Googled a bunch to figure out how to convert a PDF to text
    txt <- pdf_text("webtest.pdf")
    
    # this parses up the PDF into pages (high-level, [[]]) and lines [] by breaking on the '\n' carriage return  
    txt2 <- strsplit(txt, "\n")
    
    # this gets how many pages are in the PDF
    pages <- length(txt2)
    
    # this calls another for loop within the first one that now is going to cycle through the pages of the PDF "k"
    for(i in 1:pages){
      
      # this creates another empty matrix that will be appended onto the x matrix created at the beginning of the code
      y <- matrix(vector(), 0, 5, dimnames=list(c(), c('Plan', 'kWh500', 'kWh1000', 'kWh1500', 'kWh2000')))
      
      # now we need to cycle over the lines on each page, but need to find out how many lines are in each one
      page_lines <- length(txt2[[i]])
      
      # this is the 3rd nested for loop that is now going through each line of each page of each PDF
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
      
      
    } # end i
   
   # make the matrix y a dataframe
   y <- as.data.frame(y) 
   
   # append the year to the end of the y dataframe
   y$year <- year 
   
   # this appends each y dataframe (an individual PDFs worth of lines) onto x
   x <- rbind(x, y)
     
  } # end k
  
  
  # make x a dataframe
  x <- as.data.frame(x)
  
  # cancel out rownames 
  rownames(x) <- NULL
  
  x = transform(x, kWh500 = as.numeric(as.character(kWh500)), kWh1000 = as.numeric(as.character(kWh1000)), kWh1500 = as.numeric(as.character(kWh1500)), kWh2000 = as.numeric(as.character(kWh2000)))
  
  return(x)
  
}
library("rio")
xls <- dir(pattern = "xlsx")
created <- mapply(convert, xls, gsub("xlsx", "csv", xls))
unlink(xls) # delete xlsx files
# This script reproduces plot2.R
library(lubridate) # date library
library(dplyr) # I love dplyr for the chaining and methods
d1 <- ymd("2007-02-01")
d2 <- ymd("2007-02-02")
read_data = TRUE
if (read_data) {
  #d1 <- ymd("2006-12-16")
  #d2 <- ymd("2006-12-16")
  # First, we read the "date" column of the data, and find the subset indices
  #epc <- read.table("household_power_consumption.txt",header = TRUE,nrows = 10,na.strings = "?", sep = ";" )
  # Get the number of columns by reading one row:
  tmp <- read.table("household_power_consumption.txt",header = TRUE, 
                    nrows = 1,na.strings = "?", sep = ";" )
  epc <- tbl_df(read.table("household_power_consumption.txt",header = TRUE, 
                           #nrows = 1000,
                           na.strings = "?", sep = ";", 
                           colClasses = c("character",rep("NULL",ncol(tmp)-1)))) #Read only date column
  # Get the indices of the dates that satisfy the requirement
  epc <- epc %>% mutate(Date = dmy(Date)) %>% mutate (id_to_import = (Date<=d2 & Date>=d1))
  # Read only those lines :
  data_to_plot <- tbl_df(read.table("household_power_consumption.txt",header = TRUE,na.strings = "?",
                                    sep = ";" )[epc$id_to_import,])
  data_to_plot <- data_to_plot %>% mutate(Date = dmy(Date)) %>% mutate (Time = hms(Time))
}
# Do plotting
par(mfrow = c(1,1))

with(data_to_plot, {
  plot(Date+Time, Global_active_power,col = "black",
       ylab = "Global Active Power (kilowatts)",xlab="",type= "l",lwd=2)
  })
dev.print(png, 'plot2.png', width = 480, height = 640)

#dev.copy(png, file = "plot2.png", width = 480, height = 640)
#dev.off()

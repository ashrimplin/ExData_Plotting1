#load the appropriate libraries
library(RCurl)
library(reshape)

#load the power consumption file
hpc = read.csv("household_power_consumption.txt", na.strings="?", sep=";", stringsAsFactors=FALSE)

#format the date field 
hpc$Date = as.Date(hpc$Date,"%d/%m/%Y")

#create new data frame to subset data for dates 02-01-2007 and 02-02-2007
hpc_2_day = subset(hpc, Date>="2007-02-01" & Date<="2007-02-02")

#create a new DateTime field to get timestamp information and format the field
hpc_2_day$DateTime <- paste(hpc_2_day$Date, hpc_2_day$Time, sep=' ') 
hpc_2_day$DateTime = strptime(hpc_2_day$DateTime, "%Y-%m-%d %H:%M:%S")

#sort the data DateTime ascending
hpc_2_day <- hpc_2_day[order(hpc_2_day$DateTime),] 

#launch graphics device
pdf(file = "plot1.pdf") 

#create the plot
hist(hpc_2_day$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")

#close the file device
dev.off()
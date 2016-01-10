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

#create variable based on the sub_metering columns 
hpc_2_day_melt = melt(hpc_2_day, id=c("Date","Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "DateTime"))

#launch graphics device
pdf(file = "plot3.pdf")

#create the plot
with(hpc_2_day_melt, plot(DateTime, value, type = "l", ylab = "Energy sub metering", xlab = ""))
with(subset(hpc_2_day_melt, variable == "Sub_metering_1"), lines(DateTime, value, col = "black"))
with(subset(hpc_2_day_melt, variable == "Sub_metering_3"), lines(DateTime, value, col = "blue"))
with(subset(hpc_2_day_melt, variable == "Sub_metering_2"), lines(DateTime, value, col = "red"))
legend("topright", pch = '_', col = c("black", "blue", "red"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#close the file device
dev.off()
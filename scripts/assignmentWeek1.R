fileURL <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
download.file(fileURL, destfile='data/data_extract.zip')
unzip("data/data_extract.zip", exdir="data")
data <- read.delim("data/household_power_consumption.txt", sep=";", na.strings="?")

library(dplyr)
library(lubridate)
#cleaning dates format so that it can be merged with time and into a datetime column
filteredData <- filter(data, grepl("^[12]/2/2007", Date))
filteredData["Date"] <- lapply(filteredData["Date"],function(x){strptime(as.Date(x,format="%d/%m/%Y"), format="%Y-%m-%d")})
filteredData$dateTime<- as.POSIXct(paste(filteredData$Date, filteredData$Time), format="%Y-%m-%d %H:%M:%S")

#graph1
png(filename="plot1.png", width=480, height=480)
hist(filteredData$Global_active_power, xlab="Global Active Power (kilowatts)", main="Global Active Power", col="red" )
dev.off()

#graph2
png(filename="plot2.png", width=480, height=480)
with(filteredData, plot(Global_active_power~ dateTime, type="l", xlab="", ylab="Global Active Power (kilowatts)"))
dev.off()

#graph3
png(filename="plot3.png", width=480, height=480)
with(filteredData,
     plot(Sub_metering_1 ~ dateTime, type="l", xlab="", ylab="Energy sub metering"),
     )
lines(filteredData$Sub_metering_2 ~ filteredData$dateTime, col="red")
lines(filteredData$Sub_metering_3 ~ filteredData$dateTime, col="blue")
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red","blue"), lty=1)
dev.off()

#graph4
png(filename="plot4.png", width=480, height=480)
par(mfrow=c(2,2), mar=c(4,6,2,1))
with(filteredData, plot(Global_active_power~ dateTime, type="l", xlab="", ylab="Global Active Power (kilowatts)"))

with(filteredData,
     plot(Voltage ~ dateTime, type="l", xlab="datetime", ylab="Voltage"))

with(filteredData,
     plot(Sub_metering_1 ~ dateTime, type="l", xlab=""))

lines(filteredData$Sub_metering_2 ~ filteredData$dateTime, col="red")
lines(filteredData$Sub_metering_3 ~ filteredData$dateTime, col="blue")
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red","blue"), lty=1, bty="n")

with(filteredData,
     plot(Global_reactive_power ~ dateTime, type="l", xlab="datetime"))
dev.off()
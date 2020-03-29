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

#graph3
png(filename="plot3.png", width=480, height=480)
with(filteredData,
     plot(Sub_metering_1 ~ dateTime, type="l", xlab="", ylab="Energy sub metering"),
)
lines(filteredData$Sub_metering_2 ~ filteredData$dateTime, col="red")
lines(filteredData$Sub_metering_3 ~ filteredData$dateTime, col="blue")
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red","blue"), lty=1)
dev.off()
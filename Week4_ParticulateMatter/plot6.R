fileURL <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
download.file(fileURL,destfile='data.zip')
unzip('data.zip')

NEI <- readRDS('summarySCC_PM25.rds')
SCC <- readRDS("Source_Classification_Code.rds")


#plot6
png(filename="plot6.png", width=720, height=320)
par(mfrow=c(1,3))
LAmotor <- subset(motorData, motorData$fips=="06037")
LAmotordata <- tapply(LAmotor$Emissions, LAmotor$year, sum)
LAdf <- data.frame(year=names(LAmotordata), totals=LAmotordata)
LAdf$year <- as.numeric(as.character(LAdf$year))

plot(LAdf$year, LAdf$totals, ylim=c(0,10000), xlab="Year", ylab="Total Emissions", type="n", main="Overall")
points(LAdf$year, LAdf$totals, col="blue")
lines(LAdf$year, LAdf$totals, col="blue")

points(baltdf$year, baltdf$totals, col="red")
lines(baltdf$year, baltdf$totals, col="red")
legend("topright", legend=c("LA","Baltimore"), col=c("blue","red"), lty=1)

plot(baltdf$year, baltdf$totals, type="b", xlab="Year", ylab="Total Emissions", main="Baltimore")
plot(LAdf$year, LAdf$totals, type="b", xlab="Year", ylab="Total Emissions", main="LA")
dev.off()
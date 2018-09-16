### Download and unzip
hpc_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(hpc_url, "hpc.zip")
unzip("hpc.zip")
file.remove("hpc.zip")

### Read relevant rows
txt <- "household_power_consumption.txt"
relevant_rows <- grep("^[12]/2/2007", readLines(txt))
hpc <- read.table(txt, skip = relevant_rows[[1]] - 1, # Skip all rows before start of relevant rows
                  nrows = length(relevant_rows), # Select the number of relevant rows
                  sep = ";", na.strings = "?") # NAs are coded as "?"

### Add header
header <- read.table("household_power_consumption.txt", nrows = 1, sep = ";")
names(hpc) <- unlist(header[1,])

### Concatenate date and time and convert to datetime format
hpc$Date <- paste(hpc$Date, hpc$Time)
hpc$Date <- strptime(hpc$Date, format = "%d/%m/%Y %H:%M:%S")
names(hpc)[1] <- "datetime"
hpc <- hpc[,-2] # Time column is redundant now

### Plot graphic to PNG
png("plot4.png", width = 480, height = 480)
par(mfcol=c(2,2))

## First graphic
x <- hpc$datetime
y <- hpc$Global_active_power
plot(x, y, type = "n", xlab = "", ylab = "Global Active Power")
lines(x, y)

## Second graphic
y1 <- hpc$Sub_metering_1
y2 <- hpc$Sub_metering_2
y3 <- hpc$Sub_metering_3
plot(x, y1, type="n", xlab = "", ylab = "Energy sub metering")
lines(x, y1, col = "Black")
lines(x, y2, col = "Red")
lines(x, y3, col = "Blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = c(1,1), col = c("Black", "Red", "Blue"), bty = "n")

## Third graphic
plot(x, hpc$Voltage, xlab = "datetime", ylab = "Voltage", type = "n")
lines(x, hpc$Voltage)

## Fourth graphic
plot(x, hpc$Global_reactive_power, xlab = "datetime", ylab = "Global_reactive_power", type = "n")
lines(x, hpc$Global_reactive_power)

dev.off()

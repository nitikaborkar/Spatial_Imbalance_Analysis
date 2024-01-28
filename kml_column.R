library(st)
library(sf)
install.packages("data.table")  
library(data.table)
install.packages("dplyr")  # Install dplyr package if not already installed
library(dplyr)
TracesData <- fread("1DayTracesData.csv")
TracesData$adma_location_read_at <- as.POSIXct(TracesData$adma_location_read_at / 1000, origin = as.POSIXct("1970-01-01"))

#filtering the data table to contain - only minutes>55 or the minutes<5

# Extract minutes from the adma_location_read_at column
TracesData[, minute := as.numeric(format(adma_location_read_at, "%M"))]

# Filter rows based on the time condition
TracesData <- TracesData[minute >= 55 | minute <= 5]

# Remove the temporary column 
TracesData[, minute := NULL]

kml_data <- st_read("Community.kml")
kml_valid<-st_make_valid(kml_data)

traces_data<-unique(TracesData[,.(driver_id,adma_location_read_at,latitude,longitude)])
traces_data_sf <- sf::st_as_sf(traces_data, coords=c("longitude","latitude"), crs=st_crs(kml_data))

result_traces <- st_join(traces_data_sf, kml_valid, join = st_within)
result_traces <- result_traces %>% mutate(longitude = sf::st_coordinates(.)[,1],
                                          latitude = sf::st_coordinates(.)[,2])

result_traces <- as.data.table(result_traces)

result_traces[,c("Description","geometry") := NULL]

fwrite(result_traces, "tracesKML.csv")


#doing the same for order data frame

OrderData <- fread("1DayOrderData.csv")

#filtering the data table to contain - only minutes>55 or the minutes<5

# Extract minutes from the adma_location_read_at column
OrderData[, minute := as.numeric(format(order_received_timestamp, "%M"))]

# Filter rows based on the time condition
OrderData <- OrderData[minute >= 55 | minute <= 5]

# Remove the temporary column 
OrderData[, minute := NULL]


order_data<-unique(OrderData[,.(order_id,order_received_timestamp,assigned_lon,assigned_lat)])
order_data_sf <- sf::st_as_sf(order_data, coords=c("assigned_lon","assigned_lat"), crs=st_crs(kml_data))

result_order <- st_join(order_data_sf, kml_valid, join = st_within)
result_order <- result_order %>% mutate(assigned_lon = sf::st_coordinates(.)[,1],
                                        assigned_lat = sf::st_coordinates(.)[,2])

result_order <- as.data.table(result_order)

result_order[,c("Description","geometry") := NULL]

fwrite(result_order, "orderKML.csv")



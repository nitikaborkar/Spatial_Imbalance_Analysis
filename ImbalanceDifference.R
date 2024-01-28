library(readr)
library(dplyr)
library(data.table)
order<-fread("orderKML.csv")
traces<-fread('tracesKML.csv')

setnames(order, "Name", "kml_region")
setnames(traces, "Name", "kml_region")

traces[, hour := 0] # Create a new column called hour in traces
# Extract and format hour and minutes from adma_location_read_at
traces[, hour := as.numeric(format(adma_location_read_at, "%H"))]
minutes <- as.numeric(format(traces$adma_location_read_at, "%M"))

#If minutes are greater than or equal to 55 and update the hour column
traces[minutes >= 55, hour := (hour + 1)%%24]

#take only the distint drivers in each kml_region for each hour
traces <- unique(traces, by = c("driver_id", "kml_region", "hour"))

####### doing the same for order ###########
order[, hour := 0] # Create a new column called hour in traces
# Extract and format hour and minutes from adma_location_read_at
order[, hour := as.numeric(format(order_received_timestamp, "%H"))]
minutes <- as.numeric(format(order$order_received_timestamp, "%M"))

#If minutes are greater than or equal to 55 and update the hour column
order[minutes >= 55, hour := (hour + 1) %% 24]

#take only the distint drivers in each kml_region for each hour
order <- unique(order, by = c("order_id", "kml_region", "hour"))


##########

#Imbalance per hour

#Getting no. of drivers per hour
Hourly_Imbalance1 <-traces[,.(no_of_drivers = .N), by = .(hour)]
#Getting no. of order per hour
Hourly_Imbalance2 <-order[,.(no_of_orders = .N), by = .(hour)]

#Merging the two data tables into one 
Hourly_imbalance <- merge(Hourly_Imbalance1, Hourly_Imbalance2, by = "hour", all.x = TRUE)

# replacing Na with 0
Hourly_imbalance[is.na(Hourly_imbalance$no_of_orders),no_of_orders:= 0]

Hourly_imbalance[, zone := ifelse(no_of_drivers < no_of_orders - no_of_drivers * 0.10, 'Red', 
                               ifelse(no_of_drivers > no_of_orders + no_of_drivers * 0.10, 'Green', 'Yellow'))]
#Imbalance for each kml_region

#Getting no. of drivers per hour per kml region
kml_imbalance1 <-traces[,.(no_of_drivers = .N), by = .(hour,kml_region)]
kml_imbalance1 <-kml_imbalance1[kml_region!=""]
#Getting no. of order per hour per kml region
kml_imbalance2 <-order[,.(no_of_orders = .N), by = .(hour,kml_region)]
kml_imbalance2 <-kml_imbalance2[kml_region!=""]

#Merging the two data tables into one 
kml_imbalance <- merge(kml_imbalance1, kml_imbalance2, by = c("hour", "kml_region"), all.x = TRUE)

# replacing Na with 0
kml_imbalance[is.na(kml_imbalance$no_of_orders),no_of_orders:= 0]


#sorting kml_imbalance based on kml_region and hour
kml_imbalance <- kml_imbalance[order(kml_region, hour)]

# Creating a zone column
kml_imbalance[, zone := ifelse(no_of_drivers < no_of_orders - no_of_drivers * 0.10, 'Red', 
                                   ifelse(no_of_drivers > no_of_orders + no_of_drivers * 0.10, 'Green', 'Yellow'))]

#Grouping by zone
zone_imbalance <-kml_imbalance[,.(count = .N), by = c("hour","zone")]

library(ggplot2)

# Create separate plots for each hour and combine them using facet_wrap
zone_imbalance %>%
  ggplot(aes(x = zone, y = count, fill = zone)) +
  geom_bar(stat = "identity") +
  facet_wrap(~hour, scales = "free_x", ncol = 4) +
  labs(title = "Hourly Bar Charts for Zones", x = "Zone", y = "Count") +
  scale_fill_manual(values = c("Red" = "red", "Yellow" = "yellow", "Green" = "green"))









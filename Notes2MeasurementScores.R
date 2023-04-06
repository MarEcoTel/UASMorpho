input <- read.csv(file.path("data", "measurement_inputs.csv"))
csv <- read.csv(input) %>% 
  dplyr::mutate(object_position = NA, ImageSharpness = NA, WaterState = NA, MeasurementAcc = NA, Comments = NA)
Notes <- strsplit(csv$Notes,"_")
for (i in 1:nrow(csv)) {
  csv$object_position[i] <- Notes[[i]][1]
  csv$ImageSharpness[i] <- strsplit(Notes[[i]][2],"IS")[[1]][2]
  csv$WaterState[i] <- strsplit(Notes[[i]][3],"WS")[[1]][2]
  csv$MeasurementAcc[i] <- strsplit(Notes[[i]][4],"MA")[[1]][2]
  csv$Comments[i] <- Notes[[i]][5]
}
write.csv(csv, file.path("data", "measurement_inputs.csv"), row.names=FALSE)

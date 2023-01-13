#### Manual Inputs ####
day_folder <- "C:/Users/marec/Docs/UAS/UAS-Calibrate/PVC-Frame_Calibrations/20220325"  #folder directory for days images

#### stuff that just needs to run ####
{
  #load necessary packages
  require(tidyverse)
  require(lubridate)
  
  #combine all whalength measurement files
  lf <- list.files(day_folder)
  lfiles <- lf[which(grepl("lengths",lf))] #just the files with Whalength measurements
  length_data <- data.frame()
  for (f in paste0(day_folder, "/", lfiles)) {
    length_data <- length_data %>% bind_rows(., read.csv(f, skip = 1,
                                                         col.names = c("WhaleID", "Date", "Time", 
                                                                       "Filename", "Image_sharpness",
                                                                       "Flukes_up", "Water_quality", "Sides_clear",
                                                                       "Tilt_deg", "Altitude_m", "Length_m", "Length_pix",
                                                                       "Width10_10", "Width10_20", "Width10_30",
                                                                       "Width10_40", "Width10_50", "Width10_60",
                                                                       "Width10_70", "Width10_80", "Width10_90", 
                                                                       "Width_eye", "Rostrum2eye",
                                                                       "Rostrum2BH", "Rostrum2DF", "Fluke_width",
                                                                       "BH2DF.insert", "Width_DF", "Folder", 
                                                                       "Label_for.mult.whales", "Notes",
                                                                       "Width5_5", "Width5_10", "Width5_15",
                                                                       "Width5_20", "Width5_25", "Width5_30",
                                                                       "Width5_35", "Width5_40", "Width5_45",
                                                                       "Width5_50", "Width5_55", "Width5_60",
                                                                       "Width5_65", "Width5_70", "Width5_75",
                                                                       "Width5_80", "Width5_85", "Width5_90",
                                                                       "Width5_95", "Content")) %>% 
                                               rename(FlightDate = Date) %>% 
                                               mutate(FlightDate = unlist(str_split(day_folder,"/"))[length(unlist(str_split(day_folder,"/")))]))
    
  }
  
  #apply values in 5% or 10% to the other measurement category
  for (i in 1:nrow(length_data)) {
    if (is.na(length_data$Width10_10[i])) {
      length_data$Width10_10[i] <- length_data$Width5_10[i]
    } else {
      if (is.na(length_data$Width5_10[i])) {
        length_data$Width5_10[i] <- length_data$Width10_10[i]
      }
    }
    if (is.na(length_data$Width10_20[i])) {
      length_data$Width10_20[i] <- length_data$Width5_20[i]
    } else {
      if (is.na(length_data$Width5_20[i])) {
        length_data$Width5_20[i] <- length_data$Width10_20[i]
      }
    }
    if (is.na(length_data$Width10_30[i])) {
      length_data$Width10_30[i] <- length_data$Width5_30[i]
    } else {
      if (is.na(length_data$Width5_30[i])) {
        length_data$Width5_30[i] <- length_data$Width10_30[i]
      }
    }
    if (is.na(length_data$Width10_40[i])) {
      length_data$Width10_40[i] <- length_data$Width5_40[i]
    } else {
      if (is.na(length_data$Width5_40[i])) {
        length_data$Width5_40[i] <- length_data$Width10_40[i]
      }
    }
    if (is.na(length_data$Width10_50[i])) {
      length_data$Width10_50[i] <- length_data$Width5_50[i]
    } else {
      if (is.na(length_data$Width5_50[i])) {
        length_data$Width5_50[i] <- length_data$Width10_50[i]
      }
    }
    if (is.na(length_data$Width10_60[i])) {
      length_data$Width10_60[i] <- length_data$Width5_60[i]
    } else {
      if (is.na(length_data$Width5_60[i])) {
        length_data$Width5_60[i] <- length_data$Width10_60[i]
      }
    }
    if (is.na(length_data$Width10_70[i])) {
      length_data$Width10_70[i] <- length_data$Width5_70[i]
    } else {
      if (is.na(length_data$Width5_70[i])) {
        length_data$Width5_70[i] <- length_data$Width10_70[i]
      }
    }
    if (is.na(length_data$Width10_80[i])) {
      length_data$Width10_80[i] <- length_data$Width5_80[i]
    } else {
      if (is.na(length_data$Width5_80[i])) {
        length_data$Width5_80[i] <- length_data$Width10_80[i]
      }  
    }
    if (is.na(length_data$Width10_90[i])) {
      length_data$Width10_90[i] <- length_data$Width5_90[i]
    } else {
      if (is.na(length_data$Width5_90[i])) {
        length_data$Width5_90[i] <- length_data$Width10_90[i]
      }
    }
  }
  
  #write data to csv
  write.csv(length_data %>% arrange(Filename), paste0(day_folder, "/", length_data$FlightDate[1], "_CompiledMeasurements.csv"), row.names=FALSE)
}
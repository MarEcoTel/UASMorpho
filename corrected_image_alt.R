# This R script is used calculate the true altitude of the drone camera after accounting for offset between the
# camera lense and the lense of the lidar unit and after taking into account tilt of the lidar during pitching and rolling
# of the drone during flight.
# 
# This script should be fulling functional by the time you are using it. Unlike some other script that are used while processing
# UAS data, this script is a function that is called separately each time you need a new true altitude obtained. In order to use this function
# you first must copy and paste the entire function script below into your command line. After that, you can use the function like 
# any other function in R.
# 
# This function's inputs are as follows:
#  - lidar_file = filepath to the compiled lidar data for the day's flights (likely named LidarLog_DailyMaster.csv if using other R scripts I developed)
#  - vid_start = start datetime of the video from which the still was captured in PDT (format = yyyy-mm-dd hh:mm:ss)
#  - still_time = time of video still (format = mm:ss:ZZ, where ZZ is from 1-30 as obtained from Adobe Premier Pro and likely shown in the still's file name)
#  - image_name = filename of image still (do not include .png or whatever at the end of the image name)
#  - safety_file = filepath and name of csv file where the input data will be stored (this is used later when performing calculations with the Collatrix software)
#  - lidar_camera_offset_cm = distance between the lidar lense and camera lense (default is -9 cm as the lidar on our Inspires are 9cm above the camera lenses)
#  - focal_length = camera focal length (default is 25 as this matches the Olympus cameras flown on our Inspires)
#  - pixel_dim = dimensions of the pixels in mm/pixel (defalt is 0.0045, again the olympus camera value)

# Below here is an example of how to run this function assuming the default settings for our Inspires with Olympus camera lenses
# corrected_image_alt("C:/Users/marec/Docs/UAS/UAS-Calibrate/PVC-Frame_Calibrations/20220325/LidarLog_DailyMaster.csv",
#                     "2022-03-25 11:37:09", "04:51:00", 
#                     "20220325113659_METRInspire1.MOV.00_04_51_00.Still021", 
#                     "C:/Users/marec/Docs/UAS/UAS-Calibrate/PVC-Frame_Calibrations/20220325/Measurements_Safety_File.csv")

# In order to use the following code, you need to make sure you have the following R packages installed on your computer:
# "tidyverse", "lubridate". Without these R packages, this code will not work.

# Unless you run into problems, you shouldn't need to change the code found under "stuff that just needs to run",
# so ignore that for now. As always, let me, David, know if you have any questions by emailing me
# at dsweeney@marecotel.org or by calling me at +1 224-804-7754.

corrected_image_alt <- function(lidar_file, vid_start, still_time, image_name, safety_file, 
                                lidar_camera_offset_cm = -9, focal_length = 25, pixel_dim = .0045) {
  #load necessary packages
  require(lubridate)
  require(tidyverse)
  
  #pull in lidar data
  lidar_data <- read.csv(lidar_file) %>% mutate(DateTime = ymd_hms(DateTime))
  
  #find row of data for this image's timestamp
  if (!is.POSIXct(vid_start)) {
    vid_start <- with_tz(ymd_hms(vid_start, tz="America/Los_Angeles"), tz="UTC")
  }
  still_split <- as.numeric(unlist(str_split(still_time, "_")))
  img_time <- vid_start + round((still_split[1]*60) + (still_split[2]) + (still_split[3]/30))
  row <- which(lidar_data$DateTime == img_time)
  if (length(row) == 0) {
    stop("No Lidar data for this timestamp")
  }
  
  #calculate and return corrected altitude
  alt <- lidar_data$laser_altitude_cm[row]
  tilt <- lidar_data$tilt_deg[row]
  corrected_alt <- round((alt*cos(tilt*pi/180)+lidar_camera_offset_cm)/100, 2)
  
  #write data to safety file
  if (file.exists(safety_file)) {
    safety_data <- read.csv(safety_file) %>% 
      bind_rows(., data.frame(Image = paste0(image_name,".png"), Altitude = corrected_alt, 
                              Focal_Length = focal_length, Pixel_Dimension = pixel_dim)) %>% 
      distinct()
    write.csv(safety_data, safety_file, row.names=FALSE)
  } else {
    safety_data <- data.frame(Image = paste0(image_name,".png"), Altitude = corrected_alt, 
                              Focal_Length = focal_length, Pixel_Dimension = pixel_dim) %>% 
      distinct()
    write.csv(safety_data, safety_file, row.names=FALSE)
  }
  
  #print results for manual input
  print(paste0("Correct altitude is: ", corrected_alt, " m"))
}

corrected_image_alt(lidar_file = "E:/IG/Sep-Oct 2021/UAS/2021-10-05/LidarLog_DailyMaster.csv",
                    vid_start = "2021-10-05 17:36:05", still_time = "00_27_18",
                    image_name = "20211005173554_METRInspire2.MOV.00_00_27_18.Still005",
                    safety_file = "C:/Users/marec/Docs/IG/UAS/2021/Morphometrix_Measurements_Safety_File.csv")

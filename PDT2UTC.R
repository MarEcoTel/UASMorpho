# This function is a quick converter from PDT to UTC that is 
# to be used to obtain UTC timestamps (to compare with lidar data) of video still images.
# This code is best used when pulling stills to make sure there is lidar altitude data at the time
# of the desired still.
#
# vidstart = start time of video in PDT
# mins = minutes since start of video that still was captured
# secs = seconds since start of video that still was captured (not counting minutes already input)
# weirdmillis = value shown after seconds since start of video that still was captured (this is a frame value from 0-30)

PDT2UTC <- function(vidstart, mins, secs, weirdmillis) {
  require(tidyverse)
  require(lubridate)
  ymd_hms(vidstart, 
          tz="America/Los_Angeles") %>% 
    with_tz(tzone = "UTC") +
    round((mins*60) + secs + (weirdmillis/30))
}

PDT2UTC("2023-01-04 13:38:34", #start on this date
        0,5,0)

PDT2UTC("2023-01-04 13:38:34", #start on this date
       5+0,27+5,7+23)



# below used for pulling stills from PVC flights at timestamps
{lidar_time <- "1/31/2023 19:45:39"
  vid_start <- "1/31/2023 11:45:30"
  dt <- as.numeric(abs(difftime(lubridate::with_tz(lubridate::mdy_hms(lidar_time,
                                                                    tz="UTC"),
                                                 tz = "America/Los_Angeles"),
         lubridate::mdy_hms(vid_start,
                            tz="America/Los_Angeles"),
         units = "secs"))) ; paste0(floor(dt/60), ":", dt-(floor(dt/60)*60))
}

# {lidar_time <- "1/31/2023 18:22:21"
#   vid_start <- "1/31/2023 11:45:30"
#   dt <- as.numeric(abs(difftime(lubridate::with_tz(lubridate::mdy_hms(lidar_time,
#                                                                       tz="UTC"),
#                                                    tz = "America/Los_Angeles"),
#                                 lubridate::mdy_hms(vid_start,
#                                                    tz="America/Los_Angeles"),
#                                 units = "secs")))
#   dt <- dt - (5*60) - 27
#   paste0(floor(dt/60), ":", dt-(floor(dt/60)*60))
# }

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

PDT2UTC("2023-01-04 10:14:15", #start on this date
        0,0,0)



#below used for pulling stills from PVC flights at timestamps
  dt <- as.numeric(abs(difftime(lubridate::with_tz(lubridate::mdy_hms("1/4/2023 18:14:23", 
                                                                    tz="UTC"), 
                                                 tz = "America/Los_Angeles"),
         lubridate::mdy_hms("1/4/2023 10:14:15", 
                            tz="America/Los_Angeles"),
         units = "secs"))) ; paste0(floor(dt/60), ":", dt-(floor(dt/60)*60))

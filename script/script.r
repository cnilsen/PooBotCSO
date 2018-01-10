options(repos = "https://mran.microsoft.com")

# Installing packages ------------------------------------------------------------------

if (!require('httr')) install.packages('httr')
if (!require('jsonlite')) install.packages('jsonlite')
if (!require('rsvg')) install.packages("rsvg")
if (!require('rjson')) install.packages("rjson")
if (!require('devtools')) install.packages('devtools')
if (!require('rvest')) install.packages('rvest')
if (!require('stringr')) install.packages('stringr')
if (!require('plyr')) install.packages('plyr')
if (!require('geojsonio')) install.packages('geojsonio')
#if (!require('rtweet')) install.packages('rtweet')
if (!require('httpuv')) install.packages('httpuv')
if (!require('RgoogleMaps')) install.packages('RgoogleMaps')

install_github("geoffjentry/twitteR")

library('rjson')
library('rsvg')
library('twitteR')
library('httr')
library('jsonlite')
library('devtools')
library('plyr')     # For data wrangling
library('geojsonio')

#library('rtweet')
library('httpuv')
library('RgoogleMaps')

cso.status.raw <- as.data.frame(geojson_read('https://raw.githubusercontent.com/keum/data_display/master/cso_test_file.geojson', method = 'local', parse = TRUE), stringAsFactors = FALSE)

i <- scan('tweetdata')

j=nrow(cso.status.raw)

name <-(cso.status.raw[1,12])
cso.status <- as.numeric(cso.status.raw$features.properties$CSO_Status[i])

if (cso.status == 2){
  name <- cso.status.raw$features.properties$Name[i]
  time.stamp <- cso.status.raw$features.properties$Time_stamp[i]
  location <- cso.status.raw$features.properties$Location[i]
  loc.y <- as.numeric(substr(location, 1, 8))
  loc.x <- as.numeric(substr(location, 12, 17))
  #location.url <- paste('http://maps.google.com/maps?q=',cso.status.raw$features.properties$Location[i])
  #location.url <- gsub(" ", "", location.url, fixed = TRUE)
  tweet.text = paste('Watch out!',name,'has reported a combined sewer overflow in the past 48 hours. See http://bit.ly/2CJBGe6 for more info!')

  #generate map from https://developers.google.com/maps/documentation/static-maps/
  credentials.file = "credentials.json"
  credentials <- fromJSON(file=credentials.file)
  gmap.key <- credentials$googlemaps$key
  destfile = 'map.png'
  #---
  lat = loc.x#,40.718217,40.711614);
  lon = loc.y#,-74.015794,-73.998284);
  center = c(mean(lat), mean(lon));
  zoom <- 12;
  #this overhead is taken care of implicitly by GetMap.bbox();
  marker.url <- 'https://raw.githubusercontent.com/cnilsen/SeattlePooBot/release-1.0/pile-of-poo_1f4a9.png'
  markers = paste0("&markers=icon:",marker.url,"|",loc.x,",",loc.y)#,40.702147,-74.015794)")#&markers=color:
                   #"green|label:G|40.711614,-74.012318&markers=color:red|color:red|",
                   #"label:C|40.718217,-73.998284")
  MyMap <- GetMap(center=center,size = c(440,220),destifle, zoom=zoom,markers=markers);
  
  #markers=markerStyles|markerLocation1
  #tweet  

  ckey <- credentials$twitter$consumer_key
  csecret <- credentials$twitter$consumer_secret
  atoken <- credentials$twitter$access_token
  asecret <- credentials$twitter$access_secret
  setup_twitter_oauth(ckey, csecret, atoken, asecret)
  tweet(tweet.text, media = destfile)

}
  #update last_tweet_info
if (i <= j)  {
  i = i+1
} else {
  i = 1
}

write(i,'tweetdata')

# twitter_token <- create_token(
#   app = 'PooBotDEV',
#   consumer_key = 'rjBRbr8nt4GWo8TzsKCTOl5xN' ,
#   consumer_secret = '8dceqr5qbYW6KVIgyaon1MNEUzUzoO9mOq9lby7VjsDtSiHMtd')



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

install_github("geoffjentry/twitteR")

library('rjson')
library('rsvg')
library('twitteR')
library('httr')
library('jsonlite')
library('devtools')
library('plyr')     # For data wrangling
library('geojsonio')


cso.status.raw <- as.data.frame(geojson_read('https://raw.githubusercontent.com/keum/data_display/master/cso_test_file.geojson', method = 'local', parse = TRUE), stringAsFactors = FALSE)

read(i, 'tweetdata')

j=nrow(cso.status.raw)

name <-(cso.status.raw[1,12])
cso.status <- as.numeric(cso.status.raw$features.properties$CSO_Status[i])

if (cso.status == 2){
  name <- cso.status.raw$features.properties$Name[i]
  time.stamp <- cso.status.raw$features.properties$Time_stamp[i]
  location <- cso.status.raw$features.properties$Location[i]
  loc.y <- substr(location, 1, 8)
  loc.x <- substr(location, 12, 17)
  #location.url <- paste('http://maps.google.com/maps?q=',cso.status.raw$features.properties$Location[i])
  #location.url <- gsub(" ", "", location.url, fixed = TRUE)
  tweet.text = paste('Watch out',name,'has reported a combined sewer overflow in the past 48 hours. See http://bit.ly/2CJBGe6 for more info!')

  #generate map from https://developers.google.com/maps/documentation/static-maps/
  credentials.file = "credentials.json"
  credentials <- fromJSON(file=credentials.file)
  location.str <- paste(loc.x,',',loc.y)
  location.str <- gsub(" ", "", location.str, fixed = TRUE)
  map.key <- credentials$googlemaps$key
  map.url <- paste('https://maps.googleapis.com/maps/api/staticmap?center=',location.str,'&zoom=15&size=400x400&markers=|',location.str,'|key=',map.key)
  map.url <- gsub(" ", "", map.url, fixed = TRUE)
#tweet  

  ckey <- credentials$twitter$consumer_key
  csecret <- credentials$twitter$consumer_secret
  atoken <- credentials$twitter$access_token
  asecret <- credentials$twitter$access_secret
  
  tweet(tweet.text)

}
  #update last_tweet_info
if (i <= j)  {
  i = i+1
} else {
  i = 1
}

write(i,'tweetdata')


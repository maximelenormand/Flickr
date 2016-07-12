#Import packages
library(RCurl)
library(rjson)
library(XML)

key=""     #API key for Flickr API
user=""    #User ID

#Outputs
ID=NULL      #ID photos
LON=NULL     #Longitude
LAT=NULL     #Latitude
ACC=NULL     #Accuracy
TIM=NULL     #Time
                   
#Get number of pages (100 photos per page) and the total number of photos
api.user=paste("https://www.flickr.com/services/rest/?method=flickr.people.getPublicPhotos&api_key=", key, "&user_id=", user, "&page=1", sep="")
xml.user=getURLContent(api.user, ssl.verifypeer = FALSE)
xml.user=xmlParse(xml.user)
xml.user=xmlRoot(xml.user)

pages=as.numeric(xmlAttrs(xml.user[[1]])['pages'])
total=as.numeric(xmlAttrs(xml.user[[1]])['total'])

#Loop over the pages
for(k in 1:pages){

    #XML of the kth page
    api.user=paste("https://www.flickr.com/services/rest/?method=flickr.people.getPublicPhotos&api_key=", key, "&user_id=", user, "&page=", k, sep="")
    xml.user=getURLContent(api.user, ssl.verifypeer = FALSE)
    xml.user=xmlParse(xml.user)
    xml.user=xmlRoot(xml.user)
  
    #If the user exists
    if(xmlAttrs(xml.user)!="fail"){
  
        #Number of photos per page
        nbphotos=100
        if(total<100){
            nbphotos=total
        }

        #Loop over the photos
        for(l in 1:nbphotos){
        
            print(paste(l, "th photo of page ", k, " (out of ", pages, " pages)", sep=""))

            #Extract photo id
            photo=xmlAttrs(xml.user[[1]][[l]])[['id']]

            #Get the geo data (latitude and longitude and the accuracy level) for the lth photo
            api.photo=paste("https://www.flickr.com/services/rest/?method=flickr.photos.geo.getLocation&api_key=", key, "&photo_id=", photo, sep="")
            xml.photo=getURLContent(api.photo, ssl.verifypeer = FALSE)
            xml.photo=xmlParse(xml.photo)
            xml.photo=xmlRoot(xml.photo)
          
            lon=-1
            lat=-1
            acc=-1
            if(xmlAttrs(xml.photo)!="fail"){    
                lon=as.numeric(xmlAttrs(xml.photo[[1]][[1]])[['latitude']])
                lat=as.numeric(xmlAttrs(xml.photo[[1]][[1]])[['longitude']])
                acc=as.numeric(xmlAttrs(xml.photo[[1]][[1]])[['accuracy']])
            }        

            #Get information about when the lth photo was taken
            api.photo=paste("https://www.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=", key, "&photo_id=", photo, sep="")
            xml.photo=getURLContent(api.photo, ssl.verifypeer = FALSE)
            xml.photo=xmlParse(xml.photo)
            xml.photo=xmlRoot(xml.photo)
          
            tim=-1
            if(xmlAttrs(xml.photo)!="fail"){    
                tim=xmlAttrs(xml.photo[[1]][[5]])[['taken']]
            }     
  
            ID=c(ID, photo)
            LON=c(LON,lon)
            LAT=c(LAT,lat)
            ACC=c(ACC,acc)
            TIM=c(TIM,tim)
        
            #Update 
            total=total-1
          
        }                                         
    }
}





   
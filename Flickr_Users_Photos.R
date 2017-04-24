#Import packages
library(RCurl)
library(XML)
library(doParallel)

#Working directory & API
wd=""
setwd(paste(wd,"",sep=""))

key="" 

#Import data vector user ID
userids=c("","")
                
#Users
for(i in 1:n){
    
    print(c(i,n))

    #ID user i
    user=userids[i]

    #Get the number of pages
    api.user=paste("https://www.flickr.com/services/rest/?method=flickr.people.getPublicPhotos&api_key=", key, "&user_id=", user, "&page=1", sep="")
    xml.user=getURLContent(api.user, ssl.verifypeer = FALSE)
    if(class(xml.user) == "try-error"){
        Sys.sleep(1)
	xml.user=getURLContent(api.user, ssl.verifypeer = FALSE)
    }
    xml.user=xmlParse(xml.user)
    xml.user=xmlRoot(xml.user)

    #If the user exists
    if(xmlAttrs(xml.user)!="fail"){        
        nbpages=as.numeric(xmlAttrs(xml.user[[1]])['pages'])
    }        

    #doPrallel
    cl=makeCluster(1)  
    registerDoParallel(cl)

    #Loop over the pages
    foreach(k=1:length(pages), .packages=c('XML', 'RCurl')) %dopar% {

        #kth page
	api.user=paste("https://www.flickr.com/services/rest/?method=flickr.people.getPublicPhotos&api_key=", key, "&user_id=", user, "&page=", pages[k], sep="")
	xml.user=try(getURLContent(api.user, ssl.verifypeer = FALSE))
	if(class(xml.user) == "try-error"){
	    Sys.sleep(1)
	    xml.user=getURLContent(api.user, ssl.verifypeer = FALSE)
	}
	xml.user=xmlParse(xml.user)
	xml.user=xmlRoot(xml.user)
		 
	#Number of photos per page
	nbphotos=xmlSize(xml.user[[1]])

        #Loop over the photos
	if(nbphotos>0){
	    
	    for(l in 1:nbphotos){

		#Extract ID photo
		photo=xmlAttrs(xml.user[[1]][[l]])[['id']]

		#Get the geo data (latitude, longitude and the accuracy level) for the lth photo
		api.photo=paste("https://www.flickr.com/services/rest/?method=flickr.photos.geo.getLocation&api_key=", key, "&photo_id=", photo, sep="")
		
		xml.photo=try(getURLContent(api.photo, ssl.verifypeer = FALSE))
		if(class(xml.photo) == "try-error"){
		    Sys.sleep(1)
		    xml.photo=getURLContent(api.photo, ssl.verifypeer = FALSE)
		}
		xml.photo=xmlParse(xml.photo)
		xml.photo=xmlRoot(xml.photo)
		
		lon=-1
		lat=-1
		acc=-1
		if(xmlAttrs(xml.photo)!="fail"){    
		    lon=as.numeric(xmlAttrs(xml.photo[[1]][[1]])[['longitude']])
		    lat=as.numeric(xmlAttrs(xml.photo[[1]][[1]])[['latitude']])
		    acc=as.numeric(xmlAttrs(xml.photo[[1]][[1]])[['accuracy']])
		}        

		#Get information about when the lth photo was taken
		api.photo=paste("https://www.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=", key, "&photo_id=", photo, sep="")
		xml.photo=try(getURLContent(api.photo, ssl.verifypeer = FALSE))
		if(class(xml.photo) == "try-error"){
		     Sys.sleep(1)
		     xml.photo=getURLContent(api.photo, ssl.verifypeer = FALSE)
		}
		xml.photo=xmlParse(xml.photo)
		xml.photo=xmlRoot(xml.photo)
		
		tim=-1
		if(xmlAttrs(xml.photo)!="fail"){    
		    tim=xmlAttrs(xml.photo[[1]][[5]])[['taken']]
		}     

		out=paste(user, photo, lon, lat, acc, tim, sep=";")
		cat(out, file=namefile, append=TRUE, sep = "\n")
	      
		Sys.sleep(0.01)

		gc()                     
		
            }
       	}
		                     
    }
    
    #Stop cluster do prallel
    stopCluster(cl)
 
}


   

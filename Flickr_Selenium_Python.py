#Import libraries
from selenium import webdriver
from selenium.webdriver.firefox.webdriver import FirefoxProfile
import time

#Import list user id
pathtoinput='/home/JohnRambo/ContactID.csv'
listcontact = open(pathtoinput)             
next(listcontact)
                              
#Instantiate a Firefox webbrowser (the profile should be already logged to Flickr)
pathtoprofile='path to profile'
profile = FirefoxProfile(pathtoprofile)
browser = webdriver.Firefox(profile)

#Loop over your contact list
for line in listcontact:
   
    #Extract Flickr ID
    attr = line.rstrip('\n\r').split(';')         #Split line
    id=(attr[0])    

    #Contact form url 
    url="https://www.flickr.com/mail/write/?to=" + id
    browser.get(url)
    time.sleep(1)

    #Identification of subject and message xpath
    subject = browser.find_element_by_xpath(".//*[@id='subject']")
    message = browser.find_element_by_xpath(".//*[@id='message']")
    
    #Write de subject and the message
    subject.send_keys("test")
    message.send_keys("test")
    
    #Send!
    browser.find_element_by_xpath(".//*[@id='preview-or-send']/input[2]").click()
    
    time.sleep(1)



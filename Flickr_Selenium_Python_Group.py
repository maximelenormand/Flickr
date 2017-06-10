#Import libraries
from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.firefox.webdriver import FirefoxProfile
import time


wd="/home/maxime/"

#Import list user id
pathtoinput='/home/JohnRambo/ContactID.csv'
listcontact = open(pathtoinput)             
next(listcontact)
                              
#Instantiate a Firefox webbrowser (the profile should be already logged to Flickr)
pathtoprofile='path to profile'
profile = FirefoxProfile(pathtoprofile)
browser = webdriver.Firefox(profile)

#Url group invitation
url="https://www.flickr.com/groups_invite.gne?id=..."

#Loop over your contact list
k=0
for line in listcontact:
    
    #Url group invitation
    browser.get(url)
    time.sleep(5)
   
    #Extract Flickr ID
    attr = line.rstrip('\n\r').split(';')         #Split line
    id=(attr[0])     

    #Identification of subject and message xpath
    invit = browser.find_element_by_xpath(".//*[@id='group-invite-bo-selecta-field']")
    invit.send_keys(id)    
    time.sleep(5)
    
    #Hover & click & click
    el1=browser.find_element_by_xpath(".//*[@id='bs-dropdown-0']/div[1]/div[2]/ul/li[2]/p")
    ActionChains(browser).move_to_element(el1).click().perform()    
    time.sleep(5)
    el2=browser.find_element_by_xpath(".//*[@id='bs-dropdown-0']/div[1]/div[2]/ul/li[1]")
    ActionChains(browser).move_to_element(el2).click().perform() 
    time.sleep(5)
   
    #Write message
    message = browser.find_element_by_xpath(".//*[@id='group-invite-form']/p[1]/textarea")
    message.send_keys("test")
    time.sleep(5)
    
    #Send!
    browser.find_element_by_xpath(".//*[@id='group-invite-form']/p[2]/input").click()
    time.sleep(5)
    browser.find_element_by_xpath(".//*[@id='GoodStuff']/form/p[2]/input[1]").click()
    
    k=k+1    
    
    print(str(k) + " " + id + " done!")

    time.sleep(5)




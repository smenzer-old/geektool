#!/usr/bin/python

# rememberthegeek.py
# Version: 1.0.2
# By: David Silver (dws90@yahoo.com)
# This code is provided as-is. If it breaks your computer, a) I'm impressed, and b) better luck next 
# time? Feel free to modify and reuse this code in any way you want, although if you're going to 
# redistribute it, leaving this credit thingy would be nice. 
# Oh, and I'm in no way affiliated with RTM, so if your computer breaks, don't blame them either.

## Version History
# 1.0.1 - Fixed an encoding problem that was preventing accents from being output correctly
# 1.0.2 - Fixed code that doesn't appear to be compatible with the version of Python in Leopard

#####################################################################################################
########################################### Instructions ############################################
#####################################################################################################
# This script displays tasks from Remember the Milk (http://rememberthemilk.com) in a simple plain text.
# It was written for use with GeekTool (http://projects.tynsoe.org/en/geektool/), but it can be used
# anywhere Python is available (according to Wikipedia, "Africa, Asia, Australia and a few islands 
# in Oceania"). 
#
# Optionally, this script will cache each feed's XML file locally on your machine. If you lose your 
# internet connection, it will load the cached file, so you can still view your tasks when offline.
#
# Below are two sets of instructions for setting GeekTool up with this script. 
#
# Short Version: Plug in the private URL for the feed for the RTM list(s) in the "feeds" variable
# below, then create a GeekTool "Shell" Geeklet pointing to the script. 
#
# Long Version: 
# 1. Locate the URL of the Atom feed for the list you want to display. Within RTM, select the list
# (without selecting any tasks) and look at the "List" tab on the right. Click on the "Atom" link, and
# copy the URL it takes you to. If the "Atom" link doesn't show up, you may need to enable "Private
# addresses" in RTM's settings (General tab).
# 2. Within this file, scroll down to the Settings section, and locate "feeds = 
# ["http://url/goes/here"]". Paste the URL of the feed between the quotes (yes, it's obnoxiously long, 
# but that's the point). 
# 3. Repeat steps 1 and 2 for all the lists you want to display. Each additional URL should be added
# within the square brackets, seperated by commas (each URL gets its own set of quotes).
# 4. Save the file some place you won't accidentially delete it or replace it with porn (does anyone
# actually name their pornography "rememberthegeek.py"?). 
# 5. Open GeekTool, and create a new "Script" geeklet. Configure it as you like, but set "Command" to
# the path of the script (most likely, "/Users/you/some/directory/rememberthegeek.py").
# 6. Be sure to set a reasonable refresh rate. You probably don't need your tasks updated every 
# 10 seconds.
# 7. If nothing happens, make sure the script is executable. Open a terminal window 
# (Applications -> Utilities -> Terminal), and enter the following commands: 
# cd /Users/you/directory/your/script/is/in/
# chmod +x rememberthegeek.py
# 


import xml.dom.minidom
import urllib2
import hashlib
import os

#####################################################################################################
########################## Settings - change these to fit your setup ################################
#####################################################################################################

# The URL of the feed(s). The URLs should be between the square brackets, in quotes, and separated by 
# commas.
feeds = ["xxxxxxxxxxx"]

# These should be "True" or "False"
DISPLAY_THE_REAL_LIST_A_TASK_IS_IN_IF_THE_FEED_IS_FOR_A_SMART_LIST = False
DISPLAY_TAGS = False
CACHE_FILES = True

# The directory to store the cached files in. This only does anything if "CACHE_FILES" is "True"
CACHE_DIRECTORY = "/tmp/"

####################################################################################################
########### The fun part - don't change unless you know what you're doing (I don't) ################
####################################################################################################
def createBackupFile(path, contents):
	try:	
		f = open(path, "w+")
		f.write(contents)
		f.close();
	except:
		return False
		
def readBackupFile(path):
	contents = ""
	if(os.path.isfile(path)):
		try:	
			f = open(path, "r")
			contents = f.read()
			f.close();
			return contents
		except:
			return False
	else:
		return False
	
def loadOnlineFeed(feedURL):
	backupFilePath = CACHE_DIRECTORY + hashlib.md5(feedURL).hexdigest() + ".xml"
	
	try: 
		feed = urllib2.urlopen(feedURL).read()
		createBackupFile(backupFilePath,feed)
	except:		
		return False
			
	return feed
	
def loadFeedBackup(feedURL):
	backupFilePath = CACHE_DIRECTORY + hashlib.md5(feedURL).hexdigest() + ".xml"
	
	feed = readBackupFile(backupFilePath)
	if(feed == False):
		return False
	return feed

def parseFeed(feed):
	return xml.dom.minidom.parseString(feed)
	
def getListTitle(document):
	title =  (document.getElementsByTagName("title"))[0].firstChild.nodeValue
	
	#Get rid of the "Name's Tasks - " part 
	index = title.find("Tasks - ")
	if(index != -1):
		index = index + 8 #Move to the beginning of the list's actual name
		title = title[index:]
	return title

def createDictionaryFromTask(task):
	dictionary = {}
	dictionary["title"] = (task.getElementsByTagName("title"))[0].firstChild.nodeValue
	spanElements = task.getElementsByTagName("span")
	for span in spanElements:
		if(span.getAttribute("class") == "rtm_due_value"):
			dictionary["due"] = span.firstChild.nodeValue
		elif(span.getAttribute("class") == "rtm_list_value"):
			dictionary["list"] = span.firstChild.nodeValue
		elif(span.getAttribute("class") == "rtm_tags_value"):
			dictionary["tags"] = span.firstChild.nodeValue
		elif(span.getAttribute("class") == "rtm_priority_value"):
			dictionary["priority"] = span.firstChild.nodeValue	
	return dictionary
	
def getTasks(document):
	tasks = document.getElementsByTagName("entry")
	dictionaires = []
	for task in tasks:
		dictionaires.append(createDictionaryFromTask(task))
	return dictionaires
	
def displayList(listTitle, tasks):
	s = "%s:" % listTitle
	print s.encode("utf-8")
	if(len(tasks) == 0):
		print "\tNothing to do!"
	else:
		for task in tasks:
			if(DISPLAY_THE_REAL_LIST_A_TASK_IS_IN_IF_THE_FEED_IS_FOR_A_SMART_LIST and task.has_key("list")):
				s = "\t%s\n\t\t%s\t\t%s" % (task["title"], task["due"], task["list"])
				print s.encode("utf-8")
			else:
#				s = "\t%s\n\t\t%s" % (task["title"], task["due"])
				if (task["due"] != "never"):
#					due = "\n\t\t%s" % (task["due"])
					due = "%s\n\t\t" % (task["due"])					
				else: 
					due = ""
					
				if (task["priority"] != "none"):
					prio = "(%s) " % (task["priority"])
				else:
					prio = "    "
					
#				s = "\t%s%s" % (task["title"], due)
				s = "\t%s%s%s" % (due,prio,task["title"])				
				print s.encode("utf-8")
			if(DISPLAY_TAGS and task["tags"] != "none"):
				s = "\t\t%s" % task["tags"]
				print s.encode("utf-8")
	print ""				
def displayFeeds(feedURLs):
#	print "Remember the Milk: \n"
		
	for feedURL in feedURLs:	
		#Try to load the feed - first from the web, then from the backup
		offline = False;
		feed = loadOnlineFeed(feedURL)
		if(feed == False):
			if(CACHE_FILES):
				feed = loadFeedBackup(feedURL)
				
			if(feed == False):
				print "Unable to access feed"
				continue
			else:
				offline = True;
		
		#Parse the feed
		document = parseFeed(feed)
		
		# Filter and display
		if(document):
			listTitle = getListTitle(document)
			if(offline):
				listTitle += " (offline)"
				
			tasks = getTasks(document)
			displayList(listTitle, tasks)
		else:
			print "Error parsing feed"

### Main ###
displayFeeds(feeds)

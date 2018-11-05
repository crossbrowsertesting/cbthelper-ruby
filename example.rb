require "cbthelper"

#Set username and auth key for api requests
#Be sure to use %40 instead of @

username = "YOUR_USERNAME"
authkey = "YOUR_AUTHKEY"


Cbthelper.login(username, authkey)

#Build caps 
caps = Cbthelper.getCapsBuilder()
 	 .withPlatform("Windows 10")
     .withBrowserApiName("Chrome68")
     .withResolution(1024, 768)
     .withName("cbthelper test")
     .withBuild("0.0.1")
     .withRecordNetwork(false)
     .withRecordVideo(true)
     .build()


#wrapped in a begin rescue to ensure proper ending of test
begin
	driver = Selenium::WebDriver.for(:remote, :url => "http://#{Cbthelper.username}:#{Cbthelper.authkey}@hub.crossbrowsertesting.com:80/wd/hub", :desired_capabilities => caps)
	driver.manage.timeouts.implicit_wait = 20

	# Initialize an AutomatedTest object with the selenium session id
	myTest = Cbthelper.getTestFromId(driver.session_id)
	video = myTest.RecordingVideo
	video.setDescription("google")
	driver.navigate.to("http://google.com")
	driver.manage.timeouts.implicit_wait = 2
	
	# Easily take a snapshot
	googleSnap = myTest.takeSnapshot

	# Easily set snapshot description
	googleSnap.setDescription("testsnap")

	# Save the snapshot locally
	googleSnap.saveSnapshot("test/testsnap1.png")

	driver.navigate.to("http://crossbrowsertesting.com")
	driver.manage.timeouts.implicit_wait = 2

	#Take snapshot and set description with one call
	myTest.takeSnapshot("cbtsnap")


	#downloads every snapshot for a given test and saves them in a directory
    #can set useDescription to name the images what we set as the description
    #alternatively can set a prefix (default 'image') and images will be indexed

	myTest.saveAllSnapshots("test/newfolder", useDescription=true)

	#Sets test score
	myTest.setScore("pass")

	#Sends a request to our api to stop the test
	myTest.stop

	driver.quit()
	
	video.saveVideo("test/video.mp4")
	
	#Our test history api call takes a lot of optional parameters
    #The builder makes it easier to get what you want
	options = Cbthelper.getTestHistoryBuilder()
			  .withLimit(1)
			  .withName('cbthelper testy')
			  .build
	puts options

	#Grab our history using the options we created above
	history = Cbthelper.getTestHistory(options)
	puts history["selenium"]

#Handles any exception, print the error, and quits the driver
rescue Exception => e
	puts e.message
	puts e.backtrace.inspect
	driver.quit()
end

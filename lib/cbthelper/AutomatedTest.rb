require_relative "Snapshot"
require_relative "Video"
require_relative "../cbthelper.rb"
require "rest-client"
require "json"

#Helpful representation of a selenium test
class AutomatedTest
	

    #@param testId: the selenium session ID, usually from webdriver 
	def initialize(testId)
		@testId = testId
	end
	
	#Sets the score for our test in the CBT app
    #@param score: should be 'pass', 'fail', or 'unset'.
	def setScore(score)		
		RestClient.put("https://#{Cbthelper.username}:#{Cbthelper.authkey}@crossbrowsertesting.com/api/v3/selenium/#{@testId}",
            "action=set_score&score=#{score}")
	end
	
	#Sets the description for the test in the web app
	def setDescription(description)
		RestClient.put("https://#{Cbthelper.username}:#{Cbthelper.authkey}@crossbrowsertesting.com/api/v3/selenium/#{@testId}",
            "action=set_description&description=#{description}")
	end

   
	#@param score is optional, will combine setScore and stopTest
    #Sends the command to our api to stop the selenium test. Similar to driver.quit()
	def stop(score = nil)
		if score != nil
			setScore(score)
			RestClient.delete("https://#{Cbthelper.username}:#{$Cbthelper.authkey}@crossbrowsertesting.com/api/v3/selenium/#{@testId}")
		end

	end

	#Sends the command to take a snapshot and returns a Snapshot instance
    #@param description: (optional) shortcut for Snapshot.setDescription
	def takeSnapshot(description= nil)

        #@return : the Snapshot instance for this snapshot	
		 response = RestClient.post("https://#{Cbthelper.username}:#{Cbthelper.authkey}@crossbrowsertesting.com/api/v3/selenium/#{@testId}/snapshots",
		 	"selenium_test_id=#{@testId}")
		 hash = /(?<="hash": ")((\w|\d)*)/.match(response)[0]
		 snap = Snapshot.new(hash, @testId)
		 if description != nil
		 	snap.setDescription(description)
		 end
		 return snap

	end

	#Returns all snapshots for this test
	def getSnapshots()
		snaps = JSON.parse(RestClient.get("https://#{Cbthelper.username}:#{Cbthelper.authkey}@crossbrowsertesting.com/api/v3/selenium/#{@testId}/snapshots/"))	
		ret = []

		for snap in snaps
			ret.push(Snapshot.new(snap["hash"], @testId))

		end
		return ret
	end

	#Downloads all snapshots for this test into the provided directory
	def saveAllSnapshots(directory, useDescription=false)
		prefix = "image"
		snaps = getSnapshots
		makeDirectory(directory)
      
		for i in 0...snaps.size
			if useDescription and snaps[i].info["description"] != ""
                img = snaps[i].info["description"] + ".png"
            else
                img = prefix + i.to_s + ".png"
            end
            	snaps[i].saveSnapshot(File.join(directory, img))
		end
	end

	#Return the video recording for this test
	def RecordingVideo(description=nil)
		 response = RestClient.get("https://#{Cbthelper.username}:#{Cbthelper.authkey}@crossbrowsertesting.com/api/v3/selenium/#{@testId}/videos")
		 hash = /(?<="hash": ")((\w|\d)*)/.match(response)[0]
		 video = Video.new(hash, @testId)
		 if description != nil
		 	video.setDescription(description)
		 end
		 return video
		
	end

	#Returns all videos for this test
	def getVideos
		videos = JSON.parse(RestClient.get("https://#{Cbthelper.username}:#{Cbthelper.authkey}@crossbrowsertesting.com/api/v3/selenium/#{@testId}/videos/"))	
		ret = []

		for video in videos
			ret.push(Video.new(video["hash"], @testId))

		end

		return ret
	end

	#Downloads all videos for this test into a directory
	def saveAllVideos(directory, useDescription=false)
		prefix = "video"
		videos = getVideos
		makeDirectory(directory)

		for i in 0...videos.size
			if useDescription and videos[i].info["description"] != ""
                vid = videos[i].info["description"] + ".mp4"
            else
                vid = prefix + i.to_s + ".mp4"
            end
            videos[i].saveVideo(File.join(directory, vid))
		end

	end

	private 
	def makeDirectory(dir)
		Dir.mkdir(dir) unless Dir.exist?(dir)
	
	end
	
end

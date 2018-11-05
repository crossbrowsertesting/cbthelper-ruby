require_relative "../cbthelper.rb"
require "json"
require "rest-client"

#Represents a video recording for a selenium test
class Video
	
	
    #@param hash: the hash for this video, returned by rest api when starting a recording
    #@param test: an AutomatedTest object that represents a test currently running
	attr_accessor :info
	def initialize(hash, test)
		@hash = hash
		@testId = test
		getInfo

	end

	#Calls out to api to get updated info for this video
    #@return : a hash object with all of the info for this video
    def getInfo
		@info = JSON.parse(RestClient.get("https://#{Cbthelper.username}:#{Cbthelper.authkey}@crossbrowsertesting.com/api/v3/selenium/#{@testId}/videos/#{@hash}"))
	end
	
	def stopRecording
		#Sends the command to stop a video recording
		RestClient.delete("https://#{Cbthelper.username}:#{Cbthelper.authkey}@crossbrowsertesting.com/api/v3/selenium/#{@testId}/videos/#{@hash}")
		
	end
	 
	#Sets the description for this video
	def setDescription(description)
		url = "https://#{Cbthelper.username}:#{Cbthelper.authkey}@crossbrowsertesting.com/api/v3/selenium/#{@testId}/videos/#{@hash}"
        @info = RestClient.put(url, "description=#{description}")

	end

	#@param location: a string with the location and filename for the video. Should have a .mp4 extension
	def saveVideo(location)
		url = getInfo["video"]
        stopRecording unless info["is_finished"]

        path = File.split(location)[0]
        Dir.mkdir(path) unless Dir.exist?(path)

        #downloads the video to the given location in chunks
        File.open(location, "wb") {|f|
            block = proc { |response|
                response.read_body do |chunk|
                    f.write chunk
                end
            }
            RestClient::Request.execute(method: :get,
                                        url: url,
                                        block_response: block)
        }

	end
end
